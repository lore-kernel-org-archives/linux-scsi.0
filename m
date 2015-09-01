From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/23] scsi_dh_alua: Use separate alua_port_group
	structure
Date: Tue, 1 Sep 2015 12:48:27 +0200
Message-ID: <20150901104827.GA10589@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34734 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbbIAKs3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 06:48:29 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

Ok, coming back to this path as it's the start of somethign building
up over various patches:

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
> +
> +	return SCSI_DH_OK;

All this code isn't really checking the VPD anymore.  Please keep
the existing alua_check_vpd as a low-level helper, and move this
new functionality into a separate alua_find_get_pg function that
calls the original alua_check_vpd.  Also please return the
pg from it so that we c

> @@ -596,13 +643,12 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
>  		goto out;
>  
>  	err = alua_check_vpd(sdev, h);
> -	if (err != SCSI_DH_OK)
> -		goto out;
> -
> -	err = alua_rtpg(sdev, h, 0);
> -	if (err != SCSI_DH_OK)
> +	if (err != SCSI_DH_OK || !h->pg)
>  		goto out;

How could we end up here without h->pg? Either way that should
move into a conditional together with the kref_get which should
become the not_zero variant if it is kept.
