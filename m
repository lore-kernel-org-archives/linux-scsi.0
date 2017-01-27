From: Jens Axboe <axboe@fb.com>
Subject: Re: [dm-devel] split scsi passthrough fields out of struct request V2
Date: Thu, 26 Jan 2017 23:40:06 -0700
Message-ID: <37ab009a-bc2d-d2ae-a875-269ab563a430@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
 <1485455329.2540.7.camel@sandisk.com>
 <e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
 <1485456745.2540.9.camel@sandisk.com>
 <db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com> <20170126185924.GA25289@lst.de>
 <ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
 <71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
 <4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
 <1485464486.2540.12.camel@sandisk.com>
 <6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
 <1485467235.2540.14.camel@sandisk.com>
 <e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
 <1485472465.2540.19.camel@sandisk.com>
 <e222c541-3239-104d-e0b0-40d19b012b66@fb.com>
 <1485474426.2540.25.camel@sandisk.com>
 <b98195e7-6e04-5a59-8b83-ce2e1c5c4e1a@fb.com>
 <1485477510.2540.27.camel@sandisk.com>
 <2d971693-b79d-c1b9-fb2a-f5dd04128c68@fb.com>
 <1485479738.2540.30.camel@sandisk.com>
 <ecca734c-7a9c-f060-9335-c2de089849c2@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ecca734c-7a9c-f060-9335-c2de089849c2@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On 01/26/2017 06:22 PM, Jens Axboe wrote:
> On 01/26/2017 06:15 PM, Bart Van Assche wrote:
>> On Thu, 2017-01-26 at 17:41 -0700, Jens Axboe wrote:
>>> On 01/26/2017 05:38 PM, Bart Van Assche wrote:
>>>> I see similar behavior with the blk-mq-sched branch of
>>>> git://git.kernel.dk/linux-block.git (git commit ID 0efe27068ecf):
>>>> booting happens much slower than usual and I/O hangs if I run the
>>>> srp-test software.
>>>
>>> Please don't run that, run for-4.11/block and merge it to master.
>>> Same behavior?
>>
>> I have not yet had the chance to run the srp-test software against that
>> kernel. But I already see that booting takes more than ten times longer
>> than usual. Note: as far as I know the dm-mpath driver is not involved
>> in the boot process of my test system.
> 
> What's your boot device? I've been booting this on a variety of setups,
> no problems observed. It's booting my laptop, and on SCSI and SATA as
> well. What is your root drive? What is the queue depth of it?
> Controller?

Are you using dm for your root device?

I think I see what is going on. The scheduler framework put the
insertion of flushes on the side, whereas it's integrated "nicely"
on the legacy side.

Can you try with this applied? This is on top of the previous two that
we already went through. Or, you can just pull:

git://git.kernel.dk/linux-block for-4.11/next

which is for-4.11/block with the next set of fixes on top that I haven't
pulled in yet.


commit 995447bfd14dd871e0c8771261ed7d1f2b5b4c86
Author: Jens Axboe <axboe@fb.com>
Date:   Thu Jan 26 23:34:56 2017 -0700

    blk-mq-sched: integrate flush insertion into blk_mq_sched_get_request()
    
    Instead of letting the caller check this and handle the details
    of inserting a flush request, put the logic in the scheduler
    insertion function.
    
    Outside of cleaning up the code, this handles the case where
    outside callers insert a flush, like through
    blk_insert_cloned_request().
    
    Signed-off-by: Jens Axboe <axboe@fb.com>

diff --git a/block/blk-core.c b/block/blk-core.c
index a61f1407f4f6..78daf5b6d7cb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2129,7 +2129,7 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	if (q->mq_ops) {
 		if (blk_queue_io_stat(q))
 			blk_account_io_start(rq, true);
-		blk_mq_sched_insert_request(rq, false, true, false);
+		blk_mq_sched_insert_request(rq, false, true, false, false);
 		return 0;
 	}
 
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 86656fdfa637..ed1f10165268 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -66,7 +66,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	 * be reused after dying flag is set
 	 */
 	if (q->mq_ops) {
-		blk_mq_sched_insert_request(rq, at_head, true, false);
+		blk_mq_sched_insert_request(rq, at_head, true, false, false);
 		return;
 	}
 
