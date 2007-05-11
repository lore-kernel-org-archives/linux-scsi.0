From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 16:36:56 -0500
Message-ID: <1178919416.3692.82.camel@mulgrave.il.steeleye.com>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
	 <20070511.130024.104034874.davem@davemloft.net>
	 <1178917967.3692.70.camel@mulgrave.il.steeleye.com>
	 <20070511.142111.118971174.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52314 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753995AbXEKVhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 17:37:19 -0400
In-Reply-To: <20070511.142111.118971174.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-05-11 at 14:21 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Date: Fri, 11 May 2007 16:12:47 -0500
> 
> > I could probably cook up a patch for you, if you like? ... I've already
> > done it for several other architectures.
> 
> I don't want to use that "if (bus == &sbus_bus_type)" scheme so
> if that's what your patch will do don't bother :-)

That's sort of what you already have, if you're still using the generic
dma-mapping.h helpers in asm-sparc64.  They already have a 

BUG_ON(dev->bus != &pci_bus_type)

> I'm consolidating all of the IOMMU handling code on sparc64
> since they all do exactly the same thing, so at least on
> sparc64 there will be essentially direct calls to the IOMMU
> code agnostic of bus type.

OK ... I'll let you fix it.

On PARISC, we actually use a table of function pointers, but then we
also have several other oddities including having to walk up the bus
tree to find our IOMMU (having several) which can actually be on a
different bus type for some of the older systems (i.e. the PCI iommu is
in the GSC bus etc).

> Sparc32 will be a bit different, and that platform has no
> active maintainer so it'll have to wait until I have a
> spare weekend to do nothing but sparc32 stuff :-)

James


