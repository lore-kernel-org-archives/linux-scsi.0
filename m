From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/5] block: Fix blk_execute_rq_nowait() dead queue handling
Date: Fri, 29 Jun 2012 15:31:49 +0000
Message-ID: <4FEDCA65.30608@acm.org>
References: <4FEDCA26.90804@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:45688 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab2F2Pbw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jun 2012 11:31:52 -0400
In-Reply-To: <4FEDCA26.90804@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Mike Christie <michaelc@cs.wisc.edu>, Muthukumar Ratty <muthur@gmail.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tejun Heo <tj@kernel.org>

From: Muthukumar Ratty <muthur@gmail.com>

If the queue is dead blk_execute_rq_nowait() doesn't invoke the done()
callback function. That will result in blk_execute_rq() being stuck
in wait_for_completion(). Avoid this by initializing rq->end_io to the
done() callback before we check the queue state. Also, make sure the
queue lock is held around the invocation of the done() callback. Found
this through source code review.

Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <JBottomley@parallels.com>
---
 block/blk-exec.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index fb2cbd5..8b6dc5b 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -43,6 +43,9 @@ static void blk_end_sync_rq(struct request *rq, int error)
  * Description:
  *    Insert a fully prepared request at the back of the I/O scheduler queue
  *    for execution.  Don't wait for completion.
+ *
+ * Note:
+ *    This function will invoke @done directly if the queue is dead.
  */
 void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 			   struct request *rq, int at_head,
@@ -51,18 +54,20 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 
 	WARN_ON(irqs_disabled());
+
+	rq->rq_disk = bd_disk;
+	rq->end_io = done;
+
 	spin_lock_irq(q->queue_lock);
 
 	if (unlikely(blk_queue_dead(q))) {
-		spin_unlock_irq(q->queue_lock);
 		rq->errors = -ENXIO;
 		if (rq->end_io)
 			rq->end_io(rq, rq->errors);
+		spin_unlock_irq(q->queue_lock);
 		return;
 	}
 
-	rq->rq_disk = bd_disk;
-	rq->end_io = done;
 	__elv_add_request(q, rq, where);
 	__blk_run_queue(q);
 	/* the queue is stopped so it won't be run */
-- 
1.7.7


