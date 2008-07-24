From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Thu, 24 Jul 2008 10:32:45 +0900
Message-ID: <20080724101953R.fujita.tomonori@lab.ntt.co.jp>
References: <20080722175729.GC8833@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42107 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbYGXBgz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jul 2008 21:36:55 -0400
In-Reply-To: <20080722175729.GC8833@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

CC'ed linux-scsi, why did you drop it?

On Tue, 22 Jul 2008 12:57:29 -0500
scameron@beardog.cca.cpqcorp.net wrote:

> James Bottomley wrote:
> > Actually, I think we can make one (which is really required ... it's a
> > lot of pain to move device nodes, just look at libata).  It should be
> > child's play to come up with a udev rule that simply does extra symbolic
> > links from /dev/cciss<n>c<n>p<n> to whatever the sd device is.  That
> > should hide a lot of the problem.
> > 
> > The other issue is plugging the management ioctl in, but that can be
> > done via scsi_host->ioctl.
> > 
> > James 
> 
> Another thing which would help would be to expose device type 0x0C (raid
> controller) and let sg bind to it.

Yeah, it's possible (and might be useful). Actually, my first version
exposed a RAID device. I'm not sure yet what's the best way to expose
CCISS logical and physical units (including a RAID device) to SCSI
logical unit numbers.


> It is a little hard to see what Tomo's patch does, as it's all in one step.
> 
> In the times I've converted cciss to be a SCSI driver in the past 
> the steps were more or less as follows (from memory):
> 
> 1) copy the driver files into drivers/scsi,
> 2) rename everything, change the Makefile/Kconfig stuff to add in the new code.
> 3) take out the stuff that makes it a block driver

Sounds reasonable, I did the similar.


> 4) add a CCISS_REPORT_LOGICAL_LUNS call into the scsi tape device discovery
> code, expose those devices, add the controller itself in to the list of devices
> artificially (8-byte lun address == all zeroes).
> 
> At this point the driver will work, but performance will completely suck.
> 
> 5) switch the tape code to use the block side command allocator, (cmd_alloc()
> in cciss.c) and ditch the rinky-dink tape code command allocator
> (scsi_cmd_alloc() in cciss_scsi.c) and jack up the number of commands 
> and queue depth the SCSI side of the driver will support to something 
> reasonable.

Yeah, right. I've not cleaned up this part yet. We need to rework on
command allocation and queue depth management. I think that the scsi
subsystem enables us to simplify (and improve) the queue depth
management code.


> At this point performance will stop completely sucking.
> 
> 6) rip out a bunch of the block side code.
> 7) (I've never actually done this step) move the necessary ioctls to the scsi
> side of the driver.
> 
> The tape code has stuff for hot-plugging of things, sort of (and I sent up some
> patches some time ago to make that better awhile ago, but they seemed to get
> ignored for whatever reason.) This would need to change to be a bit more
> careful (look at page 0x83 serial numbers to find what devices were
> new/changed/gone rather than just looking at device type, which is what it's
> doing now.  BTW, I have patches in the works for the block driver to improve
> the behavior of rebuild_lun_table, which currently sucks in the brute force way
> that it does things.  This patch also removes the duplicated discovery
> cdde from cciss_init_one, and has cciss_init_one just call rebuild_lun_table(),
> but I digress.)

Yeah, I think that the device scanning code is an area that we need to
rework on. We need to make it work nicely with the scsi infrastructure.


> In any case, I don't think what I described above was what was done here... It
> looks like the tape code was ditched, and new code that does almost the same
> thing was written.  Maybe there was a good reason for that, I don't know.

I didn't integrate the tape code because it was just an RFC. I just
read the cciss code and converted it to a scsi driver. Of course, we
need to integrate the tape support to a scsi cciss driver.
