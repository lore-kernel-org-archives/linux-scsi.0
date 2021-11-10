Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD359C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 17:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A314E61037
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 17:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhKJRxe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 12:53:34 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:11138 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232548AbhKJRxd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Nov 2021 12:53:33 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636566645; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=JMJQhYKBnyVC0fQ+dcmFnQ5ocmFMcaWvBYvjYbYdQgg=; b=eA64Rfdaw9j4PpnoD6Ez+0M8wkPTiF53lbNolRwtlH/eLDbBwXqt09gvZLZ5wRq8OFWY3h6u
 KHgY9pcJU3NAhWzYt9WiNfFH9jeLsgLTsiQff+7Si2YQsbHSmi4IrXQrMUU5CgZsc0GXCOP3
 wS51JAlChd7Z/XxdgO7fS0Dq74U=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 618c06670f34c3436ac76e92 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Nov 2021 17:50:31
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BD9B2C43617; Wed, 10 Nov 2021 17:50:30 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CED31C4338F;
        Wed, 10 Nov 2021 17:50:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org CED31C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <f0aec70e-f7d5-8d52-5996-bbcfab5aaa1b@codeaurora.org>
Date:   Wed, 10 Nov 2021 09:50:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 03/11] scsi: ufs: Remove the sdev_rpmb member
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-4-bvanassche@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <20211110004440.3389311-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/2021 4:44 PM, Bart Van Assche wrote:
> Since the sdev_rpmb member of struct ufs_hba is only used inside
> ufshcd_scsi_add_wlus(), convert it into a local variable.
> 
> Suggested-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>   drivers/scsi/ufs/ufshcd.h |  1 -
>   2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d18685d080d7..dff76b1a0d5d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7407,7 +7407,7 @@ static inline void ufshcd_blk_pm_runtime_init(struct scsi_device *sdev)
>   static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
>   {
>   	int ret = 0;
> -	struct scsi_device *sdev_boot;
> +	struct scsi_device *sdev_boot, *sdev_rpmb;
>   
>   	hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
>   		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN), NULL);
> @@ -7418,14 +7418,14 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
>   	}
>   	scsi_device_put(hba->sdev_ufs_device);
>   
> -	hba->sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
> +	sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
>   		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
> -	if (IS_ERR(hba->sdev_rpmb)) {
> -		ret = PTR_ERR(hba->sdev_rpmb);
> +	if (IS_ERR(sdev_rpmb)) {
> +		ret = PTR_ERR(sdev_rpmb);
>   		goto remove_sdev_ufs_device;
>   	}
> -	ufshcd_blk_pm_runtime_init(hba->sdev_rpmb);
> -	scsi_device_put(hba->sdev_rpmb);
> +	ufshcd_blk_pm_runtime_init(sdev_rpmb);
> +	scsi_device_put(sdev_rpmb);
>   
>   	sdev_boot = __scsi_add_device(hba->host, 0, 0,
>   		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index a911ad72de7a..65178487adf3 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -809,7 +809,6 @@ struct ufs_hba {
>   	 * "UFS device" W-LU.
>   	 */
>   	struct scsi_device *sdev_ufs_device;
> -	struct scsi_device *sdev_rpmb;
>   
>   #ifdef CONFIG_SCSI_UFS_HWMON
>   	struct device *hwmon_device;
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
