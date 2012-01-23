From: Hannes Reinecke <hare@suse.de>
Subject: Re: SCSI:implement PM for sr
Date: Mon, 23 Jan 2012 09:48:36 +0100
Message-ID: <4F1D1EE4.8040003@suse.de>
References: <201201160941.41334.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab2AWIsh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2012 03:48:37 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id A67108FC92
	for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2012 09:48:36 +0100 (CET)
In-Reply-To: <201201160941.41334.oneukum@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-scsi@vger.kernel.org

On 01/16/2012 09:41 AM, Oliver Neukum wrote:
> From e81a6204b9c53b1e6a2817a96f0e1b44e3c87fb4 Mon Sep 17 00:00:00 200=
1
> From: Oliver Neukum <oliver@neukum.org>
> Date: Mon, 16 Jan 2012 09:38:04 +0100
> Subject: [PATCH] SCSI:implement PM for sr
>=20
> This implements basic power management for SCSI CDs.
>=20
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> ---
>  drivers/scsi/sr.c |   31 +++++++++++++++++++++++++++++--
>  1 files changed, 29 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 5fc97d2..91b545b 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -508,16 +508,29 @@ static int sr_prep_fn(struct request_queue *q, =
struct request *rq)
> =20
>  static int sr_block_open(struct block_device *bdev, fmode_t mode)
>  {
> +	struct scsi_device *sdev;
>  	struct scsi_cd *cd;
>  	int ret =3D -ENXIO;
> +	int err;
> =20
>  	mutex_lock(&sr_mutex);
>  	cd =3D scsi_cd_get(bdev->bd_disk);
> +	sdev =3D cd->device;
> +
> +	err =3D scsi_autopm_get_device(sdev);
> +	if (err) {
> +		ret =3D -EIO;
> +		goto err_out;
> +	}
> +
>  	if (cd) {
>  		ret =3D cdrom_open(&cd->cdi, bdev, mode);
> -		if (ret)
> +		if (ret) {
>  			scsi_cd_put(cd);
> +			scsi_autopm_put_device(sdev);
> +		}
>  	}
> +err_out:
>  	mutex_unlock(&sr_mutex);
>  	return ret;
>  }
> @@ -525,9 +538,12 @@ static int sr_block_open(struct block_device *bd=
ev, fmode_t mode)
>  static int sr_block_release(struct gendisk *disk, fmode_t mode)
>  {
>  	struct scsi_cd *cd =3D scsi_cd(disk);
> +	struct scsi_device *sdev =3D cd->device;
> +
>  	mutex_lock(&sr_mutex);
>  	cdrom_release(&cd->cdi, mode);
>  	scsi_cd_put(cd);
> +	scsi_autopm_put_device(sdev);
>  	mutex_unlock(&sr_mutex);
>  	return 0;
>  }
> @@ -615,6 +631,11 @@ static int sr_open(struct cdrom_device_info *cdi=
, int purpose)
>  	struct scsi_device *sdev =3D cd->device;
>  	int retval;
> =20
> +	retval =3D scsi_autopm_get_device(sdev);
> +	if (retval) {
> +		retval =3D -EIO;
> +		goto pm_error_out;
> +	}
>  	/*
>  	 * If the device is in error recovery, wait until it is done.
>  	 * If the device is offline, then disallow any access to it.
> @@ -626,16 +647,19 @@ static int sr_open(struct cdrom_device_info *cd=
i, int purpose)
>  	return 0;
> =20
>  error_out:
> +	scsi_autopm_put_device(sdev);
> +pm_error_out:
>  	return retval;=09
>  }
> =20
>  static void sr_release(struct cdrom_device_info *cdi)
>  {
>  	struct scsi_cd *cd =3D cdi->handle;
> +	struct scsi_device *sdev =3D cd->device;
> =20
>  	if (cd->device->sector_size > 2048)
>  		sr_set_blocklength(cd, 2048);
> -
> +	scsi_autopm_put_device(sdev);
>  }
> =20
>  static int sr_probe(struct device *dev)
> @@ -715,6 +739,7 @@ static int sr_probe(struct device *dev)
>  	dev_set_drvdata(dev, cd);
>  	disk->flags |=3D GENHD_FL_REMOVABLE;
>  	add_disk(disk);
> +	scsi_autopm_put_device(sdev);
> =20
>  	sdev_printk(KERN_DEBUG, sdev,
>  		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
> @@ -964,7 +989,9 @@ static void sr_kref_release(struct kref *kref)
>  static int sr_remove(struct device *dev)
>  {
>  	struct scsi_cd *cd =3D dev_get_drvdata(dev);
> +	struct scsi_device *sdev =3D cd->device;
> =20
> +	scsi_autopm_get_device(sdev);
>  	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
>  	del_gendisk(cd->disk);
> =20
Why do I have to do a _put() on probe and a _get() on remove?
This looks odd, to say the least.
Not saying it's wrong, but I would like to have a comment
here as to why the 'normal' order of _get() and _put() is
reversed here.

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
