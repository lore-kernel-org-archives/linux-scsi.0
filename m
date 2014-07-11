From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/10] scsi: restructure command initialization for TYPE_FS
 requests
Date: Fri, 11 Jul 2014 14:18:16 +0200
Message-ID: <53BFD608.6040509@suse.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaGKMSS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 08:18:18 -0400
In-Reply-To: <1404048881-19526-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 06/29/2014 03:34 PM, Christoph Hellwig wrote:
> We should call the device handler prep_fn for all TYPE_FS requests,
> not just simple read/write calls that are handled by the disk driver.
>
> Restructure the common I/O code to call the prep_fn handler and zero
> out the CDB, and just leave the call to scsi_init_io to the ULDs.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c    |   22 ++++++++++++----------
>   drivers/scsi/sd.c          |    2 +-
>   drivers/scsi/sr.c          |    3 +--
>   include/scsi/scsi_driver.h |    1 -
>   4 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b505b06..bc84811 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1115,11 +1115,10 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device=
 *sdev, struct request *req)
>   EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
>
>   /*
> - * Setup a REQ_TYPE_FS command.  These are simple read/write request
> - * from filesystems that still need to be translated to SCSI CDBs fr=
om
> - * the ULD.
> + * Setup a REQ_TYPE_FS command.  These are simple request from files=
ystems
> + * that still need to be translated to SCSI CDBs from the ULD.
>    */
> -int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req=
)
> +static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct reque=
st *req)
>   {
>   	struct scsi_cmnd *cmd =3D req->special;
>
> @@ -1131,9 +1130,8 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev=
, struct request *req)
>   	}
>
>   	memset(cmd->cmnd, 0, BLK_MAX_CDB);
> -	return scsi_init_io(cmd, GFP_ATOMIC);
> +	return scsi_cmd_to_driver(cmd)->init_command(cmd);
>   }
> -EXPORT_SYMBOL(scsi_setup_fs_cmnd);
>
>   static int
>   scsi_prep_state_check(struct scsi_device *sdev, struct request *req=
)
> @@ -1238,12 +1236,16 @@ static int scsi_prep_fn(struct request_queue =
*q, struct request *req)
>   		goto out;
>   	}
>
> -	if (req->cmd_type =3D=3D REQ_TYPE_FS)
> -		ret =3D scsi_cmd_to_driver(cmd)->init_command(cmd);
> -	else if (req->cmd_type =3D=3D REQ_TYPE_BLOCK_PC)
> +	switch (req->cmd_type) {
> +	case REQ_TYPE_FS:
> +		ret =3D scsi_setup_fs_cmnd(sdev, req);
> +		break;
> +	case REQ_TYPE_BLOCK_PC:
>   		ret =3D scsi_setup_blk_pc_cmnd(sdev, req);
> -	else
> +		break;
> +	default:
>   		ret =3D BLKPREP_KILL;
> +	}
>
>   out:
>   	return scsi_prep_return(q, req, ret);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 9c86e3d..001b3e8 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -894,7 +894,7 @@ static int sd_init_command(struct scsi_cmnd *SCpn=
t)
>   		ret =3D scsi_setup_flush_cmnd(sdp, rq);
>   		goto out;
>   	}
> -	ret =3D scsi_setup_fs_cmnd(sdp, rq);
> +	ret =3D scsi_init_io(SCpnt, GFP_ATOMIC);
>   	if (ret !=3D BLKPREP_OK)
>   		goto out;
>   	SCpnt =3D rq->special;
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index a7ea27c..9feeb37 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -385,10 +385,9 @@ static int sr_init_command(struct scsi_cmnd *SCp=
nt)
>   	int block =3D 0, this_count, s_size;
>   	struct scsi_cd *cd;
>   	struct request *rq =3D SCpnt->request;
> -	struct scsi_device *sdp =3D SCpnt->device;
>   	int ret;
>
> -	ret =3D scsi_setup_fs_cmnd(sdp, rq);
> +	ret =3D scsi_init_io(SCpnt, GFP_ATOMIC);
>   	if (ret !=3D BLKPREP_OK)
>   		goto out;
>   	SCpnt =3D rq->special;
> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> index 36c4114..009d2ae 100644
> --- a/include/scsi/scsi_driver.h
> +++ b/include/scsi/scsi_driver.h
> @@ -30,6 +30,5 @@ extern int scsi_register_interface(struct class_int=
erface *);
>   	class_interface_unregister(intf)
>
>   int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request=
 *req);
> -int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req=
);
>
>   #endif /* _SCSI_SCSI_DRIVER_H */
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
