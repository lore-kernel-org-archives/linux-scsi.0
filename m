Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075F0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 18:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF016105A
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 18:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhJESyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 14:54:21 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:38655 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhJESyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 14:54:20 -0400
Received: by mail-pl1-f179.google.com with SMTP id x4so96161pln.5
        for <linux-scsi@vger.kernel.org>; Tue, 05 Oct 2021 11:52:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uPwU+RA+zaY9foLTizeR7ar/M3njZdDtRQOkNDlX7g4=;
        b=UG3MtF5l/qb601xSIMX7XjRx88n7QUQHam9IykNWMUh1Rsd7lmrmWVMbs1yT/39/J8
         KswkESw31O52yPvQPvq2Szs2kyOt4lNRd0Fe9Dl3iZU64V+E/VPCo/0HSL+y5lVOywi5
         irh3H4lh6M+pAaojR4Gbq2z4SKzXXhkOAPzjlfaq5hQf+QUuXJ65kdzjCn5Psm90XRB1
         dFgl+xRvlcEznRX6p8gQQG8wLLl+AUJXYsoAZ2Qiplb8P3ezET1tkgSFJOHD7/gVsAY2
         J9NFUrutqq5mAFKr1ihSigh7t3TaCn0puLHTE6fDuTQa86XYzok2o/7e22KFLAyrPf86
         UyZw==
X-Gm-Message-State: AOAM530RpGihB+6+tec0G2mv0zhRE7H5W4EOadXiBm8CUtL/L3oa2NCL
        2eZx8m3XI/Jnhuf/6L6lKZv+yAyL3R8=
X-Google-Smtp-Source: ABdhPJyNx88EXCzpyK1EVFFROS6bKJqfuf4zju916VRfoRUj+ZbzCX7FAQ2v5V94CHAGmkjR2gy6QA==
X-Received: by 2002:a17:90b:b15:: with SMTP id bf21mr5865974pjb.32.1633459948822;
        Tue, 05 Oct 2021 11:52:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:e8fc:af57:dd49:3964])
        by smtp.gmail.com with ESMTPSA id t1sm17499921pgf.78.2021.10.05.11.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 11:52:28 -0700 (PDT)
Subject: Re: [PATCH V7 1/2] scsi: ufs: Fix runtime PM dependencies getting
 broken
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20211005134445.234671-1-adrian.hunter@intel.com>
 <20211005134445.234671-2-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <dcb1c627-1431-8437-7a02-e5d74a3f3b70@acm.org>
Date:   Tue, 5 Oct 2021 11:52:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211005134445.234671-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/21 6:44 AM, Adrian Hunter wrote:
> UFS SCSI devices make use of device links to establish PM dependencies.
> However, SCSI PM will force devices' runtime PM state to be active during
> system resume. That can break runtime PM dependencies for UFS devices.
> Fix by adding a flag 'preserve_rpm' to let UFS SCSI devices opt-out of
> the unwanted behaviour.
> 
> Fixes: b294ff3e34490f ("scsi: ufs: core: Enable power management for wlun")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   drivers/scsi/scsi_pm.c     | 16 +++++++++++-----
>   drivers/scsi/ufs/ufshcd.c  |  1 +
>   include/scsi/scsi_device.h |  1 +
>   3 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index 3717eea37ecb..0557c1ad304d 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -73,13 +73,22 @@ static int scsi_dev_type_resume(struct device *dev,
>   		int (*cb)(struct device *, const struct dev_pm_ops *))
>   {
>   	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +	struct scsi_device *sdev = NULL;
> +	bool preserve_rpm = false;
>   	int err = 0;
>   
> +	if (scsi_is_sdev_device(dev)) {
> +		sdev = to_scsi_device(dev);
> +		preserve_rpm = sdev->preserve_rpm;
> +		if (preserve_rpm && pm_runtime_suspended(dev))
> +			return 0;
> +	}
> +
>   	err = cb(dev, pm);
>   	scsi_device_resume(to_scsi_device(dev));
>   	dev_dbg(dev, "scsi resume: %d\n", err);
>   
> -	if (err == 0) {
> +	if (err == 0 && !preserve_rpm) {
>   		pm_runtime_disable(dev);
>   		err = pm_runtime_set_active(dev);
>   		pm_runtime_enable(dev);
> @@ -91,11 +100,8 @@ static int scsi_dev_type_resume(struct device *dev,
>   		 *
>   		 * The resume hook will correct runtime PM status of the disk.
>   		 */
> -		if (!err && scsi_is_sdev_device(dev)) {
> -			struct scsi_device *sdev = to_scsi_device(dev);
> -
> +		if (!err && sdev)
>   			blk_set_runtime_active(sdev->request_queue);
> -		}
>   	}
>   
>   	return err;
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d91a405fd181..b70f566f7f8a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5016,6 +5016,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
>   		pm_runtime_get_noresume(&sdev->sdev_gendev);
>   	else if (ufshcd_is_rpm_autosuspend_allowed(hba))
>   		sdev->rpm_autosuspend = 1;
> +	sdev->preserve_rpm = 1;
>   
>   	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
>   
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 09a17f6e93a7..47eb30a6b7b2 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -197,6 +197,7 @@ struct scsi_device {
>   	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
>   	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
>   	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
> +	unsigned preserve_rpm:1;	/* Preserve runtime PM */
>   	unsigned security_supported:1;	/* Supports Security Protocols */
>   	unsigned is_visible:1;	/* is the device visible in sysfs */
>   	unsigned wce_default_on:1;	/* Cache is ON by default */

So a new flag is added in struct scsi_device and that flag is only used by
the UFS driver? I'm less than enthusiast about this patch. I think that the
SCSI core needs to be modified such that system suspend and resume is
separated from runtime suspend and resume. The following code:

	if (err == 0) {
		pm_runtime_disable(dev);
		err = pm_runtime_set_active(dev);
		pm_runtime_enable(dev);
		[ ... ]
	}

has been introduced in scsi_dev_type_resume() by commit 3c31b52f96f7
("scsi: async sd resume"). I'm in favor of removing that code.

Thanks,

Bart.


