From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/10] sd: retry write same commands
Date: Fri, 11 Jul 2014 14:26:57 +0200
Message-ID: <53BFD811.4040909@suse.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbaGKM06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 08:26:58 -0400
In-Reply-To: <1404048881-19526-8-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 06/29/2014 03:34 PM, Christoph Hellwig wrote:
> Currently cmd->allowed is initialized from rq->retries for write same
> commands, but retries is always 0 for non-BLOCK_PC requests.  Set it
> to the standard number of retries instead.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 9737e78..777b141 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -843,7 +843,7 @@ static int sd_setup_write_same_cmnd(struct scsi_c=
mnd *cmd)
>   	}
>
>   	cmd->transfersize =3D sdp->sector_size;
> -	cmd->allowed =3D rq->retries;
> +	cmd->allowed =3D SD_MAX_RETRIES;
>
>   	/*
>   	 * For WRITE_SAME the data transferred in the DATA IN buffer is
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
