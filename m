From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 13/22] scsi_dh_alua: Use workqueue for RTPG
Date: Tue, 12 Jan 2016 18:14:04 +0100
Message-ID: <20160112171404.GE23947@lst.de>
References: <1452613258-94084-1-git-send-email-hare@suse.de> <1452613258-94084-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39012 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbcALROF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2016 12:14:05 -0500
Content-Disposition: inline
In-Reply-To: <1452613258-94084-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

> -		kref_get(&pg->kref);
> +		if (!kref_get_unless_zero(&pg->kref))
> +			continue;

As pointed out earlier this should be done from the start.

> +	/* Check for existing port_group references */
> +	spin_lock(&h->pg_lock);
> +	if (h->pg) {
> +		old_pg = pg;
> +		/* port_group has changed. Update to new port group */
> +		if (h->pg != pg) {
> +			old_pg = h->pg;
> +			rcu_assign_pointer(h->pg, pg);
> +			pg_updated = true;
> +		}
> +	} else {
> +		rcu_assign_pointer(h->pg, pg);
> +		pg_updated = true;
> +	}
> +	alua_rtpg_queue(h->pg, sdev, NULL);
> +	spin_unlock(&h->pg_lock);
> +
> +	if (pg_updated)
> +		synchronize_rcu();
> +	if (old_pg) {
> +		if (old_pg->rtpg_sdev)
> +			flush_delayed_work(&old_pg->rtpg_work);
> +		kref_put(&old_pg->kref, release_port_group);
> +	}

The synchronize_rcu() needs to be done in release_port_group, or even
better be replaced by doing a kfree_rcu there instead of a kfree.

And unless I'm mistaken the flush_delayed_work should probably be
done in release_port_group as well.
