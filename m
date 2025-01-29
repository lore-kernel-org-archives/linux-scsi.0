Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BF733987;
	Wed, 29 Jan 2025 05:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738128921; cv=none; b=TvSouHNN5u2LJSXz93pJl3pdjiyEnNlh5Z1AhBLp89vUMKq9eFl7s0BpWse0QcDRBZUvUsAanvh74pMVgnYT1TC02l3G/3lBMdJDpqcFRuU8O2u/DMBJoxtRUTpjOw+UxesX09R9pMQwnVi9dcqid6aljSExbhz4IvI8nJhSPy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738128921; c=relaxed/simple;
	bh=2I97VhuMPk6McX+OnR9iNvG6huT8hz5DRHZjOVZ667o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YcvOj8PI0r4wFf48lkxlJ6ho5R7CuBg+6K/4Z4YysSIJnflsrHwfIxn2pRcM14QJvayNi3QyXhqY+BGSlkN0SvlNW0wGqR78aWIasT5kU1lNilJdh8rMVYbWdQI00rwT2KH+2E39Mak4AWqtyTBIafJpLzF0rVCjw4W5mBLVWfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=19xPbi69; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="19xPbi69"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4tSY5YHB1CMzJLN7f2bF8+o2Ug0EXUU/zLwwCnIyOo0=; b=19xPbi69m7gDfZeHfHUZgczwMk
	Zc7Ll0XtDubaCm+S0YiNG/K0kzDVGUDxIxb7Te5Wn5vaP59J0w6d01fYKg5dkfhPg6r1VP/wXwts8
	xtbtE3bcfzL6cCr15RndeIJvo1W1pPXjHaZzhsQYMdrmcALnXKOPePZ/uVmeSc9PfSsEyUKAeUGdv
	MzED77mRfVkSyzs6eh/jeW9VKjnLuPkjlPcPDEPfNeqZFiajHLgVki+fW1uYn+R0DNQ2gpQ0grTz6
	vODJAEGGaTvF/WRvgPuFAttL40yIvzxbkpHP3tMXBzMUH2KR5+NCKsbC6eY1FJ9vxI89ydwy/V5TG
	aRNb0Zlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1td0jO-00000006MCe-05p9;
	Wed, 29 Jan 2025 05:35:18 +0000
Date: Tue, 28 Jan 2025 21:35:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Marc =?iso-8859-1?Q?Aur=E8le?= La France <tsi@tuyoix.net>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] scsi: use GFP_NOFS to avoid circular locking dependency
Message-ID: <Z5m-FuU7wJsUoSST@infradead.org>
References: <20250128164700.6d8504c1@fangorn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128164700.6d8504c1@fangorn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

GFP_NOFS is never the right thing for block layer allocations.
The right thing here is GFP_NOIO which is a superset of GFP_NOFS.
Otherwise you could reproduce the same deadlock when using swap
instead of a file system to reproduce basically the same deadlock.

Note that this:

https://lore.kernel.org/linux-block/20250117074442.256705-3-hch@lst.de/T/#u

should probably fix the actual deadlock, but it might still need
annotations for lockdep to deal with the initial probing where
the queue is not frozen.  Compared to hacky annotations just using
GFP_NOIO feels simpler and more obvious.

