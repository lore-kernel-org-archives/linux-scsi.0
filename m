From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH][RFC] Sysfs class support for SCSI tapes for 2.6.2-bk1
Date: Thu, 5 Feb 2004 23:18:29 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402052237540.1072@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:40552 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S266870AbUBEVSb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2004 16:18:31 -0500
Received: from kai.makisara.local ([80.186.84.196])
          by fep02-app.kolumbus.fi with ESMTP
          id <20040205211829.DAHZ1464.fep02-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Thu, 5 Feb 2004 23:18:29 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The patch at the end of this message adds to st support for
/sys/class/scsi_tape. It also removes the links to/from the st files in 
/sys/cdev/major.

A file is created for each mode and rewind/non-rewind device for each 
tape drive. Here is an example for one drive:
> ls /sys/class/scsi_tape/
st0m0  st0m0n  st0m1  st0m1n  st0m2  st0m2n  st0m3  st0m3n

In addition to the automatic links (dev, driver), each directory contains 
files that export some of the mode parameters:
> ls /sys/class/scsi_tape/st0m0
default_blksize      default_density  dev     driver
default_compression  defined          device

A link is made from the SCSI device directory back to the mode 0 
auto-rewind class file:
> ls -l /sys/devices/pci0000:00/0000:00:1e.0/0000:02:01.1/host1/1:0:5:0/tape
lrwxrwxrwx    1 root     root           39 2004-02-05 23:14 
/sys/devices/pci0000:00/0000:00:1e.0/0000:02:01.1/host1/1:0:5:0/tape -> 
../../../../../../class/scsi_tape/st0m0

The patch is against 2.6.2-bk1.

-- 
Kai
---------------------------------8<--------------------------------------
--- linux-2.6.2-bk1/drivers/scsi/st.c	2004-02-05 20:57:19.000000000 +0200
+++ linux-2.6.2-bk1-k1/drivers/scsi/st.c	2004-02-05 23:06:52.000000000 +0200
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20040122";
+static char *verstr = "20040205";
 
 #include <linux/module.h>
 
@@ -77,6 +77,8 @@
 static int st_dev_max;
 static int st_nr_dev;
 
+static struct class_simple *st_sysfs_class;
+
 MODULE_AUTHOR("Kai Makisara");
 MODULE_DESCRIPTION("SCSI Tape Driver");
 MODULE_LICENSE("GPL");
@@ -183,7 +185,7 @@
 
 static void do_create_driverfs_files(void);
 static void do_remove_driverfs_files(void);
-
+static void do_create_class_files(Scsi_Tape *, int, int);
 
 static struct scsi_driver st_template = {
 	.owner			= THIS_MODULE,
@@ -3902,20 +3904,8 @@
 			}
 			STm->cdevs[j] = cdev;
 
-			error = sysfs_create_link(&STm->cdevs[j]->kobj, &SDp->sdev_gendev.kobj,
-						  "device");
-			if (error) {
-				printk(KERN_ERR
-				       "st%d: Can't create sysfs link from SCSI device.\n",
-				       dev_num);
-			}
 		}
-	}
-	error = sysfs_create_link(&SDp->sdev_gendev.kobj, &tpnt->modes[0].cdevs[0]->kobj,
-				  "tape");
-	if (error) {
-		printk(KERN_ERR "st%d: Can't create sysfs link from SCSI device.\n",
-		       dev_num);
+		do_create_class_files(tpnt, dev_num, mode);
 	}
 
 	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
