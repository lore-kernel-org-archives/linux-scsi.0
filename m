From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5/6] blk-mq: don't stop queue for quiescing
Date: Fri, 26 May 2017 11:07:38 +0800
Message-ID: <20170526030740.26959-6-ming.lei@redhat.com>
References: <20170526030740.26959-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170526030740.26959-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Now we use the QUIESCED flag to drain & block dispatching,
not necessary to stop queue any more.

Also queue can be started by other blk-mq APIs, this limits
uses of blk_mq_quiesce_queue().

Now blk_mq_quiesce_queue() can be used safely and users won't
worry about queue restart during quiescing.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e1fc9ab50c87..900eb91e0ece 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -168,8 +168,6 @@ void blk_mq_quiesce_queue(struct request_queue *q)
 	unsigned int i;
 	bool rcu = false;
 
-	__blk_mq_stop_hw_queues(q, true);
-
 	spin_lock_irq(q->queue_lock);
 	queue_flag_set(QUEUE_FLAG_QUIESCED, q);
 	spin_unlock_irq(q->queue_lock);
@@ -198,7 +196,12 @@ void blk_mq_unquiesce_queue(struct request_queue *q)
 	queue_flag_clear(QUEUE_FLAG_QUIESCED, q);
 	spin_unlock_irq(q->queue_lock);
 
-	blk_mq_start_stopped_hw_queues(q, true);
+	/*
+	 * During quiescing, requests can be inserted
+	 * to scheduler queue or sw queue, so we run
+	 * queues for dispatching these requests.
+	 */
+	blk_mq_start_hw_queues(q);
 }
 EXPORT_SYMBOL_GPL(blk_mq_unquiesce_queue);
 
-- 
2.9.4
