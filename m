From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 18/24][RFC] eata: Use of scsi_make_sense() API for DMA-able sense buffer
Date: Mon,  4 Feb 2008 19:29:17 +0200
Message-ID: <1202146157-5199-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:55524 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYBDRec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:34:32 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - Use a pre allocated, DMA mapped, sense buffer at each command,
    Using the scsi_make_sense() API. And scsi_return_sense() when
    done.
  - mark this driver as: "need for a pre allocated sense buffer"
    at host template.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/eata.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 8be3d76..2d9e086 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -501,6 +501,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_eh.h>
 
 static int eata2x_detect(struct scsi_host_template *);
 static int eata2x_release(struct Scsi_Host *);
@@ -524,6 +525,8 @@ static struct scsi_host_template driver_template = {
 	.this_id = 7,
 	.unchecked_isa_dma = 1,
 	.use_clustering = ENABLE_CLUSTERING,
+	.pre_allocate_sense = 1,
+	.sense_buffsize = SCSI_SENSE_BUFFERSIZE,
 };
 
 #if !defined(__BIG_ENDIAN_BITFIELD) && !defined(__LITTLE_ENDIAN_BITFIELD)
@@ -801,6 +804,7 @@ struct mscp {
 	u_int32_t data_address;	/* If sg=0 Data Address, if sg=1 sglist address */
 	u_int32_t sp_dma_addr;	/* Address where sp is DMA'ed when cp completes */
 	u_int32_t sense_addr;	/* Address where Sense Data is DMA'ed on error */
+	u8 *sense_buffer;	/* scsi_{make,return}_sense pointer */
 
 	/* Additional fields begin here. */
 	struct scsi_cmnd *SCpnt;
@@ -1619,9 +1623,9 @@ static void map_dma(unsigned int i, struct hostdata *ha)
 	SCpnt = cpp->SCpnt;
 	pci_dir = SCpnt->sc_data_direction;
 
-	if (SCpnt->sense_buffer)
-		cpp->sense_addr =
-		    H2DEV(pci_map_single(ha->pdev, SCpnt->sense_buffer,
+	cpp->sense_buffer = scsi_make_sense(SCpnt);
+	cpp->sense_addr =
+		    H2DEV(pci_map_single(ha->pdev, cpp->sense_buffer,
 			   SCSI_SENSE_BUFFERSIZE, PCI_DMA_FROMDEVICE));
 
 	cpp->sense_len = SCSI_SENSE_BUFFERSIZE;
@@ -1651,9 +1655,11 @@ static void unmap_dma(unsigned int i, struct hostdata *ha)
 	SCpnt = cpp->SCpnt;
 	pci_dir = SCpnt->sc_data_direction;
 
-	if (DEV2H(cpp->sense_addr))
+	if (DEV2H(cpp->sense_addr)) {
 		pci_unmap_single(ha->pdev, DEV2H(cpp->sense_addr),
 				 DEV2H(cpp->sense_len), PCI_DMA_FROMDEVICE);
+		scsi_return_sense(SCpnt, cpp->sense_buffer);
+	}
 
 	scsi_dma_unmap(SCpnt);
 
@@ -2428,7 +2434,7 @@ static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
 		/* Works around a flaw in scsi.c */
 		else if (tstatus == CHECK_CONDITION
 			 && SCpnt->device->type == TYPE_DISK
-			 && (SCpnt->sense_buffer[2] & 0xf) == RECOVERED_ERROR)
+			 && (cpp->sense_buffer[2] & 0xf) == RECOVERED_ERROR)
 			status = DID_BUS_BUSY << 16;
 
 		else
@@ -2440,13 +2446,13 @@ static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
 
 		if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
 		    (!(tstatus == CHECK_CONDITION && ha->iocount <= 1000 &&
-		       (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
+		       (cpp->sense_buffer[2] & 0xf) == NOT_READY)))
 			printk("%s: ihdlr, target %d.%d:%d, pid %ld, "
 			       "target_status 0x%x, sense key 0x%x.\n",
 			       ha->board_name,
 			       SCpnt->device->channel, SCpnt->device->id,
 			       SCpnt->device->lun, SCpnt->serial_number,
-			       spp->target_status, SCpnt->sense_buffer[2]);
+			       spp->target_status, cpp->sense_buffer[2]);
 
 		ha->target_to[SCpnt->device->id][SCpnt->device->channel] = 0;
 
-- 
1.5.3.3

