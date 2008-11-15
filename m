From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [17/21] Remove GFP_DMA use in sr.c
Date: Sun, 16 Nov 2008 00:11:17 +0100 (CET)
Message-ID: <20081115231117.A08693E6619@basil.firstfloor.org>
References: <200811161211.212948789@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44203 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYKOXLO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 18:11:14 -0500
In-Reply-To: <200811161211.212948789@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org


Just remove GFP_DMA in all explicit IO calls in sr.c and friends. 

The block layer will bounce correctly now, and as far as I can see all the 
explicit IOs here are only for very small data sizes, so one copy more does not 
really matter.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/sr.c        |    2 +-
 drivers/scsi/sr_ioctl.c  |   13 ++++---------
 drivers/scsi/sr_vendor.c |    4 ++--
 3 files changed, 7 insertions(+), 12 deletions(-)

Index: linux/drivers/scsi/sr.c
===================================================================
--- linux.orig/drivers/scsi/sr.c	2008-11-15 22:37:08.000000000 +0100
+++ linux/drivers/scsi/sr.c	2008-11-15 22:37:12.000000000 +0100
@@ -761,7 +761,7 @@
 
 
 	/* allocate transfer buffer */
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer) {
 		printk(KERN_ERR "sr: out of memory.\n");
 		return;
Index: linux/drivers/scsi/sr_ioctl.c
===================================================================
--- linux.orig/drivers/scsi/sr_ioctl.c	2008-11-15 22:37:08.000000000 +0100
+++ linux/drivers/scsi/sr_ioctl.c	2008-11-15 22:37:12.000000000 +0100
@@ -30,11 +30,6 @@
 
 module_param(xa_test, int, S_IRUGO | S_IWUSR);
 
-/* primitive to determine whether we need to have GFP_DMA set based on
- * the status of the unchecked_isa_dma flag in the host structure */
-#define SR_GFP_DMA(cd) (((cd)->device->host->unchecked_isa_dma) ? GFP_DMA : 0)
-
-
 static int sr_read_tochdr(struct cdrom_device_info *cdi,
 		struct cdrom_tochdr *tochdr)
 {
@@ -43,7 +38,7 @@
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	buffer = kmalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -73,7 +68,7 @@
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	buffer = kmalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -385,7 +380,7 @@
 {
 	Scsi_CD *cd = cdi->handle;
 	struct packet_command cgc;
-	char *buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	char *buffer = kmalloc(32, GFP_KERNEL);
 	int result;
 
 	if (!buffer)
@@ -564,7 +559,7 @@
 	if (!xa_test)
 		return 0;
 
-	raw_sector = kmalloc(2048, GFP_KERNEL | SR_GFP_DMA(cd));
+	raw_sector = kmalloc(2048, GFP_KERNEL);
 	if (!raw_sector)
 		return -ENOMEM;
 	if (0 == sr_read_sector(cd, cd->ms_offset + 16,
Index: linux/drivers/scsi/sr_vendor.c
===================================================================
--- linux.orig/drivers/scsi/sr_vendor.c	2008-11-15 22:37:08.000000000 +0100
+++ linux/drivers/scsi/sr_vendor.c	2008-11-15 22:37:12.000000000 +0100
@@ -117,7 +117,7 @@
 		density = (blocklength > 2048) ? 0x81 : 0x83;
 #endif
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -164,7 +164,7 @@
 	if (cd->cdi.mask & CDC_MULTI_SESSION)
 		return 0;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
