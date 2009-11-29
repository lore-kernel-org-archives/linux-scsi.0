From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/2] osduld: Use device->release instead of internal kref
Date: Sun, 29 Nov 2009 16:25:26 +0200
Message-ID: <4B128456.10707@panasas.com>
References: <20091127143229.108298c6.sfr@canb.auug.org.au>		<4B123A82.10104@panasas.com> <4B127202.1010900@panasas.com>	<1259502399.2827.14.camel@mulgrave.site> <4B1283C9.1030002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:39055 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752179AbZK2OZW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2009 09:25:22 -0500
In-Reply-To: <4B1283C9.1030002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>


The true logic of this patch will be clear in the next patch where we
use the class_find_device() API. When doing so the use of an internal
kref leaves us a narrow window where a find is started while the actual
object can go away. Using the device's kobj reference solves this
problem because now the same kref is used for both operations. (Remove
and find)

Core changes
* Embed a struct device in uld_ structure and use device_register
  instead of devie_create. Set __remove to be the device release
  function.
* __uld_get/put is just get_/put_device. Now every thing is accounted
  for on the device object. Internal kref is removed.
* At __remove() we can safely de-allocate the uld_ structure. (The
  function has moved to avoid forward declaration)

Some cleanups
* Use class register/unregister is cleaner for this driver now.
* cdev ref-counting games are no longer necessary

I have incremented the device version string in case of new bugs.

Note: Previous bugfix of taking the reference around fput() still
      applies.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_uld.c   |  162 ++++++++++++++++++++----------------------
 include/scsi/osd_initiator.h |    1 -
 2 files changed, 77 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 1ea6447..fc6fc1c 100644
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
@@ -82,15 +81,24 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_OSD);
 
 struct osd_uld_device {
 	int minor;
-	struct kref kref;
+	struct device class_dev;
 	struct cdev cdev;
 	struct osd_dev od;
 	struct gendisk *disk;
-	struct device *class_member;
 };
 
-static void __uld_get(struct osd_uld_device *oud);
-static void __uld_put(struct osd_uld_device *oud);
+struct osd_dev_handle {
+	struct osd_dev od;
+	struct file *file;
+	struct osd_uld_device *oud;
+} ;
+
+static DEFINE_IDA(osd_minor_ida);
+
+static struct class osd_uld_class = {
+	.owner		= THIS_MODULE,
+	.name		= "scsi_osd",
+};
 
 /*
  * Char Device operations
@@ -101,7 +109,7 @@ static int osd_uld_open(struct inode *inode, struct file *file)
 	struct osd_uld_device *oud = container_of(inode->i_cdev,
 					struct osd_uld_device, cdev);
 
-	__uld_get(oud);
+	get_device(&oud->class_dev);
 	/* cache osd_uld_device on file handle */
 	file->private_data = oud;
 	OSD_DEBUG("osd_uld_open %p\n", oud);
@@ -114,7 +122,7 @@ static int osd_uld_release(struct inode *inode, struct file *file)
 
 	OSD_DEBUG("osd_uld_release %p\n", file->private_data);
 	file->private_data = NULL;
-	__uld_put(oud);
+	put_device(&oud->class_dev);
 	return 0;
 }
 
@@ -177,7 +185,7 @@ static const struct file_operations osd_fops = {
 struct osd_dev *osduld_path_lookup(const char *name)
 {
 	struct osd_uld_device *oud;
-	struct osd_dev *od;
+	struct osd_dev_handle *odh;
 	struct file *file;
 	int error;
 
@@ -186,8 +194,8 @@ struct osd_dev *osduld_path_lookup(const char *name)
 		return ERR_PTR(-EINVAL);
 	}
 
-	od = kzalloc(sizeof(*od), GFP_KERNEL);
-	if (!od)
+	odh = kzalloc(sizeof(*odh), GFP_KERNEL);
+	if (unlikely(!odh))
 		return ERR_PTR(-ENOMEM);
 
 	file = filp_open(name, O_RDWR, 0);
@@ -203,37 +211,39 @@ struct osd_dev *osduld_path_lookup(const char *name)
 
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
 
 		/* If scsi has released the device (logout), and exofs has last
 		 * reference on oud it will be freed by above osd_uld_release
 		 * within fput below. But this will oops in cdev_release which
-		 * is called after the fops->release. __uld_get/put pair makes
+		 * is called after the fops->release. A get_/put_ pair makes
 		 * sure we have a cdev for the duration of fput
 		 */
-		__uld_get(oud);
-		fput(od->file);
-		__uld_put(oud);
-		kfree(od);
+		get_device(&oud->class_dev);
+		fput(odh->file);
+		put_device(&oud->class_dev);
+		kfree(odh);
 	}
 }
 EXPORT_SYMBOL(osduld_put_device);
