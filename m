Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBEA1AB6C1;
	Wed, 11 Sep 2024 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726067931; cv=none; b=cCDbylWD4NPtLb3DXfF8n/oTbcwOTLZ/JYtHTpt09jrTYCjfyDGotdh+I9QjEl3lUr+WUERpEwNr1KbCMd9B5Z0toHC5OZkEJmMlW+qiREU1Oi6+TOMs5+XPMRwsFMVRDXTPQOB4L1H9fy3DwMJNmZ3mnuAWKgUz+TFtXhZuJbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726067931; c=relaxed/simple;
	bh=ccPusGui9l+4uHYSFKd64E0OMOr0AoqgldLtmLoEqYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EwmQtWus3ojPjlWXY1gB7JVUSO/j4yw8G/w/EiMJO5gUETr0mE7dHoQOQFS7Ads2gRU5PuIDbHjjCJ661PfzdBZLNQv7SyQ8nRCkvVu515rmsKt8r7zZit8eo4PfMVd1pZMExyaVmh8ERhySoLTkumkJQmtZCzkRMol4LeIAbTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fqDcy7TJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fqDcy7TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584A3C4CEC5;
	Wed, 11 Sep 2024 15:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726067930;
	bh=ccPusGui9l+4uHYSFKd64E0OMOr0AoqgldLtmLoEqYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fqDcy7TJbQkf745PlXaAf/KeypPhhV5acD0o717aenLvheqSeXY3kLogzRjx6H5+9
	 TKZdRjlLyo/SF4rG5N4gr/KJGpVqIxTZRa7nkUrLXjIsolhy+vn9cNSOf7FW0vSTe5
	 mfgafYzdtGx6WjkZCJ1GWJ4DWZ7O9/HTPy6QRiwfVC2qYPDHnnWfa4SubT0DbFXLRi
	 ocuF8+/TLMd+jfSrxvgQiJhk1jyBLdymctdkPFpyAjeeDDiN9GWS5KS89VValAwfaG
	 ohskAH93ZjMc2eqdJ0lNbQI9EV5J4j1e6fU9DuJ4gUTJmN8vab9wRcgVuOpTdOUJdG
	 IdveCmvioaA9A==
Date: Wed, 11 Sep 2024 09:18:48 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	sagi@grimberg.me
Subject: Re: [PATCHv3 08/10] blk-integrity: remove inappropriate limit checks
Message-ID: <ZuG02LcaQwo9cK2a@kbusch-mbp.dhcp.thefacebook.com>
References: <20240904152605.4055570-1-kbusch@meta.com>
 <20240904152605.4055570-9-kbusch@meta.com>
 <20240910154526.GH23805@lst.de>
 <ZuBx9blCTUvsS6yq@kbusch-mbp>
 <20240911081846.GB7372@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911081846.GB7372@lst.de>

On Wed, Sep 11, 2024 at 10:18:46AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 10, 2024 at 10:21:09AM -0600, Keith Busch wrote:
> > I was hoping to not introduce another queue limit for the metadata
> > virt_boundary_mask. We could remove the virt_boundary from the NVMe PCI
> > driver if it supports SGL's and then we're fine. But we're commiting to
> > that data format for all IO even if PRP might have been more efficient.
> > That might be alright, though.
> 
> The real question is if we actually want that.  If we want to take
> fully advantage of the new dma mapping API that Leon is proposing we'd
> need to impose a similar limit.  And a lot of these super tiny SGL
> segments probably aren't very efficient to start with.  Something that
> bounce buffers a page worth of PI tuples might end up beeing more
> efficient in the end.

Yes, a bounce buffer is more efficient for the device side of the
transaction. We have the infrastructure for it when the integrity data
comes from user space addresses, so I suppose we could introduce a "kern"
equivalent.

But currently, instead of many small SGL's stiched together in a single
command, we have the same small SGLs in their own commands. I think this
patch set is a step in the right direction, and doesn't preclude bounce
optimizations.
