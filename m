From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi host/scsi device ref count cleanup 4/4
Date: Tue, 8 Jul 2003 15:27:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708222759.GE2232@beaverton.ibm.com>
References: <20030708222447.GA2232@beaverton.ibm.com> <20030708222541.GB2232@beaverton.ibm.com> <20030708222622.GC2232@beaverton.ibm.com> <20030708222706.GD2232@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:32676 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S265403AbTGHWKW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jul 2003 18:10:22 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e33.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h68MOvkj252064
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2003 18:24:57 -0400
Received: from dyn9-47-17-195 (DYN318017.beaverton.ibm.com [9.47.17.83])
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h68MOvgH055780
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2003 16:24:57 -0600
Content-Disposition: inline
In-Reply-To: <20030708222706.GD2232@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-andmike
--
Michael Anderson
andmike@us.ibm.com

DESC
This is a cleanup patch for scsi_device removal.
	- Addition of device_flags member to the scsi_device strucuture to
	  contain "state" of the device instance.
	- Added SDEV_ADD, SDEV_DEL, SDEV_CANCEL, SDEV_RECOVERY states for
	  a scsi device
	- Built on previous patch that renamed scsi_set_device_offline to
	  scsi_device_cancel to use SDEV_CANCEL value.
	- Usage of the device_flags flags member to stop scsi_device_get's
	  and final cleanup on access_count going to zero.
	- Added newer release functions and reordered scsi device sysfs
	  unregister.
EDESC


 drivers/scsi/scsi.c        |   36 ++++++++++++++++++++++-----
 drivers/scsi/scsi_priv.h   |    1 
 drivers/scsi/scsi_sysfs.c  |   60 ++++++++++++++++++++++++++++++---------------
 include/scsi/scsi_device.h |   13 +++++++++
 4 files changed, 84 insertions(+), 26 deletions(-)