@@ -264,8 +274,27 @@ static int __detect_osd(struct osd_uld_device *oud)
 	return 0;
 }
 
-static struct class *osd_sysfs_class;
-static DEFINE_IDA(osd_minor_ida);
+static void __remove(struct device *dev)
+{
+	struct osd_uld_device *oud = container_of(dev, struct osd_uld_device,
+						  class_dev);
+	struct scsi_device *scsi_device = oud->od.scsi_device;
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
@@ -297,7 +326,6 @@ static int osd_probe(struct device *dev)
 	if (NULL == oud)
 		goto err_retract_minor;
 
-	kref_init(&oud->kref);
 	dev_set_drvdata(dev, oud);
 	oud->minor = minor;
 
@@ -335,18 +363,25 @@ static int osd_probe(struct device *dev)
 		OSD_ERR("cdev_add failed\n");
 		goto err_put_disk;
 	}
-	kobject_get(&oud->cdev.kobj); /* 2nd ref see osd_remove() */
-
-	/* class_member */
-	oud->class_member = device_create(osd_sysfs_class, dev,
-		MKDEV(SCSI_OSD_MAJOR, oud->minor), "%s", disk->disk_name);
-	if (IS_ERR(oud->class_member)) {
-		OSD_ERR("class_device_create failed\n");
-		error = PTR_ERR(oud->class_member);
+
+	/* class device member */
+	oud->class_dev.devt = oud->cdev.dev;
+	oud->class_dev.class = &osd_uld_class;
+	oud->class_dev.parent = dev;
+	oud->class_dev.release = __remove;
+	error = dev_set_name(&oud->class_dev, disk->disk_name);
+	if (error) {
+		OSD_ERR("dev_set_name failed => %d\n", error);
 		goto err_put_cdev;
 	}
 
-	dev_set_drvdata(oud->class_member, oud);
+	error = device_register(&oud->class_dev);
+	if (error) {
+		OSD_ERR("device_register failed => %d\n", error);
+		goto err_put_cdev;
+	}
+
+	get_device(&oud->class_dev);
 
 	OSD_INFO("osd_probe %s\n", disk->disk_name);
 	return 0;
@@ -375,54 +410,12 @@ static int osd_remove(struct device *dev)
 			scsi_device);
 	}
 
-	if (oud->class_member)
-		device_destroy(osd_sysfs_class,
-			       MKDEV(SCSI_OSD_MAJOR, oud->minor));
-
-	/* We have 2 references to the cdev. One is released here
-	 * and also takes down the /dev/osdX mapping. The second
-	 * Will be released in __remove() after all users have released
-	 * the osd_uld_device.
-	 */
-	if (oud->cdev.owner)
-		cdev_del(&oud->cdev);
+	device_unregister(&oud->class_dev);
 
-	__uld_put(oud);
+	put_device(&oud->class_dev);
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
-static void __uld_get(struct osd_uld_device *oud)
-{
-	kref_get(&oud->kref);
-}
-
-static void __uld_put(struct osd_uld_device *oud)
-{
-	kref_put(&oud->kref, __remove);
-}
-
 /*
  * Global driver and scsi registration
  */
@@ -440,11 +433,10 @@ static int __init osd_uld_init(void)
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
@@ -467,7 +459,7 @@ static int __init osd_uld_init(void)
 err_out_chrdev:
 	unregister_chrdev_region(MKDEV(SCSI_OSD_MAJOR, 0), SCSI_OSD_MAX_MINOR);
 err_out:
-	class_destroy(osd_sysfs_class);
+	class_unregister(&osd_uld_class);
 	return err;
 }
 
@@ -475,7 +467,7 @@ static void __exit osd_uld_exit(void)
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
1.6.5.2


