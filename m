From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Wed, 5 Oct 2005 12:43:32 +0100
Message-ID: <20051005114332.GB11202@infradead.org>
References: <200510051314.33411.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9629 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965124AbVJELnc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2005 07:43:32 -0400
Content-Disposition: inline
In-Reply-To: <200510051314.33411.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 05, 2005 at 01:14:32PM +0200, Andi Kleen wrote:
> SCSI_ADVANSYS - vendor went out of market afaik. Probably not many left.

there's quite a lot left.  And the driver isn't really broken, just not
converted to the proper dma mapping API.  It works okay on x86, but not
on the more advanced hardware.  I have a pending new driver for the wide
scsi advansys cards but it's stuck for me to get some new wide scsi disks.

> SCSI_CPQFCTS - suboption of another driver, incredibly ugly code defying all 
> coding standards.

cpqfc should go.  mkp is working on a proper driver for the hardware.

> SCSI_EATA_PIO - really old ISA cards. Probably all left over cards are way 
> over their MTBF by now.

absolutely.

> SCSI_SEAGATE - extremly scary code, i doubt there is any such card left
> SCSI_MCA_53C9X - BROKEN_ON_SMP only. Ok I guess there are no SMP
> Micro Channel systems.
> SCSI_QLOGIC_ISP - afaik there is a newer driver for this

yes, qla1280 supports the hardware.  the only thing missing is support
for reading settings from the nvram. someone who has a qla1020/qla1040
pci card should be able to port that over easily, but when I added support
for the chips I only had sgi hardware with onboard chips available that
didn't have the nvram.

> SCSI_AMIGA7XX - no maintainer, broken forever
> ATARI_SCSI - no maintainer, broken forever
> MVME16x_SCSI - no maintainer, broken forever
> BVME6000_SCSI - same
> SUN3_SCSI - sun3 never worked in mainline anyways

yes, we should probably kill them.  the 53c7xx core driver needs to die
and the users ported over to the 53c700 core.  sun3_scsi needs to be
reimplemented using the common 5380 core instead of it's own out of
date copy.

