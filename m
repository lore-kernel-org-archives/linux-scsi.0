From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/6] scsi: don't use scsi_next_command in scsi_reset_provider
Date: Thu, 06 Nov 2014 09:18:03 +0100
Message-ID: <545B2EBB.2010801@suse.de>
References: <1415259630-20784-1-git-send-email-hch@lst.de> <1415259630-20784-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaKFISG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 03:18:06 -0500
In-Reply-To: <1415259630-20784-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

On 11/06/2014 08:40 AM, Christoph Hellwig wrote:
> scsi_reset_provider already manually runs all queues for the given ho=
st,
> so it doesn't need the scsi_run_queues call from it, and it doesn't n=
eed
> a reference on the device because it's synchronous.
>=20
> So let's just call scsi_put_command directly and avoid the device ref=
erence
> dance to simplify the code.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index ba19687..a1ffdb0 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2335,14 +2335,9 @@ scsi_ioctl_reset(struct scsi_device *dev, int =
__user *arg)
>  		return -EIO;
> =20
>  	error =3D -EIO;
> -	if (!get_device(&dev->sdev_gendev))
> -		goto out_put_autopm_host;
> -
>  	scmd =3D scsi_get_command(dev, GFP_KERNEL);
> -	if (!scmd) {
> -		put_device(&dev->sdev_gendev);
> +	if (!scmd)
>  		goto out_put_autopm_host;
> -	}
> =20
>  	blk_rq_init(NULL, &req);
>  	scmd->request =3D &req;
> @@ -2404,10 +2399,10 @@ scsi_ioctl_reset(struct scsi_device *dev, int=
 __user *arg)
>  			     "waking up host to restart after TMF\n"));
> =20
>  	wake_up(&shost->host_wait);
> -
>  	scsi_run_host_queues(shost);
> =20
> -	scsi_next_command(scmd);
> +	scsi_put_command(scmd);
> +
>  out_put_autopm_host:
>  	scsi_autopm_put_host(shost);
>  	return error;
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
