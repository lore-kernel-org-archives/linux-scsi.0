From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add target and host to transport classes
Date: 07 Sep 2004 13:23:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094577840.2069.118.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:58779 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268200AbUIGRYB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 13:24:01 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i87HO0J15196
	for <linux-scsi@vger.kernel.org>; Tue, 7 Sep 2004 13:24:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

OK, I've polished this up quite a bit, and actually got the
implementation to work in the SPI transport classes.  It still needs to
be commented and have all the failure cases sorted out, but this should
be ready to play with. (Obviously, you need the target patch before this
will apply.)

James

diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	2004-09-07 12:20:29 -05:00
+++ b/drivers/scsi/hosts.c	2004-09-07 12:20:29 -05:00
@@ -82,6 +82,8 @@
 	set_bit(SHOST_DEL, &shost->shost_state);
 
 	class_device_unregister(&shost->shost_classdev);
+	if (shost->transport_classdev.class)
+		class_device_unregister(&shost->transport_classdev);
 	device_del(&shost->shost_gendev);
 }
 
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	2004-09-07 12:20:29 -05:00
+++ b/drivers/scsi/scsi_priv.h	2004-09-07 12:20:29 -05:00
@@ -58,22 +58,6 @@
  */
 #define SCAN_WILD_CARD	~0
 
-/*
- * scsi_target: representation of a scsi target, for now, this is only
- * used for single_lun devices. If no one has active IO to the target,
- * starget_sdev_user is NULL, else it points to the active sdev.
- */
-struct scsi_target {
-	struct scsi_device	*starget_sdev_user;
-	struct device		dev;
-};
-
-#define to_scsi_target(d)	container_of(d, struct scsi_target, dev)
-static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
-{
-	return to_scsi_target(sdev->sdev_gendev.parent);
-}
-
 /* hosts.c */
 extern int scsi_init_hosts(void);
 extern void scsi_exit_hosts(void);
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2004-09-07 12:20:29 -05:00
+++ b/drivers/scsi/scsi_scan.c	2004-09-07 12:20:29 -05:00
@@ -202,10 +202,11 @@
 static struct scsi_device *scsi_alloc_sdev(struct Scsi_Host *shost,
 	       	uint channel, uint id, uint lun, void *hostdata)
 {
-	struct scsi_device *sdev, *device;
+	struct scsi_device *sdev;
 	unsigned long flags;
 
-	sdev = kmalloc(sizeof(*sdev) + shost->transportt->size, GFP_ATOMIC);
+	sdev = kmalloc(sizeof(*sdev) + shost->transportt->device_size,
+		       GFP_ATOMIC);
 	if (!sdev)
 		goto out;
 
@@ -256,45 +257,28 @@
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
 
-	/*
-	 * If there are any same target siblings, add this to the
-	 * sibling list
-	 */
-	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry(device, &shost->__devices, siblings) {
-		if (device->id == sdev->id &&
-		    device->channel == sdev->channel) {
-			list_add_tail(&sdev->same_target_siblings,
-				      &device->same_target_siblings);
-			sdev->scsi_level = device->scsi_level;
-			break;
-		}
-	}
 
-	/*
-	 * If there wasn't another lun already configured at this
-	 * target, then default this device to SCSI_2 until we
-	 * know better
-	 */
-	if (!sdev->scsi_level)
-		sdev->scsi_level = SCSI_2;
+	/* NOTE: this target initialisation code depends critically on
+	 * lun scanning being sequential. */
+	if (scsi_sysfs_target_initialize(sdev))
+		goto out_remove_siblings;
 
-	list_add_tail(&sdev->siblings, &shost->__devices);
-	spin_unlock_irqrestore(shost->host_lock, flags);
 	return sdev;
 
-out_cleanup_transport:
-	if (shost->transportt->cleanup)
-		shost->transportt->cleanup(sdev);
+out_remove_siblings:
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del(&sdev->siblings);
+	list_del(&sdev->same_target_siblings);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 out_cleanup_slave:
 	if (shost->hostt->slave_destroy)
 		shost->hostt->slave_destroy(sdev);
@@ -586,11 +570,6 @@
 	if (*bflags & BLIST_NOSTARTONADD)
 		sdev->no_start_on_add = 1;
 
-	/* NOTE: this target initialisation code depends critically on
-	 * lun scanning being sequential. */
-	if(scsi_sysfs_target_initialize(sdev))
-		return SCSI_SCAN_NO_RESPONSE;
-
 	if (*bflags & BLIST_SINGLELUN)
 		sdev->single_lun = 1;
 
@@ -733,8 +712,6 @@
 	} else {
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
-		if (sdev->host->transportt->cleanup)
-			sdev->host->transportt->cleanup(sdev);
 		put_device(&sdev->sdev_gendev);
 	}
  out:
