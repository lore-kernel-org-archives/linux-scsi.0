From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Wed, 31 May 2006 16:21:39 -0700
Message-ID: <20060531232139.GA3202@us.ibm.com>
References: <20060511143352.GI12272@parisc-linux.org> <20060518172258.GL1604@parisc-linux.org> <20060529031915.GB23405@parisc-linux.org> <447AB2F5.2000700@s5r6.in-berlin.de> <20060529130515.GE23405@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:34708 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S964847AbWEaXVq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 19:21:46 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4VNLjW5000381
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 19:21:45 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k4VNLj3N143686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 17:21:45 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4VNLi9c016239
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 17:21:45 -0600
Content-Disposition: inline
In-Reply-To: <20060529130515.GE23405@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-hotplug-devel@lists.sourceforge.net
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

[adding hotplug-devel ... maybe Marco or Kay can comment]

On Mon, May 29, 2006 at 07:05:15AM -0600, Matthew Wilcox wrote:
> On Mon, May 29, 2006 at 10:38:13AM +0200, Stefan Richter wrote:
> > Matthew Wilcox wrote:
> > > Add the scsi_mod.scan kernel parameter to determine how scsi busses
> > > are scanned.  "sync" is the current behaviour.  "none" punts scanning
> > > scsi busses to userspace.  "async" is the new default.
> > 
> > This parameter is only relevant with LLDDs which use scsi_scan_host, right?
> 
> Not entirely.  If you set it to "none", scsi_scan_target() also returns
> without doing anything.  If you use the scsi_prep_async_scan() and
> scsi_finish_async_scan() API, you can also use this infrastructure to
> make scanning sbp2 synchronised with other scsi hosts.  Then the setting
> of sync vs async also triggers old vs new behaviour.
> 
> > Furthermore, "sync|async" basically means "serialized|parallelized
> > across host adapters". Does it also mean "finishing before|after driver
> > initialization"? (With LLDDs which use scsi_scan_host.)
> 
> That's what scsi_complete_async_scans() is for.  If you have a built-in
> module, it will wait for the async scans to finish before we get as far
> as trying to mount root.  It does change observable behaviour in that
> sys_module_init() will return before scans are complete.  However, I
> believe most distros userspace copes with this these days.  For example,
> Debian has:
> 
>     # wait for the udevd childs to finish
>     log_action_begin_msg "Waiting for /dev to be fully populated"
>     while [ -d /dev/.udev/queue/ ]; do
>         sleep 1
>         udevd_timeout=$(($udevd_timeout - 1))
> [...]

Not sure where that is, but AFAIR that is to process the cold plug case,
where udev starts up, the hotplug/netlink events are replayed, and we
don't want to continue until all those events have been processed.

SLES 10 has similar code, but a sleep of 0.1 (see their /etc/init.d/boot.udev,
and I think /sbin/mkinitrd).

> Since the scsi scan is going to be finding new devices the entire time,
> the queue directory is going to not empty.

It won't always be finding new devices, there could be glitches like a
timeout, or some read (partitition check) that happens to take more than a
second, and the udev queue becomes empty even though the scsi /sd scan is
still in progress.

You really want some udev rule that mounts root or such and then the boot
continues from there ... rather than waiting for an unrelated sets of
events, and then trying to mount root unconditionally (and possibly
failing). I thought Hannes or someone had posted an example udev rule or
such for this. Maybe it is even in SLES 10?

Same for applications - you want them to start after a dev (or set of
devs) shows up, though if we wait for the root dev it is even less likely
that an app's dev will be unavailable.

Of course if you aren't using udev in your init{rd|ramfs}, udev rules
and such can't fix the problem :-(

-- Patrick Mansfield
