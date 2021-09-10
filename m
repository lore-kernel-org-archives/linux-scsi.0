Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D9AC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBEB161041
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhIJCAC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 22:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhIJCAB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 22:00:01 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D228FC061574
        for <linux-scsi@vger.kernel.org>; Thu,  9 Sep 2021 18:58:51 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id b4so434449ilr.11
        for <linux-scsi@vger.kernel.org>; Thu, 09 Sep 2021 18:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=af5QtWDmLmB2xr1L33XEXYLHDDW+tTo+osB1441nljo=;
        b=Ofbo5PXE5CmSPr0nSOsNLusfN4pURnjKDnRJs0ZSLcR9Z8ERhm6XrioMb+RsUZxJfy
         yVYdsVa9Da2kw7xIY8jlUYKnT3+5i5o/n8m5HEnWrJyL4QLqoy5KDq8bOLdKRNVOLed/
         PVsEYWGk1p5jHis7OAmReEDuvvGEmF6qZn7H4iqH3gIrsJ/mbTvOeuuMP0kJbk4Dr0bo
         Om6lU+VAMSin7fcbNJ8GfYrA4G51JLOkLzk0o7ydIsg/cGI46PPTQ09gfSe0dgVxusha
         AqwphWumOHqVOk23s76+Pn5ufD4KK2aZo/U2qXCfO6txYBnzntCe/kI/sc6mEw7nvNbl
         i57Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=af5QtWDmLmB2xr1L33XEXYLHDDW+tTo+osB1441nljo=;
        b=697XFIXYm1oHYrBa1R8DLUrMpuGTU8qCG+tQeQU9IK3SLmaoiFw9DblgbpcCHgl3RR
         hn315+5x9WYNFJuJ0WUo7TyeAcuTGjyIi2CrKYjH8m4cpwigx1OIpJay68/MGJnkKT1n
         QVwTWZFhOzD6DDp9TFiWUxsCAtbEAqECAkcqqEHgjLPnuywMzpLl9aL4kyZBA35OSFrr
         f1zrYTKh5fBz44ieR9QYot+rng9dKGAGwCLwono8V2wQxqFFdnJOuni36O9Mjzksn3ib
         cCUSxuZuISmg9HPXzWytzt/LiUOWGtgyGHpiviGD7Oq0eClWh7HsT98FkfKaSXZdshL7
         aGbg==
X-Gm-Message-State: AOAM532uZlSs2YzMOBUHMiTa4VsL0QjTzyatb1AjFIDpFizV8FqJ5PYf
        Fnwg/H71Iewj2KvQRFLneNHQ4Q==
X-Google-Smtp-Source: ABdhPJyEheAEpWZA9EhLvlh+oC3w7uEzYFAcYKrm4xZjGypTqGLaz5an3bNVxrnEE4ff/kFBcj/Hfw==
X-Received: by 2002:a92:c846:: with SMTP id b6mr4374052ilq.84.1631239131022;
        Thu, 09 Sep 2021 18:58:51 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id f2sm1756452ioz.14.2021.09.09.18.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 18:58:50 -0700 (PDT)
Subject: Re: [PATCH] scsi: remove SCSI CDROM MAINTAINERS entry
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <c5e12bd1-10de-634c-d6b3-dac79ed01af5@kernel.dk>
 <d086adfb-9cfe-6f3c-aae1-b9106436037d@kernel.dk>
 <yq1ilz92osg.fsf@ca-mkp.ca.oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <23620431-4066-957a-2823-2fc1526b3432@kernel.dk>
Date:   Thu, 9 Sep 2021 19:58:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <yq1ilz92osg.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/9/21 7:57 PM, Martin K. Petersen wrote:
> 
> Jens,
> 
>> On 9/3/21 8:11 AM, Jens Axboe wrote:
>>> There's little point in keeping this one separately maintained these
>>> days, so just remove the entry and it'll fall under the SCSI subsystem
>>> where it belongs.
>>
>> Ping...
> 
> It's been in scsi-staging for a few days. Just haven't hit the main
> branch yet.

Ah ok, just wanted to make sure it wasn't missed, since I hadn't heard
anything.

-- 
Jens Axboe

