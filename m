From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] Allow transport classes to attach to host, target or device
Date: 06 Sep 2004 10:47:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094482026.2149.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27082 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268070AbUIFOrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Sep 2004 10:47:09 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i86El6J16226
	for <linux-scsi@vger.kernel.org>; Mon, 6 Sep 2004 10:47:06 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a nice simple patch that makes the transport class a combination
of up to three sysfs classes, attaching to host, transport or device. 
So that the attributes it's exporting may be attached to the correct
place.

I also got rid of the cleanup methods since the users of the class make
it obvious that these are totally unnecessary (cleanup is done as part
of the class release instead).

This compiles and runs, but is really only a sketch of what's planned.

James

diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Mon Sep  6 09:42:22 2004
+++ b/drivers/scsi/hosts.c	Mon Sep  6 09:42:22 2004
@@ -82,6 +82,8 @@
 	set_bit(SHOST_DEL, &shost->shost_state);
 
 	class_device_unregister(&shost->shost_classdev);
+	if (shost->transport_classdev.class)
+		class_device_unregister(&shost->transport_classdev);
 	device_del(&shost->shost_gendev);
 }
 
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Mon Sep  6 09:42:22 2004
+++ b/drivers/scsi/scsi_priv.h	Mon Sep  6 09:42:22 2004
@@ -66,13 +66,17 @@
 struct scsi_target {
 	struct scsi_device	*starget_sdev_user;
 	struct device		dev;
-};
+	struct class_device	transport_classdev;
+	unsigned long		transport_data[0];
+} __attribute__((aligned(sizeof(unsigned long))));
 
 #define to_scsi_target(d)	container_of(d, struct scsi_target, dev)
 static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
 {
 	return to_scsi_target(sdev->sdev_gendev.parent);
 }
+#define transport_classdev_to_starget(class_dev) \
+	container_of(class_dev, struct scsi_target, transport_classdev)
 
 /* hosts.c */
 extern int scsi_init_hosts(void);
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Mon Sep  6 09:42:22 2004
+++ b/drivers/scsi/scsi_scan.c	Mon Sep  6 09:42:22 2004
@@ -205,7 +205,8 @@
 	struct scsi_device *sdev, *device;
 	unsigned long flags;
 
-	sdev = kmalloc(sizeof(*sdev) + shost->transportt->size, GFP_ATOMIC);
+	sdev = kmalloc(sizeof(*sdev) + shost->transportt->device_size,
+		       GFP_ATOMIC);
 	if (!sdev)
 		goto out;
 
@@ -256,14 +257,14 @@
 			goto out_free_queue;
 	}
 
