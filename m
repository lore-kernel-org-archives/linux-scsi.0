Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742C8C388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 02:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 001452242F
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 02:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="GggyczKt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439963AbgJUCFZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 22:05:25 -0400
Received: from z5.mailgun.us ([104.130.96.5]:58545 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439953AbgJUCFY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 22:05:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603245924; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=S5lmg/47eSMB0cMlWY5RcQ2SoXrP4WZ/K1BZsdaCAF8=;
 b=GggyczKtADXxb40a7aUP4D4VJ8ihS5p+fPuUgtZVL3GoYSrUHQdeRpwi6DTALSJCxwrvyGve
 thQ2GZ4o+kLLetqxhLkOFq+t/QZVpj85XMJX+gryd6OIbXQCQYgcAuyexmQ/Z5kHqaGvAC2a
 Y+2ZIcUgmKxq6KIJBvZPRzAXmvg=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f8f9762e9e942744c293421 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 21 Oct 2020 02:05:22
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1E434C433CB; Wed, 21 Oct 2020 02:05:22 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4AD07C433C9;
        Wed, 21 Oct 2020 02:05:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 21 Oct 2020 10:05:21 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com,
        Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v2 1/5] scsi: ufs: atomic update for clkgating_enable
In-Reply-To: <20201020195258.2005605-2-jaegeuk@kernel.org>
References: <20201020195258.2005605-1-jaegeuk@kernel.org>
 <20201020195258.2005605-2-jaegeuk@kernel.org>
Message-ID: <6c7bc6794b215a0ae1ae0cd9d448efa3@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-21 03:52, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> When giving a stress test which enables/disables clkgating, we hit 
> device
> timeout sometimes. This patch avoids subtle racy condition to address 
> it.
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

Next time can you have a cover letter in case of multiple patches?

Thanks,

Can Guo.

> ---
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b8f573a02713..7344353a9167 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1807,19 +1807,19 @@ static ssize_t
> ufshcd_clkgate_enable_store(struct device *dev,
>  		return -EINVAL;
> 
>  	value = !!value;
> +
> +	spin_lock_irqsave(hba->host->host_lock, flags);
>  	if (value == hba->clk_gating.is_enabled)
>  		goto out;
> 
> -	if (value) {
> -		ufshcd_release(hba);
> -	} else {
> -		spin_lock_irqsave(hba->host->host_lock, flags);
> +	if (value)
> +		__ufshcd_release(hba);
> +	else
>  		hba->clk_gating.active_reqs++;
> -		spin_unlock_irqrestore(hba->host->host_lock, flags);
> -	}
> 
>  	hba->clk_gating.is_enabled = value;
>  out:
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	return count;
>  }
