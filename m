From: Paul Smith <paul@mad-scientist.net>
Subject: Re: [2.6.27.25] Hang in SCSI sync cache when a disk is removed--?
Date: Thu, 02 Jul 2009 16:12:59 -0400
Message-ID: <1246565579.9022.7226.camel@psmith-ubeta.netezza.com>
References: <1246551772.9022.7192.camel@psmith-ubeta.netezza.com>
	 <20090702174151.GA17414@linux.vnet.ibm.com>
Reply-To: paul@mad-scientist.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta.netezza.com ([12.148.248.132]:50944 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753229AbZGBUM7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jul 2009 16:12:59 -0400
In-Reply-To: <20090702174151.GA17414@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2009-07-02 at 10:41 -0700, Mike Anderson wrote:
> > As I mentioned, when we pull one of the disks from the EXP3000 the IO
> > subsystem completely hangs.  Since we're running on a ramdisk this
> > doesn't hang our system completely, but any attempt to do any disk IO
> > thereafter hangs, so we have to power-cycle the blade (because reboot
> > tries to write to the disks).  This quite reproducible in our
> > environment BUT it is very timing-sensitive, as shown below.  If we
> > enable too much logging, etc. it goes away.
> 
> Have you tried a minimum level of logging like the following without the
> error going away?
> "sysctl -w dev.scsi.logging_level=4100"

We've been enabling some logging at the mptlinux driver level, but not
the generic SCSI level.  We'll give this a try.

> Can you run "cat /sys/class/scsi_host/*/state" when you are in the hung
> state?

We'll try this as well.  One thing we did discover was that the device
entry in /sys/class/scsi_device/* is already gone when the hang occurs
so we can't retrieve the state of the device that way.

> If the host is in recovery no IOs will move forward. I assume if you can
> get a run with the 4100 level of logging it will show a host reset sent,
> but no waking up host to restart (unless the reset is being generated for
> other reasons outside of the scsi error handler).

This seems likely but the question is, why isn't it waking up again?

Unfortunately one of the folks working on this with me left for the US
holiday weekend so we'll have to take it up again on Monday morning.
Thanks for your reply, Mike!

