From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 6 Dec 2006 12:21:33 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0612061207550.3298-100000@iolanthe.rowland.org>
References: <1165423635.2810.33.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58738 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S936798AbWLFRVe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 12:21:34 -0500
In-Reply-To: <1165423635.2810.33.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Wed, 6 Dec 2006, James Bottomley wrote:

> Realistically, no-one makes SCSI CDs or DVDs any more ... I know, I've
> tried to get some for some of my older boxes.  Most of them nowadays are
> IDE attachments, which don't have a /dev/sg node.  So /dev/sg is really
> the legacy mode for burning.

Well, there are still a lot of legacy devices out there.

>  The correct way to do it today is to use
> the actual device name ... then you don't have to worry about what the
> transport is any more.

> > I could easily enough rewrite the patch to put the ioctl somewhere else
> > (although I'm not quite sure exactly where would be best).  But do
> > non-block devices have request queues?  What about the points that Doug
> > raised:
> 
> All CD/DVD burners are block devices, which is the problem set under
> discussion.

Fair enough.

> > On Tue, 5 Dec 2006, Douglas Gilbert wrote:
> > 
> > > Apart from sensibly yielding the max size in bytes, your patch
> > > has the added benefit of allowing non-block devices (e.g. tape,
> > > processor and enclosure services) to find out what limit the
> > > OS/host has placed on each command's maximum transfer size.
> 
> They all possess block queues, yes, so we should really allow access to
> the block ioctls for them.

> I have no idea why the block layer even implements
> SG_SET_RESERVED_SIZE ... I suspect it was some legacy application
> compatibility problem, so it probably can be eliminated.

Let's leave that for a separate patch.


It turns out that for block device files we don't need to change anything.
The BLKSECTGET ioctl already does almost exactly what we want:

	int n;

	if (ioctl(fd, BLKSECTGET, &n) == 0)
		max_transfer_size = n * 512;

So only the legacy sg character-device files need attention, which means 
that only the part of the patch affecting sg.c is necessary.  The new 
SG_GET_MAX_TRANSFER_LENGTH ioctl can remain unimplemented by the block 
layer -- just as SG_[SG]ET_RESERVED_SIZE should be.

How does that sound?

Alan Stern

