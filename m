Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC15C6FA8F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 17:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjH2RI7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 13:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237203AbjH2RIY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 13:08:24 -0400
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C534FC
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 10:08:21 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6bca3311b4fso3386943a34.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 10:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693328900; x=1693933700;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=34xysteFXtIeD/9v4k2P9zCOodV4mwgQ1ZAO+uSmcnQ=;
        b=ZcaaMBUK8H2Y2CKt42djQWkngh3DyagiKl7pgNCUwHjnryY2tk+b5ZWzEkS58qj+KX
         JhAKcrVEr+Ihs4PV4AlVItedjRJ9Xo5HLT89r8ymAxXUABccJ+cMqxG2SEyQSngWH63G
         6hJg0F1YdU5ljTSKxlxrlLyxKLK7KtCVXBOhzVVY5QH77ZnZAUGQrs1rdKt3Yln5zhlg
         Tnju8Pup6zVz301TueTo1RAEl/feh8COIlOPKYEIj0NAAHoEnlwNrFlAdVQQ/oGbKNn0
         sTCQR6XGyIPb2zV0GUHMkQk5t0c/xc58ODXDeCed5S+dohU4vLaJLu6WKAcWg0HhPr4y
         FELw==
X-Gm-Message-State: AOJu0Yz/5BBZkfwX++hY8MEtxi+woWG2CJmUV2Whbs8l+EJst4F0wp0N
        kN2uyYuwn5JP+jDjaq72HLQ=
X-Google-Smtp-Source: AGHT+IHq3K+K7sMsWcudCmDgfnfRY6EhgE49ac9ZBemSBFawT7JhVsiceDdG9H7k/Pz+idVXEjtHoQ==
X-Received: by 2002:a05:6871:5214:b0:1c8:c27f:7dbb with SMTP id ht20-20020a056871521400b001c8c27f7dbbmr18790350oac.41.1693328899927;
        Tue, 29 Aug 2023 10:08:19 -0700 (PDT)
Received: from [172.20.4.71] ([208.98.210.70])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b001bf5e24b2a8sm9595806plf.174.2023.08.29.10.08.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 10:08:19 -0700 (PDT)
Message-ID: <0bff609c-48d7-482c-9cba-9643a5d33686@acm.org>
Date:   Tue, 29 Aug 2023 10:08:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] ufs: core: only suspend clock scaling if scale
 down
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
        naomi.chu@mediatek.com
References: <20230823092948.22734-1-peter.wang@mediatek.com>
 <20230823092948.22734-2-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230823092948.22734-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/23/23 02:29, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> If clock scale up and suspend clock scaling, ufs will keep high
> performance/power mode but no read/write requests on going.
> It is logic wrong and have power concern.
> 
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
>   

Is this perhaps the same patch as
https://lore.kernel.org/linux-scsi/20230801133458.6837-1-peter.wang@mediatek.com/ 
?

Thanks,

Bart.
