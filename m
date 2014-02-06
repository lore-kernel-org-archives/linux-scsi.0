From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into
 scsi_{host,target}_queue_ready
Date: Thu, 06 Feb 2014 08:56:59 -0800
Message-ID: <1391705819.22335.8.camel@dabdike>
References: <20140205123930.150608699@bombadil.infradead.org>
	 <20140205124021.286457268@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48574 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbaBFQ5A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 11:57:00 -0500
In-Reply-To: <20140205124021.286457268@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org


On Wed, 2014-02-05 at 04:39 -0800, Christoph Hellwig wrote:
> Prepare for not taking a host-wide lock in the dispatch path by pushing
> the lock down into the places that actually need it.  Note that this
> patch is just a preparation step, as it will actually increase lock
> roundtrips and thus decrease performance on its own.

I'm not really convinced by the rest of the series.  I think patches
4,8,9,10,11,12 (lock elimination from fast path and get/put reduction)
are where the improvements are at and they mostly look ready to apply
modulo some author and signoff fixes.

I'm dubious about replacing a locked set of checks and increments with
atomics for the simple reason that atomics are pretty expensive on
non-x86, so you've likely slowed the critical path down for them.  Even
on x86, atomics can be very expensive because of the global bus lock.  I
think about three of them in a row is where you might as well stick with
the lock.

Could you benchmark this lot and show what the actual improvement is
just for this series, if any?

I also think we should be getting more utility out of threading
guarantees.  So, if there's only one thread active per device we don't
need any device counters to be atomic.  Likewise, u32 read/write is an
atomic operation, so we might be able to use sloppy counters for the
target and host stuff (one per CPU that are incremented/decremented on
that CPU ... this will only work using CPU locality ... completion on
same CPU but that seems to be an element of a lot of stuff nowadays).

I'm not saying this will all pan out, but I am saying I don't think just
making all the counters atomic to reduce locking will buy us a huge
amount, so I'd appreciate careful benchmarking to confirm or invalidate
this hypothesis first.

James


