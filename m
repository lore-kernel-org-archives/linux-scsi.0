From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V7 5/6] block: support PREEMPT_ONLY
Date: Sat, 30 Sep 2017 14:12:13 +0800
Message-ID: <20170930061214.10622-6-ming.lei@redhat.com>
References: <20170930061214.10622-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170930061214.10622-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

When queue is in PREEMPT_ONLY mode, only RQF_PREEMPT request
can be allocated and dispatched, other requests won't be allowed
to enter I/O path.

This is useful for supporting safe SCSI quiesce.

Part of this patch is from Bart's '[PATCH v4 4∕7] block: Add the QUEUE_FLAG_PREEMPT_ONLY
request queue flag'.

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 26 ++++++++++++++++++++++++--
 include/linux/blkdev.h |  5 +++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 95b1c5e50be3..bb683bfe37b2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -346,6 +346,17 @@ void blk_sync_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
+void blk_set_preempt_only(struct request_queue *q, bool preempt_only)
+{
+	blk_mq_freeze_queue(q);
+	if (preempt_only)
+		queue_flag_set_unlocked(QUEUE_FLAG_PREEMPT_ONLY, q);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_PREEMPT_ONLY, q);
+	blk_mq_unfreeze_queue(q);
+}
+EXPORT_SYMBOL(blk_set_preempt_only);
+
 /**
  * __blk_run_queue_uncond - run a queue whether or not it has been stopped
  * @q:	The queue to run
@@ -771,9 +782,18 @@ int blk_queue_enter(struct request_queue *q, unsigned flags)
 	while (true) {
 		int ret;
 
+		/*
+		 * preempt_only flag has to be set after queue is frozen,
+		 * so it can be checked here lockless and safely
+		 */
+		if (blk_queue_preempt_only(q)) {
+			if (!(flags & BLK_REQ_PREEMPT))
+				goto slow_path;
+		}
+
 		if (percpu_ref_tryget_live(&q->q_usage_counter))
 			return 0;
-
+ slow_path:
 		if (flags & BLK_REQ_NOWAIT)
 			return -EBUSY;
 
@@ -787,7 +807,9 @@ int blk_queue_enter(struct request_queue *q, unsigned flags)
 		smp_rmb();
 
 		ret = wait_event_interruptible(q->mq_freeze_wq,
-				!atomic_read(&q->mq_freeze_depth) ||
+				(!atomic_read(&q->mq_freeze_depth) &&
+				((flags & BLK_REQ_PREEMPT) ||
+				 !blk_queue_preempt_only(q))) ||
 				blk_queue_dying(q));
 		if (blk_queue_dying(q))
 			return -ENODEV;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 68445adc8765..b01a0c6bb1f0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -631,6 +631,7 @@ struct request_queue {
 #define QUEUE_FLAG_REGISTERED  26	/* queue has been registered to a disk */
 #define QUEUE_FLAG_SCSI_PASSTHROUGH 27	/* queue supports SCSI commands */
 #define QUEUE_FLAG_QUIESCED    28	/* queue has been quiesced */
+#define QUEUE_FLAG_PREEMPT_ONLY	29	/* only process REQ_PREEMPT requests */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -735,6 +736,10 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
 			     REQ_FAILFAST_DRIVER))
 #define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
+#define blk_queue_preempt_only(q)				\
+	test_bit(QUEUE_FLAG_PREEMPT_ONLY, &(q)->queue_flags)
+
+extern void blk_set_preempt_only(struct request_queue *q, bool preempt_only);
 
 static inline bool blk_account_rq(struct request *rq)
 {
-- 
2.9.5
