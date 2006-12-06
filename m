From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 6 Dec 2006 11:32:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0612061105500.3298-100000@iolanthe.rowland.org>
References: <4575fd53.ja06l7+Yx9/C/OYS%Joerg.Schilling@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40792 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S936369AbWLFQch (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 11:32:37 -0500
In-Reply-To: <4575fd53.ja06l7+Yx9/C/OYS%Joerg.Schilling@fokus.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: James.Bottomley@steeleye.com, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Tue, 5 Dec 2006, Joerg Schilling wrote:

> If the number in "sectors" is not a value in sectors but a value in 512 byte
> units, it looks OK.

That's right.  This is one of those places where the kernel converts
between the hardware's actual sector size and a fictitious 512-byte sector
size.

> Is this value correct for all "host adaptors"?

Yes.


On Tue, 5 Dec 2006, James Bottomley wrote:

> > To recap: Joerg Schilling needs to be able to retrieve the max_sectors 
> > value for a SCSI device's request queue.  Doing it via sysfs is rather 
> > clumsy, especially when only a file descriptor is available and not the 
> > device name.  He has asked for an ioctl interface to provide the 
> > information.
> 
> But how did he get the file descriptor?  He opened a device name, which
> could have been used to get the sysfs file.

The device name was probably something like /dev/sg0.  This doesn't easily
permit one to find the corresponding sysfs filename for the real
underlying device, although it can be done with difficulty.  (That's why I
used the excessively-ornate sysfs pathname in the Bugzilla entry.)  It
certainly wouldn't be as easy as using an ioctl.

It wouldn't be as uniform either.  The search through sysfs would have to 
be different depending on whether the device name was /dev/sr0 or 
/dev/sg0.

> > Is the patch below acceptable?
> 
> Really, no.  The parameter you're fishing for is a block parameter, not
> a SCSI parameter ... it should really be a block ioctl if we have to
> have an ioctl at all.

I could easily enough rewrite the patch to put the ioctl somewhere else
(although I'm not quite sure exactly where would be best).  But do
non-block devices have request queues?  What about the points that Doug
raised:

On Tue, 5 Dec 2006, Douglas Gilbert wrote:

> Apart from sensibly yielding the max size in bytes, your patch
> has the added benefit of allowing non-block devices (e.g. tape,
> processor and enclosure services) to find out what limit the
> OS/host has placed on each command's maximum transfer size.
>  
> If you manage to get that ioctl in, then ungrateful people
> will ask for the corresponding "set" operation as well.
> 
> 
> To illustrate the /sys mess look at naming of the sysfs approach
> to this problem. For example:
>   /sys/block/sde/queue/max_sectors_kb
>     - it is not only a "block" property
>     - sde is an "end device" and suggests information from that
>       device's Block Limits VPD page, actually it is a limit
>       imposed by the OS and the host used to access that device
>     - what has "queue" got to do with it?
>     - "max_sectors_kb" should have units of bytes

In addition to all of these points, there remains the peculiar location of 
the SG_ ioctls.  They are implemented it two places in the kernel: 
block/scsi_ioctl.c and drivers/scsi/sg.c.  And the two implementations of 
e.g. SG_SET_RESERVED_SIZE don't even do the same thing!


On Wed, 6 Dec 2006, Joerg Schilling wrote:

> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Tue, 2006-12-05 at 23:46 +0100, Joerg Schilling wrote:
> > > I am afraid, you seem to missunderstand things.
> > > 
> > > This parameter is not related to something you may call "block layer", it is 
> > > rather related to the low level SCSI transport. If the value is stored in a 
> > > higher layer, it is not stored in the layer where it belongs to.
> > > 
> > > If you like to take care of clean interfaces, make sure that this parameter is 
> > > moved to the right place in the code.
> >
> > The patch Alan posted is returning the max_sectors count from the block
> > layer, which is a block, not a SCSI parameter ... so what is it that you
> > actually want?
> 
> Well, accept the patch if it works. And in case that you don't like it, make 
> sure that the _parameter_ is moved to where it belongs: to the low level 
> transport layer.

The problem is that this parameter is used in _both_ the low-level
transport and the mid-level block & request-queuing code.  The transport
obviously has to be aware of the maximum transfer size, and the
queue-management code has to know into what size units I/O requests should
be broken up.  So I don't think it makes sense to say that the parameter
"belongs" to one layer or the other.

Given all this, it seems to be a good idea to add this ioctl.  The only 
question is where?

Alan Stern

