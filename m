Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D7CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 19:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9345861157
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 19:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhKCTGO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 15:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhKCTGO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 15:06:14 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F892C061205
        for <linux-scsi@vger.kernel.org>; Wed,  3 Nov 2021 12:03:37 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id x70so5206841oix.6
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2021 12:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5oaC9OT7PCd2Vr4m+94T0a/jYCQYumzRDNC0eRuxbgg=;
        b=Tdt5km7jlZggUD/yGLnsTL4FeB/NyUiATf/d8TR3BcaWJEbNrUmWqe5k+mZVlZuWKR
         9cmy5yV46NiOk/1R0hwOoH/mWvA4fieemyERhOyku4sLWPtIXJ7YJUG2N7omWfNsNQXu
         goFIxkAuOb5Zay98aWf8WkWOPqYaECdcjUroVI7+B5HJz2PzY+ZvaaHcmRsZng9GtiOv
         LxtorsRqjqnEyDNuQvQJbcD56ANKsPLHEUo+2rZVz/Ub0WIDganblzoMpL+odv+OUTWy
         fDuHjEYJRV5zcswU23dpFVIL+w5JGFSGx4G886yhNEjc8JdcAmFAahJktKjkbXA6gcOj
         6afw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5oaC9OT7PCd2Vr4m+94T0a/jYCQYumzRDNC0eRuxbgg=;
        b=QO61Ylo3+QyEMnW6sRjPcS6jcaLhNI0yv+OlOPUzXwVznXMbaOKVn8jV2YY+dSYP8h
         yRXTrJxOauIEkrTrGlfD2J8vTLGX21jpmuFv2u2ObmWp0SqCog/OpXQMJHOqobOAfUA7
         er5DjLBgyDRbTBaYGDlE/f4NrgBytCbtEmW7FDgG3yl8yssDEERA8LnKIs+/Mp+RCdMy
         ZnjqSIgbXtFbN5sxYiO7/1FYWpwNzd/VE3/DoaZ2K8kWEVQUamp1PGmNCndvvt0D0bhT
         PEdqkKj7rDgpTeaUiuR8HHGOvHXDd79MIyG80ZCXV/bApUynvOm5AvJAyVgJipaXqujZ
         rbBQ==
X-Gm-Message-State: AOAM531NCUXP9DKlyxT1CsAxsGLbRxCmZP8n+T1rpPWSygZVlVOrUCCY
        HwtUM7l3AgQGNv4LKP4EKaSASSggrw+uLQ==
X-Google-Smtp-Source: ABdhPJwuIcO4RpWVlExK2PiHYX6hoYdR1+O8lrLPZzNHQWc3RFpUznlDnPph6yXFelS6iM7aYeGjeg==
X-Received: by 2002:a05:6808:171c:: with SMTP id bc28mr12306248oib.18.1635966216083;
        Wed, 03 Nov 2021 12:03:36 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id bc32sm789359oob.12.2021.11.03.12.03.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 12:03:35 -0700 (PDT)
Subject: Re: [bug report] WARNING: CPU: 1 PID: 1386 at
 block/blk-mq-sched.c:432 blk_mq_sched_insert_request+0x54/0x178
To:     Yi Zhang <yi.zhang@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Steffen Maier <maier@linux.ibm.com>,
        linux-block <linux-block@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
References: <YYIHXGSb2O5va0vA@T590>
 <85F2E9AC-385F-4BCA-BD3C-7A093442F87F@kernel.dk>
 <CAHj4cs-pTYoksSQDjfFpK13Xtg0jB6EOvhfOZu5cDHowZa=ueg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f95deb32-59a0-1fc1-b7b2-92583a5ef4de@kernel.dk>
Date:   Wed, 3 Nov 2021 13:03:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHj4cs-pTYoksSQDjfFpK13Xtg0jB6EOvhfOZu5cDHowZa=ueg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/21 10:00 PM, Yi Zhang wrote:
>>>
>>> Hello Jens,
>>>
>>> I guess the issue could be the following code run without grabbing
>>> ->q_usage_counter from blk_mq_alloc_request() and blk_mq_alloc_request_hctx().
>>>
>>> .rq_flags       = q->elevator ? RQF_ELV : 0,
>>>
>>> then elevator is switched to real one from none, and check on q->elevator
>>> becomes not consistent.
>>
>> Indeed, that’s where I was going with this. I have a patch, testing it locally but it’s getting late. Will send it out tomorrow. The nice benefit is that it allows dropping the weird ref get on plug flush, and batches getting the refs as well.
>>
> 
> Hi Jens
> Here is the log in case you still need it. :)

Can you retry with the updated for-next pulled into -git?

-- 
Jens Axboe

