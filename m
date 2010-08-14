From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Date: Sat, 14 Aug 2010 12:36:54 +0200
Message-ID: <20100814103654.GA13292@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org> <20100813143820.GA7931@lst.de> <4C655BE5.4070809@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C655BE5.4070809@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 13, 2010 at 04:51:17PM +0200, Tejun Heo wrote:
> Do you want to change the whole thing in a single commit?  That would
> be a pretty big invasive patch touching multiple subsystems.

We can just stop draining in the block layer in the first patch, then
stop doing the stuff in md/dm/etc in the following and then do the
final renaming patches.  It would still be less patches then now, but
keep things working through the whole transition, which would really
help biseting any problems.

> +			if (req->cmd_flags & REQ_FUA)
> +				vbr->out_hdr.type |= VIRTIO_BLK_T_FUA;

I'd suggest not adding FUA support to virtio yet.  Just using the flush
feature gives you a fully working barrier implementation.

Eventually we might want to add a flag in the block queue to send
REQ_FLUSH|REQ_FUA request through to virtio directly so that we can
avoid separate pre- and post flushes, but I really want to benchmark if
it makes an impact on real life setups first.

> Index: block/drivers/md/linear.c
> ===================================================================
> --- block.orig/drivers/md/linear.c
> +++ block/drivers/md/linear.c
> @@ -294,8 +294,8 @@ static int linear_make_request (mddev_t
>  	dev_info_t *tmp_dev;
>  	sector_t start_sector;
> 
> -	if (unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
> -		md_barrier_request(mddev, bio);
> +	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
> +		md_flush_request(mddev, bio);

We only need the special md_flush_request handling for
empty REQ_FLUSH requests.  REQ_WRITE | REQ_FLUSH just need the
flag propagated to the underlying devices.

> +static void md_end_flush(struct bio *bio, int err)
>  {
>  	mdk_rdev_t *rdev = bio->bi_private;
>  	mddev_t *mddev = rdev->mddev;
> 
>  	rdev_dec_pending(rdev, mddev);
> 
>  	if (atomic_dec_and_test(&mddev->flush_pending)) {
> +		/* The pre-request flush has finished */
> +		schedule_work(&mddev->flush_work);

Once we only handle empty barriers here we can directly call bio_endio
instead of first scheduling a work queue.Once we only handle empty
barriers here we can directly call bio_endio and the super wakeup
instead of first scheduling a work queue.

>  	while ((bio = bio_list_pop(writes))) {
> -		if (unlikely(bio_empty_barrier(bio))) {
> +		if ((bio->bi_rw & REQ_FLUSH) && !bio_has_data(bio)) {

I kept bio_empty_barrier as bio_empty_flush, which actually is a quite
useful macro for the bio based drivers.

> @@ -621,7 +621,7 @@ static void dec_pending(struct dm_io *io
>  			 */
>  			spin_lock_irqsave(&md->deferred_lock, flags);
>  			if (__noflush_suspending(md)) {
> -				if (!(io->bio->bi_rw & REQ_HARDBARRIER))
> +				if (!(io->bio->bi_rw & REQ_FLUSH))

I suspect we don't actually need to special case flushes here anymore.


> @@ -633,14 +633,14 @@ static void dec_pending(struct dm_io *io
>  		io_error = io->error;
>  		bio = io->bio;
> 
> -		if (bio->bi_rw & REQ_HARDBARRIER) {
> +		if (bio->bi_rw & REQ_FLUSH) {
>  			/*
> -			 * There can be just one barrier request so we use
> +			 * There can be just one flush request so we use
>  			 * a per-device variable for error reporting.
>  			 * Note that you can't touch the bio after end_io_acct
>  			 */
> -			if (!md->barrier_error && io_error != -EOPNOTSUPP)
> -				md->barrier_error = io_error;
> +			if (!md->flush_error)
> +				md->flush_error = io_error;

And we certainly do not need any special casing here.  See my patch.

>  {
>  	int rw = rq_data_dir(clone);
>  	int run_queue = 1;
> -	bool is_barrier = clone->cmd_flags & REQ_HARDBARRIER;
> +	bool is_flush = clone->cmd_flags & REQ_FLUSH;
>  	struct dm_rq_target_io *tio = clone->end_io_data;
>  	struct mapped_device *md = tio->md;
>  	struct request *rq = tio->orig;
> 
> -	if (rq->cmd_type == REQ_TYPE_BLOCK_PC && !is_barrier) {
> +	if (rq->cmd_type == REQ_TYPE_BLOCK_PC && !is_flush) {

We never send flush requests as REQ_TYPE_BLOCK_PC anymore, so no need
for the second half of this conditional.

> +	if (!is_flush)
> +		blk_end_request_all(rq, error);
> +	else {
>  		if (unlikely(error))
> -			store_barrier_error(md, error);
> +			store_flush_error(md, error);
>  		run_queue = 0;
> -	} else
> -		blk_end_request_all(rq, error);
> +	}

Flush requests can now be completed normally.

> @@ -1308,11 +1302,11 @@ static void __split_and_process_bio(stru
> 
>  	ci.map = dm_get_live_table(md);
>  	if (unlikely(!ci.map)) {
> -		if (!(bio->bi_rw & REQ_HARDBARRIER))
> +		if (!(bio->bi_rw & REQ_FLUSH))
>  			bio_io_error(bio);
>  		else
> -			if (!md->barrier_error)
> -				md->barrier_error = -EIO;
> +			if (!md->flush_error)
> +				md->flush_error = -EIO;

No need for the special error handling here, flush requests can now
be completed normally.

> @@ -1417,11 +1419,11 @@ static int _dm_request(struct request_qu
>  	part_stat_unlock();
> 
>  	/*
> -	 * If we're suspended or the thread is processing barriers
> +	 * If we're suspended or the thread is processing flushes
>  	 * we have to queue this io for later.
>  	 */
>  	if (unlikely(test_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags)) ||
> -	    unlikely(bio->bi_rw & REQ_HARDBARRIER)) {
> +	    (bio->bi_rw & REQ_FLUSH)) {
>  		up_read(&md->io_lock);

AFAICS this is only needed for the old barrier code, no need for this
for pure flushes.

> @@ -1464,10 +1466,7 @@ static int dm_request(struct request_que
> 
>  static bool dm_rq_is_flush_request(struct request *rq)
>  {
> -	if (rq->cmd_flags & REQ_FLUSH)
> -		return true;
> -	else
> -		return false;
> +	return rq->cmd_flags & REQ_FLUSH;
>  }

It's probably worth just killing this wrapper.


>  void dm_dispatch_request(struct request *rq)
> @@ -1520,7 +1519,7 @@ static int setup_clone(struct request *c
>  	if (dm_rq_is_flush_request(rq)) {
>  		blk_rq_init(NULL, clone);
>  		clone->cmd_type = REQ_TYPE_FS;
> -		clone->cmd_flags |= (REQ_HARDBARRIER | WRITE);
> +		clone->cmd_flags |= (REQ_FLUSH | WRITE);
>  	} else {
>  		r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
>  				      dm_rq_bio_constructor, tio);

My suspicion is that we can get rif of all that special casing here
and just use blk_rq_prep_clone once it's been updated to propagate
REQ_FLUSH, similar to the DISCARD flag.

I also suspect that there is absolutely no need to the barrier work
queue once we stop waiting for outstanding request.  But then again
the request based dm code still somewhat confuses me.

> +static void process_flush(struct mapped_device *md, struct bio *bio)
>  {
> +	md->flush_error = 0;
> +
> +	/* handle REQ_FLUSH */
>  	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
> 
> -	bio_init(&md->barrier_bio);
> -	md->barrier_bio.bi_bdev = md->bdev;
> -	md->barrier_bio.bi_rw = WRITE_BARRIER;
> -	__split_and_process_bio(md, &md->barrier_bio);
> +	bio_init(&md->flush_bio);
> +	md->flush_bio.bi_bdev = md->bdev;
> +	md->flush_bio.bi_rw = WRITE_FLUSH;
> +	__split_and_process_bio(md, &md->flush_bio);

There's not need to use a separate flush_bio here.
__split_and_process_bio does the right thing for empty REQ_FLUSH
requests.  See my patch for how to do this differenty.  And yeah,
my version has been tested.
