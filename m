From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Wed, 20 Jan 2016 12:17:15 -0500
Message-ID: <1453310235.22112.115.camel@localhost.localdomain>
References: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934940AbcATRRQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 12:17:16 -0500
In-Reply-To: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, borntraeger@de.ibm.com

On Wed, 2016-01-20 at 11:01 -0500, Martin K. Petersen wrote:
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
>  	else
>  		rw_max = BLK_DEF_MAX_SECTORS;
>  

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


