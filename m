Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E971DB13A;
	Wed, 10 Dec 2025 06:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765349298; cv=none; b=KrkEZWdCreqCagrlko7tXSEvQTeDLiiYwHFE4Btg3HnsOoFjUY+d5yxw5bpRfdelX8EwGYZ9dYcrtH3Ejjckc55/G/Jg4ont/xJVXTQJrCuPOLqHgkfX6W89sOdDnd+1qxYbPlcxooEu8T8b8rg5Xht//cJH3k4G7Y7y+AhXH8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765349298; c=relaxed/simple;
	bh=lRkhyvr837y6BNdI7bnZg0FF7dDuA7tFSOU+jCZ92Pg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eOqScBGC+9ekeiy+HhIqQsAsqXIt9U8vvYXznJ7prXVsveXXqQfUvaKNQewfCdUhE7/OCpMVBrPfpsUhBNppcXnm+GuSe0JE5s7tBeO9UOXZMUVSzkFsAehMfxgvBzoqIwDsAWAx5FFqmIo3QAvDoAadk5lRyNk11tuZB1+Z/20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vP022oew; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vP022oew"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p5F3hIfhfJ+nqXPNqqRHJDehqzqM1e3wq2Ng6+ufFUA=; b=vP022oew9ULL3TqLgnXQMMWmjQ
	ZC7YLOThBIGDyy1IQlF3/OlZ3FVWqljDYGD+ehmhpqOzYDfFzcuJ1+pkJaqEXGMyRHE8geTDQoc9r
	zLi2om69Bu72e9cC5a5S7I5MnksiuPUBFiMBJVU6uAIskU3yNCwpdOA3g0u56u+xDNFCW4nO1eZ40
	4X4G28Uc82oA2TgH49a4T6zFaIf1irS/B2OPMwosQlPh82o0pOmNtj998ibAcYDDCT+zr7eCEzSou
	y3u50bP0u1tH8+gfPhxUrOqAB1r3U8EPO/WIRcw8zF5pa5ge5Hdp4hxQePYHIPK7Um4mryr0VeyI3
	/wVQhFyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTDze-0000000FBIJ-2IW9;
	Wed, 10 Dec 2025 06:48:10 +0000
Date: Tue, 9 Dec 2025 22:48:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Po-Wen Kao <powenkao@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix error handler encryption support
Message-ID: <aTkXqslvwMOz2TUG@infradead.org>
References: <20251208025232.4068621-1-powenkao@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208025232.4068621-1-powenkao@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 08, 2025 at 02:52:21AM +0000, Po-Wen Kao wrote:
> From: Brian Kao <powenkao@google.com>
> 
> The UFS driver utilizes block layer crypto fields, such as
> rq->crypt_keyslot and rq->crypt_ctx, to configure hardware for inline
> encryption. However, the SCSI error handler (EH) reuses the
> Protocol Data Unit (PDU) from the original failing request when issuing
> EH commands (e.g., TEST UNIT READY, START STOP UNIT).
> 
> This can lead to issues if the original request of reused PDU contains
> stale cryptographic configurations, which are not applicable for
> the simple EH commands. These commands should not involve data
> encryption.
> 
> This patch fixes this by checking if the command was submitted by the
> SCSI error handler. If so, it bypasses the cryptographic setup for
> the request, ensuring UTRDs are not inadvertently
> configured with potentially incorrect encryption parameters.

As mentioned last round, why are you even calling into the crypto
code here?  Calling that for a request without a crypt context,
which includes all of them that do not transfer any data makes no
sense to start with.

