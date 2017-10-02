From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V6 12/14] block: mq-deadline: Introduce zone locking support
Date: Mon,  2 Oct 2017 16:15:33 +0900
Message-ID: <20171002071535.8007-13-damien.lemoal@wdc.com>
References: <20171002071535.8007-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:22502 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbdJBHPv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2017 03:15:51 -0400
In-Reply-To: <20171002071535.8007-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

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
 block/mq-deadline.c | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 6b7b84ee8f82..93a1aede5dd0 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -177,6 +177,91 @@ deadline_move_request(struct deadline_data *dd, struct request *rq)
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
+	/*
+	 * REQ_OP_SCSI_* and REQ_OP_DRV_* are already handled with
+	 * the previous check. Add them again here so that all request
+	 * operations defined by enum req_off are handled (so that a compiler
+	 * warning shows up if/when request operation definitions change.
+	 */
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
+enum rq_zone_lock {
+	RQ_ZONE_NO_WLOCK = 0UL,
+	RQ_ZONE_WLOCKED  = 1UL,
+};
+
+static inline void deadline_set_request_zone_wlock(struct request *rq)
+{
+	rq->elv.priv[0] = (void *)RQ_ZONE_WLOCKED;
+}
+
+static inline void deadline_clear_request_zone_wlock(struct request *rq)
+{
+	rq->elv.priv[0] = (void *)RQ_ZONE_NO_WLOCK;
+}
+
+static inline bool deadline_request_has_zone_wlock(struct request *rq)
+{
+	return rq->elv.priv[0] == (void *)RQ_ZONE_WLOCKED;
+}
+
+/*
+ * Write lock the target zone of a write request.
+ */
+static void deadline_wlock_zone(struct deadline_data *dd,
+				struct request *rq)
+{
+	WARN_ON_ONCE(deadline_request_has_zone_wlock(rq));
+	WARN_ON_ONCE(test_and_set_bit(blk_rq_zone_no(rq), dd->zones_wlock));
+	deadline_set_request_zone_wlock(rq);
+}
+
+/*
+ * Write unlock the target zone of a write request.
+ */
+static void deadline_wunlock_zone(struct deadline_data *dd,
+				  struct request *rq)
+{
+	WARN_ON_ONCE(!test_and_clear_bit(blk_rq_zone_no(rq), dd->zones_wlock));
+	deadline_clear_request_zone_wlock(rq);
+}
+
+/*
+ * Test the write lock state of the target zone of a write request.
+ */
+static inline bool deadline_zone_is_wlocked(struct deadline_data *dd,
+					    struct request *rq)
+{
+	return test_bit(blk_rq_zone_no(rq), dd->zones_wlock);
+}
+
+/*
  * deadline_check_fifo returns 0 if there are no expired requests on the fifo,
  * 1 otherwise. Requires !list_empty(&dd->fifo_list[data_dir])
  */
@@ -315,6 +400,11 @@ static struct request *__dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
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
@@ -464,6 +554,13 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	struct deadline_data *dd = q->elevator->elevator_data;
 	const int data_dir = rq_data_dir(rq);
 
+	/*
+	 * This may be a requeue of a write request that has locked its
+	 * target zone. If this is the case, release the zone lock.
+	 */
+	if (deadline_request_has_zone_wlock(rq))
+		deadline_wunlock_zone(dd, rq);
+
 	if (blk_mq_sched_try_insert_merge(q, rq))
 		return;
 
@@ -508,6 +605,19 @@ static void dd_insert_requests(struct blk_mq_hw_ctx *hctx,
 	spin_unlock(&dd->lock);
 }
 
+/*
+ * For zoned block devices, write unlock the target zone of
+ * completed write requests.
+ */
+static void dd_completed_request(struct request *rq)
+{
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
@@ -709,6 +819,7 @@ static struct elevator_type mq_deadline = {
 	.ops.mq = {
 		.insert_requests	= dd_insert_requests,
 		.dispatch_request	= dd_dispatch_request,
+		.completed_request	= dd_completed_request,
 		.next_request		= elv_rb_latter_request,
 		.former_request		= elv_rb_former_request,
 		.bio_merge		= dd_bio_merge,
-- 
2.13.6
