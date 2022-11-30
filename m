Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6FAC4321E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 17:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiK3Ru4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 12:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiK3Ruh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 12:50:37 -0500
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8327A8B183
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 09:49:16 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id s196so16771596pgs.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 09:49:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QODGe8XQrN2AfrxhMBF7VvZeMPDvCS3eDqJW1xbLQYg=;
        b=gXxWfYKRW3xoOH6Cl+OQp3FFTAaMOPyC77FBSn+Yuacze1gJf+7MR8ctKLC9RJ6JOV
         y17SDHI4G2t2sQ/x/CisFGnITOP+8lmcdDcHM3CViAN9cKZ+tFG9MALOg8xyNq5/Jzrb
         In4foPLb696IU0cQT2uTGFivScng+U4RZxJLva61BEYPJEyDrvlrR2yl0bj91MdI9HEp
         3SnWLXT/qDQTNuQvPU4nQFZlA5hstIQXLkNDJU8jc/DcD1hkvnLBAzDuk/FDbZ6rcvRw
         nLR3ymkZpxt6DWFIQIWAubiB5aZl5rWt30mGGZXsvhciuvfS905H3+ZqKVY+2zn8vS/A
         Ku7w==
X-Gm-Message-State: ANoB5pk+JKVcql73a/zuQi6ta83c+QKpuMqHuEtX4V/smCLi6tfWtxvr
        74WiFYx48lxkrJuI0hj9HWE=
X-Google-Smtp-Source: AA0mqf7Thgy/URFKtK7bJBJgxBHxENZbJRZTowkER0TCYeV6b7x7JFFIrmvxitWNrTDEKMJpsmTZvg==
X-Received: by 2002:a62:84c5:0:b0:574:32ac:a47a with SMTP id k188-20020a6284c5000000b0057432aca47amr39706827pfd.7.1669830555943;
        Wed, 30 Nov 2022 09:49:15 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:3729:bd90:53d2:99e3? ([2620:15c:211:201:3729:bd90:53d2:99e3])
        by smtp.gmail.com with ESMTPSA id e68-20020a621e47000000b00574db8ca00fsm1652367pfe.185.2022.11.30.09.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 09:49:14 -0800 (PST)
Message-ID: <5e00ce60-3859-4964-11f7-e036f6dda56a@acm.org>
Date:   Wed, 30 Nov 2022 09:49:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v1] ufs: core: wlun suspend SSU fail recovery
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>, peter.wang@mediatek.com,
        stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
References: <20221101142410.31463-1-peter.wang@mediatek.com>
 <98bfafd3-c7b7-89b5-497a-aa694d0152dd@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <98bfafd3-c7b7-89b5-497a-aa694d0152dd@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/22 02:17, Adrian Hunter wrote:
> On 1/11/22 16:24, peter.wang@mediatek.com wrote:
>> From: Peter Wang <peter.wang@mediatek.com>
>>
>> When SSU fail in wlun suspend flow, trigger error handlder and
> 
> handlder -> handler
> 
> Why / how does SSU fail?

I'm not sure but the issue that Peter is trying to fix with this patch 
may already have been fixed by my patch series "Fix a deadlock in the 
UFS driver".

Thanks,

Bart.

