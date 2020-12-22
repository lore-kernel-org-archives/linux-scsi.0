Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C645BC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 11:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91A2C23124
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 11:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgLVLeQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 06:34:16 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:41771 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbgLVLeQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 06:34:16 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608636832; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=E8HQMio4RsYHO6n1kGjpbJsWX+/FYy067JA+sAFufFU=;
 b=rq1w6jz5t7VNhaYPbH9TFhH8n9VE4ao42AgfnzQVmFcj5/sJMS1wjXV3ZOtrP1irP9VIpo+B
 uslZAB8NwdZwf5MW+qCdP2oltE11IPe3BiMTW7XpEldiCMfe42fDSPqujO8x9WZ+pf6WwrCE
 nFIsO+ZujqrE0tpsaz/So+76KFs=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fe1d9801d5c1fa42715312d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Dec 2020 11:33:20
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5911FC433ED; Tue, 22 Dec 2020 11:33:20 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B1CD2C433CA;
        Tue, 22 Dec 2020 11:33:18 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 22 Dec 2020 19:33:18 +0800
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
Subject: Re: [PATCH v2 1/2] scsi: ufs: Fix possible power drain during system
 suspend
In-Reply-To: <20201222072905.32221-2-stanley.chu@mediatek.com>
References: <20201222072905.32221-1-stanley.chu@mediatek.com>
 <20201222072905.32221-2-stanley.chu@mediatek.com>
Message-ID: <66348e3c157ef48485f07d4b4043f01f@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-22 15:29, Stanley Chu wrote:
> Currently if device needs to do flush or BKOP operations,
> the device VCC power is kept during runtime-suspend period.
> 
> However, if system suspend is happening while device is
> runtime-suspended, such power may not be disabled successfully.
> 
> The reasons may be,
> 
> 1. If current PM level is the same as SPM level, device will
>    keep runtime-suspended by ufshcd_system_suspend().
> 
> 2. Flush recheck work may not be scheduled successfully
>    during system suspend period. If it can wake up the system,
>    this is also not the intention of the recheck work.
> 
> To fix this issue, simply runtime-resume the device if the flush
> is allowed during runtime suspend period. Flush capability will be
> disabled while leaving runtime suspend, and also not be allowed in
> system suspend period.
> 
> Fixes: 51dd905bd2f6 ("scsi: ufs: Fix WriteBooster flush during runtime 
> suspend")
> Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e221add25a7e..9d61dc3eb842 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8903,7 +8903,8 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>  	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
>  	     hba->curr_dev_pwr_mode) &&
>  	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
> -	     hba->uic_link_state))
> +	     hba->uic_link_state) &&
> +	     !hba->dev_info.b_rpm_dev_flush_capable)
>  		goto out;
> 
>  	if (pm_runtime_suspended(hba->dev)) {

Reviewed-by: Can Guo <cang@codeaurora.org>
