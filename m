From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Tue, 10 Feb 2004 10:47:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2472850000.1076435243@aslan.btc.adaptec.com>
References: <20040120132052.GA6740@lst.de> 	<2432440000.1076430858@aslan.btc.adaptec.com> <1076431366.1804.24.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:57039 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266101AbUBJRkq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 12:40:46 -0500
In-Reply-To: <1076431366.1804.24.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

>> o When should the timer start?  If the HBA controls the timer, the timer
>>   can be started only once the command is actually issued to the end device.
>>   The watchdog is supposed to ensure that the transport/device doesn't
>>   lockup, so the timer should only cover this period.  The mid-layer
>>   can't have this precision.  This is even more crucial for drivers that
>>   must temporarily hold back I/O to handle a topology change, LIP, or
>>   other transport specific event that the mid-layer is unaware of.
> 
> There was a change between 2.4 and 2.6 to address this.  It was the
> concept of eliminating driver queues entirely and using the block layer
> queueing facilities.  Thus, a 2.6 queuecommand should either issue the
> command or return it to the mid-layer for requeueing.

You can't get rid of driver or controller queues entirely.  The command
will always live on some queue for some period of time before
it goes out on the transport.  This implies that there will always
be situations where I do not know in my queuecommand routine that the
command needs to be stalled.  In general, for this to work, the mid-layer
must provide:

1) A counting "device frozen semaphore" that the LLD or the mid-layer
   can decrement when I/O to this device needs to be halted.

2) An explicit scsi cmd code indicating "requeue this request - don't
   attempt recovery" for commands that are in internal queues that were
   innocently affected by a recovery or transport event.

FreeBSD has had this concept since '97, and I'd be more than happy to
use it if it were available and worked in Linux.

> If you're spending seconds in the HW issue queue, there's something
> wrong in the way the queue is working.

Who's to say that the timeout duration is seconds?  I've worked on several
products where the largest timeout for disk I/O was perhaps 100ms.  My
drivers are pretty good about not holding locks for long periods, but it is
not hard for me to believe that certain recovery operations may end up
holding off the queue of a new transaction for 10s of milliseconds in the
worst case.

>> o When should the timer be stopped?  On command completion, of course,
>>   but there are other, transport specific, times when the timer may need
>>   to be stopped prematurely or given a completely different value than
>>   what was originally given.  For example, on transports that do not
>>   provide error/sense data with every completion, the HBA may have to
>>   issue another command, without the knowledge of the mid-layer, to
>>   retrieve this data.  Since the original command has already completed,
>>   the original timer should not be running.  A new timer, tailored to
>>   the characteristics of retrieving sense data should be running instead.
>>   If the old timer is left running and expires, which command timed out?
>>   The original command or the request sense command?  The HBA knows,
>>   but the mid-layer does not.
> 
> commands are stopped as soon as the device acks.  scsi_done() is
> designed to be called from interrupt level.  This can be done with or
> without the lock since it uses a per cpu queue.

I'm well aware of how scsi_done() works.  The argument above has nothing to
do with normal completions.

> As far as ACA emulation goes, perhaps you're right, it is time to remove
> that from the drivers as well and place it up in the mid-layer.  That
> way we'd have better knowledge of the request sense timings.

Please don't confuse the issue by using the term "ACA".  Linux doesn't
take advantage of ACA so it has no place in this discussion.  Perhaps you
meant "auto-sense" emulation?  (SAM3 5.9.4.2).

For auto-sense to work, the driver will have to:

1) Abort all I/O waiting for issuance to the device.  On the aic7xxx and
   aic79xx hardware, there can be 10s of I/Os waiting to be issued to the
   device on the controller queue.  These would have to be aborted to the
   mid-layer in order to not clobber the sense information.

2) The mid-layer would have to queue the request sense operation at the
   head of the device's transaction queue to ensure it is the next command
   sent to the device.

To do this safely, and to allow the controller to abort pending transactions
in whatever order it finds convenient, the mid-layer should allow the LLD
to decrement the device queue frozen semaphore for each aborted command while
setting a flag in the command structure indicating it has done so.  The 
mid-layer can then up the semaphore after successfully processing each
command.  This ensures that the mid-layer cannot proceed until it has "seen"
the command that has the check condition.

Of course, not all controllers have this kind of ability, and the controller
drivers can often guarantee ordering in a controller specific manner without
all these complication.  You should also consider that any additional latency
added to this path may adversly effect tape (consider ILI reporting) and other
peripheral type performance where check conditions are more routine.
However, if you really want to go this route and you make the mid-layer handle
it correctly, I won't get in your way.

--
Justin

