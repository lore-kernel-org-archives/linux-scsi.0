Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558DFC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 17:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C8FD6101D
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 17:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhEDRCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 13:02:41 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:44857 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhEDRCk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2021 13:02:40 -0400
Received: by mail-pf1-f175.google.com with SMTP id m11so8270190pfc.11
        for <linux-scsi@vger.kernel.org>; Tue, 04 May 2021 10:01:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h2oGHUb+1QlpYw+nmrJh4L305jQsOelgUwmbHMkuyHs=;
        b=cynUcGYBnSeQEwfixFdrtHogOCO/etc9Sj4XBd8JW18gcu0iUAmKc/NPZljZhwj6Jl
         ZFNbxyxmZHdahJY9DOJ545t25vFRLUzrSe5P5Jh3tvnMrWpAyj9Is+R9Ssl/2c90cFKN
         Q3wPuONqDqz09BeYBjzGc+qkBFyFouLQmi3EIoFsPkClnGmqoJcDchWrlattt3sk3uOM
         MxmOYQO9xyJSQ2aRWoMqQnq7RYVgarlOQ+tIW05u7G7bAEuYLpFASh7YRrRaBVN7cDvV
         /XJGtxVBS3qWVGzXeeB2KrG6DXqQa1vUvkogcsToXQWD36G7FF4tMMwyY24LWelkx8NO
         VBKQ==
X-Gm-Message-State: AOAM531Sl3ikHoOLVjhAhya21uOn9xj8MeGKo4waj7n3Z7ArouVJxKcm
        aJdrNoFRONzxJVZPbml/vmn8TNlGM84=
X-Google-Smtp-Source: ABdhPJyoXLwoMl6KF7kemlxA8o0PQX/UVowrvbbnx64iX+QOjPWR6DKejBgF1l4kcuu9AJP6MP6Adg==
X-Received: by 2002:a63:1f4d:: with SMTP id q13mr24006746pgm.453.1620147704825;
        Tue, 04 May 2021 10:01:44 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id q19sm14170497pfl.171.2021.05.04.10.01.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 10:01:44 -0700 (PDT)
Subject: Re: [PATCH 10/18] scsi: implement reserved command handling
To:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-11-hare@suse.de>
 <3e41e5ea-6313-9718-c07d-20f8b203efd2@acm.org>
 <1db7fc49-17a9-1c8d-9d94-9a1b3694f392@suse.de>
 <7a9ceb36-32dc-4fcc-49a2-f4c2ca2286c3@huawei.com>
 <e2d2b5f7-6f8d-241e-5a38-44cbcd7fc772@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4467caa8-b4f4-3de0-c5d6-09a685229e5a@acm.org>
Date:   Tue, 4 May 2021 09:59:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <e2d2b5f7-6f8d-241e-5a38-44cbcd7fc772@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 6:12 AM, Hannes Reinecke wrote:
> On 5/4/21 12:55 PM, John Garry wrote:
>> On 04/05/2021 07:17, Hannes Reinecke wrote:
>>> On 5/4/21 5:20 AM, Bart Van Assche wrote:
>>>> On 5/3/21 8:03 AM, Hannes Reinecke wrote:
>>>>> These commands are set aside before allocating the block-mq tag
>>>>> bitmap,
>>>>> so they'll never show up as busy in the tag map.
>>>>
>>>> That doesn't sound correct to me. Should the above perhaps be changed
>>>> into "blk_mq_start_request() is never called for internal commands so
>>>> they'll never show up as busy in the tag map"?
>>>>
>>> Yes, will do.
>>
>> So why don't these - or shouldn't these - turn up in the busy tag map?
>>
>> One of the motivations to use these block requests for internal
>> commands is that we can take advantage of the block layer handling for
>> CPU hotplug for MQ hosts, i.e. if blk-mq can't see these are inflight,
>> then they would be missed in blk_mq_hctx_notify_offline() ->
>> blk_mq_hctx_has_requests(), right? And who knows what else...
>>
> Oh, but of course it's possible to call 'start' on these requests to
> have them counted in the busy map.
> I just didn't see the need for it until now, that's all.

This is possible but this will require careful review of at least the
following code paths such that nothing unexpected happens for internal
commands:
* The SCSI timeout code.
* All blk_mq_tagset_busy_iter() and scsi_host_busy_iter() callers. As an
example, scsi_host_busy() must not include LLD-internal commands.

Thanks,

Bart.
