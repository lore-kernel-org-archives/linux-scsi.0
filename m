Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72815C41513
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 19:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354319AbjHQTNu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 15:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354325AbjHQTNl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 15:13:41 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F378C2135;
        Thu, 17 Aug 2023 12:13:39 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-53fa455cd94so131180a12.2;
        Thu, 17 Aug 2023 12:13:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692299619; x=1692904419;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ArvvBCOPf5okQGMkT9cId1pWGA9y4S0Bgbh2qZElm1k=;
        b=HJvKl8jL1e08Qzyg8oW8exoWScEtjyvJ57/C2OQw8cOeH0CyqJjmDK3FzucWHpmrgA
         2O6PkY0cRgzwINpm7vyw4X1vE4C0b4Cen/voyGzrY0JHN6bZyV9qTxGPhMaIA+939pps
         sp32OO7iBWZwbaLBGrRBbTqhvhSzyPO17y7xpZ2IS+AZumZabyNLKqObOoLiCVUfEdwj
         3lM9R37WO5Ol3XfWjAbqR/eyY7JAoeKluZW9lebuSBgwXuoMqWcgmHIsRiZT/MVUcRfW
         vYSUmzJz+HirWXp0CtV9W6Pt6ErouAjse/m3cSWZU/CdcKeQd5serXHHiXpuPCatr0Lf
         rf4A==
X-Gm-Message-State: AOJu0YzBv+izmbQba8kJezLA8BztZOc0EnBml5oPRnO2YcZQF2HV8//4
        XDPOS8WGbQ3r0LPUwH47rC8=
X-Google-Smtp-Source: AGHT+IHUMGTkyXfuSP8AAYtyjLxPTmNBe2qQDAjaut5cPLQe+B60Sz4IkE6Z17hYOC4WqTEaeK3jEg==
X-Received: by 2002:a17:90a:f3d5:b0:269:3cdb:4edf with SMTP id ha21-20020a17090af3d500b002693cdb4edfmr351268pjb.16.1692299619284;
        Thu, 17 Aug 2023 12:13:39 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:dfd:6f25:f7be:a9ca? ([2620:15c:211:201:dfd:6f25:f7be:a9ca])
        by smtp.gmail.com with ESMTPSA id mj3-20020a17090b368300b0026b12768e46sm145570pjb.42.2023.08.17.12.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Aug 2023 12:13:38 -0700 (PDT)
Message-ID: <df642697-8c3d-c945-5b8f-e477a1e551d6@acm.org>
Date:   Thu, 17 Aug 2023 12:13:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v9 12/17] scsi: ufs: mediatek: Rework the code for
 disabling auto-hibernation
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-13-bvanassche@acm.org>
 <3b1caab8-c95e-eb81-57ef-21b746795ba6@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3b1caab8-c95e-eb81-57ef-21b746795ba6@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 11:40, Bao D. Nguyen wrote:
> On 8/16/2023 12:53 PM, Bart Van Assche wrote:
>> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
>> index e68b05976f9e..a3cf30e603ca 100644
>> --- a/drivers/ufs/host/ufs-mediatek.c
>> +++ b/drivers/ufs/host/ufs-mediatek.c
>> @@ -1252,7 +1252,7 @@ static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
>>       int ret;
>>       /* disable auto-hibern8 */
>> -    ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
>> +    ufshcd_auto_hibern8_update(hba, 0);
> 
> Since you now use ufshcd_auto_hibern8_update(), the caller should not need to check for ufshcd_is_auto_hibern8_supported() because this is already part of the hibern8_update(). Suggest remove the if statement from the caller.
 >
> 
>      if (ufshcd_is_auto_hibern8_supported(hba))
>          ufs_mtk_auto_hibern8_disable(hba);
> 
>>       /* wait host return to idle state when auto-hibern8 off */
>>       ufs_mtk_wait_idle_state(hba, 5);

I think that check in the caller is still useful to skip the wait loop in
ufs_mtk_auto_hibern8_disable() if auto-hibernation is not supported.

Thanks,

Bart.


