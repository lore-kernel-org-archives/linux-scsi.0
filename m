From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 17 Jul 2003 13:46:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058474814.4638.11.camel@markh1.pdx.osdl.net>
References: <20030716132036.GB833@suse.de>
	 <1058364455.1856.28.camel@mulgrave> <20030716170456.GK833@suse.de>
	 <20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de>
	 <3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de>
	 <3F167F98.60006@cyberone.com.au> <20030717105641.GF833@suse.de>
	 <3F1683F5.4030107@cyberone.com.au> <20030717111059.GI833@suse.de>
	 <3F168846.90902@cyberone.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:31920 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S271530AbTGQUcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 16:32:10 -0400
In-Reply-To: <3F168846.90902@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: Jens Axboe <axboe@suse.de>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, Daniel McNeil <daniel@osdl.org>

On Thu, 2003-07-17 at 04:28, Nick Piggin wrote:
> Jens Axboe wrote:
> 
> >On Thu, Jul 17 2003, Nick Piggin wrote:
> >
> 
> snip
> 
> >>
> >>Jens, this is exactly right. Would you be OK with this? Everyone else?
> >>
> >
> >I'm happy with it.
> >
> 
> OK, Mark, please try the following patch in combination with Jens'
> previous. Untested due to not being able to exercise the requeue
> path, so it might blow up.
> 
> ______________________________________________________________________
Nick,

Looking at the as_requeue_request function, the BUG that I sent you
earlier was caused from aic->nr_queued not being incremented.  When we
tried to increment this element in the requeue function, we found that
the ad->nr_dispatched variable was out of sync again.  The enclosed
patch contains Jens' patch and an updated patch to the
as_requeue_request code that just puts the request back on the
dispatched queue and increments aic->nr_dispatched.  We have run this
code for a while and it seems to work.  Let me know if we've over
simplified things here.

Thanks,

Mark and Daniel.

===== drivers/block/as-iosched.c 1.5 vs edited =====
--- 1.5/drivers/block/as-iosched.c	Sat Jul 12 04:28:01 2003
+++ edited/drivers/block/as-iosched.c	Thu Jul 17 13:35:03 2003
@@ -1306,6 +1306,30 @@
 	as_update_arq(ad, arq); /* keep state machine up to date */
 }
 
+/*
+ * requeue the request. The request has not been completed, nor is it a
+ * new request, so don't touch accounting.
+ */
+static void as_requeue_request(request_queue_t *q, struct request *rq)
+{
+	struct as_data *ad = q->elevator.elevator_data;
+	struct as_rq *arq = RQ_DATA(rq);
+	int data_dir;
+
+	if (arq->io_context && arq->io_context->aic)
+		atomic_inc(&arq->io_context->aic->nr_dispatched);
+
+	list_add(&rq->queuelist, ad->dispatch->prev);
+
+	/* Stop anticipating - let this request get through */
+	if (!list_empty(ad->dispatch)
+		&& (ad->antic_status == ANTIC_WAIT_REQ
+			|| ad->antic_status == ANTIC_WAIT_NEXT))
+		as_antic_stop(ad);
+
+	return;
+}
+
 static void
 as_insert_request(request_queue_t *q, struct request *rq,
 			struct list_head *insert_here)
@@ -1821,6 +1845,7 @@
 	.elevator_next_req_fn =		as_next_request,
 	.elevator_add_req_fn =		as_insert_request,
 	.elevator_remove_req_fn =	as_remove_request,
+	.elevator_requeue_req_fn = 	as_requeue_request,
 	.elevator_queue_empty_fn =	as_queue_empty,
 	.elevator_completed_req_fn =	as_completed_request,
 	.elevator_former_req_fn =	as_former_request,
===== drivers/block/elevator.c 1.46 vs edited =====
--- 1.46/drivers/block/elevator.c	Fri Jul  4 23:52:45 2003
+++ edited/drivers/block/elevator.c	Thu Jul 17 07:30:06 2003
@@ -214,6 +214,18 @@
 		e->elevator_merge_req_fn(q, rq, next);
 }
 
+void elv_requeue_request(request_queue_t *q, struct request *rq)
+{
+	/*
+	 * if iosched has an explicit requeue hook, then use that. otherwise
+	 * just put the request at the front of the queue
+	 */
+	if (q->elevator.elevator_requeue_req_fn)
+		q->elevator.elevator_requeue_req_fn(q, rq);
+	else
+		__elv_add_request(q, rq, 0, 0);
+}
+
 void __elv_add_request(request_queue_t *q, struct request *rq, int at_end,
 		       int plug)
 {
@@ -417,6 +429,7 @@
 
 EXPORT_SYMBOL(elv_add_request);
 EXPORT_SYMBOL(__elv_add_request);
+EXPORT_SYMBOL(elv_requeue_request);
 EXPORT_SYMBOL(elv_next_request);
 EXPORT_SYMBOL(elv_remove_request);
 EXPORT_SYMBOL(elv_queue_empty);
===== drivers/block/ll_rw_blk.c 1.192 vs edited =====
--- 1.192/drivers/block/ll_rw_blk.c	Sun Jul 13 05:15:43 2003
+++ edited/drivers/block/ll_rw_blk.c	Thu Jul 17 07:30:06 2003
@@ -1494,6 +1494,23 @@
 
 	return rq;
 }
