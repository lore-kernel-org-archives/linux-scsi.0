Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF3CC43331
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 17:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5884420776
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 17:00:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="UmWRnJSH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgC3RA7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 13:00:59 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:57437 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728075AbgC3RA6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Mar 2020 13:00:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585587658; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=1d8KTbgt/iCLQW3VVzDGNmfmBuqcJpPIW3cjwTeucPA=; b=UmWRnJSHCSIBhZwAi/eXK+T4ZJ/Jn7sTca/MMRgO/9ng3/HFVTxyvVyAqjLnez03ON9Wv93R
 ToKN+ySpGNTK9JnR3A9nkcPXZI/xuM6wa5KiR9otu+r1vXbugKjKjBGzipe78XgXIBLy7xKk
 VMu1s0gc2xATjh7WuHRHdUzt4Zs=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8225b3.7f655d9d99d0-smtp-out-n01;
 Mon, 30 Mar 2020 17:00:35 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C3157C43637; Mon, 30 Mar 2020 17:00:35 +0000 (UTC)
Received: from [192.168.8.111] (cpe-70-95-153-89.san.res.rr.com [70.95.153.89])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 795AAC433D2;
        Mon, 30 Mar 2020 17:00:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 795AAC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 1/1] scsi: ufs: set device as active power mode after
 resetting device
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200327095835.10293-1-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <ae5747c1-fd33-2588-b838-d88d21bcb267@codeaurora.org>
Date:   Mon, 30 Mar 2020 10:00:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200327095835.10293-1-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 3/27/2020 2:58 AM, Stanley Chu wrote:
> Currently ufshcd driver assumes that bInitPowerMode parameter
> is not changed by any vendors thus device power mode can be set as
> "Active" during initialization.
> 
> According to UFS JEDEC specification, device power mode shall be
> "Active" after HW Reset is triggered if the bInitPowerMode parameter
> in Device Descriptor is default value.
> 
> By above description, we can set device power mode as "Active" after
> device reset is triggered by vendor's callback. With this change,
> the link startup performance can be improved in some cases
> by not setting link_startup_again as true in ufshcd_link_startup().
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 13 -------------
>   drivers/scsi/ufs/ufshcd.h | 14 ++++++++++++++
>   2 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 227660a1a446..f0a35b289b7c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -171,19 +171,6 @@ enum {
>   #define ufshcd_clear_eh_in_progress(h) \
>   	((h)->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
>   
> -#define ufshcd_set_ufs_dev_active(h) \
> -	((h)->curr_dev_pwr_mode = UFS_ACTIVE_PWR_MODE)
> -#define ufshcd_set_ufs_dev_sleep(h) \
> -	((h)->curr_dev_pwr_mode = UFS_SLEEP_PWR_MODE)
> -#define ufshcd_set_ufs_dev_poweroff(h) \
> -	((h)->curr_dev_pwr_mode = UFS_POWERDOWN_PWR_MODE)
> -#define ufshcd_is_ufs_dev_active(h) \
> -	((h)->curr_dev_pwr_mode == UFS_ACTIVE_PWR_MODE)
> -#define ufshcd_is_ufs_dev_sleep(h) \
> -	((h)->curr_dev_pwr_mode == UFS_SLEEP_PWR_MODE)
> -#define ufshcd_is_ufs_dev_poweroff(h) \
> -	((h)->curr_dev_pwr_mode == UFS_POWERDOWN_PWR_MODE)
> -
>   struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
>   	{UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE},
>   	{UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE},
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index b7bd81795c24..7a9d1d170719 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -129,6 +129,19 @@ enum uic_link_state {
>   #define ufshcd_set_link_hibern8(hba) ((hba)->uic_link_state = \
>   				    UIC_LINK_HIBERN8_STATE)
>   
> +#define ufshcd_set_ufs_dev_active(h) \
> +	((h)->curr_dev_pwr_mode = UFS_ACTIVE_PWR_MODE)
> +#define ufshcd_set_ufs_dev_sleep(h) \
> +	((h)->curr_dev_pwr_mode = UFS_SLEEP_PWR_MODE)
> +#define ufshcd_set_ufs_dev_poweroff(h) \
> +	((h)->curr_dev_pwr_mode = UFS_POWERDOWN_PWR_MODE)
> +#define ufshcd_is_ufs_dev_active(h) \
> +	((h)->curr_dev_pwr_mode == UFS_ACTIVE_PWR_MODE)
> +#define ufshcd_is_ufs_dev_sleep(h) \
> +	((h)->curr_dev_pwr_mode == UFS_SLEEP_PWR_MODE)
> +#define ufshcd_is_ufs_dev_poweroff(h) \
> +	((h)->curr_dev_pwr_mode == UFS_POWERDOWN_PWR_MODE)
> +
>   /*
>    * UFS Power management levels.
>    * Each level is in increasing order of power savings.
> @@ -1091,6 +1104,7 @@ static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
>   {
>   	if (hba->vops && hba->vops->device_reset) {
>   		hba->vops->device_reset(hba);
> +		ufshcd_set_ufs_dev_active(hba);
>   		ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, 0);
>   	}
>   }
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
