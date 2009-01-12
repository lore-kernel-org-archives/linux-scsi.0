From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Make errors printed from scsi_sysfs_add_sdev() mean something.
Date: Mon, 12 Jan 2009 13:30:00 +0100
Message-ID: <496B37C8.3010705@suse.de>
References: <20081223221859.GA541@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZALMaE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 07:30:04 -0500
In-Reply-To: <20081223221859.GA541@rere.qmqm.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Hi Michal,

Micha=B3 Miros=B3aw wrote:
> This is an updated version of patch I wrote long time ago, but looks =
like
> it didn't get far. Patch against linux-2.6.git. And yes - printk() li=
nes
> are longer than 80 chars - it shouldn't matter here (grep is happy ;)=
=2E
>=20
> Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>
>=20
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 93c28f3..7a3389c 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -872,12 +872,12 @@ int scsi_sysfs_add_sdev(struct scsi_device *sde=
v)
>  	error =3D device_add(&sdev->sdev_gendev);
>  	if (error) {
>  		put_device(sdev->sdev_gendev.parent);
> -		printk(KERN_INFO "error 1\n");
> +		printk(KERN_ERR "sysfs: SCSI device registration failed: %d\n", er=
ror);
Shouldn't that be sdev_printk()?

>  		return error;
>  	}
>  	error =3D device_add(&sdev->sdev_dev);
>  	if (error) {
> -		printk(KERN_INFO "error 2\n");
> +		printk(KERN_ERR "sysfs: SCSI class device registration failed: %d\=
n", error);
Same here ...

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
