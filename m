Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7623C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 17:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 699DA61959
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 17:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhCSRAb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:00:31 -0400
Received: from foss.arm.com ([217.140.110.172]:57112 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230108AbhCSRAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Mar 2021 13:00:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92EC0ED1;
        Fri, 19 Mar 2021 10:00:20 -0700 (PDT)
Received: from [10.57.50.37] (unknown [10.57.50.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD3C63F70D;
        Fri, 19 Mar 2021 10:00:18 -0700 (PDT)
Subject: Re: [PATCH 5/6] dma-mapping/iommu: Add dma_set_max_opt_size()
To:     John Garry <john.garry@huawei.com>, joro@8bytes.org,
        will@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, m.szyprowski@samsung.com
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
References: <1616160348-29451-1-git-send-email-john.garry@huawei.com>
 <1616160348-29451-6-git-send-email-john.garry@huawei.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <9ecb6980-7f40-0333-572f-f9d4b8238353@arm.com>
Date:   Fri, 19 Mar 2021 17:00:12 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1616160348-29451-6-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-19 13:25, John Garry wrote:
> Add a function to allow the max size which we want to optimise DMA mappings
> for.

It seems neat in theory - particularly for packet-based interfaces that 
might have a known fixed size of data unit that they're working on at 
any given time - but aren't there going to be many cases where the 
driver has no idea because it depends on whatever size(s) of request 
userspace happens to throw at it? Even if it does know the absolute 
maximum size of thing it could ever transfer, that could be 
impractically large in areas like video/AI/etc., so it could still be 
hard to make a reasonable decision.

Being largely workload-dependent is why I still think this should be a 
command-line or sysfs tuneable - we could set the default based on how 
much total memory is available, but ultimately it's the end user who 
knows what the workload is going to be and what they care about 
optimising for.

Another thought (which I'm almost reluctant to share) is that I would 
*love* to try implementing a self-tuning strategy that can detect high 
contention on particular allocation sizes and adjust the caches on the 
fly, but I can easily imagine that having enough inherent overhead to 
end up being an impractical (but fun) waste of time.

Robin.

> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/iommu/dma-iommu.c   |  2 +-
>   include/linux/dma-map-ops.h |  1 +
>   include/linux/dma-mapping.h |  5 +++++
>   kernel/dma/mapping.c        | 11 +++++++++++
>   4 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index a5dfbd6c0496..d35881fcfb9c 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -447,7 +447,6 @@ static dma_addr_t iommu_dma_alloc_iova(struct iommu_domain *domain,
>   	return (dma_addr_t)iova << shift;
>   }
>   
> -__maybe_unused
>   static void iommu_dma_set_opt_size(struct device *dev, size_t size)
>   {
>   	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> @@ -1278,6 +1277,7 @@ static const struct dma_map_ops iommu_dma_ops = {
>   	.map_resource		= iommu_dma_map_resource,
>   	.unmap_resource		= iommu_dma_unmap_resource,
>   	.get_merge_boundary	= iommu_dma_get_merge_boundary,
> +	.set_max_opt_size	= iommu_dma_set_opt_size,
>   };
>   
>   /*
> diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
> index 51872e736e7b..fed7a183b3b9 100644
> --- a/include/linux/dma-map-ops.h
> +++ b/include/linux/dma-map-ops.h
> @@ -64,6 +64,7 @@ struct dma_map_ops {
>   	u64 (*get_required_mask)(struct device *dev);
>   	size_t (*max_mapping_size)(struct device *dev);
>   	unsigned long (*get_merge_boundary)(struct device *dev);
> +	void (*set_max_opt_size)(struct device *dev, size_t size);
>   };
>   
>   #ifdef CONFIG_DMA_OPS
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 2a984cb4d1e0..91fe770145d4 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -144,6 +144,7 @@ u64 dma_get_required_mask(struct device *dev);
>   size_t dma_max_mapping_size(struct device *dev);
>   bool dma_need_sync(struct device *dev, dma_addr_t dma_addr);
>   unsigned long dma_get_merge_boundary(struct device *dev);
> +void dma_set_max_opt_size(struct device *dev, size_t size);
>   #else /* CONFIG_HAS_DMA */
>   static inline dma_addr_t dma_map_page_attrs(struct device *dev,
>   		struct page *page, size_t offset, size_t size,
> @@ -257,6 +258,10 @@ static inline unsigned long dma_get_merge_boundary(struct device *dev)
>   {
>   	return 0;
>   }
> +static inline void dma_set_max_opt_size(struct device *dev, size_t size)
> +{
> +}
> +
>   #endif /* CONFIG_HAS_DMA */
>   
>   struct page *dma_alloc_pages(struct device *dev, size_t size,
> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> index b6a633679933..59e6acb1c471 100644
> --- a/kernel/dma/mapping.c
> +++ b/kernel/dma/mapping.c
> @@ -608,3 +608,14 @@ unsigned long dma_get_merge_boundary(struct device *dev)
>   	return ops->get_merge_boundary(dev);
>   }
>   EXPORT_SYMBOL_GPL(dma_get_merge_boundary);
> +
> +void dma_set_max_opt_size(struct device *dev, size_t size)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +
> +	if (!ops || !ops->set_max_opt_size)
> +		return;
> +
> +	ops->set_max_opt_size(dev, size);
> +}
> +EXPORT_SYMBOL_GPL(dma_set_max_opt_size);
> 
