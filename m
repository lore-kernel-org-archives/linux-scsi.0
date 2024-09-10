Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBABA18DF72;
	Tue, 10 Sep 2024 15:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725982760; cv=none; b=ZJu8UQcjHHz5Z3PM5nn0CZz6HsB26mhCcrzqKr54TrAVAV7Bjj2oRSeS0vdxPAAn+kwCWScA3w+4QSSDl5ydi+0xUAfbElAFqRn6lGMY9wm15DejGzyY3l5tsGDw2c9hL9k6Y+nxouSC/ueNul5TyTEVxty7aSQbTcLdGZiBKV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725982760; c=relaxed/simple;
	bh=gqnIRsyOZvYlumv1w6sgCwEqmA0ykjp1xDrMLzjEcds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fz8EOOyceJHVh8LwotpnR9nFOv6/WkNWpwoqyfFEuBb+HN8fzq8cgXbA82J3tJr/NdnUTj+P21JxSS/PZG6O9XDzOuUxcLAll2NmqDk7yfK8Ig/1325OT4ka3o3gaUq1RMrtgbYe0DQUqny75lxuHzQAz5GuraypkBDAemW+zKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RclTTXgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RclTTXgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105ACC4CEC3;
	Tue, 10 Sep 2024 15:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725982760;
	bh=gqnIRsyOZvYlumv1w6sgCwEqmA0ykjp1xDrMLzjEcds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RclTTXgXiw4c5CLvhhyoHhy6AUUEynnX3GLJz8QF0UdBJFFoFyG2HUoz9A2KsPn2W
	 LDmwh1H+GfWpORCqdCI0noZSxTbgUK48CkxNA/2E2z6GrFbx4+h7g9WKFixR+X535J
	 tBN3lroSVZSznQ7LLpgY3z5jbvviTqXzTiXBPO9kxglw/uHRP9anmAkucQo/kC6KwD
	 dzzEIIdok/x3w7L+m22VdEr8O3/GvRWv+35nUDYIC5bxY497mTtjtwpS4d8P6BlKnx
	 wU+hdMYABkNvrNTl3NGkCelTbbtI9eytjhu2mp4xVL+HzY0rr377QYI/BsHGI5WPqa
	 5+JGOGcjDPCng==
Date: Tue, 10 Sep 2024 09:39:17 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	sagi@grimberg.me
Subject: Re: [PATCHv3 02/10] block: provide helper for nr_integrity_segments
Message-ID: <ZuBoJYw5Ke9cdTXK@kbusch-mbp>
References: <20240904152605.4055570-1-kbusch@meta.com>
 <20240904152605.4055570-3-kbusch@meta.com>
 <20240910153046.GB23805@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910153046.GB23805@lst.de>

On Tue, Sep 10, 2024 at 05:30:46PM +0200, Christoph Hellwig wrote:
> On Wed, Sep 04, 2024 at 08:25:57AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > This way drivers that want this value don't need to concern themselves
> > with the CONFIG_BLK_DEV_INTEGRITY setting.
> 
> Looks ok:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Although I wonder if we should simply define the field unconditionally
> given that it is only 2 bytes wide and packs nicely.

Good idea, I didn't consider that. Various parts become cleaner if it's
unconditionally part of the request. I'll try it out.

BTW, just want to mention the the return value here is unreliable until
patch 10. I've reworked the series so that appears first to avoid a
bisect hazard. The end result is the same though, so I didn't want to
spam the mailing list with a v2 just yet.
