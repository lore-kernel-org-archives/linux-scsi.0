From: Tejun Heo <htejun@gmail.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Wed, 26 Mar 2008 09:54:22 +0900
Message-ID: <47E99EBE.7010708@gmail.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.229]:7343 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbYCZAyd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 20:54:33 -0400
Received: by qb-out-0506.google.com with SMTP id e11so4150672qbe.15
        for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2008 17:54:30 -0700 (PDT)
In-Reply-To: <47E99A02.7040903@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hello,

Mark Lord wrote:
> So have we.  sysfs is a total nightmare to extract information from
> under program / script control.  The idea presented in this thread,
> is to have it cross-index the contents with a method that actually
> makes it easy to access in many common scenarios, without requiring
> huge gobs of code in user space.  Or in kernel space.
> 
> And it's not just a few 10s of lines of code currently,
> but rather about 80-100 lines just to find the correct device subdir,
> and *then* a few more 10s of lines of code to retrieve the value.
> 
> In a bulletproof fashion, that is.  Sure it can be slightly smaller
> if niceties such as error checking/handling are omitted.
> 
> There's no guarantee that udev is present, and even if it were present,
> there's no guarantee that the names in /dev/ will match /sysfs/ pathnames,
> since udev is very configurable to do otherwise.
> 
> So lookups are by dev_t, which sysfs has no simple or even easy way
> of accomplishing.  O(n) at a minimum.
> 
> If we make it easier to access, then more programs will use it
> rather than us having to expand our tricky binary ioctl interfaces.
> 
> Isn't that part of the idea of sysfs -- to limit the need for new ioctls ?

The questions are...

1. Are we gonna push sysfs as the primary interface and not provide an
alternative interface (ioctl here) which can provide equivalent
information?  There are people running their systems w/o sysfs but I
think we're getting closer to this everyday.

2. Is udev an essential part of all systems?  I'm not sure about this
one.  Lots of small machines run w/o udev and I think udev is a bit too
high level to depend on for every system.

If both #1 and #2 are true, I agree with Mark that we need an easy to
map from device number to matching sysfs nodes.  Tools which are used
early during boot and emergency sessions need this mapping and many of
them are minimal C program w/o much dependency for a good reason.
Requiring each of them to implement their own way to map device node to
sysfs node is too awkward.

Probably something like /sys/class/block/MAJ:MIN or
/sys/class/devnums/bMAJ:MIN?

-- 
tejun
