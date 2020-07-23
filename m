Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86CFC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 02:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2CF4206F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 02:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="UU6PVu44"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387470AbgGWCpf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 22:45:35 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:25697 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731405AbgGWCpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jul 2020 22:45:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595472334; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ZYYl7C2C3XkUBcES8NesjtqLRO46HerlpPpxaHi1mZc=;
 b=UU6PVu44d/hHVjUp2/3avHG6Xv6k+xG2/NgKIvcdBMnrWpA6yOnweotPwsnntZ450zcDogfw
 sY3giiKD6isme4i6Qpf0UKBRp6vaCQUztKUXdv9brx3gspA6zDCzksLnYmdACWsV2ZIN7v+X
 1aJf+9PC2NzgapuHWenHOqbRgYo=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n13.prod.us-east-1.postgun.com with SMTP id
 5f18f9b27c8ca473a8b70f86 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 23 Jul 2020 02:45:06
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 12E1AC4339C; Thu, 23 Jul 2020 02:45:05 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hongwus)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 17EB7C433C6;
        Thu, 23 Jul 2020 02:45:04 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 23 Jul 2020 10:45:04 +0800
From:   hongwus@codeaurora.org
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, sh425.lee@samsung.com,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/9] scsi: ufs: Add checks before setting clk-gating
 states
In-Reply-To: <1595471649-25675-2-git-send-email-cang@codeaurora.org>
References: <1595471649-25675-1-git-send-email-cang@codeaurora.org>
 <1595471649-25675-2-git-send-email-cang@codeaurora.org>
Message-ID: <d36e8ab21277f5d478d34cb3f8be13f4@codeaurora.org>
X-Sender: hongwus@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-23 10:34, Can Guo wrote:
> Clock gating features can be turned on/off selectively which means its
> state information is only important if it is enabled. This change makes
> sure that we only look at state of clk-gating if it is enabled.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index cdff7e5..99bd3e4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1839,6 +1839,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba 
> *hba)
>  	if (!ufshcd_is_clkgating_allowed(hba))
>  		return;
> 
> +	hba->clk_gating.state = CLKS_ON;
> +
>  	hba->clk_gating.delay_ms = 150;
>  	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
>  	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
> @@ -2541,7 +2543,8 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  		err = SCSI_MLQUEUE_HOST_BUSY;
>  		goto out;
>  	}
> -	WARN_ON(hba->clk_gating.state != CLKS_ON);
> +	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
> +		(hba->clk_gating.state != CLKS_ON));
> 
>  	lrbp = &hba->lrb[tag];
> 
> @@ -8315,8 +8318,11 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  		/* If link is active, device ref_clk can't be switched off */
>  		__ufshcd_setup_clocks(hba, false, true);
> 
> -	hba->clk_gating.state = CLKS_OFF;
> -	trace_ufshcd_clk_gating(dev_name(hba->dev), hba->clk_gating.state);
> +	if (ufshcd_is_clkgating_allowed(hba)) {
> +		hba->clk_gating.state = CLKS_OFF;
> +		trace_ufshcd_clk_gating(dev_name(hba->dev),
> +					hba->clk_gating.state);
> +	}
> 
>  	/* Put the host controller in low power mode if possible */
>  	ufshcd_hba_vreg_set_lpm(hba);
> @@ -8456,6 +8462,11 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	if (hba->clk_scaling.is_allowed)
>  		ufshcd_suspend_clkscaling(hba);
>  	ufshcd_setup_clocks(hba, false);
> +	if (ufshcd_is_clkgating_allowed(hba)) {
> +		hba->clk_gating.state = CLKS_OFF;
> +		trace_ufshcd_clk_gating(dev_name(hba->dev),
> +					hba->clk_gating.state);
> +	}
>  out:
>  	hba->pm_op_in_progress = 0;
>  	if (ret)


Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
