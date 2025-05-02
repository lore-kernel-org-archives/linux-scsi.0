Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154C526657E;
	Fri,  2 May 2025 06:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746168650; cv=none; b=apyfeGCdeJ3d6+9ib7T/Mv/bpDACV+mSOgJ/xjvfR/0afAPhpZjDqSoG0eL9KslLGkDZhA8NKW+AMOi6JAihER4sUJ/+VsRR2DBtivCUnNrB71QMKsprSbMujZbMZxApGb/5YblDR7sK4rckseffYRh3rtKqSzcYe/iynFXs6AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746168650; c=relaxed/simple;
	bh=vXLNV6WspfQ7oFQZ2UIkX9Giwg80lspubwes2xQvt2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PT2v4RyvWP/VU3G2bMAppT92OqcPZhz2DGgeSa2vfdNv6C5wejmk+ReQzuxbaykOmca+lUX+R/EhpvtDArmHoV+NRI6krpZiK6BQS3MEWyeVhVCqwAljntCvVqP15Hsh2+MM6Z4M/PnIuboPJWzHy9ojoMkRbg+qkNz8TxR53Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jtw99QA4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jtw99QA4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vXLNV6WspfQ7oFQZ2UIkX9Giwg80lspubwes2xQvt2Y=; b=Jtw99QA4W80UI/TJn2dVHgpk3Z
	Ae7o6okfckpsSuoByc+zX3HiPECpizk7Z17hn+NRzfpZjR5QpUaPLR2vdVnUFJ8iMkhZCISzi3npb
	gBkqdTikMp4ggSkYuj7NCIoml39obS7+8TGdWctFZewQwtjeBGGzmesiSejZv3gm0YiNrta0bx1XP
	ZEdChUVMduyL57l3mx2fgISej69vwl8jn8Il3xcSYX6aSNol3o0NDldKoYO/kXPMHAN5d67X4p379
	INsWDvAu8OFlmVVdP0HvQJSf5bcAyTdNtO01v5gsZGKFhUuySAQHZDzLAN00WUlmb6dSc0ppGdtzq
	t4rBrMaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAkEJ-000000011Nw-2WMz;
	Fri, 02 May 2025 06:50:39 +0000
Date: Thu, 1 May 2025 23:50:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2][next] scsi: sd: Avoid -Wflex-array-member-not-at-end
 warning
Message-ID: <aBRrP8EuNkeAtPC9@infradead.org>
References: <aBO_32OsMj3hsJsv@kspp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBO_32OsMj3hsJsv@kspp>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I actually send a patch for this yesterday, also keeping the proto
test that actually still works despite my initial overreaching removal.
(I still wish we'd kill the stupid struct and this test and just used
the simpler and cleaner bitshifting and masking)

