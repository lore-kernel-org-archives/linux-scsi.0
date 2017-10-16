From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v9 05/10] block: Introduce blk_get_request_flags()
Date: Mon, 16 Oct 2017 16:29:00 -0700
Message-ID: <20171016232905.5047-6-bart.vanassche@wdc.com>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171016232905.5047-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

A side effect of this patch is that the GFP mask that is passed to
several allocation functions in the legacy block layer is changed
from GFP_KERNEL into __GFP_DIRECT_RECLAIM.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-core.c       | 50 +++++++++++++++++++++++++++++++++++---------------
 include/linux/blkdev.h |  3 +++
 2 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 23a0110fc62b..559818be8e02 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1157,7 +1157,7 @@ int blk_update_nr_requests(struct request_queue *q, unsigned int nr)
  * @rl: request list to allocate from
  * @op: operation and flags
  * @bio: bio to allocate request for (can be %NULL)
- * @gfp_mask: allocation mask
+ * @flags: BLQ_MQ_REQ_* flags
  *
  * Get a free request from @q.  This function may fail under memory
  * pressure or if @q is dead.
@@ -1167,7 +1167,7 @@ int blk_update_nr_requests(struct request_queue *q, unsigned int nr)
  * Returns request pointer on success, with @q->queue_lock *not held*.
  */
 static struct request *__get_request(struct request_list *rl, unsigned int op,
-		struct bio *bio, gfp_t gfp_mask)
+				     struct bio *bio, unsigned int flags)
 {
 	struct request_queue *q = rl->q;
 	struct request *rq;
@@ -1176,6 +1176,8 @@ static struct request *__get_request(struct request_list *rl, unsigned int op,
 	struct io_cq *icq = NULL;
 	const bool is_sync = op_is_sync(op);
 	int may_queue;
+	gfp_t gfp_mask = flags & BLK_MQ_REQ_NOWAIT ? GFP_ATOMIC :
+			 __GFP_DIRECT_RECLAIM;
 	req_flags_t rq_flags = RQF_ALLOCED;
 
 	lockdep_assert_held(q->queue_lock);
@@ -1336,7 +1338,7 @@ static struct request *__get_request(struct request_list *rl, unsigned int op,
  * @q: request_queue to allocate request from
  * @op: operation and flags
  * @bio: bio to allocate request for (can be %NULL)
- * @gfp_mask: allocation mask
+ * @flags: BLK_MQ_REQ_* flags.
  *
  * Get a free request from @q.  If %__GFP_DIRECT_RECLAIM is set in @gfp_mask,
  * this function keeps retrying under memory pressure and fails iff @q is dead.
@@ -1346,7 +1348,7 @@ static struct request *__get_request(struct request_list *rl, unsigned int op,
  * Returns request pointer on success, with @q->queue_lock *not held*.
  */
 static struct request *get_request(struct request_queue *q, unsigned int op,
-		struct bio *bio, gfp_t gfp_mask)
+				   struct bio *bio, unsigned int flags)
 {
 	const bool is_sync = op_is_sync(op);
 	DEFINE_WAIT(wait);
@@ -1358,7 +1360,7 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
 
 	rl = blk_get_rl(q, bio);	/* transferred to @rq on success */
 retry:
-	rq = __get_request(rl, op, bio, gfp_mask);
+	rq = __get_request(rl, op, bio, flags);
 	if (!IS_ERR(rq))
 		return rq;
 
@@ -1367,7 +1369,7 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
 		return ERR_PTR(-EAGAIN);
 	}
 
-	if (!gfpflags_allow_blocking(gfp_mask) || unlikely(blk_queue_dying(q))) {
+	if ((flags & BLK_MQ_REQ_NOWAIT) || unlikely(blk_queue_dying(q))) {
 		blk_put_rl(rl);
 		return rq;
 	}
@@ -1394,10 +1396,13 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
 	goto retry;
 }
 
+/* flags: BLK_MQ_REQ_PREEMPT and/or BLK_MQ_REQ_NOWAIT. */
 static struct request *blk_old_get_request(struct request_queue *q,
-					   unsigned int op, gfp_t gfp_mask)
+					   unsigned int op, unsigned int flags)
 {
 	struct request *rq;
+	gfp_t gfp_mask = flags & BLK_MQ_REQ_NOWAIT ? GFP_ATOMIC :
+			 __GFP_DIRECT_RECLAIM;
 	int ret = 0;
 
 	WARN_ON_ONCE(q->mq_ops);
@@ -1410,7 +1415,7 @@ static struct request *blk_old_get_request(struct request_queue *q,
 	if (ret)
 		return ERR_PTR(ret);
 	spin_lock_irq(q->queue_lock);
-	rq = get_request(q, op, NULL, gfp_mask);
+	rq = get_request(q, op, NULL, flags);
 	if (IS_ERR(rq)) {
 		spin_unlock_irq(q->queue_lock);
 		blk_queue_exit(q);
@@ -1424,25 +1429,40 @@ static struct request *blk_old_get_request(struct request_queue *q,
 	return rq;
 }
 
-struct request *blk_get_request(struct request_queue *q, unsigned int op,
-				gfp_t gfp_mask)
+/**
+ * blk_get_request_flags - allocate a request
+ * @q: request queue to allocate a request for
+ * @op: operation (REQ_OP_*) and REQ_* flags, e.g. REQ_SYNC.
+ * @flags: BLK_MQ_REQ_* flags, e.g. BLK_MQ_REQ_NOWAIT.
+ */
+struct request *blk_get_request_flags(struct request_queue *q, unsigned int op,
+				      unsigned int flags)
 {
 	struct request *req;
 
+	WARN_ON_ONCE(op & REQ_NOWAIT);
+	WARN_ON_ONCE(flags & ~BLK_MQ_REQ_NOWAIT);
+
 	if (q->mq_ops) {
-		req = blk_mq_alloc_request(q, op,
-			(gfp_mask & __GFP_DIRECT_RECLAIM) ?
-				0 : BLK_MQ_REQ_NOWAIT);
+		req = blk_mq_alloc_request(q, op, flags);
 		if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
 			q->mq_ops->initialize_rq_fn(req);
 	} else {
-		req = blk_old_get_request(q, op, gfp_mask);
+		req = blk_old_get_request(q, op, flags);
 		if (!IS_ERR(req) && q->initialize_rq_fn)
 			q->initialize_rq_fn(req);
 	}
 
 	return req;
 }
+EXPORT_SYMBOL(blk_get_request_flags);
+
+struct request *blk_get_request(struct request_queue *q, unsigned int op,
+				gfp_t gfp_mask)
+{
+	return blk_get_request_flags(q, op, gfp_mask & __GFP_DIRECT_RECLAIM ?
+				     0 : BLK_MQ_REQ_NOWAIT);
+}
 EXPORT_SYMBOL(blk_get_request);
 
 /**
@@ -1868,7 +1888,7 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio)
 	 * Returns with the queue unlocked.
 	 */
 	blk_queue_enter_live(q);
-	req = get_request(q, bio->bi_opf, bio, GFP_NOIO);
+	req = get_request(q, bio->bi_opf, bio, 0);
 	if (IS_ERR(req)) {
 		blk_queue_exit(q);
 		__wbt_done(q->rq_wb, wb_acct);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 72637028f3c9..05203175eb9c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -924,6 +924,9 @@ extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_init_request_from_bio(struct request *req, struct bio *bio);
 extern void blk_put_request(struct request *);
 extern void __blk_put_request(struct request_queue *, struct request *);
+extern struct request *blk_get_request_flags(struct request_queue *,
+					     unsigned int op,
+					     unsigned int flags);
 extern struct request *blk_get_request(struct request_queue *, unsigned int op,
 				       gfp_t gfp_mask);
 extern void blk_requeue_request(struct request_queue *, struct request *);
-- 
2.14.2
