From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Fri, 19 Sep 2014 11:11:04 -0700
Message-ID: <20140919181104.GA16875@infradead.org>
References: <541C27BF.6070609@acm.org>
 <541C28E0.7010705@acm.org>
 <CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>
 <541C49EC.6030404@acm.org>
 <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com>
 <541C4D2F.9060907@acm.org>
 <541C4DF1.4090604@kernel.dk>
 <CAF9gx6LxWiXAWuSe8zt08NTzi9CmPU1RxRPo3e2AGT_J7QCojg@mail.gmail.com>
 <541C68DB.1050002@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbaISSLJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 14:11:09 -0400
Content-Disposition: inline
In-Reply-To: <541C68DB.1050002@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Robert Elliott <Elliott@hp.com>

On Fri, Sep 19, 2014 at 11:33:15AM -0600, Jens Axboe wrote:
> That'd be fine as well. The mapping is cheap, though, but it would make
> sense to have an appropriate way to just pass it in like it happens for
> ->queue_rq() for native blk-mq drivers.

I think just passing the hw_ctx is fine.  But I don't want drivers to
have to implement both methods, so we should make sure the new method
works for both the blk-mq and !blk-mq case.  Note that once thing the
new method should get is a bool last paramter similar to the one I
added to the queue_rq method in the block tree tree.

It might be worth it to simply do a global search and replace and pass
a hw_ctx method to all instances, too.
