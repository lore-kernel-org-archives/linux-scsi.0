From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC][PATCH] allow sleep inside EH hooks
Date: Fri, 27 May 2005 13:23:58 -0400
Message-ID: <20050527172358.GA24045@havoc.gtf.org>
References: <4296A2C7.4090107@pobox.com> <20050527071109.GB27256@infradead.org> <4296D0D8.6030907@pobox.com> <20050527075924.GA28608@infradead.org> <4296DC0B.9060802@pobox.com> <42974E19.9040007@adaptec.com> <42974F95.6010603@pobox.com> <1117213489.5035.30.camel@mulgrave> <20050527172232.GA5814@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlmail.prod.rxgsys.com ([69.61.70.25]:941 "EHLO
	bastet.signetmail.com") by vger.kernel.org with ESMTP
	id S262522AbVE0RYN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 13:24:13 -0400
Content-Disposition: inline
In-Reply-To: <20050527172232.GA5814@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, May 27, 2005 at 06:22:32PM +0100, Christoph Hellwig wrote:
> On Fri, May 27, 2005 at 01:04:49PM -0400, James Bottomley wrote:
> > On Fri, 2005-05-27 at 12:49 -0400, Jeff Garzik wrote:
> > > I'm also curious to see what others think about removing the host_lock 
> > > acquisition from ->queuecommand() calls.
> > 
> > Personally I don't see the need for it for two reasons:
> > 
> > 1) There are certain atomic ops in the mid layer issue that necessitate
> > we acquire it anyway (serial number generation and state model checking)
> > 2) All queuecommand routines should move to the model of either issuing
> > or rejecting the command ... if they do that, often there's no need for
> > the mucking with lock, they remain locked throughout.
> > 
> > On point 2), look at the changes to the aic7xxx driver.  Once its
> > internal issue queueing was pulled out, it no longer needs to muck with
> > the host lock in ahc_linux_queue.  If you don't enter this locked, it
> > would just have to take it at the top and release it before return, as
> > would most other well written drivers.
> 
> The only think host_lock in ->queuecommand protects against is the
> interrupt handler, which is completely in the driver.  At which point
> it makes lots of sense to use a driver-private lock for it.  Even better
> we can get the scsi subsystem out of the irq disabling business once
> all drivers use their own locks in the interrupt handler.

Don't forget...

We still need to have some mechanism for handling the request_queue's
locking.

	Jeff



