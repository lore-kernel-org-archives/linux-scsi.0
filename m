From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: 10 Feb 2004 11:42:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076431366.1804.24.camel@mulgrave>
References: <20040120132052.GA6740@lst.de>
	<2432440000.1076430858@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:28384 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265984AbUBJQm6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 11:42:58 -0500
In-Reply-To: <2432440000.1076430858@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-02-10 at 11:34, Justin T. Gibbs wrote:
> o When should the timer start?  If the HBA controls the timer, the timer
>   can be started only once the command is actually issued to the end device.
>   The watchdog is supposed to ensure that the transport/device doesn't
>   lockup, so the timer should only cover this period.  The mid-layer
>   can't have this precision.  This is even more crucial for drivers that
>   must temporarily hold back I/O to handle a topology change, LIP, or
>   other transport specific event that the mid-layer is unaware of.

There was a change between 2.4 and 2.6 to address this.  It was the
concept of eliminating driver queues entirely and using the block layer
queueing facilities.  Thus, a 2.6 queuecommand should either issue the
command or return it to the mid-layer for requeueing.

I know that "issue the command" means queue in the device internal issue
queue for quite a few devices.  However, the time to traverse this queue
should be as short as possible.  The driver is free to watchdog the HW
issue queue to make sure it operates.

If you're spending seconds in the HW issue queue, there's something
wrong in the way the queue is working.

The bottom line is that the elimination of software queueing in drivers
should have dispensed with the need to modify the mid-layer timers.

> o When should the timer be stopped?  On command completion, of course,
>   but there are other, transport specific, times when the timer may need
>   to be stopped prematurely or given a completely different value than
>   what was originally given.  For example, on transports that do not
>   provide error/sense data with every completion, the HBA may have to
>   issue another command, without the knowledge of the mid-layer, to
>   retrieve this data.  Since the original command has already completed,
>   the original timer should not be running.  A new timer, tailored to
>   the characteristics of retrieving sense data should be running instead.
>   If the old timer is left running and expires, which command timed out?
>   The original command or the request sense command?  The HBA knows,
>   but the mid-layer does not.

commands are stopped as soon as the device acks.  scsi_done() is
designed to be called from interrupt level.  This can be done with or
without the lock since it uses a per cpu queue.

scsi_done stops the timer immediately.  Command processing is deferred
until the scsi softirq.

As far as ACA emulation goes, perhaps you're right, it is time to remove
that from the drivers as well and place it up in the mid-layer.  That
way we'd have better knowledge of the request sense timings.

James 


