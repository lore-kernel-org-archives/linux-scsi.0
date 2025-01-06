Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF42148838;
	Mon,  6 Jan 2025 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177237; cv=none; b=V776uW5k3WxCdIv2Vi57QPzAtuvmhLAySGnWk0IsGIUDrlwZA/u0HgGvNacdDOIDRJ6Sivl/FlOFULiTstxqJbBQEqzP3phPQe/+lZuLYGNpinBiObwp8jAagnCX1MS9dPKGJ2eHpIrRodgXkijK2wOjVoB0h26t6zEP2qwEHMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177237; c=relaxed/simple;
	bh=+iZj72vs1oUGhMHh+imKfqfDEr4waAhow996P5NhBG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b78yXPizdxUcguZFVShViAHk7Rydeo+P0op3EckGp9PydYPEMFjtb1YJIDLTng1p0/klPYKkDRI//uhjbb3MArYmtInj4jCl9TViNfpfIMYYx4mwohXjHe8CfqCNIG1/HtcLz1e6Yb7fAtGvnsSIBFj4eSqUXYkAqpBSN5xOVHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 98D4A68C7B; Mon,  6 Jan 2025 16:27:08 +0100 (CET)
Date: Mon, 6 Jan 2025 16:27:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	nbd@other.debian.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 05/10] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
Message-ID: <20250106152708.GA27431@lst.de>
References: <20250106100645.850445-1-hch@lst.de> <20250106100645.850445-6-hch@lst.de> <4addcb5e-fc88-4a86-a464-cc25d8674267@linux.ibm.com> <20250106110532.GA22062@lst.de> <3fb212e4-8fff-45fc-9cff-f5b5eaff4231@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fb212e4-8fff-45fc-9cff-f5b5eaff4231@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 05:36:52PM +0530, Nilay Shroff wrote:
> Oh yes, I saw that you moved blk_mq_can_poll() to blk-mq.h and 
> made it inline so thought why bdev_can_poll() can't be made inline?

It can be, but why would you want it to?  What do you gain from forcing
the compiler to inline it, when sane compilers with a sane inlining
threshold will do that anyway.

> BTW, bdev_can_poll() is  called from IO fastpath and so making it inline 
> may slightly improve performance. 
> On another note, I do see that blk_mq_can_poll() is now only called 
> from bdev_can_poll(). So you may want to merge these two functions 
> in a single call and make that inline.

I'd rather keep generic block layer logic separate from blk-mq logic.
We tend to do a few direct calls into blk-mq from the core code to
avoid the indirect call overhead, but we should still keep the code
as separate as possible to keep it somewhat modular.

