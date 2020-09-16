import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user_side/models/cardModel.dart';
import 'package:ecommerce_user_side/models/productModel.dart';

class FirestoreClient {
  FirestoreClient._();

  static FirestoreClient firestoreclient = FirestoreClient._();

  setOrdeToFirestore(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance.collection('order').add(map);
    } catch (e) {
      print('error' + e);
    }
  }

  Future<QuerySnapshot> getOrderByUserId(String userId) async {
    QuerySnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('order')
        .where('userId', isEqualTo: userId)
        .get();

    return documentSnapshot;
  }

  setLikes(String userId, String productId, Products products) async {
    await FirebaseFirestore.instance
        .collection('likes')
        .doc(userId)
        .set(products.toJson());
  }

  Future<QuerySnapshot> getProduct() async {
    QuerySnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    return documentSnapshot;
  }

  createCart(Map<String, dynamic> map) async {
    await FirebaseFirestore.instance.collection('carts').doc().set(map);
  }

  createLikes(CardModel cardModel) async {
    await FirebaseFirestore.instance
        .collection('likes')
        .add(cardModel.toJson());
  }

  Future<QuerySnapshot> getAllLikes(String userId) async {
    QuerySnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('likes')
        .where('userId', isEqualTo: userId)
        .get();
    return documentSnapshot;
  }

  deleteCart(String docId) async {
    await FirebaseFirestore.instance.collection('carts').doc(docId).delete();
  }

  deleteLikes(String productName, String userId) async {
    await FirebaseFirestore.instance
        .collection('likes')
        .where('userId', isEqualTo: userId)
        .where('name', isEqualTo: productName)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  deleteAllCart() async {
    FirebaseFirestore.instance.collection('carts').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<QuerySnapshot> getAllCart() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('carts').get();
    return querySnapshot;
  }

  Future<QuerySnapshot> getProductsByCateory(String category) async {
    QuerySnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('categories', isEqualTo: category)
        .get();

    return documentSnapshot;
  }

  Future<QuerySnapshot> searchByCateory(String name) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('categories',
            isGreaterThanOrEqualTo:
                '${name[0].toUpperCase() + name.substring(1)}')
        .where('categories',
            isLessThan: '${name[0].toUpperCase() + name.substring(1)}' + 'z')
        .get();
    return querySnapshot;
  }

  Future<QuerySnapshot> filterProduct(
      String category, String color, String size, int price) async {
    QuerySnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('categories', whereIn: [category])
        .where('color', isEqualTo: color)
        .where('size', isEqualTo: size)
        .where('price', isEqualTo: price)
        .get();

    return documentSnapshot;
  }
}
