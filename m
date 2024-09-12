Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A34615C3;
	Thu, 12 Sep 2024 07:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726127179; cv=none; b=fMdxCnG1UQLpZVUhCVowvIEUqr8o+w2+GeCErhrjnTyycy9nmt4MYQDqflbx9tJDRajJtFGqOqabGyQj28RdJXcKqYAO9mg40TFBa+hmhZGwOmZmt0LgdD3kzPoR0CHb/F3gbmNNyT0FHR1KPlY+Rs5RNUxY1zmFZvvl1B3/tLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726127179; c=relaxed/simple;
	bh=b+LbfcSP3fwjQ9A009127xkFp3fLiZ6F2Jz11T2JlJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7DzeIDkBycURnqDo5ACLX8HbAPKy1Tohg+t66xcdseLS2Q9zzocBi29v7K+l4/n6KqwiY8arQXxCcgBvHNPJ6U5MwFPNr93bnWzv3UmlarE6lHg4PuE0mXwWNNdtWQmCXIv7k00KLQHzecb+0Tl0LausT0ZqXgKc33cpwlXWhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EC0C468AFE; Thu, 12 Sep 2024 09:46:13 +0200 (CEST)
Date: Thu, 12 Sep 2024 09:46:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	sagi@grimberg.me
Subject: Re: [PATCHv4 10/10] blk-integrity: improved sg segment mapping
Message-ID: <20240912074613.GA8409@lst.de>
References: <20240911201240.3982856-1-kbusch@meta.com> <20240911201240.3982856-11-kbusch@meta.com> <ZuImbgYqqZzLZkho@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuImbgYqqZzLZkho@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 11, 2024 at 05:23:26PM -0600, Keith Busch wrote:
> On Wed, Sep 11, 2024 at 01:12:40PM -0700, Keith Busch wrote:
> > @@ -102,6 +103,12 @@ int blk_rq_map_integrity_sg(struct request_queue *q, struct bio *bio,
> > +	 */
> > +	BUG_ON(segments > blk_rq_nr_phys_segments(rq));
> 
> Doh, this was mixed up with the copy from blk_rq_map_sg. It should say:
> 
> 	BUG_ON(segments > blk_rq_nr_integrity_segments(rq));
> 
> Question though, blk_rq_map_sg uses WARN and scsi used BUG for this
> check. But if the condition is true, a buffer overrun occured. So BUG,
> right?

That would be my preference, unless we manage to add a error return
condition.  Note that Linus seems to be on his weird anti-BUG crusade
again, though.
