From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Wed, 6 Jul 2011 08:50:07 +0200
Message-ID: <20110706065007.GB2580@osiris.boeblingen.de.ibm.com>
References: <20110704112727.GA2557@osiris.boeblingen.de.ibm.com>
 <Pine.LNX.4.44L0.1107041202170.12242-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:60106 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1GFGuR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2011 02:50:17 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107041202170.12242-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: axboe@kernel.dk, James Bottomley <James.Bottomley@HansenPartnership.com>, Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Roland Dreier <roland@kernel.org>

On Mon, Jul 04, 2011 at 12:04:54PM -0400, Alan Stern wrote:
> On Mon, 4 Jul 2011, Heiko Carstens wrote:
> 
> > On Sat, Jul 02, 2011 at 01:37:59PM -0400, Alan Stern wrote:
> > > The second bug, which hit me but apparently not any of you, is that the 
> > > request_queue's elevator gets deallocated while it is still in use.  
> > > That's because __scsi_remove_device() calls scsi_free_queue(), which 
> > > does blk_cleanup_queue(), which calls elevator_exit(), even though the 
> > > device file is still open and more requests will be submitted when the 
> > > file is closed.
> > > 
> > > I'm not sure of the right fix for this.  One possibility is to move the 
> > > scsi_free_queue() call to scsi_device_dev_release_usercontext().  Or 
> > > maybe the elevator_exit() call should be moved to blk_release_queue().
> > > 
> > > Also, I have no idea why this shows up with USB drives but not other 
> > > SCSI transports.  A fluke of timing?
> > 
> > FWIW, I reported a bug where the request_queue's elevator got deallocated
> > while it was still in use (fc transport with device hotplug):
> > 
> > http://www.spinics.net/lists/linux-scsi/msg52879.html
> 
> That does sound like the second bug I encountered.  Can you reproduce 
> it?  Does the patch here:
> 
> 	http://marc.info/?l=linux-kernel&m=130963676907731&w=2
> 
> fix the problem?

I used to be reproducible, however I have to ask Manvathara to try your
patch and see if it works.

Thanks!