diff --git a/block/blk-flush.c b/block/blk-flush.c
index d7de34ee39c2..4427896641ac 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -456,7 +456,7 @@ void blk_insert_flush(struct request *rq)
 	if ((policy & REQ_FSEQ_DATA) &&
 	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
 		if (q->mq_ops)
-			blk_mq_sched_insert_request(rq, false, true, false);
+			blk_mq_sched_insert_request(rq, false, true, false, false);
 		else
 			list_add_tail(&rq->queuelist, &q->queue_head);
 		return;
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index c27613de80c5..fa2ff0f458fa 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -336,6 +336,64 @@ void blk_mq_sched_restart_queues(struct blk_mq_hw_ctx *hctx)
 	}
 }
 
+/*
+ * Add flush/fua to the queue. If we fail getting a driver tag, then
+ * punt to the requeue list. Requeue will re-invoke us from a context
+ * that's safe to block from.
+ */
+static void blk_mq_sched_insert_flush(struct blk_mq_hw_ctx *hctx,
+				      struct request *rq, bool can_block)
+{
+	if (blk_mq_get_driver_tag(rq, &hctx, can_block)) {
+		blk_insert_flush(rq);
+		blk_mq_run_hw_queue(hctx, !can_block);
+	} else
+		blk_mq_add_to_requeue_list(rq, true, true);
+}
+
+void blk_mq_sched_insert_request(struct request *rq, bool at_head,
+				 bool run_queue, bool async, bool can_block)
+{
+	struct request_queue *q = rq->q;
+	struct elevator_queue *e = q->elevator;
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
+
+	if (rq->tag == -1 && (rq->cmd_flags & (REQ_PREFLUSH | REQ_FUA))) {
+		blk_mq_sched_insert_flush(hctx, rq, can_block);
+		return;
+	}
+
+	if (e && e->type->ops.mq.insert_requests) {
+		LIST_HEAD(list);
+
+		list_add(&rq->queuelist, &list);
+		e->type->ops.mq.insert_requests(hctx, &list, at_head);
+	} else {
+		spin_lock(&ctx->lock);
+		__blk_mq_insert_request(hctx, rq, at_head);
+		spin_unlock(&ctx->lock);
+	}
+
+	if (run_queue)
+		blk_mq_run_hw_queue(hctx, async);
+}
+
+void blk_mq_sched_insert_requests(struct request_queue *q,
+				  struct blk_mq_ctx *ctx,
+				  struct list_head *list, bool run_queue_async)
+{
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
+	struct elevator_queue *e = hctx->queue->elevator;
+
+	if (e && e->type->ops.mq.insert_requests)
+		e->type->ops.mq.insert_requests(hctx, list, false);
+	else
+		blk_mq_insert_requests(hctx, ctx, list);
+
+	blk_mq_run_hw_queue(hctx, run_queue_async);
+}
+
 static void blk_mq_sched_free_tags(struct blk_mq_tag_set *set,
 				   struct blk_mq_hw_ctx *hctx,
 				   unsigned int hctx_idx)
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index becbc7840364..9478aaeb48c5 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -21,6 +21,12 @@ bool __blk_mq_sched_bio_merge(struct request_queue *q, struct bio *bio);
 bool blk_mq_sched_try_insert_merge(struct request_queue *q, struct request *rq);
 void blk_mq_sched_restart_queues(struct blk_mq_hw_ctx *hctx);
 
