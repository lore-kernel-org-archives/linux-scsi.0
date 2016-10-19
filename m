From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 04/11] blk-mq: Introduce blk_mq_quiesce_queue()
Date: Wed, 19 Oct 2016 15:23:21 +0200
Message-ID: <20161019132321.GD6323@lst.de>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com> <e42a952c-f245-eb39-d0a1-0336035573f9@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41958 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942710AbcJSOle (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Oct 2016 10:41:34 -0400
Content-Disposition: inline
In-Reply-To: <e42a952c-f245-eb39-d0a1-0336035573f9@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

> +/**
> + * blk_mq_quiesce_queue() - wait until all ongoing queue_rq calls have finished
> + *
> + * Note: this function does not prevent that the struct request end_io()
> + * callback function is invoked. Additionally, it is not prevented that
> + * new queue_rq() calls occur unless the queue has been stopped first.
> + */
> +void blk_mq_quiesce_queue(struct request_queue *q)

If this is intended to be a kerneldoc comment you need to document the 'q'
parameter.  If not you should drop the magic "/**" marker.

> +static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
> +{
> +	int srcu_idx;
> +
> +	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask) &&
> +		cpu_online(hctx->next_cpu));
> +
> +	if (!(hctx->flags & BLK_MQ_F_BLOCKING)) {
> +		rcu_read_lock();
> +		blk_mq_process_rq_list(hctx);
> +		rcu_read_unlock();
> +	} else {
> +		srcu_idx = srcu_read_lock(&hctx->queue_rq_srcu);
> +		blk_mq_process_rq_list(hctx);
> +		srcu_read_unlock(&hctx->queue_rq_srcu, srcu_idx);
> +	}
> +}

Can you document these synchronization changes in detail in the changelog?

> +static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
> +				      struct request *rq, blk_qc_t *cookie)
> +{
> +	if (blk_mq_hctx_stopped(hctx) ||
> +	    blk_mq_direct_issue_request(rq, cookie) != 0)
> +		blk_mq_insert_request(rq, false, true, true);
> +}

Any reason not to merge this function with blk_mq_direct_issue_request?

Otherwise this change looks fine to me.
