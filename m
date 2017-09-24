From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V4 10/16] block: mq-deadline: Add zoned block device
        data
Date: Sun, 24 Sep 2017 17:14:52 +0200
Message-ID: <20170924151452.GG14806@lst.de>
References: <20170924070247.25560-1-damien.lemoal@wdc.com> <20170924070247.25560-11-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170924070247.25560-11-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

> +
> +	struct request_queue *q;

Do you really need the queue backpointer?  At least as far as this
patch is concerned we could just pass the queue on to
deadline_enable_zones_wlock and be fine.  And in general we should
always passing the q, as we can trivial go from queue to deadline_data
using queue->elevator->elevator_data.

> +static int deadline_zoned_init_queue(struct request_queue *q,
> +				     struct deadline_data *dd)
> +{
> +	if (!blk_queue_is_zoned(q) ||
> +	    !blk_queue_nr_zones(q)) {

Shouldn't !blk_queue_nr_zones(q) be enough?  If not both conditionals
could easily fit into the same line, and I'd be tempted to move them
to the caller and call deadline_enable_zones_wlock straight from there.

> @@ -341,6 +387,15 @@ static int dd_init_queue(struct request_queue *q, struct elevator_type *e)
>  	spin_lock_init(&dd->lock);
>  	INIT_LIST_HEAD(&dd->dispatch);
>  
> +	dd->q = q;
> +	spin_lock_init(&dd->zone_lock);
> +	ret = deadline_zoned_init_queue(q, dd);
> +	if (ret) {
> +		kfree(dd);
> +		kobject_put(&eq->kobj);
> +		return ret;
> +	}
> +
>  	q->elevator = eq;
>  	return 0;

This should probably grow goto based unwinding, e.g.

	int ret = -ENOMEM;

	...

	dd = kzalloc_node(sizeof(*dd), GFP_KERNEL, q->node);
	if (!dd)
		goto out_put_object;

	...

	if (blk_queue_nr_zones(q))) {
		ret = deadline_enable_zones_wlock(...);
		if (ret)
			goto out_free_dd;
	}
	
  	q->elevator = eq;
  	return 0;

out_free_dd:
	kfree(dd);
out_put_object
	kobject_put(&eq->kobj);
	return ret;
	
