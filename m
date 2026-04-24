Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86FF31E85B;
	Fri, 24 Apr 2026 13:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777036873; cv=none; b=DU/+NNc6EKUDooUhmp+1OxVMSoROG3+hkhu97O07wappcNVWO9ZSRYZU0+9akyD66okYdFNbITcEo+iciLfYsOG6ogJnvOXt29Ljyb0h4sAuPWTLIOpfjofUKXMzCIAyzp9ndsLYOT3tj1E5+Fv8E3rL6jgE3cyz8R16JVTUQOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777036873; c=relaxed/simple;
	bh=9F8VABLsRUEphPoeAAeRlFvMhIld3nJ5fx8YvmC3grw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zaf0ov677H6g5or6QQBShK+Bo/7pNwQTIcR5LXtdM6k2CXahZCOKtrQVW2Qf2hFcJPBb4N9EwWy9jdgUsWtvCR3P7FgERXwS+WmjtS+yYFbag6AObOySZaYy4Nasz1Xr5Pfa0J4KrE9VLqSwnHbEFmi4NxRNemfcGbvixxcMkgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B7E568C4E; Fri, 24 Apr 2026 15:21:00 +0200 (CEST)
Date: Fri, 24 Apr 2026 15:21:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, hch@lst.de, dlemoal@kernel.org,
	robin.murphy@arm.com, john.g.garry@oracle.com, axboe@kernel.dk,
	m.szyprowski@samsung.com, ahuang12@lenovo.com,
	ionut_n2001@yahoo.com, sunlightlinux@gmail.com
Subject: Re: [PATCH v7 1/1] scsi: sas: skip opt_sectors when DMA reports no
 real optimization hint
Message-ID: <20260424132100.GA15553@lst.de>
References: <20260415071849.25693-1-ionut.nechita@windriver.com> <20260415071849.25693-2-ionut.nechita@windriver.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415071849.25693-2-ionut.nechita@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 15, 2026 at 10:18:49AM +0300, Ionut Nechita (Wind River) wrote:
> +/*
> + * Set shost->opt_sectors from the DMA optimal mapping size, but only
> + * when dma_opt_mapping_size() is strictly less than dma_max_mapping_size(),
> + * indicating a genuine optimization hint from an IOMMU or DMA backend.
> + * When the two are equal (e.g. IOMMU disabled / passthrough), no real
> + * hint exists, so leave opt_sectors at 0 to avoid bogus optimal_io_size
> + * values that break filesystem geometry (e.g. mkfs.xfs stripe alignment).
> + */
> +static void sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
> +{
> +	struct device *dma_dev = shost->dma_dev;
> +	size_t opt, max;
> +	unsigned int opt_sectors;
> +
> +	if (!dma_dev->dma_mask)
> +		return;

Upper layers have no real busines looking at dma_dev->dma_mask. What
is this check intended to do?

> +
> +	opt = dma_opt_mapping_size(dma_dev);
> +	max = dma_max_mapping_size(dma_dev);
> +
> +	if (opt >= max)
> +		return;
> +
> +	opt_sectors = min_t(unsigned int, opt >> SECTOR_SHIFT,
> +			    shost->max_sectors);
> +	if (!opt_sectors)
> +		return;
> +
> +	shost->opt_sectors = rounddown_pow_of_two(opt_sectors);

Please add comments explaining the logic.

