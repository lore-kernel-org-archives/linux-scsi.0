From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V4 13/16] block: mq-deadline: Introduce zone locking support
Date: Sun, 24 Sep 2017 16:02:44 +0900
Message-ID: <20170924070247.25560-14-damien.lemoal@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

For a write request to a zoned block device, lock the request target
zone upon request displatch. The zone is unlocked either when the
request completes or when the request is requeued (inserted).

To indicate that a request has locked its target zone, use the first
pointer of the request elevator private data to store the value
RQ_ZONE_WLOCKED. Testing for this value allows quick decision in
dd_insert_request() and dd_completed_request() regarding the need for
unlocking the target zone of a request.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/mq-deadline.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 1236a464b547..2de1a36c34f5 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -179,6 +179,93 @@ deadline_move_request(struct deadline_data *dd, struct request *rq)
 }
 
 /*
+ * Return true if a request is a write requests that needs zone
+ * write locking.
+ */
+static inline bool deadline_request_needs_zone_wlock(struct deadline_data *dd,
+						     struct request *rq)
+{
+
+	if (!dd->zones_wlock)
+		return false;
+
+	if (blk_rq_is_passthrough(rq))
+		return false;
+
+	switch (req_op(rq)) {
+	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_WRITE_SAME:
+	case REQ_OP_WRITE:
+		return blk_rq_zone_is_seq(rq);
+	default:
+		return false;
+	}
+}
+
+/*
+ * Abuse the elv.priv[0] pointer to indicate if a request has write
+ * locked its target zone. Only write request to a zoned block device
+ * can own a zone write lock.
+ */
+#define RQ_ZONE_WLOCKED		((void *)1UL)
+static inline void deadline_set_request_zone_wlock(struct request *rq)
+{
+	rq->elv.priv[0] = RQ_ZONE_WLOCKED;
+}
+
+#define RQ_ZONE_NO_WLOCK	((void *)0UL)
+static inline void deadline_clear_request_zone_wlock(struct request *rq)
+{
+	rq->elv.priv[0] = RQ_ZONE_NO_WLOCK;
+}
+
+static inline bool deadline_request_has_zone_wlock(struct request *rq)
+{
+	return rq->elv.priv[0] == RQ_ZONE_WLOCKED;
+}
+
+/*
+ * Write lock the target zone of a write request.
+ */
+static void deadline_wlock_zone(struct deadline_data *dd,
+				struct request *rq)
+{
+	unsigned int zno = blk_rq_zone_no(rq);
+
+	WARN_ON_ONCE(deadline_request_has_zone_wlock(rq));
+	WARN_ON_ONCE(test_and_set_bit(zno, dd->zones_wlock));
+	deadline_set_request_zone_wlock(rq);
+}
+
+/*
+ * Write unlock the target zone of a write request.
+ */
+static void deadline_wunlock_zone(struct deadline_data *dd,
+				  struct request *rq)
+{
+	unsigned int zno = blk_rq_zone_no(rq);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dd->zone_lock, flags);
+
+	WARN_ON_ONCE(!test_and_clear_bit(zno, dd->zones_wlock));
+	deadline_clear_request_zone_wlock(rq);
+
+	spin_unlock_irqrestore(&dd->zone_lock, flags);
+}
+
+/*
+ * Test the write lock state of the target zone of a write request.
+ */
+static inline bool deadline_zone_is_wlocked(struct deadline_data *dd,
+					    struct request *rq)
+{
+	unsigned int zno = blk_rq_zone_no(rq);
+
+	return test_bit(zno, dd->zones_wlock);
+}
+
+/*
  * deadline_check_fifo returns 0 if there are no expired requests on the fifo,
  * 1 otherwise. Requires !list_empty(&dd->fifo_list[data_dir])
  */
@@ -311,6 +398,11 @@ static struct request *__dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	dd->batching++;
 	deadline_move_request(dd, rq);
 done:
+	/*
+	 * If the request needs its target zone locked, do it.
+	 */
+	if (deadline_request_needs_zone_wlock(dd, rq))
+		deadline_wlock_zone(dd, rq);
 	rq->rq_flags |= RQF_STARTED;
 	return rq;
 }
@@ -472,6 +564,13 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	struct deadline_data *dd = q->elevator->elevator_data;
 	const int data_dir = rq_data_dir(rq);
 
+	/*
+	 * This may be a requeue of a request that has locked its
+	 * target zone. If this is the case, release the request zone lock.
+	 */
+	if (deadline_request_has_zone_wlock(rq))
+		deadline_wunlock_zone(dd, rq);
+
 	if (blk_mq_sched_try_insert_merge(q, rq))
 		return;
 
@@ -516,6 +615,20 @@ static void dd_insert_requests(struct blk_mq_hw_ctx *hctx,
 	spin_unlock(&dd->lock);
 }
 
+/*
+ * For zoned block devices, write unlock the target zone of
+ * completed write requests.
+ */
+static void dd_completed_request(struct request *rq)
+{
+
+	if (deadline_request_has_zone_wlock(rq)) {
+		struct deadline_data *dd = rq->q->elevator->elevator_data;
+
+		deadline_wunlock_zone(dd, rq);
+	}
+}
+
 static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
 {
 	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
@@ -757,6 +870,7 @@ static struct elevator_type mq_deadline = {
 	.ops.mq = {
 		.insert_requests	= dd_insert_requests,
 		.dispatch_request	= dd_dispatch_request,
+		.completed_request	= dd_completed_request,
 		.next_request		= elv_rb_latter_request,
 		.former_request		= elv_rb_former_request,
 		.bio_merge		= dd_bio_merge,
-- 
2.13.5
