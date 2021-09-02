Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A224AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 23:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EDBD60FDC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 23:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345419AbhIBXdW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345432AbhIBXdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 19:33:19 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A975C061757
        for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2021 16:32:20 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id q3so4674589iot.3
        for <linux-scsi@vger.kernel.org>; Thu, 02 Sep 2021 16:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hDXsOVX4DWQRKSpmXZqpCzSQEfu3SkuGOqTbKiVrB8g=;
        b=TqhzCjpycKGXatL/8fIxvn/iokhpSnk/TnLoqE0c9vcqalDD0DvENDuQPuaqtc5kxm
         MXV1OwcRNpSIaRljpRDzsxl1KNp0RrURqiLrmxsFUV1XsBmTWxM1AHpubB62o7ECm+PR
         Pe419Qiy6GHamVSExTKqDsuIaM6z5PoSQdCOdixH0ryto0QBFyemm6H0thysycIWOUEm
         OGZTccLd98rcEQRyaD6GQXhVwYcrnk6g0vrG3vhxJjE+uSYEhMxV4a5+Vz+ZD4IPCikt
         f+V16symS4Z/XTg8GmPqK4cksJohvjNVB286snis49yiYioLm4s8CqhkyjJGpuTn7gXP
         LkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hDXsOVX4DWQRKSpmXZqpCzSQEfu3SkuGOqTbKiVrB8g=;
        b=e+wGymWk4D7zepPKS4b0lY5OCAOJDGXEwQKeu4+Z7MgiZzO3HE8Xttxw/fy+2chpvx
         wSDu4TzW/2qzy9o03eZjaWNnmFwqGhtsx43AxPn90GYoNS1G5DvQY20BpCem7PIyVi6H
         sa91UbOf6HF1Ff6fxHN98Pou4VfYELT0CJx7vupAgi91YOOsRi4GsrnvS1vyNds4Ar5L
         iMHp4YDETpBeaPwU4Jd1BTonADGxk8t1v99y+Kd8J0qH6KzDAsOmVvOOVJ2mNs05s64r
         rgTuI9MlWRO/tzs8AZy08FAxMhHe7vYLxfV4I8/NPvvPMRNJTCTVbcMrGJ2Z+UDvV0mI
         YBxA==
X-Gm-Message-State: AOAM530y7glVILH0pkCJZlkx3nefGCzlgllN8BWf7zBmkrGabg6vv36h
        w3kWA0Kz7RZp4N+IBzp69U3oWg==
X-Google-Smtp-Source: ABdhPJxDKCuUUOT/96isH2RL+4xF7761TzATr8C7ea51+Y578l0+KGRxSyHVA+fum9oZZlFcjvK2+g==
X-Received: by 2002:a02:9542:: with SMTP id y60mr209790jah.87.1630625539626;
        Thu, 02 Sep 2021 16:32:19 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j5sm1670277ilu.11.2021.09.02.16.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 16:32:19 -0700 (PDT)
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.14+ merge window
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
References: <fc14fbbf0d7c27b7356bc6271ba2a5599d46af58.camel@HansenPartnership.com>
 <CAHk-=wi99u+xj93-pLG0Na7SZmjvWg6n60Pq9Wt9PgO6=exdUA@mail.gmail.com>
 <26c12f13870a2276f41aebfea6e467d576f70860.camel@HansenPartnership.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <18fc05ae-d167-9eee-de16-55223705819d@kernel.dk>
Date:   Thu, 2 Sep 2021 17:32:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <26c12f13870a2276f41aebfea6e467d576f70860.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/2/21 5:23 PM, James Bottomley wrote:
> On Thu, 2021-09-02 at 15:38 -0700, Linus Torvalds wrote:
>> On Thu, Sep 2, 2021 at 9:50 AM James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>>> We also picked up a non trivial conflict with the already upstream
>>> block tree in st.c
>>
>> Hmm. Resolving that conflict, I just reacted to how the st.c code
>> passes in a NULL gendisk to scsi_ioctl() and then on to
>> blk_execute_rq().
>>
>> Just checking that was fine, and I notice how *many* places do that.
>>
>> Should the blk_execute_rq() function even take that "struct gendisk
>> *bd_disk" argument at all?
>>
>> Maybe the right thing to do would be for the people who care to just
>> set rq->rq_disk before starting the request..
>>
>> But I guess it's traditional, and nobody cares.
> 
> It's certainly traditional, but Christoph has been caring a lot about
> cleaning up our gendisks recently, so he might be interested in seeing
> if he can fix it ...

It's trivially doable, it's more a question of whether it's a good idea
or not... At least when passed in you have to make a conscious decision
on it being NULL. And just like Linus did, it's something you'll notice
and see what other callers are doing.

As I said, I don't feel that strongly about it. Hopefully most cases
that would forget to set it would trigger a NULL defer when they test
their code, and the core does initialize ->rq_disk to NULL. It's less
risky now than earlier, where the request alloc path was less
streamlined.

-- 
Jens Axboe

