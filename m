From: "Saripalli, Venkata Ramanamurthy (STSD)" <saripalli@hp.com>
Subject: [PATCH 1/3] cpqarray: support for SENSE_SURF_STATUS ioctl
Date: Thu, 4 Aug 2005 10:13:15 +0530
Message-ID: <4221C1B21C20854291E185D1243EA8F302623BD4@bgeexc04.asiapacific.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bgerelbas01.asiapac.hp.net ([15.219.201.134]:25473 "EHLO
	bgerelbas01.ind.hp.com") by vger.kernel.org with ESMTP
	id S261776AbVHDEnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2005 00:43:19 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: axboe@suse.de

Patch 1 of 3
This patch adds support for SENSE_SURF_STATUS ioctl for configuring
SA4200 controller
using Array Configuration Utility (ACU).

Please consider this for inclusion.

Signed-off-by: Ramanamurthy Saripalli <saripalli@hp.com>

 cpqarray.c |    8 +++++---
 ida_cmd.h  |    2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)
------------------------------------------------------------------------
--------------
diff -burpN old/drivers/block/cpqarray.c new1/drivers/block/cpqarray.c
--- old/drivers/block/cpqarray.c	2005-06-28 23:26:06.000000000
-0400
+++ new1/drivers/block/cpqarray.c	2005-06-28 23:28:03.000000000
-0400
@@ -45,13 +45,13 @@
 
 #define SMART2_DRIVER_VERSION(maj,min,submin)
((maj<<16)|(min<<8)|(submin))
 
-#define DRIVER_NAME "Compaq SMART2 Driver (v 2.6.0)"
-#define DRIVER_VERSION SMART2_DRIVER_VERSION(2,6,0)
+#define DRIVER_NAME "Compaq SMART2 Driver (v 2.6.1)"
+#define DRIVER_VERSION SMART2_DRIVER_VERSION(2,6,1)
 
 /* Embedded module documentation macros - see modules.h */
 /* Original author Chris Frantz - Compaq Computer Corporation */
 MODULE_AUTHOR("Compaq Computer Corporation");
-MODULE_DESCRIPTION("Driver for Compaq Smart2 Array Controllers version
2.6.0");
+MODULE_DESCRIPTION("Driver for Compaq Smart2 Array Controllers version
2.6.1");
 MODULE_LICENSE("GPL");
 
 #include "cpqarray.h"
@@ -1272,6 +1272,7 @@ static int ida_ctlr_ioctl(ctlr_info_t *h
 		c->req.hdr.sg_cnt = 1;
 		break;
 	case IDA_READ:
+	case SENSE_SURF_STATUS:
 	case READ_FLASH_ROM:
 	case SENSE_CONTROLLER_PERFORMANCE:
 		p = kmalloc(io->sg[0].size, GFP_KERNEL);
@@ -1337,6 +1338,7 @@ static int ida_ctlr_ioctl(ctlr_info_t *h
                                 sizeof(ida_ioctl_t),
                                 PCI_DMA_BIDIRECTIONAL);
 	case IDA_READ:
+	case SENSE_SURF_STATUS:
 	case DIAG_PASS_THRU:
 	case SENSE_CONTROLLER_PERFORMANCE:
 	case READ_FLASH_ROM:
diff -burpN old/drivers/block/ida_cmd.h new1/drivers/block/ida_cmd.h
--- old/drivers/block/ida_cmd.h	2005-06-28 23:26:22.000000000 -0400
+++ new1/drivers/block/ida_cmd.h	2005-06-28 23:28:03.000000000
-0400
@@ -318,6 +318,8 @@ typedef struct {
 	__u8	reserved[510];
 } mp_delay_t;
 
+#define SENSE_SURF_STATUS       0x70
+
 #define PASSTHRU_A	0x91
 typedef struct {
 	__u8	target;
