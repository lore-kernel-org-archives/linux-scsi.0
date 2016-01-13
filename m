From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 13/22] scsi_dh_alua: Use workqueue for RTPG
Date: Wed, 13 Jan 2016 08:02:02 +0100
Message-ID: <5695F66A.9040709@suse.de>
References: <1452613258-94084-1-git-send-email-hare@suse.de>
 <1452613258-94084-14-git-send-email-hare@suse.de>
 <20160112171404.GE23947@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbcAMHCF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 02:02:05 -0500
In-Reply-To: <20160112171404.GE23947@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 01/12/2016 06:14 PM, Christoph Hellwig wrote:
>> -		kref_get(&pg->kref);
>> +		if (!kref_get_unless_zero(&pg->kref))
>> +			continue;
>
> As pointed out earlier this should be done from the start.
>
Yep.

>> +	/* Check for existing port_group references */
>> +	spin_lock(&h->pg_lock);
>> +	if (h->pg) {
>> +		old_pg =3D pg;
>> +		/* port_group has changed. Update to new port group */
>> +		if (h->pg !=3D pg) {
>> +			old_pg =3D h->pg;
>> +			rcu_assign_pointer(h->pg, pg);
>> +			pg_updated =3D true;
>> +		}
>> +	} else {
>> +		rcu_assign_pointer(h->pg, pg);
>> +		pg_updated =3D true;
>> +	}
>> +	alua_rtpg_queue(h->pg, sdev, NULL);
>> +	spin_unlock(&h->pg_lock);
>> +
>> +	if (pg_updated)
>> +		synchronize_rcu();
>> +	if (old_pg) {
>> +		if (old_pg->rtpg_sdev)
>> +			flush_delayed_work(&old_pg->rtpg_work);
>> +		kref_put(&old_pg->kref, release_port_group);
>> +	}
>
> The synchronize_rcu() needs to be done in release_port_group, or even
> better be replaced by doing a kfree_rcu there instead of a kfree.
>
Point is that we don't necessarily have an old_pg to call=20
release_port_group() on, but we still need to call synchronize_rcu()
to inform everyong that h->pg now has a new value.
So while I could do that it would end with a mess of if-clauses here.

> And unless I'm mistaken the flush_delayed_work should probably be
> done in release_port_group as well.
>
_Actually_ we only need to call flush_delayed_work if sdev =3D=3D=20
rtgp_sdev. Otherwise the workqueue item is running off a different=20
device and won't be affected.

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
