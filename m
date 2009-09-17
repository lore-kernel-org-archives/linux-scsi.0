From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] sd: add support for WRITE SAME (16) with unmap bit
Date: Thu, 17 Sep 2009 12:25:39 -0400
Message-ID: <20090917163105.685289349@bombadil.infradead.org>
References: <20090917162536.815743395@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59098 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbZIQQbD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 12:31:03 -0400
Content-Disposition: inline; filename=discard-add-scsi-write-same-support
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, matthew@wil.cx, dwmw2@infradead.org
Cc: linux-scsi@vger.kernel.org

Send  WRITE SAME request with the unmap bit set to the device if it
advertises thin provisioning support.  Still pretty hacky and not
actually looking at the INQUIRY data for the unmap parameters for
example.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c	2009-09-17 13:12:00.743253792 -0300
+++ linux-2.6/drivers/scsi/sd.c	2009-09-17 13:18:31.185005932 -0300
@@ -370,6 +370,35 @@ static void scsi_disk_put(struct scsi_di
 	mutex_unlock(&sd_ref_mutex);
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
@@ -389,6 +418,13 @@ static int sd_prep_fn(struct request_que
 	unsigned int this_count = blk_rq_sectors(rq);
 	int ret, host_dif;
 
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
@@ -396,6 +432,7 @@ static int sd_prep_fn(struct request_que
 		ret = BLKPREP_KILL;
 		goto out;
 	}
+
 	ret = scsi_setup_fs_cmnd(sdp, rq);
 	if (ret != BLKPREP_OK)
 		goto out;
@@ -1369,6 +1406,9 @@ static int read_capacity_16(struct scsi_
 		sd_printk(KERN_NOTICE, sdkp,
 			  "physical block alignment offset: %u\n", alignment);
 
+	if (buffer[14] & 0x80)
+		sdkp->thin_provisioning = 1;
+
 	sdkp->capacity = lba + 1;
 	return sector_size;
 }
@@ -1916,6 +1956,11 @@ static int sd_revalidate_disk(struct gen
 
 	blk_queue_ordered(sdkp->disk->queue, ordered, sd_prepare_flush);
 
+	if (sdkp->thin_provisioning) {
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, sdkp->disk->queue);
+		blk_queue_max_discard_sectors(sdp->request_queue, UINT_MAX);
+	}
+
 	set_capacity(disk, sdkp->capacity);
 	kfree(buffer);
 
Index: linux-2.6/include/scsi/scsi.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi.h	2009-09-17 13:12:00.756253702 -0300
+++ linux-2.6/include/scsi/scsi.h	2009-09-17 13:12:21.031004671 -0300
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
--- linux-2.6.orig/drivers/scsi/sd.h	2009-09-17 13:12:00.750254405 -0300
+++ linux-2.6/drivers/scsi/sd.h	2009-09-17 13:12:21.034025726 -0300
@@ -55,6 +55,7 @@ struct scsi_disk {
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
 	unsigned	first_scan : 1;
+	unsigned	thin_provisioning : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 

