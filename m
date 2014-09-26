From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V6 02/18] scsi: sysfs: don't add scsi_device if its
 already added
Date: Fri, 26 Sep 2014 01:14:34 -0700
Message-ID: <20140926081434.GB22805@infradead.org>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
 <1411648356-3883-3-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411648356-3883-3-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Looks fine to me, just want a cross check from Martin or Hannes.

On Thu, Sep 25, 2014 at 03:32:20PM +0300, Dolev Raviv wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> If LLD has added scsi device (by calling scsi_add_device) before scheduling
> async scsi_scan_host then scsi_finish_async_scan() will end up calling
> scsi_sysfs_add_sdev for scsi device which was already added by LLD.
> This patch fixes this issue by skipping the call to scsi_sysfs_add_sdev()
> if it's already visible to rest of the kernel.
> 
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 1095d5a..c6c5716 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1746,6 +1746,9 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
>  		/* target removed before the device could be added */
>  		if (sdev->sdev_state == SDEV_DEL)
>  			continue;
> +		/* If device is already visible, skip adding it to sysfs */
> +		if (sdev->is_visible)
> +			continue;
>  		if (!scsi_host_scan_allowed(shost) ||
>  		    scsi_sysfs_add_sdev(sdev) != 0)
>  			__scsi_remove_device(sdev);
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
