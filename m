From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 02/18] scsi: ignore errors from scsi_dh_add_device()
Date: Tue, 24 Nov 2015 13:14:28 +0100
Message-ID: <1448367268.2877.11.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbbKXMO3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:14:29 -0500
In-Reply-To: <1447081703-110552-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> device handler initialisation might fail due to a number of
> reasons. But as device_handlers are optional this shouldn't
> cause us to disable the device entirely.
> So just ignore errors from scsi_dh_add_device().
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/scsi_sysfs.c | 7 ++++---
> =C2=A01 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 13a5ede..7b41b2c 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1118,11 +1118,12 @@ int scsi_sysfs_add_sdev(struct scsi_device
> *sdev)
> =C2=A0	}
> =C2=A0
> =C2=A0	error =3D scsi_dh_add_device(sdev);
> -	if (error) {
> +	if (error)
> +		/*
> +		=C2=A0* device_handler is optional, so any error can be
> ignored
> +		=C2=A0*/
> =C2=A0		sdev_printk(KERN_INFO, sdev,
> =C2=A0				"failed to add device handler:
> %d\n", error);
> -		return error;
> -	}
> =C2=A0
> =C2=A0	device_enable_async_suspend(&sdev->sdev_dev);
> =C2=A0	error =3D device_add(&sdev->sdev_dev);

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
