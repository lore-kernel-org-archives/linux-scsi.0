Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4212CC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 12:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30C4F60FC2
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 12:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhKBNCL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 09:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhKBNBz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 09:01:55 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A192C0613F5
        for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2021 05:59:21 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id s14so4470728ilv.10
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 05:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iYiRp0l1uhYjvBkGrtc0hnMXWU1AiLYZRHqgAfjylr0=;
        b=kcxt2J1mhW7sBpvFZNbRqM6hkrFV66WlENLfeuZmetnkPYCkQMHSFUdSug9x4+sPK8
         peRB0nEwdDsXLa1WsvW5p6617nA8yXpp6EY6WNDLtMPSD2shExXn/GI1Tpn1wdIhhg++
         AictJVJSoUCvSmqzlgvf4295rmRhVdsRGymy6MPWQVBhz7dr5k5CqSFmBxEi9u+FCrq3
         evca0xlUbk0i6l3XrJwseCp2d7gHz/NhcwGopUuqpyXLzb6ye21VCnG9RntUM6UmFZVA
         HUx5z9IWc4TwguqgKX8+/mstIQR5jqPuDVSV9e94QJ3Ydv9sJlWDYvWJBwcTjE2TFHnt
         E+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iYiRp0l1uhYjvBkGrtc0hnMXWU1AiLYZRHqgAfjylr0=;
        b=VJGoKKSQzLJNsgutmVtuCS9XCFHznV1ZalEfEhba1GqbTpXO/Pmg90sie6CV1CXX/f
         v104eH5jfQX/qO0CKwFf2Q1gyHUNFpTkR+mus57iQxLtjbOEyL+2sXhqmRtbKedIO/KL
         mi6A/FAmmwQYiCvfDnRPICqx8ciwr61nlSrf/GBcJoPz5607FWKao0CCemF4IiLW4RHW
         /Yo3sV+GiQPk7zz7HOMAe7YI7VKjYzbsRsjn0Zysma1nZUgK7eOOlFHuI6OuqD9svmpq
         roq9N/gO2Zs2SsFkrTpFifQWiU1wSAsRgswtQQ4HU1r8TiK9YAhDSwGpK7eTkQ+mzjlf
         oCaQ==
X-Gm-Message-State: AOAM531vPcaQgxThwAoB+MrFT0I5z1a4wUAdYPnfLSAGbR90696arF7+
        MfkyG/BYU7zHm6h3xbEVry4TOA==
X-Google-Smtp-Source: ABdhPJxvALWLpyGcrXCgpmlgX6E6EkmrZY0JmhIZnPbQeBAVBX9qvNHL5hCeTbm0c8VWV+BBzmukow==
X-Received: by 2002:a05:6e02:e41:: with SMTP id l1mr20381671ilk.139.1635857960219;
        Tue, 02 Nov 2021 05:59:20 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m2sm4904622iow.6.2021.11.02.05.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 05:59:19 -0700 (PDT)
Subject: Re: [PATCH 2/3] scsi: make sure that request queue queiesce and
 unquiesce balanced
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com
References: <20211021145918.2691762-1-ming.lei@redhat.com>
 <20211021145918.2691762-3-ming.lei@redhat.com>
 <10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8cbc1be6-15a5-ed34-53f1-081a05025d34@kernel.dk>
Date:   Tue, 2 Nov 2021 06:59:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/21 7:43 PM, James Bottomley wrote:
> On Thu, 2021-10-21 at 22:59 +0800, Ming Lei wrote:
>> For fixing queue quiesce race between driver and block layer(elevator
>> switch, update nr_requests, ...), we need to support concurrent
>> quiesce
>> and unquiesce, which requires the two call balanced.
>>
>> It isn't easy to audit that in all scsi drivers, especially the two
>> may
>> be called from different contexts, so do it in scsi core with one
>> per-device
>> bit flag & global spinlock, basically zero cost since request queue
>> quiesce
>> is seldom triggered.
>>
>> Reported-by: Yi Zhang <yi.zhang@redhat.com>
>> Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue
>> quiesce/unquiesce")
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>>  drivers/scsi/scsi_lib.c    | 45 ++++++++++++++++++++++++++++++----
>> ----
>>  include/scsi/scsi_device.h |  1 +
>>  2 files changed, 37 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 51fcd46be265..414f4daf8005 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -2638,6 +2638,40 @@ static int
>> __scsi_internal_device_block_nowait(struct scsi_device *sdev)
>>  	return 0;
>>  }
>>  
>> +static DEFINE_SPINLOCK(sdev_queue_stop_lock);
>> +
>> +void scsi_start_queue(struct scsi_device *sdev)
>> +{
>> +	bool need_start;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
>> +	need_start = sdev->queue_stopped;
>> +	sdev->queue_stopped = 0;
>> +	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
>> +
>> +	if (need_start)
>> +		blk_mq_unquiesce_queue(sdev->request_queue);
> 
> Well, this is a classic atomic pattern:
> 
> if (cmpxchg(&sdev->queue_stopped, 1, 0))
> 	blk_mq_unquiesce_queue(sdev->request_queue);
> 
> The reason to do it with atomics rather than spinlocks is
> 
>    1. no need to disable interrupts: atomics are locked
>    2. faster because a spinlock takes an exclusive line every time but the
>       read to check the value can be in shared mode in cmpxchg
>    3. it's just shorter and better code.
> 
> The only minor downside is queue_stopped now needs to be a u32.

Are you fine with the change as-is, or do you want it redone? I
can drop the SCSI parts and just queue up the dm fix. Personally
I think it'd be better to get it fixed upfront.

-- 
Jens Axboe

