Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B308D26CE0F
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 06:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753252004; cv=none; b=i6wG+t52rH7yNiWRNrNd/4iAHNRaD11Az6fgc1AKgaLLi63snitep/qEiO4nGkwhoB4ZhOauq692d/rRI1uUmNrNFBqn/Tu+rmchzMOjiRINc18hCPf/VBQ2nZMWnYixil5dXlRxcQTvyh7zry+rXBXPdMwB1Yd0lrSIi0jhExE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753252004; c=relaxed/simple;
	bh=/NMg7DM5UitJCVu2bvOxgz7gTGiQqQFWWH2wRdSudPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IOjZzxqh7yYzG29iYxGljrmHuPO8maZ4Xj6v+dHNUbGPb+Y77zSrDvfOp5kl8nkh2u9qCP5ITdIEKrZhZMse95qKjJ7Zo/cWB3vuhq8TuoyM7Skc3wio8zgemGvh/Zrn/IgHPvZ6EMzUlcegb2WXZgiQkJpC+kxNqvkoMfSrG/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uE/JJJ4d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uE/JJJ4d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0SBtB4ajOv/fS7+1NNPdoc4A+iqhHyprYgRzl7wHdb8=; b=uE/JJJ4dYWBVsooNBTigjP35i4
	aPq4CEnbych06QbGu053si95Cd4I53Rtdtq/OuYjjhoO3IQQxX3wAGkEVy8ullVdHcQUfwSMt58Yd
	Wm02vUbXhMB1JSZK66nghuLdFHJmF1gHYOsThQRyGm1PEMUoMpqZSj6xEHeuLtyEVgem0F/QSiC0R
	iGqcsOg6rrqWV0akvATtCk2EAwnh0akv+0NFDO6I9UA7fhoqtgFa59vnu0SQiUQViWibr0yPnific
	FebCx1leUb2fpkYygDhcmumhYbm24CQwRUUJoqhs25kjlkUpnAUNHsnf4Gi0WKFwJ46oJWrcx/qKI
	pOL+rPQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueSw6-000000048NZ-0k9y;
	Wed, 23 Jul 2025 06:26:42 +0000
Date: Tue, 22 Jul 2025 23:26:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v1] mpt3sas: Set DMA_BIDIRECTIONAL for additional SCSI
 commands
Message-ID: <aICAoqAYPsy2ErLg@infradead.org>
References: <20250721110546.100355-1-ranjan.kumar@broadcom.com>
 <aH8oUpyOhTlo-sZc@infradead.org>
 <CAFdVvOx2RCtwc2H-K=QOQ+fG2=5s-TN4oOd0qJsCXvzfOpM69g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFdVvOx2RCtwc2H-K=QOQ+fG2=5s-TN4oOd0qJsCXvzfOpM69g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 22, 2025 at 09:06:10AM -0600, Sathya Prakash Veerichetty wrote:
> There is a resource issue which prevents SATL from doing double
> buffering and RMW of the contents to map the data from SATA drives to
> the host buffers for the specific commands.  Our firmware changes
> leads to performance and functional issues, So we are left with either
> failing those commands in the driver or changing the mapping, We
> decided to go with changing the DMA mapping as we know those commands
> require both read/write access to the buffers.
> Any functional issue of changing the DMA mapping?

Well, we have to change the mapping to make your broken hardware work.
But these kinds of hacks in firmware are really problematic.  When an
application does a passthrough of a SCSI command it can very much
expect that the payload is not changed by a call to SG_IO, and this
breaks it.

