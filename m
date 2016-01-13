From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 13/22] scsi_dh_alua: Use workqueue for RTPG
Date: Wed, 13 Jan 2016 11:04:25 +0100
Message-ID: <20160113100425.GA15163@lst.de>
References: <1452613258-94084-1-git-send-email-hare@suse.de> <1452613258-94084-14-git-send-email-hare@suse.de> <20160112171404.GE23947@lst.de> <5695F66A.9040709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41976 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbcAMKE1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 05:04:27 -0500
Content-Disposition: inline
In-Reply-To: <5695F66A.9040709@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Jan 13, 2016 at 08:02:02AM +0100, Hannes Reinecke wrote:
>>> +	/* Check for existing port_group references */
>>> +	spin_lock(&h->pg_lock);
>>> +	if (h->pg) {
>>> +		old_pg = pg;
>>> +		/* port_group has changed. Update to new port group */
>>> +		if (h->pg != pg) {
>>> +			old_pg = h->pg;
>>> +			rcu_assign_pointer(h->pg, pg);
>>> +			pg_updated = true;
>>> +		}
>>> +	} else {
>>> +		rcu_assign_pointer(h->pg, pg);
>>> +		pg_updated = true;
>>> +	}
>>> +	alua_rtpg_queue(h->pg, sdev, NULL);
>>> +	spin_unlock(&h->pg_lock);
>>> +
>>> +	if (pg_updated)
>>> +		synchronize_rcu();
>>> +	if (old_pg) {
>>> +		if (old_pg->rtpg_sdev)
>>> +			flush_delayed_work(&old_pg->rtpg_work);
>>> +		kref_put(&old_pg->kref, release_port_group);
>>> +	}
>>
>> The synchronize_rcu() needs to be done in release_port_group, or even
>> better be replaced by doing a kfree_rcu there instead of a kfree.
>>
> Point is that we don't necessarily have an old_pg to call 
> release_port_group() on, but we still need to call synchronize_rcu()
> to inform everyong that h->pg now has a new value.

No, you don't.  synchronize_rcu() just waits for all previously
started RCU grace periods to finish.  If old_pg doesn't get freed
you don't need to wait for the grace period.  synchronize_rcu does
not notify anyone about anything, it just waits.

>> And unless I'm mistaken the flush_delayed_work should probably be
>> done in release_port_group as well.
>>
> _Actually_ we only need to call flush_delayed_work if sdev == rtgp_sdev. 
> Otherwise the workqueue item is running off a different device and won't be 
> affected.

I'm actually pretty sure I suggested that in an earlier iteratation,
but you said that's not the case.  So please only run it if
sdev == rtgp_sdev only then.
