Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A581741FA;
	Wed, 11 Sep 2024 08:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726042731; cv=none; b=SmYFif/YqGU3FB/4VVKfck84VMmASXAOCMoN2pzTww/DuIRQfsb0TjQ5xKLPZEUgEFfK1GYWG6/0IlgSpILURR91Gsw+g5vUAuDD9W8H2L5jHec4nWdHgB5jOuEoARTbPFeZ6mw2XVr5Ku/2X9tegNuQnPJ4jvpNFRHjrV4iCYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726042731; c=relaxed/simple;
	bh=Q4IxcW+epXF4dQzwjD0N1hlIVgLYH4XAx38YlSOKVus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d0BNCVDIl4/T97Qz/hgRlPl7HMwxc1tEVCMazLD8RafvTinpi+IkMrwGruNHC7NzNBW+V9vZksqNK27o9b78dSE6RgL/v+rk2O49sh3llCFS9iIjE6t418eIcnM3xfGgcaAM66SK/Q8A1DTjgGG2mexNFml8ztkX3rABzTN+h28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 66D2B227AB6; Wed, 11 Sep 2024 10:18:46 +0200 (CEST)
Date: Wed, 11 Sep 2024 10:18:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	axboe@kernel.dk, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me
Subject: Re: [PATCHv3 08/10] blk-integrity: remove inappropriate limit
 checks
Message-ID: <20240911081846.GB7372@lst.de>
References: <20240904152605.4055570-1-kbusch@meta.com> <20240904152605.4055570-9-kbusch@meta.com> <20240910154526.GH23805@lst.de> <ZuBx9blCTUvsS6yq@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuBx9blCTUvsS6yq@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 10, 2024 at 10:21:09AM -0600, Keith Busch wrote:
> I was hoping to not introduce another queue limit for the metadata
> virt_boundary_mask. We could remove the virt_boundary from the NVMe PCI
> driver if it supports SGL's and then we're fine. But we're commiting to
> that data format for all IO even if PRP might have been more efficient.
> That might be alright, though.

The real question is if we actually want that.  If we want to take
fully advantage of the new dma mapping API that Leon is proposing we'd
need to impose a similar limit.  And a lot of these super tiny SGL
segments probably aren't very efficient to start with.  Something that
bounce buffers a page worth of PI tuples might end up beeing more
efficient in the end.
