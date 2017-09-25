From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V5 13/14] block: mq-deadline: Limit write request dispatch for zoned block devices
Date: Mon, 25 Sep 2017 15:14:53 +0900
Message-ID: <20170925061454.5533-14-damien.lemoal@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170925061454.5533-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

When dispatching writes to a zoned block device, only allow the request
to be dispatched if its target zone is not locked. If it is, leave the
request in the scheduler queue and look for another suitable write
request. If no write can be dispatched, allow reads to be dispatched
even if the write batch is not done.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/mq-deadline.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 4 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 186c32099845..fc3e50a0a495 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -282,19 +282,47 @@ static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
 }
 
 /*
+ * Test if a request can be dispatched.
+ */
+static inline bool deadline_can_dispatch_request(struct deadline_data *dd,
+						 struct request *rq)
+{
+	if (!deadline_request_needs_zone_wlock(dd, rq))
+		return true;
+	return !deadline_zone_is_wlocked(dd, rq);
+}
+
+/*
  * For the specified data direction, return the next request to
  * dispatch using arrival ordered lists.
  */
 static struct request *
 deadline_fifo_request(struct deadline_data *dd, int data_dir)
 {
+	struct request *rq;
+	unsigned long flags;
+
 	if (WARN_ON_ONCE(data_dir != READ && data_dir != WRITE))
 		return NULL;
 
 	if (list_empty(&dd->fifo_list[data_dir]))
 		return NULL;
 
-	return rq_entry_fifo(dd->fifo_list[data_dir].next);
+	if (!dd->zones_wlock || data_dir == READ)
+		return rq_entry_fifo(dd->fifo_list[data_dir].next);
+
+	spin_lock_irqsave(&dd->zone_lock, flags);
+
+	list_for_each_entry(rq, &dd->fifo_list[WRITE], queuelist) {
+		if (deadline_can_dispatch_request(dd, rq))
+			goto out;
+	}
+	rq = NULL;
+
+out:
+	spin_unlock_irqrestore(&dd->zone_lock, flags);
+
+	return rq;
 }
 
 /*
@@ -304,10 +332,25 @@ deadline_fifo_request(struct deadline_data *dd, int data_dir)
 static struct request *
 deadline_next_request(struct deadline_data *dd, int data_dir)
 {
+	struct request *rq;
+	unsigned long flags;
+
 	if (WARN_ON_ONCE(data_dir != READ && data_dir != WRITE))
 		return NULL;
 
-	return dd->next_rq[data_dir];
+	rq = dd->next_rq[data_dir];
+	if (!dd->zones_wlock || data_dir == READ)
+		return rq;
+
+	spin_lock_irqsave(&dd->zone_lock, flags);
+	while (rq) {
+		if (deadline_can_dispatch_request(dd, rq))
+			break;
+		rq = deadline_latter_request(rq);
+	}
+	spin_unlock_irqrestore(&dd->zone_lock, flags);
+
+	return rq;
 }
 
 /*
@@ -349,7 +392,8 @@ static struct request *__dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	if (reads) {
 		BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[READ]));
 
-		if (writes && (dd->starved++ >= dd->writes_starved))
+		if (deadline_fifo_request(dd, WRITE) &&
+		    (dd->starved++ >= dd->writes_starved))
 			goto dispatch_writes;
 
 		data_dir = READ;
@@ -394,6 +438,13 @@ static struct request *__dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 		rq = next_rq;
 	}
 
+	/*
+	 * If we only have writes queued and none of them can be dispatched,
+	 * rq will be NULL.
+	 */
+	if (!rq)
+		return NULL;
+
 	dd->batching = 0;
 
 dispatch_request:
@@ -560,7 +611,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	/*
 	 * This may be a requeue of a request that has locked its
-	 * target zone. If this is the case, release the request zone lock.
+	 * target zone. If this is the case, release the zone lock.
 	 */
 	if (deadline_request_has_zone_wlock(rq))
 		deadline_wunlock_zone(dd, rq);
@@ -570,6 +621,9 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	blk_mq_sched_request_inserted(rq);
 
+	if (at_head && deadline_request_needs_zone_wlock(dd, rq))
+		pr_info("######## Write at head !\n");
+
 	if (at_head || blk_rq_is_passthrough(rq)) {
 		if (at_head)
 			list_add(&rq->queuelist, &dd->dispatch);
-- 
2.13.5
