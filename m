Return-Path: <SRS0=JQ6K=7B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35586C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 16:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6BE20756
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 16:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="f+qQPmol"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbgESQ1z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 12:27:55 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:22004 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728795AbgESQ1w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 May 2020 12:27:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589905670; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=6X9hMFobMkVLgkXSvHsdTSvgP/JXFdU8N066HN1mPZs=; b=f+qQPmolTgczPKVMTusjZxkBlQebfs9Glo2Oxy3MUE92YisMw6cCNoJIDVfbuT0wI+mYrWvt
 zPheS9bENOCh3GuyaD3KXLiNlOtCVtF60bwPKq7ViFbGUZd159rJJLwIohfYci/s+twN4CNC
 cd64kfejmmp7xKVlhcN1LHASq6U=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ec408fe.7fa2bce3fd50-smtp-out-n05;
 Tue, 19 May 2020 16:27:42 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1C300C4478C; Tue, 19 May 2020 16:27:41 +0000 (UTC)
Received: from [192.168.8.176] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7A312C433F2;
        Tue, 19 May 2020 16:27:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7A312C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v3 5/5] scsi: ufs: Fix possible VCC power drain during
 runtime suspend
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200516174615.15445-1-stanley.chu@mediatek.com>
 <20200516174615.15445-6-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <6d32fba1-f7c3-f043-42b6-0da065e9795b@codeaurora.org>
Date:   Tue, 19 May 2020 09:27:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200516174615.15445-6-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 5/16/2020 10:46 AM, Stanley Chu wrote:
> The commit "scsi: ufs: Fix WriteBooster flush during runtime
> suspend" promises essential resource, i.e., for UFS devices doing
> WriteBooster buffer flush and Auto BKOPs. However if device
> finishes its job but not resumed for a very long time, system
> will have unnecessary power drain because VCC is still supplied.
> 
> To fix this, a method to recheck the threshold of keeping VCC
> supply is required. However, the threshold recheck needs to
> re-activate the link because the decision depends on the device
> status.
> 
> Introduce a delayed work to force runtime resume after a certain
> delay during runtime suspend. This makes threshold recheck simpler
> which will be done in the next runtime-suspend.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---

Is there a reason to have this code as a separate patch?
[1] Commit: "scsi: ufs: Fix WriteBooster flush during runtime suspend" 
introduces 'keep_curr_dev_pwr_mode' and the very next change (this one) 
removes it.
Do you think this change and [1] should be merged?

