From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/7] sd: add support for WRITE SAME (16) with unmap bit
Date: Sat, 29 Aug 2009 19:03:36 -0400
Message-ID: <20090829231121.713422216@bombadil.infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZH2XLV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2009 19:11:21 -0400
Content-Disposition: inline; filename=discard-add-scsi-write-same-support
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org

Add a prepare_discard function to sd that sends a WRITE SAME request with
the unmap bit set to the device if it advertises thin provisioning support.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c	2009-08-29 19:19:36.067371669 -0300
+++ linux-2.6/drivers/scsi/sd.c	2009-08-29 19:26:20.723754241 -0300
@@ -911,6 +911,50 @@ static void sd_prepare_flush(struct requ
 	rq->cmd_len = 10;
 }
 
+static int sd_prepare_discard(struct request_queue *q, struct request *rq,
+		struct bio *bio)
+{
+	struct scsi_device *sdp = q->queuedata;
+	struct page *page = alloc_page(GFP_KERNEL);
+
+	if (!page)
+		return -ENOMEM;
+
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->timeout = SD_TIMEOUT;
+	rq->cmd[0] = WRITE_SAME_16;
+	rq->cmd[1] = 0x8; /* UNMAP bit */
+	rq->cmd[2] = sizeof(bio->bi_sector) > 4 ?
+			(unsigned char) (bio->bi_sector >> 56) & 0xff : 0;
+	rq->cmd[3] = sizeof(bio->bi_sector) > 4 ?
+			(unsigned char) (bio->bi_sector >> 48) & 0xff : 0;
+	rq->cmd[4] = sizeof(bio->bi_sector) > 4 ?
+			(unsigned char) (bio->bi_sector >> 40) & 0xff : 0;
+	rq->cmd[5] = sizeof(bio->bi_sector) > 4 ?
+			(unsigned char) (bio->bi_sector >> 32) & 0xff : 0;
+	rq->cmd[6] = (unsigned char) (bio->bi_sector >> 24) & 0xff;
+	rq->cmd[7] = (unsigned char) (bio->bi_sector >> 16) & 0xff;
+	rq->cmd[8] = (unsigned char) (bio->bi_sector >> 8) & 0xff;
+	rq->cmd[9] = (unsigned char) bio->bi_sector & 0xff;
+	rq->cmd[10] = (unsigned char) (bio_sectors(bio) >> 24) & 0xff;
+	rq->cmd[11] = (unsigned char) (bio_sectors(bio) >> 16) & 0xff;
+	rq->cmd[12] = (unsigned char) (bio_sectors(bio) >> 8) & 0xff;
+	rq->cmd[13] = (unsigned char) bio_sectors(bio) & 0xff;
+	rq->cmd[14] = 0;
+	rq->cmd[15] = 0;
+	rq->cmd_len = 16;
+
+	printk(KERN_INFO "umap, lba = 0x%lld, len = %d\n",
+	       bio->bi_sector, bio_sectors(bio));
+
+	bio->bi_size = 0;
+	if (bio_add_pc_page(q, bio, page, sdp->sector_size, 0) <
+			sdp->sector_size)
+		return -EIO;
+
+	return 0;
+}
+
 static void sd_rescan(struct device *dev)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
@@ -1369,6 +1413,9 @@ static int read_capacity_16(struct scsi_
 		sd_printk(KERN_NOTICE, sdkp,
 			  "physical block alignment offset: %u\n", alignment);
 
+	if (buffer[14] & 0x80)
+		sdkp->thin_provisioning = 1;
+
 	sdkp->capacity = lba + 1;
 	return sector_size;
 }
@@ -1915,6 +1962,8 @@ static int sd_revalidate_disk(struct gen
 		ordered = QUEUE_ORDERED_DRAIN;
 
 	blk_queue_ordered(sdkp->disk->queue, ordered, sd_prepare_flush);
+	if (sdkp->thin_provisioning && !sdp->request_queue->prepare_discard_fn)
+		blk_queue_set_discard(sdkp->disk->queue, sd_prepare_discard);
 
 	set_capacity(disk, sdkp->capacity);
 	kfree(buffer);
Index: linux-2.6/include/scsi/scsi.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi.h	2009-08-29 19:19:36.079340649 -0300
+++ linux-2.6/include/scsi/scsi.h	2009-08-29 19:20:01.995378150 -0300
@@ -122,6 +122,8 @@ struct scsi_cmnd;
 #define READ_16               0x88
 #define WRITE_16              0x8a
 #define VERIFY_16	      0x8f
+#define WRITE_SAME_16	      0x93
+
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
Index: linux-2.6/drivers/scsi/sd.h
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.h	2009-08-29 19:19:36.071341377 -0300
+++ linux-2.6/drivers/scsi/sd.h	2009-08-29 19:20:01.995378150 -0300
@@ -55,6 +55,7 @@ struct scsi_disk {
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
 	unsigned	first_scan : 1;
+	unsigned	thin_provisioning : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 

