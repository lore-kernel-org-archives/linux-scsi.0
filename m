From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC] scsi host sysfs support again [4/4]
Date: Mon, 5 May 2003 01:38:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505083816.GF8416@beaverton.ibm.com>
References: <20030505083315.GB8416@beaverton.ibm.com> <20030505083445.GC8416@beaverton.ibm.com> <20030505083540.GD8416@beaverton.ibm.com> <20030505083723.GE8416@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:10388 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262054AbTEEIXY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 04:23:24 -0400
Content-Disposition: inline
In-Reply-To: <20030505083723.GE8416@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
Change scsi sysfs to support scsi host class device and call release
functions when ref count goes to zero.
EDESC


 drivers/scsi/scsi_sysfs.c |  111 +++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 96 insertions(+), 15 deletions(-)

diff -puN drivers/scsi/scsi_sysfs.c~sysfs-shosts drivers/scsi/scsi_sysfs.c
--- sysfs-scsi-misc-2.5/drivers/scsi/scsi_sysfs.c~sysfs-shosts	Thu May  1 18:17:38 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/scsi_sysfs.c	Sun May  4 22:48:20 2003
@@ -22,9 +22,9 @@
  */
 #define shost_show_function(field, format_string)			\
 static ssize_t								\
-show_##field (struct device *dev, char *buf)				\
+show_##field (struct class_device *class_dev, char *buf)		\
 {									\
-	struct Scsi_Host *shost = to_scsi_host(dev);			\
+	struct Scsi_Host *shost = class_to_shost(class_dev);		\
 	return snprintf (buf, 20, format_string, shost->field);	\
 }
 
@@ -33,8 +33,8 @@ show_##field (struct device *dev, char *
  * read only field.
  */
 #define shost_rd_attr(field, format_string)				\
-	shost_show_function(field, format_string)				\
-static DEVICE_ATTR(field, S_IRUGO, show_##field, NULL)
+	shost_show_function(field, format_string)			\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_##field, NULL)
 
 /*
  * Create the actual show/store functions and data structures.
@@ -45,16 +45,16 @@ shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
 
-static struct device_attribute *const shost_attrs[] = {
-	&dev_attr_unique_id,
-	&dev_attr_host_busy,
-	&dev_attr_cmd_per_lun,
-	&dev_attr_sg_tablesize,
-	&dev_attr_unchecked_isa_dma,
+static struct class_device_attribute *const shost_attrs[] = {
+	&class_device_attr_unique_id,
+	&class_device_attr_host_busy,
+	&class_device_attr_cmd_per_lun,
+	&class_device_attr_sg_tablesize,
+	&class_device_attr_unchecked_isa_dma,
 };
 
 struct class shost_class = {
-	.name		= "scsi-host",
+	.name		= "scsi_host",
 };
 
 /**
@@ -91,10 +91,16 @@ static struct bus_type scsi_bus_type = {
 
 int scsi_sysfs_register(void)
 {
-	bus_register(&scsi_bus_type);
-	class_register(&shost_class);
+	int error;
 
-	return 0;
+	error = bus_register(&scsi_bus_type);
+	if (error)
+		return error;
+	error = class_register(&shost_class);
+	if (error)
+		return error;
+
+	return error;
 }
 
 void scsi_sysfs_unregister(void)
@@ -250,6 +256,16 @@ static struct device_attribute * const s
 	&dev_attr_rescan,
 };
 
+static void scsi_device_release(struct device *dev)
+{
+	struct scsi_device *sdev;
+
+	sdev = to_scsi_device(dev);
+	if (!sdev)
+		return;
+	scsi_free_sdev(sdev);
+}
+
 /**
  * scsi_device_register - register a scsi device with the scsi bus
  * @sdev:	scsi_device to register
@@ -263,8 +279,9 @@ int scsi_device_register(struct scsi_dev
 
 	sprintf(sdev->sdev_driverfs_dev.bus_id,"%d:%d:%d:%d",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	sdev->sdev_driverfs_dev.parent = sdev->host->host_gendev;
+	sdev->sdev_driverfs_dev.parent = &sdev->host->host_gendev;
 	sdev->sdev_driverfs_dev.bus = &scsi_bus_type;
+	sdev->sdev_driverfs_dev.release = scsi_device_release;
 
 	error = device_register(&sdev->sdev_driverfs_dev);
 	if (error)
@@ -292,3 +309,67 @@ void scsi_device_unregister(struct scsi_
 		device_remove_file(&sdev->sdev_driverfs_dev, sdev_attrs[i]);
 	device_unregister(&sdev->sdev_driverfs_dev);
 }
+
+static void scsi_host_release(struct device *dev)
+{
+	struct Scsi_Host *shost;
+
+	shost = dev_to_shost(dev);
+	if (!shost)
+		return;
+	shost->hostt->release(shost);
+}
+
+/**
+ * scsi_sysfs_add_host - add scsi host to subsystem
+ * @shost:     scsi host struct to add to subsystem
+ * @dev:       parent struct device pointer
+ **/
+int scsi_sysfs_add_host(struct Scsi_Host *shost, struct device *dev)
+{
+	int i, error;
+
+	sprintf(shost->host_gendev.bus_id,"host%d",
+		shost->host_no);
+	if (!shost->host_gendev.parent)
+		shost->host_gendev.parent = (dev) ? dev : &legacy_bus;
+	shost->host_gendev.release = scsi_host_release;
+
+	error = device_register(&shost->host_gendev);
+	if (error)
+		return error;
+
+	shost->class_dev.dev = &shost->host_gendev;
+	shost->class_dev.class = &shost_class;
+	snprintf(shost->class_dev.class_id, BUS_ID_SIZE, "host%d",
+		  shost->host_no);
+	error = class_device_register(&shost->class_dev);
+	if (error)
+		goto clean_device;
+
+	for (i = 0; !error && i < ARRAY_SIZE(shost_attrs); i++)
+		error = class_device_create_file(&shost->class_dev,
+					   shost_attrs[i]);
+	if (error)
+		goto clean_class;
+
+	return error;
+
+clean_class:
+	class_device_unregister(&shost->class_dev);
+clean_device:
+	device_unregister(&shost->host_gendev);
+
+	return error;
+}
+
+/**
+ * scsi_sysfs_remove_host - remove scsi host from subsystem
+ * @shost:     scsi host to remove from subsystem
+ **/
+void scsi_sysfs_remove_host(struct Scsi_Host *shost)
+{
+	class_device_unregister(&shost->class_dev);
+	device_unregister(&shost->host_gendev);
+}
+

_

