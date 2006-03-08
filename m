From: akpm@osdl.org
Subject: [patch 04/28] MODULE_ALIAS_{BLOCK,CHAR}DEV_MAJOR for drivers/scsi
Date: Wed, 08 Mar 2006 00:14:20 -0800
Message-ID: <200603080816.k288G97w002160@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:25772 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1752097AbWCHIQU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, rene.herman@keyaccess.nl, greg@kroah.com, hch@lst.de


From: Rene Herman <rene.herman@keyaccess.nl>

Add device-major aliases in drivers/scsi, allowing kmod autoload:

MODULE_ALIAS_CHARDEV_MAJOR(SCSI_CHANGER_MAJOR)
MODULE_ALIAS_CHARDEV_MAJOR(OSST_MAJOR)
MODULE_ALIAS_CHARDEV_MAJOR(SCSI_TAPE_MAJOR)
MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_CDROM_MAJOR)
MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISKN_MAJOR)

Submitted the SCSI_TAPE_MAJOR before to the driver author, but never got
a reply:

http://marc.theaimsgroup.com/?l=linux-kernel&m=110589612809217&w=2

Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/ch.c   |    1 +
 drivers/scsi/osst.c |    1 +
 drivers/scsi/sd.c   |   25 +++++++++++++++++++++----
 drivers/scsi/sg.c   |    2 +-
 drivers/scsi/sr.c   |    4 ++++
 drivers/scsi/st.c   |    3 ++-
 6 files changed, 30 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ch.c~module_alias_blockchardev_major-for-drivers-scsi drivers/scsi/ch.c
--- devel/drivers/scsi/ch.c~module_alias_blockchardev_major-for-drivers-scsi	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/ch.c	2006-02-27 20:57:26.000000000 -0800
@@ -39,6 +39,7 @@
 MODULE_DESCRIPTION("device driver for scsi media changer devices");
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(SCSI_CHANGER_MAJOR);
 
 static int init = 1;
 module_param(init, int, 0444);
diff -puN drivers/scsi/osst.c~module_alias_blockchardev_major-for-drivers-scsi drivers/scsi/osst.c
--- devel/drivers/scsi/osst.c~module_alias_blockchardev_major-for-drivers-scsi	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/osst.c	2006-02-27 20:57:26.000000000 -0800
@@ -86,6 +86,7 @@ static int max_sg_segs = 0;
 MODULE_AUTHOR("Willem Riede");
 MODULE_DESCRIPTION("OnStream {DI-|FW-|SC-|USB}{30|50} Tape Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(OSST_MAJOR);
 
 module_param(max_dev, int, 0444);
 MODULE_PARM_DESC(max_dev, "Maximum number of OnStream Tape Drives to attach (4)");
diff -puN drivers/scsi/sd.c~module_alias_blockchardev_major-for-drivers-scsi drivers/scsi/sd.c
--- devel/drivers/scsi/sd.c~module_alias_blockchardev_major-for-drivers-scsi	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/sd.c	2006-02-27 20:57:26.000000000 -0800
@@ -71,6 +71,27 @@
  */
 #define SD_MAJORS	16
 
+MODULE_AUTHOR("Eric Youngdale");
+MODULE_DESCRIPTION("SCSI disk (sd) driver");
+MODULE_LICENSE("GPL");
+
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK0_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK1_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK2_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK3_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK4_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK5_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK6_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK7_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK8_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK9_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK10_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK11_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK12_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK13_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK14_MAJOR);
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK15_MAJOR);
+
 /*
  * This is limited by the naming scheme enforced in sd_probe,
  * add another character to it if you really need more disks.
@@ -1707,9 +1728,5 @@ static void __exit exit_sd(void)
 		unregister_blkdev(sd_major(i), "sd");
 }
 
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Eric Youngdale");
-MODULE_DESCRIPTION("SCSI disk (sd) driver");
-
 module_init(init_sd);
 module_exit(exit_sd);
diff -puN drivers/scsi/sg.c~module_alias_blockchardev_major-for-drivers-scsi drivers/scsi/sg.c
--- devel/drivers/scsi/sg.c~module_alias_blockchardev_major-for-drivers-scsi	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/sg.c	2006-02-27 20:57:26.000000000 -0800
@@ -1569,6 +1569,7 @@ MODULE_AUTHOR("Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI generic (sg) driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(SG_VERSION_STR);
+MODULE_ALIAS_CHARDEV_MAJOR(SCSI_GENERIC_MAJOR);
 
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
 MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
@@ -2966,4 +2967,3 @@ static int sg_proc_seq_show_debug(struct
 
 module_init(init_sg);
 module_exit(exit_sg);
-MODULE_ALIAS_CHARDEV_MAJOR(SCSI_GENERIC_MAJOR);
diff -puN drivers/scsi/sr.c~module_alias_blockchardev_major-for-drivers-scsi drivers/scsi/sr.c
--- devel/drivers/scsi/sr.c~module_alias_blockchardev_major-for-drivers-scsi	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/sr.c	2006-02-27 20:57:26.000000000 -0800
@@ -60,6 +60,10 @@
 #include "sr.h"
 
 
+MODULE_DESCRIPTION("SCSI cdrom (sr) driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_CDROM_MAJOR);
+
 #define SR_DISKS	256
 
 #define MAX_RETRIES	3
diff -puN drivers/scsi/st.c~module_alias_blockchardev_major-for-drivers-scsi drivers/scsi/st.c
--- devel/drivers/scsi/st.c~module_alias_blockchardev_major-for-drivers-scsi	2006-02-27 20:57:26.000000000 -0800
+++ devel-akpm/drivers/scsi/st.c	2006-02-27 20:57:26.000000000 -0800
@@ -86,8 +86,9 @@ static int st_nr_dev;
 static struct class *st_sysfs_class;
 
 MODULE_AUTHOR("Kai Makisara");
-MODULE_DESCRIPTION("SCSI Tape Driver");
+MODULE_DESCRIPTION("SCSI tape (st) driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(SCSI_TAPE_MAJOR);
 
 /* Set 'perm' (4th argument) to 0 to disable module_param's definition
  * of sysfs parameters (which module_param doesn't yet support).
_
