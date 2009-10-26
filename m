From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/5] osduld: Use device->release instead of internal kref
Date: Mon, 26 Oct 2009 18:58:14 +0200
Message-ID: <1256576294-10430-1-git-send-email-bharrosh@panasas.com>
References: <4AE5D374.80400@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:33941 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753480AbZJZQ6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2009 12:58:12 -0400
In-Reply-To: <4AE5D374.80400@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

The true logic of this patch will be clear in the next patch where we
use the class_find_device???() API. When doing so the use of an internal
kref leaves us a narrow window where a find is started while the actual
object can go away. Using the device's kobj reference solves this problem
because now the same kref is used for both operations. (Remove and find)

Some cleanups
* Use class register/unregister is cleaner for this driver now.
* Call create_device with the right parameters, and save calling
  set_drv_data() (It was not a bug just a side effect)
* cdev ref-counting games are no longer necessary

Core changes
* At create_device (in osd_probe), returned device->release is saved in an internal
  member and the final __remove function is now registered as the device->release
  function. (__Remove was moved in the file to avoid forward declaration)
* At __remove() chain to the old device->release() to de-allocate the device
  created by create_device.
* __uld_get/put is just device_get/put. Now every thing is accounted for on the
  device object.

I have incremented the device version string in case of new bugs.

Note: that previous bugfix of taking the reference around fput() still applies.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_uld.c   |  129 ++++++++++++++++++++++--------------------
 include/scsi/osd_initiator.h |    1 -
 2 files changed, 67 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 1ea6447..7ec12ef 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -71,8 +71,7 @@
 #define SCSI_OSD_MAX_MINOR 64
 
 static const char osd_name[] = "osd";
-static const char *osd_version_string = "open-osd 0.1.0";
-const char osd_symlink[] = "scsi_osd";
+static const char *osd_version_string = "open-osd 0.2.0";
 
 MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
 MODULE_DESCRIPTION("open-osd Upper-Layer-Driver osd.ko");
@@ -80,18 +79,33 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_OSD_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_OSD);
 
+#define OSD_FMT_d "osd%d"
+
 struct osd_uld_device {
 	int minor;
-	struct kref kref;
 	struct cdev cdev;
 	struct osd_dev od;
 	struct gendisk *disk;
 	struct device *class_member;
+	typeof(((struct device *)NULL)->release) save_release;
 };
 
+struct osd_dev_handle {
+	struct osd_dev od;
+	struct file *file;
+	struct osd_uld_device *oud;
+} ;
+
+static DEFINE_IDA(osd_minor_ida);
+
 static void __uld_get(struct osd_uld_device *oud);
 static void __uld_put(struct osd_uld_device *oud);
 
+static struct class osd_uld_class = {
+	.owner		= THIS_MODULE,
+	.name		= "scsi_osd",
+};
+
 /*
  * Char Device operations
  */
@@ -177,7 +191,7 @@ static const struct file_operations osd_fops = {
 struct osd_dev *osduld_path_lookup(const char *name)
 {
 	struct osd_uld_device *oud;
-	struct osd_dev *od;
+	struct osd_dev_handle *odh;
 	struct file *file;
 	int error;
 
@@ -186,8 +200,8 @@ struct osd_dev *osduld_path_lookup(const char *name)
 		return ERR_PTR(-EINVAL);
 	}
 
-	od = kzalloc(sizeof(*od), GFP_KERNEL);
-	if (!od)
+	odh = kzalloc(sizeof(*odh), GFP_KERNEL);
+	if (unlikely(!odh))
 		return ERR_PTR(-ENOMEM);
 
 	file = filp_open(name, O_RDWR, 0);
@@ -203,24 +217,26 @@ struct osd_dev *osduld_path_lookup(const char *name)
 
 	oud = file->private_data;
 
-	*od = oud->od;
-	od->file = file;
+	odh->od = oud->od;
+	odh->file = file;
+	odh->oud = oud;
 
-	return od;
+	return &odh->od;
 
 close_file:
 	fput(file);
 free_od:
-	kfree(od);
+	kfree(odh);
 	return ERR_PTR(error);
 }
 EXPORT_SYMBOL(osduld_path_lookup);
 
 void osduld_put_device(struct osd_dev *od)
 {
-
 	if (od && !IS_ERR(od)) {
-		struct osd_uld_device *oud = od->file->private_data;
+		struct osd_dev_handle *odh =
+				container_of(od, struct osd_dev_handle, od);
+		struct osd_uld_device *oud = odh->oud;
 
 		BUG_ON(od->scsi_device != oud->od.scsi_device);
 
@@ -231,9 +247,9 @@ void osduld_put_device(struct osd_dev *od)
 		 * sure we have a cdev for the duration of fput
 		 */
 		__uld_get(oud);
-		fput(od->file);
+		fput(odh->file);
 		__uld_put(oud);
-		kfree(od);
+		kfree(odh);
 	}
 }
 EXPORT_SYMBOL(osduld_put_device);
@@ -264,8 +280,28 @@ static int __detect_osd(struct osd_uld_device *oud)
 	return 0;
 }
 
