From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [3/22] Remove unchecked_isa_dma in advansys.c
Date: Tue, 26 Feb 2008 11:40:36 -0700
Message-ID: <20080226184035.GC6029@parisc-linux.org>
References: <200802251235.889863872@firstfloor.org> <20080224233516.0657F1B4183@basil.firstfloor.org> <20080225214746.GA11382@parisc-linux.org> <20080225224035.GB21577@one.firstfloor.org> <20080225225022.GD20273@parisc-linux.org> <20080226034402.GD21577@one.firstfloor.org> <1204039098.3254.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33828 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbYBZSkh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Feb 2008 13:40:37 -0500
Content-Disposition: inline
In-Reply-To: <1204039098.3254.63.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org

On Tue, Feb 26, 2008 at 07:18:18AM -0800, James Bottomley wrote:
> On Tue, 2008-02-26 at 04:44 +0100, Andi Kleen wrote:
> > No pci_alloc_coherent works, but pci_map_* will not.
> 
> Yes, it does ... dma_map is a flush/virt_to_phys on x86. so of course it
> works.  If you mean it doesn't transform from > 24 bit phys to < 24 bit
> phys, then yes; but that's not an API requirement; that's what bounce
> buffering is all about, so for ISA devices we always only call dma_map
> on < 24 bit phys addresses and it all works.

Actually, tomo's patch violates that ...

asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);

[...]

asc_dvc->overrun_dma = dma_map_single(board->dev, asc_dvc->overrun_buf, ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);

There's a missing check for ISA boards and GFP_DMA.

Honestly, I'd rather over-allocate asc_dvc_varp->overrun_buf by 4 bytes
and map the appropriate alignment.  Patch next week, probably.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
