From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] 3ware add MSI support
Date: Wed, 23 Jul 2008 08:05:23 -0400
Message-ID: <1216814723.3557.7.camel@localhost.localdomain>
References: <b1bc6a000807221636s2c5ef1faj6ed0c375a14ee995@mail.gmail.com>
	 <20080723014745.GH7337@parisc-linux.org>
	 <1216813629.3557.3.camel@localhost.localdomain>
	 <48871D04.8070601@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <48871D04.8070601@panasas.com>
Sender: linux-pci-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-07-23 at 14:59 +0300, Boaz Harrosh wrote:
> James Bottomley wrote:
> > On Tue, 2008-07-22 at 19:47 -0600, Matthew Wilcox wrote:
> >> On Tue, Jul 22, 2008 at 04:36:32PM -0700, adam radford wrote:
> >>> This patch for the 3w-9xxx scsi driver applies on top of the
> >>> BKL-pushdown changes in -git9.
> >>>
> >>> This patch does the following:
> >>>
> >>> - Increase max AENs drained to 256.
> >>> - Add MSI support and "use_msi" module parameter.
> >>> - Fix bug in twa_get_param() on 4GB+.
> >>> - Use pci_resource_len() for ioremap().
> >> Is there a reason you default use_msi to off?  I would have thought
> >> you'd want to enable it as widely as possible.
> > 
> > Hardly ... just look at our LSI fiasco with globally enabling them.
> > 
> > Right at the moment, due to motherboard bugs, it looks like global
> > enabling of MSI by default would produce a significant increase in "my
> > system doesn't boot" type bugs.
> > 
> > I asked Jesse if we could actually get better recognition of
> > motherboards with MSI problems in pci/quirks.c to forestall some of
> > this, but it seems to be a hard problem.  I've cc'd the PCI list in case
> > they have better suggestions.
> > 
> > James
> > 
> 
> This seems to be a general problem. Maybe there should be an LSI_SYSTEM_DEFAULT
> kind of parameter or function, that will enable LSI if it is default for the
> system on all supporting drivers. This way a user can configure LSI=on for all
> drivers in one place instead of configuring each driver individually.

There is ... it's the mpt_msi_enable parameter.  It defaults to off for
SPI and FC and on for SAS.  When questioned (mainly because I have a
working MSI SPI controller), LSI admitted it was because SPI was most
likely to be installed in an older motherboard with some type of MSI
failure (which gets blamed on the SCSI driver because it causes a boot
failure).

If you mean a general msi enable/disable; then again we sort of have it
in PCI; it's pci=nomsi (without this, PCI will enable msi if at all
possible).

I'd love to toss out the one per driver msi enable/disable parameters,
but until we can sort out recognition of the bad MSI motherboards
reliably we're a bit stuck.

James


James
