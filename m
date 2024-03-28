Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2698225CF;
	Thu, 28 Mar 2024 06:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711608781; cv=none; b=OBe+hPjJYAs2o/F45wl9BnB4wJ4bFEgDGv7IPo4WVfA1h6dMwaWNUcVKMFtQNrCxXX0CiaaiRRtJL/LK4PveXNRLzGi5L0vWob9nSGyPFfBLamQNBZcCm0AVlaF3CKF3PqI3JqcNUcRkS5KuJoL3Pyk+k6cQDS6Apid9UgpEhQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711608781; c=relaxed/simple;
	bh=IsG7fsolO+VI9XYrUV3KhSni/zrhmJIuPCPtBGvLwK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8+NvY0NqAEc+Npi14KOw6y4dvc6+ptxy3dnD45PPRZe+K7LmGxo+afuqWrKi6j5w3yfqAqBXBuIXQjS4F+wm1J+T5DwBVYU/RVrZlQwr8Z40iCihw6LUODuW/loHaTTQKFTU+H7I/3irDcWGrunxesUvssFg79qRFHCqNdQBCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DA3D268B05; Thu, 28 Mar 2024 07:52:56 +0100 (CET)
Date: Thu, 28 Mar 2024 07:52:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
Message-ID: <20240328065256.GB17890@lst.de>
References: <20240328043016.GA13701@lst.de> <714d0cbc-be4d-4aa9-b200-73c6caaa1d18@kernel.org> <20240328054652.GA16237@lst.de> <7d8f3ec4-c416-445f-92db-7d2b60726821@kernel.org> <20240328060357.GA16819@lst.de> <ca3fe7b0-7e27-4ac9-b669-5263c3cec550@kernel.org> <20240328062237.GA17225@lst.de> <0d54c569-f586-4b75-a8a3-509e3f3717e2@kernel.org> <20240328063816.GA17642@lst.de> <b144a7f1-af29-4c0d-96f7-c0f16b2299b8@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b144a7f1-af29-4c0d-96f7-c0f16b2299b8@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 03:51:09PM +0900, Damien Le Moal wrote:
> I am all for not micro-optimizing the free path right now.
> I am not so sure about the mempool being simpler... And I do see some
> improvements in perf for SMR HDDs with the free list. Could be noise though but
> it feels a little more solid perf-wise. I have not seen any benefit for faster
> devices with the free list though...
> 
> If you prefer the mempool, I can go back to using it though, not a big deal.

A capped free list + dynamic allocation beyond it is exactly what the
mempool is, so reimplementing seems a bit silly.
