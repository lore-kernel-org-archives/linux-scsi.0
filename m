From: maximilian attems <maks@sternwelten.at>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Thu, 26 Oct 2006 21:53:22 +0200
Message-ID: <20061026195322.GC12013@nancy>
References: <20060511143352.GI12272@parisc-linux.org> <20060518172258.GL1604@parisc-linux.org> <20060529031915.GB23405@parisc-linux.org> <447AB2F5.2000700@s5r6.in-berlin.de> <20060529130515.GE23405@parisc-linux.org> <20060531232139.GA3202@us.ibm.com> <1149164533.3419.38.camel@pim.off.vrfy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:22800 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S1423480AbWJZTx1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Oct 2006 15:53:27 -0400
Content-Disposition: inline
In-Reply-To: <1149164533.3419.38.camel@pim.off.vrfy.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>, linux-hotplug-devel@lists.sourceforge.net, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>

On Thu, 01 Jun 2006, Kay Sievers wrote:

> On Wed, 2006-05-31 at 16:21 -0700, Patrick Mansfield wrote:
> > [adding hotplug-devel ... maybe Marco or Kay can comment]
> > 
> > On Mon, May 29, 2006 at 07:05:15AM -0600, Matthew Wilcox wrote:
> > > On Mon, May 29, 2006 at 10:38:13AM +0200, Stefan Richter wrote:
<snipp unrelated>
> > > 
> > > That's what scsi_complete_async_scans() is for.  If you have a built-in
> > > module, it will wait for the async scans to finish before we get as far
> > > as trying to mount root.  It does change observable behaviour in that
> > > sys_module_init() will return before scans are complete.  However, I
> > > believe most distros userspace copes with this these days.  For example,
> > > Debian has:
> > > 
> > >     # wait for the udevd childs to finish
> > >     log_action_begin_msg "Waiting for /dev to be fully populated"
> > >     while [ -d /dev/.udev/queue/ ]; do
> > >         sleep 1
> > >         udevd_timeout=$(($udevd_timeout - 1))
> > > [...]
> 
> That has replaced by a binary called "udevsettle" which waits for events
> to finish, by comparing the current kernel event sequence number
> exported in sysfs with the latest handled event by udev.

usb-storage is still giving troubles in that area.
in the case of usb-storage udevsettle exists much too early.
the /sys uevent_seqnum is the same as the udev worked on,
while dmesg is saying:
usb-storage: waiting for device to settle before scanning

it would be really helpful if udevsettle would have an uevent
to wait on. [adding gregkh to cc]

 
> > second, and the udev queue becomes empty even though the scsi /sd scan is
> > still in progress.
> 
> Right. For the settle time of usb-storage we watch for the kernel tread
> to go away. :)

bug reports don't comfirm that statement.
nor do i see any code for it in udevsettle.c.
 
-- 
maks
