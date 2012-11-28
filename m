From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 04/13] block: Avoid scheduling delayed work on a dead queue
Date: Wed, 28 Nov 2012 13:45:56 +0100
Message-ID: <50B60784.1080604@acm.org>
References: <50B60619.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:46499 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab2K1Mp6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2012 07:45:58 -0500
In-Reply-To: <50B60619.4080406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Running a queue must continue after it has been marked dying until
it has been marked dead. So the function blk_run_queue_async() must
not schedule delayed work after blk_cleanup_queue() has marked a queue
dead. Hence add a test for that queue state in blk_run_queue_async()
and make sure that queue_unplugged() invokes that function with the
queue lock held. This avoids that the queue state can change after
it has been tested and before mod_delayed_work() is invoked. Drop
the queue dying test in queue_unplugged() since it is now
superfluous: __blk_run_queue() already tests whether or not the
queue is dead.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c |   33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b8ba9fb..12deca9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -219,12 +219,13 @@ static void blk_delay_work(struct work_struct *work)
  * Description:
  *   Sometimes queueing needs to be postponed for a little while, to allow
  *   resources to come back. This function will make sure that queueing is
- *   restarted around the specified time.
+ *   restarted around the specified time. Queue lock must be held.
  */
 void blk_delay_queue(struct request_queue *q, unsigned long msecs)
 {
-	queue_delayed_work(kblockd_workqueue, &q->delay_work,
-				msecs_to_jiffies(msecs));
+	if (likely(!blk_queue_dead(q)))
+		queue_delayed_work(kblockd_workqueue, &q->delay_work,
+				   msecs_to_jiffies(msecs));
 }
 EXPORT_SYMBOL(blk_delay_queue);
 
@@ -334,11 +335,11 @@ EXPORT_SYMBOL(__blk_run_queue);
  *
  * Description:
  *    Tells kblockd to perform the equivalent of @blk_run_queue on behalf
- *    of us.
+ *    of us. The caller must hold the queue lock.
  */
 void blk_run_queue_async(struct request_queue *q)
 {
-	if (likely(!blk_queue_stopped(q)))
+	if (likely(!blk_queue_stopped(q) && !blk_queue_dead(q)))
 		mod_delayed_work(kblockd_workqueue, &q->delay_work, 0);
 }
 EXPORT_SYMBOL(blk_run_queue_async);
@@ -2913,27 +2914,11 @@ static void queue_unplugged(struct request_queue *q, unsigned int depth,
 {
 	trace_block_unplug(q, depth, !from_schedule);
 
-	/*
-	 * Don't mess with a dying queue.
-	 */
-	if (unlikely(blk_queue_dying(q))) {
-		spin_unlock(q->queue_lock);
-		return;
-	}
-
-	/*
-	 * If we are punting this to kblockd, then we can safely drop
-	 * the queue_lock before waking kblockd (which needs to take
-	 * this lock).
-	 */
-	if (from_schedule) {
-		spin_unlock(q->queue_lock);
+	if (from_schedule)
 		blk_run_queue_async(q);
-	} else {
+	else
 		__blk_run_queue(q);
-		spin_unlock(q->queue_lock);
-	}
-
+	spin_unlock(q->queue_lock);
 }
 
 static void flush_plug_callbacks(struct blk_plug *plug, bool from_schedule)
-- 
1.7.10.4

