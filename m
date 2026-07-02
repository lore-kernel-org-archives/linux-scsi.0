Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3406481FB9
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 14:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783001481; cv=none; b=gFPSlIwfbQ+aFZWza58i6KvqYlYaOdeJQ7gNnp+x+2JfF+pqpniIlTwoJ5IIvU9m4URUE/zI4I7MuxaFIGKpCDDAKuqbgqo5nH0Wb58OLNLdjY80JTcxWGYPWk8Da2hQCRye30jii+zGGksQesvZTwm7mwyP5xCgEwaqHynqpFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783001481; c=relaxed/simple;
	bh=MZrfZMqTxJVvhcMmXsDFGzyLGl4iubhbCil/w06E3Es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O52ENerp2SKMGwz8HNoWheJhmSYALPedQEZMd4ScIMSYTXG+jI+zQetMMwDskz1xRaUKSogady4N0ceI4Bgm0u6ryjzZmomlVL/rdhPDaXiFMN4YDlCNv+qN0Fym/t7K0jW3A79Cm3nYg7h46ZdVnijqPqdXg+cVWdbZNwh1bm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 712CD68BEB; Thu,  2 Jul 2026 16:11:16 +0200 (CEST)
Date: Thu, 2 Jul 2026 16:11:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Robin Murphy <robin.murphy@arm.com>
Cc: John Garry <john.g.garry@oracle.com>,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	m.szyprowski@samsung.com, hch@lst.de, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, ionut.nechita@windriver.com
Subject: Re: [PATCH 1/2] dma-mapping: make dma_max_mapping_size() return 0
 for no DMA capability
Message-ID: <20260702141116.GA22720@lst.de>
References: <20260629085310.2298552-1-john.g.garry@oracle.com> <20260629085310.2298552-2-john.g.garry@oracle.com> <53d07679-b1bb-469c-acc2-981e75c071c9@arm.com> <d82926fe-4557-401d-ae58-4302fef5657c@oracle.com> <7c9720fd-c615-481c-ba4d-f5e0efbdd7f0@arm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c9720fd-c615-481c-ba4d-f5e0efbdd7f0@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 12:09:42PM +0100, Robin Murphy wrote:
>>  > Additionally, could this cause invalid zero-sized block layer queue 
>> limits
>>  > in MMC drivers? In drivers/mmc/host/bcm2835.c:bcm2835_add_host(), the
>>  > return value clamps max_req_size:
>>  >
>>  >          mmc->max_req_size = min_t(size_t, 524288, 
>> dma_max_mapping_size(dev));
>>
>> bcm2835.c is a platform device driver, and platform devices have their 
>> dev->dma_mask set in setup_pdev_dma_masks()
>>
>> Indeed, that driver does have a non-DMA mode of operation, but that looks 
>> to be selected independent of whether dev->dma_mask is set.
>
> That one seems pretty bogus already, given that DMA mode is apparently 
> dependent on an external DMA channel, so "dev" is the wrong device to check 
> (should be dmaengine_get_dma_device()), while conversely 
> dma_max_mapping_size(anything) is a questionably meaningless number for PIO 
> mode... :/

Yeah.  It would be good to get this fixed before this change hits mainline,
though.

