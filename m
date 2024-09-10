Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F54191F9B;
	Tue, 10 Sep 2024 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725983329; cv=none; b=pN9COpFkVeVHu+BFQTE/EzEMlq3bn6iuKHb6H/B2hDZCChyJ8ltBpkFNuJhCnG9YTdQYM6IsduQj1ADIpktqCV/JXu2JvnujcCS2nm2H0G0sHAXxCZCzr2WzGMn1X3dRfLkllYBkkjszIMzAcVtmr0dI1hnYFRKOGtREcQ5diHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725983329; c=relaxed/simple;
	bh=tYS5dZ1b5d0Y0eopKjZQOewhnWeePLSlndr7LgQAHzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6LhF7SOlyoaudWHGveT3YD39y3GU/tivGIVHsATjQWGlvrWUVNVNqtR1YtW4rNKHWeHhGsBXtPSGPpNoDyGn4Nspy53Z72kdq8yFJcTmLbF4kLFwH/REzgpDLQBFKecT5GKza0D9GsKOBTDq2Vf93zVaF/E2s8bATwiiMB8ZRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1AA3068AFE; Tue, 10 Sep 2024 17:48:44 +0200 (CEST)
Date: Tue, 10 Sep 2024 17:48:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 09/10] blk-integrity: consider entire bio list for
 merging
Message-ID: <20240910154843.GI23805@lst.de>
References: <20240904152605.4055570-1-kbusch@meta.com> <20240904152605.4055570-10-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904152605.4055570-10-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 04, 2024 at 08:26:04AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> If a bio is merged to a req, the entire bio list is merged, so don't
> temporarily unchain it when counting segments for consideration.

As far as I can tell we never do merge decisions on bio lists.  If
bi_next is non-NULL here it probably is due to scheduler lists or
something like it.

