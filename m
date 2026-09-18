Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A966238D014
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 07:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789715217; cv=none; b=MUb/ZFq26qCthIqS3GGt6UdlO1hGBfZPDcjqmJTP5iWV33KGv13CdbT+ZJX+W+9SrAA9MHJXMN1RaBAeTnsanO6CrEq2YAqmbrmfHjgk5t94dXGusrbWyp3pBfFuRScUjZs6Dk76bS1ADCNtg5FmSqsDZmzvT0fvkzrxuIJoQGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789715217; c=relaxed/simple;
	bh=/52L/1stFFn+XzKZCwrSF8fl4+KBTqM1teAOA+trINY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=onHbbiXZpTaOLazB0T8uT+tHG87o7IKsOt/+VBTrSwIncG4B3/5PewIDmTWbEws2XRVtmIDaUaVw1XdQCdWfmLZcWjLx+v6PMI71KOW7QEJjuDDleQxDECvkizhEIC8uKw4OIJzAEbI2hkAV6TjheCXOTNAS4mlT+nVOoYiaRCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2763168C4E; Fri, 18 Sep 2026 09:06:42 +0200 (CEST)
Date: Fri, 18 Sep 2026 09:06:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>, John Garry <john.garry@linux.dev>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
Message-ID: <20260918070641.GA10655@lst.de>
References: <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev> <aqu5Q_6EvfY7iRmk@ryzen> <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev> <aqvCeq9IsbjSJIEx@ryzen> <35ad0b9c-06bb-4ccd-8e58-fde4d859b85e@linux.dev> <3709D24B-4D27-44CC-92C5-59DC66309931@kernel.org> <aqwlS-_pWMWL238o@ryzen> <d4640976-7cfe-4d29-8a3f-cfb91b474110@kernel.org> <aqzOBedKG6JPbn3C@ryzen> <153761e3-b288-44bc-96d0-ddfb323f7428@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153761e3-b288-44bc-96d0-ddfb323f7428@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 18, 2026 at 01:15:36PM +0700, Damien Le Moal wrote:
> Sure, but it may not be that simple in practice because achieving atomic writes
> on HDD is not that simple: even though most modern HDDs do have some form of
> atomicity for single sector writes (e.g. on EPO events), even that is not
> guaranteed at all. So let's not assume anything that may end up being different
> than what a real implementation may do.

Besides that the whole concept of atomic writes on sequential write
required zones does not make much sense.

Atomic writes are about atomic updates of multiple sectors, but
sequential write required zoned never update existing data.  So the best
they could provide is to guarantee that either all or nothing of a single
command is appended at the write pointer.  It is very hard to find a way
to use this feature, as zoned writes all require metadata updates to
point to the current location, and without this the data won't be
reached.  There are some schemes to optimizes this by doing a zoned write
with a header containing the location as a sort of distributed log (zenfs
in userspace would be the canonical example), but even with that a torn
write would invalidate the recovery of this header.

In other words, there really is no point in supporting atomic writes on
ZBC.  So we should not implement it in scsi_debug, and disable the
feature in sd.  If we ever see real hardware and a real use case we can
reconsider, but I doubt it is going to happen.

