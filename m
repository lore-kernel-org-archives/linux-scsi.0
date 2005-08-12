From: corene@polyserve.com
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Fri, 12 Aug 2005 09:07:09 -0600
Message-ID: <200508121507.j7CF79o14855@zion.ut.polyserve.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [205.240.78.250] ([205.240.78.250]:14723 "EHLO
	zion.ut.polyserve.com") by vger.kernel.org with ESMTP
	id S1750831AbVHLPJi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 11:09:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hbryan@us.ibm.com, SEIPP@de.ibm.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

> From linux-scsi-owner@vger.kernel.org  Fri Aug 12 03:31:22 2005
> Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
> To: Bryan Henderson <hbryan@us.ibm.com>
> Cc: James Bottomley <James.Bottomley@SteelEye.com>,
>    SCSI Mailing List <linux-scsi@vger.kernel.org>
> From: Harald Seipp <SEIPP@de.ibm.com>
> Date: 	Fri, 12 Aug 2005 10:59:00 +0200
>
> > Don't use /etc/mtab.  Don't use it for anything if you can help it; it
> was
> > important technology in its day, but we can now go to the horse's mouth
> --
> > the kernel -- for that information.
> > /proc/mounts will tell you what is really mounted.
> But:
> 1. /proc/mounts hides the most important information - the physical device
> of the root fs - it will always be /dev/root - so I don't see a way to get
> down to the physical device
> 2. In my understanding, long-term-strategically procfs will only be used
> for process information and all other information should be covered by
> sysfs. So I doubt that using /proc/mounts will be a long-term solution
> >
> > As you mentioned in another posting, this isn't really the information
> you
> > want either -- you want to know if the SCSI disk is in use.  Being the
> > device backing a conventional filesystem image is only one way a SCSI
> disk
> > might be in use.
> For our usage, the device ref count information would be enough - we won't
> care about the difference if the device is really mounted or if just one
> process is sitting inside the sysfs tree of the device, we just would not
> issue the remove-single-device to that device.
>

I've only been skimming this thread, so forgive me if this is completely
offtrack from what you're trying to do.  But if your goal is to determine
if the device is in-use, and you're okay with just a 'point-in-time'
reading on it (since obviously the state could change at any time),
one possible solution would be to open the disk (not the partition, the
disk itself), and do a BLKRRPART ioctl on it.  This ioctl fails
(I believe with EBUSY) if the device or any of its partitions have any
open references, so this might give you the information you want.
(Of course, it also has the effect of making the kernel update its notion
of the disk's partition table, so if you can think of a scenario where
that would cause a problem, you wouldn't want to use this approach!
Although since it only succeeds if the disk is completely not in-use,
offhand it doesn't seem like it should be a problem).
Well, just an idea.
-corene

----------------------------------------------------------------------
Corene Casper				email: corene@polyserve.com
Polyserve, Inc.
