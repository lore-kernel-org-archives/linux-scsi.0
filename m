From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] block: drop request->hard_* and *nr_sectors
Date: Wed, 29 Apr 2009 18:13:45 +0900
Message-ID: <1240996428-10159-8-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:56410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbZD2JSf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2009 05:18:35 -0400
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko
Cc: Tejun Heo <tj@kernel.org>

struct request has had a few different ways to represent some
properties of a request.  ->hard_* represent block layer's view of the
request progress (completion cursor) and the ones without the prefix
are supposed to represent the issue cursor and allowed to be updated
as necessary by the low level drivers.  The thing is that as block
layer supports partial completion, the two cursors really aren't
necessary and only cause confusion.  In addition, manual management of
request detail from low level drivers is cumbersome and error-prone at
the very least.

Another interesting duplicate fields are rq->[hard_]nr_sectors and
rq->{hard_cur|current}_nr_sectors against rq->data_len and
rq->bio->bi_size.  This is more convoluted than the hard_ case.

rq->[hard_]nr_sectors are initialized for requests with bio but
blk_rq_bytes() uses it only for !pc requests.  rq->data_len is
initialized for all request but blk_rq_bytes() uses it only for pc
requests.  This causes good amount of confusion throughout block layer
and its drivers and determining the request length has been a bit of
black magic which may or may not work depending on circumstances and
what the specific LLD is actually doing.

rq->{hard_cur|current}_nr_sectors represent the number of sectors in
the contiguous data area at the front.  This is mainly used by drivers
which transfers data by walking request segment-by-segment.  This
value always equals rq->bio->bi_size >> 9.  However, data length for
pc requests may not be multiple of 512 bytes and using this field
becomes a bit confusing.

In general, having multiple fields to represent the same property
leads only to confusion and subtle bugs.  With recent block low level
driver cleanups, no driver is accessing or manipulating these
duplicate fields directly.  Drop all the duplicates.  Now rq->sector
means the current sector, rq->data_len the current total length and
rq->bio->bi_size the current segment length.  Everything else is
defined in terms of these three and available only through accessors.

* blk_recalc_rq_sectors() is collapsed into blk_update_request() and
  now handles pc and fs requests equally other than rq->sector update.
  This means that now pc requests can use partial completion too (no
  in-kernel user yet tho).

* bio_cur_sectors() is replaced with bio_cur_bytes() as block layer
  now uses byte count as the primary data length.

* blk_rq_pos() is now guranteed to be always correct.  In-block users
  converted.

* blk_rq_bytes() is now guaranteed to be always valid as is
  blk_rq_sectors().  In-block users converted.

* blk_rq_sectors() is now guaranteed to equal blk_rq_bytes() >> 9.
  More convenient one is used.

[ Impact: API cleanup, single way to represent one property of a request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c         |   81 +++++++++++++++++-----------------------------
 block/blk-merge.c        |   36 ++------------------
 block/blk.h              |    1 -
 block/cfq-iosched.c      |   10 +++---
 include/linux/bio.h      |    6 ++--
 include/linux/blkdev.h   |   37 +++++++++------------
 include/linux/elevator.h |    2 +-
 kernel/trace/blktrace.c  |   16 ++++----
 8 files changed, 67 insertions(+), 122 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 82dc206..3596ca7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -127,7 +127,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	INIT_LIST_HEAD(&rq->timeout_list);
 	rq->cpu = -1;
 	rq->q = q;
-	rq->sector = rq->hard_sector = (sector_t) -1;
+	rq->sector = (sector_t) -1;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->cmd = rq->__cmd;
@@ -189,8 +189,7 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 	       (unsigned long long)blk_rq_pos(rq),
 	       blk_rq_sectors(rq), blk_rq_cur_sectors(rq));
 	printk(KERN_INFO "  bio %p, biotail %p, buffer %p, len %u\n",
-						rq->bio, rq->biotail,
-						rq->buffer, rq->data_len);
+	       rq->bio, rq->biotail, rq->buffer, blk_rq_bytes(rq));
 
 	if (blk_pc_request(rq)) {
 		printk(KERN_INFO "  cdb: ");
@@ -1096,7 +1095,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 		req->cmd_flags |= REQ_NOIDLE;
 
 	req->errors = 0;
-	req->hard_sector = req->sector = bio->bi_sector;
+	req->sector = bio->bi_sector;
 	req->ioprio = bio_prio(bio);
 	blk_rq_bio_prep(req->q, req, bio);
 }
