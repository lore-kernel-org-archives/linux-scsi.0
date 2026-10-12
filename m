Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1452F531B;
	Mon, 12 Oct 2026 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815029; cv=none; b=qa60h4fUTksKOO2jCCqKBpgDElRI7Z/OkfzTRo64ES+giCB/qPhpPYQI83NKC0jLVGQsr1ozthFyfvEVG9nNBUJR08z6KhWVnuB5Bpnt17uwwGwhJlb6Y+m2BEmyWpqPet+DYh8YU1PjuNqGD/BcKj+YML1lq7R++0aU+QwWyOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815029; c=relaxed/simple;
	bh=jT1SLDuJRuhklBPJR0kEEPl5FZ7PVGcBZ2TwyBR4NOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBo4dDWIfaVxSKjGa2OEt/LexeuDPPRwECwuXzCkWtPrVRUsGONQl1puD4R5z9Voyo3fLl3dS3tZ7b0R4G0wyyNRpmKO/Vs1mlh1uon37jo9TuhhIcKAPktYA7Bne03xavT4s8mDietlyhhF052Rf4E5NjXhwB3yWnf1sGzAnUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5D253227A8E; Mon, 12 Oct 2026 16:23:41 +0200 (CEST)
Date: Mon, 12 Oct 2026 16:23:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 3/9] block: introduce storage element management
Message-ID: <20261012142341.GA8609@lst.de>
References: <20261012130121.1902634-1-dlemoal@kernel.org> <20261012130121.1902634-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012130121.1902634-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 12, 2026 at 10:01:15PM +0900, Damien Le Moal wrote:
> +static int disk_check_remove_error(struct gendisk *disk,
> +				   struct blk_se *elements,
> +				   unsigned int element_id)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < disk->nr_storage_elements; i++) {
> +		if (elements[i].id == element_id
> +		    && elements[i].status == BLK_SE_STS_REMOVE_ERROR)

kernel style places the && on the previous line.

> +	noio_flag = memalloc_noio_save();
> +	elements = kzalloc_objs(struct blk_se, disk->nr_storage_elements);
> +	memalloc_noio_restore(noio_flag);

This is a bit odd, we can still use GFP_NOIO for now, but if we
want to use the scope API, I'd expect it to be used higher level and
not over a single call.  Of course not a bug, but somewhat strange
looking code.

The rest looks good.  I think the Sashiko comment is a bit confused,
as the code explicitly just flushes with a freeze/unfreeze, so
extending the scope is a strange suggestion.
