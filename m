From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix inia100 dma mapping warnings
Date: Mon, 27 Sep 2004 17:14:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040927151444.GA21455@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:42405 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266319AbUI0POw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 11:14:52 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

 - always use the midlayer provided field to save the dma handle for unmapping
 - merge the unmapping into the main completion handler
   

--- 1.11/drivers/scsi/i60uscsi.c	2004-07-13 15:48:19 +02:00
+++ edited/drivers/scsi/i60uscsi.c	2004-09-26 19:02:20 +02:00
@@ -682,23 +682,6 @@
 	spin_unlock_irqrestore(&(hcsp->BitAllocFlagLock), flags);
 }
 
-
-/***************************************************************************/
-void orc_release_dma(ORC_HCS * hcsp, Scsi_Cmnd * SCpnt)
-{
-	struct scatterlist *pSrbSG;
-
-	if (SCpnt->use_sg) {
-		pSrbSG = (struct scatterlist *)SCpnt->request_buffer;
-		pci_unmap_sg(hcsp->pdev, pSrbSG, SCpnt->use_sg,
-			scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
-	} else if (SCpnt->request_bufflen != 0) {
-		pci_unmap_single(hcsp->pdev, (U32)SCpnt->host_scribble,
-			SCpnt->request_bufflen,
-			scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
-	}
-}
-
 /*****************************************************************************
  Function name  : abort_SCB
  Description    : Abort a queued command.
--- 1.28/drivers/scsi/inia100.c	2004-09-12 16:07:15 +02:00
+++ edited/drivers/scsi/inia100.c	2004-09-26 19:04:45 +02:00
@@ -108,7 +108,6 @@
 extern ORC_SCB *orc_alloc_scb(ORC_HCS * hcsp);
 extern void orc_exec_scb(ORC_HCS * hcsp, ORC_SCB * scbp);
 extern void orc_release_scb(ORC_HCS * hcsp, ORC_SCB * scbp);
-extern void orc_release_dma(ORC_HCS * hcsp, struct scsi_cmnd * cmnd);
 extern void orc_interrupt(ORC_HCS * hcsp);
 extern int orc_device_reset(ORC_HCS * pHCB, struct scsi_cmnd *SCpnt, unsigned int target);
 extern int orc_reset_scsi_bus(ORC_HCS * pHCB);
@@ -128,7 +127,6 @@
 	struct scatterlist *pSrbSG;
 	ORC_SG *pSG;		/* Pointer to SG list           */
 	int i, count_sg;
-	U32 TotalLen;
 	ESCB *pEScb;
 
 	pEScb = pSCB->SCB_EScb;
@@ -146,7 +144,6 @@
 	if ((pSCB->SCB_XferLen = (U32) SCpnt->request_bufflen)) {
 		pSG = (ORC_SG *) & pEScb->ESCB_SGList[0];
 		if (SCpnt->use_sg) {
-			TotalLen = 0;
 			pSrbSG = (struct scatterlist *) SCpnt->request_buffer;
 			count_sg = pci_map_sg(pHCB->pdev, pSrbSG, SCpnt->use_sg,
 					SCpnt->sc_data_direction);
@@ -154,14 +151,14 @@
 			for (i = 0; i < count_sg; i++, pSG++, pSrbSG++) {
 				pSG->SG_Ptr = (U32) sg_dma_address(pSrbSG);
 				pSG->SG_Len = (U32) sg_dma_len(pSrbSG);
-				TotalLen += (U32) sg_dma_len(pSrbSG);
 			}
 		} else if (SCpnt->request_bufflen != 0) {/* Non SG */
 			pSCB->SCB_SGLen = 0x8;
-			pSG->SG_Ptr = (U32) pci_map_single(pHCB->pdev,
-				SCpnt->request_buffer, SCpnt->request_bufflen,
-				SCpnt->sc_data_direction);
-			SCpnt->host_scribble = (void *)pSG->SG_Ptr;
+			SCpnt->SCp.dma_handle = pci_map_single(pHCB->pdev,
+					SCpnt->request_buffer,
+					SCpnt->request_bufflen,
+					SCpnt->sc_data_direction);
+			pSG->SG_Ptr = (U32) SCpnt->SCp.dma_handle;
 			pSG->SG_Len = (U32) SCpnt->request_bufflen;
 		} else {
 			pSCB->SCB_SGLen = 0;
@@ -325,7 +322,17 @@
 		   (unsigned char *) &pEScb->ESCB_SGList[0], SENSE_SIZE);
 	}
 	pSRB->result = pSCB->SCB_TaStat | (pSCB->SCB_HaStat << 16);
-	orc_release_dma(pHCB, pSRB);  /* release DMA before we call scsi_done */
+
+	if (pSRB->use_sg) {
+		pci_unmap_sg(pHCB->pdev,
+			     (struct scatterlist *)pSRB->request_buffer,
+			     pSRB->use_sg, pSRB->sc_data_direction);
+	} else if (pSRB->request_bufflen != 0) {
+		pci_unmap_single(pHCB->pdev, pSRB->SCp.dma_handle,
+				 pSRB->request_bufflen,
+				 pSRB->sc_data_direction);
+	}
+
 	pSRB->scsi_done(pSRB);	/* Notify system DONE           */
 
 	orc_release_scb(pHCB, pSCB);	/* Release SCB for current channel */

