From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/19] block: add a op_is_flush helper
Date: Fri, 27 Jan 2017 17:35:00 +0100
Message-ID: <1485534918-18239-2-git-send-email-hch@lst.de>
References: <1485534918-18239-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485534918-18239-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This centralizes the checks for bios that needs to be go into the flush
state machine.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-core.c             |  8 ++++----
 block/blk-mq-sched.c         |  5 ++---
 block/blk-mq.c               |  4 ++--
 drivers/md/bcache/request.c  |  2 +-
 drivers/md/dm-cache-target.c | 13 +++----------
 drivers/md/dm-thin.c         | 13 +++++--------
 include/linux/blk_types.h    |  9 +++++++++
 7 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 78daf5b..4bfd867 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1035,7 +1035,7 @@ static bool blk_rq_should_init_elevator(struct bio *bio)
 	 * Flush requests do not use the elevator so skip initialization.
 	 * This allows a request to share the flush and elevator data.
 	 */
-	if (bio->bi_opf & (REQ_PREFLUSH | REQ_FUA))
+	if (op_is_flush(bio->bi_opf))
 		return false;
 
 	return true;
@@ -1641,7 +1641,7 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	if (bio->bi_opf & (REQ_PREFLUSH | REQ_FUA)) {
+	if (op_is_flush(bio->bi_opf)) {
 		spin_lock_irq(q->queue_lock);
 		where = ELEVATOR_INSERT_FLUSH;
 		goto get_rq;
@@ -2145,7 +2145,7 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	 */
 	BUG_ON(blk_queued_rq(rq));
 
-	if (rq->cmd_flags & (REQ_PREFLUSH | REQ_FUA))
+	if (op_is_flush(rq->cmd_flags))
 		where = ELEVATOR_INSERT_FLUSH;
 
 	add_acct_request(q, rq, where);
@@ -3256,7 +3256,7 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 		/*
 		 * rq is already accounted, so use raw insert
 		 */
-		if (rq->cmd_flags & (REQ_PREFLUSH | REQ_FUA))
+		if (op_is_flush(rq->cmd_flags))
 			__elv_add_request(q, rq, ELEVATOR_INSERT_FLUSH);
 		else
 			__elv_add_request(q, rq, ELEVATOR_INSERT_SORT_MERGE);
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 5e91743..1112752 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -111,7 +111,6 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
 	struct blk_mq_hw_ctx *hctx;
 	struct blk_mq_ctx *ctx;
 	struct request *rq;
-	const bool is_flush = op & (REQ_PREFLUSH | REQ_FUA);
 
 	blk_queue_enter_live(q);
 	ctx = blk_mq_get_ctx(q);
@@ -126,7 +125,7 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
 		 * Flush requests are special and go directly to the
 		 * dispatch list.
 		 */
-		if (!is_flush && e->type->ops.mq.get_request) {
+		if (!op_is_flush(op) && e->type->ops.mq.get_request) {
 			rq = e->type->ops.mq.get_request(q, op, data);
 			if (rq)
 				rq->rq_flags |= RQF_QUEUED;
@@ -139,7 +138,7 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
 	}
 
 	if (rq) {
-		if (!is_flush) {
+		if (!op_is_flush(op)) {
 			rq->elv.icq = NULL;
 			if (e && e->type->icq_cache)
 				blk_mq_sched_assign_ioc(q, rq, bio);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 888868b..ff70219 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1405,7 +1405,7 @@ static void blk_mq_try_issue_directly(struct request *rq, blk_qc_t *cookie)
 static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = op_is_sync(bio->bi_opf);
-	const int is_flush_fua = bio->bi_opf & (REQ_PREFLUSH | REQ_FUA);
+	const int is_flush_fua = op_is_flush(bio->bi_opf);
 	struct blk_mq_alloc_data data = { .flags = 0 };
 	struct request *rq;
 	unsigned int request_count = 0, srcu_idx;
@@ -1527,7 +1527,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = op_is_sync(bio->bi_opf);
-	const int is_flush_fua = bio->bi_opf & (REQ_PREFLUSH | REQ_FUA);
+	const int is_flush_fua = op_is_flush(bio->bi_opf);
 	struct blk_plug *plug;
 	unsigned int request_count = 0;
 	struct blk_mq_alloc_data data = { .flags = 0 };
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 76d2087..01035e7 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -666,7 +666,7 @@ static inline struct search *search_alloc(struct bio *bio,
 	s->iop.write_prio	= 0;
 	s->iop.error		= 0;
 	s->iop.flags		= 0;
-	s->iop.flush_journal	= (bio->bi_opf & (REQ_PREFLUSH|REQ_FUA)) != 0;
+	s->iop.flush_journal	= op_is_flush(bio->bi_opf);
 	s->iop.wq		= bcache_wq;
 
 	return s;
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index e04c61e..5b9cf56 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -787,8 +787,7 @@ static void check_if_tick_bio_needed(struct cache *cache, struct bio *bio)
 	struct per_bio_data *pb = get_per_bio_data(bio, pb_data_size);
 
 	spin_lock_irqsave(&cache->lock, flags);
-	if (cache->need_tick_bio &&
-	    !(bio->bi_opf & (REQ_FUA | REQ_PREFLUSH)) &&
+	if (cache->need_tick_bio && !op_is_flush(bio->bi_opf) &&
 	    bio_op(bio) != REQ_OP_DISCARD) {
 		pb->tick = true;
 		cache->need_tick_bio = false;
@@ -828,11 +827,6 @@ static dm_oblock_t get_bio_block(struct cache *cache, struct bio *bio)
 	return to_oblock(block_nr);
 }
 
-static int bio_triggers_commit(struct cache *cache, struct bio *bio)
-{
-	return bio->bi_opf & (REQ_PREFLUSH | REQ_FUA);
-}
-
 /*
  * You must increment the deferred set whilst the prison cell is held.  To
  * encourage this, we ask for 'cell' to be passed in.
@@ -884,7 +878,7 @@ static void issue(struct cache *cache, struct bio *bio)
 {
 	unsigned long flags;
 
-	if (!bio_triggers_commit(cache, bio)) {
+	if (!op_is_flush(bio->bi_opf)) {
 		accounted_request(cache, bio);
 		return;
 	}
@@ -1069,8 +1063,7 @@ static void dec_io_migrations(struct cache *cache)
 
 static bool discard_or_flush(struct bio *bio)
 {
-	return bio_op(bio) == REQ_OP_DISCARD ||
-	       bio->bi_opf & (REQ_PREFLUSH | REQ_FUA);
+	return bio_op(bio) == REQ_OP_DISCARD || op_is_flush(bio->bi_opf);
 }
 
 static void __cell_defer(struct cache *cache, struct dm_bio_prison_cell *cell)
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index d1c05c1..110982d 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -699,7 +699,7 @@ static void remap_to_origin(struct thin_c *tc, struct bio *bio)
 
 static int bio_triggers_commit(struct thin_c *tc, struct bio *bio)
 {
-	return (bio->bi_opf & (REQ_PREFLUSH | REQ_FUA)) &&
+	return op_is_flush(bio->bi_opf) &&
 		dm_thin_changed_this_transaction(tc->td);
 }
 
@@ -870,8 +870,7 @@ static void __inc_remap_and_issue_cell(void *context,
 	struct bio *bio;
 
 	while ((bio = bio_list_pop(&cell->bios))) {
-		if (bio->bi_opf & (REQ_PREFLUSH | REQ_FUA) ||
-		    bio_op(bio) == REQ_OP_DISCARD)
+		if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD)
 			bio_list_add(&info->defer_bios, bio);
 		else {
 			inc_all_io_entry(info->tc->pool, bio);
@@ -1716,9 +1715,8 @@ static void __remap_and_issue_shared_cell(void *context,
 	struct bio *bio;
 
 	while ((bio = bio_list_pop(&cell->bios))) {
-		if ((bio_data_dir(bio) == WRITE) ||
-		    (bio->bi_opf & (REQ_PREFLUSH | REQ_FUA) ||
-		     bio_op(bio) == REQ_OP_DISCARD))
+		if (bio_data_dir(bio) == WRITE || op_is_flush(bio->bi_opf) ||
+		    bio_op(bio) == REQ_OP_DISCARD)
 			bio_list_add(&info->defer_bios, bio);
 		else {
 			struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));;
@@ -2635,8 +2633,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_SUBMITTED;
 	}
 
-	if (bio->bi_opf & (REQ_PREFLUSH | REQ_FUA) ||
-	    bio_op(bio) == REQ_OP_DISCARD) {
+	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD) {
 		thin_defer_bio_with_throttle(tc, bio);
 		return DM_MAPIO_SUBMITTED;
 	}
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 0e5b1cd..37c9a43 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -221,6 +221,15 @@ static inline bool op_is_write(unsigned int op)
 }
 
 /*
+ * Check if the bio or request is one that needs special treatment in the
+ * flush state machine.
+ */
+static inline bool op_is_flush(unsigned int op)
+{
+	return op & (REQ_FUA | REQ_PREFLUSH);
+}
+
+/*
  * Reads are always treated as synchronous, as are requests with the FUA or
  * PREFLUSH flag.  Other operations may be marked as synchronous using the
  * REQ_SYNC flag.
-- 
2.1.4

