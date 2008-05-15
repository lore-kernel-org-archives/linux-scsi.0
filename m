From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/7] scsi_dh: Implement generic device table handling
Date: Thu, 15 May 2008 09:16:56 +0200
Message-ID: <482BE368.3070506@suse.de>
References: <20080514144310.1EDBC10B5DF@craiglockhart-ipmi.suse.de> <1210819551.21974.252.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYEOHRB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2008 03:17:01 -0400
In-Reply-To: <1210819551.21974.252.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, dm-devel <dm-devel@redhat.com>

Chandra Seetharaman wrote:
> On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
> <snip>
>=20
>> +
>> +struct scsi_dh_devinfo_list {
>> +	struct list_head node;
>> +	char vendor[9];
>> +	char model[17];
>> +	struct scsi_device_handler *handler;
>> +};
>=20
> I do not see why we should be duplicating the information that
> is already present in scsi_dh and is available here thru scsi_dh_list=
=2E
> Instead of walking thru the scsi_dh_dev_list we could walk thru
> scsi_dh_list and get the same result.
>
Indeed we can. I originally did this as it would allow us to dynamicall=
y
add and remove entries from that list, which isn't possible with the
static arrays provided by the individual device handler.
But seeing that we can now manually attach any device I guess we can
remove it.
=20
> On the other hand, if we could create a cache of the list of devices
> (vendor-product-scsi_dh triplet) that has been attached, and walk
> thru that list first before others during attach, it would help
> (as we would guess there to be multiple of the same device).
> =20
Yes, but we can achieve that very same thing by walking the scsi_dh_lis=
t.
I'll fix it up.

>> +
>> +int scsi_dh_handler_attach(struct scsi_device *sdev,
>> +			   struct scsi_device_handler *scsi_dh);
>> +int scsi_dh_handler_detach(struct scsi_device *sdev);
>=20
> Why is the prototype needed ?
>=20
> Can this be static ?
>=20
Probably a left over from earlier attempts. Will be removing them.

>>  static struct scsi_device_handler *get_device_handler(const char *n=
ame)
>>  {
>> @@ -33,7 +45,7 @@ static struct scsi_device_handler *get_device_hand=
ler(const char *name)
>>
>=20
> <snip>
>=20
>> +/*
>> + * scsi_dh_handler_attach - Attach a device handler to a device
>> + * @sdev - SCSI device the device handler should attach to
>> + * @scsi_dh - The device handler to attach
>> + */
>> +int scsi_dh_handler_attach(struct scsi_device *sdev,
>> +			   struct scsi_device_handler *scsi_dh)
>> +{
>> +	int err =3D -EBUSY;
>> +
>> +	if (sdev->scsi_dh_data)
>> +		return err;
>=20
> One of the later patch check for scsi_dh to be same as
> sdev->scsi_dh_data->scsi_dh. We can check for that here.
>=20
> One more thing: there are multiple places (in this file and
> in the hardware handlers) the same check appear. Can we just
> do it only here and remove all the others ?
>
Yes. Will do.
=20
>> +
>> +	err =3D scsi_dh->attach(sdev);
>=20
> This assumes attach is available, but there is no assertion in
> scsi_register_device_handler().  Same is the case with detach(). Eith=
er
> assert or check for the function availability here.
Ok.

>> +
>> +	return err;
>> +}
>> +
>> +/*
>> + * scsi_dh_handler_detach - Detach a device handler to a device
>> + * @sdev - SCSI device the device handler should be detached from
>> + */
>> +int scsi_dh_handler_detach(struct scsi_device *sdev)
>> +{
>> +	struct scsi_device_handler *scsi_dh;
>=20
> can avoid the variable and call detach directly ?
>> +
>> +	if (!sdev->scsi_dh_data)
>> +		return -ENODEV;
>=20
> Can't we just return 0 ?
>=20
Well, seeing that the actual detach callback is
of type 'void', we should be using the same type here.

>> +
>> +	scsi_dh =3D sdev->scsi_dh_data->scsi_dh;
>> +
>> +	scsi_dh->detach(sdev);
>> +
>> +	return 0;
>> +}
>=20
> <snip>
>=20
>>  	list_add(&scsi_dh->list, &scsi_dh_list);
>>  	spin_unlock(&list_lock);
>> +	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_a=
dd);
>> +	printk(KERN_INFO "%s: registered\n", scsi_dh->name);
>=20
> We can be more descriptive. Like "Hardware handler %s registered" or =
some such.
>=20
Ok.

>> +	ret =3D SCSI_DH_OK;
>>
>>  done:
>>  	return ret;
> <snip>
>=20
>> +	}
>>  	list_del(&scsi_dh->list);
>>  	spin_unlock(&list_lock);
>> +	printk(KERN_INFO "%s: unregistered\n", scsi_dh->name);
>=20
> Same here.
>=20
OK.

Thanks for the review. I'll post an update soon.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
