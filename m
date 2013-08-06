From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] [SCSI] sg: Fix user memory corruption when SG_IO is interrupted
 by a signal
Date: Mon, 05 Aug 2013 20:19:02 -0400
Message-ID: <520040F6.9060605@interlog.com>
References: <1375740121-23350-1-git-send-email-roland@kernel.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1375740121-23350-1-git-send-email-roland@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Costa Sapuntzakis <costa@purestorage.com>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Roland,
When this sg code was originally designed, there wasn't a bio
in sight :-)

Now I'm trying to get my head around this. We have launched
a "data-in" SCSI command like READ(10) and the DMA is underway
so we are waiting for a "done" indication. Instead we receive
a signal interruption. It is not clear to me why that DMA
would not just keep going unless we can get to something that
can stop or redirect the DMA. That something is more likely to
be the low level driver being used rather than the block layer.
In the original design to cope with this the destination pages
were locked in memory until the DMA completed.

So originally the design was to allow for this case at the top
of the waterfall. Now it seems there is bio magic going on
half way down the waterfall in the case of a signal interruption.


BTW, the keep_orphan logic probably only works for the
asynchronous sg interface (i.e. write sg_io_hdr then read response)
rather the the synchronous SG_IO ioctl. To support the keep_orphan
the user would need to do a read() on the sg device after the
SG_IO ioctl was interrupted.


Anyway, this obviously needs to be fixed.

Doug Gilbert

