Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A02E3219F;
	Tue, 25 Jun 2024 14:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719326098; cv=none; b=KgQ8a0LSVvRcCpmh3HgMvqq5oTKKNbdxeZDefQvGAOIPqYwugpl2DQQfQgncokhe3SsffW8BJ7pIdaqPiJEQNwxcsT1CkRb3unelAu3CA3xKgioPk4O6A85eJkqZez6AxxX11rtRrWSymrpz2CbI1AjplLFrSifMkDVkDsFcd8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719326098; c=relaxed/simple;
	bh=sjcg5oheb96XbyNA3n+2Eu59CvtKaUIZM3e0v1a3VwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FA1vTbWPCDSeXk/FjJ5DmwjVKDPTylY0SXb8czNXhc/bNEeViHWC3CfS9ZkOJHnJO59FvS7gkMqvCdIET0g9C/iTpkE7Qx2PRmyRkv+Mlf1vOyNobXqj60d1/gvikB460NDxTp1Zo98zMVtZA9ldSgbT3NUzp12OPsQVuOJo/KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sfTRFWRN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sfTRFWRN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rTOMkVR0lzd1GL0VA8NMM+4rqSDYk+4Clj5YedNUa0s=; b=sfTRFWRNifLp8Kd2STLN+nJPsJ
	sb2Tza1SrXoItNdh+tCtqaSRfZrAN6GrJdXEUct18DC7NylNPA9FY/Q2r1ZRfz8oQnmcW7UMfSi8i
	tyhqjtSeRq19NueJcM1tB+jDz498PIIjLT3GgWRP1NUhFq4eEWIODmt2wA0HrAgUSJdsGqIuYC0KZ
	+vAGzLaINzJP4kN+ihoJPp23xNqRC1SgVkJts7BXTgQjiBhGPXE2CtcxX3oDx0KemeeAOYSMGLWJA
	8bpHIqFbn0YRRKGvvl2pKTyrYQSUzujpc7SPYl+Kua9MymvoYvV9GYe09eZ/xw1QJdvG6oXPJiZcQ
	G46l+f7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM7Fy-00000003CZs-0Ys7;
	Tue, 25 Jun 2024 14:34:50 +0000
Date: Tue, 25 Jun 2024 07:34:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 6/7] block: remove the fallback case in
 queue_dma_alignment
Message-ID: <ZnrVio4kVd1NpHsF@infradead.org>
References: <20240625110603.50885-1-hch@lst.de>
 <20240625110603.50885-7-hch@lst.de>
 <7b800a42-e3cb-4c1c-9a29-74907fcb2c8b@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b800a42-e3cb-4c1c-9a29-74907fcb2c8b@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 25, 2024 at 01:03:19PM +0100, John Garry wrote:
> On 25/06/2024 12:05, Christoph Hellwig wrote:
> > Now that all updates go through blk_validate_limits the default of 511
> > is set at initialization time.
> 
> The code handles q == NULL case, so is q == NULL now impossible?

No caller ever passed a NULL q in. But yes, this could use a sentence
in the commit log.