>   drivers/scsi/ufs/ufs.h    |  1 +
>   drivers/scsi/ufs/ufshcd.c | 43 ++++++++++++++++++++++++++++++++++-----
>   drivers/scsi/ufs/ufshcd.h |  1 +
>   3 files changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index db07eedfed96..c70845d41449 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -574,6 +574,7 @@ struct ufs_dev_info {
>   	u32 d_ext_ufs_feature_sup;
>   	u8 b_wb_buffer_type;
>   	u32 d_wb_alloc_units;
> +	bool b_rpm_dev_flush_capable;
>   	u8 b_presrv_uspc_en;
>   };
>   
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f4f2c7b5ab0a..a137553f9b41 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -94,6 +94,9 @@
>   /* default delay of autosuspend: 2000 ms */
>   #define RPM_AUTOSUSPEND_DELAY_MS 2000
>   
> +/* Default delay of RPM device flush delayed work */
> +#define RPM_DEV_FLUSH_RECHECK_WORK_DELAY_MS 5000
> +
>   /* Default value of wait time before gating device ref clock */
>   #define UFSHCD_REF_CLK_GATING_WAIT_US 0xFF /* microsecs */
>   
> @@ -5310,7 +5313,7 @@ static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
>   	return false;
>   }
>   
> -static bool ufshcd_wb_keep_vcc_on(struct ufs_hba *hba)
> +static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
>   {
>   	int ret;
>   	u32 avail_buf;
> @@ -5348,6 +5351,21 @@ static bool ufshcd_wb_keep_vcc_on(struct ufs_hba *hba)
>   	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
>   }
>   
> +static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
> +{
> +	struct ufs_hba *hba = container_of(to_delayed_work(work),
> +					   struct ufs_hba,
> +					   rpm_dev_flush_recheck_work);
> +	/*
> +	 * To prevent unnecessary VCC power drain after device finishes
> +	 * WriteBooster buffer flush or Auto BKOPs, force runtime resume
> +	 * after a certain delay to recheck the threshold by next runtime
> +	 * supsend.
> +	 */
> +	pm_runtime_get_sync(hba->dev);
> +	pm_runtime_put_sync(hba->dev);
> +}
> +
>   /**
>    * ufshcd_exception_event_handler - handle exceptions raised by device
>    * @work: pointer to work data
> @@ -8164,7 +8182,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   	enum ufs_pm_level pm_lvl;
>   	enum ufs_dev_pwr_mode req_dev_pwr_mode;
>   	enum uic_link_state req_link_state;
> -	bool keep_curr_dev_pwr_mode = false;
>   
>   	hba->pm_op_in_progress = 1;
>   	if (!ufshcd_is_shutdown_pm(pm_op)) {
> @@ -8224,11 +8241,12 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   		 * Hibern8, keep device power mode as "active power mode"
>   		 * and VCC supply.
>   		 */
> -		keep_curr_dev_pwr_mode = hba->auto_bkops_enabled ||
> +		hba->dev_info.b_rpm_dev_flush_capable =
> +			hba->auto_bkops_enabled ||
>   			(((req_link_state == UIC_LINK_HIBERN8_STATE) ||
>   			((req_link_state == UIC_LINK_ACTIVE_STATE) &&
>   			ufshcd_is_auto_hibern8_enabled(hba))) &&
> -			ufshcd_wb_keep_vcc_on(hba));
> +			ufshcd_wb_need_flush(hba));
>   	}
>   
>   	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
> @@ -8238,7 +8256,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   			ufshcd_disable_auto_bkops(hba);
>   		}
>   
> -		if (!keep_curr_dev_pwr_mode) {
> +		if (!hba->dev_info.b_rpm_dev_flush_capable) {
>   			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
>   			if (ret)
>   				goto enable_gating;
> @@ -8295,9 +8313,16 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   	if (hba->clk_scaling.is_allowed)
>   		ufshcd_resume_clkscaling(hba);
>   	hba->clk_gating.is_suspended = false;
> +	hba->dev_info.b_rpm_dev_flush_capable = false;
>   	ufshcd_release(hba);
>   out:
> +	if (hba->dev_info.b_rpm_dev_flush_capable) {
> +		schedule_delayed_work(&hba->rpm_dev_flush_recheck_work,
> +			msecs_to_jiffies(RPM_DEV_FLUSH_RECHECK_WORK_DELAY_MS));
> +	}
> +
>   	hba->pm_op_in_progress = 0;
> +
Nitpick; newline, perhaps?

>   	if (ret)
>   		ufshcd_update_reg_hist(&hba->ufs_stats.suspend_err, (u32)ret);
>   	return ret;
> @@ -8386,6 +8411,11 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   	/* Enable Auto-Hibernate if configured */
>   	ufshcd_auto_hibern8_enable(hba);
>   
> +	if (hba->dev_info.b_rpm_dev_flush_capable) {
> +		hba->dev_info.b_rpm_dev_flush_capable = false;
> +		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
> +	}
> +
>   	/* Schedule clock gating in case of no access to UFS device yet */
>   	ufshcd_release(hba);
>   
> @@ -8859,6 +8889,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   						UFS_SLEEP_PWR_MODE,
>   						UIC_LINK_HIBERN8_STATE);
>   
> +	INIT_DELAYED_WORK(&hba->rpm_dev_flush_recheck_work,
> +			  ufshcd_rpm_dev_flush_recheck_work);
> +
>   	/* Set the default auto-hiberate idle timer value to 150 ms */
>   	if (ufshcd_is_auto_hibern8_supported(hba) && !hba->ahit) {
>   		hba->ahit = FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, 150) |
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 8db7a6101892..9acd437037e8 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -745,6 +745,7 @@ struct ufs_hba {
>   	struct request_queue	*bsg_queue;
>   	bool wb_buf_flush_enabled;
>   	bool wb_enabled;
> +	struct delayed_work rpm_dev_flush_recheck_work;
>   };
>   
>   /* Returns true if clocks can be gated. Otherwise false */
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
