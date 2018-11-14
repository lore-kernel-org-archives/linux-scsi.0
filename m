From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [RFC PATCH] SCSI: fix queue cleanup race before queue is
 initialized done
Date: Wed, 14 Nov 2018 13:41:46 +0800
Message-ID: <31e77713-c974-1d6a-89a6-7c09b8190ef1@oracle.com>
References: <20181114043512.19627-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181114043512.19627-1-ming.lei@redhat.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Andrew Jones <drjones@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 11/14/18 12:35 PM, Ming Lei wrote:
> c2856ae2f315d ("blk-mq: quiesce queue before freeing queue") has
> already fixed this race, however the implied synchronize_rcu()
> in blk_mq_quiesce_queue() can slow down LUN probe a lot, so caused
> performance regression.
> 
> Then 1311326cf4755c7 ("blk-mq: avoid to synchronize rcu inside blk_cleanup_queue()")
> tried to only quiesce queue for avoiding unnecessary synchronize_rcu()
> in case that queue isn't initialized done.
> 
> However, turns out we still need to quiesce the queue in case that
> queue isn't initialized done. Because when one SCSI command is
> completed, the user is waken up immediately, then the scsi device
> can be removed, meantime the run queue in scsi_end_request() can
> be still in-progress, so kernel panic is triggered.
> 
> In Red Hat QE lab, there are several reports about this kind of kernel
> panic triggered during kernel booting.
> 
> Fixes: 1311326cf4755c7 ("blk-mq: avoid to synchronize rcu inside blk_cleanup_queue()")
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-core.c        |  6 +++---
>  drivers/scsi/scsi_lib.c | 36 ++++++++++++++++++++++++++++++------
>  2 files changed, 33 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index ce12515f9b9b..cf7742a677c4 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -798,9 +798,9 @@ void blk_cleanup_queue(struct request_queue *q)
>  	 * dispatch may still be in-progress since we dispatch requests
>  	 * from more than one contexts.
>  	 *
> -	 * No need to quiesce queue if it isn't initialized yet since
> -	 * blk_freeze_queue() should be enough for cases of passthrough
> -	 * request.
> +	 * We rely on driver to deal with the race in case that queue
> +	 * initialization isn't done.
> +	 *
>  	 */
>  	if (q->mq_ops && blk_queue_init_done(q))
>  		blk_mq_quiesce_queue(q);
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index c7fccbb8f554..7ec7a8a2d000 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -697,13 +697,37 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>  		 */
>  		scsi_mq_uninit_cmd(cmd);
>  
> -		__blk_mq_end_request(req, error);
> +		/*
> +		 * When block queue initialization isn't done, the request
> +		 * queue won't be quiesced in blk_cleanup_queue() for avoiding
> +		 * slowing down LUN probe, so queue still may be run even though
> +		 * its resource is cleaned up, this way can cause kernel panic.
> +		 *
> +		 * Workaround this issue by freeing request after running the
> +		 * queue when queue initialization isn't done, so the queue's
> +		 * usage counter can be held during running queue.
> +		 *
> +		 * This way is safe because sdev->device_busy has been decreased
> +		 * already, and scsi_queue_rq() may guarantee the forward-progress.
> +		 *
> +		 */
> +		if (blk_queue_init_done(q)) {
> +			__blk_mq_end_request(req, error);
> +
> +			if (scsi_target(sdev)->single_lun ||
> +					!list_empty(&sdev->host->starved_list))
> +				kblockd_schedule_work(&sdev->requeue_work);
> +			else
> +				blk_mq_run_hw_queues(q, true);
> +		} else {
>  
> -		if (scsi_target(sdev)->single_lun ||
> -		    !list_empty(&sdev->host->starved_list))
> -			kblockd_schedule_work(&sdev->requeue_work);
> -		else
> -			blk_mq_run_hw_queues(q, true);
> +			if (scsi_target(sdev)->single_lun ||
> +					!list_empty(&sdev->host->starved_list))
> +				kblockd_schedule_work(&sdev->requeue_work);
> +			else
> +				blk_mq_run_hw_queues(q, true);
> +			__blk_mq_end_request(req, error);
> +		}
>  	} else {
>  		unsigned long flags;
>  
> 

Why not get a q_usage_counter during this ?

Something like，

@@ -610,6 +610,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
         */
        scsi_mq_uninit_cmd(cmd);
 
+       percpu_ref_get(&q->q_usage_counter)
        __blk_mq_end_request(req, error);
 
        if (scsi_target(sdev)->single_lun ||
@@ -618,6 +619,8 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
        else
                blk_mq_run_hw_queues(q, true);
 
+       percpu_ref_put(&q->q_usage_counter)
+
        put_device(&sdev->sdev_gendev);
        return false;
 }

Thanks
Jianchao
