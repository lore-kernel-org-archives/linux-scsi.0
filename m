From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V4 10/16] block: mq-deadline: Add zoned block device data
Date: Sun, 24 Sep 2017 16:02:41 +0900
Message-ID: <20170924070247.25560-11-damien.lemoal@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Introduce new fields to mq-deadline private data to support zoned block
devices. The fields added provide a back pointer to the device request
queue to give access to the device zone model and zone information.
Also added are a zone bitmap used to implement zone write locking and
a spinlock to atomically handle zone locking with other processing.

Modify mq-dealine init_queue and exit_queue elevator methods to handle
initialization and cleanup of these fields.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/mq-deadline.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index a1cad4331edd..53b1d16179ad 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -60,6 +60,10 @@ struct deadline_data {
 
 	spinlock_t lock;
 	struct list_head dispatch;
+
+	struct request_queue *q;
+	spinlock_t zone_lock;
+	unsigned long *zones_wlock;
 };
 
 static inline struct rb_root *
@@ -300,6 +304,24 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	return rq;
 }
 
+static int deadline_enable_zones_wlock(struct deadline_data *dd,
+				       gfp_t gfp_mask)
+{
+	dd->zones_wlock = kzalloc_node(BITS_TO_LONGS(blk_queue_nr_zones(dd->q))
+				       * sizeof(unsigned long),
+				       gfp_mask, dd->q->node);
+	if (!dd->zones_wlock)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void deadline_disable_zones_wlock(struct deadline_data *dd)
+{
+	kfree(dd->zones_wlock);
+	dd->zones_wlock = NULL;
+}
+
 static void dd_exit_queue(struct elevator_queue *e)
 {
 	struct deadline_data *dd = e->elevator_data;
@@ -307,16 +329,40 @@ static void dd_exit_queue(struct elevator_queue *e)
 	BUG_ON(!list_empty(&dd->fifo_list[READ]));
 	BUG_ON(!list_empty(&dd->fifo_list[WRITE]));
 
+	deadline_disable_zones_wlock(dd);
 	kfree(dd);
 }
 
 /*
+ * initialize zoned block device related elevator private data.
+ */
+static int deadline_zoned_init_queue(struct request_queue *q,
+				     struct deadline_data *dd)
+{
+	if (!blk_queue_is_zoned(q) ||
+	    !blk_queue_nr_zones(q)) {
+		/*
+		 * Regular drive, or non-conforming zoned block device.
+		 * Do not use zone write locking.
+		 */
+		return 0;
+	}
+
+	/*
+	 * Enable zone write locking by default for any zoned
+	 * block device model.
+	 */
+	return deadline_enable_zones_wlock(dd, GFP_KERNEL);
+}
+
+/*
  * initialize elevator private data (deadline_data).
  */
 static int dd_init_queue(struct request_queue *q, struct elevator_type *e)
 {
 	struct deadline_data *dd;
 	struct elevator_queue *eq;
+	int ret;
 
 	eq = elevator_alloc(q, e);
 	if (!eq)
@@ -341,6 +387,15 @@ static int dd_init_queue(struct request_queue *q, struct elevator_type *e)
 	spin_lock_init(&dd->lock);
 	INIT_LIST_HEAD(&dd->dispatch);
 
+	dd->q = q;
+	spin_lock_init(&dd->zone_lock);
+	ret = deadline_zoned_init_queue(q, dd);
+	if (ret) {
+		kfree(dd);
+		kobject_put(&eq->kobj);
+		return ret;
+	}
+
 	q->elevator = eq;
 	return 0;
 }
-- 
2.13.5
