From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/11] scsi: remove ordered_tag host template field
Date: Tue, 04 Nov 2014 09:38:31 +0100
Message-ID: <54589087.10508@suse.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbaKDIid (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 03:38:33 -0500
In-Reply-To: <1415087656-9491-5-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/04/2014 08:54 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/hosts.c      |  1 -
>  drivers/usb/storage/uas.c |  1 -
>  include/scsi/scsi_host.h  | 10 ----------
>  3 files changed, 12 deletions(-)
>=20
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 06030e1..8bb173e 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -418,7 +418,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_hos=
t_template *sht, int privsize)
>  	shost->cmd_per_lun =3D sht->cmd_per_lun;
>  	shost->unchecked_isa_dma =3D sht->unchecked_isa_dma;
>  	shost->use_clustering =3D sht->use_clustering;
> -	shost->ordered_tag =3D sht->ordered_tag;
>  	shost->no_write_same =3D sht->no_write_same;
> =20
>  	if (shost_eh_deadline =3D=3D -1 || !sht->eh_host_reset_handler)
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index b38bc13..1bc5df4 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -817,7 +817,6 @@ static struct scsi_host_template uas_host_templat=
e =3D {
>  	.sg_tablesize =3D SG_NONE,
>  	.cmd_per_lun =3D 1,	/* until we override it */
>  	.skip_settle_delay =3D 1,
> -	.ordered_tag =3D 1,
> =20
>  	/*
>  	 * The uas drivers expects tags not to be bigger than the maximum
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 5e36248..f62143a 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -451,11 +451,6 @@ struct scsi_host_template {
>  	 */
>  	unsigned skip_settle_delay:1;
> =20
> -	/*
> -	 * True if we are using ordered write support.
> -	 */
> -	unsigned ordered_tag:1;
> -
>  	/* True if the controller does not support WRITE SAME */
>  	unsigned no_write_same:1;
> =20
> @@ -662,11 +657,6 @@ struct Scsi_Host {
>  	 */
>  	unsigned reverse_ordering:1;
> =20
> -	/*
> -	 * Ordered write support
> -	 */
> -	unsigned ordered_tag:1;
> -
>  	/* Task mgmt function in progress */
>  	unsigned tmf_in_progress:1;
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
