Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3694C56201
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 02:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 535FC2075A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 02:07:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="OSTqICcU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732807AbgKZCHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 21:07:37 -0500
Received: from z5.mailgun.us ([104.130.96.5]:23017 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731736AbgKZCHh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Nov 2020 21:07:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606356456; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=eM/OlWlq0U/ubShojsUmq0EBcUvDZy0oih5TzXFbMYE=;
 b=OSTqICcUmu1+gaP9jMx5KpOerJUC5UXkalbfz3+UIdiJVw8aoLpiwICXy00KEuXlSaiNshFN
 JTQEJTvWFbNPS6m8mpT9e/TXeN4KDHV1CZtTXxWBdQyS94f1le7CEUUbcxkqsV9EXYsI0Ucc
 XQtPcijQT2J0yXAmQ8iKwajQHqI=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fbf0de7a5a29b56a162f767 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 26 Nov 2020 02:07:35
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5A8C8C43467; Thu, 26 Nov 2020 02:07:35 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 75B37C433ED;
        Thu, 26 Nov 2020 02:07:34 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 26 Nov 2020 10:07:34 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Remove unnecessary if condition in
 ufshcd_suspend()
In-Reply-To: <20201125185300.3394-1-huobean@gmail.com>
References: <20201125185300.3394-1-huobean@gmail.com>
Message-ID: <c241a19195be34886cd754d73bd6d168@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-26 02:53, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> In the case that auto_bkops_enable is false, which means auto bkops
> has been disabled, so no need to call ufshcd_disable_auto_bkops().
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 80cbce414678..d169db41ee16 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8543,11 +8543,9 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	}
> 
>  	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
> -		if ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
> -		    !ufshcd_is_runtime_pm(pm_op)) {
> +		if (!ufshcd_is_runtime_pm(pm_op))
>  			/* ensure that bkops is disabled */
>  			ufshcd_disable_auto_bkops(hba);
> -		}
> 
>  		if (!hba->dev_info.b_rpm_dev_flush_capable) {
>  			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);

Reviewed-by: Can Guo <cang@codeaurora.org>
