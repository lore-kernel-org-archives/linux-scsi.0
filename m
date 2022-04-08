Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D1CC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 11:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiDHLhC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 07:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiDHLhB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 07:37:01 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9116D1FA5F;
        Fri,  8 Apr 2022 04:34:57 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id qh7so16651020ejb.11;
        Fri, 08 Apr 2022 04:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oc2aSIcmw8UQwHtPl9ryEEa1rfYk3kDUXosrq4ZLbTM=;
        b=A+PfFlbA22iYNpe3wZN2vkPWEL69ZOt/Z5e0TxfKAblkzmpD+gvXgbYzdoQFAkan4S
         vmMdEUYWtyPoFLurXmN7p/TqJEUiZgTUnszxiDm9v45TFLWCasYoW3rSPyKUlzugOY4l
         eiSj7tNK4sgINNacax2h1TwHDUZwnQ8opEAMIk/WIv+J4Y8RtR5j7CeLbJzw+9cW0OAR
         p3fQy1Jt3n7rBeQXKkmavBr5jkSkPoVVPMJ/9dib7QxYg528PTtnV0Bd2YLEsRufNe9t
         lGARou4LgCd/n/0P85M0ct9qJOOTQK1ENsvDv+C3YaGY8RCqgC0OLP6KYfYszE4IuFI0
         x3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oc2aSIcmw8UQwHtPl9ryEEa1rfYk3kDUXosrq4ZLbTM=;
        b=zWHvQTOnkeHGETyvEPcNGAB5Z7JudAKvqYjKE2z+A5cbhUWuevdY/slNLGXWw8Ro1m
         su3hF2IBcRHNIpVrfteRqKPTNBQab1XGKgwq+Y7P878nmuw608QolPYrsbSHCRjJqvkm
         dTCfF5FZCP4Sjhvne0cWSk3olG+VmxU7nawKq/EFUFLYErTaDIOfI4GhFJh1+cxjnj16
         egku58ljDKPQkELJpPqw7iGDk4em8yorFZ68DyOouq531152k6R7054YESIQQwmGIU9C
         Rvfc5bGztVi/XQST4sTbt7nju4FchMWh9gdqz+hveCpvriGPz5gtwvYUi76jfOZsVcwt
         baaA==
X-Gm-Message-State: AOAM531VdTmBOjh5Ov7aUZzVh7xND2YuiArn6NnTbf2jUk29XKMyZ0MA
        DXEMdlwhGIZ+QvyFKxMNlA50cOhKunk=
X-Google-Smtp-Source: ABdhPJw0ujR1Ngs6s2mfa8kAHl71pN4TSQ0xK9w5EC3rAZSVE9ZTnI2krLlRtaIkslw/1rK9h+oO5w==
X-Received: by 2002:a17:907:728b:b0:6df:8f3b:28ae with SMTP id dt11-20020a170907728b00b006df8f3b28aemr17847584ejc.336.1649417696040;
        Fri, 08 Apr 2022 04:34:56 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id d19-20020a170906c21300b006e7f0730353sm5553432ejz.101.2022.04.08.04.34.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 04:34:55 -0700 (PDT)
Message-ID: <37af149e-6ee4-b0c4-90c4-cddb1b50db9a@gmail.com>
Date:   Fri, 8 Apr 2022 13:34:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 3/3] scsi: target: tcmu: Use
 address_space->invalidate_lock
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20220323134940.31463-1-xiaoguang.wang@linux.alibaba.com>
 <20220323134940.31463-4-xiaoguang.wang@linux.alibaba.com>
 <5226b4ae-33fe-2bee-b88a-240994231d1c@gmail.com>
 <7038dcfd-4f66-2d8c-d988-132a84193b33@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <7038dcfd-4f66-2d8c-d988-132a84193b33@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04.04.22 17:09, Xiaoguang Wang wrote:
