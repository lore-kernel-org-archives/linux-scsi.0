From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: bug 2400
Date: Tue, 6 Apr 2004 10:00:58 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404060946430.1042-100000@ida.rowland.org>
References: <1081200462.2105.63.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3076 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263835AbUDFOBA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 10:01:00 -0400
In-Reply-To: <1081200462.2105.63.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 5 Apr 2004, James Bottomley wrote:

> On Sun, 2004-04-04 at 22:17, Alan Stern wrote:
> > Of course it would!  That's exactly what this thread is about: bugs caused
> > by improper handling of open/disconnect races.
> 
> So you're quietly shifting your ground away from this assertion:
> 
> On Sat, 2004-04-03 at 19:40, Alan Stern wrote:
> > The problem _can_ be solved by introducing a lock higher up, such as at
> > the driver level or at the bus level.  (A kernel lock would work too but
> > it would be extravagantly excessive.)  For example, the bus subsystem
> > rwsem in the driver model prevents analogous problems there.  But you
> > don't want to get a read lock on a bus-wide semaphore every time your
> > open() procedure runs!  A driver-wide lock makes a good solution.
> > 
> > Another possible solution would be to have disconnect() perform an RCU 
> > update to the device pointer.  I haven't seen any code that does this, but 
> > I think it ought to work.
> 
> ?

Not at all.  Open/disconnect races can appear at several points in a 
driver.  The earlier assertion referred to one of those points: the place 
where the code gets a pointer to a device structure from an open inode's 
private data.

> My contention is that the races can be solved by proper refcounting
> (without the need for locks and RCUs) not that we don't have any bugs in
> sd.c (I'll be happy if I can pull them all out of sr at the moment).

Your contention is correct, I agree.  However, not all parts of the kernel
implement proper refcounting and, equally important, proper
delete-then-release notifications.  In particular, the VFS layer doesn't.  
If a driver notifies VFS that a device has been disconnected so that the
private data in the corresponding /dev inode entry can be removed, the
driver does _not_ receive a release notification in return when the last
process actively using that inode has finished with it.

Given the lack of proper adherence to the object-lifetime rules in VFS,
a driver has no choice but to adopt a scheme similar to what I outlined
in the section you quoted above.  _That's_ the manifestation of the
open/disconnect race I was referring to.  (It's different from the 
problems in sd.c, incidentally.)

Alan Stern

