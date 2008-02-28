From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] block: fix residual byte count handling
Date: Thu, 28 Feb 2008 17:50:14 +0900
Message-ID: <47C675C6.8000904@gmail.com>
References: <1203583379.6244.27.camel@homer.simson.net>	 <20080222073228.GZ23197@kernel.dk>	 <1203752563.5225.4.camel@homer.simson.net>	 <1203839683.17463.9.camel@homer.simson.net>	 <1204019283.8731.11.camel@homer.simson.net>	 <1204033003.11828.22.camel@homer.simson.net>	 <20080226150845.2196bc1a.akpm@linux-foundation.org>	 <1204079075.26640.8.camel@homer.simson.net>	 <1204092010.9934.31.camel@homer.simson.net>	 <1204096025.1623.9.camel@homer.simson.net>  <47C6661E.9010504@gmail.com> <1204186800.7362.7.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:26227 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYB1IuX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Feb 2008 03:50:23 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2075495rvb.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Feb 2008 00:50:22 -0800 (PST)
In-Reply-To: <1204186800.7362.7.camel@homer.simson.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>

rq->raw_data_len introduced for block layer padding and draining
(commit 6b00769fe1502b4ad97bb327ef7ac971b208bfb5) broke residual byte
count handling.  Block drivers modify rq->data_len to notify residual
byte count to the block layer which blindly reported unmodified
rq->raw_data_len to userland.

To keep block drivers dealing only with rq->data_len, this should be
handled inside block layer.  However, how much extra buffer was
appened is lost after rq->data_len is modified.

This patch replaces rq->raw_data_len with rq->extra_len and add
blk_rq_raw_data_len() helper to calculate raw data size from
rq->data_len and rq->extra_len.  The helper returns correct raw
residual byte count when called on a rq whose data_len is modified to
carry residual byte count.

This problem was reported and diagnosed by Mike Galbraith.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 block/blk-core.c          |    3 +--
 block/blk-map.c           |    2 +-
 block/blk-merge.c         |    1 +
 block/bsg.c               |    8 ++++----
 block/scsi_ioctl.c        |    4 ++--
 drivers/ata/libata-scsi.c |    3 ++-
 include/linux/blkdev.h    |    8 +++++++-
 7 files changed, 18 insertions(+), 11 deletions(-)
diff --git a/block/blk-core.c b/block/blk-core.c
index 775c851..929ab61 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -127,7 +127,7 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->nr_hw_segments = 0;
 	rq->ioprio = 0;
 	rq->special = NULL;
-	rq->raw_data_len = 0;
+	rq->extra_len = 0;
 	rq->buffer = NULL;
 	rq->tag = -1;
 	rq->errors = 0;
@@ -2016,7 +2016,6 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->buffer = bio_data(bio);
-	rq->raw_data_len = bio->bi_size;
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
diff --git a/block/blk-map.c b/block/blk-map.c
index 09f7fd0..c67a75f 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -19,7 +19,6 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
-		rq->raw_data_len += bio->bi_size;
 		rq->data_len += bio->bi_size;
 	}
 	return 0;
@@ -156,6 +155,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
 		bio->bi_size += pad_len;
 		rq->data_len += pad_len;
+		rq->extra_len += pad_len;
 	}
 
 	rq->buffer = rq->data = NULL;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 7506c4f..efb5b4d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -232,6 +232,7 @@ new_segment:
 			    (PAGE_SIZE - 1));
 		nsegs++;
 		rq->data_len += q->dma_drain_size;
+		rq->extra_len += q->dma_drain_size;
 	}
 
 	if (sg)
diff --git a/block/bsg.c b/block/bsg.c
index 7f3c095..81b2133 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -437,14 +437,14 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	}
 
 	if (rq->next_rq) {
-		hdr->dout_resid = rq->raw_data_len;
-		hdr->din_resid = rq->next_rq->raw_data_len;
+		hdr->dout_resid = blk_rq_raw_data_len(rq);
+		hdr->din_resid = blk_rq_raw_data_len(rq->next_rq);
 		blk_rq_unmap_user(bidi_bio);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
-		hdr->din_resid = rq->raw_data_len;
+		hdr->din_resid = blk_rq_raw_data_len(rq);
 	else
-		hdr->dout_resid = rq->raw_data_len;
+		hdr->dout_resid = blk_rq_raw_data_len(rq);
 
 	/*
 	 * If the request generated a negative error number, return it
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index e993cac..32424b3 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -266,7 +266,7 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->resid = rq->raw_data_len;
+	hdr->resid = blk_rq_raw_data_len(rq);
 	hdr->sb_len_wr = 0;
 
 	if (rq->sense_len && hdr->sbp) {
@@ -528,8 +528,8 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->data = NULL;
-	rq->raw_data_len = 0;
 	rq->data_len = 0;
+	rq->extra_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->cmd[0] = cmd;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0562b0a..5cab84c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2539,7 +2539,8 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	 * want to set it properly, and for DMA where it is
 	 * effectively meaningless.
 	 */
-	nbytes = min(scmd->request->raw_data_len, (unsigned int)63 * 1024);
+	nbytes = min(blk_rq_raw_data_len(scmd->request),
+		     (unsigned int)63 * 1024);
 
 	/* Most ATAPI devices which honor transfer chunk size don't
 	 * behave according to the spec when odd chunk size which
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6fe67d1..917b97f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -216,8 +216,8 @@ struct request {
 	unsigned int cmd_len;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	unsigned int raw_data_len;
 	unsigned int data_len;
+	unsigned int extra_len;	/* length of alignment and padding */
 	unsigned int sense_len;
 	void *data;
 	void *sense;
@@ -477,6 +477,12 @@ enum {
 
 #define rq_data_dir(rq)		((rq)->cmd_flags & 1)
 
+/* data_len of the request sans extra stuff for alignment and padding */
+static inline unsigned int blk_rq_raw_data_len(struct request *rq)
+{
+	return rq->data_len - min(rq->extra_len, rq->data_len);
+}
+
 /*
  * We regard a request as sync, if it's a READ or a SYNC write.
  */
