From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] correct transport class abstraction to work outside SCSI
Date: Sun, 14 Aug 2005 17:09:01 -0500
Message-ID: <1124057341.18802.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:16324 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932317AbVHNWJD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2005 18:09:03 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j7EM92A10778
	for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2005 18:09:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

I recently tried to construct a totally generic transport class and
found there were certain features missing from the current abstract
transport class.  Most notable is that you have to hang the data on the
class_device but most of the API is framed in terms of the generic
device, not the class_device.

These changes are two fold

- Provide the class_device to all of the setup and configure APIs
- Provide and extra API to take the device and the attribute class and
  return the corresponding class_device

James

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -58,6 +58,7 @@ attribute_container_register(struct attr
 {
 	INIT_LIST_HEAD(&cont->node);
 	INIT_LIST_HEAD(&cont->containers);
+	spin_lock_init(&cont->containers_lock);
 		
 	down(&attribute_container_mutex);
 	list_add_tail(&cont->node, &attribute_container_list);
@@ -77,11 +78,13 @@ attribute_container_unregister(struct at
 {
 	int retval = -EBUSY;
 	down(&attribute_container_mutex);
+	spin_lock(&cont->containers_lock);
 	if (!list_empty(&cont->containers))
 		goto out;
 	retval = 0;
 	list_del(&cont->node);
  out:
+	spin_unlock(&cont->containers_lock);
 	up(&attribute_container_mutex);
 	return retval;
 		
@@ -151,7 +154,9 @@ attribute_container_add_device(struct de
 			fn(cont, dev, &ic->classdev);
 		else
 			attribute_container_add_class_device(&ic->classdev);
+		spin_lock(&cont->containers_lock);
 		list_add_tail(&ic->node, &cont->containers);
+		spin_unlock(&cont->containers_lock);
 	}
 	up(&attribute_container_mutex);
 }
@@ -189,6 +194,7 @@ attribute_container_remove_device(struct
 
 		if (!cont->match(cont, dev))
 			continue;
+		spin_lock(&cont->containers_lock);
 		list_for_each_entry_safe(ic, tmp, &cont->containers, node) {
 			if (dev != ic->classdev.dev)
 				continue;
@@ -200,6 +206,7 @@ attribute_container_remove_device(struct
 				class_device_unregister(&ic->classdev);
 			}
 		}
+		spin_unlock(&cont->containers_lock);
 	}
 	up(&attribute_container_mutex);
 }
@@ -230,10 +237,12 @@ attribute_container_device_trigger(struc
 		if (!cont->match(cont, dev))
 			continue;
 
+		spin_lock(&cont->containers_lock);
 		list_for_each_entry_safe(ic, tmp, &cont->containers, node) {
 			if (dev == ic->classdev.dev)
 				fn(cont, dev, &ic->classdev);
 		}
+		spin_unlock(&cont->containers_lock);
 	}
 	up(&attribute_container_mutex);
 }
@@ -368,6 +377,35 @@ attribute_container_class_device_del(str
 }
 EXPORT_SYMBOL_GPL(attribute_container_class_device_del);
 
+/**
+ * attribute_container_find_class_device - find the corresponding class_device
+ *
+ * @cont:	the container
+ * @dev:	the generic device
+ *
+ * Looks up the device in the container's list of class devices and returns
+ * the corresponding class_device.
+ */
+struct class_device *
+attribute_container_find_class_device(struct attribute_container *cont,
+				      struct device *dev)
+{
+	struct class_device *cdev = NULL;
+	struct internal_container *ic;
+
+	spin_lock(&cont->containers_lock);
+	list_for_each_entry(ic, &cont->containers, node) {
+		if (ic->classdev.dev == dev) {
+			cdev = &ic->classdev;
+			break;
+		}
+	}
+	spin_unlock(&cont->containers_lock);
+
+	return cdev;
+}
+EXPORT_SYMBOL_GPL(attribute_container_find_class_device);
+
 int __init
 attribute_container_init(void)
 {
diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -64,7 +64,9 @@ void transport_class_unregister(struct t
 }
 EXPORT_SYMBOL_GPL(transport_class_unregister);
 
-static int anon_transport_dummy_function(struct device *dev)
+static int anon_transport_dummy_function(struct transport_container *tc,
+					 struct device *dev,
+					 struct class_device *cdev)
 {
 	/* do nothing */
 	return 0;
@@ -115,9 +117,10 @@ static int transport_setup_classdev(stru
 				    struct class_device *classdev)
 {
 	struct transport_class *tclass = class_to_transport_class(cont->class);
+	struct transport_container *tcont = attribute_container_to_transport_container(cont);
 
 	if (tclass->setup)
-		tclass->setup(dev);
+		tclass->setup(tcont, dev, classdev);
 
 	return 0;
 }
@@ -178,12 +181,14 @@ void transport_add_device(struct device 
 EXPORT_SYMBOL_GPL(transport_add_device);
 
 static int transport_configure(struct attribute_container *cont,
-			       struct device *dev)
+			       struct device *dev,
+			       struct class_device *cdev)
 {
 	struct transport_class *tclass = class_to_transport_class(cont->class);
+	struct transport_container *tcont = attribute_container_to_transport_container(cont);
 
 	if (tclass->configure)
-		tclass->configure(dev);
+		tclass->configure(tcont, dev, cdev);
 
 	return 0;
 }
@@ -202,7 +207,7 @@ static int transport_configure(struct at
  */
 void transport_configure_device(struct device *dev)
 {
-	attribute_container_trigger(dev, transport_configure);
+	attribute_container_device_trigger(dev, transport_configure);
 }
 EXPORT_SYMBOL_GPL(transport_configure_device);
 
@@ -215,7 +220,7 @@ static int transport_remove_classdev(str
 	struct transport_class *tclass = class_to_transport_class(cont->class);
 
 	if (tclass->remove)
-		tclass->remove(dev);
+		tclass->remove(tcont, dev, classdev);
 
 	if (tclass->remove != anon_transport_dummy_function) {
 		if (tcont->statistics)
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -252,7 +252,8 @@ struct fc_internal {
 
 #define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)
 
-static int fc_target_setup(struct device *dev)
+static int fc_target_setup(struct transport_container *tc, struct device *dev,
+			   struct class_device *cdev)
 {
 	struct scsi_target *starget = to_scsi_target(dev);
 	struct fc_rport *rport = starget_to_rport(starget);
@@ -281,7 +282,8 @@ static DECLARE_TRANSPORT_CLASS(fc_transp
 			       NULL,
 			       NULL);
 
-static int fc_host_setup(struct device *dev)
+static int fc_host_setup(struct transport_container *tc, struct device *dev,
+			 struct class_device *cdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -166,7 +166,8 @@ static inline enum spi_signal_type spi_s
 	return SPI_SIGNAL_UNKNOWN;
 }
 
-static int spi_host_setup(struct device *dev)
+static int spi_host_setup(struct transport_container *tc, struct device *dev,
+			  struct class_device *cdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 
@@ -200,7 +201,9 @@ static int spi_host_match(struct attribu
 	return &i->t.host_attrs.ac == cont;
 }
 
-static int spi_device_configure(struct device *dev)
+static int spi_device_configure(struct transport_container *tc,
+				struct device *dev,
+				struct class_device *cdev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_target *starget = sdev->sdev_target;
@@ -218,7 +221,9 @@ static int spi_device_configure(struct d
 	return 0;
 }
 
-static int spi_setup_transport_attrs(struct device *dev)
+static int spi_setup_transport_attrs(struct transport_container *tc,
+				     struct device *dev,
+				     struct class_device *cdev)
 {
 	struct scsi_target *starget = to_scsi_target(dev);
 
diff --git a/include/linux/attribute_container.h b/include/linux/attribute_container.h
--- a/include/linux/attribute_container.h
+++ b/include/linux/attribute_container.h
@@ -11,10 +11,12 @@
 
 #include <linux/device.h>
 #include <linux/list.h>
+#include <linux/spinlock.h>
 
 struct attribute_container {
 	struct list_head	node;
 	struct list_head	containers;
+	spinlock_t		containers_lock;
 	struct class		*class;
 	struct class_device_attribute **attrs;
 	int (*match)(struct attribute_container *, struct device *);
@@ -62,12 +64,7 @@ int attribute_container_add_class_device
 						 struct class_device *classdev);
 void attribute_container_remove_attrs(struct class_device *classdev);
 void attribute_container_class_device_del(struct class_device *classdev);
-
-
-
-
-
-
+struct class_device *attribute_container_find_class_device(struct attribute_container *, struct device *);
 struct class_device_attribute **attribute_container_classdev_to_attrs(const struct class_device *classdev);
 
 #endif
diff --git a/include/linux/transport_class.h b/include/linux/transport_class.h
--- a/include/linux/transport_class.h
+++ b/include/linux/transport_class.h
@@ -12,11 +12,16 @@
 #include <linux/device.h>
 #include <linux/attribute_container.h>
 
+struct transport_container;
+
 struct transport_class {
 	struct class class;
-	int (*setup)(struct device *);
-	int (*configure)(struct device *);
-	int (*remove)(struct device *);
+	int (*setup)(struct transport_container *, struct device *,
+		     struct class_device *);
+	int (*configure)(struct transport_container *, struct device *,
+			 struct class_device *);
+	int (*remove)(struct transport_container *, struct device *,
+		      struct class_device *);
 };
 
 #define DECLARE_TRANSPORT_CLASS(cls, nm, su, rm, cfg)			\


