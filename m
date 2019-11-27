Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82D1C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 14:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B094F20674
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 14:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="fNmDe8vc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfK0OWD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:22:03 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33405 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfK0OWD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Nov 2019 09:22:03 -0500
Received: by mail-pl1-f193.google.com with SMTP id ay6so9844373plb.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 Nov 2019 06:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2L4Ok5zBUAmvBbfbQin1peWu4VrzbK+5f4SjmrXFrCA=;
        b=fNmDe8vc0e0T0a/MUFSJxePj/G0VYifcKSFWUi7/OJAH4se+uApSGJ81QNPEyZ/YuL
         8f1cRtwoOylO+jrfVxOXyK12oZH2JR++IlpHJSQtgM8kEfzwfjwqjyg7YvG7xq6Nn9h+
         c6iu1P5rJwz4w6MmQ7eJoagV7hXQQwsgDimuIIvb5g+seBIF1pPaNYvzAGysD+XLg/bQ
         mrDWM5M+I9igFfw3/nYXcfe622J/AT9HBYSmGWKNv6NhNEZmNJU2SoPe4tWkz8vuJ+A7
         CQOjJP+EsLJnvel6vZsOqxSBusgmgyMuIj6Ag0Hqe5y9GT978J5dops4hFXSLTFMYeM7
         7e+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2L4Ok5zBUAmvBbfbQin1peWu4VrzbK+5f4SjmrXFrCA=;
        b=UaU5DtS5v9JKyeBL/Cnceb2T/D9xayOYUdXzh+iPrlGmkcaKGhAtYFIrp+3453bfFI
         EdNtTGQ9fHiVMeUKlfkorzmEjTAyKgzxr35SzERe2SuZYZpaFLAm7Ws8i1ydOrpglW1p
         g51LG5HIX5xMP85eCyUZ9NN7e2hsAdfPzK47gwTBzbD5yVTYJzRCXuENJCiZc5coKsUY
         xcYnGrKO3puJNfLfXOh+rD1roJVSaGta0ohpe0flCJfCaDIY5DHofDT7FV1+35kAJJCW
         zgbs+rEXfRygMjwLHCZyENN0SlTZkgIhcKhgNEcje5DfqMWhGsyKyD5x1KcpRjMW3dOs
         D7pQ==
X-Gm-Message-State: APjAAAUJOo/6zKccGs/4GH4G1yz7U+B/TJr+QQs5wcrJHzL85+hyJ8oo
        Sv9bs6bSMJzo1myOUQCTXK7kfg==
X-Google-Smtp-Source: APXvYqwf+3kgIW5ei2GYe2ZhZfnB9hoGPSx4d/5jrpPLhsjrnRzm/I2hjSYXtZg5ua7iTQXCAci8bQ==
X-Received: by 2002:a17:90b:3108:: with SMTP id gc8mr6129482pjb.54.1574864521319;
        Wed, 27 Nov 2019 06:22:01 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:c030:6a7d:9480:46b8? ([2605:e000:100e:8c61:c030:6a7d:9480:46b8])
        by smtp.gmail.com with ESMTPSA id h9sm7653205pjh.8.2019.11.27.06.21.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 06:22:00 -0800 (PST)
Subject: Re: [PATCH 3/8] blk-mq: Use a pointer for sbitmap
To:     John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-4-hare@suse.de>
 <8f0522ee-2a81-c2ae-d111-3ff89ee6f93e@kernel.dk>
 <62838bca-cd3c-fccf-767c-76d8bea12324@huawei.com>
 <00a6d920-1855-c861-caa3-e845dcbe1fd8@kernel.dk>
 <baffb360-56c0-3da5-9a52-400fb763adbf@huawei.com>
 <9290eb7f-8d0b-8012-f9a4-a49c068def1b@kernel.dk>
 <157f3e58-1d16-cc6b-52aa-15a6e1ac828a@huawei.com>
 <1add0896-4867-12c5-4507-76526c27fb56@kernel.dk>
 <4a780199-7997-b677-b184-411afdeabba5@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5bc7b976-845c-92ec-6ccc-8e43237313bc@kernel.dk>
Date:   Wed, 27 Nov 2019 06:21:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <4a780199-7997-b677-b184-411afdeabba5@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/27/19 6:05 AM, John Garry wrote:
> On 27/11/2019 01:46, Jens Axboe wrote:
>>>> Would be interesting to check the generated code for that, ideally we'd
>>>> get rid of the extra load for that case, even if it is in the same
>>>> cacheline.
>>>>
>>> I checked the disassembly and we still have the load instead of the add.
>>>
>>> This is not surprising, as the compiler would not know for certain that
>>> we point to a field within the same struct. But at least we still should
>>> point to a close memory.
>>>
>>> Note that the pointer could be dropped, which would remove the load, but
>>> then we have many if-elses which could be slower, not to mention that
>>> the blk-mq-tag code deals in bitmap pointers anyway.
> 
> Hi Jens,
> 
>> It might still be worthwhile to do:
>>
>> if (tags->ptr == &tags->__default)
>> 	foo(&tags->__default);
>>
>> to make it clear, as that branch will predict easily.
> 
> Not sure. So this code does produce the same assembly, as we still need
> to do the tags->ptr load for the comparison.

How can it be the same? The approach in the patchset needs to load
*tags->ptr, this one needs tags->ptr. That's the big difference.

-- 
Jens Axboe

