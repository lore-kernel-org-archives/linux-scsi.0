From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/10] sd: don't use scsi_setup_blk_pc_cmnd for write
 same requests
Date: Fri, 11 Jul 2014 14:25:05 +0200
Message-ID: <53BFD7A1.7040205@suse.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaGKMZH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 08:25:07 -0400
In-Reply-To: <1404048881-19526-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 06/29/2014 03:34 PM, Christoph Hellwig wrote:
> Simplify handling of write same requests by setting up the command di=
rectly
> instead of initializing request fields and then calling
> scsi_setup_blk_pc_cmnd to propagate the information into the command.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c |   44 ++++++++++++++++++++++++++++--------------=
--
>   1 file changed, 28 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 620d32f..25f25dd 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -799,14 +799,15 @@ out:
>
>   /**
>    * sd_setup_write_same_cmnd - write the same data to multiple block=
s
> - * @sdp: scsi device to operate one
> - * @rq: Request to prepare
> + * @cmd: command to prepare
>    *
>    * Will issue either WRITE SAME(10) or WRITE SAME(16) depending on
>    * preference indicated by target device.
>    **/
> -static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct =
request *rq)
> +static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
>   {
> +	struct request *rq =3D cmd->request;
> +	struct scsi_device *sdp =3D cmd->device;
>   	struct scsi_disk *sdkp =3D scsi_disk(rq->rq_disk);
>   	struct bio *bio =3D rq->bio;
>   	sector_t sector =3D blk_rq_pos(rq);
> @@ -822,25 +823,36 @@ static int sd_setup_write_same_cmnd(struct scsi=
_device *sdp, struct request *rq)
>   	sector >>=3D ilog2(sdp->sector_size) - 9;
>   	nr_sectors >>=3D ilog2(sdp->sector_size) - 9;
>
> -	rq->__data_len =3D sdp->sector_size;
>   	rq->timeout =3D SD_WRITE_SAME_TIMEOUT;
> -	memset(rq->cmd, 0, rq->cmd_len);
>
>   	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff) {
> -		rq->cmd_len =3D 16;
> -		rq->cmd[0] =3D WRITE_SAME_16;
> -		put_unaligned_be64(sector, &rq->cmd[2]);
> -		put_unaligned_be32(nr_sectors, &rq->cmd[10]);
> +		cmd->cmd_len =3D 16;
> +		cmd->cmnd[0] =3D WRITE_SAME_16;
> +		put_unaligned_be64(sector, &cmd->cmnd[2]);
> +		put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
>   	} else {
> -		rq->cmd_len =3D 10;
> -		rq->cmd[0] =3D WRITE_SAME;
> -		put_unaligned_be32(sector, &rq->cmd[2]);
> -		put_unaligned_be16(nr_sectors, &rq->cmd[7]);
> +		cmd->cmd_len =3D 10;
> +		cmd->cmnd[0] =3D WRITE_SAME;
> +		put_unaligned_be32(sector, &cmd->cmnd[2]);
> +		put_unaligned_be16(nr_sectors, &cmd->cmnd[7]);
>   	}
>
> -	ret =3D scsi_setup_blk_pc_cmnd(sdp, rq);
> -	rq->__data_len =3D nr_bytes;
> +	cmd->transfersize =3D sdp->sector_size;
> +	cmd->allowed =3D rq->retries;
>
> +	/*
> +	 * For WRITE_SAME the data transferred in the DATA IN buffer is
> +	 * different from the amount of data actually written to the target=
=2E
> +	 *
> +	 * We set up __data_len to the amount of data transferred from the
> +	 * DATA IN buffer so that blk_rq_map_sg set up the proper S/G list
> +	 * to transfer a single sector of data first, but then reset it to
> +	 * the amount of data to be written right after so that the I/O pat=
h
> +	 * knows how much to actually write.
> +	 */
> +	rq->__data_len =3D sdp->sector_size;
> +	ret =3D scsi_init_io(cmd, GFP_ATOMIC);
> +	rq->__data_len =3D nr_bytes;
>   	return ret;
>   }
>
Hmm? __data_len is the amount of data written _on the target_.
Do we actually care about it?
And if so, why didn't it break with the original version?
In either case a short description in the patch would be nice.

> @@ -894,7 +906,7 @@ static int sd_init_command(struct scsi_cmnd *SCpn=
t)
>   		ret =3D sd_setup_discard_cmnd(sdp, rq);
>   		goto out;
>   	} else if (rq->cmd_flags & REQ_WRITE_SAME) {
> -		ret =3D sd_setup_write_same_cmnd(sdp, rq);
> +		ret =3D sd_setup_write_same_cmnd(SCpnt);
>   		goto out;
>   	} else if (rq->cmd_flags & REQ_FLUSH) {
>   		ret =3D sd_setup_flush_cmnd(SCpnt);
>

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
