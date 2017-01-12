From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] preview - block layer help to detect sequential IO
Date: Thu, 12 Jan 2017 15:54:39 -0500
Message-ID: <x494m14atio.fsf@segfault.boston.devel.redhat.com>
References: <1484138217-20486-1-git-send-email-kashyap.desai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35498 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750768AbdALUzC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 15:55:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com, kent.overstreet@gmail.com

Hi, Kashyap,

I'm CC-ing Kent, seeing how this is his code.

Kashyap Desai <kashyap.desai@broadcom.com> writes:

> Objective of this patch is - 
>
> To move code used in bcache module in block layer which is used to
> find IO stream.  Reference code @drivers/md/bcache/request.c
> check_should_bypass().  This is a high level patch for review and
> understand if it is worth to follow ?
>
> As of now bcache module use this logic, but good to have it in block
> layer and expose function for external use.
>
> In this patch, I move logic of sequential IO search in block layer and
> exposed function blk_queue_rq_seq_cutoff.  Low level driver just need
> to call if they want stream detection per request queue.  For my
> testing I just added call blk_queue_rq_seq_cutoff(sdev->request_queue,
> 4) megaraid_sas driver.
>  
> In general, code of bcache module was referred and they are doing
> almost same as what we want to do in megaraid_sas driver below patch -
>
> http://marc.info/?l=linux-scsi&m=148245616108288&w=2
>  
> bcache implementation use search algorithm (hashed based on bio start
> sector) and detects 128 streams. <bcache> wanted those implementation
> to skip sequential IO to be placed on SSD and move it direct to the
> HDD.
>
> Will it be good design to keep this algorithm open at block layer (as
> proposed in patch.) ?

It's almost always a good idea to avoid code duplication, but this patch
definitely needs some work.

I haven't looked terribly closely at the bcache implementaiton, so do
let me know if I've misinterpreted something.

We should track streams per io_context/queue pair.  We already have a
data structure for that, the io_cq.  Right now that structure is
tailored for use by the I/O schedulers, but I'm sure we could rework
that.  That would also get rid of the tremedous amount of bloat this
patch adds to the request_queue.  It will also allow us to remove the
bcache-specific fields that were added to task_struct.  Overall, it
should be a good simplification, unless I've completely missed the point
(which happens).

I don't like that you put sequential I/O detection into bio_check_eod.
Split it out into its own function.

You've added a member to struct bio that isn't referenced.  It would
have been nice of you to put enough work into this RFC so that we could
at least see how the common code was used by bcache and your driver.

EWMA (exponentially weighted moving average) is not an acronym I keep
handy in my head.  It would be nice to add documentation on the
algorithm and design choices.  More comments in the code would also be
appreciated.  CFQ does some similar things (detecting sequential
vs. seeky I/O) in a much lighter-weight fashion.  Any change to the
algorithm, of course, would have to be verified to still meet bcache's
needs.

A queue flag might be a better way for the driver to request this
functionality.

Coding style will definitely need fixing.

I hope that was helpful.

Cheers,
Jeff

