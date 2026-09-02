Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C58C374A16;
	Wed,  2 Sep 2026 11:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788348495; cv=none; b=NmcipR1v9lFiPj1ulo7ac8/6svx2QqYGvYt8l0MvDVvB/lgCrCLHLnoIyKEapba3IyvP9AtLNk0EGUHoeQHPWcGy99/NK0YjLvcgK7lHEfiVQDPpqLP72G59FD6EXtfVOhKZAP6ucIczgs+SwpyogJObuzuSxVcyhFyCUjDJYKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788348495; c=relaxed/simple;
	bh=OQzpxFybii+XcyHWqbOSTw1HsAgi7t6DYqqzMkyEkcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AqwTQwazJ/tCdCdjcoZm/BCmomgzWNnH01GmdENuKKbBhJSwclwjkjQWYoLljNC6LTJA5SrxviG7qOm0aPAmEX60rjfojz5zXf4SOg1LgWzoqRCQDrZhKyJqvK9S9tkV20WFk4G7pciN7rV/k7rcua0mZUW3Z7XxwGEMR1Ekt+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F39A46732A; Wed,  2 Sep 2026 13:28:07 +0200 (CEST)
Date: Wed, 2 Sep 2026 13:28:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.garry@linux.dev>
Cc: James.Bottomley@HansenPartnership.com, mkp@kernel.org,
	linux-scsi@vger.kernel.org, djwong@kernel.org, hch@lst.de,
	fstests@vger.kernel.org, bvanassche@acm.org
Subject: Re: [PATCH] scsi: scsi_debug: default to a higher throughput config
Message-ID: <20260902112807.GA12271@lst.de>
References: <20260902092844.1741533-1-john.garry@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902092844.1741533-1-john.garry@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 02, 2026 at 10:28:44AM +0100, John Garry wrote:
> Currently the default config goes not give as high a throughput as some
> would like.
> 
> Give a higher default throughput by modifying the following:
> - set completion response delay as 0
> - increase shost can_queue to 4096, which aligns better with modern
>   high-speed HBAs
> - turn on clustering

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

