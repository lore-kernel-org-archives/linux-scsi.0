From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ipr: don't doublefree pages from scatterlist
Date: Mon, 06 Feb 2006 01:46:08 -0800 (PST)
Message-ID: <20060206.014608.22328385.davem@davemloft.net>
References: <Pine.LNX.4.61.0602040004020.5406@goblin.wat.veritas.com>
	<43E66FB6.6070303@us.ibm.com>
	<Pine.LNX.4.61.0602060909180.6827@goblin.wat.veritas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:33708
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S1750866AbWBFJqN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 04:46:13 -0500
In-Reply-To: <Pine.LNX.4.61.0602060909180.6827@goblin.wat.veritas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hugh@veritas.com
Cc: brking@us.ibm.com, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>
Date: Mon, 6 Feb 2006 09:32:54 +0000 (GMT)

> From looking at the source, the architectures I found to be doing
> scatterlist coalescing in some cases were alpha, ia64, parisc (some
> code under drivers), powerpc, sparc64 and x86_64.
> 
> I agree with you that it would be possible for them to do the coalescing
> by just adjusting dma_address and dma_length (though it's architecture-
> dependent whether there are such fields at all), not interfering with
> the input page and length; and maybe some of them do proceed that way.
> I didn't find the coalescing code in any of them very easy to follow.
> 
> So please examine arch/x86_64/kernel/pci_gart.c gart_map_sg (and
> dma_map_cont which it calls): x86_64 was the architecture on which
> the problem was really found with drivers/scsi/st.c, and avoided
> by that boot option iommu=nomerge.
> 
> Lines like "*sout = *s;" and "*sout = sg[start];" are structure-
> copying whole scallerlist entries from one position in the list
> to another, without explicit mention of the page and length fields.

That's a bug, frankly.  Sparc64 doesn't need to do anything like
that.  Spamming the page pointers is really really bogus and I'm
surprised this doesn't make more stuff explode.

It was never the intention to allow the DMA mapping support code
to modify the page, offset, and length members of the scatterlist.
Only the DMA components.

I'd really prefer that those assignments get fixed and an explicit
note added to Documentation/DMA-mapping.txt about this.

It's rediculious that these generic subsystem drivers need to
know about this. :)

