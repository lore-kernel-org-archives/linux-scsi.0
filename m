Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D06C839E4;
	Tue, 26 Mar 2024 06:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711436262; cv=none; b=fcSbp5Te3JmrCtSoQ4HY3o/N3oB9bOozaZxBAnE3K9Ne0aoG4Hg8L3lUkPMRrMmxgH9zBr2OpjeYDUzP8VgG8hJhizNZ6nNPEtCEfacBArf1tS0pcC74i6P7ALMVLKSAXtHqUNR618QdprVmJg8MO6Z/ToWXouQpui5IwbAxDQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711436262; c=relaxed/simple;
	bh=z5hg35ENI9a/h2Na+VGBT5gzo0c/DkLaON+CG2HdJws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMTGY0qcNTrwPwWEDIdZypfeNSePzwI1269ljcoTbSu9InK4qN2cHUHJHNtGepU4sxAZCSo26Lj493x7lvvMo3UFTsHhpDGPzgZj3GyDwLbRv/8IEIC8U2Zgz1PH1jipryPwe4gnVKFZPCk1vmkXFXUTc5b5gLP+fyvxOTMxjbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8DAE668D37; Tue, 26 Mar 2024 07:57:37 +0100 (CET)
Date: Tue, 26 Mar 2024 07:57:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 09/28] block: Fake max open zones limit when there
 is no limit
Message-ID: <20240326065737.GH7986@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org> <20240325044452.3125418-10-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325044452.3125418-10-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 25, 2024 at 01:44:33PM +0900, Damien Le Moal wrote:
> For a zoned block device that has no limit on the number of open zones
> and no limit on the number of active zones, the zone write plug mempool
> size defaults to 128 zone write plugs. For such case, set the device
> max_open_zones queue limit to this value to indicate to the user the
> potential performance penalty that may happen when writing
> simultaneously to more zones than the mempool size.

zone_hw_limits is a horrible name for
max(lim->max_active_zones, lim->max_open_zones).

But why do we even need it?  I'd rather make sure that we always
have valid max_open/active limits, doing something like:

	if (!max_open && !max_active)
		max_open = max_active = DEFAULT_CAP;
	else if (!max_open || WARN_ON_ONCE(max_open > max_active)
		max_open = max_active;
	else if (!max_active)
		max_active = max_open;

and do away with the extra limit.  Maybe DEFAULT_CAP should be
tunable as well?
