From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add missing class_device_del to transport classes
Date: Sat, 29 Jan 2005 19:47:55 -0600
Message-ID: <1107049675.4535.43.camel@mulgrave>
References: <41F82EDE.3040905@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:46242 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261633AbVA3BsL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2005 20:48:11 -0500
In-Reply-To: <41F82EDE.3040905@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, greg@kroah.com

On Wed, 2005-01-26 at 15:59 -0800, Mike Christie wrote:
> It appears there is a missing class_device_del.
> The comments for transport_remove_device indicate
> that transport_remove_classdev should call it
> (which the attached patch does), but the comment in
> attribute_container_remove_device:

OK, try this.  I think it corrects my architectural cockup and puts the
attribute additions and removals in the container class where they
should have been in the first place.

James

===== drivers/base/attribute_container.c 1.1 vs edited =====
--- 1.1/drivers/base/attribute_container.c	2005-01-18 12:54:21 -06:00
+++ edited/drivers/base/attribute_container.c	2005-01-29 10:00:15 -06:00
@@ -150,7 +150,7 @@
 		if (fn)
 			fn(cont, dev, &ic->classdev);
 		else
-			class_device_add(&ic->classdev);
+			attribute_container_add_class_device(&ic->classdev);
 		list_add_tail(&ic->node, &cont->containers);
 	}
 	up(&attribute_container_mutex);
@@ -195,8 +195,10 @@
 			list_del(&ic->node);
 			if (fn)
 				fn(cont, dev, &ic->classdev);
-			else
+			else {
+				attribute_container_remove_attrs(&ic->classdev);
 				class_device_unregister(&ic->classdev);
+			}
 		}
 	}
 	up(&attribute_container_mutex);
@@ -264,7 +266,107 @@
 	up(&attribute_container_mutex);
 }
 EXPORT_SYMBOL_GPL(attribute_container_trigger);
-     
+
+/**
+ * attribute_container_add_attrs - add attributes
+ *
+ * @classdev: The class device
+ *
+ * This simply creates all the class device sysfs files from the
+ * attributes listed in the container
+ */
+int
+attribute_container_add_attrs(struct class_device *classdev)
+{
+	struct attribute_container *cont =
+		attribute_container_classdev_to_container(classdev);
+	struct class_device_attribute **attrs =	cont->attrs;
+	int i, error;
+
+	if (!attrs)
+		return 0;
+
+	for (i = 0; attrs[i]; i++) {
+		error = class_device_create_file(classdev, attrs[i]);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(attribute_container_add_attrs);
+
+/**
+ * attribute_container_add_class_device - same function as class_device_add
+ *
+ * @classdev:	the class device to add
+ *
+ * This performs essentially the same function as class_device_add except for
+ * attribute containers, namely add the classdev to the system and then
+ * create the attribute files
+ */
+int
+attribute_container_add_class_device(struct class_device *classdev)
+{
+	int error = class_device_add(classdev);
+	if (error)
+		return error;
+	return attribute_container_add_attrs(classdev);
+}
+EXPORT_SYMBOL_GPL(attribute_container_add_class_device);
+
+/**
+ * attribute_container_add_class_device_adapter - simple adapter for triggers
+ *
+ * This function is identical to attribute_container_add_class_device except
+ * that it is designed to be called from the triggers
+ */
+int
+attribute_container_add_class_device_adapter(struct attribute_container *cont,
+					     struct device *dev,
+					     struct class_device *classdev)
+{
+	return attribute_container_add_class_device(classdev);
+}
+EXPORT_SYMBOL_GPL(attribute_container_add_class_device_adapter);
+
+/**
+ * attribute_container_remove_attrs - remove any attribute files
+ *
+ * @classdev: The class device to remove the files from
+ *
+ */
+void
+attribute_container_remove_attrs(struct class_device *classdev)
+{
+	struct attribute_container *cont =
+		attribute_container_classdev_to_container(classdev);
+	struct class_device_attribute **attrs =	cont->attrs;
+	int i;
+
+	if (!attrs)
+		return;
+
+	for (i = 0; attrs[i]; i++)
+		class_device_remove_file(classdev, attrs[i]);
+}
+EXPORT_SYMBOL_GPL(attribute_container_remove_attrs);
+
+/**
+ * attribute_container_class_device_del - equivalent of class_device_del
+ *
+ * @classdev: the class device
+ *
+ * This function simply removes all the attribute files and then calls
+ * class_device_del.
+ */
+void
+attribute_container_class_device_del(struct class_device *classdev)
+{
+	attribute_container_remove_attrs(classdev);
+	class_device_del(classdev);
+}
+EXPORT_SYMBOL_GPL(attribute_container_class_device_del);
 
 int __init
 attribute_container_init(void)
===== drivers/base/transport_class.c 1.1 vs edited =====
--- 1.1/drivers/base/transport_class.c	2005-01-18 13:03:32 -06:00
+++ edited/drivers/base/transport_class.c	2005-01-29 09:50:15 -06:00
@@ -146,25 +146,6 @@
 EXPORT_SYMBOL_GPL(transport_setup_device);
 
 
-static int transport_add_classdev(struct attribute_container *cont,
-				  struct device *dev,
-				  struct class_device *classdev)
-{
-	struct class_device_attribute **attrs =	cont->attrs;
-	int i, error;
-
-	error = class_device_add(classdev);
-	if (error)
-		return error;
-	for (i = 0; attrs[i]; i++) {
-		error = class_device_create_file(classdev, attrs[i]);
-		if (error)
-			return error;
-	}
-
-	return 0;
-}
-
 /**
  * transport_add_device - declare a new dev for transport class association
  *
@@ -178,7 +159,8 @@
 
 void transport_add_device(struct device *dev)
 {
-	attribute_container_device_trigger(dev, transport_add_classdev);
+	attribute_container_device_trigger(dev,
+			   attribute_container_add_class_device_adapter);
 }
 EXPORT_SYMBOL_GPL(transport_add_device);
 
@@ -219,6 +201,9 @@
 
 	if (tclass->remove)
 		tclass->remove(dev);
+
+	if (tclass->remove != anon_transport_dummy_function)
+		attribute_container_class_device_del(classdev);
 
 	return 0;
 }
===== include/linux/attribute_container.h 1.1 vs edited =====
--- 1.1/include/linux/attribute_container.h	2005-01-18 12:54:22 -06:00
+++ edited/include/linux/attribute_container.h	2005-01-29 09:58:54 -06:00
@@ -55,6 +55,18 @@
 void attribute_container_trigger(struct device *dev, 
 				 int (*fn)(struct attribute_container *,
 					   struct device *));
+int attribute_container_add_attrs(struct class_device *classdev);
+int attribute_container_add_class_device(struct class_device *classdev);
+int attribute_container_add_class_device_adapter(struct attribute_container *cont,
+						 struct device *dev,
+						 struct class_device *classdev);
+void attribute_container_remove_attrs(struct class_device *classdev);
+void attribute_container_class_device_del(struct class_device *classdev);
+
+
+
+
+
 
 struct class_device_attribute **attribute_container_classdev_to_attrs(const struct class_device *classdev);
 