> hi,
> 
>> On 23.03.22 14:49, Xiaoguang Wang wrote:
>>> Currently tcmu_vma_fault() uses udev->cmdr_lock to avoid concurrent
>>> find_free_blocks(), which unmaps idle pages and truncates them. This
>>> work is really like many filesystem's truncate operations, but they
>>> use address_space->invalidate_lock to protect race.
>>>
>>> This patch replaces cmdr_lock with address_space->invalidate_lock in
>>> tcmu fault procedure, which will also make page-fault have concurrency.
>>>
>>
>> Page fault happens only once for each allocated data page. After the
>> page fault was processed, the page is re-used for many cmds without
>> further page faults.
> Oh, right, I almost have forgotten that, thanks.
> 
>>
>> Of course, if find_free_blocks released a page and tcmu after that
>> allocates a new one, another page fault will occur. But that is a
>> very rare case.
> Yeah, now I agree it will happen rarely, but will still happen, especially
> in the early stages of page fault establishment when tcmu device is
> freshly created.
> 
> And in current codes, tcmu normally reclaim free pages under such
> conditions:
>          if (atomic_read(&global_page_count) > tcmu_global_max_pages &&
>              xa_empty(&udev->commands) && list_empty(&udev->qfull_queue)) {
>                  /*
>                   * Allocated blocks exceeded global block limit, currently no
>                   * more pending or waiting commands so try to reclaim blocks.
>                   */
>                  schedule_delayed_work(&tcmu_unmap_work, 0);
>          }
> 
> I'm not sure whether this method is good, seems other subsystems use
> mm shrinker feature to reclaim free pages when system memory is low.
> tcmu_global_max_pages is 512k, 2GB memory, that means if tcmu devices
> really have allocated 2GB memory, these memory won't be tried to be freed
> even whole system memory is very low.
> What I want to express is that though currently page fault occurs rarely,
> but if we use a better memory reclaim method later, page fault may occur
> more.

The way how memory limit currently is implemented in tcmu really looks
not very sophisticated. It waits until the hard limit is reached and
then frees as much memory as possible. Ideas for a better algorithm are
welcome!

Currently, I think the best way to limit mem usage in existing tcmu
is to limit data area size per tcmu device. The default of 1 GB per dev
I think is rarely needed. So users should configure devices carefully.
OTOH, if many tcmu devs are in use, even with small data areas the total
limit of 2GB can easily be reached. E.g., I know of a customer who uses
256 tcmu devs with 16MB each. So he rises the global limit to even 4GB,
as from performance point of view every releasing of data pages with
later re-allocation is just an overhead.

 From this point of view I think it would be difficult to find a good
algorithm.

> 
>>
>> So, what is the advantage of concurrency here?
> cmdr_lock is a mutex, so it meas that tcmu page fault could not happen
> concurrently, and indeed mm subsystem allows page fault to run concurrently.
> If we change to use filemap_invalidate_lock_shared() in tcmu page fault,
> I think there will be two advantages:
> 1) Though page fault will happen rarely in tcmu if system memory is
> enough, in the early stages of page fault establishment, say we'll
> finally make the default 1GB data area have page fault happened.
> At least in this stage, page fault will have concurrency.
> Also if page fault happens with queue_cmd_ring() at the same time,
> for big io size, queue_cmd_ring() may hold cmdr_lock for long time
> because of data area and sgl pages copy, page fault will be stalled
> for a long time, which will result in long tail latency.

TCM core can send multiple new cmds to tcmu concurrently, but cmdr_lock
forces sequential processing. So, some time ago I started an attempt to
make tcmu release the cmdr_lock while it copies sgl_pages. The measured
results unfortunately were not as good as expected. But I still need to
do further meassurements to find and possibly fix the reason.

With that change, I hope to also lower the latency by far for cmds
with big data transfers.

> 
> 2) If we latter try to support zero copy successfully, we'll need to
> call zap_page_range() in tcmu_handle_completion(), which needs to
> hold mm_struct's mmap_lock, then we may have "abba" dead lock issue:
>    page fault: hold mm_struct's mmap_lock, then try to hold cmdr_lock
>    cmd completion: hold cmdr_lock, then try to hold mm_struct's mmap_lock.

I'm still not convinced that you can get the support from mm you need.

