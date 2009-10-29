From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] sd: add support for WRITE SAME (16) with unmap bit
Date: Thu, 29 Oct 2009 11:08:32 -0400
Message-ID: <20091029151127.656124850@bombadil.infradead.org>
References: <20091029150830.497006534@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbZJ2PLX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 11:11:23 -0400
Content-Disposition: inline; filename=discard-add-scsi-write-same-support
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mkp@mkp.net, axboe@kernel.dk, matthew@wil.cx

Send  WRITE SAME request with the unmap bit set to the device if it advertises
thin provisioning support. 


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c	2009-10-29 15:46:55.754006357 +0100
+++ linux-2.6/drivers/scsi/sd.c	2009-10-29 15:49:05.825279362 +0100
@@ -398,6 +398,35 @@ static void sd_prot_op(struct scsi_cmnd 
 	scsi_set_prot_type(scmd, dif);
 }
 
+static void sd_prepare_discard(struct request_queue *q, struct request *rq)
+{
+	struct bio *bio = rq->bio;
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
+}
+
 /**
  *	sd_init_command - build a scsi (read or write) command from
  *	information in the request structure.
@@ -418,6 +447,13 @@ static int sd_prep_fn(struct request_que
 	int ret, host_dif;
 	unsigned char protect;
 
+	/*
+	 * Discard request come in as REQ_TYPE_FS but we turn them into
+	 * block PC requests to make life easier.
+	 */
+	if (blk_discard_rq(rq))
+		sd_prepare_discard(q, rq);
+
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 		goto out;
@@ -425,6 +461,7 @@ static int sd_prep_fn(struct request_que
 		ret = BLKPREP_KILL;
 		goto out;
 	}
+
 	ret = scsi_setup_fs_cmnd(sdp, rq);
 	if (ret != BLKPREP_OK)
 		goto out;
@@ -1432,6 +1469,9 @@ static int read_capacity_16(struct scsi_
 		sd_printk(KERN_NOTICE, sdkp,
 			  "physical block alignment offset: %u\n", alignment);
 
+	if (buffer[14] & 0x80)
+		sdkp->thin_provisioning = 1;
+
 	sdkp->capacity = lba + 1;
 	return sector_size;
 }
@@ -1877,6 +1917,17 @@ static void sd_read_block_limits(struct 
 	blk_queue_io_opt(sdkp->disk->queue,
 			 get_unaligned_be32(&buffer[12]) * sector_sz);
 
+	if (sdkp->thin_provisioning) {
+		sdkp->disk->queue->limits.discard_granularity =
+			get_unaligned_be32(&buffer[28]);
+
+		if (buffer[32] & 0x80) {
+			buffer[32] &= ~0x80;
+			sdkp->disk->queue->limits.discard_alignment =
+				get_unaligned_be32(&buffer[32]);
+		}
+	}
+
 	kfree(buffer);
 }
 
@@ -1979,6 +2030,11 @@ static int sd_revalidate_disk(struct gen
 
 	blk_queue_ordered(sdkp->disk->queue, ordered, sd_prepare_flush);
 
+	if (sdkp->thin_provisioning) {
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, sdkp->disk->queue);
+		blk_queue_max_discard_sectors(sdp->request_queue, UINT_MAX);
+	}
+
 	set_capacity(disk, sdkp->capacity);
 	kfree(buffer);
 
Index: linux-2.6/drivers/scsi/sd.h
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.h	2009-10-29 15:49:00.890254050 +0100
+++ linux-2.6/drivers/scsi/sd.h	2009-10-29 15:49:05.826278860 +0100
@@ -60,6 +60,7 @@ struct scsi_disk {
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
 	unsigned	first_scan : 1;
+	unsigned	thin_provisioning : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 

