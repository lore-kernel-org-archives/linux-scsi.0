From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/4] block: Fix blk_execute_rq_nowait() dead queue handling
Date: Mon, 25 Jun 2012 18:14:15 +0000
Message-ID: <4FE8AA77.5050005@acm.org>
References: <4FE8A9FC.6040805@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:54679 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2FYSOS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2012 14:14:18 -0400
In-Reply-To: <4FE8A9FC.6040805@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Muthu Kumar <muthu.lkml@gmail.com>, Muthukumar Ratty <muthur@gmail.com>

From: Muthukumar Ratty <muthur@gmail.com>

If the queue is dead blk_execute_rq_nowait() doesn't invoke the done()
callback function. That will result in blk_execute_rq() being stuck
in wait_for_completion(). Avoid this by initializing rq->end_io to the
done() callback before we check the queue state. Also, make sure the
queue lock is held around the invocation of the done() callback. Found
this through source code review.

Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
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
