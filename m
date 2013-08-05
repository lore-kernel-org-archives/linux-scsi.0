From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
Date: Mon, 05 Aug 2013 16:31:02 -0700
Message-ID: <1375745462.18481.22.camel@dabdike.int.hansenpartnership.com>
References: <1375740121-23350-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59386 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755378Ab3HEXbI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Aug 2013 19:31:08 -0400
In-Reply-To: <1375740121-23350-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>, Costa Sapuntzakis <costa@purestorage.com>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2013-08-05 at 15:02 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> There is a nasty bug in the SCSI SG_IO ioctl that in some circumstances
> leads to one process writing data into the address space of some other
> random unrelated process if the ioctl is interrupted by a signal.
> What happens is the following:
> 
>  - A process issues an SG_IO ioctl with direction DXFER_FROM_DEV (ie the
>    underlying SCSI command will transfer data from the SCSI device to
>    the buffer provided in the ioctl)
> 
>  - Before the command finishes, a signal is sent to the process waiting
>    in the ioctl.  This will end up waking up the sg_ioctl() code:
> 
> 		result = wait_event_interruptible(sfp->read_wait,
> 			(srp_done(sfp, srp) || sdp->detached));
> 
>    but neither srp_done() nor sdp->detached is true, so we end up just
>    setting srp->orphan and returning to userspace:
> 
> 		srp->orphan = 1;
> 		write_unlock_irq(&sfp->rq_list_lock);
> 		return result;	/* -ERESTARTSYS because signal hit process */
> 
>    At this point the original process is done with the ioctl and
>    blithely goes ahead handling the signal, reissuing the ioctl, etc.
> 
>  - Eventually, the SCSI command issued by the first ioctl finishes and
>    ends up in sg_rq_end_io().  At the end of that function, we run through:
> 
> 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
> 	if (unlikely(srp->orphan)) {
> 		if (sfp->keep_orphan)
> 			srp->sg_io_owned = 0;
> 		else
> 			done = 0;
> 	}
> 	srp->done = done;
> 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> 
> 	if (likely(done)) {
> 		/* Now wake up any sg_read() that is waiting for this
> 		 * packet.
> 		 */
> 		wake_up_interruptible(&sfp->read_wait);
> 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
> 		kref_put(&sfp->f_ref, sg_remove_sfp);
> 	} else {
> 		INIT_WORK(&srp->ew.work, sg_rq_end_io_usercontext);
> 		schedule_work(&srp->ew.work);
> 	}
> 
>    Since srp->orphan *is* set, we set done to 0 (assuming the
>    userspace app has not set keep_orphan via an SG_SET_KEEP_ORPHAN
>    ioctl), and therefore we end up scheduling sg_rq_end_io_usercontext()
>    to run in a workqueue.
> 
>  - In workqueue context we go through sg_rq_end_io_usercontext() ->
>    sg_finish_rem_req() -> blk_rq_unmap_user() -> ... ->
>    bio_uncopy_user() -> __bio_copy_iov() -> copy_to_user().
> 
>    The key point here is that we are doing copy_to_user() on a
>    workqueue -- that is, we're on a kernel thread with current->mm
>    equal to whatever random previous user process was scheduled before
>    this kernel thread.  So we end up copying whatever data the SCSI
>    command returned to the virtual address of the buffer passed into
>    the original ioctl, but it's quite likely we do this copying into a
>    different address space!
> 
> Fix this by telling sg_finish_rem_req() whether we're on a workqueue
> or not, and if we are, calling a new function blk_rq_unmap_user_nocopy()
> that does everything the original blk_rq_unmap_user() does except
> calling copy_{to,from}_user().  This requires a few levels of plumbing
> through a "copy" flag in the bio layer.

I agree with the analysis.  The fix is a bit draconian, though.  A
workqueue actually runs in a kernel thread and there's a simple test for
that (!current->mm), so how about this instead (which is much less
intrusive)

James

---

diff --git a/fs/bio.c b/fs/bio.c
index 94bbc04..e2ab39c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1045,12 +1045,22 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 int bio_uncopy_user(struct bio *bio)
 {
 	struct bio_map_data *bmd = bio->bi_private;
-	int ret = 0;
+	struct bio_vec *bvec;
+	int ret = 0, i;
 
-	if (!bio_flagged(bio, BIO_NULL_MAPPED))
-		ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
-				     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
-				     0, bmd->is_our_pages);
+	if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
+		/*
+		 * if we're in a workqueue, the request is orphaned, so
+		 * don't copy into the kernel address space, just free
+		 */
+		if (current->mm)
+			ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
+					     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
+					     0, bmd->is_our_pages);
+		else if (bmd->is_our_pages)
+			bio_for_each_segment_all(bvec, bio, i)
+				__free_page(bvec->bv_page);
+	}
 	bio_free_map_data(bmd);
 	bio_put(bio);
 	return ret;


