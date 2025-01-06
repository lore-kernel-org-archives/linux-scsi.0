Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A88B1BF58;
	Mon,  6 Jan 2025 08:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736153761; cv=none; b=kxVNKWRwQOJkNt5lVKbTwtCmfZQBuiONHR0KvFBRm9k0jiWSVBbvB0+sUFSdpr7LJNa3p6cx8fJtQ4RWA0eOJnZ4bKf+afV5gX3jjYqMoTvSgMR0qExacvTBbvkOqj8VM6jp1p4Bi9NDtwAbKs3yNslzmr7J1rPad4vHqCb+648=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736153761; c=relaxed/simple;
	bh=Jspeq8m2DbvnilOfrGNfWiBfpTDwPOaB5foPQIunmbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YhMkCKfLtpivB2dx5pDY80hYv+ksiSfWKBRjHuK34kqFwiM79QW60bBAF5Bt61mmGgHW4uLssnTEVw3XHW3zjJ9+0lNLrpsGXqtGR8Bw8V9zoqMMGcvAZid1pBBzidwbYMxXo72rW68ra2DWhnArf57OFocUakryeV6j9rRcYGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F392E68BFE; Mon,  6 Jan 2025 09:55:54 +0100 (CET)
Date: Mon, 6 Jan 2025 09:55:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/4] block: simplify tag allocation policy selection
Message-ID: <20250106085554.GA19343@lst.de>
References: <20250106083531.799976-1-hch@lst.de> <20250106083531.799976-5-hch@lst.de> <10f1383a-fe7e-4cf8-a15f-14cd4385a7de@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10f1383a-fe7e-4cf8-a15f-14cd4385a7de@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 08:50:20AM +0000, John Garry wrote:
>>   	.can_queue		= SIL24_MAX_CMDS,
>>   	.sg_tablesize		= SIL24_MAX_SGE,
>>   	.dma_boundary		= ATA_DMA_BOUNDARY,
>> -	.tag_alloc_policy	= BLK_TAG_ALLOC_FIFO,
>
> nit: maybe that could be a separate patch, but no biggie

I though about that, but if felt a bit overkill.

>> +	/*
>> +	 * Allocate tags starting from last allocated tag.
>> +	 */
>> +	bool tag_alloc_policy_rr : 1;
>
> Is it proper to use bool here? I am not sure. Others use unsigned int or 
> unsigned.

Yes, you can use any unsigned type for a single-bit bitfield.  Most of
the existing uses just predate the availability of bool or were copy
and pasted after that.

>
> nit: coding style elsewhere in scsi_host_template would be to use 
> "tag_alloc_policy_rr:1;"

Yes, but that's against the normal kernel coding style, so we'd better
stop adding more of that.

