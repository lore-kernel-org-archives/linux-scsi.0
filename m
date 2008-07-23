From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] 3ware add MSI support
Date: Wed, 23 Jul 2008 07:47:09 -0400
Message-ID: <1216813629.3557.3.camel@localhost.localdomain>
References: <b1bc6a000807221636s2c5ef1faj6ed0c375a14ee995@mail.gmail.com>
	 <20080723014745.GH7337@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20080723014745.GH7337@parisc-linux.org>
Sender: linux-pci-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-07-22 at 19:47 -0600, Matthew Wilcox wrote:
> On Tue, Jul 22, 2008 at 04:36:32PM -0700, adam radford wrote:
> > This patch for the 3w-9xxx scsi driver applies on top of the
> > BKL-pushdown changes in -git9.
> > 
> > This patch does the following:
> > 
> > - Increase max AENs drained to 256.
> > - Add MSI support and "use_msi" module parameter.
> > - Fix bug in twa_get_param() on 4GB+.
> > - Use pci_resource_len() for ioremap().
> 
> Is there a reason you default use_msi to off?  I would have thought
> you'd want to enable it as widely as possible.

Hardly ... just look at our LSI fiasco with globally enabling them.

Right at the moment, due to motherboard bugs, it looks like global
enabling of MSI by default would produce a significant increase in "my
system doesn't boot" type bugs.

I asked Jesse if we could actually get better recognition of
motherboards with MSI problems in pci/quirks.c to forestall some of
this, but it seems to be a hard problem.  I've cc'd the PCI list in case
they have better suggestions.

James
