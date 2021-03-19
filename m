Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6E1C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 19:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B176197A
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 19:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhCSTUu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 15:20:50 -0400
Received: from foss.arm.com ([217.140.110.172]:33766 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230297AbhCSTUZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Mar 2021 15:20:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73E0831B;
        Fri, 19 Mar 2021 12:20:24 -0700 (PDT)
Received: from [10.57.50.37] (unknown [10.57.50.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B57573F718;
        Fri, 19 Mar 2021 12:20:22 -0700 (PDT)
Subject: Re: [PATCH 1/6] iommu: Move IOVA power-of-2 roundup into allocator
To:     John Garry <john.garry@huawei.com>, joro@8bytes.org,
        will@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, m.szyprowski@samsung.com
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
References: <1616160348-29451-1-git-send-email-john.garry@huawei.com>
 <1616160348-29451-2-git-send-email-john.garry@huawei.com>
 <ee935a6d-a94c-313e-f0ed-e14cc6dac055@arm.com>
 <73d459de-b5cc-e2f5-bcd7-2ee23c8d5075@huawei.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <afc2fc05-a799-cb14-debd-d36afed8f456@arm.com>
Date:   Fri, 19 Mar 2021 19:20:16 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <73d459de-b5cc-e2f5-bcd7-2ee23c8d5075@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-19 16:58, John Garry wrote:
> On 19/03/2021 16:13, Robin Murphy wrote:
>> On 2021-03-19 13:25, John Garry wrote:
>>> Move the IOVA size power-of-2 rcache roundup into the IOVA allocator.
>>>
>>> This is to eventually make it possible to be able to configure the upper
>>> limit of the IOVA rcache range.
>>>
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>> ---
>>>   drivers/iommu/dma-iommu.c |  8 ------
>>>   drivers/iommu/iova.c      | 51 ++++++++++++++++++++++++++-------------
>>>   2 files changed, 34 insertions(+), 25 deletions(-)
>>>
>>> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
>>> index af765c813cc8..15b7270a5c2a 100644
>>> --- a/drivers/iommu/dma-iommu.c
>>> +++ b/drivers/iommu/dma-iommu.c
>>> @@ -429,14 +429,6 @@ static dma_addr_t iommu_dma_alloc_iova(struct 
>>> iommu_domain *domain,
>>>       shift = iova_shift(iovad);
>>>       iova_len = size >> shift;
>>> -    /*
>>> -     * Freeing non-power-of-two-sized allocations back into the IOVA 
>>> caches
>>> -     * will come back to bite us badly, so we have to waste a bit of 
>>> space
>>> -     * rounding up anything cacheable to make sure that can't 
>>> happen. The
>>> -     * order of the unadjusted size will still match upon freeing.
>>> -     */
>>> -    if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
>>> -        iova_len = roundup_pow_of_two(iova_len);
>>>       dma_limit = min_not_zero(dma_limit, dev->bus_dma_limit);
>>> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
>>> index e6e2fa85271c..e62e9e30b30c 100644
>>> --- a/drivers/iommu/iova.c
>>> +++ b/drivers/iommu/iova.c
>>> @@ -179,7 +179,7 @@ iova_insert_rbtree(struct rb_root *root, struct 
>>> iova *iova,
>>>   static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
>>>           unsigned long size, unsigned long limit_pfn,
>>> -            struct iova *new, bool size_aligned)
>>> +            struct iova *new, bool size_aligned, bool fast)
>>>   {
>>>       struct rb_node *curr, *prev;
>>>       struct iova *curr_iova;
>>> @@ -188,6 +188,15 @@ static int __alloc_and_insert_iova_range(struct 
>>> iova_domain *iovad,
>>>       unsigned long align_mask = ~0UL;
>>>       unsigned long high_pfn = limit_pfn, low_pfn = iovad->start_pfn;
>>> +    /*
>>> +     * Freeing non-power-of-two-sized allocations back into the IOVA 
>>> caches
>>> +     * will come back to bite us badly, so we have to waste a bit of 
>>> space
>>> +     * rounding up anything cacheable to make sure that can't 
>>> happen. The
>>> +     * order of the unadjusted size will still match upon freeing.
>>> +     */
>>> +    if (fast && size < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
>>> +        size = roundup_pow_of_two(size);
>>
>> If this transformation is only relevant to alloc_iova_fast(), and we 
>> have to add a special parameter here to tell whether we were called 
>> from alloc_iova_fast(), doesn't it seem more sensible to just do it in 
>> alloc_iova_fast() rather than here?
> 
> We have the restriction that anything we put in the rcache needs be a 
> power-of-2.

I was really only talking about the apparently silly structure of:

void foo(bool in_bar) {
	if (in_bar)
		//do thing
	...
}
void bar() {
	foo(true);
}

vs.:

void foo() {
	...
}
void bar() {
	//do thing
	foo();
}

> So then we have the issue of how to dynamically increase this rcache 
> threshold. The problem is that we may have many devices associated with 
> the same domain. So, in theory, we can't assume that when we increase 
> the threshold that some other device will try to fast free an IOVA which 
> was allocated prior to the increase and was not rounded up.
> 
> I'm very open to better (or less bad) suggestions on how to do this ...

...but yes, regardless of exactly where it happens, rounding up or not 
is the problem for rcaches in general. I've said several times that my 
preferred approach is to not change it that dynamically at all, but 
instead treat it more like we treat the default domain type.

> I could say that we only allow this for a group with a single device, so 
> these sort of things don't have to be worried about, but even then the 
> iommu_group internals are not readily accessible here.
> 
>>
>> But then the API itself has no strict requirement that a pfn passed to 
>> free_iova_fast() wasn't originally allocated with alloc_iova(), so 
>> arguably hiding the adjustment away makes it less clear that the 
>> responsibility is really on any caller of free_iova_fast() to make 
>> sure they don't get things wrong.
>>
> 
> alloc_iova() doesn't roundup to pow-of-2, so wouldn't it be broken to do 
> that?

Well, right now neither call rounds up, which is why iommu-dma takes 
care to avoid any issues by explicitly rounding up for itself 
beforehand. I'm just concerned that giving the impression that the API 
takes care of everything for itself will make it easier to write broken 
code in future, if that impression is in fact not entirely true.

I don't even think it's very likely that someone would manage to hit 
that rather wacky alloc/free pattern either way, I just know that 
getting wrong-sized things into the rcaches is an absolute sod to debug, 
so...

Robin.
