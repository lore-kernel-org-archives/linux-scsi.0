From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] [PATCH REGRESSION] alua: fix bus detach oops
Date: Thu, 29 Jan 2015 09:45:24 +0100
Message-ID: <54C9F324.1020102@suse.de>
References: <1422438413-10273-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbbA2Ip1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 03:45:27 -0500
In-Reply-To: <1422438413-10273-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On 01/28/2015 10:46 AM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>=20
> This fixes a regression caused by commit
> 1d5203284d8acbdfdf9b478d434450b34f338f28
>=20
> The bug is that the alua detach() callout will try to access the
> sddev->scsi_dh_data, but we have already set it to NULL. This patch
> moves the clearing of that field to after detach() is called.
>=20
> It looks like the regression was added during 3.19 development,
> so it has not been in a released kernel, and so I did not cc
> stable.
>=20
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>=20
> ---
>  drivers/scsi/device_handler/scsi_dh.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/dev=
ice_handler/scsi_dh.c
> index 1dba62c..1efebc9 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -136,11 +136,12 @@ static void __detach_handler (struct kref *kref=
)
>  	struct scsi_device_handler *scsi_dh =3D scsi_dh_data->scsi_dh;
>  	struct scsi_device *sdev =3D scsi_dh_data->sdev;
> =20
> +	scsi_dh->detach(sdev);
> +
>  	spin_lock_irq(sdev->request_queue->queue_lock);
>  	sdev->scsi_dh_data =3D NULL;
>  	spin_unlock_irq(sdev->request_queue->queue_lock);
> =20
> -	scsi_dh->detach(sdev);
>  	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", scsi_dh->name);
>  	module_put(scsi_dh->module);
>  }
>=20
Errm.

We save the contents first:

>  	struct scsi_device_handler *scsi_dh =3D scsi_dh_data->scsi_dh;

Then set the pointer to NULL:

>  	sdev->scsi_dh_data =3D NULL;

and then call 'detach':

> 	scsi_dh->detach(sdev);

So scsi_dh is _not_ NULL, hence it shouldn't oops.

NACK.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
