From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH v5 14/14] nvme: Use BLK_MQ_S_STOPPED instead of
 QUEUE_FLAG_STOPPED in blk-mq code
Date: Mon, 31 Oct 2016 09:53:18 -0400 (EDT)
Message-ID: <540193784.5466628.1477921998345.JavaMail.zimbra@redhat.com>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com> <fe057bf0-6ede-fc9e-9a53-9d790c9782c2@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <fe057bf0-6ede-fc9e-9a53-9d790c9782c2@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Roger Pau =?utf-8?Q?Monn=C3=A9?= <roger.pau@citrix.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche@sandisk.com>
> To: "Jens Axboe" <axboe@fb.com>
> Cc: "Christoph Hellwig" <hch@lst.de>, "James Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen"
> <martin.petersen@oracle.com>, "Mike Snitzer" <snitzer@redhat.com>, "Doug Ledford" <dledford@redhat.com>, "Keith
> Busch" <keith.busch@intel.com>, "Ming Lei" <tom.leiming@gmail.com>, "Konrad Rzeszutek Wilk"
> <konrad.wilk@oracle.com>, "Roger Pau Monné" <roger.pau@citrix.com>, "Laurence Oberman" <loberman@redhat.com>,
> linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
> Sent: Friday, October 28, 2016 8:23:40 PM
> Subject: [PATCH v5 14/14] nvme: Use BLK_MQ_S_STOPPED instead of QUEUE_FLAG_STOPPED in blk-mq code
> 
> Make nvme_requeue_req() check BLK_MQ_S_STOPPED instead of
> QUEUE_FLAG_STOPPED. Remove the QUEUE_FLAG_STOPPED manipulations
> that became superfluous because of this change. Change
> blk_queue_stopped() tests into blk_mq_queue_stopped().
> 
> This patch fixes a race condition: using queue_flag_clear_unlocked()
> is not safe if any other function that manipulates the queue flags
> can be called concurrently, e.g. blk_cleanup_queue().
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> ---
>  drivers/nvme/host/core.c | 16 ++--------------
>  1 file changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index fe15d94..45dd237 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -201,13 +201,7 @@ static struct nvme_ns *nvme_get_ns_from_disk(struct
> gendisk *disk)
>  
>  void nvme_requeue_req(struct request *req)
>  {
> -	unsigned long flags;
> -
> -	blk_mq_requeue_request(req, false);
> -	spin_lock_irqsave(req->q->queue_lock, flags);
> -	if (!blk_queue_stopped(req->q))
> -		blk_mq_kick_requeue_list(req->q);
> -	spin_unlock_irqrestore(req->q->queue_lock, flags);
> +	blk_mq_requeue_request(req, !blk_mq_queue_stopped(req->q));
>  }
>  EXPORT_SYMBOL_GPL(nvme_requeue_req);
>  
> @@ -2078,13 +2072,8 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl)
>  	struct nvme_ns *ns;
>  
>  	mutex_lock(&ctrl->namespaces_mutex);
> -	list_for_each_entry(ns, &ctrl->namespaces, list) {
> -		spin_lock_irq(ns->queue->queue_lock);
> -		queue_flag_set(QUEUE_FLAG_STOPPED, ns->queue);
> -		spin_unlock_irq(ns->queue->queue_lock);
> -
> +	list_for_each_entry(ns, &ctrl->namespaces, list)
>  		blk_mq_quiesce_queue(ns->queue);
> -	}
>  	mutex_unlock(&ctrl->namespaces_mutex);
>  }
>  EXPORT_SYMBOL_GPL(nvme_stop_queues);
> @@ -2095,7 +2084,6 @@ void nvme_start_queues(struct nvme_ctrl *ctrl)
>  
>  	mutex_lock(&ctrl->namespaces_mutex);
>  	list_for_each_entry(ns, &ctrl->namespaces, list) {
> -		queue_flag_clear_unlocked(QUEUE_FLAG_STOPPED, ns->queue);
>  		blk_mq_start_stopped_hw_queues(ns->queue, true);
>  		blk_mq_kick_requeue_list(ns->queue);
>  	}
> --
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello Bart

Thanks for all this work.

Applied all 14 patches, also corrected the part of the xen-blkfront.c blkif_recover patch in patchv5-5/14.

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9908597..60fff99 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2045,6 +2045,7 @@ static int blkif_recover(struct blkfront_info *info)
                 BUG_ON(req->nr_phys_segments > segs);
                 blk_mq_requeue_request(req);
         }
+        blk_mq_start_stopped_hw_queues(infrq, true);                    *** Corrected
         blk_mq_kick_requeue_list(infrq);
 
         while ((bio = bio_list_pop(&infbio_list)) != NULL) {

Ran multiple read/write buffered and directio tests via RDMA/SRP and mlx5 (100Gbit) with max_sectors_kb set to 1024, 2048, 4096 and 8196
Ran multiple read/write buffered and directio tests via RDMA/SRP and mlx4 (56Gbit)  with max_sectors_kb set to 1024, 2048, 4096 and 8196
Reset the SRP hosts multiple times with multipath set to no_path_retry queue
Ran basic NVME read/write testing with no hot plug disconnects on multiple block sizes

All tests passed.

For the series:
Tested-by: Laurence Oberman <loberman@redhat.com>
