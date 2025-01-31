Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2304B155A4D;
	Fri, 31 Jan 2025 07:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738307425; cv=none; b=HVZTHea8R4auM7sWoQ2jppUWNVwFVEFF6aG+6LDmcN6LY8CoFZ8NWlgtfkHJ4K2rX7c7usVG9eCkKjcqeoYrRWmM+RBhiq1b09WhNxiyXqpNKUX7vHbDmLUG0B6Shbg+XfqHcmhT/8ZgrpREFxz+eXg1NQiSdssecZoPaWTWIRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738307425; c=relaxed/simple;
	bh=zmIWHizyd5SqFJk7tosRNY8vrRUsr30E40gNB+nKDcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjOGLkdv+uoeewlm70xVnU3bWH+QVL5b+4gJeGA9UczhP8Iuz6r5hvdgavv6Eu5CC1bF9sAbLbwXhf4BqD9rknTS8cVWCwNcqBquVkJw1GUnipMfHtRpNCu0pUPnWzaXwjdbq+QPdkIXMbWRRKdhcglYFBnNFYKLwI4GyBHOeSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0CkDKDIU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0CkDKDIU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tBztvNpisgEaCWmNhAOX9TlPmv7xeZkW0DZiLAEZMV4=; b=0CkDKDIUB9NmweU9QR5Q2+v0IR
	tyfd5IuHOEg4sySo1IVTZeo02OYz12CDs3WFHExtxrqzrZmLCs+xZbgC+BMcq7+3oGfJeAy447FXj
	UELgqYP/Hw1UKvXJWuv0oaugcz4/UF6n/sFIqBTmBFonLT3HXde8Wizs0JvWP2GtUAKBnjrzyR89Y
	cRqtjyIeTxtx1OvLNjHN9jmdTqEGH/khTog2gP/ZACqQk3v+bCwG0TA3W281t3hfiO2Fd2hQoTqdg
	tn9yr6Tfp/aE9Td32KPPliqE83PeqkMk1EHoQX8CK4Qw0jL/gAuDubZBSvAFpL4+7o8MRRSW3u0fE
	QXr2qQSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tdlAV-0000000A5bb-2MM5;
	Fri, 31 Jan 2025 07:10:23 +0000
Date: Thu, 30 Jan 2025 23:10:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Marc =?iso-8859-1?Q?Aur=E8le?= La France <tsi@tuyoix.net>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] scsi: use GFP_NOIO to avoid circular locking
 dependency
Message-ID: <Z5x3XwERjbtL6LDE@infradead.org>
References: <20250128164700.6d8504c1@fangorn>
 <Z5m-FuU7wJsUoSST@infradead.org>
 <20250129104525.0ae8421e@fangorn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250129104525.0ae8421e@fangorn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 29, 2025 at 10:45:25AM -0500, Rik van Riel wrote:
> On Tue, 28 Jan 2025 21:35:18 -0800
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > GFP_NOFS is never the right thing for block layer allocations.
> > The right thing here is GFP_NOIO which is a superset of GFP_NOFS.
> > Otherwise you could reproduce the same deadlock when using swap
> > instead of a file system to reproduce basically the same deadlock.
> 
> Duh, you are right of course!
> 
> The fixed up patch with GFP_NOIO is below.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
