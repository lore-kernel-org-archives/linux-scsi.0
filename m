From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 11/11] nvme: Fix a race condition
Date: Wed, 19 Oct 2016 15:41:31 +0200
Message-ID: <20161019134131.GD6809@lst.de>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com> <2a29b7ec-0113-3450-9a36-b925b47b1fb0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2a29b7ec-0113-3450-9a36-b925b47b1fb0@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hi Bart,

this looks great!

Reviewed-by: Christoph Hellwig <hch@lst.de>

Some minor nitpicks below:

>  void nvme_requeue_req(struct request *req)
>  {
> +	blk_mq_requeue_request(req, true);
>  }
>  EXPORT_SYMBOL_GPL(nvme_requeue_req);

Please just remove the nvme_requeue_req wrapper.

>  
> @@ -2074,11 +2068,14 @@ EXPORT_SYMBOL_GPL(nvme_kill_queues);
>  void nvme_stop_queues(struct nvme_ctrl *ctrl)
>  {
>  	struct nvme_ns *ns;
> +	struct request_queue *q;
>  
>  	mutex_lock(&ctrl->namespaces_mutex);
>  	list_for_each_entry(ns, &ctrl->namespaces, list) {
> +		q = ns->queue;
> +		blk_mq_cancel_requeue_work(q);
> +		blk_mq_stop_hw_queues(q);
> +		blk_mq_quiesce_queue(q);
>  	}

I'd keep the q declaration in the minimal scope, e.g.

	list_for_each_entry(ns, &ctrl->namespaces, list) {
		struct request_queue *q = ns->queue;

		blk_mq_cancel_requeue_work(q);
		blk_mq_stop_hw_queues(q);
		blk_mq_quiesce_queue(q);
	}
