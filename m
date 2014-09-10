From: Christoph Hellwig <hch@infradead.org>
Subject: Re: lk 3.17-rc4 blk_mq large write problems
Date: Wed, 10 Sep 2014 11:40:04 -0700
Message-ID: <20140910184004.GA14286@infradead.org>
References: <540FCB96.8000606@interlog.com>
 <20140910154144.GA22296@infradead.org>
 <541080B5.8080505@kernel.dk>
 <20140910180957.GA17495@infradead.org>
 <541097F1.8030808@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaIJSkG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 14:40:06 -0400
Content-Disposition: inline
In-Reply-To: <541097F1.8030808@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Sep 10, 2014 at 12:26:57PM -0600, Jens Axboe wrote:
> > I have to.  It's set by start_request, so we need to pass down the last
> > argument to keep the old behavior.  And once we pass the argument we
> > can just it directly.
> 
> It could still be done in the caller, but arguably, you'd have to do it
> twice unless the ->queue_rq() call was rolled into a function.

At which point we'd better do it the right way and just pass the flag
instead of wasting a request flag for it.  The other benefit is that
there is a clear compile time API break for ->queue_rq that reminds
people that need to start using blk_mq_start_request.

Anyway, still waiting for test reports of the people that can reproduce
the timeouts.  By the time I'll submit the patch it should have a much
better changelog.

