Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FDD4B95D2;
	Wed,  7 Oct 2026 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791386900; cv=none; b=BjBDE/ZuRWhtTtvYXYwDArq7OhNS3R8isfTebzr3Wd03OxbmSkhSKyRN0NHkjXFWAiRKeRUvT27JvJK/6OxmxlH+WCa1uD+vgSTpNqnfTR3aSfhEHo6KxRZBWukc2V5m7MFkWEKpoY9JcMpgFb1Yu4u3wX4hTu4LSfpyULdtjWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791386900; c=relaxed/simple;
	bh=Z0X/5MuDO4O6Ru409BZr22KTPo7lPVJOcbmclQN/eQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WK/c9dYFF6D99D6zdk4HghOn+4mcBOUXavMfD+0unn0HZQTCr+tjcKl5BiO49oJjLpaSADyeU6Km9d3SJsy22hERLpi+b7Hf+Wc5xCgOZzjYXuKCDCZAmT4ujseqjCGkK95poWjWBIWmWUZTOb/qRYD5b8Yz9g18/v0JH/VjvXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 95D7268AFE; Wed,  7 Oct 2026 17:28:11 +0200 (CEST)
Date: Wed, 7 Oct 2026 17:28:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 3/7] block: add storage element management ioctls
Message-ID: <20261007152811.GA8435@lst.de>
References: <20261007082344.1049179-1-dlemoal@kernel.org> <20261007082344.1049179-4-dlemoal@kernel.org> <20261007133922.GC31906@lst.de> <e11de48b-e719-4cfc-a08d-916a8603782d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e11de48b-e719-4cfc-a08d-916a8603782d@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 07, 2026 at 04:37:49PM +0200, Damien Le Moal wrote:
> >> +	elements = kzalloc_objs(struct blk_storage_element, nr_elements);
> > 
> > This doesn't work as it could race.  We'll always need to allocate
> > the space for all the elements the user asked for?
> 
> I am not following... The number of elements of a drive never changes, and that
> is what nr_elements indicates. So getting the min with the user indicated value
> still gives all elements, and that also creates a bound in case we get a crazy
> large value from the user.

The explicitly pass the bound in.  Or have it struct gendisk as a
fixed value.

