From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] consistant names for device model related struct members
Date: Mon, 7 Jul 2003 08:20:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030707062021.GA27465@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:35743 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266818AbTGGGGG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2003 02:06:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

currently the embedded struct devices and class devices have totally
irregular and sometimes confusing (sdev_driverfs_dev) names.  Name
them consistanly s{dev,host}_{class,gen}dev.


diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Sat Jul  5 22:53:01 2003
+++ b/drivers/scsi/hosts.c	Sat Jul  5 22:53:01 2003
@@ -283,8 +283,8 @@
  **/
 void scsi_host_get(struct Scsi_Host *shost)
 {
-	get_device(&shost->host_gendev);
-	class_device_get(&shost->class_dev);
+	get_device(&shost->shost_gendev);
+	class_device_get(&shost->shost_classdev);
 }
 
 /**
@@ -293,6 +293,6 @@
  **/
 void scsi_host_put(struct Scsi_Host *shost)
 {
-	class_device_put(&shost->class_dev);
-	put_device(&shost->host_gendev);
+	class_device_put(&shost->shost_classdev);
+	put_device(&shost->shost_gendev);
 }
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Sat Jul  5 22:53:01 2003
+++ b/drivers/scsi/scsi_scan.c	Sat Jul  5 22:53:01 2003
@@ -464,8 +464,7 @@
 	while (i >= 0 && type[i] == ' ')
 		type[i--] = '\0';
 
-	snprintf(sdev->sdev_driverfs_dev.name, DEVICE_NAME_SIZE, "SCSI %s",
-		 type);
+	snprintf(sdev->sdev_gendev.name, DEVICE_NAME_SIZE, "SCSI %s", type);
 }
 
 /**
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Sat Jul  5 22:53:01 2003
+++ b/drivers/scsi/scsi_sysfs.c	Sat Jul  5 22:53:01 2003
@@ -239,20 +239,20 @@
 {
 	int error = 0, i;
 
-	device_initialize(&sdev->sdev_driverfs_dev);
-	sprintf(sdev->sdev_driverfs_dev.bus_id,"%d:%d:%d:%d",
+	device_initialize(&sdev->sdev_gendev);
+	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	sdev->sdev_driverfs_dev.parent = &sdev->host->host_gendev;
-	sdev->sdev_driverfs_dev.bus = &scsi_bus_type;
-	sdev->sdev_driverfs_dev.release = scsi_device_release;
+	sdev->sdev_gendev.parent = &sdev->host->shost_gendev;
+	sdev->sdev_gendev.bus = &scsi_bus_type;
+	sdev->sdev_gendev.release = scsi_device_release;
 
 	class_device_initialize(&sdev->sdev_classdev);
-	sdev->sdev_classdev.dev = &sdev->sdev_driverfs_dev;
+	sdev->sdev_classdev.dev = &sdev->sdev_gendev;
 	sdev->sdev_classdev.class = &sdev_class;
 	snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE, "%d:%d:%d:%d",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 
-	error = device_add(&sdev->sdev_driverfs_dev);
+	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		printk(KERN_INFO "error 1\n");
 		return error;
@@ -260,12 +260,12 @@
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
-		device_unregister(&sdev->sdev_driverfs_dev);
+		device_unregister(&sdev->sdev_gendev);
 		return error;
 	}
 
 	for (i = 0; !error && sdev->host->hostt->sdev_attrs[i] != NULL; i++)
-		error = device_create_file(&sdev->sdev_driverfs_dev,
+		error = device_create_file(&sdev->sdev_gendev,
 					   sdev->host->hostt->sdev_attrs[i]);
 
 	if (error)
@@ -283,9 +283,9 @@
 	int i;
 
 	for (i = 0; sdev->host->hostt->sdev_attrs[i] != NULL; i++)
-		device_remove_file(&sdev->sdev_driverfs_dev, sdev->host->hostt->sdev_attrs[i]);
+		device_remove_file(&sdev->sdev_gendev, sdev->host->hostt->sdev_attrs[i]);
 	class_device_unregister(&sdev->sdev_classdev);
-	device_unregister(&sdev->sdev_driverfs_dev);
+	device_unregister(&sdev->sdev_gendev);
 }
 
 int scsi_register_driver(struct device_driver *drv)
@@ -315,17 +315,17 @@
 
 void scsi_sysfs_init_host(struct Scsi_Host *shost)
 {
-	device_initialize(&shost->host_gendev);
-	snprintf(shost->host_gendev.bus_id, BUS_ID_SIZE, "host%d",
+	device_initialize(&shost->shost_gendev);
+	snprintf(shost->shost_gendev.bus_id, BUS_ID_SIZE, "host%d",
 		shost->host_no);
-	snprintf(shost->host_gendev.name, DEVICE_NAME_SIZE, "%s",
+	snprintf(shost->shost_gendev.name, DEVICE_NAME_SIZE, "%s",
 		shost->hostt->proc_name);
-	shost->host_gendev.release = scsi_host_release;
+	shost->shost_gendev.release = scsi_host_release;
 
-	class_device_initialize(&shost->class_dev);
-	shost->class_dev.dev = &shost->host_gendev;
-	shost->class_dev.class = &shost_class;
-	snprintf(shost->class_dev.class_id, BUS_ID_SIZE, "host%d",
+	class_device_initialize(&shost->shost_classdev);
+	shost->shost_classdev.dev = &shost->shost_gendev;
+	shost->shost_classdev.class = &shost_class;
+	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "host%d",
 		  shost->host_no);
 }
 
@@ -338,19 +338,19 @@
 {
 	int i, error;
 
-	if (!shost->host_gendev.parent)
-		shost->host_gendev.parent = dev ? dev : &legacy_bus;
+	if (!shost->shost_gendev.parent)
+		shost->shost_gendev.parent = dev ? dev : &legacy_bus;
 
-	error = device_add(&shost->host_gendev);
+	error = device_add(&shost->shost_gendev);
 	if (error)
 		return error;
 
-	error = class_device_add(&shost->class_dev);
+	error = class_device_add(&shost->shost_classdev);
 	if (error)
 		goto clean_device;
 
 	for (i = 0; !error && shost->hostt->shost_attrs[i] != NULL; i++)
-		error = class_device_create_file(&shost->class_dev,
+		error = class_device_create_file(&shost->shost_classdev,
 					   shost->hostt->shost_attrs[i]);
 	if (error)
 		goto clean_class;
@@ -358,9 +358,9 @@
 	return error;
 
 clean_class:
-	class_device_del(&shost->class_dev);
+	class_device_del(&shost->shost_classdev);
 clean_device:
-	device_del(&shost->host_gendev);
+	device_del(&shost->shost_gendev);
 
 	return error;
 }
@@ -371,8 +371,8 @@
  **/
 void scsi_sysfs_remove_host(struct Scsi_Host *shost)
 {
-	class_device_del(&shost->class_dev);
-	device_del(&shost->host_gendev);
+	class_device_del(&shost->shost_classdev);
+	device_del(&shost->shost_gendev);
 }
 
 /** scsi_sysfs_modify_shost_attribute - modify or add a host class attribute
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Sat Jul  5 22:53:01 2003
+++ b/drivers/scsi/sd.c	Sat Jul  5 22:53:01 2003
@@ -1318,7 +1318,7 @@
 
 	sd_revalidate_disk(gd);
 
-	gd->driverfs_dev = &sdp->sdev_driverfs_dev;
+	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_DRIVERFS;
 	if (sdp->removable)
 		gd->flags |= GENHD_FL_REMOVABLE;
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Sat Jul  5 22:53:01 2003
+++ b/drivers/scsi/sr.c	Sat Jul  5 22:53:01 2003
@@ -533,7 +533,7 @@
 
 	snprintf(disk->devfs_name, sizeof(disk->devfs_name),
 			"%s/cd", sdev->devfs_name);
-	disk->driverfs_dev = &sdev->sdev_driverfs_dev;
+	disk->driverfs_dev = &sdev->sdev_gendev;
 	register_cdrom(&cd->cdi);
 	set_capacity(disk, cd->capacity);
 	disk->private_data = &cd->driver;
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Sat Jul  5 22:53:01 2003
+++ b/include/scsi/scsi_device.h	Sat Jul  5 22:53:01 2003
@@ -11,8 +11,6 @@
 
 
 struct scsi_device {
-	struct class_device	sdev_classdev;
-
 	struct list_head    siblings;   /* list of all devices on this host */
 	struct list_head    same_target_siblings; /* just the devices sharing same target id */
 	struct Scsi_Host *host;
