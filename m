Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1D8C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 10:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A27223C6
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 10:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="tTSWLTSu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393390AbgJTK5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 06:57:40 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:46562 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389666AbgJTK5k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 06:57:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603191459; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=kDyFGrjqjzvUGZvCqxfuCVT1uxHJbiGv9HnASJOiAKE=;
 b=tTSWLTSuZE/oNqj2zGzh9KuzzW7Ayn37YTT13LSUxg0di25GQTFN+ftRLEpJd8s5L4wd2q30
 t8k4aphExPnkET8WC1gBPmsR3En8WSJ6QVxBLSsXbdnlKsgjr/Yc4/4BiaIT2X9qIHm0wpfj
 k3UbPrHLEs4YwXaeYQp4OzReHVE=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f8ec2a3a03b63d6739e0168 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 20 Oct 2020 10:57:39
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C2B4CC433CB; Tue, 20 Oct 2020 10:57:38 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 387BCC433C9;
        Tue, 20 Oct 2020 10:57:38 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 20 Oct 2020 18:57:38 +0800
From:   Can Guo <cang@codeaurora.org>
To:     jaegeuk@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v2] scsi: ufs: fix clkgating on/off correctly
In-Reply-To: <20201016211826.GA3441410@google.com>
References: <20201016060259.390029-1-jaegeuk@kernel.org>
 <20201016211826.GA3441410@google.com>
Message-ID: <5a59c4c4ec0959223fe0e879f2dd9d91@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-17 05:18, jaegeuk@kernel.org wrote:
> The below call stack prevents clk_gating at every IO completion.
> We can remove the condition, ufshcd_any_tag_in_use(), since 
> clkgating_work
> will check it again.
> 
> ufshcd_complete_requests(struct ufs_hba *hba)
>   ufshcd_transfer_req_compl()
>     __ufshcd_transfer_req_compl()
>       __ufshcd_release(hba)
>         if (ufshcd_any_tag_in_use() == 1)
>            return;
>   ufshcd_tmc_handler(hba);
>     blk_mq_tagset_busy_iter();
> 
> In addition, we have to avoid gate_work, if it was disabled.
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
> 
> Change log from v1:
>  - change the patch subject
>  - fix clkgate.is_enable to work
> 
>  drivers/scsi/ufs/ufshcd.c | 5 +++--
>  drivers/scsi/ufs/ufshcd.h | 5 +++++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a2db8182663d..75e8a76f20c7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1729,9 +1729,10 @@ static void __ufshcd_release(struct ufs_hba 
> *hba)
> 
>  	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended
>  		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
> -		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
> +		|| hba->outstanding_tasks
>  		|| hba->active_uic_cmd || hba->uic_async_done
> -		|| ufshcd_eh_in_progress(hba))
> +		|| ufshcd_eh_in_progress(hba)
> +		|| ufshcd_is_clkgating_enabled(hba))

I guess you want it to be "!ufshcd_is_clkgating_enabled(hba)" - if
clk gating is enabled, we should let gating happen but not bail, right?

That said, I don't think we need to check whether clk gating is enabled 
or
not here, since ufshcd_clkgating_store() manipulates 
clk_gating->active_reqs
in an atomic way. If someone disables clk gating -> 
clk_gating->active_reqs++,
this check becomes TURE on the very first condition.

So the very fisrt patch looks better to me.

Thanks,

Can Guo.

>  		return;
> 
>  	hba->clk_gating.state = REQ_CLKS_OFF;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 8344d8cb3678..09e59cb86e69 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -814,6 +814,11 @@ static inline bool
> ufshcd_is_auto_hibern8_supported(struct ufs_hba *hba)
>  		!(hba->quirks & UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8);
>  }
> 
> +static inline bool ufshcd_is_clkgating_enabled(struct ufs_hba *hba)
> +{
> +	return hba->clk_gating.is_enabled;
> +}
> +
>  static inline bool ufshcd_is_auto_hibern8_enabled(struct ufs_hba *hba)
>  {
>  	return FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) ? true : 
> false;
