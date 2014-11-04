From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/11] mptfusion: don't change queue type in ->change_queue_depth
Date: Tue, 04 Nov 2014 09:46:22 +0100
Message-ID: <5458925E.5080204@suse.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaKDIqX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 03:46:23 -0500
In-Reply-To: <1415087656-9491-7-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/04/2014 08:54 AM, Christoph Hellwig wrote:
> This function shouldn't change the queue type, just the depth.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/message/fusion/mptscsih.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>=20
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusi=
on/mptscsih.c
> index 00bd13d..c0d84a0 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -2322,7 +2322,6 @@ mptscsih_change_queue_depth(struct scsi_device =
*sdev, int qdepth, int reason)
>  	VirtTarget 		*vtarget;
>  	struct scsi_target 	*starget;
>  	int			max_depth;
> -	int			tagged;
>  	MPT_ADAPTER		*ioc =3D hd->ioc;
> =20
>  	starget =3D scsi_target(sdev);
> @@ -2347,12 +2346,8 @@ mptscsih_change_queue_depth(struct scsi_device=
 *sdev, int qdepth, int reason)
> =20
>  	if (qdepth > max_depth)
>  		qdepth =3D max_depth;
> -	if (qdepth =3D=3D 1)
> -		tagged =3D 0;
> -	else
> -		tagged =3D MSG_SIMPLE_TAG;
> =20
> -	scsi_adjust_queue_depth(sdev, tagged, qdepth);
> +	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
>  	return sdev->queue_depth;
>  }
> =20
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
