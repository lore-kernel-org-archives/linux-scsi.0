Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6821C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 18:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiHBSqS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 14:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiHBSqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 14:46:17 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876DE33A00
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 11:46:16 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so16294847pjf.5
        for <linux-scsi@vger.kernel.org>; Tue, 02 Aug 2022 11:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=MBwOPQs1CzRtLk4HN0C9Pmc9BYea+vGTzRIRfwnFt70=;
        b=fShTaEoz4FMwyYNtwMZBRuOUbI7OqmBdOpwvXN/tU383pjUD/qz0q9MwcAGMNjSHio
         EfBBzNdQxxfQ2eIjYIrAetnrSifTg8eeltZwEIOIauaj6YgnpaoQIkz7cFNuOYjwh3Hj
         Vdhe1s6CwN96l1SIrGw+T1RnURF4rSU3dgARpa/7nmlyRFkxJJbpwBIwq0lNHfjZWvDA
         NGn5AX4dafkLaXgeV4LuENkNytAU33uF9Ujhq8Aj0ONqBV0kjB0OiM+dFzK4ZLGGxLcg
         fUgpK99+ycDl7tBJoF+fORBg9BgmI2LezJCfdD+rvsXtKQ/EpV28tKCTaCJCNqTbS3Ac
         KsCw==
X-Gm-Message-State: ACgBeo0zoFRrrFTlU9hjI9IrL4CJ4BXh2ni33aeOzTHoRpLI2PyScSdc
        d7tcXrgeILQbasiMJ4ME+ww=
X-Google-Smtp-Source: AA6agR7/aVEzG18zydnBcenmndozfbiF/e630iNJcHBapYnTwzteCDzo2tfVHpzB03knxO5qiEvRDw==
X-Received: by 2002:a17:902:e844:b0:16f:9d2:f4ff with SMTP id t4-20020a170902e84400b0016f09d2f4ffmr2889063plg.27.1659465975878;
        Tue, 02 Aug 2022 11:46:15 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:5297:9162:3271:e5df? ([2620:15c:211:201:5297:9162:3271:e5df])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902d49200b0016d737bff00sm18275plg.220.2022.08.02.11.46.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 11:46:15 -0700 (PDT)
Message-ID: <517895b7-95ed-5e83-fb6d-98e155b896d4@acm.org>
Date:   Tue, 2 Aug 2022 11:46:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 2/2] ufs: host: support wb toggle with clock scaling
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220802143223.1276-1-peter.wang@mediatek.com>
 <20220802143223.1276-3-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220802143223.1276-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/2/22 07:32, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> Set UFSHCD_CAP_WB_WITH_CLK_SCALING for qcom to compatible legacy design.
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>   drivers/ufs/host/ufs-qcom.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index f10d4668814c..f8c9a78e7776 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -869,7 +869,7 @@ static void ufs_qcom_set_caps(struct ufs_hba *hba)
>   	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>   
>   	hba->caps |= UFSHCD_CAP_CLK_GATING | UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
> -	hba->caps |= UFSHCD_CAP_CLK_SCALING;
> +	hba->caps |= UFSHCD_CAP_CLK_SCALING | UFSHCD_CAP_WB_WITH_CLK_SCALING;
>   	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
>   	hba->caps |= UFSHCD_CAP_WB_EN;
>   	hba->caps |= UFSHCD_CAP_CRYPTO;

A patch series should be bisectable. Without this patch the previous 
patch in this series introduces a regression for Qualcomm controllers. 
So I think that the two patches should be combined into a single patch.

Thanks,

Bart.