BTW: after the cmdr_lock changes I described, the next step from my side
would be to avoid data copy in an even more efficient way for at least
those fabrics, that use core sgl allocation by calling
transport_generic_new_command or transport_handle_cdb_direct, or
target_submit_prep without pre-allocated sgls. The idea is to add a new
optional backend call that allows the backend (tcmu) to build sgls from
its own pages (tcmu: data pages). This method avoid data copy _and_
the need for mapping/unmapping sgl pages because we use already mapped
pages.

Of cause, this method does not speed up loopback, vhost and some other
fabrics, but it works very well e.g. for qla2xxx.

> 
> Or we can define a new "struct rw_semaphore i_mmap_sem;" in
> tcmu_dev, and use it rather than filemap_invalidate_lock_shared(mapping);
> 
>>
>> OTOH, I don't like the switch from tcmu's cmdr_lock to
>> filemap_invalidate_* without a real technical reason.
> Anyway, at least I don't see any obvious disadvantages
> about this patch.
> 
> 
> Regards,
> Xiaoguang Wang
>>
>>
>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>> ---
>>>    drivers/target/target_core_user.c | 14 ++++++++++----
>>>    1 file changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>>> index 9196188504ec..81bfa553cc67 100644
>>> --- a/drivers/target/target_core_user.c
>>> +++ b/drivers/target/target_core_user.c
>>> @@ -1820,13 +1820,14 @@ static int tcmu_find_mem_index(struct vm_area_struct *vma)
>>>      static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>>>    {
>>> +    struct address_space *mapping = udev->inode->i_mapping;
>>>        struct page *page;
>>>    -    mutex_lock(&udev->cmdr_lock);
>>> +    filemap_invalidate_lock_shared(mapping);
>>>        page = xa_load(&udev->data_pages, dpi);
>>>        if (likely(page)) {
>>>            get_page(page);
>>> -        mutex_unlock(&udev->cmdr_lock);
>>> +        filemap_invalidate_unlock_shared(mapping);
>>>            return page;
>>>        }
>>>    @@ -1836,7 +1837,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>>>         */
>>>        pr_err("Invalid addr to data page mapping (dpi %u) on device %s\n",
>>>               dpi, udev->name);
>>> -    mutex_unlock(&udev->cmdr_lock);
>>> +    filemap_invalidate_unlock_shared(mapping);
>>>          return NULL;
>>>    }
>>> @@ -3116,6 +3117,7 @@ static void find_free_blocks(void)
>>>        loff_t off;
>>>        u32 pages_freed, total_pages_freed = 0;
>>>        u32 start, end, block, total_blocks_freed = 0;
>>> +    struct address_space *mapping;
>>>          if (atomic_read(&global_page_count) <= tcmu_global_max_pages)
>>>            return;
>>> @@ -3139,6 +3141,8 @@ static void find_free_blocks(void)
>>>                continue;
>>>            }
>>>    +        mapping = udev->inode->i_mapping;
>>> +        filemap_invalidate_lock(mapping);
>>>            end = udev->dbi_max + 1;
>>>            block = find_last_bit(udev->data_bitmap, end);
>>>            if (block == udev->dbi_max) {
>>> @@ -3146,6 +3150,7 @@ static void find_free_blocks(void)
>>>                 * The last bit is dbi_max, so it is not possible
>>>                 * reclaim any blocks.
>>>                 */
>>> +            filemap_invalidate_unlock(mapping);
>>>                mutex_unlock(&udev->cmdr_lock);
>>>                continue;
>>>            } else if (block == end) {
>>> @@ -3159,10 +3164,11 @@ static void find_free_blocks(void)
>>>              /* Here will truncate the data area from off */
>>>            off = udev->data_off + (loff_t)start * udev->data_blk_size;
>>> -        unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
>>> +        unmap_mapping_range(mapping, off, 0, 1);
>>>              /* Release the block pages */
>>>            pages_freed = tcmu_blocks_release(udev, start, end - 1);
>>> +        filemap_invalidate_unlock(mapping);
>>>            mutex_unlock(&udev->cmdr_lock);
>>>              total_pages_freed += pages_freed;
> 
