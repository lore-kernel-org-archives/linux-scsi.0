From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/14] sd: don't use rq->cmd_len before setting it up
Date: Wed, 09 Jul 2014 13:12:34 +0200
Message-ID: <53BD23A2.4030902@suse.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbaGILMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2014 07:12:36 -0400
In-Reply-To: <1403715121-1201-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 06/25/2014 06:51 PM, Christoph Hellwig wrote:
> Unlike the old request code blk-mq doesn't initialize cmd_len with a
> default value, so don't rely on it being set in sd_setup_write_same_c=
mnd.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 9c86e3d..6ec4ffe 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -824,15 +824,16 @@ static int sd_setup_write_same_cmnd(struct scsi=
_device *sdp, struct request *rq)
>
>   	rq->__data_len =3D sdp->sector_size;
>   	rq->timeout =3D SD_WRITE_SAME_TIMEOUT;
> -	memset(rq->cmd, 0, rq->cmd_len);
>
>   	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff) {
>   		rq->cmd_len =3D 16;
> +		memset(rq->cmd, 0, rq->cmd_len);
>   		rq->cmd[0] =3D WRITE_SAME_16;
>   		put_unaligned_be64(sector, &rq->cmd[2]);
>   		put_unaligned_be32(nr_sectors, &rq->cmd[10]);
>   	} else {
>   		rq->cmd_len =3D 10;
> +		memset(rq->cmd, 0, rq->cmd_len);
>   		rq->cmd[0] =3D WRITE_SAME;
>   		put_unaligned_be32(sector, &rq->cmd[2]);
>   		put_unaligned_be16(nr_sectors, &rq->cmd[7]);
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
