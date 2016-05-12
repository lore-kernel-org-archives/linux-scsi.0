From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Thu, 12 May 2016 12:04:33 +0800
Message-ID: <20160512040433.GA20240@ad.usersys.redhat.com>
References: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbcELEEd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 May 2016 00:04:33 -0400
Content-Disposition: inline
In-Reply-To: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, borntraeger@de.ibm.com

On Wed, 01/20 11:01, Martin K. Petersen wrote:
> Commit ca369d51b3e1 ("block/sd: Fix device-imposed transfer length
> limits") accidentally switched optimal I/O size reporting from bytes to
> block layer sectors.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  drivers/scsi/sd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4e08d1cd704d..ec163d08f6c3 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2893,7 +2893,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
>  	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_CACHE_SIZE)
>  		rw_max = q->limits.io_opt =
> -			logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
> +			sdkp->opt_xfer_blocks * sdp->sector_size;

Hi Martin,

This looks wrong to me, maybe I'm missing the obvious? Here
sdkp->opt_xfer_blocks is in block size unit, and rw_max is in byte unit.

Following is:

	else
		rw_max = BLK_DEF_MAX_SECTORS;

Which seems in sector unit, and is already making above change suspicious, and
further down:

	/* Combine with controller limits */
	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));

looks like a unit mismatch to me.  IIUC q->limits.max_sectors _is_ in sector
unit, similar to queue_max_hw_sectors().

Is the error reported by Christian fixed just because we are setting an
incorrect high max?

(I noticed this when I see I/O error because a virtio-scsi guest starts to
issue large reads that are rejected by host device.)

Fam
