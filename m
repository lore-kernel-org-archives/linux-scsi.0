Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD92C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 18:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A45864F2B
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 18:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhBZSsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 13:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhBZSsU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 13:48:20 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E375C061574;
        Fri, 26 Feb 2021 10:47:39 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id p1so7705928edy.2;
        Fri, 26 Feb 2021 10:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ke1gbe6z3p8MMEcSDh7pJgpkMWdRs0sxLS/cRZ3RDpc=;
        b=hMAppgkkpLAZPSjxmrSKH13f7X68cWNRTZ4nQ97ngM7bLBbttzfVfef9k+RjqgTPs0
         aZtjxvxpeGYXK8kaVTgodiu+PGE5TgfzZZJV4K/XbuN1SbeEjg9UbC+SNwRQ2j9n2Ife
         nCkEyLp7HbVXeCJTU+bJQAA8X8QdYxlZ6HOYhiHg0yX9MvC46+KBwt3mmzAlehWgsjT3
         ZUQAK58LPytTu67IE8zh+FtEzriM3RhudFGdQ/F1LQL0E7+5lBnAwCOi/qenSgPQJbvp
         OFpVi8HAd2IvEyIXRZYvZXMXy4oSQoi2ytmHAPYKcE1IYX5cUBiB59WVDFFJropZzIqH
         5QiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ke1gbe6z3p8MMEcSDh7pJgpkMWdRs0sxLS/cRZ3RDpc=;
        b=Z0C3JhpN27wEOF62YvBZhUynpgNYN8x6vNmpplhQrzS3IQOwc4tZbCdQWGOozyZ/z3
         WKfXB3uOTEBkaYR3GFhDx9Pif5pbO4h0sizjoMLYajTA5cwpt1ZztGWAl9XKnyURJx8P
         P++SLWrONFykhmvtqEh1MA5PX+3dU/8U+1WylYGq1dZBTorf0USnfWeXTfA48z+sXxuC
         YB/iX31lbqpedt8apEKsuYweRM+PdLqo6RsK0DWyN5FUS6NjjBuh+oYQzjSyOpId6Njp
         JKfMC/LCniCfJ/lInf2ZPi8t35h64OdM6SJeiydjponbgvgRbjS8ZycjiPO3d9E91Nu9
         rhyA==
X-Gm-Message-State: AOAM532gm0DJyRqrS49WMxYejEDFZybUEmkgZHa4ewTtPa+RMJ+UNZP7
        kd71Ga2S4IoJU8hduePXn1o=
X-Google-Smtp-Source: ABdhPJx4Ep1fXj+Q+pT747VbUAd+eeEnJllpgm7uFP+Aj/bOUoxR7wJOIjlFeNJTC3JTUtBpF8XhqQ==
X-Received: by 2002:a05:6402:40b:: with SMTP id q11mr4973394edv.36.1614365258285;
        Fri, 26 Feb 2021 10:47:38 -0800 (PST)
Received: from [192.168.178.40] (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id bx2sm3888662edb.80.2021.02.26.10.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 10:47:38 -0800 (PST)
Subject: Re: [PATCH 0/2] scsi: target: tcmu: Replace IDR and radix_tree with
 XArray
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
References: <20210224185335.13844-1-bostroesser@gmail.com>
 <b36fee7f-6fdc-b5de-3a7b-4396e5f9aab1@oracle.com>
 <4a1fece0-fc3e-9588-6494-aaf2270d6ccd@gmail.com>
 <6aed57e4-5182-ab99-ad65-c7444db56527@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <2c31212e-1c1b-57d6-0be2-5c0501ad3cdc@gmail.com>
Date:   Fri, 26 Feb 2021 19:47:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <6aed57e4-5182-ab99-ad65-c7444db56527@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26.02.21 17:04, Mike Christie wrote:
> On 2/26/21 2:41 AM, Bodo Stroesser wrote:
>> On 26.02.21 04:59, michael.christie@oracle.com wrote:
>>> On 2/24/21 12:53 PM, Bodo Stroesser wrote:
>>>> This small series is based on Martin's for-next.
>>>>
>>>> Future patches will need something like the - meanwhile removed -
>>>> radix_tree_for_each_contig macro.
>>>> Since general direction is to use xarray as replacement for
>>>> radix_tree and IDR, instead of re-introducing or open coding the
>>>> removed macro, with this series we switch over to xarray API.
>>>> Based on xarray a future patch easily can implement an analog
>>>> to radix_tree_for_each_contig.
>>>>
>>>> Bodo Stroesser (2):
>>>>     scsi: target: tcmu: Replace IDR by XArray
>>>>     scsi: target: tcmu: Replace radix_tree with XArray
>>>>
>>>>    drivers/target/target_core_user.c | 64 +++++++++++++++++++--------------------
>>>>    1 file changed, 31 insertions(+), 33 deletions(-)
>>>>
>>>
>>> Looks ok to me.
>>>
>>> Reviewed-by: Mike Christie <michael.christie@oracle.com>
>>>
>>> I think in a separate patch we need to change:
>>>
>>> +        if (xa_store(&udev->data_blocks, dbi, page, GFP_KERNEL))
>>>                goto err_insert;
>>>
>>> to GFP_NOIO. There were some users doing tcm loop  + tcmu and
>>> were hitting issues when GFP_KERNEL lead to write backs back on
>>> to the same tcmu device. We tried to change all the gfp flags but
>>> we missed that one, because it was hidden in the radix tree's
>>> xa_flags.
>>>
>>
>> But then, for consistency reasons, shouldn't we change
>>
>> +    if (xa_alloc(&udev->commands, &cmd_id, tcmu_cmd, XA_LIMIT(1, 0xffff),
>> +             GFP_NOWAIT) < 0) {
>>
>> to GFP_NOIO also?
> 
> I think so, but am not sure. I've always wondered why we used
> GFP_NOWAIT and meant to test with different gfp values but didn't
> have time. It wouldn't hit the same issue I mentioned though.
> 

I'll send a patch changing it to GFP_NOIO.
There is no reason to disallow sleeping. Just IO should be avoided
as you said.

>>
>> Additionally I have to change memory allocation in tcmu_tmr_notify from
>> GFP_KERNEL to GFP_NOIO, since it happens while holding cmdr_lock mutex,
>> which could also cause the problems you desribed.
>>
>> Shouldn't we better change to new API memalloc_noio_save and
>> memalloc_noio_restore in that new patch?
> 
> I think it's your preference. I like to use the correct gfp
> when I can, so you can just look at that chunk of code and
> know it's right. If you put memalloc_noio_save in tcmu_queue_cmd
> then a couple functions down you have a GFP_KERNEL it's
> confusing when you are just searching the code.
> 

Good point. I'll stay with GFP_NOIO.

> I think memalloc_noio_save is handy in other places like the
> iscsi/nbd code since when calling into the network stack you can't
> control all the allocations sometimes.
> 
> 
> 
