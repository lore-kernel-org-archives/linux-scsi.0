From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 1/5] st: Use static class attributes
Date: Wed, 16 May 2012 20:56:13 -0700
Message-ID: <4FB476DD.4020107@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kai.makisara@kolumbus.fi, jeffm@suse.com
List-Id: linux-scsi@vger.kernel.org

st currently sets up and tears down class attributes manually for
every tape drive in the system. This patch uses a statically defined
class with class attributes to let the device core do it for us.

Signed-off-by: Lee Duncan <lduncan@suse.de>
---
 drivers/scsi/st.c |   74 ++++++++++++++++++++++++-----------------------------
 1 file changed, 33 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e41998c..532543c 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -84,7 +84,8 @@ static int try_wdio = 1;
 static int st_dev_max;
 static int st_nr_dev;
 
-static struct class *st_sysfs_class;
+extern struct class st_sysfs_class;
+extern struct device_attribute st_dev_attrs[];
 
 MODULE_AUTHOR("Kai Makisara");
 MODULE_DESCRIPTION("SCSI tape (st) driver");
@@ -4195,7 +4196,7 @@ out_free_tape:
 			if (STm->cdevs[j]) {
 				if (cdev == STm->cdevs[j])
 					cdev = NULL;
-					device_destroy(st_sysfs_class,
+					device_destroy(&st_sysfs_class,
 						       MKDEV(SCSI_TAPE_MAJOR,
 							     TAPE_MINOR(i, mode, j)));
 				cdev_del(STm->cdevs[j]);
@@ -4236,7 +4237,7 @@ static int st_remove(struct device *dev)
 					  "tape");
 			for (mode = 0; mode < ST_NBR_MODES; ++mode) {
 				for (j=0; j < 2; j++) {
-					device_destroy(st_sysfs_class,
+					device_destroy(&st_sysfs_class,
 						       MKDEV(SCSI_TAPE_MAJOR,
 							     TAPE_MINOR(i, mode, j)));
 					cdev_del(tpnt->modes[mode].cdevs[j]);
@@ -4283,6 +4284,11 @@ static void scsi_tape_release(struct kref *kref)
 	return;
 }
 
+struct class st_sysfs_class = {
+	.name = "scsi_tape",
+	.dev_attrs = st_dev_attrs,
+};
+
 static int __init init_st(void)
 {
 	int err;
@@ -4292,10 +4298,10 @@ static int __init init_st(void)
 	printk(KERN_INFO "st: Version %s, fixed bufsize %d, s/g segs %d\n",
 		verstr, st_fixed_buffer_size, st_max_sg_segs);
 
-	st_sysfs_class = class_create(THIS_MODULE, "scsi_tape");
-	if (IS_ERR(st_sysfs_class)) {
-		printk(KERN_ERR "Unable create sysfs class for SCSI tapes\n");
-		return PTR_ERR(st_sysfs_class);
+	err = class_register(&st_sysfs_class);
+	if (err) {
+		printk(KERN_ERR "Unable register sysfs class for SCSI tapes\n");
+		return err;
 	}
 
 	err = register_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
@@ -4322,7 +4328,7 @@ err_chrdev:
 	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
 				 ST_MAX_TAPE_ENTRIES);
 err_class:
-	class_destroy(st_sysfs_class);
+	class_unregister(&st_sysfs_class);
 	return err;
 }
 
@@ -4332,7 +4338,7 @@ static void __exit exit_st(void)
 	scsi_unregister_driver(&st_template.gendrv);
 	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
 				 ST_MAX_TAPE_ENTRIES);
-	class_destroy(st_sysfs_class);
+	class_unregister(&st_sysfs_class);
 	kfree(scsi_tapes);
 	printk(KERN_INFO "st: Unloaded.\n");
 }
@@ -4405,10 +4411,9 @@ static void do_remove_sysfs_files(void)
 	driver_remove_file(sysfs, &driver_attr_try_direct_io);
 }
 
-
 /* The sysfs simple class interface */
 static ssize_t
