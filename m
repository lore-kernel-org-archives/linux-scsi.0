Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A46523746;
	Tue, 25 Jun 2024 14:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719326047; cv=none; b=kdmFIjrUIy8LoXzZLeshbJpMG8/zmxnazOTC/9h8S3OcWcMFn6wX96Oay6hDCxz0beOVWKZQetNhL27SEEnn1nzw4CA0/UnJJP/37wOn9DFt3Y0jCh22tz5ZTLwojdXW4bky7dgsGWFsLcfXPg/myICTCzJOkTRAtir4WPwJAjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719326047; c=relaxed/simple;
	bh=/vR5gzXvpyVoPk6BbLO7bFouZXmuo8RQE+aDWGHclgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uB8srGiPJvFF1jMMxeCllAEfmnyEc3rNAd7V4Fonvh2rt235lQ0cSf5FEOJJwH1b0l0NQ6yEQy/j0g7l+ncJeKQZqiMYdg+JL1pNhT3JGj6lr+lYHLXm6HxBTdbnYUUik6yf9BsTNzuIugYaF+GBSpEchNvS5i6H/0DsyuLzr44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H5jbhO/M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H5jbhO/M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9ciiqiUrvxs5LDFWa8n1PBKBJ+QaIr/6uQvwo2KW0Uk=; b=H5jbhO/M8VR5Gf31Hg7J/NLUmj
	qKMwvPkXzhtAo822FTQv0U+xX7YqPhbAv4QXujMUmvGalmEcZ0/A1xc8CU+hgZxWUjIbcT6H/7u9F
	V3OdLAqxma2cgYIOzFDRas3qzLGlgq1dvksuTZvH/ywtlOqu2k41cKltkmRamTN7GCG+j6FHXbOLD
	Al7UFST1cHTv4owz6dlWYWL8KXDdFNBOTmjfk27dFOIU4O5j7mLWEfBHOaXdtuoRmMk/r7ZG/SYFO
	ZYxACy6BlFVR+x6VaT/uLcyEUbsNWcn3YgXoYJGpgR/jd7hp4EmUMN/EMEVup4cPn1UwQ6BgeW/5M
	y3vVFF4w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM7FB-00000003CPK-3Syn;
	Tue, 25 Jun 2024 14:34:01 +0000
Date: Tue, 25 Jun 2024 07:34:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/7] block: rename BLK_FLAG_MISALIGNED
Message-ID: <ZnrVWfj-p7wDXOUr@infradead.org>
References: <20240625110603.50885-1-hch@lst.de>
 <20240625110603.50885-4-hch@lst.de>
 <c7184755-3e82-44d1-bedf-d1c6f0211f59@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7184755-3e82-44d1-bedf-d1c6f0211f59@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 25, 2024 at 12:24:07PM +0100, John Garry wrote:
> On 25/06/2024 12:05, Christoph Hellwig wrote:
> > @@ -351,7 +351,7 @@ static int blk_validate_limits(struct queue_limits *lim)
> >   	if (lim->alignment_offset) {
> >   		lim->alignment_offset &= (lim->physical_block_size - 1);
> > -		lim->features &= ~BLK_FEAT_MISALIGNED;
> > +		lim->features &= ~BLK_FLAG_MISALIGNED;
> 
> The comment for enum which BLK_FLAG_MISALIGNED is a member of reads
> "internal flags for queue_limits.flags", so it might help to comment why we
> clear in lim->features (if correct to do so).

Or fix that as well.  And probably move to a __bitwise type to make
sparse catch this.

