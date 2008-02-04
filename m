From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 15/24][RFC] tmscsim: Use scsi_eh API for REQUEST_SENSE invocation
Date: Mon,  4 Feb 2008 19:19:33 +0200
Message-ID: <1202145573-5094-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:48927 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbYBDRZf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:25:35 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - Use scsi_eh_prep/restore_cmnd() for synchronous
    REQUEST_SENSE invocation.
  - Use new sense accessors where needed.
  - Cleanup of no longer used bits

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/tmscsim.c |   72 ++++++-----------------------------------------
 drivers/scsi/tmscsim.h |   11 +------
 2 files changed, 12 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 5b04ddf..2447da9 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -242,7 +242,6 @@
 #include <scsi/scsicam.h>
 #include <scsi/scsi_tcq.h>
 
-
 #define DC390_BANNER "Tekram DC390/AM53C974"
 #define DC390_VERSION "2.1d 2004-05-27"
 
@@ -428,33 +427,13 @@ static __inline__ void dc390_Going_remove (struct dc390_dcb* pDCB, struct dc390_
    pDCB->GoingSRBCnt--;
 }
 
-static struct scatterlist* dc390_sg_build_single(struct scatterlist *sg, void *addr, unsigned int length)
-{
-	sg_init_one(sg, addr, length);
-	return sg;
-}
-
 /* Create pci mapping */
 static int dc390_pci_map (struct dc390_srb* pSRB)
 {
 	int error = 0;
 	struct scsi_cmnd *pcmd = pSRB->pcmd;
-	struct pci_dev *pdev = pSRB->pSRBDCB->pDCBACB->pdev;
-	dc390_cmd_scp_t* cmdp = ((dc390_cmd_scp_t*)(&pcmd->SCp));
-
-	/* Map sense buffer */
-	if (pSRB->SRBFlag & AUTO_REQSENSE) {
-		pSRB->pSegmentList	= dc390_sg_build_single(&pSRB->Segmentx, pcmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
-		pSRB->SGcount		= pci_map_sg(pdev, pSRB->pSegmentList, 1,
-						     DMA_FROM_DEVICE);
-		cmdp->saved_dma_handle	= sg_dma_address(pSRB->pSegmentList);
 
-		/* TODO: error handling */
-		if (pSRB->SGcount != 1)
-			error = 1;
-		DEBUG1(printk("%s(): Mapped sense buffer %p at %x\n", __FUNCTION__, pcmd->sense_buffer, cmdp->saved_dma_handle));
-	/* Map SG list */
-	} else if (scsi_sg_count(pcmd)) {
+	if (scsi_sg_count(pcmd)) {
 		int nseg;
 
 		nseg = scsi_dma_map(pcmd);
@@ -478,17 +457,10 @@ static int dc390_pci_map (struct dc390_srb* pSRB)
 static void dc390_pci_unmap (struct dc390_srb* pSRB)
 {
 	struct scsi_cmnd *pcmd = pSRB->pcmd;
-	struct pci_dev *pdev = pSRB->pSRBDCB->pDCBACB->pdev;
-	DEBUG1(dc390_cmd_scp_t* cmdp = ((dc390_cmd_scp_t*)(&pcmd->SCp)));
 
-	if (pSRB->SRBFlag) {
-		pci_unmap_sg(pdev, &pSRB->Segmentx, 1, DMA_FROM_DEVICE);
-		DEBUG1(printk("%s(): Unmapped sense buffer at %x\n", __FUNCTION__, cmdp->saved_dma_handle));
-	} else {
-		scsi_dma_unmap(pcmd);
-		DEBUG1(printk("%s(): Unmapped SG at %p with %d elements\n",
-			      __FUNCTION__, scsi_sglist(pcmd), scsi_sg_count(pcmd)));
-	}
+	scsi_dma_unmap(pcmd);
+	DEBUG1(printk("%s(): Unmapped SG at %p with %d elements\n",
+		      __FUNCTION__, scsi_sglist(pcmd), scsi_sg_count(pcmd)));
 }
 
 static void __inline__
@@ -593,23 +565,10 @@ dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_sr
     /* Command is written in CommandPhase, if SEL_W_ATN_STOP ... */
     if (cmd != SEL_W_ATN_STOP)
       {
-	if( pSRB->SRBFlag & AUTO_REQSENSE )
-	  {
-	    DC390_write8 (ScsiFifo, REQUEST_SENSE);
-	    DC390_write8 (ScsiFifo, pDCB->TargetLUN << 5);
-	    DC390_write8 (ScsiFifo, 0);
-	    DC390_write8 (ScsiFifo, 0);
-	    DC390_write8 (ScsiFifo, SCSI_SENSE_BUFFERSIZE);
-	    DC390_write8 (ScsiFifo, 0);
-	    DEBUG1(printk (KERN_DEBUG "DC390: AutoReqSense !\n"));
-	  }
-	else	/* write cmnd to bus */ 
-	  {
 	    u8 *ptr; u8 i;
 	    ptr = (u8 *)scmd->cmnd;
 	    for (i = 0; i < scmd->cmd_len; i++)
 	      DC390_write8 (ScsiFifo, *(ptr++));
-	  }
       }
     DEBUG0(if (pACB->pActiveDCB)	\
 	   printk (KERN_WARNING "DC390: ActiveDCB != 0\n"));
@@ -1369,30 +1328,17 @@ dc390_DataInPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 static void
 dc390_CommandPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 {
-    struct dc390_dcb*   pDCB;
     u8  i, cnt;
     u8     *ptr;
 
     DC390_write8 (ScsiCmd, RESET_ATN_CMD);
     DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-    if( !(pSRB->SRBFlag & AUTO_REQSENSE) )
-    {
+
 	cnt = (u8) pSRB->pcmd->cmd_len;
 	ptr = (u8 *) pSRB->pcmd->cmnd;
 	for(i=0; i < cnt; i++)
 	    DC390_write8 (ScsiFifo, *(ptr++));
-    }
-    else
-    {
-	DC390_write8 (ScsiFifo, REQUEST_SENSE);
-	pDCB = pACB->pActiveDCB;
-	DC390_write8 (ScsiFifo, pDCB->TargetLUN << 5);
-	DC390_write8 (ScsiFifo, 0);
-	DC390_write8 (ScsiFifo, 0);
-	DC390_write8 (ScsiFifo, SCSI_SENSE_BUFFERSIZE);
-	DC390_write8 (ScsiFifo, 0);
-	DEBUG0(printk(KERN_DEBUG "DC390: AutoReqSense (CmndPhase)!\n"));
-    }
+
     pSRB->SRBState = SRB_COMMAND;
     DC390_write8 (ScsiCmd, INFO_XFER_CMD);
 }
@@ -1678,16 +1624,16 @@ dc390_RequestSense(struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_
 			      pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));
 
 	pSRB->SRBFlag |= AUTO_REQSENSE;
-	pSRB->SavedTotXLen = pSRB->TotalXferredLen;
 	pSRB->AdaptStatus = 0;
 	pSRB->TargetStatus = 0; /* CHECK_CONDITION<<1; */
 
 	/* We are called from SRBdone, original PCI mapping has been removed
 	 * already, new one is set up from StartSCSI */
 	pSRB->SGIndex = 0;
-
 	pSRB->TotalXferredLen = 0;
 	pSRB->SGToBeXferLen = 0;
+
+	scsi_eh_prep_cmnd(pcmd, &pSRB->ses, NULL, 0, ~0);
 	return dc390_StartSCSI(pACB, pDCB, pSRB);
 }
 
@@ -1708,6 +1654,7 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
 		pSRB, pcmd->serial_number));
     if(pSRB->SRBFlag & AUTO_REQSENSE)
     {	/* Last command was a Request Sense */
+	scsi_eh_restore_cmnd(pSRB->pcmd, &pSRB->ses);
 	pSRB->SRBFlag &= ~AUTO_REQSENSE;
 	pSRB->AdaptStatus = 0;
 	pSRB->TargetStatus = SAM_STAT_CHECK_CONDITION;
@@ -2210,6 +2157,7 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.max_sectors		= 0x4000, /* 8MiB = 16 * 1024 * 512 */
+	.sense_buffsize		= SCSI_SENSE_BUFFERSIZE,
 };
 
 /***********************************************************************
diff --git a/drivers/scsi/tmscsim.h b/drivers/scsi/tmscsim.h
index 77adc54..909e9ac 100644
--- a/drivers/scsi/tmscsim.h
+++ b/drivers/scsi/tmscsim.h
@@ -9,6 +9,7 @@
 #define _TMSCSIM_H
 
 #include <linux/types.h>
+#include <scsi/scsi_eh.h>
 
 #define SCSI_IRQ_NONE 255
 
@@ -26,7 +27,7 @@
 */
 struct dc390_srb
 {
-//u8		CmdBlock[12];
+struct scsi_eh_save	ses;
 
 struct dc390_srb	*pNextSRB;
 struct dc390_dcb	*pSRBDCB;
@@ -40,7 +41,6 @@ unsigned long	SGBusAddr;	/*;a segment starting address as seen by AM53C974A
 				  addresses by default */
 unsigned long	SGToBeXferLen;	/*; to be xfer length */
 unsigned long	TotalXferredLen;
-unsigned long	SavedTotXLen;
 unsigned long	Saved_Ptr;
 u32		SRBState;
 
@@ -298,13 +298,6 @@ struct dc390_srb	SRB_array[MAX_SRB_CNT]; 	/* 50 SRBs */
 #define ABORT_TAG	0x0d
 
 /*
- *	SISC query queue
- */
-typedef struct {
-	dma_addr_t		saved_dma_handle;
-} dc390_cmd_scp_t;
-
-/*
 ;==========================================================
 ; EEPROM byte offset
 ;==========================================================
-- 
1.5.3.3

