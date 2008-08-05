From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Tue, 5 Aug 2008 13:53:52 -0700
Message-ID: <200808051353.52323.jbarnes@virtuousgeek.org>
References: <1217786532.4179.24.camel@localhost.localdomain> <200808051003.10400.jbarnes@virtuousgeek.org> <1217969041.9923.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1217969041.9923.64.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday, August 05, 2008 1:44 pm James Bottomley wrote:
> On Tue, 2008-08-05 at 10:03 -0700, Jesse Barnes wrote:
> > This seems to be a function that just returns what type of IRQ you're
> > using or how it's routed and it isn't necessarily "lost interrupt"
> > specific.
>
> So perhaps this routine should only note but not advise?  The drivers
> can then just call pci_interrupt_type to see if they can do anything.

If it's just a pci_irq_type function then it probably shouldn't print 
anything, and leave that to the caller, since it might be used for other 
purposes too (e.g. a driver load printk or something).  In the lost interrupt 
case you already have to disable MSI or MSIX in the Fusion driver, so you may 
as well put the printk there, right?  I guess I'm saying it should neither 
note nor advise, just return the IRQ type.

> > This information is clearly useful to drivers both for informational
> > purposes and for debugging problems, so on that front it looks good. 
> > However, I think it should probably be called pci_interrupt_type(struct
> > pci_dev *dev) or something instead, and just return an enum of either
> > MSIX, MSI, or LINE (though I'm open to better names).  From that, the
> > driver can infer what might be going wrong, though in the case of a LINE
> > interrupt, all you can really do is report that there's probably a
> > platform IRQ routing problem.
>
> The only thing that this can't do is ACPI ... but on the other hand once
> the IRQ routing is set by ACPI I'm not sure the driver can do anything
> to fix it.

Yeah, ACPI may or may not be the problem, all you'll really know is that 
you've got a line interrupt that you failed to get...  The driver won't be 
able to do much in that case aside from complain loudly.

Thanks,
Jesse
