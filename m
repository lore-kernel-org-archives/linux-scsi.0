Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE6CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 15:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354796AbiDOPFC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 11:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347234AbiDOPFA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 11:05:00 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15469B8236;
        Fri, 15 Apr 2022 08:02:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VA7tRbT_1650034947;
Received: from 30.0.160.194(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VA7tRbT_1650034947)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Apr 2022 23:02:28 +0800
Message-ID: <36df03a0-a0d9-f43b-8c51-166ef6a790fd@linux.alibaba.com>
Date:   Fri, 15 Apr 2022 23:02:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20220411135958.21385-1-xiaoguang.wang@linux.alibaba.com>
 <cb3a64c6-eeee-213f-ad71-d343e9c0e13c@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <cb3a64c6-eeee-213f-ad71-d343e9c0e13c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

> Hi,
>
> Thank you for the patch.
>
> I'm wondering whether we need the new function
> tcmu_wait_inflight_page_fault? Your previous patch just fixed
> tcmu_vma_fault and tcmu_try_get_data_page to call get_page() while
> holding cmdr_lock. So, I think we are safe to first call
> tcmu_blocks_release and then do unmap_mapping_range.
> If so, we could simply add lock_page() and unlock_page() to
> tcmu_blocks_release avoiding the need for a second walk through the
> xarray.
Oh, you're right, thanks.
I'll prepare V3 soon.

Regards,
Xiaoguang Wang

>
> Bodo
>
> On 11.04.22 15:59, Xiaoguang Wang wrote:
>> When tcmu_vma_fault() gets one page successfully, before the current
>> context completes page fault procedure, find_free_blocks() may run in
>> and call unmap_mapping_range() to unmap this page. Assume when
>> find_free_blocks() completes its job firstly, previous page fault
>> procedure starts to run again and completes, then one truncated page has
>> beed mapped to use space, but note that tcmu_vma_fault() has gotten one
>> refcount for this page, so any other subsystem won't use this page,
>> unless later the use space addr is unmapped.
>>
>> If another command runs in later and needs to extends dbi_thresh, it may
>> reuse the corresponding slot to previous page in data_bitmap, then though
>> we'll allocate new page for this slot in data_area, but no page fault will
>> happen again, because we have a valid map, real request's data will lose.
>>
>> Filesystem implementations will also run into this issue, but they
>> usually lock page when vm_operations_struct->fault gets one page, and
>> unlock page after finish_fault() completes. In truncate sides, they
>> lock pages in truncate_inode_pages() to protect race with page fault.
>> We can also have similar codes like filesystem to fix this issue.
>>
>> To fix this possible data corruption, we can apply similar method like
>> filesystem. For pages that are to be freed, find_free_blocks() locks
>> and unlocks these pages, and make tcmu_vma_fault() also lock found page
>> under cmdr_lock. With this action, for above race, find_free_blocks()
>> will wait all page faults to be completed before calling
>> unmap_mapping_range(), and later if unmap_mapping_range() is called,
>> it will ensure stale mappings to be removed cleanly.
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>
>> ---
>> V2:
>>    Wait all possible inflight page faults to be completed in
>> find_free_blocks() to fix possible stale map.
>> ---
>>   drivers/target/target_core_user.c | 39 ++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 38 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>> index fd7267baa707..ed026f5bdb14 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -20,6 +20,7 @@
>>   #include <linux/configfs.h>
>>   #include <linux/mutex.h>
>>   #include <linux/workqueue.h>
>> +#include <linux/pagemap.h>
>>   #include <net/genetlink.h>
>>   #include <scsi/scsi_common.h>
>>   #include <scsi/scsi_proto.h>
>> @@ -1657,6 +1658,20 @@ static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
>>       return -EINVAL;
>>   }
>>   +static void tcmu_wait_inflight_page_fault(struct tcmu_dev *udev,
>> +            unsigned long first, unsigned long last)
>> +{
>> +    XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
>> +    struct page *page;
>> +
>> +    xas_lock(&xas);
>> +    xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
>> +        lock_page(page);
>> +        unlock_page(page);
>> +    }
>> +    xas_unlock(&xas);
>> +}
>> +
>>   static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
>>                   unsigned long last)
>>   {
>> @@ -1822,6 +1837,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>>       page = xa_load(&udev->data_pages, dpi);
>>       if (likely(page)) {
>>           get_page(page);
>> +        lock_page(page);
>>           mutex_unlock(&udev->cmdr_lock);
>>           return page;
>>       }
>> @@ -1863,6 +1879,7 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
>>       struct page *page;
>>       unsigned long offset;
>>       void *addr;
>> +    int ret = 0;
>>         int mi = tcmu_find_mem_index(vmf->vma);
>>       if (mi < 0)
>> @@ -1887,10 +1904,11 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
>>           page = tcmu_try_get_data_page(udev, dpi);
>>           if (!page)
>>               return VM_FAULT_SIGBUS;
>> +        ret = VM_FAULT_LOCKED;
>>       }
>>         vmf->page = page;
>> -    return 0;
>> +    return ret;
>>   }
>>     static const struct vm_operations_struct tcmu_vm_ops = {
>> @@ -3205,6 +3223,25 @@ static void find_free_blocks(void)
>>               udev->dbi_max = block;
>>           }
>>   +        /*
>> +         * While reaching here, there maybe page faults occurring on
>> +         * these to be released pages, and there maybe one race that
>> +         * unmap_mapping_range() is called before page fault on these
>> +         * pages are finished, then valid but stale map is created.
>> +         *
>> +         * If another command runs in later and needs to extends
>> +         * dbi_thresh, it may reuse the corresponding slot to previous
>> +         * page in data_bitmap, then though we'll allocate new page for
>> +         * this slot in data_area, but no page fault will happen again,
>> +         * because we have a valid map, command's data will lose.
>> +         *
>> +         * So here we lock and unlock pages that are to be released to
>> +         * ensure all page faults to be completed, then following
>> +         * unmap_mapping_range() can ensure stale maps to be removed
>> +         * cleanly.
>> +         */
>> +        tcmu_wait_inflight_page_fault(udev, start, end - 1);
>> +
>>           /* Here will truncate the data area from off */
>>           off = udev->data_off + (loff_t)start * udev->data_blk_size;
>>           unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);

