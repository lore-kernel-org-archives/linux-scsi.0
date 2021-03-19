Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7446EC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 17:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C7396197B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 17:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhCSR2j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:28:39 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2718 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhCSR20 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 13:28:26 -0400
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4F29gL15Hqz680Lg;
        Sat, 20 Mar 2021 01:22:06 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 19 Mar 2021 18:28:24 +0100
Received: from [10.47.10.104] (10.47.10.104) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 19 Mar
 2021 17:28:23 +0000
Subject: Re: [PATCH 3/6] iova: Allow rcache range upper limit to be
 configurable
To:     Robin Murphy <robin.murphy@arm.com>, <joro@8bytes.org>,
        <will@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hch@lst.de>,
        <m.szyprowski@samsung.com>
CC:     <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1616160348-29451-1-git-send-email-john.garry@huawei.com>
 <1616160348-29451-4-git-send-email-john.garry@huawei.com>
 <26fb1b79-2e46-09f6-1814-48fec4205f32@arm.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <3375b67f-438c-32d3-a5a6-7e08f37b04e3@huawei.com>
Date:   Fri, 19 Mar 2021 17:26:12 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <26fb1b79-2e46-09f6-1814-48fec4205f32@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.10.104]
X-ClientProxiedBy: lhreml717-chm.china.huawei.com (10.201.108.68) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/03/2021 16:25, Robin Murphy wrote:
> On 2021-03-19 13:25, John Garry wrote:
>> Some LLDs may request DMA mappings whose IOVA length exceeds that of the
>> current rcache upper limit.
>>
>> This means that allocations for those IOVAs will never be cached, and
>> always must be allocated and freed from the RB tree per DMA mapping 
>> cycle.
>> This has a significant effect on performance, more so since commit
>> 4e89dce72521 ("iommu/iova: Retry from last rb tree node if iova search
>> fails"), as discussed at [0].
>>
>> Allow the range of cached IOVAs to be increased, by providing an API 
>> to set
>> the upper limit, which is capped at IOVA_RANGE_CACHE_MAX_SIZE.
>>
>> For simplicity, the full range of IOVA rcaches is allocated and 
>> initialized
>> at IOVA domain init time.
>>
>> Setting the range upper limit will fail if the domain is already live
>> (before the tree contains IOVA nodes). This must be done to ensure any
>> IOVAs cached comply with rule of size being a power-of-2.
>>
>> [0] 
>> https://lore.kernel.org/linux-iommu/20210129092120.1482-1-thunder.leizhen@huawei.com/ 
>>
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>>   drivers/iommu/iova.c | 37 +++++++++++++++++++++++++++++++++++--
>>   include/linux/iova.h | 11 ++++++++++-
>>   2 files changed, 45 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
>> index cecc74fb8663..d4f2f7fbbd84 100644
>> --- a/drivers/iommu/iova.c
>> +++ b/drivers/iommu/iova.c
>> @@ -49,6 +49,7 @@ init_iova_domain(struct iova_domain *iovad, unsigned 
>> long granule,
>>       iovad->flush_cb = NULL;
>>       iovad->fq = NULL;
>>       iovad->anchor.pfn_lo = iovad->anchor.pfn_hi = IOVA_ANCHOR;
>> +    iovad->rcache_max_size = IOVA_RANGE_CACHE_DEFAULT_SIZE;
>>       rb_link_node(&iovad->anchor.node, NULL, &iovad->rbroot.rb_node);
>>       rb_insert_color(&iovad->anchor.node, &iovad->rbroot);
>>       init_iova_rcaches(iovad);
>> @@ -194,7 +195,7 @@ static int __alloc_and_insert_iova_range(struct 
>> iova_domain *iovad,
>>        * rounding up anything cacheable to make sure that can't 
>> happen. The
>>        * order of the unadjusted size will still match upon freeing.
>>        */
>> -    if (fast && size < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
>> +    if (fast && size < (1 << (iovad->rcache_max_size - 1)))
>>           size = roundup_pow_of_two(size);
>>       if (size_aligned)
>> @@ -901,7 +902,7 @@ static bool iova_rcache_insert(struct iova_domain 
>> *iovad, unsigned long pfn,
>>   {
>>       unsigned int log_size = order_base_2(size);
>> -    if (log_size >= IOVA_RANGE_CACHE_MAX_SIZE)
>> +    if (log_size >= iovad->rcache_max_size)
>>           return false;
>>       return __iova_rcache_insert(iovad, &iovad->rcaches[log_size], pfn);
>> @@ -946,6 +947,38 @@ static unsigned long __iova_rcache_get(struct 
>> iova_rcache *rcache,
>>       return iova_pfn;
>>   }
>> +void iova_rcache_set_upper_limit(struct iova_domain *iovad,
>> +                 unsigned long iova_len)
>> +{
>> +    unsigned int rcache_index = order_base_2(iova_len) + 1;
>> +    struct rb_node *rb_node = &iovad->anchor.node;
>> +    unsigned long flags;
>> +    int count = 0;
>> +
>> +    spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
>> +    if (rcache_index <= iovad->rcache_max_size)
>> +        goto out;
>> +
>> +    while (1) {
>> +        rb_node = rb_prev(rb_node);
>> +        if (!rb_node)
>> +            break;
>> +        count++;
>> +    }
>> +
>> +    /*
>> +     * If there are already IOVA nodes present in the tree, then don't
>> +     * allow range upper limit to be set.
>> +     */
>> +    if (count != iovad->reserved_node_count)
>> +        goto out;
>> +
>> +    iovad->rcache_max_size = min_t(unsigned long, rcache_index,
>> +                       IOVA_RANGE_CACHE_MAX_SIZE);
>> +out:
>> +    spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
>> +}
>> +
>>   /*
>>    * Try to satisfy IOVA allocation range from rcache.  Fail if requested
>>    * size is too big or the DMA limit we are given isn't satisfied by the
>> diff --git a/include/linux/iova.h b/include/linux/iova.h
>> index fd3217a605b2..952b81b54ef7 100644
>> --- a/include/linux/iova.h
>> +++ b/include/linux/iova.h
>> @@ -25,7 +25,8 @@ struct iova {
>>   struct iova_magazine;
>>   struct iova_cpu_rcache;
>> -#define IOVA_RANGE_CACHE_MAX_SIZE 6    /* log of max cached IOVA 
>> range size (in pages) */
>> +#define IOVA_RANGE_CACHE_DEFAULT_SIZE 6
>> +#define IOVA_RANGE_CACHE_MAX_SIZE 10 /* log of max cached IOVA range 
>> size (in pages) */
> 
> No.
> 
> And why? If we're going to allocate massive caches anyway, whatever is 
> the point of *not* using all of them?
> 

I wanted to keep the same effective threshold for devices today, unless 
set otherwise.

The reason is that I didn't know if a blanket increase would cause 
regressions, and I was taking the super-safe road. Specifically some 
systems may be very IOVA space limited, and just work today by not 
caching large IOVAs.

And in the precursor thread you wrote "We can't arbitrarily *increase* 
the scope of caching once a domain is active due to the size-rounding-up 
requirement, which would be prohibitive to larger allocations if applied 
universally" (sorry for quoting)

I took the last part to mean that we shouldn't apply this increase in 
threshold globally.

> It only makes sense for a configuration knob to affect the actual rcache 
> and depot allocations - that way, big high-throughput systems with 
> plenty of memory can spend it on better performance, while small systems 
> - that often need IOMMU scatter-gather precisely *because* memory is 
> tight and thus easily fragmented - don't have to pay the (not 
> insignificant) cost for caches they don't need.

So do you suggest to just make IOVA_RANGE_CACHE_MAX_SIZE a kconfig option?

Thanks,
John

> 
> Robin.
> 
>>   #define MAX_GLOBAL_MAGS 32    /* magazines per bin */
>>   struct iova_rcache {
>> @@ -74,6 +75,7 @@ struct iova_domain {
>>       unsigned long    start_pfn;    /* Lower limit for this domain */
>>       unsigned long    dma_32bit_pfn;
>>       unsigned long    max32_alloc_size; /* Size of last failed 
>> allocation */
>> +    unsigned long    rcache_max_size; /* Upper limit of cached IOVA 
>> RANGE */
>>       struct iova_fq __percpu *fq;    /* Flush Queue */
>>       atomic64_t    fq_flush_start_cnt;    /* Number of TLB flushes that
>> @@ -158,6 +160,8 @@ int init_iova_flush_queue(struct iova_domain *iovad,
>>   struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn);
>>   void put_iova_domain(struct iova_domain *iovad);
>>   void free_cpu_cached_iovas(unsigned int cpu, struct iova_domain 
>> *iovad);
>> +void iova_rcache_set_upper_limit(struct iova_domain *iovad,
>> +                 unsigned long iova_len);
>>   #else
>>   static inline int iova_cache_get(void)
>>   {
>> @@ -238,6 +242,11 @@ static inline void free_cpu_cached_iovas(unsigned 
>> int cpu,
>>                        struct iova_domain *iovad)
>>   {
>>   }
>> +
>> +static inline void iova_rcache_set_upper_limit(struct iova_domain 
>> *iovad,
>> +                           unsigned long iova_len)
>> +{
>> +}
>>   #endif
>>   #endif
>>
> .

