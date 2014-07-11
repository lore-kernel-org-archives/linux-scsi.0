From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/10] sd: retry discard commands
Date: Fri, 11 Jul 2014 14:27:19 +0200
Message-ID: <53BFD827.8050104@suse.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-9-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbaGKM1V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 08:27:21 -0400
In-Reply-To: <1404048881-19526-9-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 06/29/2014 03:34 PM, Christoph Hellwig wrote:
> Currently cmd->allowed is initialized from rq->retries for discard
> commands, but retries is always 0 for non-BLOCK_PC requests.  Set it
> to the standard number of retries instead.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 777b141..5f85102 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -760,7 +760,7 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd=
 *cmd)
>   	blk_add_request_payload(rq, page, len);
>
>   	cmd->transfersize =3D len;
> -	cmd->allowed =3D rq->retries;
> +	cmd->allowed =3D SD_MAX_RETRIES;
>
>   	ret =3D scsi_init_io(cmd, GFP_ATOMIC);
>   	rq->__data_len =3D nr_bytes;
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