diff -puN drivers/scsi/scsi.c~sdev_state drivers/scsi/scsi.c
--- remove-scsi-misc-2.5/drivers/scsi/scsi.c~sdev_state	Tue Jul  8 14:19:55 2003
+++ remove-scsi-misc-2.5-andmike/drivers/scsi/scsi.c	Tue Jul  8 14:19:55 2003
@@ -893,17 +893,41 @@ int scsi_track_queue_full(struct scsi_de
 
 int scsi_device_get(struct scsi_device *sdev)
 {
-	if (!try_module_get(sdev->host->hostt->module))
-		return -ENXIO;
+	struct class *class = class_get(&sdev_class);
+	int error = -ENXIO;
 
-	sdev->access_count++;
-	return 0;
+	if (class) {
+		down_write(&class->subsys.rwsem);
+		if (!test_bit(SDEV_DEL, &sdev->device_flags))
+			if (try_module_get(sdev->host->hostt->module)) 
+				if (get_device(&sdev->sdev_driverfs_dev)) {
+					sdev->access_count++;
+					error = 0;
+				}
+		up_write(&class->subsys.rwsem);
+		class_put(&sdev_class);
+	}
+
+	return error;
 }
 
 void scsi_device_put(struct scsi_device *sdev)
 {
-	sdev->access_count--;
+	struct class *class = class_get(&sdev_class);
+
+	if (!class)
+		return;
+
+	down_write(&class->subsys.rwsem);
 	module_put(sdev->host->hostt->module);
+	if (--sdev->access_count == 0) {
+		if (test_bit(SDEV_DEL, &sdev->device_flags))
+			device_del(&sdev->sdev_driverfs_dev);
+	}
+	put_device(&sdev->sdev_driverfs_dev);
+	up_write(&class->subsys.rwsem);
+
+	class_put(&sdev_class);
 }
 
 /**
@@ -921,7 +945,7 @@ int scsi_device_cancel(struct device *de
 	struct scsi_device *sdev = to_scsi_device(dev);
 	unsigned int recovery = *(unsigned int *)data;
 
-	sdev->online = 0;
+	set_bit(SDEV_CANCEL, &sdev->device_flags);
 
 	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_for_each_entry(scmd, &sdev->cmd_list, list) {
diff -puN drivers/scsi/scsi_sysfs.c~sdev_state drivers/scsi/scsi_sysfs.c
--- remove-scsi-misc-2.5/drivers/scsi/scsi_sysfs.c~sdev_state	Tue Jul  8 14:19:55 2003
+++ remove-scsi-misc-2.5-andmike/drivers/scsi/scsi_sysfs.c	Tue Jul  8 14:19:55 2003
@@ -78,8 +78,25 @@ struct class shost_class = {
 	.release	= scsi_host_cls_release,
 };
 
-static struct class sdev_class = {
+static void scsi_device_cls_release(struct class_device *class_dev)
+{
+	struct scsi_device *sdev;
+
+	sdev = class_to_sdev(class_dev);
+	put_device(&sdev->sdev_driverfs_dev);
+}
+
+static void scsi_device_dev_release(struct device *dev)
+{
+	struct scsi_device *sdev;
+
+	sdev = to_scsi_device(dev);
+	scsi_free_sdev(sdev);
+}
+
+struct class sdev_class = {
 	.name		= "scsi_device",
+	.release	= scsi_device_cls_release,
 };
 
 /* all probing is done in the individual ->probe routines */
@@ -129,7 +146,7 @@ void scsi_sysfs_unregister(void)
  */
 #define sdev_show_function(field, format_string)				\
 static ssize_t								\
-show_##field (struct device *dev, char *buf)				\
+sdev_show_##field (struct device *dev, char *buf)				\
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
@@ -142,7 +159,7 @@ show_##field (struct device *dev, char *
  */
 #define sdev_rd_attr(field, format_string)				\
 	sdev_show_function(field, format_string)				\
-static DEVICE_ATTR(field, S_IRUGO, show_##field, NULL)
+static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL)
 
 
 /*
@@ -160,7 +177,7 @@ sdev_store_##field (struct device *dev, 
 	snscanf (buf, 20, format_string, &sdev->field);			\
 	return count;							\
 }									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, sdev_store_##field)
+static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field)
 
 /*
  * sdev_rd_attr: create a function and attribute variable for a
@@ -182,7 +199,7 @@ sdev_store_##field (struct device *dev, 
 	}								\
 	return ret;							\
 }									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, sdev_store_##field)
+static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field)
 
 /*
  * scsi_sdev_check_buf_bit: return 0 if buf is "0", return 1 if buf is "1",
@@ -212,6 +229,7 @@ sdev_rd_attr (access_count, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
+sdev_rd_attr (device_flags, "%lx\n");
 sdev_rw_attr_bit (online);
 
 static ssize_t
@@ -233,20 +251,12 @@ struct device_attribute *scsi_sysfs_sdev
 	&dev_attr_vendor,
 	&dev_attr_model,
 	&dev_attr_rev,
+	&dev_attr_device_flags,
 	&dev_attr_online,
 	&dev_attr_rescan,
 	NULL
 };
 
-static void scsi_device_release(struct device *dev)
-{
-	struct scsi_device *sdev;
-
-	sdev = to_scsi_device(dev);
-	if (!sdev)
-		return;
-	scsi_free_sdev(sdev);
-}
 
 /**
  * scsi_device_register - register a scsi device with the scsi bus
@@ -259,12 +269,13 @@ int scsi_device_register(struct scsi_dev
 {
 	int error = 0, i;
 
+	__set_bit(SDEV_ADD, &sdev->device_flags);
 	device_initialize(&sdev->sdev_driverfs_dev);
 	sprintf(sdev->sdev_driverfs_dev.bus_id,"%d:%d:%d:%d",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->sdev_driverfs_dev.parent = &sdev->host->host_gendev;
 	sdev->sdev_driverfs_dev.bus = &scsi_bus_type;
-	sdev->sdev_driverfs_dev.release = scsi_device_release;
+	sdev->sdev_driverfs_dev.release = scsi_device_dev_release;
 
 	class_device_initialize(&sdev->sdev_classdev);
 	sdev->sdev_classdev.dev = &sdev->sdev_driverfs_dev;
@@ -284,6 +295,8 @@ int scsi_device_register(struct scsi_dev
 		return error;
 	}
 
+	get_device(&sdev->sdev_driverfs_dev);
+
 	for (i = 0; !error && sdev->host->hostt->sdev_attrs[i] != NULL; i++)
 		error = device_create_file(&sdev->sdev_driverfs_dev,
 					   sdev->host->hostt->sdev_attrs[i]);
@@ -300,12 +313,21 @@ int scsi_device_register(struct scsi_dev
  **/
 void scsi_device_unregister(struct scsi_device *sdev)
 {
-	int i;
+	struct class *class = class_get(&sdev_class);
 
-	for (i = 0; sdev->host->hostt->sdev_attrs[i] != NULL; i++)
-		device_remove_file(&sdev->sdev_driverfs_dev, sdev->host->hostt->sdev_attrs[i]);
+	if (class) {
+		down_write(&class->subsys.rwsem);
+		__set_bit(SDEV_DEL, &sdev->device_flags);
+		if (sdev->access_count == 0)
+			device_del(&sdev->sdev_driverfs_dev);
+		up_write(&class->subsys.rwsem);
+	}
+	
 	class_device_unregister(&sdev->sdev_classdev);
-	device_unregister(&sdev->sdev_driverfs_dev);
+
+	put_device(&sdev->sdev_driverfs_dev);
+
+	class_put(&sdev_class);
 }
 
 int scsi_register_driver(struct device_driver *drv)
diff -puN include/scsi/scsi_device.h~sdev_state include/scsi/scsi_device.h
--- remove-scsi-misc-2.5/include/scsi/scsi_device.h~sdev_state	Tue Jul  8 14:19:55 2003
+++ remove-scsi-misc-2.5-andmike/include/scsi/scsi_device.h	Tue Jul  8 14:19:55 2003
@@ -10,6 +10,14 @@ struct scsi_cmnd;
 struct scsi_mode_data;
 
 
+/*
+ * sdev flags
+ */
+#define SDEV_ADD	1
+#define SDEV_DEL	2
+#define SDEV_CANCEL 	3
+#define SDEV_RECOVERY 	4
+
 struct scsi_device {
 	struct class_device	sdev_classdev;
 
@@ -87,9 +95,13 @@ struct scsi_device {
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
 	struct device sdev_driverfs_dev;
+
+	unsigned long device_flags;
 };
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_driverfs_dev)
+#define	class_to_sdev(d)	\
+	container_of(d, struct scsi_device, sdev_classdev)
 
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
@@ -107,5 +119,4 @@ extern int scsi_set_medium_removal(struc
 extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			   unsigned char *buffer, int len, int timeout,
 			   int retries, struct scsi_mode_data *data);
-
 #endif /* _SCSI_SCSI_DEVICE_H */
diff -puN drivers/scsi/scsi_priv.h~sdev_state drivers/scsi/scsi_priv.h
--- remove-scsi-misc-2.5/drivers/scsi/scsi_priv.h~sdev_state	Tue Jul  8 14:19:55 2003
+++ remove-scsi-misc-2.5-andmike/drivers/scsi/scsi_priv.h	Tue Jul  8 14:19:55 2003
@@ -127,6 +127,7 @@ extern struct class_device_attribute *sc
 extern struct device_attribute *scsi_sysfs_sdev_attrs[];
 
 extern struct class shost_class;
+extern struct class sdev_class;
 extern struct bus_type scsi_bus_type;
 
 #endif /* _SCSI_PRIV_H */

_
