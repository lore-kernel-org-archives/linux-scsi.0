From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Mon, 4 Jul 2011 12:04:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107041202170.12242-100000@netrider.rowland.org>
References: <20110704112727.GA2557@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:53263 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755061Ab1GDQEz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2011 12:04:55 -0400
In-Reply-To: <20110704112727.GA2557@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: axboe@kernel.dk, James Bottomley <James.Bottomley@HansenPartnership.com>, Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>

On Mon, 4 Jul 2011, Heiko Carstens wrote:

> On Sat, Jul 02, 2011 at 01:37:59PM -0400, Alan Stern wrote:
> > The second bug, which hit me but apparently not any of you, is that the 
> > request_queue's elevator gets deallocated while it is still in use.  
> > That's because __scsi_remove_device() calls scsi_free_queue(), which 
> > does blk_cleanup_queue(), which calls elevator_exit(), even though the 
> > device file is still open and more requests will be submitted when the 
> > file is closed.
> > 
> > I'm not sure of the right fix for this.  One possibility is to move the 
> > scsi_free_queue() call to scsi_device_dev_release_usercontext().  Or 
> > maybe the elevator_exit() call should be moved to blk_release_queue().
> > 
> > Also, I have no idea why this shows up with USB drives but not other 
> > SCSI transports.  A fluke of timing?
> 
> FWIW, I reported a bug where the request_queue's elevator got deallocated
> while it was still in use (fc transport with device hotplug):
> 
> http://www.spinics.net/lists/linux-scsi/msg52879.html

That does sound like the second bug I encountered.  Can you reproduce 
it?  Does the patch here:

	http://marc.info/?l=linux-kernel&m=130963676907731&w=2

fix the problem?

Alan Stern

