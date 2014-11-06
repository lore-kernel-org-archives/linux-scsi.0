From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/6] scsi: remove scsi_next_command
Date: Thu, 06 Nov 2014 09:21:05 +0100
Message-ID: <545B2F71.7020808@suse.de>
References: <1415259630-20784-1-git-send-email-hch@lst.de> <1415259630-20784-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaKFIVG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 03:21:06 -0500
In-Reply-To: <1415259630-20784-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

On 11/06/2014 08:40 AM, Christoph Hellwig wrote:
> There's only one caller left, so inline it and reduce the blk-mq vs !=
blk-mq
> diff a litte bit.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c  | 18 ++++--------------
>  drivers/scsi/scsi_priv.h |  1 -
>  2 files changed, 4 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 38f8c85..1a3546e8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -543,17 +543,6 @@ static void scsi_requeue_command(struct request_=
queue *q, struct scsi_cmnd *cmd)
>  	put_device(&sdev->sdev_gendev);
>  }
> =20
> -void scsi_next_command(struct scsi_cmnd *cmd)
> -{
> -	struct scsi_device *sdev =3D cmd->device;
> -	struct request_queue *q =3D sdev->request_queue;
> -
> -	scsi_put_command(cmd);
> -	scsi_run_queue(q);
> -
> -	put_device(&sdev->sdev_gendev);
> -}
> -
>  void scsi_run_host_queues(struct Scsi_Host *shost)
>  {
>  	struct scsi_device *sdev;
> @@ -731,8 +720,6 @@ static bool scsi_end_request(struct request *req,=
 int error,
>  			kblockd_schedule_work(&sdev->requeue_work);
>  		else
>  			blk_mq_start_stopped_hw_queues(q, true);
> -
> -		put_device(&sdev->sdev_gendev);
>  	} else {
>  		unsigned long flags;
> =20
> @@ -744,9 +731,12 @@ static bool scsi_end_request(struct request *req=
, int error,
>  		spin_unlock_irqrestore(q->queue_lock, flags);
> =20
>  		scsi_release_buffers(cmd);
> -		scsi_next_command(cmd);
> +
> +		scsi_put_command(cmd);
> +		scsi_run_queue(q);
>  	}
> =20
> +	put_device(&sdev->sdev_gendev);
>  	return false;
>  }
> =20
Hmm? Isn't there a scsi_put_comand() too many?
You dropped it from the 'if' branch, moved it out of
the condition, but kept in in the 'else' branch ...

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
