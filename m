From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] block/sd: Return -EREMOTEIO when WRITE SAME and DISCARD
 are disabled
Date: Thu, 4 Feb 2016 15:14:13 +0100
Message-ID: <56B35CB5.9000405@suse.de>
References: <20160204042528.GA15599@redhat.com>
 <1454568483-11298-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965633AbcBDOOQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2016 09:14:16 -0500
In-Reply-To: <1454568483-11298-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: jiangyiwen@huawei.com, snitzer@redhat.com

On 02/04/2016 07:48 AM, Martin K. Petersen wrote:
> When a storage device rejects a WRITE SAME command we will disable wr=
ite
> same functionality for the device and return -EREMOTEIO to the block
> layer. -EREMOTEIO will in turn prevent DM from retrying the I/O and/o=
r
> failing the path.
>=20
> Yiwen Jiang discovered a small race where WRITE SAME requests issued
> simultaneously would cause -EIO to be returned. This happened because
> any requests being prepared after WRITE SAME had been disabled for th=
e
> device caused us to return BLKPREP_KILL. The latter caused the block
> layer to return -EIO upon completion.
>=20
> To overcome this we introduce BLKPREP_INVALID which indicates that th=
is
> is an invalid request for the device. blk_peek_request() is modified =
to
> return -EREMOTEIO in that case.
>=20
> Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Suggested-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>=20
> ---
>=20
> I contemplated making blk_peek_request() use rq->errors to decide wha=
t
> to return up the stack. However, I cringed at mixing errnos and SCSI
> midlayer status information in the same location.

Well, rq->errors has a mixed heritage anyway; occasionally it's an
errno, sometimes a SCSI midlayer status, you name it.
One should clean it up eventually ...

> ---
>  block/blk-core.c       | 6 ++++--
>  drivers/scsi/sd.c      | 4 ++--
>  include/linux/blkdev.h | 9 ++++++---
>  3 files changed, 12 insertions(+), 7 deletions(-)
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 33e2f62d5062..ee833af2f892 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2446,14 +2446,16 @@ struct request *blk_peek_request(struct reque=
st_queue *q)
> =20
>  			rq =3D NULL;
>  			break;
> -		} else if (ret =3D=3D BLKPREP_KILL) {
> +		} else if (ret =3D=3D BLKPREP_KILL || ret =3D=3D BLKPREP_INVALID) =
{
> +			int err =3D ret =3D=3D BLKPREP_INVALID ? -EREMOTEIO : -EIO;
> +
>  			rq->cmd_flags |=3D REQ_QUIET;
>  			/*
>  			 * Mark this request as started so we don't trigger
>  			 * any debug logic in the end I/O path.
>  			 */
>  			blk_start_request(rq);
> -			__blk_end_request_all(rq, -EIO);
> +			__blk_end_request_all(rq, err);
>  		} else {
>  			printk(KERN_ERR "%s: bad return=3D%d\n", __func__, ret);
>  			break;
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ec163d08f6c3..6e841c6da632 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -761,7 +761,7 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd=
 *cmd)
>  		break;
> =20
>  	default:
> -		ret =3D BLKPREP_KILL;
> +		ret =3D BLKPREP_INVALID;
>  		goto out;
>  	}
> =20
> @@ -839,7 +839,7 @@ static int sd_setup_write_same_cmnd(struct scsi_c=
mnd *cmd)
>  	int ret;
> =20
>  	if (sdkp->device->no_write_same)
> -		return BLKPREP_KILL;
> +		return BLKPREP_INVALID;
> =20
>  	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len !=3D sdp->sector_si=
ze);
> =20
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c70e3588a48c..e990d181625a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -680,9 +680,12 @@ static inline bool blk_write_same_mergeable(stru=
ct bio *a, struct bio *b)
>  /*
>   * q->prep_rq_fn return values
>   */
> -#define BLKPREP_OK		0	/* serve it */
> -#define BLKPREP_KILL		1	/* fatal error, kill */
> -#define BLKPREP_DEFER		2	/* leave on queue */
> +enum {
> +	BLKPREP_OK,		/* serve it */
> +	BLKPREP_KILL,		/* fatal error, kill, return -EIO */
> +	BLKPREP_INVALID,	/* invalid command, kill, return -EREMOTEIO */
> +	BLKPREP_DEFER,		/* leave on queue */
> +};
> =20
>  extern unsigned long blk_max_low_pfn, blk_max_pfn;
> =20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
