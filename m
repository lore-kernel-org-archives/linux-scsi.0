From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi host / scsi device ref counting take 2 [3/3]
Date: Fri, 1 Aug 2003 13:26:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030801202654.GG3868@beaverton.ibm.com>
References: <20030801202431.GE3868@beaverton.ibm.com> <20030801202541.GF3868@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:64706 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S272485AbTHAUl1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Aug 2003 16:41:27 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e31.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h71KfQRZ101456
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2003 16:41:26 -0400
Received: from dyn9-47-17-195 (DYN318028BLD.beaverton.ibm.com [9.47.17.91] (may be forged))
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h71KfPsw099192
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2003 14:41:26 -0600
Content-Disposition: inline
In-Reply-To: <20030801202541.GF3868@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
This is a cleanup patch for scsi_device removal.
- Addition of sdev_state member to the scsi_device strucuture to contain
"state" of the device instance.

- Added SDEV_ADD, SDEV_DEL, SDEV_CANCEL, SDEV_RECOVERY states for a scsi
device

- Built on previous patch that renamed scsi_set_device_offline to
scsi_device_cancel to use SDEV_CANCEL value.

- Usage of the sdev_state member to stop scsi_device_get's and final cleanup
on access_count going to zero.

- Added newer release functions and reordered scsi device sysfs unregister.
EDESC


 drivers/scsi/scsi.c        |   36 +++++++++++++++++++----
 drivers/scsi/scsi_priv.h   |    1 
 drivers/scsi/scsi_scan.c   |    4 +-
 drivers/scsi/scsi_sysfs.c  |   70 ++++++++++++++++++++++++++++++++++-----------
 include/scsi/scsi_device.h |   15 +++++++++
 5 files changed, 100 insertions(+), 26 deletions(-)

diff -puN drivers/scsi/scsi.c~sdev_state drivers/scsi/scsi.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi.c~sdev_state	Fri Aug  1 07:07:20 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi.c	Fri Aug  1 07:07:20 2003
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
+		if (!test_bit(SDEV_DEL, &sdev->sdev_state))
+			if (try_module_get(sdev->host->hostt->module)) 
+				if (get_device(&sdev->sdev_gendev)) {
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
+		if (test_bit(SDEV_DEL, &sdev->sdev_state))
+			device_del(&sdev->sdev_gendev);
+	}
+	put_device(&sdev->sdev_gendev);
+	up_write(&class->subsys.rwsem);
+
+	class_put(&sdev_class);
 }
 
 int scsi_device_cancel_cb(struct device *dev, void *data)
