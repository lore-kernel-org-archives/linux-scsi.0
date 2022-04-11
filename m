Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CD1C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 06:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiDKGTP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 02:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiDKGTN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 02:19:13 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D7C3CFDA;
        Sun, 10 Apr 2022 23:16:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V9j3zU6_1649657815;
Received: from 30.225.28.189(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V9j3zU6_1649657815)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Apr 2022 14:16:56 +0800
Message-ID: <15e92dcf-5d81-0880-bd5c-75cbd29063a0@linux.alibaba.com>
Date:   Mon, 11 Apr 2022 14:16:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 3/3] scsi: target: tcmu: Use
 address_space->invalidate_lock
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20220323134940.31463-1-xiaoguang.wang@linux.alibaba.com>
 <20220323134940.31463-4-xiaoguang.wang@linux.alibaba.com>
 <5226b4ae-33fe-2bee-b88a-240994231d1c@gmail.com>
 <7038dcfd-4f66-2d8c-d988-132a84193b33@linux.alibaba.com>
 <37af149e-6ee4-b0c4-90c4-cddb1b50db9a@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <37af149e-6ee4-b0c4-90c4-cddb1b50db9a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

> On 04.04.22 17:09, Xiaoguang Wang wrote:
>> hi,
>>
>>> On 23.03.22 14:49, Xiaoguang Wang wrote:
>>>> Currently tcmu_vma_fault() uses udev->cmdr_lock to avoid concurrent
>>>> find_free_blocks(), which unmaps idle pages and truncates them. This
>>>> work is really like many filesystem's truncate operations, but they
>>>> use address_space->invalidate_lock to protect race.
>>>>
>>>> This patch replaces cmdr_lock with address_space->invalidate_lock in
>>>> tcmu fault procedure, which will also make page-fault have concurrency.
>>>>
>>>
>>> Page fault happens only once for each allocated data page. After the
>>> page fault was processed, the page is re-used for many cmds without
>>> further page faults.
>> Oh, right, I almost have forgotten that, thanks.
>>
>>>
>>> Of course, if find_free_blocks released a page and tcmu after that
>>> allocates a new one, another page fault will occur. But that is a
>>> very rare case.
>> Yeah, now I agree it will happen rarely, but will still happen, especially
>> in the early stages of page fault establishment when tcmu device is
>> freshly created.
>>
>> And in current codes, tcmu normally reclaim free pages under such
>> conditions:
>>          if (atomic_read(&global_page_count) > tcmu_global_max_pages &&
>>              xa_empty(&udev->commands) && list_empty(&udev->qfull_queue)) {
>>                  /*
>>                   * Allocated blocks exceeded global block limit, currently no
>>                   * more pending or waiting commands so try to reclaim blocks.
>>                   */
>>                  schedule_delayed_work(&tcmu_unmap_work, 0);
>>          }
>>
>> I'm not sure whether this method is good, seems other subsystems use
>> mm shrinker feature to reclaim free pages when system memory is low.
>> tcmu_global_max_pages is 512k, 2GB memory, that means if tcmu devices
>> really have allocated 2GB memory, these memory won't be tried to be freed
>> even whole system memory is very low.
>> What I want to express is that though currently page fault occurs rarely,
>> but if we use a better memory reclaim method later, page fault may occur
>> more.
>
> The way how memory limit currently is implemented in tcmu really looks
> not very sophisticated. It waits until the hard limit is reached and
> then frees as much memory as possible. Ideas for a better algorithm are
> welcome!
>
> Currently, I think the best way to limit mem usage in existing tcmu
> is to limit data area size per tcmu device. The default of 1 GB per dev
> I think is rarely needed. So users should configure devices carefully.
> OTOH, if many tcmu devs are in use, even with small data areas the total
> limit of 2GB can easily be reached. E.g., I know of a customer who uses
> 256 tcmu devs with 16MB each. So he rises the global limit to even 4GB,
> as from performance point of view every releasing of data pages with
> later re-allocation is just an overhead.
>
> From this point of view I think it would be difficult to find a good
> algorithm.
>
>>
>>>
>>> So, what is the advantage of concurrency here?
>> cmdr_lock is a mutex, so it meas that tcmu page fault could not happen
>> concurrently, and indeed mm subsystem allows page fault to run concurrently.
>> If we change to use filemap_invalidate_lock_shared() in tcmu page fault,
>> I think there will be two advantages:
>> 1) Though page fault will happen rarely in tcmu if system memory is
>> enough, in the early stages of page fault establishment, say we'll
>> finally make the default 1GB data area have page fault happened.
>> At least in this stage, page fault will have concurrency.
>> Also if page fault happens with queue_cmd_ring() at the same time,
>> for big io size, queue_cmd_ring() may hold cmdr_lock for long time
>> because of data area and sgl pages copy, page fault will be stalled
>> for a long time, which will result in long tail latency.
>
> TCM core can send multiple new cmds to tcmu concurrently, but cmdr_lock
> forces sequential processing. So, some time ago I started an attempt to
> make tcmu release the cmdr_lock while it copies sgl_pages. The measured
> results unfortunately were not as good as expected. But I still need to
> do further meassurements to find and possibly fix the reason.
OK, thanks.

