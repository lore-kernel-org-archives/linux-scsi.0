From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/1] scsi: Fix max transfer length for 4k disks
Date: Fri, 30 Jan 2015 00:09:56 +0100
Message-ID: <54CABDC4.9000404@redhat.com>
References: <201501292155.t0TLt4qF025739@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52813 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbA2XKB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 18:10:01 -0500
In-Reply-To: <201501292155.t0TLt4qF025739@d01av05.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, stable@vger.kernel.org



On 29/01/2015 22:54, Brian King wrote:
> The following patch fixes an issue observed with 4k sector disks
> where the max_hw_sectors attribute was getting set too large in
> sd_revalidate_disk. Since sdkp->max_xfer_blocks is in units
> of SCSI logical blocks and queue_max_hw_sectors is in units of
> 512 byte blocks, on a 4k sector disk, every time we went through
> sd_revalidate_disk, we were taking the current value of
> queue_max_hw_sectors and increasing it by a factor of 8. Fix
> this by only shifting sdkp->max_xfer_blocks.
> 
> Cc: stable<stable@vger.kernel.org>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/sd.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/scsi/sd.c~sd_revalidate_4k drivers/scsi/sd.c
> --- linux/drivers/scsi/sd.c~sd_revalidate_4k	2015-01-29 14:44:23.316171187 -0600
> +++ linux-bjking1/drivers/scsi/sd.c	2015-01-29 14:51:05.846126392 -0600
> @@ -2800,9 +2800,11 @@ static int sd_revalidate_disk(struct gen
>  	 */
>  	sd_set_flush_flag(sdkp);
>  
> -	max_xfer = min_not_zero(queue_max_hw_sectors(sdkp->disk->queue),
> -				sdkp->max_xfer_blocks);
> +	max_xfer = sdkp->max_xfer_blocks;
>  	max_xfer <<= ilog2(sdp->sector_size) - 9;
> +
> +	max_xfer = min_not_zero(queue_max_hw_sectors(sdkp->disk->queue),
> +				max_xfer);
>  	blk_queue_max_hw_sectors(sdkp->disk->queue, max_xfer);
>  	set_capacity(disk, sdkp->capacity);
>  	sd_config_write_same(sdkp);
> _
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
