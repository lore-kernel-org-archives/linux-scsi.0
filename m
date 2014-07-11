From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/10] sd: don't use scsi_setup_blk_pc_cmnd for discard
 requests
Date: Fri, 11 Jul 2014 14:26:24 +0200
Message-ID: <53BFD7F0.5080703@suse.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaGKM00 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 08:26:26 -0400
In-Reply-To: <1404048881-19526-7-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 06/29/2014 03:34 PM, Christoph Hellwig wrote:
> Simplify handling of discard requests by setting up the command direc=
tly
> instead of initializing request fields and then calling
> scsi_setup_blk_pc_cmnd to propagate the information into the command.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c |   43 ++++++++++++++++++++++++------------------=
-
>   1 file changed, 24 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 25f25dd..9737e78 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -691,8 +691,10 @@ static void sd_config_discard(struct scsi_disk *=
sdkp, unsigned int mode)
>    * Will issue either UNMAP or WRITE SAME(16) depending on preferenc=
e
>    * indicated by target device.
>    **/
> -static int sd_setup_discard_cmnd(struct scsi_device *sdp, struct req=
uest *rq)
> +static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
>   {
> +	struct request *rq =3D cmd->request;
> +	struct scsi_device *sdp =3D cmd->device;
>   	struct scsi_disk *sdkp =3D scsi_disk(rq->rq_disk);
>   	sector_t sector =3D blk_rq_pos(rq);
>   	unsigned int nr_sectors =3D blk_rq_sectors(rq);
> @@ -704,9 +706,6 @@ static int sd_setup_discard_cmnd(struct scsi_devi=
ce *sdp, struct request *rq)
>
>   	sector >>=3D ilog2(sdp->sector_size) - 9;
>   	nr_sectors >>=3D ilog2(sdp->sector_size) - 9;
> -	rq->timeout =3D SD_TIMEOUT;
> -
> -	memset(rq->cmd, 0, rq->cmd_len);
>
>   	page =3D alloc_page(GFP_ATOMIC | __GFP_ZERO);
>   	if (!page)
> @@ -716,9 +715,9 @@ static int sd_setup_discard_cmnd(struct scsi_devi=
ce *sdp, struct request *rq)
>   	case SD_LBP_UNMAP:
>   		buf =3D page_address(page);
>
> -		rq->cmd_len =3D 10;
> -		rq->cmd[0] =3D UNMAP;
> -		rq->cmd[8] =3D 24;
> +		cmd->cmd_len =3D 10;
> +		cmd->cmnd[0] =3D UNMAP;
> +		cmd->cmnd[8] =3D 24;
>
>   		put_unaligned_be16(6 + 16, &buf[0]);
>   		put_unaligned_be16(16, &buf[2]);
> @@ -729,23 +728,23 @@ static int sd_setup_discard_cmnd(struct scsi_de=
vice *sdp, struct request *rq)
>   		break;
>
>   	case SD_LBP_WS16:
> -		rq->cmd_len =3D 16;
> -		rq->cmd[0] =3D WRITE_SAME_16;
> -		rq->cmd[1] =3D 0x8; /* UNMAP */
> -		put_unaligned_be64(sector, &rq->cmd[2]);
> -		put_unaligned_be32(nr_sectors, &rq->cmd[10]);
> +		cmd->cmd_len =3D 16;
> +		cmd->cmnd[0] =3D WRITE_SAME_16;
> +		cmd->cmnd[1] =3D 0x8; /* UNMAP */
> +		put_unaligned_be64(sector, &cmd->cmnd[2]);
> +		put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
>
>   		len =3D sdkp->device->sector_size;
>   		break;
>
>   	case SD_LBP_WS10:
>   	case SD_LBP_ZERO:
> -		rq->cmd_len =3D 10;
> -		rq->cmd[0] =3D WRITE_SAME;
> +		cmd->cmd_len =3D 10;
> +		cmd->cmnd[0] =3D WRITE_SAME;
>   		if (sdkp->provisioning_mode =3D=3D SD_LBP_WS10)
> -			rq->cmd[1] =3D 0x8; /* UNMAP */
> -		put_unaligned_be32(sector, &rq->cmd[2]);
> -		put_unaligned_be16(nr_sectors, &rq->cmd[7]);
> +			cmd->cmnd[1] =3D 0x8; /* UNMAP */
> +		put_unaligned_be32(sector, &cmd->cmnd[2]);
> +		put_unaligned_be16(nr_sectors, &cmd->cmnd[7]);
>
>   		len =3D sdkp->device->sector_size;
>   		break;
> @@ -756,8 +755,14 @@ static int sd_setup_discard_cmnd(struct scsi_dev=
ice *sdp, struct request *rq)
>   	}
>
>   	rq->completion_data =3D page;
> +	rq->timeout =3D SD_TIMEOUT;
> +
>   	blk_add_request_payload(rq, page, len);
> -	ret =3D scsi_setup_blk_pc_cmnd(sdp, rq);
> +
> +	cmd->transfersize =3D len;
> +	cmd->allowed =3D rq->retries;
> +
> +	ret =3D scsi_init_io(cmd, GFP_ATOMIC);
>   	rq->__data_len =3D nr_bytes;
>
>   out:
Ah. Here it's done properly.

> @@ -903,7 +908,7 @@ static int sd_init_command(struct scsi_cmnd *SCpn=
t)
>   	 * block PC requests to make life easier.
>   	 */
>   	if (rq->cmd_flags & REQ_DISCARD) {
> -		ret =3D sd_setup_discard_cmnd(sdp, rq);
> +		ret =3D sd_setup_discard_cmnd(SCpnt);
>   		goto out;
>   	} else if (rq->cmd_flags & REQ_WRITE_SAME) {
>   		ret =3D sd_setup_write_same_cmnd(SCpnt);
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
