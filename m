From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 2/4] ps3disk: updates after final review
Date: Thu, 19 Jul 2007 15:54:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707191553500.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
 <20070716162206.392129000@pademelon.sonytel.be> <20070718163637.3f0e0164.akpm@linux-foundation.org>
 <Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
 <20070719021045.c0b994ca.akpm@linux-foundation.org>
 <Pine.LNX.4.62.0707191548070.8661@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-2081383282-1184853258=:8661"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43785 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1765802AbXGSNyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 09:54:20 -0400
In-Reply-To: <Pine.LNX.4.62.0707191548070.8661@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-2081383282-1184853258=:8661
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

ps3disk: updates after final review:
  o Kill KERNEL_SECTOR_SIZE, just hardcode `512' or `>> 9'
  o Kill confusing ps3disk_priv() macro, open code it instead
  o ps3disk_scatter_gather(): Kill unused variable  `sectors'
  o Introduce ps3disk_mask_mutex to protect ps3disk_mask
  o Minor coding style fixes not reported by checkpatch

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/block/ps3disk.c |   44 +++++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -33,8 +33,6 @@
 #define PS3DISK_MAX_DISKS	16
 #define PS3DISK_MINORS		16
 
-#define KERNEL_SECTOR_SIZE	512
-
 
 #define PS3DISK_NAME		"ps3d%c"
 
@@ -48,7 +46,6 @@ struct ps3disk_private {
 	u64 raw_capacity;
 	unsigned char model[ATA_ID_PROD_LEN+1];
 };
-#define ps3disk_priv(dev)	((dev)->sbd.core.driver_data)
 
 
 #define LV1_STORAGE_SEND_ATA_COMMAND	(2)
@@ -93,7 +90,7 @@ static struct block_device_operations ps
 static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
 				   struct request *req, int gather)
 {
-	unsigned int sectors = 0, offset = 0;
+	unsigned int offset = 0;
 	struct bio *bio;
 	sector_t sector;
 	struct bio_vec *bvec;
@@ -118,7 +115,6 @@ static void ps3disk_scatter_gather(struc
 			flush_kernel_dcache_page(bio_iovec_idx(bio, j)->bv_page);
 			__bio_kunmap_atomic(bio, KM_IRQ0);
 		}
-		sectors += bio_sectors(bio);
 		i++;
 	}
 }
@@ -126,7 +122,7 @@ static void ps3disk_scatter_gather(struc
 static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
 				     struct request *req)
 {
-	struct ps3disk_private *priv = ps3disk_priv(dev);
+	struct ps3disk_private *priv = dev->sbd.core.driver_data;
 	int write = rq_data_dir(req), res;
 	const char *op = write ? "write" : "read";
 	u64 start_sector, sectors;
@@ -135,6 +131,7 @@ static int ps3disk_submit_request_sg(str
 #ifdef DEBUG
 	unsigned int n = 0;
 	struct bio *bio;
+
 	rq_for_each_bio(bio, req)
 		n++;
 	dev_dbg(&dev->sbd.core,
@@ -143,8 +140,8 @@ static int ps3disk_submit_request_sg(str
 		req->hard_nr_sectors);
 #endif
 
-	start_sector = req->sector*priv->blocking_factor;
-	sectors = req->nr_sectors*priv->blocking_factor;
+	start_sector = req->sector * priv->blocking_factor;
+	sectors = req->nr_sectors * priv->blocking_factor;
 	dev_dbg(&dev->sbd.core, "%s:%u: %s %lu sectors starting at %lu\n",
 		__func__, __LINE__, op, sectors, start_sector);
 
@@ -173,7 +170,7 @@ static int ps3disk_submit_request_sg(str
 static int ps3disk_submit_flush_request(struct ps3_storage_device *dev,
 					struct request *req)
 {
-	struct ps3disk_private *priv = ps3disk_priv(dev);
+	struct ps3disk_private *priv = dev->sbd.core.driver_data;
 	u64 res;
 
 	dev_dbg(&dev->sbd.core, "%s:%u: flush request\n", __func__, __LINE__);
@@ -217,7 +214,7 @@ static void ps3disk_do_request(struct ps
 static void ps3disk_request(request_queue_t *q)
 {
 	struct ps3_storage_device *dev = q->queuedata;
-	struct ps3disk_private *priv = ps3disk_priv(dev);
+	struct ps3disk_private *priv = dev->sbd.core.driver_data;
 
 	if (priv->req) {
 		dev_dbg(&dev->sbd.core, "%s:%u busy\n", __func__, __LINE__);
@@ -250,7 +247,7 @@ static irqreturn_t ps3disk_interrupt(int
 		return IRQ_HANDLED;
 	}
 
-	priv = ps3disk_priv(dev);
+	priv = dev->sbd.core.driver_data;
 	req = priv->req;
 	if (!req) {
 		dev_dbg(&dev->sbd.core,
@@ -374,7 +371,7 @@ static void ata_id_c_string(const u16 *i
 
 static int ps3disk_identify(struct ps3_storage_device *dev)
 {
-	struct ps3disk_private *priv = ps3disk_priv(dev);
+	struct ps3disk_private *priv = dev->sbd.core.driver_data;
 	struct lv1_ata_cmnd_block ata_cmnd;
 	u16 *id = dev->bounce_buf;
 	u64 res;
@@ -439,6 +436,8 @@ static int ps3disk_issue_flush(request_q
 
 static unsigned long ps3disk_mask;
 
+static DEFINE_MUTEX(ps3disk_mask_mutex);
+
 static int __devinit ps3disk_probe(struct ps3_system_bus_device *_dev)
 {
 	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
@@ -448,7 +447,7 @@ static int __devinit ps3disk_probe(struc
 	struct request_queue *queue;
 	struct gendisk *gendisk;
 
-	if (dev->blk_size < KERNEL_SECTOR_SIZE) {
+	if (dev->blk_size < 512) {
 		dev_err(&dev->sbd.core,
 			"%s:%u: cannot handle block size %lu\n", __func__,
 			__LINE__, dev->blk_size);
@@ -456,13 +455,16 @@ static int __devinit ps3disk_probe(struc
 	}
 
 	BUILD_BUG_ON(PS3DISK_MAX_DISKS > BITS_PER_LONG);
+	mutex_lock(&ps3disk_mask_mutex);
 	devidx = find_first_zero_bit(&ps3disk_mask, PS3DISK_MAX_DISKS);
 	if (devidx >= PS3DISK_MAX_DISKS) {
 		dev_err(&dev->sbd.core, "%s:%u: Too many disks\n", __func__,
 			__LINE__);
+		mutex_unlock(&ps3disk_mask_mutex);
 		return -ENOSPC;
 	}
 	__set_bit(devidx, &ps3disk_mask);
+	mutex_unlock(&ps3disk_mask_mutex);
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
@@ -470,7 +472,7 @@ static int __devinit ps3disk_probe(struc
 		goto fail;
 	}
 
-	ps3disk_priv(dev) = priv;
+	dev->sbd.core.driver_data = priv;
 	spin_lock_init(&priv->lock);
 
 	dev->bounce_size = BOUNCE_SIZE;
@@ -499,7 +501,7 @@ static int __devinit ps3disk_probe(struc
 
 	blk_queue_bounce_limit(queue, BLK_BOUNCE_HIGH);
 
-	blk_queue_max_sectors(queue, dev->bounce_size/KERNEL_SECTOR_SIZE);
+	blk_queue_max_sectors(queue, dev->bounce_size >> 9);
 	blk_queue_segment_boundary(queue, -1UL);
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
 	blk_queue_hardsect_size(queue, dev->blk_size);
@@ -529,7 +531,7 @@ static int __devinit ps3disk_probe(struc
 	gendisk->driverfs_dev = &dev->sbd.core;
 	snprintf(gendisk->disk_name, sizeof(gendisk->disk_name), PS3DISK_NAME,
 		 devidx+'a');
-	priv->blocking_factor = dev->blk_size/KERNEL_SECTOR_SIZE;
+	priv->blocking_factor = dev->blk_size >> 9;
 	set_capacity(gendisk,
 		     dev->regions[dev->region_idx].size*priv->blocking_factor);
 
@@ -549,19 +551,23 @@ fail_free_bounce:
 	kfree(dev->bounce_buf);
 fail_free_priv:
 	kfree(priv);
-	ps3disk_priv(dev) = NULL;
+	dev->sbd.core.driver_data = NULL;
 fail:
+	mutex_lock(&ps3disk_mask_mutex);
 	__clear_bit(devidx, &ps3disk_mask);
+	mutex_unlock(&ps3disk_mask_mutex);
 	return error;
 }
 
 static int ps3disk_remove(struct ps3_system_bus_device *_dev)
 {
 	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
-	struct ps3disk_private *priv = ps3disk_priv(dev);
+	struct ps3disk_private *priv = dev->sbd.core.driver_data;
 
+	mutex_lock(&ps3disk_mask_mutex);
 	__clear_bit(priv->gendisk->first_minor / PS3DISK_MINORS,
 		    &ps3disk_mask);
+	mutex_unlock(&ps3disk_mask_mutex);
 	del_gendisk(priv->gendisk);
 	blk_cleanup_queue(priv->queue);
 	put_disk(priv->gendisk);
@@ -570,7 +576,7 @@ static int ps3disk_remove(struct ps3_sys
 	ps3stor_teardown(dev);
 	kfree(dev->bounce_buf);
 	kfree(priv);
-	ps3disk_priv(dev) = NULL;
+	dev->sbd.core.driver_data = NULL;
 	return 0;
 }
 

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-2081383282-1184853258=:8661--
