From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V5 10/14] block: mq-deadline: Add zoned block device data
Date: Mon, 25 Sep 2017 15:14:50 +0900
Message-ID: <20170925061454.5533-11-damien.lemoal@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:20296 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932427AbdIYGPJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 02:15:09 -0400
In-Reply-To: <20170925061454.5533-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Introduce new fields to mq-deadline private data to support zoned block
devices. The fields are a zone bitmap used to implement zone write
locking and a spinlock to atomically handle zone write locking with
other processing.

Modify mq-dealine init_queue and exit_queue elevator methods to handle
initialization and cleanup of the zone write lock bitmap.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/mq-deadline.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index a1cad4331edd..af2eb9b3936e 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -60,6 +60,9 @@ struct deadline_data {
 
 	spinlock_t lock;
 	struct list_head dispatch;
+
+	spinlock_t zone_lock;
+	unsigned long *zones_wlock;
 };
 
 static inline struct rb_root *
@@ -300,6 +303,34 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	return rq;
 }
 
+static int deadline_init_zones_wlock(struct request_queue *q,
+				     struct deadline_data *dd)
+{
+	/*
+	 * For regular drives or non-conforming zoned block device,
+	 * do not use zone write locking.
+	 */
+	if (!blk_queue_nr_zones(q))
+		return 0;
+
+	/*
+	 * Treat host aware drives as regular disks.
+	 */
+	if (blk_queue_zoned_model(q) != BLK_ZONED_HM)
+		return 0;
+
+	dd->zones_wlock = kzalloc_node(BITS_TO_LONGS(blk_queue_nr_zones(q))
+				       * sizeof(unsigned long),
+				       GFP_KERNEL, q->node);
+	if (!dd->zones_wlock)
+		return -ENOMEM;
+
+	pr_info("mq-deadline: %s: zones write locking enabled\n",
+		dev_name(q->backing_dev_info->dev));
+
+	return 0;
+}
+
 static void dd_exit_queue(struct elevator_queue *e)
 {
 	struct deadline_data *dd = e->elevator_data;
@@ -307,6 +338,7 @@ static void dd_exit_queue(struct elevator_queue *e)
 	BUG_ON(!list_empty(&dd->fifo_list[READ]));
 	BUG_ON(!list_empty(&dd->fifo_list[WRITE]));
 
+	kfree(dd->zones_wlock);
 	kfree(dd);
 }
 
@@ -317,16 +349,15 @@ static int dd_init_queue(struct request_queue *q, struct elevator_type *e)
 {
 	struct deadline_data *dd;
 	struct elevator_queue *eq;
+	int ret = -ENOMEM;
 
 	eq = elevator_alloc(q, e);
 	if (!eq)
 		return -ENOMEM;
 
 	dd = kzalloc_node(sizeof(*dd), GFP_KERNEL, q->node);
-	if (!dd) {
-		kobject_put(&eq->kobj);
-		return -ENOMEM;
-	}
+	if (!dd)
+		goto out_put_elv;
 	eq->elevator_data = dd;
 
 	INIT_LIST_HEAD(&dd->fifo_list[READ]);
@@ -340,9 +371,20 @@ static int dd_init_queue(struct request_queue *q, struct elevator_type *e)
 	dd->fifo_batch = fifo_batch;
 	spin_lock_init(&dd->lock);
 	INIT_LIST_HEAD(&dd->dispatch);
+	spin_lock_init(&dd->zone_lock);
+
+	ret = deadline_init_zones_wlock(q, dd);
+	if (ret)
+		goto out_free_dd;
 
 	q->elevator = eq;
 	return 0;
+
+out_free_dd:
+	kfree(dd);
+out_put_elv:
+	kobject_put(&eq->kobj);
+	return ret;
 }
 
 static int dd_request_merge(struct request_queue *q, struct request **rq,
-- 
2.13.5
