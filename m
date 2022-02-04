Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FE0C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Feb 2022 13:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbiBDNeE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Feb 2022 08:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiBDNeE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2022 08:34:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C42C061714
        for <linux-scsi@vger.kernel.org>; Fri,  4 Feb 2022 05:34:04 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y17so5149175plg.7
        for <linux-scsi@vger.kernel.org>; Fri, 04 Feb 2022 05:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KWj5VHbmtPCAG80WBX4yW0jMIjhI+i8MGje98xVpJ28=;
        b=J0H1WlwC0P37XJGQ80pvU6MOXxkQhBt8I8jYBfMI4Ak4jZTB2jdXIyOEE9Kllnlosl
         x9hSWRjBcJabIqRFmAa0jW6HQxN6K09LfSnx2stfcfoHwdOShgYR4VS9L68fEQryHmcI
         o1oi+IOQjRfyeD34mj6H+wgZH5o8zcR1bHhXTsZTR3oxryEKBgD2/L9Ne08APK8zUMF7
         W1cTkxcnoxIyNsDpKJkZ+Iq3r8wtZV9a4WDe+F7RXXyDrO6kc2ga0WrjZ62WMMZ3Ucna
         bkc9AWj5Fv6K4yZk5HMlpeORWYohWortqx1DTQD5l4yq0v2of1uD5ZuntPINz58Pqcx0
         JQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KWj5VHbmtPCAG80WBX4yW0jMIjhI+i8MGje98xVpJ28=;
        b=Z5rY2p6koP5U0wO8yd6eRmuojNLaPfi1zQ4Y1hfYc3giMh13YSdireavFzHYGCg2+S
         gAluC7vz6O8Kbbayscgr5tyYeSjU2q5GzgA+3Qo1qGoe9l7pU1FHGTbynZC6kqPq//yq
         OikOKkYOTO9qijGQxqNGylb1PrbnsstDf+y3m1Jznm+6mW3GBf/E8NlGHNyGWZwKulPy
         xD8PY9CauMY0Fk8C1R6HhWwwdLi5ZoECC4YRyDy6Xv5U9qZIFtl0AOMEEb5l5fqZDkp7
         /3l7J2eO+r6QeBSX7etyF5rRPEDfyhuOIjsA9aL4YP85r2jAMZMcDFD6pt6UGhgUCOAU
         DWRQ==
X-Gm-Message-State: AOAM531KjfpHn1HUZclYqpUd5H2DajFVeAu3RG+QKiX3vV1frRSzAFfw
        Xx7DSbFT6lOfMKQlSxzOyWKlY0yCr/1R8g==
X-Google-Smtp-Source: ABdhPJxj+mWKk80hBHd+iZIf+Sws1xCuDe5XG9c0N/wSw4I51o6nz5iMnvsk4OFG8pEwrP+T/IACJA==
X-Received: by 2002:a17:90b:3511:: with SMTP id ls17mr3138025pjb.241.1643981643450;
        Fri, 04 Feb 2022 05:34:03 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id f8sm2818712pfv.24.2022.02.04.05.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 05:34:03 -0800 (PST)
Subject: Re: [RFC PATCH 1/3] block: add copy offload support
To:     Mikulas Patocka <mpatocka@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
 <20220201102122.4okwj2gipjbvuyux@mpHalley-2>
 <alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2202011331570.22481@file01.intranet.prod.int.rdu2.redhat.com>
 <efd2e976-4d2d-178e-890d-9bde1a89c47f@acm.org>
 <alpine.LRH.2.02.2202031310530.28604@file01.intranet.prod.int.rdu2.redhat.com>
 <a2ec9086-72d2-4a4e-c4fa-fe53bf5ba092@acm.org>
 <alpine.LRH.2.02.2202040657060.19134@file01.intranet.prod.int.rdu2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2c33ecab-7154-a476-8038-451e37785201@kernel.dk>
Date:   Fri, 4 Feb 2022 06:34:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2202040657060.19134@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/22 5:09 AM, Mikulas Patocka wrote:
> 
> 
> On Thu, 3 Feb 2022, Bart Van Assche wrote:
> 
>> On 2/3/22 10:50, Mikulas Patocka wrote:
>>> On Tue, 1 Feb 2022, Bart Van Assche wrote:
>>>> On 2/1/22 10:32, Mikulas Patocka wrote:
>>>>>    /**
>>>>> + * blk_queue_max_copy_sectors - set maximum copy offload sectors for
>>>>> the
>>>>> queue
>>>>> + * @q:  the request queue for the device
>>>>> + * @size:  the maximum copy offload sectors
>>>>> + */
>>>>> +void blk_queue_max_copy_sectors(struct request_queue *q, unsigned int
>>>>> size)
>>>>> +{
>>>>> +	q->limits.max_copy_sectors = size;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(blk_queue_max_copy_sectors);
>>>>
>>>> Please either change the unit of 'size' into bytes or change its type into
>>>> sector_t.
>>>
>>> blk_queue_chunk_sectors, blk_queue_max_discard_sectors,
>>> blk_queue_max_write_same_sectors, blk_queue_max_write_zeroes_sectors,
>>> blk_queue_max_zone_append_sectors also have the unit of sectors and the
>>> argument is "unsigned int". Should blk_queue_max_copy_sectors be
>>> different?
>>
>> As far as I know using the type sector_t for variables that represent a number
>> of sectors is a widely followed convention:
>>
>> $ git grep -w sector_t | wc -l
>> 2575
>>
>> I would appreciate it if that convention would be used consistently, even if
>> that means modifying existing code.
>>
>> Thanks,
>>
>> Bart.
> 
> Changing the sector limit variables in struct queue_limits from
> unsigned int to sector_t would increase the size of the structure and
> its cache footprint.
> 
> And we can't send bios larger than 4GiB anyway because bi_size is
> 32-bit.
> 
> Jens, what do you think about it? Should the sectors limits be
> sector_t?

Why make it larger than it needs to?

-- 
Jens Axboe

