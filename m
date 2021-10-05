Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC18C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 19:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AD566103E
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 19:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbhJETIU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 15:08:20 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:46623 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhJETIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 15:08:19 -0400
Received: by mail-pl1-f172.google.com with SMTP id w11so55221plz.13
        for <linux-scsi@vger.kernel.org>; Tue, 05 Oct 2021 12:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EJpVQNUGAqyh0WTNrqFfXmd/qkbYjw6bkWwlBlUflU4=;
        b=SI4jzNa89clpPevpe3KTsfkPGoZ8PSmiWG7qC1u4TIeMaA93bLS1BJGBJwDOARyizE
         dJtrz9WdfwqGyDsV7NQhNBXST9dgOkB32+ovQma+IbexyQ8O0hBa+LJA/Wee7LYKaMnq
         NqE8DPotDIr6Ba//Xp4vD32WOsmkJ+XMJ5fSH6ED/n9U2/JgY0aX99gMELhpv/h9sqzN
         dFIG+FB951zh+g1n6eh+8sYp3EcgFPh2zVSZH8R1LaUvwOePCu8XaaNfW0XwtusQ1PfJ
         syjTbLwsDuGvFveZO1Hm6XdbPsXiyeLOAWuyELi/i1GYbEM+2VtLgwQqBTV32gqezmNX
         SdkA==
X-Gm-Message-State: AOAM532WFT6Pb/urc7WPuDKAWOGvnL11gv1euGXhQkTF0DTh+kv7nXIF
        JBxnxBgBTZZwQXrIEGWYmZ79A/MVGTk=
X-Google-Smtp-Source: ABdhPJz3AmTzLc6CB/FGSGmEKzgaBTcnlDEfTMMtJwoQE/BpPGaVRzptMARiUmOnKwwhJpotuUWmuw==
X-Received: by 2002:a17:902:e0c2:b0:13e:7f73:f181 with SMTP id e2-20020a170902e0c200b0013e7f73f181mr6707506pla.10.1633460788223;
        Tue, 05 Oct 2021 12:06:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:e8fc:af57:dd49:3964])
        by smtp.gmail.com with ESMTPSA id u1sm2767997pje.47.2021.10.05.12.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 12:06:27 -0700 (PDT)
Subject: Re: [PATCH RFC 2/6] scsi: ufs: Rename clk_scaling_lock to host_rw_sem
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20211004120650.153218-1-adrian.hunter@intel.com>
 <20211004120650.153218-3-adrian.hunter@intel.com>
 <453b33d4-4e53-3b31-ef9a-3a63989de7a8@acm.org>
 <a94a44e0-ff6e-6521-7822-134b7211ddca@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9d81c691-3b1b-081a-8a2d-b2cb51ec26d0@acm.org>
Date:   Tue, 5 Oct 2021 12:06:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a94a44e0-ff6e-6521-7822-134b7211ddca@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/4/21 10:06 PM, Adrian Hunter wrote:
> On 04/10/2021 19:52, Bart Van Assche wrote:
>> I'm concerned that
>> this will prevent to fully benefit from multiqueue support. Has it been
> 
> You are talking about contention between ufshcd_queuecommand() running
> simultaneously on 2 CPUs right?  In that case, down_read() should be practically
> atomic, so no contention unless a third process is waiting on down_write()
> which never happens under normal circumstances.
> 
>> Has it been
>> considered to eliminate the clk_scaling_lock and instead to use RCU to
>> serialize clock scaling against command processing? One possible approach is to
>> use blk_mq_freeze_queue() and blk_mq_unfreeze_queue() around the clock scaling
>> code. A disadvantage of using RCU is that waiting for an RCU grace period takes
>> some time - about 10 ms on my test setup. I have not yet verified what the
>> performance and time impact would be of using an expedited RCU grace period
>> instead of a regular RCU grace period.
> 
> It is probably worth measuring the performance of clk_scaling_lock first.

Upcoming UFS devices support several million IOPS. My experience, and that of
everyone else working with such storage devices is that every single atomic
operation in the hot path causes a measurable performance overhead.
down_read() is a synchronization operation and implementing synchronization
operations without using atomic loads or stores is not possible. This is why
I see clk_scaling_lock as a performance bottleneck.

Thanks,

Bart.


