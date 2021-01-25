Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D204BC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 21:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83FCC2083E
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 21:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbhAYV0Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 16:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732554AbhAYVYX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 16:24:23 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFFCC061573
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2021 13:23:42 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id m6so9172047pfk.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2021 13:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rUEo2ymm1PXl62fUfLLLw3fQUnSwO6veMAzxwu2oAuk=;
        b=fnHI91VluGYQQfqIZc6EFptoip89t8cA7LEDV/ZS2zTM+Rs4azNhieCHsesKM5map/
         wsuC7NOWZNJOLMJd1+/K6SIJJMhcj8YZ8cqjAARlemFWs3926QjQYgG3oi3ManwLzaWG
         1PR9WmiPsQW4BR2LjXWegdbwFjDT3SAFcZZ+NJQe7nnxe8+Ft8g8ukjkBxqygOEWWuz4
         x1q/uQVP2Yr9hMQeSW5++vrkDDAfMWP4b4n2hWYtYdHRdUe9gKcxY+C3AfqmJe1DuEeZ
         e2PKDXCUeT27jwKxDGzRShw6MZmihOf+QQ9q1toA+TBl+TX+kKwi+zziTJHLzC/Z2yMU
         uCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rUEo2ymm1PXl62fUfLLLw3fQUnSwO6veMAzxwu2oAuk=;
        b=ZAtq/GRv/69GzJBJAU/mnINir6oRV80MOibbUFh31tMP5a0cc57MWHmLj1d72ypwMe
         WvlBAhYN70vIInD2/sJpENra3OdIvjAzZLfZRuXzj9gsywsTiSRLLN8RkTCAIBMGEoHN
         1+UOMIfS5R8e602mukCGKtOUbnYYBvhwUrdGHXGjfpAXp+JnshucjS03h6UiFJ1z9AVv
         Llvp6m4Ndh2OEQvsKNrqPiFfPqY0hKzBBXQrZb5zHmxart0vsyKMUL4b5mgdBLZx2iAm
         t9nsP8WbuzU2LteFgP95qS85j1fOfZuH6crbtDYSPteQU7tUSdt+G1B1k5FByzEacdsC
         bVIg==
X-Gm-Message-State: AOAM530aBz1VRMhrmWdlTCld4kq8vKMoeKD6oiT0FF/bU0Q2EXsgMAvd
        Yfd9ILphgp94Oxg9i5gs/LlqBg==
X-Google-Smtp-Source: ABdhPJwGzdAL2/wRuNfjey+PXVF5Uw4uvnuSrQM9YGJky2hnvbhS8e3E5wir6j0I6fd8eUkqD+KBpw==
X-Received: by 2002:a05:6a00:8d0:b029:1b6:3581:4f41 with SMTP id s16-20020a056a0008d0b02901b635814f41mr2108903pfu.56.1611609821727;
        Mon, 25 Jan 2021 13:23:41 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id s73sm17997839pgc.46.2021.01.25.13.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 13:23:41 -0800 (PST)
Subject: Re: [PATCH 0/2] Resource-managed blk_ksm_init()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block <linux-block@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Satya Tangirala <satyat@google.com>
References: <20210121082155.111333-1-ebiggers@kernel.org>
 <CAPDyKFrLn_4Csxc6BeRR0-zY+_RQuNqNSF9SmKk3Bx2WFJJ_Ag@mail.gmail.com>
 <2d03dda2-adaf-a44a-922d-f3770e3da8f4@kernel.dk> <YA82Y43vGr30v7Ml@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <848e8646-b179-6f83-1c26-97c984a2c85f@kernel.dk>
Date:   Mon, 25 Jan 2021 14:23:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YA82Y43vGr30v7Ml@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/21 2:21 PM, Eric Biggers wrote:
> On Mon, Jan 25, 2021 at 02:14:32PM -0700, Jens Axboe wrote:
>> On 1/21/21 5:50 AM, Ulf Hansson wrote:
>>> + Jens, Martin, James
>>>
>>>
>>> On Thu, 21 Jan 2021 at 09:23, Eric Biggers <ebiggers@kernel.org> wrote:
>>>>
>>>> This patchset adds a resource-managed variant of blk_ksm_init() so that
>>>> drivers don't have to worry about calling blk_ksm_destroy().
>>>>
>>>> This was suggested during review of my patchset which adds eMMC inline
>>>> encryption support
>>>> (https://lkml.kernel.org/linux-mmc/20210104184542.4616-1-ebiggers@kernel.org/T/#u).
>>>> That patchset proposes a second caller of blk_ksm_init().  But it can
>>>> instead use the resource-managed variant, as can the UFS driver.
>>>>
>>>> My preference is that patch #1 be taken through the MMC tree together
>>>> with my MMC patchset, so that we don't have to wait an extra cycle for
>>>> the MMC changes.  Patch #2 can then go in later.
>>>
>>> Sure, I can pick patch #1 through my mmc tree, but need an ack from
>>> Jens to do it. Or whatever he prefers.
>>
>> Or we can take it through the block tree, usually the easiest as
>> it's the most likely source of potential conflicts. And that's true
>> for both of them, as long as the SCSI side signs off on patch 2/2.
>>
> 
> As I mentioned, the issue is that my patchset to add eMMC inline encryption
> support (https://lkml.kernel.org/r/20210121090140.326380-1-ebiggers@kernel.org)
> depends on devm_blk_ksm_init(), as it was requested during review.
> 
> So if devm_blk_ksm_init() goes in through the block tree, Ulf won't be able to
> take the eMMC patchset for 5.12.

Well he could, such cross tree dependencies are not hard to solve. But
as mentioned in the other email, for this one, just queued it up
yourself. You can add my acked-by to it.

-- 
Jens Axboe

