From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] block/sd: Return -EREMOTEIO when WRITE SAME and
 DISCARD are disabled
Date: Thu, 04 Feb 2016 11:36:52 -0500
Message-ID: <1454603812.22112.246.camel@localhost.localdomain>
References: <20160204042528.GA15599@redhat.com>
	 <1454568483-11298-1-git-send-email-martin.petersen@oracle.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbcBDQgx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2016 11:36:53 -0500
In-Reply-To: <1454568483-11298-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, jiangyiwen@huawei.com, snitzer@redhat.com

See below.

On Thu, 2016-02-04 at 01:48 -0500, Martin K. Petersen wrote:
> When a storage device rejects a WRITE SAME command we will disable write
> same functionality for the device and return -EREMOTEIO to the block
> layer. -EREMOTEIO will in turn prevent DM from retrying the I/O and/or
> failing the path.
> 
> Yiwen Jiang discovered a small race where WRITE SAME requests issued
> simultaneously would cause -EIO to be returned. This happened because
> any requests being prepared after WRITE SAME had been disabled for the
> device caused us to return BLKPREP_KILL. The latter caused the block
> layer to return -EIO upon completion.
> 
> To overcome this we introduce BLKPREP_INVALID which indicates that this
> is an invalid request for the device. blk_peek_request() is modified to
> return -EREMOTEIO in that case.
> 
> Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Suggested-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> ---
> 
> I contemplated making blk_peek_request() use rq->errors to decide what
> to return up the stack. However, I cringed at mixing errnos and SCSI
> midlayer status information in the same location.
> ---
>  block/blk-core.c       | 6 ++++--
>  drivers/scsi/sd.c      | 4 ++--
>  include/linux/blkdev.h | 9 ++++++---
>  3 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 33e2f62d5062..ee833af2f892 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2446,14 +2446,16 @@ struct request *blk_peek_request(struct request_queue *q)
>  
>  			rq = NULL;
>  			break;
> -		} else if (ret == BLKPREP_KILL) {
> +		} else if (ret == BLKPREP_KILL || ret == BLKPREP_INVALID) {
> +			int err = ret == BLKPREP_INVALID ? -EREMOTEIO : -EIO;

Maybe it's unnecessary, but I would put parenthesis around (ret == ... -EIO); for clarity.

> +
>  			rq->cmd_flags |= REQ_QUIET;
>  			/*
>  			 * Mark this request as started so we don't trigger
>  			 * any debug logic in the end I/O path.
>  			 */
>  			blk_start_request(rq);
> -			__blk_end_request_all(rq, -EIO);
> +			__blk_end_request_all(rq, err);
>  		} else {
>  			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
>  			break;
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ec163d08f6c3..6e841c6da632 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -761,7 +761,7 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
>  		break;
>  
>  	default:
> -		ret = BLKPREP_KILL;
> +		ret = BLKPREP_INVALID;
>  		goto out;
>  	}
>  
> @@ -839,7 +839,7 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
>  	int ret;
>  
>  	if (sdkp->device->no_write_same)
> -		return BLKPREP_KILL;
> +		return BLKPREP_INVALID;
>  
>  	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len != sdp->sector_size);
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c70e3588a48c..e990d181625a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -680,9 +680,12 @@ static inline bool blk_write_same_mergeable(struct bio *a, struct bio *b)
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

I would prefer that additional enum/constant values be added to the end
of the series, here you are changing the ordinal value of BLKPREP_DEFER
from 2 to 3.  Could you swap these?

>  extern unsigned long blk_max_low_pfn, blk_max_pfn;
>  

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


