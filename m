From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 04 Apr 2004 11:23:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081092223.2034.8.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:36767 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262431AbUDDPYe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Apr 2004 11:24:34 -0400
In-Reply-To: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-04-03 at 20:40, Alan Stern wrote:
> Without having looked recently in any detail at the specific code in sd.c
> or sr.c, I want to comment in general terms on the nature of the
> open/disconnect race.
> 
> It's a generic problem that affects every driver whose devices can be
> opened through the filesystem.  It _cannot_ be solved by adding any sort
> of lock to the device structure.  This is because the device structure is
> not available to the open() routine until it has followed some pointer
> from the major/minor device table entry, and the disconnect() routine will
> erase the pointer.  That (or someplace equivalent) is where the race
> occurs.

OK, your "problem" definition is that "there's a race", which I agree
with, I just don't agree that it's a problem.

Disconnections are fundamentally asynchronous events (a device may be
disconnected by the user at any stage regardless of what any kernel
internal state model is doing).  Trying to impose synchronisation on
asynchronous events is asking for trouble.

In the open race scenario, either the open is refused or the user gets a
fd that cannot do anything (because the device isn't there) and simply
returns errors to all operations.  Both cases are correct, so who wins
the race is irrelevant.

Let me illustrate: the user may disconnect the device then open it.  If
they open it before even the USB subsystem gets notified of the
disconnection then all the elaborate synchronisation in the world isn't
going to be able to prevent that (the device was gone when they opened
it, just nothing in the kernel knew that).  Since we cannot solve that
race, there's no reason to try to solve the "some parts of the kernel
know but others don't" part of the race.

James


> The problem _can_ be solved by introducing a lock higher up, such as at
> the driver level or at the bus level.  (A kernel lock would work too but
> it would be extravagantly excessive.)  For example, the bus subsystem
> rwsem in the driver model prevents analogous problems there.  But you
> don't want to get a read lock on a bus-wide semaphore every time your
> open() procedure runs!  A driver-wide lock makes a good solution.
> 
> Another possible solution would be to have disconnect() perform an RCU 
> update to the device pointer.  I haven't seen any code that does this, but 
> I think it ought to work.
> 
> Alan Stern
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


