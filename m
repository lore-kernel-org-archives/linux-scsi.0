From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
Date: Sat, 17 May 2003 09:33:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC66465.6020700@pacbell.net>
References: <Pine.LNX.4.44L0.0305171108050.26146-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta4.rcsntx.swbell.net ([151.164.30.28]:53385 "EHLO
	mta4.rcsntx.swbell.net") by vger.kernel.org with ESMTP
	id S261706AbTEQRkO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 13:40:14 -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Florin Iucha <florin@iucha.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org


> What happens is that the device crashes because of the 3-byte 
> MODE-SENSE(6) request.  The scsi error handler tries various levels of 
> fault recovery, all the way up to a bus reset.  Usb-storage implements the 
> bus reset as a USB port reset, which requires usbcore to re-enumerate 
> the device.  The line
> 
>    drivers/usb/core/message.c: usb_control/bulk_msg: timeout
> 
> refers to a failure during the re-enumeration.  Apparently even the port
> reset was not enough to revive the device.  

That reset couldn't re-assign the address, so of course it failed.

In hub.c, usb_physical_reset_device() is leaving dev->state as
USB_STATE_CONFIGURED after resetting the port, and of course it's
not legal to set the address of a device in that state.

- Dave






