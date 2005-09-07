From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Wed, 7 Sep 2005 15:31:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509071519080.4988-100000@iolanthe.rowland.org>
References: <431F3486.4060704@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:5532 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932228AbVIGTbx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 15:31:53 -0400
In-Reply-To: <431F3486.4060704@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 7 Sep 2005, Luben Tuikov wrote:

> On 09/07/05 14:27, Alan Stern wrote:

> > I'm going to argue strongly about this.  scsi_remove_host should _not_
> > wait for error recovery to complete -- to do so will invite deadlocks.  
> > (Suppose the error handler is waiting for a bus reset, but the bus reset
> > routine requires a semaphore held by the LLD during the call to
> > scsi_remove_host?)  Furthermore, error recovery can potentially take quite
> > a long time -- much longer than we want to wait during a removal event.  
> > Instead, the error handler should not be allowed to make the transition to
> > RUNNING once the removal has started.
> 
> Alan, this tells me one thing: the _layering_ infrastructure is broken,
> and in this case, it looks like is not SCSI Core.
> 
> E.g. why is the LLDD messing with semas of the host? (rhetorical, please
> do not answer as this would go into another thread...)
> 
> BTW, since the eh is a _function of the host_, James is correct that
> scsi_remove_host should wait for the eh to finish.

That's a very good point.  It hadn't occurred to me before, but you're
absolutely right.  scsi_remove_host should indeed wait for the error
handler to finish.  But first it should set things up so that the
everything the error handler does will fail-fast, so that the eh can
return quickly.  That will include putting the device into the SDEV_CANCEL
state, so it remains true that the error handler better not try to move
from CANCEL back to RUNNING.

As for layering violations and deadlocks...  Unfortunately the violation
is unavoidable.  It's related to the way the error handler sometimes tries
to fix a non-working device by doing a bus reset, which will also affect
all the other devices on the same bus.  The same sort of thing applies to
USB.  Fortunately the deadlock _is_ avoidable; in fact the USB driver
already has code in place to fail the reset attempt if it takes too long
to acquire the lock.  So that's no longer an issue.

> This makes me believe that maybe USB storage would need an overhaul
> of the event infra: removing and adding, and/or implement its own
> eh.

In the long run that might be good, but for now I think we'll be okay.  
The important thing is to make sure that once the device has moved to the
CANCEL state, everything fails quickly.

Alan Stern

