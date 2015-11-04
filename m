From: mchristi@redhat.com
Subject: [PATCH 25/32] block: add operation field to request
	struct
Date: Wed,  4 Nov 2015 16:08:22 -0600
Message-ID: <1446674909-5371-26-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch adds field to the request to store the REQ_OP, and
has the block layer code set it up.

The next patches will modify the other drivers to get/test the
request->op field. We are still ORing the op into the cmd_flags.
When I am done with the conversion, that will be dropped.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-core.c       | 50 ++++++++++++++++++++++++++++----------------------
 block/blk-flush.c      |  1 +
 block/blk-mq.c         | 31 +++++++++++++++++--------------
 include/linux/blkdev.h |  1 +
 4 files changed, 47 insertions(+), 36 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c8672f2..e625516 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -984,7 +984,8 @@ static struct io_context *rq_ioc(struct bio *bio)
 /**
  * __get_request - get a free request
  * @rl: request list to allocate from
- * @rw_flags: RW and SYNC flags
+ * @op: REQ_OP
+ * @op_flags: rq_flag_bits
  * @bio: bio to allocate request for (can be %NULL)
  * @gfp_mask: allocation mask
  *
@@ -995,21 +996,22 @@ static struct io_context *rq_ioc(struct bio *bio)
  * Returns ERR_PTR on failure, with @q->queue_lock held.
  * Returns request pointer on success, with @q->queue_lock *not held*.
  */
