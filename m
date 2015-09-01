From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 19/23] scsi_dh_alua: Use workqueue for RTPG
Date: Tue, 1 Sep 2015 14:57:57 +0200
Message-ID: <55E5A0D5.5070402@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-20-git-send-email-hare@suse.de>
 <20150901111517.GB10589@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbbIAM6A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 08:58:00 -0400
In-Reply-To: <20150901111517.GB10589@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/01/2015 01:15 PM, Christoph Hellwig wrote:
>> +	unsigned long		expiry;
>> +	unsigned long		interval;
>> +	struct workqueue_struct *work_q;
>> +	struct delayed_work	rtpg_work;
>> +	struct delayed_work	stpg_work;
>> +	struct delayed_work	qdata_work;
>> +	spinlock_t		rtpg_lock;
>=20
> This one also protects ->flag.  I'd just call it lock, and
> introduce it at the time struct alua_port_group is introduced,
> so that we can have coherent locking from the very beginning.
>=20
Okay.

>> +struct alua_queue_data {
>> +	struct list_head	entry;
>>  	activate_complete	callback_fn;
>>  	void			*callback_data;
>=20
> I've been looking over the active callback for a while, and I
> think the model of it is fundamentally broken.  Yes, as long as
> multipathing isn't in SCSI we'll need path change notifications
> for dm-mpath, but I don't see how tying them into ->activate
> makes any sense.
>=20
> I guess for this series we're stuck with it, but in the long
> run we should have a callback in the request_queue which the
> consumer that has bd_claim()ed the device can set and get path
> change notifications instead.
>=20
That is what I'm eventually planning to do.
My final goal is to move the multipath path monitoring stuff
into the kernel (via the block device polling mechanism), and sending
block events for path failure and re-establishment.

But that'll be subject to further patches :-)

> That being said after spending a lot of time reading this code I thin=
k
> my orginal advice to use different work_structs for the different
> kinds of events was wrong, and I'd like to apologize for making you
> go down that direction.
>=20
> STPG/RTPG is just too dependent to sensibly split them up, and the
> qdata bit while broken can be shoe horned in for now.  So I'd suggest
> to revert back to the original model with a single work_struct per
> port group, and a global workqueue.
>=20
Weelll ... there was a reason why I did that initially :-)
But anyway, no harm done. I still have the original series around.

>> -	if (h->pg)
>> +	if (h->pg) {
>> +		synchronize_rcu();
>>  		return SCSI_DH_OK;
>> +	}
>=20
> What is this synchronize_rcu supposed to help with?
>=20
>> -		h->pg =3D tmp_pg;
>>  		kref_get(&tmp_pg->kref);
>> +		spin_lock(&h->pg_lock);
>> +		rcu_assign_pointer(h->pg, tmp_pg);
>> +		spin_unlock(&h->pg_lock);
>=20
> I think the assignment to h->ph should have been past the kref_get
> from the very beginning, please fold this into the original patch.
>=20
Okay.

>> +	struct alua_port_group *pg =3D NULL;
>> +	int error;
>> +
>> +	mutex_lock(&h->init_mutex);
>> +	error =3D alua_check_tpgs(sdev, h);
>> +	if (error =3D=3D SCSI_DH_OK) {
>> +		error =3D alua_check_vpd(sdev, h);
>> +		rcu_read_lock();
>> +		pg =3D rcu_dereference(h->pg);
>> +		if (!pg) {
>> +			rcu_read_unlock();
>> +			h->tpgs =3D TPGS_MODE_NONE;
>> +			error =3D SCSI_DH_DEV_UNSUPP;
>> +		} else {
>> +			WARN_ON(error !=3D SCSI_DH_OK);
>> +			kref_get(&pg->kref);
>> +			rcu_read_unlock();
>> +		}
>> +	}
>=20
> Eww. Please grab the reference to the pg inside the replacement for
> alua_check_vpd, and ensure that we never return from that without a
> valid h->pg.  Together with the previously suggested removal of h->tp=
gs,
> and moving the call to alua_rtpg_queue into the alua_check_vpd replac=
ement
> that would keep alua_initialize nice and simple.
>=20
You are right in that the interface for alua_check_tpgs isn't very
clear. Currently we need to check both the return code _and_ 'h->pg',
even though both are interrelated.
I guess it should rather be 'h->pg =3D alua_check_vpd()' or even making
alua_check_vpd() a void function, which would eliminate the need for th=
e
separate return value.
I'll have to think about it.

>> @@ -679,6 +895,10 @@ static int alua_set_params(struct scsi_device *=
sdev, const char *params)
>>  	unsigned int optimize =3D 0, argc;
>>  	const char *p =3D params;
>>  	int result =3D SCSI_DH_OK;
>> +	unsigned long flags;
>> +
>> +	if (!h)
>> +		return -ENXIO;
>=20
> How could that happen?  Why does it beling into this patch?
>=20
Leftover from the original patch, which didn't have your scsi_dh
patchset. I'll remove it.

>> @@ -723,24 +944,46 @@ static int alua_activate(struct scsi_device *s=
dev,
>>  {
>>  	struct alua_dh_data *h =3D sdev->handler_data;
>>  	int err =3D SCSI_DH_OK;
>> +	struct alua_queue_data *qdata;
>> +	struct alua_port_group *pg;
>> =20
>> -	if (!h->pg)
>> +	if (!h) {
>> +		err =3D SCSI_DH_NOSYS;
>>  		goto out;
>> +	}
>=20
> Same here.
>=20
>> +	qdata =3D kzalloc(sizeof(*qdata), GFP_KERNEL);
>> +	if (!qdata) {
>> +		err =3D SCSI_DH_RES_TEMP_UNAVAIL;
>> +		goto out;
>> +	}
>> +	qdata->callback_fn =3D fn;
>> +	qdata->callback_data =3D data;
>> =20
>> +	mutex_lock(&h->init_mutex);
>> +	rcu_read_lock();
>> +	pg =3D rcu_dereference(h->pg);
>> +	if (!pg) {
>> +		rcu_read_unlock();
>> +		kfree(qdata);
>> +		err =3D h->init_error;
>> +		mutex_unlock(&h->init_mutex);
>>  		goto out;
>>  	}
>> +	mutex_unlock(&h->init_mutex);
>> +	fn =3D NULL;
>> +	kref_get(&pg->kref);
>> +	rcu_read_unlock();
>> +
>> +	if (optimize_stpg) {
>> +		unsigned long flags;
>> +
>> +		spin_lock_irqsave(&pg->rtpg_lock, flags);
>> +		pg->flags |=3D ALUA_OPTIMIZE_STPG;
>> +		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
>> +	}
>=20
> The optimize_stpg should have been moved towards the alua_port_group
> allocation earlier in the series, please fold that in there.
>=20
Okay.

>> +	alua_rtpg_queue(pg, sdev, qdata);
>> +	kref_put(&pg->kref, release_port_group);
>=20
> Note that all alua_rtpg_queue callers already have a reference to the
> PG, so I don't think we need to grab another one inside it or even
> check for a NULL pg.
>=20
In general I try to follow the rule of getting an initial reference, an=
d
another one whenever the port_group structure is put on the workqueue.
But I'll check here if the additional reference is warranted.

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