>
> With that change, I hope to also lower the latency by far for cmds
> with big data transfers.
>
>>
>> 2) If we latter try to support zero copy successfully, we'll need to
>> call zap_page_range() in tcmu_handle_completion(), which needs to
>> hold mm_struct's mmap_lock, then we may have "abba" dead lock issue:
>>    page fault: hold mm_struct's mmap_lock, then try to hold cmdr_lock
>>    cmd completion: hold cmdr_lock, then try to hold mm_struct's mmap_lock.
>
> I'm still not convinced that you can get the support from mm you need.
Yeah, I also get frustrated about current status, but I'll try to see whether
I can do something better later.

OK, now I'm fine that we leave this patch alone. If later I get a better
memory map function, we can go back to this patch :)

>
> BTW: after the cmdr_lock changes I described, the next step from my side
> would be to avoid data copy in an even more efficient way for at least
> those fabrics, that use core sgl allocation by calling
> transport_generic_new_command or transport_handle_cdb_direct, or
> target_submit_prep without pre-allocated sgls. The idea is to add a new
> optional backend call that allows the backend (tcmu) to build sgls from
> its own pages (tcmu: data pages). This method avoid data copy _and_
> the need for mapping/unmapping sgl pages because we use already mapped
> pages.
>
> Of cause, this method does not speed up loopback, vhost and some other
> fabrics, but it works very well e.g. for qla2xxx.
Thanks, it's a good start, and I believe this will give better io throughput.

Regards,
Xiaoguang Wang
>
>>
>> Or we can define a new "struct rw_semaphore i_mmap_sem;" in
>> tcmu_dev, and use it rather than filemap_invalidate_lock_shared(mapping);
>>
>>>
>>> OTOH, I don't like the switch from tcmu's cmdr_lock to
>>> filemap_invalidate_* without a real technical reason.
>> Anyway, at least I don't see any obvious disadvantages
>> about this patch.
>>
>>
>> Regards,
>> Xiaoguang Wang
>>>
>>>
>>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>> ---
>>>>    drivers/target/target_core_user.c | 14 ++++++++++----
>>>>    1 file changed, 10 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>>>> index 9196188504ec..81bfa553cc67 100644
>>>> --- a/drivers/target/target_core_user.c
>>>> +++ b/drivers/target/target_core_user.c
>>>> @@ -1820,13 +1820,14 @@ static int tcmu_find_mem_index(struct vm_area_struct *vma)
>>>>      static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>>>>    {
>>>> +    struct address_space *mapping = udev->inode->i_mapping;
>>>>        struct page *page;
>>>>    -    mutex_lock(&udev->cmdr_lock);
>>>> +    filemap_invalidate_lock_shared(mapping);
>>>>        page = xa_load(&udev->data_pages, dpi);
>>>>        if (likely(page)) {
>>>>            get_page(page);
>>>> -        mutex_unlock(&udev->cmdr_lock);
>>>> +        filemap_invalidate_unlock_shared(mapping);
>>>>            return page;
>>>>        }
>>>>    @@ -1836,7 +1837,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>>>>         */
>>>>        pr_err("Invalid addr to data page mapping (dpi %u) on device %s\n",
>>>>               dpi, udev->name);
>>>> -    mutex_unlock(&udev->cmdr_lock);
>>>> +    filemap_invalidate_unlock_shared(mapping);
>>>>          return NULL;
>>>>    }
>>>> @@ -3116,6 +3117,7 @@ static void find_free_blocks(void)
>>>>        loff_t off;
>>>>        u32 pages_freed, total_pages_freed = 0;
>>>>        u32 start, end, block, total_blocks_freed = 0;
>>>> +    struct address_space *mapping;
>>>>          if (atomic_read(&global_page_count) <= tcmu_global_max_pages)
>>>>            return;
>>>> @@ -3139,6 +3141,8 @@ static void find_free_blocks(void)
>>>>                continue;
>>>>            }
>>>>    +        mapping = udev->inode->i_mapping;
>>>> +        filemap_invalidate_lock(mapping);
>>>>            end = udev->dbi_max + 1;
>>>>            block = find_last_bit(udev->data_bitmap, end);
>>>>            if (block == udev->dbi_max) {
>>>> @@ -3146,6 +3150,7 @@ static void find_free_blocks(void)
>>>>                 * The last bit is dbi_max, so it is not possible
>>>>                 * reclaim any blocks.
>>>>                 */
>>>> +            filemap_invalidate_unlock(mapping);
>>>>                mutex_unlock(&udev->cmdr_lock);
>>>>                continue;
>>>>            } else if (block == end) {
>>>> @@ -3159,10 +3164,11 @@ static void find_free_blocks(void)
>>>>              /* Here will truncate the data area from off */
>>>>            off = udev->data_off + (loff_t)start * udev->data_blk_size;
>>>> -        unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
>>>> +        unmap_mapping_range(mapping, off, 0, 1);
>>>>              /* Release the block pages */
>>>>            pages_freed = tcmu_blocks_release(udev, start, end - 1);
>>>> +        filemap_invalidate_unlock(mapping);
>>>>            mutex_unlock(&udev->cmdr_lock);
>>>>              total_pages_freed += pages_freed;
>>

