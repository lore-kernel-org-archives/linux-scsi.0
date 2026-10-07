Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E314908AE;
	Wed,  7 Oct 2026 13:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380373; cv=none; b=YfqFZM1cVfvLEkrfnyTUsZ010eqPvBnhRd8dhgWn8kqlBuBu/+1LEdSTPQTUtU7QMgKsC63rdELA2+zt4AQaU7SKI46oTvPQLsgDD8kREI1r7RjP2gxuQ8elwZT2aeEK5CofMV7kfFAo8X2E/TA6Of9m9CM8l6vvlYI/LlrDuZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380373; c=relaxed/simple;
	bh=nMaVLPy8+GNG9HTg3E9YIlSUHKlOP4mVjRrdQS4ezZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVDU5fiZy1sRa7CM5RhHoYeFru/Pm3M50ffFbfQF6uMVMHyRG+6tV3DdeMbsHgjG6rfuiA3YmYOD0cJy0lvd2E5rg+gfY2BePtFc/Zu3oPQkE2VHnuADUbfhD93quc5Aj3HKoyUsYi5f4LlxzlnAFfYDWFYhyghu0aPErNwMkQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6B2C0227A88; Wed,  7 Oct 2026 15:39:22 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:39:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 3/7] block: add storage element management ioctls
Message-ID: <20261007133922.GC31906@lst.de>
References: <20261007082344.1049179-1-dlemoal@kernel.org> <20261007082344.1049179-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007082344.1049179-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +	if (copy_from_user(&rep, argp,
> +			   sizeof(struct blk_storage_elements_report)))

Can we shorten the name of the struct a bit?  blk_se_report?
Similar for other identifiers?

> +		return -EFAULT;
> +
> +	ret = bdev_report_storage_elements(bdev, NULL, &nr_elements);
> +	if (ret)
> +		return ret;
> +
> +	nr_elements = min(rep.nr_elements, nr_elements);
> +	if (!nr_elements)
> +		return -EINVAL;
> +
> +	elements = kzalloc_objs(struct blk_storage_element, nr_elements);

This doesn't work as it could race.  We'll always need to allocate
the space for all the elements the user asked for?

> +	retc = copy_to_user(argp + sizeof(struct blk_storage_elements_report),
> +			    elements,
> +			    sizeof(struct blk_storage_element) * nr_elements);
> +	if (retc) {
> +		ret = -EFAULT;
> +		goto free_elements;
> +	}
> +
> +	rep.nr_elements = nr_elements;
> +	retc = copy_to_user(argp, &rep,
> +			    sizeof(struct blk_storage_elements_report));

Why not copy back the entire struct in one go?

> +		ret = truncate_bdev_range(bdev, mode, 0,
> +			(get_capacity(bdev->bd_disk) << SECTOR_SHIFT) - 1);

Use bdev_nr_bytes() here?

> +	/*
> +	 * Storage element restoration is a destructive operation that will
> +	 * reset all zones. So fflush the device volatile write cache and
> +	 * invalidate all cached data that we may have.
> +	 */
> +	filemap_invalidate_lock(bdev->bd_mapping);
> +	ret = blkdev_issue_flush(bdev->bd_disk->part0);
> +	if (!ret)
> +		ret = truncate_bdev_range(bdev, mode, 0,
> +			(get_capacity(bdev->bd_disk) << SECTOR_SHIFT) - 1);

Same.  Also what about factoring the duplicate code block into a helper?

