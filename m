From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: Sun, 04 Apr 2004 11:16:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <407050F4.2090607@pacbell.net>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org> <1081092223.2034.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtaw4.prodigy.net ([64.164.98.52]:47053 "EHLO mtaw4.prodigy.net")
	by vger.kernel.org with ESMTP id S262514AbUDDSQg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Apr 2004 14:16:36 -0400
In-Reply-To: <1081092223.2034.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> Let me illustrate: the user may disconnect the device then open it.  If
> they open it before even the USB subsystem gets notified of the
> disconnection then all the elaborate synchronisation in the world isn't
> going to be able to prevent that (the device was gone when they opened
> it, just nothing in the kernel knew that).  Since we cannot solve that
> race, there's no reason to try to solve the "some parts of the kernel
> know but others don't" part of the race.

You're assuming that synchronization is there to establish a single
global notion of state.  Clearly that's impossible; also undesirable.

The synchronization is actually there to let the "device gone" state
spread cleanly through the software stack.  By the time USB disconnect()
is called, host controller drivers (and khubd) have normally cleaned up
all hardware state, and usbcore is never going to accept another operation
on that device.  The disconnect() callback is there to prevent that
raciness from making trouble ... closing windows from the bottom up.

The way usb-storage passes that up to the SCSI layer is by calling
scsi_remove_host().  Bug 2400 shows up later, through the block
layer (or is it just cdrom?) code.  Did someone actually post the
specific source code line in cdrom_release() that's oopsing?

- Dave




