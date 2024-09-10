Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A002AE69;
	Tue, 10 Sep 2024 16:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985272; cv=none; b=sRYdnIYTx9iNPonxScEnA3BArfk/RBWCBr9RniNe5tprUB8187TuNRs49WWDVVkqQNlCaJBsHEd+/be9+PpqF78CqIVUWI8LNwwDH+tWE8bHS+ysPgiVCwFlvm1539DMC2FC68zk9YafBYPuzd5JPZi16w6yx8CdSWsgsNbdzfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985272; c=relaxed/simple;
	bh=2IBMIJqI8PHktjccNnGcVhaiteOsqyw1iGPhtEuQJOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBiaNcYIvrS7UfC76nF/TUumCMjf/LuCmav0mSXbMgmV4qDCmfnKO9EdqbVY6Q3xnIG8VLBSLXlfpUAvsV1zIJDxkPUB7WMYru9Bj8Uhcl0LJN3FS2kqjQ62SVvG5y1DHdNudx3TcjWmR89cMRJTAGk4Yb3Yc7f4ocaw3h9xPKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pS7U4Ouj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pS7U4Ouj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AD1C4CEC3;
	Tue, 10 Sep 2024 16:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725985272;
	bh=2IBMIJqI8PHktjccNnGcVhaiteOsqyw1iGPhtEuQJOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pS7U4OujPOstuwgVxtpKl4tNQfouvess+kEErgSp6YcSrPkX6nehTFaAKNbs/qRqa
	 j0oA6iMJZTdpy/5zXLEaqXomUJjBrmvDb4ibMMAk+O8R2064E6hByH+/NiDcy8baWF
	 2HZO5fu2Mquwcr065Zk6/ProjtZqobSk2ORvqnJrPpJ0UtkAf3wGjWGOL6tvZPqdoU
	 ASbPllaQyWJl7meCHUAKZ+Y6xLzwZmCwTBHaqNkt6W/bVZwmVSo7vqmfhXCvleSeGv
	 zzdOP0DH70mDMzb3jsn3yFVIDvoVIn8V/W71QkMyt9wEeuAUW9+BZR02dKATbApPwA
	 R+5rFQVvryOgw==
Date: Tue, 10 Sep 2024 10:21:09 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	sagi@grimberg.me
Subject: Re: [PATCHv3 08/10] blk-integrity: remove inappropriate limit checks
Message-ID: <ZuBx9blCTUvsS6yq@kbusch-mbp>
References: <20240904152605.4055570-1-kbusch@meta.com>
 <20240904152605.4055570-9-kbusch@meta.com>
 <20240910154526.GH23805@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910154526.GH23805@lst.de>

On Tue, Sep 10, 2024 at 05:45:26PM +0200, Christoph Hellwig wrote:
> On Wed, Sep 04, 2024 at 08:26:03AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > The queue limits for block access are not the same as metadata access.
> > Delete these.
> 
> While for NVMe-PCIe there isn't any metadata mapping using PRPs, for RDMA
> the PRP-like scheme is used for anything, so the same virtual boundary
> limits apply for all mappings.

Oh shoot. The end goal here is to support NVMe META SGL mode, and that
virt boundary doesn't work there.

I was hoping to not introduce another queue limit for the metadata
virt_boundary_mask. We could remove the virt_boundary from the NVMe PCI
driver if it supports SGL's and then we're fine. But we're commiting to
that data format for all IO even if PRP might have been more efficient.
That might be alright, though.
