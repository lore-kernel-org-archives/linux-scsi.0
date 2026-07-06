Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE09543C7BD;
	Mon,  6 Jul 2026 18:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783362365; cv=none; b=DLxnpqeUfd0RetetOhHlVEJotfahCorX8m1fTQR4kO/vvQUc/vz+z1gCmrGZBIe4rrZLy9SXRivO2Key+wITBjRKRePO73LUIhPI0p3xlLMJ13bVRelhG4TbEjayUK2RB6GLQ356npglGgfayrotSzjqAopsj0To04+ZOJ7r/K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783362365; c=relaxed/simple;
	bh=MavHpYLeD2XbEmIPY4vakrO883UsSfl0C9Q6pWPZmJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgudOPNB3JnQHthDyoiM2r04sMP7VVWx6FVbeDB9csfxDkJKN4acPzW8B8DDs19639lioGNU6uQdOLBn4ftGLhyptcVaBmGc/WopyCIXsQYOfnulmKhJxzPoIBVxIGr/3mGBzvkTwqry8UODD+Gu7d+pAhfU1jNucAao3ZJMlBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e37/CpCQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e37/CpCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAF41F000E9;
	Mon,  6 Jul 2026 18:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783362363;
	bh=zV+tx3ZMxfpBxIT6Hf0j+6VrwjuhUDO+r30EXf7SWks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e37/CpCQh3wmddMYsVPts/0+ZL8gbjDMqdAq3jjMF/b/SbkMAxtYNMeeB6qy+Q1c4
	 qOHobjmO9hwOuYsg8ce65YlNlr9oJWzlIaN9jvlXkYe8kBKgHfPLMqDbXtFHiaWgXy
	 moO1yhUMAMRjm578NvTPBO+neRuo4rMDQpagay5hkFzXjf3kBXzqIhDrYHPQVPTXQd
	 kJgJskcs8KfVFN8zd/WgA+cCDy18BHgCGdIqrKsqenlk32NsG4Q5l9X7aJlNwXstzk
	 Yu7czRvPlz3rywNDpoVvDOJqV74lgGNprWew6sjG4NRBQnuB2uMlbWB09/BgvQqLRX
	 ep85JW1vLda/A==
Date: Mon, 6 Jul 2026 12:26:01 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
	sumit.saxena@broadcom.com
Subject: Re: [RFC PATCH 0/6] sbitmap enforced fairness for blk-mq
Message-ID: <akvzOT55mYMVXhn-@kbusch-mbp>
References: <20260706173438.3537347-1-kbusch@meta.com>
 <6db8dcc3-6f79-4407-a5de-ec80915bc73a@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6db8dcc3-6f79-4407-a5de-ec80915bc73a@acm.org>

On Mon, Jul 06, 2026 at 10:56:05AM -0700, Bart Van Assche wrote:
> On 7/6/26 10:34 AM, Keith Busch wrote:
> > There have been a few proposals to remove the blk-mq tag fairness
> > algorithm:
> > 
> >   https://lore.kernel.org/linux-block/20240529213921.3166462-1-bvanassche@acm.org/
> >   https://lore.kernel.org/linux-block/20260609121806.2121755-1-sumit.saxena@broadcom.com/
> 
> There have been more proposals to remove the fairness code from other
> kernel contributors. I proposed to remove the tag fairness code because
> prior attempts to solve UFS performance issues were not good enough for
> the upstream kernel.
> 
> > Both abandon blk-mq's attempt to enforce tag allocation limits on the
> > per-queue/per-hctx users that share tag space. This can harm resource
> > allocation for lesser devices sharing the space, potentially starving,
> > them from fair progress by a highly utilized device.
> 
> Has this starving phenomenon ever been observed? 

If you're asking if a production workload sees the phenomenon, no
because they run the code that has enforced fairness.

> I think that the
> measurement data that I published shows that the fairness properties of
> the current sbitmap implementation are good enough.

I can trivially wire up a test where one queue allocates 100% of the
tags for long running commands, and all the other queues that want to
start a short running command can't proceed.

> >    Second, you can optionally declare a percentage of that pool to be
> >    fair game for anyone to allocate from. This provides a way to
> >    guarantee minimum tag space for each client while allowing a user to
> >    over-allocate its fair budget on demand into the shared zone.
> 
> What software layer is expected to set these percentages? 

It's a tagset parameter that the LLD can set to whatever it needs.

> My patch
> series intentionally removes the fairness mechanism because that's
> exactly what the legacy code path in the UFS driver needs. The UFS
> WLUN and data logical units share a single tag set. Any activity on
> the WLUN increases the number of active queues and hence reduces the
> number of tags available for any data logical units.
> 
> Additionally, what is the performance impact of this patch series?

It removes the per-io atomics, so impact is it goes faster if that was
your bottle-neck.

> Removing the tag fairness code increases IOPS so this patch series
> probably has a performance impact.

You can declare the entire tagset is shared if you want. That should get
you what you were going for, but we still have an option to spatially
constrain others that want fairness with this series.
