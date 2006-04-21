From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Fri, 21 Apr 2006 23:28:16 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604212310450.3237@poirot.grange>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
 <1145054008.3520.69.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:22179 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S964790AbWDUV2R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Apr 2006 17:28:17 -0400
In-Reply-To: <1145054008.3520.69.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Frei <Sebastian@schnapsleichen.de>, Fredrik Roubert <roubert@df.lth.se>, lenehan@twibble.org

On Fri, 14 Apr 2006, James Bottomley wrote:

> I put this in, but just a warning here.  You're modifying a kmapped
> page, so you need to call flush_kernel_dcache_page() before unmapping it
> otherwise user space may not see the change on VIPT or VIVT CPU (the
> data may be in a non congruent cache line).

While we are at it, there's something else in dc395x.c I wanted to ask 
about:

		DC395x_write32(acb, TRM_S1040_DMA_XHIGHADDR, 0);
		if (srb->cmd->use_sg) {	/* with S/G */
			io_dir |= DMACMD_SG;
			DC395x_write32(acb, TRM_S1040_DMA_XLOWADDR,
				       srb->sg_bus_addr +
				       sizeof(struct SGentry) *
				       srb->sg_index);
			/* load how many bytes in the sg list table */
			DC395x_write32(acb, TRM_S1040_DMA_XCNT,
				       ((u32)(srb->sg_count -
					      srb->sg_index) << 3));
		} else {	/* without S/G */
			io_dir &= ~DMACMD_SG;
			DC395x_write32(acb, TRM_S1040_DMA_XLOWADDR,
				       srb->segment_x[0].address);
			DC395x_write32(acb, TRM_S1040_DMA_XCNT,
				       srb->segment_x[0].length);
		}

So, it looks like TRM_S1040_DMA_XHIGHADDR is always written with 0. The 
question - is TRM_S1040_DMA_XHIGHADDR the high part of a (64-bit) address? 
If so, would it work just loading it appropriately (I don't have specs)? 
If not / unknown, do we have to set pci_set_dma_mask(dev, DMA_32BIT_MASK) 
for this to work on 64-bit? What do PCI bus addresses look like on IA64 
and other 64-bit systems? Is it the 64-bit PCI extension they are using? 
Sorry, no experience with 64-bit so far.

Thanks
Guennadi
---
Guennadi Liakhovetski
