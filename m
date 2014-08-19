From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 09/10] scsi: sd: Avoid sending medium write commands if
 device is write protected
Date: Tue, 19 Aug 2014 10:30:22 -0700
Message-ID: <20140819173022.GA2072@infradead.org>
References: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
 <1407760838-6406-10-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1407760838-6406-10-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

This looks reasonable to me.  Martin, and objections?

On Mon, Aug 11, 2014 at 03:40:37PM +0300, Dolev Raviv wrote:
> From: Sujit Reddy Thumma <sthumma@codeaurora.org>
> 
> The SYNCHRONIZE_CACHE command is a medium write command and hence can
> fail when the device is write protected. Avoid sending such commands by
> making sure that write-cache-enable is disabled even though the device
> claim to support it.
> 
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3663e38..67282bf 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -185,7 +185,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
>  	if (ct < 0)
>  		return -EINVAL;
>  	rcd = ct & 0x01 ? 1 : 0;
> -	wce = ct & 0x02 ? 1 : 0;
> +	wce = (ct & 0x02) && !sdkp->write_prot ? 1 : 0;
>  
>  	if (sdkp->cache_override) {
>  		sdkp->WCE = wce;
> @@ -2493,6 +2493,10 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>  			sdkp->DPOFUA = 0;
>  		}
>  
> +		/* No cache flush allowed for write protected devices */
> +		if (sdkp->WCE && sdkp->write_prot)
> +			sdkp->WCE = 0;
> +
>  		if (sdkp->first_scan || old_wce != sdkp->WCE ||
>  		    old_rcd != sdkp->RCD || old_dpofua != sdkp->DPOFUA)
>  			sd_printk(KERN_NOTICE, sdkp,
> -- 
> 1.8.5.2
> -- 
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
