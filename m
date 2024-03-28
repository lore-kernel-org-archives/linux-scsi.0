Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAB41DA23;
	Thu, 28 Mar 2024 06:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711607902; cv=none; b=da0WJ8JSKlYIxoYfiI8QI9jaAv+9dkQYWOJXapSoj83oyopfGBoQi9inFhx20u1i3jEvJIM4Mdg5ycQbl6osXmHF9ERrVzN4lcQ+bi8tOJj0BQlDakPo7GfAsUVQxEaEFmNqLcu5+QxrbXYtZmEYXYWUdLLmoTiN2vG2vN9E1dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711607902; c=relaxed/simple;
	bh=joTn78ZtVJ4pzxdPQWvRQsr7Gm7XiJR/bOvihSH8mRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZV+u1/ObjPC+Xn1u1OH+eorawSE1l9uKUv/+rsgxHQ0vDStLVoM6aHRqZoL0m5LaHr7xr8UYUYBz18MpzFgPGaXObfgDdyvDyokKm2aFSK6l+PONcZZXSw9FUwRl7EO3nPtGxuHMakD53lEZtR9PsSP0GTnZwqlEtvGqUTAJL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 50B2A68B05; Thu, 28 Mar 2024 07:38:16 +0100 (CET)
Date: Thu, 28 Mar 2024 07:38:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
Message-ID: <20240328063816.GA17642@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-10-dlemoal@kernel.org> <20240328043016.GA13701@lst.de> <714d0cbc-be4d-4aa9-b200-73c6caaa1d18@kernel.org> <20240328054652.GA16237@lst.de> <7d8f3ec4-c416-445f-92db-7d2b60726821@kernel.org> <20240328060357.GA16819@lst.de> <ca3fe7b0-7e27-4ac9-b669-5263c3cec550@kernel.org> <20240328062237.GA17225@lst.de> <0d54c569-f586-4b75-a8a3-509e3f3717e2@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d54c569-f586-4b75-a8a3-509e3f3717e2@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 03:33:13PM +0900, Damien Le Moal wrote:
> Ha. OK. I did not see that one. But that means that the plug kfree() can then
> block the caller. Given that the last ref drop may happen from BIO completion
> context (when the last write to a zone making the zone full complete), I do not
> think we can use this function...

Ah, damn.  So yes, we probably still need the rcu head.  We can kill
the gendisk pointer, though.  Or just stick with the existing version
and don't bother with the micro-optimization, at which point the
mempool might actually be the simpler implementation?