@@ -1293,7 +1270,5 @@
 
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
-	if (sdev->host->transportt->cleanup)
-		sdev->host->transportt->cleanup(sdev);
 	put_device(&sdev->sdev_gendev);
 }
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	2004-09-07 12:20:29 -05:00
+++ b/drivers/scsi/scsi_sysfs.c	2004-09-07 12:20:29 -05:00
@@ -160,14 +160,19 @@
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
 	/* If we're the last LUN on the target, destroy the target */
-	delete = (list_empty(&sdev->same_target_siblings) && parent);
+	delete = list_empty(&sdev->same_target_siblings);
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	if (delete) {
-		device_del(parent);
+		struct scsi_target *starget = to_scsi_target(parent);
+		if (!starget->create) {
+			device_del(parent);
+			if (starget->transport_classdev.class)
+				class_device_unregister(&starget->transport_classdev);
+		}
 		put_device(parent);
 	}
 	if (sdev->request_queue)
@@ -454,7 +459,48 @@
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
 	struct class_device_attribute **attrs;
-	int error, i;
+	struct scsi_target *starget = sdev->sdev_target;
+	struct Scsi_Host *shost = sdev->host;
+	int error, i, create;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	create = starget->create;
+	starget->create = 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (create) {
+		error = device_add(&starget->dev);
+		if (error) {
+			printk(KERN_ERR "Target device_add failed\n");
+			return error;
+		}
+		if (starget->transport_classdev.class) {
+			int i;
+			struct class_device_attribute **attrs =
+				sdev->host->transportt->target_attrs;
+
+			error = class_device_add(&starget->transport_classdev);
+			if (error) {
+				dev_printk(KERN_ERR, &starget->dev,
+					   "Target transport add failed\n");
+				return error;
+			}
+
+			/* take a reference for the transport_classdev; this
+			 * is released by the transport_class .release */
+			get_device(&starget->dev);
+			for (i = 0; attrs[i]; i++) {
+				error = class_device_create_file(&starget->transport_classdev,
+								 attrs[i]);
+				if (error) {
+					dev_printk(KERN_ERR, &starget->dev,
+						   "Target transport attr add failed\n");
+					return error;
+				}
+			}
+		}
+	}
 
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
 		return error;
@@ -474,7 +520,6 @@
 	/* take a reference for the sdev_classdev; this is
 	 * released by the sdev_class .release */
 	get_device(&sdev->sdev_gendev);
-
 	if (sdev->transport_classdev.class) {
 		error = class_device_add(&sdev->transport_classdev);
 		if (error)
@@ -509,7 +554,7 @@
 	}
 
  	if (sdev->transport_classdev.class) {
- 		attrs = sdev->host->transportt->attrs;
+ 		attrs = sdev->host->transportt->device_attrs;
  		for (i = 0; attrs[i]; i++) {
  			error = class_device_create_file(&sdev->transport_classdev,
  							 attrs[i]);
@@ -553,8 +598,6 @@
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
-	if (sdev->host->transportt->cleanup)
-		sdev->host->transportt->cleanup(sdev);
 	put_device(&sdev->sdev_gendev);
 
 out:
@@ -641,6 +684,29 @@
 		}
 	}
 
+	if (shost->transportt->host_setup)
+		shost->transportt->host_setup(shost);
+
+	class_device_initialize(&shost->transport_classdev);
+	shost->transport_classdev.class = shost->transportt->host_class;
+	shost->transport_classdev.dev = &shost->shost_gendev;
+	snprintf(shost->transport_classdev.class_id, BUS_ID_SIZE,
+		 "host%d", shost->host_no);
+
+	if (shost->transport_classdev.class) {
+		struct class_device_attribute **attrs =
+			shost->transportt->host_attrs;
+		error = class_device_add(&shost->transport_classdev);
+		if (error)
+			return error;
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
 
@@ -662,7 +728,7 @@
 
 	class_device_initialize(&sdev->transport_classdev);
 	sdev->transport_classdev.dev = &sdev->sdev_gendev;
-	sdev->transport_classdev.class = sdev->host->transportt->class;
+	sdev->transport_classdev.class = sdev->host->transportt->device_class;
 	snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
 		 "%d:%d:%d:%d", sdev->host->host_no,
 		 sdev->channel, sdev->id, sdev->lun);
