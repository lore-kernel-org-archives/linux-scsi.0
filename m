From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/20] scsi_dh_alua: Use separate alua_port_group
	structure
Date: Wed, 30 Dec 2015 12:17:51 +0100
Message-ID: <20151230111751.GA14156@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49179 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbbL3LRw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2015 06:17:52 -0500
Content-Disposition: inline
In-Reply-To: <1449560260-53407-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

> +struct alua_dh_data {
> +	struct alua_port_group	*pg;
> +	int			group_id;

Keeping the group id here seem odd.  It gets cleaned up later
in the series, so this is just a nitpick.

> -static int realloc_buffer(struct alua_dh_data *h, unsigned len)
> +static int realloc_buffer(struct alua_port_group *pg, unsigned len)
>  {
> -	if (h->buff && h->buff != h->inq)
> -		kfree(h->buff);
> +	if (pg->buff && pg->buff != pg->inq)
> +		kfree(pg->buff);
>  
> -	h->buff = kmalloc(len, GFP_NOIO);
> -	if (!h->buff) {
> -		h->buff = h->inq;
> -		h->bufflen = ALUA_INQUIRY_SIZE;
> +	pg->buff = kmalloc(len, GFP_NOIO);
> +	if (!pg->buff) {
> +		pg->buff = pg->inq;
> +		pg->bufflen = ALUA_INQUIRY_SIZE;
>  		return 1;
>  	}
> -	h->bufflen = len;
> +	pg->bufflen = len;
>  	return 0;
>  }

All this disappears in the next patch, wouldn't it have been smarted
to move the next one before this one?

>  /*
> + * alua_get_pg - Allocate a new port_group structure
> + * @sdev: scsi device
> + * @h: alua device_handler data
> + * @group_id: port group id
> + *
> + * Allocate a new port_group structure for a given
> + * device.
> + */
> +struct alua_port_group *alua_get_pg(struct scsi_device *sdev,
> +				    int group_id, int tpgs)

Can you call this alua_alloc_pg, please?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
