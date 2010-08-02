From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb-storage: implement autosuspend
Date: Mon, 2 Aug 2010 11:07:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1008021104180.1595-100000@iolanthe.rowland.org>
References: <201008021636.10290.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59021 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751590Ab0HBPHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2010 11:07:31 -0400
In-Reply-To: <201008021636.10290.oneukum@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Mon, 2 Aug 2010, Oliver Neukum wrote:

> Am Mittwoch, 28. Juli 2010, 23:12:39 schrieb Alan Stern:
> > 
> > This patch (as1400) adds runtime-PM support to usb-storage.  It
> > utilizes the SCSI layer's runtime-PM implementation, so its scope is
> > limited.  Currently the only effect is that disk-like devices (such as
> > card readers or flash drives) will be autosuspended if they aren't
> > mounted and their device files aren't open.  This would apply, for
> > example, to card readers that don't contain a memory card.
> 
> So it will autosuspend devices that do contain a medium, which
> is not mounted? This is a bit problematic, as some card readers
> will report a medium change upon resumption?
> 
> How does user space deal with this?

For the most part it won't matter.  It's rare to open a card reader's 
device file without mounting it.

If it does matter, the user can disable autosuspend (or more 
accurately, avoid enabling it) for that device.

Alan Stern

