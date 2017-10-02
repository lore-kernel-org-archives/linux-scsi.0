From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V6 10/14] block: mq-deadline: Add zoned block device data
Date: Mon,  2 Oct 2017 16:15:31 +0900
Message-ID: <20171002071535.8007-11-damien.lemoal@wdc.com>
References: <20171002071535.8007-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:22502 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdJBHPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2017 03:15:49 -0400
In-Reply-To: <20171002071535.8007-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Introduce a zone bitmap field in mq-deadline private data to support
zoned block devices. The zone bitmap is used to implement per zone
write locking. Modify mq-deadline init_queue() and exit_queue()
elevator methods to handle initialization and cleanup of the zone write
lock bitmap.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/mq-deadline.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index a1cad4331edd..f0c01ef934b4 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -60,6 +60,8 @@ struct deadline_data {
 
 	spinlock_t lock;
 	struct list_head dispatch;
+
+	unsigned long *zones_wlock;
 };
 
 static inline struct rb_root *
@@ -300,6 +302,34 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
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
@@ -307,6 +337,7 @@ static void dd_exit_queue(struct elevator_queue *e)
 	BUG_ON(!list_empty(&dd->fifo_list[READ]));
 	BUG_ON(!list_empty(&dd->fifo_list[WRITE]));
 
+	kfree(dd->zones_wlock);
 	kfree(dd);
 }
 
@@ -317,16 +348,15 @@ static int dd_init_queue(struct request_queue *q, struct elevator_type *e)
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
@@ -341,8 +371,18 @@ static int dd_init_queue(struct request_queue *q, struct elevator_type *e)
 	spin_lock_init(&dd->lock);
 	INIT_LIST_HEAD(&dd->dispatch);
 
+	ret = deadline_init_zones_wlock(q, dd);
+	if (ret)
+		goto out_free_dd;
+
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
2.13.6
