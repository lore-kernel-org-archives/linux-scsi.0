From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Thu, 27 Mar 2008 20:29:11 +0100
Message-ID: <3ae72650803271229h6e188de1t81ccfb64e5d3a214@mail.gmail.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca>
	 <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca>
	 <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca>
	 <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca>
	 <47E99EBE.7010708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47E99EBE.7010708@gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 26, 2008 at 1:54 AM, Tejun Heo <htejun@gmail.com> wrote:
>  Mark Lord wrote:
>  > So have we.  sysfs is a total nightmare to extract information from
>  > under program / script control.  The idea presented in this thread,
>  > is to have it cross-index the contents with a method that actually
>  > makes it easy to access in many common scenarios, without requiring
>  > huge gobs of code in user space.  Or in kernel space.
>  >
>  > And it's not just a few 10s of lines of code currently,
>  > but rather about 80-100 lines just to find the correct device subdir,
>  > and *then* a few more 10s of lines of code to retrieve the value.
>  >
>  > In a bulletproof fashion, that is.  Sure it can be slightly smaller
>  > if niceties such as error checking/handling are omitted.
>  >
>  > There's no guarantee that udev is present, and even if it were present,
>  > there's no guarantee that the names in /dev/ will match /sysfs/ pathnames,
>  > since udev is very configurable to do otherwise.
>  >
>  > So lookups are by dev_t, which sysfs has no simple or even easy way
>  > of accomplishing.  O(n) at a minimum.
>  >
>  > If we make it easier to access, then more programs will use it
>  > rather than us having to expand our tricky binary ioctl interfaces.
>  >
>  > Isn't that part of the idea of sysfs -- to limit the need for new ioctls ?
>
>  The questions are...
>
>  1. Are we gonna push sysfs as the primary interface and not provide an
>  alternative interface (ioctl here) which can provide equivalent
>  information?  There are people running their systems w/o sysfs but I
>  think we're getting closer to this everyday.
>
>  2. Is udev an essential part of all systems?  I'm not sure about this
>  one.  Lots of small machines run w/o udev and I think udev is a bit too
>  high level to depend on for every system.
>
>  If both #1 and #2 are true, I agree with Mark that we need an easy to
>  map from device number to matching sysfs nodes.  Tools which are used
>  early during boot and emergency sessions need this mapping and many of
>  them are minimal C program w/o much dependency for a good reason.
>  Requiring each of them to implement their own way to map device node to
>  sysfs node is too awkward.
>
>  Probably something like /sys/class/block/MAJ:MIN

"Devices directories" are not supposed to contain duplicate entries.
It would slow-down, or may even break things.

> or /sys/class/devnums/bMAJ:MIN?

These are no devices belonging to the class "devnums", so it may
confuse things which crawl these directories to get "all devices".
Current coldplug-like setups will likely add duplicate devices with
the wrong subsystem. There are also bus-devices with have a dev_t, and
that will make them show up in /sys/class, which might confuse some
tools too.

I guess we will need to find some other solution as a /sys/class/ for
that. And we must prefix the links with 'c' and 'b' because dev_t is
not unique across char and block devices.

Thanks,
Kay
