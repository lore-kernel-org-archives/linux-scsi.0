From: Andi Kleen <ak@suse.de>
Subject: GFP_DMA use in SCSI midlayer
Date: Sun, 1 Oct 2006 22:13:24 +0200
Message-ID: <200610012213.24123.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:36812 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932297AbWJAUNc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Oct 2006 16:13:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>


>From a quick grep the SCSI midlayer still uses a lot of GFP_DMA
for various things:

% gid GFP_DMA | grep scsi
drivers/scsi/aha1542.c:704:             SCpnt->host_scribble = (unsigned char *) kmalloc(512, GFP_KERNEL | GFP_DMA);
drivers/scsi/ch.c:266:  buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
drivers/scsi/ch.c:323:  buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
drivers/scsi/ch.c:773:          buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
drivers/scsi/eata.c:1358:               gfp_t gfp_mask = (shost->unchecked_isa_dma ? GFP_DMA : 0) | GFP_ATOMIC;
drivers/scsi/initio.c:2830:             if ((tul_scb = (SCB *) kmalloc(i, GFP_ATOMIC | GFP_DMA)) != NULL)
drivers/scsi/osst.c:5250:               priority |= GFP_DMA;
drivers/scsi/pluto.c:120:       fcs = (struct ctrl_inquiry *) kmalloc (sizeof (struct ctrl_inquiry) * fcscount, GFP_DMA);
drivers/scsi/sg.c:1660:  * XXX(hch): we shouldn't need GFP_DMA for the actual S/G list.
drivers/scsi/sg.c:1663:          gfp_flags |= GFP_DMA;
drivers/scsi/sg.c:2453:         page_mask = GFP_ATOMIC | GFP_DMA | __GFP_COMP | __GFP_NOWARN;
drivers/scsi/sr.c:628:  buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
drivers/scsi/sr.c:728:  buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
drivers/scsi/sr_ioctl.c:34:/* primitive to determine whether we need to have GFP_DMA set based on
drivers/scsi/sr_ioctl.c:36:#define SR_GFP_DMA(cd) (((cd)->device->host->unchecked_isa_dma) ? GFP_DMA : 0)
drivers/scsi/sr_vendor.c:120:   buffer = (unsigned char *) kmalloc(512, GFP_KERNEL | GFP_DMA);
drivers/scsi/sr_vendor.c:167:   buffer = (unsigned char *) kmalloc(512, GFP_KERNEL | GFP_DMA);
drivers/scsi/st.c:3627:         priority |= GFP_DMA;
drivers/scsi/u14-34f.c:983:            (sh[j]->unchecked_isa_dma ? GFP_DMA : 0) | GFP_ATOMIC))) {

GFP_DMA in general is deprecated and should be replaced by appropiate dma_alloc_coherent()
or similar.  And I can't imagine any modern systems still need them, and for 
the few still non CONFIG_BROKEN ISA drivers maybe some other way can be found?
And do they really require the mid layer data structures to be GFP_DMA too?

Is it possible to get rid of those GFP_DMAs in the mid layer and the 
higher level drivers like sd,sr,ch etc.?

Thanks,

-Andi
