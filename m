Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A178BC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 17:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbiGYRHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jul 2022 13:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiGYRHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2022 13:07:50 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF41C17A8C
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 10:07:49 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id p1so2481369plr.11
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 10:07:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sw1p4Ct4038ajzG7YO2p29jpkoZuGnzz5bWfg0LQBtM=;
        b=Zg2/iwD9U4Au7UCB7xdtGkif0nWkNvdBWGdf+gIOrsb/v4ZF5WBt4WeGw1vd5LCPbg
         7N1SLhWGZhwSRsnll5tr9rARthefLC7LEjj6YhchdV4ux1sdLhqNPyim14qbYKCt0K/S
         28b0IrRUjGUkMHfQgKgYZkZeAFSP7DK7xsFD8X/2tfRpNUbaUegBH8oifY3nHpz2AnQa
         6er4eeWrEf7FcOdkh/H/FuIghDLm3f/7P3/VOhOEi+oo24FIZqJ0iwRaNIkNxWDikCP9
         j7f1n3d8/JL3ecTODP5A/J8c3jWQ9zrX9ixAPalM8ZL8GQQylg1+fg8AO/luqNpslQPx
         pwtQ==
X-Gm-Message-State: AJIora+1gTYkc2Kg67Jmt2PoRVSxk+kNlY83ytvGNlY4xpwk9IRxk7pf
        rEIVq/sv3w6ro7u5zARIEPM=
X-Google-Smtp-Source: AGRyM1unNMYA1GUxNbVV21SCt/CEhvRgmKS5ZtPL3ilnIkmvLlHcY5dIokCQMDpDtfBn4ZknBqhWVg==
X-Received: by 2002:a17:90a:5e0b:b0:1f0:5565:ee6e with SMTP id w11-20020a17090a5e0b00b001f05565ee6emr32488117pjf.128.1658768869293;
        Mon, 25 Jul 2022 10:07:49 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:54bc:1b55:1813:e7a8? ([2620:15c:211:201:54bc:1b55:1813:e7a8])
        by smtp.gmail.com with ESMTPSA id v188-20020a6261c5000000b0051b9ecb53e6sm9801300pfb.105.2022.07.25.10.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 10:07:48 -0700 (PDT)
Message-ID: <2edfdadc-2a93-591f-c5ca-98dc02a30499@acm.org>
Date:   Mon, 25 Jul 2022 10:07:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3] scsi: ufs: correct ufshcd_shutdown flow
Content-Language: en-US
To:     Peter Wang <peter.wang@mediatek.com>, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220721065833.26887-1-peter.wang@mediatek.com>
 <2f66f4ba-f0d5-6b8a-cc3b-fa896a302d60@acm.org>
 <090da948-0fce-9a89-0e1c-a26b3e0b735f@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <090da948-0fce-9a89-0e1c-a26b3e0b735f@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/24/22 20:47, Peter Wang wrote:
> Because kernel_restart is export, and mediatek may call kernel_restart 
                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Is this code upstream?

> while shutdown is on going.
> EXPORT_SYMBOL_GPL(kernel_restart);
> kernel_restart -> kernel_restart_prepare -> device_shutdown
> 
> So, there may have two thread execute device_shutdown concurrently.
> And the list_lock in device_shutdown function is not protect shutdown 
> callback function,
> caused two callback function(ufshcd_shutdown/ufshcd_wl_shutdown) could 
> run concurrently.
> 
> Here is the error log that two thread in device_shutdown.
> [37684.002227] [T1500641] platform +platform:112b0000.ufshci 
> kpoc_charger: ufshcd-mtk 112b0000.ufshci: [name:core&]shutdown
> [37684.002264] [T1600339] scsi +scsi:0:0:0:49488 charger_thread: 
> ufs_device_wlun 0:0:0:49488: [name:core&]shutdown

Hi Peter,

I had not yet taken a look at the kernel_restart() function. Now that I 
have taken a look, it seems to me that kernel_restart() calls must be 
serialized via the system_transition_mutex. Please make sure that the 
kernel_restart() calls are serialized.

Thanks,

Bart.
