From: "Fillod Stephane" <stephane.fillod@thomson.net>
Subject: [PATCH] compile out scsi_ioctl when no SCSI/IDE/etc.  (take 2)
Date: Mon, 4 Apr 2005 15:47:01 +0200
Message-ID: <1CFEB358338412458B21FAA0D78FE86D4F0D29@rennsmail02.eu.thmulti.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dmzraw2.extranet.tce.com ([157.254.234.138]:37053 "EHLO
	dmzraw2.extranet.tce.com") by vger.kernel.org with ESMTP
	id S261239AbVDDNrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2005 09:47:17 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>
Cc: linux-tiny@selenic.com, linux-scsi@vger.kernel.org

Hi Matt and everyone,

I fixed my previous patch, added "select" statements, and provided
support for hard-disk only IDE systems as suggested by Eric.

Here are the sizes of vmlinux for a ppc system:

                           text    data     bss     dec
no IDE, with scsi_ioctl 1646846  181844  111428 1940118
no IDE, no scsi_ioctl   1642498  179884  111428 1933810
IDE, with scsi_ioctl    1646870  181844  111428 1940142
IDE, no scsi_ioctl      1642522  179884  111428 1933834

On systems with no SCSI/IDE/etc. or with IDE but no CD/DVD, 
the potential saving is 6308 bytes.

Matt, how do we proceed from here? If the patch is to your liking,
can I hand it off to you, for eventual submission to Linus
or the SCSI guys?


This patch compiles out scsi_ioctl for embedded system with no 
SCSI/IDE/etc, and saves up to 6 KiB.
It was made against linux 2.6.11.6.

Signed-off-by: Stephane Fillod <fillods@gmail.com>

--- linux/drivers/block/Kconfig	26 Mar 2005 03:28:16 -0000	1.1.1.2
+++ linux/drivers/block/Kconfig	4 Apr 2005 13:24:29 -0000
@@ -354,6 +354,7 @@
 config BLK_DEV_UB
 	tristate "Low Performance USB Block driver"
 	depends on USB
+	select SCSI_IOCTL
 	help
 	  This driver supports certain USB attached storage devices
 	  such as flash keys.
@@ -506,4 +507,18 @@
 	This driver provides Support for ATA over Ethernet block
 	devices like the Coraid EtherDrive (R) Storage Blade.
 
+config SCSI_IOCTL
+	bool "SCSI ioctl" if EMBEDDED
+	depends on IDE || PARIDE || SCSI || CD_NO_IDESCSI || BLK_DEV_UB
+	default y
+        help
+	  Say Y here if you have any CD/DVD device (IDE, SCSI, other)
+	  or USB mass storage device attached to your system and want
+          it to be available to applications.
+
+          Say N here if you have a hard-drive only or diskless system, 
+	  and want to save couple KiB of memory.
+
+          If unsure, say Y.
+
 endmenu
--- linux/drivers/block/Makefile	6 Dec 2004 16:18:35 -0000
1.1.1.1
+++ linux/drivers/block/Makefile	4 Apr 2005 13:24:29 -0000
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
+++ linux/drivers/cdrom/Kconfig	4 Apr 2005 13:24:29 -0000
@@ -7,6 +7,7 @@
 
 config CD_NO_IDESCSI
 	bool "Support non-SCSI/IDE/ATAPI CDROM drives"
+	select SCSI_IOCTL
 	---help---
 	  If you have a CD-ROM drive that is neither SCSI nor IDE/ATAPI,
say Y
 	  here, otherwise N. Read the CD-ROM-HOWTO, available from
--- linux/drivers/ide/Kconfig	26 Mar 2005 03:28:20 -0000	1.1.1.2
+++ linux/drivers/ide/Kconfig	4 Apr 2005 13:24:29 -0000
@@ -168,6 +168,7 @@
 
 config BLK_DEV_IDECD
 	tristate "Include IDE/ATAPI CDROM support"
+	select SCSI_IOCTL
 	---help---
 	  If you have a CD-ROM drive using the ATAPI protocol, say Y.
ATAPI is
 	  a newer protocol used by IDE CD-ROM and TAPE drives, similar
to the
--- linux/drivers/ide/ide.c	26 Mar 2005 03:28:17 -0000	1.1.1.2
+++ linux/drivers/ide/ide.c	4 Apr 2005 13:24:29 -0000
@@ -1562,9 +1562,11 @@
 			return 0;
 		}
 
+#ifdef CONFIG_SCSI_IOCTL
 		case CDROMEJECT:
 		case CDROMCLOSETRAY:
 			return scsi_cmd_ioctl(file, bdev->bd_disk, cmd,
p);
+#endif
 
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
--- linux/drivers/scsi/Kconfig	26 Mar 2005 03:28:36 -0000	1.1.1.2
+++ linux/drivers/scsi/Kconfig	4 Apr 2005 13:24:30 -0000
@@ -2,6 +2,7 @@
 
 config SCSI
 	tristate "SCSI device support"
+	select SCSI_IOCTL
 	---help---
 	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI
CD-ROM or
 	  any other SCSI device under Linux, say Y and make sure that
you know


Comments welcome.


Best Regards,
--
Stephane Fillod

PS: please Cc:

