From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PATCH: Further aacraid work
Date: Fri, 18 Jun 2004 01:57:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D2842F.6090304@pobox.com>
References: <286GI-5y3-11@gated-at.bofh.it> <286Qp-5EU-19@gated-at.bofh.it> <m3smcut2z0.fsf@averell.firstfloor.org> <20040617205414.GE8705@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:19136 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263415AbUFRF50
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 01:57:26 -0400
In-Reply-To: <20040617205414.GE8705@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: Andi Kleen <ak@muc.de>, Anton Blanchard <anton@samba.org>, mark_salyzyn@adaptec.com, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>

Alan Cox wrote:
> On Thu, Jun 17, 2004 at 09:10:43PM +0200, Andi Kleen wrote:
> 
>>The AMD64 IOMMU could do it too (and the code to do it exists in
>>2.6). But the problem is that the current IO layer doesn't provide a
>>sufficient fallback path when this fails. You have to promise in
>>advance that you can merge and then later it's too late to change your
>>mind without signalling an IO error.
> 
> 
> I would rather see it below the I/O layer for things like AMD64. The
> reason I say this is that many drivers would suffer from iommu merging not
> gain, and others may have limits.


This reminds me of good ole IDE:  the first-generation SATA controllers 
carry forward the limits of the older PCI IDE controllers:  neither the 
S/G table nor any single S/G entry may span a 64K boundary.

In theory the block layer / SCSI layer DMA boundary stuff takes care of 
this -- but iommu merging _undoes_ the segment splitting that the 
hardware _requires_.  Thus, in ata_fill_sg in libata-core.c, I re-split 
the S/G list after DMA-mapping it.  A bit lame.

James and BenH discussed a solution at the DMA level, but I don't think 
anything ever happened.

	Jeff


