From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] 3ware add MSI support
Date: Thu, 24 Jul 2008 08:27:01 -0600
Message-ID: <20080724142701.GE28269@parisc-linux.org>
References: <b1bc6a000807221636s2c5ef1faj6ed0c375a14ee995@mail.gmail.com> <20080723014745.GH7337@parisc-linux.org> <1216813629.3557.3.camel@localhost.localdomain> <48871D04.8070601@panasas.com> <1216814723.3557.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58012 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYGXO1D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 10:27:03 -0400
Content-Disposition: inline
In-Reply-To: <1216814723.3557.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org

On Wed, Jul 23, 2008 at 08:05:23AM -0400, James Bottomley wrote:
> On Wed, 2008-07-23 at 14:59 +0300, Boaz Harrosh wrote:
> > James Bottomley wrote:
> > > On Tue, 2008-07-22 at 19:47 -0600, Matthew Wilcox wrote:
> > >> On Tue, Jul 22, 2008 at 04:36:32PM -0700, adam radford wrote:
> > >>> This patch for the 3w-9xxx scsi driver applies on top of the
> > >>> BKL-pushdown changes in -git9.
> > >>>
> > >>> This patch does the following:
> > >>>
> > >>> - Increase max AENs drained to 256.
> > >>> - Add MSI support and "use_msi" module parameter.
> > >>> - Fix bug in twa_get_param() on 4GB+.
> > >>> - Use pci_resource_len() for ioremap().
> > >> Is there a reason you default use_msi to off?  I would have thought
> > >> you'd want to enable it as widely as possible.
> > > 
> > > Hardly ... just look at our LSI fiasco with globally enabling them.
> > > 
> > > Right at the moment, due to motherboard bugs, it looks like global
> > > enabling of MSI by default would produce a significant increase in "my
> > > system doesn't boot" type bugs.
> > > 
> > > I asked Jesse if we could actually get better recognition of
> > > motherboards with MSI problems in pci/quirks.c to forestall some of
> > > this, but it seems to be a hard problem.  I've cc'd the PCI list in case
> > > they have better suggestions.

With my PCI hat on ... er, not sure.  It's a rather hard thing to test
generically.  You need to do a write from a card to a specific address
and see whether an interrupt is generated.  I don't think trying the
write from a CPU is sufficient as the bug can be in the host bridge, or
indeed in a PCI-PCI bridge.

Obviously, finding which systems need to be blacklisted is an important
thing to do.  Jeff Garzik claimed recently that adding MSI support to
ahci had found a lot of machines which didn't support MSI properly.

> > This seems to be a general problem. Maybe there should be an LSI_SYSTEM_DEFAULT
> > kind of parameter or function, that will enable LSI if it is default for the
> > system on all supporting drivers. This way a user can configure LSI=on for all
> > drivers in one place instead of configuring each driver individually.

I believe Boaz meant MSI_SYSTEM_DEFAULT ...

> There is ... it's the mpt_msi_enable parameter.  It defaults to off for
> SPI and FC and on for SAS.  When questioned (mainly because I have a
> working MSI SPI controller), LSI admitted it was because SPI was most
> likely to be installed in an older motherboard with some type of MSI
> failure (which gets blamed on the SCSI driver because it causes a boot
> failure).

I certainly understand that point of view.  sym2 gets blamed all the
time when it's actually an interrupt routing problem.

> If you mean a general msi enable/disable; then again we sort of have it
> in PCI; it's pci=nomsi (without this, PCI will enable msi if at all
> possible).
> 
> I'd love to toss out the one per driver msi enable/disable parameters,
> but until we can sort out recognition of the bad MSI motherboards
> reliably we're a bit stuck.

Maybe we can persuade the kind, happy, generous people at Fedora to help
out here?  We can pick a reasonably common driver (eg Fusion) and craft
a test which prints out an oops.  The oopses will be caught by
kerneloops.org and then we can add the chipsets in question to the
MSI blacklist.

We have to make the system boot anyway after this oops, or the oops
will never get collected.  So nobody should get nastygrams about boot
failing.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
