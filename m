From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: Proposal for new generic device API: dma_get_required_mask()
Date: Sun, 20 Jun 2004 02:00:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3zn6zf68l.fsf@defiant.pm.waw.pl>
References: <1087481331.2210.27.camel@mulgrave>
	<m33c4tsnex.fsf@defiant.pm.waw.pl>
	<20040618102120.A29213@flint.arm.linux.org.uk>
	<m3brjg7994.fsf@defiant.pm.waw.pl>
	<20040619212246.B8063@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq.pm.waw.pl ([195.116.170.10]:19181 "EHLO hq.pm.waw.pl")
	by vger.kernel.org with ESMTP id S263962AbUFTCBn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2004 22:01:43 -0400
In-Reply-To: <20040619212246.B8063@flint.arm.linux.org.uk> (Russell King's
 message of "Sat, 19 Jun 2004 21:22:46 +0100")
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Russell King <rmk+lkml@arm.linux.org.uk> writes:

> The SA1111 device and associated sub-device drivers.  Basically, Intel
> has a "no fix" errata where one of the address bits gets incorrectly
> routed to the SDRAM "auto precharge" address bit.  This address bit
> must be zero, otherwise the SDRAM accesses are messed up.

Well, I knew about it, but I thought it's a "host" problem and device
drivers don't have to care.

> You may have a 32MB SDRAM but need to ensure that
> physical bit 20 is always zero - IOW you can only DMA from even MB
> addresses and not odd MB addresses.

I understand that currently the bit in question is cleared from the
masks, and that the ARM/SA1111 dma/pci alloc/map functions know how
to handle such mask?

Wouldn't it be better to not touch the masks (which are device
capabilities rather than platform limitations) and let alloc/map
functions always use the correct half of RAM?

Just asking, I've never worked with such thing.
-- 
Krzysztof Halasa, B*FH
