From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] Sysfs class support for SCSI tapes
Date: Sun, 22 Feb 2004 15:10:10 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402221453540.1710@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep19-0.kolumbus.fi ([193.229.0.45]:5047 "EHLO
	fep19-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261242AbUBVNKM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2004 08:10:12 -0500
Received: from kai.makisara.local ([80.186.89.113])
          by fep19-app.kolumbus.fi with ESMTP
          id <20040222131010.LINV23318.fep19-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Sun, 22 Feb 2004 15:10:10 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a new version of the patch I sent two weeks ago. The code is th=
e=20
same but now diffed against 2.6.3. Some documentation has been added.=20
Creation and removal of the st device files has been tested with =20
udev-018.

The patch adds support for /sys/class/scsi_tape. It also removes the li=
nks=20
to/from the st files in /sys/cdev/major.

A file is created for each mode and rewind/non-rewind device for each=20
tape drive. Here is an example for one drive:
> ls /sys/class/scsi_tape/
st0m0  st0m0n  st0m1  st0m1n  st0m2  st0m2n  st0m3  st0m3n

In addition to the automatic links (dev, driver), each directory contai=
ns=20
files that export some of the mode parameters:
> ls /sys/class/scsi_tape/st0m0
default_blksize      default_density  dev     driver
default_compression  defined          device

A link is made from the SCSI device directory back to the mode 0=20
auto-rewind class file:
> ls -l=20
/sys/devices/pci0000:00/0000:00:1e.0/0000:02:01.1/host1/1:0:5:0/tape
lrwxrwxrwx    1 root     root           39 2004-02-05 23:14=20
/sys/devices/pci0000:00/0000:00:1e.0/0000:02:01.1/host1/1:0:5:0/tape ->=
=20
=2E./../../../../../class/scsi_tape/st0m0

--=20
Kai
-------------------------------------8<--------------------------------=
---
--- linux-2.6.3/drivers/scsi/st.c	2004-02-18 17:40:54.000000000 +0200
+++ linux-2.6.3-k1/drivers/scsi/st.c	2004-02-18 17:58:54.000000000 +020=
0
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Dev=
fs support
  */
=20
-static char *verstr =3D "20040122";
+static char *verstr =3D "20040213";
=20
 #include <linux/module.h>
=20
@@ -77,6 +77,8 @@
 static int st_dev_max;
 static int st_nr_dev;
=20
+static struct class_simple *st_sysfs_class;
+
 MODULE_AUTHOR("Kai Makisara");
 MODULE_DESCRIPTION("SCSI Tape Driver");
 MODULE_LICENSE("GPL");
@@ -183,7 +185,7 @@
=20
 static void do_create_driverfs_files(void);
 static void do_remove_driverfs_files(void);
-
+static void do_create_class_files(Scsi_Tape *, int, int);
=20
 static struct scsi_driver st_template =3D {
 	.owner			=3D THIS_MODULE,
@@ -3902,20 +3904,8 @@
 			}
 			STm->cdevs[j] =3D cdev;
=20
-			error =3D sysfs_create_link(&STm->cdevs[j]->kobj, &SDp->sdev_gendev=
=2Ekobj,
-						  "device");
-			if (error) {
-				printk(KERN_ERR
-				       "st%d: Can't create sysfs link from SCSI device.\n",
-				       dev_num);
-			}
 		}
-	}
-	error =3D sysfs_create_link(&SDp->sdev_gendev.kobj, &tpnt->modes[0].c=
devs[0]->kobj,
-				  "tape");
-	if (error) {
-		printk(KERN_ERR "st%d: Can't create sysfs link from SCSI device.\n",
-		       dev_num);
+		do_create_class_files(tpnt, dev_num, mode);
 	}
