From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Unaligned scatter-gather buffers and usb-storage
Date: Wed, 19 Nov 2003 11:58:35 -0500 (EST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0311191147270.957-100000@ida.rowland.org>
References: <20031119154911.GM1106@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20031119154911.GM1106@suse.de>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Jens Axboe <axboe@suse.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Wed, 19 Nov 2003, Jens Axboe wrote:

> > any main code path, and it wouldn't get invoked by anything using the st
> > or sg drivers.  In fact, it looks like scsi_ioctl.c:scsi_cmd_ioctl() is
> > only called from within the sd driver.
> 
> It's invoked from user space. Don't mix block and scsi scsi_ioctl() up.
> bio_map_user() would be used by a block layer sg driver too, for
> instance.

You've lost me.  scsi_cmd_ioctl() and bio_map_user() are _not_ used by the
sg driver -- did you mean that a hypothetical block layer sg driver would
call them?  That doesn't seem relevant to the point of this thread.  

Although come to think of it, you probably never saw the start of the
thread.  Take a look at

http://marc.theaimsgroup.com/?l=linux-usb-devel&m=106916943618090&w=2

to understand my problem.

> > So something needs to be fixed up.  Is there some spot in the block layer 
> > that's supposed to be checking dma alignments but isn't doing so?
> 
> The queue dma alignment was added to better cater to cdrecord, for
> instance. We need better than 512b granularity there, or you cannot use
> DMA on certain types of burns (lots of sector types are non-2kb aligned
> there).
> 
> If you can 512-byte align the data and transfer from user space, _that
> is enough_. The program just needs to be aware of this, it's not an odd
> restriction. There are just scenarious where you cannot do this, and
> that is why I added the queue dma alignment attribute. To me, it doesn't
> sound like your case applies.

This isn't a userspace problem as such; it's a problem of enforcing dma
alignment restrictions within the block layer or lower.  I'm not working
on a user program; I'm working on the usb-storage driver.  It too needs
512-byte alignment, but under the right circumstances the st and sg
drivers can submit scatter-gather buffers that aren't aligned.  You said
earlier that misaligned buffers would be caught in the block layer
queueing code, but I don't see any place where that happens.

Alan Stern




-------------------------------------------------------
This SF.net email is sponsored by: SF.net Giveback Program.
Does SourceForge.net help you be more productive?  Does it
help you create better code?  SHARE THE LOVE, and help us help
YOU!  Click Here: http://sourceforge.net/donate/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
