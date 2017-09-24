From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V4 14/16] block: mq-deadline: Limit write dispatch for zoned block devices
Date: Sun, 24 Sep 2017 16:02:45 +0900
Message-ID: <20170924070247.25560-15-damien.lemoal@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:35286 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbdIXHDI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2017 03:03:08 -0400
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

When dispatching writes to a zoned block device, only allow the request
to be dispatched if its target zone is not locked. If it is, leave the
request in the scheduler queues and look for another suitable write
request. If no write can be dispatched, allow reads to be dispatched
even if the write batch is not done.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/mq-deadline.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 57 insertions(+), 4 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 2de1a36c34f5..8725b4f950c1 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -283,16 +283,44 @@ static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
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
@@ -302,7 +330,21 @@ deadline_fifo_request(struct deadline_data *dd, int data_dir)
 static struct request *
 deadline_next_request(struct deadline_data *dd, int data_dir)
 {
-	return dd->next_rq[data_dir];
+	struct request *rq = dd->next_rq[data_dir];
+	unsigned long flags;
+
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
@@ -344,7 +386,8 @@ static struct request *__dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	if (reads) {
 		BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[READ]));
 
-		if (writes && (dd->starved++ >= dd->writes_starved))
+		if (deadline_fifo_request(dd, WRITE) &&
+		    (dd->starved++ >= dd->writes_starved))
 			goto dispatch_writes;
 
 		data_dir = READ;
@@ -389,6 +432,13 @@ static struct request *__dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
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
@@ -566,7 +616,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	/*
 	 * This may be a requeue of a request that has locked its
-	 * target zone. If this is the case, release the request zone lock.
+	 * target zone. If this is the case, release the zone lock.
 	 */
 	if (deadline_request_has_zone_wlock(rq))
 		deadline_wunlock_zone(dd, rq);
@@ -576,6 +626,9 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	blk_mq_sched_request_inserted(rq);
 
+	if (at_head && deadline_request_needs_zone_wlock(dd, rq))
+		pr_info("######## Write at head !\n");
+
 	if (at_head || blk_rq_is_passthrough(rq)) {
 		if (at_head)
 			list_add(&rq->queuelist, &dd->dispatch);
-- 
2.13.5
