From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH] Use the correct size to set block max sectors
Date: Fri, 27 May 2016 08:40:13 +0800
Message-ID: <20160527004013.GH31052@ad.usersys.redhat.com>
References: <1464307708-4315-1-git-send-email-longli@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464307708-4315-1-git-send-email-longli@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, KY Srinivasan <kys@microsoft.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 05/26 17:08, Long Li wrote:
> The block sector size should be in unit of 512 bytes, not in bytes.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> 
> ---
>  drivers/scsi/sd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 428c03e..4bce17e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2862,9 +2862,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	if (sdkp->opt_xfer_blocks &&
>  	    sdkp->opt_xfer_blocks <= dev_max &&
>  	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
> -	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_SIZE)
> -		rw_max = q->limits.io_opt =
> +	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_SIZE) {
> +		q->limits.io_opt =
>  			sdkp->opt_xfer_blocks * sdp->sector_size;
> +		rw_max = (q->limits.io_opt >> 9);

Other than the superfluous parenthesis, looks good to me.

Fam

> +	}
>  	else
>  		rw_max = BLK_DEF_MAX_SECTORS;
>  
> -- 
> 1.8.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