On 13-08-05 06:02 PM, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
>
> There is a nasty bug in the SCSI SG_IO ioctl that in some circumstances
> leads to one process writing data into the address space of some other
> random unrelated process if the ioctl is interrupted by a signal.
> What happens is the following:
>
>   - A process issues an SG_IO ioctl with direction DXFER_FROM_DEV (ie the
>     underlying SCSI command will transfer data from the SCSI device to
>     the buffer provided in the ioctl)
>
>   - Before the command finishes, a signal is sent to the process waiting
>     in the ioctl.  This will end up waking up the sg_ioctl() code:
>
> 		result = wait_event_interruptible(sfp->read_wait,
> 			(srp_done(sfp, srp) || sdp->detached));
>
>     but neither srp_done() nor sdp->detached is true, so we end up just
>     setting srp->orphan and returning to userspace:
>
> 		srp->orphan = 1;
> 		write_unlock_irq(&sfp->rq_list_lock);
> 		return result;	/* -ERESTARTSYS because signal hit process */
>
>     At this point the original process is done with the ioctl and
>     blithely goes ahead handling the signal, reissuing the ioctl, etc.
>
>   - Eventually, the SCSI command issued by the first ioctl finishes and
>     ends up in sg_rq_end_io().  At the end of that function, we run through:
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
>     Since srp->orphan *is* set, we set done to 0 (assuming the
>     userspace app has not set keep_orphan via an SG_SET_KEEP_ORPHAN
>     ioctl), and therefore we end up scheduling sg_rq_end_io_usercontext()
>     to run in a workqueue.
>
>   - In workqueue context we go through sg_rq_end_io_usercontext() ->
>     sg_finish_rem_req() -> blk_rq_unmap_user() -> ... ->
>     bio_uncopy_user() -> __bio_copy_iov() -> copy_to_user().
>
>     The key point here is that we are doing copy_to_user() on a
>     workqueue -- that is, we're on a kernel thread with current->mm
>     equal to whatever random previous user process was scheduled before
>     this kernel thread.  So we end up copying whatever data the SCSI
>     command returned to the virtual address of the buffer passed into
>     the original ioctl, but it's quite likely we do this copying into a
>     different address space!
>
> Fix this by telling sg_finish_rem_req() whether we're on a workqueue
> or not, and if we are, calling a new function blk_rq_unmap_user_nocopy()
> that does everything the original blk_rq_unmap_user() does except
> calling copy_{to,from}_user().  This requires a few levels of plumbing
> through a "copy" flag in the bio layer.
>
> I also considered fixing this by having the sg code just set
> BIO_NULL_MAPPED for bios that are unmapped from a workqueue, which
> happens to work because the __free_page() part of __bio_copy_iov()
> isn't needed for sg (because sg handles its own pages).  However, this
> seems coincidental and fragile, so I preferred making the fix
> explicit, at the cost of minor tweaks to the bio code.
>
> Huge thanks to Costa Sapuntzakis <costa@purestorage.com> for the
> original pointer to this bug in the sg code.
>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> Cc: <stable@vger.kernel.org>
> ---
>   block/blk-map.c        | 15 ++++++++-------
>   drivers/scsi/sg.c      | 19 ++++++++++---------
>   fs/bio.c               | 22 +++++++++++++++-------
>   include/linux/bio.h    |  2 +-
>   include/linux/blkdev.h | 11 ++++++++++-
>   5 files changed, 44 insertions(+), 25 deletions(-)
>
> diff --git a/block/blk-map.c b/block/blk-map.c
> index 623e1cd..bd63201 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -25,7 +25,7 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
>   	return 0;
>   }
>
> -static int __blk_rq_unmap_user(struct bio *bio)
> +static int __blk_rq_unmap_user(struct bio *bio, bool copy)
>   {
>   	int ret = 0;
>
> @@ -33,7 +33,7 @@ static int __blk_rq_unmap_user(struct bio *bio)
>   		if (bio_flagged(bio, BIO_USER_MAPPED))
>   			bio_unmap_user(bio);
>   		else
> -			ret = bio_uncopy_user(bio);
> +			ret = bio_uncopy_user(bio, copy);
>   	}
>
>   	return ret;
> @@ -80,7 +80,7 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
>
>   	/* if it was boucned we must call the end io function */
>   	bio_endio(bio, 0);
> -	__blk_rq_unmap_user(orig_bio);
> +	__blk_rq_unmap_user(orig_bio, true);
>   	bio_put(bio);
>   	return ret;
>   }
> @@ -228,7 +228,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
>   		 */
>   		bio_get(bio);
>   		bio_endio(bio, 0);
> -		__blk_rq_unmap_user(bio);
> +		__blk_rq_unmap_user(bio, true);
>   		return -EINVAL;
>   	}
>
> @@ -246,13 +246,14 @@ EXPORT_SYMBOL(blk_rq_map_user_iov);
>   /**
>    * blk_rq_unmap_user - unmap a request with user data
>    * @bio:	       start of bio list
> + * @copy:	       if false, just unmap without copying data
>    *
>    * Description:
>    *    Unmap a rq previously mapped by blk_rq_map_user(). The caller must
>    *    supply the original rq->bio from the blk_rq_map_user() return, since
>    *    the I/O completion may have changed rq->bio.
>    */
> -int blk_rq_unmap_user(struct bio *bio)
> +int _blk_rq_unmap_user(struct bio *bio, bool copy)
>   {
>   	struct bio *mapped_bio;
>   	int ret = 0, ret2;
> @@ -262,7 +263,7 @@ int blk_rq_unmap_user(struct bio *bio)
>   		if (unlikely(bio_flagged(bio, BIO_BOUNCED)))
>   			mapped_bio = bio->bi_private;
>
> -		ret2 = __blk_rq_unmap_user(mapped_bio);
> +		ret2 = __blk_rq_unmap_user(mapped_bio, copy);
>   		if (ret2 && !ret)
>   			ret = ret2;
>
> @@ -273,7 +274,7 @@ int blk_rq_unmap_user(struct bio *bio)
>
>   	return ret;
>   }
> -EXPORT_SYMBOL(blk_rq_unmap_user);
> +EXPORT_SYMBOL(_blk_rq_unmap_user);
>
>   /**
>    * blk_rq_map_kern - map kernel data to a request, for REQ_TYPE_BLOCK_PC usage
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index df5e961..2eab50e 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -187,7 +187,7 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
>   /* tasklet or soft irq callback */
>   static void sg_rq_end_io(struct request *rq, int uptodate);
>   static int sg_start_req(Sg_request *srp, unsigned char *cmd);
> -static int sg_finish_rem_req(Sg_request * srp);
> +static int sg_finish_rem_req(Sg_request * srp, bool on_workqueue);
>   static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
>   static ssize_t sg_new_read(Sg_fd * sfp, char __user *buf, size_t count,
>   			   Sg_request * srp);
> @@ -511,7 +511,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
>   		}
>   	} else
>   		count = (old_hdr->result == 0) ? 0 : -EIO;
> -	sg_finish_rem_req(srp);
> +	sg_finish_rem_req(srp, false);
>   	retval = count;
>   free_old_hdr:
>   	kfree(old_hdr);
> @@ -551,7 +551,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
>   		goto err_out;
>   	}
>   err_out:
> -	err = sg_finish_rem_req(srp);
> +	err = sg_finish_rem_req(srp, false);
>   	return (0 == err) ? count : err;
>   }
>
> @@ -761,13 +761,13 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
>   	k = sg_start_req(srp, cmnd);
>   	if (k) {
>   		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: start_req err=%d\n", k));
> -		sg_finish_rem_req(srp);
> +		sg_finish_rem_req(srp, false);
>   		return k;	/* probably out of space --> ENOMEM */
>   	}
>   	if (sdp->detached) {
>   		if (srp->bio)
>   			blk_end_request_all(srp->rq, -EIO);
> -		sg_finish_rem_req(srp);
> +		sg_finish_rem_req(srp, false);
>   		return -ENODEV;
>   	}
>
> @@ -1269,7 +1269,7 @@ static void sg_rq_end_io_usercontext(struct work_struct *work)
>   	struct sg_request *srp = container_of(work, struct sg_request, ew.work);
>   	struct sg_fd *sfp = srp->parentfp;
>
> -	sg_finish_rem_req(srp);
> +	sg_finish_rem_req(srp, true);
>   	kref_put(&sfp->f_ref, sg_remove_sfp);
>   }
>
> @@ -1727,7 +1727,7 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
>   	return res;
>   }
>
> -static int sg_finish_rem_req(Sg_request * srp)
> +static int sg_finish_rem_req(Sg_request * srp, bool on_workqueue)
>   {
>   	int ret = 0;
>
> @@ -1737,7 +1737,8 @@ static int sg_finish_rem_req(Sg_request * srp)
>   	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req: res_used=%d\n", (int) srp->res_used));
>   	if (srp->rq) {
>   		if (srp->bio)
> -			ret = blk_rq_unmap_user(srp->bio);
> +			ret = on_workqueue ? blk_rq_unmap_user_nocopy(srp->bio) :
> +				blk_rq_unmap_user(srp->bio);
>
>   		blk_put_request(srp->rq);
>   	}
> @@ -2103,7 +2104,7 @@ static void sg_remove_sfp_usercontext(struct work_struct *work)
>
>   	/* Cleanup any responses which were never read(). */
>   	while (sfp->headrp)
> -		sg_finish_rem_req(sfp->headrp);
> +		sg_finish_rem_req(sfp->headrp, true);
>
>   	if (sfp->reserve.bufflen > 0) {
>   		SCSI_LOG_TIMEOUT(6,
> diff --git a/fs/bio.c b/fs/bio.c
> index 94bbc04..c312523 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1038,19 +1038,27 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
>   /**
>    *	bio_uncopy_user	-	finish previously mapped bio
>    *	@bio: bio being terminated
> + *	@copy: if false, just free pages without copying data
>    *
>    *	Free pages allocated from bio_copy_user() and write back data
> - *	to user space in case of a read.
> + *	to user space in case of a read.  Skip copying if no longer in
> + *	context of the original process/mm.
>    */
> -int bio_uncopy_user(struct bio *bio)
> +int bio_uncopy_user(struct bio *bio, bool copy)
>   {
>   	struct bio_map_data *bmd = bio->bi_private;
> -	int ret = 0;
> +	struct bio_vec *bvec;
> +	int ret = 0, i;
>
> -	if (!bio_flagged(bio, BIO_NULL_MAPPED))
> -		ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
> -				     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
> -				     0, bmd->is_our_pages);
> +	if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
> +		if (copy)
> +			ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
> +					     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
> +					     0, bmd->is_our_pages);
> +		else if (bmd->is_our_pages)
> +			bio_for_each_segment_all(bvec, bio, i)
> +				__free_page(bvec->bv_page);
> +	}
>   	bio_free_map_data(bmd);
>   	bio_put(bio);
>   	return ret;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index ec48bac..6fca2c8 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -301,7 +301,7 @@ extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
>   extern struct bio *bio_copy_user_iov(struct request_queue *,
>   				     struct rq_map_data *, struct sg_iovec *,
>   				     int, int, gfp_t);
> -extern int bio_uncopy_user(struct bio *);
> +extern int bio_uncopy_user(struct bio *, bool);
>   void zero_fill_bio(struct bio *bio);
>   extern struct bio_vec *bvec_alloc(gfp_t, int, unsigned long *, mempool_t *);
>   extern void bvec_free(mempool_t *, struct bio_vec *, unsigned int);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 2fdb4a4..934ce38 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -790,7 +790,16 @@ extern void blk_run_queue_async(struct request_queue *q);
>   extern int blk_rq_map_user(struct request_queue *, struct request *,
>   			   struct rq_map_data *, void __user *, unsigned long,
>   			   gfp_t);
> -extern int blk_rq_unmap_user(struct bio *);
> +extern int _blk_rq_unmap_user(struct bio *bio, bool copy);
> +static inline int blk_rq_unmap_user(struct bio *bio)
> +{
> +	return _blk_rq_unmap_user(bio, true);
> +}
> +static inline int blk_rq_unmap_user_nocopy(struct bio *bio)
> +{
> +	return _blk_rq_unmap_user(bio, false);
> +}
> +
>   extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
>   extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
>   			       struct rq_map_data *, struct sg_iovec *, int,
>