@@ -86,10 +84,11 @@
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
-	struct device sdev_driverfs_dev;
+	struct device		sdev_gendev;
+	struct class_device	sdev_classdev;
 };
 #define	to_scsi_device(d)	\
-	container_of(d, struct scsi_device, sdev_driverfs_dev)
+	container_of(d, struct scsi_device, sdev_gendev)
 
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Sat Jul  5 22:53:01 2003
+++ b/include/scsi/scsi_host.h	Sat Jul  5 22:53:01 2003
@@ -442,12 +442,6 @@
 	 */
 	unsigned int max_host_blocked;
 
-	/* 
-	 * Support for sysfs
-	 */
-	struct device host_gendev;
-	struct class_device class_dev;
-
 	/* legacy crap */
 	unsigned long base;
 	unsigned long io_port;
@@ -455,6 +449,9 @@
 	unsigned char dma_channel;
 	unsigned int  irq;
 
+	/* ldm bits */
+	struct device		shost_gendev;
+	struct class_device	shost_classdev;
 
 	/*
 	 * List of hosts per template.
@@ -474,9 +471,9 @@
 		__attribute__ ((aligned (sizeof(unsigned long))));
 };
 #define		dev_to_shost(d)		\
-	container_of(d, struct Scsi_Host, host_gendev)
+	container_of(d, struct Scsi_Host, shost_gendev)
 #define		class_to_shost(d)	\
-	container_of(d, struct Scsi_Host, class_dev)
+	container_of(d, struct Scsi_Host, shost_classdev)
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int scsi_add_host(struct Scsi_Host *, struct device *);
@@ -495,12 +492,12 @@
 static inline void scsi_set_device(struct Scsi_Host *shost,
                                    struct device *dev)
 {
-        shost->host_gendev.parent = dev;
+        shost->shost_gendev.parent = dev;
 }
 
 static inline struct device *scsi_get_device(struct Scsi_Host *shost)
 {
-        return shost->host_gendev.parent;
+        return shost->shost_gendev.parent;
 }
 
 extern void scsi_sysfs_release_attributes(struct scsi_host_template *);
