From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/20] scsi_dh_alua: Use separate alua_port_group
	structure
Date: Fri, 24 Jul 2015 16:58:11 +0200
Message-ID: <20150724145811.GA29296@lst.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55887 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbbGXO6N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 10:58:13 -0400
Content-Disposition: inline
In-Reply-To: <1436346378-96518-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

On Wed, Jul 08, 2015 at 11:06:09AM +0200, Hannes Reinecke wrote:
> +	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
> +	if (!pg) {
> +		sdev_printk(KERN_WARNING, sdev,
> +			    "%s: kzalloc port group failed\n",
> +			    ALUA_DH_NAME);
> +		/* Temporary failure, bypass */
> +		return SCSI_DH_DEV_TEMP_BUSY;
> +	}
> +	pg->group_id = group_id;
> +	pg->buff = pg->inq;
> +	pg->bufflen = ALUA_INQUIRY_SIZE;
> +	pg->tpgs = h->tpgs;
> +	pg->state = TPGS_STATE_OPTIMIZED;
> +	kref_init(&pg->kref);
> +	spin_lock(&port_group_lock);
> +	list_add(&pg->node, &port_group_list);
> +	h->pg = pg;
> +	spin_unlock(&port_group_lock);

Is there any high level protection against someone racing to allocate
this structure, e.g. from a sysfs-initiated scan?

> -	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
> -		(h->buff[2] << 8) + h->buff[3] + 4;
> +	len = get_unaligned_be32(&pg->buff[0]) + 4;

Andother spurious get/set_unaligned conversion.  I'd really recommend doing
all of them before the atual series.

> +	rcu_read_lock();
> +	pg = rcu_dereference(h->pg);
> +	if (!pg) {
> +		rcu_read_unlock();
> +		return -ENXIO;
> +	}
> +	rcu_read_unlock();
> +
>  	if (optimize)
> -		h->flags |= ALUA_OPTIMIZE_STPG;
> +		pg->flags |= ALUA_OPTIMIZE_STPG;
>  	else
> -		h->flags &= ~ALUA_OPTIMIZE_STPG;
> +		pg->flags |= ~ALUA_OPTIMIZE_STPG;

You'll need to move the rcu_read_unlock here to be safe.

