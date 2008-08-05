From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Tue, 5 Aug 2008 09:42:07 -0600
Message-ID: <200808050942.08123.bjorn.helgaas@hp.com>
References: <1217786532.4179.24.camel@localhost.localdomain> <200808041443.20942.bjorn.helgaas@hp.com> <1217894547.3318.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:36684 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbYHEPnJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 11:43:09 -0400
In-Reply-To: <1217894547.3318.38.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org

On Monday 04 August 2008 06:02:27 pm James Bottomley wrote:
> On Mon, 2008-08-04 at 14:43 -0600, Bjorn Helgaas wrote:
> > On Sunday 03 August 2008 12:02:12 pm James Bottomley wrote:
> > > +static void pci_note_irq_problem(struct pci_dev *pdev, const char *reason)
> > > +{
> > > +	struct pci_dev *parent = to_pci_dev(pdev->dev.parent);
> > > +
> > > +	dev_printk(KERN_ERR, &pdev->dev,
> > > +		   "Potentially misrouted IRQ (Bridge %s %04x:%04x)\n",
> > > +		   parent->dev.bus_id, parent->vendor, parent->device);
> > 
> > Do you prefer "dev_printk(KERN_ERR, ...)" over "dev_err(...)"?  Easier
> > to grep for the former, maybe?  If so, should we deprecate "dev_err()"
> > and friends?  When I converted most of the PCI core to use dev_printk(),
> > (80ccba1186d48f ...) I used dev_err(), but I don't really care one way
> > or the other.
> > 
> > Maybe use pci_name(parent)?
> > 
> > I tried to standardize the PCI core on "[%04x/%04x]" for vendor/device ID.
> 
> To be honest I'm not really interested too much in the various API
> preferences ... they can be fixed up later by the people who care.

I'm happy to fix it up later if you prefer.  I only mentioned it
because doing it later adds churn and risk of breakage.

Bjorn
