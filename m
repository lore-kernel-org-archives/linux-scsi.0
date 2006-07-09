From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: broken reverse_scan in aic7xxx
Date: Sat, 8 Jul 2006 19:29:25 -0600
Message-ID: <20060709012925.GH1605@parisc-linux.org>
References: <Pine.GSO.3.95.1060708171547.28320A-100000@rcs52.urz.tu-dresden.de> <20060708154449.GE1605@parisc-linux.org> <20060708174844.GB29602@infradead.org> <20060708183752.GF1605@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:31374 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1161034AbWGIB30 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 21:29:26 -0400
Content-Disposition: inline
In-Reply-To: <20060708183752.GF1605@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephan Seidl <stephan.seidl@tu-dresden.de>, linux-scsi@vger.kernel.org

On Sat, Jul 08, 2006 at 12:37:52PM -0600, Matthew Wilcox wrote:
> On Sat, Jul 08, 2006 at 06:48:44PM +0100, Christoph Hellwig wrote:
> > Or you could submit a patch to implement a reverse scanning option in
> > the core PCI code..
> 
> You'd want to specify that on a per-driver basis, though, surely.  Or
> all your ethernet cards would get reversed too.  Oh, but it wouldn't be
> enough for sym2 (iterate through card types instead of through pci ids),
> so you'd want another option for that.

Actually, it's even worse.  PCI doesn't do its own matching any more;
it's now part of the driver core ... so the flag/alternate
implementation has to go all through the callchain:

pci_register_driver
  __pci_register_driver
    driver_register
      bus_add_driver
        driver_attach

At this point, you'd want to change/replace the bus_for_each_dev()
macro.  Wouldn't be too hard to have a bus_for_each_dev_rev() to give
aic7xxx backward compatibility, but sym2 is completely SOL.  The real
pain is passing the information that we want to do this in reverse
all the way down the call chain.
