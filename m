From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into
 scsi_{host,target}_queue_ready
Date: Mon, 10 Feb 2014 13:09:34 -0700
Message-ID: <20140210200934.GA4096@kernel.dk>
References: <20140205123930.150608699@bombadil.infradead.org>
 <20140205124021.286457268@bombadil.infradead.org>
 <1391705819.22335.8.camel@dabdike>
 <20140210113932.GA31405@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52986 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaBJUJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2014 15:09:38 -0500
Received: by mail-pa0-f53.google.com with SMTP id lj1so6623014pab.40
        for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2014 12:09:38 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140210113932.GA31405@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Mon, Feb 10 2014, Christoph Hellwig wrote:
> > I also think we should be getting more utility out of threading
> > guarantees.  So, if there's only one thread active per device we don't
> > need any device counters to be atomic.  Likewise, u32 read/write is an
> > atomic operation, so we might be able to use sloppy counters for the
> > target and host stuff (one per CPU that are incremented/decremented on
> > that CPU ... this will only work using CPU locality ... completion on
> > same CPU but that seems to be an element of a lot of stuff nowadays).
> 
> The blk-mq code is aiming for CPU locality, but there are no hard
> guarantees.  I'm also not sure always bouncing around the I/O submission
> is a win, but it might be something to play around with at the block
> layer.
> 
> Jens, did you try something like this earlier?

Nope, I've always thought that if you needed to bounce submission
around, you would already have lost. Hopefully we're moving to a model
where you at least have X completion queues and can tell the hardware
where you want the completion. You'd be a lot better off just placing
the tasks differently, for the cases where you are not on the right
node.

If we're talking about shoving to a dedicated thread to avoid all the
locking, that's going to hurt you on the sync workloads as well. And
depending on your device and peak load, it'll kill you on the peak
performance as well. That's why blk-mq was designed to handle parallel
activity more efficiently.

-- 
Jens Axboe

