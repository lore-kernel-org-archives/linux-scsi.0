From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v7 9/9] block, scsi: Make SCSI quiesce and resume work
 reliably
Date: Tue, 10 Oct 2017 18:56:28 +0800
Message-ID: <20171010105626.GB18664@ming.t460p>
References: <20171009231400.562-1-bart.vanassche@wdc.com>
 <20171009231400.562-10-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171009231400.562-10-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 09, 2017 at 04:14:00PM -0700, Bart Van Assche wrote:
> The contexts from which a SCSI device can be quiesced or resumed are:
> * Writing into /sys/class/scsi_device/*/device/state.
> * SCSI parallel (SPI) domain validation.
> * The SCSI device power management methods. See also scsi_bus_pm_ops.
> 
> It is essential during suspend and resume that neither the filesystem
> state nor the filesystem metadata in RAM changes. This is why while
> the hibernation image is being written or restored that SCSI devices
> are quiesced. The SCSI core quiesces devices through scsi_device_quiesce()
> and scsi_device_resume(). In the SDEV_QUIESCE state execution of
> non-preempt requests is deferred. This is realized by returning
> BLKPREP_DEFER from inside scsi_prep_state_check() for quiesced SCSI
> devices. Avoid that a full queue prevents power management requests
> to be submitted by deferring allocation of non-preempt requests for
> devices in the quiesced state. This patch has been tested by running
> the following commands and by verifying that after resume the fio job
> is still running:
> 
> for d in /sys/class/block/sd*[a-z]; do
>   hcil=$(readlink "$d/device")
>   hcil=${hcil#../../../}
>   echo 4 > "$d/queue/nr_requests"
>   echo 1 > "/sys/class/scsi_device/$hcil/device/queue_depth"
> done
> bdev=$(readlink /dev/disk/by-uuid/5217d83f-213e-4b42-b86e-20013325ba6c)
> bdev=${bdev#../../}
> hcil=$(readlink "/sys/block/$bdev/device")
> hcil=${hcil#../../../}
> fio --name="$bdev" --filename="/dev/$bdev" --buffered=0 --bs=512 --rw=randread \
>   --ioengine=libaio --numjobs=4 --iodepth=16 --iodepth_batch=1 --thread \
>   --loops=$((2**31)) &
> pid=$!
> sleep 1
> systemctl hibernate
> sleep 10
> kill $pid
> 
> Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> References: "I/O hangs after resuming from suspend-to-ram" (https://marc.info/?l=linux-block&m=150340235201348).
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  block/blk-core.c        | 42 +++++++++++++++++++++++++++++++++++-------
>  block/blk-mq.c          |  4 ++--
>  block/blk-timeout.c     |  2 +-
>  drivers/scsi/scsi_lib.c | 28 ++++++++++++++++++----------
>  fs/block_dev.c          |  4 ++--
>  include/linux/blkdev.h  |  2 +-
>  6 files changed, 59 insertions(+), 23 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index ed992cbd107f..3847ea42e341 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -372,6 +372,7 @@ void blk_clear_preempt_only(struct request_queue *q)
>  
>  	spin_lock_irqsave(q->queue_lock, flags);
>  	queue_flag_clear(QUEUE_FLAG_PREEMPT_ONLY, q);
> +	wake_up_all(&q->mq_freeze_wq);
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(blk_clear_preempt_only);
> @@ -793,15 +794,40 @@ struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
>  }
>  EXPORT_SYMBOL(blk_alloc_queue);
>  
> -int blk_queue_enter(struct request_queue *q, bool nowait)
> +/**
> + * blk_queue_enter() - try to increase q->q_usage_counter
> + * @q: request queue pointer
> + * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
> + */
> +int blk_queue_enter(struct request_queue *q, unsigned int flags)
>  {
> +	const bool preempt = flags & BLK_MQ_REQ_PREEMPT;
> +
>  	while (true) {
> +		bool success = false;
>  		int ret;
>  
> -		if (percpu_ref_tryget_live(&q->q_usage_counter))
> +		rcu_read_lock_sched();
> +		if (percpu_ref_tryget_live(&q->q_usage_counter)) {
> +			/*
> +			 * The code that sets the PREEMPT_ONLY flag is
> +			 * responsible for ensuring that that flag is globally
> +			 * visible before the queue is unfrozen.
> +			 */
> +			if (preempt || !blk_queue_preempt_only(q)) {
> +				success = true;
> +			} else {
> +				percpu_ref_put(&q->q_usage_counter);
> +				WARN_ONCE("%s: Attempt to allocate non-preempt request in preempt-only mode.\n",
> +					  kobject_name(q->kobj.parent));
> +			}
> +		}
> +		rcu_read_unlock_sched();
> +
> +		if (success)
>  			return 0;
>  
> -		if (nowait)
> +		if (flags & BLK_MQ_REQ_NOWAIT)
>  			return -EBUSY;
>  
>  		/*
> @@ -814,7 +840,8 @@ int blk_queue_enter(struct request_queue *q, bool nowait)
>  		smp_rmb();
>  
>  		ret = wait_event_interruptible(q->mq_freeze_wq,
> -				!atomic_read(&q->mq_freeze_depth) ||
> +				(atomic_read(&q->mq_freeze_depth) == 0 &&
> +				 (preempt || !blk_queue_preempt_only(q))) ||
>  				blk_queue_dying(q));
>  		if (blk_queue_dying(q))
>  			return -ENODEV;
> @@ -1442,8 +1469,7 @@ static struct request *blk_old_get_request(struct request_queue *q,
>  	/* create ioc upfront */
>  	create_io_context(gfp_mask, q->node);
>  
> -	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM) ||
> -			      (op & REQ_NOWAIT));
> +	ret = blk_queue_enter(q, flags);
>  	if (ret)
>  		return ERR_PTR(ret);
>  	spin_lock_irq(q->queue_lock);
> @@ -2264,8 +2290,10 @@ blk_qc_t generic_make_request(struct bio *bio)
>  	current->bio_list = bio_list_on_stack;
>  	do {
>  		struct request_queue *q = bio->bi_disk->queue;
> +		unsigned int flags = bio->bi_opf & REQ_NOWAIT ?
> +			BLK_MQ_REQ_NOWAIT : 0;
>  
> -		if (likely(blk_queue_enter(q, bio->bi_opf & REQ_NOWAIT) == 0)) {
> +		if (likely(blk_queue_enter(q, flags) == 0)) {
>  			struct bio_list lower, same;
>  
>  			/* Create a fresh bio_list for all subordinate requests */
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index bdbfe760bda0..44a06e8541f2 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -386,7 +386,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
>  	struct request *rq;
>  	int ret;
>  
> -	ret = blk_queue_enter(q, flags & BLK_MQ_REQ_NOWAIT);
> +	ret = blk_queue_enter(q, flags);
>  	if (ret)
>  		return ERR_PTR(ret);
>  
> @@ -425,7 +425,7 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
>  	if (hctx_idx >= q->nr_hw_queues)
>  		return ERR_PTR(-EIO);
>  
> -	ret = blk_queue_enter(q, true);
> +	ret = blk_queue_enter(q, flags);
>  	if (ret)
>  		return ERR_PTR(ret);
>  
> diff --git a/block/blk-timeout.c b/block/blk-timeout.c
> index e3e9c9771d36..1eba71486716 100644
> --- a/block/blk-timeout.c
> +++ b/block/blk-timeout.c
> @@ -134,7 +134,7 @@ void blk_timeout_work(struct work_struct *work)
>  	struct request *rq, *tmp;
>  	int next_set = 0;
>  
> -	if (blk_queue_enter(q, true))
> +	if (blk_queue_enter(q, BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT))
>  		return;
>  	spin_lock_irqsave(q->queue_lock, flags);
>  
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1c16a247fae6..a3cf36c8079b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2926,21 +2926,29 @@ static void scsi_wait_for_queuecommand(struct scsi_device *sdev)
>  int
>  scsi_device_quiesce(struct scsi_device *sdev)
>  {
> +	struct request_queue *q = sdev->request_queue;
>  	int err;
>  
> +	/* If the SCSI device already has been quiesced, do nothing. */
> +	if (blk_set_preempt_only(q))
> +		return 0;

This way isn't safe:

1) suppose path1 sets the flag, and blk_mq_freeze_queue() isn't
finished, or even not started;

2) path2 sees the flag set at the exact time, and returns immediately,
and unfortunately SCSI QUIESCE isn't respected in this context.

> +
> +	/*
> +	 * Since blk_mq_freeze_queue() calls synchronize_rcu() indirectly the
> +	 * effect of blk_set_preempt_only() will be visible for
> +	 * percpu_ref_tryget() callers that occur after the queue
> +	 * unfreeze. See also https://lwn.net/Articles/573497/.
> +	 */
> +	blk_mq_freeze_queue(q);
> +	blk_mq_unfreeze_queue(q);

This way isn't safe too, because queue may has been frozen before
scsi_device_quiesce() is run, then there isn't synchronize_rcu()
implicated in blk_mq_freeze_queue().

Please take a look at my previous post in the following link:

	https://marc.info/?l=linux-block&m=150703957529335&w=2
	https://marc.info/?l=linux-kernel&m=150703956929333&w=2

-- 
Ming