@@ -1113,14 +1112,13 @@ static inline bool queue_should_plug(struct request_queue *q)
 static int __make_request(struct request_queue *q, struct bio *bio)
 {
 	struct request *req;
-	int el_ret, nr_sectors;
+	int el_ret;
+	unsigned int bytes = bio->bi_size;
 	const unsigned short prio = bio_prio(bio);
 	const int sync = bio_sync(bio);
 	const int unplug = bio_unplug(bio);
 	int rw_flags;
 
-	nr_sectors = bio_sectors(bio);
-
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
@@ -1145,7 +1143,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 
 		req->biotail->bi_next = bio;
 		req->biotail = bio;
-		req->nr_sectors = req->hard_nr_sectors += nr_sectors;
+		req->data_len += bytes;
 		req->ioprio = ioprio_best(req->ioprio, prio);
 		if (!blk_rq_cpu_valid(req))
 			req->cpu = bio->bi_comp_cpu;
@@ -1171,10 +1169,8 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 		 * not touch req->buffer either...
 		 */
 		req->buffer = bio_data(bio);
-		req->current_nr_sectors = bio_cur_sectors(bio);
-		req->hard_cur_sectors = req->current_nr_sectors;
-		req->sector = req->hard_sector = bio->bi_sector;
-		req->nr_sectors = req->hard_nr_sectors += nr_sectors;
+		req->sector = bio->bi_sector;
+		req->data_len += bytes;
 		req->ioprio = ioprio_best(req->ioprio, prio);
 		if (!blk_rq_cpu_valid(req))
 			req->cpu = bio->bi_comp_cpu;
@@ -1557,7 +1553,7 @@ EXPORT_SYMBOL(submit_bio);
 int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 {
 	if (blk_rq_sectors(rq) > q->max_sectors ||
-	    rq->data_len > q->max_hw_sectors << 9) {
+	    blk_rq_bytes(rq) > q->max_hw_sectors << 9) {
 		printk(KERN_ERR "%s: over max size limit.\n", __func__);
 		return -EIO;
 	}
@@ -1675,35 +1671,6 @@ static void blk_account_io_done(struct request *req)
 	}
 }
 
