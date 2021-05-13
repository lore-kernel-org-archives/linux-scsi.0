Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6AB2C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 01:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B18E161404
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 01:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhEMBhQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 21:37:16 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:43629 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230310AbhEMBhN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 May 2021 21:37:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620869764; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=SGU/z9DpYp2bXDBu0Fnqn8NCB+obFI2rWRk4p0JbNmE=;
 b=vdrwbLfv9VqtfrFm45zcqvTeIWSDMjq9mnm21wb0BOk0tN6xK9DeYJph7IS+5K1gxoFd6Cor
 zqXISTx6doNuE2CI581NYM5Fve1JkzGFbkdJjUxL2z2hQ5Ge+01/+dX9HuwXsMHQLj46R5Sb
 rueYK2FTSU+Sg77ksXwBXOdGNs8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 609c8277fbf7d4a2f3658edf (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 13 May 2021 01:35:51
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F2A56C58A28; Thu, 13 May 2021 01:35:50 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 71E8BC58A1B;
        Thu, 13 May 2021 01:35:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 13 May 2021 09:35:46 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] ufs: Fix handling of active power mode in
 ufshcd_suspend()
In-Reply-To: <20210512195721.8157-1-bvanassche@acm.org>
References: <20210512195721.8157-1-bvanassche@acm.org>
Message-ID: <7e4e33158be2e5bfc8260c47202b45d9@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-13 03:57, Bart Van Assche wrote:
> If the rpm_lvl and spm_lvl sysfs attributes indicate that 
> ufshcd_suspend()
> should keep the link active, re-enable clock gating instead of 
> disabling
> clocks.
> 
> Suggested-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f540b0cc253f..c96e36aab989 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8690,9 +8690,8 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	ufshcd_clk_scaling_suspend(hba, true);
> 
>  	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
> -			req_link_state == UIC_LINK_ACTIVE_STATE) {
> -		goto disable_clks;
> -	}
> +			req_link_state == UIC_LINK_ACTIVE_STATE)
> +		goto enable_gating;
> 
>  	if ((req_dev_pwr_mode == hba->curr_dev_pwr_mode) &&
>  	    (req_link_state == hba->uic_link_state))
> @@ -8754,7 +8753,6 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	if (ret)
>  		goto set_dev_active;
> 
> -disable_clks:
>  	/*
>  	 * Call vendor specific suspend callback. As these callbacks may 
> access
>  	 * vendor specific host controller register space call them before 
> the

Hi Bart,

The change is unnecessary, ufshcd_suspend() is indeed keeping link alive 
even if
we are disabling clocks. In __ufshcd_setup_clocks(), we have checks on 
clock sources
so that we leave certain clock sources ON if the link is alive. And we 
have many
of our customers tested the case rpm/spm_lvl == 0, it is working well. 
Please check
below changes:

https://lore.kernel.org/patchwork/patch/1345336/
https://lore.kernel.org/patchwork/patch/1345337/

With this change, after suspend (rpm/spm_lvl == 0), leaving clock gating 
running is risky:
1. clock gating may run into concurrency with resume.
2. In ufshcd_resume(), we also have a ufshcd_release(), it will cause 
unbalanced usage of clock gating.

And it seems quite opposite from what you want - you want to keep link
alive but you are leaving clock gating enabled, then when clock gating
kicks start, it will put the link into hibern8, but not keep link alive.

Thanks,
Can Guo.
