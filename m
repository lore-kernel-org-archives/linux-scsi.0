Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7735FC5519F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 03:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24AF222210
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 03:55:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="FR38yKV5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgKRDy4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 22:54:56 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:20164 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbgKRDyy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 22:54:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605671693; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ZpMUv3oK49C6eOBaaI0CLod60nuTQ9Tc+mFUPGAV3Ng=;
 b=FR38yKV5F/MHb3oaDL+8QZe076MRvfr/8n1lWyLHrR7Zbof+yOuKiZRohEWDz3j9ArSpQniO
 xNrpfVQQt4v1Y4S06GHK4fQ0gRPQizImiGSpGs0XDcsUA3cwI7Nxj4stWvtEFpvNbQbgIBOX
 K5e7mnd4H3b0zge6jZPoutHoNtA=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5fb49b0d6c42d983b9353405 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 03:54:53
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 79F3CC43465; Wed, 18 Nov 2020 03:54:52 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CE19CC433ED;
        Wed, 18 Nov 2020 03:54:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 11:54:51 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com
Subject: Re: [PATCH v5 1/7] scsi: ufs: avoid to call REQ_CLKS_OFF to CLKS_OFF
In-Reply-To: <20201117165839.1643377-2-jaegeuk@kernel.org>
References: <20201117165839.1643377-1-jaegeuk@kernel.org>
 <20201117165839.1643377-2-jaegeuk@kernel.org>
Message-ID: <9947ab24ad74d77b96e9f09523f25e1a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-18 00:58, Jaegeuk Kim wrote:
> Once UFS was gated with CLKS_OFF, it should not call REQ_CLKS_OFF 
> again, which
> caused hibern8_enter failure.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b8f573a02713..cc8d5f0c3fdc 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1745,7 +1745,8 @@ static void __ufshcd_release(struct ufs_hba *hba)
>  	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
>  	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
>  	    ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks ||
> -	    hba->active_uic_cmd || hba->uic_async_done)
> +	    hba->active_uic_cmd || hba->uic_async_done ||
> +	    hba->clk_gating.state == CLKS_OFF)
>  		return;
> 
>  	hba->clk_gating.state = REQ_CLKS_OFF;
