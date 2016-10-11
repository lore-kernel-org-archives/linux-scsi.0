From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 7/7] [RFC] nvme: Fix a race condition
Date: Tue, 11 Oct 2016 18:46:01 +0200
Message-ID: <20161011164601.GC18822@lst.de>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com> <ff412bfb-548c-c4fc-5180-78ede8a19ef2@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ff412bfb-548c-c4fc-5180-78ede8a19ef2@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 28, 2016 at 05:01:45PM -0700, Bart Van Assche wrote:
> Avoid that nvme_queue_rq() is still running when nvme_stop_queues()
> returns. Untested.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> ---
>  drivers/nvme/host/core.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index d791fba..98f1f29 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -201,13 +201,9 @@ fail:
>  
>  void nvme_requeue_req(struct request *req)
>  {
> -	unsigned long flags;
> -
>  	blk_mq_requeue_request(req);
> -	spin_lock_irqsave(req->q->queue_lock, flags);
> -	if (!blk_mq_queue_stopped(req->q))
> -		blk_mq_kick_requeue_list(req->q);
> -	spin_unlock_irqrestore(req->q->queue_lock, flags);
> +	WARN_ON_ONCE(blk_mq_queue_stopped(req->q));
> +	blk_mq_kick_requeue_list(req->q);
>  }
>  EXPORT_SYMBOL_GPL(nvme_requeue_req);

Can we just add a 'bool kick' argument to blk_mq_requeue_request and
move all this handling to the core?
