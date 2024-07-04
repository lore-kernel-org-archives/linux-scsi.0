Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CAB20328;
	Thu,  4 Jul 2024 05:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720070228; cv=none; b=CQ1jaOUorRMf0sG8SnMVqwh/XztVb/sGXfdbGA0Yr9fkELVocMkr4WFaOlk4Ep4Sx61MgzFDBnR0QFCgd92T+A5CI2JpXIHmLsmhhbLa3r+5hcSPlvICRDLbTLUc2eaadS8f/gbNWozZoAm531XA90OKQEdEwVTbk399hdbrXA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720070228; c=relaxed/simple;
	bh=3ILCXgjbBWr2Q5Qdu7JevMO8Yg4UJyA0DZq1Pw0/djM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1fvHisGIFRxon7f3qsqE3ukMs0i5/ZQTyZhRH8fFYN/KMGKu8tP51nFeTn/BNSTmiSLyhQaQS9MiFtsltyKeTvNGSYIqjLeBQMV6bqzYi0JLqujqng0fMzRZhfv2CffBhkp/GX0HSVSVOildcVHt01q5vk5SSPF60DyZ7aINn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D365568AFE; Thu,  4 Jul 2024 07:17:03 +0200 (CEST)
Date: Thu, 4 Jul 2024 07:17:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/5] dm: handle REQ_OP_ZONE_RESET_ALL
Message-ID: <20240704051703.GD19411@lst.de>
References: <20240703233932.545228-1-dlemoal@kernel.org> <20240703233932.545228-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703233932.545228-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> Targets that can natively support REQ_OP_ZONE_RESET_ALL are identified
> using the new target field zone_reset_all_supported. This boolean is set
> to true in for targets that have reliable zone limitsi, that is, targets

s/limitsi/limits/

> +		/*
> +		 * Assume that the target can accept REQ_OP_ZONE_RESET_ALL.
> +		 * device_get_zone_resource_limits() may adjust this if one of
> +		 * the device used by the target does not have all its sequential

Overly long line here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
