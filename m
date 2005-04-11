From: "Fillod Stephane" <stephane.fillod@thomson.net>
Subject: [PATCH] compile out scsi_ioctl when no SCSI/IDE/etc. (take 3)
Date: Mon, 11 Apr 2005 17:50:08 +0200
Message-ID: <1CFEB358338412458B21FAA0D78FE86D4F0D3B@rennsmail02.eu.thmulti.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dmzraw2.extranet.tce.com ([157.254.234.138]:57514 "EHLO
	dmzraw2.extranet.tce.com") by vger.kernel.org with ESMTP
	id S261815AbVDKPua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2005 11:50:30 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-tiny@selenic.com
Cc: linux-scsi@vger.kernel.org

Hi Matt and everyone, 

I fixed again my previous patch (take2):

* CDROM_PKTCDVD draws dependency

* removing SCSI_IOCTL from displayed options,
  as suggested by Milton Miller.

* rewrote ifdefs in the middle of ide.c functions as dummy function 
  in header, as suggested by Matthew Wilcox.


Matt, how do we proceed from here? If the patch is to your liking,
can I hand it off to you, for eventual submission to Linus
or the SCSI team?


This patch compiles out scsi_ioctl for embedded system with no 
SCSI/IDE/etc, and saves up to 6 KiB.
It was made against linux 2.6.11.6.

Signed-off-by: Stephane Fillod <fillods@gmail.com>

--- linux/drivers/block/Kconfig	26 Mar 2005 03:28:16 -0000	1.1.1.2
+++ linux/drivers/block/Kconfig	11 Apr 2005 15:45:02 -0000
@@ -354,6 +354,7 @@
 config BLK_DEV_UB
 	tristate "Low Performance USB Block driver"
 	depends on USB
+	select SCSI_IOCTL
 	help
 	  This driver supports certain USB attached storage devices
 	  such as flash keys.
@@ -464,6 +465,7 @@
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !USERMODE
+	select SCSI_IOCTL
 	help
 	  If you have a CDROM drive that supports packet writing, say Y
to
 	  include preliminary support. It should work with any MMC/Mt
Fuji
@@ -506,4 +508,7 @@
 	This driver provides Support for ATA over Ethernet block
 	devices like the Coraid EtherDrive (R) Storage Blade.
 
+config SCSI_IOCTL
+	bool
+
 endmenu
--- linux/drivers/block/Makefile	6 Dec 2004 16:18:35 -0000
1.1.1.1
+++ linux/drivers/block/Makefile	11 Apr 2005 15:45:02 -0000
@@ -13,8 +13,9 @@
 # kblockd threads
 #
 
-obj-y	:= elevator.o ll_rw_blk.o ioctl.o genhd.o scsi_ioctl.o
+obj-y	:= elevator.o ll_rw_blk.o ioctl.o genhd.o
 
+obj-$(CONFIG_SCSI_IOCTL)	+= scsi_ioctl.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_AS)	+= as-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
--- linux/drivers/cdrom/Kconfig	26 Mar 2005 03:28:26 -0000	1.1.1.2
+++ linux/drivers/cdrom/Kconfig	11 Apr 2005 15:45:02 -0000
@@ -7,6 +7,7 @@
 
 config CD_NO_IDESCSI
 	bool "Support non-SCSI/IDE/ATAPI CDROM drives"
+	select SCSI_IOCTL
 	---help---
 	  If you have a CD-ROM drive that is neither SCSI nor IDE/ATAPI,
say Y
 	  here, otherwise N. Read the CD-ROM-HOWTO, available from
--- linux/drivers/ide/Kconfig	26 Mar 2005 03:28:20 -0000	1.1.1.2
+++ linux/drivers/ide/Kconfig	11 Apr 2005 15:45:02 -0000
@@ -168,6 +168,7 @@
 
 config BLK_DEV_IDECD
 	tristate "Include IDE/ATAPI CDROM support"
+	select SCSI_IOCTL
 	---help---
 	  If you have a CD-ROM drive using the ATAPI protocol, say Y.
ATAPI is
 	  a newer protocol used by IDE CD-ROM and TAPE drives, similar
to the
--- linux/drivers/scsi/Kconfig	26 Mar 2005 03:28:36 -0000	1.1.1.2
+++ linux/drivers/scsi/Kconfig	11 Apr 2005 15:45:02 -0000
@@ -2,6 +2,7 @@
 
 config SCSI
 	tristate "SCSI device support"
+	select SCSI_IOCTL
 	---help---
 	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI
CD-ROM or
 	  any other SCSI device under Linux, say Y and make sure that
you know
--- linux/include/linux/blkdev.h	26 Mar 2005 03:28:16 -0000
1.1.1.2
+++ linux/include/linux/blkdev.h	11 Apr 2005 15:45:02 -0000
@@ -520,7 +520,14 @@
 extern void blk_recount_segments(request_queue_t *, struct bio *);
 extern int blk_phys_contig_segment(request_queue_t *q, struct bio *,
struct bio *);
 extern int blk_hw_contig_segment(request_queue_t *q, struct bio *,
struct bio *);
+#ifdef CONFIG_SCSI_IOCTL
 extern int scsi_cmd_ioctl(struct file *, struct gendisk *, unsigned
int, void __user *);
+#else
+static inline int scsi_cmd_ioctl(struct file *f, struct gendisk *g,
unsigned int cmd, void __user *ptr)
+{
+	return -ENOTTY;
+}
+#endif
 extern void blk_start_queue(request_queue_t *q);
 extern void blk_stop_queue(request_queue_t *q);
 extern void blk_sync_queue(struct request_queue *q);


Comments welcome.

I've seen another function blkdev_scsi_issue_flush_fn that could be
compiled
out..


Best Regards,
--
Stephane Fillod

PS: please Cc:

