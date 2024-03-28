Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613BF3FB91;
	Thu, 28 Mar 2024 04:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711601327; cv=none; b=T9vp3eXOTvj95WAeSFUCAISUYBl5rL2D2KHac2Va3xBB2YtZCyhR9JyQ2O9UsHlExdneIx6uUp2QhO0b5g4RkUDvyUCBL6j5/gQ7eelYSYbuWAimuEVR9seXkfy38J7cCEmCbEFyiN+wukf3FdXj75v803lewgYaoTs40laCem4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711601327; c=relaxed/simple;
	bh=P/EVXY7Uim9G2AZ7BzTBoJxMIxLOnBCRLoHziGRj1f8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p4BHSDq5CRaZe08Wzav0FwfRG9BOsL5bAJERuN4dNy44TCaSiwfq5DxcnKvyQEUlgLJ0Q2w68XAk6FMM0qnD/6IAWUIb2td056Nd+/DlhUd/MocasI9vRPGVQ6MggjQpO3kCLTPKfOqtNeMG81gxeOb2YFs0XtgKRKFizdnGH/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D9F668B05; Thu, 28 Mar 2024 05:48:41 +0100 (CET)
Date: Thu, 28 Mar 2024 05:48:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 08/30] block: Introduce zone write plugging
Message-ID: <20240328044841.GA14113@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-9-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328004409.594888-9-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +	spin_lock_irqsave(&zwplug->lock, flags);
> +	while (zwplug->wp_offset < zone_capacity &&
> +	       (bio = bio_list_peek(&zwplug->bio_list))) {

Nit: I find this mix of a comparism and a combined assignment / NULL
check just a bit too dense.  I'd move one them out of the loop condition
and to use a separate break to make things a little easier to digest.

Otherwise this looks good modulo the freelist discissoon in the
next patch.
