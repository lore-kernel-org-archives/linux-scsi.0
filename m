Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC40BC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 10:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbiDHKfb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 06:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbiDHKfX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 06:35:23 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F9319FF4D;
        Fri,  8 Apr 2022 03:33:19 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bg10so16461401ejb.4;
        Fri, 08 Apr 2022 03:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UqBif9+iFybWmxI64ysyl0V/yFSEfZiKtdTwlbqX6/8=;
        b=Xsk/NbEyWhEK76l6rad958FsA/Q/MhtxX+VTtNhxilMd7B9OsyNKglmJdhb+jpH8LT
         p0xvZF0ck6JWdUMXJRPwCiqVZF4V6+5Y8rBPvh6IY0JN+uggY8RXWxDvrsobQbge7QAJ
         ejagJ81dzthcrWc1FVSMbZtjziyW2S6yFDDepHxHlWNi7ht0P42wvgrquqO8EtEAHLkn
         mub+hp5AvzXy3iRQcyQ1rB32FMyPO7NBc04Yh3BHU7mqm9PaJNLuVEXWDQdqBTY4nwZs
         llqWg/HYGMcgk/veqVExCfticGHTjfhjUf/gtjN8/PxYayPlU9Kakoa9GtAboq8LzHYR
         FJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UqBif9+iFybWmxI64ysyl0V/yFSEfZiKtdTwlbqX6/8=;
        b=Vlse8Cm8339d71h+F9dvdI9Q/PXvuyCvzp3s18Bkw9dhft1BIdjWbHdy1KlsSoBNBl
         2Dt3EAvm7MlU2c0uDus29iT6AAy48A14KkBbarn1rzMZrl5s1USW6mTBdTNtXix/6TF6
         oGA8yrgLkHHRq/55NlQFbMEG+2ln76StQzNipZ9SUwXz/tWkDQ3f6MNSSQwQjt2hc6F5
         3jJxcp7QT5GylLoYjNi11B/HQ3k0HQzEIV2z8upsZotzfnkvYnOiP7TDE8C8GbbPT+gB
         He9QGzj9/eu4XjQ5R5Mec3NeDFPje5CNFCBzVMmgnkprD84ebtorG7TODSIZENP7APio
         +02Q==
X-Gm-Message-State: AOAM531jOI9r+koP8yLpUBJdQ0ssGCg8MEZGDj00xkhO0aCeAI5gcfFG
        GTsFReZbnsY3q/BiHAdRbnrOWB0e4h8=
X-Google-Smtp-Source: ABdhPJxEZhdVF6nnzpNxfodxf9yM5zDw0wz73FiENLDvkCmkpQzaG+2dbufzk2Sk/fk9rXKGlO6cWw==
X-Received: by 2002:a17:907:608d:b0:6e7:f1d1:ff42 with SMTP id ht13-20020a170907608d00b006e7f1d1ff42mr18391744ejc.620.1649413998106;
        Fri, 08 Apr 2022 03:33:18 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id jv20-20020a170907769400b006e7f859e683sm4969771ejc.19.2022.04.08.03.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 03:33:17 -0700 (PDT)
Message-ID: <3e704fd9-b65d-6c5f-b710-df52aaae3bdf@gmail.com>
Date:   Fri, 8 Apr 2022 12:33:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/3] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20220323134940.31463-1-xiaoguang.wang@linux.alibaba.com>
 <20220323134940.31463-3-xiaoguang.wang@linux.alibaba.com>
 <b6280955-d3f5-f11b-5f62-07ab83cff4ac@gmail.com>
 <e5923923-375f-c696-0c87-ca5def984d84@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <e5923923-375f-c696-0c87-ca5def984d84@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05.04.22 18:03, Xiaoguang Wang wrote:
> hi,
> 
>> On 23.03.22 14:49, Xiaoguang Wang wrote:
>>> When tcmu_vma_fault() gets one page successfully, before the current
>>> context completes page fault procedure, find_free_blocks() may run in
>>> and call unmap_mapping_range() to unmap this page. Assume when
>>> find_free_blocks() completes its job firstly, previous page fault
>>> procedure starts to run again and completes, then one truncated page has
>>> beed mapped to use space, but note that tcmu_vma_fault() has gotten one
>>> refcount for this page, so any other subsystem won't use this page,
>>> unless later the use space addr is unmapped.
>>>
>>> If another command runs in later and needs to extends dbi_thresh, it may
>>> reuse the corresponding slot to previous page in data_bitmap, then thouth
>>> we'll allocate new page for this slot in data_area, but no page fault will
>>> happen again, because we have a valid map, real request's data will lose.
>>
>> I don't think, this is a safe fix. It is possible that not only
>> find_free_blocks runs before page fault procedure completes, but also
>> allocation for next cmd happens. In that case the new call to
>> unmap_mapping_range would also happen before page fault completes ->
>> data corruption.
>>
>> AFAIK, no one ever has seen this this bug in real life, as
> Yeah, I know, just find this maybe an issue by reading codes :)
> 
>> find_free_blocks only runs seldomly and userspace would have to access
>> a data page the very first time while the cmd that owned this page
>> already has been completed by userspace. Therefore I think we should
>> apply a perfect fix only.
>>
>> I'm wondering whether there really is such a race. If so, couldn't the
>> same race happen in other drivers or even when truncating mapped files?
> Indeed, I have described how filesystem implementations avoid this issue
> in patch's commit message:
> 
>    Filesystem implementations will also run into this issue, but they
>    usually lock page when vm_operations_struct->fault gets one page, and
>    unlock page after finish_fault() completes. In truncate sides, they
>    lock pages in truncate_inode_pages() to protect race with page fault.
>    We can also have similar codes like filesystem to fix this issue.
> 
> 
> Take ext4 as example, a file in ext4 is mapped to user space, if then a truncate
> operation occurs, ext4 calls truncate_pagecache():
> void truncate_pagecache(struct inode *inode, loff_t newsize)
> {
>          struct address_space *mapping = inode->i_mapping;
>          loff_t holebegin = round_up(newsize, PAGE_SIZE);
> 
>          /*
>           * unmap_mapping_range is called twice, first simply for
>           * efficiency so that truncate_inode_pages does fewer
>           * single-page unmaps.  However after this first call, and
>           * before truncate_inode_pages finishes, it is possible for
>           * private pages to be COWed, which remain after
>           * truncate_inode_pages finishes, hence the second
>           * unmap_mapping_range call must be made for correctness.
>           */
>          unmap_mapping_range(mapping, holebegin, 0, 1);
>          truncate_inode_pages(mapping, newsize);
>          unmap_mapping_range(mapping, holebegin, 0, 1);
> }
> 
> In truncate_inode_pages(), it'll lock page and set page->mapping
> to be NULL, and in ext4's filemap_fault(), it'll lock page and check whether
> page->mapping has been changed, if it's true, it'll just fail the page
> fault procedure.
> 
> For tcmu, though the data area's pages don't have a valid mapping,
> but we can apply similar method.
> In tcmu_vma_fault(), we lock the page and set VM_FAULT_LOCKED
> flag,

Yeah, looking into page fault handling I'm wondering why tcmu didn't do
that from the beginning!

> in find_free_blocks(), we firstly try to lock pages which are going
> to be released, if lock_page() returns,

I assume, we immediately unlock the page again, right?

> we can ensure that there are
> not inflight running page fault procedure, and following unmap_mapping_range()
> will also ensure that all user maps will be cleared.
> Seems that it'll resolve this possible issue, please have a check, thanks.

AFAICS, this is the clean solution we were searching for.

Thank you
Bodo
