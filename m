From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI tape sysfs name fixes
Date: Wed, 25 Feb 2004 18:51:40 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402251842570.1756@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep22-0.kolumbus.fi ([193.229.0.60]:9460 "EHLO
	fep22-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261405AbUBYQvo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 11:51:44 -0500
Received: from kai.makisara.local ([80.186.197.216])
          by fep22-app.kolumbus.fi with ESMTP
          id <20040225165142.MGGM3524.fep22-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2004 18:51:42 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The patch at the end of this message contains the following changes and=
=20
fixes:

- The sysfs directory names are changed from stxmy[n] to the names in=20
  devices.txt. Below is an example for the first tape drive:
  /sys/class/scsi_tape/
  |-- nst0
  |-- nst0a
  |-- nst0l
  |-- nst0m
  |-- st0
  |-- st0a
  |-- st0l
  `-- st0m

- Name generation for non-default number of modes fixed so that same=20
  minors get same names even with different number of modes.

- devfs minor generation fixed to work with non-default number of modes

- The alignment requirement is printed in the line logged when a tape i=
s
  attached.

--=20
Kai
------------------------------------8<---------------------------------=
-----
--- linux-2.6.3-bk7/drivers/scsi/st.c	2004-02-25 17:51:43.000000000 +02=
00
+++ linux-2.6.3-bk7-k1/drivers/scsi/st.c	2004-02-25 18:33:23.000000000 =
+0200
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Dev=
fs support
  */
=20
-static char *verstr =3D "20040213";
+static char *verstr =3D "20040225";
=20
 #include <linux/module.h>
=20
@@ -121,7 +121,15 @@
 };
 #endif
=20
-static char *st_formats[ST_NBR_MODES] =3D{"", "l", "m", "a"};
+/* Restrict the number of modes so that names for all are assigned */
+#if ST_NBR_MODES > 16
+#error "Maximum number of modes is 16"
+#endif
+/* Bit reversed order to get same names for same minors with all
+   mode counts */
+static char *st_formats[] =3D {
+	"",  "r", "n", "s", "l", "t", "o", "u",
+	"m", "v", "p", "x", "a", "y", "q", "z"};=20
=20
 /* The default definitions have been moved to st_options.h */
=20
@@ -3888,8 +3896,11 @@
 				       dev_num);
 				goto out_free_tape;
 			}
-			snprintf(cdev->kobj.name, KOBJ_NAME_LEN, "%sm%d%s", disk->disk_name=
,
-				 mode, j ? "n" : "");
+			/* Make sure that the minor numbers corresponding to the four
+			   first modes always get the same names */
+			i =3D mode << (4 - ST_NBR_MODE_BITS);
+			snprintf(cdev->kobj.name, KOBJ_NAME_LEN, "%s%s%s", j ? "n" : "",
+				 disk->disk_name, st_formats[i]);
 			cdev->owner =3D THIS_MODULE;
 			cdev->ops =3D &st_fops;
=20
@@ -3909,22 +3920,26 @@
 	}
=20
 	for (mode =3D 0; mode < ST_NBR_MODES; ++mode) {
+		/* Make sure that the minor numbers corresponding to the four
+		   first modes always get the same names */
+		i =3D mode << (4 - ST_NBR_MODE_BITS);
 		/*  Rewind entry  */
-		devfs_mk_cdev(MKDEV(SCSI_TAPE_MAJOR, dev_num + (mode << 5)),
+		devfs_mk_cdev(MKDEV(SCSI_TAPE_MAJOR, TAPE_MINOR(dev_num, mode, 0)),
 			      S_IFCHR | S_IRUGO | S_IWUGO,
-			      "%s/mt%s", SDp->devfs_name, st_formats[mode]);
+			      "%s/mt%s", SDp->devfs_name, st_formats[i]);
 		/*  No-rewind entry  */
-		devfs_mk_cdev(MKDEV(SCSI_TAPE_MAJOR, dev_num + (mode << 5) + 128),
+		devfs_mk_cdev(MKDEV(SCSI_TAPE_MAJOR, TAPE_MINOR(dev_num, mode, 1)),
 			      S_IFCHR | S_IRUGO | S_IWUGO,
-			      "%s/mt%sn", SDp->devfs_name, st_formats[mode]);
+			      "%s/mt%sn", SDp->devfs_name, st_formats[i]);
 	}
 	disk->number =3D devfs_register_tape(SDp->devfs_name);
=20
 	printk(KERN_WARNING
 	"Attached scsi tape %s at scsi%d, channel %d, id %d, lun %d\n",
 	       tape_name(tpnt), SDp->host->host_no, SDp->channel, SDp->id, SD=
p->lun);
-	printk(KERN_WARNING "%s: try direct i/o: %s, max page reachable by HB=
A %lu\n",
-	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no", tpnt->max_pfn);
+	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B), max pag=
e reachable by HBA %lu\n",
+	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
+	       queue_dma_alignment(SDp->request_queue) + 1, tpnt->max_pfn);
=20
 	return 0;
=20
@@ -3977,8 +3992,9 @@
 			sysfs_remove_link(&tpnt->device->sdev_gendev.kobj,
 					  "tape");
 			for (mode =3D 0; mode < ST_NBR_MODES; ++mode) {
-				devfs_remove("%s/mt%s", SDp->devfs_name, st_formats[mode]);
-				devfs_remove("%s/mt%sn", SDp->devfs_name, st_formats[mode]);
+				j =3D mode << (4 - ST_NBR_MODE_BITS);
+				devfs_remove("%s/mt%s", SDp->devfs_name, st_formats[j]);
+				devfs_remove("%s/mt%sn", SDp->devfs_name, st_formats[j]);
 				for (j=3D0; j < 2; j++) {
 					class_simple_device_remove(MKDEV(SCSI_TAPE_MAJOR,
 									 TAPE_MINOR(i, mode, j)));
--- linux-2.6.3-bk7/drivers/scsi/st.h	2004-01-09 21:52:34.000000000 +02=
00
+++ linux-2.6.3-bk7-k1/drivers/scsi/st.h	2004-02-25 17:52:47.000000000 =
+0200
@@ -50,6 +50,8 @@
 	struct cdev *cdevs[2];  /* Auto-rewind and non-rewind devices */
 } ST_mode;
=20
+/* Number of modes can be changed by changing ST_NBR_MODE_BITS. The ma=
ximum
+   number of modes is 16 (ST_NBR_MODE_BITS 4) */
 #define ST_NBR_MODE_BITS 2
 #define ST_NBR_MODES (1 << ST_NBR_MODE_BITS)
 #define ST_MODE_SHIFT (7 - ST_NBR_MODE_BITS)
--- linux-2.6.3-bk7/Documentation/scsi/st.txt	2004-02-25 17:51:42.00000=
0000 +0200
+++ linux-2.6.3-bk7-k1/Documentation/scsi/st.txt	2004-02-25 17:52:47.00=
0000000 +0200
@@ -2,7 +2,7 @@
 The driver is currently maintained by Kai M=E4kisara (email
 Kai.Makisara@kolumbus.fi)
=20
-Last modified: Thu Feb 19 21:57:30 2004 by makisara
+Last modified: Wed Feb 25 14:09:08 2004 by makisara
=20
=20
 BASICS
@@ -36,8 +36,9 @@
 manager. The changes persist until the defaults again come into
 effect.
=20
-3. Up to four modes can be defined and selected using the minor number
-(bits 5 and 6). Mode 0 corresponds to the defaults discussed
+3. By default, up to four modes can be defined and selected using the =
minor
+number (bits 5 and 6). The number of modes can be changed by changing
+ST_NBR_MODE_BITS in st.h. Mode 0 corresponds to the defaults discussed
 above. Additional modes are dormant until they are defined by the
 system manager (root). When specification of a new mode is started,
 the configuration of mode 0 is used to provide a starting point for
@@ -107,7 +108,7 @@
 dev_upper non-rew mode dev-lower
   20 -  8     7    6 5  4      0
 The non-rewind bit is always bit 7 (the uppermost bit in the lowermost
-byte). The bits defining the mode are next to the non-rewind bits. The
+byte). The bits defining the mode are below the non-rewind bit. The
 remaining bits define the tape device number. This numbering is
 backward compatible with the numbering used when the minor number was
 only 8 bits wide.
@@ -117,10 +118,10 @@
=20
 The driver creates the directory /sys/class/scsi_tape and populates it=
 with
 directories corresponding to the existing tape devices. There are auto=
rewind
-and non-rewind entries for each mode. The names are stxmy and stxmyn, =
where x
-is the tape number and y is the mode. For example, the directories for=
 the
-first tape device are (assuming four modes): st0m0  st0m0n  st0m1  st0=
m1n
-st0m2  st0m2n  st0m3  st0m3n.
+and non-rewind entries for each mode. The names are stxy and nstxy, wh=
ere x
+is the tape number and y a character corresponding to the mode (none, =
l, m,
+a). For example, the directories for the first tape device are (assumi=
ng four
+modes): st0  nst0  st0l  nst0l  st0m  nst0m  st0a  nst0a.
=20
 Each directory contains the entries: default_blksize  default_compress=
ion
 default_density  defined  dev  device  driver. The file 'defined' cont=
ains 1
@@ -130,7 +131,7 @@
 'device' and 'driver' point to the SCSI device and driver entries.
=20
 A link named 'tape' is made from the SCSI device directory to the clas=
s
-directory corresponding to the mode 0 auto-rewind device (e.g., st0m0)=
=2E=20
+directory corresponding to the mode 0 auto-rewind device (e.g., st0).=20
=20
=20
 BSD AND SYS V SEMANTICS
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
