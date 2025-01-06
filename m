Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC3A1581F0;
	Mon,  6 Jan 2025 07:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736150311; cv=none; b=u7x1yMQJPIhKOpeIezcaDeKxQktvzVRzlps/ewcV+IEQWs1VzBOVdCO8NK+97vu+jrZIm7507df/wBPKAN/U5m3JEHGaVZHwvObXq5QQMqdcXiKST6/hudXTJDuGvUItohQ8cQ8Bcp+72ujWl5GF4HAvh2wEr/JNzmjwo/O+lBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736150311; c=relaxed/simple;
	bh=0Ua4bdZYE1vlc8vQaO8eCg3GpRxynX3bb4dMgOMP6JI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KNqlB+aRzCk6We7yM+81mAizPc1ywN+4tpzseagk5Yd57WnLIUuHXE9tjz/PDZaU5B5ntsnm8oHlv3WGNbfIslk2whjFCZEZUzfOkZ0DPoSt1YOgekg9rkSld6iMHS1rxyz0qLsdwCPBubQHLrr+WoZFMDCitmH9rPrhZnBPmZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B26968BFE; Mon,  6 Jan 2025 08:58:25 +0100 (CET)
Date: Mon, 6 Jan 2025 08:58:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/4] block: simplify tag allocation policy selection
Message-ID: <20250106075824.GA17919@lst.de>
References: <20250103074237.460751-1-hch@lst.de> <20250103074237.460751-5-hch@lst.de> <d7cbbe46-ecd1-4bdc-8fe9-7df499ba9e6f@oracle.com> <20250106073520.GA17229@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106073520.GA17229@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 08:35:20AM +0100, Christoph Hellwig wrote:
> >> --- a/drivers/ata/sata_sil24.c
> >> +++ b/drivers/ata/sata_sil24.c
> >> @@ -378,7 +378,7 @@ static const struct scsi_host_template sil24_sht = {
> >>   	.can_queue		= SIL24_MAX_CMDS,
> >>   	.sg_tablesize		= SIL24_MAX_SGE,
> >>   	.dma_boundary		= ATA_DMA_BOUNDARY,
> >> -	.tag_alloc_policy	= BLK_TAG_ALLOC_FIFO,
> >> +	.tag_alloc_policy	= SCSI_TAG_ALLOC_FIFO,
> >
> > do we actually need to set tag_alloc_policy to the default 
> > (SCSI_TAG_ALLOC_FIFO)?
> 
> libata uses weird inheritance where __ATA_BASE_SHT sets default fields
> that can then later be override, so this is indeed needed to set the
> field back to the original default after the previous assignment changed
> it.  (Did I mentioned I hate this style of programming? :))

It turns out the clearning is not needed here, as the driver only
uses __ATA_BASE_SHT and not ATA_BASE_SHT (did I mentioned I hate this
templating?)

