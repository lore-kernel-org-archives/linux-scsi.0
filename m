From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC PATCH 3/5] block: Export rq_init, rename to blk_init_rq
Date: Wed, 23 Apr 2008 18:05:06 +0300
Message-ID: <480F5022.8060404@panasas.com>
References: <480F4CC2.7070804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:1216 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751277AbYDWPGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Apr 2008 11:06:22 -0400
In-Reply-To: <480F4CC2.7070804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Pete Wyckoff <pw@osc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-ide <linux-ide@vger.kernel.org>


Export rq_init so code that allocates requests on stack or in private
structures can call it, and not mess with block internals.

Rename rq_init => blk_init_rq to be more consistent with blk's API
naming convention.

Also memset the full request structure so new members that are zero
need not be initialized at init function separately.

It used to be that cmd_flags was set before the call to rq_init()
so pass cmd_flags to blk_init_req, to simplify user code.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 block/blk-barrier.c    |    6 ++----
 block/blk-core.c       |   37 +++++--------------------------------
 block/blk.h            |    1 -
 include/linux/blkdev.h |    1 +
 4 files changed, 8 insertions(+), 37 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 55c5f1f..9eb5bd0 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -143,8 +143,7 @@ static void queue_flush(struct request_queue *q, unsigned which)
 		end_io = post_flush_end_io;
 	}
 
-	rq->cmd_flags = REQ_HARDBARRIER;
-	rq_init(q, rq);
+	blk_init_rq(q, rq, REQ_HARDBARRIER);
 	rq->elevator_private = NULL;
 	rq->elevator_private2 = NULL;
 	rq->rq_disk = q->bar_rq.rq_disk;
@@ -167,8 +166,7 @@ static inline struct request *start_ordered(struct request_queue *q,
 	blkdev_dequeue_request(rq);
 	q->orig_bar_rq = rq;
 	rq = &q->bar_rq;
-	rq->cmd_flags = 0;
-	rq_init(q, rq);
+	blk_init_rq(q, rq, 0);
 	if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
 		rq->cmd_flags |= REQ_RW;
 	if (q->ordered & QUEUE_ORDERED_FUA)
diff --git a/block/blk-core.c b/block/blk-core.c
index 6669238..ca103d1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -107,41 +107,20 @@ struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev)
 }
 EXPORT_SYMBOL(blk_get_backing_dev_info);
 
-/*
- * We can't just memset() the structure, since the allocation path
- * already stored some information in the request.
- */
-void rq_init(struct request_queue *q, struct request *rq)
+void blk_init_rq(struct request_queue *q, struct request *rq, int cmd_flags)
 {
+	memset(rq, 0, sizeof(*rq));
+	rq->cmd_flags = cmd_flags;
 	INIT_LIST_HEAD(&rq->queuelist);
 	INIT_LIST_HEAD(&rq->donelist);
 	rq->q = q;
 	rq->sector = rq->hard_sector = (sector_t) -1;
-	rq->nr_sectors = rq->hard_nr_sectors = 0;
-	rq->current_nr_sectors = rq->hard_cur_sectors = 0;
-	rq->bio = rq->biotail = NULL;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
-	rq->rq_disk = NULL;
-	rq->nr_phys_segments = 0;
-	rq->nr_hw_segments = 0;
-	rq->ioprio = 0;
-	rq->special = NULL;
-	rq->buffer = NULL;
 	rq->tag = -1;
-	rq->errors = 0;
 	rq->ref_count = 1;
-	rq->cmd_len = 0;
-	memset(rq->cmd, 0, BLK_MAX_CDB);
-	rq->data_len = 0;
-	rq->extra_len = 0;
-	rq->sense_len = 0;
-	rq->data = NULL;
-	rq->sense = NULL;
-	rq->end_io = NULL;
-	rq->end_io_data = NULL;
-	rq->next_rq = NULL;
 }
+EXPORT_SYMBOL(blk_init_rq);
 
 static void req_bio_endio(struct request *rq, struct bio *bio,
 			  unsigned int nbytes, int error)
@@ -607,11 +586,7 @@ blk_alloc_request(struct request_queue *q, int rw, int priv, gfp_t gfp_mask)
 	if (!rq)
 		return NULL;
 
-	/*
-	 * first three bits are identical in rq->cmd_flags and bio->bi_rw,
-	 * see bio.h and blkdev.h
-	 */
-	rq->cmd_flags = rw | REQ_ALLOCED;
+	blk_init_rq(q, rq, rw | REQ_ALLOCED);
 
 	if (priv) {
 		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
@@ -789,8 +764,6 @@ rq_starved:
 	if (ioc_batching(q, ioc))
 		ioc->nr_batch_requests--;
 
-	rq_init(q, rq);
-
 	blk_add_trace_generic(q, bio, rw, BLK_TA_GETRQ);
 out:
 	return rq;
diff --git a/block/blk.h b/block/blk.h
index ec9120f..59776ab 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -10,7 +10,6 @@
 extern struct kmem_cache *blk_requestq_cachep;
 extern struct kobj_type blk_queue_ktype;
 
-void rq_init(struct request_queue *q, struct request *rq);
 void init_request_from_bio(struct request *req, struct bio *bio);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c5065e3..7121783 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -596,6 +596,7 @@ extern int scsi_cmd_ioctl(struct file *, struct request_queue *,
 			  struct gendisk *, unsigned int, void __user *);
 extern int sg_scsi_ioctl(struct file *, struct request_queue *,
 		struct gendisk *, struct scsi_ioctl_command __user *);
+extern void blk_init_rq(struct request_queue *, struct request *, int);
 
 /*
  * Temporary export, until SCSI gets fixed up.
-- 
1.5.3.3

