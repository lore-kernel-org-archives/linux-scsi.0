Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E18A14885D;
	Thu, 31 Jul 2025 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753971866; cv=none; b=poOAQGwIi5ErdkHw1g4YdwXOkNw7JRBPuwbCp9XHwRPGjbrsmWMz7olDed/xvdbrPUEPhaVHkoWNIlW0oXI9ZU/FC30pTjZE8A86JgtKraLaagxWmPl//06HGYP407NH+rldTPiqkBmjK/jikXGwW5kIJr+JhHg/qgxmOj64uDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753971866; c=relaxed/simple;
	bh=NnD75Ujp3G/TbxqafNqnap7QmOy7eTehmQZP6bmHfqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIMyyn3yA4rxOklLuk7rAT3QNG1DV2EdTKjNeucKjglQOIAD+O3Ip5IcbF0hlyj1aDlHjkSdtRSNu5z6MtrSa8kQ173m2AW9yQRfx5EUxPkj12oaxPTtHO2S7/qzEWSfp+oUsI8tuq3DZ3nf3Z+P9sV4bVP0Aa273WM+tYWUmy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mmtd6I12; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mmtd6I12"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m+2A9w+aUv0ZDr6hyfhfJ9HUaAAeP1mYbGPx8VhkZ6U=; b=Mmtd6I12WJKczi2mR7i+xITNFM
	sOfWaZUgUz3JFXpZNwsbRLs1hhExh5YzY91cqHMoWPoeqGRHyRBM9tT3vue1c5m1lF8pGgDNaM6rP
	ubfo8sSOAbrlHFxsaX02k0svRGz6fvacssSXM6ok7m1/8qxnyZEwn7EPf8CnJfy20SZgd/HPj4SAr
	4vhUuKI8KHFZcsBZYx2POSv4GCYe/YaXtCDCTV3LOjcobIV8aZyEKGhJhCJxtGVucTJp2jhWLyO+h
	S6BOmnt96+A3t8zh7R0CoCHCN6PhILaZ/57EDI0AazF8K4EpzDigUJFgFV1RhpLavdsPdnTl3dWwY
	nB/bHQhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uhUCh-00000003p9x-3wsg;
	Thu, 31 Jul 2025 14:24:19 +0000
Date: Thu, 31 Jul 2025 07:24:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Xiang Gao <gxxa03070307@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	jaegeuk@kernel.org, chao@kernel.org, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org, peter.wang@mediatek.com,
	beanhuo@micron.com, mani@kernel.org, quic_nguyenb@quicinc.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH] fs: export some tracepoints for iotrace
Message-ID: <aIt8kzlJ2sW7nKir@infradead.org>
References: <20250729160345.3420908-1-gxxa03070307@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729160345.3420908-1-gxxa03070307@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 30, 2025 at 12:03:45AM +0800, Xiang Gao wrote:
> From: gaoxiang17 <gaoxiang17@xiaomi.com>
> 
> Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>

Random exports without a user of even explanation are weird.

What up with Android folks that this kind of junk keeps getting sent
over and over?

