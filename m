From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4 11/17] scsi: ufs: add UFS power management support
Date: Tue, 23 Sep 2014 03:14:51 -0700
Message-ID: <20140923101451.GA11623@infradead.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
 <1411457499-8074-12-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbaIWKOw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2014 06:14:52 -0400
Content-Disposition: inline
In-Reply-To: <1411457499-8074-12-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>

>  /**
>   * ufshcd_slave_alloc - handle initial SCSI device configurations
>   * @sdev: pointer to SCSI device
> @@ -2232,6 +2403,21 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
>  
>  	ufshcd_set_queue_depth(sdev);
>  
> +	ufshcd_get_lu_power_on_wp_status(hba, sdev);
> +
> +	/*
> +	 * For selecting the UFS device power mode (Active / UFS_Sleep /
> +	 * UFS_PowerDown), SCSI power management command (START STOP UNIT)
> +	 * needs to be sent to a "UFS device" Well known Logical Unit (W-LU).
> +	 * As this command would be sent during the UFS host controller
> +	 * runtime/system PM callbacks, we need a reference to "scsi_device"
> +	 * associated to "UFS device" W-LU. This change saves the "scsi_device"
> +	 * reference for "UFS device" W-LU during slave_configure() callback
> +	 * from SCSI mid layer.
> +	 */
> +	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN)
> +		hba->sdev_ufs_device = sdev;
> +

Storing the pointer in slave_alloc is not safe as you don't known if the
probing was successful.  In addition you really need a reference to a
scsi_device that you store somewhere as a user could easily delete the
device through sysfs, which any access to it invalid.

As mention earlier you should just add this wlun using __scsi_device_add
which gives you a pointer and a reference to the fully probed device.

> +static int
> +ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
> +{
> +	unsigned char cmd[6] = {REQUEST_SENSE,
> +				0,
> +				0,
> +				0,
> +				SCSI_SENSE_BUFFERSIZE,
> +				0};
> +	char *buffer;
> +	int ret;
> +
> +	buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
> +	if (!buffer) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = scsi_execute_req_flags(sdp, cmd, DMA_FROM_DEVICE, buffer,
> +				SCSI_SENSE_BUFFERSIZE, NULL,
> +				msecs_to_jiffies(1000), 3, NULL, REQ_PM);
> +	if (ret)
> +		pr_err("%s: failed with err %d\n", __func__, ret);
> +
> +	kfree(buffer);
> +out:
> +	return ret;
> +}

It would be good to have an explanation why you need to call
REQUEST SENSE from the driver.  OR your own START STOP later one.  This
all seems very much against the normal model of operation for SCSI
devices.

