From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/10] sd: don't use scsi_setup_blk_pc_cmnd for flush
 requests
Date: Fri, 11 Jul 2014 14:20:03 +0200
Message-ID: <53BFD673.504@suse.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaGKMUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 08:20:05 -0400
In-Reply-To: <1404048881-19526-5-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 06/29/2014 03:34 PM, Christoph Hellwig wrote:
> Simplify handling of flush requests by setting up the command directl=
y
> instead of initializing request fields and then calling
> scsi_setup_blk_pc_cmnd to propagate the information into the command.
>
> Also rename scsi_setup_flush_cmnd to sd_setup_flush_cmnd for consiste=
ncy.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c |   20 +++++++++++++-------
>   1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d88bdc8..620d32f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -844,14 +844,20 @@ static int sd_setup_write_same_cmnd(struct scsi=
_device *sdp, struct request *rq)
>   	return ret;
>   }
>
> -static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct req=
uest *rq)
> +static int sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
>   {
> -	rq->timeout *=3D SD_FLUSH_TIMEOUT_MULTIPLIER;
> -	rq->retries =3D SD_MAX_RETRIES;
> -	rq->cmd[0] =3D SYNCHRONIZE_CACHE;
> -	rq->cmd_len =3D 10;
> +	struct request *rq =3D cmd->request;
> +
> +	/* flush requests don't perform I/O, zero the S/G table */
> +	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
>
> -	return scsi_setup_blk_pc_cmnd(sdp, rq);
> +	cmd->cmnd[0] =3D SYNCHRONIZE_CACHE;
> +	cmd->cmd_len =3D 10;
> +	cmd->transfersize =3D 0;
> +	cmd->allowed =3D SD_MAX_RETRIES;
> +
> +	rq->timeout *=3D SD_FLUSH_TIMEOUT_MULTIPLIER;
> +	return BLKPREP_OK;
>   }
>
>   static void sd_uninit_command(struct scsi_cmnd *SCpnt)
> @@ -891,7 +897,7 @@ static int sd_init_command(struct scsi_cmnd *SCpn=
t)
>   		ret =3D sd_setup_write_same_cmnd(sdp, rq);
>   		goto out;
>   	} else if (rq->cmd_flags & REQ_FLUSH) {
> -		ret =3D scsi_setup_flush_cmnd(sdp, rq);
> +		ret =3D sd_setup_flush_cmnd(SCpnt);
>   		goto out;
>   	}
>   	ret =3D scsi_init_io(SCpnt, GFP_ATOMIC);
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
