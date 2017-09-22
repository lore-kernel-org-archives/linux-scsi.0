From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH V6 1/3] dma-mapping: Introduce device_is_coherent() as
 ahelper
Date: Fri, 22 Sep 2017 14:44:51 +0100
Message-ID: <9213ab49-b6e6-d513-6d35-1fe2294aad68@arm.com>
References: <1505811161-25246-1-git-send-email-chenhc@lemote.com>
 <5e792b21-1d63-9200-b36a-c423385e2a2e@arm.com>
 <tencent_6FDFA013608B41F6241AD9D7@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <tencent_6FDFA013608B41F6241AD9D7@qq.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: =?UTF-8?B?6ZmI5Y2O5omN?= <chenhc@lemote.com>, Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel <linux-kernel@vger.kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 22/09/17 03:13, 陈华才 wrote:
> Hi, Robin,
> 
> Before 2.6.36 dma_get_cache_alignment is arch-dependent, and it is unified in commit 4565f0170dfc849b3629c27d7 ("dma-mapping: unify dma_get_cache_alignment implementations"). Should we revert to the old implementation?

Not quite - I mean instead of adding an ops->device_is_coherent callback
(which cannot really have a safe fallback value either way) and trying
to enforce that dma_get_cache_alignment() should be the only valid
caller, just add an ops->get_cache_alignment callback directly.

Robin.

>  
> Huacai
>  
> ------------------ Original ------------------
> From:  "Robin Murphy"<robin.murphy@arm.com>;
> Date:  Thu, Sep 21, 2017 06:47 PM
> To:  "Huacai Chen"<chenhc@lemote.com>; "Christoph Hellwig"<hch@lst.de>; 
> Cc:  "Marek Szyprowski"<m.szyprowski@samsung.com>; "Andrew Morton"<akpm@linux-foundation.org>; "Fuxin Zhang"<zhangfx@lemote.com>; "linux-kernel"<linux-kernel@vger.kernel.org>; "James E . J . Bottomley"<jejb@linux.vnet.ibm.com>; "Martin K . Petersen"<martin.petersen@oracle.com>; "linux-scsi"<linux-scsi@vger.kernel.org>; "stable"<stable@vger.kernel.org>; 
> Subject:  Re: [PATCH V6 1/3] dma-mapping: Introduce device_is_coherent() as ahelper
> 
>  
> On 19/09/17 09:52, Huacai Chen wrote:
>> We will use device_is_coherent() as a helper function, which will be
>> used in the next patch.
>>
>> There is a MIPS-specific plat_device_is_coherent(), but we need a more
>> generic solution, so add and use a new function pointer in dma_map_ops.
> 
> I think we're heading in the right direction with the series, but I
> still don't like this patch. I can pretty much guarantee that driver
> authors *will* abuse a generic device_is_coherent() API to mean "I can
> skip other DMA API calls and just use virt_to_phys()".
> 
> I think it would be far better to allow architectures to provide their
> own override of dma_get_cache_alignment(), and let the coherency detail
> remain internal to the relevant arch implementations.
> 
> [...]
>> @@ -697,6 +698,15 @@ static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
>>  }
>>  
>>  #ifdef CONFIG_HAS_DMA
>> +static inline int device_is_coherent(struct device *dev)
>> +{
>> +	const struct dma_map_ops *ops = get_dma_ops(dev);
>> +	if (ops && ops->device_is_coherent)
>> +		return ops->device_is_coherent(dev);
>> +	else
>> +		return 1;    /* compatible behavior */
> 
> That is also quite scary - if someone now adds a new
> dma_get_cache_alignemnt() call and dutifully passes a non-NULL device,
> they will now get back an alignment of 1 on all non-coherent platforms
> except MIPS: hello data corruption.
> 
> Robin.
> 
>> +}
>> +
>>  static inline int dma_get_cache_alignment(void)
>>  {
>>  #ifdef ARCH_DMA_MINALIGN
>>
> 
