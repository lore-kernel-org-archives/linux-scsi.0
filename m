From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Tue, 10 Feb 2004 09:34:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2432440000.1076430858@aslan.btc.adaptec.com>
References: <20040120132052.GA6740@lst.de>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:30350 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265995AbUBJQ1n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 11:27:43 -0500
In-Reply-To: <20040120132052.GA6740@lst.de>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

> We all know talk is cheap, so here's a first draft patch to allow LLDDs
> to get control first after a command timeout.  Justin, does this look
> okay for you?  BTW, your drivers are the last ones using scsi_add_timer
> from outside the midlayer, if we could get rid of that we'd be able to
> keep the interface private.

[ Sorry for taking so long to get back to you.  Things are still very
  hectic here... ]

I would rather not lose the ability for LLDs to setup/modify/etc.
timers.  This is because in an ideal world, the mid-layer and peripheral
drivers would specify the timeout value and let the LLD start and stop
the timer as it sees fit.   I say this because the mid-layer just can't
know all of the information that the HBA driver does:

o When should the timer start?  If the HBA controls the timer, the timer
  can be started only once the command is actually issued to the end device.
  The watchdog is supposed to ensure that the transport/device doesn't
  lockup, so the timer should only cover this period.  The mid-layer
  can't have this precision.  This is even more crucial for drivers that
  must temporarily hold back I/O to handle a topology change, LIP, or
  other transport specific event that the mid-layer is unaware of.

o When should the timer be stopped?  On command completion, of course,
  but there are other, transport specific, times when the timer may need
  to be stopped prematurely or given a completely different value than
  what was originally given.  For example, on transports that do not
  provide error/sense data with every completion, the HBA may have to
  issue another command, without the knowledge of the mid-layer, to
  retrieve this data.  Since the original command has already completed,
  the original timer should not be running.  A new timer, tailored to
  the characteristics of retrieving sense data should be running instead.
  If the old timer is left running and expires, which command timed out?
  The original command or the request sense command?  The HBA knows,
  but the mid-layer does not.

If you just allow the LLD drivers to claim responsibility for setting
and tearing down timers, there is no need to redirect the timer
action.  All that would be required is a check of a flag in the host
structure in scsi_add_timer to avoid starting the timer at all and
another check in scsi_done that doesn't enforce that a timer be
active on completion.

--
Justin

