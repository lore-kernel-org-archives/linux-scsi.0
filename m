Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C44C4320E
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 15:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93D9F60F3A
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 15:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343879AbhIAPww (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 11:52:52 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:59312 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244935AbhIAPwu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Sep 2021 11:52:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630511514; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=DJPKLCjknE7MNkfUkV2JvIF1pJAJ2fVxt2U+Ra9y/r0=; b=uwWIYeiNx27aAqax5YX3W4dLa0bkahRguVDFtaGtUIBgSq1hllPgD5dgCOuGhY/yAh/NasGD
 5L7u2GcXJb4cfh0j0iJ3kmqELLsRVV+tHPmBENoRny5M0SgMDCMCldppjBwOX3zkkw0nOKfL
 T8OmbZdFI/LRC7H1wfTMbVLTqxk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 612fa193825e13c54a159083 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 01 Sep 2021 15:51:47
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E2B5CC43619; Wed,  1 Sep 2021 15:51:46 +0000 (UTC)
Received: from [192.168.1.8] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2B976C4338F;
        Wed,  1 Sep 2021 15:51:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 2B976C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH 2/3] scsi: ufs: Add temperature notification exception
 handling
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
 <20210901123707.5014-3-avri.altman@wdc.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <c00af2a5-63f0-e38d-a209-952b11db2b51@codeaurora.org>
Date:   Wed, 1 Sep 2021 08:51:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210901123707.5014-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/2021 5:37 AM, Avri Altman wrote:
> The device may notify the host of an extreme temperature by using the
> exception event mechanism. The exception can be raised when the device’s
> Tcase temperature is either too high or too low.
> 
> It is essentially up to the platform to decide what further actions need
> to be taken. So add a designated vop for that.  Each chipset vendor can
> decide if it wants to use the thermal subsystem, hw monitor, or some
> Privet implementation.
The sensors of thermal subsystem would essentially get the skin 
temperature and invoke the registered handlers to throttle, if possible.

I'm not sure how the vendor drivers can use thermal subsystem now if the 
ufs device doesn't inform the thermal subsystem about its increase in 
temperature.

Meaning, (FWIU):
  -> ufs device senses an increase in temperature
     -> informs thermal subsystem
       -> registered vendor driver cb() is invoked by thermal subsystem.

Please let me know if I'm missing something.

> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   drivers/scsi/ufs/ufs.h    |  2 ++
>   drivers/scsi/ufs/ufshcd.c | 18 ++++++++++++++++++
>   drivers/scsi/ufs/ufshcd.h |  7 +++++++
>   3 files changed, 27 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index dee897ef9631..4f2a2fe0c84a 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -374,6 +374,8 @@ enum {
>   	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
>   };
>   
> +#define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
> +
>   /* Background operation status */
>   enum bkops_status {
>   	BKOPS_STATUS_NO_OP               = 0x0,
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 6ad51ae764c5..5f1fce21b655 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5642,6 +5642,11 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
>   				__func__, err);
>   }
>   
> +static void ufshcd_temp_exception_event_handler(struct ufs_hba *hba, u16 status)
> +{
> +	ufshcd_vops_temp_notify(hba, status);
> +}
> +
>   static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
>   {
>   	u8 index;
> @@ -5821,6 +5826,9 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
>   	if (status & hba->ee_drv_mask & MASK_EE_URGENT_BKOPS)
>   		ufshcd_bkops_exception_event_handler(hba);
>   
> +	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
> +		ufshcd_temp_exception_event_handler(hba, status);
> +
>   	ufs_debugfs_exception_event(hba, status);
>   out:
>   	ufshcd_scsi_unblock_requests(hba);
> @@ -7473,6 +7481,7 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
>   {
>   	struct ufs_dev_info *dev_info = &hba->dev_info;
>   	u32 ext_ufs_feature;
> +	u16 mask = 0;
>   
>   	if (!(hba->caps & UFSHCD_CAP_TEMP_NOTIF) ||
>   	    dev_info->wspecversion < 0x300)
> @@ -7483,6 +7492,15 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
>   
>   	dev_info->low_temp_notif = ext_ufs_feature & UFS_DEV_LOW_TEMP_NOTIF;
>   	dev_info->high_temp_notif = ext_ufs_feature & UFS_DEV_HIGH_TEMP_NOTIF;
> +
> +	if (dev_info->low_temp_notif)
> +		mask |= MASK_EE_TOO_LOW_TEMP;
> +
> +	if (dev_info->high_temp_notif)
> +		mask |= MASK_EE_TOO_HIGH_TEMP;
> +
> +	if (mask)
> +		ufshcd_enable_ee(hba, mask);
>   }
>   
>   void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix *fixups)
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 467affbaec80..98ac7e7c8ec3 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -356,6 +356,7 @@ struct ufs_hba_variant_ops {
>   			       const union ufs_crypto_cfg_entry *cfg, int slot);
>   	void	(*event_notify)(struct ufs_hba *hba,
>   				enum ufs_event_type evt, void *data);
> +	void	(*temp_notify)(struct ufs_hba *hba, u16 status);
>   };
>   
>   /* clock gating state  */
> @@ -1355,6 +1356,12 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
>   		hba->vops->config_scaling_param(hba, profile, data);
>   }
>   
> +static inline void ufshcd_vops_temp_notify(struct ufs_hba *hba, u16 status)
> +{
> +	if (hba->vops && hba->vops->temp_notify)
> +		hba->vops->temp_notify(hba, status);
> +}
> +
>   extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
>   
>   /*
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
