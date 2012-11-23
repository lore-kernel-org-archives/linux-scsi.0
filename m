From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/7 v5] More device removal fixes
Date: Fri, 23 Nov 2012 11:37:58 +0100
Message-ID: <50AF5206.9060608@acm.org>
References: <508A7B63.60608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:55266 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2KWKiC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Nov 2012 05:38:02 -0500
In-Reply-To: <508A7B63.60608@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 10/26/12 14:00, Bart Van Assche wrote:
> Fix a few race conditions that can be triggered by removing a device:
> [ ... ]

Hello,

I'd like to add the patch below to this series. This is something I came
up with after analyzing why a crash was triggered during an SRP failover
test. One of the functions in the crash call stack was blk_delay_work().

Bart.


[PATCH] block: Avoid scheduling delayed work on a dead queue

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
 block/blk-core.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e4f4e06..212c878 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -343,11 +343,11 @@ EXPORT_SYMBOL(__blk_run_queue);
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
@@ -2923,27 +2923,11 @@ static void queue_unplugged(struct request_queue *q, unsigned int depth,
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


