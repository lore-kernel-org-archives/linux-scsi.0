From: Tejun Heo <htejun@gmail.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Wed, 26 Mar 2008 13:24:55 +0900
Message-ID: <47E9D017.5080305@gmail.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca> <47E99EBE.7010708@gmail.com> <20080326033804.GA27925@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.232]:31640 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYCZEZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Mar 2008 00:25:05 -0400
Received: by qb-out-0506.google.com with SMTP id e11so4215684qbe.15
        for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2008 21:25:04 -0700 (PDT)
In-Reply-To: <20080326033804.GA27925@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Mark Lord <lkml@rtr.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hello, Greg.

Greg KH wrote:
>> 1. Are we gonna push sysfs as the primary interface and not provide an
>> alternative interface (ioctl here) which can provide equivalent
>> information?  There are people running their systems w/o sysfs but I
>> think we're getting closer to this everyday.
> 
> Exactly, originally you suggested a new ioctl,

Well, I like Mark but am not really him.  :-)

> which would be trivial to
> add, and trivial to switch any program that was currently using an ioctl
> to get the disk size, to use it instead.

That should be the simplest solution for the problem at hand.

> Since when is the major:minor view of devices the "standard" one that
> userspace uses?  Last I looked, userspace uses symlinks and lots of
> other ways of directly accessing block devices in /dev/, and does not
> rely on major:minor.

The fact that major:minor is the unique identifier of a device makes it
a bit special compared to other names on filesystem.

> And finally, I haven't seen a patch that implements this "shadow" tree,
> it would be interesting to see if it could even be done.

It's possible, all that's needed are symlinks.  We do similar things all
the time.

>> 2. Is udev an essential part of all systems?  I'm not sure about this
>> one.  Lots of small machines run w/o udev and I think udev is a bit too
>> high level to depend on for every system.
> 
> My tiny little phone runs udev, I don't see why anyone wouldn't run it
> these days, except in very limited embedded applications with no dynamic
> devices.  But if you are in that situation, you aren't querying the size
> of any random block device either :)
> 
> And heck, this phone is a very limited embedded application, with razor
> thin margins, if it can use udev, I'd be interested in hearing the
> justifications for anyone who says it is too large for their systems to
> use it.

I agree udev is affordable for most cases but it's still a major step to
require it for every system.  I would hate to hear that hdparm or fdisk
doesn't work unless udev is online.  These are tools which are used to
recover systems.

>> If both #1 and #2 are true, I agree with Mark that we need an easy to
>> map from device number to matching sysfs nodes.  Tools which are used
>> early during boot and emergency sessions need this mapping and many of
>> them are minimal C program w/o much dependency for a good reason.
>> Requiring each of them to implement their own way to map device node to
>> sysfs node is too awkward.
>>
>> Probably something like /sys/class/block/MAJ:MIN or
>> /sys/class/devnums/bMAJ:MIN?
> 
> Why the preopcupation with major:minor?  Just because you are able to
> grab it from an open file handle?  Heck, why not just an ioctl to get
> the path within sysfs for the device currently open?  :)

Because major:minor is the key attribute to devices?

Thanks.

-- 
tejun
