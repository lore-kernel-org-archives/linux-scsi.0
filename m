Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536B8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Mar 2022 06:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiCQGT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Mar 2022 02:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiCQGTu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2022 02:19:50 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F21C15B3FD;
        Wed, 16 Mar 2022 23:09:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V7QH7hw_1647497340;
Received: from 30.225.28.160(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V7QH7hw_1647497340)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 17 Mar 2022 14:09:01 +0800
Message-ID: <c3f0d8c6-f468-1685-e89e-3fb0dd079ab5@linux.alibaba.com>
Date:   Thu, 17 Mar 2022 14:09:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] scsi: target: tcmu: Use
 address_space->invalidate_lock
Content-Language: en-US
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20220311132206.24515-1-xiaoguang.wang@linux.alibaba.com>
 <20220311132206.24515-2-xiaoguang.wang@linux.alibaba.com>
 <c6a25258-6937-6cdf-0fab-081312c4dee6@linux.alibaba.com>
 <b04319b3-2214-8d9e-46b4-1772dd003240@gmail.com>
 <02d64544-b5fa-3f06-caab-5239ff60c0bf@linux.alibaba.com>
In-Reply-To: <02d64544-b5fa-3f06-caab-5239ff60c0bf@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

> hi,
>
>> Sorry for the late response. Currently I'm quite busy.
> Really never mind :)
>
>>
>> In your earlier mail you described a possible dead lock.
>> With this patch applied, are you sure a similar deadlock cannot
>> happen?
> AFAIK, this patch will solve the deadlock.
>
>>
>> Additionally, let's assume tcmu_vma_fault/tcmu_try_get_data_page
>> - after having found a valid page to map - is interrupted after
>> releasing the invalidate_lock. Are there any locks held to prevent
>> find_free_blocks from jumping in and possibly remove that page from 
>> xarray and try to remove it from the mmapped area?
>> If not, we might end up mapping a no longer valid page.
> Yeah, after tcmu_try_get_data_page() returns, find_free_blocks() 
> definitely
> may come in and do unmap_mapping_range() and tcmu_blocks_release(),
> but I think it won't cause problems:
> 1) Since page fault procedure and unmap_mapping_range are designed to
> be able to run concurrently, they sync at pte_offset_map_lock(). See
> => do_user_addr_fault
> ==> handle_mm_fault
> ===> __handle_mm_fault
> ====> do_fault
> =====> do_shared_fault
> =======> finish_fault
> ========> pte_offset_map_lock
> ========> do_set_pte
> ========> pte_unmap_unlock
>
> and in find_free_blocks():
> => unmap_mapping_range
> == > unmap_mapping_range_tree
> ===> zap_page_range_single
> ====> unmap_page_range
> =====> zap_p4d_range
> ======> zap_pud_range
> ========> zap_pmd_range
> ==========> zap_pte_range
> ===========> pte_offset_map_lock
> ===========> pte_clear_not_present_full
> ===========> pte_unmap_unlock(start_pte, ptl);
>
> So what I want to express is that because of the concurrency of page 
> fault
> procedure and unmap_mapping_range(), one will either see a valid map, or
> not. And if not, because this page exceeds dbi_max, a later page fault 
> will
> happen, and will get sigbus, but it's reasonable.
>
> As for your question, tcmu_try_get_data_page() finds a page successfully,
> this page will get a refcount properly, if later unmap_mapping_range() 
> and
> tcmu_blocks_release() come in, just after tcmu_try_get_data_page() 
> returns and
> before tcmu_vma_fault() returns, then actually tcmu_blocks_release() 
> won't
> free this page because there is one refcount. So yes, we'll map a no 
> longer
> valid page, but this page also won't be re-used, unless the map is 
> unmapped
> later(process exits or killed), then put_page() will be called and 
> page will finally
> be given back to mm subsystem.
After thinking more about this problem, if we now have a valid map which 
points
to a truncated page, and this offset of this page in data_bitmap is 
freed. If later
another command runs in, it reuse the previous freed slot in 
data_bitmap. Though
we'll allocate new page for this slot in data_area, but seems no page 
fault will
happen again, because we have a valid map.. so real request's data will 
lose.

As you say, indeed this would be a long standing problem, we'll need to have
a deeper look at codes.

Regards,
Xiaoguang Wang

