From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/23] scsi_dh_alua: Use separate alua_port_group
	structure
Date: Tue, 1 Sep 2015 12:20:55 +0200
Message-ID: <20150901102055.GC9838@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34622 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbbIAKU5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 06:20:57 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

> +struct alua_dh_data {
> +	struct alua_port_group	*pg;
> +	int			rel_port;
> +	int			tpgs;

The tpgs file doesn't make much sense in the new alua_dh_data
structure.  Please return it explicitly from alua_check_tpgs and
assign it directly to the member in struct alua_port_group.

> +static void release_port_group(struct kref *kref)
> +{
> +	struct alua_port_group *pg;
> +
> +	pg = container_of(kref, struct alua_port_group, kref);
> +	printk(KERN_WARNING "alua: release port group %d\n", pg->group_id);

Why is this a warning?  I'd consider it nothing but debug noise.

> -	err = alua_rtpg(sdev, h, 0);
> -	if (err != SCSI_DH_OK)
> +	if (err != SCSI_DH_OK || !h->pg)
>  		goto out;
>  
> +	kref_get(&h->pg->kref);

What prevents this kref_get from racing with the last kref_put?

I think all the kref_get calls in this patch need to be
kref_get_unless_zero with proper error handling.

> +	rcu_read_lock();
> +	pg = rcu_dereference(h->pg);
> +	if (!pg) {
> +		rcu_read_unlock();
> +		return -ENXIO;
> +	}

What is this rcu_read_lock supposed to protect against given
that struct alua_port_group isn't RCU freed?  I think this needs
to be another kref_get_unless_zero.

> +
>  	if (optimize)
> -		h->flags |= ALUA_OPTIMIZE_STPG;
> +		pg->flags |= ALUA_OPTIMIZE_STPG;
>  	else
> -		h->flags &= ~ALUA_OPTIMIZE_STPG;
> +		pg->flags |= ~ALUA_OPTIMIZE_STPG;
> +	rcu_read_unlock();

The read-modify-write of pg->flags will need some sort of locking.
Seems like most modifications of it are under pg->rtpg_lock, so
I'd suggest to enforce that as a strict rule.

> +	err = alua_rtpg(sdev, h->pg, 1);
> +	if (err != SCSI_DH_OK) {
> +		kref_put(&h->pg->kref, release_port_group);
> +		goto out;

		goto out_put_pg;


out_put_pg:
> +	kref_put(&h->pg->kref, release_port_group);
>  out:
>  	if (fn)
>  		fn(data, err);
