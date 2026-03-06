import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor de Tareas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {

  // Lista de tareas mejorada
  final List<Map<String, dynamic>> _tareas = [];

  final _formKey = GlobalKey<FormState>();
  final _tareaController = TextEditingController();

  @override
  void dispose() {
    _tareaController.dispose();
    super.dispose();
  }

  // Agregar tarea
  void _agregarTarea() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _tareas.add({
          'texto': _tareaController.text.trim(),
          'completado': false,
          'fecha': DateTime.now()
        });
      });

      _tareaController.clear();

      // Mensaje visual
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarea agregada correctamente')),
      );
    }
  }

  // Eliminar tarea
  void _eliminarTarea(int index) {
    setState(() {
      _tareas.removeAt(index);
    });
  }

  // Borrar todas las tareas
  void _borrarTodo() {
    setState(() {
      _tareas.clear();
    });
  }

  @override
  Widget build(BuildContext context) {

    int tareasCompletadas =
        _tareas.where((t) => t['completado'] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Tareas (${_tareas.length})'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _borrarTodo,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Contador de tareas
            Text(
              'Completadas: $tareasCompletadas / ${_tareas.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // FORMULARIO
            Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: TextFormField(
                      controller: _tareaController,
                      autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: 'Nueva tarea',
                        hintText: 'Ej. Estudiar Flutter',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {

                        if (value == null || value.trim().isEmpty) {
                          return 'La tarea es obligatoria';
                        }

                        if (value.trim().length < 3) {
                          return 'Debe tener al menos 3 letras';
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _agregarTarea,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 40, thickness: 2),

            // LISTA
            Expanded(
              child: _tareas.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay tareas. ¡Añade la primera!',
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tareas.length,
                      itemBuilder: (context, index) {

                        final tarea = _tareas[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(

                            // CHECKBOX
                            leading: Checkbox(
                              value: tarea['completado'],
                              onChanged: (value) {
                                setState(() {
                                  tarea['completado'] = value!;
                                });
                              },
                            ),

                            // TEXTO
                            title: Text(
                              tarea['texto'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: tarea['completado']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),

                            // FECHA
                            subtitle: Text(
                              'Creado: ${tarea['fecha'].toString().substring(0,16)}',
                            ),

                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () =>
                                  _eliminarTarea(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}