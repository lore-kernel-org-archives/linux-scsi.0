Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB5EEE49B0
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 16:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237546AbjHWQ0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 12:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237561AbjHWQ0g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 12:26:36 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C657010E0;
        Wed, 23 Aug 2023 09:26:28 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1bc8a2f71eeso38431285ad.0;
        Wed, 23 Aug 2023 09:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692807988; x=1693412788;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k1Ik3NbSu/OHRXNMCFvLBT9/b05UkIh4Bdi7YU49cKU=;
        b=KFmdlP33lgxecPJ49xvNjo7LmrRL6s5bGGoTnawfKtwnYyVZpgj2ONOY8VqJxL1Ks5
         G25O6YF2Up9S//4/XCQR6cBAqJJ9z3k1v2+Vr6/vwknhL/v/eB9V0OEa+DNm1tb7BYAN
         4LAD5utUsELV8speoHouDQh5ZC9ZOqDmK+qLiihPxvsfz7kTHbf2Nh1YKn4GUC7gLDe0
         vyfUwCv/n5dhFkaCfJn0dwBwoVB7BsULuTzNgvtf0fm7ANeW7DW7TvqZanyR4Objfpzj
         jXMCL72Nl+6KM6jUi1EmY3WISY+lwO0OcbmeRPJRLY20UOeHIJr1coFJivvMQaFBze80
         SSjA==
X-Gm-Message-State: AOJu0YzKvAcCnOodmNH6yeM7PciZAVHYyFfo6pVDDSAG8xbuyVlULoZY
        xKaWg9RDoPskaFaCdplg1/NbYKE6zJ8=
X-Google-Smtp-Source: AGHT+IESYJf+m/xOvi/msi/qj+ggKweXXA5GfyTd1ZL44qcSqKH2Z7GVhEkGmV0dPjElPqFZRZ98tA==
X-Received: by 2002:a17:902:f687:b0:1bf:3094:32eb with SMTP id l7-20020a170902f68700b001bf309432ebmr12051833plg.50.1692807987993;
        Wed, 23 Aug 2023 09:26:27 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ecb6:e8b9:f433:b4b4? ([2620:15c:211:201:ecb6:e8b9:f433:b4b4])
        by smtp.gmail.com with ESMTPSA id ik20-20020a170902ab1400b001b9da8b4eb7sm11351984plb.35.2023.08.23.09.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Aug 2023 09:26:27 -0700 (PDT)
Message-ID: <b4a5fa6a-e67b-d010-b704-2d7379bf2a3b@acm.org>
Date:   Wed, 23 Aug 2023 09:26:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v1] ufs: core: only suspend clock scaling if scale down
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, stable@vger.kernel.org
References: <20230801133458.6837-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230801133458.6837-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 06:34, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> If clock scale up and suspend clock scaling, ufs will keep high
> performance/power mode but no read/write requests on going.
> It is logic wrong and have power concern.
> 
> Fixes: 401f1e4490ee ("scsi: ufs: don't suspend clock scaling during clock gating")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>   drivers/ufs/core/ufshcd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 129446775796..e3672e55efae 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1458,7 +1458,7 @@ static int ufshcd_devfreq_target(struct device *dev,
>   		ktime_to_us(ktime_sub(ktime_get(), start)), ret);
>   
>   out:
> -	if (sched_clk_scaling_suspend_work)
> +	if (sched_clk_scaling_suspend_work && !scale_up)
>   		queue_work(hba->clk_scaling.workq,
>   			   &hba->clk_scaling.suspend_work);

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
