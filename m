From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 10:47:14 -0600
Message-ID: <1165423635.2810.33.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0612061105500.3298-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35405 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936493AbWLFQvG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 11:51:06 -0500
In-Reply-To: <Pine.LNX.4.44L0.0612061105500.3298-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Wed, 2006-12-06 at 11:32 -0500, Alan Stern wrote:
> > But how did he get the file descriptor?  He opened a device name, which
> > could have been used to get the sysfs file.
> 
> The device name was probably something like /dev/sg0.  This doesn't easily
> permit one to find the corresponding sysfs filename for the real
> underlying device, although it can be done with difficulty.  (That's why I
> used the excessively-ornate sysfs pathname in the Bugzilla entry.)  It
> certainly wouldn't be as easy as using an ioctl.
> 
> It wouldn't be as uniform either.  The search through sysfs would have to 
> be different depending on whether the device name was /dev/sr0 or 
> /dev/sg0.

Realistically, no-one makes SCSI CDs or DVDs any more ... I know, I've
tried to get some for some of my older boxes.  Most of them nowadays are
IDE attachments, which don't have a /dev/sg node.  So /dev/sg is really
the legacy mode for burning.  The correct way to do it today is to use
the actual device name ... then you don't have to worry about what the
transport is any more.

> > > Is the patch below acceptable?
> > 
> > Really, no.  The parameter you're fishing for is a block parameter, not
> > a SCSI parameter ... it should really be a block ioctl if we have to
> > have an ioctl at all.
> 
> I could easily enough rewrite the patch to put the ioctl somewhere else
> (although I'm not quite sure exactly where would be best).  But do
> non-block devices have request queues?  What about the points that Doug
> raised:

All CD/DVD burners are block devices, which is the problem set under
discussion.

> On Tue, 5 Dec 2006, Douglas Gilbert wrote:
> 
> > Apart from sensibly yielding the max size in bytes, your patch
> > has the added benefit of allowing non-block devices (e.g. tape,
> > processor and enclosure services) to find out what limit the
> > OS/host has placed on each command's maximum transfer size.

They all possess block queues, yes, so we should really allow access to
the block ioctls for them.

> > If you manage to get that ioctl in, then ungrateful people
> > will ask for the corresponding "set" operation as well.
> > 
> > 
> > To illustrate the /sys mess look at naming of the sysfs approach
> > to this problem. For example:
> >   /sys/block/sde/queue/max_sectors_kb
> >     - it is not only a "block" property
> >     - sde is an "end device" and suggests information from that
> >       device's Block Limits VPD page, actually it is a limit
> >       imposed by the OS and the host used to access that device
> >     - what has "queue" got to do with it?
> >     - "max_sectors_kb" should have units of bytes
> 
> In addition to all of these points, there remains the peculiar location of 
> the SG_ ioctls.  They are implemented it two places in the kernel: 
> block/scsi_ioctl.c and drivers/scsi/sg.c.  And the two implementations of 
> e.g. SG_SET_RESERVED_SIZE don't even do the same thing!

I have no idea why the block layer even implements
SG_SET_RESERVED_SIZE ... I suspect it was some legacy application
compatibility problem, so it probably can be eliminated.

James


