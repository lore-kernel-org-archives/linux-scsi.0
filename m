Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A13C2C18A;
	Tue, 29 Jul 2025 07:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753774369; cv=none; b=FROnpzNHLxdwQDlLvwb+tXtTbAtYis6NuwtMWvCExDCWbJHETpILGzOl/jS5Bi16uvB/eT5xT0IsO5mL3KIB8lrC1dGI2Lp8JhlYTQiZlGg4xQt6GGYcwKo5O4RY/FODYBlRFTcjYEzBZH3tVQ1Eh9gFNjlyE4COlwe/E3qg7ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753774369; c=relaxed/simple;
	bh=gu9Vfn3Xnc+YB01hXHBmYpL8Kd8tfPplc9en4o/NvuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SyJVfQRIoclQxqJItDLtt4tU75p3s2A3ulXkWKhR+g/H3YZuspRtEfzoQWBU6GYVQ5fPe1XkpJKjf6PwNqoevKBwDSEKX5KsOzXGS6V5j674+lcVe0k/YFgWvnTxNQ3jL2TekizofuW3tAYr0n1PQsX107EceuNPGTchICKYfrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p13g40gx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p13g40gx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0MWTGeSb5WN5PjPAy3ePZECj7+qyiS1J4g1426SAwvo=; b=p13g40gx2oUQ/u2Q9UTlFvBkCu
	m0+03OcSXYkp6ifGSOcWs1wzFuuFZ5iKZAssEqubxTLtQ4Vl8mXROf4Lo9lwje/kAdyVUJK9Z5ras
	XyiGR+QpY6eifpRmvkHZhAqnm2nNUFgm2HIRPpwZnHnQwgPrNfK7hLJZ6IlCALmz5B95JLuMswaxE
	BZZAHBegMxMtymRX5zoGMEw4EnMqE3+w+rxObpMT+7OYGX5WM4amSWY44BzQno3jivTkG98mTQ9Ao
	jpVW4oU+M7pkyGFTn4L4ADkLaFAzEKUXfSPHmaVFxXvBPiMN1o6wy2OjUg/YE1yqexu40hx7yTbVi
	+5LUOE+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ugepJ-0000000G7wq-2svP;
	Tue, 29 Jul 2025 07:32:45 +0000
Date: Tue, 29 Jul 2025 00:32:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Magnus Lindholm <linmag7@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-alpha@vger.kernel.org, martin.petersen@oracle.com,
	James.Bottomley@hansenpartnership.com, hch@infradead.org,
	macro@orcam.me.uk
Subject: Re: [PATCH 1/1] scsi: qla1280: Make 64-bit DMA addressing a Kconfig
 option
Message-ID: <aIh5HY1nVGusQ9Yb@infradead.org>
References: <20250728163752.9778-1-linmag7@gmail.com>
 <20250728163752.9778-2-linmag7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728163752.9778-2-linmag7@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 28, 2025 at 06:34:14PM +0200, Magnus Lindholm wrote:
> Make 64-bit DMA addressing a Kconfig option.
> 
> While defaulting to 64-bit addressing, this gives the user the option
> to revert to 32-bits when necessary without messing with the kernel
> source. The Kconfig help text also points out the issues with tsunami
> based alphas with more than 2GB RAM and 32-bit PCI Qlogic SCSI
> controllers.

Compile time options like this are annoying as they require
distributions to pick a default.  Why not at least a module option
even if it just a workaround?
