import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Congratulations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4")
      ..setVolume(1.0);
    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.addListener(() {
      log('${_controller.value}');
      // if (!_controller.value.isPlaying) {
      //   _controller.play();
      // }
    });
  }

  // void createVideo() {
  //   if (playerController == null) {

  //       ..initialize()
  //       ..play();
  //   } else {
  //     if (playerController.value.isPlaying) {
  //       playerController.pause();
  //     } else {
  //       playerController.initialize();
  //       playerController.play();
  //     }
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.setVolume(0.0);
    // _controller.removeListener(listener);
    super.deactivate();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Congratulations'),
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _controller.play();
              return Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: Stack(
                    children: [
                      VideoPlayer(_controller),
                      Image.asset(
                        'assets/framework.png',
                        fit: BoxFit.fill,
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                      )
                      // Container(
                      //   width: double.infinity,
                      //   height: double.infinity,
                      //   decoration: const BoxDecoration(
                      //     color: Colors.transparent,
                      //     image: DecorationImage(
                      //       image: AssetImage('assets/framework.png'),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
