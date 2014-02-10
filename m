From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into
 scsi_{host,target}_queue_ready
Date: Mon, 10 Feb 2014 13:10:07 -0800
Message-ID: <1392066607.19708.5.camel@dabdike.int.hansenpartnership.com>
References: <20140205123930.150608699@bombadil.infradead.org>
	 <20140205124021.286457268@bombadil.infradead.org>
	 <1391705819.22335.8.camel@dabdike> <20140210113932.GA31405@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46658 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbaBJVKJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Feb 2014 16:10:09 -0500
In-Reply-To: <20140210113932.GA31405@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org


On Mon, 2014-02-10 at 03:39 -0800, Christoph Hellwig wrote:
> On Thu, Feb 06, 2014 at 08:56:59AM -0800, James Bottomley wrote:
> > I'm dubious about replacing a locked set of checks and increments with
> > atomics for the simple reason that atomics are pretty expensive on
> > non-x86, so you've likely slowed the critical path down for them.  Even
> > on x86, atomics can be very expensive because of the global bus lock.  I
> > think about three of them in a row is where you might as well stick with
> > the lock.
> 
> The three of them replace two locks at least when using blk-mq.  Until
> we use blk-mq and those avoid the queue_lock we could keep the
> per-device counters as-is.

I'm not saying never, I'm just really dubious about this bit and the
potential cost on other platforms ... at the very least, surely the
device busy can still be a counter because of the current threading
guarantees?

> As Bart's numbers have shown this defintively shows a major improvement
> on x86, for other architecture we'd need someone to run benchmarks
> on useful hardware.  Maybe some of the IBM people on the list could
> help out on PPC and S/390?

Well, no, they haven't.  The number were an assertion not a benchmark
and 3.8% can be in the error margin of anybody's tests.  Even if the
actual benchmark were published, I can't see it being convincing because
there's too much potential variation (other architectures, different
ways of testing) for such a small result.

I'm happy to take shortening critical sections and removing atomics in
get/put because they're obvious wins without needing benchmark
justification.  I don't really want to take the dubious stuff (like spin
lock replacement with atomic) until we see the shape of what we can do
with the block mq stuff and what's necessary and what isn't.

James


