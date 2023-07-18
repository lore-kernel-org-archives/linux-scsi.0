Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD56FEB64DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Jul 2023 13:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjGRNSw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jul 2023 09:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjGRNSu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2023 09:18:50 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE204CA
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 06:18:49 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-66872d4a141so3672571b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 06:18:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689686329; x=1692278329;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7cYJfQ9bybbpwTSM3tOH76X9E/CnWa1aPBxNPHlvqGo=;
        b=JGgXE2lcXCniDLRaZ2NamcbNZSKoyIgFTB8ldtLlwlVv3wfTYnkM70/MLqgWR23Uqk
         t4L6Pj+/hx/2hAtiw0wwbzaXjZ7athE/fUf9ssusPpIvmzE9Sg/YeB6SslN2FpyW29EF
         ezRAUrUYfYSsXAFaGD993Q7Vu+bSk79nCey/MNrkiag3wkwvNUdns9cFQbI68CDn2e0p
         eKQiK9k/+Azdf/HQvmTW5DEwGWyMw17wl2I6bvGtS7+iYmIXEoNjPOcMYE7HGuBExmjt
         Nrlle8OLds2yVO6KLeVyt5As/BtN8VvHI95MfT2z0kIdJlYbmeO3sXwSxDmkBCHR+aE2
         Bgcw==
X-Gm-Message-State: ABy/qLY7DknJD/4Z1gjphXW3VS0hYrIpON3PJj24P+bB3KDzqCL7ZUdx
        2JhrK59s+wwaL9u65aVZna4=
X-Google-Smtp-Source: APBJJlGC3j95OJt9TjK/sz43BBVAYXFAXqsOeXSA1PctKpnaVxbveapvPH15gYRTJCXosWo7++u3MA==
X-Received: by 2002:a17:90a:c28f:b0:263:60af:54c5 with SMTP id f15-20020a17090ac28f00b0026360af54c5mr10356996pjt.35.1689686329168;
        Tue, 18 Jul 2023 06:18:49 -0700 (PDT)
Received: from ?IPV6:2601:642:4c05:a4:73b8:9fee:ec1e:4d12? ([2601:642:4c05:a4:73b8:9fee:ec1e:4d12])
        by smtp.gmail.com with ESMTPSA id er14-20020a17090af6ce00b0026309d57724sm6376153pjb.39.2023.07.18.06.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 06:18:48 -0700 (PDT)
Message-ID: <90b1d8d6-dbfe-efcb-45c6-c7d781b846b9@acm.org>
Date:   Tue, 18 Jul 2023 06:18:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] scsi: ufs: Remove HPB support
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Markus Fuchs <mklntf@gmail.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>
References: <20230717193827.2001174-1-bvanassche@acm.org>
 <46838112-007a-0245-8026-59e35b6e2415@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <46838112-007a-0245-8026-59e35b6e2415@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/17/23 23:43, Adrian Hunter wrote:
> On 17/07/23 22:36, Bart Van Assche wrote:
>> Interest among UFS users in HPB has reduced significantly.
> 
> Can you say more about why, or give some background?

Hi Adrian,

I haven't seen any recent changes in the HPB implementation - neither 
upstream nor in the Android kernel. That makes me wonder whether there 
are any HPB users left at all. If there are any HPB users left, it's 
time for them to speak up. Additionally, the work in JEDEC on a 
successor for HPB nears completion (Zoned storage for UFS or ZUFS).

My motivation for removing the HPB code is that I want to make 
blk_mq_run_hw_queue() faster if BLK_MQ_F_BLOCKING is set. The patch 
series I posted 
(https://lore.kernel.org/linux-block/20230717205216.2024545-1-bvanassche@acm.org/) 
may cause blk_execute_rq_nowait() to sleep. The HPB code is the only 
code I am aware of that calls blk_execute_rq_nowait() from a context 
where it is not allowed to sleep. If the HPB code is removed, I don't 
have to modify it to make it compatible with the blk_execute_rq_nowait() 
changes.

Bart.


