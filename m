From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V6 13/14] block: mq-deadline: Limit write request dispatch for zoned block devices
Date: Mon,  2 Oct 2017 16:15:34 +0900
Message-ID: <20171002071535.8007-14-damien.lemoal@wdc.com>
References: <20171002071535.8007-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171002071535.8007-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

When dispatching write requests to a zoned block device, only allow
requests targeting an unlocked zone. Requests targeting a locked zone
are left in the scheduler queue to preserve the initial write order.
If no write request can be dispatched, allow reads to be dispatched
even if the write batch is not done.

To ensure that the search for an appropriate write request is atomic
in deadline_fifo_request() and deadline_next_request() with reagrd to
write requests zone lock state, introduce the spinlock zone_lock.
Holding this lock while doing the search in these functions as well as
when unlocking the target zone of a completed write request in
dd_completed_request() ensure that the search does not pickup a write
request in the middle of a zone queued write sequence.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/mq-deadline.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 3 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 93a1aede5dd0..cbca24e1f96e 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -61,6 +61,7 @@ struct deadline_data {
 	spinlock_t lock;
 	struct list_head dispatch;
 
+	spinlock_t zone_lock;
 	unsigned long *zones_wlock;
 };
 
@@ -244,12 +245,24 @@ static void deadline_wlock_zone(struct deadline_data *dd,
 
 /*
  * Write unlock the target zone of a write request.
+ * Clearing the target zone write lock bit is done with the scheduler zone_lock
+ * spinlock held so that deadline_next_request() and deadline_fifo_request()
+ * cannot see the lock state of a zone change due to a request completion during
+ * their eventual search for an appropriate write request. Otherwise, for a zone
+ * with multiple write requests queued, a non sequential write request
+ * can be chosen.
  */
 static void deadline_wunlock_zone(struct deadline_data *dd,
 				  struct request *rq)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&dd->zone_lock, flags);
+
 	WARN_ON_ONCE(!test_and_clear_bit(blk_rq_zone_no(rq), dd->zones_wlock));
 	deadline_clear_request_zone_wlock(rq);
+
+	spin_unlock_irqrestore(&dd->zone_lock, flags);
 }
 
 /*
@@ -279,19 +292,47 @@ static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
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
@@ -301,10 +342,25 @@ deadline_fifo_request(struct deadline_data *dd, int data_dir)
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
@@ -346,7 +402,8 @@ static struct request *__dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	if (reads) {
 		BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[READ]));
 
-		if (writes && (dd->starved++ >= dd->writes_starved))
+		if (deadline_fifo_request(dd, WRITE) &&
+		    (dd->starved++ >= dd->writes_starved))
 			goto dispatch_writes;
 
 		data_dir = READ;
@@ -391,6 +448,13 @@ static struct request *__dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
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
@@ -490,6 +554,7 @@ static int dd_init_queue(struct request_queue *q, struct elevator_type *e)
 	spin_lock_init(&dd->lock);
 	INIT_LIST_HEAD(&dd->dispatch);
 
+	spin_lock_init(&dd->zone_lock);
 	ret = deadline_init_zones_wlock(q, dd);
 	if (ret)
 		goto out_free_dd;
-- 
2.13.6
