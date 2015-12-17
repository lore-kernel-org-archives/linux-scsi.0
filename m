From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/3] sd: Reject optimal transfer length smaller than page
 size
Date: Wed, 16 Dec 2015 19:55:10 -0500
Message-ID: <567207EE.5050508@interlog.com>
References: <1450306433-20166-1-git-send-email-martin.petersen@oracle.com>
 <1450306433-20166-2-git-send-email-martin.petersen@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49456 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbbLQAzY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2015 19:55:24 -0500
In-Reply-To: <1450306433-20166-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On 15-12-16 05:53 PM, Martin K. Petersen wrote:
> Eryu Guan reported that loading scsi_debug would fail. This turned out
> to be caused by scsi_debug reporting an optimal I/O size of 32KB which
> is smaller than the 64KB page size on the PowerPC system in question.
>
> Add a check to ensure that we only use the device-reported OPTIMAL
> TRANSFER LENGTH if it is bigger than or equal to the page cache size.
>
> Reported-by: Eryu Guan <guaneryu@gmail.com>
> Reported-by: Ming Lei <tom.leiming@gmail.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   drivers/scsi/sd.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3d22fc3e3c1a..4e08d1cd704d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2885,10 +2885,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
>
>   	/*
>   	 * Use the device's preferred I/O size for reads and writes
> -	 * unless the reported value is unreasonably large (or garbage).
> +	 * unless the reported value is unreasonably small, large, or
> +	 * garbage.
>   	 */
> -	if (sdkp->opt_xfer_blocks && sdkp->opt_xfer_blocks <= dev_max &&
> -	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS)
> +	if (sdkp->opt_xfer_blocks &&
> +	    sdkp->opt_xfer_blocks <= dev_max &&
> +	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
> +	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_CACHE_SIZE)
>   		rw_max = q->limits.io_opt =
>   			logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
>   	else
>
and following that 'else' is:
                 rw_max = BLK_DEF_MAX_SECTORS;

and blkdev.h says:

enum blk_default_limits {
         BLK_MAX_SEGMENTS        = 128,
         BLK_SAFE_MAX_SECTORS    = 255,
         BLK_DEF_MAX_SECTORS     = 2560,
         BLK_MAX_SEGMENT_SIZE    = 65536,
         BLK_SEG_BOUNDARY_MASK   = 0xFFFFFFFFUL,
};


Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>

