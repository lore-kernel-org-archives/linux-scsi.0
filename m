Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5F0C4363D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 00:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E73121707
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 00:57:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="bVWezeCM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439780AbgJUA5s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 20:57:48 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:24539 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393832AbgJUA5s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 20:57:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603241867; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=qGge+OiVZHcS6eMn06MDb+HUQOh85jgQH0fDblnbuxQ=;
 b=bVWezeCMUVu02nCaHPSzL5/hXPcFsWcXG+QxZ2eUtFH9vpkeg+AyuLrXXQDenSVyL2wLfuxj
 ao+Ggz+9I25VMNFr+XTeQbDVBusGDN9RiroRfoEB22o+d3P0mSlZ4f12QqEtlt14oKYRr7nj
 70WsYHgh4fEpXMy7Y+m1cr2pkm8=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f8f877eef891f1ee27b93c3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 21 Oct 2020 00:57:34
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8C044C433F1; Wed, 21 Oct 2020 00:57:33 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9950AC433C9;
        Wed, 21 Oct 2020 00:57:32 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 21 Oct 2020 08:57:32 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com,
        Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v2 3/5] scsi: ufs: use WQ_HIGHPRI for gating work
In-Reply-To: <20201020195258.2005605-4-jaegeuk@kernel.org>
References: <20201020195258.2005605-1-jaegeuk@kernel.org>
 <20201020195258.2005605-4-jaegeuk@kernel.org>
Message-ID: <d6e794548891f81a579cda138cd1529e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-21 03:52, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> Must have WQ_MEM_RECLAIM
> ``WQ_MEM_RECLAIM``
>   All wq which might be used in the memory reclaim paths **MUST**
>   have this flag set.  The wq is guaranteed to have at least one
>   execution context regardless of memory pressure.
> 

You misunderstood my point. I meant you need to give more info about why
we are adding WQ_HIGHPRI flag but not why WQ_MEM_RECLAIM must be there.

Thanks,

Can Guo.

> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index feb10ebf7a35..0858c0b55eac 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1867,7 +1867,7 @@ static void ufshcd_init_clk_gating(struct ufs_hba 
> *hba)
>  	snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clk_gating_%d",
>  		 hba->host->host_no);
>  	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
> -							   WQ_MEM_RECLAIM);
> +					WQ_MEM_RECLAIM | WQ_HIGHPRI);
> 
>  	hba->clk_gating.is_enabled = true;