-	if (shost->transportt->setup) {
-		if (shost->transportt->setup(sdev))
+	if (shost->transportt->device_setup) {
+		if (shost->transportt->device_setup(sdev))
 			goto out_cleanup_slave;
 	}
 
 	if (get_device(&sdev->host->shost_gendev) == NULL ||
 	    scsi_sysfs_device_initialize(sdev) != 0)
-		goto out_cleanup_transport;
+		goto out_cleanup_slave;
 
 	/*
 	 * If there are any same target siblings, add this to the
@@ -292,9 +293,6 @@
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return sdev;
 
-out_cleanup_transport:
-	if (shost->transportt->cleanup)
-		shost->transportt->cleanup(sdev);
 out_cleanup_slave:
 	if (shost->hostt->slave_destroy)
 		shost->hostt->slave_destroy(sdev);
@@ -733,8 +731,6 @@
 	} else {
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
-		if (sdev->host->transportt->cleanup)
-			sdev->host->transportt->cleanup(sdev);
 		put_device(&sdev->sdev_gendev);
 	}
  out:
@@ -1293,7 +1289,5 @@
 
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
-	if (sdev->host->transportt->cleanup)
-		sdev->host->transportt->cleanup(sdev);
 	put_device(&sdev->sdev_gendev);
 }
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Mon Sep  6 09:42:22 2004
+++ b/drivers/scsi/scsi_sysfs.c	Mon Sep  6 09:42:22 2004
@@ -160,14 +160,17 @@
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
 	/* If we're the last LUN on the target, destroy the target */
-	delete = (list_empty(&sdev->same_target_siblings) && parent);
+	delete = list_empty(&sdev->same_target_siblings);
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
-	if (delete) {
+	if (delete && parent) {
+		struct scsi_target *starget = to_scsi_target(parent);
 		device_del(parent);
+		if (starget->transport_classdev.class)
+			class_device_unregister(&starget->transport_classdev);
 		put_device(parent);
 	}
 	if (sdev->request_queue)
@@ -509,7 +512,7 @@
 	}
 
  	if (sdev->transport_classdev.class) {
- 		attrs = sdev->host->transportt->attrs;
+ 		attrs = sdev->host->transportt->device_attrs;
  		for (i = 0; attrs[i]; i++) {
  			error = class_device_create_file(&sdev->transport_classdev,
  							 attrs[i]);
@@ -553,8 +556,6 @@
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
-	if (sdev->host->transportt->cleanup)
-		sdev->host->transportt->cleanup(sdev);
 	put_device(&sdev->sdev_gendev);
 
 out:
@@ -641,6 +642,20 @@
 		}
 	}
 
+	if (shost->transportt->host_setup)
+		shost->transportt->host_setup(shost);
+
+	if (shost->transport_classdev.class) {
+		struct class_device_attribute **attrs =
+			shost->transportt->host_attrs;
+		for (i = 0; attrs[i]; i++) {
+ 			error = class_device_create_file(&shost->transport_classdev,
+ 							 attrs[i]);
+ 			if (error)
+				return error;
+ 		}
+ 	}
+
 	return 0;
 }
 
@@ -662,7 +677,7 @@
 
 	class_device_initialize(&sdev->transport_classdev);
 	sdev->transport_classdev.dev = &sdev->sdev_gendev;
-	sdev->transport_classdev.class = sdev->host->transportt->class;
+	sdev->transport_classdev.class = sdev->host->transportt->device_class;
 	snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
 		 "%d:%d:%d:%d", sdev->host->host_no,
 		 sdev->channel, sdev->id, sdev->lun);
@@ -674,7 +689,7 @@
 	struct scsi_target *starget = NULL;
 	struct scsi_device *sdev_sibling;
 	struct device *dev = NULL;
-	int error;
+	int error, create = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
@@ -689,7 +704,9 @@
 		}
 	}
 	if (!starget) {
-		starget = kmalloc(sizeof(*starget), GFP_ATOMIC);
+		starget = kmalloc(sizeof(*starget) +
+				  sdev->host->transportt->target_size,
+				  GFP_ATOMIC);
 		if (!starget) {
 			printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
 			spin_unlock_irqrestore(sdev->host->host_lock,
@@ -703,6 +720,7 @@
 		dev->release = scsi_target_dev_release;
 		sprintf(dev->bus_id, "target%d:%d:%d",
 			sdev->host->host_no, sdev->channel, sdev->id);
+		create = 1;
 	}
 	get_device(&starget->dev);
 	sdev->sdev_gendev.parent = &starget->dev;
@@ -711,6 +729,22 @@
 		printk(KERN_ERR "Target device_add failed\n");
 		return error;
 	}
+	if (create) {
+		if (sdev->host->transportt->target_setup)
+			sdev->host->transportt->target_setup(starget);
+		if (starget->transport_classdev.class) {
+			int i;
+			struct class_device_attribute **attrs =
+				sdev->host->transportt->target_attrs;
+			for (i = 0; attrs[i]; i++) {
+				error = class_device_create_file(&starget->transport_classdev,
+								 attrs[i]);
+				if (error)
+					return error;
+			}
+		}
+	}
+
 	return 0;
 }
 
