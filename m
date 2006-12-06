From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 6 Dec 2006 15:31:16 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0612061516350.3298-100000@iolanthe.rowland.org>
References: <1165432436.2810.66.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37416 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S937626AbWLFUbR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 15:31:17 -0500
In-Reply-To: <1165432436.2810.66.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Wed, 6 Dec 2006, James Bottomley wrote:

> On Wed, 2006-12-06 at 13:58 -0500, Alan Stern wrote:
> > I'd love to do that -- but blkdev_ioctl() wants inode->i_bdev to be set, 
> > and blkdev_locked_ioctl() uses it as the argument to bdev_get_queue().  So 
> > it won't work with sg, which uses character device nodes.
> 
> Well, even sg has the queue ... and what we're looking for are the queue
> parameters.  In block/ioctl.c the bdev is just used for getting the
> queue parameters (mainly via bdev->bd_disk->queue),

That's true for several of the ioctls but not all of them.

>  so I could see if
> Jens might be amenable to refactoring the queue ioctls so we can get at
> them simply with a struct request_queue parameter.

That would be fine with me.  Could you go ahead and ask Jens?

> > How about adding BLKSECTGET to the list of commands accepted by 
> > sg_ioctl()?
> 
> That's certainly a possible hack ... although I'd prefer to see the full
> queue ioctls exposed.

I agree; it's better to keep things in one place rather than to duplicate
them.

Alan Stern

