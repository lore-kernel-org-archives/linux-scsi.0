Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD981AAE01;
	Wed, 11 Sep 2024 15:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726068521; cv=none; b=Nth/bZdsYuQdMLMXdsXDd9SdkdM0P07dTRFyyY/G5dYJoTx2UcjSd61poboBlTuLFEEzV407eN6WcYhoLB40XyPROPB3KyZkJVBzQdp+lhBvW153rSH3+P5aRZQV+DaLBJqke6tWm8RMWQ1HVQqacabjRoQjb2wLA+u49wifbcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726068521; c=relaxed/simple;
	bh=DqtkfdaA8P1FYjzF3GC+zMYqZk72DjfX7QjCW8jFSys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ALQTnEyS2kVxqbYHbYFvX5njxc89uWq+ut1dHaMffsgyzICWPFwk7XRlyaBnRGsqDdPyAin7sfG8+yYyCmNHLm0rfyNyj3xVnJBmFbrNbYnPMHqRQ0SZU1tZ0gH3WT4koRdGca9EkB5bwpfHJxazUmGTQt89IQeLAF//IxfxyMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoMCgDtw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoMCgDtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEC8C4CEC5;
	Wed, 11 Sep 2024 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726068521;
	bh=DqtkfdaA8P1FYjzF3GC+zMYqZk72DjfX7QjCW8jFSys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YoMCgDtw3d7qW2tYi+Xz30aYj3X9q9rO9DhMB4wmZEMPb/L7NKZJw6iw0S2e6pHb2
	 zpSoY79IUr5blezaNWacaw+TZIBT7fhfjmUGxHIF/icasi5AivB8DgG5+nZAIYy5aJ
	 R/NNf8CogCGbea5VopmELrKCQqCqIxPBAqGp5wdDchkWSWk8jfFB199XbnMn69VnCP
	 e9/b50RArisnekOIElkpmkJlCq9bpB3LFyDiPIJoXhCsn8tUmT9ota+sEvLW+qW2xD
	 k0swsa4wYpsHmD3siQWHHumTotVRfxUgz8npKzq4yn8HZqqM9/bSEONRHP2uFt5jrF
	 T/xhlemsa+2SA==
Date: Wed, 11 Sep 2024 09:28:38 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	sagi@grimberg.me
Subject: Re: [PATCHv3 06/10] blk-integrity: simplify counting segments
Message-ID: <ZuG3JoOq-XaLbBo4@kbusch-mbp.dhcp.thefacebook.com>
References: <20240904152605.4055570-1-kbusch@meta.com>
 <20240904152605.4055570-7-kbusch@meta.com>
 <20240910154105.GF23805@lst.de>
 <ZuBua91J2X5Yt-72@kbusch-mbp>
 <20240911081720.GA7372@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911081720.GA7372@lst.de>

On Wed, Sep 11, 2024 at 10:17:20AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 10, 2024 at 10:06:03AM -0600, Keith Busch wrote:
> > Exactly. bio_integrity_add_page will use the queue's limits to decide if
> > it can combine pages into one vector, so appending pages through that
> > interface will always result in the most compact bip vector.
> > 
> > This patch doesn't combine merged bio's but that's unlikely to have
> > mergable segments.
> 
> Oh, bio_integrity_add_page uses bvec_try_merge_hw_page.  That means it
> doesn't really work well for our stacking model, as any stacking driver
> can and will change these.  Maybe we need to take a step back and fully
> apply the immutable biovec and split at final submission model to
> metadata?

Would you be okay if I resubmit this patchset with just the minimum to
fix the existing merging? I agree stacking and splitting integrity is
currently broken, but I think the merging fixes from this series need to
happen regardless of the how the block stack might change when integrity
data is set in bios.
