Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817CA3DAADE;
	Tue, 13 Oct 2026 14:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791900982; cv=none; b=sMEPrhcoyzmBPa6o7+01xCJPQWlr22ne1SQ/VnNJRHQx/hzWewp+zKejaTdEoPrqEbZCRJFqXU+KQWNd5dRdS/eVINBLKCG8zRe1ySYWrpYoiRuoBHvZB33s7TJpOjm+i4TQdAWm2sNVk58aqylsXRLToqJqu3gd0+UV/ge29WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791900982; c=relaxed/simple;
	bh=3dr4PCNT9W7pPJeuG/fybIgp+Wk2jStonp5+6J+c26Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CoTQCFc/UAYrh5S6Qpvjt5bxL75v8ozt1osRyAF8fvlMqrhp1CBVboTGpksz6yduMIJmTvIdYiieUjplwTx7hINK/OKbLQzh0s9Pe6rkgwkSXxdA2WRMrgT64mxQBnE5Q2RoB/kFNlGbLsnlb/zDmwoQ9pKYq3Dm62D/STv5tBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 24994227A88; Tue, 13 Oct 2026 16:16:18 +0200 (CEST)
Date: Tue, 13 Oct 2026 16:16:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 04/10] block: add storage element management ioctls
Message-ID: <20261013141617.GB13783@lst.de>
References: <20261013122750.2237843-1-dlemoal@kernel.org> <20261013122750.2237843-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013122750.2237843-5-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 13, 2026 at 09:27:44PM +0900, Damien Le Moal wrote:
> +	nr_elements = rep->nr_elements;
> +	if (nr_elements < disk->nr_storage_elements)
> +		rep->nr_reported_elements = nr_elements;
> +	else
> +		rep->nr_reported_elements = disk->nr_storage_elements;

Nit: this could use min().

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
