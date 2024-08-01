Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6CF183CC5;
	Thu,  1 Aug 2024 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722519664; cv=none; b=TdFXYpjp189UoR2FLbHtWScON35GR29ZC5UGIm3D71Wdu8LCDBq/DSExg2jcKRSfLnDaVgWUr2Mo3m8tgvGUrpzp9wdDJlpj6mFCWDG4X7mokne129bJW5coRN+pmZdnO4iFLAxhw01R1QviI2LIyUujNZdKyvCYb1vXIahdbcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722519664; c=relaxed/simple;
	bh=Q93/G2zxiqpxyZEN4/XJBrYrUzBW29Qvcz3EuO1W2EE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PPYI4Fo263zur832c6z4ldBHnwrof0iM7HlvhZvstOXVSYDXNDcGEV6qdYjgiCUDy6LfX5xTBRu9q4RmO4H/Ztb5YbOahnrzxzlzj0n9DtcalP6uxSTOtSBr2USEQEi2MrklYNQDyJp6/tkqk67VTbFsW3o20wLchXio78/mBlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B4F6268D0A; Thu,  1 Aug 2024 15:40:57 +0200 (CEST)
Date: Thu, 1 Aug 2024 15:40:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@lst.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	PowerPC <linuxppc-dev@lists.ozlabs.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>, linux-scsi@vger.kernel.org
Subject: Re: linux-next: runtime warning after merge of the dma-mapping tree
Message-ID: <20240801134057.GA2245@lst.de>
References: <20240801151455.01f08778@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801151455.01f08778@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)

Ok, I guess this is what Robin was referring to.

A midlayer like SCSI really shouldn't directly call dma layer
functions without knowing that the underlying bus is DMA capable.

I'll see what I can do about it, and in the meantime drop this patch
and the companion from the dma-mapping tree.

