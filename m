Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9228FCDB482
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 16:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjJMQdm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 12:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjJMQdl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 12:33:41 -0400
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFC3BB
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 09:33:40 -0700 (PDT)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1e1b1b96746so1286816fac.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 09:33:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697214820; x=1697819620;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kTN2loqrcEaBYbY1WHMRH/B8y09M49Nf4CIuqrkaHwM=;
        b=YhCA1l8vnegKGBvPfj9RSfik5XHluYJc6vV199DW5rkr9Iy1Y1X8JewIMijtwwQbnv
         eR4ilkZuJKsZGn7/Qo1Bt/hS36yiPpZSShRfYhFnas9om2WvoAKLgC9jSMyFvaDTvGIo
         xaJnixhqkxcP6iZtSBI2N41r5sw3SbvqSYrMPijLddL5AhbOBKfts3aRC4MdjM6JLzPr
         5sYVWzCVuvBIsOm/odXSx9OwAiLQYofdsWEf+3tMPAtTrry4cxH3DjCEFM9S1VgubJdS
         cwpf0uuNOSCSzGCDB1iwDGgF0qFPojqg0h6VQKKJQ2JzzJeyrEOcrGeuJNZJKHePkSEH
         ELfA==
X-Gm-Message-State: AOJu0Yyu6a7GnoSYJOzQVWxGlzvDxcO+m9nfARBgTtKtraBnzdEakX3L
        EI/Ida+s+yN9BBQrnvXqfJ4ovEbopF/rZQ==
X-Google-Smtp-Source: AGHT+IErzh9fHI8XgM9IAnJuH3I/OxiTpALdkmg+1lAEo52E44ghLqKHqaBGLD4ZVEM3FM4nPb3ZOQ==
X-Received: by 2002:a05:6870:8181:b0:1e9:b653:94d with SMTP id k1-20020a056870818100b001e9b653094dmr5709127oae.1.1697214819921;
        Fri, 13 Oct 2023 09:33:39 -0700 (PDT)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id c14-20020a63724e000000b005897bfc2ed3sm3581014pgn.93.2023.10.13.09.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Oct 2023 09:33:39 -0700 (PDT)
Message-ID: <dd6f13e7-ae2f-4821-849d-8ca43ad48144@acm.org>
Date:   Fri, 13 Oct 2023 09:33:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ufs: core: fix abnormal scale up after last cmd
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
References: <20230831130826.5592-1-peter.wang@mediatek.com>
 <20230831130826.5592-3-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230831130826.5592-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/31/23 06:08, peter.wang@mediatek.com wrote:
> When ufshcd_clk_scaling_suspend_work(Thread A) running and new command
> coming, ufshcd_clk_scaling_start_busy(Thread B) may get host_lock
> after Thread A first time release host_lock. Then Thread A second time
> get host_lock will set clk_scaling.window_start_t = 0 which scale up
> clock abnormal next polling_ms time.
> Also inlines another __ufshcd_suspend_clkscaling calls.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
