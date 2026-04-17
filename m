Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0A536165C;
	Fri, 17 Apr 2026 07:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776412511; cv=none; b=pETitB/E6VNTC9AajDSUvCI3kY1mEdgpUcxaSFdT7n1WGBwSC4pytw/+ZwpOAZ5wLO4ISuFZOp/04UJAuWDKfwpPKIr20Etita0dhDcGzYAewjyUIFVndlvfzDh67OXEsFhl0R9rjkbsBRfAL+S6NIKpZUSKyBeuNj8HOt5p+BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776412511; c=relaxed/simple;
	bh=ajAVELCEaERjQo6lioB7t9fK+z3PTGZsW7P6NLKstqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qWnS2Cr43wAgK655d4ZAAYF8nBxZXYNrY+m5Elqd0MtJjuGkkMg2Fcz6xBDpw4FNTZwjJvp28Z93osURmIjp7XQRYntGylQ37y4necPicKbkYVXvo8u8KJ86KmX+7CPWmX4bC67NDh6wMbyoXxCJn+Q0wRJ2EAriJWzMhsthy18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7A4CF68CFE; Fri, 17 Apr 2026 09:55:07 +0200 (CEST)
Date: Fri, 17 Apr 2026 09:55:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 6/6] blk-integrity: avoid sector_t in
 bip_{get,set}_seed()
Message-ID: <20260417075507.GD31524@lst.de>
References: <20260416002214.2048150-1-csander@purestorage.com> <20260416002214.2048150-7-csander@purestorage.com> <20260416052325.GE14950@lst.de> <CADUfDZpbOhO9BUW_mFZYh9-UZU26_o3rFGBffNTpepk0ogJhZw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUfDZpbOhO9BUW_mFZYh9-UZU26_o3rFGBffNTpepk0ogJhZw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 16, 2026 at 06:53:05PM -0700, Caleb Sander Mateos wrote:
> > > +static inline void bip_set_seed(struct bio_integrity_payload *bip,
> > > +                             const struct blk_integrity *bi,
> > > +                             const struct bio *bio)
> > > +{
> > > +     bip->bip_iter.bi_sector =
> > > +             bio_integrity_intervals(bi, bio->bi_iter.bi_sector);
> >
> > The bip is pointed to by the bio, so we don't need to pass it separately.
> > Same for struct blk_integrity.
> 
> I did consider that, but all callers already have bip and bi in
> variables that they also use elsewhere. Seemed like it might be
> slightly more efficient to just pass the precomputed values instead of
> looking them up again. Not a big deal either way. I'll go ahead and
> implement your suggestion.

In general I much prefer API-simplicity over a little bit more
efficiency unless we can show it makes a difference that matters.
And given that this is an inline function where compiler tend to
avoid duplicate dereferences anyway I doubt we'll see a difference
here.

