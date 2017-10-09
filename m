From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v7 8/9] block: Add the QUEUE_FLAG_PREEMPT_ONLY request queue flag
Date: Mon,  9 Oct 2017 16:13:59 -0700
Message-ID: <20171009231400.562-9-bart.vanassche@wdc.com>
References: <20171009231400.562-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:54488 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755648AbdJIXOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2017 19:14:10 -0400
In-Reply-To: <20171009231400.562-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

This flag will be used in the next patch to let the block layer
core know whether or not a SCSI request queue has been quiesced.
A quiesced SCSI queue namely only processes RQF_PREEMPT requests.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-core.c       | 30 ++++++++++++++++++++++++++++++
 block/blk-mq-debugfs.c |  1 +
 include/linux/blkdev.h |  6 ++++++
 3 files changed, 37 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 842e67e0b7ab..ed992cbd107f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -346,6 +346,36 @@ void blk_sync_queue(struct request_queue *q)
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
index 7f4a1ba532af..75f31535f280 100644
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
index 3f7b08a9b9ae..89555eea742b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -630,6 +630,7 @@ struct request_queue {
 #define QUEUE_FLAG_REGISTERED  26	/* queue has been registered to a disk */
 #define QUEUE_FLAG_SCSI_PASSTHROUGH 27	/* queue supports SCSI commands */
 #define QUEUE_FLAG_QUIESCED    28	/* queue has been quiesced */
+#define QUEUE_FLAG_PREEMPT_ONLY	29	/* only process REQ_PREEMPT requests */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
@@ -730,6 +731,11 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
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
2.14.2
