From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Date: Wed, 31 Oct 2007 18:32:41 +0100
Message-ID: <1193851961.6621.50.camel@lov.site>
References: <Pine.LNX.4.44L0.0710311200080.4704-100000@iolanthe.rowland.org>
	 <1193847197.3411.32.camel@localhost.localdomain>
	 <1193847866.6621.5.camel@lov.site>
	 <1193848270.3411.39.camel@localhost.localdomain>
	 <1193848942.6621.18.camel@lov.site>
	 <1193849183.3411.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:54159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbXJaRa0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 13:30:26 -0400
In-Reply-To: <1193849183.3411.45.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2007-10-31 at 11:46 -0500, James Bottomley wrote:
> On Wed, 2007-10-31 at 17:42 +0100, Kay Sievers wrote:
> > On Wed, 2007-10-31 at 11:31 -0500, James Bottomley wrote:

> > > Doesn't this circularity now exist for everything?  Every device that
> > > creates a queue has a reference to the queue, every queue has a
> > > reference to its attached gendisk and now every gendisk has a reference
> > > to the device creating the queue?  This doesn't look to be a SCSI
> > > specific problem.
> > 
> > It's only SCSI so far, everything else seems fine.
> 
> But you didn't respond to the stated problem: there are very few other
> non-scsi block devices ... have you tried looking at cciss?

I tried ub instead of usb-storage and sd card driver which is a raw
block driver, i didn't try cciss, or other more advanced blockdev
drivers.

> > But, the real problem is that the core seems to deadlock if two devices
> > reference each other (or build a larger circle), even when they are
> > deleted, that's the problem we are running in.
> 
> Yes ... we sort of evaded that one by having class devices hang off the
> sides of real devices ... making everything a peer with crosslinks
> brings it back with a vengeance.
 
Yeah, which made sysfs a horrible mess as soon as people started putting
hierarchy in class devices. The whole idea of "physical", "virtual", 
"class", "bus" causes nothing but problems in userspace, and exposes
kernel implementation details, which change all the time. There are even
subsystem which moved from class to bus because they need driver
binding. And there is really no point in exposing that to userspace.

It's a design mistake, we try to fix now. We really need a single
classification and a single hierarchy and not the 3 completely different
access rules for 3 types of devices, which don't have any interesting
difference, besides the way the kernel handles them.

Kay

