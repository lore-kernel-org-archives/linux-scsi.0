From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down
 disk
Date: Tue, 25 Sep 2007 11:03:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709251039550.3909-100000@iolanthe.rowland.org>
References: <200709250950.35933.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44113 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755188AbXIYPDF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 11:03:05 -0400
In-Reply-To: <200709250950.35933.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, 25 Sep 2007, Oliver Neukum wrote:

> Am Montag 24 September 2007 schrieb Alan Stern:
> > On Mon, 24 Sep 2007, Oliver Neukum wrote:
> > 
> > > > subsystem implements its own form of runtime PM support, then you'll be
> > > > able to use it properly.  But until then, there isn't anything much you
> > > > can do.
> > > 
> > > Well, we can't simply cut power. Buffers must be flushed and the disk
> > > spun down. The suspend() method of the storage driver will have to become
> > > complex.
> > 
> > That's right, if the device is a real disk.  If it's a flash memory
> > device then of course these issues don't arise.  Unfortunately the
> 
> With respect to buffers how sure are you about that?

Well, I'm not intimately familiar with the design of these chips.  But 
as long as the device remains powered, internally-buffered data 
shouldn't be lost.  It should be written out to flash storage when the 
device is resumed.

Are you worried about what might happen if the device is unplugged 
while it is still suspended?  Then yes, there is a risk of data loss.  
But that's also true if the device isn't suspended -- unplugging it 
without flushing its buffers could lose some data.

> > driver isn't able to tell one from the other; the user will have to
> > do that for us.
> 
> Code for what we need is in sd_suspend(). The only trouble is locking.
> We need to make sure no commands that dirty buffers are issued after
> flushing the buffers.

No -- _we_ don't need to do that.  The sd driver needs to, by making 
sure that once the buffers have been flushed, any new commands will 
cause sd_resume() to be called.

That's what I meant when I said that sd has to support autoresume.

In addition, sd_suspend() and sd_resume() have to pass information up
the stack.  sd_suspend() has to let the SCSI core know that there is
one less active device on the bus, and when there are no active devices
left then the SCSI core has to call the LLD (in this case, usb-storage)  
to tell it the host adapter can be suspended.

Likewise, before sd_resume() runs it has to tell the SCSI core that the
bus needs to be active, and if the bus is suspended then the SCSI core
has to tell the LLD that the host adapter must be resumed.

The same reasoning applies to sr and any other high-level SCSI drivers
that might get written.  sg and SG_IO might present problems, since
they effectively are additional interfaces to the same devices already
managed by sd and sr -- they could be treated more or less the way we
treat access through usbfs.

Getting all this to work will be tricky, because sd is a block device
driven by requests issued through the block layer in atomic context,
whereas suspend and resume require a process context.  Probably the 
SCSI core would have to get involved in managing the synchronization.

Alan Stern

