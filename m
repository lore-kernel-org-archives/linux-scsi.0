From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Mon, 3 Mar 2008 18:04:07 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803031758310.8280-100000@iolanthe.rowland.org>
References: <1204581661.3043.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34781 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757494AbYCCXEJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 18:04:09 -0500
In-Reply-To: <1204581661.3043.66.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 3 Mar 2008, James Bottomley wrote:

> On Mon, 2008-03-03 at 15:16 -0500, Alan Stern wrote:
> > This patch (as1050) adds a new field to struct scsi_device, to keep a
> > count of the number of block-device open file references.  This count
> > will be used by usb-storage to determine whether USB-PERSIST should be
> > forced on during a suspend.
> 
> I don't think this does what's advertised if you mean it to keep a count
> as the atomics seem to imply. (->open is only called on first open and
> ->release on last close.  openers was a historical 2.4 field that used
> to count opens but now just flags whether sd is open or not.

Um.  The real purpose of that field is to let usb-storage know whether 
or not the device is open at all.  I used a count because that seemed 
like the only way to do it; it doesn't matter if the count value 
doesn't exactly match the actual number of open file references.

I didn't want to use the openers field in struct scsi_disk because this 
should apply to CDs and any other block devices as well as to disks.

> Secondly, if you really want an openers count (which I remember SCSI
> rendering a bad idea ages ago), that's held in struct block_device as
> openers, isn't it?  So there's no need to duplicate this in SCSI.

But there's no way to get to the block_device structure if all you're 
given is the scsi_device, right?  You would have to know something 
special about it, such as whether it is a disk, a CD, or something 
else.  This is intended to be generic.

Alan Stern

