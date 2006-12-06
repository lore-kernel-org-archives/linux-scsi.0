From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 6 Dec 2006 13:58:25 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0612061354150.3298-100000@iolanthe.rowland.org>
References: <1165425931.2810.37.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42656 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S937115AbWLFS60 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 13:58:26 -0500
In-Reply-To: <1165425931.2810.37.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Wed, 6 Dec 2006, James Bottomley wrote:

> On Wed, 2006-12-06 at 12:21 -0500, Alan Stern wrote:
> > So only the legacy sg character-device files need attention, which
> > means 
> > that only the part of the patch affecting sg.c is necessary.  The new 
> > SG_GET_MAX_TRANSFER_LENGTH ioctl can remain unimplemented by the
> > block 
> > layer -- just as SG_[SG]ET_RESERVED_SIZE should be.
> > 
> > How does that sound?
> 
> Actually, I'd just connect sg up to the block ioctl ... it has a block
> queue and valid parameters, so BLKSECTGET will work for it as well.

I'd love to do that -- but blkdev_ioctl() wants inode->i_bdev to be set, 
and blkdev_locked_ioctl() uses it as the argument to bdev_get_queue().  So 
it won't work with sg, which uses character device nodes.

How about adding BLKSECTGET to the list of commands accepted by 
sg_ioctl()?

Alan Stern

