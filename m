Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8193B71DE
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 11:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731387; cv=none; b=XnS5d7/GrMjJ9zOFtR5dy13jwLwAHV46UT6+xPJEDX7/t1SqwIRSqUcDOvFPAxwiE+5gdNbo3M+zdx3HSxcHXc2p12TXZ+vxLojl9xgFWFg/xNuYhLxjFQ0bouKaTo5blt+dfxOg03HxAnZ6UwhUQZY25JMMVCfBfkYxieXWfsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731387; c=relaxed/simple;
	bh=QgqZKkxSbB1wM8e1IkdcQNU62wH1FE5dh6CdTyleERs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AqE+8HPPLqVimRVzOaCi35D8yXzJNn0g9WW/b8iIJwKjm8EeO680Pj/DPl5vYCdrOvCM8cbyu7YCcr/mogt1G4l+E4VMotC8STCGuzBEGvRFvpaCmlIBIQyYI8CdOTyQXX0PF9LZG7kuSN4Qn3YTj/4SO4PcF+vkNxE6YJ3IMjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=etUC27lV; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="etUC27lV"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECFD1176C;
	Mon, 29 Jun 2026 04:09:40 -0700 (PDT)
Received: from [10.2.212.23] (e121345-lin.cambridge.arm.com [10.2.212.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 13CF33F905;
	Mon, 29 Jun 2026 04:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782731385; bh=QgqZKkxSbB1wM8e1IkdcQNU62wH1FE5dh6CdTyleERs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=etUC27lVxe1LcWUtyzLzSaSYek/7XypDJ6QAtaOA17N3O1iP7MNCBcY0k9Z75DiCQ
	 aapf//5FtO5mL2ZSaB+K6jodFkzvCYjO1WpBvVkLx3UYubGinfus94XJCRXDZX9czU
	 9Ku+OI1viWKbsbijz3REGZnYSzjx/p3xlNx5JVpg=
Message-ID: <7c9720fd-c615-481c-ba4d-f5e0efbdd7f0@arm.com>
Date: Mon, 29 Jun 2026 12:09:42 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dma-mapping: make dma_max_mapping_size() return 0 for
 no DMA capability
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 m.szyprowski@samsung.com, hch@lst.de
Cc: linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
 ionut.nechita@windriver.com
References: <20260629085310.2298552-1-john.g.garry@oracle.com>
 <20260629085310.2298552-2-john.g.garry@oracle.com>
 <53d07679-b1bb-469c-acc2-981e75c071c9@arm.com>
 <d82926fe-4557-401d-ae58-4302fef5657c@oracle.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <d82926fe-4557-401d-ae58-4302fef5657c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29/06/2026 11:46 am, John Garry wrote:
> On 29/06/2026 11:11, Robin Murphy wrote:
>> On 29/06/2026 9:53 am, John Garry wrote:
>>> For when a device is not DMA capable, the max mapping size would be 
>>> 0, so
>>> make dma_max_mapping_size() reflect that.
>>
>> Seems logical.
>>
>> Reviewed-by: Robin Murphy <robin.murphy@arm.com>
> 
> Thanks, but sashiko has been reviewing this and has a few things to say.
> 
> I don't know how it chooses recipients.
> 
> On 29/06/2026 10:10, sashiko-bot@kernel.org wrote:
>  >>
>  >> +    if (!dev->dma_mask)
>  >> +        return 0;
>  > [Severity: High]
>  > Could this new return value of 0 cause a division by zero in callers 
> that
>  > expect a strictly positive maximum mapping size?
>  >
>  > For instance, in drivers/accel/amdxdna/ 
> amdxdna_cbuf.c:amdxdna_cbuf_map(),
>  > the returned size is used directly as a divisor:
>  >
>  >          max_seg = min_t(size_t, UINT_MAX, dma_max_mapping_size(dev));
>  >          n_entries = (cbuf->node.size + max_seg - 1) / max_seg;
> 
> Later in amdxdna_cbuf_map() we call dma_map_resource() (-> 
> dma_map_phys()) and this would fail and WARN for !dev->dma_mask. Indeed 
> amdxdna_cbuf_map() is used as a callback for .map_dma_buf, so highly 
> unrealistic to have !dev->dma_mask ever.

Moreover, the driver would have failed to probe in the first place if 
its dma_set_mask_and_coherent() call had failed.

>  >
>  > If a device lacking a dma_mask maps the attachment, max_seg becomes 0,
>  > which would result in an immediate kernel panic.
>  >
>  > Additionally, could this cause invalid zero-sized block layer queue 
> limits
>  > in MMC drivers? In drivers/mmc/host/bcm2835.c:bcm2835_add_host(), the
>  > return value clamps max_req_size:
>  >
>  >          mmc->max_req_size = min_t(size_t, 524288, 
> dma_max_mapping_size(dev));
> 
> bcm2835.c is a platform device driver, and platform devices have their 
> dev->dma_mask set in setup_pdev_dma_masks()
> 
> Indeed, that driver does have a non-DMA mode of operation, but that 
> looks to be selected independent of whether dev->dma_mask is set.

That one seems pretty bogus already, given that DMA mode is apparently 
dependent on an external DMA channel, so "dev" is the wrong device to 
check (should be dmaengine_get_dma_device()), while conversely 
dma_max_mapping_size(anything) is a questionably meaningless number for 
PIO mode... :/

Cheers,
Robin.

> 
>  >
>  > If the device lacks DMA support, max_req_size becomes 0, which 
> propagates
>  > to the block layer and can trigger panics when processing requests.
> 
> All other users of dma_max_mapping_size() are drivers for real/virtio 
> HW, so should be no issues.
> 
>>
>>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>>> ---
>>>   kernel/dma/mapping.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
>>> index 4fe04669e5e66..7e576e5c6b8be 100644
>>> --- a/kernel/dma/mapping.c
>>> +++ b/kernel/dma/mapping.c
>>> @@ -979,6 +979,9 @@ size_t dma_max_mapping_size(struct device *dev)
>>>       const struct dma_map_ops *ops = get_dma_ops(dev);
>>>       size_t size = SIZE_MAX;
>>> +    if (!dev->dma_mask)
>>> +        return 0;
>>> +
>>>       if (dma_map_direct(dev, ops))
>>>           size = dma_direct_max_mapping_size(dev);
>>>       else if (use_dma_iommu(dev))
>>
> 

