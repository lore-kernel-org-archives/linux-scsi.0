From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 18 Jul 2003 09:28:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058545730.20130.62.camel@markh1.pdx.osdl.net>
References: <20030716132036.GB833@suse.de>
	 <1058364455.1856.28.camel@mulgrave>	<20030716170456.GK833@suse.de>
	 <20030717015756.135a3f5a.akpm@osdl.org>	<20030717085952.GX833@suse.de>
	 <3F1672D9.7070309@cyberone.com.au>	<20030717102926.GE833@suse.de>
	 <3F167F98.60006@cyberone.com.au>	<20030717105641.GF833@suse.de>
	 <3F1683F5.4030107@cyberone.com.au>	<20030717111059.GI833@suse.de>
	 <3F168846.90902@cyberone.com.au>
	 <1058474814.4638.11.camel@markh1.pdx.osdl.net>
	 <1058481553.19508.5.camel@markh1.pdx.osdl.net>
	 <1058485621.7424.30.camel@dell_ss5.pdx.osdl.net>
	 <20030717170055.5dbe20c1.akpm@osdl.org>  <3F17821A.307@cyberone.com.au>
	 <1058540605.20130.48.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:21185 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S271838AbTGRQOF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 12:14:05 -0400
In-Reply-To: <1058540605.20130.48.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: Andrew Morton <akpm@osdl.org>, Daniel McNeil <daniel@osdl.org>, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2003-07-18 at 08:03, Mark Haverkamp wrote:
> On Thu, 2003-07-17 at 22:14, Nick Piggin wrote:
> > Andrew Morton wrote:
> > 
> > >Daniel McNeil <daniel@osdl.org> wrote:
> > >
> > >>Should	
> > >>	list_add(&rq->queuelist, ad->dispatch->prev);
> > >>be
> > >>	list_add_tail(&rq->queuelist, ad->dispatch);
> > >>
> > >>It is equivalent, but makes the code clearer that we're adding to the
> > >>end.
> > >>
> > >
> > >yup.
> > >
> > >
> > >>Also, isn't the: !list_empty(ad->dispatch) unnecessary since a
> > >>list_add was just done, so the list cannot be empty?
> > >>
> > >
> > >more yup.
> > >
> > 
> > Oh, so the request should go on the dispatch list?
> > OK that makes sense. Maybe also set arq->state = AS_RQ_DISPATCHED
> > just in case.
> > 
> > And I think the arq == NULL case should be checked for with
> > rq->flags & REQ_HARDBARRIER || !blk_fs_request(rq) for consistency.
> > I think if arq is still NULL then its a bug.
> > 
> > Thanks
> > Nick
> 
> Nick,
> 
> I tried what you suggested and I'm pretty sure that aic->nr_dispatched
> is not getting incremented when it should be.  I get:
> 
> Badness in as_remove_dispatched_request at drivers/block/as-iosched.c:1019
> 
> Which says that aic->nr_dispatched is wrong. I have attached the
> as_requeue_request that I was using.  Is this what you had in mind?
> 

Nick,

I thought more about what you were saying about checking arq == NULL so
I have enclosed a patch (compilation of everything) which works for us
here on our hardware.  I have created file systems on multiple disks,
did copies and also writes to a raw device as well and have had no
problems yet.

Mark.
-----------

===== drivers/block/as-iosched.c 1.5 vs edited =====
--- 1.5/drivers/block/as-iosched.c	Sat Jul 12 04:28:01 2003
+++ edited/drivers/block/as-iosched.c	Fri Jul 18 09:12:40 2003
@@ -1306,6 +1306,33 @@
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
+
+	if (arq) 
+		if (arq->io_context && arq->io_context->aic) {
+			arq->state = AS_RQ_DISPATCHED;
+			atomic_inc(&arq->io_context->aic->nr_dispatched);
+		}
+	else
+		WARN_ON(!(rq->flags & REQ_HARDBARRIER) && blk_fs_request(rq));
+
+	list_add_tail(&rq->queuelist, ad->dispatch);
+
+	/* Stop anticipating - let this request get through */
+	if (ad->antic_status == ANTIC_WAIT_REQ
+			|| ad->antic_status == ANTIC_WAIT_NEXT)
+		as_antic_stop(ad);
+
+	return;
+}
+
 static void
 as_insert_request(request_queue_t *q, struct request *rq,
 			struct list_head *insert_here)
@@ -1821,6 +1848,7 @@
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

