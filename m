From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Thu, 17 Jul 2003 01:57:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030717015756.135a3f5a.akpm@osdl.org>
References: <1058310172.981.7.camel@markh1.pdx.osdl.net>
	<1058359278.1856.8.camel@mulgrave>
	<20030716124549.GX833@suse.de>
	<1058360162.1850.15.camel@mulgrave>
	<20030716132036.GB833@suse.de>
	<1058364455.1856.28.camel@mulgrave>
	<20030716170456.GK833@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:35269 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S271381AbTGQIml (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 04:42:41 -0400
In-Reply-To: <20030716170456.GK833@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James.Bottomley@steeleye.com, markh@osdl.org, piggin@cyberone.com.au, cliffw@osdl.org, linux-scsi@vger.kernel.org


So this is what I ended up with.  Could we please have confirmation that it
fixes the aacraid hang?


 25-akpm/drivers/block/ll_rw_blk.c |   18 ++++++++++++++++++
 25-akpm/drivers/scsi/scsi_lib.c   |   20 ++------------------
 25-akpm/include/linux/blkdev.h    |    1 +
 3 files changed, 21 insertions(+), 18 deletions(-)

diff -puN drivers/block/ll_rw_blk.c~blk_requeue_request drivers/block/ll_rw_blk.c
--- 25/drivers/block/ll_rw_blk.c~blk_requeue_request	Wed Jul 16 16:02:39 2003
+++ 25-akpm/drivers/block/ll_rw_blk.c	Wed Jul 16 16:02:39 2003
@@ -1508,6 +1508,23 @@ struct request *blk_get_request(request_
 
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
+	__elv_add_request(q, rq, 0, 0);
+}
 
 /**
  * blk_insert_request - insert a special request in to a request queue
@@ -2745,6 +2762,7 @@ EXPORT_SYMBOL(blk_hw_contig_segment);
 EXPORT_SYMBOL(blk_get_request);
 EXPORT_SYMBOL(blk_put_request);
 EXPORT_SYMBOL(blk_insert_request);
+EXPORT_SYMBOL(blk_requeue_request);
 
 EXPORT_SYMBOL(blk_queue_prep_rq);
 EXPORT_SYMBOL(blk_queue_merge_bvec);
diff -puN drivers/scsi/scsi_lib.c~blk_requeue_request drivers/scsi/scsi_lib.c
--- 25/drivers/scsi/scsi_lib.c~blk_requeue_request	Wed Jul 16 16:02:39 2003
+++ 25-akpm/drivers/scsi/scsi_lib.c	Wed Jul 16 16:03:28 2003
@@ -444,22 +444,8 @@ static void scsi_run_queue(struct reques
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
@@ -1213,9 +1199,7 @@ static void scsi_request_fn(struct reque
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
diff -puN include/linux/blkdev.h~blk_requeue_request include/linux/blkdev.h
--- 25/include/linux/blkdev.h~blk_requeue_request	Wed Jul 16 16:02:39 2003
+++ 25-akpm/include/linux/blkdev.h	Wed Jul 16 16:02:39 2003
@@ -491,6 +491,7 @@ extern void __blk_attempt_remerge(reques
 extern struct request *blk_get_request(request_queue_t *, int, int);
 extern void blk_put_request(struct request *);
 extern void blk_insert_request(request_queue_t *, struct request *, int, void *);
+extern void blk_requeue_request(request_queue_t *, struct request *);
 extern void blk_plug_device(request_queue_t *);
 extern int blk_remove_plug(request_queue_t *);
 extern void blk_recount_segments(request_queue_t *, struct bio *);

_

