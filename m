Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC82C83F12
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 17:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjH2REj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 13:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237635AbjH2REb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 13:04:31 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C5BAD
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 10:04:28 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1c0ecb9a075so17532385ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 10:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693328668; x=1693933468;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2g0z4vCZFb+xWLqle7EKEHd+VDY8EWLsCC+AfA6tqOs=;
        b=Kxfa1cQsQRuF09l2tI/xSQRUDYEq2INybI56cY8DUisz5orRoaYJH4dynyU1TlUTt1
         K8qmVzJX3CHO5ri2tKOi1QOYYzRDYtvb2l43uoqPM9+CRH3rKWRy/U+DRV+VIXJjS3px
         SLnxMgHUb0Xpap21d8j/w9VexSsqmNNMjOIcIChN/+XV5qaIhnxwDx6rgoThprKO7I18
         RxG3DSF7fuFMT3Rd0YO2pqLQx1xQM8V+p6J81d6GZEkYbBdtQG5em3TTlR/qXlOUx1nC
         IROgdKIe9m9vp5EXygAuuUUqxUeeuH3wp+5Gtbpq3QaCvp7FvJabKmWv4OHKXo/5I7ec
         nY2Q==
X-Gm-Message-State: AOJu0YyGbdt3hVU9K9XAKa8ac2xqpNevqN165JveY2ygIKWVArN1vWjq
        yje5thNme2/Pm9Zu1c2I22CM7JpHr/kR7Q==
X-Google-Smtp-Source: AGHT+IHiJckEqm4LFnNq/w9OvpLfNZxILPMYlHefKaZGTyCwiwalEX9NdlsSYfbsRNeAcP+QUiKe6Q==
X-Received: by 2002:a17:902:c945:b0:1b8:78e:7c1 with SMTP id i5-20020a170902c94500b001b8078e07c1mr31350884pla.51.1693328667919;
        Tue, 29 Aug 2023 10:04:27 -0700 (PDT)
Received: from [172.20.4.71] ([208.98.210.70])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b001bf5e24b2a8sm9595806plf.174.2023.08.29.10.04.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 10:04:27 -0700 (PDT)
Message-ID: <468fb5a4-32d5-42a7-b00f-115044954125@acm.org>
Date:   Tue, 29 Aug 2023 10:04:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] ufs: core: fix abnormal scale up after last cmd
 finish
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
 <20230823092948.22734-3-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230823092948.22734-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/23/23 02:29, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> When ufshcd_clk_scaling_suspend_work(Thread A) running and new command
> coming, ufshcd_clk_scaling_start_busy(Thread B) may get host_lock
> after Thread A first time release host_lock. Then Thread A second time
> get host_lock will set clk_scaling.window_start_t = 0 which scale up
> clock abnormal next polling_ms time.
> 
> Below is racing step:
> 1	hba->clk_scaling.suspend_work (Thread A)
> 	ufshcd_clk_scaling_suspend_work
> 2		spin_lock_irqsave(hba->host->host_lock, irq_flags);
> 3		hba->clk_scaling.is_suspended = true;
> 4		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
> 		__ufshcd_suspend_clkscaling
> 7			spin_lock_irqsave(hba->host->host_lock, flags);
> 8			hba->clk_scaling.window_start_t = 0;
> 9			spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
> 	ufshcd_send_command (Thread B)
> 		ufshcd_clk_scaling_start_busy
> 5			spin_lock_irqsave(hba->host->host_lock, flags);
> 			....
> 6			spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>   drivers/ufs/core/ufshcd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index e3672e55efae..017f32b3a789 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1385,9 +1385,10 @@ static void ufshcd_clk_scaling_suspend_work(struct work_struct *work)
>   		return;
>   	}
>   	hba->clk_scaling.is_suspended = true;
> +	hba->clk_scaling.window_start_t = 0;
>   	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
>   
> -	__ufshcd_suspend_clkscaling(hba);
> +	devfreq_suspend_device(hba->devfreq);
>   }
>   
>   static void ufshcd_clk_scaling_resume_work(struct work_struct *work)

There is a second __ufshcd_suspend_clkscaling() call in the same source
file. Please fix that call too.

Thanks,

Bart.
