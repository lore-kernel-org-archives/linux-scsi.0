From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V7 5/6] block: support PREEMPT_ONLY
Date: Mon, 2 Oct 2017 06:50:24 -0700
Message-ID: <20171002135024.GE19119@infradead.org>
References: <20170930061214.10622-1-ming.lei@redhat.com>
 <20170930061214.10622-6-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170930061214.10622-6-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

> +void blk_set_preempt_only(struct request_queue *q, bool preempt_only)
> +{
> +	blk_mq_freeze_queue(q);
> +	if (preempt_only)
> +		queue_flag_set_unlocked(QUEUE_FLAG_PREEMPT_ONLY, q);
> +	else
> +		queue_flag_clear_unlocked(QUEUE_FLAG_PREEMPT_ONLY, q);
> +	blk_mq_unfreeze_queue(q);
> +}
> +EXPORT_SYMBOL(blk_set_preempt_only);

What do you need the queue freeze for?

> +		/*
> +		 * preempt_only flag has to be set after queue is frozen,
> +		 * so it can be checked here lockless and safely
> +		 */
> +		if (blk_queue_preempt_only(q)) {

We can always check a single bit flag safely, so I really don't
understand that comment.

> +			if (!(flags & BLK_REQ_PREEMPT))
> +				goto slow_path;
> +		}
> +
>  		if (percpu_ref_tryget_live(&q->q_usage_counter))
>  			return 0;
> -
> + slow_path:

Also this looks a very spaghetti, why not:


	if (!blk_queue_preempt_only(q) || (flags & BLK_MQ_REQ_PREEMPT)) {
		if (percpu_ref_tryget_live(&q->q_usage_counter))
			return 0;
	}
