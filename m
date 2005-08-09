From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Tue, 9 Aug 2005 10:50:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0508091040470.4643-100000@iolanthe.rowland.org>
References: <20050809004934.95766.qmail@web51605.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:23991 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964800AbVHIOu6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 10:50:58 -0400
In-Reply-To: <20050809004934.95766.qmail@web51605.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>

On Mon, 8 Aug 2005, Luben Tuikov wrote:

> --- Alan Stern <stern@rowland.harvard.edu> wrote:
> > > I think that "scanning" is a special process which should involve
> > > the minimum of error handling, by either ignoring errors and trying
> > > to connect to the device anyway, or on the first error, give up
> > > the device.  Which policy would one follow depends on the transport.
> > 
> > No, that's not feasible.  We can't just ignore errors, and we do have to 
> > cope with them.  Scanning is a particular vulnerable time, since it 
> > involves sending commands that don't occur most of the time during normal 
> > operation.
> 
> Your reasoning is correct, but your conclusion is not.
> 
> Exactly, scanning is a "particularly vulnerable time" and this is why
> we do not want the full I_T nexus error recovery.  At scanning time
> we're just "probing" here and there.

Scanning is a lot more involved than just "probing" here and there.  
Getting the INQUIRY data is just the first step.  The second step involves
registering the scsi_dev, which causes the high-level driver's probe
routine to be called.  That routine does an awful lot of work: determine
the device capacity, check for write-protect and cache settings, read the
partition table, maybe more.  These activities need robust error recovery.


> > > If the latter, you need to blacklist the device as not supporting
> > > TUR.  Then on any error, like you pulling the cable during scanning,
> > > the scanning process will give up and all will be well.
> > 
> > You can't blacklist devices you don't know about.  The kernel should work 
> > regardless.
> 
> Hmm, I thought there was a black listing somewhere in scsi, maybe
> /proc/scsi/device_info?

The point of a black list is to avoid using features or commands that a
device doesn't support.  Black lists are _not_ meant to prevent the kernel
from crashing or falling into deadlock.

> So then you do scheme #1 as I described: ignore as much as possible and try
> to establish an I_T nexus and _then_ try to poke around with the device.

Under the circumstances, I think it will be best to leave the usb-storage
bus-reset handler and device locking as they are.  There doesn't seem to 
be any simpler approach that is provably safe.

Alan Stern