+/**
+ * blk_requeue_request - put a request back on queue
+ * @q:		request queue where request should be inserted
+ * @rq:		request to be inserted
+ *
+ * Description:
+ *    Drivers often keep queueing requests until the hardware cannot accept
+ *    more, when that condition happens we need to put the request back
+ *    on the queue. Must be called with queue lock held.
+ */
+void blk_requeue_request(request_queue_t *q, struct request *rq)
+{
+	if (blk_rq_tagged(rq))
+		blk_queue_end_tag(q, rq);
+
+	elv_requeue_request(q, rq);
+}
 
 /**
  * blk_insert_request - insert a special request in to a request queue
@@ -2730,6 +2747,7 @@
 EXPORT_SYMBOL(blk_get_request);
 EXPORT_SYMBOL(blk_put_request);
 EXPORT_SYMBOL(blk_insert_request);
+EXPORT_SYMBOL(blk_requeue_request);
 
 EXPORT_SYMBOL(blk_queue_prep_rq);
 EXPORT_SYMBOL(blk_queue_merge_bvec);
===== drivers/scsi/scsi_lib.c 1.99 vs edited =====
--- 1.99/drivers/scsi/scsi_lib.c	Sun Jun 29 18:14:44 2003
+++ edited/drivers/scsi/scsi_lib.c	Thu Jul 17 07:30:06 2003
@@ -444,22 +444,8 @@
  */
 static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	cmd->request->special = cmd;
-	if (blk_rq_tagged(cmd->request))
-		blk_queue_end_tag(q, cmd->request);
-
-	/*
-	 * set REQ_SPECIAL - we have a command
-	 * clear REQ_DONTPREP - we assume the sg table has been 
-	 *	nuked so we need to set it up again.
-	 */
-	cmd->request->flags |= REQ_SPECIAL;
 	cmd->request->flags &= ~REQ_DONTPREP;
-	__elv_add_request(q, cmd->request, 0, 0);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	blk_insert_request(q, cmd->request, 1, cmd);
 
 	scsi_run_queue(q);
 }
@@ -1213,9 +1199,7 @@
 	 * later time.
 	 */
 	spin_lock_irq(q->queue_lock);
-	if (blk_rq_tagged(req))
-		blk_queue_end_tag(q, req);
-	__elv_add_request(q, req, 0, 0);
+	blk_requeue_request(q, req);
 	sdev->device_busy--;
 	if(sdev->device_busy == 0)
 		blk_plug_device(q);
===== include/linux/blkdev.h 1.116 vs edited =====
--- 1.116/include/linux/blkdev.h	Fri Jul  4 23:52:51 2003
+++ edited/include/linux/blkdev.h	Thu Jul 17 07:30:06 2003
@@ -491,6 +491,7 @@
 extern struct request *blk_get_request(request_queue_t *, int, int);
 extern void blk_put_request(struct request *);
 extern void blk_insert_request(request_queue_t *, struct request *, int, void *);
+extern void blk_requeue_request(request_queue_t *, struct request *);
 extern void blk_plug_device(request_queue_t *);
 extern int blk_remove_plug(request_queue_t *);
 extern void blk_recount_segments(request_queue_t *, struct bio *);
===== include/linux/elevator.h 1.25 vs edited =====
--- 1.25/include/linux/elevator.h	Fri Jul  4 23:52:40 2003
+++ edited/include/linux/elevator.h	Thu Jul 17 07:30:06 2003
@@ -13,6 +13,7 @@
 typedef void (elevator_add_req_fn) (request_queue_t *, struct request *, struct list_head *);
 typedef int (elevator_queue_empty_fn) (request_queue_t *);
 typedef void (elevator_remove_req_fn) (request_queue_t *, struct request *);
+typedef void (elevator_requeue_req_fn) (request_queue_t *, struct request *);
 typedef struct request *(elevator_request_list_fn) (request_queue_t *, struct request *);
 typedef struct list_head *(elevator_get_sort_head_fn) (request_queue_t *, struct request *);
 typedef void (elevator_completed_req_fn) (request_queue_t *, struct request *);
@@ -33,6 +34,7 @@
 	elevator_next_req_fn *elevator_next_req_fn;
 	elevator_add_req_fn *elevator_add_req_fn;
 	elevator_remove_req_fn *elevator_remove_req_fn;
+	elevator_requeue_req_fn *elevator_requeue_req_fn;
 
 	elevator_queue_empty_fn *elevator_queue_empty_fn;
 	elevator_completed_req_fn *elevator_completed_req_fn;
@@ -64,6 +66,7 @@
 			       struct request *);
 extern void elv_merged_request(request_queue_t *, struct request *);
 extern void elv_remove_request(request_queue_t *, struct request *);
+extern void elv_requeue_request(request_queue_t *, struct request *);
 extern int elv_queue_empty(request_queue_t *);
 extern struct request *elv_next_request(struct request_queue *q);
 extern struct request *elv_former_request(request_queue_t *, struct request *);

-- 
Mark Haverkamp <markh@osdl.org>

