From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Limit transfer length
Date: Mon, 02 Jun 2014 15:11:57 -0400
Message-ID: <yq17g4z86te.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25493 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaFBTMQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 15:12:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>


Until now the per-command transfer length has exclusively been gated by
the max_sectors parameter in the scsi_host template. Given that the size
of this parameter has been bumped to an unsigned int we have to be
careful not to exceed the target device's capabilities.

If the if the device specifies a Maximum Transfer Length in the Block
Limits VPD we'll use that value. Otherwise we'll use 0xffffffff for
devices that have use_16_for_rw set and 0xffff for the rest. We then
combine the chosen disk limit with max_sectors in the host template. The
smaller of the two will be used to set the max_hw_sectors queue limit.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 321faf603035..56018f37518d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2228,7 +2228,11 @@ got_data:
 		}
 	}
 
-	sdp->use_16_for_rw = (sdkp->capacity > 0xffffffff);
+	if (sdkp->capacity > 0xffffffff) {
+		sdp->use_16_for_rw = 1;
+		sdkp->max_xfer_blocks = SD_MAX_XFER_BLOCKS;
+	} else
+		sdkp->max_xfer_blocks = SD_DEF_XFER_BLOCKS;
 
 	/* Rescale capacity to 512-byte units */
 	if (sector_size == 4096)
@@ -2540,6 +2544,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
 	unsigned int sector_sz = sdkp->device->sector_size;
 	const int vpd_len = 64;
+	u32 max_xfer_length;
 	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
 
 	if (!buffer ||
@@ -2547,6 +2552,10 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	    scsi_get_vpd_page(sdkp->device, 0xb0, buffer, vpd_len))
 		goto out;
 
+	max_xfer_length = get_unaligned_be32(&buffer[8]);
+	if (max_xfer_length)
+		sdkp->max_xfer_blocks = max_xfer_length;
+
 	blk_queue_io_min(sdkp->disk->queue,
 			 get_unaligned_be16(&buffer[6]) * sector_sz);
 	blk_queue_io_opt(sdkp->disk->queue,
@@ -2702,6 +2711,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct scsi_device *sdp = sdkp->device;
 	unsigned char *buffer;
 	unsigned flush = 0;
+	unsigned int max_xfer;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -2755,6 +2765,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	blk_queue_flush(sdkp->disk->queue, flush);
 
+	max_xfer = min_not_zero((unsigned int)sdp->host->max_sectors,
+				(unsigned int)sdkp->max_xfer_blocks);
+	max_xfer <<= ilog2(sdp->sector_size) - 9;
+	blk_queue_max_hw_sectors(sdkp->disk->queue, max_xfer);
 	set_capacity(disk, sdkp->capacity);
 	sd_config_write_same(sdkp);
 	kfree(buffer);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 620871efbf0a..4c3ab8377fd3 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -44,6 +44,8 @@ enum {
 };
 
 enum {
+	SD_DEF_XFER_BLOCKS = 0xffff,
+	SD_MAX_XFER_BLOCKS = 0xffffffff,
 	SD_MAX_WS10_BLOCKS = 0xffff,
 	SD_MAX_WS16_BLOCKS = 0x7fffff,
 };
@@ -64,6 +66,7 @@ struct scsi_disk {
 	struct gendisk	*disk;
 	atomic_t	openers;
 	sector_t	capacity;	/* size in 512-byte sectors */
+	u32		max_xfer_blocks;
 	u32		max_ws_blocks;
 	u32		max_unmap_blocks;
 	u32		unmap_granularity;
