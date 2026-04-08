Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC2B1A683C;
	Wed,  8 Apr 2026 05:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775625023; cv=none; b=qPD24YDSPm/11cuHodoiwnNzEkBrnZz2xx7y02HOpVBHSZZCqNjbVSYQdFxuuIzPlw590AR69IBAnBJ3qwkYRqpkl2Vnu4KfDKLfNxatY8ONIeNHPPHXHCeqCGLn+C+e2uF2ViCMUoEjHGeSS5gOg6cwoDKc6vg+hURcrSb2zDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775625023; c=relaxed/simple;
	bh=KyU2yJR9V/uUR9MwJTA9doEM3RTgBTYUaHwHPzvWfpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlcqNOYY8wblrkM1HdY7QywoYDF+sKdYIT/qo90lHx4D9GUtVrbioi4HB3LM/J6Fc+K9c7MJruv4zNybvjwIi4kEj5GAOKjddWgY3q1iZjqFA1/fA7G9V/54MzLyYIgfrR3K2dg7iUgWWGcXav4FxVT0h8RelTfQiv6BxOiARP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aKRH8jvX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aKRH8jvX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=FGVZvsJ7+aFUi9R2AonAN1Szz4uf3rqKeEpjoICbM3I=; b=aKRH8jvXvX1teD1XeQODhCogn1
	IkV6DyseyZRbC8aIwAjUzBwg1X9sch2mrOXvKkdJX1o/rmwK6gqTgqIMn1mrwJzNBIVFyhBAKqXNc
	8agURruUzK/tbbRO6Bdyfr9+7nvhcx4tY2EjH/MtJqxTwkRAjT9JqRyUd1EEJbfhaygRoLLOuFX2s
	cwTrJM3i85pkYTJuvPhmHSZA81ot5LOLzIbe4QQa3qAPz+ZH7hKzxuFcvNcCgifQkFqpVNBLZESEu
	F+tqxWBMBmJzgIBtYIdpHDbCUJ2ubk+Sj51npE0LeBiHPZm739OAdvYNbPOWwVEe1i0i6P1lAxzEm
	mZdAfNIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wALBD-00000008GxA-3rp7;
	Wed, 08 Apr 2026 05:10:19 +0000
Date: Tue, 7 Apr 2026 22:10:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: Re: [PATCH 2/6] block: use integrity interval instead of sector as
 seed
Message-ID: <adXjO5y6tLLVz77C@infradead.org>
References: <20260403194109.2255933-1-csander@purestorage.com>
 <20260403194109.2255933-3-csander@purestorage.com>
 <adNUE67FpIGF_x7Q@infradead.org>
 <CADUfDZqHyTDO6aYed+mtChU9m3iPgW=hghwfifuCV8Z_CzxoFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZqHyTDO6aYed+mtChU9m3iPgW=hghwfifuCV8Z_CzxoFQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 07, 2026 at 09:48:52AM -0700, Caleb Sander Mateos wrote:
> On Sun, Apr 5, 2026 at 11:35 PM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Fri, Apr 03, 2026 at 01:41:05PM -0600, Caleb Sander Mateos wrote:
> > >  void bio_integrity_setup_default(struct bio *bio)
> > >  {
> > >       struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
> > >       struct bio_integrity_payload *bip = bio_integrity(bio);
> > >
> > > -     bip_set_seed(bip, bio->bi_iter.bi_sector);
> > > +     bip_set_seed(bip, bio_integrity_intervals(bi, bio->bi_iter.bi_sector));
> >
> > Should we simply switch bip_set_seed to take a bio bvec_iter argument and
> > lift all this logic into it?  That feels a lot less fragile.
> 
> Perhaps I'm misunderstanding the suggestion, but how would that work
> for initializing the seed from struct uio_meta in
> bio_integrity_map_iter()?
> 
> bip_set_seed(bio_integrity(bio), meta->seed);

Just open code the assignment there as the code must be build with
blk-integrityu support?

