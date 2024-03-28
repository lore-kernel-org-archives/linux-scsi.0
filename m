Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB33D1B7E4;
	Thu, 28 Mar 2024 04:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711599304; cv=none; b=OPSpWiAXIMvsqv3XFt+C1lEvBA2Gnp819euxg9D8fRDPtUDebL0SucpQo08o8swjmHdvSlxEV/MnFYoNwBADx9FjhWeCfJf07kdVnuzH36Y+WTCHV1jS8CZqxHuzKrMd+IAkBqorfuPOyMmghSYadV8qv3okpWfTusnUGpyAhUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711599304; c=relaxed/simple;
	bh=Nz2EwgrdhWxI5qI5qy3JP33wYLDuo/vc1tXUvRTKNJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PsptsbI1Rq57wM6AV6zpZ+len6EeU0VgOW4MDQi56XZaAu1wn100a0a1Mzhas7HATB0AhFMmNXNiAq+04BxwI0Uv5kvRhkZofXcrkb18FYutr5NcTDUKNZxGn/JdfQ3xkdbxovXWG09VrwJpBFr7+PlZhn+ebIMgRWSSuAdcsPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C984368B05; Thu, 28 Mar 2024 05:14:57 +0100 (CET)
Date: Thu, 28 Mar 2024 05:14:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 04/30] block: Introduce blk_zone_update_request_bio()
Message-ID: <20240328041457.GC13510@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328004409.594888-5-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> -		if (req_op(req) == REQ_OP_ZONE_APPEND)
> -			bio->bi_iter.bi_sector = req->__sector;
> -
> -		if (!is_flush)
> +		if (!is_flush) {
> +			blk_zone_update_request_bio(req, bio);
>  			bio_endio(bio);
> +		}

As noted by Bart last time around, the blk_zone_update_request_bio
really should stay out of the !is_flush check, as otherwise we'd
break zone appends going through the flush state machine.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
