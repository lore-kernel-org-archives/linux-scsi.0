Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2584184F;
	Mon,  6 Jan 2025 07:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736148926; cv=none; b=FrlnXIhK8byCGeJdVk4BY8GShJXZuAgB958SaE8/kcSKtI0szUxUW5s9fD0fZJclBc8IB3CxupVlNlbT3DCFQANUuJmKVCfism0jBMnBMvUx1xwH+9SAg7q1vb016zLnpNrsbdP/vM9+aYCdKH1uL+7SvHlcDmP+ePL/hSFsRgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736148926; c=relaxed/simple;
	bh=qbko2Z+H6pgF7QgMKcN3IFdAcCTv0LQGjnrM1OmzeeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gx93kTzyxVTSpXD8YQeXOlG14cWY6J9m/yp1WLSsMCT+jgqxSRDOWqQz2AWUHL8S2u5tk+LMm7zbRQZ/N7NYCjEBIL/X8J93dn+KxGThWExQTbqxPwGO69zHtqbSNVLnEkL6cXkHQA1jLr7zoZ7WgKmKhCNwvHhpYzNN0JF/uAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 75F6E68BFE; Mon,  6 Jan 2025 08:35:20 +0100 (CET)
Date: Mon, 6 Jan 2025 08:35:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/4] block: simplify tag allocation policy selection
Message-ID: <20250106073520.GA17229@lst.de>
References: <20250103074237.460751-1-hch@lst.de> <20250103074237.460751-5-hch@lst.de> <d7cbbe46-ecd1-4bdc-8fe9-7df499ba9e6f@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7cbbe46-ecd1-4bdc-8fe9-7df499ba9e6f@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 03, 2025 at 09:33:31AM +0000, John Garry wrote:
>> -	BUILD_BUG_ON(ARRAY_SIZE(alloc_policy_name) != BLK_TAG_ALLOC_MAX);
>> +	BUILD_BUG_ON(ARRAY_SIZE(hctx_flag_name) != ilog2(BLK_MQ_F_MAX));
>>   -	seq_puts(m, "alloc_policy=");
>
> Maybe it's nice to preserve this formatting, but I know that debugfs is not 
> a stable ABI...

It's not a stable API indeed, and I'd rather not keep extra code for
debugging.

>> index 72c03cbdaff4..d51eeba4da3c 100644
>> --- a/drivers/ata/sata_sil24.c
>> +++ b/drivers/ata/sata_sil24.c
>> @@ -378,7 +378,7 @@ static const struct scsi_host_template sil24_sht = {
>>   	.can_queue		= SIL24_MAX_CMDS,
>>   	.sg_tablesize		= SIL24_MAX_SGE,
>>   	.dma_boundary		= ATA_DMA_BOUNDARY,
>> -	.tag_alloc_policy	= BLK_TAG_ALLOC_FIFO,
>> +	.tag_alloc_policy	= SCSI_TAG_ALLOC_FIFO,
>
> do we actually need to set tag_alloc_policy to the default 
> (SCSI_TAG_ALLOC_FIFO)?

libata uses weird inheritance where __ATA_BASE_SHT sets default fields
that can then later be override, so this is indeed needed to set the
field back to the original default after the previous assignment changed
it.  (Did I mentioned I hate this style of programming? :))

> Could we just have
>
> struct scsi_host_template {
> 	...
> 	int tag_alloc_policy_rr:1
>
> instead of this enum?

This should probably work.  I tried to reduce the churn a bit, but
due to the change of the enum value names that didn't actually work.

>
> Or does that cause issues for the ATA SHT and descendants where it 
> overrides members? I didn't think that it would.

It'll still work fine.  It will be even less obvious, so the case
mentioned above by you will probably have to grow a comment explaining
it to preempt the cleanup brigade from removing it.

