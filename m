Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E437A2DCBF8;
	Wed, 19 Nov 2025 08:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763541085; cv=none; b=JrQlQM72svDpTyKN5F7jBOAihvz/IGQ/edNSVthd/RXsrc44J2MhaS8iaCN2xSi/N5Uyj4QaR6F1flXFFcm9DT5+Iy56Ak2GneIsOpx+mlAsK1rL6+TjCTSKUpRYF1Wjji0fRgq+kDf9fBFZlxz48hGEMLTIoAnedn8GJIkL2z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763541085; c=relaxed/simple;
	bh=T5DxWiQHbbjkLaa6LEYEoku+RsGntGjGAOg7JmoxK8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mFP0BoFVVaGZjgx1AOxmVWvO/zHOgOrEHARva9F4atwky80e9tJWU+Pnt9TQLPyeC8jPiPajCivmRQW8YNRbMgccYsE1XlqF3xC5UxVk1Vm1rqm1cxEO0XrQQ545cUx0I2u78YaXsykhUZScXoUMaCn4qlMdePKU1Uk+0E4o4mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LgBx2vH/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LgBx2vH/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T5DxWiQHbbjkLaa6LEYEoku+RsGntGjGAOg7JmoxK8s=; b=LgBx2vH/kSHf6LoIGp11WLIN3f
	0tpwDmXPndVgLW+3zKS6l+Et7uEDWOT+QHcIqRv5XJP3pge7MJB5keay3HyRpH4/lBduTYcXoJit2
	RknzrOPqvrdg82R0I5Xrl7x4UqesrotJh8kP3GFrd34JWJuQnDNWpVx85KNRYwqYyQycWZdXdWKwF
	DcnUvnOzvCAXjBk5LMIrmyG7Fs0y0H/LWEfgXMkXiMo15rgelbfnX72na9/axZ5FNlI3NwaIYphNP
	1Qpg0nproxOOkZ4B6SeGQe8neXavBXCblepzogMVc6zskDZWqTUQWUO/HK8WZfNzSrqM2983WsW5M
	V15C3rew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLdb0-00000002nJN-1cws;
	Wed, 19 Nov 2025 08:31:22 +0000
Date: Wed, 19 Nov 2025 00:31:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: ally heev <allyheev@gmail.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix uninitialized pointers with free attr
Message-ID: <aR2AWjHTtCszByqX@infradead.org>
References: <20251105-aheev-uninitialized-free-attr-scsi-v1-1-d28435a0a7ea@gmail.com>
 <6d199d062b16abfbf083750820d7a39cb2ebf144.camel@HansenPartnership.com>
 <f6592ccc-155d-48ba-bac6-6e2b719a5c3e@suswa.mountain>
 <407aed0ff7be4fdcafebd09e58e25496b6b4fec0.camel@HansenPartnership.com>
 <f7f26ae6-31d7-4793-8daa-331622460833@suswa.mountain>
 <bed8636bc4d036f4b2fe532e7bb4bb4b05c059fc.camel@HansenPartnership.com>
 <aRwPcgDXSE9s4jKS@stanley.mountain>
 <9c62ff497aa00bcdf213f579272d3decdd22ea34.camel@HansenPartnership.com>
 <aRyBI_j77mQaQxgT@stanley.mountain>
 <231f839b3b567f16360ad2a24f51add1d40ea575.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <231f839b3b567f16360ad2a24f51add1d40ea575.camel@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 19, 2025 at 12:26:56PM +0530, ally heev wrote:
> As per the ongoing discussion
> https://lore.kernel.org/lkml/58fd478f408a34b578ee8d949c5c4b4da4d4f41d.camel@HansenPartnership.com/
> , I believe there are no changes required here

What about just dropping that __free thing that just make the code
harder to read and more buggy?
