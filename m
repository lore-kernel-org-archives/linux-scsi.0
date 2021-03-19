Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB0BC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 17:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 823236197D
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 17:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhCSRBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:01:03 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2717 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhCSRAc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 13:00:32 -0400
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4F290Z17N6z680K7;
        Sat, 20 Mar 2021 00:51:58 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 19 Mar 2021 18:00:29 +0100
Received: from [10.47.10.104] (10.47.10.104) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 19 Mar
 2021 17:00:28 +0000
Subject: Re: [PATCH 1/6] iommu: Move IOVA power-of-2 roundup into allocator
To:     Robin Murphy <robin.murphy@arm.com>, <joro@8bytes.org>,
        <will@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hch@lst.de>,
        <m.szyprowski@samsung.com>
CC:     <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1616160348-29451-1-git-send-email-john.garry@huawei.com>
 <1616160348-29451-2-git-send-email-john.garry@huawei.com>
 <ee935a6d-a94c-313e-f0ed-e14cc6dac055@arm.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <73d459de-b5cc-e2f5-bcd7-2ee23c8d5075@huawei.com>
Date:   Fri, 19 Mar 2021 16:58:17 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <ee935a6d-a94c-313e-f0ed-e14cc6dac055@arm.com>
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

On 19/03/2021 16:13, Robin Murphy wrote:
> On 2021-03-19 13:25, John Garry wrote:
>> Move the IOVA size power-of-2 rcache roundup into the IOVA allocator.
>>
>> This is to eventually make it possible to be able to configure the upper
>> limit of the IOVA rcache range.
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>>   drivers/iommu/dma-iommu.c |  8 ------
>>   drivers/iommu/iova.c      | 51 ++++++++++++++++++++++++++-------------
>>   2 files changed, 34 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
>> index af765c813cc8..15b7270a5c2a 100644
>> --- a/drivers/iommu/dma-iommu.c
>> +++ b/drivers/iommu/dma-iommu.c
>> @@ -429,14 +429,6 @@ static dma_addr_t iommu_dma_alloc_iova(struct 
>> iommu_domain *domain,
>>       shift = iova_shift(iovad);
>>       iova_len = size >> shift;
>> -    /*
>> -     * Freeing non-power-of-two-sized allocations back into the IOVA 
>> caches
>> -     * will come back to bite us badly, so we have to waste a bit of 
>> space
>> -     * rounding up anything cacheable to make sure that can't happen. 
>> The
>> -     * order of the unadjusted size will still match upon freeing.
>> -     */
>> -    if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
>> -        iova_len = roundup_pow_of_two(iova_len);
>>       dma_limit = min_not_zero(dma_limit, dev->bus_dma_limit);
>> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
>> index e6e2fa85271c..e62e9e30b30c 100644
>> --- a/drivers/iommu/iova.c
>> +++ b/drivers/iommu/iova.c
>> @@ -179,7 +179,7 @@ iova_insert_rbtree(struct rb_root *root, struct 
>> iova *iova,
>>   static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
>>           unsigned long size, unsigned long limit_pfn,
>> -            struct iova *new, bool size_aligned)
>> +            struct iova *new, bool size_aligned, bool fast)
>>   {
>>       struct rb_node *curr, *prev;
>>       struct iova *curr_iova;
>> @@ -188,6 +188,15 @@ static int __alloc_and_insert_iova_range(struct 
>> iova_domain *iovad,
>>       unsigned long align_mask = ~0UL;
>>       unsigned long high_pfn = limit_pfn, low_pfn = iovad->start_pfn;
>> +    /*
>> +     * Freeing non-power-of-two-sized allocations back into the IOVA 
>> caches
>> +     * will come back to bite us badly, so we have to waste a bit of 
>> space
>> +     * rounding up anything cacheable to make sure that can't happen. 
>> The
>> +     * order of the unadjusted size will still match upon freeing.
>> +     */
>> +    if (fast && size < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
>> +        size = roundup_pow_of_two(size);
> 
> If this transformation is only relevant to alloc_iova_fast(), and we 
> have to add a special parameter here to tell whether we were called from 
> alloc_iova_fast(), doesn't it seem more sensible to just do it in 
> alloc_iova_fast() rather than here?

We have the restriction that anything we put in the rcache needs be a 
power-of-2.

So then we have the issue of how to dynamically increase this rcache 
threshold. The problem is that we may have many devices associated with 
the same domain. So, in theory, we can't assume that when we increase 
the threshold that some other device will try to fast free an IOVA which 
was allocated prior to the increase and was not rounded up.

I'm very open to better (or less bad) suggestions on how to do this ...

I could say that we only allow this for a group with a single device, so 
these sort of things don't have to be worried about, but even then the 
iommu_group internals are not readily accessible here.

> 
> But then the API itself has no strict requirement that a pfn passed to 
> free_iova_fast() wasn't originally allocated with alloc_iova(), so 
> arguably hiding the adjustment away makes it less clear that the 
> responsibility is really on any caller of free_iova_fast() to make sure 
> they don't get things wrong.
> 

alloc_iova() doesn't roundup to pow-of-2, so wouldn't it be broken to do 
that?

Cheers,
John
