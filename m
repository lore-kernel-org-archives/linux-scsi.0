From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Wed, 27 Aug 2014 16:02:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408271551170.1460-100000@iolanthe.rowland.org>
References: <201408271923.s7RJNkHA009793@hobgoblin.ariadne.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53704 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935538AbaH0UCZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Aug 2014 16:02:25 -0400
In-Reply-To: <201408271923.s7RJNkHA009793@hobgoblin.ariadne.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dale R. Worley" <worley@alum.mit.edu>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 27 Aug 2014, Dale R. Worley wrote:

> What I find interesting is that Windows (at least, Windows 7
> Professional) seems to be able to handle the deficient adapter.

So does Linux.  The difference is that Windows believes the values in
the partition table in preference to what the hardware says, whereas 
Linux believes the hardware in preference to the partition table.

Thus, if the hardware says the disk contains 0.8 TB and the partition 
table says the first partition contains 2.8 TB, Windows will try to 
access all 2.8 TB but Linux will complain that the partition entry is 
invalid (because the partition extends beyond the end of the disk).

If you try to repartition the drive under Windows using the deficient 
adapter, you'll see that the problem still exists.  It just doesn't 
show up during normal use.

>  What
> I'd like to do is log the disk commands during the mounting sequence,
> preferably at both the SCSI and USB layers.  Then at least we'll know
> exactly what the driver is doing.  Are there kernel options to do
> this?

You can record the USB transfers by using usbmon (see
Documentation/usb/usbmon.txt).  The trace will include all the
important SCSI data, so you don't need to record anything at the SCSI
layer.

This isn't really necessary, though.  We already know what the driver 
is doing.

> Unfortunately, I don't know any way to log what Windows is doing with
> the drive.

My experiments with Windows show that it does essentially the same
things as Linux does.  The important difference is not what commands
and data get sent, but whether the OS pays attention to the result.

Alan Stern

