Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3249FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 22:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0454F6054E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 22:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348494AbhIBWrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347811AbhIBWru (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 18:47:50 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A4FC061575
        for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2021 15:46:51 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id b10so4578906ioq.9
        for <linux-scsi@vger.kernel.org>; Thu, 02 Sep 2021 15:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LTWD1W2YPJXVZ1hE6EoJHl2hIHtse8iYBkOWTYvtDV8=;
        b=BL/ybra+iSnjXcGnfaebYYlKzV+aS2BeM16Qe6IWKfdWY5074Net7vAmPVZa3uLRNh
         JaTPvrbCsoZavSWsimLepNxWyUfJfEQX1+7+xWC76w76o8oFg5zhQMCEu7L3HVwINhcu
         1LaU23i8HVJLGolzildSEzKFSyt/9Dnly7EDxXXhMTnJrlCUBI2YUvqJXdJWh8TG/I6s
         51ZG4bxqDhV6qFvdhO0vAzsCykeURgRtgCEC3TZ4ACJoBmCl2HjCVSUGcIwJ0oMC2b55
         8+rIKtLfWMh+62n1qYfohxTD/5d7bn9oyYYc5CHyE/Ft4m6E+NXT8Xqd7fzqHmaWOx7G
         S2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LTWD1W2YPJXVZ1hE6EoJHl2hIHtse8iYBkOWTYvtDV8=;
        b=g+I26iXdLhAk249uHljD95wA+lM7bUlwgZtG400F7YH7ZwEwVEPn19kPTr+CcdN9Jb
         UpHwZVZLBVT6ChiEnQHzQGrZ7DQdU/Rpv3UlFoypBOyJwiZQ4P1jHNm6yzKydL9idzFv
         RbFzKLdASUIOFXj1DXozx23DCoS883ExAoEKz5MIwBmtGaufD0JtZ6OHrty215ySnJMY
         DDPwBqr7C+bobDUxQ6LxcO1Di9ZgcHZ12cRJM1LemuaMSVH6VPr7w3ODn2FlGdcFKLT+
         InwHNrV3wF+DpO5x4KfrLms0Z+egPK1YasaBkkJjF76ik7EfqUEVGa8qIkTK3kmW75fB
         dFgw==
X-Gm-Message-State: AOAM532qLlCFzKpmnEvJP2EfqWtah4awtHcv/HAURdq6s6I5uRNvfMq+
        drXJ+YMd/RKtQul4rFRAWw0bX+QJ9zOM/Q==
X-Google-Smtp-Source: ABdhPJzhI9ZP9GUJBBm7KCViTcwD4rPevHLP2Mjc3JYlcRJHNUtjw25z8FJIflItabkx4c7rM5odmg==
X-Received: by 2002:a02:946d:: with SMTP id a100mr99565jai.118.1630622811333;
        Thu, 02 Sep 2021 15:46:51 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id t15sm1719829ioi.7.2021.09.02.15.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 15:46:50 -0700 (PDT)
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.14+ merge window
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <fc14fbbf0d7c27b7356bc6271ba2a5599d46af58.camel@HansenPartnership.com>
 <CAHk-=wi99u+xj93-pLG0Na7SZmjvWg6n60Pq9Wt9PgO6=exdUA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <df7408f6-15a1-9e53-feb0-bbc1f3cf6e2d@kernel.dk>
Date:   Thu, 2 Sep 2021 16:46:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wi99u+xj93-pLG0Na7SZmjvWg6n60Pq9Wt9PgO6=exdUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/2/21 4:38 PM, Linus Torvalds wrote:
> On Thu, Sep 2, 2021 at 9:50 AM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>>
>> We also picked up a non trivial conflict with the already upstream
>> block tree in st.c
> 
> Hmm. Resolving that conflict, I just reacted to how the st.c code
> passes in a NULL gendisk to scsi_ioctl() and then on to
> blk_execute_rq().
> 
> Just checking that was fine, and I notice how *many* places do that.
> 
> Should the blk_execute_rq() function even take that "struct gendisk
> *bd_disk" argument at all?
> 
> Maybe the right thing to do would be for the people who care to just
> set rq->rq_disk before starting the request..
> 
> But I guess it's traditional, and nobody cares.

We could certainly just do that. There are other things that are
required set in the request before that call, things like the queue, but
those get naturally set by the request allocation. Hence it would not be
_that_ different to require disk being set. Seems safer to just keep it
the way it is and pass in the reference, even if it ends up being NULL
in probably 50% of the cases.

-- 
Jens Axboe

