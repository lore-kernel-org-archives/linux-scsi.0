From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: 04 Apr 2004 14:42:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081104161.2112.34.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>
	<1081092223.2034.8.camel@mulgrave>  <407050F4.2090607@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:53418 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262541AbUDDSnA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Apr 2004 14:43:00 -0400
In-Reply-To: <407050F4.2090607@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-04-04 at 14:16, David Brownell wrote:
> You're assuming that synchronization is there to establish a single
> global notion of state.  Clearly that's impossible; also undesirable.

Thank you.

> The synchronization is actually there to let the "device gone" state
> spread cleanly through the software stack.  By the time USB disconnect()
> is called, host controller drivers (and khubd) have normally cleaned up
> all hardware state, and usbcore is never going to accept another operation
> on that device.  The disconnect() callback is there to prevent that
> raciness from making trouble ... closing windows from the bottom up.

So you dispute this assertion in the email you quoted above:

On Sun, 2004-04-04 at 14:16, David Brownell wrote:
> James Bottomley wrote:
> > Since we cannot solve that
> > race, there's no reason to try to solve the "some parts of the kernel
> > know but others don't" part of the race.

On what basis?  This, I think, is the core of the differences between
us.  I don't see why an asynchronous event should proceed up the stack
in an orderly synchronised manner.

It goes like this:

- Initially, only the device knows, so commands outstanding time out
- Then, the USB driver knows, so it errors incoming commands (and
presumably returns with error any outstanding untimed out ones)
- Then, SCSI knows, so we forbid user I/O

The point is, that any I/O after disconnection gets an error ... the
error just comes from different places as the knowledge propagates
upwards.

> The way usb-storage passes that up to the SCSI layer is by calling
> scsi_remove_host().  Bug 2400 shows up later, through the block
> layer (or is it just cdrom?) code.  Did someone actually post the
> specific source code line in cdrom_release() that's oopsing?

Well, someone posted a patch a lot earlier in the thread ... we're on to
general hotplug principles now.

James


