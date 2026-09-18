Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7924A4836
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 07:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789716498; cv=none; b=rLPVWToaJ0KXKdZbBMmBxsghUDRDjafANsXlGyAFDNktGYdiRihKqLdE6865a+trSsjzI31cqbeA1pXxsdfY1Ncp+qw0zNoiyKQMBy8UOzxCJ6kXi58WEn7Z78iyoQMrrJ0mxV2P9j6gIwUYvTrWh8pF0yGMCdRBOyR8Ow2ySfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789716498; c=relaxed/simple;
	bh=T4UeetZ4LzSzUtPa7KYHxRfhGCZazjSsbY3KEUzadic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtvGYVeKmgyiPzQeRc5Zn1ite+PPzK0kMMsGmy/pLpUKkscWPDz4egsR6595wFYLUtja5whLaGo3uQFueTCCrLynXhrpf5gF/wcyO1ptFgvDeRrbjvfgWkC5UPTheLSQj1p4H6YCvIo9IF6u9OUdESMyGauLIPLUyx05XMpOYuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhVnTtju; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhVnTtju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397EC1F00893;
	Fri, 18 Sep 2026 07:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789716483;
	bh=fZ6IJoGMBgJYNkNJp9+YjuEl3mkvQ2GIziZadcedjCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JhVnTtjucAeMzCqaEpXce4Cbj1tbP0YhZBt2laws8ri29S7BBCH8gYGrtGtijjTiM
	 azRlDV8l2pKqPVRzCwfkE53W3LsC7MZLy32Sv8yBJFtiyfG55enS7SedQr6MjrzhdF
	 t0oyjhX1ZiPb8mvSaCXp6VmepwPQHjzkLG5S40cLcazL8TpKWvMx+q5Jdc9W80bZxN
	 Hk3onXaQStALD3oaQMpv4untWrIRXDaW9GGiWQ+lULdsk7WikqrIzBKlKodGtcc3tK
	 WmsDVLy21SUnlCozBomJ+HsZg4chXFzLOmMV+GoomzrfjG9zqg3yVYUlGDkC/GQWUW
	 yjZyUNUn3mdEg==
Date: Fri, 18 Sep 2026 09:27:59 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, John Garry <john.garry@linux.dev>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
Message-ID: <aqzn_y5A0w3KQiFh@ryzen>
References: <aqu5Q_6EvfY7iRmk@ryzen>
 <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev>
 <aqvCeq9IsbjSJIEx@ryzen>
 <35ad0b9c-06bb-4ccd-8e58-fde4d859b85e@linux.dev>
 <3709D24B-4D27-44CC-92C5-59DC66309931@kernel.org>
 <aqwlS-_pWMWL238o@ryzen>
 <d4640976-7cfe-4d29-8a3f-cfb91b474110@kernel.org>
 <aqzOBedKG6JPbn3C@ryzen>
 <153761e3-b288-44bc-96d0-ddfb323f7428@kernel.org>
 <20260918070641.GA10655@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918070641.GA10655@lst.de>

Hello Christoph,

On Fri, Sep 18, 2026 at 09:06:41AM +0200, Christoph Hellwig wrote:
> On Fri, Sep 18, 2026 at 01:15:36PM +0700, Damien Le Moal wrote:
> > Sure, but it may not be that simple in practice because achieving atomic writes
> > on HDD is not that simple: even though most modern HDDs do have some form of
> > atomicity for single sector writes (e.g. on EPO events), even that is not
> > guaranteed at all. So let's not assume anything that may end up being different
> > than what a real implementation may do.
> 
> Besides that the whole concept of atomic writes on sequential write
> required zones does not make much sense.
> 
> Atomic writes are about atomic updates of multiple sectors, but
> sequential write required zoned never update existing data.  So the best
> they could provide is to guarantee that either all or nothing of a single
> command is appended at the write pointer.  It is very hard to find a way
> to use this feature, as zoned writes all require metadata updates to
> point to the current location, and without this the data won't be
> reached.  There are some schemes to optimizes this by doing a zoned write
> with a header containing the location as a sort of distributed log (zenfs
> in userspace would be the canonical example), but even with that a torn
> write would invalidate the recovery of this header.
> 
> In other words, there really is no point in supporting atomic writes on
> ZBC.  So we should not implement it in scsi_debug, and disable the
> feature in sd.  If we ever see real hardware and a real use case we can
> reconsider, but I doubt it is going to happen.

I have just sent out a new version of this series, and in this patch:
https://lore.kernel.org/linux-scsi/20260918062910.1709791-14-cassel@kernel.org/

a combination of ZBC and atomic writes is rejected by scsi_debug.


This series does not touch sd.c, so changes to sd.c should be a separate patch.
From you reply, it is obvious that you would be able to write a sd.c patch with
a better motivation than anything that I would attempt to cook up.


Kind regards,
Niklas
