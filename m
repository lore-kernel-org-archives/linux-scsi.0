From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Add new driver for LSI 3ware 9750
Date: Thu, 29 Oct 2009 20:08:59 +0000
Message-ID: <1256846939.7191.40.camel@mulgrave.site>
References: <b1bc6a000910201722v28d895cbv25e4959473ff215d@mail.gmail.com>
	 <200910211727.34165.eike-kernel@sf-tec.de>
	 <20091023112137.GB19566@parisc-linux.org>
	 <200910292014.28787.eike@sf-mail.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33463 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754299AbZJ2UJC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2009 16:09:02 -0400
In-Reply-To: <200910292014.28787.eike@sf-mail.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike@sf-mail.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Rolf Eike Beer <eike-kernel@sf-tec.de>, adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>

On Thu, 2009-10-29 at 20:14 +0100, Rolf Eike Beer wrote:
> Am Freitag 23 Oktober 2009 13:21:38 schrieb Matthew Wilcox:
> > On Wed, Oct 21, 2009 at 05:27:27PM +0200, Rolf Eike Beer wrote:
> > > > +	/* Try to enable MSI */
> > > > +	if (use_msi && !pci_enable_msi(pdev))
> > > > +		set_bit(TW_USING_MSI, &tw_dev->flags);
> > > > +
> > > > +	/* Now setup the interrupt handler */
> > > > +	retval = request_irq(pdev->irq, twl_interrupt, IRQF_SHARED, "3w-sas",
> > > >  tw_dev); +	if (retval) {
> > > > +		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1f, "Error requesting IRQ");
> > > > +		goto out_remove_host;
> > > > +	}
> > >
> > > If you're using MSI you should not pass IRQF_SHARED here.
> > 
> > That's not true.  While it is currently the case that each MSI gets its
> > own vector, if you have a machine with sufficiently many interrupt sources
> > and insufficiently many interrupt vectors, it is possible we'll have to
> > share interrupt vectors.  The PCI MSI code does not support this yet,
> > but it may have to in the future, and it would be unpleasant to have to
> > go through and change all the device drivers.
> 
> Sounds reasonable. Anyway I've seen the exact opposite comment from Chris (CC 
> added) in his review of VMware's driver (Message-ID: 
> <20091013053726.GE17547@sequoia.sous-sol.org> from Mon, 12 Oct 2009 22:37:26 
> -0700).
> 
> Either way is fine for me, I just would like to have a common agreement on 
> that.

I think the correct way to look at this is that IRQF_SHARED is a
statement the driver makes about its interrupt routine:  That it
correctly checks if the irq was destined for it and returns IRQ_HANDLED
in that case.  This is still a true statement regardless of whether the
interrupt can be physically shared or not.

James