+void blk_mq_sched_insert_request(struct request *rq, bool at_head,
+				 bool run_queue, bool async, bool can_block);
+void blk_mq_sched_insert_requests(struct request_queue *q,
+				  struct blk_mq_ctx *ctx,
+				  struct list_head *list, bool run_queue_async);
+
 void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx);
 void blk_mq_sched_move_to_dispatch(struct blk_mq_hw_ctx *hctx,
 			struct list_head *rq_list,
@@ -62,45 +68,6 @@ static inline void blk_mq_sched_put_rq_priv(struct request_queue *q,
 		e->type->ops.mq.put_rq_priv(q, rq);
 }
 
-static inline void
-blk_mq_sched_insert_request(struct request *rq, bool at_head, bool run_queue,
-			    bool async)
-{
-	struct request_queue *q = rq->q;
-	struct elevator_queue *e = q->elevator;
-	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
-
-	if (e && e->type->ops.mq.insert_requests) {
-		LIST_HEAD(list);
-
-		list_add(&rq->queuelist, &list);
-		e->type->ops.mq.insert_requests(hctx, &list, at_head);
-	} else {
-		spin_lock(&ctx->lock);
-		__blk_mq_insert_request(hctx, rq, at_head);
-		spin_unlock(&ctx->lock);
-	}
-
-	if (run_queue)
-		blk_mq_run_hw_queue(hctx, async);
-}
-
-static inline void
-blk_mq_sched_insert_requests(struct request_queue *q, struct blk_mq_ctx *ctx,
-			     struct list_head *list, bool run_queue_async)
-{
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
-	struct elevator_queue *e = hctx->queue->elevator;
-
-	if (e && e->type->ops.mq.insert_requests)
-		e->type->ops.mq.insert_requests(hctx, list, false);
-	else
-		blk_mq_insert_requests(hctx, ctx, list);
-
-	blk_mq_run_hw_queue(hctx, run_queue_async);
-}
-
 static inline bool
 blk_mq_sched_allow_merge(struct request_queue *q, struct request *rq,
 			 struct bio *bio)
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 1b156ca79af6..78bbacd129c9 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -106,6 +106,7 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data)
 	struct sbq_wait_state *ws;
 	DEFINE_WAIT(wait);
 	unsigned int tag_offset;
+	bool drop_ctx;
 	int tag;
 
 	if (data->flags & BLK_MQ_REQ_RESERVED) {
@@ -128,6 +129,7 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data)
 		return BLK_MQ_TAG_FAIL;
 
 	ws = bt_wait_ptr(bt, data->hctx);
+	drop_ctx = data->ctx == NULL;
 	do {
 		prepare_to_wait(&ws->wait, &wait, TASK_UNINTERRUPTIBLE);
 
@@ -150,7 +152,8 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data)
 		if (tag != -1)
 			break;
 
-		blk_mq_put_ctx(data->ctx);
+		if (data->ctx)
+			blk_mq_put_ctx(data->ctx);
 
 		io_schedule();
 
@@ -166,6 +169,9 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data)
 		ws = bt_wait_ptr(bt, data->hctx);
 	} while (1);
 
+	if (drop_ctx && data->ctx)
+		blk_mq_put_ctx(data->ctx);
+
 	finish_wait(&ws->wait, &wait);
 
 found_tag:
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4df397910251..9046f7802de3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -568,13 +568,13 @@ static void blk_mq_requeue_work(struct work_struct *work)
 
 		rq->rq_flags &= ~RQF_SOFTBARRIER;
 		list_del_init(&rq->queuelist);
-		blk_mq_sched_insert_request(rq, true, false, false);
+		blk_mq_sched_insert_request(rq, true, false, false, true);
 	}
 
 	while (!list_empty(&rq_list)) {
 		rq = list_entry(rq_list.next, struct request, queuelist);
 		list_del_init(&rq->queuelist);
-		blk_mq_sched_insert_request(rq, false, false, false);
+		blk_mq_sched_insert_request(rq, false, false, false, true);
 	}
 
 	blk_mq_run_hw_queues(q, false);
@@ -847,12 +847,11 @@ static inline unsigned int queued_to_index(unsigned int queued)
 	return min(BLK_MQ_MAX_DISPATCH_ORDER - 1, ilog2(queued) + 1);
 }
 
