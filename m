From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: bug 2400
Date: Sat, 3 Apr 2004 20:40:58 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>
References: <1080951925.1829.172.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:25098 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S262085AbUDDBk7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Apr 2004 20:40:59 -0500
In-Reply-To: <1080951925.1829.172.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 2 Apr 2004, James Bottomley wrote:

> On Fri, 2004-04-02 at 18:40, Mike Anderson wrote:
> > Greg stopped by and after talking this over I think I see why sd is
> > racing in its current form. The race happens when sd_remove and do_open
> > race. Even though I do not like adding a lock_kernel it would appear
> > adding on to sd_remove would serialize sd_remove and do_open. This would
> > ensure either do_open's get_gendisk returns a gendisk struct and sd
> > ref's are incremented or we will start cleaning up and sd_open will not
> > be called.
> > 
> > I would believe similar alignment in sr.c to what sd is doing plus
> > agreement on the lock_kernel should fix both drivers.
> > 
> > I think the "error out correctly" on trying to get a ref on sdev_gendev
> > may need some higher serialization as I think there is a race on a release
> > function starting and the reference count trying to be taken to 1 (i.e.
> > you need something subsystem wide as you cannot look at the item you
> > maybe deleting.
> 
> I'm not convinced we need any other serialisation.  As long as we get
> the reference we may use the device (of course if the device is being
> removed and sd_remove is being called, then I/O to it will fail, but I
> think that's fine). Leaving the user with an open device that won't
> accept I/O is also fine (as long as it returns the correct error codes).
> 
> Could you outline what the consequences of this race are?

Without having looked recently in any detail at the specific code in sd.c
or sr.c, I want to comment in general terms on the nature of the
open/disconnect race.

It's a generic problem that affects every driver whose devices can be
opened through the filesystem.  It _cannot_ be solved by adding any sort
of lock to the device structure.  This is because the device structure is
not available to the open() routine until it has followed some pointer
from the major/minor device table entry, and the disconnect() routine will
erase the pointer.  That (or someplace equivalent) is where the race
occurs.

The problem _can_ be solved by introducing a lock higher up, such as at
the driver level or at the bus level.  (A kernel lock would work too but
it would be extravagantly excessive.)  For example, the bus subsystem
rwsem in the driver model prevents analogous problems there.  But you
don't want to get a read lock on a bus-wide semaphore every time your
open() procedure runs!  A driver-wide lock makes a good solution.

Another possible solution would be to have disconnect() perform an RCU 
update to the device pointer.  I haven't seen any code that does this, but 
I think it ought to work.

Alan Stern

