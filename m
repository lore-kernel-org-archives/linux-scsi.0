From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: Smart plugging of multiple devices connected to a single controller
Date: Wed, 22 Oct 2008 21:22:38 +0200
Message-ID: <87skqoph8h.fsf@denkblock.local>
References: <87y70gpjxg.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <87y70gpjxg.fsf@denkblock.local> (Elias Oltmanns's message of
	"Wed, 22 Oct 2008 20:24:27 +0200")
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
> Hi Jens,
>
> in an effort to avoid calling the ->request_fn() from hard irq context
> in ide, a patch like the one attached below would seem convenient (not
> even compile tested yet).

Well, I should have actually attach the patch. Here it is then.

> However, before implementing this or, indeed, in case you should
> outright reject this patch, I'd like to ask for your opinion about a
> more general approach: Since ide, scsi and libata (once it has moved
> out of scsi) have very similar issues with devices that cannot process
> the request queue in parallel (typically because they are connected to
> the same controller), would it be appropriate to deal with that in the
> block layer directly? Currently, I'm mainly concerned with the problem
> that devices connected to the same controller are served without too
> much discrimination due to races in the (un)plug logic, which is
> currently being dealt with more or less cleverly in scsi / ide.
> Generally though, there might be other shared resources (like a tag
> map, etc.) that could be maintained in a in a block layer structure
> similar to struct Scsi_Host. All request queues belonging to such a
> group could be added to a circular link list rooted at the structure
> containing the shared resources, i.e. the unplug_timer and whatever
> you deem adequate to be moved there.
>
> What do you think about it?
>
> Regards,
>
> Elias

---
 block/blk-core.c       |   27 ++++++++++++++++++---------
 include/linux/blkdev.h |    1 +
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c3df30c..fcdcb09 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -322,6 +322,15 @@ void blk_unplug(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_unplug);
 
+void blk_schedule_queue_run(struct request_queue *q)
+{
+	if (!elv_queue_empty(q)) {
+		queue_flag_set(QUEUE_FLAG_PLUGGED, q);
+		kblockd_schedule_work(q, &q->unplug_work);
+	}
+}
+EXPORT_SYMBOL_GPL(blk_schedule_queue_run);
+
 static void blk_invoke_request_fn(struct request_queue *q)
 {
 	if (unlikely(blk_queue_stopped(q)))
@@ -331,13 +340,14 @@ static void blk_invoke_request_fn(struct request_queue *q)
 	 * one level of recursion is ok and is much faster than kicking
 	 * the unplug handling
 	 */
-	if (!queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
-		q->request_fn(q);
-		queue_flag_clear(QUEUE_FLAG_REENTER, q);
-	} else {
-		queue_flag_set(QUEUE_FLAG_PLUGGED, q);
-		kblockd_schedule_work(q, &q->unplug_work);
-	}
+	if (!test_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+		if (!elv_queue_empty(q)) {
+			queue_flag_set(QUEUE_FLAG_REENTER, q);
+			q->request_fn(q);
+			queue_flag_clear(QUEUE_FLAG_REENTER, q);
+		}
+	} else
+		blk_schedule_queue_run(q);
 }
 
 /**
@@ -417,8 +427,7 @@ void __blk_run_queue(struct request_queue *q)
 	 * Only recurse once to avoid overrunning the stack, let the unplug
 	 * handling reinvoke the handler shortly if we already got there.
 	 */
-	if (!elv_queue_empty(q))
-		blk_invoke_request_fn(q);
+	blk_invoke_request_fn(q);
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b4fe68f..516851e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -753,6 +753,7 @@ extern void blk_sync_queue(struct request_queue *q);
 extern void __blk_stop_queue(struct request_queue *q);
 extern void __blk_run_queue(struct request_queue *);
 extern void blk_run_queue(struct request_queue *);
+extern void blk_schedule_queue_run(struct request_queue *q);
 extern void blk_start_queueing(struct request_queue *);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
