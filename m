From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 3/7] block: add request->raw_data_len
Date: Sat,  9 Feb 2008 10:40:22 +0900
Message-ID: <12025212273391-git-send-email-htejun@gmail.com>
References: <12025212262892-git-send-email-htejun@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:57416 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbYBIBkg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 20:40:36 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2705691rvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Feb 2008 17:40:35 -0800 (PST)
In-Reply-To: <12025212262892-git-send-email-htejun@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
Cc: Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

With padding and draining moved into it, block layer now may extend
requests as directed by queue parameters, so now a request has two
sizes - the original request size and the extended size which matches
the size of area pointed to by bios and later by sgs.  The latter size
is what lower layers are primarily interested in when allocating,
filling up DMA tables and setting up the controller.

Both padding and draining extend the data area to accomodate
controller characteristics.  As any controller which speaks SCSI can
handle underflows, feeding larger data area is safe.

So, this patch makes the primary data length field, request->data_len,
indicate the size of full data area and add a separate length field,
request->raw_data_len, for the unmodified request size.  The latter is
used to report to higher layer (userland) and where the original
request size should be fed to the controller or device.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/blk-core.c        |    2 ++
 block/blk-map.c         |    2 ++
 block/blk-merge.c       |    1 +
 block/bsg.c             |    8 ++++----
 block/scsi_ioctl.c      |    3 ++-
 drivers/scsi/scsi_lib.c |    8 ++++----
 include/linux/blkdev.h  |    1 +
 7 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4afb39c..8b004e1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -116,6 +116,7 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->ref_count = 1;
 	rq->q = q;
 	rq->special = NULL;
+	rq->raw_data_len = 0;
 	rq->data_len = 0;
 	rq->data = NULL;
 	rq->nr_phys_segments = 0;
@@ -1982,6 +1983,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->buffer = bio_data(bio);
+	rq->raw_data_len = bio->bi_size;
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
diff --git a/block/blk-map.c b/block/blk-map.c
index 103b1df..1588ea3 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -19,6 +19,7 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
+		rq->raw_data_len += bio->bi_size;
 		rq->data_len += bio->bi_size;
 	}
 	return 0;
@@ -154,6 +155,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 
 		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
 		bio->bi_size += pad_len;
+		rq->data_len += pad_len;
 	}
 
 	rq->buffer = rq->data = NULL;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 845ef81..480d2bc 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -228,6 +228,7 @@ new_segment:
 			    ((unsigned long)q->dma_drain_buffer) &
 			    (PAGE_SIZE - 1));
 		nsegs++;
+		rq->data_len += q->dma_drain_size;
 	}
 
 	if (sg)
diff --git a/block/bsg.c b/block/bsg.c
index 8917c51..7f3c095 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -437,14 +437,14 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	}
 
 	if (rq->next_rq) {
-		hdr->dout_resid = rq->data_len;
-		hdr->din_resid = rq->next_rq->data_len;
+		hdr->dout_resid = rq->raw_data_len;
+		hdr->din_resid = rq->next_rq->raw_data_len;
 		blk_rq_unmap_user(bidi_bio);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
-		hdr->din_resid = rq->data_len;
+		hdr->din_resid = rq->raw_data_len;
 	else
-		hdr->dout_resid = rq->data_len;
+		hdr->dout_resid = rq->raw_data_len;
 
 	/*
 	 * If the request generated a negative error number, return it
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 9675b34..e993cac 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -266,7 +266,7 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->resid = rq->data_len;
+	hdr->resid = rq->raw_data_len;
 	hdr->sb_len_wr = 0;
 
 	if (rq->sense_len && hdr->sbp) {
@@ -528,6 +528,7 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->data = NULL;
+	rq->raw_data_len = 0;
 	rq->data_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	memset(rq->cmd, 0, sizeof(rq->cmd));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f243fc3..afb2c9f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1015,10 +1015,6 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 	}
 
 	req->buffer = NULL;
-	if (blk_pc_request(req))
-		sdb->length = req->data_len;
-	else
-		sdb->length = req->nr_sectors << 9;
 
 	/* 
 	 * Next, walk the list, and fill in the addresses and sizes of
@@ -1027,6 +1023,10 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
 	BUG_ON(count > sdb->table.nents);
 	sdb->table.nents = count;
+	if (blk_pc_request(req))
+		sdb->length = req->data_len;
+	else
+		sdb->length = req->nr_sectors << 9;
 	return BLKPREP_OK;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 90392a9..ee0b021 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -214,6 +214,7 @@ struct request {
 	unsigned int cmd_len;
 	unsigned char cmd[BLK_MAX_CDB];
 
+	unsigned int raw_data_len;
 	unsigned int data_len;
 	unsigned int sense_len;
 	void *data;
-- 
1.5.2.4

