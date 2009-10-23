From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add new driver for LSI 3ware 9750
Date: Fri, 23 Oct 2009 05:21:38 -0600
Message-ID: <20091023112137.GB19566@parisc-linux.org>
References: <b1bc6a000910201722v28d895cbv25e4959473ff215d@mail.gmail.com> <200910211727.34165.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57405 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZJWLVe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2009 07:21:34 -0400
Content-Disposition: inline
In-Reply-To: <200910211727.34165.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

On Wed, Oct 21, 2009 at 05:27:27PM +0200, Rolf Eike Beer wrote:
> > +	/* Try to enable MSI */
> > +	if (use_msi && !pci_enable_msi(pdev))
> > +		set_bit(TW_USING_MSI, &tw_dev->flags);
> > +
> > +	/* Now setup the interrupt handler */
> > +	retval = request_irq(pdev->irq, twl_interrupt, IRQF_SHARED, "3w-sas",
> >  tw_dev); +	if (retval) {
> > +		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1f, "Error requesting IRQ");
> > +		goto out_remove_host;
> > +	}
> 
> If you're using MSI you should not pass IRQF_SHARED here.

That's not true.  While it is currently the case that each MSI gets its
own vector, if you have a machine with sufficiently many interrupt sources
and insufficiently many interrupt vectors, it is possible we'll have to
share interrupt vectors.  The PCI MSI code does not support this yet,
but it may have to in the future, and it would be unpleasant to have to
go through and change all the device drivers.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
