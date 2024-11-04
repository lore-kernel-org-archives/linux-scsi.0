Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D37B18C91D
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 07:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730706104; cv=none; b=oetUKs3waGp1jUqlEp6KZ36tThMAEbEOPrm1xDVjlZkeT969iEQbhpFAvLAlpIszJ9fDj6JqnXvufcNDCQBhaHWgUPLXIavvWF3Bk0LuldiDjH0Se+QFUCy7gEnSxhPoHYVs2Sf6po2CX1/M6iwVe9SSnx+NC8+UuDHVm5Qi7/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730706104; c=relaxed/simple;
	bh=0GzCvqovrsXgUYZjZI8n0l/Kwa/QPAh7TOXhuZU4MUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeO5NwDrddAuUF8W18FIYEfQx28mPiCjKXqxlEwBGXYe42qRK7CuNtxYIVfqQ+xFl7P40QwTIwkm4npLsRRctz18hWYoEm4I9UqVMH+yGBvvuh9r70JWWGRLskp6mrFffVwjnrksMC/31625Qdo1bV86t35YdApRerRoDMEY94k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fpuW3f6v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fpuW3f6v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kEKm6zsRPpkyYoMdSoA44siZ2N6lt7pvDyTwQY4yBAA=; b=fpuW3f6vCGm9Mps0beyeSOoJJU
	lkklFJfNkQvcdT9F2yTaGiA1H6Ho/H41aLMeMNVCy6dHrhHMvrd08B8/sl/GvgtoP7h/j7baCPrh3
	8ZyAwBVDhX+ws3E41u5QvLk4T2NRFHdN06U+R/I3jdzBcbFrJXrN851EQggZv92xp8NWjb/kERw+K
	VQBUUG2HJkDeibgoP7VMMg7dUlG3cEwjKWMz7t7ymfWL+TquD5zkdwFgoijqyVFDVvQbAfkoj3Enc
	q6RP4lnS421WHypaoC1qBV8s8ZHZC1tD3RyPqUn2s1Qg30KZabcNgsq9REnmtz9QNJ2ioP3pf8A7W
	d+cvwcDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t7riW-0000000CsPE-0Wko;
	Mon, 04 Nov 2024 07:41:40 +0000
Date: Sun, 3 Nov 2024 23:41:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Magnus Lindholm <linmag7@gmail.com>,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
Message-ID: <Zyh6tP-eWlABiBG7@infradead.org>
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
 <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
 <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com>
 <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
 <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
 <20241030102549.572751ec@samweis>
 <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
 <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk>
 <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
 <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 31, 2024 at 05:30:31PM +0000, Maciej W. Rozycki wrote:
>  This also means that the ISP_CFG0_1040A check also added in 2.6.9 with 
> <https://lore.kernel.org/r/20040606125825.GE31063@lst.de/> will never 
> match, possibly meaning that this code wasn't actually ever verified with 
> affected 1040A hardware.  This might also explain why a later change made 
> with commit 0888f4c33128 ("[SCSI] qla1280: don't use bitfields for 
> hardware access in isp_config") went unnoticed that changed the semantics 
> of the workaround from keeping bursts unconditionally disabled with the 
> 1040A to making them enabled in the absence of NVRAM.
> 
>  NB comments for the FIFO threshold surely are suspicious too.
> 
>  Christoph can you please have a look into it?  It seems like something 
> you ought to be quite familiar with if not for the passage of time.

Somewhat surprisingly I don't remember that details of a drive by
cleanup 20 years ago :)

So whatever fixes you have based on other implementations are probably
correct.