>
> Signed-off-by: Kashyap desai <kashyap.desai@broadcom.com>
> ---
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 14d7c07..2e93d14 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -693,6 +693,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
>  {
>  	struct request_queue *q;
>  	int err;
> +	struct seq_io_tracker *io;
>  
>  	q = kmem_cache_alloc_node(blk_requestq_cachep,
>  				gfp_mask | __GFP_ZERO, node_id);
> @@ -761,6 +762,15 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
>  
>  	if (blkcg_init_queue(q))
>  		goto fail_ref;
> +	
> +	q->sequential_cutoff = 0;
> +	spin_lock_init(&q->io_lock);
> +	INIT_LIST_HEAD(&q->io_lru);
> +
> +	for (io = q->io; io < q->io + BLK_RECENT_IO; io++) {
> +		list_add(&io->lru, &q->io_lru);
> +		hlist_add_head(&io->hash, q->io_hash + BLK_RECENT_IO);
> +	}
>  
>  	return q;
>  
> @@ -1876,6 +1886,26 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
>  	return 0;
>  }
>  
> +static void add_sequential(struct task_struct *t)
> +{
> +#define blk_ewma_add(ewma, val, weight, factor)                             \
> +({                                                                      \
> +        (ewma) *= (weight) - 1;                                         \
> +        (ewma) += (val) << factor;                                      \
> +        (ewma) /= (weight);                                             \
> +        (ewma) >> factor;                                               \
> +})
> +
> +	blk_ewma_add(t->sequential_io_avg,
> +		 t->sequential_io, 8, 0);
> +
> +	t->sequential_io = 0;
> +}
> +static struct hlist_head *blk_iohash(struct request_queue *q, uint64_t k)
> +{
> +	return &q->io_hash[hash_64(k, BLK_RECENT_IO_BITS)];
> +}
> +
>  static noinline_for_stack bool
>  generic_make_request_checks(struct bio *bio)
>  {
> @@ -1884,6 +1914,7 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
>  	int err = -EIO;
>  	char b[BDEVNAME_SIZE];
>  	struct hd_struct *part;
> +	struct task_struct *task = current;
>  
>  	might_sleep();
>  
> @@ -1957,6 +1988,42 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
>  	if (!blkcg_bio_issue_check(q, bio))
>  		return false;
>  
> +	if (q->sequential_cutoff) {
> +		struct seq_io_tracker *i;
> +		unsigned sectors;
> +
> +		spin_lock(&q->io_lock);
> +
> +		hlist_for_each_entry(i, blk_iohash(q, bio->bi_iter.bi_sector), hash)
> +			if (i->last == bio->bi_iter.bi_sector &&
> +			    time_before(jiffies, i->jiffies))
> +				goto found;
> +
> +		i = list_first_entry(&q->io_lru, struct seq_io_tracker, lru);
> +
> +		add_sequential(task);
> +		i->sequential = 0;
> +found:
> +		if (i->sequential + bio->bi_iter.bi_size > i->sequential)
> +			i->sequential	+= bio->bi_iter.bi_size;
> +
> +		i->last			 = bio_end_sector(bio);
> +		i->jiffies		 = jiffies + msecs_to_jiffies(5000);
> +		task->sequential_io	 = i->sequential;
> +
> +		hlist_del(&i->hash);
> +		hlist_add_head(&i->hash, blk_iohash(q, i->last));
> +		list_move_tail(&i->lru, &q->io_lru);
> +
> +		spin_unlock(&q->io_lock);
> +
> +		sectors = max(task->sequential_io,
> +			      task->sequential_io_avg) >> 9;
> +		if (sectors >= q->sequential_cutoff >> 9) {
> +			bio->is_sequential = true;
> +		}
> +	}
> +
>  	trace_block_bio_queue(q, bio);
>  	return true;
>  
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f3d27a6..f7d3845 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1977,6 +1977,7 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
>  	/* mark the queue as mq asap */
>  	q->mq_ops = set->ops;
>  
> +	struct seq_io_tracker *io;
>  	q->queue_ctx = alloc_percpu(struct blk_mq_ctx);
>  	if (!q->queue_ctx)
>  		goto err_exit;
> @@ -2017,6 +2018,14 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
>  	 * Do this after blk_queue_make_request() overrides it...
>  	 */
>  	q->nr_requests = set->queue_depth;
> +	q->sequential_cutoff = 0;
> +	spin_lock_init(&q->io_lock);
> +	INIT_LIST_HEAD(&q->io_lru);
> +
> +	for (io = q->io; io < q->io + BLK_RECENT_IO; io++) {
> +		list_add(&io->lru, &q->io_lru);
> +		hlist_add_head(&io->hash, q->io_hash + BLK_RECENT_IO);
> +	}
>  
>  	if (set->ops->complete)
>  		blk_queue_softirq_done(q, set->ops->complete);
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index f679ae1..fae7d00 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -65,6 +65,13 @@ void blk_queue_rq_timeout(struct request_queue *q, unsigned int timeout)
>  }
>  EXPORT_SYMBOL_GPL(blk_queue_rq_timeout);
>  
> +void blk_queue_rq_seq_cutoff(struct request_queue *q, unsigned int cutoff)
> +{
> +	q->sequential_cutoff = cutoff << 20;
> +	printk(KERN_INFO "%s: set seq cutoff %lx\n", __func__, q->sequential_cutoff);
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_rq_seq_cutoff);
> +
>  void blk_queue_rq_timed_out(struct request_queue *q, rq_timed_out_fn *fn)
>  {
>  	q->rq_timed_out_fn = fn;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index cd395ec..a73ff37 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -73,6 +73,7 @@ struct bio {
>  	 */
>  
>  	unsigned short		bi_max_vecs;	/* max bvl_vecs we can hold */
> +	bool			is_sequential;
>  
>  	atomic_t		__bi_cnt;	/* pin count */
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c47c358..1d3fb45 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -292,6 +292,17 @@ struct queue_limits {
>  	unsigned char		raid_partial_stripes_expensive;
>  };
>  
> +#define BLK_RECENT_IO_BITS  7
> +#define BLK_RECENT_IO       (1 << BLK_RECENT_IO_BITS)
> +struct seq_io_tracker {
> +        /* Used to track sequential IO so it can be skipped */
> +        struct hlist_node       hash;
> +        struct list_head        lru;
> +
> +        unsigned long           jiffies;
> +        unsigned                sequential;
> +        sector_t                last;
> +};
>  struct request_queue {
>  	/*
>  	 * Together with queue_head for cacheline sharing
> @@ -337,6 +348,13 @@ struct request_queue {
>  	sector_t		end_sector;
>  	struct request		*boundary_rq;
>  
> +	/* For tracking sequential IO */
> +	struct seq_io_tracker       io[BLK_RECENT_IO];
> +	struct hlist_head       io_hash[BLK_RECENT_IO + 1];
> +	struct list_head        io_lru;
> +	spinlock_t              io_lock;
> +	unsigned 		sequential_cutoff;
> +	
>  	/*
>  	 * Delayed queue handling
>  	 */
> @@ -1023,6 +1041,7 @@ extern int blk_queue_dma_drain(struct request_queue *q,
>  extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
>  extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
>  extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
> +extern void blk_queue_rq_seq_cutoff(struct request_queue *, unsigned int);
>  extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
>  extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
>  extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
