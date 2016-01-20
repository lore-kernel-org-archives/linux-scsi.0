From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Wed, 20 Jan 2016 08:19:25 -0800
Message-ID: <1453306765.2341.11.camel@HansenPartnership.com>
References: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58786 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934241AbcATQT0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 11:19:26 -0500
In-Reply-To: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: borntraeger@de.ibm.com

On Wed, 2016-01-20 at 11:01 -0500, Martin K. Petersen wrote:
> Commit ca369d51b3e1 ("block/sd: Fix device-imposed transfer length
> limits") accidentally switched optimal I/O size reporting from bytes
> to
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
> @@ -2893,7 +2893,7 @@ static int sd_revalidate_disk(struct gendisk
> *disk)
>  	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
>  	    sdkp->opt_xfer_blocks * sdp->sector_size >=
> PAGE_CACHE_SIZE)
>  		rw_max = q->limits.io_opt =
> -			logical_to_sectors(sdp, sdkp
> ->opt_xfer_blocks);
> +			sdkp->opt_xfer_blocks * sdp->sector_size;
>  	else
>  		rw_max = BLK_DEF_MAX_SECTORS;
>  

We should mark the commit causing the problems, which went into 4.4 if
I remember correctly:

Fixes: ca369d51b3e1649be4a72addd6d6a168cfb3f537
Cc: stable@vger.kernel.org # 4.4+
Reviewed-by: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>

James
