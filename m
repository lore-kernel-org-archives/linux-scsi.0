From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into
 scsi_{host,target}_queue_ready
Date: Mon, 10 Feb 2014 03:39:32 -0800
Message-ID: <20140210113932.GA31405@infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
 <20140205124021.286457268@bombadil.infradead.org>
 <1391705819.22335.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaBJLjq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2014 06:39:46 -0500
Content-Disposition: inline
In-Reply-To: <1391705819.22335.8.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Thu, Feb 06, 2014 at 08:56:59AM -0800, James Bottomley wrote:
> I'm dubious about replacing a locked set of checks and increments with
> atomics for the simple reason that atomics are pretty expensive on
> non-x86, so you've likely slowed the critical path down for them.  Even
> on x86, atomics can be very expensive because of the global bus lock.  I
> think about three of them in a row is where you might as well stick with
> the lock.

The three of them replace two locks at least when using blk-mq.  Until
we use blk-mq and those avoid the queue_lock we could keep the
per-device counters as-is.

As Bart's numbers have shown this defintively shows a major improvement
on x86, for other architecture we'd need someone to run benchmarks
on useful hardware.  Maybe some of the IBM people on the list could
help out on PPC and S/390?

> I also think we should be getting more utility out of threading
> guarantees.  So, if there's only one thread active per device we don't
> need any device counters to be atomic.  Likewise, u32 read/write is an
> atomic operation, so we might be able to use sloppy counters for the
> target and host stuff (one per CPU that are incremented/decremented on
> that CPU ... this will only work using CPU locality ... completion on
> same CPU but that seems to be an element of a lot of stuff nowadays).

The blk-mq code is aiming for CPU locality, but there are no hard
guarantees.  I'm also not sure always bouncing around the I/O submission
is a win, but it might be something to play around with at the block
layer.

Jens, did you try something like this earlier?

