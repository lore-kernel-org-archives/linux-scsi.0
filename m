From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Thu, 17 Jul 2003 12:56:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030717105641.GF833@suse.de>
References: <20030716124549.GX833@suse.de> <1058360162.1850.15.camel@mulgrave> <20030716132036.GB833@suse.de> <1058364455.1856.28.camel@mulgrave> <20030716170456.GK833@suse.de> <20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de> <3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de> <3F167F98.60006@cyberone.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:56737 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S271400AbTGQKlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 06:41:50 -0400
Content-Disposition: inline
In-Reply-To: <3F167F98.60006@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com, markh@osdl.org, cliffw@osdl.org, linux-scsi@vger.kernel.org

On Thu, Jul 17 2003, Nick Piggin wrote:
> 
> 
> Jens Axboe wrote:
> 
> >On Thu, Jul 17 2003, Nick Piggin wrote:
> >
> >>
> >>Jens Axboe wrote:
> >>
> >>
> >>>On Thu, Jul 17 2003, Andrew Morton wrote:
> >>>
> >>>
> >>>>So this is what I ended up with.  Could we please have confirmation 
> >>>>that it
> >>>>fixes the aacraid hang?
> >>>>
> >>>>
> >>>It doesn't, it's just a pre-requisite to fixing the bug :-)
> >>>
> >>>Nick should chime in with how we wants it to be handled from
> >>>blk_requeue_request(), he needs to decrease dispatched from there. We
> >>>could always add some hook for it of course, but...
> >>>
> >>>
> >>Well you could just put an elv_completed_request in there, but
> >>
> >
> >Yeah, I told Andrew to add that for now.
> >
> >
> >>I suppose it really wants an elv_requeue_request - which would
> >>just default to elv_add_request for other schedulers.
> >>
> >
> >I'd rather keep it seperate, ie just a requeue notifier. How's this?
> >
> 
> Well it would be much nicer for AS if it were seperate. Basically
> AS wants the requeue implemented as as_add_request but without
> the accounting updates: there has been no request completed, and
> no really new request.
> 
> If the requeue were seperate to the add, it would simply be a call
> to as_completed_request in as-iosched.c.

Like this then? Nicer semantics, too.

===== drivers/block/elevator.c 1.46 vs edited =====
--- 1.46/drivers/block/elevator.c	Sat Jul  5 08:52:45 2003
+++ edited/drivers/block/elevator.c	Thu Jul 17 12:55:51 2003
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
--- 1.192/drivers/block/ll_rw_blk.c	Sun Jul 13 14:15:43 2003
+++ edited/drivers/block/ll_rw_blk.c	Thu Jul 17 12:56:00 2003
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
--- 1.99/drivers/scsi/scsi_lib.c	Mon Jun 30 03:14:44 2003
+++ edited/drivers/scsi/scsi_lib.c	Thu Jul 17 12:22:46 2003
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
--- 1.116/include/linux/blkdev.h	Sat Jul  5 08:52:51 2003
+++ edited/include/linux/blkdev.h	Wed Jul 16 15:18:06 2003
@@ -491,6 +491,7 @@
 extern struct request *blk_get_request(request_queue_t *, int, int);
 extern void blk_put_request(struct request *);
 extern void blk_insert_request(request_queue_t *, struct request *, int, void *);
+extern void blk_requeue_request(request_queue_t *, struct request *);
 extern void blk_plug_device(request_queue_t *);
 extern int blk_remove_plug(request_queue_t *);
 extern void blk_recount_segments(request_queue_t *, struct bio *);
===== include/linux/elevator.h 1.25 vs edited =====
--- 1.25/include/linux/elevator.h	Sat Jul  5 08:52:40 2003
+++ edited/include/linux/elevator.h	Thu Jul 17 12:24:29 2003
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
Jens Axboe

