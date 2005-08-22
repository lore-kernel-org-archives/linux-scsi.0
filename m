From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] correct attribute_container list usage
Date: Mon, 22 Aug 2005 10:06:19 -0500
Message-ID: <1124723180.5211.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:54763 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1750743AbVHVVKr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 17:10:47 -0400
Received: from hancock.sc.steeleye.com (stat16.steeleye.com [209.192.50.48])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id j7MF7Q0t026631
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 08:07:27 -0700
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j7MF6KA09053
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 11:06:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

One of the changes in the attribute_container code in the scsi-misc tree
was to add a lock to protect the list of devices per container.  This,
unfortunately, leads to potential scheduling while atomic problems if
there's a sleep in the function called by a trigger.

The correct solution is to use the kernel klist infrastructure instead
which allows lockless traversal of a list.

While implementing this patch, some bugs were found in klist, so the
attached patch depends on this patch:

http://marc.theaimsgroup.com/?l=linux-kernel&m=112445733108094

James

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -22,7 +22,7 @@
 /* This is a private structure used to tie the classdev and the
  * container .. it should never be visible outside this file */
 struct internal_container {
-	struct list_head node;
+	struct klist_node node;
 	struct attribute_container *cont;
 	struct class_device classdev;
 };
@@ -57,8 +57,7 @@ int
 attribute_container_register(struct attribute_container *cont)
 {
 	INIT_LIST_HEAD(&cont->node);
-	INIT_LIST_HEAD(&cont->containers);
-	spin_lock_init(&cont->containers_lock);
+	klist_init(&cont->containers);
 		
 	down(&attribute_container_mutex);
 	list_add_tail(&cont->node, &attribute_container_list);
@@ -78,13 +77,13 @@ attribute_container_unregister(struct at
 {
 	int retval = -EBUSY;
 	down(&attribute_container_mutex);
-	spin_lock(&cont->containers_lock);
-	if (!list_empty(&cont->containers))
+	spin_lock(&cont->containers.k_lock);
+	if (!list_empty(&cont->containers.k_list))
 		goto out;
 	retval = 0;
 	list_del(&cont->node);
  out:
-	spin_unlock(&cont->containers_lock);
+	spin_unlock(&cont->containers.k_lock);
 	up(&attribute_container_mutex);
 	return retval;
 		
@@ -143,7 +142,6 @@ attribute_container_add_device(struct de
 			continue;
 		}
 		memset(ic, 0, sizeof(struct internal_container));
-		INIT_LIST_HEAD(&ic->node);
 		ic->cont = cont;
 		class_device_initialize(&ic->classdev);
 		ic->classdev.dev = get_device(dev);
@@ -154,13 +152,22 @@ attribute_container_add_device(struct de
 			fn(cont, dev, &ic->classdev);
 		else
 			attribute_container_add_class_device(&ic->classdev);
-		spin_lock(&cont->containers_lock);
-		list_add_tail(&ic->node, &cont->containers);
-		spin_unlock(&cont->containers_lock);
+		klist_add_tail(&ic->node, &cont->containers);
 	}
 	up(&attribute_container_mutex);
 }
 
+/* FIXME: can't break out of this unless klist_iter_exit is also
+ * called before doing the break
+ */
+#define klist_for_each_entry(pos, head, member, iter) \
+	for (klist_iter_init(head, iter); (pos = ({ \
+		struct klist_node *n = klist_next(iter); \
+		n ? ({ klist_iter_exit(iter) ; NULL; }) : \
+			container_of(n, typeof(*pos), member);\
+	}) ) != NULL; )
+			
+
 /**
  * attribute_container_remove_device - make device eligible for removal.
  *
@@ -187,18 +194,19 @@ attribute_container_remove_device(struct
 
 	down(&attribute_container_mutex);
 	list_for_each_entry(cont, &attribute_container_list, node) {
-		struct internal_container *ic, *tmp;
+		struct internal_container *ic;
+		struct klist_iter iter;
 
 		if (attribute_container_no_classdevs(cont))
 			continue;
 
 		if (!cont->match(cont, dev))
 			continue;
-		spin_lock(&cont->containers_lock);
-		list_for_each_entry_safe(ic, tmp, &cont->containers, node) {
+
+		klist_for_each_entry(ic, &cont->containers, node, &iter) {
 			if (dev != ic->classdev.dev)
 				continue;
-			list_del(&ic->node);
+			klist_remove(&ic->node);
 			if (fn)
 				fn(cont, dev, &ic->classdev);
 			else {
@@ -206,7 +214,6 @@ attribute_container_remove_device(struct
 				class_device_unregister(&ic->classdev);
 			}
 		}
-		spin_unlock(&cont->containers_lock);
 	}
 	up(&attribute_container_mutex);
 }
@@ -232,7 +239,8 @@ attribute_container_device_trigger(struc
 
 	down(&attribute_container_mutex);
 	list_for_each_entry(cont, &attribute_container_list, node) {
-		struct internal_container *ic, *tmp;
+		struct internal_container *ic;
+		struct klist_iter iter;
 
 		if (!cont->match(cont, dev))
 			continue;
@@ -242,12 +250,10 @@ attribute_container_device_trigger(struc
 			continue;
 		}
 
-		spin_lock(&cont->containers_lock);
-		list_for_each_entry_safe(ic, tmp, &cont->containers, node) {
+		klist_for_each_entry(ic, &cont->containers, node, &iter) {
 			if (dev == ic->classdev.dev)
 				fn(cont, dev, &ic->classdev);
 		}
-		spin_unlock(&cont->containers_lock);
 	}
 	up(&attribute_container_mutex);
 }
@@ -397,15 +403,16 @@ attribute_container_find_class_device(st
 {
 	struct class_device *cdev = NULL;
 	struct internal_container *ic;
+	struct klist_iter iter;
 
-	spin_lock(&cont->containers_lock);
-	list_for_each_entry(ic, &cont->containers, node) {
+	klist_for_each_entry(ic, &cont->containers, node, &iter) {
 		if (ic->classdev.dev == dev) {
 			cdev = &ic->classdev;
+			/* FIXME: must exit iterator then break */
+			klist_iter_exit(&iter);
 			break;
 		}
 	}
-	spin_unlock(&cont->containers_lock);
 
 	return cdev;
 }
diff --git a/include/linux/attribute_container.h b/include/linux/attribute_container.h
--- a/include/linux/attribute_container.h
+++ b/include/linux/attribute_container.h
@@ -11,12 +11,12 @@
 
 #include <linux/device.h>
 #include <linux/list.h>
+#include <linux/klist.h>
 #include <linux/spinlock.h>
 
 struct attribute_container {
 	struct list_head	node;
-	struct list_head	containers;
-	spinlock_t		containers_lock;
+	struct klist		containers;
 	struct class		*class;
 	struct class_device_attribute **attrs;
 	int (*match)(struct attribute_container *, struct device *);


