From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH v2] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
Date: Wed, 07 Aug 2013 09:38:27 -0500
Message-ID: <52025BE3.5020002@redhat.com>
References: <1375746189.18481.23.camel@dabdike.int.hansenpartnership.com> <1375750501-21902-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1375750501-21902-1-git-send-email-roland@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>, James Bottomley <JBottomley@Parallels.com>, Costa Sapuntzakis <costa@purestorage.com>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Jeffery <djeffery@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Roland Dreier wrote:
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
> As suggested by James Bottomley <James.Bottomley@hansenpartnership.com>,
> add a check for current->mm (which is NULL if we're on a kernel thread
> without a real userspace address space) in bio_uncopy_user(), and skip
> the copy if we're on a kernel thread.
> 
> There's no reason that I can think of for any caller of bio_uncopy_user()
> to want to do copying on a kernel thread with a random active userspace
> address space.
> 
> Huge thanks to Costa Sapuntzakis <costa@purestorage.com> for the
> original pointer to this bug in the sg code.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> Cc: <stable@vger.kernel.org>
> ---
>  fs/bio.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 94bbc04..c5eae72 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1045,12 +1045,22 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
>  int bio_uncopy_user(struct bio *bio)
>  {
>  	struct bio_map_data *bmd = bio->bi_private;
> -	int ret = 0;
> +	struct bio_vec *bvec;
> +	int ret = 0, i;
>  
> -	if (!bio_flagged(bio, BIO_NULL_MAPPED))
> -		ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
> -				     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
> -				     0, bmd->is_our_pages);
> +	if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
> +		/*
> +		 * if we're in a workqueue, the request is orphaned, so
> +		 * don't copy into a random user address space, just free.
> +		 */
> +		if (current->mm)
> +			ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
> +					     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
> +					     0, bmd->is_our_pages);
> +		else if (bmd->is_our_pages)
> +			bio_for_each_segment_all(bvec, bio, i)
> +				__free_page(bvec->bv_page);
> +	}
>  	bio_free_map_data(bmd);
>  	bio_put(bio);
>  	return ret;

Hi Roland,

I was able to succesfully test this patch overnight, I had been 
experimenting with the
sg driver setting the BIO_NULL_MAPPED flag in sg_rq_end_io_usercontext 
for a orphan process
which prevented the corruption, but your solution seems much better.

Thanks,
David