=20
 	for (mode =3D 0; mode < ST_NBR_MODES; ++mode) {
@@ -3941,11 +3931,14 @@
 out_free_tape:
 	for (mode=3D0; mode < ST_NBR_MODES; mode++) {
 		STm =3D &(tpnt->modes[mode]);
+		sysfs_remove_link(&tpnt->device->sdev_gendev.kobj,
+				  "tape");
 		for (j=3D0; j < 2; j++) {
 			if (STm->cdevs[j]) {
 				if (cdev =3D=3D STm->cdevs[j])
 					cdev =3D NULL;
-				sysfs_remove_link(&STm->cdevs[j]->kobj, "device");
+				class_simple_device_remove(MKDEV(SCSI_TAPE_MAJOR,
+								 TAPE_MINOR(i, mode, j)));
 				cdev_del(STm->cdevs[j]);
 			}
 		}
@@ -3981,13 +3974,14 @@
 			st_nr_dev--;
 			write_unlock(&st_dev_arr_lock);
 			devfs_unregister_tape(tpnt->disk->number);
-			sysfs_remove_link(&SDp->sdev_gendev.kobj, "tape");
+			sysfs_remove_link(&tpnt->device->sdev_gendev.kobj,
+					  "tape");
 			for (mode =3D 0; mode < ST_NBR_MODES; ++mode) {
 				devfs_remove("%s/mt%s", SDp->devfs_name, st_formats[mode]);
 				devfs_remove("%s/mt%sn", SDp->devfs_name, st_formats[mode]);
 				for (j=3D0; j < 2; j++) {
-					sysfs_remove_link(&tpnt->modes[mode].cdevs[j]->kobj,
-							  "device");
+					class_simple_device_remove(MKDEV(SCSI_TAPE_MAJOR,
+									 TAPE_MINOR(i, mode, j)));
 					cdev_del(tpnt->modes[mode].cdevs[j]);
 					tpnt->modes[mode].cdevs[j] =3D NULL;
 				}
@@ -4052,13 +4046,23 @@
 		"st: Version %s, fixed bufsize %d, s/g segs %d\n",
 		verstr, st_fixed_buffer_size, st_max_sg_segs);
=20
+	st_sysfs_class =3D class_simple_create(THIS_MODULE, "scsi_tape");
+	if (IS_ERR(st_sysfs_class)) {
+		st_sysfs_class =3D NULL;
+		printk(KERN_ERR "Unable create sysfs class for SCSI tapes\n");
+		return 1;
+	}
+
 	if (!register_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
 				    ST_MAX_TAPE_ENTRIES, "st")) {
 		if (scsi_register_driver(&st_template.gendrv) =3D=3D 0) {
 			do_create_driverfs_files();
 			return 0;
 		}
+		if (st_sysfs_class)
+			class_simple_destroy(st_sysfs_class);	=09
 		unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
+
 					 ST_MAX_TAPE_ENTRIES);
 	}
