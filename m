Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672B213B58F;
	Tue,  7 Jan 2025 08:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736238119; cv=none; b=WvGi8Zs42qP8CS+g+ZNr4gQQT8X19koiM9Ckrk3F1V1uK5pYO8d7gWzrjOgTEiWog0xv1F4Lt2Zo0yyMrIJtNGVz/JkrWV+NSFqrEnHksbiLdoCK603a6f2uuTu66Zy8TK6bTfNxcQuw1t9z/ocNugJ7HgfuUSh91+/3ArGw6uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736238119; c=relaxed/simple;
	bh=fQh7w2Dbf9cZSb1yGpq1cffKm6fQnI1SdfU4Rp5v+ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ta3gX3AXZjoefYsTFMQa60dYGFZCdxGGurA4nVuFXfDvBQdYTXkz9ELXbJzV+7sy3wGSUklfJXoi9mSHlXNKzJIQB32lq2WIDYCbO3TI2VarkniMxU7EiiUcTVRA1x6hA1P2FCgtFQ7Kto1Yx4WioNwhJGG5124VUshZ0WTNDsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3418768AFE; Tue,  7 Jan 2025 09:21:46 +0100 (CET)
Date: Tue, 7 Jan 2025 09:21:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	nbd@other.debian.org, linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 3/8] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
Message-ID: <20250107082145.GA15960@lst.de>
References: <20250107063120.1011593-1-hch@lst.de> <20250107063120.1011593-4-hch@lst.de> <220cdd33-527f-405d-90af-2abaace36645@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <220cdd33-527f-405d-90af-2abaace36645@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 07, 2025 at 12:27:35PM +0530, Nilay Shroff wrote:
> As discussed in another thread with Damien, shouldn't we need to 
> move bdev_can_poll() to header file?

Well, if it was needed I would have done it, otherwise the code wouldn't
compile, would it?

> We also need to use this 
> function while reading sysfs attribute "io-poll", no?  

This now reports polling support when the driver declared it but
later resized the number of queues to have no queues left.  Which I
think is a fine tradeoff if you do that.

