From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/43] hpsa: add masked physical devices into h->dev[]
 array
Date: Mon, 23 Feb 2015 12:14:42 -0800
Message-ID: <20150223201442.GA11037@infradead.org>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221221735.21954.24837.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbbBWUOn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2015 15:14:43 -0500
Content-Disposition: inline
In-Reply-To: <20150221221735.21954.24837.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

> -/* link sdev->hostdata to our per-device structure. */
>  static int hpsa_slave_alloc(struct scsi_device *sdev)
>  {
>  	struct hpsa_scsi_dev_t *sd;
>  	unsigned long flags;
>  	struct ctlr_info *h;
> +	int queue_depth;
>  
>  	h = sdev_to_hba(sdev);
>  	spin_lock_irqsave(&h->devlock, flags);
>  	sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
>  		sdev_id(sdev), sdev->lun);
> -	if (sd != NULL) {
> -		sdev->hostdata = sd;
> -		if (sd->queue_depth)
> +
> +	if (likely(sd)) {
>  			scsi_change_queue_depth(sdev, sd->queue_depth);

Looks like the indentation is incorrect here.

>  		atomic_set(&sd->ioaccel_cmds_out, 0);
> +		sdev->hostdata = (sd->expose_state & HPSA_SCSI_ADD) ? sd : NULL;
> +		queue_depth = sd->queue_depth != 0 ?
> +			sd->queue_depth : sdev->host->can_queue;
> +	} else {
> +		sdev->hostdata = NULL;
> +		queue_depth = sdev->host->can_queue;
>  	}
> +
> +	if (shost_use_blk_mq(sdev->host))
> +		scsi_change_queue_depth(sdev, queue_depth);

But why do you have another call here only for the mq case?
Also in general I'd really prefer if you'd only change the queue
depth in ->slave_configure as most drivers do unless you have a good
reason to do it differently.

> +	else /* We depend on tags for cmd allocation. */
> +		sdev->tagged_supported = 1;

Since 3.19-rc1 you'll always get tags from the first command sent, as
we now moved the block tagging configuration earlier.

> +/* configure scsi device based on internal per-device structure */
> +static int hpsa_slave_configure(struct scsi_device *sdev)
> +{
> +	struct hpsa_scsi_dev_t *sd;
> +	unsigned long flags;
> +	struct ctlr_info *h;
> +
> +	h = sdev_to_hba(sdev);
> +	spin_lock_irqsave(&h->devlock, flags);
> +	sd = sdev->hostdata;

There should be no need to have this dereference inside the spinlock.

Also can you explain somewhere why some devices might not have this
hostdata set?
