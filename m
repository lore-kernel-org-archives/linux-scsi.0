Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE74B1885A0;
	Thu, 12 Sep 2024 07:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726124472; cv=none; b=YDN4HGCQ0O0UolZgK7x6ISpdvY+WJUrnE3Ntnz6MCpPEg8B447IxZLpRpUKsdTABK+n/jsepXQBmWJ89xp3z3xLKpt0YCRfsMpIwtNHjxYt5AFoxl3xTlm0kilThhcsnyuWOEL/84VPG+quSFFOJWuVI/yUw5BlMhyhPJDc4lnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726124472; c=relaxed/simple;
	bh=S+hLU8gsCveFYn5PMQrWSmG9xW09pMhiBUEd4YuraV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9KJgvKBJutp2UeTXqrKbqR6WLtxv+SvlzDw4CWT3jWg+QugW8blTNCVkKTgRasdfm9fVbj9yrtmVfK7yoRz+r2AMJPZubTeAGhLFYpI6B074wjgFhDIPKLQh88SY8mYLFZ0YWNwgPIaut+8MBIGfZrJNasCnXAoyE14NPkyp7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70047227AAF; Thu, 12 Sep 2024 09:01:06 +0200 (CEST)
Date: Thu, 12 Sep 2024 09:01:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	axboe@kernel.dk, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me
Subject: Re: [PATCHv3 06/10] blk-integrity: simplify counting segments
Message-ID: <20240912070106.GA7572@lst.de>
References: <20240904152605.4055570-1-kbusch@meta.com> <20240904152605.4055570-7-kbusch@meta.com> <20240910154105.GF23805@lst.de> <ZuBua91J2X5Yt-72@kbusch-mbp> <20240911081720.GA7372@lst.de> <ZuG3JoOq-XaLbBo4@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuG3JoOq-XaLbBo4@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 11, 2024 at 09:28:38AM -0600, Keith Busch wrote:
> Would you be okay if I resubmit this patchset with just the minimum to
> fix the existing merging? I agree stacking and splitting integrity is
> currently broken, but I think the merging fixes from this series need to
> happen regardless of the how the block stack might change when integrity
> data is set in bios.

I guess everything that makes it less broken is good.  I'm a little
worried about removing some of the split/count code we'll eventually
need, though.
