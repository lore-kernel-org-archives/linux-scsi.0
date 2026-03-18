Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D67D36AB50;
	Wed, 18 Mar 2026 07:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773820388; cv=none; b=l1mtSIYf/YK1LBLPdn5YURlY204B5En1M6iXeqnbmelLzzX+f8p2Lyt69BaveTIW+s6pwgMtvP4JNJ85JatIxYpRVhhNB9PHeHCIXJ/49BaZK+H7gS7CdIB1qwXplKQIid4gfoGGsb4zvbJ+DvnZUVeM8jaA3gmmjhqWrJWbXMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773820388; c=relaxed/simple;
	bh=oLzettf5PonOTO1iU1zqd+AsezXYJ9jP4V/gzgeO/pA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sQs/zUcnfaKhyB59a4nPyoEvmDLEM2H2SuHzdQPjjp3iaJZlgEhqFHTz8Mgr38ZXqXAf8ETaakZS5emsdCNm4IXLrfsn1x7NhriI7rP4TNeYio7+DYp0Wk+KMfrF/oK0tBe3LmkZ+VCr4OpDGsqVUnFYIjy96SBMu2CHa/Ei09o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 68DD068B05; Wed, 18 Mar 2026 08:53:01 +0100 (CET)
Date: Wed, 18 Mar 2026 08:53:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	ahuang12@lenovo.com, axboe@kernel.dk,
	damien.lemoal@opensource.wdc.com, hch@lst.de, iommu@lists.linux.dev,
	ionut_n2001@yahoo.com, john.g.garry@oracle.com, kbusch@kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, m.szyprowski@samsung.com,
	robin.murphy@arm.com, sagi@grimberg.me, stable@vger.kernel.org,
	sunlightlinux@gmail.com
Subject: Re: [PATCH 1/1] scsi: sas: skip opt_sectors when DMA reports no
 real optimization hint
Message-ID: <20260318075301.GA25589@lst.de>
References: <20260318074314.17372-1-ionut.nechita@windriver.com> <20260318074314.17372-2-ionut.nechita@windriver.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260318074314.17372-2-ionut.nechita@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

>  	if (dma_dev->dma_mask) {
> -		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
> -				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
> +		size_t opt = dma_opt_mapping_size(dma_dev);
> +
> +		/*
> +		 * Only set opt_sectors when the DMA layer reports a
> +		 * genuine optimization constraint.  When opt equals
> +		 * dma_max_mapping_size() no backend provided a real
> +		 * hint — the value is just the DMA maximum, which is
> +		 * not useful as an optimal I/O size and can cause
> +		 * mkfs.xfs to compute invalid stripe geometry.
> +		 */
> +		if (opt < dma_max_mapping_size(dma_dev))
> +			shost->opt_sectors = min_t(unsigned int,
> +					shost->max_sectors,
> +					opt >> SECTOR_SHIFT);

This looks reasonable, but please also round down the opt value
to a power of two when you touch this anyway.

And especially with that this logic is complicated enough that it
warrants a little helper that is clearly split out.