diff -Nru a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	Mon Sep  6 09:42:22 2004
+++ b/drivers/scsi/scsi_transport_fc.c	Mon Sep  6 09:42:22 2004
@@ -156,10 +156,10 @@
 
 	memset(i, 0, sizeof(struct fc_internal));
 
-	i->t.attrs = &i->attrs[0];
-	i->t.class = &fc_transport_class;
-	i->t.setup = &fc_setup_transport_attrs;
-	i->t.size = sizeof(struct fc_transport_attrs);
+	i->t.device_attrs = &i->attrs[0];
+	i->t.device_class = &fc_transport_class;
+	i->t.device_setup = &fc_setup_transport_attrs;
+	i->t.device_size = sizeof(struct fc_transport_attrs);
 	i->f = ft;
 
 	SETUP_ATTRIBUTE_RD(port_id);
diff -Nru a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c	Mon Sep  6 09:42:22 2004
+++ b/drivers/scsi/scsi_transport_spi.c	Mon Sep  6 09:42:22 2004
@@ -666,10 +666,10 @@
 	memset(i, 0, sizeof(struct spi_internal));
 

-	i->t.attrs = &i->attrs[0];
-	i->t.class = &spi_transport_class;
-	i->t.setup = &spi_setup_transport_attrs;
-	i->t.size = sizeof(struct spi_transport_attrs);
+	i->t.device_attrs = &i->attrs[0];
+	i->t.device_class = &spi_transport_class;
+	i->t.device_setup = &spi_setup_transport_attrs;
+	i->t.device_size = sizeof(struct spi_transport_attrs);
 	i->f = ft;
 
 	SETUP_ATTRIBUTE(period);
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Mon Sep  6 09:42:22 2004
+++ b/include/scsi/scsi_host.h	Mon Sep  6 09:42:22 2004
@@ -511,6 +511,13 @@
 	struct list_head sht_legacy_list;
 
 	/*
+	 * Points to the transport data (if any) which is allocated
+	 * separately
+	 */
+	void *transport_data;
+	struct class_device transport_classdev;
+
+	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
 	 * alignment to a long boundary.
@@ -522,6 +529,9 @@
 	container_of(d, struct Scsi_Host, shost_gendev)
 #define		class_to_shost(d)	\
 	container_of(d, struct Scsi_Host, shost_classdev)
+#define		transport_classdev_to_shost(class_dev) \
+	container_of(class_dev, struct Scsi_Host, transport_classdev)
+
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int scsi_add_host(struct Scsi_Host *, struct device *);
diff -Nru a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
--- a/include/scsi/scsi_transport.h	Mon Sep  6 09:42:22 2004
+++ b/include/scsi/scsi_transport.h	Mon Sep  6 09:42:22 2004
@@ -24,18 +24,26 @@
 	/* The NULL terminated list of transport attributes
 	 * that should be exported.
 	 */
-	struct class_device_attribute **attrs;
+	struct class_device_attribute **device_attrs;
+	struct class_device_attribute **target_attrs;
+	struct class_device_attribute **host_attrs;
+
 
 	/* The transport class that the device is in */
-	struct class *class;
+	struct class *device_class;
+	struct class *target_class;
+	struct class *host_class;
+
+	/* Constructor functions */
+	int (*device_setup)(struct scsi_device *);
+	int (*target_setup)(struct scsi_target *);
+	int (*host_setup)(struct Scsi_Host *);
 
-	/* Constructor/Destructor functions */
-	int (* setup)(struct scsi_device *);
-	void (* cleanup)(struct scsi_device *);
 	/* The size of the specific transport attribute structure (a
 	 * space of this size will be left at the end of the
-	 * scsi_device structure */
-	int	size;
+	 * scsi_* structure */
+	int	device_size;
+	int	target_size;
 };
 
 #endif /* SCSI_TRANSPORT_H */

