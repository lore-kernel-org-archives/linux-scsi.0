From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [patch 13/17] drivers/scsi/initio.c: suppress compile warning
Date: Sat, 5 Apr 2008 10:14:22 -0600
Message-ID: <20080405161422.GA19742@colo.lackof.org>
References: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org> <da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com> <1206743181.3662.55.camel@localhost.localdomain> <20080328224335.1f14cf6a@core> <1206748313.3662.66.camel@localhost.localdomain> <da824cf30803281749l614c3592t89cce073c9b043c8@mail.gmail.com> <1206760156.3662.79.camel@localhost.localdomain> <da824cf30804040005w7ae131c5he1248462041a658a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:60287 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbYDEQOf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Apr 2008 12:14:35 -0400
Content-Disposition: inline
In-Reply-To: <da824cf30804040005w7ae131c5he1248462041a658a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Fri, Apr 04, 2008 at 12:05:01AM -0700, Grant Grundler wrote:
> On Fri, Mar 28, 2008 at 8:09 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> ...
> >  If you can verify my analysis of the way the driver works, then the
> >  complete fix should be pretty simple: just remove the cpu_to_le32 from
> >  everywhere except the sg list construction.

Ok...here's a patch that builds clean on parisc (Big endian) and I *think*
addresses the issues we found.

thanks,
grant

---

Most of the cpu_to_le32() usage was wrong in one way or another.
Compiler warning on BE builds was just the tip of the iceberg.
This patch attempts to make this driver work on BE though I
don't have the HW to test it.

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 0cc8868..dbae3fd 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2581,8 +2581,8 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 	/* Map the sense buffer into bus memory */
 	dma_addr = dma_map_single(&host->pci_dev->dev, cmnd->sense_buffer,
 				  SENSE_SIZE, DMA_FROM_DEVICE);
-	cblk->senseptr = cpu_to_le32((u32)dma_addr);
-	cblk->senselen = cpu_to_le32(SENSE_SIZE);
+	cblk->senseptr = (u32)dma_addr;
+	cblk->senselen = SENSE_SIZE;
 	cmnd->SCp.ptr = (char *)(unsigned long)dma_addr;
 	cblk->cdblen = cmnd->cmd_len;
 
@@ -2606,7 +2606,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 		dma_addr = dma_map_single(&host->pci_dev->dev, &cblk->sglist[0],
 					  sizeof(struct sg_entry) * TOTAL_SG_ENTRY,
 					  DMA_BIDIRECTIONAL);
-		cblk->bufptr = cpu_to_le32((u32)dma_addr);
+		cblk->bufptr = (u32)dma_addr;
 		cmnd->SCp.dma_handle = dma_addr;
 
 		cblk->sglen = nseg;
@@ -2616,7 +2616,8 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 		sg = &cblk->sglist[0];
 		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
 			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
-			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
+			sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
+			total_len += sg_dma_len(sglist);
 			++sg;
 		}
 