-static bool blk_mq_get_driver_tag(struct request *rq,
-				  struct blk_mq_hw_ctx **hctx, bool wait)
+bool blk_mq_get_driver_tag(struct request *rq, struct blk_mq_hw_ctx **hctx,
+			   bool wait)
 {
 	struct blk_mq_alloc_data data = {
 		.q = rq->q,
-		.ctx = rq->mq_ctx,
 		.hctx = blk_mq_map_queue(rq->q, rq->mq_ctx->cpu),
 		.flags = wait ? 0 : BLK_MQ_REQ_NOWAIT,
 	};
@@ -1395,7 +1394,7 @@ static void blk_mq_try_issue_directly(struct request *rq, blk_qc_t *cookie)
 	}
 
 insert:
-	blk_mq_sched_insert_request(rq, false, true, true);
+	blk_mq_sched_insert_request(rq, false, true, true, false);
 }
 
 /*
@@ -1445,12 +1444,8 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 
 	cookie = request_to_qc_t(data.hctx, rq);
 
-	if (unlikely(is_flush_fua)) {
-		blk_mq_bio_to_request(rq, bio);
-		blk_mq_get_driver_tag(rq, NULL, true);
-		blk_insert_flush(rq);
-		goto run_queue;
-	}
+	if (unlikely(is_flush_fua))
+		goto insert;
 
 	plug = current->plug;
 	/*
@@ -1499,10 +1494,11 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	}
 
 	if (q->elevator) {
+insert:
 		blk_mq_put_ctx(data.ctx);
 		blk_mq_bio_to_request(rq, bio);
 		blk_mq_sched_insert_request(rq, false, true,
-						!is_sync || is_flush_fua);
+						!is_sync || is_flush_fua, true);
 		goto done;
 	}
 	if (!blk_mq_merge_queue_io(data.hctx, data.ctx, rq, bio)) {
@@ -1512,7 +1508,6 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		 * latter allows for merging opportunities and more efficient
 		 * dispatching.
 		 */
-run_queue:
 		blk_mq_run_hw_queue(data.hctx, !is_sync || is_flush_fua);
 	}
 	blk_mq_put_ctx(data.ctx);
@@ -1567,12 +1562,8 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 
 	cookie = request_to_qc_t(data.hctx, rq);
 
-	if (unlikely(is_flush_fua)) {
-		blk_mq_bio_to_request(rq, bio);
-		blk_mq_get_driver_tag(rq, NULL, true);
-		blk_insert_flush(rq);
-		goto run_queue;
-	}
+	if (unlikely(is_flush_fua))
+		goto insert;
 
 	/*
 	 * A task plug currently exists. Since this is completely lockless,
@@ -1609,10 +1600,11 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 	}
 
 	if (q->elevator) {
+insert:
 		blk_mq_put_ctx(data.ctx);
 		blk_mq_bio_to_request(rq, bio);
 		blk_mq_sched_insert_request(rq, false, true,
-						!is_sync || is_flush_fua);
+						!is_sync || is_flush_fua, true);
 		goto done;
 	}
 	if (!blk_mq_merge_queue_io(data.hctx, data.ctx, rq, bio)) {
@@ -1622,7 +1614,6 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 		 * latter allows for merging opportunities and more efficient
 		 * dispatching.
 		 */
-run_queue:
 		blk_mq_run_hw_queue(data.hctx, !is_sync || is_flush_fua);
 	}
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index d19b0e75a129..d34929968071 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -34,6 +34,8 @@ void blk_mq_wake_waiters(struct request_queue *q);
 bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *, struct list_head *);
 void blk_mq_flush_busy_ctxs(struct blk_mq_hw_ctx *hctx, struct list_head *list);
 bool blk_mq_hctx_has_pending(struct blk_mq_hw_ctx *hctx);
+bool blk_mq_get_driver_tag(struct request *rq, struct blk_mq_hw_ctx **hctx,
+				bool wait);
 
 /*
  * Internal helpers for allocating/freeing the request map

-- 
Jens Axboe

