import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

const PI = 3.1415926;

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController animationController, _controller;
  Animation animation, _animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    animation = Tween<double>(begin: 0, end: PI + 2).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    ));
    _animation = Tween<double>(begin: 0, end: 200.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    animation.addListener(() {
      setState(() {
        _controller.forward();
      });
    });
    animationController
        .forward()
        .whenComplete(() => animationController.repeat());
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(20.0),
        width: width,
        height: height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.white,
                height: _animation.value,
                child: CustomPaint(
                  size: Size(width, height),
                  painter: AnimSplash(
                    offset: animation.value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimSplash extends CustomPainter {
  AnimSplash({
    this.offset,
  }) : _paint = Paint()
          ..strokeCap = StrokeCap.round
          ..color = Colors.red
          ..style = PaintingStyle.fill;

  final Paint _paint;
  final double offset;
  @override
  void paint(Canvas canvas, Size size) {
    //LEFT
    double left = (offset > PI) ? PI : offset;
    Offset leftOffset =
        Offset(size.width / 4, size.height / 2 - 40 * sin(left));
    canvas.drawCircle(leftOffset, 20.0, _paint);

    //CENTER
    double center = (offset - 1 > PI) ? PI : offset - 1;
    if (center < 0) {
      center = 0;
    }
    Offset middleOffset =
        Offset(size.width / 2, size.height / 2 - 40 * sin(center));
    canvas.drawCircle(middleOffset, 20.0, _paint);

    //RIGHT

    double right = offset - 2 < 0 ? 0 : offset - 2;
    Offset rightOffset =
        Offset(size.width * 3 / 4, size.height / 2 - 40 * sin(right));
    canvas.drawCircle(rightOffset, 20.0, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
