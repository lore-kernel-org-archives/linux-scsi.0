From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 01/17] scsi: fixing the "type" for well known LUs
Date: Wed, 24 Sep 2014 09:04:30 -0700
Message-ID: <20140924160430.GA13541@infradead.org>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org>
 <1411571653-22729-2-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411571653-22729-2-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <elliott@hp.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 24, 2014 at 06:13:57PM +0300, Dolev Raviv wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> Some devices may respond with wrong type for well-known logical units.
> This patch forces well-known type for devices which doesn't report it
> correct.

This looks fine to me, as the well known LUN addresses seem to be nailed
down nicely in t10, but let's see if Martin or Robert disagree..

> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 56675db..a34db9e 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -805,6 +805,14 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  	} else {
>  		sdev->type = (inq_result[0] & 0x1f);
>  		sdev->removable = (inq_result[1] & 0x80) >> 7;
> +
> +		/*
> +		 * some devices may respond with wrong type for
> +		 * well-known logical units. Force well-known type
> +		 * to enumerate them correctly.
> +		 */
> +		if (scsi_is_wlun(sdev->lun))
> +			sdev->type = TYPE_WLUN;
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
