Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD6C23A9B3
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 18:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772129721; cv=none; b=thWYFvy/4e+9y0GP8vuzmlUm5X+j5+ZQF9kCPR3zzLsyaN1yHFZBcyDEDQEm/yf+i/AcoaE8Ind3fIH+PMQcH/xyriEg2m+2w82yKBLoTNnAgp9LHRv+9yfaEsVVrlBpOfoWzjaJEofO/626vZRCnFCoZEGeoYGStGKlRn7OJeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772129721; c=relaxed/simple;
	bh=MEpTSyjNRJ1W/nhZpu80wpvFIoWLaZGQNhVRqRoIJIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkdlZcOKD7UiVU/Km0fnnZH/9FWJ7jnLpJ9cT0QxHPTX7181vsvx2J8TnyY+lC9j6UDtk+h3NFuvml/IL+u57MF2LmGIHZFnbHjYE/p79EKY4xR1d8r73BWgqrSBwBKJs7XmlABlWOuxw+lvsVHAFB+UqRZgd2DeXRZXAk13lGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQCJVlF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQCJVlF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C39C116C6;
	Thu, 26 Feb 2026 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772129721;
	bh=MEpTSyjNRJ1W/nhZpu80wpvFIoWLaZGQNhVRqRoIJIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nQCJVlF56ElQbLw0Amw24fH3uaB/IhI++rV66xhuKkiNWed1UDzN4vhKbXeWVjpwU
	 S60EeAZBiZ1MhjUvr9CsS8m88MRnDwNtMkHQKANwWkiZtZDbCsC95qQ4WgVVekHtQv
	 URyKkwrvKDWZ9CZcyiVStalXpqVJIu6Ag5wuDuI8I3AXEsRfPzPTxu9AoKiRtArmyJ
	 pz1X8pxhj74a0LKnYNoJ3kPhtV3MQAavzuNggTfsjp3Iud+Ijn294gJDnsMBNcztDz
	 ckIn4VVDxVeJ9hQwaj57zghiPn/i9os9THVForBKs6vwkq26NEonlYYwXcT3GqpW5i
	 pZmROTL5AH0sw==
Date: Thu, 26 Feb 2026 11:15:18 -0700
From: Keith Busch <kbusch@kernel.org>
To: John Meneghini <jmeneghi@redhat.com>
Cc: Maurizio Lombardi <mlombard@arkamax.eu>,
	Maurizio Lombardi <mlombard@redhat.com>, hch@lst.de, hare@suse.de,
	chaitanyak@nvidia.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
	James.Bottomley@hansenpartnership.com, emilne@redhat.com,
	bgurney@redhat.com
Subject: Re: [PATCH V3 0/3] Ensure ordered namespace registration during
 async scan
Message-ID: <aaCNtpPzP9TIDNjE@kbusch-mbp>
References: <20260225161203.76168-1-mlombard@redhat.com>
 <aZ9sjbZ3CEW_1rW1@kbusch-mbp>
 <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>
 <e43b914c-2ca5-455e-b0fe-3ce2eb0c64bd@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e43b914c-2ca5-455e-b0fe-3ce2eb0c64bd@redhat.com>

On Thu, Feb 26, 2026 at 11:35:15AM -0500, John Meneghini wrote:
> It's worse than this.  Yes, in RHEL we carry out of tree patches to tun off the async scanning with SCSI,
> and we reverted this async namespace scanning patch in NVMe.
> 
> We had to do this because, as soon as we turned these async scanning mechanisms on, we immediately
> received customer escalations. Customer were not able to upgrade their systems. We have customer issues
> and complaints open about this and we see this async namespace scanning as a barrier to adoption with NVMEe -
> especially with NVME-OF which tends to have many more Namespaces than PCIe.

Sounds like some people just don't know how to use labels or persistent
names. Relying on /dev/nvmeXnY or /dev/sdX to always be a handle to the
same device is a fragile solution.
 
> And yes, the PCIe async discovery stuff does cause some problems.  The difference is: the PCIe bus configuration does
> not change nearly as often as, e.g., the nvme namespace configuration in a fabric, so customers don't notice the changing pci ids.
> Unless some one is going lots of hot unplugging and plugging with their PCI bus, the PCI ids typically don't change at all.

It's not about the PCI topology changing. The async probe makes it
non-deterministic as to which PCI device is going to claim which
instance out of the nvme ida since they all try to run concurrently.