-static struct request *__get_request(struct request_list *rl, int rw_flags,
-				     struct bio *bio, gfp_t gfp_mask)
+static struct request *__get_request(struct request_list *rl, int op,
+				     int op_flags, struct bio *bio,
+				     gfp_t gfp_mask)
 {
 	struct request_queue *q = rl->q;
 	struct request *rq;
 	struct elevator_type *et = q->elevator->type;
 	struct io_context *ioc = rq_ioc(bio);
 	struct io_cq *icq = NULL;
-	const bool is_sync = rw_is_sync(rw_flags) != 0;
+	const bool is_sync = rw_is_sync(op | op_flags) != 0;
 	int may_queue;
 
 	if (unlikely(blk_queue_dying(q)))
 		return ERR_PTR(-ENODEV);
 
-	may_queue = elv_may_queue(q, rw_flags);
+	may_queue = elv_may_queue(q, op | op_flags);
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
@@ -1053,7 +1055,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 
 	/*
 	 * Decide whether the new request will be managed by elevator.  If
-	 * so, mark @rw_flags and increment elvpriv.  Non-zero elvpriv will
+	 * so, mark @op_flags and increment elvpriv.  Non-zero elvpriv will
 	 * prevent the current elevator from being destroyed until the new
 	 * request is freed.  This guarantees icq's won't be destroyed and
 	 * makes creating new ones safe.
@@ -1062,14 +1064,14 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 	 * it will be created after releasing queue_lock.
 	 */
 	if (blk_rq_should_init_elevator(bio) && !blk_queue_bypass(q)) {
-		rw_flags |= REQ_ELVPRIV;
+		op_flags |= REQ_ELVPRIV;
 		q->nr_rqs_elvpriv++;
 		if (et->icq_cache && ioc)
 			icq = ioc_lookup_icq(ioc, q);
 	}
 
 	if (blk_queue_io_stat(q))
-		rw_flags |= REQ_IO_STAT;
+		op_flags |= REQ_IO_STAT;
 	spin_unlock_irq(q->queue_lock);
 
 	/* allocate and init request */
@@ -1079,10 +1081,11 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 
 	blk_rq_init(q, rq);
 	blk_rq_set_rl(rq, rl);
-	rq->cmd_flags = rw_flags | REQ_ALLOCED;
+	rq->cmd_flags = op | op_flags | REQ_ALLOCED;
+	rq->op = op;
 
 	/* init elvpriv */
-	if (rw_flags & REQ_ELVPRIV) {
+	if (op_flags & REQ_ELVPRIV) {
 		if (unlikely(et->icq_cache && !icq)) {
 			if (ioc)
 				icq = ioc_create_icq(ioc, q, gfp_mask);
@@ -1108,7 +1111,7 @@ out:
 	if (ioc_batching(q, ioc))
 		ioc->nr_batch_requests--;
 
-	trace_block_getrq(q, bio, rw_flags & 1);
+	trace_block_getrq(q, bio, op);
 	return rq;
 
 fail_elvpriv:
@@ -1138,7 +1141,7 @@ fail_alloc:
 	 * queue, but this is pretty rare.
 	 */
 	spin_lock_irq(q->queue_lock);
-	freed_request(rl, rw_flags);
+	freed_request(rl, op | op_flags);
 
 	/*
 	 * in the very unlikely event that allocation failed and no
@@ -1156,7 +1159,8 @@ rq_starved:
 /**
  * get_request - get a free request
  * @q: request_queue to allocate request from
- * @rw_flags: RW and SYNC flags
+ * op: REQ_OP
+ * @op_flags: rq_flag_bits
  * @bio: bio to allocate request for (can be %NULL)
  * @gfp_mask: allocation mask
  *
@@ -1167,17 +1171,18 @@ rq_starved:
  * Returns ERR_PTR on failure, with @q->queue_lock held.
  * Returns request pointer on success, with @q->queue_lock *not held*.
  */
-static struct request *get_request(struct request_queue *q, int rw_flags,
-				   struct bio *bio, gfp_t gfp_mask)
+static struct request *get_request(struct request_queue *q, int op,
+				   int op_flags, struct bio *bio,
+				   gfp_t gfp_mask)
 {
-	const bool is_sync = rw_is_sync(rw_flags) != 0;
+	const bool is_sync = rw_is_sync(op | op_flags) != 0;
 	DEFINE_WAIT(wait);
 	struct request_list *rl;
 	struct request *rq;
 
 	rl = blk_get_rl(q, bio);	/* transferred to @rq on success */
 retry:
-	rq = __get_request(rl, rw_flags, bio, gfp_mask);
+	rq = __get_request(rl, op, op_flags, bio, gfp_mask);
 	if (!IS_ERR(rq))
 		return rq;
 
@@ -1190,7 +1195,7 @@ retry:
 	prepare_to_wait_exclusive(&rl->wait[is_sync], &wait,
 				  TASK_UNINTERRUPTIBLE);
 
-	trace_block_sleeprq(q, bio, rw_flags & 1);
+	trace_block_sleeprq(q, bio, op);
 
 	spin_unlock_irq(q->queue_lock);
 	io_schedule();
@@ -1219,7 +1224,7 @@ static struct request *blk_old_get_request(struct request_queue *q, int rw,
 	create_io_context(gfp_mask, q->node);
 
 	spin_lock_irq(q->queue_lock);
-	rq = get_request(q, rw, NULL, gfp_mask);
+	rq = get_request(q, rw, 0, NULL, gfp_mask);
 	if (IS_ERR(rq))
 		spin_unlock_irq(q->queue_lock);
 	/* q->queue_lock is unlocked at this point */
@@ -1612,7 +1617,7 @@ static void blk_queue_bio(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 	struct blk_plug *plug;
-	int el_ret, rw_flags, where = ELEVATOR_INSERT_SORT;
+	int el_ret, rw_flags = 0, where = ELEVATOR_INSERT_SORT;
 	struct request *req;
 	unsigned int request_count = 0;
 
@@ -1670,7 +1675,6 @@ get_rq:
 	 * but we need to set it earlier to expose the sync flag to the
 	 * rq allocator and io schedulers.
 	 */
-	rw_flags = bio_data_dir(bio);
 	if (sync)
 		rw_flags |= REQ_SYNC;
 
@@ -1678,7 +1682,7 @@ get_rq:
 	 * Grab a free request. This is might sleep but can not fail.
 	 * Returns with the queue unlocked.
 	 */
-	req = get_request(q, rw_flags, bio, GFP_NOIO);
+	req = get_request(q, bio_data_dir(bio), rw_flags, bio, GFP_NOIO);
 	if (IS_ERR(req)) {
 		bio->bi_error = PTR_ERR(req);
 		bio_endio(bio);
@@ -2870,6 +2874,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 {
 	/* Bit 0 (R/W) is identical in rq->cmd_flags and bio->bi_rw */
 	rq->cmd_flags |= bio->bi_rw & REQ_WRITE;
+	rq->op = bio->bi_op;
 
 	if (bio_has_data(bio))
 		rq->nr_phys_segments = bio_phys_segments(q, bio);
@@ -2954,6 +2959,7 @@ EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
 static void __blk_rq_prep_clone(struct request *dst, struct request *src)
 {
 	dst->cpu = src->cpu;
+	dst->op = src->op;
 	dst->cmd_flags |= (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
 	dst->cmd_type = src->cmd_type;
 	dst->__sector = blk_rq_pos(src);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index f707ba1..fc9c343 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -330,6 +330,7 @@ static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq)
 
 	flush_rq->cmd_type = REQ_TYPE_FS;
 	flush_rq->cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
+	flush_rq->op = REQ_OP_WRITE;
 	flush_rq->rq_disk = first_rq->rq_disk;
 	flush_rq->end_io = flush_end_io;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 85f0143..d57a581 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -176,16 +176,18 @@ bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
 EXPORT_SYMBOL(blk_mq_can_queue);
 
 static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
-			       struct request *rq, unsigned int rw_flags)
+			       struct request *rq, int op,
+			       unsigned int op_flags)
 {
 	if (blk_queue_io_stat(q))
-		rw_flags |= REQ_IO_STAT;
+		op_flags |= REQ_IO_STAT;
 
 	INIT_LIST_HEAD(&rq->queuelist);
 	/* csd/requeue_work/fifo_time is initialized before use */
 	rq->q = q;
 	rq->mq_ctx = ctx;
-	rq->cmd_flags |= rw_flags;
+	rq->op = op;
+	rq->cmd_flags |= op | op_flags;
 	/* do not touch atomic flags, it needs atomic ops against the timer */
 	rq->cpu = -1;
 	INIT_HLIST_NODE(&rq->hash);
@@ -220,11 +222,11 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
 
-	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
+	ctx->rq_dispatched[rw_is_sync(op | op_flags)]++;
 }
 
 static struct request *
-__blk_mq_alloc_request(struct blk_mq_alloc_data *data, int rw)
+__blk_mq_alloc_request(struct blk_mq_alloc_data *data, int op, int op_flags)
 {
 	struct request *rq;
 	unsigned int tag;
@@ -239,7 +241,7 @@ __blk_mq_alloc_request(struct blk_mq_alloc_data *data, int rw)
 		}
 
 		rq->tag = tag;
-		blk_mq_rq_ctx_init(data->q, data->ctx, rq, rw);
+		blk_mq_rq_ctx_init(data->q, data->ctx, rq, op, op_flags);
 		return rq;
 	}
 
@@ -264,7 +266,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp,
 	blk_mq_set_alloc_data(&alloc_data, q, gfp & ~__GFP_WAIT,
 			reserved, ctx, hctx);
 
-	rq = __blk_mq_alloc_request(&alloc_data, rw);
+	rq = __blk_mq_alloc_request(&alloc_data, rw, 0);
 	if (!rq && (gfp & __GFP_WAIT)) {
 		__blk_mq_run_hw_queue(hctx);
 		blk_mq_put_ctx(ctx);
@@ -273,7 +275,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp,
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 		blk_mq_set_alloc_data(&alloc_data, q, gfp, reserved, ctx,
 				hctx);
-		rq =  __blk_mq_alloc_request(&alloc_data, rw);
+		rq =  __blk_mq_alloc_request(&alloc_data, rw, 0);
 		ctx = alloc_data.ctx;
 	}
 	blk_mq_put_ctx(ctx);
@@ -1173,7 +1175,8 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	struct blk_mq_hw_ctx *hctx;
 	struct blk_mq_ctx *ctx;
 	struct request *rq;
-	int rw = bio_data_dir(bio);
+	int op = bio_data_dir(bio);
+	int op_flags = 0;
 	struct blk_mq_alloc_data alloc_data;
 
 	if (unlikely(blk_mq_queue_enter(q, GFP_KERNEL))) {
@@ -1185,22 +1188,22 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
 	if (rw_is_sync(bio->bi_rw))
-		rw |= REQ_SYNC;
+		op_flags |= REQ_SYNC;
 
-	trace_block_getrq(q, bio, rw);
+	trace_block_getrq(q, bio, op);
 	blk_mq_set_alloc_data(&alloc_data, q, GFP_ATOMIC, false, ctx,
 			hctx);
-	rq = __blk_mq_alloc_request(&alloc_data, rw);
+	rq = __blk_mq_alloc_request(&alloc_data, op, op_flags);
 	if (unlikely(!rq)) {
 		__blk_mq_run_hw_queue(hctx);
 		blk_mq_put_ctx(ctx);
-		trace_block_sleeprq(q, bio, rw);
+		trace_block_sleeprq(q, bio, op);
 
 		ctx = blk_mq_get_ctx(q);
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 		blk_mq_set_alloc_data(&alloc_data, q,
 				__GFP_WAIT|GFP_ATOMIC, false, ctx, hctx);
-		rq = __blk_mq_alloc_request(&alloc_data, rw);
+		rq = __blk_mq_alloc_request(&alloc_data, op, op_flags);
 		ctx = alloc_data.ctx;
 		hctx = alloc_data.hctx;
 	}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cf5f518..9c5bee9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -94,6 +94,7 @@ struct request {
 	struct request_queue *q;
 	struct blk_mq_ctx *mq_ctx;
 
+	int op;
 	u64 cmd_flags;
 	unsigned cmd_type;
 	unsigned long atomic_flags;
-- 
1.8.3.1