-/**
- * blk_rq_bytes - Returns bytes left to complete in the entire request
- * @rq: the request being processed
- **/
-unsigned int blk_rq_bytes(struct request *rq)
-{
-	if (blk_fs_request(rq))
-		return blk_rq_sectors(rq) << 9;
-
-	return rq->data_len;
-}
-EXPORT_SYMBOL_GPL(blk_rq_bytes);
-
-/**
- * blk_rq_cur_bytes - Returns bytes left to complete in the current segment
- * @rq: the request being processed
- **/
-unsigned int blk_rq_cur_bytes(struct request *rq)
-{
-	if (blk_fs_request(rq))
-		return rq->current_nr_sectors << 9;
-
-	if (rq->bio)
-		return rq->bio->bi_size;
-
-	return rq->data_len;
-}
-EXPORT_SYMBOL_GPL(blk_rq_cur_bytes);
-
 struct request *elv_next_request(struct request_queue *q)
 {
 	struct request *rq;
@@ -1736,7 +1703,7 @@ struct request *elv_next_request(struct request_queue *q)
 		if (rq->cmd_flags & REQ_DONTPREP)
 			break;
 
-		if (q->dma_drain_size && rq->data_len) {
+		if (q->dma_drain_size && blk_rq_bytes(rq)) {
 			/*
 			 * make sure space for the drain appears we
 			 * know we can do this because max_hw_segments
@@ -1759,7 +1726,7 @@ struct request *elv_next_request(struct request_queue *q)
 			 * avoid resource deadlock.  REQ_STARTED will
 			 * prevent other fs requests from passing this one.
 			 */
-			if (q->dma_drain_size && rq->data_len &&
+			if (q->dma_drain_size && blk_rq_bytes(rq) &&
 			    !(rq->cmd_flags & REQ_DONTPREP)) {
 				/*
 				 * remove the space for the drain we added
@@ -1911,8 +1878,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		 * can find how many bytes remain in the request
 		 * later.
 		 */
-		req->nr_sectors = req->hard_nr_sectors = 0;
-		req->current_nr_sectors = req->hard_cur_sectors = 0;
+		req->data_len = 0;
 		return false;
 	}
 
@@ -1926,8 +1892,25 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		bio_iovec(bio)->bv_len -= nr_bytes;
 	}
 
-	blk_recalc_rq_sectors(req, total_bytes >> 9);
+	req->data_len -= total_bytes;
+	req->buffer = bio_data(req->bio);
+
+	/* update sector only for requests with clear definition of sector */
+	if (blk_fs_request(req) || blk_discard_rq(req))
+		req->sector += total_bytes >> 9;
+
+	/*
+	 * If total number of sectors is less than the first segment
+	 * size, something has gone terribly wrong.
+	 */
+	if (blk_rq_bytes(req) < blk_rq_cur_bytes(req)) {
+		printk(KERN_ERR "blk: request botched\n");
+		req->data_len = blk_rq_cur_bytes(req);
+	}
+
+	/* recalculate the number of segments */
 	blk_recalc_rq_segments(req);
+
 	return true;
 }
 EXPORT_SYMBOL_GPL(blk_update_request);
@@ -2049,11 +2032,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		rq->nr_phys_segments = bio_phys_segments(q, bio);
 		rq->buffer = bio_data(bio);
 	}
-	rq->current_nr_sectors = bio_cur_sectors(bio);
-	rq->hard_cur_sectors = rq->current_nr_sectors;
-	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->data_len = bio->bi_size;
-
 	rq->bio = rq->biotail = bio;
 
 	if (bio->bi_bdev)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index bf62a87..b8df66a 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -9,35 +9,6 @@
 
 #include "blk.h"
 
-void blk_recalc_rq_sectors(struct request *rq, int nsect)
-{
-	if (blk_fs_request(rq) || blk_discard_rq(rq)) {
-		rq->hard_sector += nsect;
-		rq->hard_nr_sectors -= nsect;
-
-		/*
-		 * Move the I/O submission pointers ahead if required.
-		 */
-		if ((rq->nr_sectors >= rq->hard_nr_sectors) &&
-		    (rq->sector <= rq->hard_sector)) {
-			rq->sector = rq->hard_sector;
-			rq->nr_sectors = rq->hard_nr_sectors;
-			rq->hard_cur_sectors = bio_cur_sectors(rq->bio);
-			rq->current_nr_sectors = rq->hard_cur_sectors;
-			rq->buffer = bio_data(rq->bio);
-		}
-
-		/*
-		 * if total number of sectors is less than the first segment
-		 * size, something has gone terribly wrong
-		 */
-		if (rq->nr_sectors < rq->current_nr_sectors) {
-			printk(KERN_ERR "blk: request botched\n");
-			rq->nr_sectors = rq->current_nr_sectors;
-		}
-	}
-}
-
 static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio)
 {
@@ -199,8 +170,9 @@ new_segment:
 
 
 	if (unlikely(rq->cmd_flags & REQ_COPY_USER) &&
-	    (rq->data_len & q->dma_pad_mask)) {
-		unsigned int pad_len = (q->dma_pad_mask & ~rq->data_len) + 1;
+	    (blk_rq_bytes(rq) & q->dma_pad_mask)) {
+		unsigned int pad_len =
+			(q->dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
 
 		sg->length += pad_len;
 		rq->extra_len += pad_len;
@@ -398,7 +370,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	req->biotail->bi_next = next->bio;
 	req->biotail = next->biotail;
 
-	req->nr_sectors = req->hard_nr_sectors += next->hard_nr_sectors;
+	req->data_len += blk_rq_bytes(next);
 
 	elv_merge_requests(q, req, next);
 
diff --git a/block/blk.h b/block/blk.h
index 5111559..ab54529 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -101,7 +101,6 @@ int ll_front_merge_fn(struct request_queue *q, struct request *req,
 int attempt_back_merge(struct request_queue *q, struct request *rq);
 int attempt_front_merge(struct request_queue *q, struct request *rq);
 void blk_recalc_rq_segments(struct request *rq);
-void blk_recalc_rq_sectors(struct request *rq, int nsect);
 
 void blk_queue_congestion_threshold(struct request_queue *q);
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index db4d990..99ac430 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -579,9 +579,9 @@ cfq_prio_tree_lookup(struct cfq_data *cfqd, struct rb_root *root,
 		 * Sort strictly based on sector.  Smallest to the left,
 		 * largest to the right.
 		 */
-		if (sector > cfqq->next_rq->sector)
+		if (sector > blk_rq_pos(cfqq->next_rq))
 			n = &(*p)->rb_right;
-		else if (sector < cfqq->next_rq->sector)
+		else if (sector < blk_rq_pos(cfqq->next_rq))
 			n = &(*p)->rb_left;
 		else
 			break;
@@ -611,8 +611,8 @@ static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		return;
 
 	cfqq->p_root = &cfqd->prio_trees[cfqq->org_ioprio];
-	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->p_root, cfqq->next_rq->sector,
-					 &parent, &p);
+	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->p_root,
+				      blk_rq_pos(cfqq->next_rq), &parent, &p);
 	if (!__cfqq) {
 		rb_link_node(&cfqq->p_node, parent, p);
 		rb_insert_color(&cfqq->p_node, cfqq->p_root);
@@ -996,7 +996,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
 	if (cfq_rq_close(cfqd, __cfqq->next_rq))
 		return __cfqq;
 
-	if (__cfqq->next_rq->sector < sector)
+	if (blk_rq_pos(__cfqq->next_rq) < sector)
 		node = rb_next(&__cfqq->p_node);
 	else
 		node = rb_prev(&__cfqq->p_node);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index f37ca8c..d30ec6f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -218,12 +218,12 @@ struct bio {
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
 #define bio_empty_barrier(bio)	(bio_barrier(bio) && !bio_has_data(bio) && !bio_discard(bio))
 
-static inline unsigned int bio_cur_sectors(struct bio *bio)
+static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
 	if (bio->bi_vcnt)
-		return bio_iovec(bio)->bv_len >> 9;
+		return bio_iovec(bio)->bv_len;
 	else /* dataless requests such as discard */
-		return bio->bi_size >> 9;
+		return bio->bi_size;
 }
 
 static inline void *bio_data(struct bio *bio)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1e18ef7..943cbfe 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -166,19 +166,8 @@ struct request {
 	enum rq_cmd_type_bits cmd_type;
 	unsigned long atomic_flags;
 
-	/* Maintain bio traversal state for part by part I/O submission.
-	 * hard_* are block layer internals, no driver should touch them!
-	 */
-
-	sector_t sector;		/* next sector to submit */
-	sector_t hard_sector;		/* next sector to complete */
-	unsigned long nr_sectors;	/* no. of sectors left to submit */
-	unsigned long hard_nr_sectors;	/* no. of sectors left to complete */
-	/* no. of sectors left to submit in the current segment */
-	unsigned int current_nr_sectors;
-
-	/* no. of sectors left to complete in the current segment */
-	unsigned int hard_cur_sectors;
+	sector_t sector;	/* sector cursor */
+	unsigned int data_len;	/* total data len, don't access directly */
 
 	struct bio *bio;
 	struct bio *biotail;
@@ -226,7 +215,6 @@ struct request {
 	unsigned char __cmd[BLK_MAX_CDB];
 	unsigned char *cmd;
 
-	unsigned int data_len;
 	unsigned int extra_len;	/* length of alignment and padding */
 	unsigned int sense_len;
 	unsigned int resid_len;	/* residual count */
@@ -840,20 +828,27 @@ extern void blkdev_dequeue_request(struct request *req);
  */
 static inline sector_t blk_rq_pos(struct request *rq)
 {
-	return rq->hard_sector;
+	return rq->sector;
+}
+
+static inline unsigned int blk_rq_bytes(struct request *rq)
+{
+	return rq->data_len;
 }
 
-extern unsigned int blk_rq_bytes(struct request *rq);
-extern unsigned int blk_rq_cur_bytes(struct request *rq);
+static inline int blk_rq_cur_bytes(struct request *rq)
+{
+	return rq->bio ? bio_cur_bytes(rq->bio) : 0;
+}
 
 static inline unsigned int blk_rq_sectors(struct request *rq)
 {
-	return rq->hard_nr_sectors;
+	return blk_rq_bytes(rq) >> 9;
 }
 
 static inline unsigned int blk_rq_cur_sectors(struct request *rq)
 {
-	return rq->hard_cur_sectors;
+	return blk_rq_cur_bytes(rq) >> 9;
 }
 
 /*
@@ -928,7 +923,7 @@ static inline void blk_end_request_all(struct request *rq, int error)
  */
 static inline bool blk_end_request_cur(struct request *rq, int error)
 {
-	return blk_end_request(rq, error, rq->hard_cur_sectors << 9);
+	return blk_end_request(rq, error, blk_rq_cur_bytes(rq));
 }
 
 /**
@@ -981,7 +976,7 @@ static inline void __blk_end_request_all(struct request *rq, int error)
  */
 static inline bool __blk_end_request_cur(struct request *rq, int error)
 {
-	return __blk_end_request(rq, error, rq->hard_cur_sectors << 9);
+	return __blk_end_request(rq, error, blk_rq_cur_bytes(rq));
 }
 
 extern void blk_complete_request(struct request *);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index c59b769..4e46287 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -171,7 +171,7 @@ enum {
 	ELV_MQUEUE_MUST,
 };
 
-#define rq_end_sector(rq)	((rq)->sector + (rq)->nr_sectors)
+#define rq_end_sector(rq)	(blk_rq_pos(rq) + blk_rq_sectors(rq))
 #define rb_entry_rq(node)	rb_entry((node), struct request, rb_node)
 
 /*
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 42f1c11..5708a14 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -642,12 +642,12 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 
 	if (blk_pc_request(rq)) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
-		__blk_add_trace(bt, 0, rq->data_len, rw, what, rq->errors,
-				rq->cmd_len, rq->cmd);
+		__blk_add_trace(bt, 0, blk_rq_bytes(rq), rw,
+				what, rq->errors, rq->cmd_len, rq->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
-		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_sectors(rq) << 9,
-				rw, what, rq->errors, 0, NULL);
+		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq), rw,
+				what, rq->errors, 0, NULL);
 	}
 }
 
@@ -854,11 +854,11 @@ void blk_add_driver_data(struct request_queue *q,
 		return;
 
 	if (blk_pc_request(rq))
-		__blk_add_trace(bt, 0, rq->data_len, 0, BLK_TA_DRV_DATA,
-				rq->errors, len, data);
+		__blk_add_trace(bt, 0, blk_rq_bytes(rq), 0,
+				BLK_TA_DRV_DATA, rq->errors, len, data);
 	else
-		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_sectors(rq) << 9,
-				0, BLK_TA_DRV_DATA, rq->errors, len, data);
+		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq), 0,
+				BLK_TA_DRV_DATA, rq->errors, len, data);
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
 
-- 
1.6.0.2

