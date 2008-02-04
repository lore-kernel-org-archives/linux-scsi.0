From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 19/24][RFC] initio: Use of scsi_make_sense() API for DMA-able sense buffer
Date: Mon,  4 Feb 2008 19:33:31 +0200
Message-ID: <1202146411-5237-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:55530 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443AbYBDRiy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:38:54 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - Use a pre allocated, DMA mapped, sense buffer at each command,
    Using the scsi_make_sense() API. And scsi_return_sense() when
    done.
  - Set .pre_allocate_sense && .sense_buffsize at host template.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/initio.c |   12 +++++++++---
 drivers/scsi/initio.h |    1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 40e9875..b32a145 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -102,6 +102,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_eh.h>
 
 #include "initio.h"
 
@@ -2578,8 +2579,9 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 
 	cblk->flags |= SCF_SENSE;	/* Turn on auto request sense   */
 
+	cblk->sense_buffer = scsi_make_sense(cmnd);
 	/* Map the sense buffer into bus memory */
-	dma_addr = dma_map_single(&host->pci_dev->dev, cmnd->sense_buffer,
+	dma_addr = dma_map_single(&host->pci_dev->dev, cblk->sense_buffer,
 				  SENSE_SIZE, DMA_FROM_DEVICE);
 	cblk->senseptr = cpu_to_le32((u32)dma_addr);
 	cblk->senselen = cpu_to_le32(SENSE_SIZE);
@@ -2733,7 +2735,8 @@ static int i91u_biosparam(struct scsi_device *sdev, struct block_device *dev,
  *	was mapped originally as part of initio_build_scb
  */
 
-static void i91u_unmap_scb(struct pci_dev *pci_dev, struct scsi_cmnd *cmnd)
+static void i91u_unmap_scb(struct pci_dev *pci_dev, struct scsi_ctrl_blk *cblk,
+							struct scsi_cmnd *cmnd)
 {
 	/* auto sense buffer */
 	if (cmnd->SCp.ptr) {
@@ -2741,6 +2744,7 @@ static void i91u_unmap_scb(struct pci_dev *pci_dev, struct scsi_cmnd *cmnd)
 				 (dma_addr_t)((unsigned long)cmnd->SCp.ptr),
 				 SENSE_SIZE, DMA_FROM_DEVICE);
 		cmnd->SCp.ptr = NULL;
+		scsi_return_sense(cmnd, cblk->sense_buffer);
 	}
 
 	/* request buffer */
@@ -2817,7 +2821,7 @@ static void i91uSCBPost(u8 * host_mem, u8 * cblk_mem)
 
 	cmnd->result = cblk->tastat | (cblk->hastat << 16);
 	WARN_ON(cmnd == NULL);
-	i91u_unmap_scb(host->pci_dev, cmnd);
+	i91u_unmap_scb(host->pci_dev, cblk, cmnd);
 	cmnd->scsi_done(cmnd);	/* Notify system DONE           */
 	initio_release_scb(host, cblk);	/* Release SCB for current channel */
 }
@@ -2833,6 +2837,8 @@ static struct scsi_host_template initio_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.pre_allocate_sense 	= 1,
+	.sense_buffsize 	= SCSI_SENSE_BUFFERSIZE,
 };
 
 static int initio_probe_one(struct pci_dev *pdev,
diff --git a/drivers/scsi/initio.h b/drivers/scsi/initio.h
index cb48efa..9e4a79d 100644
--- a/drivers/scsi/initio.h
+++ b/drivers/scsi/initio.h
@@ -384,6 +384,7 @@ struct scsi_ctrl_blk {
 	void (*post) (u8 *, u8 *);	/*4C POST routine */
 	struct scsi_cmnd *srb;	/*50 SRB Pointer */
 	struct sg_entry sglist[TOTAL_SG_ENTRY];	/*54 Start of SG list */
+	u8 *sense_buffer;
 };
 
 /* Bit Definition for status */
-- 
1.5.3.3