@@ -672,45 +738,66 @@
 int scsi_sysfs_target_initialize(struct scsi_device *sdev)
 {
 	struct scsi_target *starget = NULL;
-	struct scsi_device *sdev_sibling;
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_device *device;
 	struct device *dev = NULL;
-	int error;
 	unsigned long flags;
+	int create = 0;
 
-	spin_lock_irqsave(sdev->host->host_lock, flags);
+	spin_lock_irqsave(shost->host_lock, flags);
 	/*
 	 * Search for an existing target for this sdev.
 	 */
-	list_for_each_entry(sdev_sibling, &sdev->same_target_siblings,
-			    same_target_siblings) {
-		if (sdev_sibling->sdev_gendev.parent != NULL) {
-			starget = scsi_target(sdev_sibling);
+	list_for_each_entry(device, &shost->__devices, siblings) {
+		if (device->id == sdev->id &&
+		    device->channel == sdev->channel) {
+			list_add_tail(&sdev->same_target_siblings,
+				      &device->same_target_siblings);
+			sdev->scsi_level = device->scsi_level;
+			starget = device->sdev_target;
 			break;
 		}
 	}
+			
 	if (!starget) {
-		starget = kmalloc(sizeof(*starget), GFP_ATOMIC);
+		const int size = sizeof(*starget) +
+			shost->transportt->target_size;
+		starget = kmalloc(size, GFP_ATOMIC);
 		if (!starget) {
 			printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
-			spin_unlock_irqrestore(sdev->host->host_lock,
+			spin_unlock_irqrestore(shost->host_lock,
 					       flags);
 			return -ENOMEM;
 		}
-		memset(starget, 0, sizeof(*starget));
+		memset(starget, 0, size);
 		dev = &starget->dev;
 		device_initialize(dev);
-		dev->parent = &sdev->host->shost_gendev;
+		dev->parent = &shost->shost_gendev;
 		dev->release = scsi_target_dev_release;
 		sprintf(dev->bus_id, "target%d:%d:%d",
-			sdev->host->host_no, sdev->channel, sdev->id);
+			shost->host_no, sdev->channel, sdev->id);
+		class_device_initialize(&starget->transport_classdev);
+		starget->transport_classdev.dev = &starget->dev;
+		starget->transport_classdev.class = shost->transportt->target_class;
+		snprintf(starget->transport_classdev.class_id, BUS_ID_SIZE,
+			 "target%d:%d:%d",
+			 shost->host_no, sdev->channel, sdev->id);
+		starget->id = sdev->id;
+		create = starget->create = 1;
+		/*
+		 * If there wasn't another lun already configured at
+		 * this target, then default this device to SCSI_2
+		 * until we know better
+		 */
+		sdev->scsi_level = SCSI_2;
 	}
 	get_device(&starget->dev);
 	sdev->sdev_gendev.parent = &starget->dev;
-	spin_unlock_irqrestore(sdev->host->host_lock, flags);
-	if (dev && (error = device_add(dev))) {
-		printk(KERN_ERR "Target device_add failed\n");
-		return error;
-	}
+	sdev->sdev_target = starget;
+	list_add_tail(&sdev->siblings, &shost->__devices);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	if (create && shost->transportt->target_setup)
+		shost->transportt->target_setup(starget);
 	return 0;
 }
 
diff -Nru a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2004-09-07 12:20:29 -05:00
+++ b/drivers/scsi/scsi_transport_fc.c	2004-09-07 12:20:29 -05:00
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
--- a/drivers/scsi/scsi_transport_spi.c	2004-09-07 12:20:29 -05:00
+++ b/drivers/scsi/scsi_transport_spi.c	2004-09-07 12:20:29 -05:00
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
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	2004-09-07 12:20:29 -05:00
+++ b/include/scsi/scsi_device.h	2004-09-07 12:20:29 -05:00
@@ -129,6 +129,29 @@
 #define transport_class_to_sdev(class_dev) \
 	container_of(class_dev, struct scsi_device, transport_classdev)
 
+/*
+ * scsi_target: representation of a scsi target, for now, this is only
+ * used for single_lun devices. If no one has active IO to the target,
+ * starget_sdev_user is NULL, else it points to the active sdev.
+ */
+struct scsi_target {
+	struct scsi_device	*starget_sdev_user;
+	struct device		dev;
+	unsigned int		id; /* target id ... replace
+				     * scsi_device.id eventually */
+	struct class_device	transport_classdev;
+	unsigned long		create:1; /* signal that it needs to be added */
+	unsigned long		transport_data[0];
+} __attribute__((aligned(sizeof(unsigned long))));
+
+#define to_scsi_target(d)	container_of(d, struct scsi_target, dev)
+static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
+{
+	return to_scsi_target(sdev->sdev_gendev.parent);
+}
+#define transport_class_to_starget(class_dev) \
+	container_of(class_dev, struct scsi_target, transport_classdev)
+
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint, void *hostdata);
 #define scsi_add_device(host, channel, target, lun) \
@@ -191,6 +214,8 @@
 				 enum scsi_device_state state);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
+extern void scsi_target_quiesce(struct scsi_target *);
+extern void scsi_target_resume(struct scsi_target *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2004-09-07 12:20:29 -05:00
+++ b/include/scsi/scsi_host.h	2004-09-07 12:20:29 -05:00
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
--- a/include/scsi/scsi_transport.h	2004-09-07 12:20:29 -05:00
+++ b/include/scsi/scsi_transport.h	2004-09-07 12:20:29 -05:00
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