-static struct class *osd_sysfs_class;
-static DEFINE_IDA(osd_minor_ida);
+static void __remove(struct device *dev)
+{
+	struct osd_uld_device *oud = dev_get_drvdata(dev);
+	struct scsi_device *scsi_device = oud->od.scsi_device;
+
+	oud->save_release(oud->class_member);
+
+	if (oud->cdev.owner)
+		cdev_del(&oud->cdev);
+
+	osd_dev_fini(&oud->od);
+	scsi_device_put(scsi_device);
+
+	OSD_INFO("osd_remove %s\n",
+		 oud->disk ? oud->disk->disk_name : NULL);
+
+	if (oud->disk)
+		put_disk(oud->disk);
+	ida_remove(&osd_minor_ida, oud->minor);
+
+	kfree(oud);
+}
 
 static int osd_probe(struct device *dev)
 {
@@ -297,7 +333,6 @@ static int osd_probe(struct device *dev)
 	if (NULL == oud)
 		goto err_retract_minor;
 
-	kref_init(&oud->kref);
 	dev_set_drvdata(dev, oud);
 	oud->minor = minor;
 
@@ -310,7 +345,7 @@ static int osd_probe(struct device *dev)
 	}
 	disk->major = SCSI_OSD_MAJOR;
 	disk->first_minor = oud->minor;
-	sprintf(disk->disk_name, "osd%d", oud->minor);
+	sprintf(disk->disk_name, OSD_FMT_d, oud->minor);
 	oud->disk = disk;
 
 	/* hold one more reference to the scsi_device that will get released
@@ -335,18 +370,19 @@ static int osd_probe(struct device *dev)
 		OSD_ERR("cdev_add failed\n");
 		goto err_put_disk;
 	}
-	kobject_get(&oud->cdev.kobj); /* 2nd ref see osd_remove() */
 
 	/* class_member */
-	oud->class_member = device_create(osd_sysfs_class, dev,
-		MKDEV(SCSI_OSD_MAJOR, oud->minor), "%s", disk->disk_name);
+	oud->class_member = device_create(&osd_uld_class, dev,
+		MKDEV(SCSI_OSD_MAJOR, oud->minor), oud, disk->disk_name);
 	if (IS_ERR(oud->class_member)) {
 		OSD_ERR("class_device_create failed\n");
 		error = PTR_ERR(oud->class_member);
 		goto err_put_cdev;
 	}
+	oud->save_release = oud->class_member->release;
+	oud->class_member->release = __remove;
 
-	dev_set_drvdata(oud->class_member, oud);
+	__uld_get(oud);
 
 	OSD_INFO("osd_probe %s\n", disk->disk_name);
 	return 0;
@@ -376,51 +412,21 @@ static int osd_remove(struct device *dev)
 	}
 
 	if (oud->class_member)
-		device_destroy(osd_sysfs_class,
+		device_destroy(&osd_uld_class,
 			       MKDEV(SCSI_OSD_MAJOR, oud->minor));
 
-	/* We have 2 references to the cdev. One is released here
-	 * and also takes down the /dev/osdX mapping. The second
-	 * Will be released in __remove() after all users have released
-	 * the osd_uld_device.
-	 */
-	if (oud->cdev.owner)
-		cdev_del(&oud->cdev);
-
 	__uld_put(oud);
 	return 0;
 }
 
-static void __remove(struct kref *kref)
-{
-	struct osd_uld_device *oud = container_of(kref,
-					struct osd_uld_device, kref);
-	struct scsi_device *scsi_device = oud->od.scsi_device;
-
-	/* now let delete the char_dev */
-	kobject_put(&oud->cdev.kobj);
-
-	osd_dev_fini(&oud->od);
-	scsi_device_put(scsi_device);
-
-	OSD_INFO("osd_remove %s\n",
-		 oud->disk ? oud->disk->disk_name : NULL);
-
-	if (oud->disk)
-		put_disk(oud->disk);
-
-	ida_remove(&osd_minor_ida, oud->minor);
-	kfree(oud);
-}
-
 static void __uld_get(struct osd_uld_device *oud)
 {
-	kref_get(&oud->kref);
+	get_device(oud->class_member);
 }
 
 static void __uld_put(struct osd_uld_device *oud)
 {
-	kref_put(&oud->kref, __remove);
+	put_device(oud->class_member);
 }
 
 /*
@@ -440,11 +446,10 @@ static int __init osd_uld_init(void)
 {
 	int err;
 
-	osd_sysfs_class = class_create(THIS_MODULE, osd_symlink);
-	if (IS_ERR(osd_sysfs_class)) {
-		OSD_ERR("Unable to register sysfs class => %ld\n",
-			PTR_ERR(osd_sysfs_class));
-		return PTR_ERR(osd_sysfs_class);
+	err = class_register(&osd_uld_class);
+	if (err) {
+		OSD_ERR("Unable to register sysfs class => %d\n", err);
+		return err;
 	}
 
 	err = register_chrdev_region(MKDEV(SCSI_OSD_MAJOR, 0),
@@ -467,7 +472,7 @@ static int __init osd_uld_init(void)
 err_out_chrdev:
 	unregister_chrdev_region(MKDEV(SCSI_OSD_MAJOR, 0), SCSI_OSD_MAX_MINOR);
 err_out:
-	class_destroy(osd_sysfs_class);
+	class_unregister(&osd_uld_class);
 	return err;
 }
 
@@ -475,7 +480,7 @@ static void __exit osd_uld_exit(void)
 {
 	scsi_unregister_driver(&osd_driver.gendrv);
 	unregister_chrdev_region(MKDEV(SCSI_OSD_MAJOR, 0), SCSI_OSD_MAX_MINOR);
-	class_destroy(osd_sysfs_class);
+	class_unregister(&osd_uld_class);
 	OSD_INFO("UNLOADED %s\n", osd_version_string);
 }
 
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index f787d24..589e5f0 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -48,7 +48,6 @@ enum osd_std_version {
  */
 struct osd_dev {
 	struct scsi_device *scsi_device;
-	struct file *file;
 	unsigned def_timeout;
 
 #ifdef OSD_VER1_SUPPORT
-- 
1.6.5.1

