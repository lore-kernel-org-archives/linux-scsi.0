From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Fri, 08 Jul 2011 17:25:40 -0500
Message-ID: <1310163940.3282.113.camel@mulgrave>
References: <Pine.LNX.4.44L0.1107081801400.2208-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41986 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064Ab1GHWZp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 18:25:45 -0400
In-Reply-To: <Pine.LNX.4.44L0.1107081801400.2208-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Roland Dreier <roland@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Fri, 2011-07-08 at 18:08 -0400, Alan Stern wrote:
> On Fri, 8 Jul 2011, James Bottomley wrote:
> 
> > On Fri, 2011-07-08 at 15:43 -0400, Alan Stern wrote:
> > > On Fri, 8 Jul 2011, James Bottomley wrote:
> > > 
> > > > However, that does beg the question of why sr is using the device after
> > > > sr_remove() has completed.  That seems to be because of the block ops
> > > > being the dominant structure, so we try to do cleanup when we get the
> > > > block release rather than the driver release ... that looks to be the
> > > > root cause to me.
> > > 
> > > Hmmm.  What happens if I use sysfs to unbind the scsi_device from sr
> > > while it is still mounted, and then quickly rebind it again?  Until the
> > > filesystem is unmounted and the block release is complete, would both
> > > instances end up sending commands to the device concurrently?
> > 
> > The device will go into CANCEL or DEL and resurrection is impossible ...
> > it should give an error when you attempt the rebind.
> 
> No, you're thinking of device removal.  I'm talking about unbinding;  
> the device remains intact, only the driver is affected.  The device
> doesn't go into CANCEL or DEL, and the driver can indeed be rebound.  
> In fact I just tried it (with a USB flash drive, not a cdrom) and the
> rebind worked perfectly.

For the sr case, it's broken as I pointed out before.  For sd, you'll
see the device shut down.

James


