From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Thu, 15 May 2008 11:46:30 +0200
Message-ID: <482C0676.9070004@suse.de>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de> <1210819801.21974.266.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:50003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbYEOJqc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2008 05:46:32 -0400
In-Reply-To: <1210819801.21974.266.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>

Hi Chandra,

Chandra Seetharaman wrote:
> What is the purpose of this feature ?
>=20
> With dh_state functionality, one could associate a handler to a new
> device and then if one does "multipath", the hardware handler would b=
e
> associated with the multipath device. What are we achieving by this ?
>=20
This allows multipath to override the device tables build into
the device handler. Reason here is that multipath has a configuration
file which allows the user to override the build-in defaults.
And this includes the hardware handler, so we need to make sure that
the hardware handler is indeed attached.

I'd rather have it here instead of doing it from userland, as I try
to avoid searching through sysfs wherever possible.

> The review comments below are on the assumption that this is a needed
> feature.
> ---
>=20
> Shouldn't we provide a detach also ?
>=20
Hmm. Maybe. I'll check if it's possible to distinguish between
built-in devices (which shouldn't be detached) and overridden
ones (which should be).

> On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
>> multipath keeps a separate device table which may be
>> more current than the built-in one.
>> So we should allow to override the multipath settings
>> by calling ->attach for each device.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/md/dm-mpath.c                 |   10 ++++++
>>  drivers/scsi/device_handler/scsi_dh.c |   52 ++++++++++++++++++++++=
++++++++--
>>  include/scsi/scsi_dh.h                |    1 +
>>  3 files changed, 59 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>> index e8f704a..b69cd87 100644
>> --- a/drivers/md/dm-mpath.c
>> +++ b/drivers/md/dm-mpath.c
>> @@ -546,6 +546,7 @@ static struct pgpath *parse_path(struct arg_set =
*as, struct path_selector *ps,
>>  {
>>  	int r;
>>  	struct pgpath *p;
>> +	struct multipath *m =3D (struct multipath *) ti->private;
>>
>>  	/* we need at least a path arg */
>>  	if (as->argc < 1) {
>> @@ -564,6 +565,15 @@ static struct pgpath *parse_path(struct arg_set=
 *as, struct path_selector *ps,
>>  		goto bad;
>>  	}
>>
>> +	if (m->hw_handler_name) {
>> +		r =3D scsi_dh_attach(bdev_get_queue(p->path.dev->bdev),
>> +				   m->hw_handler_name);
>> +		if (r < 0) {
>> +			dm_put_device(ti, p->path.dev);
>> +			goto bad;
>> +		}
>> +	}
>> +
>>  	r =3D ps->type->add_path(ps, &p->path, as->argc, as->argv, &ti->er=
ror);
>>  	if (r) {
>>  		dm_put_device(ti, p->path.dev);
>> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/de=
vice_handler/scsi_dh.c
>> index 2dbf84b..dfca3db 100644
>> --- a/drivers/scsi/device_handler/scsi_dh.c
>> +++ b/drivers/scsi/device_handler/scsi_dh.c
>> @@ -113,8 +113,12 @@ int scsi_dh_handler_attach(struct scsi_device *=
sdev,
>>  {
>>  	int err =3D -EBUSY;
>>
>> -	if (sdev->scsi_dh_data)
>> -		return err;
>> +	if (sdev->scsi_dh_data) {
>> +		if (sdev->scsi_dh_data->scsi_dh !=3D scsi_dh)
>> +			return err;
>> +		else
>> +			return 0;
>> +	}
>=20
> This need to be moved to an earlier patch.
Yes.

>>  	err =3D scsi_dh->attach(sdev);
>>
>> @@ -163,8 +167,11 @@ static int scsi_dh_notifier(struct notifier_blo=
ck *nb,
>>  		goto out;
>>
>>  	if (action =3D=3D BUS_NOTIFY_ADD_DEVICE) {
>> -		scsi_dh_handler_attach(sdev, devinfo->handler);
>> -		device_create_file(dev, &scsi_dh_state_attr);
>> +		int err;
>> +
>> +		err =3D scsi_dh_handler_attach(sdev, devinfo->handler);
>> +		if (!err)
>> +			err =3D device_create_file(dev, &scsi_dh_state_attr);
>=20
> This too.
>=20
Ok.

>>  	} else if (action =3D=3D BUS_NOTIFY_DEL_DEVICE) {
>>  		if (sdev->scsi_dh_data =3D=3D NULL)
>>  			goto out;
>> @@ -345,6 +352,43 @@ int scsi_dh_handler_exist(const char *name)
>>  }
>>  EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
>>
>> +/*
>> + * scsi_dh_handler_attach - Attach device handler
>> + * @sdev - sdev the handler should be attached to
>> + * @name - name of the handler to attach
>> + */
>> +int scsi_dh_attach(struct request_queue *q, const char *name)
>> +{
>=20
> This code seems to do incorrect things (run the case with sdev =3D=3D=
 NULL
> or sdev->scsi_dh_data->scsi_dh !=3D scsi_dh).
>=20
> This function can be simplified to just call scsi_dh_handler_attach()
> after getting scsi_dh and a get_device.
>=20
> We can avoid calling scsi_dh->attach directly. instead call
> scsi_dh_device_handler(), which would do all the necessary checking.
>=20
Correct. Fixed.

Chandra, thank you very much for your review.
That helped a lot (and fixed some bugs, too :-).

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
