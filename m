Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D9637EFF3;
	Wed, 22 Jul 2026 12:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.167.242.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784722300; cv=none; b=GoRiKpc2/LwXnKyV7TDxH9E7b6yQ2LaaBfkpHuZxftKr99TspvgiiiTxUcFD6ey0ZUImCl7yJeIm9J5vADRQElkyzX1BwukJTxkD9wXqzeJAjqqXi5pVdjdemq/vl5C6SaG9KKyIkSs8q+CPJLn5VXr99F2lnfBMiIEIxMRZPDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784722300; c=relaxed/simple;
	bh=OZFiJfGH+tCL4cL71/l+DTDw+bpYVgYJt1tADyjISdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EeffvexJGMYegDCrv1RbF0E6zdRVBAB1wiz2t7sFwKytKdzO0NED4TsoUDkOgQ8fvT4OsD2c/a/YWWAcWybOBs1/MQKYOtGn7bDR9wfnqRn24nSV4GfCGfy0/gt4WFJ2wBbszZLaslBh2HgYd5wOZTWUIXeOK/EvkaWmAmSKhMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com; spf=pass smtp.mailfrom=ideasonboard.com; dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b=S6EB5i1W; arc=none smtp.client-ip=213.167.242.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="S6EB5i1W"
Received: from killaraus.ideasonboard.com (2001-14ba-70f3-e800--a06.rev.dnainternet.fi [IPv6:2001:14ba:70f3:e800::a06])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5757C447;
	Wed, 22 Jul 2026 14:10:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1784722236;
	bh=OZFiJfGH+tCL4cL71/l+DTDw+bpYVgYJt1tADyjISdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S6EB5i1WUdaS+auWVNS9PuYRSJyqwxE2gwR8brupm7IjI0VYtfzJsPpY5zA8FlOdB
	 i2zxCKM2jyGMXtFqZ4Wjdr1UNmTQVrRRvXSnu425vmnzy6HFgzJ+dT2R9qSzf8HLB+
	 0E2BylewvudBmVD2gXs79dJjAAEByVBNxZ2ljiBY=
Date: Wed, 22 Jul 2026 15:11:35 +0300
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: sashiko-reviews@lists.linux.dev, Chris Mason <clm@fb.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-scsi@vger.kernel.org, ksummit@lists.linux.dev,
	workflows@vger.kernel.org
Subject: Re: How to fix problems with the sashiko review model
Message-ID: <20260722121135.GB629472@killaraus.ideasonboard.com>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
 <20260722042744.5C1B01F000E9@smtp.kernel.org>
 <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>

On Wed, Jul 22, 2026 at 07:58:48AM -0400, James Bottomley wrote:
> There doesn't seem to be a Sashiko list, so I added ksummit as the most
> likely one to catch attention.  We got this review in SCSI on this
> thread:

workflows@vger.kernel.org seems a good candidate for discussions about
tooling. The mailing list was created to share workflows and tools
between maintainers as far as I understand.

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

-- 
Regards,

Laurent Pinchart
