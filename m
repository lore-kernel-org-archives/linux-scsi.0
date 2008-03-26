From: Greg KH <gregkh@suse.de>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 20:38:04 -0700
Message-ID: <20080326033804.GA27925@suse.de>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca> <47E99EBE.7010708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:41400 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYCZDdG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Mar 2008 23:33:06 -0400
Content-Disposition: inline
In-Reply-To: <47E99EBE.7010708@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <lkml@rtr.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Mar 26, 2008 at 09:54:22AM +0900, Tejun Heo wrote:
> Hello,
> 
> Mark Lord wrote:
> > So have we.  sysfs is a total nightmare to extract information from
> > under program / script control.  The idea presented in this thread,
> > is to have it cross-index the contents with a method that actually
> > makes it easy to access in many common scenarios, without requiring
> > huge gobs of code in user space.  Or in kernel space.
> > 
> > And it's not just a few 10s of lines of code currently,
> > but rather about 80-100 lines just to find the correct device subdir,
> > and *then* a few more 10s of lines of code to retrieve the value.

I think you are using either the wrong programming language, or your
sysfs walking logic is quite convulted.  Look at the udev and HAL code
if you want to steal some compact, working sysfs code :)

> > In a bulletproof fashion, that is.  Sure it can be slightly smaller
> > if niceties such as error checking/handling are omitted.
> > 
> > There's no guarantee that udev is present, and even if it were present,
> > there's no guarantee that the names in /dev/ will match /sysfs/ pathnames,
> > since udev is very configurable to do otherwise.
> > 
> > So lookups are by dev_t, which sysfs has no simple or even easy way
> > of accomplishing.  O(n) at a minimum.

And again, is this a performance requiring operation?

> > If we make it easier to access, then more programs will use it
> > rather than us having to expand our tricky binary ioctl interfaces.
> > 
> > Isn't that part of the idea of sysfs -- to limit the need for new ioctls ?
> 
> The questions are...
> 
> 1. Are we gonna push sysfs as the primary interface and not provide an
> alternative interface (ioctl here) which can provide equivalent
> information?  There are people running their systems w/o sysfs but I
> think we're getting closer to this everyday.

Exactly, originally you suggested a new ioctl, which would be trivial to
add, and trivial to switch any program that was currently using an ioctl
to get the disk size, to use it instead.

Since when is the major:minor view of devices the "standard" one that
userspace uses?  Last I looked, userspace uses symlinks and lots of
other ways of directly accessing block devices in /dev/, and does not
rely on major:minor.

And finally, I haven't seen a patch that implements this "shadow" tree,
it would be interesting to see if it could even be done.

> 2. Is udev an essential part of all systems?  I'm not sure about this
> one.  Lots of small machines run w/o udev and I think udev is a bit too
> high level to depend on for every system.

My tiny little phone runs udev, I don't see why anyone wouldn't run it
these days, except in very limited embedded applications with no dynamic
devices.  But if you are in that situation, you aren't querying the size
of any random block device either :)

And heck, this phone is a very limited embedded application, with razor
thin margins, if it can use udev, I'd be interested in hearing the
justifications for anyone who says it is too large for their systems to
use it.

> If both #1 and #2 are true, I agree with Mark that we need an easy to
> map from device number to matching sysfs nodes.  Tools which are used
> early during boot and emergency sessions need this mapping and many of
> them are minimal C program w/o much dependency for a good reason.
> Requiring each of them to implement their own way to map device node to
> sysfs node is too awkward.
> 
> Probably something like /sys/class/block/MAJ:MIN or
> /sys/class/devnums/bMAJ:MIN?

Why the preopcupation with major:minor?  Just because you are able to
grab it from an open file handle?  Heck, why not just an ioctl to get
the path within sysfs for the device currently open?  :)

thanks,

greg k-h
