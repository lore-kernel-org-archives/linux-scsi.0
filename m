Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54660C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 09:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCF532225F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 09:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="nIpAQEBp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgJSJSg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 05:18:36 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:34649 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729941AbgJSJSg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 05:18:36 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603099115; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=214UCzHFLDONI35AQrRDMUkpfaFdQ/OBZ1szzBN82CI=;
 b=nIpAQEBpfZMqXDuAbKMdF8iSLRwsVvMBeq3dJb3ten0NHWbbDom9kN8Gohw9zmoZXo50Djc3
 TzCZM+Ditl2g2++3AR8rPIBaclTsgCVHNzcjUw/OJZGRYBAQcaHFsdLxVkxOAQTBsxJclC18
 AOUmCyAZuh0T3iiCIa1uFDGZ/mE=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f8d59cc57b88ccb5608102f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 19 Oct 2020 09:18:04
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4C427C43382; Mon, 19 Oct 2020 09:18:04 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E61CC433FE;
        Mon, 19 Oct 2020 09:18:03 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 19 Oct 2020 17:18:03 +0800
From:   Can Guo <cang@codeaurora.org>
To:     jaegeuk@kernel.org, Asutosh Das <asutoshd@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v2] scsi: ufs: fix clkgating on/off correctly
In-Reply-To: <20201016211826.GA3441410@google.com>
References: <20201016060259.390029-1-jaegeuk@kernel.org>
 <20201016211826.GA3441410@google.com>
Message-ID: <b03c5b39506381577ea049a38a342adf@codeaurora.org>
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

Thanks for fixing it, actually we have noticed this for a while.
It used to work well, please add a Fixes tag or mention the commit
which breaks clk gating functionality - the commit which introduces
func ufshcd_any_tag_in_use().

Regards,

Can Guo.

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
