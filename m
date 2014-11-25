From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] megaraid_sas: Enable shared host tag map
Date: Tue, 25 Nov 2014 17:30:14 +0100
Message-ID: <20141125163014.GA2614@lst.de>
References: <1416843235-35947-1-git-send-email-hare@suse.de> <20141124153558.GA27364@lst.de> <547353F2.1040005@suse.de> <20141125143140.GA32570@lst.de> <5474968C.2080800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39726 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaKYQaT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 11:30:19 -0500
Content-Disposition: inline
In-Reply-To: <5474968C.2080800@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, linux-scsi@vger.kernel.org, Webb Scales <webbnh@hp.com>, Don Brace <don.brace@pmcs.com>, Jens Axboe <axboe@kernel.dk>

On Tue, Nov 25, 2014 at 03:47:40PM +0100, Hannes Reinecke wrote:
> I'd rather have a single map to get request/tags from; otherwise
> we'd be arbitrarily starving internal requests even though the
> 'main' tag map is empty.

At least in blk-mq the assumption is that a driver needs very few
internal tags, and it might need access to them in "emergency"
situations like resets or aborts.

> My plan was more to mark a certain range of tags as 'reserved',
> and add another helper/argument to allow to dip into the reserved
> pool, too.

We can add this as optional behavior, but I think the existing blk-mq
behavior is a good default.

> A tentative patch is attached.
> Idea is to call blk_queue_init_tags() with the actual tag size and
> then blk_resize_tags() to limit the number of tags for the request
> queue.
> The driver can then use 'blk_allocate_tag' with the appropriate max
> depth to get tags from the range [max_depth:real_max_depth].

I'd much prefer the blk-mq approach with two maps.  Either way please
make sure whatever you come up is compatible with blk-mq.
