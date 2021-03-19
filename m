Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9826BC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 16:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C7C961981
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 16:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhCSQNq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:13:46 -0400
Received: from foss.arm.com ([217.140.110.172]:55706 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhCSQN0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Mar 2021 12:13:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9435231B;
        Fri, 19 Mar 2021 09:13:25 -0700 (PDT)
Received: from [10.57.50.37] (unknown [10.57.50.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBEB73F718;
        Fri, 19 Mar 2021 09:13:22 -0700 (PDT)
Subject: Re: [PATCH 1/6] iommu: Move IOVA power-of-2 roundup into allocator
To:     John Garry <john.garry@huawei.com>, joro@8bytes.org,
        will@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, m.szyprowski@samsung.com
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
References: <1616160348-29451-1-git-send-email-john.garry@huawei.com>
 <1616160348-29451-2-git-send-email-john.garry@huawei.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <ee935a6d-a94c-313e-f0ed-e14cc6dac055@arm.com>
Date:   Fri, 19 Mar 2021 16:13:17 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1616160348-29451-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-19 13:25, John Garry wrote:
> Move the IOVA size power-of-2 rcache roundup into the IOVA allocator.
> 
> This is to eventually make it possible to be able to configure the upper
> limit of the IOVA rcache range.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/iommu/dma-iommu.c |  8 ------
>   drivers/iommu/iova.c      | 51 ++++++++++++++++++++++++++-------------
>   2 files changed, 34 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index af765c813cc8..15b7270a5c2a 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -429,14 +429,6 @@ static dma_addr_t iommu_dma_alloc_iova(struct iommu_domain *domain,
>   
>   	shift = iova_shift(iovad);
>   	iova_len = size >> shift;
> -	/*
> -	 * Freeing non-power-of-two-sized allocations back into the IOVA caches
> -	 * will come back to bite us badly, so we have to waste a bit of space
> -	 * rounding up anything cacheable to make sure that can't happen. The
> -	 * order of the unadjusted size will still match upon freeing.
> -	 */
> -	if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
> -		iova_len = roundup_pow_of_two(iova_len);
>   
>   	dma_limit = min_not_zero(dma_limit, dev->bus_dma_limit);
>   
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index e6e2fa85271c..e62e9e30b30c 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -179,7 +179,7 @@ iova_insert_rbtree(struct rb_root *root, struct iova *iova,
>   
>   static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
>   		unsigned long size, unsigned long limit_pfn,
> -			struct iova *new, bool size_aligned)
> +			struct iova *new, bool size_aligned, bool fast)
>   {
>   	struct rb_node *curr, *prev;
>   	struct iova *curr_iova;
> @@ -188,6 +188,15 @@ static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
>   	unsigned long align_mask = ~0UL;
>   	unsigned long high_pfn = limit_pfn, low_pfn = iovad->start_pfn;
>   
> +	/*
> +	 * Freeing non-power-of-two-sized allocations back into the IOVA caches
> +	 * will come back to bite us badly, so we have to waste a bit of space
> +	 * rounding up anything cacheable to make sure that can't happen. The
> +	 * order of the unadjusted size will still match upon freeing.
> +	 */
> +	if (fast && size < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
> +		size = roundup_pow_of_two(size);

If this transformation is only relevant to alloc_iova_fast(), and we 
have to add a special parameter here to tell whether we were called from 
alloc_iova_fast(), doesn't it seem more sensible to just do it in 
alloc_iova_fast() rather than here?

But then the API itself has no strict requirement that a pfn passed to 
free_iova_fast() wasn't originally allocated with alloc_iova(), so 
arguably hiding the adjustment away makes it less clear that the 
responsibility is really on any caller of free_iova_fast() to make sure 
they don't get things wrong.

Robin.

> +
>   	if (size_aligned)
>   		align_mask <<= fls_long(size - 1);
>   
> @@ -288,21 +297,10 @@ void iova_cache_put(void)
>   }
>   EXPORT_SYMBOL_GPL(iova_cache_put);
>   
> -/**
> - * alloc_iova - allocates an iova
> - * @iovad: - iova domain in question
> - * @size: - size of page frames to allocate
> - * @limit_pfn: - max limit address
> - * @size_aligned: - set if size_aligned address range is required
> - * This function allocates an iova in the range iovad->start_pfn to limit_pfn,
> - * searching top-down from limit_pfn to iovad->start_pfn. If the size_aligned
> - * flag is set then the allocated address iova->pfn_lo will be naturally
> - * aligned on roundup_power_of_two(size).
> - */
> -struct iova *
> -alloc_iova(struct iova_domain *iovad, unsigned long size,
> +static struct iova *
> +__alloc_iova(struct iova_domain *iovad, unsigned long size,
>   	unsigned long limit_pfn,
> -	bool size_aligned)
> +	bool size_aligned, bool fast)
>   {
>   	struct iova *new_iova;
>   	int ret;
> @@ -312,7 +310,7 @@ alloc_iova(struct iova_domain *iovad, unsigned long size,
>   		return NULL;
>   
>   	ret = __alloc_and_insert_iova_range(iovad, size, limit_pfn + 1,
> -			new_iova, size_aligned);
> +			new_iova, size_aligned, fast);
>   
>   	if (ret) {
>   		free_iova_mem(new_iova);
> @@ -321,6 +319,25 @@ alloc_iova(struct iova_domain *iovad, unsigned long size,
>   
>   	return new_iova;
>   }
> +
> +/**
> + * alloc_iova - allocates an iova
> + * @iovad: - iova domain in question
> + * @size: - size of page frames to allocate
> + * @limit_pfn: - max limit address
> + * @size_aligned: - set if size_aligned address range is required
> + * This function allocates an iova in the range iovad->start_pfn to limit_pfn,
> + * searching top-down from limit_pfn to iovad->start_pfn. If the size_aligned
> + * flag is set then the allocated address iova->pfn_lo will be naturally
> + * aligned on roundup_power_of_two(size).
> + */
> +struct iova *
> +alloc_iova(struct iova_domain *iovad, unsigned long size,
> +	unsigned long limit_pfn,
> +	bool size_aligned)
> +{
> +	return __alloc_iova(iovad, size, limit_pfn, size_aligned, false);
> +}
>   EXPORT_SYMBOL_GPL(alloc_iova);
>   
>   static struct iova *
> @@ -433,7 +450,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
>   		return iova_pfn;
>   
>   retry:
> -	new_iova = alloc_iova(iovad, size, limit_pfn, true);
> +	new_iova = __alloc_iova(iovad, size, limit_pfn, true, true);
>   	if (!new_iova) {
>   		unsigned int cpu;
>   
> 
