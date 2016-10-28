From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 11/12] nvme: Use BLK_MQ_S_STOPPED instead of
 QUEUE_FLAG_STOPPED in blk-mq code
Date: Fri, 28 Oct 2016 12:01:45 -0400
Message-ID: <20161028160145.GC5621@localhost.localdomain>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
 <805e1911-cd10-0563-c76b-256d76054b08@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:53357 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752947AbcJ1PvB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 11:51:01 -0400
Content-Disposition: inline
In-Reply-To: <805e1911-cd10-0563-c76b-256d76054b08@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On Wed, Oct 26, 2016 at 03:56:04PM -0700, Bart Van Assche wrote:
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 7bb73ba..b662416 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -205,7 +205,7 @@ void nvme_requeue_req(struct request *req)
>  
>  	blk_mq_requeue_request(req, false);
>  	spin_lock_irqsave(req->q->queue_lock, flags);
> -	if (!blk_queue_stopped(req->q))
> +	if (!blk_mq_queue_stopped(req->q))
>  		blk_mq_kick_requeue_list(req->q);
>  	spin_unlock_irqrestore(req->q->queue_lock, flags);
>  }
> @@ -2079,10 +2079,6 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl)
>  
>  	mutex_lock(&ctrl->namespaces_mutex);
>  	list_for_each_entry(ns, &ctrl->namespaces, list) {
> -		spin_lock_irq(ns->queue->queue_lock);
> -		queue_flag_set(QUEUE_FLAG_STOPPED, ns->queue);
> -		spin_unlock_irq(ns->queue->queue_lock);
> -
>  		blk_mq_cancel_requeue_work(ns->queue);
>  		blk_mq_stop_hw_queues(ns->queue);

There's actually a reason the queue stoppage is using a different flag
than blk_mq_queue_stopped: kicking the queue starts stopped queues.
The driver has to ensure the requeue work can't be kicked prior to
cancelling the current requeue work. Once we know requeue work isn't
running and can't restart again, then we're safe to stop the hw queues.

It's a pretty obscure condition, requiring the controller post an
error completion at the same time the driver decides to reset the
controller. Here's the sequence with the wrong outcome:

 CPU A                   CPU B
 -----                   -----
nvme_stop_queues         nvme_requeue_req
 blk_mq_stop_hw_queues    if (blk_mq_queue_stopped) <- returns false
  blk_mq_stop_hw_queue     blk_mq_kick_requeue_list
                         blk_mq_requeue_work
                          blk_mq_start_hw_queues
