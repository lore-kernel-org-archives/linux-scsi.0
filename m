From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Maximum_transfer_size and SCSI request buffer size parameters
Date: Thu, 24 Jul 2003 12:22:31 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307241213180.720-100000@ida.rowland.org>
References: <20030724153505.GC1063@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:9220 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266622AbTGXQHX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 12:07:23 -0400
In-Reply-To: <20030724153505.GC1063@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>, Harald Dunkel <harri@synopsys.COM>

On Thu, 24 Jul 2003, Jens Axboe wrote:

> On Thu, Jul 24 2003, Alan Stern wrote:
> > I'm trying to solve the problem of a user whose USB disk drive crashes
> > when it is asked to write 512K bytes in a single command.  A good way to
> > solve this problem would be to have a maximum_transfer_size field as part 
> > of the scsi_device structure.  Is it worthwhile adding such a feature?
> 
> First of all, you don't mention what kernel version you are talking
> about...

And I often make the same mental complaint about other writers!  I'm 
referring to 2.6, although it wouldn't hurt to work on 2.4 as well...

> Anyways, the feature is already there. It's called max_sectors, and it's
> even in the host template for you to set. That handles block layer
> requests, at least.

Great!  I should have seen that.  Thanks for the pointer.

> > In sd.c and sr.c, scmd->request_bufflen is the number of bytes to
> > transfer.  Both files use the variable this_count to compute the number
> > of sectors, stored in the command's CDB.  this_count is based on
> > request_bufflen, but the values can disagree.  For example, if READ(6)  
> > is used and request_bufflen corresponds to more than 255 sectors, 
> > this_count will be reduced to 255.
> 
> That is in purpose, for cases like that you have to only do a part of
> the entire request.

Certainly.  But when this_count is reduced, request_bufflen should be 
reduced as well.

> > Furthermore, sr.c goes to the trouble of adding up the lengths of all the
> > scatter-gather blocks, and if the total disagrees with request_bufflen it
> > sets request_bufflen equal to the total -- but it does this after storing
> > this_count in the CDB.
> 
> It's a bug if they differ, that's why there's a printk there. Might be a
> good idea to make that a harder error, though.

But if they differ and you're trying to correct the error, the correction 
should be made _before_ this_count is set to request_bufflen, not after.

> > A related issue is that in both sd.c and sr.c, the rw_intr() routine
> > identifies the number of sectors correctly transferred as scmd->bufflen
> > (if no error occurred).  Normally bufflen is initialized equal to
> > request_bufflen.  But if this_count has been altered, the number of
> > sectors will be different from bufflen.
> 
> The device will not transfer more data than what it is told from the
> cdb. Aren't you getting a completed byte count from your hardware? Or
> are you blindly assuming the device transferred what you initially told
> you?

If no errors occur we do not get a completed byte count; we have to assume
that all the requested data was transferred.  It seems like a reasonable
assumption under the circumstances.  That's not the problem; the problem
is that the value passed to scsi_io_completion() for the number of sectors
completed will be the value in scmd->bufflen, not the amount in the CDB
which was actually transferred.

Alan Stern

