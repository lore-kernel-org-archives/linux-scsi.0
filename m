From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Thu, 01 Jun 2006 14:22:12 +0200
Message-ID: <1149164533.3419.38.camel@pim.off.vrfy.org>
References: <20060511143352.GI12272@parisc-linux.org>
	 <20060518172258.GL1604@parisc-linux.org>
	 <20060529031915.GB23405@parisc-linux.org>
	 <447AB2F5.2000700@s5r6.in-berlin.de>
	 <20060529130515.GE23405@parisc-linux.org>
	 <20060531232139.GA3202@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from soundwarez.org ([217.160.171.123]:54925 "EHLO soundwarez.org")
	by vger.kernel.org with ESMTP id S1750858AbWFAMVP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2006 08:21:15 -0400
In-Reply-To: <20060531232139.GA3202@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-hotplug-devel@lists.sourceforge.net, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

On Wed, 2006-05-31 at 16:21 -0700, Patrick Mansfield wrote:
> [adding hotplug-devel ... maybe Marco or Kay can comment]
> 
> On Mon, May 29, 2006 at 07:05:15AM -0600, Matthew Wilcox wrote:
> > On Mon, May 29, 2006 at 10:38:13AM +0200, Stefan Richter wrote:
> > > Matthew Wilcox wrote:
> > > > Add the scsi_mod.scan kernel parameter to determine how scsi busses
> > > > are scanned.  "sync" is the current behaviour.  "none" punts scanning
> > > > scsi busses to userspace.  "async" is the new default.
> > > 
> > > This parameter is only relevant with LLDDs which use scsi_scan_host, right?
> > 
> > Not entirely.  If you set it to "none", scsi_scan_target() also returns
> > without doing anything.  If you use the scsi_prep_async_scan() and
> > scsi_finish_async_scan() API, you can also use this infrastructure to
> > make scanning sbp2 synchronised with other scsi hosts.  Then the setting
> > of sync vs async also triggers old vs new behaviour.
> > 
> > > Furthermore, "sync|async" basically means "serialized|parallelized
> > > across host adapters". Does it also mean "finishing before|after driver
> > > initialization"? (With LLDDs which use scsi_scan_host.)
> > 
> > That's what scsi_complete_async_scans() is for.  If you have a built-in
> > module, it will wait for the async scans to finish before we get as far
> > as trying to mount root.  It does change observable behaviour in that
> > sys_module_init() will return before scans are complete.  However, I
> > believe most distros userspace copes with this these days.  For example,
> > Debian has:
> > 
> >     # wait for the udevd childs to finish
> >     log_action_begin_msg "Waiting for /dev to be fully populated"
> >     while [ -d /dev/.udev/queue/ ]; do
> >         sleep 1
> >         udevd_timeout=$(($udevd_timeout - 1))
> > [...]

That has replaced by a binary called "udevsettle" which waits for events
to finish, by comparing the current kernel event sequence number
exported in sysfs with the latest handled event by udev.

> Not sure where that is, but AFAIR that is to process the cold plug case,
> where udev starts up, the hotplug/netlink events are replayed, and we
> don't want to continue until all those events have been processed.
> 
> SLES 10 has similar code, but a sleep of 0.1 (see their /etc/init.d/boot.udev,
> and I think /sbin/mkinitrd).

It uses only udevsettle now, also the partitioner and similar needs this
to wait for the partiton table rescan to finish, before continuing using
the new devices. 

> > Since the scsi scan is going to be finding new devices the entire time,
> > the queue directory is going to not empty.

Watching only the queue is not enough, cause there are only received
events exported, but not events still in the kernel netlink queue.
Therefore you need to compare the current kernel seqnum like udevsettle
is doing it.

> It won't always be finding new devices, there could be glitches like a
> timeout, or some read (partitition check) that happens to take more than a
> second, and the udev queue becomes empty even though the scsi /sd scan is
> still in progress.

Right. For the settle time of usb-storage we watch for the kernel tread
to go away. :)

> You really want some udev rule that mounts root or such and then the boot
> continues from there ... rather than waiting for an unrelated sets of
> events, and then trying to mount root unconditionally (and possibly
> failing). I thought Hannes or someone had posted an example udev rule or
> such for this. Maybe it is even in SLES 10?

It does not only wait for the queue to become empty. Initramfs creates
dynamic udev rules based on the kernel commandline and waits until the
device appears. The real root (localfs) waits for all needed devices
mentioned in /etc/fstab before continuing.

> Same for applications - you want them to start after a dev (or set of
> devs) shows up, though if we wait for the root dev it is even less likely
> that an app's dev will be unavailable.
> 
> Of course if you aren't using udev in your init{rd|ramfs}, udev rules
> and such can't fix the problem :-(

Kay

