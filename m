From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Thu, 27 Sep 2007 21:26:47 +0200
Message-ID: <200709272126.47558.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709271455080.7735-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:57464 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737AbXI0TZ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 15:25:59 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709271455080.7735-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Donnerstag 27 September 2007 schrieb Alan Stern:
> On Thu, 27 Sep 2007, Oliver Neukum wrote:
> 
> > > Oliver, I'm surprised at you!  This patch is a big hack, not to mention 
> > > a layering violation and an inversion of the proper calling sequence.
> > 
> > Well,
> > 
> > 1. autosuspend should not be specific to USB
> 
> Correct.  Which means support for it should be added to the SCSI
> drivers.  SCSI autosuspend shouldn't be kluged into usb-storage in a
> way that basically ignores what the SCSI layer is doing.

It isn't. The decision to autosuspend is based on activity on the bus.
Now you might argue that the decision to do an autosuspend should
always propagate upwards from the lowest level of the device tree.
Then I ask why?

> > 2. I like to view the generic SCSI code as a library
> 
> That viewpoint might work out okay in some cases, but I don't think 
> it's tenable when dealing with high-level drivers like sd and sr.

sg worries me.
 
> > 3. The low level drivers will have to decide whether to suspend devices,
> > as the generic code doesn't know whether the bus is shared.
> 
> I'm having trouble understanding this; it's a bit ambiguous.  Does
> "devices" mean "SCSI devices", "host adapter devices", or both?  Does

SCSI devices

> "generic code" refer to the SCSI core, the high-level SCSI drivers, or
> something else?  When you say the bus is "shared", do you mean there
> are multiple SCSI devices attached to it or do you mean something else?

No multiple hosts. Think Firewire or FibreChannel. We certainly cannot
spin down a Firewire disk some other host is using just because we
are done with it.

> (I assume you mean something else, as the SCSI core certainly does know
> when multiple SCSI devices are attached to a SCSI bus.)
> 
> In any case, that's not how I would put it.  The SCSI core and
> high-level drivers will have to decide when they are not using SCSI
> devices and the devices can be suspended.  When all the devices the

Err, why? After all, there's a central instance in userspace that decides
that the whole system isn't used right now. I see no reason to not use
this model for parts of the device tree.

	Regards
		Oliver
