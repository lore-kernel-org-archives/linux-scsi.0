From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: bug 2400
Date: Sun, 4 Apr 2004 12:46:50 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404041216040.14668-100000@netrider.rowland.org>
References: <1081092223.2034.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:47882 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S262470AbUDDQqv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Apr 2004 12:46:51 -0400
In-Reply-To: <1081092223.2034.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 4 Apr 2004, James Bottomley wrote:

> OK, your "problem" definition is that "there's a race", which I agree
> with, I just don't agree that it's a problem.
> 
> Disconnections are fundamentally asynchronous events (a device may be
> disconnected by the user at any stage regardless of what any kernel
> internal state model is doing).  Trying to impose synchronisation on
> asynchronous events is asking for trouble.
> 
> In the open race scenario, either the open is refused or the user gets a
> fd that cannot do anything (because the device isn't there) and simply
> returns errors to all operations.  Both cases are correct, so who wins
> the race is irrelevant.

Ah, you have left out the third, bad alternative: open succeeds, user gets 
an fd that points to a deallocated device.  More details below...

> Let me illustrate: the user may disconnect the device then open it.  If
> they open it before even the USB subsystem gets notified of the
> disconnection then all the elaborate synchronisation in the world isn't
> going to be able to prevent that (the device was gone when they opened
> it, just nothing in the kernel knew that).  Since we cannot solve that
> race, there's no reason to try to solve the "some parts of the kernel
> know but others don't" part of the race.

I agree with everything except your conclusion. :-)  Just because some
outcomes of the race lead to a benign result no matter what, that doesn't
mean all outcomes will or that we can ignore the race.

Let's consider a simple example, one that doesn't have all the
complexities of the sr driver with its multiple driver layers.  The
usb-skeleton program in drivers/usb makes a good illustration; I added a
semaphore to it some time ago to protect against exactly this sort of
race.  Without that semaphore, here's what can happen:

	Open process:			Disconnect process:

	Get minor number from inode
	Lookup USB interface using
	  minor number
	Get device pointer from the
	  interface's private data
	  and check it's not NULL
					Get device pointer from the
					  interface's private data
					Set the private data to NULL
					Lock the device sem
					Unregister the minor number
					Terminate ongoing I/O operations
					Clear the device->present flag
					Unlock the device
					Since the open count is 0,
					  deallocate the device structure
	Lock the device sem --> oops

The idea is that at some stage the open process has got far enough along
to believe the device exists, but not far enough to hold a reference to
it.  (That's inevitable, since you can't try to acquire a reference until
you're sure the device does exist.)  If the disconnect process deallocates
the device at that time, there will be trouble.

Alan Stern

