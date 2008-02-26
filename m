From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [3/22] Remove unchecked_isa_dma in advansys.c
Date: Tue, 26 Feb 2008 07:18:18 -0800
Message-ID: <1204039098.3254.63.camel@localhost.localdomain>
References: <200802251235.889863872@firstfloor.org>
	 <20080224233516.0657F1B4183@basil.firstfloor.org>
	 <20080225214746.GA11382@parisc-linux.org>
	 <20080225224035.GB21577@one.firstfloor.org>
	 <20080225225022.GD20273@parisc-linux.org>
	 <20080226034402.GD21577@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40747 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760767AbYBZPSY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Feb 2008 10:18:24 -0500
In-Reply-To: <20080226034402.GD21577@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Tue, 2008-02-26 at 04:44 +0100, Andi Kleen wrote:
> On Mon, Feb 25, 2008 at 03:50:22PM -0700, Matthew Wilcox wrote:
> > On Mon, Feb 25, 2008 at 11:40:35PM +0100, Andi Kleen wrote:
> > > > (I must have fixed it somehow because it works on parisc, which is most
> > > > unforgiving of drivers which do DMA without the DMA API).
> > > 
> > > At least on x86 the DMA API cannot do ISA bouncing.
> > 
> > You're saying that if I set a 24-bit DMA mask, and then do a
> > pci_alloc_coherent(), x86 might hand me back something that's not
> > accessible?  That would be just broken.
> 
> No pci_alloc_coherent works, but pci_map_* will not.

Yes, it does ... dma_map is a flush/virt_to_phys on x86. so of course it
works.  If you mean it doesn't transform from > 24 bit phys to < 24 bit
phys, then yes; but that's not an API requirement; that's what bounce
buffering is all about, so for ISA devices we always only call dma_map
on < 24 bit phys addresses and it all works.

James


