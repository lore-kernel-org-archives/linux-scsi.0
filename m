Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424FD33D0;
	Fri, 24 May 2024 07:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716537115; cv=none; b=shFCC/GqWBZbB1SaIe98kT9qHmsaKfeXyCRnXtgPnvznz5oGgJyRrsfDOXwt1Vf52Bjg1+dQtZvfOAtAqDHSUidAVXkZS50nEl89QkQTukE6hbxmYfAIX65OckRl9zLxC/Jpk/nQT6cTOFhA0cC0fHAhZmXV22hRfSReY5npSb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716537115; c=relaxed/simple;
	bh=qurPS/s1ozPWn2d8uCxvYWrNCjvL62Ex7+ncYgDCkus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FwmcvQR+OWNxFXrgW3kenyxKwDncboKViBomZ4mZ+Dmiw4U7ctYK/NqF0bYE540TXEGIYJW99DAFKzcnvIXCEjj5IMePvdIRsG5HF/t8dUbbRbkOmq/ay2wXFu93VQm7+2iyyEY0BMJjjk+9LT9H8sEUHvReifNCBCgEZf/RE7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6661068B05; Fri, 24 May 2024 09:51:50 +0200 (CEST)
Date: Fri, 24 May 2024 09:51:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] sd: also set max_user_sectors when setting
 max_sectors
Message-ID: <20240524075150.GA18024@lst.de>
References: <20240523182618.602003-1-hch@lst.de> <20240523182618.602003-2-hch@lst.de> <yq1o78wjrsw.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1o78wjrsw.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 23, 2024 at 02:53:40PM -0400, Martin K. Petersen wrote:
> 
> Christoph,
> 
> > sd can set a max_sectors value that is lower than the max_hw_sectors
> > limit based on the block limits VPD page.   While this is rather
> > unusual,
> 
> It's not particularly unusual. Virtually all arrays have a much smaller
> stripe or cache line size than what the average HBA can handle in one
> transfer. Using the device's preferred I/O size to configure max_sectors
> made a substantial difference performance-wise.

Well, in terms of Linux it is weird in that drivers weren't ever supposed
to set max_sectors directly but only provide max_hw_sectors (although
nbd also decreases it and rbd increases it in odd ways).  Especially
as we already have an opt_in limit for the optimal size.

I'll find a way to sort it out and build a grand unified and somewhat
coherent theory out of it..

