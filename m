Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5EB6C4332B
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 23:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97AB922B37
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 23:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732665AbhAYXrK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 18:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732558AbhAYVRj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 16:17:39 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19006C061574
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2021 13:16:32 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id t29so9126170pfg.11
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2021 13:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+xXlGKTVDgIyvWhOoljB9Gs9FebPS3Flyvxw1e08Ee4=;
        b=NdK/uI7VhBO9KWdGbLnVxZKhox4QUgowO1vpru6G1PeartHOjKFh8WvQlF0fhdPl5q
         mIKgSpdJ+WvOOnLJcgqMvgONzmyPe9PDyw/yFcX33n45HgJJgmlsXSx1kuaMomVt/N5W
         osFpkbr1DVcEkYoEXaU4vIk52KZkVSFgS8YkpLIzU64oGgcI44BzqlTlKjLIJL0DTace
         ENKiFrM+ATIX/9iI2oSLmKgx6mpwqfBObVg+NvFCBLfMfULuFtG+WiOFZ/7vf7IAAu12
         3ArfEIKUs/wSdNPilvkqKr33g5B8lK38kWT9GMJff3a7tx0lRCfU+eHbtkOMLLbtL01t
         Ymeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+xXlGKTVDgIyvWhOoljB9Gs9FebPS3Flyvxw1e08Ee4=;
        b=frPTmylBuuWU/UlltsaaG+z7onoNXA/xviiu/ANChr+EhvPAZDugjlX9sbXyRzfRqz
         ZcJI5hDuP9lgNBObZP0plLWlELDLy9fmxCdKxuhdDXLeWpfCBM/m+qFUHmPFHOmiqjBh
         oBaDQwKR6YqH4LDdqIdDNVW05ePCq54gkUsi4QkQJrs6V+nmIxIanD3vocAhYRv9Wrxz
         NvJ1sbVow9iVE8FCRTddezK2rUOP18FhNiFkWQQlojyRoyiqvb45JVRYQkw3PocRGqyV
         qm/2ir09b+niZ++gmxVzRYdgCdKxR114LjYPlxcGbehxbkspwInrkH09Ig5balIu7pqg
         n67Q==
X-Gm-Message-State: AOAM531xtQn96XgO7ftBEUwlIX4RP9BXo0ZufeNC9rKJwtuwcfaeRLIe
        QP/FtPzOKV+hPNJCnxh8YOiYwQ==
X-Google-Smtp-Source: ABdhPJwzuZn6IAHaUTKcz4pq9UDRKZp32og5hS04jcTF9nG6ejx0eeknVKsRuMOrUgoTmKNsC5GZKA==
X-Received: by 2002:a65:6290:: with SMTP id f16mr2400670pgv.69.1611609391559;
        Mon, 25 Jan 2021 13:16:31 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 6sm17653269pfz.34.2021.01.25.13.16.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 13:16:30 -0800 (PST)
Subject: Re: [PATCH 1/2] block/keyslot-manager: introduce devm_blk_ksm_init()
To:     Eric Biggers <ebiggers@kernel.org>,
        Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
References: <20210121082155.111333-1-ebiggers@kernel.org>
 <20210121082155.111333-2-ebiggers@kernel.org>
 <CAA+FYZerh02JXSKghCKuG29ATdYU_=2O93moGnLgD6Jv2v2auQ@mail.gmail.com>
 <YA8pMDqHsKZA0zfR@sol.localdomain>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3b1b6a94-f283-e8a3-8638-6475d0323c30@kernel.dk>
Date:   Mon, 25 Jan 2021 14:16:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YA8pMDqHsKZA0zfR@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/21 1:25 PM, Eric Biggers wrote:
> On Mon, Jan 25, 2021 at 12:14:00PM -0800, Satya Tangirala wrote:
>> On Thu, Jan 21, 2021 at 12:23 AM Eric Biggers <ebiggers@kernel.org> wrote:
>>>
>>> From: Eric Biggers <ebiggers@google.com>
>>>
>>> Add a resource-managed variant of blk_ksm_init() so that drivers don't
>>> have to worry about calling blk_ksm_destroy().
>>>
>>> Note that the implementation uses a custom devres action to call
>>> blk_ksm_destroy() rather than switching the two allocations to be
>>> directly devres-managed, e.g. with devm_kmalloc().  This is because we
>>> need to keep zeroing the memory containing the keyslots when it is
>>> freed, and also because we want to continue using kvmalloc() (and there
>>> is no devm_kvmalloc()).
>>>
>>> Signed-off-by: Eric Biggers <ebiggers@google.com>
> [..]
>>> diff --git a/include/linux/keyslot-manager.h b/include/linux/keyslot-manager.h
>>> index 18f3f5346843f..443ad817c6c57 100644
>>> --- a/include/linux/keyslot-manager.h
>>> +++ b/include/linux/keyslot-manager.h
>>> @@ -85,6 +85,9 @@ struct blk_keyslot_manager {
>>>
>>>  int blk_ksm_init(struct blk_keyslot_manager *ksm, unsigned int num_slots);
>>>
>>> +int devm_blk_ksm_init(struct device *dev, struct blk_keyslot_manager *ksm,
>>> +                     unsigned int num_slots);
>>> +
>>>  blk_status_t blk_ksm_get_slot_for_key(struct blk_keyslot_manager *ksm,
>>>                                       const struct blk_crypto_key *key,
>>>                                       struct blk_ksm_keyslot **slot_ptr);
>>> --
>>
>> Looks good to me. Please feel free to add
>> Reviewed-by: Satya Tangirala <satyat@google.com>
> 
> Thanks Satya.  Jens, any objection to this patch going in through the MMC tree?

No objections from me, doesn't look like we have any real worries of
conflicts.

-- 
Jens Axboe

