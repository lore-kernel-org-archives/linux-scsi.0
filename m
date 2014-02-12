From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/6] scsi: avoid taking host_lock in scsi_run_queue unless
 nessecary
Date: Wed, 12 Feb 2014 12:08:35 +0100
Message-ID: <52FB5633.3050904@suse.de>
References: <20140206184306.997538898@bombadil.infradead.org> <20140206184417.536140873@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbaBLLIh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 06:08:37 -0500
In-Reply-To: <20140206184417.536140873@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 02/06/2014 07:43 PM, Christoph Hellwig wrote:
> If we don't have starved devices we don't need to take the host lock
> to iterate over them.  Also split the function up to be more clear.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_lib.c |   43 ++++++++++++++++++++++++-------------=
------
>  1 file changed, 24 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7bd7f0d..ad516c0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -385,29 +385,12 @@ static inline int scsi_host_is_busy(struct Scsi=
_Host *shost)
>  	return 0;
>  }
> =20
> -/*
> - * Function:	scsi_run_queue()
> - *
> - * Purpose:	Select a proper request queue to serve next
> - *
> - * Arguments:	q	- last request's queue
> - *
> - * Returns:     Nothing
> - *
> - * Notes:	The previous command was completely finished, start
> - *		a new one if possible.
> - */
> -static void scsi_run_queue(struct request_queue *q)
> +static void scsi_starved_list_run(struct Scsi_Host *shost)
>  {
> -	struct scsi_device *sdev =3D q->queuedata;
> -	struct Scsi_Host *shost;
>  	LIST_HEAD(starved_list);
> +	struct scsi_device *sdev;
>  	unsigned long flags;
> =20
> -	shost =3D sdev->host;
> -	if (scsi_target(sdev)->single_lun)
> -		scsi_single_lun_run(sdev);
> -
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_splice_init(&shost->starved_list, &starved_list);
> =20
> @@ -459,6 +442,28 @@ static void scsi_run_queue(struct request_queue =
*q)
>  	/* put any unprocessed entries back */
>  	list_splice(&starved_list, &shost->starved_list);
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> +}
> +
> +/*
> + * Function:   scsi_run_queue()
> + *
> + * Purpose:    Select a proper request queue to serve next
> + *
> + * Arguments:  q       - last request's queue
> + *
> + * Returns:     Nothing
> + *
> + * Notes:      The previous command was completely finished, start
> + *             a new one if possible.
> + */
> +static void scsi_run_queue(struct request_queue *q)
> +{
> +	struct scsi_device *sdev =3D q->queuedata;
> +
> +	if (scsi_target(sdev)->single_lun)
> +		scsi_single_lun_run(sdev);
> +	if (!list_empty(&sdev->host->starved_list))
> +		scsi_starved_list_run(sdev->host);
> =20
>  	blk_run_queue(q);
>  }
> -- 1.7.10.4 --
Hmm.

What happens when another CPU is just modifying the starved list
at this point?
We probably won't be seeing the update until when the next command
completed.
Which probably doesn't matter if the HBA has run out of resources
(which means there are plenty of other commands outstanding),
but it'll surely influence the load balancing when using several
devices, won't it?

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
