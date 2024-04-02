Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCD6140E4D;
	Tue,  2 Apr 2024 16:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712074338; cv=none; b=DBTqgV3Bli6XRi/g7JLTP+KPdxX0epmOeB37Vjy13MLvQQX4BFe3clw3RYvVHRAp7ujCBPKmvjj0tvoam4SoeBWnbLOMe7Gkae5/xCMbkrlk5EQobsNSzxrwdp6JgpBoIn7sxegnCc9ny7+lMVzp46UA2wGdjHyenfDY+wZTmyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712074338; c=relaxed/simple;
	bh=A4USTVRH9rcWxotvG2CFX4iRoo+9995zKoAWz0yeV6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dcwMRUARD/k+kbia/bcOxireYyLHjy+66w04WIhGjFeh5sD5xwANt8JL03x4SrH3YLV9HaXYRRAqJAptxjBlBb0G2oM4qQvQ2WaImmfv8ecdg3Q90e0awrqB0iArXQDrf4hY0MqTajND2fhwZWjWZ5q4bojtAoDFktecOLLsCoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 63DDF68BFE; Tue,  2 Apr 2024 18:12:13 +0200 (CEST)
Date: Tue, 2 Apr 2024 18:12:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 07/28] block: Introduce zone write plugging
Message-ID: <20240402161213.GB3527@lst.de>
References: <20240402123907.512027-1-dlemoal@kernel.org> <20240402123907.512027-8-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402123907.512027-8-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +	/* We can remove zone write plugs for zones that are empty or full. */
> +	return !zwplug->wp_offset ||
> +		zwplug->wp_offset >= disk->zone_capacity;

Nit: this condition easily fits onto a single line.

> +static inline struct blk_zone_wplug *
> +disk_lookup_zone_wplug(struct gendisk *disk, sector_t sector)
> +{
> +	unsigned int zno = disk_zone_no(disk, sector);
> +	unsigned int idx = hash_32(zno, disk->zone_wplugs_hash_bits);
> +	struct blk_zone_wplug *zwplug;
> +
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[idx], node) {
> +		if (zwplug->zone_no == zno)
> +			goto unlock;
> +	}
> +	zwplug = NULL;
> +
> +unlock:
> +	rcu_read_unlock();
> +	return zwplug;
> +}

Did we lose an atomic_inc_unless_zero here?  This now just does a lookup
under RCU, but nothing to prevent the zwplug from beeing freed?

> +	/* Resize the zone write plug memory pool if needed. */
> +	if (disk->zone_wplugs_pool->min_nr != pool_size)
> +		return mempool_resize(disk->zone_wplugs_pool, pool_size);

Note that a mempool_resize to the current size work just fine.  It takes
a pointless lock, but given that this is something that doesn't happen
frequently that probably doesn't matter.

> +#include <linux/mempool.h>

> +	mempool_t		*zone_wplugs_pool;

Please use struct mempool_s here so that you only need a forward
declaration instead of pulling in another header.
