Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44CE1DA303;
	Tue,  9 Jul 2024 07:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720509370; cv=none; b=BURvjPQjsJ2OfH467u5dpEYdpbrP1R0BtCmue2eTeDL4FBhdtEDb7JgnA1uqoHH+JeS2HMjh6nCVmQ6TMEJtbp+LIRRuvf/vqYw43/R6zn+wKDTsbhilf4An01rTJqM8GCdzeFKnBncKyLCLr0wWNh9qvSqD0bbyKseizRqbF7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720509370; c=relaxed/simple;
	bh=QS4zMTZFSUoeJOw8wwu5OtMF/V1WMixZFBLuysqqOOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/JST5370aa/rM9AHXmBtHnXPaIMRUbU/H/TTG42bDZz0GQCRfTHsvH9femQBZmLTgU+4GpQLOtRn9Z5CMnjiun49NsP5y2zFr1H6V+9TXxU0uTeMfL2qVquZbDNHxP9zPDjkenBm3HBIyJQUH5+6ffQlJcy1vOooZfJhqVYv2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7225268AFE; Tue,  9 Jul 2024 09:16:04 +0200 (CEST)
Date: Tue, 9 Jul 2024 09:16:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: fine-grained PI control
Message-ID: <20240709071604.GB18993@lst.de>
References: <20240705083205.2111277-1-hch@lst.de> <yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 08, 2024 at 11:35:13PM -0400, Martin K. Petersen wrote:
> I don't like having the BIP_USER_CHECK_FOO flags exposed in the block
> layer. The io_uring interface obviously needs to expose some flags in
> the user API. But there should not be a separate set of BIP_USER_* flags
> bolted onto the side of the existing kernel integrity flags.
>
> The bip flags should describe the contents of the integrity buffer and
> how the hardware needs to interpret and check that information.

Yes, that was also my review comments.

> The other alternative is to only expose a generic CHECK or NOCHECK flag
> (depending which polarity we prefer) which will enable or disable
> checking for both controller and disk in the SCSI case. But that also
> means porting the DI test tooling will be impossible.
> 
> Another wrinkle is that SCSI does not have a way to directly specify
> which tags to check. You can check guard only, check app+ref only, or
> all three. But you can't just check the ref tag if that's what you want
> to do.
> 
> I addressed that in DIX by having individual tag check flags and NVMe
> inherited those in PRCHK. But for the SCSI disk itself we're limited to
> what RDPROTECT/WRPROTECT can express. And that's why BIP_DISK_NOCHECK
> disables checking of all tags and why there are currently no separate
> BIP_DISK_NO_{GUARD,APP,REF}_CHECK flags.

So what are useful APIs we can/should expose?.

If we want full portability we can't support all the individual checks,
because the disk will check it for SCSI even if we don't do the extra
checks in the controller.  We could still expose the invidual
flags, but reuse the combinations SCSI doesn't support on SCSI,
although that would lead to surprises if people write their software
and test on NVMe and then move to SCSI.  Could we just expose the
valid SCSI combinations if people are find with that for now?

> > Last but not least the fact that all reads and writes on PI enabled
> > devices by default check the guard (and reference if available for the
> > PI type) tags leads to a lot of annoying warnings when the kernel or
> > userspace does speculative reads.
> 
> > Most of this is to read signatures of file systems or partitions, and
> > that previously always succeeded, but now returns an error and warns
> > in the block layer. I've been wondering a few things here:
> 
> Is that on NVMe? It's been a while since I've tried. We don't get errors
> for readahead on SCSI, that would be a bug.

Note that these reads aren't readaheads (well, they actually are too
because everything in the buffer cache does a readahead first), but
probing reads from blkid / partitions scans / etc.  Right now the
driver has not way to distinguish them for reads that are really looking
for (meta-)data that is expected to be there.

I'm not currently seeing warnings on SCSI, but that's because my only
PI testing is scsi_debug which starts out with deallocated blocks.

