From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/10] scsi: set sc_data_direction in common code
Date: Fri, 11 Jul 2014 14:19:02 +0200
Message-ID: <53BFD636.3090703@suse.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbaGKMTD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 08:19:03 -0400
In-Reply-To: <1404048881-19526-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 06/29/2014 03:34 PM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c |   14 +++++++-------
>   drivers/scsi/sd.c       |    2 --
>   drivers/scsi/sr.c       |    2 --
>   3 files changed, 7 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index bc84811..ea23860 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1101,13 +1101,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device =
*sdev, struct request *req)
>   	}
>
>   	cmd->cmd_len =3D req->cmd_len;
> -	if (!blk_rq_bytes(req))
> -		cmd->sc_data_direction =3D DMA_NONE;
> -	else if (rq_data_dir(req) =3D=3D WRITE)
> -		cmd->sc_data_direction =3D DMA_TO_DEVICE;
> -	else
> -		cmd->sc_data_direction =3D DMA_FROM_DEVICE;
> -=09
>   	cmd->transfersize =3D blk_rq_bytes(req);
>   	cmd->allowed =3D req->retries;
>   	return BLKPREP_OK;
> @@ -1236,6 +1229,13 @@ static int scsi_prep_fn(struct request_queue *=
q, struct request *req)
>   		goto out;
>   	}
>
> +	if (!blk_rq_bytes(req))
> +		cmd->sc_data_direction =3D DMA_NONE;
> +	else if (rq_data_dir(req) =3D=3D WRITE)
> +		cmd->sc_data_direction =3D DMA_TO_DEVICE;
> +	else
> +		cmd->sc_data_direction =3D DMA_FROM_DEVICE;
> +
>   	switch (req->cmd_type) {
>   	case REQ_TYPE_FS:
>   		ret =3D scsi_setup_fs_cmnd(sdev, req);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 001b3e8..d88bdc8 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -994,14 +994,12 @@ static int sd_init_command(struct scsi_cmnd *SC=
pnt)
>   			goto out;
>   		}
>   		SCpnt->cmnd[0] =3D WRITE_6;
> -		SCpnt->sc_data_direction =3D DMA_TO_DEVICE;
>
>   		if (blk_integrity_rq(rq))
>   			sd_dif_prepare(rq, block, sdp->sector_size);
>
>   	} else if (rq_data_dir(rq) =3D=3D READ) {
>   		SCpnt->cmnd[0] =3D READ_6;
> -		SCpnt->sc_data_direction =3D DMA_FROM_DEVICE;
>   	} else {
>   		scmd_printk(KERN_ERR, SCpnt, "Unknown command %llx\n", (unsigned =
long long) rq->cmd_flags);
>   		goto out;
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 9feeb37..cce4771 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -438,11 +438,9 @@ static int sr_init_command(struct scsi_cmnd *SCp=
nt)
>   		if (!cd->device->writeable)
>   			goto out;
>   		SCpnt->cmnd[0] =3D WRITE_10;
> -		SCpnt->sc_data_direction =3D DMA_TO_DEVICE;
>   		cd->cdi.media_written =3D 1;
>   	} else if (rq_data_dir(rq) =3D=3D READ) {
>   		SCpnt->cmnd[0] =3D READ_10;
> -		SCpnt->sc_data_direction =3D DMA_FROM_DEVICE;
>   	} else {
>   		blk_dump_rq_flags(rq, "Unknown sr command");
>   		goto out;
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
