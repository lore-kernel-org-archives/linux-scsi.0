From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv4 13/23] scsi_dh_alua: Use workqueue for RTPG
Date: Tue, 2 Feb 2016 01:32:09 -0800
Message-ID: <20160202093209.GA1357@infradead.org>
References: <1453191727-3626-1-git-send-email-hare@suse.de>
 <1453191727-3626-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbcBBJcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2016 04:32:15 -0500
Content-Disposition: inline
In-Reply-To: <1453191727-3626-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

>  static void release_port_group(struct kref *kref)
>  {
>  	struct alua_port_group *pg;
>  
> +	synchronize_rcu();
>  	pg = container_of(kref, struct alua_port_group, kref);
> +	if (pg->rtpg_sdev)
> +		flush_delayed_work(&pg->rtpg_work);
>  	spin_lock(&port_group_lock);
>  	list_del(&pg->node);
>  	spin_unlock(&port_group_lock);

I don't think this is correct - we need a grace period after the
list_del to prevent new lookups.  I suspect the right thing to do here
is to simply use kfree_rcu for the pg.  This also avoids waiting for
whole grace periods for each deleted port_group, which might be rather
expensive.

> +	/* Check for existing port group references */
> +	spin_lock(&h->pg_lock);
> +	if (h->pg) {
> +		old_pg = pg;
> +		if (h->pg != pg) {
> +			/* port group has changed. Update to new port group */
> +			old_pg = h->pg;
> +			rcu_assign_pointer(h->pg, pg);
> +		}
> +	} else {
> +		rcu_assign_pointer(h->pg, pg);
> +	}

This looks confusing - pg is the structure we just allocated, so why
do we assign it to old_pg?  It seems like the above could be written
similar and more clear as:


	olg_pg = h->pg;
	if (pg != old_pg)
		rcu_assign_pointer(h->pg, pg);

> +	if (!sdev) {
> +		WARN_ON(pg->flags & ALUA_PG_RUN_RTPG ||
> +			pg->flags & ALUA_PG_RUN_STPG);

Please use two separate WARN_ONs here to know which one triggered from
the line in the kernel log.
