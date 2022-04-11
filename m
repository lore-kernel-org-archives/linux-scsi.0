Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC94C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 04:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbiDKEvu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 00:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiDKEvt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 00:51:49 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B076C27B24;
        Sun, 10 Apr 2022 21:49:34 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V9hCbw9_1649652571;
Received: from 30.225.28.189(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V9hCbw9_1649652571)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Apr 2022 12:49:32 +0800
Message-ID: <de4b6a3a-6210-d229-204f-08062e2a2670@linux.alibaba.com>
Date:   Mon, 11 Apr 2022 12:49:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/3] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20220323134940.31463-1-xiaoguang.wang@linux.alibaba.com>
 <20220323134940.31463-3-xiaoguang.wang@linux.alibaba.com>
 <b6280955-d3f5-f11b-5f62-07ab83cff4ac@gmail.com>
 <e5923923-375f-c696-0c87-ca5def984d84@linux.alibaba.com>
 <3e704fd9-b65d-6c5f-b710-df52aaae3bdf@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <3e704fd9-b65d-6c5f-b710-df52aaae3bdf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

> On 05.04.22 18:03, Xiaoguang Wang wrote:
>> hi,
>>
>>> On 23.03.22 14:49, Xiaoguang Wang wrote:
>>>> When tcmu_vma_fault() gets one page successfully, before the current
>>>> context completes page fault procedure, find_free_blocks() may run in
>>>> and call unmap_mapping_range() to unmap this page. Assume when
>>>> find_free_blocks() completes its job firstly, previous page fault
>>>> procedure starts to run again and completes, then one truncated page has
>>>> beed mapped to use space, but note that tcmu_vma_fault() has gotten one
>>>> refcount for this page, so any other subsystem won't use this page,
>>>> unless later the use space addr is unmapped.
>>>>
>>>> If another command runs in later and needs to extends dbi_thresh, it may
>>>> reuse the corresponding slot to previous page in data_bitmap, then thouth
>>>> we'll allocate new page for this slot in data_area, but no page fault will
>>>> happen again, because we have a valid map, real request's data will lose.
>>>
>>> I don't think, this is a safe fix. It is possible that not only
>>> find_free_blocks runs before page fault procedure completes, but also
>>> allocation for next cmd happens. In that case the new call to
>>> unmap_mapping_range would also happen before page fault completes ->
>>> data corruption.
>>>
>>> AFAIK, no one ever has seen this this bug in real life, as
>> Yeah, I know, just find this maybe an issue by reading codes :)
>>
>>> find_free_blocks only runs seldomly and userspace would have to access
>>> a data page the very first time while the cmd that owned this page
>>> already has been completed by userspace. Therefore I think we should
>>> apply a perfect fix only.
>>>
>>> I'm wondering whether there really is such a race. If so, couldn't the
>>> same race happen in other drivers or even when truncating mapped files?
>> Indeed, I have described how filesystem implementations avoid this issue
>> in patch's commit message:
>>
>>    Filesystem implementations will also run into this issue, but they
>>    usually lock page when vm_operations_struct->fault gets one page, and
>>    unlock page after finish_fault() completes. In truncate sides, they
>>    lock pages in truncate_inode_pages() to protect race with page fault.
>>    We can also have similar codes like filesystem to fix this issue.
>>
>>
>> Take ext4 as example, a file in ext4 is mapped to user space, if then a truncate
>> operation occurs, ext4 calls truncate_pagecache():
>> void truncate_pagecache(struct inode *inode, loff_t newsize)
>> {
>>          struct address_space *mapping = inode->i_mapping;
>>          loff_t holebegin = round_up(newsize, PAGE_SIZE);
>>
>>          /*
>>           * unmap_mapping_range is called twice, first simply for
>>           * efficiency so that truncate_inode_pages does fewer
>>           * single-page unmaps.  However after this first call, and
>>           * before truncate_inode_pages finishes, it is possible for
>>           * private pages to be COWed, which remain after
>>           * truncate_inode_pages finishes, hence the second
>>           * unmap_mapping_range call must be made for correctness.
>>           */
>>          unmap_mapping_range(mapping, holebegin, 0, 1);
>>          truncate_inode_pages(mapping, newsize);
>>          unmap_mapping_range(mapping, holebegin, 0, 1);
>> }
>>
>> In truncate_inode_pages(), it'll lock page and set page->mapping
>> to be NULL, and in ext4's filemap_fault(), it'll lock page and check whether
>> page->mapping has been changed, if it's true, it'll just fail the page
>> fault procedure.
>>
>> For tcmu, though the data area's pages don't have a valid mapping,
>> but we can apply similar method.
>> In tcmu_vma_fault(), we lock the page and set VM_FAULT_LOCKED
>> flag,
>
> Yeah, looking into page fault handling I'm wondering why tcmu didn't do
> that from the beginning!
>
>> in find_free_blocks(), we firstly try to lock pages which are going
>> to be released, if lock_page() returns,
>
> I assume, we immediately unlock the page again, right?
Yeah, and I'll add proper code comments in new version patch set.

>
>> we can ensure that there are
>> not inflight running page fault procedure, and following unmap_mapping_range()
>> will also ensure that all user maps will be cleared.
>> Seems that it'll resolve this possible issue, please have a check, thanks.
>
> AFAICS, this is the clean solution we were searching for.
Agree, I'll prepare new patch set soon.


Regards,
Xiaoguang Wang
>
> Thank you
> Bodo