-st_defined_show(struct device *dev, struct device_attribute *attr, char *buf)
+defined_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct st_modedef *STm = dev_get_drvdata(dev);
 	ssize_t l = 0;
@@ -4417,10 +4422,9 @@ st_defined_show(struct device *dev, struct device_attribute *attr, char *buf)
 	return l;
 }
 
-DEVICE_ATTR(defined, S_IRUGO, st_defined_show, NULL);
-
 static ssize_t
-st_defblk_show(struct device *dev, struct device_attribute *attr, char *buf)
+default_blksize_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
 {
 	struct st_modedef *STm = dev_get_drvdata(dev);
 	ssize_t l = 0;
@@ -4429,10 +4433,10 @@ st_defblk_show(struct device *dev, struct device_attribute *attr, char *buf)
 	return l;
 }
 
-DEVICE_ATTR(default_blksize, S_IRUGO, st_defblk_show, NULL);
 
 static ssize_t
-st_defdensity_show(struct device *dev, struct device_attribute *attr, char *buf)
+default_density_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
 {
 	struct st_modedef *STm = dev_get_drvdata(dev);
 	ssize_t l = 0;
@@ -4443,11 +4447,9 @@ st_defdensity_show(struct device *dev, struct device_attribute *attr, char *buf)
 	return l;
 }
 
-DEVICE_ATTR(default_density, S_IRUGO, st_defdensity_show, NULL);
-
 static ssize_t
-st_defcompression_show(struct device *dev, struct device_attribute *attr,
-		       char *buf)
+default_compression_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	struct st_modedef *STm = dev_get_drvdata(dev);
 	ssize_t l = 0;
@@ -4456,10 +4458,8 @@ st_defcompression_show(struct device *dev, struct device_attribute *attr,
 	return l;
 }
 
-DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show, NULL);
-
 static ssize_t
-st_options_show(struct device *dev, struct device_attribute *attr, char *buf)
+options_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct st_modedef *STm = dev_get_drvdata(dev);
 	struct scsi_tape *STp;
@@ -4498,7 +4498,14 @@ st_options_show(struct device *dev, struct device_attribute *attr, char *buf)
 	return l;
 }
 
-DEVICE_ATTR(options, S_IRUGO, st_options_show, NULL);
+struct device_attribute st_dev_attrs[] = {
+	__ATTR_RO(defined),
+	__ATTR_RO(default_blksize),
+	__ATTR_RO(default_density),
+	__ATTR_RO(default_compression),
+	__ATTR_RO(options),
+	__ATTR_NULL,
+};
 
 static int do_create_class_files(struct scsi_tape *STp, int dev_num, int mode)
 {
@@ -4513,7 +4520,8 @@ static int do_create_class_files(struct scsi_tape *STp, int dev_num, int mode)
 		snprintf(name, 10, "%s%s%s", rew ? "n" : "",
 			 STp->disk->disk_name, st_formats[i]);
 		st_class_member =
-			device_create(st_sysfs_class, &STp->device->sdev_gendev,
+			device_create(&st_sysfs_class,
+				      &STp->device->sdev_gendev,
 				      MKDEV(SCSI_TAPE_MAJOR,
 					    TAPE_MINOR(dev_num, mode, rew)),
 				      &STp->modes[mode], "%s", name);
@@ -4524,22 +4532,6 @@ static int do_create_class_files(struct scsi_tape *STp, int dev_num, int mode)
 			goto out;
 		}
 
-		error = device_create_file(st_class_member,
-					   &dev_attr_defined);
-		if (error) goto out;
-		error = device_create_file(st_class_member,
-					   &dev_attr_default_blksize);
-		if (error) goto out;
-		error = device_create_file(st_class_member,
-					   &dev_attr_default_density);
-		if (error) goto out;
-		error = device_create_file(st_class_member,
-					   &dev_attr_default_compression);
-		if (error) goto out;
-		error = device_create_file(st_class_member,
-					   &dev_attr_options);
-		if (error) goto out;
-
 		if (mode == 0 && rew == 0) {
 			error = sysfs_create_link(&STp->device->sdev_gendev.kobj,
 						  &st_class_member->kobj,
-- 
1.7.9.2
