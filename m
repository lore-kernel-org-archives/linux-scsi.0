Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F98C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 01:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722C561263
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 01:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhDZBvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 21:51:31 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:40609 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhDZBvb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 21:51:31 -0400
Received: by mail-pg1-f176.google.com with SMTP id b17so2031819pgh.7;
        Sun, 25 Apr 2021 18:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zPUtfVnEEWwuygIs9roDA8n1hisriGb9DgakGssm9V4=;
        b=MRASh4Hxg0m4b4zAdN4U0A3dU1KIiQy1P/a+2LKsIAtMYWOtohckgsHmWN4bjZi9u5
         8tCRNDXhcBlV7F2ZhrOBJ+AYF2Tno4yf/vr9fZr3qk73Pe5purOQQHowXfrBXoYpYO+Y
         LzmpPXaZnsoNbdrNGnsSi6Hbnxn/2kd5f+2UEpnTK3/LVfZYiyrBtMtD6KZSyjdr9yGw
         0wgytv80TrrskOTLqA2CkRy9kspsI7HRPnLVYERL8LlCtOJVjkQbC6ITQy0aSUwTXSqR
         oEsI5PGdAqFa214GbuV6mIUMuZnwvGr3xkq+BCEW8dfjeXrZNcqwEuu+fky8lfJw7c7X
         PlhA==
X-Gm-Message-State: AOAM531ug9gl+5GP42zGh16vfmGJYK7q8xxODw3f6RTMf1bj1WU7D0AB
        cZiMhpec73sCXvOuB35Rn2c=
X-Google-Smtp-Source: ABdhPJzwMUBdl76J3O+0TGJaDFvHGuRvkjdgNBKS/8OpFzxfDhzu6bUmqq9rsaKdhTXZZEebZzeFTg==
X-Received: by 2002:aa7:9299:0:b029:21d:7ad1:2320 with SMTP id j25-20020aa792990000b029021d7ad12320mr15243625pfa.22.1619401850638;
        Sun, 25 Apr 2021 18:50:50 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 22sm13214507pjl.31.2021.04.25.18.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 18:50:49 -0700 (PDT)
Subject: Re: [PATCH 8/8] blk-mq: clear stale request in tags->rq[] before
 freeing one request pool
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <20210425085753.2617424-9-ming.lei@redhat.com>
 <d3493eef-ff45-23a8-f12a-b7246ba9f3a2@acm.org> <YIYOLHaidxc5fBH2@T590>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <69764ff2-f339-0dc0-aac0-a1f9f4b30d53@acm.org>
Date:   Sun, 25 Apr 2021 18:50:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIYOLHaidxc5fBH2@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/25/21 5:49 PM, Ming Lei wrote:
> On Sun, Apr 25, 2021 at 01:42:59PM -0700, Bart Van Assche wrote:
>> Using cmpxchg() on set->tags[] is only safe if all other set->tags[]
>> accesses are changed into WRITE_ONCE() or READ_ONCE().
> 
> Why?
> 
> Semantic of cmpxchg() is to modify value pointed by the address if its
> old value is same with passed 'rq'. That is exactly what we need.
> 
> writting 'void *' is always atomic. if someone has touched
> '->rqs[tag]', cmpxchg() won't modify the value.

WRITE_ONCE() supports data types that have the same size as char, short,
int, long and long long. That includes void *. If writes to these data
types would always be atomic then we wouldn't need the WRITE_ONCE()
macro. The explanation at the top of the rwonce.h header file is as
follows: "Prevent the compiler from merging or refetching reads or
writes. [ ... ] Ensuring that the compiler does not fold, spindle, or
otherwise mutilate accesses that either do not require ordering or that
interact with an explicit memory barrier or atomic instruction that
provides the required ordering."

Bart.
