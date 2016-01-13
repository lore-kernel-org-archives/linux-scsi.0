From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 13/22] scsi_dh_alua: Use workqueue for RTPG
Date: Wed, 13 Jan 2016 11:27:23 +0100
Message-ID: <5696268B.2090502@suse.de>
References: <1452613258-94084-1-git-send-email-hare@suse.de>
 <1452613258-94084-14-git-send-email-hare@suse.de>
 <20160112171404.GE23947@lst.de> <5695F66A.9040709@suse.de>
 <20160113100425.GA15163@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbcAMK1Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 05:27:25 -0500
In-Reply-To: <20160113100425.GA15163@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 01/13/2016 11:04 AM, Christoph Hellwig wrote:
> On Wed, Jan 13, 2016 at 08:02:02AM +0100, Hannes Reinecke wrote:
>>>> +	/* Check for existing port_group references */
>>>> +	spin_lock(&h->pg_lock);
>>>> +	if (h->pg) {
>>>> +		old_pg =3D pg;
>>>> +		/* port_group has changed. Update to new port group */
>>>> +		if (h->pg !=3D pg) {
>>>> +			old_pg =3D h->pg;
>>>> +			rcu_assign_pointer(h->pg, pg);
>>>> +			pg_updated =3D true;
>>>> +		}
>>>> +	} else {
>>>> +		rcu_assign_pointer(h->pg, pg);
>>>> +		pg_updated =3D true;
>>>> +	}
>>>> +	alua_rtpg_queue(h->pg, sdev, NULL);
>>>> +	spin_unlock(&h->pg_lock);
>>>> +
>>>> +	if (pg_updated)
>>>> +		synchronize_rcu();
>>>> +	if (old_pg) {
>>>> +		if (old_pg->rtpg_sdev)
>>>> +			flush_delayed_work(&old_pg->rtpg_work);
>>>> +		kref_put(&old_pg->kref, release_port_group);
>>>> +	}
>>>
>>> The synchronize_rcu() needs to be done in release_port_group, or ev=
en
>>> better be replaced by doing a kfree_rcu there instead of a kfree.
>>>
>> Point is that we don't necessarily have an old_pg to call
>> release_port_group() on, but we still need to call synchronize_rcu()
>> to inform everyong that h->pg now has a new value.
>
> No, you don't.  synchronize_rcu() just waits for all previously
> started RCU grace periods to finish.  If old_pg doesn't get freed
> you don't need to wait for the grace period.  synchronize_rcu does
> not notify anyone about anything, it just waits.
>
Ah. Right. Good point. Of course we don't need to call it if there's=20
nothing to be freed.

Will be folding it into the next round of patches, or just resending=20
this one if the remaining patches meets with approval.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