=20
@@ -4068,6 +4072,9 @@
=20
 static void __exit exit_st(void)
 {
+	if (st_sysfs_class)
+		class_simple_destroy(st_sysfs_class);
+	st_sysfs_class =3D NULL;
 	do_remove_driverfs_files();
 	scsi_unregister_driver(&st_template.gendrv);
 	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
@@ -4080,7 +4087,7 @@
 module_exit(exit_st);
=20
=20
-/* The sysfs interface. Read-only at the moment */
+/* The sysfs driver interface. Read-only at the moment */
 static ssize_t st_try_direct_io_show(struct device_driver *ddp, char *=
buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", try_direct_io);
@@ -4126,6 +4133,99 @@
 }
=20
=20
+/* The sysfs simple class interface */
+static ssize_t st_defined_show(struct class_device *class_dev, char *b=
uf)
+{
+	ST_mode *STm =3D (ST_mode *)class_get_devdata(class_dev);
+	ssize_t l =3D 0;
+
+	l =3D snprintf(buf, PAGE_SIZE, "%d\n", STm->defined);
+	return l;
+}
+
+CLASS_DEVICE_ATTR(defined, S_IRUGO, st_defined_show, NULL);
+
+static ssize_t st_defblk_show(struct class_device *class_dev, char *bu=
f)
+{
+	ST_mode *STm =3D (ST_mode *)class_get_devdata(class_dev);
+	ssize_t l =3D 0;
+
+	l =3D snprintf(buf, PAGE_SIZE, "%d\n", STm->default_blksize);
+	return l;
+}
+
+CLASS_DEVICE_ATTR(default_blksize, S_IRUGO, st_defblk_show, NULL);
+
+static ssize_t st_defdensity_show(struct class_device *class_dev, char=
 *buf)
+{
+	ST_mode *STm =3D (ST_mode *)class_get_devdata(class_dev);
+	ssize_t l =3D 0;
+	char *fmt;
+
+	fmt =3D STm->default_density >=3D 0 ? "0x%02x\n" : "%d\n";
+	l =3D snprintf(buf, PAGE_SIZE, fmt, STm->default_density);
+	return l;
+}
+
+CLASS_DEVICE_ATTR(default_density, S_IRUGO, st_defdensity_show, NULL);
+
+static ssize_t st_defcompression_show(struct class_device *class_dev, =
char *buf)
+{
+	ST_mode *STm =3D (ST_mode *)class_get_devdata(class_dev);
+	ssize_t l =3D 0;
+
+	l =3D snprintf(buf, PAGE_SIZE, "%d\n", STm->default_compression - 1);
+	return l;
+}
+
+CLASS_DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show=
, NULL);
+
+static void do_create_class_files(Scsi_Tape *STp, int dev_num, int mod=
e)
+{
+	int rew, error;
+	struct class_device *st_class_member;
+
+	if (!st_sysfs_class)
+		return;
+
+	for (rew=3D0; rew < 2; rew++) {
+		st_class_member =3D
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
+		if (mode =3D=3D 0 && rew =3D=3D 0) {
+			error =3D sysfs_create_link(&STp->device->sdev_gendev.kobj,
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
 /* Pin down user pages and put them into a scatter gather list. Return=
s <=3D 0 if
    - mapping of all pages not successful
    - any page is above max_pfn
--- linux-2.6.3/Documentation/scsi/st.txt	2004-01-09 21:52:33.000000000=
 +0200
+++ linux-2.6.3-k1/Documentation/scsi/st.txt	2004-02-19 21:57:30.000000=
000 +0200
@@ -2,7 +2,7 @@
 The driver is currently maintained by Kai M=E4kisara (email
 Kai.Makisara@kolumbus.fi)
=20
-Last modified: Sun Nov  9 22:36:02 2003 by makisara
+Last modified: Thu Feb 19 21:57:30 2004 by makisara
=20
=20
 BASICS
@@ -113,6 +113,26 @@
 only 8 bits wide.
=20
=20
+SYSFS SUPPORT
+
+The driver creates the directory /sys/class/scsi_tape and populates it=
 with
+directories corresponding to the existing tape devices. There are auto=
rewind
+and non-rewind entries for each mode. The names are stxmy and stxmyn, =
where x
+is the tape number and y is the mode. For example, the directories for=
 the
+first tape device are (assuming four modes): st0m0  st0m0n  st0m1  st0=
m1n
+st0m2  st0m2n  st0m3  st0m3n.
+
+Each directory contains the entries: default_blksize  default_compress=
ion
+default_density  defined  dev  device  driver. The file 'defined' cont=
ains 1
+if the mode is defined and zero if not defined. The files 'default_*' =
contain
+the defaults set by the user. The value -1 means the default is not se=
t. The
+file 'dev' contains the device numbers corresponding to this device. T=
he links
+'device' and 'driver' point to the SCSI device and driver entries.
+
+A link named 'tape' is made from the SCSI device directory to the clas=
s
+directory corresponding to the mode 0 auto-rewind device (e.g., st0m0)=
=2E=20
+
+
 BSD AND SYS V SEMANTICS
=20
 The user can choose between these two behaviours of the tape driver by
@@ -126,7 +146,7 @@
=20
 BUFFERING
=20
-The driver tries to do tranfers directly to/from user space. If this
+The driver tries to do transfers directly to/from user space. If this
 is not possible, a driver buffer allocated at run-time is used. If
 direct i/o is not possible for the whole transfer, the driver buffer
 is used (i.e., bounce buffers for individual pages are not
@@ -147,6 +167,12 @@
 size). Because of this the actual buffer size may be larger than the
 minimum allowable buffer size.
=20
+NOTE that if direct i/o is used, the small writes are not buffered. Th=
is may
+cause a surprise when moving from 2.4. There small writes (e.g., tar w=
ithout
+-b option) may have had good throughput but this is not true any more =
with
+2.6. Direct i/o can be turned off to solve this problem but a better s=
olution
+is to use bigger write() byte counts (e.g., tar -b 64).
+
 Asynchronous writing. Writing the buffer contents to the tape is
 started and the write call returns immediately. The status is checked
 at the next tape operation. Asynchronous writes are not done with
@@ -453,7 +479,7 @@
=20
 To enable debugging messages, edit st.c and #define DEBUG 1. As seen
 above, debugging can be switched off with an ioctl if debugging is
-compiled into the driver. The debugging output is not voluminuous.
+compiled into the driver. The debugging output is not voluminous.
=20
 If the tape seems to hang, I would be very interested to hear where
 the driver is waiting. With the command 'ps -l' you can see the state
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
