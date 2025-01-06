Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AAD1946CC;
	Mon,  6 Jan 2025 11:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736161539; cv=none; b=aNbvSUzQLJ4MWQ5ou+xgrrnvwGysF2j8q93CTRLFaEBaau0la/Soj579VFMwpo6kqtEsD2SViCi9kPQ05fSXYTIOZYRCqFka4WZUDPCFXNhmuLqynndWjU50jgmJPdpghDcfPxsMZcAkxoi8nsvDItBJ1ym59j/BMmbz1lQGm3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736161539; c=relaxed/simple;
	bh=rGFmx6VxnMZ5kLtq/7pgErF8oyzmncl0+E8IoRNXNBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwmXHO8DL/Ur7aYFCdF7uMIADSPaiTWEVMe14bWsLEj8W8apvrM4ogNdv0v2ZIHxZjve7QOnxUZl4+1qzqXPhbfd0+Mztj6VUo/fMzIq4NBqeJpUUKuoSrdMEaJXT3r4UV9wee6ZKZ16BO6ra/vrkGICzX1vhU4e3k1AXwO8J8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4122D68B05; Mon,  6 Jan 2025 12:05:32 +0100 (CET)
Date: Mon, 6 Jan 2025 12:05:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	nbd@other.debian.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 05/10] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
Message-ID: <20250106110532.GA22062@lst.de>
References: <20250106100645.850445-1-hch@lst.de> <20250106100645.850445-6-hch@lst.de> <4addcb5e-fc88-4a86-a464-cc25d8674267@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4addcb5e-fc88-4a86-a464-cc25d8674267@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 04:31:23PM +0530, Nilay Shroff wrote:
> > +static bool bdev_can_poll(struct block_device *bdev)
> > +{
> > +	struct request_queue *q = bdev_get_queue(bdev);
> > +
> > +	if (queue_is_mq(q))
> > +		return blk_mq_can_poll(q->tag_set);
> > +	return q->limits.features & BLK_FEAT_POLL;
> > +}
> > +
> 
> Should we make bdev_can_poll() inline ?

I don't really see the point.  It's file local and doesn't have any
magic that could confuse the code generator, so we might as well leave
it to the compiler.  Although that might be about to change per the
discussion with Damien, which could require it in blk-sysfs, in
which case it should become an inline in a header.

