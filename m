From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [12/22] Remove GFP_DMAs/unchecked_isa_dma checks in scsi_scan.c
Date: Mon, 25 Feb 2008 17:34:10 +0100
Message-ID: <20080225163410.GA17349@one.firstfloor.org>
References: <200802251235.889863872@firstfloor.org> <20080224233525.31E991B4183@basil.firstfloor.org> <1203950818.3254.16.camel@localhost.localdomain> <20080225145850.GB16158@one.firstfloor.org> <1203951860.3254.26.camel@localhost.localdomain> <20080225151138.GE16158@one.firstfloor.org> <1203954305.3254.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:59671 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbYBYQdf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 11:33:35 -0500
Content-Disposition: inline
In-Reply-To: <1203954305.3254.39.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org

> You've already added a new special field with your u64
> sense_buffer_mask;

Ok I'll add another one for this case so that you can still
have zero copy SCSI scan. Or maybe it can check the block
layer bounce information directly here.

> It's a special case field for ISA devices because everything else has a
> dev->dma_mask you can use.

I'm not sure that trying to use ->dma_mask for this is all that useful.
The issue is that a lot of drivers do not actually DMA specific areas
because either they don't care about the data or the data is passed
in some other implicit way.

Trying to lump it all together into a single mask would be a mistake
I think.

> So, in fact, you're removing my single bit isa_unchecked_dma flag and
> using 64 bits in its place that preserves essentially the same
> information.  It just doesn't look like a bargain to me.  Particularly
> as you're removing a lot of the memory allocation optimisation paths at
> the same time.

Essentially it removes an ISA specific optimization and makes ISA
work like all other IO without IOMMU.

> There is a proposal that's been under consideration for a while because
> it might solve other issues ATA has with mdma (they need to use

... that'll have to be done by someone else.

-Andi

