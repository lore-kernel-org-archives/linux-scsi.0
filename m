Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF21EC2BB48
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 17:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EBA622B2D
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 17:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbgLORfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 12:35:17 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:46928 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731135AbgLORex (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 12:34:53 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608053665; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=xXc2UK5tza7QAAftIMaq+gM4d7+YcF9ucDsrs/aFZvk=; b=L+Ep2kXGcZuv2Q9NIk4cKEotY8HQhQv9JDVGMIDQbBWAOyB7ULFFrq/VKpIl4KLGHfo//TF7
 UmpLWaNSTA7gcAtaoqh7exUjE7RL9WuQkz01QEaQa7Tbpjn/N2e9k/DaayE6LEVoXps0DUWF
 a+XrqGRDNz8Ia9gcOIVYuxh+/UA=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fd8f382031793dcb46c7115 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Dec 2020 17:33:54
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 11DB8C43467; Tue, 15 Dec 2020 17:33:54 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B6F67C433CA;
        Tue, 15 Dec 2020 17:33:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B6F67C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2 2/2] scsi: ufs: Uninline ufshcd_vops_device_reset
 function
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nguyenb@codeaurora.org, bjorn.andersson@linaro.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
References: <20201208135635.15326-1-stanley.chu@mediatek.com>
 <20201208135635.15326-3-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <a1b39518-6a44-f349-008a-f029295d7e10@codeaurora.org>
Date:   Tue, 15 Dec 2020 09:33:49 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201208135635.15326-3-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/2020 5:56 AM, Stanley Chu wrote:
> Since more and more statements showing up in ufshcd_vops_device_reset(),
> uninline it to allow compiler making possibly better optimization.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 27 ++++++++++++++++++++++-----
>   drivers/scsi/ufs/ufshcd.h | 19 +++++--------------
>   2 files changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c1c401b2b69d..b2ca1a6ad426 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -580,6 +580,23 @@ static void ufshcd_print_pwr_info(struct ufs_hba *hba)
>   		 hba->pwr_info.hs_rate);
>   }
>   
> +static void ufshcd_device_reset(struct ufs_hba *hba)
> +{
> +	int err;
> +
> +	err = ufshcd_vops_device_reset(hba);
> +
> +	if (!err) {
> +		ufshcd_set_ufs_dev_active(hba);
> +		if (ufshcd_is_wb_allowed(hba)) {
> +			hba->wb_enabled = false;
> +			hba->wb_buf_flush_enabled = false;
> +		}
> +	}
> +	if (err != -EOPNOTSUPP)
> +		ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, err);
> +}
> +
>   void ufshcd_delay_us(unsigned long us, unsigned long tolerance)
>   {
>   	if (!us)
> @@ -3932,7 +3949,7 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   
>   	/* Reset the attached device */
> -	ufshcd_vops_device_reset(hba);
> +	ufshcd_device_reset(hba);
>   
>   	ret = ufshcd_host_reset_and_restore(hba);
>   
> @@ -6933,7 +6950,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>   
>   	do {
>   		/* Reset the attached device */
> -		ufshcd_vops_device_reset(hba);
> +		ufshcd_device_reset(hba);
>   
>   		err = ufshcd_host_reset_and_restore(hba);
>   	} while (err && --retries);
> @@ -8712,7 +8729,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   	 * further below.
>   	 */
>   	if (ufshcd_is_ufs_dev_deepsleep(hba)) {
> -		ufshcd_vops_device_reset(hba);
> +		ufshcd_device_reset(hba);
>   		WARN_ON(!ufshcd_is_link_off(hba));
>   	}
>   	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
> @@ -8722,7 +8739,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   set_dev_active:
>   	/* Can also get here needing to exit DeepSleep */
>   	if (ufshcd_is_ufs_dev_deepsleep(hba)) {
> -		ufshcd_vops_device_reset(hba);
> +		ufshcd_device_reset(hba);
>   		ufshcd_host_reset_and_restore(hba);
>   	}
>   	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
> @@ -9321,7 +9338,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	}
>   
>   	/* Reset the attached device */
> -	ufshcd_vops_device_reset(hba);
> +	ufshcd_device_reset(hba);
>   
>   	ufshcd_init_crypto(hba);
>   
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 36d367eb8139..9bb5f0ed4124 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1216,21 +1216,12 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
>   		hba->vops->dbg_register_dump(hba);
>   }
>   
> -static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
> +static inline int ufshcd_vops_device_reset(struct ufs_hba *hba)
>   {
> -	if (hba->vops && hba->vops->device_reset) {
> -		int err = hba->vops->device_reset(hba);
> -
> -		if (!err) {
> -			ufshcd_set_ufs_dev_active(hba);
> -			if (ufshcd_is_wb_allowed(hba)) {
> -				hba->wb_enabled = false;
> -				hba->wb_buf_flush_enabled = false;
> -			}
> -		}
> -		if (err != -EOPNOTSUPP)
> -			ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, err);
> -	}
> +	if (hba->vops && hba->vops->device_reset)
> +		return hba->vops->device_reset(hba);
> +
> +	return -EOPNOTSUPP;
>   }
>   
>   static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
