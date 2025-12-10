Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A44823AB90;
	Wed, 10 Dec 2025 15:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765379595; cv=none; b=Yl55U+pRJL1LCsl2k+2mF9EYBUhnNv+3mYkWPXDRBhhXDE/ZrDKDC57kZwtryr5fSrgvg0XVPfLjI00V8rkOhWxN3Y7aiWSmAyMyoHhNIm8gprdKaBwGhqur8DFnxt3Ave3aj2YQ+dfNoN/Beh0P2f7m4eKlVR+ftrgeIdOugBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765379595; c=relaxed/simple;
	bh=SkL5q18FeJf+HoWFG3q+JZsCZp8WtPDMibjSfslAwXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fnKjN7+CVLoYI2FK/pOjawbcHomsiyU1lbGacfF5/5dTkSxTsgaUtEqFkcgMD4D92lbmwsO6X/RKRZrPQ7A2U5/wP0i7m7EREy4nbZiAlW9E9GsJAIyiQIyKTk3VrhqbTtqAS2qhMoLxKLK199niIAFvT4FqtODbK9rsKXbrons=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O7uzpnu3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O7uzpnu3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SkL5q18FeJf+HoWFG3q+JZsCZp8WtPDMibjSfslAwXk=; b=O7uzpnu3M7qCGf+GoK54lK1GHj
	SG9njwuRXumLZT1UBoj4AcGVVTeZvg4T+Z5VsirKH81w9U2g8cGr1bz+1j8GGtZPQh1I+cwnTyB6b
	fScYjZ7Cv356/hWaiDFy1VIEjJR8r7+mUlyltL0SoiG5Qr+AZ8Ehlqim7ZsDKb01RbPyqlhiIO5n/
	MMQNpnd4JBDtljBWdmqUWZu92l1ausHxZmf/bXdS2zk6BQWigOySIoHUp7e4h71dSgiXx2vz0NliO
	oGhrHHEo2vMiua7fS5jE0Zl1/rNJ4QGBfL72znqNW1LJZ3cEq+9g7bvfmYkHs5HRKdjHoIjp6NrE3
	K0DSSIwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTLsO-0000000FY0H-02RE;
	Wed, 10 Dec 2025 15:13:12 +0000
Date: Wed, 10 Dec 2025 07:13:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pmcraid: Replace cpu_to_be64 + le64_to_cpu with
 swab64
Message-ID: <aTmOB6-uRMV4BT1H@infradead.org>
References: <20251210143322.596158-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210143322.596158-1-thorsten.blum@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 10, 2025 at 03:33:21PM +0100, Thorsten Blum wrote:
> Replace cpu_to_be64(le64_to_cpu()) with swab64() to simplify
> pmcraid_prepare_cancel_cmd().

How does this not break the __le64/__be64 annotation checking?

