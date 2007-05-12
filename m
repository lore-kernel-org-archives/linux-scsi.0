From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Sat, 12 May 2007 08:04:57 -0500
Message-ID: <1178975097.3723.2.camel@mulgrave.il.steeleye.com>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
	 <20070512091244.GA7981@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56257 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756218AbXELNFF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 09:05:05 -0400
In-Reply-To: <20070512091244.GA7981@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2007-05-12 at 11:12 +0200, Heiko Carstens wrote:
> I hope that doesn't mean that each architecture is required to
> implement all the DMA mapping stuff?

Yes, it will require this ... or at least dma_map_sg() and
dma_unmap_sg().

>  s390 doesn't have any support
> for DMA at all.

Well ... it does, you just do it differently.  You seem to construct
this fsf thing from sbals that are programmed directly from the kernel
vaddr.

This would all work in the new scenario if you simply defined
dma_map_sg() et al. to be a nop, wouldn't it?

>  The current workaround seems to be to sprinkle
> a lot of BUG() statements in code that simply won't work on such
> architectures but still compile it in.
> Lately I introduced CONFIG_HAS_DMA and made building
> drivers/base/dma-mapping.o and dmapool.o depend on that,
> so we don't compile all the non working stuff on s390. Hope
> all that can be sorted out if you go that direction.

James


