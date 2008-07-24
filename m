From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Thu, 24 Jul 2008 10:32:45 +0900
Message-ID: <20080724103322Q.fujita.tomonori@lab.ntt.co.jp>
References: <20080722175537.GB8833@beardog.cca.cpqcorp.net>
	<20080723155005.GF8833@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42115 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYGXBhH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jul 2008 21:37:07 -0400
In-Reply-To: <20080723155005.GF8833@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, fujita.tomonori@lab.ntt.co.jp

CC'ed linux-scsi.

On Wed, 23 Jul 2008 10:50:05 -0500
scameron@beardog.cca.cpqcorp.net wrote:

> 
> Fujita Tomonori wrote:
> > I created symbolic links (neat udev rules can do automatically).
> > 
> > clover:/home/fujita# ls -l /dev/cciss/
> > total 0
> > lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d0 -> /dev/sde
> > lrwxrwxrwx 1 root root 9 2008-07-23 21:39 c0d0p1 -> /dev/sde1
> > lrwxrwxrwx 1 root root 9 2008-07-23 21:39 c0d0p2 -> /dev/sde2
> > lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d1 -> /dev/sdf
> > lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d2 -> /dev/sdg
> > lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d3 -> /dev/sdh
> > 
> > The symbolic links enable users to mount the device as before.
> > 
> > hpacucli seems to work (I didn't try all the commands but the point is
> > that we can provide the ioctl compatibility): 
> 
> That's pretty neat, I'm surprised that works.  Obviously
> you've got the needed ioctls already done. 

I've not finished ioctls but my driver supports it partly.


> I bet if you deleted all the logical drives it wouldn't work
> anymore (because /dev/cciss/c0d0 -> /dev/sde would disappear.)

Yeah, right. As you know, cciss doesn't have a global character device
for it so the tools don't work if no logical device exists.


> A way around that would be to present a device to the linux
> kernel with 8-byte LUN address of all zeroes mapped to some
> bus/target/lun.  When the SCSI scan happens and the inquiry
> is sent down to this address, the RAID controller will respond.
> Then let sg bind to that, and get ACU to use the sg device.
> (I hope it's clear what I'm saying.)
> 
> I don't know if the udev rules can be made smart enough to
> point /dev/cciss/c0d0 at the sg device if there are no 

udev rules can execute external programs. So you can make udev rules
do whatever you want.


> logical drives, and at the first logical drive if there 
> is at least one.   In the longer term, ACU would have to 
> be changed to use that sg device always rather than using
> /dev/cciss/c0d0.
> 
> In the cciss driver, we always present /dev/cciss/c0d0
> whether there are any logical drives or not for this reason,
> a rather clunky solution.

Ideally, I think that the best solution is exporting a RAID device so
that the management tools can access to hardware via it (as other SCSI
drivers do). But we need the compatibility here. So I'm not sure. I'll
follow Mike's decision.
