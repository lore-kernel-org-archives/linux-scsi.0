From: jiangyiwen <jiangyiwen@huawei.com>
Subject: Re: [PATCH] block/sd: Return -EREMOTEIO when WRITE SAME and DISCARD
 are disabled
Date: Thu, 4 Feb 2016 17:16:26 +0800
Message-ID: <56B316EA.9090803@huawei.com>
References: <20160204042528.GA15599@redhat.com>
 <1454568483-11298-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:9497 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbcBDJQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 04:16:52 -0500
In-Reply-To: <1454568483-11298-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: snitzer@redhat.com

On 2016/2/4 14:48, Martin K. Petersen wrote:
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
>  
>  extern unsigned long blk_max_low_pfn, blk_max_pfn;
>  
> 
Hi Martin,
It is very good, I totally agree with this patch. But I have
three questions:

First, I don't understand why blk_peek_request() return EREMOTEIO,
as I know, in this situation we only prepare scsi command
without sending to device, and I think EREMOTEIO should
be returned only when IO has already sent to device, maybe
I don't understand definition of EREMOTEIO.
So, Why don't return the errno with EOPNOTSUPP?

In addition, I still worried with whether there has other
situations which will return EIO or other error. In this
way, MD/DM still can happen this type of problem, so I think
may be in multipath we still needs a protection to avoid it.

At last, I have a additional problem, I remember that you
previously send a series of patches about XCOPY, why don't
have any news latter later? I very much expect that I can
see these patches which are merged into kernel.

Thanks,
Yiwen Jiang.

