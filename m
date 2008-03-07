From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [16/20] Convert sr driver over the blk_kmalloc
Date: Fri,  7 Mar 2008 18:54:16 +0100 (CET)
Message-ID: <20080307175416.11A2D1B41AE@basil.firstfloor.org>
References: <20080307653.720459648@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:14690 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758779AbYCGRyV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 12:54:21 -0500
In-Reply-To: <20080307653.720459648@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


This replaces references to unchecked_isa_dma. Instead just let the block
layer allocate dma able memory for it.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/sr.c        |   12 ++++++------
 drivers/scsi/sr_ioctl.c  |   22 +++++++++-------------
 drivers/scsi/sr_vendor.c |    8 ++++----
 3 files changed, 19 insertions(+), 23 deletions(-)

Index: linux/drivers/scsi/sr_ioctl.c
===================================================================
--- linux.orig/drivers/scsi/sr_ioctl.c
+++ linux/drivers/scsi/sr_ioctl.c
@@ -30,11 +30,6 @@ static int xa_test = 0;
 
 module_param(xa_test, int, S_IRUGO | S_IWUSR);
 
-/* primitive to determine whether we need to have GFP_DMA set based on
- * the status of the unchecked_isa_dma flag in the host structure */
-#define SR_GFP_DMA(cd) (((cd)->device->host->unchecked_isa_dma) ? GFP_DMA : 0)
-
-
 static int sr_read_tochdr(struct cdrom_device_info *cdi,
 		struct cdrom_tochdr *tochdr)
 {
@@ -43,7 +38,7 @@ static int sr_read_tochdr(struct cdrom_d
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	buffer = blk_kmalloc(cd->device->request_queue, 32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -61,7 +56,7 @@ static int sr_read_tochdr(struct cdrom_d
 	tochdr->cdth_trk0 = buffer[2];
 	tochdr->cdth_trk1 = buffer[3];
 
-	kfree(buffer);
+	blk_kfree(buffer, 32);
 	return result;
 }
 
@@ -73,7 +68,7 @@ static int sr_read_tocentry(struct cdrom
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	buffer = blk_kmalloc(cd->device->request_queue, 32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -100,7 +95,7 @@ static int sr_read_tocentry(struct cdrom
 		tocentry->cdte_addr.lba = (((((buffer[8] << 8) + buffer[9]) << 8)
 			+ buffer[10]) << 8) + buffer[11];
 
-	kfree(buffer);
+	blk_kfree(buffer, 32);
 	return result;
 }
 
@@ -385,7 +380,8 @@ int sr_get_mcn(struct cdrom_device_info 
 {
 	Scsi_CD *cd = cdi->handle;
 	struct packet_command cgc;
-	char *buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	struct scsi_device *dev = cd->device;
+	char *buffer = blk_kmalloc(dev->request_queue, 32, GFP_KERNEL);
 	int result;
 
 	if (!buffer)
@@ -405,7 +401,7 @@ int sr_get_mcn(struct cdrom_device_info 
 	memcpy(mcn->medium_catalog_number, buffer + 9, 13);
 	mcn->medium_catalog_number[13] = 0;
 
-	kfree(buffer);
+	blk_kfree(buffer, 32);
 	return result;
 }
 
@@ -564,7 +560,7 @@ int sr_is_xa(Scsi_CD *cd)
 	if (!xa_test)
 		return 0;
 
-	raw_sector = kmalloc(2048, GFP_KERNEL | SR_GFP_DMA(cd));
+	raw_sector = blk_kmalloc(cd->device->request_queue, 2048, GFP_KERNEL);
 	if (!raw_sector)
 		return -ENOMEM;
 	if (0 == sr_read_sector(cd, cd->ms_offset + 16,
@@ -574,7 +570,7 @@ int sr_is_xa(Scsi_CD *cd)
 		/* read a raw sector failed for some reason. */
 		is_xa = -1;
 	}
-	kfree(raw_sector);
+	blk_kfree(raw_sector, 2048);
 #ifdef DEBUG
 	printk("%s: sr_is_xa: %d\n", cd->cdi.name, is_xa);
 #endif
Index: linux/drivers/scsi/sr.c
===================================================================
--- linux.orig/drivers/scsi/sr.c
+++ linux/drivers/scsi/sr.c
@@ -674,7 +674,8 @@ static void get_sectorsize(struct scsi_c
 	int sector_size;
 	struct request_queue *queue;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	queue = cd->device->request_queue;
+	buffer = blk_kmalloc(queue, 512, GFP_KERNEL);
 	if (!buffer)
 		goto Enomem;
 
@@ -739,10 +740,9 @@ static void get_sectorsize(struct scsi_c
 		set_capacity(cd->disk, cd->capacity);
 	}
 
-	queue = cd->device->request_queue;
 	blk_queue_hardsect_size(queue, sector_size);
 out:
-	kfree(buffer);
+	blk_kfree(buffer, 512);
 	return;
 
 Enomem:
@@ -772,7 +772,7 @@ static void get_capabilities(struct scsi
 
 
 	/* allocate transfer buffer */
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = blk_kmalloc(cd->device->request_queue, 512, GFP_KERNEL);
 	if (!buffer) {
 		printk(KERN_ERR "sr: out of memory.\n");
 		return;
@@ -792,7 +792,7 @@ static void get_capabilities(struct scsi
 				 CDC_DVD | CDC_DVD_RAM |
 				 CDC_SELECT_DISC | CDC_SELECT_SPEED |
 				 CDC_MRW | CDC_MRW_W | CDC_RAM);
-		kfree(buffer);
+		blk_kfree(buffer, 512);
 		printk("%s: scsi-1 drive\n", cd->cdi.name);
 		return;
 	}
@@ -851,7 +851,7 @@ static void get_capabilities(struct scsi
 		cd->device->writeable = 1;
 	}
 
-	kfree(buffer);
+	blk_kfree(buffer, 512);
 }
 
 /*
Index: linux/drivers/scsi/sr_vendor.c
===================================================================
--- linux.orig/drivers/scsi/sr_vendor.c
+++ linux/drivers/scsi/sr_vendor.c
@@ -117,7 +117,7 @@ int sr_set_blocklength(Scsi_CD *cd, int 
 		density = (blocklength > 2048) ? 0x81 : 0x83;
 #endif
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = blk_kmalloc(cd->device->request_queue, 512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -146,7 +146,7 @@ int sr_set_blocklength(Scsi_CD *cd, int 
 		printk("%s: switching blocklength to %d bytes failed\n",
 		       cd->cdi.name, blocklength);
 #endif
-	kfree(buffer);
+	blk_kfree(buffer, 512);
 	return rc;
 }
 
@@ -164,7 +164,7 @@ int sr_cd_check(struct cdrom_device_info
 	if (cd->cdi.mask & CDC_MULTI_SESSION)
 		return 0;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = blk_kmalloc(cd->device->request_queue, 512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -323,6 +323,6 @@ int sr_cd_check(struct cdrom_device_info
 		printk(KERN_DEBUG "%s: multisession offset=%lu\n",
 		       cd->cdi.name, sector);
 #endif
-	kfree(buffer);
+	blk_kfree(buffer, 512);
 	return rc;
 }
