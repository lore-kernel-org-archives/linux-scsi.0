From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/23] scsi_dh_alua: Use separate alua_port_group
 structure
Date: Tue, 1 Sep 2015 15:02:29 +0200
Message-ID: <55E5A1E5.8000701@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-14-git-send-email-hare@suse.de>
 <20150901102055.GC9838@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbbIANCb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 09:02:31 -0400
In-Reply-To: <20150901102055.GC9838@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/01/2015 12:20 PM, Christoph Hellwig wrote:
>> +struct alua_dh_data {
>> +	struct alua_port_group	*pg;
>> +	int			rel_port;
>> +	int			tpgs;
>=20
> The tpgs file doesn't make much sense in the new alua_dh_data
> structure.  Please return it explicitly from alua_check_tpgs and
> assign it directly to the member in struct alua_port_group.
>=20
Okay.

>> +static void release_port_group(struct kref *kref)
>> +{
>> +	struct alua_port_group *pg;
>> +
>> +	pg =3D container_of(kref, struct alua_port_group, kref);
>> +	printk(KERN_WARNING "alua: release port group %d\n", pg->group_id)=
;
>=20
> Why is this a warning?  I'd consider it nothing but debug noise.
>=20
Yes, indeed it is. I'll be removing it.

>> -	err =3D alua_rtpg(sdev, h, 0);
>> -	if (err !=3D SCSI_DH_OK)
>> +	if (err !=3D SCSI_DH_OK || !h->pg)
>>  		goto out;
>> =20
>> +	kref_get(&h->pg->kref);
>=20
> What prevents this kref_get from racing with the last kref_put?
>=20
> I think all the kref_get calls in this patch need to be
> kref_get_unless_zero with proper error handling.
>=20
Okay.

>> +	rcu_read_lock();
>> +	pg =3D rcu_dereference(h->pg);
>> +	if (!pg) {
>> +		rcu_read_unlock();
>> +		return -ENXIO;
>> +	}
>=20
> What is this rcu_read_lock supposed to protect against given
> that struct alua_port_group isn't RCU freed?  I think this needs
> to be another kref_get_unless_zero.
>=20
It's not freed now, but it'll be with one of the next patches (ie with
the 'rescan' patch).
I just kept it here for consistency, following the rule to always
enclose 'rcu_dereference' with 'rcu_read_lock()/rcu_read_unlock()'
pairs. Irrespective on whether it's being freed or not.

>> +
>>  	if (optimize)
>> -		h->flags |=3D ALUA_OPTIMIZE_STPG;
>> +		pg->flags |=3D ALUA_OPTIMIZE_STPG;
>>  	else
>> -		h->flags &=3D ~ALUA_OPTIMIZE_STPG;
>> +		pg->flags |=3D ~ALUA_OPTIMIZE_STPG;
>> +	rcu_read_unlock();
>=20
> The read-modify-write of pg->flags will need some sort of locking.
> Seems like most modifications of it are under pg->rtpg_lock, so
> I'd suggest to enforce that as a strict rule.
>=20
Yes, of course the 'rtpg_lock' should have been taken here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
