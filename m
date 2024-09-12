Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CABE1AD25F;
	Thu, 12 Sep 2024 13:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726147088; cv=none; b=H7sO99vl98xJRAq89ms1GEZJPbQ1z9tptgSKDMoat2siQMOC/rLFzFAbfFcLIiIpxVTFqbCWeZk2oDUolO64IJ+F+e11zc9hV9+kEm62dRFg26OWK3G5hUz+KVuef2K6E1a8ZsiUetZqLqIC+f7QKfiVGrzHsoHQwrXcwH1TMs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726147088; c=relaxed/simple;
	bh=C3/Nc/KoOALtwLGH/MVu6z0ftf6mNd+GYdD0BhiQLqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fP+KCp2DNQmLMY3mnzN4xWtGWuq9l5eM4mzocIHXvXLtVW2G0NYQL0iduUaeugXX6gmpVLN00nxNiChebAgGWDlhyUfMIYgr+7Usch+fGFrAERuy7ipf1ozvXm9tT3SN+S5TWxWT3ZTGB//yTUQmmqPbOxePj8f3n8MLL8L50xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 88577227AB5; Thu, 12 Sep 2024 15:18:03 +0200 (CEST)
Date: Thu, 12 Sep 2024 15:18:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] md/raid0: Atomic write support
Message-ID: <20240912131803.GD29641@lst.de>
References: <20240903150748.2179966-1-john.g.garry@oracle.com> <20240903150748.2179966-5-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903150748.2179966-5-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 03, 2024 at 03:07:48PM +0000, John Garry wrote:
>  	if (sectors < bio_sectors(bio)) {
> -		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
> +		struct bio *split;
> +
> +		if (bio->bi_opf & REQ_ATOMIC)
> +			return false;

I guess this is the erroring out when attempting to split the request.
Can you add a comment to explain that and why it can't happen for the
normal I/O patterns?

