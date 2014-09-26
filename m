From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V6 01/18] scsi: fixing the "type" for well known LUs
Date: Fri, 26 Sep 2014 01:13:43 -0700
Message-ID: <20140926081343.GA22805@infradead.org>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
 <1411648356-3883-2-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49735 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbaIZINn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2014 04:13:43 -0400
Content-Disposition: inline
In-Reply-To: <1411648356-3883-2-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Robert, I guess this version is okay with you?

On Thu, Sep 25, 2014 at 03:32:19PM +0300, Dolev Raviv wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> Some devices may respond with wrong type for well-known logical units.
> This patch forces well-known type for devices which doesn't report it
> correct.
> 
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 56675db..1095d5a 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -805,6 +805,19 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  	} else {
>  		sdev->type = (inq_result[0] & 0x1f);
>  		sdev->removable = (inq_result[1] & 0x80) >> 7;
> +
> +		/*
> +		 * some devices may respond with wrong type for
> +		 * well-known logical units. Force well-known type
> +		 * to enumerate them correctly.
> +		 */
> +		if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
> +			sdev_printk(KERN_WARNING, sdev,
> +				"%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16phN\n",
> +				__func__, sdev->type, sdev->lun);
> +			sdev->type = TYPE_WLUN;
> +		}
> +
>  	}
>  
>  	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 261e708..d17178e 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -333,6 +333,7 @@ static inline int scsi_status_is_good(int status)
>  #define TYPE_RBC	    0x0e
>  #define TYPE_OSD            0x11
>  #define TYPE_ZBC            0x14
> +#define TYPE_WLUN           0x1e    /* well-known logical unit */
>  #define TYPE_NO_LUN         0x7f
>  
>  /* SCSI protocols; these are taken from SPC-3 section 7.5 */
> -- 
> 1.8.5.2
> -- 
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
