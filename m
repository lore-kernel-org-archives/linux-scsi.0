From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into
 scsi_{host,target}_queue_ready
Date: Mon, 17 Feb 2014 14:00:57 -0800
Message-ID: <20140217220057.GB30101@infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
 <20140205124021.286457268@bombadil.infradead.org>
 <1391705819.22335.8.camel@dabdike>
 <20140210113932.GA31405@infradead.org>
 <20140210200934.GA4096@kernel.dk>
 <5301D814.5070100@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaBQWBD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2014 17:01:03 -0500
Content-Disposition: inline
In-Reply-To: <5301D814.5070100@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Mon, Feb 17, 2014 at 10:36:20AM +0100, Bart Van Assche wrote:
> This comment makes a lot of sense to me. The approach that has been
> taken in the scsi-mq patches that have been posted on February 5 is to
> associate one blk-mq device with each LUN. That blk-mq device has one
> hctx with queue depth shost->cmd_per_lun. So if there are multiple LUNs
> per SCSI host the combined hctx queue depth of its LUNs can exceed
> shost->can_queue. I'm not sure whether it's possible to prevent this
> without modifying the block layer. How about modifying the block layer
> such that a single hctx can be shared by multiple block devices and
> adding cmd_per_lun support in the block layer ? I think that would allow
> to prevent having to bounce submission in the SCSI mid-layer.

Most of the scsi multiqueue work so far has been about modifying the
block layer, so I'm defintively now shy about doing that were needed.
And I think we will eventually need to be able to have n:m queue to hctx
mapping instead of the current 1:n one.

I think the biggest issue will be to sort out the tag allocation.  I'm
going to look into this whole cluster of issues once the basic
functionality is fully working.

