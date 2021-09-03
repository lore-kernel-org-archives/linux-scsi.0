Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFDEC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 14:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C45B6610CF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 14:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349248AbhICOK2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Sep 2021 10:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349205AbhICOK0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2021 10:10:26 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DF6C061757
        for <linux-scsi@vger.kernel.org>; Fri,  3 Sep 2021 07:09:26 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id l10so5314845ilh.8
        for <linux-scsi@vger.kernel.org>; Fri, 03 Sep 2021 07:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EQm9RAyywsVzGwf0kUxWQhr1Th2A95c0kLcLDX50iWI=;
        b=hQgFoq/6s+zpvk/nvts1YvPI+jgUAbagVJiJ9wrT4D1sO5SyYHrZYlf7T6qIHTuB0W
         NkOFzoF0hq7zosK9Va52OwAWvr1jG2rLiyJAnGcFKWwgR54mnX/YmFb0l1bHRVfK8y4R
         wGDFq18cl+H6wlr17CWbOvbiLHxydkOjqe/hZqpfH8kM7Vlw6IMYScy1MI2K+2xb5sYd
         1SW0CVqeAUqFpKSXo9QN9JSyZzbcCFms/1dE1TueqbjMvzFxTY70D3B5mp/RFLEgRmcx
         xMGb1Wf93E9xEXu4dIzSsdVtaw7/wrAOb0npHt5gQ/N7UH1QCppT49q4puXP9r7+YwRE
         0x9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EQm9RAyywsVzGwf0kUxWQhr1Th2A95c0kLcLDX50iWI=;
        b=n0/6Yi1DCyrncWT1wyDy3PLKSVO4JihuCDEd534sdQ/heaJmBy4ane0TVW1f92pdlg
         lqFPvCSDQeu7qbbNhNZHl6EQAxy1VOFMJAKRLITmmIsyJVoO9ur4gKjxxQC9zA4hVdS4
         +NuJJFfS0AVMFPmQkI6f/tnwr7utuNOirgb0Y/ttRj/VoQxk3O2Q7xnh59TXIYQId8m3
         nOrsd45mjx6wQkLDcgbFf5LoeKu06D3N/8WZm1UuxcVW7AMoCGt+lHWhaYv8loyiIxfb
         o3fMET4lMSuU8G/jRo46v8L6eCLq5f0XlmG9soP685eSnOCKDTrn1/oKOTbYeEsdO3Rz
         3Kmg==
X-Gm-Message-State: AOAM532Nx4TixpMq8lkBO71KPg+R7GKy0/e1ms1OxL7cL25fZ7rCM0ed
        ZCbz5jtuzbGuWWZRGW3pw+uU3IDEHxOFIQ==
X-Google-Smtp-Source: ABdhPJwOIDYWjgzl+UWUuBzuByBjDqG3hSUWKXQYCkR8lTd/vCa6M/hBErD1tq/w3Az8XnlYJ2xmHQ==
X-Received: by 2002:a92:cf0d:: with SMTP id c13mr2674374ilo.49.1630678166112;
        Fri, 03 Sep 2021 07:09:26 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x12sm2589061ill.6.2021.09.03.07.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 07:09:25 -0700 (PDT)
Subject: Re: Wanted: CDROM maintainer
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <22d59432-1b8e-0125-96e9-51b041fe3536@kernel.dk>
 <20210827235623.1344-1-phil@philpotter.co.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <89679d81-7e9e-7cae-c335-b97d53fa68ab@kernel.dk>
Date:   Fri, 3 Sep 2021 08:09:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210827235623.1344-1-phil@philpotter.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/27/21 5:56 PM, Phillip Potter wrote:
> Dear Jens,
> 
> Thought I'd reply publicly given the spirit of the mailing lists, hope this
> is OK.
> 
> Whilst I haven't worked on this area of the kernel, I would certainly like
> to register my interest. Many thanks.

Why don't we give it a try, then? Here's what I propose:

1) Send a patch that updates MAINTAINERS for the uniform cdrom driver to
   yourself

2) Just send pull requests for changes through me, so I can keep an eye
   on it at least initially

I'll send in a patch to update the SCSI cdrom to just fall under SCSI,
probably just removing that entry as that should then happen by default.

-- 
Jens Axboe

