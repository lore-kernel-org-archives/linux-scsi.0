From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: 10 Feb 2004 13:41:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076438507.2165.38.camel@mulgrave>
References: <20040120132052.GA6740@lst.de>
		<2432440000.1076430858@aslan.btc.adaptec.com>
	<1076431366.1804.24.camel@mulgrave>
	<2472850000.1076435243@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:16103 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266169AbUBJSlz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 13:41:55 -0500
In-Reply-To: <2472850000.1076435243@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-02-10 at 12:47, Justin T. Gibbs wrote:
> >> o When should the timer start?  If the HBA controls the timer, the timer
> >>   can be started only once the command is actually issued to the end device.
> >>   The watchdog is supposed to ensure that the transport/device doesn't
> >>   lockup, so the timer should only cover this period.  The mid-layer
> >>   can't have this precision.  This is even more crucial for drivers that
> >>   must temporarily hold back I/O to handle a topology change, LIP, or
> >>   other transport specific event that the mid-layer is unaware of.
> > 
> > There was a change between 2.4 and 2.6 to address this.  It was the
> > concept of eliminating driver queues entirely and using the block layer
> > queueing facilities.  Thus, a 2.6 queuecommand should either issue the
> > command or return it to the mid-layer for requeueing.
> 
> You can't get rid of driver or controller queues entirely.  The command
> will always live on some queue for some period of time before
> it goes out on the transport.  This implies that there will always
> be situations where I do not know in my queuecommand routine that the
> command needs to be stalled.  In general, for this to work, the mid-layer
> must provide:

I assert you can get rid of driver queueing.  I agree about the
controller issue queue.

If you need to stall a command after you've accepted it by returning
zero from queuecommand, you return it to the mid-layer with status
either BUSY or QUEUE_FULL.

> 1) A counting "device frozen semaphore" that the LLD or the mid-layer
>    can decrement when I/O to this device needs to be halted.

If you really need to halt everything after returning BUSY, then the
scsi_block_requests()/scsi_unblock_requests() can be used for this.

> 2) An explicit scsi cmd code indicating "requeue this request - don't
>    attempt recovery" for commands that are in internal queues that were
>    innocently affected by a recovery or transport event.

commands in the controller issue queue innocently affected by recovery
should be returned to the mid-layer with DID_RESET, where they will be
reissued.

> > As far as ACA emulation goes, perhaps you're right, it is time to remove
> > that from the drivers as well and place it up in the mid-layer.  That
> > way we'd have better knowledge of the request sense timings.
> 
> Please don't confuse the issue by using the term "ACA".  Linux doesn't
> take advantage of ACA so it has no place in this discussion.  Perhaps you
> meant "auto-sense" emulation?  (SAM3 5.9.4.2).

OK, I mean the clearing of the contingent allegiance condition in the
driver by issuing the REQUEST SENSE directly.  That's the one case where
two commands are issued under one timer.

James


