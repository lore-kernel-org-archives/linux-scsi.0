From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/10] scsi: move the nr_phys_segments assert into scsi_init_io
Date: Fri, 11 Jul 2014 14:17:10 +0200
Message-ID: <53BFD5C6.10801@suse.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbaGKMRM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 08:17:12 -0400
In-Reply-To: <1404048881-19526-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 06/29/2014 03:34 PM, Christoph Hellwig wrote:
> scsi_init_io should only be called for requests that transfer data,
> so move the assert that a request has segments from the callers into
> scsi_init_io.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c |   16 +++++-----------
>   1 file changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 37038fb..b505b06 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -996,8 +996,11 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gf=
p_mask)
>   {
>   	struct scsi_device *sdev =3D cmd->device;
>   	struct request *rq =3D cmd->request;
> +	int error;
>
> -	int error =3D scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
> +	BUG_ON(!rq->nr_phys_segments);
> +
> +	error =3D scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
>   	if (error)
>   		goto err_exit;
>
> @@ -1088,11 +1091,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device =
*sdev, struct request *req)
>   	 * submit a request without an attached bio.
>   	 */
>   	if (req->bio) {
> -		int ret;
> -
> -		BUG_ON(!req->nr_phys_segments);
> -
> -		ret =3D scsi_init_io(cmd, GFP_ATOMIC);
> +		int ret =3D scsi_init_io(cmd, GFP_ATOMIC);
>   		if (unlikely(ret))
>   			return ret;
>   	} else {
> @@ -1131,11 +1130,6 @@ int scsi_setup_fs_cmnd(struct scsi_device *sde=
v, struct request *req)
>   			return ret;
>   	}
>
> -	/*
> -	 * Filesystem requests must transfer data.
> -	 */
> -	BUG_ON(!req->nr_phys_segments);
> -
>   	memset(cmd->cmnd, 0, BLK_MAX_CDB);
>   	return scsi_init_io(cmd, GFP_ATOMIC);
>   }
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
