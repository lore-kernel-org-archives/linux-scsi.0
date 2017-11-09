From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v12 5/7] block: Add the QUEUE_FLAG_PREEMPT_ONLY request queue flag
Date: Thu, 9 Nov 2017 10:49:57 -0800
Message-ID: <20171109184959.4617-6-bart.vanassche@wdc.com>
References: <20171109184959.4617-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:38599 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753777AbdKISuF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 13:50:05 -0500
In-Reply-To: <20171109184959.4617-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, Bart Van Assche <bart.vanassche@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>

This flag will be used in the next patch to let the block layer
core know whether or not a SCSI request queue has been quiesced.
A quiesced SCSI queue namely only processes RQF_PREEMPT requests.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-core.c       | 30 ++++++++++++++++++++++++++++++
 block/blk-mq-debugfs.c |  1 +
 include/linux/blkdev.h |  6 ++++++
 3 files changed, 37 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 17eed16a6e04..edc276899116 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -348,6 +348,36 @@ void blk_sync_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
+/**
+ * blk_set_preempt_only - set QUEUE_FLAG_PREEMPT_ONLY
+ * @q: request queue pointer
+ *
+ * Returns the previous value of the PREEMPT_ONLY flag - 0 if the flag was not
+ * set and 1 if the flag was already set.
+ */
+int blk_set_preempt_only(struct request_queue *q)
+{
+	unsigned long flags;
+	int res;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	res = queue_flag_test_and_set(QUEUE_FLAG_PREEMPT_ONLY, q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	return res;
+}
+EXPORT_SYMBOL_GPL(blk_set_preempt_only);
+
+void blk_clear_preempt_only(struct request_queue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	queue_flag_clear(QUEUE_FLAG_PREEMPT_ONLY, q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blk_clear_preempt_only);
+
 /**
  * __blk_run_queue_uncond - run a queue whether or not it has been stopped
  * @q:	The queue to run
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 7e3ae8105d5f..b56a4f35720d 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -74,6 +74,7 @@ static const char *const blk_queue_flag_name[] = {
 	QUEUE_FLAG_NAME(REGISTERED),
 	QUEUE_FLAG_NAME(SCSI_PASSTHROUGH),
 	QUEUE_FLAG_NAME(QUIESCED),
+	QUEUE_FLAG_NAME(PREEMPT_ONLY),
 };
 #undef QUEUE_FLAG_NAME
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1af5ddd0f631..2147e2381a22 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -632,6 +632,7 @@ struct request_queue {
 #define QUEUE_FLAG_REGISTERED  26	/* queue has been registered to a disk */
 #define QUEUE_FLAG_SCSI_PASSTHROUGH 27	/* queue supports SCSI commands */
 #define QUEUE_FLAG_QUIESCED    28	/* queue has been quiesced */
+#define QUEUE_FLAG_PREEMPT_ONLY	29	/* only process REQ_PREEMPT requests */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
@@ -732,6 +733,11 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
 			     REQ_FAILFAST_DRIVER))
 #define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
+#define blk_queue_preempt_only(q)				\
+	test_bit(QUEUE_FLAG_PREEMPT_ONLY, &(q)->queue_flags)
+
+extern int blk_set_preempt_only(struct request_queue *q);
+extern void blk_clear_preempt_only(struct request_queue *q);
 
 static inline bool blk_account_rq(struct request *rq)
 {
-- 
2.14.3
