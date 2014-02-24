From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Proposal for a scalable SCSI midlayer
Date: Sun, 23 Feb 2014 20:25:49 -0800
Message-ID: <20140224042549.GA11583@infradead.org>
References: <20140205123918.GA15907@infradead.org>
 <1393186218.9743.3.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43645 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaBXEZz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Feb 2014 23:25:55 -0500
Content-Disposition: inline
In-Reply-To: <1393186218.9743.3.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Sun, Feb 23, 2014 at 02:10:18PM -0600, James Bottomley wrote:
> If we can do this, that would be great, because it cuts down on the
> maintenance burden for all of us and gives some benefits at least to
> non-MQ hardware.

So far this seems to work out great, and I think we will be able to
stick to it.

> > Even when avoiding the host lock by replacing it with atomic counters we'd
> > run into multiple host or target-wide shared cache lines for each I/O
> > submission or completion.
> 
> Right ... my ideal here if we can achieve it would be lockless threaded
> models, where we could make guarantees like single thread of execution
> per command, so all command state could be lockless.  Even CPU dedicated
> to single device would give us all device state lockless and the
> necessary cache hotness (although this may not be feasible).

It's not fitting the current blk-mq model, which I'd much prefer to
follow for now.  As Jens pointed out in the previous discussion blk-mq
tries to map to cpu-local queues as much as possible, but there's no
hard guarantee.

> >  - implement BIDI support in blk-mq.  This is currently missing entirely
> >    and will be needed to support the OSD2 protocol, as well as a few
> >    SBC commands through sg_io.
> 
> Ambivalent.  We need bidi support for OSD arrays and some of the more
> esoteric commands, but I'm not convinced they're necessary to the
> functioning of the stack.

It's needed so that we get a full replacement of the old code, so we'll
have to tackle it eventually.  I wish we could simply avoid it, but life
ain't that easy.

