From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH V5 10/17] scsi: ufs: manually add well known logical units
Date: Wed, 24 Sep 2014 09:36:37 -0700
Message-ID: <001101cfd815$b66e0490$234a0db0$@codeaurora.org>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org> <1411571653-22729-11-git-send-email-draviv@codeaurora.org> <20140924162444.GA20581@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20140924162444.GA20581@infradead.org>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, 'Dolev Raviv' <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Comments inline:

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Wednesday, September 24, 2014 9:25 AM
To: Dolev Raviv
Cc: James.Bottomley@HansenPartnership.com; hch@infradead.org;
linux-scsi@vger.kernel.org; linux-scsi-owner@vger.kernel.org;
linux-arm-msm@vger.kernel.org; santoshsy@gmail.com; Subhash Jadavani; Sujit
Reddy Thumma
Subject: Re: [PATCH V5 10/17] scsi: ufs: manually add well known logical
units

>  /**
> + * ufshcd_set_queue_depth - set lun queue depth
> + * @sdev: pointer to SCSI device
> + *
> + * Read bLUQueueDepth value and activate scsi tagged command
> + * queueing. For WLUN, queue depth is set to 1. For best-effort
> + * cases (bLUQueueDepth = 0) the queue depth is set to a maximum
> + * value that host can queue.
> + */
> +static void ufshcd_set_queue_depth(struct scsi_device *sdev)

I don't think this refactoring belong in here..

[Subhash] I agree, This shouldn't belong here. Will fix it in next patch.

> @@ -2152,8 +2215,6 @@ static int ufshcd_verify_dev_init(struct ufs_hba 
> *hba)  static int ufshcd_slave_alloc(struct scsi_device *sdev)  {
>  	struct ufs_hba *hba;
> -	u8 lun_qdepth;
> -	int ret;
>  
>  	hba = shost_priv(sdev->host);
>  	sdev->tagged_supported = 1;
> @@ -2168,20 +2229,8 @@ static int ufshcd_slave_alloc(struct scsi_device
*sdev)
>  	/* REPORT SUPPORTED OPERATION CODES is not supported */
>  	sdev->no_report_opcodes = 1;
>  
> -	ret = ufshcd_read_unit_desc_param(hba,
> -					  sdev->lun,
> -					  UNIT_DESC_PARAM_LU_Q_DEPTH,
> -					  &lun_qdepth,
> -					  sizeof(lun_qdepth));
> -	if (!ret || !lun_qdepth)
> -		/* eventually, we can figure out the real queue depth */
> -		lun_qdepth = hba->nutrs;
> -	else
> -		lun_qdepth = min_t(int, lun_qdepth, hba->nutrs);
>  
> -	dev_dbg(hba->dev, "%s: activate tcq with queue depth %d\n",
> -			__func__, lun_qdepth);
> -	scsi_activate_tcq(sdev, lun_qdepth);
> +	ufshcd_set_queue_depth(sdev);
>  
>  	return 0;

Addinitional all this setup really belongs into ->slave_configure.
->slave_alloc is just for allocating any needed per-LUN data structure
before scanning, while ->slave_configure is called after a LUN has finished
scanning and is made available.  That should be left for a separate patch,
though.

[Subhash] Ok, will fix it and I agree it shouldn't be part of this patch.

> +static int ufshcd_scsi_add_wlus(struct ufs_hba *hba) {
> +	int ret = 0;
> +
> +	hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
> +		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN),
NULL);
> +	if (IS_ERR(hba->sdev_ufs_device)) {
> +		ret = PTR_ERR(hba->sdev_ufs_device);
> +		hba->sdev_ufs_device = NULL;
> +		goto out;
> +	}

Where do you release these references again?  It seems like they are never
released on the device removal path.

[Subhash] That's because these are embedded/non-removable UFS devices which
are always present on the board and never get removed. Do you have any
suggestion on how we should handle this?