>
>>
>> Of course, this would be a long standing problem not caused by your
>> change. But if there would be a problem, we should try to fix it
>> when touching this code, I think.
>> Unfortunately I didn't manage yet to check which locks are involved
>> during page fault handling and unmap_mapping_range.
> At least for my knowledge, page fault will hold mmap_read_lock() and
> pte lock, unmap_mapping_range() will hold mapping->i_mmap_rwsem
> and pte lock.
>
> Regards,
> Xiaoguang Wang
>>
>> Bodo
>>
>> On 16.03.22 11:43, Xiaoguang Wang wrote:
>>> hello,
>>>
>>> Gentle ping.
>>>
>>> Regards,
>>> Xiaoguang Wang
>>>
>>>> Currently tcmu_vma_fault() uses udev->cmdr_lock to avoid concurrent
>>>> find_free_blocks(), which unmaps idle pages and truncates them. This
>>>> work is really like many filesystem's truncate operations, but they
>>>> use address_space->invalidate_lock to protect race.
>>>>
>>>> This patch replaces cmdr_lock with address_space->invalidate_lock in
>>>> tcmu fault procedure, which will also make page-fault have 
>>>> concurrency.
>>>>
>>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>> ---
>>>>   drivers/target/target_core_user.c | 13 +++++++++----
>>>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/target/target_core_user.c 
>>>> b/drivers/target/target_core_user.c
>>>> index 06a5c4086551..e0a62623ccd7 100644
>>>> --- a/drivers/target/target_core_user.c
>>>> +++ b/drivers/target/target_core_user.c
>>>> @@ -1815,13 +1815,14 @@ static int tcmu_find_mem_index(struct 
>>>> vm_area_struct *vma)
>>>>   static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, 
>>>> uint32_t dpi)
>>>>   {
>>>> +    struct address_space *mapping = udev->inode->i_mapping;
>>>>       struct page *page;
>>>> -    mutex_lock(&udev->cmdr_lock);
>>>> +    filemap_invalidate_lock_shared(mapping);
>>>>       page = xa_load(&udev->data_pages, dpi);
>>>>       if (likely(page)) {
>>>>           get_page(page);
>>>> -        mutex_unlock(&udev->cmdr_lock);
>>>> +        filemap_invalidate_unlock_shared(mapping);
>>>>           return page;
>>>>       }
>>>> @@ -1831,7 +1832,7 @@ static struct page 
>>>> *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>>>>        */
>>>>       pr_err("Invalid addr to data page mapping (dpi %u) on device 
>>>> %s\n",
>>>>              dpi, udev->name);
>>>> -    mutex_unlock(&udev->cmdr_lock);
>>>> +    filemap_invalidate_unlock_shared(mapping);
>>>>       return NULL;
>>>>   }
>>>> @@ -3111,6 +3112,7 @@ static void find_free_blocks(void)
>>>>       loff_t off;
>>>>       u32 pages_freed, total_pages_freed = 0;
>>>>       u32 start, end, block, total_blocks_freed = 0;
>>>> +    struct address_space *mapping;
>>>>       if (atomic_read(&global_page_count) <= tcmu_global_max_pages)
>>>>           return;
>>>> @@ -3134,6 +3136,7 @@ static void find_free_blocks(void)
>>>>               continue;
>>>>           }
>>>> +        mapping = udev->inode->i_mapping;
>>>>           end = udev->dbi_max + 1;
>>>>           block = find_last_bit(udev->data_bitmap, end);
>>>>           if (block == udev->dbi_max) {
>>>> @@ -3152,12 +3155,14 @@ static void find_free_blocks(void)
>>>>               udev->dbi_max = block;
>>>>           }
>>>> +        filemap_invalidate_lock(mapping);
>>>>           /* Here will truncate the data area from off */
>>>>           off = udev->data_off + (loff_t)start * udev->data_blk_size;
>>>> -        unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
>>>> +        unmap_mapping_range(mapping, off, 0, 1);
>>>>           /* Release the block pages */
>>>>           pages_freed = tcmu_blocks_release(udev, start, end - 1);
>>>> +        filemap_invalidate_unlock(mapping);
>>>>           mutex_unlock(&udev->cmdr_lock);
>>>>           total_pages_freed += pages_freed;
>>>

