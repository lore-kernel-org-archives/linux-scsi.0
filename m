Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE92CC4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F67A23136
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgLRGJe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 01:09:34 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:63402 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgLRGJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 01:09:34 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608271754; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=uS4mzlo3uSd6U8vrzsDXSBBTfBn/BjCQj5rxsqIrlfA=;
 b=oVb2Axzecy46yTzizlulnMkFQjo5yEk4EwJT4wTr4YS8mpeHLc87Jp2j7XZMLunY9tiE+ewQ
 XmgsxI9KPNAr4gF9x8D4Yb+ii4wdiK3qVEjI+WaNTxTzeyv/SnRGLltjjfMyWLlyN07i+CGS
 s0q8AoRGlDyC1wzBQ0gPQ5nMI6A=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fdc47660564dfefcd00b779 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 18 Dec 2020 06:08:38
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3C1FFC43466; Fri, 18 Dec 2020 06:08:37 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3600C433CA;
        Fri, 18 Dec 2020 06:08:35 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 18 Dec 2020 14:08:35 +0800
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
Subject: Re: [PATCH v2 1/4] scsi: ufs: Refactor cancelling clkscaling works
In-Reply-To: <20201216131639.4128-2-stanley.chu@mediatek.com>
References: <20201216131639.4128-1-stanley.chu@mediatek.com>
 <20201216131639.4128-2-stanley.chu@mediatek.com>
Message-ID: <0a96e3c62a0a77c78285fe92f2db2cd3@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-16 21:16, Stanley Chu wrote:
> Cancelling suspend_work and resume_work is only required while
> suspending clk-scaling. Thus moving these two invokes into
> ufshcd_suspend_clkscaling() function.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 052479a56a6f..a91b73a1fc48 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1451,6 +1451,9 @@ static void ufshcd_suspend_clkscaling(struct 
> ufs_hba *hba)
>  	if (!ufshcd_is_clkscaling_supported(hba))
>  		return;
> 
> +	cancel_work_sync(&hba->clk_scaling.suspend_work);
> +	cancel_work_sync(&hba->clk_scaling.resume_work);
> +
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	if (!hba->clk_scaling.is_suspended) {
>  		suspend = true;
> @@ -1514,9 +1517,6 @@ static ssize_t
> ufshcd_clkscale_enable_store(struct device *dev,
>  	pm_runtime_get_sync(hba->dev);
>  	ufshcd_hold(hba, false);
> 
> -	cancel_work_sync(&hba->clk_scaling.suspend_work);
> -	cancel_work_sync(&hba->clk_scaling.resume_work);
> -
>  	if (value) {
>  		ufshcd_resume_clkscaling(hba);
>  	} else {
> @@ -5663,11 +5663,8 @@ static void ufshcd_err_handling_prepare(struct
> ufs_hba *hba)
>  		ufshcd_vops_resume(hba, UFS_RUNTIME_PM);
>  	} else {
>  		ufshcd_hold(hba, false);
> -		if (hba->clk_scaling.is_enabled) {
> -			cancel_work_sync(&hba->clk_scaling.suspend_work);
> -			cancel_work_sync(&hba->clk_scaling.resume_work);
> +		if (hba->clk_scaling.is_enabled)
>  			ufshcd_suspend_clkscaling(hba);
> -		}
>  	}
>  	down_write(&hba->clk_scaling_lock);
>  	hba->clk_scaling.is_allowed = false;
> @@ -8512,11 +8509,9 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	ufshcd_hold(hba, false);
>  	hba->clk_gating.is_suspended = true;
> 
> -	if (hba->clk_scaling.is_enabled) {
> -		cancel_work_sync(&hba->clk_scaling.suspend_work);
> -		cancel_work_sync(&hba->clk_scaling.resume_work);
> +	if (hba->clk_scaling.is_enabled)
>  		ufshcd_suspend_clkscaling(hba);
> -	}
> +
>  	down_write(&hba->clk_scaling_lock);
>  	hba->clk_scaling.is_allowed = false;
>  	up_write(&hba->clk_scaling_lock);

Reviewed-by: Can Guo <cang@codeaurora.org>
