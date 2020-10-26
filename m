Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7C3C388F7
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 03:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33E7420885
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 03:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="VwYKNrVA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421905AbgJZD2t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 23:28:49 -0400
Received: from z5.mailgun.us ([104.130.96.5]:36904 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727885AbgJZD2t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Oct 2020 23:28:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603682929; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=mlxfck8q9sIQPtbUdbIP5NseLL7/CM6uJ5aM506Ks68=;
 b=VwYKNrVAOd9QuAhDNAAeyYh4E1gwsDTx1bWLEa48R/61Z7R8M3UpIwH5nsCKGQmabUOIf+8z
 tHnUt9NWb5BLbGpgc2DRSE2JNsBUPd6MsYR7O1OLZ1pIvYQtMWurXMPG11tTNCUkhb1uYpnz
 NSF3N395G6jsUMVeYtiQ7ZAMrS4=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5f96425ec6b781f75398a137 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Oct 2020 03:28:30
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5177EC433FE; Mon, 26 Oct 2020 03:28:29 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EEB9AC433C9;
        Mon, 26 Oct 2020 03:28:27 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 26 Oct 2020 11:28:27 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        Jaegeuk Kim <jaegeuk@google.com>
Subject: Re: [PATCH v3 1/5] scsi: ufs: atomic update for clkgating_enable
In-Reply-To: <20201024150646.1790529-2-jaegeuk@kernel.org>
References: <20201024150646.1790529-1-jaegeuk@kernel.org>
 <20201024150646.1790529-2-jaegeuk@kernel.org>
Message-ID: <68cf5fe17691653f07544db5fe390c97@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-24 23:06, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> When giving a stress test which enables/disables clkgating, we hit 
> device
> timeout sometimes. This patch avoids subtle racy condition to address 
> it.
> 
> If we use __ufshcd_release(), I've seen that gate_work can be called in 
> parallel
> with ungate_work, which results in UFS timeout when doing hibern8.
> Should avoid it.
> 

I don't understand this comment. gate_work and ungate_work are queued on
an ordered workqueue and an ordered workqueue executes at most one work 
item
at any given time in the queued order. How can the two run in parallel?

Thanks,

Can Guo.

> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b8f573a02713..e0b479f9eb8a 100644
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
> +		hba->clk_gating.active_reqs--;
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
