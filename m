Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19753603C2;
	Mon, 25 May 2026 06:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779688943; cv=none; b=WSydp164x80Y6mHbGt/Qwj8qG5T/qWOHWVzcgQ0eb/SqdZP+1mr24151uLSNyHw/N/M82YqBJD+IR4cnLIxFQ4sMoRJQlmwr22C+nzCMlp9C2peIRC47UXwHrWiC97iPYu83s8C2rkVncgK4gcgvq4axh7Dh5hOJYX0QDE0EaZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779688943; c=relaxed/simple;
	bh=KpS1Trw6YdoMcXx6dFdGf78wMgd8htX+8RPS0nABSM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIZgW0M8bNL+vZcm0fZCy4uZr6HGTHOSe6dTqy9zu1HZTrGSNQU7gT1x8+TwHBfaBK9ms5pqMwImORM+yhfL4AK8EhZgxPplT2uuD0PSAzvc5OWbJ6bk/RiPCwDqjEomPgU2d3XhuFpaQIb9V7BkM0bJ/lkKNxPEXEY33ErvomE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BF52868BEB; Mon, 25 May 2026 08:02:15 +0200 (CEST)
Date: Mon, 25 May 2026 08:02:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, hch@lst.de, dlemoal@kernel.org,
	robin.murphy@arm.com, john.g.garry@oracle.com, axboe@kernel.dk,
	m.szyprowski@samsung.com, ahuang12@lenovo.com,
	ionut_n2001@yahoo.com, sunlightlinux@gmail.com
Subject: Re: [PATCH v8 1/1] scsi: sas: skip opt_sectors when DMA reports no
 real optimization hint
Message-ID: <20260525060214.GA3479@lst.de>
References: <20260519135238.373784-1-ionut.nechita@windriver.com> <20260519135238.373784-2-ionut.nechita@windriver.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519135238.373784-2-ionut.nechita@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, May 19, 2026 at 04:52:33PM +0300, Ionut Nechita (Wind River) wrote:
> +static void sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
> +{
> +	struct device *dma_dev = shost->dma_dev;
> +	size_t opt, max;
> +	unsigned int opt_sectors;
> +
> +	opt = dma_opt_mapping_size(dma_dev);
> +	max = dma_max_mapping_size(dma_dev);

I'm almost feeling bad for suggesting more changes, but this would read
much cleaner by doing:

	struct device *dma_dev = shost->dma_dev;
	size_t opt = dma_opt_mapping_size(dma_dev);
	size_t max = dma_max_mapping_size(dma_dev);
	unsigned int opt_sectors;

but otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
