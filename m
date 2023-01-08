Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A691AC54EBD
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Jan 2023 22:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjAHWop (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Jan 2023 17:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjAHWoo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jan 2023 17:44:44 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A2FF02A
        for <linux-scsi@vger.kernel.org>; Sun,  8 Jan 2023 14:44:43 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id l1-20020a17090a384100b00226f05b9595so5469931pjf.0
        for <linux-scsi@vger.kernel.org>; Sun, 08 Jan 2023 14:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p68y4K12HDXYnLzyQXi9BeSM304eUujIBK7ac777WUM=;
        b=c9kSqC2nLWkrGRvrzYNB9TEOxXtfPwm0g21TnvQt7Y1VMyoIyWtieZKuyYfNvpXZ7D
         THGidJnczt6HGf/GrHzPMwtroR/U8rT5eTiQm80tx2yCtvDTSuBA1v7mTP4pBlCwW3v8
         Ap2JBqNzB1jaD3LgPgw+2w1NZ87AwQRh/GTtJN2ZEp70/OeWmNpLiDPsRlmDr/gcoYGe
         GWD7EY0qaIMR1tj801XCd5V7w0CbJi2BWrEuMfxJHdoNdk6/sqpiJM7oTL6X+laWfalT
         9XvhjKQwaHVLA62UZk554dLI/ORMOGDhgAva6ye4ueYSRNoKw1MzKn69nw6FHn3clxUE
         kHDQ==
X-Gm-Message-State: AFqh2kpdDgSyIqP+xBWhrWNsg/s2MfXIvuay0UyqfMbu/h8a7NbJZRB9
        vOVW8kArHJYQLgz8Wu2MwMw=
X-Google-Smtp-Source: AMrXdXuxSqXGVSgtPlBfU2ia/pf3805nTU54ITcUJDDe9Xk2iHa1Lwh5+WxsDEd/xpoyB/suTCMKKg==
X-Received: by 2002:a17:903:31c2:b0:192:7447:adfe with SMTP id v2-20020a17090331c200b001927447adfemr47534286ple.36.1673217882621;
        Sun, 08 Jan 2023 14:44:42 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id f5-20020a170902ce8500b00178b9c997e5sm4610797plg.138.2023.01.08.14.44.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 14:44:41 -0800 (PST)
Message-ID: <8c7f62c9-3599-dda0-9db7-47fb31c37655@acm.org>
Date:   Sun, 8 Jan 2023 14:44:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 3/3] scsi: ufs: Enable DMA clustering
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20230106215800.2249344-1-bvanassche@acm.org>
 <20230106215800.2249344-4-bvanassche@acm.org>
 <DM6PR04MB657596A68F5A93F22D6F6C66FCF99@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657596A68F5A93F22D6F6C66FCF99@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/8/23 00:20, Avri Altman wrote:
>> All UFS host controllers support DMA clustering. Hence enable DMA clustering.
>>
>> Note: without patch "Exynos: Fix the maximum segment size", this patch breaks
>> support for the Exynos controller.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/ufs/core/ufshcd.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
>> be18edf4ef7f..fe83fdda8d23 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -8429,7 +8429,6 @@ static struct scsi_host_template
>> ufshcd_driver_template = {
>>          .max_host_blocked       = 1,
>>          .track_queue_depth      = 1,
>>          .sdev_groups            = ufshcd_driver_groups,
>> -       .dma_boundary           = PAGE_SIZE - 1,
 >
> Isn't DBC <= 256KB implies that for a boundary?

Hi Avri,

I don't think so. I think that the 256 KiB limit for the PRDT 
corresponds to the max_segment_size parameter. The dma_boundary 
parameter represents a boundary that must not be crossed by DMA 
scatter/gather lists. I'm not aware of any restrictions on DMA 
scatter/gather lists for UFS controllers other than the 256 KiB limit 
for a single PRDT and a limitation to 32-bits addresses for controllers 
that only support 32-bits DMA. The latter restriction is already handled 
by ufshcd_set_dma_mask().

Bart.

