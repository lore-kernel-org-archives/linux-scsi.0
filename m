From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Thu, 07 Jul 2011 15:45:40 -0500
Message-ID: <1310071540.3282.71.camel@mulgrave>
References: <Pine.LNX.4.44L0.1107061432340.1995-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42209 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab1GGUpy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2011 16:45:54 -0400
In-Reply-To: <Pine.LNX.4.44L0.1107061432340.1995-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Roland Dreier <roland@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Wed, 2011-07-06 at 14:49 -0400, Alan Stern wrote:
> On Wed, 6 Jul 2011, Roland Dreier wrote:
> 
> > On Wed, Jul 6, 2011 at 9:53 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > He probably meant blk_execute_rq_nowait(). The test has to be done
> > > before the elevator is accessed.
> > 
> > Hmm, seems we would need the test in multiple places, since my second call
> > trace is io_schedule -> blk_flush_plug_list -> queue_unplugged ->
> > __blk_run_queue
> > 
> > So I don't think I hit blk_execute_rq_nowait in my crash.
> > 
> > But maybe the problem is that dm-multipath is trying to requeue the IO to an
> > underlying sdX device that is already dead?
> 
> I'm not at all familiar with the block layer.  It seems that the check
> for a dead queue would have to be made on every path that ends up
> calling the elevator, which would be a difficult sort of thing to
> enforce.
> 
> I'm not too sure about James's comment:
> 
> > Moving the
> > queue free is wrong ... it recently moved to fix another oops.
> 
> Apparently this refers to commit
> e73e079bf128d68284efedeba1fbbc18d78610f9 ([SCSI] Fix oops caused by
> queue refcounting failure).  In fact that commit does _not_ move the
> call to scsi_free_queue().  Instead it merely takes another reference
> to the queue, so that scsi_free_queue() doesn't actually deallocate the
> queue.  But it does still deallocate the elevator.

Not that one, 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b

> Perhaps this means the elevator shouldn't be freed until the queue is.  
> I just don't know.  Jens and James are the experts, but Jens hasn't
> said anything and James is currently busy.

OK, back from being busy now (for a short while).

This is what I think should fix it all (at least it fixes it for me now
I've finally figured out how to reproduce it).

The nasty about this is that blk_get_request() has to return NULL even
if __GFP_WAIT is specified, if the queue is already dead.  Lots of block
users don't check for NULL if they specify __GFP_WAIT.

James

---

diff --git a/block/blk-core.c b/block/blk-core.c
index d2f8f40..1d49e1c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -839,6 +839,9 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 {
 	struct request *rq;
 
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		return NULL;
+
 	BUG_ON(rw != READ && rw != WRITE);
 
 	spin_lock_irq(q->queue_lock);
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 8a0e7ec..a1ebceb 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -50,6 +50,13 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
+		rq->errors = -ENXIO;
+		if (rq->end_io)
+			rq->end_io(rq, rq->errors);
+		return;
+	}
+
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
 	WARN_ON(irqs_disabled());
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ec1803a..28d9c9d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -213,6 +213,8 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	int ret = DRIVER_ERROR << 24;
 
 	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
+	if (!req)
+		return ret;
 
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
 					buffer, bufflen, __GFP_WAIT))


