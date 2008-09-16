From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 02/13] block: add request submission interface
Date: Tue, 16 Sep 2008 12:06:56 -0400 (EDT)
Message-ID: <20080916.120656.78704115.k-ueda@ct.jp.nec.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	<20080912.104152.63132582.k-ueda@ct.jp.nec.com>
	<48CD0D62.4020303@panasas.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48CD0D62.4020303@panasas.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bharrosh@panasas.com, jens.axboe@oracle.com
Cc: k-ueda@ct.jp.nec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi Boaz, Jens,

On Sun, 14 Sep 2008 16:10:58 +0300, Boaz Harrosh wrote:
> Kiyoshi Ueda wrote:
> > This patch adds blk_submit_request(), a generic request submission
> > interface for request stacking drivers.
> > Request-based dm will use it to submit their clones to underlying
> > devices.
> > 
> > blk_rq_check_limits() is also added because it is possible that
> > the lower queue has stronger limitations than the upper queue
> > if multiple drivers are stacking at request-level.
> > Not only for blk_submit_request()'s internal use, the function
> > will be used by request-based dm when the queue limitation is
> > modified (e.g. by replacing dm's table).
> > 
> > 
> > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  block/blk-core.c       |   81 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/blkdev.h |    2 +
> >  2 files changed, 83 insertions(+)
> > 
> > Index: 2.6.27-rc6/block/blk-core.c
> > ===================================================================
> > --- 2.6.27-rc6.orig/block/blk-core.c
> > +++ 2.6.27-rc6/block/blk-core.c
> > @@ -1517,6 +1517,87 @@ void submit_bio(int rw, struct bio *bio)
> >  EXPORT_SYMBOL(submit_bio);
> >  
> >  /**
> > + * blk_rq_check_limits - Helper function to check a request for the queue limit
> > + * @q:  the queue
> > + * @rq: the request being checked
> > + *
> > + * Description:
> > + *    @rq may have been made based on weaker limitations of upper-level queues
> > + *    in request stacking drivers, and it may violate the limitation of @q.
> > + *    Since the block layer and the underlying device driver trust @rq
> > + *    after it is inserted to @q, it should be checked against @q before
> > + *    the insertion using this generic function.
> > + *
> > + *    This function should also be useful for request stacking drivers
> > + *    in some cases below, so export this fuction.
> > + *    Request stacking drivers like request-based dm may change the queue
> > + *    limits while requests are in the queue (e.g. dm's table swapping).
> > + *    Such request stacking drivers should check those requests agaist
> > + *    the new queue limits again when they dispatch those requests,
> > + *    although such checkings are also done against the old queue limits
> > + *    when submitting requests.
> > + */
> > +int blk_rq_check_limits(struct request_queue *q, struct request *rq)
> > +{
> > +	if (rq->nr_sectors > q->max_sectors ||
> > +	    rq->data_len > q->max_hw_sectors << 9) {
> > +		printk(KERN_ERR "%s: over max size limit.\n", __func__);
> > +		return -EIO;
> > +	}
> > +
> > +	/*
> > +	 * queue's settings related to segment counting like q->bounce_pfn
> > +	 * may differ from that of other stacking queues.
> > +	 * Recalculate it to check the request correctly on this queue's
> > +	 * limitation.
> > +	 */
> > +	blk_recalc_rq_segments(rq);
> > +	if (rq->nr_phys_segments > q->max_phys_segments ||
> > +	    rq->nr_hw_segments > q->max_hw_segments) {
> > +		printk(KERN_ERR "%s: over max segments limit.\n", __func__);
> > +		return -EIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(blk_rq_check_limits);
> > +
> > +/**
> > + * blk_submit_request - Helper for stacking drivers to submit a request
> > + * @q:  the queue to submit the request
> > + * @rq: the request being queued
> > + */
> > +int blk_submit_request(struct request_queue *q, struct request *rq)
> > +{
> > +	unsigned long flags;
> > +
> > +	if (blk_rq_check_limits(q, rq))
> > +		return -EIO;
> > +
> > +#ifdef CONFIG_FAIL_MAKE_REQUEST
> > +	if (rq->rq_disk && rq->rq_disk->flags & GENHD_FL_FAIL &&
> > +	    should_fail(&fail_make_request, blk_rq_bytes(rq)))
> > +		return -EIO;
> > +#endif
> > +
> > +	spin_lock_irqsave(q->queue_lock, flags);
> > +
> > +	/*
> > +	 * Submitting request must be dequeued before calling this function
> > +	 * because it will be linked to another request_queue
> > +	 */
> > +	BUG_ON(blk_queued_rq(rq));
> > +
> > +	drive_stat_acct(rq, 1);
> > +	__elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 0);
> > +
> > +	spin_unlock_irqrestore(q->queue_lock, flags);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(blk_submit_request);
> > +
> 
> This looks awfully similar to blk_execute_rq_nowait With an Added 
> blk_rq_check_limits, minus the __generic_unplug_device() and
> q->request_fn(q) calls. Perhaps the common code could be re factored
> out?

They might look simlar but don't have much in common actually.
I could refactor them like the attached patch, but I'm not sure
this is a correct way and this is cleaner than the current code.
(e.g. blk_execute_rq_nowait() can't be called with irqs-disabled,
 but blk_insert_request() and my blk_submit_request() can be called
 with irqs-disabled.)

So I'd leave them as it is unless you or others strongly prefer
the attached patch...
Anyway, I would like to leave the refactoring as a separate patch,
since it's not so straightforward.


> Also isn't block-exec.c a better file for this function?

blk_insert_request() is in blk-core.c and it is similar to
blk_submit_request(), so I added it to blk-core.c.
But maybe both should be in blk-exec.c.
I don't have any problem on this, I'd like to hear Jens' opinion.

Thanks,
Kiyoshi Ueda

---
 block/blk-core.c |   20 +++----------------
 block/blk-exec.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 54 insertions(+), 23 deletions(-)

Index: linux-2.6-block/block/blk-core.c
===================================================================
--- linux-2.6-block.orig/block/blk-core.c
+++ linux-2.6-block/block/blk-core.c
@@ -881,7 +881,7 @@ EXPORT_SYMBOL(blk_get_request);
  */
 void blk_start_queueing(struct request_queue *q)
 {
-	if (!blk_queue_plugged(q))
+	if (!blk_queue_plugged(q) && !blk_queue_stopped(q))
 		q->request_fn(q);
 	else
 		__generic_unplug_device(q);
@@ -930,11 +930,10 @@ EXPORT_SYMBOL(blk_requeue_request);
  *    of the queue for things like a QUEUE_FULL message from a device, or a
  *    host that is unable to accept a particular command.
  */
-void blk_insert_request(struct request_queue *q, struct request *rq,
-			int at_head, void *data)
+void blk_insert_special_request(struct request_queue *q, struct request *rq,
+				int at_head, void *data)
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
-	unsigned long flags;
 
 	/*
 	 * tell I/O scheduler that this isn't a regular read/write (ie it
@@ -946,18 +945,7 @@ void blk_insert_request(struct request_q
 
 	rq->special = data;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-
-	/*
-	 * If command is tagged, release the tag
-	 */
-	if (blk_rq_tagged(rq))
-		blk_queue_end_tag(q, rq);
-
-	drive_stat_acct(rq, 1);
-	__elv_add_request(q, rq, where, 0);
-	blk_start_queueing(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	blk_insert_request(q, rq, where, 1);
 }
 EXPORT_SYMBOL(blk_insert_request);
 
Index: linux-2.6-block/block/blk-exec.c
===================================================================
--- linux-2.6-block.orig/block/blk-exec.c
+++ linux-2.6-block/block/blk-exec.c
@@ -33,6 +33,46 @@ static void blk_end_sync_rq(struct reque
 }
 
 /**
+ * blk_insert_request - Helper function for inserting a request
+ * @q:          request queue where request should be inserted
+ * @rq:         request to be inserted
+ * @where:      where insert request to
+ * @run_queue:  run the queue or not
+ */
+static void blk_insert_request(struct request_queue *q, struct request *rq,
+			       int where, int run_queue)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+
+	/*
+	 * Submitting request must be dequeued before calling this function
+	 * because it will be linked to another request_queue
+	 */
+	BUG_ON(blk_queued_rq(rq));
+
+	/*
+	 * If command is tagged, release the tag
+	 */
+	if (blk_rq_tagged(rq))
+		blk_queue_end_tag(q, rq);
+
+	drive_stat_acct(rq, 1);
+	__elv_add_request(q, rq, where, 0);
+
+	if (run_queue) {
+		blk_start_queueing(q);
+
+		/* the queue is stopped so it won't be plugged+unplugged */
+		if (blk_pm_resume_request(rq))
+			q->request_fn(q);
+	}
+
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+/**
  * blk_execute_rq_nowait - insert a request into queue for execution
  * @q:		queue to insert the request in
  * @bd_disk:	matching gendisk
@@ -54,13 +94,7 @@ void blk_execute_rq_nowait(struct reques
 	rq->cmd_flags |= REQ_NOMERGE;
 	rq->end_io = done;
 	WARN_ON(irqs_disabled());
-	spin_lock_irq(q->queue_lock);
-	__elv_add_request(q, rq, where, 1);
-	__generic_unplug_device(q);
-	/* the queue is stopped so it won't be plugged+unplugged */
-	if (blk_pm_resume_request(rq))
-		q->request_fn(q);
-	spin_unlock_irq(q->queue_lock);
+	blk_insert_request(q, rq, where, 1);
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
 
@@ -104,3 +138,12 @@ int blk_execute_rq(struct request_queue 
 	return err;
 }
 EXPORT_SYMBOL(blk_execute_rq);
+
+int blk_insert_clone_request(struct request_queue *q, struct request *rq)
+{
+	if (blk_rq_check_limits(q, rq))
+		return -EIO;
+
+	blk_insert_request(q, rq, ELEVATOR_INSERT_BACK, 0);
+}
+EXPORT_SYMBOL_GPL(blk_insert_clone_request);
