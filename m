Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5803619F133;
	Wed,  8 Jan 2025 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736350032; cv=none; b=iB3MIxubVKt0CZq8j30DWmfh1vPVy8l9ChHmA2pG8aJ3WVHzfBgT9tSDElhACJx+ZuDp+w+DrJe8fuNC0CMfBwJ05cm/UuHBNYXslptWXqvsD0WuxoXbUckboHRBBIeLHZHzXwVVpE66xw4GtL3xemwKudiFbfuKk5OXYcg6zEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736350032; c=relaxed/simple;
	bh=e2FxtjEoipeTygiybES07KCk4wRf46CKtAa/9qOHAYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I42fyVo5XpOueXQ5N4l5IxD1LK0UwLYS7kImdlg+guxEpSn33lcQ9QDo0qPv3OqOe4OC+olxcu54hrUX7/Z2QthOvAFZguXI1RcFOocIvBnjmnGBWOUX2MAFGNdrEHjv+8oHmUWd1hK8avdl21/Gp02OE9QI7NIbgbrkGMu58vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4A05568BFE; Wed,  8 Jan 2025 16:27:06 +0100 (CET)
Date: Wed, 8 Jan 2025 16:27:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 03/10] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
Message-ID: <20250108152705.GA24792@lst.de>
References: <20250108092520.1325324-1-hch@lst.de> <20250108092520.1325324-4-hch@lst.de> <Z35T8xeLxhXe-zAS@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z35T8xeLxhXe-zAS@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 08, 2025 at 06:31:15PM +0800, Ming Lei wrote:
> > -	if (!(q->limits.features & BLK_FEAT_POLL) &&
> > -			(bio->bi_opf & REQ_POLLED)) {
> > +	if ((bio->bi_opf & REQ_POLLED) && !bdev_can_poll(bdev)) {
> 
> submit_bio_noacct() is called without grabbing .q_usage_counter,
> so tagset may be freed now, then use-after-free on q->tag_set?

Indeed.  That also means the previous check wasn't reliable either.
I think we can simple move the check into
blk_mq_submit_bio/__submit_bio which means we'll do a bunch more
checks before we eventually fail, but otherwise it'll work the
same.

