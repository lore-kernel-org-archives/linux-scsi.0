From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: Proposal for new generic device API: dma_get_required_mask()
Date: Sun, 20 Jun 2004 01:39:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m34qp7glsp.fsf@defiant.pm.waw.pl>
References: <1087481331.2210.27.camel@mulgrave>
	<m33c4tsnex.fsf@defiant.pm.waw.pl> <1087523134.2210.97.camel@mulgrave>
	<m3fz8s79dz.fsf@defiant.pm.waw.pl> <1087657251.2162.49.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq.pm.waw.pl ([195.116.170.10]:19437 "EHLO hq.pm.waw.pl")
	by vger.kernel.org with ESMTP id S264535AbUFTCBn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2004 22:01:43 -0400
In-Reply-To: <1087657251.2162.49.camel@mulgrave> (James Bottomley's message
 of "19 Jun 2004 10:00:50 -0500")
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@steeleye.com> writes:

> Could you elaborate on this?  In the current scheme the coherent mask is
> for descriptor allocation (i.e. dma_alloc_coherent()) and the dma_mask
> represents the bus physical addresses to which the device can DMA
> directly; there's not much more the DMA API really does, what do you
> think is missing?

The problem is that (depending on platform) the pci_map_* and dma_map_*
functions ignore both masks. An example of such platform is i386 :-)

It seems the masks are used on i386 for only one thing - consistent
dma mask is used for consistent allocations only, and normal dma mask
is not used at all.

The normal mask is used mainly on 64-bit platforms and the meaningful
values are 2^32-1 and 2^64-1. It's used by PCI-X device drivers to
enable DAC transfers. This is why it isn't used on 32-bit platforms.
-- 
Krzysztof Halasa, B*FH
