Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0A8C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 21:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbiGVVM6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 17:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGVVM5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 17:12:57 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C3EB504E
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 14:12:56 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id b9so5428371pfp.10
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 14:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c9WsKYP78qtCT0ErIavQs+Q5NIpoTLGobCYxRumep4k=;
        b=rozp5YkTmNhjxR799z5Tm4F35y0w4+9bD94A3R53RSP42D/VdJtorQuS0nyH7PQYxT
         U9di2qOdcs1HU1m4uKjiQccFXdA0tFWyTBPMvdjuXUyHXtUh9MMwD8ynMRUAoGlXUjYe
         hnPMB1W/ZRKqEVmBaSSRB4MJR2P9zjd1wTbkBfLxyTjwNLom3jE2u4d3wo5psuZh5FVu
         cYQDlPqlyjuLJEbyB2jBcjMuJATmPqRxGbuCb+jbjsRSTiNoCXMJ4fLXB2vkrkEQhGiP
         YqazM862Jt9a4WF4Fr/bq6/KnzDWlViOkpbLLhvJqNbh8Ym1grBzV7f8CWuJfdUwuV92
         vffg==
X-Gm-Message-State: AJIora/JZwqRPiD91aHovMkzMARB+fdMv6fhQk2fxAVWCvaP3cXcoK4b
        1Ti4LlOJ9Ib+QKbcpzLAmIM=
X-Google-Smtp-Source: AGRyM1skqTQGIq8EhXNOZW/llHdz3ok4Yt+f/wc47H+x9dyaLS8CpI3xeEkInEGO84kmTs6bP/YNog==
X-Received: by 2002:a05:6a00:1589:b0:52a:eb00:71d8 with SMTP id u9-20020a056a00158900b0052aeb0071d8mr1805063pfk.38.1658524376175;
        Fri, 22 Jul 2022 14:12:56 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:805b:3c64:6a1f:424c? ([2620:15c:211:201:805b:3c64:6a1f:424c])
        by smtp.gmail.com with ESMTPSA id i9-20020a628709000000b0052aca106b20sm4404311pfe.202.2022.07.22.14.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 14:12:55 -0700 (PDT)
Message-ID: <2f66f4ba-f0d5-6b8a-cc3b-fa896a302d60@acm.org>
Date:   Fri, 22 Jul 2022 14:12:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3] scsi: ufs: correct ufshcd_shutdown flow
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220721065833.26887-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220721065833.26887-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/20/22 23:58, peter.wang@mediatek.com wrote:
> Both ufshcd_shtdown and ufshcd_wl_shutdown could run concurrently.
> And it have race condition when ufshcd_wl_shutdown on-going and
> clock/power turn off by ufshcd_shutdown.
> 
> The normal case:
> ufshcd_wl_shutdown -> ufshcd_shtdown
> ufshcd_shtdown should turn off clock/power.
> 
> The abnormal case:
> ufshcd_shtdown -> ufshcd_wl_shutdown

How can this happen since device_shutdown() iterates over devices in the 
opposite order in which these have been created?

Thanks,

Bart.
