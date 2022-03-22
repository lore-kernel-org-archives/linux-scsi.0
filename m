Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4CCC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 13:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbiCVNSl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 09:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbiCVNSl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 09:18:41 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CF263BF4;
        Tue, 22 Mar 2022 06:17:12 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V7wMyaL_1647955029;
Received: from 30.225.28.195(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V7wMyaL_1647955029)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Mar 2022 21:17:10 +0800
Message-ID: <36b5a8e5-c8e9-6a1f-834c-6bf9bf920f4c@linux.alibaba.com>
Date:   Tue, 22 Mar 2022 21:17:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [RFC 0/3] Add zero copy feature for tcmu
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-mm@kvack.org,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, xuyu@linux.alibaba.com
References: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
 <abbe51c4-873f-e96e-d421-85906689a55a@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <abbe51c4-873f-e96e-d421-85906689a55a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

> On 18.03.22 10:55, Xiaoguang Wang wrote:
>> The core idea to implement tcmu zero copy feature is really straight,
>> which just maps block device io request's sgl pages to tcmu user space
>> backstore, then we can avoid extra copy overhead between sgl pages and
>> tcmu internal data area(which really impacts io throughput), please see
>> https://www.spinics.net/lists/target-devel/msg21121.html for detailed
>> info.
>>
>
> Can you please tell us, how big the performance improvement is and
> which configuration you are using for measurenments?
Sorry, I should have attached test results here. Initially I tried to use
tcmu user:fbo backstore to evaluate performance improvements, but
it only shows about 10%~15% io throughput improvement. Fio config
is numjobs=1, iodepth=8, bs=256k, which isn't very impressive. The
reason is that user:fbo backstore does buffered reads, it consumes most
of cpu.

Then I test this zero copy feature for our real workload, whose backstore
is a network program visiting distributed file system and it's 
multi-threaded.
For 4 job, 8 depth, 256 kb io size, the write throughput improves from
3.6GB/s to 10GB/s.

Regards,
Xiaoguang Wang

>
>> Initially I use remap_pfn_range or vm_insert_pages to map sgl pages to
>> user space, but both of them have limits:
>> 1)  Use vm_insert_pages
>> which is like tcp getsockopt(TCP_ZEROCOPY_RECEIVE), but there're two
>> restrictions:
>>    1. anonymous pages can not be mmaped to user spacea.
>>      ==> vm_insert_pages
>>      ====> insert_pages
>>      ======> insert_page_in_batch_locked
>>      ========> validate_page_before_insert
>>      In validate_page_before_insert(), it shows that anonymous page 
>> can not
>>      be mapped to use space, we know that if issuing direct io to block
>>      device, io request's sgl pages mostly comes from anonymous page.
>>          if (PageAnon(page) || PageSlab(page) || page_has_type(page))
>>              return -EINVAL;
>>      I'm not sure why there is such restriction? for safety reasons ?
>>
>>    2. warn_on triggered in __folio_mark_dirty
>>      When calling zap_page_range in tcmu user space backstore when io
>>      completes, there is a warn_on triggered in __folio_mark_dirty:
>>         if (folio->mapping) {   /* Race with truncate? */
>>             WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
>>
>>      I'm not familiar with folio yet, but I think the reason is that 
>> when
>>      issuing a buffered read to tcmu block device, it's page cache 
>> mapped
>>      to user space, backstore write this page and pte will be 
>> dirtied. but
>>      initially it's newly allocated, hence page_update flag not set.
>>      In zap_pte_range(), there is such codes:
>>         if (!PageAnon(page)) {
>>             if (pte_dirty(ptent)) {
>>                 force_flush = 1;
>>                 set_page_dirty(page);
>>             }
>>     So this warn_on is reasonable.
>>     Indeed what I want is just to map io request sgl pages to tcmu user
>>     space backstore, then backstore can read or write data to mapped 
>> area,
>>     I don't want to care about page or its mapping status, so I 
>> choose to
>>     use remap_pfn_range.
>>
>> 2) Use remap_pfn_range()
>>    remap_pfn_range works well, but it has somewhat obvious overhead. 
>> For a
>>    512kb io request, it has 128 pages, and usually this 128 page's 
>> pfn are
>>    not consecutive, so in worst cases, for a 512kb io request, I'd 
>> need to
>>    issue 128 calls to remap_pfn_range, it's horrible. And in 
>> remap_pfn_range,
>>    if x86 page attribute table feature is enabled, lookup_memtype 
>> called by
>>    track_pfn_remap() also introduces obvious overhead.
>>
>> Finally in order to solve these problems, Xu Yu helps to implment a new
>> helper, which accepts an array of pages as parameter, anonymous pages 
>> can
>> be mapped to user space, pages would be treated as special 
>> pte(pte_special
>> returns true), so vm_normal_page returns NULL, above folio warn_on won't
>> trigger.
>>
>> Thanks.
>>
>> Xiaoguang Wang (2):
>>    mm: export zap_page_range()
>>    scsi: target: tcmu: Support zero copy
>>
>> Xu Yu (1):
>>    mm/memory.c: introduce vm_insert_page(s)_mkspecial
>>
>>   drivers/target/target_core_user.c | 257 
>> +++++++++++++++++++++++++++++++++-----
>>   include/linux/mm.h                |   2 +
>>   mm/memory.c                       | 183 +++++++++++++++++++++++++++
>>   3 files changed, 414 insertions(+), 28 deletions(-)
>>

