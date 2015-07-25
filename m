From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/20] scsi_dh_alua: Use separate alua_port_group structure
Date: Sat, 25 Jul 2015 17:52:43 +0200
Message-ID: <55B3B0CB.4040903@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-12-git-send-email-hare@suse.de> <20150724145811.GA29296@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbbGYPwr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2015 11:52:47 -0400
In-Reply-To: <20150724145811.GA29296@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

On 07/24/2015 04:58 PM, Christoph Hellwig wrote:
> On Wed, Jul 08, 2015 at 11:06:09AM +0200, Hannes Reinecke wrote:
>> +	pg =3D kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
>> +	if (!pg) {
>> +		sdev_printk(KERN_WARNING, sdev,
>> +			    "%s: kzalloc port group failed\n",
>> +			    ALUA_DH_NAME);
>> +		/* Temporary failure, bypass */
>> +		return SCSI_DH_DEV_TEMP_BUSY;
>> +	}
>> +	pg->group_id =3D group_id;
>> +	pg->buff =3D pg->inq;
>> +	pg->bufflen =3D ALUA_INQUIRY_SIZE;
>> +	pg->tpgs =3D h->tpgs;
>> +	pg->state =3D TPGS_STATE_OPTIMIZED;
>> +	kref_init(&pg->kref);
>> +	spin_lock(&port_group_lock);
>> +	list_add(&pg->node, &port_group_list);
>> +	h->pg =3D pg;
>> +	spin_unlock(&port_group_lock);
>=20
> Is there any high level protection against someone racing to allocate
> this structure, e.g. from a sysfs-initiated scan?
>=20
Not in this patch, as this is called during device scan only. It is
assumed that higher levels will protect against simultaneous scans.

Real protection against concurrent updates is done in patch
'scsi_dh_alua: parse device id', as with that we can easily hit existin=
g
port groups.

>> -	len =3D (h->buff[0] << 24) + (h->buff[1] << 16) +
>> -		(h->buff[2] << 8) + h->buff[3] + 4;
>> +	len =3D get_unaligned_be32(&pg->buff[0]) + 4;
>=20
> Andother spurious get/set_unaligned conversion.  I'd really recommend=
 doing
> all of them before the atual series.
>=20
Okay, will be doing so.

>> +	rcu_read_lock();
>> +	pg =3D rcu_dereference(h->pg);
>> +	if (!pg) {
>> +		rcu_read_unlock();
>> +		return -ENXIO;
>> +	}
>> +	rcu_read_unlock();
>> +
>>  	if (optimize)
>> -		h->flags |=3D ALUA_OPTIMIZE_STPG;
>> +		pg->flags |=3D ALUA_OPTIMIZE_STPG;
>>  	else
>> -		h->flags &=3D ~ALUA_OPTIMIZE_STPG;
>> +		pg->flags |=3D ~ALUA_OPTIMIZE_STPG;
>=20
> You'll need to move the rcu_read_unlock here to be safe.
>=20
Ok.

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