@@ -927,7 +951,7 @@ int scsi_device_cancel(struct scsi_devic
 	struct list_head *lh, *lh_sf;
 	unsigned long flags;
 
-	sdev->online = 0;
+	set_bit(SDEV_CANCEL, &sdev->sdev_state);
 
 	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_for_each_entry(scmd, &sdev->cmd_list, list) {
diff -puN drivers/scsi/scsi_priv.h~sdev_state drivers/scsi/scsi_priv.h
--- patched-scsi-misc-2.5/drivers/scsi/scsi_priv.h~sdev_state	Fri Aug  1 07:07:20 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_priv.h	Fri Aug  1 07:07:20 2003
@@ -121,6 +121,7 @@ extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
 
 extern struct class shost_class;
+extern struct class sdev_class;
 extern struct bus_type scsi_bus_type;
 
 #endif /* _SCSI_PRIV_H */
diff -puN drivers/scsi/scsi_scan.c~sdev_state drivers/scsi/scsi_scan.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi_scan.c~sdev_state	Fri Aug  1 07:07:20 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_scan.c	Fri Aug  1 07:38:00 2003
@@ -288,8 +288,6 @@ void scsi_free_sdev(struct scsi_device *
 
 	if (sdev->request_queue)
 		scsi_free_queue(sdev->request_queue);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
 	if (sdev->inquiry)
 		kfree(sdev->inquiry);
 	spin_lock_irqsave(sdev->host->host_lock, flags);
@@ -1076,6 +1074,8 @@ struct scsi_device *scsi_add_device(stru
 
 int scsi_remove_device(struct scsi_device *sdev)
 {
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
 	scsi_device_unregister(sdev);
 	return 0;
 }
diff -puN drivers/scsi/scsi_sysfs.c~sdev_state drivers/scsi/scsi_sysfs.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi_sysfs.c~sdev_state	Fri Aug  1 07:07:20 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_sysfs.c	Fri Aug  1 07:30:58 2003
@@ -78,8 +78,28 @@ struct class shost_class = {
 	.release	= scsi_host_cls_release,
 };
 
-static struct class sdev_class = {
+static void scsi_device_cls_release(struct class_device *class_dev)
+{
+	struct scsi_device *sdev;
+
+	sdev = class_to_sdev(class_dev);
+	put_device(&sdev->sdev_gendev);
+}
+
+static void scsi_device_dev_release(struct device *dev)
+{
+	struct scsi_device *sdev;
+	struct device *parent;
+
+	parent = dev->parent;
+	sdev = to_scsi_device(dev);
+	scsi_free_sdev(sdev);
+	put_device(parent);
+}
+
+struct class sdev_class = {
 	.name		= "scsi_device",
+	.release	= scsi_device_cls_release,
 };
 
 /* all probing is done in the individual ->probe routines */
@@ -129,7 +149,7 @@ void scsi_sysfs_unregister(void)
  */
 #define sdev_show_function(field, format_string)				\
 static ssize_t								\
-show_##field (struct device *dev, char *buf)				\
+sdev_show_##field (struct device *dev, char *buf)				\
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
@@ -142,7 +162,7 @@ show_##field (struct device *dev, char *
  */
 #define sdev_rd_attr(field, format_string)				\
 	sdev_show_function(field, format_string)				\
-static DEVICE_ATTR(field, S_IRUGO, show_##field, NULL)
+static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL)
 
 
 /*
@@ -160,7 +180,7 @@ sdev_store_##field (struct device *dev, 
 	snscanf (buf, 20, format_string, &sdev->field);			\
 	return count;							\
 }									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, sdev_store_##field)
+static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field)
 
 /*
  * sdev_rd_attr: create a function and attribute variable for a
@@ -182,7 +202,7 @@ sdev_store_##field (struct device *dev, 
 	}								\
 	return ret;							\
 }									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, sdev_store_##field)
+static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field)
 
 /*
  * scsi_sdev_check_buf_bit: return 0 if buf is "0", return 1 if buf is "1",
@@ -238,15 +258,6 @@ static struct device_attribute *scsi_sys
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
 
 static struct device_attribute *attr_overridden(
 		struct device_attribute **attrs,
@@ -295,12 +306,13 @@ int scsi_device_register(struct scsi_dev
 {
 	int error = 0, i;
 
+	set_bit(SDEV_ADD, &sdev->sdev_state);
 	device_initialize(&sdev->sdev_gendev);
 	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->sdev_gendev.parent = &sdev->host->shost_gendev;
 	sdev->sdev_gendev.bus = &scsi_bus_type;
-	sdev->sdev_gendev.release = scsi_device_release;
+	sdev->sdev_gendev.release = scsi_device_dev_release;
 
 	class_device_initialize(&sdev->sdev_classdev);
 	sdev->sdev_classdev.dev = &sdev->sdev_gendev;
@@ -313,13 +325,18 @@ int scsi_device_register(struct scsi_dev
 		printk(KERN_INFO "error 1\n");
 		return error;
 	}
+
+	get_device(sdev->sdev_gendev.parent);
+
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
-		device_unregister(&sdev->sdev_gendev);
+		goto clean_device;
 		return error;
 	}
 
+	get_device(&sdev->sdev_gendev);
+
 	if (sdev->host->hostt->sdev_attrs) {
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
 			error = attr_add(&sdev->sdev_gendev,
@@ -340,6 +357,12 @@ int scsi_device_register(struct scsi_dev
 	}
 
 	return error;
+
+clean_device:
+	device_del(&sdev->sdev_gendev);
+	put_device(&sdev->sdev_gendev);
+	return error;
+
 }
 
 /**
@@ -348,8 +371,21 @@ int scsi_device_register(struct scsi_dev
  **/
 void scsi_device_unregister(struct scsi_device *sdev)
 {
+	struct class *class = class_get(&sdev_class);
+
 	class_device_unregister(&sdev->sdev_classdev);
-	device_unregister(&sdev->sdev_gendev);
+
+	if (class) {
+		down_write(&class->subsys.rwsem);
+		set_bit(SDEV_DEL, &sdev->sdev_state);
+		if (sdev->access_count == 0)
+			device_del(&sdev->sdev_gendev);
+		up_write(&class->subsys.rwsem);
+	}
+
+	put_device(&sdev->sdev_gendev);
+
+	class_put(&sdev_class);
 }
 
 int scsi_register_driver(struct device_driver *drv)
diff -puN include/scsi/scsi_device.h~sdev_state include/scsi/scsi_device.h
--- patched-scsi-misc-2.5/include/scsi/scsi_device.h~sdev_state	Fri Aug  1 07:07:20 2003
+++ patched-scsi-misc-2.5-andmike/include/scsi/scsi_device.h	Fri Aug  1 07:07:20 2003
@@ -10,6 +10,16 @@ struct scsi_cmnd;
 struct scsi_mode_data;
 
 
+/*
+ * sdev state
+ */
+enum {
+	SDEV_ADD,
+	SDEV_DEL,
+	SDEV_CANCEL,
+	SDEV_RECOVERY,
+};
+
 struct scsi_device {
 	struct list_head    siblings;   /* list of all devices on this host */
 	struct list_head    same_target_siblings; /* just the devices sharing same target id */
@@ -86,9 +96,13 @@ struct scsi_device {
 
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
+
+	unsigned long sdev_state;
 };
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
+#define	class_to_sdev(d)	\
+	container_of(d, struct scsi_device, sdev_classdev)
 
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
@@ -107,5 +121,4 @@ extern int scsi_set_medium_removal(struc
 extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			   unsigned char *buffer, int len, int timeout,
 			   int retries, struct scsi_mode_data *data);
-
 #endif /* _SCSI_SCSI_DEVICE_H */

_