@@ -3941,11 +3931,14 @@
 out_free_tape:
 	for (mode=0; mode < ST_NBR_MODES; mode++) {
 		STm = &(tpnt->modes[mode]);
+		sysfs_remove_link(&tpnt->device->sdev_gendev.kobj,
+				  "tape");
 		for (j=0; j < 2; j++) {
 			if (STm->cdevs[j]) {
 				if (cdev == STm->cdevs[j])
 					cdev = NULL;
-				sysfs_remove_link(&STm->cdevs[j]->kobj, "device");
+				class_simple_device_remove(MKDEV(SCSI_TAPE_MAJOR,
+								 TAPE_MINOR(i, mode, j)));
 				cdev_unmap(MKDEV(SCSI_TAPE_MAJOR,
 						 TAPE_MINOR(dev_num, mode, j)), 1);
 				cdev_del(STm->cdevs[j]);
@@ -3983,13 +3976,14 @@
 			st_nr_dev--;
 			write_unlock(&st_dev_arr_lock);
 			devfs_unregister_tape(tpnt->disk->number);
-			sysfs_remove_link(&SDp->sdev_gendev.kobj, "tape");
+			sysfs_remove_link(&tpnt->device->sdev_gendev.kobj,
+					  "tape");
 			for (mode = 0; mode < ST_NBR_MODES; ++mode) {
 				devfs_remove("%s/mt%s", SDp->devfs_name, st_formats[mode]);
 				devfs_remove("%s/mt%sn", SDp->devfs_name, st_formats[mode]);
 				for (j=0; j < 2; j++) {
-					sysfs_remove_link(&tpnt->modes[mode].cdevs[j]->kobj,
-							  "device");
+					class_simple_device_remove(MKDEV(SCSI_TAPE_MAJOR,
+									 TAPE_MINOR(i, mode, j)));
 					cdev_unmap(MKDEV(SCSI_TAPE_MAJOR,
 							 TAPE_MINOR(i, mode, j)), 1);
 					cdev_del(tpnt->modes[mode].cdevs[j]);
@@ -4056,13 +4050,23 @@
 		"st: Version %s, fixed bufsize %d, s/g segs %d\n",
 		verstr, st_fixed_buffer_size, st_max_sg_segs);
 
+	st_sysfs_class = class_simple_create(THIS_MODULE, "scsi_tape");
+	if (IS_ERR(st_sysfs_class)) {
+		st_sysfs_class = NULL;
+		printk(KERN_ERR "Unable create sysfs class for SCSI tapes\n");
+		return 1;
+	}
+
 	if (!register_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
 				    ST_MAX_TAPE_ENTRIES, "st")) {
 		if (scsi_register_driver(&st_template.gendrv) == 0) {
 			do_create_driverfs_files();
 			return 0;
 		}
+		if (st_sysfs_class)
+			class_simple_destroy(st_sysfs_class);		
 		unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
+
 					 ST_MAX_TAPE_ENTRIES);
 	}
 
@@ -4072,6 +4076,9 @@
 
 static void __exit exit_st(void)
 {
+	if (st_sysfs_class)
+		class_simple_destroy(st_sysfs_class);
+	st_sysfs_class = NULL;
 	do_remove_driverfs_files();
 	scsi_unregister_driver(&st_template.gendrv);
 	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
@@ -4084,7 +4091,7 @@
 module_exit(exit_st);
 
 
-/* The sysfs interface. Read-only at the moment */
+/* The sysfs driver interface. Read-only at the moment */
 static ssize_t st_try_direct_io_show(struct device_driver *ddp, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", try_direct_io);
@@ -4130,6 +4137,99 @@
 }
 
 
+/* The sysfs simple class interface */
+static ssize_t st_defined_show(struct class_device *class_dev, char *buf)
+{
+	ST_mode *STm = (ST_mode *)class_get_devdata(class_dev);
+	ssize_t l = 0;
+
+	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->defined);
+	return l;
+}
+
+CLASS_DEVICE_ATTR(defined, S_IRUGO, st_defined_show, NULL);
+
+static ssize_t st_defblk_show(struct class_device *class_dev, char *buf)
+{
+	ST_mode *STm = (ST_mode *)class_get_devdata(class_dev);
+	ssize_t l = 0;
+
+	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->default_blksize);
+	return l;
+}
+
+CLASS_DEVICE_ATTR(default_blksize, S_IRUGO, st_defblk_show, NULL);
+
+static ssize_t st_defdensity_show(struct class_device *class_dev, char *buf)
+{
+	ST_mode *STm = (ST_mode *)class_get_devdata(class_dev);
+	ssize_t l = 0;
+	char *fmt;
+
+	fmt = STm->default_density >= 0 ? "0x%02x\n" : "%d\n";
+	l = snprintf(buf, PAGE_SIZE, fmt, STm->default_density);
+	return l;
+}
+
+CLASS_DEVICE_ATTR(default_density, S_IRUGO, st_defdensity_show, NULL);
+
+static ssize_t st_defcompression_show(struct class_device *class_dev, char *buf)
+{
+	ST_mode *STm = (ST_mode *)class_get_devdata(class_dev);
+	ssize_t l = 0;
+
+	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->default_compression - 1);
+	return l;
+}
+
+CLASS_DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show, NULL);
+
+static void do_create_class_files(Scsi_Tape *STp, int dev_num, int mode)
+{
+	int rew, error;
+	struct class_device *st_class_member;
+
+	if (!st_sysfs_class)
+		return;
+
+	for (rew=0; rew < 2; rew++) {
+		st_class_member =
+			class_simple_device_add(st_sysfs_class,
+						MKDEV(SCSI_TAPE_MAJOR,
+						      TAPE_MINOR(dev_num, mode, rew)),
+						&STp->device->sdev_gendev, "%s",
+						STp->modes[mode].cdevs[rew]->kobj.name);
+		if (!st_class_member) {
+			printk(KERN_WARNING "st%d: class_simple_device_add failed\n",
+			       dev_num);
+			goto out;
+		}
+		class_set_devdata(st_class_member, &STp->modes[mode]);
+
+		class_device_create_file(st_class_member,
+					 &class_device_attr_defined);
+		class_device_create_file(st_class_member,
+					 &class_device_attr_default_blksize);
+		class_device_create_file(st_class_member,
+					 &class_device_attr_default_density);
+		class_device_create_file(st_class_member,
+					 &class_device_attr_default_compression);
+		if (mode == 0 && rew == 0) {
+			error = sysfs_create_link(&STp->device->sdev_gendev.kobj,
+						  &st_class_member->kobj,
+						  "tape");
+			if (error) {
+				printk(KERN_ERR
+				       "st%d: Can't create sysfs link from SCSI device.\n",
+				       dev_num);
+			}
+		}
+	}
+ out:
+	return;
+}
+
+
 /* Pin down user pages and put them into a scatter gather list. Returns <= 0 if
    - mapping of all pages not successful
    - any page is above max_pfn
