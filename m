Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32BBC4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 02:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A11EC2072E
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 02:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="mtGpzp6H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504446AbgJ0CRh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 22:17:37 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:47928 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504442AbgJ0CRg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 22:17:36 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603765055; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ZzFhkO2QNn27KCRuwRwy9HGYUS6mSmOvRLivBwN26xE=;
 b=mtGpzp6HrhPwwIzQLWoGALvpTIBKS9B1eWt++zhSuTlnKy4UTSRoOUI0nkQdmjnQ5JRLq17d
 tSJJQyqxsVEu8sH3ePLJnty8PacfgrSJYJ29Qvj1XK4XdVXXAd8CLgBUAUa53CYrbfBsyUoB
 AGgmPoBXGKnFxuvS2tIO0EYQtbs=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f97833f7955e2c7cd1033fc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 27 Oct 2020 02:17:35
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4E101C43382; Tue, 27 Oct 2020 02:17:35 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BDFC6C433C9;
        Tue, 27 Oct 2020 02:17:34 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 27 Oct 2020 10:17:34 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        Jaegeuk Kim <jaegeuk@google.com>
Subject: Re: [PATCH v4 1/5] scsi: ufs: atomic update for clkgating_enable
In-Reply-To: <20201026195124.363096-2-jaegeuk@kernel.org>
References: <20201026195124.363096-1-jaegeuk@kernel.org>
 <20201026195124.363096-2-jaegeuk@kernel.org>
Message-ID: <20d1c2ca06e95beb207fd4ba1b61dc80@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-27 03:51, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> When giving a stress test which enables/disables clkgating, we hit 
> device
> timeout sometimes. This patch avoids subtle racy condition to address 
> it.
> 
> Note that, this requires a patch to address the device stuck by 
> REQ_CLKS_OFF in
> __ufshcd_release().
> 
> The fix is "scsi: ufs: avoid to call REQ_CLKS_OFF to CLKS_OFF".

Why don't you just squash the fix into this one?

Thanks,

Can Guo.

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index cc8d5f0c3fdc..6c9269bffcbd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1808,19 +1808,19 @@ static ssize_t
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
