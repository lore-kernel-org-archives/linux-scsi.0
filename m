Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45000356A08;
	Mon,  6 Apr 2026 06:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775457394; cv=none; b=OLfszdDn+UbZZoqPfDBatmOJF4TTIZG+V5FTMIU5EECLPItB4MnGkful7lB5u++DonmJyNBvxS/wSU1Rdwnv2aXIvhhhVZn/Y7VJ2nXyvOmv5g8c9SxYKgNxo46LLWz4nMz0r4C6RdKA/xmtjNnX1u1g87u+pdZiV4RMkSEFKnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775457394; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxcdALBPnrgtVDy7nDihk4nlgoiHPKr2cXdgwtUQGMrUVeWTrmj9d26hqSS74IuwMM9Er69bsXZgDItkPE3GJAMe5VPJzmJN9vA/Y8hB+sDmDK1eabEuU09V2fhc9jYKCw3F69kAJkb48qhqfP4nDPPdgxGfaGhkbjwF3WRrvhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QLuoB57d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QLuoB57d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QLuoB57dHy1kF5hImdfbXL/MLr
	WniD/IeCFmqShWSZ6hbf1FuN/eqHaKOU/I0WJ4Hws4eCzah+Z8MPmRebjjgO6aWgxraj1NIXJzIQI
	c/1zs6ctbGaGnaH8Sjs1QwwMmG8ZDWoCjL99KMlRHRUAOAoKrO74NoQItE0c6s/P5vhZxJE5HKxCQ
	NNL4fCt0Spt0Bjq3wJklM1JWowMqt60pJgfSsMFvRrYIOKKpAOHU1ahIOxqWxfYWbxWnxUEGmhXr8
	PNH6Z3GzaB/Q2EdcUmayyO8IMkeGzG8pAktt3T4fKx2BdF7A/J3oMMhy4OPXAbBnyQmup/va/I5e9
	xePScajA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9dZX-00000004qwh-2H8N;
	Mon, 06 Apr 2026 06:36:31 +0000
Date: Sun, 5 Apr 2026 23:36:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: Re: [PATCH 4/6] bio-integrity-fs: use integrity interval instead of
 sector as seed
Message-ID: <adNUby8NxCpHlr3Y@infradead.org>
References: <20260403194109.2255933-1-csander@purestorage.com>
 <20260403194109.2255933-5-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403194109.2255933-5-csander@purestorage.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
