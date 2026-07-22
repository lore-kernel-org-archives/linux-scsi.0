Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CF52236F7;
	Wed, 22 Jul 2026 13:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784725735; cv=none; b=r4zYQ8geyeDe4y9nN46ubVGVUBOSBQszXTIvgxsqKUtQr9/FooptJfr5NgcamL+Vn2zXkOYPHuuDwpZGRM26psHUuyBgzxwFn3qqWmkJv6YVTmbi/HZpxU52IoaCeu/iEIJU6lEggTv7BSrACbFv1cJPYe2hrL51+SQ0a24vffw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784725735; c=relaxed/simple;
	bh=3gSD1hOZU42lj52sk+8oIlGlwBvURDsKRZs3kZoclWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/9neYQmyWRklAeyZw1bxx7HBgd1wgHBFutuA8TIuz8aRreALo5GUS4+dIAImnifu7QSZrzqSUkw9p2PPmx0W83BbCZZjX1l1W6jiFUh0GMkWo1m9B1mNIBETWqd9JVMETKozSBpmfnT7Els1xlYi/qIPmF338pbdHnUk3vSpWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aj9osxRS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aj9osxRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D971F000E9;
	Wed, 22 Jul 2026 13:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784725733;
	bh=H+Qi617eo3zUgYds5z521wJuB64qpF7zXKkxOz66ms4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Aj9osxRSzFsqEtzDC0cumxQAnvyoe0mj6gU20GeYVJ8C3EFfEnr6Yqbs47vJU7fzW
	 /v0RbK4gPBnGxJUW11IIkI9nFijKT4+ilYhQi8jK22XOk8OlTGr9XPLiF0F49yM8kO
	 1r7rb0K2YYL+sDdCOq6z1V6MxO6DVjtRfHm6Gaw4=
Date: Wed, 22 Jul 2026 15:08:44 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: sashiko-reviews@lists.linux.dev, Chris Mason <clm@fb.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
Subject: Re: How to fix problems with the sashiko review model
Message-ID: <2026072224-moisture-gonad-409f@gregkh>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
 <20260722042744.5C1B01F000E9@smtp.kernel.org>
 <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>

On Wed, Jul 22, 2026 at 07:58:48AM -0400, James Bottomley wrote:
> There doesn't seem to be a Sashiko list, so I added ksummit as the most
> likely one to catch attention.  We got this review in SCSI on this
> thread:
> 
> https://lore.kernel.org/linux-scsi/20260722041257.1557-1-pengpeng@iscas.ac.cn/
> 
> But this part of the review
> 
> On Wed, 2026-07-22 at 04:27 +0000, sashiko-bot@kernel.org wrote:
> [...]
> > > +
> > > +	reply_len = mpi_reply->MsgLength * 4;
> > > +	if (reply_len < event_offset || reply_len > ioc->reply_sz)
> > > +		return false;
> > > +
> > > +	event_data_len = le16_to_cpu(mpi_reply->EventDataLength) *
> > > 4;
> > 
> > [Severity: High]
> > Is there a Time-of-Check to Time-of-Use window here since mpi_reply
> > is read directly from shared DMA memory?
> > 
> > The validation function reads bounds from mpi_reply, but after
> > validation passes, mpt3sas_scsih_event_callback() re-reads fields
> > like EventDataLength and NumEntries directly from the same DMA-backed
> > memory.
> > 
> > Could a malicious device mutate these fields in the window between
> > validation and use to bypass the checks introduced by this patch?
> 
> Is wrong.  Hardware may never be presumed to be malicious (well, except
> if it's virtual hardware provided by an untrusted host to a
> confidential guest, but that's a very small list of drivers or it's a
> USB or thunderbolt device designed to attack or exfiltrate data from an
> unattended system).  It may be buggy, but we never presume bugs until
> someone finds a device exhibiting the bug in the field (so we don't
> proactively fix them).
> 
> The bigger part of this is that I was looking into how to fix this
> (which might interest a broader swathe of developers than just SCSI). 
> I think the fault is in the review prompts:
> 
> https://github.com/masoncl/review-prompts
> 
> And what I need to do is to add an additional drivers.md file to
> kernel/subsystems explaining this?  If that's right I can send a pull
> request, but I thought I'd check here because the audience is much
> bigger than if it were to get discussed in the github PR.

Please make this per-subsystem, as your description above doesn't hold
for all types of devices or busses.  See this thread where I describe
what we do for USB and asking for much the same type of description for
the virtio drivers:
	https://lore.kernel.org/all/2026072036-outburst-rebel-c71b@gregkh/

thanks,

greg k-h
