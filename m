Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EEF2AE69;
	Tue, 10 Sep 2024 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725983133; cv=none; b=EviBPkYMC7EAneGweEER3o2VPTQxGCsm1nEUf4xh/akBVgjjbXZWyx2rwd2BiEoLnCCS50ZM4q3YrUpe/TKLe4usHGhBViK4Kc+KayiE3OfaumRtb18fxIyv5cee5AgJegoTD6xN1x6FMhK5yjqqV4gGxjWAk+DajpA0U63Pggk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725983133; c=relaxed/simple;
	bh=5SbsjGFvS1RVbqLljcvrbrcms4kPUEnGiDAcwXir2ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bupYSDpkJQpRkReXXSvfq2M1kI/9FBhWIlbAZw1lJqHvk3A9dMDMwQ6wojX7UViV3W+BGHsEpsC+7IfEmXoa7MXhcVslidJGtth+B36Y8iunSKB/X64jOBSPCaUdBELcnnvNy1U1B2EgcAxAxvZ2A5Bf5khRVMe3j29tM5M7mEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 35979227AAE; Tue, 10 Sep 2024 17:45:27 +0200 (CEST)
Date: Tue, 10 Sep 2024 17:45:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 08/10] blk-integrity: remove inappropriate limit
 checks
Message-ID: <20240910154526.GH23805@lst.de>
References: <20240904152605.4055570-1-kbusch@meta.com> <20240904152605.4055570-9-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904152605.4055570-9-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 04, 2024 at 08:26:03AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The queue limits for block access are not the same as metadata access.
> Delete these.

While for NVMe-PCIe there isn't any metadata mapping using PRPs, for RDMA
the PRP-like scheme is used for anything, so the same virtual boundary
limits apply for all mappings.

