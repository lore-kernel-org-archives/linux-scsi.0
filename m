Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B737E14A618;
	Wed, 11 Sep 2024 08:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726042646; cv=none; b=Kh0awmLRbyUqa6iifacHWDxQRKHYhvGN2JCSFR4oic1+iwLCj2tVLy6qmGYT9eFKJbMfleDhN3dW178hV1eeJfc/y4K2BDkXxUMZlRBjVXBKKN+ywhJqiVz5/4xzVY+kmUkrQJWuTgWgMy9o5yrxjpoOhu+4ZQoMJnK4q1LsgGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726042646; c=relaxed/simple;
	bh=0VHblDdGu0nMtSwDwXPmUMCEX7hNAHcvpiJ3x1MSsmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qaMASOnXKl54tJroirzfZq3OgyW5++h1p+pRtg7JZvL0MW0tuhRvmz5AbMYrlclJFROGUP3WaoXjx3Htac4uUqcTCd0A0o2bJn8ND8xifjE1VfpOBNaka2yUtoQy1CREO/Weq1i0aIBDCtgGMzsbEWKoE9VypSQUNm2SXjbvQvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70F4A227AB6; Wed, 11 Sep 2024 10:17:20 +0200 (CEST)
Date: Wed, 11 Sep 2024 10:17:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	axboe@kernel.dk, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me
Subject: Re: [PATCHv3 06/10] blk-integrity: simplify counting segments
Message-ID: <20240911081720.GA7372@lst.de>
References: <20240904152605.4055570-1-kbusch@meta.com> <20240904152605.4055570-7-kbusch@meta.com> <20240910154105.GF23805@lst.de> <ZuBua91J2X5Yt-72@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuBua91J2X5Yt-72@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 10, 2024 at 10:06:03AM -0600, Keith Busch wrote:
> Exactly. bio_integrity_add_page will use the queue's limits to decide if
> it can combine pages into one vector, so appending pages through that
> interface will always result in the most compact bip vector.
> 
> This patch doesn't combine merged bio's but that's unlikely to have
> mergable segments.

Oh, bio_integrity_add_page uses bvec_try_merge_hw_page.  That means it
doesn't really work well for our stacking model, as any stacking driver
can and will change these.  Maybe we need to take a step back and fully
apply the immutable biovec and split at final submission model to
metadata?

> The common use cases don't add integrity data until after the bio is
> already split in __bio_split_to_limits(), and it won't be split again
> after integrity is added via bio_integrity_prep(). The common path
> always adds integrity in a single segment, so it's always valid.

Where common case is the somewhat awful auto PI in the lowest level
driver.  I'd really much prefer to move to the file system adding
the PI wherever possible, as that way it can actually look into it
(and return it to the driver, etc).

> There are just a few other users that set their own bio integrity before
> submitting (the nvme and scsi target drivers), and I think both can
> break from possible bio splitting, but I haven't been able to test
> those. 

Yes.  Plus dm-integrity and the new io_uring read/write with PI code
that's being submitted. I plan to also support this from the file
system eventually.  None of these seems widely used, which I think
explains the current messy state of PI as soon as merging/splitting
or remapping is involved.

