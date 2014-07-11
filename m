From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/10] sd: split sd_init_command
Date: Fri, 11 Jul 2014 14:33:34 +0200
Message-ID: <53BFD99E.3090501@suse.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbaGKMdg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 08:33:36 -0400
In-Reply-To: <1404048881-19526-10-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 06/29/2014 03:34 PM, Christoph Hellwig wrote:
> Factor out a function to initialize regular read/write commands and l=
eave
> sd_init_command as a simple dispatcher to the different prepare routi=
nes.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c |   58 ++++++++++++++++++++++++++----------------=
-----------
>   1 file changed, 29 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 5f85102..ba756b1 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -877,21 +877,7 @@ static int sd_setup_flush_cmnd(struct scsi_cmnd =
*cmd)
>   	return BLKPREP_OK;
>   }
>
> -static void sd_uninit_command(struct scsi_cmnd *SCpnt)
> -{
> -	struct request *rq =3D SCpnt->request;
> -
> -	if (rq->cmd_flags & REQ_DISCARD)
> -		__free_page(rq->completion_data);
> -
> -	if (SCpnt->cmnd !=3D rq->cmd) {
> -		mempool_free(SCpnt->cmnd, sd_cdb_pool);
> -		SCpnt->cmnd =3D NULL;
> -		SCpnt->cmd_len =3D 0;
> -	}
> -}
> -
> -static int sd_init_command(struct scsi_cmnd *SCpnt)
> +static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
>   {
>   	struct request *rq =3D SCpnt->request;
>   	struct scsi_device *sdp =3D SCpnt->device;
> @@ -903,20 +889,6 @@ static int sd_init_command(struct scsi_cmnd *SCp=
nt)
>   	int ret, host_dif;
>   	unsigned char protect;
>
> -	/*
> -	 * Discard request come in as REQ_TYPE_FS but we turn them into
> -	 * block PC requests to make life easier.
> -	 */
> -	if (rq->cmd_flags & REQ_DISCARD) {
> -		ret =3D sd_setup_discard_cmnd(SCpnt);
> -		goto out;
> -	} else if (rq->cmd_flags & REQ_WRITE_SAME) {
> -		ret =3D sd_setup_write_same_cmnd(SCpnt);
> -		goto out;
> -	} else if (rq->cmd_flags & REQ_FLUSH) {
> -		ret =3D sd_setup_flush_cmnd(SCpnt);
> -		goto out;
> -	}
>   	ret =3D scsi_init_io(SCpnt, GFP_ATOMIC);
>   	if (ret !=3D BLKPREP_OK)
>   		goto out;
> @@ -1148,6 +1120,34 @@ static int sd_init_command(struct scsi_cmnd *S=
Cpnt)
>   	return ret;
>   }
>
> +static int sd_init_command(struct scsi_cmnd *cmd)
> +{
> +	struct request *rq =3D cmd->request;
> +
> +	if (rq->cmd_flags & REQ_DISCARD)
> +		return sd_setup_discard_cmnd(cmd);
> +	else if (rq->cmd_flags & REQ_WRITE_SAME)
> +		return sd_setup_write_same_cmnd(cmd);
> +	else if (rq->cmd_flags & REQ_FLUSH)
> +		return sd_setup_flush_cmnd(cmd);
> +	else
> +		return sd_setup_read_write_cmnd(cmd);
> +}
> +
> +static void sd_uninit_command(struct scsi_cmnd *SCpnt)
> +{
> +	struct request *rq =3D SCpnt->request;
> +
> +	if (rq->cmd_flags & REQ_DISCARD)
> +		__free_page(rq->completion_data);
> +
> +	if (SCpnt->cmnd !=3D rq->cmd) {
> +		mempool_free(SCpnt->cmnd, sd_cdb_pool);
> +		SCpnt->cmnd =3D NULL;
> +		SCpnt->cmd_len =3D 0;
> +	}
> +}
> +
>   /**
>    *	sd_open - open a scsi disk device
>    *	@inode: only i_rdev member may be used
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
