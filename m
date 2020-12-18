Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2951DC2BBD4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E015B23131
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732677AbgLRGQ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 01:16:58 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:58120 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgLRGQ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 01:16:58 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608272197; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=LTW17UsHmSpSoJcBXlNHnM6V9HWBmm35DKkl0BCtoaM=;
 b=iQ+T3y90uxwR5raNyltw/p67HhQcWRqsSoq19twPbuNE+duLpzdg+qlWCIVBt5IKvGR+q0Nl
 3UvHmh6GF+IDILIG/4menWO+w+zcsZqlbc9PtIe7vaXg04UicIq9SBvF4y3nxgbOajobYkb7
 77dRXSUK2MQS60vbH7uaFo95oLY=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fdc492bf5e9af65f8e44b5a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 18 Dec 2020 06:16:11
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 16F35C43461; Fri, 18 Dec 2020 06:16:11 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 70198C433CA;
        Fri, 18 Dec 2020 06:16:09 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 18 Dec 2020 14:16:09 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Subject: Re: [PATCH v2 3/4] scsi: ufs: Cleanup and refactor clk-scaling
 feature
In-Reply-To: <20201216131639.4128-4-stanley.chu@mediatek.com>
References: <20201216131639.4128-1-stanley.chu@mediatek.com>
 <20201216131639.4128-4-stanley.chu@mediatek.com>
Message-ID: <cda3a961b396c48e95b32dd70961ef1b@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-16 21:16, Stanley Chu wrote:
> Manipulate clock scaling related stuff only if the host capability
> supports clock scaling feature to avoid redundant code execution.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 64 ++++++++++++++++++++-------------------
>  1 file changed, 33 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9cc16598136d..ce0528f2e2ed 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1448,9 +1448,6 @@ static void ufshcd_suspend_clkscaling(struct 
> ufs_hba *hba)
>  	unsigned long flags;
>  	bool suspend = false;
> 
> -	if (!ufshcd_is_clkscaling_supported(hba))
> -		return;
> -
>  	cancel_work_sync(&hba->clk_scaling.suspend_work);
>  	cancel_work_sync(&hba->clk_scaling.resume_work);
> 
> @@ -1470,9 +1467,6 @@ static void ufshcd_resume_clkscaling(struct 
> ufs_hba *hba)
>  	unsigned long flags;
>  	bool resume = false;
> 
> -	if (!ufshcd_is_clkscaling_supported(hba))
> -		return;
> -
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	if (hba->clk_scaling.is_suspended) {
>  		resume = true;
> @@ -5642,6 +5636,26 @@ static inline void
> ufshcd_schedule_eh_work(struct ufs_hba *hba)
>  	}
>  }
> 
> +static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
> +{
> +	down_write(&hba->clk_scaling_lock);
> +	hba->clk_scaling.is_allowed = allow;
> +	up_write(&hba->clk_scaling_lock);
> +}
> +
> +static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool 
> suspend)
> +{
> +	if (suspend) {
> +		if (hba->clk_scaling.is_enabled)
> +			ufshcd_suspend_clkscaling(hba);
> +		ufshcd_clk_scaling_allow(hba, false);
> +	} else {
> +		ufshcd_clk_scaling_allow(hba, true);
> +		if (hba->clk_scaling.is_enabled)
> +			ufshcd_resume_clkscaling(hba);
> +	}
> +}
> +
>  static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>  {
>  	pm_runtime_get_sync(hba->dev);
> @@ -5663,23 +5677,20 @@ static void ufshcd_err_handling_prepare(struct
> ufs_hba *hba)
>  		ufshcd_vops_resume(hba, UFS_RUNTIME_PM);
>  	} else {
>  		ufshcd_hold(hba, false);
> -		if (hba->clk_scaling.is_enabled)
> +		if (ufshcd_is_clkscaling_supported(hba) &&
> +		    hba->clk_scaling.is_enabled)
>  			ufshcd_suspend_clkscaling(hba);
>  	}
> -	down_write(&hba->clk_scaling_lock);
> -	hba->clk_scaling.is_allowed = false;
> -	up_write(&hba->clk_scaling_lock);
> +	ufshcd_clk_scaling_allow(hba, false);
>  }
> 
>  static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>  {
>  	ufshcd_release(hba);
> 
> -	down_write(&hba->clk_scaling_lock);
> -	hba->clk_scaling.is_allowed = true;
> -	up_write(&hba->clk_scaling_lock);
> -	if (hba->clk_scaling.is_enabled)
> -		ufshcd_resume_clkscaling(hba);
> +	if (ufshcd_is_clkscaling_supported(hba))
> +		ufshcd_clk_scaling_suspend(hba, false);
> +
>  	pm_runtime_put(hba->dev);
>  }
> 
> @@ -8507,12 +8518,8 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	ufshcd_hold(hba, false);
>  	hba->clk_gating.is_suspended = true;
> 
> -	if (hba->clk_scaling.is_enabled)
> -		ufshcd_suspend_clkscaling(hba);
> -
> -	down_write(&hba->clk_scaling_lock);
> -	hba->clk_scaling.is_allowed = false;
> -	up_write(&hba->clk_scaling_lock);
> +	if (ufshcd_is_clkscaling_supported(hba))
> +		ufshcd_clk_scaling_suspend(hba, true);
> 
>  	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
>  			req_link_state == UIC_LINK_ACTIVE_STATE) {
> @@ -8618,11 +8625,9 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
>  		ufshcd_disable_auto_bkops(hba);
>  enable_gating:
> -	down_write(&hba->clk_scaling_lock);
> -	hba->clk_scaling.is_allowed = true;
> -	up_write(&hba->clk_scaling_lock);
> -	if (hba->clk_scaling.is_enabled)
> -		ufshcd_resume_clkscaling(hba);
> +	if (ufshcd_is_clkscaling_supported(hba))
> +		ufshcd_clk_scaling_suspend(hba, false);
> +
>  	hba->clk_gating.is_suspended = false;
>  	hba->dev_info.b_rpm_dev_flush_capable = false;
>  	ufshcd_release(hba);
> @@ -8719,11 +8724,8 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
> 
>  	hba->clk_gating.is_suspended = false;
> 
> -	down_write(&hba->clk_scaling_lock);
> -	hba->clk_scaling.is_allowed = true;
> -	up_write(&hba->clk_scaling_lock);
> -	if (hba->clk_scaling.is_enabled)
> -		ufshcd_resume_clkscaling(hba);
> +	if (ufshcd_is_clkscaling_supported(hba))
> +		ufshcd_clk_scaling_suspend(hba, false);
> 
>  	/* Enable Auto-Hibernate if configured */
>  	ufshcd_auto_hibern8_enable(hba);

Thanks for the cleanup

Reviewed-by: Can Guo <cang@codeaurora.org>
