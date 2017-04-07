From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 3/6] blk-mq: Clarify comments in blk_mq_dispatch_rq_list()
Date: Fri, 7 Apr 2017 11:16:51 -0700
Message-ID: <20170407181654.27836-4-bart.vanassche@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

The blk_mq_dispatch_rq_list() implementation got modified several
times but the comments in that function were not updated every
time. Since it is nontrivial what is going on, update the comments
in blk_mq_dispatch_rq_list().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 block/blk-mq.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index dba34eb79a08..aff85d41cea3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1063,8 +1063,8 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list)
 	 */
 	if (!list_empty(list)) {
 		/*
-		 * If we got a driver tag for the next request already,
-		 * free it again.
+		 * If an I/O scheduler has been configured and we got a driver
+		 * tag for the next request already, free it again.
 		 */
 		rq = list_first_entry(list, struct request, queuelist);
 		blk_mq_put_driver_tag(rq);
@@ -1074,16 +1074,24 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list)
 		spin_unlock(&hctx->lock);
 
 		/*
-		 * the queue is expected stopped with BLK_MQ_RQ_QUEUE_BUSY, but
-		 * it's possible the queue is stopped and restarted again
-		 * before this. Queue restart will dispatch requests. And since
-		 * requests in rq_list aren't added into hctx->dispatch yet,
-		 * the requests in rq_list might get lost.
+		 * If SCHED_RESTART was set by the caller of this function and
+		 * it is no longer set that means that it was cleared by another
+		 * thread and hence that a queue rerun is needed.
 		 *
-		 * blk_mq_run_hw_queue() already checks the STOPPED bit
+		 * If TAG_WAITING is set that means that an I/O scheduler has
+		 * been configured and another thread is waiting for a driver
+		 * tag. To guarantee fairness, do not rerun this hardware queue
+		 * but let the other thread grab the driver tag.
 		 *
-		 * If RESTART or TAG_WAITING is set, then let completion restart
-		 * the queue instead of potentially looping here.
+		 * If no I/O scheduler has been configured it is possible that
+		 * the hardware queue got stopped and restarted before requests
+		 * were pushed back onto the dispatch list. Rerun the queue to
+		 * avoid starvation. Notes:
+		 * - blk_mq_run_hw_queue() checks whether or not a queue has
+		 *   been stopped before rerunning a queue.
+		 * - Some but not all block drivers stop a queue before
+		 *   returning BLK_MQ_RQ_QUEUE_BUSY. Two exceptions are scsi-mq
+		 *   and dm-rq.
 		 */
 		if (!blk_mq_sched_needs_restart(hctx) &&
 		    !test_bit(BLK_MQ_S_TAG_WAITING, &hctx->state))
-- 
2.12.0
