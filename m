From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: 24 Sep 2003 09:10:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064412617.2064.1.camel@mulgrave>
References: <Pine.LNX.4.44L0.0309231117240.1869-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:14087 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261236AbTIXOLI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 10:11:08 -0400
In-Reply-To: <Pine.LNX.4.44L0.0309231117240.1869-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andries.Brouwer@cwi.nl, david-b@pacbell.net, greg@kroah.com, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net, Patrick Mansfield <patmans@us.ibm.com>, Linus Torvalds <torvalds@osdl.org>

On Tue, 2003-09-23 at 10:23, Alan Stern wrote: 
> Is there any way to notify the system that you are about to unplug a 
> drive?  It seems to me that the best approach is to flush the cache on an 
> unmount.  People naturally assume that it's safe to unplug a device once 
> it has been unmounted, and they also realize that it's unsafe to unplug a 
> device containing a mounted filesystem.
> 
> That doesn't address the problem of raw device access, but perhaps 
> whatever ioctl is used by blockdev --flushbufs can also flush the cache.

Well, a synchronize can be really expensive (minutes to flush on a large
array), you only really want to do it if absolutely necessary, so tying
it to something separate from normal OS operation seems like the best
thing to do. 

> Is there any harm in sending a SYNCHRONIZE command to a device that
> doesn't need it (write-through cache)?  Maybe doing that is less dangerous 
> than trying to read mode-sense page 8 on these buggy USB devices.  
> (Although I'm not aware of anyone who has tried the experiment.)

Devices that don't support mode page 8 invariably seem to react badly to
the SYNCHRONIZE command (I have a few of these SCSI devices)...Although,
usually they just send an ILLEGAL COMMAND sense.  I wouldn't like to try
the same thing with a USB device... 

James 


