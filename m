From: Mark Lord <lkml@rtr.ca>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 20:34:10 -0400
Message-ID: <47E99A02.7040903@rtr.ca>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:2876 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661AbYCZAeM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Mar 2008 20:34:12 -0400
In-Reply-To: <20080325192515.GA24234@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greg KH wrote:
> On Tue, Mar 25, 2008 at 01:37:03PM -0400, Mark Lord wrote:
>> Perhaps Greg will chime in.
> 
> I've been waiting to see if sanity will take hold of anyone here.
..

So have we.  sysfs is a total nightmare to extract information from
under program / script control.  The idea presented in this thread,
is to have it cross-index the contents with a method that actually
makes it easy to access in many common scenarios, without requiring
huge gobs of code in user space.  Or in kernel space.

And it's not just a few 10s of lines of code currently,
but rather about 80-100 lines just to find the correct device subdir,
and *then* a few more 10s of lines of code to retrieve the value.

In a bulletproof fashion, that is.  Sure it can be slightly smaller
if niceties such as error checking/handling are omitted.

There's no guarantee that udev is present, and even if it were present,
there's no guarantee that the names in /dev/ will match /sysfs/ pathnames,
since udev is very configurable to do otherwise.

So lookups are by dev_t, which sysfs has no simple or even easy way
of accomplishing.  O(n) at a minimum.

If we make it easier to access, then more programs will use it
rather than us having to expand our tricky binary ioctl interfaces.

Isn't that part of the idea of sysfs -- to limit the need for new ioctls ?

Cheers
