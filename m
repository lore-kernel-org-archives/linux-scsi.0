From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] scsi: build flush requests via q->prep_rq_fn
Date: Fri,  2 Jul 2010 16:33:25 +0900
Message-ID: <1278056005-25438-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de, axboe@kernel.dk
Cc: hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

scsi-ml builds flush requests via q->prepare_flush_fn(), however,
builds discard requests via q->prep_rq_fn.

Using two different mechnisms for the similar requests (building
commands in SCSI ULD) doesn't make sense.

Handing both via q->prep_rq_fn makes the code design simpler.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-barrier.c |   10 +++-------
 drivers/scsi/sd.c   |   26 ++++++++++++++++----------
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index a348242..41e1740 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -25,12 +25,6 @@
 int blk_queue_ordered(struct request_queue *q, unsigned ordered,
 		      prepare_flush_fn *prepare_flush_fn)
 {
-	if (!prepare_flush_fn && (ordered & (QUEUE_ORDERED_DO_PREFLUSH |
-					     QUEUE_ORDERED_DO_POSTFLUSH))) {
-		printk(KERN_ERR "%s: prepare_flush_fn required\n", __func__);
-		return -EINVAL;
-	}
-
 	if (ordered != QUEUE_ORDERED_NONE &&
 	    ordered != QUEUE_ORDERED_DRAIN &&
 	    ordered != QUEUE_ORDERED_DRAIN_FLUSH &&
@@ -146,7 +140,9 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	rq->cmd_flags = REQ_HARDBARRIER | REQ_FLUSH;
 	rq->rq_disk = q->bar_rq.rq_disk;
 	rq->end_io = end_io;
-	q->prepare_flush_fn(q, rq);
+
+	if (q->prepare_flush_fn)
+		q->prepare_flush_fn(q, rq);
 
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aa6b48b..e8c295e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -471,6 +471,18 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	return ret;
 }
 
+static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
+{
+	/* for now, we use REQ_TYPE_BLOCK_PC. */
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->timeout = SD_TIMEOUT;
+	rq->retries = SD_MAX_RETRIES;
+	rq->cmd[0] = SYNCHRONIZE_CACHE;
+	rq->cmd_len = 10;
+
+	return scsi_setup_blk_pc_cmnd(sdp, rq);
+}
+
 static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 {
 	if (rq->cmd_flags & REQ_DISCARD)
@@ -504,6 +516,9 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	if (rq->cmd_flags & REQ_DISCARD) {
 		ret = scsi_setup_discard_cmnd(sdp, rq);
 		goto out;
+	} else if (rq->cmd_flags & REQ_FLUSH) {
+		ret = scsi_setup_flush_cmnd(sdp, rq);
+		goto out;
 	} else if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 		goto out;
@@ -1053,15 +1068,6 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 	return 0;
 }
 
-static void sd_prepare_flush(struct request_queue *q, struct request *rq)
-{
-	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->timeout = SD_TIMEOUT;
-	rq->retries = SD_MAX_RETRIES;
-	rq->cmd[0] = SYNCHRONIZE_CACHE;
-	rq->cmd_len = 10;
-}
-
 static void sd_rescan(struct device *dev)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
@@ -2129,7 +2135,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	else
 		ordered = QUEUE_ORDERED_DRAIN;
 
-	blk_queue_ordered(sdkp->disk->queue, ordered, sd_prepare_flush);
+	blk_queue_ordered(sdkp->disk->queue, ordered, NULL);
 
 	set_capacity(disk, sdkp->capacity);
 	kfree(buffer);
-- 
1.6.5
