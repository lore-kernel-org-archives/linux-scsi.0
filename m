From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Driver 'sd' needs updating
Date: Tue, 24 Mar 2009 16:01:20 +0100
Message-ID: <49C8F5C0.7030308@suse.de>
References: <20090324141428.31E5118C7A3@pentland.suse.de> <49C8F186.2080705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757607AbZCXPB0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 11:01:26 -0400
In-Reply-To: <49C8F186.2080705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Boaz,

Boaz Harrosh wrote:
> Hannes Reinecke wrote:
>> If a driver sets blk_queue_prep_rq() it should clean up itself
>> and not rely on the bus callbacks to handle this. This removes
>> the need to hook into bus->remove() as these should not be used
>> at the same time as driver->remove().
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>=20
> Hi Hannes, please I do not understand this patch.
>=20
> I was always under the impression that the scsi ULD
> remove() function is called from inside scsi_bus_remove()
> at the very end, please see below.
>=20
>> ---
>>  drivers/scsi/scsi_lib.c    |    6 ++++++
>>  drivers/scsi/scsi_sysfs.c  |   17 -----------------
>>  drivers/scsi/sd.c          |    2 ++
>>  drivers/scsi/sr.c          |    1 +
>>  include/scsi/scsi_driver.h |    1 +
>>  5 files changed, 10 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 4b13e36..73df41b 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1222,6 +1222,12 @@ int scsi_prep_fn(struct request_queue *q, str=
uct request *req)
>>  	return scsi_prep_return(q, req, ret);
>>  }
>> =20
>> +void scsi_reset_prep_fn(struct request_queue *q)
>> +{
>> +	blk_queue_prep_rq(q, scsi_prep_fn);
>> +}
>> +EXPORT_SYMBOL(scsi_reset_prep_fn);
>> +
>>  /*
>>   * scsi_dev_queue_ready: if we can send requests to sdev, return 1 =
else
>>   * return 0.
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index fa4711d..91482f2 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -420,29 +420,12 @@ static int scsi_bus_resume(struct device * dev=
)
>>  	return err;
>>  }
>> =20
>> -static int scsi_bus_remove(struct device *dev)
>> -{
>> -	struct device_driver *drv =3D dev->driver;
>> -	struct scsi_device *sdev =3D to_scsi_device(dev);
>> -	int err =3D 0;
>> -
>> -	/* reset the prep_fn back to the default since the
>> -	 * driver may have altered it and it's being removed */
>> -	blk_queue_prep_rq(sdev->request_queue, scsi_prep_fn);
>> -
>> -	if (drv && drv->remove)
>> -		err =3D drv->remove(dev);
>=20
> This here is where my osd_uld.c::osd_remove() is called.
>=20
> If this vector is not used will the drv-core call drv->remove(dev)
> in behalf of scsi?
>=20
=46rom drivers/base/dd.c:__device_release_driver()

		if (dev->bus && dev->bus->remove)
			dev->bus->remove(dev);
		else if (drv->remove)
			drv->remove(dev);

So the answer will be yes.

>> -
>> -	return 0;
>> -}
>> -
>>  struct bus_type scsi_bus_type =3D {
>>          .name		=3D "scsi",
>>          .match		=3D scsi_bus_match,
>>  	.uevent		=3D scsi_bus_uevent,
>>  	.suspend	=3D scsi_bus_suspend,
>>  	.resume		=3D scsi_bus_resume,
>> -	.remove		=3D scsi_bus_remove,
>>  };
>>  EXPORT_SYMBOL_GPL(scsi_bus_type);
>> =20
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index aeab5d9..64e88e2 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -2068,6 +2068,8 @@ static int sd_remove(struct device *dev)
>=20
> Until today this was called from within scsi_bus_remove
> what happens after your patch?
>=20
Driver core calls it (see above).

>>  {
>>  	struct scsi_disk *sdkp =3D dev_get_drvdata(dev);
>> =20
>> +	scsi_reset_prep_fn(sdkp->device->request_queue);
>> +
>>  	device_del(&sdkp->dev);
>>  	del_gendisk(sdkp->disk);
>>  	sd_shutdown(dev);
>> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
>> index e7fa3ca..914733a 100644
>> --- a/drivers/scsi/sr.c
>> +++ b/drivers/scsi/sr.c
>> @@ -889,6 +889,7 @@ static int sr_remove(struct device *dev)
>>  {
>>  	struct scsi_cd *cd =3D dev_get_drvdata(dev);
>> =20
>> +	scsi_reset_prep_fn(cd->device->request_queue);
>>  	del_gendisk(cd->disk);
>> =20
>>  	mutex_lock(&sr_ref_mutex);
>> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
>> index 1f5ca7f..2e22929 100644
>> --- a/include/scsi/scsi_driver.h
>> +++ b/include/scsi/scsi_driver.h
>> @@ -32,5 +32,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sde=
v, struct request *req);
>>  int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *re=
q);
>>  int scsi_prep_state_check(struct scsi_device *sdev, struct request =
*req);
>>  int scsi_prep_return(struct request_queue *q, struct request *req, =
int ret);
>> +int scsi_reset_prep_fn(struct request_queue *);
>> =20
>>  #endif /* _SCSI_SCSI_DRIVER_H */
>=20
> I did not test this patch with osd_uld yet, but I will tomorrow. If m=
y assumption
> is right then drv-core should call my osd_remove just the same, right=
?
>=20
Yes, correct.

> Are there any different timing issue for example the presence of scsi=
_device
> is still true?
>=20
No. Or rather, none you'll notice. (We're effectively saving on indirec=
tion here,
but I doubt it'll be measureable)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
