From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: What still uses the block layer?
Date: Sat, 13 Oct 2007 16:05:39 -0600
Message-ID: <20071013220539.GD29934@parisc-linux.org>
References: <200710112011.22000.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54957 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599AbXJMWFm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Oct 2007 18:05:42 -0400
Content-Disposition: inline
In-Reply-To: <200710112011.22000.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Thu, Oct 11, 2007 at 08:11:21PM -0500, Rob Landley wrote:
> My impression from asking questions on the linux-scsi mailing list is that the 
> scsi upper/middle/lower layers doesn't use the block layer described in 
> Documentation/block/*.

Entirely incorrect.

> Instead of using the block layer, SCSI reinvents this particular wheel itself.  
> There's a scsi "upper layer" that provides /dev nodes, scsi low-level 
> drivers, and a gigantic glue layer in between call the "scsi midlayer" that's 
> something like a networking stack, and is responsible for losing track of all 
> your devices so that the one SATA disk hardwired into your laptop might be 
> sda or sdc depending on whether or not you had a USB key plugged in when you 
> booted up.  Anyway, the block layer isn't between any of these three, that I 
> can tell.

You really need to get the fuck over yourself.

> Now that IDE disks have been rerouted through the scsi layer, SATA goes 
> through the scsi layer, USB goes through the scsi layer, firewire goes 
> through the scsi layer...  What's left?  It seems like everything but 
> ramdisks have now been routed through the scsi layer.  My laptop hasn't got a 
> single SCSI device but it also hasn't got any block devices that don't show 
> up as scsi.

That's nice.  Why not take a look in drivers/block?  Floppy, CCISS,
CPQDA, UMEM, UBD, loop, NBD, SX8, UB, AoE, and many more.

> So what's still using the block layer?  How do the scsi layers and the block 
> layer relate?  I'm confused!  (This is normal for me, but still...)

sd and sr are block drivers.  In fact, the whole SCSI subsystem ...

        depends on BLOCK

Just take a look at sd.c.  The init code reads:

        for (i = 0; i < SD_MAJORS; i++)
                if (register_blkdev(sd_major(i), "sd") == 0)
                        majors++;

Then look at struct scsi_cmnd.  It has a pointer to the block request
that was passed down to it.  struct scsi_device has a pointer to the
block request_queue that's associated with the device.  Block is what
has elevators and io schedulers -- that work isn't duplicated by scsi.
There's work to push more of scsi's infrastructure up into the block
layer, so non-scsi block devices can take advantage of it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
