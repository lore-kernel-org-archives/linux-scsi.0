From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 17/23] scsi_dh_alua: use unique device id
Date: Mon, 28 Sep 2015 09:41:21 +0200
Message-ID: <5608EF21.7060909@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>	 <1440679281-13234-18-git-send-email-hare@suse.de> <1442950307.4132.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbbI1HlY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Sep 2015 03:41:24 -0400
In-Reply-To: <1442950307.4132.53.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/22/2015 09:31 PM, Ewan Milne wrote:
> On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
>> Use scsi_vpd_lun_id() to assign a unique device identification
>> to the alua port group structure.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 70 +++++++++++++++++++=
++++++++---
>>  1 file changed, 65 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index dbe9ff2..c2b2100b 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -70,6 +70,8 @@ static DEFINE_SPINLOCK(port_group_lock);
>>  struct alua_port_group {
>>  	struct kref		kref;
>>  	struct list_head	node;
>> +	unsigned char		device_id_str[256];
>> +	int			device_id_size;
>=20
> I prefer _len instead of _size, _size should refer to the size of the=
 buffer,
> not the current length of the data in it.
>=20
>>  	int			group_id;
>>  	int			tpgs;
>>  	int			state;
>> @@ -229,7 +231,9 @@ static int alua_check_vpd(struct scsi_device *sd=
ev, struct alua_dh_data *h)
>>  {
>>  	unsigned char *d;
>>  	int group_id =3D -1;
>> -	struct alua_port_group *pg =3D NULL;
>> +	char device_id_str[256];
>> +	int device_id_size;
>> +	struct alua_port_group *tmp_pg, *pg =3D NULL;
>> =20
>>  	if (!sdev->vpd_pg83)
>>  		return SCSI_DH_DEV_UNSUPP;
>> @@ -266,9 +270,39 @@ static int alua_check_vpd(struct scsi_device *s=
dev, struct alua_dh_data *h)
>>  		h->tpgs =3D TPGS_MODE_NONE;
>>  		return SCSI_DH_DEV_UNSUPP;
>>  	}
>> +	device_id_size =3D scsi_vpd_lun_id(sdev, device_id_str, 256);
>=20
> should be sizeof(device_id_str) not hardcoded 256
>=20
Okay.
>> +	if (device_id_size <=3D 0) {
>> +		/*
>> +		 * Internal error: TPGS supported by no
>=20
> "Internal error: TPGS supported by no"  should be "but no"
>=20
=46ixed now.

>> +		 * device identifcation found.
>> +		 * Disable ALUA support.
>> +		 */
>> +		sdev_printk(KERN_INFO, sdev,
>> +			    "%s: No device descriptors found\n",
>> +			    ALUA_DH_NAME);
>> +		h->tpgs =3D TPGS_MODE_NONE;
>> +		return SCSI_DH_DEV_UNSUPP;
>> +	}
>>  	sdev_printk(KERN_INFO, sdev,
>> -		    "%s: port group %02x rel port %02x\n",
>> -		    ALUA_DH_NAME, group_id, h->rel_port);
>> +		    "%s: device %s port group %02x "
>> +		    "rel port %02x\n", ALUA_DH_NAME,
>> +		    device_id_str, group_id, h->rel_port);
>> +	spin_lock(&port_group_lock);
>> +	list_for_each_entry(tmp_pg, &port_group_list, node) {
>> +		if (tmp_pg->group_id !=3D group_id)
>> +			continue;
>> +		if (tmp_pg->device_id_size !=3D device_id_size)
>> +			continue;
>> +		if (strncmp(tmp_pg->device_id_str, device_id_str,
>> +			    device_id_size))
>> +			continue;
>> +		h->pg =3D tmp_pg;
>> +		kref_get(&tmp_pg->kref);
>> +		break;
>> +	}
>> +	spin_unlock(&port_group_lock);
>> +	if (h->pg)
>> +		return SCSI_DH_OK;
>=20
> The lookup checks whether h->pg =3D=3D NULL but the function never
> explicitly sets it to NULL before iterating.
>=20
=46or my next iteration I've reworked this so that h->pg is explicitly
set.

>> =20
>>  	pg =3D kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
>>  	if (!pg) {
>> @@ -278,13 +312,39 @@ static int alua_check_vpd(struct scsi_device *=
sdev, struct alua_dh_data *h)
>>  		/* Temporary failure, bypass */
>>  		return SCSI_DH_DEV_TEMP_BUSY;
>>  	}
>> +	if (device_id_size)
>> +		strncpy(pg->device_id_str, device_id_str, 256);
>=20
> should be sizeof(device_id_str) not hardcoded 256
>=20
Okay.

>> +	else
>> +		pg->device_id_str[0] =3D '\0';
>> +
>> +	pg->device_id_size =3D device_id_size;
>>  	pg->group_id =3D group_id;
>>  	pg->tpgs =3D h->tpgs;
>>  	pg->state =3D TPGS_STATE_OPTIMIZED;
>>  	kref_init(&pg->kref);
>>  	spin_lock(&port_group_lock);
>> -	list_add(&pg->node, &port_group_list);
>> -	h->pg =3D pg;
>> +	/*
>> +	 * Re-check list again to catch
>> +	 * concurrent updates
>> +	 */
>> +	list_for_each_entry(tmp_pg, &port_group_list, node) {
>> +		if (tmp_pg->group_id !=3D pg->group_id)
>> +			continue;
>> +		if (tmp_pg->device_id_size !=3D pg->device_id_size)
>> +			continue;
>> +		if (strncmp(tmp_pg->device_id_str, pg->device_id_str,
>> +			    device_id_size))
>> +			continue;
>> +		h->pg =3D tmp_pg;
>> +		kref_get(&tmp_pg->kref);
>> +		kfree(pg);
>=20
> With the added check for an existing alua_port_group object, and the =
kfree() of
> the alua_port_group that had been allocated if an existing one is fou=
nd, the code does not
> do a destroy_workqueue() on pg->work_q. =20
>=20
With the current rework I've removed the per-pg workqueues, so that
issue doesn't occur anymore.

>> +		pg =3D NULL;
>> +		break;
>> +	}
>> +	if (pg) {
>> +		list_add(&pg->node, &port_group_list);
>> +		h->pg =3D pg;
>> +	}
>>  	spin_unlock(&port_group_lock);
>> =20
>>  	return SCSI_DH_OK;
> =20
> An explanation in the comments about the ALUA topology and what the d=
evice_id vs.
> the group_id represents might be helpful.  It occurred to me that if =
someone doesn't
> understand that you can have the same device_id behind different port=
 groups they
> won't understand this code.
>=20
> HOST  ---->     STORAGE CTRL PG 1   ---->    LUN X
>       ---->                         ---->    LUN X
>       ---->     STORAGE CTRL PG 2   ---->    LUN X
>       ---->                         ---->    LUN X
>=20
Hmm. Someone willing to understand this code should be reasonable
familiar with SPC, so I doubt that'll be an issue.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
