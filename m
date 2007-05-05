From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/3] tmscsim: Remove the last bus_to_virt()
Date: Sun, 6 May 2007 01:06:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0705060052100.9593@poirot.grange>
References: <Pine.LNX.4.60.0705042259430.21060@poirot.grange>
 <20070505093859.GC9422@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51260 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934116AbXEEXG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 May 2007 19:06:57 -0400
In-Reply-To: <20070505093859.GC9422@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Sat, 5 May 2007, Christoph Hellwig wrote:

> On Fri, May 04, 2007 at 11:00:49PM +0200, Guennadi Liakhovetski wrote:
> > Dynamically map the buffer for PIO for the residue byte.
> 
> This look okay.  Btw, is there a chance you could run tmscsim.c
> through scripts/Lindent before your next round of bigger changes?

Well, I just did that - ran tmscsim.[ch] through Lindent... A couple of 
things I wouldn't do there. Like:

-static int tmscsim[] = {-2, -2, -2, -2, -2, -2};
+static int tmscsim[] = { -2, -2, -2, -2, -2, -2 };

(why extra spaces?)

-               ptr[EE_ADAPT_SCSI_ID] = (u8)tmscsim[0]; /* Adapter ID */
+               ptr[EE_ADAPT_SCSI_ID] = (u8) tmscsim[0];        /* Adapter ID */

(ditto)

-MODULE_DESCRIPTION("SCSI host adapter driver for Tekram DC390 and other AMD53C974A based PCI SCSI adapters");
+MODULE_DESCRIPTION
+    ("SCSI host adapter driver for Tekram DC390 and other AMD53C974A based PCI SCSI adapters");

(doesn't look nice. Would be better to split into two strings?)

Anyway, the diff is below. Do we really want it like that? Don't think I'd 
want to fix "minor" issues there manually.

Thanks
Guennadi
---
Guennadi Liakhovetski

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index be869d0..3fd824c 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -242,7 +242,6 @@
 #include <scsi/scsicam.h>
 #include <scsi/scsi_tcq.h>
 
-
 #define DC390_BANNER "Tekram DC390/AM53C974"
 #define DC390_VERSION "2.1d 2004-05-27"
 
@@ -250,741 +249,803 @@
 
 #include "tmscsim.h"
 
-
-static void dc390_DataOut_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_DataIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_Command_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_Status_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_MsgOut_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_MsgIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_DataOutPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_DataInPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_CommandPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_StatusPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_MsgOutPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_MsgInPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_Nop_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-static void dc390_Nop_1( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus);
-
-static void dc390_SetXferRate( struct dc390_acb* pACB, struct dc390_dcb* pDCB );
-static void dc390_Disconnect( struct dc390_acb* pACB );
-static void dc390_Reselect( struct dc390_acb* pACB );
-static void dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB );
-static void dc390_ScsiRstDetect( struct dc390_acb* pACB );
-static void dc390_EnableMsgOut_Abort(struct dc390_acb*, struct dc390_srb*);
-static void dc390_dumpinfo(struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB);
-static void dc390_ResetDevParam(struct dc390_acb* pACB);
-
-static u32	dc390_laststatus = 0;
-static u8	dc390_adapterCnt = 0;
+static void dc390_DataOut_0(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			    u8 * psstatus);
+static void dc390_DataIn_0(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			   u8 * psstatus);
+static void dc390_Command_0(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			    u8 * psstatus);
+static void dc390_Status_0(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			   u8 * psstatus);
+static void dc390_MsgOut_0(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			   u8 * psstatus);
+static void dc390_MsgIn_0(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			  u8 * psstatus);
+static void dc390_DataOutPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			       u8 * psstatus);
+static void dc390_DataInPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			      u8 * psstatus);
+static void dc390_CommandPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			       u8 * psstatus);
+static void dc390_StatusPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			      u8 * psstatus);
+static void dc390_MsgOutPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			      u8 * psstatus);
+static void dc390_MsgInPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			     u8 * psstatus);
+static void dc390_Nop_0(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			u8 * psstatus);
+static void dc390_Nop_1(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+			u8 * psstatus);
+
+static void dc390_SetXferRate(struct dc390_acb *pACB, struct dc390_dcb *pDCB);
+static void dc390_Disconnect(struct dc390_acb *pACB);
+static void dc390_Reselect(struct dc390_acb *pACB);
+static void dc390_SRBdone(struct dc390_acb *pACB, struct dc390_dcb *pDCB,
+			  struct dc390_srb *pSRB);
+static void dc390_ScsiRstDetect(struct dc390_acb *pACB);
+static void dc390_EnableMsgOut_Abort(struct dc390_acb *, struct dc390_srb *);
+static void dc390_dumpinfo(struct dc390_acb *pACB, struct dc390_dcb *pDCB,
+			   struct dc390_srb *pSRB);
+static void dc390_ResetDevParam(struct dc390_acb *pACB);
+
+static u32 dc390_laststatus = 0;
+static u8 dc390_adapterCnt = 0;
 
 static int disable_clustering;
 module_param(disable_clustering, int, S_IRUGO);
-MODULE_PARM_DESC(disable_clustering, "If you experience problems with your devices, try setting to 1");
+MODULE_PARM_DESC(disable_clustering,
+		 "If you experience problems with your devices, try setting to 1");
 
 /* Startup values, to be overriden on the commandline */
-static int tmscsim[] = {-2, -2, -2, -2, -2, -2};
+static int tmscsim[] = { -2, -2, -2, -2, -2, -2 };
 
 module_param_array(tmscsim, int, NULL, 0);
-MODULE_PARM_DESC(tmscsim, "Host SCSI ID, Speed (0=10MHz), Device Flags, Adapter Flags, Max Tags (log2(tags)-1), DelayReset (s)");
+MODULE_PARM_DESC(tmscsim,
+		 "Host SCSI ID, Speed (0=10MHz), Device Flags, Adapter Flags, Max Tags (log2(tags)-1), DelayReset (s)");
 MODULE_AUTHOR("C.L. Huang / Kurt Garloff");
-MODULE_DESCRIPTION("SCSI host adapter driver for Tekram DC390 and other AMD53C974A based PCI SCSI adapters");
+MODULE_DESCRIPTION
+    ("SCSI host adapter driver for Tekram DC390 and other AMD53C974A based PCI SCSI adapters");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("sd,sr,sg,st");
 
-static void *dc390_phase0[]={
-       dc390_DataOut_0,
-       dc390_DataIn_0,
-       dc390_Command_0,
-       dc390_Status_0,
-       dc390_Nop_0,
-       dc390_Nop_0,
-       dc390_MsgOut_0,
-       dc390_MsgIn_0,
-       dc390_Nop_1
-       };
-
-static void *dc390_phase1[]={
-       dc390_DataOutPhase,
-       dc390_DataInPhase,
-       dc390_CommandPhase,
-       dc390_StatusPhase,
-       dc390_Nop_0,
-       dc390_Nop_0,
-       dc390_MsgOutPhase,
-       dc390_MsgInPhase,
-       dc390_Nop_1
-       };
+static void *dc390_phase0[] = {
+	dc390_DataOut_0,
+	dc390_DataIn_0,
+	dc390_Command_0,
+	dc390_Status_0,
+	dc390_Nop_0,
+	dc390_Nop_0,
+	dc390_MsgOut_0,
+	dc390_MsgIn_0,
+	dc390_Nop_1
+};
+
+static void *dc390_phase1[] = {
+	dc390_DataOutPhase,
+	dc390_DataInPhase,
+	dc390_CommandPhase,
+	dc390_StatusPhase,
+	dc390_Nop_0,
+	dc390_Nop_0,
+	dc390_MsgOutPhase,
+	dc390_MsgInPhase,
+	dc390_Nop_1
+};
 
 #ifdef DC390_DEBUG1
-static char* dc390_p0_str[] = {
-       "dc390_DataOut_0",
-       "dc390_DataIn_0",
-       "dc390_Command_0",
-       "dc390_Status_0",
-       "dc390_Nop_0",
-       "dc390_Nop_0",
-       "dc390_MsgOut_0",
-       "dc390_MsgIn_0",
-       "dc390_Nop_1"
-       };
-     
-static char* dc390_p1_str[] = {
-       "dc390_DataOutPhase",
-       "dc390_DataInPhase",
-       "dc390_CommandPhase",
-       "dc390_StatusPhase",
-       "dc390_Nop_0",
-       "dc390_Nop_0",
-       "dc390_MsgOutPhase",
-       "dc390_MsgInPhase",
-       "dc390_Nop_1"
-       };
-#endif   
-
-static u8  dc390_eepromBuf[MAX_ADAPTER_NUM][EE_LEN];
-static u8  dc390_clock_period1[] = {4, 5, 6, 7, 8, 10, 13, 20};
-static u8  dc390_clock_speed[] = {100,80,67,57,50, 40, 31, 20};
+static char *dc390_p0_str[] = {
+	"dc390_DataOut_0",
+	"dc390_DataIn_0",
+	"dc390_Command_0",
+	"dc390_Status_0",
+	"dc390_Nop_0",
+	"dc390_Nop_0",
+	"dc390_MsgOut_0",
+	"dc390_MsgIn_0",
+	"dc390_Nop_1"
+};
+
+static char *dc390_p1_str[] = {
+	"dc390_DataOutPhase",
+	"dc390_DataInPhase",
+	"dc390_CommandPhase",
+	"dc390_StatusPhase",
+	"dc390_Nop_0",
+	"dc390_Nop_0",
+	"dc390_MsgOutPhase",
+	"dc390_MsgInPhase",
+	"dc390_Nop_1"
+};
+#endif
+
+static u8 dc390_eepromBuf[MAX_ADAPTER_NUM][EE_LEN];
+static u8 dc390_clock_period1[] = { 4, 5, 6, 7, 8, 10, 13, 20 };
+static u8 dc390_clock_speed[] = { 100, 80, 67, 57, 50, 40, 31, 20 };
 
 /***********************************************************************
  * Functions for the management of the internal structures 
  * (DCBs, SRBs, Queueing)
  *
  **********************************************************************/
-static struct dc390_dcb __inline__ *dc390_findDCB ( struct dc390_acb* pACB, u8 id, u8 lun)
+static struct dc390_dcb __inline__ *dc390_findDCB(struct dc390_acb *pACB, u8 id,
+						  u8 lun)
 {
-   struct dc390_dcb* pDCB = pACB->pLinkDCB; if (!pDCB) return NULL;
-   while (pDCB->TargetID != id || pDCB->TargetLUN != lun)
-     {
-	pDCB = pDCB->pNextDCB;
-	if (pDCB == pACB->pLinkDCB)
-	     return NULL;
-     }
-   DCBDEBUG1( printk (KERN_DEBUG "DCB %p (%02x,%02x) found.\n",	\
-		      pDCB, pDCB->TargetID, pDCB->TargetLUN));
-   return pDCB;
+	struct dc390_dcb *pDCB = pACB->pLinkDCB;
+	if (!pDCB)
+		return NULL;
+	while (pDCB->TargetID != id || pDCB->TargetLUN != lun) {
+		pDCB = pDCB->pNextDCB;
+		if (pDCB == pACB->pLinkDCB)
+			return NULL;
+	}
+	DCBDEBUG1(printk(KERN_DEBUG "DCB %p (%02x,%02x) found.\n",
+			 pDCB, pDCB->TargetID, pDCB->TargetLUN));
+	return pDCB;
 }
 
 /* Insert SRB oin top of free list */
-static __inline__ void dc390_Free_insert (struct dc390_acb* pACB, struct dc390_srb* pSRB)
+static __inline__ void dc390_Free_insert(struct dc390_acb *pACB,
+					 struct dc390_srb *pSRB)
 {
-    DEBUG0(printk ("DC390: Free SRB %p\n", pSRB));
-    pSRB->pNextSRB = pACB->pFreeSRB;
-    pACB->pFreeSRB = pSRB;
+	DEBUG0(printk("DC390: Free SRB %p\n", pSRB));
+	pSRB->pNextSRB = pACB->pFreeSRB;
+	pACB->pFreeSRB = pSRB;
 }
 
-static __inline__ void dc390_Going_append (struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
+static __inline__ void dc390_Going_append(struct dc390_dcb *pDCB,
+					  struct dc390_srb *pSRB)
 {
-    pDCB->GoingSRBCnt++;
-    DEBUG0(printk("DC390: Append SRB %p to Going\n", pSRB));
-    /* Append to the list of Going commands */
-    if( pDCB->pGoingSRB )
-	pDCB->pGoingLast->pNextSRB = pSRB;
-    else
-	pDCB->pGoingSRB = pSRB;
+	pDCB->GoingSRBCnt++;
+	DEBUG0(printk("DC390: Append SRB %p to Going\n", pSRB));
+	/* Append to the list of Going commands */
+	if (pDCB->pGoingSRB)
+		pDCB->pGoingLast->pNextSRB = pSRB;
+	else
+		pDCB->pGoingSRB = pSRB;
 
-    pDCB->pGoingLast = pSRB;
-    /* No next one in sent list */
-    pSRB->pNextSRB = NULL;
+	pDCB->pGoingLast = pSRB;
+	/* No next one in sent list */
+	pSRB->pNextSRB = NULL;
 }
 
-static __inline__ void dc390_Going_remove (struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
+static __inline__ void dc390_Going_remove(struct dc390_dcb *pDCB,
+					  struct dc390_srb *pSRB)
 {
 	DEBUG0(printk("DC390: Remove SRB %p from Going\n", pSRB));
-   if (pSRB == pDCB->pGoingSRB)
-	pDCB->pGoingSRB = pSRB->pNextSRB;
-   else
-     {
-	struct dc390_srb* psrb = pDCB->pGoingSRB;
-	while (psrb && psrb->pNextSRB != pSRB)
-	  psrb = psrb->pNextSRB;
-	if (!psrb) 
-	  { printk (KERN_ERR "DC390: Remove non-ex. SRB %p from Going!\n", pSRB); return; }
-	psrb->pNextSRB = pSRB->pNextSRB;
-	if (pSRB == pDCB->pGoingLast)
-	  pDCB->pGoingLast = psrb;
-     }
-   pDCB->GoingSRBCnt--;
-}
-
-static struct scatterlist* dc390_sg_build_single(struct scatterlist *sg, void *addr, unsigned int length)
+	if (pSRB == pDCB->pGoingSRB)
+		pDCB->pGoingSRB = pSRB->pNextSRB;
+	else {
+		struct dc390_srb *psrb = pDCB->pGoingSRB;
+		while (psrb && psrb->pNextSRB != pSRB)
+			psrb = psrb->pNextSRB;
+		if (!psrb) {
+			printk(KERN_ERR
+			       "DC390: Remove non-ex. SRB %p from Going!\n",
+			       pSRB);
+			return;
+		}
+		psrb->pNextSRB = pSRB->pNextSRB;
+		if (pSRB == pDCB->pGoingLast)
+			pDCB->pGoingLast = psrb;
+	}
+	pDCB->GoingSRBCnt--;
+}
+
+static struct scatterlist *dc390_sg_build_single(struct scatterlist *sg,
+						 void *addr,
+						 unsigned int length)
 {
 	memset(sg, 0, sizeof(struct scatterlist));
-	sg->page	= virt_to_page(addr);
-	sg->length	= length;
-	sg->offset	= (unsigned long)addr & ~PAGE_MASK;
+	sg->page = virt_to_page(addr);
+	sg->length = length;
+	sg->offset = (unsigned long)addr & ~PAGE_MASK;
 	return sg;
 }
 
 /* Create pci mapping */
-static int dc390_pci_map (struct dc390_srb* pSRB)
+static int dc390_pci_map(struct dc390_srb *pSRB)
 {
 	int error = 0;
 	struct scsi_cmnd *pcmd = pSRB->pcmd;
 	struct pci_dev *pdev = pSRB->pSRBDCB->pDCBACB->pdev;
-	dc390_cmd_scp_t* cmdp = ((dc390_cmd_scp_t*)(&pcmd->SCp));
+	dc390_cmd_scp_t *cmdp = ((dc390_cmd_scp_t *) (&pcmd->SCp));
 
 	/* Map sense buffer */
 	if (pSRB->SRBFlag & AUTO_REQSENSE) {
-		pSRB->pSegmentList	= dc390_sg_build_single(&pSRB->Segmentx, pcmd->sense_buffer, sizeof(pcmd->sense_buffer));
-		pSRB->SGcount		= pci_map_sg(pdev, pSRB->pSegmentList, 1,
-						     DMA_FROM_DEVICE);
-		cmdp->saved_dma_handle	= sg_dma_address(pSRB->pSegmentList);
+		pSRB->pSegmentList =
+		    dc390_sg_build_single(&pSRB->Segmentx, pcmd->sense_buffer,
+					  sizeof(pcmd->sense_buffer));
+		pSRB->SGcount =
+		    pci_map_sg(pdev, pSRB->pSegmentList, 1, DMA_FROM_DEVICE);
+		cmdp->saved_dma_handle = sg_dma_address(pSRB->pSegmentList);
 
 		/* TODO: error handling */
 		if (pSRB->SGcount != 1)
 			error = 1;
-		DEBUG1(printk("%s(): Mapped sense buffer %p at %x\n", __FUNCTION__, pcmd->sense_buffer, cmdp->saved_dma_handle));
-	/* Map SG list */
+		DEBUG1(printk
+		       ("%s(): Mapped sense buffer %p at %x\n", __FUNCTION__,
+			pcmd->sense_buffer, cmdp->saved_dma_handle));
+		/* Map SG list */
 	} else if (pcmd->use_sg) {
-		pSRB->pSegmentList	= (struct scatterlist *) pcmd->request_buffer;
-		pSRB->SGcount		= pci_map_sg(pdev, pSRB->pSegmentList, pcmd->use_sg,
-						     pcmd->sc_data_direction);
+		pSRB->pSegmentList = (struct scatterlist *)pcmd->request_buffer;
+		pSRB->SGcount =
+		    pci_map_sg(pdev, pSRB->pSegmentList, pcmd->use_sg,
+			       pcmd->sc_data_direction);
 		/* TODO: error handling */
 		if (!pSRB->SGcount)
 			error = 1;
-		DEBUG1(printk("%s(): Mapped SG %p with %d (%d) elements\n",\
-			      __FUNCTION__, pcmd->request_buffer, pSRB->SGcount, pcmd->use_sg));
-	/* Map single segment */
+		DEBUG1(printk("%s(): Mapped SG %p with %d (%d) elements\n",
+			      __FUNCTION__, pcmd->request_buffer, pSRB->SGcount,
+			      pcmd->use_sg));
+		/* Map single segment */
 	} else if (pcmd->request_buffer && pcmd->request_bufflen) {
-		pSRB->pSegmentList	= dc390_sg_build_single(&pSRB->Segmentx, pcmd->request_buffer, pcmd->request_bufflen);
-		pSRB->SGcount		= pci_map_sg(pdev, pSRB->pSegmentList, 1,
-						     pcmd->sc_data_direction);
-		cmdp->saved_dma_handle	= sg_dma_address(pSRB->pSegmentList);
+		pSRB->pSegmentList =
+		    dc390_sg_build_single(&pSRB->Segmentx, pcmd->request_buffer,
+					  pcmd->request_bufflen);
+		pSRB->SGcount =
+		    pci_map_sg(pdev, pSRB->pSegmentList, 1,
+			       pcmd->sc_data_direction);
+		cmdp->saved_dma_handle = sg_dma_address(pSRB->pSegmentList);
 
 		/* TODO: error handling */
 		if (pSRB->SGcount != 1)
 			error = 1;
-		DEBUG1(printk("%s(): Mapped request buffer %p at %x\n", __FUNCTION__, pcmd->request_buffer, cmdp->saved_dma_handle));
-	/* No mapping !? */	
-    	} else
+		DEBUG1(printk
+		       ("%s(): Mapped request buffer %p at %x\n", __FUNCTION__,
+			pcmd->request_buffer, cmdp->saved_dma_handle));
+		/* No mapping !? */
+	} else
 		pSRB->SGcount = 0;
 
 	return error;
 }
 
 /* Remove pci mapping */
-static void dc390_pci_unmap (struct dc390_srb* pSRB)
+static void dc390_pci_unmap(struct dc390_srb *pSRB)
 {
 	struct scsi_cmnd *pcmd = pSRB->pcmd;
 	struct pci_dev *pdev = pSRB->pSRBDCB->pDCBACB->pdev;
-	DEBUG1(dc390_cmd_scp_t* cmdp = ((dc390_cmd_scp_t*)(&pcmd->SCp)));
+	DEBUG1(dc390_cmd_scp_t * cmdp = ((dc390_cmd_scp_t *) (&pcmd->SCp)));
 
 	if (pSRB->SRBFlag) {
 		pci_unmap_sg(pdev, &pSRB->Segmentx, 1, DMA_FROM_DEVICE);
-		DEBUG1(printk("%s(): Unmapped sense buffer at %x\n", __FUNCTION__, cmdp->saved_dma_handle));
+		DEBUG1(printk
+		       ("%s(): Unmapped sense buffer at %x\n", __FUNCTION__,
+			cmdp->saved_dma_handle));
 	} else if (pcmd->use_sg) {
-		pci_unmap_sg(pdev, pcmd->request_buffer, pcmd->use_sg, pcmd->sc_data_direction);
-		DEBUG1(printk("%s(): Unmapped SG at %p with %d elements\n", __FUNCTION__, pcmd->request_buffer, pcmd->use_sg));
+		pci_unmap_sg(pdev, pcmd->request_buffer, pcmd->use_sg,
+			     pcmd->sc_data_direction);
+		DEBUG1(printk
+		       ("%s(): Unmapped SG at %p with %d elements\n",
+			__FUNCTION__, pcmd->request_buffer, pcmd->use_sg));
 	} else if (pcmd->request_buffer && pcmd->request_bufflen) {
 		pci_unmap_sg(pdev, &pSRB->Segmentx, 1, pcmd->sc_data_direction);
-		DEBUG1(printk("%s(): Unmapped request buffer at %x\n", __FUNCTION__, cmdp->saved_dma_handle));
+		DEBUG1(printk
+		       ("%s(): Unmapped request buffer at %x\n", __FUNCTION__,
+			cmdp->saved_dma_handle));
 	}
 }
 
 static void __inline__
-dc390_freetag (struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
+dc390_freetag(struct dc390_dcb *pDCB, struct dc390_srb *pSRB)
 {
 	if (pSRB->TagNumber != SCSI_NO_TAG) {
-		pDCB->TagMask &= ~(1 << pSRB->TagNumber);   /* free tag mask */
+		pDCB->TagMask &= ~(1 << pSRB->TagNumber);	/* free tag mask */
 		pSRB->TagNumber = SCSI_NO_TAG;
 	}
 }
 
-
 static int
-dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB )
-{
-    struct scsi_cmnd *scmd = pSRB->pcmd;
-    struct scsi_device *sdev = scmd->device;
-    u8 cmd, disc_allowed, try_sync_nego;
-    char tag[2];
-
-    pSRB->ScsiPhase = SCSI_NOP0;
-
-    if (pACB->Connected)
-    {
-	// Should not happen normally
-	printk (KERN_WARNING "DC390: Can't select when connected! (%08x,%02x)\n",
-		pSRB->SRBState, pSRB->SRBFlag);
-	pSRB->SRBState = SRB_READY;
-	pACB->SelConn++;
-	return 1;
-    }
-    if (time_before (jiffies, pACB->pScsiHost->last_reset))
-    {
-	DEBUG0(printk ("DC390: We were just reset and don't accept commands yet!\n"));
-	return 1;
-    }
-    /* KG: Moved pci mapping here */
-    dc390_pci_map(pSRB);
-    /* TODO: error handling */
-    DC390_write8 (Scsi_Dest_ID, pDCB->TargetID);
-    DC390_write8 (Sync_Period, pDCB->SyncPeriod);
-    DC390_write8 (Sync_Offset, pDCB->SyncOffset);
-    DC390_write8 (CtrlReg1, pDCB->CtrlR1);
-    DC390_write8 (CtrlReg3, pDCB->CtrlR3);
-    DC390_write8 (CtrlReg4, pDCB->CtrlR4);
-    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);		/* Flush FIFO */
-    DEBUG1(printk (KERN_INFO "DC390: Start SCSI command: %02x (Sync:%02x)\n",\
-            scmd->cmnd[0], pDCB->SyncMode));
-
-    /* Don't disconnect on AUTO_REQSENSE, cause it might be an
-     * Contingent Allegiance Condition (6.6), where no tags should be used.
-     * All other have to be allowed to disconnect to prevent Incorrect 
-     * Initiator Connection (6.8.2/6.5.2) */
-    /* Changed KG, 99/06/06 */
-    if (! (pSRB->SRBFlag & AUTO_REQSENSE))
-	disc_allowed = pDCB->DevMode & EN_DISCONNECT_;
-    else
-	disc_allowed = 0;
-
-    if ((pDCB->SyncMode & SYNC_ENABLE) && pDCB->TargetLUN == 0 && sdev->sdtr &&
-	(((scmd->cmnd[0] == REQUEST_SENSE || (pSRB->SRBFlag & AUTO_REQSENSE)) &&
-	  !(pDCB->SyncMode & SYNC_NEGO_DONE)) || scmd->cmnd[0] == INQUIRY))
-      try_sync_nego = 1;
-    else
-      try_sync_nego = 0;
-
-    pSRB->MsgCnt = 0;
-    cmd = SEL_W_ATN;
-    DC390_write8 (ScsiFifo, IDENTIFY(disc_allowed, pDCB->TargetLUN));
-    /* Change 99/05/31: Don't use tags when not disconnecting (BUSY) */
-    if ((pDCB->SyncMode & EN_TAG_QUEUEING) && disc_allowed && scsi_populate_tag_msg(scmd, tag)) {
-	DC390_write8(ScsiFifo, tag[0]);
-	pDCB->TagMask |= 1 << tag[1];
-	pSRB->TagNumber = tag[1];
-	DC390_write8(ScsiFifo, tag[1]);
-	DEBUG1(printk(KERN_INFO "DC390: Select w/DisCn for Cmd %li (SRB %p), block tag %02x\n", scmd->pid, pSRB, tag[1]));
-	cmd = SEL_W_ATN3;
-    } else {
-	/* No TagQ */
+dc390_StartSCSI(struct dc390_acb *pACB, struct dc390_dcb *pDCB,
+		struct dc390_srb *pSRB)
+{
+	struct scsi_cmnd *scmd = pSRB->pcmd;
+	struct scsi_device *sdev = scmd->device;
+	u8 cmd, disc_allowed, try_sync_nego;
+	char tag[2];
+
+	pSRB->ScsiPhase = SCSI_NOP0;
+
+	if (pACB->Connected) {
+		// Should not happen normally
+		printk(KERN_WARNING
+		       "DC390: Can't select when connected! (%08x,%02x)\n",
+		       pSRB->SRBState, pSRB->SRBFlag);
+		pSRB->SRBState = SRB_READY;
+		pACB->SelConn++;
+		return 1;
+	}
+	if (time_before(jiffies, pACB->pScsiHost->last_reset)) {
+		DEBUG0(printk
+		       ("DC390: We were just reset and don't accept commands yet!\n"));
+		return 1;
+	}
+	/* KG: Moved pci mapping here */
+	dc390_pci_map(pSRB);
+	/* TODO: error handling */
+	DC390_write8(Scsi_Dest_ID, pDCB->TargetID);
+	DC390_write8(Sync_Period, pDCB->SyncPeriod);
+	DC390_write8(Sync_Offset, pDCB->SyncOffset);
+	DC390_write8(CtrlReg1, pDCB->CtrlR1);
+	DC390_write8(CtrlReg3, pDCB->CtrlR3);
+	DC390_write8(CtrlReg4, pDCB->CtrlR4);
+	DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);	/* Flush FIFO */
+	DEBUG1(printk(KERN_INFO "DC390: Start SCSI command: %02x (Sync:%02x)\n",
+		      scmd->cmnd[0], pDCB->SyncMode));
+
+	/* Don't disconnect on AUTO_REQSENSE, cause it might be an
+	 * Contingent Allegiance Condition (6.6), where no tags should be used.
+	 * All other have to be allowed to disconnect to prevent Incorrect 
+	 * Initiator Connection (6.8.2/6.5.2) */
+	/* Changed KG, 99/06/06 */
+	if (!(pSRB->SRBFlag & AUTO_REQSENSE))
+		disc_allowed = pDCB->DevMode & EN_DISCONNECT_;
+	else
+		disc_allowed = 0;
+
+	if ((pDCB->SyncMode & SYNC_ENABLE) && pDCB->TargetLUN == 0 && sdev->sdtr
+	    &&
+	    (((scmd->cmnd[0] == REQUEST_SENSE
+	       || (pSRB->SRBFlag & AUTO_REQSENSE))
+	      && !(pDCB->SyncMode & SYNC_NEGO_DONE))
+	     || scmd->cmnd[0] == INQUIRY))
+		try_sync_nego = 1;
+	else
+		try_sync_nego = 0;
+
+	pSRB->MsgCnt = 0;
+	cmd = SEL_W_ATN;
+	DC390_write8(ScsiFifo, IDENTIFY(disc_allowed, pDCB->TargetLUN));
+	/* Change 99/05/31: Don't use tags when not disconnecting (BUSY) */
+	if ((pDCB->SyncMode & EN_TAG_QUEUEING) && disc_allowed
+	    && scsi_populate_tag_msg(scmd, tag)) {
+		DC390_write8(ScsiFifo, tag[0]);
+		pDCB->TagMask |= 1 << tag[1];
+		pSRB->TagNumber = tag[1];
+		DC390_write8(ScsiFifo, tag[1]);
+		DEBUG1(printk
+		       (KERN_INFO
+			"DC390: Select w/DisCn for Cmd %li (SRB %p), block tag %02x\n",
+			scmd->pid, pSRB, tag[1]));
+		cmd = SEL_W_ATN3;
+	} else {
+		/* No TagQ */
 //no_tag:
-	DEBUG1(printk(KERN_INFO "DC390: Select w%s/DisCn for Cmd %li (SRB %p), No TagQ\n", disc_allowed ? "" : "o", scmd->pid, pSRB));
-    }
-
-    pSRB->SRBState = SRB_START_;
-
-    if (try_sync_nego)
-      { 
-	u8 Sync_Off = pDCB->SyncOffset;
-        DEBUG0(printk (KERN_INFO "DC390: NEW Sync Nego code triggered (%i %i)\n", pDCB->TargetID, pDCB->TargetLUN));
-	pSRB->MsgOutBuf[0] = EXTENDED_MESSAGE;
-	pSRB->MsgOutBuf[1] = 3;
-	pSRB->MsgOutBuf[2] = EXTENDED_SDTR;
-	pSRB->MsgOutBuf[3] = pDCB->NegoPeriod;
-	if (!(Sync_Off & 0x0f)) Sync_Off = SYNC_NEGO_OFFSET;
-	pSRB->MsgOutBuf[4] = Sync_Off;
-	pSRB->MsgCnt = 5;
-	//pSRB->SRBState = SRB_MSGOUT_;
-	pSRB->SRBState |= DO_SYNC_NEGO;
-	cmd = SEL_W_ATN_STOP;
-      }
-
-    /* Command is written in CommandPhase, if SEL_W_ATN_STOP ... */
-    if (cmd != SEL_W_ATN_STOP)
-      {
-	if( pSRB->SRBFlag & AUTO_REQSENSE )
-	  {
-	    DC390_write8 (ScsiFifo, REQUEST_SENSE);
-	    DC390_write8 (ScsiFifo, pDCB->TargetLUN << 5);
-	    DC390_write8 (ScsiFifo, 0);
-	    DC390_write8 (ScsiFifo, 0);
-	    DC390_write8 (ScsiFifo, sizeof(scmd->sense_buffer));
-	    DC390_write8 (ScsiFifo, 0);
-	    DEBUG1(printk (KERN_DEBUG "DC390: AutoReqSense !\n"));
-	  }
-	else	/* write cmnd to bus */ 
-	  {
-	    u8 *ptr; u8 i;
-	    ptr = (u8 *)scmd->cmnd;
-	    for (i = 0; i < scmd->cmd_len; i++)
-	      DC390_write8 (ScsiFifo, *(ptr++));
-	  }
-      }
-    DEBUG0(if (pACB->pActiveDCB)	\
-	   printk (KERN_WARNING "DC390: ActiveDCB != 0\n"));
-    DEBUG0(if (pDCB->pActiveSRB)	\
-	   printk (KERN_WARNING "DC390: ActiveSRB != 0\n"));
-    //DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
-    if (DC390_read8 (Scsi_Status) & INTERRUPT)
-    {
-	dc390_freetag (pDCB, pSRB);
-	DEBUG0(printk ("DC390: Interrupt during Start SCSI (pid %li, target %02i-%02i)\n",
-		scmd->pid, scmd->device->id, scmd->device->lun));
-	pSRB->SRBState = SRB_READY;
-	//DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-	pACB->SelLost++;
-	return 1;
-    }
-    DC390_write8 (ScsiCmd, cmd);
-    pACB->pActiveDCB = pDCB;
-    pDCB->pActiveSRB = pSRB;
-    pACB->Connected = 1;
-    pSRB->ScsiPhase = SCSI_NOP1;
-    return 0;
-}
+		DEBUG1(printk
+		       (KERN_INFO
+			"DC390: Select w%s/DisCn for Cmd %li (SRB %p), No TagQ\n",
+			disc_allowed ? "" : "o", scmd->pid, pSRB));
+	}
 
+	pSRB->SRBState = SRB_START_;
+
+	if (try_sync_nego) {
+		u8 Sync_Off = pDCB->SyncOffset;
+		DEBUG0(printk
+		       (KERN_INFO
+			"DC390: NEW Sync Nego code triggered (%i %i)\n",
+			pDCB->TargetID, pDCB->TargetLUN));
+		pSRB->MsgOutBuf[0] = EXTENDED_MESSAGE;
+		pSRB->MsgOutBuf[1] = 3;
+		pSRB->MsgOutBuf[2] = EXTENDED_SDTR;
+		pSRB->MsgOutBuf[3] = pDCB->NegoPeriod;
+		if (!(Sync_Off & 0x0f))
+			Sync_Off = SYNC_NEGO_OFFSET;
+		pSRB->MsgOutBuf[4] = Sync_Off;
+		pSRB->MsgCnt = 5;
+		//pSRB->SRBState = SRB_MSGOUT_;
+		pSRB->SRBState |= DO_SYNC_NEGO;
+		cmd = SEL_W_ATN_STOP;
+	}
 
-static void __inline__
-dc390_InvalidCmd(struct dc390_acb* pACB)
+	/* Command is written in CommandPhase, if SEL_W_ATN_STOP ... */
+	if (cmd != SEL_W_ATN_STOP) {
+		if (pSRB->SRBFlag & AUTO_REQSENSE) {
+			DC390_write8(ScsiFifo, REQUEST_SENSE);
+			DC390_write8(ScsiFifo, pDCB->TargetLUN << 5);
+			DC390_write8(ScsiFifo, 0);
+			DC390_write8(ScsiFifo, 0);
+			DC390_write8(ScsiFifo, sizeof(scmd->sense_buffer));
+			DC390_write8(ScsiFifo, 0);
+			DEBUG1(printk(KERN_DEBUG "DC390: AutoReqSense !\n"));
+		} else {	/* write cmnd to bus */
+
+			u8 *ptr;
+			u8 i;
+			ptr = (u8 *) scmd->cmnd;
+			for (i = 0; i < scmd->cmd_len; i++)
+				DC390_write8(ScsiFifo, *(ptr++));
+		}
+	}
+	DEBUG0(if (pACB->pActiveDCB)
+	       printk(KERN_WARNING "DC390: ActiveDCB != 0\n")) ;
+	DEBUG0(if (pDCB->pActiveSRB)
+	       printk(KERN_WARNING "DC390: ActiveSRB != 0\n")) ;
+	//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
+	if (DC390_read8(Scsi_Status) & INTERRUPT) {
+		dc390_freetag(pDCB, pSRB);
+		DEBUG0(printk
+		       ("DC390: Interrupt during Start SCSI (pid %li, target %02i-%02i)\n",
+			scmd->pid, scmd->device->id, scmd->device->lun));
+		pSRB->SRBState = SRB_READY;
+		//DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
+		pACB->SelLost++;
+		return 1;
+	}
+	DC390_write8(ScsiCmd, cmd);
+	pACB->pActiveDCB = pDCB;
+	pDCB->pActiveSRB = pSRB;
+	pACB->Connected = 1;
+	pSRB->ScsiPhase = SCSI_NOP1;
+	return 0;
+}
+
+static void __inline__ dc390_InvalidCmd(struct dc390_acb *pACB)
 {
 	if (pACB->pActiveDCB->pActiveSRB->SRBState & (SRB_START_ | SRB_MSGOUT))
 		DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
 }
 
+static irqreturn_t __inline__ DC390_Interrupt(void *dev_id)
+{
+	struct dc390_acb *pACB = dev_id;
+	struct dc390_dcb *pDCB;
+	struct dc390_srb *pSRB;
+	u8 sstatus = 0;
+	u8 phase;
+	void (*stateV) (struct dc390_acb *, struct dc390_srb *, u8 *);
+	u8 istate, istatus;
+
+	sstatus = DC390_read8(Scsi_Status);
+	if (!(sstatus & INTERRUPT))
+		return IRQ_NONE;
+
+	DEBUG1(printk(KERN_DEBUG "sstatus=%02x,", sstatus));
+
+	//DC390_write32 (DMA_ScsiBusCtrl, WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT);
+	//dstatus = DC390_read8 (DMA_Status);
+	//DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
+
+	spin_lock_irq(pACB->pScsiHost->host_lock);
+
+	istate = DC390_read8(Intern_State);
+	istatus = DC390_read8(INT_Status);	/* This clears Scsi_Status, Intern_State and INT_Status ! */
+
+	DEBUG1(printk
+	       (KERN_INFO "Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=%02x,",
+		istatus));
+	dc390_laststatus &= ~0x00ffffff;
+	dc390_laststatus |=
+	    /* dstatus<<24 | */ sstatus << 16 | istate << 8 | istatus;
+
+	if (sstatus & ILLEGAL_OP_ERR) {
+		printk("DC390: Illegal Operation detected (%08x)!\n",
+		       dc390_laststatus);
+		dc390_dumpinfo(pACB, pACB->pActiveDCB,
+			       pACB->pActiveDCB->pActiveSRB);
+	}
 
-static irqreturn_t __inline__
-DC390_Interrupt(void *dev_id)
-{
-    struct dc390_acb *pACB = dev_id;
-    struct dc390_dcb *pDCB;
-    struct dc390_srb *pSRB;
-    u8  sstatus=0;
-    u8  phase;
-    void   (*stateV)( struct dc390_acb*, struct dc390_srb*, u8 *);
-    u8  istate, istatus;
-
-    sstatus = DC390_read8 (Scsi_Status);
-    if( !(sstatus & INTERRUPT) )
-	return IRQ_NONE;
-
-    DEBUG1(printk (KERN_DEBUG "sstatus=%02x,", sstatus));
-
-    //DC390_write32 (DMA_ScsiBusCtrl, WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT);
-    //dstatus = DC390_read8 (DMA_Status);
-    //DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
-
-    spin_lock_irq(pACB->pScsiHost->host_lock);
-
-    istate = DC390_read8 (Intern_State);
-    istatus = DC390_read8 (INT_Status); /* This clears Scsi_Status, Intern_State and INT_Status ! */
-
-    DEBUG1(printk (KERN_INFO "Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=%02x,",istatus));
-    dc390_laststatus &= ~0x00ffffff;
-    dc390_laststatus |= /* dstatus<<24 | */ sstatus<<16 | istate<<8 | istatus;
-
-    if (sstatus & ILLEGAL_OP_ERR)
-    {
-	printk ("DC390: Illegal Operation detected (%08x)!\n", dc390_laststatus);
-	dc390_dumpinfo (pACB, pACB->pActiveDCB, pACB->pActiveDCB->pActiveSRB);
-    }
-	
-    else if (istatus &  INVALID_CMD)
-    {
-	printk ("DC390: Invalid Command detected (%08x)!\n", dc390_laststatus);
-	dc390_InvalidCmd( pACB );
-	goto unlock;
-    }
-
-    if (istatus &  SCSI_RESET)
-    {
-	dc390_ScsiRstDetect( pACB );
-	goto unlock;
-    }
-
-    if (istatus &  DISCONNECTED)
-    {
-	dc390_Disconnect( pACB );
-	goto unlock;
-    }
-
-    if (istatus &  RESELECTED)
-    {
-	dc390_Reselect( pACB );
-	goto unlock;
-    }
-
-    else if (istatus & (SELECTED | SEL_ATTENTION))
-    {
-	printk (KERN_ERR "DC390: Target mode not supported!\n");
-	goto unlock;
-    }
-
-    if (istatus & (SUCCESSFUL_OP|SERVICE_REQUEST) )
-    {
-	pDCB = pACB->pActiveDCB;
-	if (!pDCB)
-	{
-		printk (KERN_ERR "DC390: Suc. op/ Serv. req: pActiveDCB = 0!\n");
+	else if (istatus & INVALID_CMD) {
+		printk("DC390: Invalid Command detected (%08x)!\n",
+		       dc390_laststatus);
+		dc390_InvalidCmd(pACB);
 		goto unlock;
 	}
-	pSRB = pDCB->pActiveSRB;
-	if( pDCB->DCBFlag & ABORT_DEV_ )
-	  dc390_EnableMsgOut_Abort (pACB, pSRB);
 
-	phase = pSRB->ScsiPhase;
-	DEBUG1(printk (KERN_INFO "DC390: [%i]%s(0) (%02x)\n", phase, dc390_p0_str[phase], sstatus));
-	stateV = (void *) dc390_phase0[phase];
-	( *stateV )( pACB, pSRB, &sstatus );
+	if (istatus & SCSI_RESET) {
+		dc390_ScsiRstDetect(pACB);
+		goto unlock;
+	}
 
-	pSRB->ScsiPhase = sstatus & 7;
-	phase = (u8) sstatus & 7;
-	DEBUG1(printk (KERN_INFO "DC390: [%i]%s(1) (%02x)\n", phase, dc390_p1_str[phase], sstatus));
-	stateV = (void *) dc390_phase1[phase];
-	( *stateV )( pACB, pSRB, &sstatus );
-    }
+	if (istatus & DISCONNECTED) {
+		dc390_Disconnect(pACB);
+		goto unlock;
+	}
 
- unlock:
-    spin_unlock_irq(pACB->pScsiHost->host_lock);
-    return IRQ_HANDLED;
+	if (istatus & RESELECTED) {
+		dc390_Reselect(pACB);
+		goto unlock;
+	}
+
+	else if (istatus & (SELECTED | SEL_ATTENTION)) {
+		printk(KERN_ERR "DC390: Target mode not supported!\n");
+		goto unlock;
+	}
+
+	if (istatus & (SUCCESSFUL_OP | SERVICE_REQUEST)) {
+		pDCB = pACB->pActiveDCB;
+		if (!pDCB) {
+			printk(KERN_ERR
+			       "DC390: Suc. op/ Serv. req: pActiveDCB = 0!\n");
+			goto unlock;
+		}
+		pSRB = pDCB->pActiveSRB;
+		if (pDCB->DCBFlag & ABORT_DEV_)
+			dc390_EnableMsgOut_Abort(pACB, pSRB);
+
+		phase = pSRB->ScsiPhase;
+		DEBUG1(printk
+		       (KERN_INFO "DC390: [%i]%s(0) (%02x)\n", phase,
+			dc390_p0_str[phase], sstatus));
+		stateV = (void *)dc390_phase0[phase];
+		(*stateV) (pACB, pSRB, &sstatus);
+
+		pSRB->ScsiPhase = sstatus & 7;
+		phase = (u8) sstatus & 7;
+		DEBUG1(printk
+		       (KERN_INFO "DC390: [%i]%s(1) (%02x)\n", phase,
+			dc390_p1_str[phase], sstatus));
+		stateV = (void *)dc390_phase1[phase];
+		(*stateV) (pACB, pSRB, &sstatus);
+	}
+
+      unlock:
+	spin_unlock_irq(pACB->pScsiHost->host_lock);
+	return IRQ_HANDLED;
 }
 
 static irqreturn_t do_DC390_Interrupt(int irq, void *dev_id)
 {
-    irqreturn_t ret;
-    DEBUG1(printk (KERN_INFO "DC390: Irq (%i) caught: ", irq));
-    /* Locking is done in DC390_Interrupt */
-    ret = DC390_Interrupt(dev_id);
-    DEBUG1(printk (".. IRQ returned\n"));
-    return ret;
+	irqreturn_t ret;
+	DEBUG1(printk(KERN_INFO "DC390: Irq (%i) caught: ", irq));
+	/* Locking is done in DC390_Interrupt */
+	ret = DC390_Interrupt(dev_id);
+	DEBUG1(printk(".. IRQ returned\n"));
+	return ret;
 }
 
 static void
-dc390_DataOut_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
-{
-    u8   sstatus;
-    struct scatterlist *psgl;
-    u32    ResidCnt, xferCnt;
-    u8   dstate = 0;
-
-    sstatus = *psstatus;
-
-    if( !(pSRB->SRBState & SRB_XFERPAD) )
-    {
-	if( sstatus & (PARITY_ERR | ILLEGAL_OP_ERR) )
-	    pSRB->SRBStatus |= PARITY_ERROR;
-
-	if( sstatus & COUNT_2_ZERO )
-	{
-	    unsigned long timeout = jiffies + HZ;
-
-	    /* Function called from the ISR with the host_lock held and interrupts disabled */
-	    if (pSRB->SGToBeXferLen)
-		while (time_before(jiffies, timeout) && !((dstate = DC390_read8 (DMA_Status)) & DMA_XFER_DONE)) {
-		    spin_unlock_irq(pACB->pScsiHost->host_lock);
-		    udelay(50);
-		    spin_lock_irq(pACB->pScsiHost->host_lock);
+dc390_DataOut_0(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
+{
+	u8 sstatus;
+	struct scatterlist *psgl;
+	u32 ResidCnt, xferCnt;
+	u8 dstate = 0;
+
+	sstatus = *psstatus;
+
+	if (!(pSRB->SRBState & SRB_XFERPAD)) {
+		if (sstatus & (PARITY_ERR | ILLEGAL_OP_ERR))
+			pSRB->SRBStatus |= PARITY_ERROR;
+
+		if (sstatus & COUNT_2_ZERO) {
+			unsigned long timeout = jiffies + HZ;
+
+			/* Function called from the ISR with the host_lock held and interrupts disabled */
+			if (pSRB->SGToBeXferLen)
+				while (time_before(jiffies, timeout)
+				       && !((dstate = DC390_read8(DMA_Status)) &
+					    DMA_XFER_DONE)) {
+					spin_unlock_irq(pACB->pScsiHost->
+							host_lock);
+					udelay(50);
+					spin_lock_irq(pACB->pScsiHost->
+						      host_lock);
+				}
+			if (!time_before(jiffies, timeout))
+				printk(KERN_CRIT
+				       "DC390: Deadlock in DataOut_0: DMA aborted unfinished: %06x bytes remain!!\n",
+				       DC390_read32(DMA_Wk_ByteCntr));
+			dc390_laststatus &= ~0xff000000;
+			dc390_laststatus |= dstate << 24;
+			pSRB->TotalXferredLen += pSRB->SGToBeXferLen;
+			pSRB->SGIndex++;
+			if (pSRB->SGIndex < pSRB->SGcount) {
+				pSRB->pSegmentList++;
+				psgl = pSRB->pSegmentList;
+
+				pSRB->SGBusAddr = sg_dma_address(psgl);
+				pSRB->SGToBeXferLen = sg_dma_len(psgl);
+			} else
+				pSRB->SGToBeXferLen = 0;
+		} else {
+			ResidCnt = (u32) DC390_read8(Current_Fifo) & 0x1f;
+			ResidCnt |= (u32) DC390_read8(CtcReg_High) << 16;
+			ResidCnt |= (u32) DC390_read8(CtcReg_Mid) << 8;
+			ResidCnt += (u32) DC390_read8(CtcReg_Low);
+
+			xferCnt = pSRB->SGToBeXferLen - ResidCnt;
+			pSRB->SGBusAddr += xferCnt;
+			pSRB->TotalXferredLen += xferCnt;
+			pSRB->SGToBeXferLen = ResidCnt;
 		}
-	    if (!time_before(jiffies, timeout))
-		printk (KERN_CRIT "DC390: Deadlock in DataOut_0: DMA aborted unfinished: %06x bytes remain!!\n",
-			DC390_read32 (DMA_Wk_ByteCntr));
-	    dc390_laststatus &= ~0xff000000;
-	    dc390_laststatus |= dstate << 24;
-	    pSRB->TotalXferredLen += pSRB->SGToBeXferLen;
-	    pSRB->SGIndex++;
-	    if( pSRB->SGIndex < pSRB->SGcount )
-	    {
-		pSRB->pSegmentList++;
-		psgl = pSRB->pSegmentList;
-
-		pSRB->SGBusAddr = sg_dma_address(psgl);
-		pSRB->SGToBeXferLen = sg_dma_len(psgl);
-	    }
-	    else
-		pSRB->SGToBeXferLen = 0;
 	}
-	else
-	{
-	    ResidCnt  = (u32) DC390_read8 (Current_Fifo) & 0x1f;
-	    ResidCnt |= (u32) DC390_read8 (CtcReg_High) << 16;
-	    ResidCnt |= (u32) DC390_read8 (CtcReg_Mid) << 8; 
-	    ResidCnt += (u32) DC390_read8 (CtcReg_Low);
-
-	    xferCnt = pSRB->SGToBeXferLen - ResidCnt;
-	    pSRB->SGBusAddr += xferCnt;
-	    pSRB->TotalXferredLen += xferCnt;
-	    pSRB->SGToBeXferLen = ResidCnt;
+	if ((*psstatus & 7) != SCSI_DATA_OUT) {
+		DC390_write8(DMA_Cmd, WRITE_DIRECTION + DMA_IDLE_CMD);
+		DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
 	}
-    }
-    if ((*psstatus & 7) != SCSI_DATA_OUT)
-    {
-	    DC390_write8 (DMA_Cmd, WRITE_DIRECTION+DMA_IDLE_CMD);
-	    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-    }	    
 }
 
 static void
-dc390_DataIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
-{
-    u8   sstatus, residual, bval;
-    struct scatterlist *psgl;
-    u32    ResidCnt, i;
-    unsigned long   xferCnt;
-    u8      *ptr;
-
-    sstatus = *psstatus;
-
-    if( !(pSRB->SRBState & SRB_XFERPAD) )
-    {
-	if( sstatus & (PARITY_ERR | ILLEGAL_OP_ERR))
-	    pSRB->SRBStatus |= PARITY_ERROR;
-
-	if( sstatus & COUNT_2_ZERO )
-	{
-	    int dstate = 0;
-	    unsigned long timeout = jiffies + HZ;
-
-	    /* Function called from the ISR with the host_lock held and interrupts disabled */
-	    if (pSRB->SGToBeXferLen)
-		while (time_before(jiffies, timeout) && !((dstate = DC390_read8 (DMA_Status)) & DMA_XFER_DONE)) {
-		    spin_unlock_irq(pACB->pScsiHost->host_lock);
-		    udelay(50);
-		    spin_lock_irq(pACB->pScsiHost->host_lock);
-		}
-	    if (!time_before(jiffies, timeout)) {
-		printk (KERN_CRIT "DC390: Deadlock in DataIn_0: DMA aborted unfinished: %06x bytes remain!!\n",
-			DC390_read32 (DMA_Wk_ByteCntr));
-		printk (KERN_CRIT "DC390: DataIn_0: DMA State: %i\n", dstate);
-	    }
-	    dc390_laststatus &= ~0xff000000;
-	    dc390_laststatus |= dstate << 24;
-	    DEBUG1(ResidCnt = ((unsigned long) DC390_read8 (CtcReg_High) << 16)	\
-		+ ((unsigned long) DC390_read8 (CtcReg_Mid) << 8)		\
-		+ ((unsigned long) DC390_read8 (CtcReg_Low)));
-	    DEBUG1(printk (KERN_DEBUG "Count_2_Zero (ResidCnt=%u,ToBeXfer=%lu),", ResidCnt, pSRB->SGToBeXferLen));
-
-	    DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD);
-
-	    pSRB->TotalXferredLen += pSRB->SGToBeXferLen;
-	    pSRB->SGIndex++;
-	    if( pSRB->SGIndex < pSRB->SGcount )
-	    {
-		pSRB->pSegmentList++;
-		psgl = pSRB->pSegmentList;
-
-		pSRB->SGBusAddr = sg_dma_address(psgl);
-		pSRB->SGToBeXferLen = sg_dma_len(psgl);
-	    }
-	    else
-		pSRB->SGToBeXferLen = 0;
-	}
-	else	/* phase changed */
-	{
-	    residual = 0;
-	    bval = DC390_read8 (Current_Fifo);
-	    while( bval & 0x1f )
-	    {
-		DEBUG1(printk (KERN_DEBUG "Check for residuals,"));
-		if( (bval & 0x1f) == 1 )
-		{
-		    for(i=0; i < 0x100; i++)
-		    {
-			bval = DC390_read8 (Current_Fifo);
-			if( !(bval & 0x1f) )
-			    goto din_1;
-			else if( i == 0x0ff )
-			{
-			    residual = 1;   /* ;1 residual byte */
-			    goto din_1;
+dc390_DataIn_0(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
+{
+	u8 sstatus, residual, bval;
+	struct scatterlist *psgl;
+	u32 ResidCnt, i;
+	unsigned long xferCnt;
+	u8 *ptr;
+
+	sstatus = *psstatus;
+
+	if (!(pSRB->SRBState & SRB_XFERPAD)) {
+		if (sstatus & (PARITY_ERR | ILLEGAL_OP_ERR))
+			pSRB->SRBStatus |= PARITY_ERROR;
+
+		if (sstatus & COUNT_2_ZERO) {
+			int dstate = 0;
+			unsigned long timeout = jiffies + HZ;
+
+			/* Function called from the ISR with the host_lock held and interrupts disabled */
+			if (pSRB->SGToBeXferLen)
+				while (time_before(jiffies, timeout)
+				       && !((dstate = DC390_read8(DMA_Status)) &
+					    DMA_XFER_DONE)) {
+					spin_unlock_irq(pACB->pScsiHost->
+							host_lock);
+					udelay(50);
+					spin_lock_irq(pACB->pScsiHost->
+						      host_lock);
+				}
+			if (!time_before(jiffies, timeout)) {
+				printk(KERN_CRIT
+				       "DC390: Deadlock in DataIn_0: DMA aborted unfinished: %06x bytes remain!!\n",
+				       DC390_read32(DMA_Wk_ByteCntr));
+				printk(KERN_CRIT
+				       "DC390: DataIn_0: DMA State: %i\n",
+				       dstate);
 			}
-		    }
-		}
-		else
-		    bval = DC390_read8 (Current_Fifo);
-	    }
-din_1:
-	    DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_BLAST_CMD);
-	    for (i = 0xa000; i; i--)
-	    {
-		bval = DC390_read8 (DMA_Status);
-		if (bval & BLAST_COMPLETE)
-		    break;
-	    }
-	    /* It seems a DMA Blast abort isn't that bad ... */
-	    if (!i) printk (KERN_ERR "DC390: DMA Blast aborted unfinished!\n");
-	    //DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD);
-	    dc390_laststatus &= ~0xff000000; dc390_laststatus |= bval << 24;
-
-	    DEBUG1(printk (KERN_DEBUG "Blast: Read %i times DMA_Status %02x", 0xa000-i, bval));
-	    ResidCnt = (u32) DC390_read8 (CtcReg_High);
-	    ResidCnt <<= 8;
-	    ResidCnt |= (u32) DC390_read8 (CtcReg_Mid);
-	    ResidCnt <<= 8;
-	    ResidCnt |= (u32) DC390_read8 (CtcReg_Low);
-
-	    xferCnt = pSRB->SGToBeXferLen - ResidCnt;
-	    pSRB->SGBusAddr += xferCnt;
-	    pSRB->TotalXferredLen += xferCnt;
-	    pSRB->SGToBeXferLen = ResidCnt;
-
-	    if( residual )
-	    {
-		static int feedback_requested;
-		bval = DC390_read8 (ScsiFifo);	    /* get one residual byte */
-
-		if (!feedback_requested) {
-			feedback_requested = 1;
-			printk(KERN_WARNING "%s: Please, contact <linux-scsi@vger.kernel.org> "
-			       "to help improve support for your system.\n", __FILE__);
-		}
-
-		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
-		*ptr = bval;
-		pSRB->SGBusAddr++;
-		xferCnt++;
-		pSRB->TotalXferredLen++;
-		pSRB->SGToBeXferLen--;
-	    }
-	    DEBUG1(printk (KERN_DEBUG "Xfered: %lu, Total: %lu, Remaining: %lu\n", xferCnt,\
-			   pSRB->TotalXferredLen, pSRB->SGToBeXferLen));
+			dc390_laststatus &= ~0xff000000;
+			dc390_laststatus |= dstate << 24;
+			DEBUG1(ResidCnt =
+			       ((unsigned long)DC390_read8(CtcReg_High) << 16)
+			       + ((unsigned long)DC390_read8(CtcReg_Mid) << 8)
+			       + ((unsigned long)DC390_read8(CtcReg_Low)));
+			DEBUG1(printk
+			       (KERN_DEBUG
+				"Count_2_Zero (ResidCnt=%u,ToBeXfer=%lu),",
+				ResidCnt, pSRB->SGToBeXferLen));
+
+			DC390_write8(DMA_Cmd, READ_DIRECTION + DMA_IDLE_CMD);
+
+			pSRB->TotalXferredLen += pSRB->SGToBeXferLen;
+			pSRB->SGIndex++;
+			if (pSRB->SGIndex < pSRB->SGcount) {
+				pSRB->pSegmentList++;
+				psgl = pSRB->pSegmentList;
+
+				pSRB->SGBusAddr = sg_dma_address(psgl);
+				pSRB->SGToBeXferLen = sg_dma_len(psgl);
+			} else
+				pSRB->SGToBeXferLen = 0;
+		} else {	/* phase changed */
+
+			residual = 0;
+			bval = DC390_read8(Current_Fifo);
+			while (bval & 0x1f) {
+				DEBUG1(printk
+				       (KERN_DEBUG "Check for residuals,"));
+				if ((bval & 0x1f) == 1) {
+					for (i = 0; i < 0x100; i++) {
+						bval =
+						    DC390_read8(Current_Fifo);
+						if (!(bval & 0x1f))
+							goto din_1;
+						else if (i == 0x0ff) {
+							residual = 1;	/* ;1 residual byte */
+							goto din_1;
+						}
+					}
+				} else
+					bval = DC390_read8(Current_Fifo);
+			}
+		      din_1:
+			DC390_write8(DMA_Cmd, READ_DIRECTION + DMA_BLAST_CMD);
+			for (i = 0xa000; i; i--) {
+				bval = DC390_read8(DMA_Status);
+				if (bval & BLAST_COMPLETE)
+					break;
+			}
+			/* It seems a DMA Blast abort isn't that bad ... */
+			if (!i)
+				printk(KERN_ERR
+				       "DC390: DMA Blast aborted unfinished!\n");
+			//DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD);
+			dc390_laststatus &= ~0xff000000;
+			dc390_laststatus |= bval << 24;
+
+			DEBUG1(printk
+			       (KERN_DEBUG
+				"Blast: Read %i times DMA_Status %02x",
+				0xa000 - i, bval));
+			ResidCnt = (u32) DC390_read8(CtcReg_High);
+			ResidCnt <<= 8;
+			ResidCnt |= (u32) DC390_read8(CtcReg_Mid);
+			ResidCnt <<= 8;
+			ResidCnt |= (u32) DC390_read8(CtcReg_Low);
+
+			xferCnt = pSRB->SGToBeXferLen - ResidCnt;
+			pSRB->SGBusAddr += xferCnt;
+			pSRB->TotalXferredLen += xferCnt;
+			pSRB->SGToBeXferLen = ResidCnt;
+
+			if (residual) {
+				static int feedback_requested;
+				bval = DC390_read8(ScsiFifo);	/* get one residual byte */
+
+				if (!feedback_requested) {
+					feedback_requested = 1;
+					printk(KERN_WARNING
+					       "%s: Please, contact <linux-scsi@vger.kernel.org> "
+					       "to help improve support for your system.\n",
+					       __FILE__);
+				}
+
+				ptr = (u8 *) bus_to_virt(pSRB->SGBusAddr);
+				*ptr = bval;
+				pSRB->SGBusAddr++;
+				xferCnt++;
+				pSRB->TotalXferredLen++;
+				pSRB->SGToBeXferLen--;
+			}
+			DEBUG1(printk
+			       (KERN_DEBUG
+				"Xfered: %lu, Total: %lu, Remaining: %lu\n",
+				xferCnt, pSRB->TotalXferredLen,
+				pSRB->SGToBeXferLen));
 
+		}
+	}
+	if ((*psstatus & 7) != SCSI_DATA_IN) {
+		DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
+		DC390_write8(DMA_Cmd, READ_DIRECTION + DMA_IDLE_CMD);
 	}
-    }
-    if ((*psstatus & 7) != SCSI_DATA_IN)
-    {
-	    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-	    DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD);
-    }
 }
 
 static void
-dc390_Command_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
+dc390_Command_0(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
 {
 }
 
 static void
-dc390_Status_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
+dc390_Status_0(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
 {
 
-    pSRB->TargetStatus = DC390_read8 (ScsiFifo);
-    //udelay (1);
-    pSRB->EndMessage = DC390_read8 (ScsiFifo);	/* get message */
+	pSRB->TargetStatus = DC390_read8(ScsiFifo);
+	//udelay (1);
+	pSRB->EndMessage = DC390_read8(ScsiFifo);	/* get message */
 
-    *psstatus = SCSI_NOP0;
-    pSRB->SRBState = SRB_COMPLETED;
-    DC390_write8 (ScsiCmd, MSG_ACCEPTED_CMD);
+	*psstatus = SCSI_NOP0;
+	pSRB->SRBState = SRB_COMPLETED;
+	DC390_write8(ScsiCmd, MSG_ACCEPTED_CMD);
 }
 
 static void
-dc390_MsgOut_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
+dc390_MsgOut_0(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
 {
-    if( pSRB->SRBState & (SRB_UNEXPECT_RESEL+SRB_ABORT_SENT) )
-	*psstatus = SCSI_NOP0;
-    //DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
+	if (pSRB->SRBState & (SRB_UNEXPECT_RESEL + SRB_ABORT_SENT))
+		*psstatus = SCSI_NOP0;
+	//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
 }
 
-
 static void __inline__
-dc390_reprog (struct dc390_acb* pACB, struct dc390_dcb* pDCB)
+dc390_reprog(struct dc390_acb *pACB, struct dc390_dcb *pDCB)
 {
-  DC390_write8 (Sync_Period, pDCB->SyncPeriod);
-  DC390_write8 (Sync_Offset, pDCB->SyncOffset);
-  DC390_write8 (CtrlReg3, pDCB->CtrlR3);
-  DC390_write8 (CtrlReg4, pDCB->CtrlR4);
-  dc390_SetXferRate (pACB, pDCB);
+	DC390_write8(Sync_Period, pDCB->SyncPeriod);
+	DC390_write8(Sync_Offset, pDCB->SyncOffset);
+	DC390_write8(CtrlReg3, pDCB->CtrlR3);
+	DC390_write8(CtrlReg4, pDCB->CtrlR4);
+	dc390_SetXferRate(pACB, pDCB);
 }
 
-
 #ifdef DC390_DEBUG0
-static void
-dc390_printMsg (u8 *MsgBuf, u8 len)
+static void dc390_printMsg(u8 * MsgBuf, u8 len)
 {
-  int i;
-  printk (" %02x", MsgBuf[0]);
-  for (i = 1; i < len; i++)
-    printk (" %02x", MsgBuf[i]);
-  printk ("\n");
+	int i;
+	printk(" %02x", MsgBuf[0]);
+	for (i = 1; i < len; i++)
+		printk(" %02x", MsgBuf[i]);
+	printk("\n");
 }
 #endif
 
@@ -992,198 +1053,203 @@ dc390_printMsg (u8 *MsgBuf, u8 len)
 
 /* reject_msg */
 static void __inline__
-dc390_MsgIn_reject (struct dc390_acb* pACB, struct dc390_srb* pSRB)
+dc390_MsgIn_reject(struct dc390_acb *pACB, struct dc390_srb *pSRB)
 {
-  pSRB->MsgOutBuf[0] = MESSAGE_REJECT;
-  pSRB->MsgCnt = 1;
-  DC390_ENABLE_MSGOUT;
-  DEBUG0 (printk (KERN_INFO "DC390: Reject message\n"));
+	pSRB->MsgOutBuf[0] = MESSAGE_REJECT;
+	pSRB->MsgCnt = 1;
+	DC390_ENABLE_MSGOUT;
+	DEBUG0(printk(KERN_INFO "DC390: Reject message\n"));
 }
 
 /* abort command */
 static void
-dc390_EnableMsgOut_Abort ( struct dc390_acb* pACB, struct dc390_srb* pSRB )
+dc390_EnableMsgOut_Abort(struct dc390_acb *pACB, struct dc390_srb *pSRB)
 {
-    pSRB->MsgOutBuf[0] = ABORT; 
-    pSRB->MsgCnt = 1; DC390_ENABLE_MSGOUT;
-    pSRB->pSRBDCB->DCBFlag &= ~ABORT_DEV_;
+	pSRB->MsgOutBuf[0] = ABORT;
+	pSRB->MsgCnt = 1;
+	DC390_ENABLE_MSGOUT;
+	pSRB->pSRBDCB->DCBFlag &= ~ABORT_DEV_;
 }
 
-static struct dc390_srb*
-dc390_MsgIn_QTag (struct dc390_acb* pACB, struct dc390_dcb* pDCB, s8 tag)
+static struct dc390_srb *dc390_MsgIn_QTag(struct dc390_acb *pACB,
+					  struct dc390_dcb *pDCB, s8 tag)
 {
-  struct dc390_srb* pSRB = pDCB->pGoingSRB;
+	struct dc390_srb *pSRB = pDCB->pGoingSRB;
 
-  if (pSRB)
-    {
-	struct scsi_cmnd *scmd = scsi_find_tag(pSRB->pcmd->device, tag);
-	pSRB = (struct dc390_srb *)scmd->host_scribble;
+	if (pSRB) {
+		struct scsi_cmnd *scmd = scsi_find_tag(pSRB->pcmd->device, tag);
+		pSRB = (struct dc390_srb *)scmd->host_scribble;
 
-	if (pDCB->DCBFlag & ABORT_DEV_)
-	{
-	  pSRB->SRBState = SRB_ABORT_SENT;
-	  dc390_EnableMsgOut_Abort( pACB, pSRB );
-	}
+		if (pDCB->DCBFlag & ABORT_DEV_) {
+			pSRB->SRBState = SRB_ABORT_SENT;
+			dc390_EnableMsgOut_Abort(pACB, pSRB);
+		}
 
-	if (!(pSRB->SRBState & SRB_DISCONNECT))
-		goto mingx0;
+		if (!(pSRB->SRBState & SRB_DISCONNECT))
+			goto mingx0;
 
-	pDCB->pActiveSRB = pSRB;
-	pSRB->SRBState = SRB_DATA_XFER;
-    }
-  else
-    {
-    mingx0:
-      pSRB = pACB->pTmpSRB;
-      pSRB->SRBState = SRB_UNEXPECT_RESEL;
-      pDCB->pActiveSRB = pSRB;
-      pSRB->MsgOutBuf[0] = ABORT_TAG;
-      pSRB->MsgCnt = 1; DC390_ENABLE_MSGOUT;
-    }
-  return pSRB;
+		pDCB->pActiveSRB = pSRB;
+		pSRB->SRBState = SRB_DATA_XFER;
+	} else {
+	      mingx0:
+		pSRB = pACB->pTmpSRB;
+		pSRB->SRBState = SRB_UNEXPECT_RESEL;
+		pDCB->pActiveSRB = pSRB;
+		pSRB->MsgOutBuf[0] = ABORT_TAG;
+		pSRB->MsgCnt = 1;
+		DC390_ENABLE_MSGOUT;
+	}
+	return pSRB;
 }
 
-
 /* set async transfer mode */
-static void 
-dc390_MsgIn_set_async (struct dc390_acb* pACB, struct dc390_srb* pSRB)
-{
-  struct dc390_dcb* pDCB = pSRB->pSRBDCB;
-  if (!(pSRB->SRBState & DO_SYNC_NEGO)) 
-    printk (KERN_INFO "DC390: Target %i initiates Non-Sync?\n", pDCB->TargetID);
-  pSRB->SRBState &= ~DO_SYNC_NEGO;
-  pDCB->SyncMode &= ~(SYNC_ENABLE+SYNC_NEGO_DONE);
-  pDCB->SyncPeriod = 0;
-  pDCB->SyncOffset = 0;
-  //pDCB->NegoPeriod = 50; /* 200ns <=> 5 MHz */
-  pDCB->CtrlR3 = FAST_CLK;	/* fast clock / normal scsi */
-  pDCB->CtrlR4 &= 0x3f;
-  pDCB->CtrlR4 |= pACB->glitch_cfg;	/* glitch eater */
-  dc390_reprog (pACB, pDCB);
+static void
+dc390_MsgIn_set_async(struct dc390_acb *pACB, struct dc390_srb *pSRB)
+{
+	struct dc390_dcb *pDCB = pSRB->pSRBDCB;
+	if (!(pSRB->SRBState & DO_SYNC_NEGO))
+		printk(KERN_INFO "DC390: Target %i initiates Non-Sync?\n",
+		       pDCB->TargetID);
+	pSRB->SRBState &= ~DO_SYNC_NEGO;
+	pDCB->SyncMode &= ~(SYNC_ENABLE + SYNC_NEGO_DONE);
+	pDCB->SyncPeriod = 0;
+	pDCB->SyncOffset = 0;
+	//pDCB->NegoPeriod = 50; /* 200ns <=> 5 MHz */
+	pDCB->CtrlR3 = FAST_CLK;	/* fast clock / normal scsi */
+	pDCB->CtrlR4 &= 0x3f;
+	pDCB->CtrlR4 |= pACB->glitch_cfg;	/* glitch eater */
+	dc390_reprog(pACB, pDCB);
 }
 
 /* set sync transfer mode */
-static void
-dc390_MsgIn_set_sync (struct dc390_acb* pACB, struct dc390_srb* pSRB)
-{
-  u8 bval;
-  u16 wval, wval1;
-  struct dc390_dcb* pDCB = pSRB->pSRBDCB;
-  u8 oldsyncperiod = pDCB->SyncPeriod;
-  u8 oldsyncoffset = pDCB->SyncOffset;
-  
-  if (!(pSRB->SRBState & DO_SYNC_NEGO))
-    {
-      printk (KERN_INFO "DC390: Target %i initiates Sync: %ins %i ... answer ...\n", 
-	      pDCB->TargetID, pSRB->MsgInBuf[3]<<2, pSRB->MsgInBuf[4]);
-
-      /* reject */
-      //dc390_MsgIn_reject (pACB, pSRB);
-      //return dc390_MsgIn_set_async (pACB, pSRB);
-
-      /* Reply with corrected SDTR Message */
-      if (pSRB->MsgInBuf[4] > 15)
-	{ 
-	  printk (KERN_INFO "DC390: Lower Sync Offset to 15\n");
-	  pSRB->MsgInBuf[4] = 15;
+static void dc390_MsgIn_set_sync(struct dc390_acb *pACB, struct dc390_srb *pSRB)
+{
+	u8 bval;
+	u16 wval, wval1;
+	struct dc390_dcb *pDCB = pSRB->pSRBDCB;
+	u8 oldsyncperiod = pDCB->SyncPeriod;
+	u8 oldsyncoffset = pDCB->SyncOffset;
+
+	if (!(pSRB->SRBState & DO_SYNC_NEGO)) {
+		printk(KERN_INFO
+		       "DC390: Target %i initiates Sync: %ins %i ... answer ...\n",
+		       pDCB->TargetID, pSRB->MsgInBuf[3] << 2,
+		       pSRB->MsgInBuf[4]);
+
+		/* reject */
+		//dc390_MsgIn_reject (pACB, pSRB);
+		//return dc390_MsgIn_set_async (pACB, pSRB);
+
+		/* Reply with corrected SDTR Message */
+		if (pSRB->MsgInBuf[4] > 15) {
+			printk(KERN_INFO "DC390: Lower Sync Offset to 15\n");
+			pSRB->MsgInBuf[4] = 15;
+		}
+		if (pSRB->MsgInBuf[3] < pDCB->NegoPeriod) {
+			printk(KERN_INFO
+			       "DC390: Set sync nego period to %ins\n",
+			       pDCB->NegoPeriod << 2);
+			pSRB->MsgInBuf[3] = pDCB->NegoPeriod;
+		}
+		memcpy(pSRB->MsgOutBuf, pSRB->MsgInBuf, 5);
+		pSRB->MsgCnt = 5;
+		DC390_ENABLE_MSGOUT;
 	}
-      if (pSRB->MsgInBuf[3] < pDCB->NegoPeriod)
-	{
-	  printk (KERN_INFO "DC390: Set sync nego period to %ins\n", pDCB->NegoPeriod << 2);
-	  pSRB->MsgInBuf[3] = pDCB->NegoPeriod;
+
+	pSRB->SRBState &= ~DO_SYNC_NEGO;
+	pDCB->SyncMode |= SYNC_ENABLE + SYNC_NEGO_DONE;
+	pDCB->SyncOffset &= 0x0f0;
+	pDCB->SyncOffset |= pSRB->MsgInBuf[4];
+	pDCB->NegoPeriod = pSRB->MsgInBuf[3];
+
+	wval = (u16) pSRB->MsgInBuf[3];
+	wval = wval << 2;
+	wval -= 3;
+	wval1 = wval / 25;	/* compute speed */
+	if ((wval1 * 25) != wval)
+		wval1++;
+	bval = FAST_CLK + FAST_SCSI;	/* fast clock / fast scsi */
+
+	pDCB->CtrlR4 &= 0x3f;	/* Glitch eater: 12ns less than normal */
+	if (pACB->glitch_cfg != NS_TO_GLITCH(0))
+		pDCB->CtrlR4 |=
+		    NS_TO_GLITCH(((GLITCH_TO_NS(pACB->glitch_cfg)) - 1));
+	else
+		pDCB->CtrlR4 |= NS_TO_GLITCH(0);
+	if (wval1 < 4)
+		pDCB->CtrlR4 |= NS_TO_GLITCH(0);	/* Ultra */
+
+	if (wval1 >= 8) {
+		wval1--;	/* Timing computation differs by 1 from FAST_SCSI */
+		bval = FAST_CLK;	/* fast clock / normal scsi */
+		pDCB->CtrlR4 |= pACB->glitch_cfg;	/* glitch eater */
 	}
-      memcpy (pSRB->MsgOutBuf, pSRB->MsgInBuf, 5);
-      pSRB->MsgCnt = 5;
-      DC390_ENABLE_MSGOUT;
-    }
-
-  pSRB->SRBState &= ~DO_SYNC_NEGO;
-  pDCB->SyncMode |= SYNC_ENABLE+SYNC_NEGO_DONE;
-  pDCB->SyncOffset &= 0x0f0;
-  pDCB->SyncOffset |= pSRB->MsgInBuf[4];
-  pDCB->NegoPeriod = pSRB->MsgInBuf[3];
-
-  wval = (u16) pSRB->MsgInBuf[3];
-  wval = wval << 2; wval -= 3; wval1 = wval / 25;	/* compute speed */
-  if( (wval1 * 25) != wval) wval1++;
-  bval = FAST_CLK+FAST_SCSI;	/* fast clock / fast scsi */
-
-  pDCB->CtrlR4 &= 0x3f;		/* Glitch eater: 12ns less than normal */
-  if (pACB->glitch_cfg != NS_TO_GLITCH(0))
-    pDCB->CtrlR4 |= NS_TO_GLITCH(((GLITCH_TO_NS(pACB->glitch_cfg)) - 1));
-  else
-    pDCB->CtrlR4 |= NS_TO_GLITCH(0);
-  if (wval1 < 4) pDCB->CtrlR4 |= NS_TO_GLITCH(0); /* Ultra */
-
-  if (wval1 >= 8)
-    {
-      wval1--;	/* Timing computation differs by 1 from FAST_SCSI */
-      bval = FAST_CLK;		/* fast clock / normal scsi */
-      pDCB->CtrlR4 |= pACB->glitch_cfg; 	/* glitch eater */
-    }
-
-  pDCB->CtrlR3 = bval;
-  pDCB->SyncPeriod = (u8)wval1;
-  
-  if ((oldsyncperiod != wval1 || oldsyncoffset != pDCB->SyncOffset) && pDCB->TargetLUN == 0)
-    {
-      if (! (bval & FAST_SCSI)) wval1++;
-      printk (KERN_INFO "DC390: Target %i: Sync transfer %i.%1i MHz, Offset %i\n", pDCB->TargetID, 
-	      40/wval1, ((40%wval1)*10+wval1/2)/wval1, pDCB->SyncOffset & 0x0f);
-    }
-  
-  dc390_reprog (pACB, pDCB);
-}
 
+	pDCB->CtrlR3 = bval;
+	pDCB->SyncPeriod = (u8) wval1;
+
+	if ((oldsyncperiod != wval1 || oldsyncoffset != pDCB->SyncOffset)
+	    && pDCB->TargetLUN == 0) {
+		if (!(bval & FAST_SCSI))
+			wval1++;
+		printk(KERN_INFO
+		       "DC390: Target %i: Sync transfer %i.%1i MHz, Offset %i\n",
+		       pDCB->TargetID, 40 / wval1,
+		       ((40 % wval1) * 10 + wval1 / 2) / wval1,
+		       pDCB->SyncOffset & 0x0f);
+	}
+
+	dc390_reprog(pACB, pDCB);
+}
 
 /* handle RESTORE_PTR */
 /* I presume, this command is already mapped, so, have to remap. */
-static void 
-dc390_restore_ptr (struct dc390_acb* pACB, struct dc390_srb* pSRB)
-{
-    struct scsi_cmnd *pcmd = pSRB->pcmd;
-    struct scatterlist *psgl;
-    pSRB->TotalXferredLen = 0;
-    pSRB->SGIndex = 0;
-    if (pcmd->use_sg) {
-	pSRB->pSegmentList = (struct scatterlist *)pcmd->request_buffer;
-	psgl = pSRB->pSegmentList;
-	//dc390_pci_sync(pSRB);
-
-	while (pSRB->TotalXferredLen + (unsigned long) sg_dma_len(psgl) < pSRB->Saved_Ptr)
-	{
-	    pSRB->TotalXferredLen += (unsigned long) sg_dma_len(psgl);
-	    pSRB->SGIndex++;
-	    if( pSRB->SGIndex < pSRB->SGcount )
-	    {
-		pSRB->pSegmentList++;
+static void dc390_restore_ptr(struct dc390_acb *pACB, struct dc390_srb *pSRB)
+{
+	struct scsi_cmnd *pcmd = pSRB->pcmd;
+	struct scatterlist *psgl;
+	pSRB->TotalXferredLen = 0;
+	pSRB->SGIndex = 0;
+	if (pcmd->use_sg) {
+		pSRB->pSegmentList = (struct scatterlist *)pcmd->request_buffer;
 		psgl = pSRB->pSegmentList;
-		pSRB->SGBusAddr = sg_dma_address(psgl);
-		pSRB->SGToBeXferLen = sg_dma_len(psgl);
-	    }
-	    else
-		pSRB->SGToBeXferLen = 0;
+		//dc390_pci_sync(pSRB);
+
+		while (pSRB->TotalXferredLen + (unsigned long)sg_dma_len(psgl) <
+		       pSRB->Saved_Ptr) {
+			pSRB->TotalXferredLen +=
+			    (unsigned long)sg_dma_len(psgl);
+			pSRB->SGIndex++;
+			if (pSRB->SGIndex < pSRB->SGcount) {
+				pSRB->pSegmentList++;
+				psgl = pSRB->pSegmentList;
+				pSRB->SGBusAddr = sg_dma_address(psgl);
+				pSRB->SGToBeXferLen = sg_dma_len(psgl);
+			} else
+				pSRB->SGToBeXferLen = 0;
+		}
+		pSRB->SGToBeXferLen -= pSRB->Saved_Ptr - pSRB->TotalXferredLen;
+		pSRB->SGBusAddr += pSRB->Saved_Ptr - pSRB->TotalXferredLen;
+		printk(KERN_INFO
+		       "DC390: Pointer restored. Segment %i, Total %li, Bus %08lx\n",
+		       pSRB->SGIndex, pSRB->Saved_Ptr, pSRB->SGBusAddr);
+
+	} else if (pcmd->request_buffer) {
+		//dc390_pci_sync(pSRB);
+
+		sg_dma_len(&pSRB->Segmentx) =
+		    pcmd->request_bufflen - pSRB->Saved_Ptr;
+		pSRB->SGcount = 1;
+		pSRB->pSegmentList = (struct scatterlist *)&pSRB->Segmentx;
+	} else {
+		pSRB->SGcount = 0;
+		printk(KERN_INFO
+		       "DC390: RESTORE_PTR message for Transfer without Scatter-Gather ??\n");
 	}
-	pSRB->SGToBeXferLen -= pSRB->Saved_Ptr - pSRB->TotalXferredLen;
-	pSRB->SGBusAddr += pSRB->Saved_Ptr - pSRB->TotalXferredLen;
-	printk (KERN_INFO "DC390: Pointer restored. Segment %i, Total %li, Bus %08lx\n",
-		pSRB->SGIndex, pSRB->Saved_Ptr, pSRB->SGBusAddr);
-
-    } else if(pcmd->request_buffer) {
-	//dc390_pci_sync(pSRB);
-
-	sg_dma_len(&pSRB->Segmentx) = pcmd->request_bufflen - pSRB->Saved_Ptr;
-	pSRB->SGcount = 1;
-	pSRB->pSegmentList = (struct scatterlist *) &pSRB->Segmentx;
-    } else {
-	 pSRB->SGcount = 0;
-	 printk (KERN_INFO "DC390: RESTORE_PTR message for Transfer without Scatter-Gather ??\n");
-    }
 
-  pSRB->TotalXferredLen = pSRB->Saved_Ptr;
+	pSRB->TotalXferredLen = pSRB->Saved_Ptr;
 }
 
-
 /* According to the docs, the AM53C974 reads the message and 
  * generates a Successful Operation IRQ before asserting ACK for
  * the last byte (how does it know whether it's the last ?) */
@@ -1193,504 +1259,488 @@ dc390_restore_ptr (struct dc390_acb* pACB, struct dc390_srb* pSRB)
 /* The old implementation was correct. Sigh! */
 
 /* Check if the message is complete */
-static u8 __inline__
-dc390_MsgIn_complete (u8 *msgbuf, u32 len)
-{ 
-  if (*msgbuf == EXTENDED_MESSAGE)
-  {
-	if (len < 2) return 0;
-	if (len < msgbuf[1] + 2) return 0;
-  }
-  else if (*msgbuf >= 0x20 && *msgbuf <= 0x2f) // two byte messages
-	if (len < 2) return 0;
-  return 1;
+static u8 __inline__ dc390_MsgIn_complete(u8 * msgbuf, u32 len)
+{
+	if (*msgbuf == EXTENDED_MESSAGE) {
+		if (len < 2)
+			return 0;
+		if (len < msgbuf[1] + 2)
+			return 0;
+	} else if (*msgbuf >= 0x20 && *msgbuf <= 0x2f)	// two byte messages
+		if (len < 2)
+			return 0;
+	return 1;
 }
 
-
-
 /* read and eval received messages */
 static void
-dc390_MsgIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
-{
-    struct dc390_dcb*   pDCB = pACB->pActiveDCB;
-
-    /* Read the msg */
-
-    pSRB->MsgInBuf[pACB->MsgLen++] = DC390_read8 (ScsiFifo);
-    //pSRB->SRBState = 0;
-
-    /* Msg complete ? */
-    if (dc390_MsgIn_complete (pSRB->MsgInBuf, pACB->MsgLen))
-      {
-	DEBUG0 (printk (KERN_INFO "DC390: MsgIn:"); dc390_printMsg (pSRB->MsgInBuf, pACB->MsgLen));
-	/* Now eval the msg */
-	switch (pSRB->MsgInBuf[0]) 
-	  {
-	  case DISCONNECT: 
-	    pSRB->SRBState = SRB_DISCONNECT; break;
-	    
-	  case SIMPLE_QUEUE_TAG:
-	  case HEAD_OF_QUEUE_TAG:
-	  case ORDERED_QUEUE_TAG:
-	    pSRB = dc390_MsgIn_QTag (pACB, pDCB, pSRB->MsgInBuf[1]);
-	    break;
-	    
-	  case MESSAGE_REJECT: 
-	    DC390_write8 (ScsiCmd, RESET_ATN_CMD);
-	    pDCB->NegoPeriod = 50; /* 200ns <=> 5 MHz */
-	    if( pSRB->SRBState & DO_SYNC_NEGO)
-	      dc390_MsgIn_set_async (pACB, pSRB);
-	    break;
-	    
-	  case EXTENDED_MESSAGE:
-	    /* reject every extended msg but SDTR */
-	    if (pSRB->MsgInBuf[1] != 3 || pSRB->MsgInBuf[2] != EXTENDED_SDTR)
-	      dc390_MsgIn_reject (pACB, pSRB);
-	    else
-	      {
-		if (pSRB->MsgInBuf[3] == 0 || pSRB->MsgInBuf[4] == 0)
-		  dc390_MsgIn_set_async (pACB, pSRB);
-		else
-		  dc390_MsgIn_set_sync (pACB, pSRB);
-	      }
-	    
-	    // nothing has to be done
-	  case COMMAND_COMPLETE: break;
-	    
-	    // SAVE POINTER may be ignored as we have the struct dc390_srb* associated with the
-	    // scsi command. Thanks, Gerard, for pointing it out.
-	  case SAVE_POINTERS: 
-	    pSRB->Saved_Ptr = pSRB->TotalXferredLen;
-	    break;
-	    // The device might want to restart transfer with a RESTORE
-	  case RESTORE_POINTERS:
-	    DEBUG0(printk ("DC390: RESTORE POINTER message received ... try to handle\n"));
-	    dc390_restore_ptr (pACB, pSRB);
-	    break;
-
-	    // reject unknown messages
-	  default: dc390_MsgIn_reject (pACB, pSRB);
-	  }
-	
-	/* Clear counter and MsgIn state */
-	pSRB->SRBState &= ~SRB_MSGIN;
-	pACB->MsgLen = 0;
-      }
+dc390_MsgIn_0(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
+{
+	struct dc390_dcb *pDCB = pACB->pActiveDCB;
+
+	/* Read the msg */
+
+	pSRB->MsgInBuf[pACB->MsgLen++] = DC390_read8(ScsiFifo);
+	//pSRB->SRBState = 0;
+
+	/* Msg complete ? */
+	if (dc390_MsgIn_complete(pSRB->MsgInBuf, pACB->MsgLen)) {
+		DEBUG0(printk(KERN_INFO "DC390: MsgIn:");
+		       dc390_printMsg(pSRB->MsgInBuf, pACB->MsgLen));
+		/* Now eval the msg */
+		switch (pSRB->MsgInBuf[0]) {
+		case DISCONNECT:
+			pSRB->SRBState = SRB_DISCONNECT;
+			break;
+
+		case SIMPLE_QUEUE_TAG:
+		case HEAD_OF_QUEUE_TAG:
+		case ORDERED_QUEUE_TAG:
+			pSRB = dc390_MsgIn_QTag(pACB, pDCB, pSRB->MsgInBuf[1]);
+			break;
+
+		case MESSAGE_REJECT:
+			DC390_write8(ScsiCmd, RESET_ATN_CMD);
+			pDCB->NegoPeriod = 50;	/* 200ns <=> 5 MHz */
+			if (pSRB->SRBState & DO_SYNC_NEGO)
+				dc390_MsgIn_set_async(pACB, pSRB);
+			break;
+
+		case EXTENDED_MESSAGE:
+			/* reject every extended msg but SDTR */
+			if (pSRB->MsgInBuf[1] != 3
+			    || pSRB->MsgInBuf[2] != EXTENDED_SDTR)
+				dc390_MsgIn_reject(pACB, pSRB);
+			else {
+				if (pSRB->MsgInBuf[3] == 0
+				    || pSRB->MsgInBuf[4] == 0)
+					dc390_MsgIn_set_async(pACB, pSRB);
+				else
+					dc390_MsgIn_set_sync(pACB, pSRB);
+			}
 
-    *psstatus = SCSI_NOP0;
-    DC390_write8 (ScsiCmd, MSG_ACCEPTED_CMD);
-    //DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
-}
+			// nothing has to be done
+		case COMMAND_COMPLETE:
+			break;
+
+			// SAVE POINTER may be ignored as we have the struct dc390_srb* associated with the
+			// scsi command. Thanks, Gerard, for pointing it out.
+		case SAVE_POINTERS:
+			pSRB->Saved_Ptr = pSRB->TotalXferredLen;
+			break;
+			// The device might want to restart transfer with a RESTORE
+		case RESTORE_POINTERS:
+			DEBUG0(printk
+			       ("DC390: RESTORE POINTER message received ... try to handle\n"));
+			dc390_restore_ptr(pACB, pSRB);
+			break;
+
+			// reject unknown messages
+		default:
+			dc390_MsgIn_reject(pACB, pSRB);
+		}
 
+		/* Clear counter and MsgIn state */
+		pSRB->SRBState &= ~SRB_MSGIN;
+		pACB->MsgLen = 0;
+	}
+
+	*psstatus = SCSI_NOP0;
+	DC390_write8(ScsiCmd, MSG_ACCEPTED_CMD);
+	//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
+}
 
 static void
-dc390_DataIO_Comm( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 ioDir)
+dc390_DataIO_Comm(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 ioDir)
 {
-    struct scatterlist *psgl;
-    unsigned long  lval;
-    struct dc390_dcb*   pDCB = pACB->pActiveDCB;
+	struct scatterlist *psgl;
+	unsigned long lval;
+	struct dc390_dcb *pDCB = pACB->pActiveDCB;
 
-    if (pSRB == pACB->pTmpSRB)
-    {
-	if (pDCB)
-		printk(KERN_ERR "DC390: pSRB == pTmpSRB! (TagQ Error?) (%02i-%i)\n", pDCB->TargetID, pDCB->TargetLUN);
-	else
-		printk(KERN_ERR "DC390: pSRB == pTmpSRB! (TagQ Error?) (DCB 0!)\n");
-
-	/* Try to recover - some broken disks react badly to tagged INQUIRY */
-	if (pDCB && pACB->scan_devices && pDCB->GoingSRBCnt == 1) {
-		pSRB = pDCB->pGoingSRB;
-		pDCB->pActiveSRB = pSRB;
-	} else {
-		pSRB->pSRBDCB = pDCB;
-		dc390_EnableMsgOut_Abort(pACB, pSRB);
+	if (pSRB == pACB->pTmpSRB) {
 		if (pDCB)
-			pDCB->DCBFlag |= ABORT_DEV;
-		return;
-	}
-    }
-
-    if( pSRB->SGIndex < pSRB->SGcount )
-    {
-	DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir);
-	if( !pSRB->SGToBeXferLen )
-	{
-	    psgl = pSRB->pSegmentList;
-	    pSRB->SGBusAddr = sg_dma_address(psgl);
-	    pSRB->SGToBeXferLen = sg_dma_len(psgl);
-	    DEBUG1(printk (KERN_DEBUG " DC390: Next SG segment."));
+			printk(KERN_ERR
+			       "DC390: pSRB == pTmpSRB! (TagQ Error?) (%02i-%i)\n",
+			       pDCB->TargetID, pDCB->TargetLUN);
+		else
+			printk(KERN_ERR
+			       "DC390: pSRB == pTmpSRB! (TagQ Error?) (DCB 0!)\n");
+
+		/* Try to recover - some broken disks react badly to tagged INQUIRY */
+		if (pDCB && pACB->scan_devices && pDCB->GoingSRBCnt == 1) {
+			pSRB = pDCB->pGoingSRB;
+			pDCB->pActiveSRB = pSRB;
+		} else {
+			pSRB->pSRBDCB = pDCB;
+			dc390_EnableMsgOut_Abort(pACB, pSRB);
+			if (pDCB)
+				pDCB->DCBFlag |= ABORT_DEV;
+			return;
+		}
 	}
-	lval = pSRB->SGToBeXferLen;
-	DEBUG1(printk (KERN_DEBUG " DC390: Start transfer: %li bytes (address %08lx)\n", lval, pSRB->SGBusAddr));
-	DC390_write8 (CtcReg_Low, (u8) lval);
-	lval >>= 8;
-	DC390_write8 (CtcReg_Mid, (u8) lval);
-	lval >>= 8;
-	DC390_write8 (CtcReg_High, (u8) lval);
 
-	DC390_write32 (DMA_XferCnt, pSRB->SGToBeXferLen);
-	DC390_write32 (DMA_XferAddr, pSRB->SGBusAddr);
+	if (pSRB->SGIndex < pSRB->SGcount) {
+		DC390_write8(DMA_Cmd, DMA_IDLE_CMD | ioDir);
+		if (!pSRB->SGToBeXferLen) {
+			psgl = pSRB->pSegmentList;
+			pSRB->SGBusAddr = sg_dma_address(psgl);
+			pSRB->SGToBeXferLen = sg_dma_len(psgl);
+			DEBUG1(printk(KERN_DEBUG " DC390: Next SG segment."));
+		}
+		lval = pSRB->SGToBeXferLen;
+		DEBUG1(printk
+		       (KERN_DEBUG
+			" DC390: Start transfer: %li bytes (address %08lx)\n",
+			lval, pSRB->SGBusAddr));
+		DC390_write8(CtcReg_Low, (u8) lval);
+		lval >>= 8;
+		DC390_write8(CtcReg_Mid, (u8) lval);
+		lval >>= 8;
+		DC390_write8(CtcReg_High, (u8) lval);
+
+		DC390_write32(DMA_XferCnt, pSRB->SGToBeXferLen);
+		DC390_write32(DMA_XferAddr, pSRB->SGBusAddr);
+
+		//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir);
+		pSRB->SRBState = SRB_DATA_XFER;
 
-	//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir);
-	pSRB->SRBState = SRB_DATA_XFER;
+		DC390_write8(ScsiCmd, DMA_COMMAND + INFO_XFER_CMD);
 
-	DC390_write8 (ScsiCmd, DMA_COMMAND+INFO_XFER_CMD);
+		DC390_write8(DMA_Cmd, DMA_START_CMD | ioDir);
+		//DEBUG1(DC390_write32 (DMA_ScsiBusCtrl, WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT));
+		//DEBUG1(printk (KERN_DEBUG "DC390: DMA_Status: %02x\n", DC390_read8 (DMA_Status)));
+		//DEBUG1(DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT));
+	} else {		/* xfer pad */
 
-	DC390_write8 (DMA_Cmd, DMA_START_CMD | ioDir);
-	//DEBUG1(DC390_write32 (DMA_ScsiBusCtrl, WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT));
-	//DEBUG1(printk (KERN_DEBUG "DC390: DMA_Status: %02x\n", DC390_read8 (DMA_Status)));
-	//DEBUG1(DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT));
-    }
-    else    /* xfer pad */
-    {
-	if( pSRB->SGcount )
-	{
-	    pSRB->AdaptStatus = H_OVER_UNDER_RUN;
-	    pSRB->SRBStatus |= OVER_RUN;
-	    DEBUG0(printk (KERN_WARNING " DC390: Overrun -"));
-	}
-	DEBUG0(printk (KERN_WARNING " Clear transfer pad \n"));
-	DC390_write8 (CtcReg_Low, 0);
-	DC390_write8 (CtcReg_Mid, 0);
-	DC390_write8 (CtcReg_High, 0);
+		if (pSRB->SGcount) {
+			pSRB->AdaptStatus = H_OVER_UNDER_RUN;
+			pSRB->SRBStatus |= OVER_RUN;
+			DEBUG0(printk(KERN_WARNING " DC390: Overrun -"));
+		}
+		DEBUG0(printk(KERN_WARNING " Clear transfer pad \n"));
+		DC390_write8(CtcReg_Low, 0);
+		DC390_write8(CtcReg_Mid, 0);
+		DC390_write8(CtcReg_High, 0);
 
-	pSRB->SRBState |= SRB_XFERPAD;
-	DC390_write8 (ScsiCmd, DMA_COMMAND+XFER_PAD_BYTE);
+		pSRB->SRBState |= SRB_XFERPAD;
+		DC390_write8(ScsiCmd, DMA_COMMAND + XFER_PAD_BYTE);
 /*
 	DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir);
 	DC390_write8 (DMA_Cmd, DMA_START_CMD | ioDir);
 */
-    }
+	}
 }
 
-
 static void
-dc390_DataOutPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
+dc390_DataOutPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+		   u8 * psstatus)
 {
-    dc390_DataIO_Comm (pACB, pSRB, WRITE_DIRECTION);
+	dc390_DataIO_Comm(pACB, pSRB, WRITE_DIRECTION);
 }
 
 static void
-dc390_DataInPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
+dc390_DataInPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
 {
-    dc390_DataIO_Comm (pACB, pSRB, READ_DIRECTION);
+	dc390_DataIO_Comm(pACB, pSRB, READ_DIRECTION);
 }
 
 static void
-dc390_CommandPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
-{
-    struct dc390_dcb*   pDCB;
-    u8  i, cnt;
-    u8     *ptr;
-
-    DC390_write8 (ScsiCmd, RESET_ATN_CMD);
-    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-    if( !(pSRB->SRBFlag & AUTO_REQSENSE) )
-    {
-	cnt = (u8) pSRB->pcmd->cmd_len;
-	ptr = (u8 *) pSRB->pcmd->cmnd;
-	for(i=0; i < cnt; i++)
-	    DC390_write8 (ScsiFifo, *(ptr++));
-    }
-    else
-    {
-	DC390_write8 (ScsiFifo, REQUEST_SENSE);
-	pDCB = pACB->pActiveDCB;
-	DC390_write8 (ScsiFifo, pDCB->TargetLUN << 5);
-	DC390_write8 (ScsiFifo, 0);
-	DC390_write8 (ScsiFifo, 0);
-	DC390_write8 (ScsiFifo, sizeof(pSRB->pcmd->sense_buffer));
-	DC390_write8 (ScsiFifo, 0);
-	DEBUG0(printk(KERN_DEBUG "DC390: AutoReqSense (CmndPhase)!\n"));
-    }
-    pSRB->SRBState = SRB_COMMAND;
-    DC390_write8 (ScsiCmd, INFO_XFER_CMD);
+dc390_CommandPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB,
+		   u8 * psstatus)
+{
+	struct dc390_dcb *pDCB;
+	u8 i, cnt;
+	u8 *ptr;
+
+	DC390_write8(ScsiCmd, RESET_ATN_CMD);
+	DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
+	if (!(pSRB->SRBFlag & AUTO_REQSENSE)) {
+		cnt = (u8) pSRB->pcmd->cmd_len;
+		ptr = (u8 *) pSRB->pcmd->cmnd;
+		for (i = 0; i < cnt; i++)
+			DC390_write8(ScsiFifo, *(ptr++));
+	} else {
+		DC390_write8(ScsiFifo, REQUEST_SENSE);
+		pDCB = pACB->pActiveDCB;
+		DC390_write8(ScsiFifo, pDCB->TargetLUN << 5);
+		DC390_write8(ScsiFifo, 0);
+		DC390_write8(ScsiFifo, 0);
+		DC390_write8(ScsiFifo, sizeof(pSRB->pcmd->sense_buffer));
+		DC390_write8(ScsiFifo, 0);
+		DEBUG0(printk(KERN_DEBUG "DC390: AutoReqSense (CmndPhase)!\n"));
+	}
+	pSRB->SRBState = SRB_COMMAND;
+	DC390_write8(ScsiCmd, INFO_XFER_CMD);
 }
 
 static void
-dc390_StatusPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
+dc390_StatusPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
 {
-    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-    pSRB->SRBState = SRB_STATUS;
-    DC390_write8 (ScsiCmd, INITIATOR_CMD_CMPLTE);
-    //DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
+	DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
+	pSRB->SRBState = SRB_STATUS;
+	DC390_write8(ScsiCmd, INITIATOR_CMD_CMPLTE);
+	//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
 }
 
 static void
-dc390_MsgOutPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
-{
-    u8   bval, i, cnt;
-    u8     *ptr;
-    struct dc390_dcb*    pDCB;
-
-    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-    pDCB = pACB->pActiveDCB;
-    if( !(pSRB->SRBState & SRB_MSGOUT) )
-    {
-	cnt = pSRB->MsgCnt;
-	if( cnt )
-	{
-	    ptr = (u8 *) pSRB->MsgOutBuf;
-	    for(i=0; i < cnt; i++)
-		DC390_write8 (ScsiFifo, *(ptr++));
-	    pSRB->MsgCnt = 0;
-	    if( (pDCB->DCBFlag & ABORT_DEV_) &&
-		(pSRB->MsgOutBuf[0] == ABORT) )
-		pSRB->SRBState = SRB_ABORT_SENT;
-	}
-	else
-	{
-	    bval = ABORT;	/* ??? MSG_NOP */
-	    if( (pSRB->pcmd->cmnd[0] == INQUIRY ) ||
-		(pSRB->pcmd->cmnd[0] == REQUEST_SENSE) ||
-		(pSRB->SRBFlag & AUTO_REQSENSE) )
-	    {
-		if( pDCB->SyncMode & SYNC_ENABLE )
-		    goto  mop1;
-	    }
-	    DC390_write8 (ScsiFifo, bval);
+dc390_MsgOutPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
+{
+	u8 bval, i, cnt;
+	u8 *ptr;
+	struct dc390_dcb *pDCB;
+
+	DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
+	pDCB = pACB->pActiveDCB;
+	if (!(pSRB->SRBState & SRB_MSGOUT)) {
+		cnt = pSRB->MsgCnt;
+		if (cnt) {
+			ptr = (u8 *) pSRB->MsgOutBuf;
+			for (i = 0; i < cnt; i++)
+				DC390_write8(ScsiFifo, *(ptr++));
+			pSRB->MsgCnt = 0;
+			if ((pDCB->DCBFlag & ABORT_DEV_) &&
+			    (pSRB->MsgOutBuf[0] == ABORT))
+				pSRB->SRBState = SRB_ABORT_SENT;
+		} else {
+			bval = ABORT;	/* ??? MSG_NOP */
+			if ((pSRB->pcmd->cmnd[0] == INQUIRY) ||
+			    (pSRB->pcmd->cmnd[0] == REQUEST_SENSE) ||
+			    (pSRB->SRBFlag & AUTO_REQSENSE)) {
+				if (pDCB->SyncMode & SYNC_ENABLE)
+					goto mop1;
+			}
+			DC390_write8(ScsiFifo, bval);
+		}
+		DC390_write8(ScsiCmd, INFO_XFER_CMD);
+	} else {
+	      mop1:
+		printk(KERN_ERR
+		       "DC390: OLD Sync Nego code triggered! (%i %i)\n",
+		       pDCB->TargetID, pDCB->TargetLUN);
+		DC390_write8(ScsiFifo, EXTENDED_MESSAGE);
+		DC390_write8(ScsiFifo, 3);	/*    ;length of extended msg */
+		DC390_write8(ScsiFifo, EXTENDED_SDTR);	/*    ; sync nego */
+		DC390_write8(ScsiFifo, pDCB->NegoPeriod);
+		if (pDCB->SyncOffset & 0x0f)
+			DC390_write8(ScsiFifo, pDCB->SyncOffset);
+		else
+			DC390_write8(ScsiFifo, SYNC_NEGO_OFFSET);
+		pSRB->SRBState |= DO_SYNC_NEGO;
+		DC390_write8(ScsiCmd, INFO_XFER_CMD);
 	}
-	DC390_write8 (ScsiCmd, INFO_XFER_CMD);
-    }
-    else
-    {
-mop1:
-        printk (KERN_ERR "DC390: OLD Sync Nego code triggered! (%i %i)\n", pDCB->TargetID, pDCB->TargetLUN);
-	DC390_write8 (ScsiFifo, EXTENDED_MESSAGE);
-	DC390_write8 (ScsiFifo, 3);	/*    ;length of extended msg */
-	DC390_write8 (ScsiFifo, EXTENDED_SDTR);	/*    ; sync nego */
-	DC390_write8 (ScsiFifo, pDCB->NegoPeriod);
-	if (pDCB->SyncOffset & 0x0f)
-		    DC390_write8 (ScsiFifo, pDCB->SyncOffset);
-	else
-		    DC390_write8 (ScsiFifo, SYNC_NEGO_OFFSET);		    
-	pSRB->SRBState |= DO_SYNC_NEGO;
-	DC390_write8 (ScsiCmd, INFO_XFER_CMD);
-    }
 }
 
 static void
-dc390_MsgInPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
+dc390_MsgInPhase(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
 {
-    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-    if( !(pSRB->SRBState & SRB_MSGIN) )
-    {
-	pSRB->SRBState &= ~SRB_DISCONNECT;
-	pSRB->SRBState |= SRB_MSGIN;
-    }
-    DC390_write8 (ScsiCmd, INFO_XFER_CMD);
-    //DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
+	DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
+	if (!(pSRB->SRBState & SRB_MSGIN)) {
+		pSRB->SRBState &= ~SRB_DISCONNECT;
+		pSRB->SRBState |= SRB_MSGIN;
+	}
+	DC390_write8(ScsiCmd, INFO_XFER_CMD);
+	//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
 }
 
 static void
-dc390_Nop_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
+dc390_Nop_0(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
 {
 }
 
 static void
-dc390_Nop_1( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
+dc390_Nop_1(struct dc390_acb *pACB, struct dc390_srb *pSRB, u8 * psstatus)
 {
 }
 
-
-static void
-dc390_SetXferRate( struct dc390_acb* pACB, struct dc390_dcb* pDCB )
-{
-    u8  bval, i, cnt;
-    struct dc390_dcb*   ptr;
-
-    if( !(pDCB->TargetLUN) )
-    {
-	if( !pACB->scan_devices )
-	{
-	    ptr = pACB->pLinkDCB;
-	    cnt = pACB->DCBCnt;
-	    bval = pDCB->TargetID;
-	    for(i=0; i<cnt; i++)
-	    {
-		if( ptr->TargetID == bval )
-		{
-		    ptr->SyncPeriod = pDCB->SyncPeriod;
-		    ptr->SyncOffset = pDCB->SyncOffset;
-		    ptr->CtrlR3 = pDCB->CtrlR3;
-		    ptr->CtrlR4 = pDCB->CtrlR4;
-		    ptr->SyncMode = pDCB->SyncMode;
+static void dc390_SetXferRate(struct dc390_acb *pACB, struct dc390_dcb *pDCB)
+{
+	u8 bval, i, cnt;
+	struct dc390_dcb *ptr;
+
+	if (!(pDCB->TargetLUN)) {
+		if (!pACB->scan_devices) {
+			ptr = pACB->pLinkDCB;
+			cnt = pACB->DCBCnt;
+			bval = pDCB->TargetID;
+			for (i = 0; i < cnt; i++) {
+				if (ptr->TargetID == bval) {
+					ptr->SyncPeriod = pDCB->SyncPeriod;
+					ptr->SyncOffset = pDCB->SyncOffset;
+					ptr->CtrlR3 = pDCB->CtrlR3;
+					ptr->CtrlR4 = pDCB->CtrlR4;
+					ptr->SyncMode = pDCB->SyncMode;
+				}
+				ptr = ptr->pNextDCB;
+			}
 		}
-		ptr = ptr->pNextDCB;
-	    }
 	}
-    }
-    return;
+	return;
 }
 
+static void dc390_Disconnect(struct dc390_acb *pACB)
+{
+	struct dc390_dcb *pDCB;
+	struct dc390_srb *pSRB, *psrb;
+	u8 i, cnt;
 
-static void
-dc390_Disconnect( struct dc390_acb* pACB )
-{
-    struct dc390_dcb *pDCB;
-    struct dc390_srb *pSRB, *psrb;
-    u8  i, cnt;
-
-    DEBUG0(printk(KERN_INFO "DISC,"));
-
-    if (!pACB->Connected) printk(KERN_ERR "DC390: Disconnect not-connected bus?\n");
-    pACB->Connected = 0;
-    pDCB = pACB->pActiveDCB;
-    if (!pDCB)
-     {
-	DEBUG0(printk(KERN_ERR "ACB:%p->ActiveDCB:%p IOPort:%04x IRQ:%02x !\n",\
-	       pACB, pDCB, pACB->IOPortBase, pACB->IRQLevel));
-	mdelay(400);
-	DC390_read8 (INT_Status);	/* Reset Pending INT */
-	DC390_write8 (ScsiCmd, EN_SEL_RESEL);
-	return;
-     }
-    DC390_write8 (ScsiCmd, EN_SEL_RESEL);
-    pSRB = pDCB->pActiveSRB;
-    pACB->pActiveDCB = NULL;
-    pSRB->ScsiPhase = SCSI_NOP0;
-    if( pSRB->SRBState & SRB_UNEXPECT_RESEL )
-	pSRB->SRBState = 0;
-    else if( pSRB->SRBState & SRB_ABORT_SENT )
-    {
-	pDCB->TagMask = 0;
-	pDCB->DCBFlag = 0;
-	cnt = pDCB->GoingSRBCnt;
-	pDCB->GoingSRBCnt = 0;
-	pSRB = pDCB->pGoingSRB;
-	for( i=0; i < cnt; i++)
-	{
-	    psrb = pSRB->pNextSRB;
-	    dc390_Free_insert (pACB, pSRB);
-	    pSRB = psrb;
-	}
-	pDCB->pGoingSRB = NULL;
-    }
-    else
-    {
-	if( (pSRB->SRBState & (SRB_START_+SRB_MSGOUT)) ||
-	   !(pSRB->SRBState & (SRB_DISCONNECT+SRB_COMPLETED)) )
-	{	/* Selection time out */
-		pSRB->TargetStatus = SCSI_STAT_SEL_TIMEOUT;
-		goto  disc1;
+	DEBUG0(printk(KERN_INFO "DISC,"));
+
+	if (!pACB->Connected)
+		printk(KERN_ERR "DC390: Disconnect not-connected bus?\n");
+	pACB->Connected = 0;
+	pDCB = pACB->pActiveDCB;
+	if (!pDCB) {
+		DEBUG0(printk
+		       (KERN_ERR
+			"ACB:%p->ActiveDCB:%p IOPort:%04x IRQ:%02x !\n", pACB,
+			pDCB, pACB->IOPortBase, pACB->IRQLevel));
+		mdelay(400);
+		DC390_read8(INT_Status);	/* Reset Pending INT */
+		DC390_write8(ScsiCmd, EN_SEL_RESEL);
+		return;
 	}
-	else if (!(pSRB->SRBState & SRB_DISCONNECT) && (pSRB->SRBState & SRB_COMPLETED))
-	{
-disc1:
-	    dc390_freetag (pDCB, pSRB);
-	    pDCB->pActiveSRB = NULL;
-	    pSRB->SRBState = SRB_FREE;
-	    dc390_SRBdone( pACB, pDCB, pSRB);
+	DC390_write8(ScsiCmd, EN_SEL_RESEL);
+	pSRB = pDCB->pActiveSRB;
+	pACB->pActiveDCB = NULL;
+	pSRB->ScsiPhase = SCSI_NOP0;
+	if (pSRB->SRBState & SRB_UNEXPECT_RESEL)
+		pSRB->SRBState = 0;
+	else if (pSRB->SRBState & SRB_ABORT_SENT) {
+		pDCB->TagMask = 0;
+		pDCB->DCBFlag = 0;
+		cnt = pDCB->GoingSRBCnt;
+		pDCB->GoingSRBCnt = 0;
+		pSRB = pDCB->pGoingSRB;
+		for (i = 0; i < cnt; i++) {
+			psrb = pSRB->pNextSRB;
+			dc390_Free_insert(pACB, pSRB);
+			pSRB = psrb;
+		}
+		pDCB->pGoingSRB = NULL;
+	} else {
+		if ((pSRB->SRBState & (SRB_START_ + SRB_MSGOUT)) || !(pSRB->SRBState & (SRB_DISCONNECT + SRB_COMPLETED))) {	/* Selection time out */
+			pSRB->TargetStatus = SCSI_STAT_SEL_TIMEOUT;
+			goto disc1;
+		} else if (!(pSRB->SRBState & SRB_DISCONNECT)
+			   && (pSRB->SRBState & SRB_COMPLETED)) {
+		      disc1:
+			dc390_freetag(pDCB, pSRB);
+			pDCB->pActiveSRB = NULL;
+			pSRB->SRBState = SRB_FREE;
+			dc390_SRBdone(pACB, pDCB, pSRB);
+		}
 	}
-    }
-    pACB->MsgLen = 0;
+	pACB->MsgLen = 0;
 }
 
+static void dc390_Reselect(struct dc390_acb *pACB)
+{
+	struct dc390_dcb *pDCB;
+	struct dc390_srb *pSRB;
+	u8 id, lun;
 
-static void
-dc390_Reselect( struct dc390_acb* pACB )
-{
-    struct dc390_dcb*   pDCB;
-    struct dc390_srb*   pSRB;
-    u8  id, lun;
-
-    DEBUG0(printk(KERN_INFO "RSEL,"));
-    pACB->Connected = 1;
-    pDCB = pACB->pActiveDCB;
-    if( pDCB )
-    {	/* Arbitration lost but Reselection won */
-	DEBUG0(printk ("DC390: (ActiveDCB != 0: Arb. lost but resel. won)!\n"));
-	pSRB = pDCB->pActiveSRB;
-	if( !( pACB->scan_devices ) )
-	{
-	    struct scsi_cmnd *pcmd = pSRB->pcmd;
-	    pcmd->resid = pcmd->request_bufflen;
-	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
-	    dc390_Going_remove(pDCB, pSRB);
-	    dc390_Free_insert(pACB, pSRB);
-	    pcmd->scsi_done (pcmd);
-	    DEBUG0(printk(KERN_DEBUG"DC390: Return SRB %p to free\n", pSRB));
-	}
-    }
-    /* Get ID */
-    lun = DC390_read8 (ScsiFifo);
-    DEBUG0(printk ("Dev %02x,", lun));
-    if (!(lun & (1 << pACB->pScsiHost->this_id)))
-      printk (KERN_ERR "DC390: Reselection must select host adapter: %02x!\n", lun);
-    else
-      lun ^= 1 << pACB->pScsiHost->this_id; /* Mask AdapterID */
-    id = 0; while (lun >>= 1) id++;
-    /* Get LUN */
-    lun = DC390_read8 (ScsiFifo);
-    if (!(lun & IDENTIFY_BASE)) printk (KERN_ERR "DC390: Resel: Expect identify message!\n");
-    lun &= 7;
-    DEBUG0(printk ("(%02i-%i),", id, lun));
-    pDCB = dc390_findDCB (pACB, id, lun);
-    if (!pDCB)
-    {
-	printk (KERN_ERR "DC390: Reselect from non existing device (%02i-%i)\n",
-		    id, lun);
-	return;
-    }
-    pACB->pActiveDCB = pDCB;
-    /* TagQ: We expect a message soon, so never mind the exact SRB */
-    if( pDCB->SyncMode & EN_TAG_QUEUEING )
-    {
-	pSRB = pACB->pTmpSRB;
-	pDCB->pActiveSRB = pSRB;
-    }
-    else
-    {
-	pSRB = pDCB->pActiveSRB;
-	if( !pSRB || !(pSRB->SRBState & SRB_DISCONNECT) )
-	{
-	    pSRB= pACB->pTmpSRB;
-	    pSRB->SRBState = SRB_UNEXPECT_RESEL;
-	    printk (KERN_ERR "DC390: Reselect without outstanding cmnd (%02i-%i)\n",
-		    id, lun);
-	    pDCB->pActiveSRB = pSRB;
-	    dc390_EnableMsgOut_Abort ( pACB, pSRB );
+	DEBUG0(printk(KERN_INFO "RSEL,"));
+	pACB->Connected = 1;
+	pDCB = pACB->pActiveDCB;
+	if (pDCB) {		/* Arbitration lost but Reselection won */
+		DEBUG0(printk
+		       ("DC390: (ActiveDCB != 0: Arb. lost but resel. won)!\n"));
+		pSRB = pDCB->pActiveSRB;
+		if (!(pACB->scan_devices)) {
+			struct scsi_cmnd *pcmd = pSRB->pcmd;
+			pcmd->resid = pcmd->request_bufflen;
+			SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
+			dc390_Going_remove(pDCB, pSRB);
+			dc390_Free_insert(pACB, pSRB);
+			pcmd->scsi_done(pcmd);
+			DEBUG0(printk
+			       (KERN_DEBUG "DC390: Return SRB %p to free\n",
+				pSRB));
+		}
 	}
+	/* Get ID */
+	lun = DC390_read8(ScsiFifo);
+	DEBUG0(printk("Dev %02x,", lun));
+	if (!(lun & (1 << pACB->pScsiHost->this_id)))
+		printk(KERN_ERR
+		       "DC390: Reselection must select host adapter: %02x!\n",
+		       lun);
 	else
-	{
-	    if( pDCB->DCBFlag & ABORT_DEV_ )
-	    {
-		pSRB->SRBState = SRB_ABORT_SENT;
-		printk (KERN_INFO "DC390: Reselect: Abort (%02i-%i)\n",
-			id, lun);
-		dc390_EnableMsgOut_Abort( pACB, pSRB );
-	    }
-	    else
-		pSRB->SRBState = SRB_DATA_XFER;
+		lun ^= 1 << pACB->pScsiHost->this_id;	/* Mask AdapterID */
+	id = 0;
+	while (lun >>= 1)
+		id++;
+	/* Get LUN */
+	lun = DC390_read8(ScsiFifo);
+	if (!(lun & IDENTIFY_BASE))
+		printk(KERN_ERR "DC390: Resel: Expect identify message!\n");
+	lun &= 7;
+	DEBUG0(printk("(%02i-%i),", id, lun));
+	pDCB = dc390_findDCB(pACB, id, lun);
+	if (!pDCB) {
+		printk(KERN_ERR
+		       "DC390: Reselect from non existing device (%02i-%i)\n",
+		       id, lun);
+		return;
+	}
+	pACB->pActiveDCB = pDCB;
+	/* TagQ: We expect a message soon, so never mind the exact SRB */
+	if (pDCB->SyncMode & EN_TAG_QUEUEING) {
+		pSRB = pACB->pTmpSRB;
+		pDCB->pActiveSRB = pSRB;
+	} else {
+		pSRB = pDCB->pActiveSRB;
+		if (!pSRB || !(pSRB->SRBState & SRB_DISCONNECT)) {
+			pSRB = pACB->pTmpSRB;
+			pSRB->SRBState = SRB_UNEXPECT_RESEL;
+			printk(KERN_ERR
+			       "DC390: Reselect without outstanding cmnd (%02i-%i)\n",
+			       id, lun);
+			pDCB->pActiveSRB = pSRB;
+			dc390_EnableMsgOut_Abort(pACB, pSRB);
+		} else {
+			if (pDCB->DCBFlag & ABORT_DEV_) {
+				pSRB->SRBState = SRB_ABORT_SENT;
+				printk(KERN_INFO
+				       "DC390: Reselect: Abort (%02i-%i)\n", id,
+				       lun);
+				dc390_EnableMsgOut_Abort(pACB, pSRB);
+			} else
+				pSRB->SRBState = SRB_DATA_XFER;
+		}
 	}
-    }
 
-    DEBUG1(printk (KERN_DEBUG "Resel SRB(%p): TagNum (%02x)\n", pSRB, pSRB->TagNumber));
-    pSRB->ScsiPhase = SCSI_NOP0;
-    DC390_write8 (Scsi_Dest_ID, pDCB->TargetID);
-    DC390_write8 (Sync_Period, pDCB->SyncPeriod);
-    DC390_write8 (Sync_Offset, pDCB->SyncOffset);
-    DC390_write8 (CtrlReg1, pDCB->CtrlR1);
-    DC390_write8 (CtrlReg3, pDCB->CtrlR3);
-    DC390_write8 (CtrlReg4, pDCB->CtrlR4);	/* ; Glitch eater */
-    DC390_write8 (ScsiCmd, MSG_ACCEPTED_CMD);	/* ;to release the /ACK signal */
+	DEBUG1(printk
+	       (KERN_DEBUG "Resel SRB(%p): TagNum (%02x)\n", pSRB,
+		pSRB->TagNumber));
+	pSRB->ScsiPhase = SCSI_NOP0;
+	DC390_write8(Scsi_Dest_ID, pDCB->TargetID);
+	DC390_write8(Sync_Period, pDCB->SyncPeriod);
+	DC390_write8(Sync_Offset, pDCB->SyncOffset);
+	DC390_write8(CtrlReg1, pDCB->CtrlR1);
+	DC390_write8(CtrlReg3, pDCB->CtrlR3);
+	DC390_write8(CtrlReg4, pDCB->CtrlR4);	/* ; Glitch eater */
+	DC390_write8(ScsiCmd, MSG_ACCEPTED_CMD);	/* ;to release the /ACK signal */
 }
 
 static int __inline__
-dc390_RequestSense(struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
+dc390_RequestSense(struct dc390_acb *pACB, struct dc390_dcb *pDCB,
+		   struct dc390_srb *pSRB)
 {
 	struct scsi_cmnd *pcmd;
 
 	pcmd = pSRB->pcmd;
 
-	REMOVABLEDEBUG(printk(KERN_INFO "DC390: RequestSense(Cmd %02x, Id %02x, LUN %02x)\n",\
-			      pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));
+	REMOVABLEDEBUG(printk
+		       (KERN_INFO
+			"DC390: RequestSense(Cmd %02x, Id %02x, LUN %02x)\n",
+			pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));
 
 	pSRB->SRBFlag |= AUTO_REQSENSE;
 	pSRB->SavedSGCount = pcmd->use_sg;
 	pSRB->SavedTotXLen = pSRB->TotalXferredLen;
 	pSRB->AdaptStatus = 0;
-	pSRB->TargetStatus = 0; /* CHECK_CONDITION<<1; */
+	pSRB->TargetStatus = 0;	/* CHECK_CONDITION<<1; */
 
 	/* We are called from SRBdone, original PCI mapping has been removed
 	 * already, new one is set up from StartSCSI */
@@ -1701,203 +1751,198 @@ dc390_RequestSense(struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_
 	return dc390_StartSCSI(pACB, pDCB, pSRB);
 }
 
-
 static void
-dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB )
+dc390_SRBdone(struct dc390_acb *pACB, struct dc390_dcb *pDCB,
+	      struct dc390_srb *pSRB)
 {
-    u8 status;
-    struct scsi_cmnd *pcmd;
+	u8 status;
+	struct scsi_cmnd *pcmd;
 
-    pcmd = pSRB->pcmd;
-    /* KG: Moved pci_unmap here */
-    dc390_pci_unmap(pSRB);
+	pcmd = pSRB->pcmd;
+	/* KG: Moved pci_unmap here */
+	dc390_pci_unmap(pSRB);
 
-    status = pSRB->TargetStatus;
+	status = pSRB->TargetStatus;
 
-    DEBUG0(printk (" SRBdone (%02x,%08x), SRB %p, pid %li\n", status, pcmd->result,\
+	DEBUG0(printk
+	       (" SRBdone (%02x,%08x), SRB %p, pid %li\n", status, pcmd->result,
 		pSRB, pcmd->pid));
-    if(pSRB->SRBFlag & AUTO_REQSENSE)
-    {	/* Last command was a Request Sense */
-	pSRB->SRBFlag &= ~AUTO_REQSENSE;
-	pSRB->AdaptStatus = 0;
-	pSRB->TargetStatus = CHECK_CONDITION << 1;
-
-	//pcmd->result = MK_RES(DRIVER_SENSE,DID_OK,0,status);
-	if (status == (CHECK_CONDITION << 1))
-	    pcmd->result = MK_RES_LNX(0, DID_BAD_TARGET, 0, /*CHECK_CONDITION*/0);
-	else /* Retry */
-	{
-	    if( pSRB->pcmd->cmnd[0] == TEST_UNIT_READY /* || pSRB->pcmd->cmnd[0] == START_STOP */)
-	    {
-		/* Don't retry on TEST_UNIT_READY */
-		pcmd->result = MK_RES_LNX(DRIVER_SENSE,DID_OK,0,CHECK_CONDITION);
-		REMOVABLEDEBUG(printk(KERN_INFO "Cmd=%02x, Result=%08x, XferL=%08x\n",pSRB->pcmd->cmnd[0],\
-		       (u32) pcmd->result, (u32) pSRB->TotalXferredLen));
-	    } else {
-		SET_RES_DRV(pcmd->result, DRIVER_SENSE);
-		pcmd->use_sg = pSRB->SavedSGCount;
-		//pSRB->ScsiCmdLen	 = (u8) (pSRB->Segment1[0] >> 8);
-		DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
-		pSRB->TotalXferredLen = 0;
-		SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
-	    }
-	}
-	goto cmd_done;
-    }
-    if( status )
-    {
-	if( status_byte(status) == CHECK_CONDITION )
-	{
-	    if (dc390_RequestSense(pACB, pDCB, pSRB)) {
-		SET_RES_DID(pcmd->result, DID_ERROR);
+	if (pSRB->SRBFlag & AUTO_REQSENSE) {	/* Last command was a Request Sense */
+		pSRB->SRBFlag &= ~AUTO_REQSENSE;
+		pSRB->AdaptStatus = 0;
+		pSRB->TargetStatus = CHECK_CONDITION << 1;
+
+		//pcmd->result = MK_RES(DRIVER_SENSE,DID_OK,0,status);
+		if (status == (CHECK_CONDITION << 1))
+			pcmd->result =
+			    MK_RES_LNX(0, DID_BAD_TARGET, 0,
+				       /*CHECK_CONDITION */ 0);
+		else {		/* Retry */
+
+			if (pSRB->pcmd->cmnd[0] ==
+			    TEST_UNIT_READY
+			    /* || pSRB->pcmd->cmnd[0] == START_STOP */ ) {
+				/* Don't retry on TEST_UNIT_READY */
+				pcmd->result =
+				    MK_RES_LNX(DRIVER_SENSE, DID_OK, 0,
+					       CHECK_CONDITION);
+				REMOVABLEDEBUG(printk
+					       (KERN_INFO
+						"Cmd=%02x, Result=%08x, XferL=%08x\n",
+						pSRB->pcmd->cmnd[0],
+						(u32) pcmd->result,
+						(u32) pSRB->TotalXferredLen));
+			} else {
+				SET_RES_DRV(pcmd->result, DRIVER_SENSE);
+				pcmd->use_sg = pSRB->SavedSGCount;
+				//pSRB->ScsiCmdLen       = (u8) (pSRB->Segment1[0] >> 8);
+				DEBUG0(printk
+				       ("DC390: RETRY pid %li (%02x), target %02i-%02i\n",
+					pcmd->pid, pcmd->cmnd[0],
+					pcmd->device->id, pcmd->device->lun));
+				pSRB->TotalXferredLen = 0;
+				SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
+			}
+		}
 		goto cmd_done;
-	    }
-	    return;
-	}
-	else if( status_byte(status) == QUEUE_FULL )
-	{
-	    scsi_track_queue_full(pcmd->device, pDCB->GoingSRBCnt - 1);
-	    pcmd->use_sg = pSRB->SavedSGCount;
-	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
-	    pSRB->TotalXferredLen = 0;
-	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
-	}
-	else if(status == SCSI_STAT_SEL_TIMEOUT)
-	{
-	    pSRB->AdaptStatus = H_SEL_TIMEOUT;
-	    pSRB->TargetStatus = 0;
-	    pcmd->result = MK_RES(0,DID_NO_CONNECT,0,0);
-	    /* Devices are removed below ... */
 	}
-	else if (status_byte(status) == BUSY && 
-		 (pcmd->cmnd[0] == TEST_UNIT_READY || pcmd->cmnd[0] == INQUIRY) &&
-		 pACB->scan_devices)
-	{
-	    pSRB->AdaptStatus = 0;
-	    pSRB->TargetStatus = status;
-	    pcmd->result = MK_RES(0,0,pSRB->EndMessage,/*status*/0);
-	}
-	else
-	{   /* Another error */
-	    pSRB->TotalXferredLen = 0;
-	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
-	    goto cmd_done;
-	}
-    }
-    else
-    {	/*  Target status == 0 */
-	status = pSRB->AdaptStatus;
-	if(status & H_OVER_UNDER_RUN)
-	{
-	    pSRB->TargetStatus = 0;
-	    SET_RES_DID(pcmd->result,DID_OK);
-	    SET_RES_MSG(pcmd->result,pSRB->EndMessage);
-	}
-	else if( pSRB->SRBStatus & PARITY_ERROR)
-	{
-	    //pcmd->result = MK_RES(0,DID_PARITY,pSRB->EndMessage,0);
-	    SET_RES_DID(pcmd->result,DID_PARITY);
-	    SET_RES_MSG(pcmd->result,pSRB->EndMessage);
-	}
-	else		       /* No error */
-	{
-	    pSRB->AdaptStatus = 0;
-	    pSRB->TargetStatus = 0;
-	    SET_RES_DID(pcmd->result,DID_OK);
+	if (status) {
+		if (status_byte(status) == CHECK_CONDITION) {
+			if (dc390_RequestSense(pACB, pDCB, pSRB)) {
+				SET_RES_DID(pcmd->result, DID_ERROR);
+				goto cmd_done;
+			}
+			return;
+		} else if (status_byte(status) == QUEUE_FULL) {
+			scsi_track_queue_full(pcmd->device,
+					      pDCB->GoingSRBCnt - 1);
+			pcmd->use_sg = pSRB->SavedSGCount;
+			DEBUG0(printk
+			       ("DC390: RETRY pid %li (%02x), target %02i-%02i\n",
+				pcmd->pid, pcmd->cmnd[0], pcmd->device->id,
+				pcmd->device->lun));
+			pSRB->TotalXferredLen = 0;
+			SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
+		} else if (status == SCSI_STAT_SEL_TIMEOUT) {
+			pSRB->AdaptStatus = H_SEL_TIMEOUT;
+			pSRB->TargetStatus = 0;
+			pcmd->result = MK_RES(0, DID_NO_CONNECT, 0, 0);
+			/* Devices are removed below ... */
+		} else if (status_byte(status) == BUSY &&
+			   (pcmd->cmnd[0] == TEST_UNIT_READY
+			    || pcmd->cmnd[0] == INQUIRY)
+			   && pACB->scan_devices) {
+			pSRB->AdaptStatus = 0;
+			pSRB->TargetStatus = status;
+			pcmd->result =
+			    MK_RES(0, 0, pSRB->EndMessage, /*status */ 0);
+		} else {	/* Another error */
+			pSRB->TotalXferredLen = 0;
+			SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
+			goto cmd_done;
+		}
+	} else {		/*  Target status == 0 */
+		status = pSRB->AdaptStatus;
+		if (status & H_OVER_UNDER_RUN) {
+			pSRB->TargetStatus = 0;
+			SET_RES_DID(pcmd->result, DID_OK);
+			SET_RES_MSG(pcmd->result, pSRB->EndMessage);
+		} else if (pSRB->SRBStatus & PARITY_ERROR) {
+			//pcmd->result = MK_RES(0,DID_PARITY,pSRB->EndMessage,0);
+			SET_RES_DID(pcmd->result, DID_PARITY);
+			SET_RES_MSG(pcmd->result, pSRB->EndMessage);
+		} else {	/* No error */
+
+			pSRB->AdaptStatus = 0;
+			pSRB->TargetStatus = 0;
+			SET_RES_DID(pcmd->result, DID_OK);
+		}
 	}
-    }
 
-cmd_done:
-    pcmd->resid = pcmd->request_bufflen - pSRB->TotalXferredLen;
+      cmd_done:
+	pcmd->resid = pcmd->request_bufflen - pSRB->TotalXferredLen;
 
-    dc390_Going_remove (pDCB, pSRB);
-    /* Add to free list */
-    dc390_Free_insert (pACB, pSRB);
+	dc390_Going_remove(pDCB, pSRB);
+	/* Add to free list */
+	dc390_Free_insert(pACB, pSRB);
 
-    DEBUG0(printk (KERN_DEBUG "DC390: SRBdone: done pid %li\n", pcmd->pid));
-    pcmd->scsi_done (pcmd);
+	DEBUG0(printk(KERN_DEBUG "DC390: SRBdone: done pid %li\n", pcmd->pid));
+	pcmd->scsi_done(pcmd);
 
-    return;
+	return;
 }
 
-
 /* Remove all SRBs from Going list and inform midlevel */
-static void
-dc390_DoingSRB_Done(struct dc390_acb* pACB, struct scsi_cmnd *cmd)
-{
-    struct dc390_dcb *pDCB, *pdcb;
-    struct dc390_srb *psrb, *psrb2;
-    int i;
-    struct scsi_cmnd *pcmd;
-
-    pDCB = pACB->pLinkDCB;
-    pdcb = pDCB;
-    if (! pdcb) return;
-    do
-    {
-	psrb = pdcb->pGoingSRB;
-	for (i = 0; i < pdcb->GoingSRBCnt; i++)
-	{
-	    psrb2 = psrb->pNextSRB;
-	    pcmd = psrb->pcmd;
-	    dc390_Free_insert (pACB, psrb);
-	    psrb  = psrb2;
-	}
-	pdcb->GoingSRBCnt = 0;
-	pdcb->pGoingSRB = NULL;
-	pdcb->TagMask = 0;
-	pdcb = pdcb->pNextDCB;
-    } while( pdcb != pDCB );
-}
+static void dc390_DoingSRB_Done(struct dc390_acb *pACB, struct scsi_cmnd *cmd)
+{
+	struct dc390_dcb *pDCB, *pdcb;
+	struct dc390_srb *psrb, *psrb2;
+	int i;
+	struct scsi_cmnd *pcmd;
 
+	pDCB = pACB->pLinkDCB;
+	pdcb = pDCB;
+	if (!pdcb)
+		return;
+	do {
+		psrb = pdcb->pGoingSRB;
+		for (i = 0; i < pdcb->GoingSRBCnt; i++) {
+			psrb2 = psrb->pNextSRB;
+			pcmd = psrb->pcmd;
+			dc390_Free_insert(pACB, psrb);
+			psrb = psrb2;
+		}
+		pdcb->GoingSRBCnt = 0;
+		pdcb->pGoingSRB = NULL;
+		pdcb->TagMask = 0;
+		pdcb = pdcb->pNextDCB;
+	} while (pdcb != pDCB);
+}
 
-static void
-dc390_ResetSCSIBus( struct dc390_acb* pACB )
+static void dc390_ResetSCSIBus(struct dc390_acb *pACB)
 {
-    //DC390_write8 (ScsiCmd, RST_DEVICE_CMD);
-    //udelay (250);
-    //DC390_write8 (ScsiCmd, NOP_CMD);
+	//DC390_write8 (ScsiCmd, RST_DEVICE_CMD);
+	//udelay (250);
+	//DC390_write8 (ScsiCmd, NOP_CMD);
 
-    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-    DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
-    DC390_write8 (ScsiCmd, RST_SCSI_BUS_CMD);
-    pACB->Connected = 0;
+	DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
+	DC390_write8(DMA_Cmd, DMA_IDLE_CMD);
+	DC390_write8(ScsiCmd, RST_SCSI_BUS_CMD);
+	pACB->Connected = 0;
 
-    return;
+	return;
 }
 
-static void
-dc390_ScsiRstDetect( struct dc390_acb* pACB )
-{
-    printk ("DC390: Rst_Detect: laststat = %08x\n", dc390_laststatus);
-    //DEBUG0(printk(KERN_INFO "RST_DETECT,"));
-
-    DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
-    /* Unlock before ? */
-    /* delay half a second */
-    udelay (1000);
-    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-    pACB->pScsiHost->last_reset = jiffies + 5*HZ/2
-		    + HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
-    pACB->Connected = 0;
-
-    if( pACB->ACBFlag & RESET_DEV )
-	pACB->ACBFlag |= RESET_DONE;
-    else
-    {   /* Reset was issued by sb else */
-	pACB->ACBFlag |= RESET_DETECT;
-
-	dc390_ResetDevParam( pACB );
-	dc390_DoingSRB_Done( pACB, NULL);
-	//dc390_RecoverSRB( pACB );
-	pACB->pActiveDCB = NULL;
-	pACB->ACBFlag = 0;
-    }
-    return;
+static void dc390_ScsiRstDetect(struct dc390_acb *pACB)
+{
+	printk("DC390: Rst_Detect: laststat = %08x\n", dc390_laststatus);
+	//DEBUG0(printk(KERN_INFO "RST_DETECT,"));
+
+	DC390_write8(DMA_Cmd, DMA_IDLE_CMD);
+	/* Unlock before ? */
+	/* delay half a second */
+	udelay(1000);
+	DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
+	pACB->pScsiHost->last_reset = jiffies + 5 * HZ / 2
+	    + HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
+	pACB->Connected = 0;
+
+	if (pACB->ACBFlag & RESET_DEV)
+		pACB->ACBFlag |= RESET_DONE;
+	else {			/* Reset was issued by sb else */
+		pACB->ACBFlag |= RESET_DETECT;
+
+		dc390_ResetDevParam(pACB);
+		dc390_DoingSRB_Done(pACB, NULL);
+		//dc390_RecoverSRB( pACB );
+		pACB->pActiveDCB = NULL;
+		pACB->ACBFlag = 0;
+	}
+	return;
 }
 
 static int DC390_queuecommand(struct scsi_cmnd *cmd,
-		void (*done)(struct scsi_cmnd *))
+			      void (*done) (struct scsi_cmnd *))
 {
 	struct scsi_device *sdev = cmd->device;
 	struct dc390_acb *acb = (struct dc390_acb *)sdev->host->hostdata;
@@ -1908,7 +1953,7 @@ static int DC390_queuecommand(struct scsi_cmnd *cmd,
 		goto device_busy;
 	if (acb->pActiveDCB)
 		goto host_busy;
-	if (acb->ACBFlag & (RESET_DETECT|RESET_DONE|RESET_DEV))
+	if (acb->ACBFlag & (RESET_DETECT | RESET_DONE | RESET_DEV))
 		goto host_busy;
 
 	srb = acb->pFreeSRB;
@@ -1925,7 +1970,7 @@ static int DC390_queuecommand(struct scsi_cmnd *cmd,
 	srb->pSRBDCB = dcb;
 	srb->pcmd = cmd;
 	cmd->host_scribble = (char *)srb;
-    
+
 	srb->SGIndex = 0;
 	srb->AdaptStatus = 0;
 	srb->TargetStatus = 0;
@@ -1950,66 +1995,77 @@ static int DC390_queuecommand(struct scsi_cmnd *cmd,
 
 	return 0;
 
- host_busy:
+      host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
- device_busy:
+      device_busy:
 	return SCSI_MLQUEUE_DEVICE_BUSY;
 }
 
-static void dc390_dumpinfo (struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
-{
-    struct pci_dev *pdev;
-    u16 pstat;
-
-    if (!pDCB) pDCB = pACB->pActiveDCB;
-    if (!pSRB && pDCB) pSRB = pDCB->pActiveSRB;
-
-    if (pSRB) 
-    {
-	printk ("DC390: SRB: Xferred %08lx, Remain %08lx, State %08x, Phase %02x\n",
-		pSRB->TotalXferredLen, pSRB->SGToBeXferLen, pSRB->SRBState,
-		pSRB->ScsiPhase);
-	printk ("DC390: AdpaterStatus: %02x, SRB Status %02x\n", pSRB->AdaptStatus, pSRB->SRBStatus);
-    }
-    printk ("DC390: Status of last IRQ (DMA/SC/Int/IRQ): %08x\n", dc390_laststatus);
-    printk ("DC390: Register dump: SCSI block:\n");
-    printk ("DC390: XferCnt  Cmd Stat IntS IRQS FFIS Ctl1 Ctl2 Ctl3 Ctl4\n");
-    printk ("DC390:  %06x   %02x   %02x   %02x",
-	    DC390_read8(CtcReg_Low) + (DC390_read8(CtcReg_Mid) << 8) + (DC390_read8(CtcReg_High) << 16),
-	    DC390_read8(ScsiCmd), DC390_read8(Scsi_Status), DC390_read8(Intern_State));
-    printk ("   %02x   %02x   %02x   %02x   %02x   %02x\n",
-	    DC390_read8(INT_Status), DC390_read8(Current_Fifo), DC390_read8(CtrlReg1),
-	    DC390_read8(CtrlReg2), DC390_read8(CtrlReg3), DC390_read8(CtrlReg4));
-    DC390_write32 (DMA_ScsiBusCtrl, WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT);
-    if (DC390_read8(Current_Fifo) & 0x1f)
-      {
-	printk ("DC390: FIFO:");
-	while (DC390_read8(Current_Fifo) & 0x1f) printk (" %02x", DC390_read8(ScsiFifo));
-	printk ("\n");
-      }
-    printk ("DC390: Register dump: DMA engine:\n");
-    printk ("DC390: Cmd   STrCnt    SBusA    WrkBC    WrkAC Stat SBusCtrl\n");
-    printk ("DC390:  %02x %08x %08x %08x %08x   %02x %08x\n",
-	    DC390_read8(DMA_Cmd), DC390_read32(DMA_XferCnt), DC390_read32(DMA_XferAddr),
-	    DC390_read32(DMA_Wk_ByteCntr), DC390_read32(DMA_Wk_AddrCntr),
-	    DC390_read8(DMA_Status), DC390_read32(DMA_ScsiBusCtrl));
-    DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
-
-    pdev = pACB->pdev;
-    pci_read_config_word(pdev, PCI_STATUS, &pstat);
-    printk ("DC390: Register dump: PCI Status: %04x\n", pstat);
-    printk ("DC390: In case of driver trouble read Documentation/scsi/tmscsim.txt\n");
-}
+static void dc390_dumpinfo(struct dc390_acb *pACB, struct dc390_dcb *pDCB,
+			   struct dc390_srb *pSRB)
+{
+	struct pci_dev *pdev;
+	u16 pstat;
 
+	if (!pDCB)
+		pDCB = pACB->pActiveDCB;
+	if (!pSRB && pDCB)
+		pSRB = pDCB->pActiveSRB;
+
+	if (pSRB) {
+		printk
+		    ("DC390: SRB: Xferred %08lx, Remain %08lx, State %08x, Phase %02x\n",
+		     pSRB->TotalXferredLen, pSRB->SGToBeXferLen, pSRB->SRBState,
+		     pSRB->ScsiPhase);
+		printk("DC390: AdpaterStatus: %02x, SRB Status %02x\n",
+		       pSRB->AdaptStatus, pSRB->SRBStatus);
+	}
+	printk("DC390: Status of last IRQ (DMA/SC/Int/IRQ): %08x\n",
+	       dc390_laststatus);
+	printk("DC390: Register dump: SCSI block:\n");
+	printk("DC390: XferCnt  Cmd Stat IntS IRQS FFIS Ctl1 Ctl2 Ctl3 Ctl4\n");
+	printk("DC390:  %06x   %02x   %02x   %02x",
+	       DC390_read8(CtcReg_Low) + (DC390_read8(CtcReg_Mid) << 8) +
+	       (DC390_read8(CtcReg_High) << 16), DC390_read8(ScsiCmd),
+	       DC390_read8(Scsi_Status), DC390_read8(Intern_State));
+	printk("   %02x   %02x   %02x   %02x   %02x   %02x\n",
+	       DC390_read8(INT_Status), DC390_read8(Current_Fifo),
+	       DC390_read8(CtrlReg1), DC390_read8(CtrlReg2),
+	       DC390_read8(CtrlReg3), DC390_read8(CtrlReg4));
+	DC390_write32(DMA_ScsiBusCtrl,
+		      WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT);
+	if (DC390_read8(Current_Fifo) & 0x1f) {
+		printk("DC390: FIFO:");
+		while (DC390_read8(Current_Fifo) & 0x1f)
+			printk(" %02x", DC390_read8(ScsiFifo));
+		printk("\n");
+	}
+	printk("DC390: Register dump: DMA engine:\n");
+	printk
+	    ("DC390: Cmd   STrCnt    SBusA    WrkBC    WrkAC Stat SBusCtrl\n");
+	printk("DC390:  %02x %08x %08x %08x %08x   %02x %08x\n",
+	       DC390_read8(DMA_Cmd), DC390_read32(DMA_XferCnt),
+	       DC390_read32(DMA_XferAddr), DC390_read32(DMA_Wk_ByteCntr),
+	       DC390_read32(DMA_Wk_AddrCntr), DC390_read8(DMA_Status),
+	       DC390_read32(DMA_ScsiBusCtrl));
+	DC390_write32(DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
+
+	pdev = pACB->pdev;
+	pci_read_config_word(pdev, PCI_STATUS, &pstat);
+	printk("DC390: Register dump: PCI Status: %04x\n", pstat);
+	printk
+	    ("DC390: In case of driver trouble read Documentation/scsi/tmscsim.txt\n");
+}
 
 static int DC390_abort(struct scsi_cmnd *cmd)
 {
-	struct dc390_acb *pACB = (struct dc390_acb*) cmd->device->host->hostdata;
-	struct dc390_dcb *pDCB = (struct dc390_dcb*) cmd->device->hostdata;
+	struct dc390_acb *pACB =
+	    (struct dc390_acb *)cmd->device->host->hostdata;
+	struct dc390_dcb *pDCB = (struct dc390_dcb *)cmd->device->hostdata;
 
 	scmd_printk(KERN_WARNING, cmd,
-		"DC390: Abort command (pid %li)\n", cmd->pid);
+		    "DC390: Abort command (pid %li)\n", cmd->pid);
 
 	/* abort() is too stupid for already sent commands at the moment. 
 	 * If it's called we are in trouble anyway, so let's dump some info 
@@ -2022,34 +2078,35 @@ static int DC390_abort(struct scsi_cmnd *cmd)
 	return FAILED;
 }
 
-
-static void dc390_ResetDevParam( struct dc390_acb* pACB )
+static void dc390_ResetDevParam(struct dc390_acb *pACB)
 {
-    struct dc390_dcb *pDCB, *pdcb;
+	struct dc390_dcb *pDCB, *pdcb;
 
-    pDCB = pACB->pLinkDCB;
-    if (! pDCB) return;
-    pdcb = pDCB;
-    do
-    {
-	pDCB->SyncMode &= ~SYNC_NEGO_DONE;
-	pDCB->SyncPeriod = 0;
-	pDCB->SyncOffset = 0;
-	pDCB->TagMask = 0;
-	pDCB->CtrlR3 = FAST_CLK;
-	pDCB->CtrlR4 &= NEGATE_REQACKDATA | CTRL4_RESERVED | NEGATE_REQACK;
-	pDCB->CtrlR4 |= pACB->glitch_cfg;
-	pDCB = pDCB->pNextDCB;
-    }
-    while( pdcb != pDCB );
-    pACB->ACBFlag &= ~(RESET_DEV | RESET_DONE | RESET_DETECT);
+	pDCB = pACB->pLinkDCB;
+	if (!pDCB)
+		return;
+	pdcb = pDCB;
+	do {
+		pDCB->SyncMode &= ~SYNC_NEGO_DONE;
+		pDCB->SyncPeriod = 0;
+		pDCB->SyncOffset = 0;
+		pDCB->TagMask = 0;
+		pDCB->CtrlR3 = FAST_CLK;
+		pDCB->CtrlR4 &=
+		    NEGATE_REQACKDATA | CTRL4_RESERVED | NEGATE_REQACK;
+		pDCB->CtrlR4 |= pACB->glitch_cfg;
+		pDCB = pDCB->pNextDCB;
+	}
+	while (pdcb != pDCB);
+	pACB->ACBFlag &= ~(RESET_DEV | RESET_DONE | RESET_DETECT);
 
 }
 
-static int DC390_bus_reset (struct scsi_cmnd *cmd)
+static int DC390_bus_reset(struct scsi_cmnd *cmd)
 {
-	struct dc390_acb*    pACB = (struct dc390_acb*) cmd->device->host->hostdata;
-	u8   bval;
+	struct dc390_acb *pACB =
+	    (struct dc390_acb *)cmd->device->host->hostdata;
+	u8 bval;
 
 	spin_lock_irq(cmd->device->host->host_lock);
 
@@ -2061,11 +2118,11 @@ static int DC390_bus_reset (struct scsi_cmnd *cmd)
 
 	dc390_ResetDevParam(pACB);
 	mdelay(1);
-	pACB->pScsiHost->last_reset = jiffies + 3*HZ/2 
-		+ HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
-    
+	pACB->pScsiHost->last_reset = jiffies + 3 * HZ / 2
+	    + HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
+
 	DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
-	DC390_read8(INT_Status);		/* Reset Pending INT */
+	DC390_read8(INT_Status);	/* Reset Pending INT */
 
 	dc390_DoingSRB_Done(pACB, cmd);
 
@@ -2088,7 +2145,8 @@ static int DC390_bus_reset (struct scsi_cmnd *cmd)
  */
 static int dc390_slave_alloc(struct scsi_device *scsi_device)
 {
-	struct dc390_acb *pACB = (struct dc390_acb*) scsi_device->host->hostdata;
+	struct dc390_acb *pACB =
+	    (struct dc390_acb *)scsi_device->host->hostdata;
 	struct dc390_dcb *pDCB, *pDCB2 = NULL;
 	uint id = scsi_device->id;
 	uint lun = scsi_device->lun;
@@ -2104,7 +2162,7 @@ static int dc390_slave_alloc(struct scsi_device *scsi_device)
 	} else {
 		pACB->pLastDCB->pNextDCB = pDCB;
 	}
-   
+
 	pDCB->pNextDCB = pACB->pLinkDCB;
 	pACB->pLastDCB = pDCB;
 
@@ -2122,16 +2180,16 @@ static int dc390_slave_alloc(struct scsi_device *scsi_device)
 		pDCB->SyncPeriod = pDCB2->SyncPeriod;
 		pDCB->SyncOffset = pDCB2->SyncOffset;
 		pDCB->NegoPeriod = pDCB2->NegoPeriod;
-      
+
 		pDCB->CtrlR3 = pDCB2->CtrlR3;
 		pDCB->CtrlR4 = pDCB2->CtrlR4;
 	} else {
 		u8 index = pACB->AdapterIndex;
-		PEEprom prom = (PEEprom) &dc390_eepromBuf[index][id << 2];
+		PEEprom prom = (PEEprom) & dc390_eepromBuf[index][id << 2];
 
 		pDCB->DevMode = prom->EE_MODE1;
 		pDCB->NegoPeriod =
-			(dc390_clock_period1[prom->EE_SPEED] * 25) >> 2;
+		    (dc390_clock_period1[prom->EE_SPEED] * 25) >> 2;
 		pDCB->CtrlR3 = FAST_CLK;
 		pDCB->CtrlR4 = pACB->glitch_cfg | CTRL4_RESERVED;
 		if (dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION)
@@ -2162,14 +2220,15 @@ static int dc390_slave_alloc(struct scsi_device *scsi_device)
  */
 static void dc390_slave_destroy(struct scsi_device *scsi_device)
 {
-	struct dc390_acb* pACB = (struct dc390_acb*) scsi_device->host->hostdata;
-	struct dc390_dcb* pDCB = (struct dc390_dcb*) scsi_device->hostdata;
-	struct dc390_dcb* pPrevDCB = pACB->pLinkDCB;
+	struct dc390_acb *pACB =
+	    (struct dc390_acb *)scsi_device->host->hostdata;
+	struct dc390_dcb *pDCB = (struct dc390_dcb *)scsi_device->hostdata;
+	struct dc390_dcb *pPrevDCB = pACB->pLinkDCB;
 
 	pACB->scan_devices = 0;
 
 	BUG_ON(pDCB->GoingSRBCnt > 1);
-	
+
 	if (pDCB == pACB->pLinkDCB) {
 		if (pACB->pLastDCB == pDCB) {
 			pDCB->pNextDCB = NULL;
@@ -2190,8 +2249,8 @@ static void dc390_slave_destroy(struct scsi_device *scsi_device)
 		pACB->pLinkDCB = pDCB->pNextDCB;
 	if (pDCB == pACB->pDCBRunRobin)
 		pACB->pDCBRunRobin = pDCB->pNextDCB;
-	kfree(pDCB); 
-	
+	kfree(pDCB);
+
 	pACB->DCBCnt--;
 }
 
@@ -2210,21 +2269,21 @@ static int dc390_slave_configure(struct scsi_device *sdev)
 }
 
 static struct scsi_host_template driver_template = {
-	.module			= THIS_MODULE,
-	.proc_name		= "tmscsim", 
-	.name			= DC390_BANNER " V" DC390_VERSION,
-	.slave_alloc		= dc390_slave_alloc,
-	.slave_configure	= dc390_slave_configure,
-	.slave_destroy		= dc390_slave_destroy,
-	.queuecommand		= DC390_queuecommand,
-	.eh_abort_handler	= DC390_abort,
-	.eh_bus_reset_handler	= DC390_bus_reset,
-	.can_queue		= 1,
-	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
-	.use_clustering		= ENABLE_CLUSTERING,
-	.max_sectors		= 0x4000, /* 8MiB = 16 * 1024 * 512 */
+	.module = THIS_MODULE,
+	.proc_name = "tmscsim",
+	.name = DC390_BANNER " V" DC390_VERSION,
+	.slave_alloc = dc390_slave_alloc,
+	.slave_configure = dc390_slave_configure,
+	.slave_destroy = dc390_slave_destroy,
+	.queuecommand = DC390_queuecommand,
+	.eh_abort_handler = DC390_abort,
+	.eh_bus_reset_handler = DC390_bus_reset,
+	.can_queue = 1,
+	.this_id = 7,
+	.sg_tablesize = SG_ALL,
+	.cmd_per_lun = 1,
+	.use_clustering = ENABLE_CLUSTERING,
+	.max_sectors = 0x4000,	/* 8MiB = 16 * 1024 * 512 */
 };
 
 /***********************************************************************
@@ -2278,7 +2337,7 @@ static u16 __devinit dc390_eeprom_get_data(struct pci_dev *pdev)
 	return wval;
 }
 
-static void __devinit dc390_read_eeprom(struct pci_dev *pdev, u16 *ptr)
+static void __devinit dc390_read_eeprom(struct pci_dev *pdev, u16 * ptr)
 {
 	u8 cmd = EEPROM_READ, i;
 
@@ -2302,34 +2361,34 @@ static void __devinit dc390_eeprom_override(u8 index)
 
 	/* Adapter Settings */
 	if (tmscsim[0] != -2)
-		ptr[EE_ADAPT_SCSI_ID] = (u8)tmscsim[0];	/* Adapter ID */
+		ptr[EE_ADAPT_SCSI_ID] = (u8) tmscsim[0];	/* Adapter ID */
 	if (tmscsim[3] != -2)
-		ptr[EE_MODE2] = (u8)tmscsim[3];
+		ptr[EE_MODE2] = (u8) tmscsim[3];
 	if (tmscsim[5] != -2)
-		ptr[EE_DELAY] = tmscsim[5];		/* Reset delay */
+		ptr[EE_DELAY] = tmscsim[5];	/* Reset delay */
 	if (tmscsim[4] != -2)
-		ptr[EE_TAG_CMD_NUM] = (u8)tmscsim[4];	/* Tagged Cmds */
+		ptr[EE_TAG_CMD_NUM] = (u8) tmscsim[4];	/* Tagged Cmds */
 
 	/* Device Settings */
 	for (id = 0; id < MAX_SCSI_ID; id++) {
 		if (tmscsim[2] != -2)
-			ptr[id << 2] = (u8)tmscsim[2];		/* EE_MODE1 */
+			ptr[id << 2] = (u8) tmscsim[2];	/* EE_MODE1 */
 		if (tmscsim[1] != -2)
-			ptr[(id << 2) + 1] = (u8)tmscsim[1];	/* EE_Speed */
+			ptr[(id << 2) + 1] = (u8) tmscsim[1];	/* EE_Speed */
 	}
 }
 
 static int __devinitdata tmscsim_def[] = {
 	7,
-	0 /* 10MHz */,
+	0 /* 10MHz */ ,
 	PARITY_CHK_ | SEND_START_ | EN_DISCONNECT_ | SYNC_NEGO_ | TAG_QUEUEING_,
 	MORE2_DRV | GREATER_1G | RST_SCSI_BUS | ACTIVE_NEGATION | LUN_CHECK,
-	3 /* 16 Tags per LUN */,
-	1 /* s delay after Reset */,
+	3 /* 16 Tags per LUN */ ,
+	1 /* s delay after Reset */ ,
 };
 
 /* Copy defaults over set values where missing */
-static void __devinit dc390_fill_with_defaults (void)
+static void __devinit dc390_fill_with_defaults(void)
 {
 	int i;
 
@@ -2351,17 +2410,18 @@ static void __devinit dc390_fill_with_defaults (void)
 
 static void __devinit dc390_check_eeprom(struct pci_dev *pdev, u8 index)
 {
-	u8 interpd[] = {1, 3, 5, 10, 16, 30, 60, 120};
+	u8 interpd[] = { 1, 3, 5, 10, 16, 30, 60, 120 };
 	u8 EEbuf[128];
-	u16 *ptr = (u16 *)EEbuf, wval = 0;
+	u16 *ptr = (u16 *) EEbuf, wval = 0;
 	int i;
 
 	dc390_read_eeprom(pdev, ptr);
 	memcpy(dc390_eepromBuf[index], EEbuf, EE_ADAPT_SCSI_ID);
-	memcpy(&dc390_eepromBuf[index][EE_ADAPT_SCSI_ID], 
+	memcpy(&dc390_eepromBuf[index][EE_ADAPT_SCSI_ID],
 	       &EEbuf[REAL_EE_ADAPT_SCSI_ID], EE_LEN - EE_ADAPT_SCSI_ID);
 
-	dc390_eepromBuf[index][EE_DELAY] = interpd[dc390_eepromBuf[index][EE_DELAY]];
+	dc390_eepromBuf[index][EE_DELAY] =
+	    interpd[dc390_eepromBuf[index][EE_DELAY]];
 
 	for (i = 0; i < 0x40; i++, ptr++)
 		wval += *ptr;
@@ -2370,7 +2430,8 @@ static void __devinit dc390_check_eeprom(struct pci_dev *pdev, u8 index)
 	if (wval != 0x1234) {
 		int speed;
 
-		printk(KERN_INFO "DC390_init: No EEPROM found! Trying default settings ...\n");
+		printk(KERN_INFO
+		       "DC390_init: No EEPROM found! Trying default settings ...\n");
 
 		/*
 		 * XXX(hch): bogus, because we might have tekram and
@@ -2379,10 +2440,12 @@ static void __devinit dc390_check_eeprom(struct pci_dev *pdev, u8 index)
 		dc390_fill_with_defaults();
 
 		speed = dc390_clock_speed[tmscsim[1]];
-		printk(KERN_INFO "DC390: Used defaults: AdaptID=%i, SpeedIdx=%i (%i.%i MHz), "
-		       "DevMode=0x%02x, AdaptMode=0x%02x, TaggedCmnds=%i (%i), DelayReset=%is\n", 
+		printk(KERN_INFO
+		       "DC390: Used defaults: AdaptID=%i, SpeedIdx=%i (%i.%i MHz), "
+		       "DevMode=0x%02x, AdaptMode=0x%02x, TaggedCmnds=%i (%i), DelayReset=%is\n",
 		       tmscsim[0], tmscsim[1], speed / 10, speed % 10,
-		       (u8)tmscsim[2], (u8)tmscsim[3], tmscsim[4], 2 << (tmscsim[4]), tmscsim[5]);
+		       (u8) tmscsim[2], (u8) tmscsim[3], tmscsim[4],
+		       2 << (tmscsim[4]), tmscsim[5]);
 	}
 }
 
@@ -2397,35 +2460,35 @@ static void __devinit dc390_init_hw(struct dc390_acb *pACB, u8 index)
 	if (pACB->Gmode2 & RST_SCSI_BUS) {
 		dc390_ResetSCSIBus(pACB);
 		udelay(1000);
-		shost->last_reset = jiffies + HZ/2 +
-			HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
+		shost->last_reset = jiffies + HZ / 2 +
+		    HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
 	}
 
 	pACB->ACBFlag = 0;
 
 	/* Reset Pending INT */
 	DC390_read8(INT_Status);
-	
+
 	/* 250ms selection timeout */
 	DC390_write8(Scsi_TimeOut, SEL_TIMEOUT);
-	
+
 	/* Conversion factor = 0 , 40MHz clock */
 	DC390_write8(Clk_Factor, CLK_FREQ_40MHZ);
-	
+
 	/* NOP cmd - clear command register */
 	DC390_write8(ScsiCmd, NOP_CMD);
-	
+
 	/* Enable Feature and SCSI-2 */
-	DC390_write8(CtrlReg2, EN_FEATURE+EN_SCSI2_CMD);
-	
+	DC390_write8(CtrlReg2, EN_FEATURE + EN_SCSI2_CMD);
+
 	/* Fast clock */
 	DC390_write8(CtrlReg3, FAST_CLK);
 
 	/* Negation */
-	DC390_write8(CtrlReg4, pACB->glitch_cfg | /* glitch eater */
-		(dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION) ?
-		 NEGATE_REQACKDATA : 0);
-	
+	DC390_write8(CtrlReg4, pACB->glitch_cfg |	/* glitch eater */
+		     (dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION) ?
+		     NEGATE_REQACKDATA : 0);
+
 	/* Clear Transfer Count High: ID */
 	DC390_write8(CtcReg_High, 0);
 	DC390_write8(DMA_Cmd, DMA_IDLE_CMD);
@@ -2437,7 +2500,7 @@ static void __devinit dc390_init_hw(struct dc390_acb *pACB, u8 index)
 }
 
 static int __devinit dc390_probe_one(struct pci_dev *pdev,
-				    const struct pci_device_id *id)
+				     const struct pci_device_id *id)
 {
 	struct dc390_acb *pACB;
 	struct Scsi_Host *shost;
@@ -2471,11 +2534,11 @@ static int __devinit dc390_probe_one(struct pci_dev *pdev,
 	shost->base = io_port;
 	shost->unique_id = io_port;
 	shost->last_reset = jiffies;
-	
+
 	pACB->pScsiHost = shost;
 	pACB->IOPortBase = (u16) io_port;
 	pACB->IRQLevel = pdev->irq;
-	
+
 	shost->max_id = 8;
 
 	if (shost->max_id - 1 ==
@@ -2491,12 +2554,12 @@ static int __devinit dc390_probe_one(struct pci_dev *pdev,
 	pACB->SRBCount = MAX_SRB_CNT;
 	pACB->AdapterIndex = dc390_adapterCnt;
 	pACB->TagMaxNum =
-		2 << dc390_eepromBuf[dc390_adapterCnt][EE_TAG_CMD_NUM];
+	    2 << dc390_eepromBuf[dc390_adapterCnt][EE_TAG_CMD_NUM];
 	pACB->Gmode2 = dc390_eepromBuf[dc390_adapterCnt][EE_MODE2];
 
-	for (i = 0; i < pACB->SRBCount-1; i++)
-		pACB->SRB_array[i].pNextSRB = &pACB->SRB_array[i+1];
-	pACB->SRB_array[pACB->SRBCount-1].pNextSRB = NULL;
+	for (i = 0; i < pACB->SRBCount - 1; i++)
+		pACB->SRB_array[i].pNextSRB = &pACB->SRB_array[i + 1];
+	pACB->SRB_array[pACB->SRBCount - 1].pNextSRB = NULL;
 	pACB->pTmpSRB = &pACB->TmpSRB;
 
 	pACB->sel_timeout = SEL_TIMEOUT;
@@ -2512,13 +2575,13 @@ static int __devinit dc390_probe_one(struct pci_dev *pdev,
 	DC390_read8_(INT_Status, io_port);
 
 	if (request_irq(pdev->irq, do_DC390_Interrupt, IRQF_SHARED,
-				"tmscsim", pACB)) {
+			"tmscsim", pACB)) {
 		printk(KERN_ERR "DC390: register IRQ error!\n");
 		goto out_release_region;
 	}
 
 	dc390_init_hw(pACB, dc390_adapterCnt);
-	
+
 	dc390_adapterCnt++;
 
 	pci_set_drvdata(pdev, shost);
@@ -2529,15 +2592,15 @@ static int __devinit dc390_probe_one(struct pci_dev *pdev,
 	scsi_scan_host(shost);
 	return 0;
 
- out_free_irq:
+      out_free_irq:
 	free_irq(pdev->irq, pACB);
- out_release_region:
+      out_release_region:
 	release_region(io_port, shost->n_io_port);
- out_host_put:
+      out_host_put:
 	scsi_host_put(shost);
- out_disable_device:
+      out_disable_device:
 	pci_disable_device(pdev);
- out:
+      out:
 	return error;
 }
 
@@ -2550,7 +2613,7 @@ static void __devexit dc390_remove_one(struct pci_dev *dev)
 {
 	struct Scsi_Host *scsi_host = pci_get_drvdata(dev);
 	unsigned long iflags;
-	struct dc390_acb* pACB = (struct dc390_acb*) scsi_host->hostdata;
+	struct dc390_acb *pACB = (struct dc390_acb *)scsi_host->hostdata;
 	u8 bval;
 
 	scsi_remove_host(scsi_host);
@@ -2558,7 +2621,7 @@ static void __devexit dc390_remove_one(struct pci_dev *dev)
 	spin_lock_irqsave(scsi_host->host_lock, iflags);
 	pACB->ACBFlag = RESET_DEV;
 	bval = DC390_read8(CtrlReg1) | DIS_INT_ON_SCSI_RST;
-	DC390_write8 (CtrlReg1, bval);	/* disable interrupt */
+	DC390_write8(CtrlReg1, bval);	/* disable interrupt */
 	if (pACB->Gmode2 & RST_SCSI_BUS)
 		dc390_ResetSCSIBus(pACB);
 	spin_unlock_irqrestore(scsi_host->host_lock, iflags);
@@ -2572,33 +2635,36 @@ static void __devexit dc390_remove_one(struct pci_dev *dev)
 }
 
 static struct pci_device_id tmscsim_pci_tbl[] = {
-	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD53C974,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ }
+	{PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD53C974,
+	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{}
 };
+
 MODULE_DEVICE_TABLE(pci, tmscsim_pci_tbl);
 
 static struct pci_driver dc390_driver = {
-	.name           = "tmscsim",
-	.id_table       = tmscsim_pci_tbl,
-	.probe          = dc390_probe_one,
-	.remove         = __devexit_p(dc390_remove_one),
+	.name = "tmscsim",
+	.id_table = tmscsim_pci_tbl,
+	.probe = dc390_probe_one,
+	.remove = __devexit_p(dc390_remove_one),
 };
 
 static int __init dc390_module_init(void)
 {
 	if (!disable_clustering)
-		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n"
+		printk(KERN_INFO
+		       "DC390: clustering now enabled by default. If you get problems load\n"
 		       "\twith \"disable_clustering=1\" and report to maintainers\n");
 
 	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
 		tmscsim[0] = 7;
 		tmscsim[1] = 4;
 		tmscsim[2] = PARITY_CHK_ | TAG_QUEUEING_;
-		tmscsim[3] = MORE2_DRV | GREATER_1G | RST_SCSI_BUS | ACTIVE_NEGATION;
+		tmscsim[3] =
+		    MORE2_DRV | GREATER_1G | RST_SCSI_BUS | ACTIVE_NEGATION;
 		tmscsim[4] = 2;
 		tmscsim[5] = 10;
-		printk (KERN_INFO "DC390: Using safe settings.\n");
+		printk(KERN_INFO "DC390: Using safe settings.\n");
 	}
 
 	return pci_module_init(&dc390_driver);
@@ -2613,20 +2679,20 @@ module_init(dc390_module_init);
 module_exit(dc390_module_exit);
 
 #ifndef MODULE
-static int __init dc390_setup (char *str)
-{	
-	int ints[8],i, im;
+static int __init dc390_setup(char *str)
+{
+	int ints[8], i, im;
 
 	get_options(str, ARRAY_SIZE(ints), ints);
 	im = ints[0];
 
 	if (im > 6) {
-		printk (KERN_NOTICE "DC390: ignore extra params!\n");
+		printk(KERN_NOTICE "DC390: ignore extra params!\n");
 		im = 6;
 	}
 
 	for (i = 0; i < im; i++)
-		tmscsim[i] = ints[i+1];
+		tmscsim[i] = ints[i + 1];
 	/* dc390_checkparams (); */
 	return 1;
 }
diff --git a/drivers/scsi/tmscsim.h b/drivers/scsi/tmscsim.h
index c3d8c80..188f70b 100644
--- a/drivers/scsi/tmscsim.h
+++ b/drivers/scsi/tmscsim.h
@@ -24,140 +24,133 @@
 ; SCSI Request Block
 ;-----------------------------------------------------------------------
 */
-struct dc390_srb
-{
-//u8		CmdBlock[12];
-
-struct dc390_srb	*pNextSRB;
-struct dc390_dcb	*pSRBDCB;
-struct scsi_cmnd	*pcmd;
-struct scatterlist	*pSegmentList;
-
-struct scatterlist Segmentx;	/* make a one entry of S/G list table */
-
-unsigned long	SGBusAddr;	/*;a segment starting address as seen by AM53C974A
-				  in CPU endianness. We're only getting 32-bit bus
-				  addresses by default */
-unsigned long	SGToBeXferLen;	/*; to be xfer length */
-unsigned long	TotalXferredLen;
-unsigned long	SavedTotXLen;
-unsigned long	Saved_Ptr;
-u32		SRBState;
-
-u8		SRBStatus;
-u8		SRBFlag;	/*; b0-AutoReqSense,b6-Read,b7-write */
-				/*; b4-settimeout,b5-Residual valid */
-u8		AdaptStatus;
-u8		TargetStatus;
-
-u8		ScsiPhase;
-s8		TagNumber;
-u8		SGIndex;
-u8		SGcount;
-
-u8		MsgCnt;
-u8		EndMessage;
-u8		SavedSGCount;			
-
-u8		MsgInBuf[6];
-u8		MsgOutBuf[6];
-
-//u8		IORBFlag;	/*;81h-Reset, 2-retry */
+struct dc390_srb {
+//u8            CmdBlock[12];
+
+	struct dc390_srb *pNextSRB;
+	struct dc390_dcb *pSRBDCB;
+	struct scsi_cmnd *pcmd;
+	struct scatterlist *pSegmentList;
+
+	struct scatterlist Segmentx;	/* make a one entry of S/G list table */
+
+	unsigned long SGBusAddr;	/*;a segment starting address as seen by AM53C974A
+					   in CPU endianness. We're only getting 32-bit bus
+					   addresses by default */
+	unsigned long SGToBeXferLen;	/*; to be xfer length */
+	unsigned long TotalXferredLen;
+	unsigned long SavedTotXLen;
+	unsigned long Saved_Ptr;
+	u32 SRBState;
+
+	u8 SRBStatus;
+	u8 SRBFlag;		/*; b0-AutoReqSense,b6-Read,b7-write */
+	/*; b4-settimeout,b5-Residual valid */
+	u8 AdaptStatus;
+	u8 TargetStatus;
+
+	u8 ScsiPhase;
+	s8 TagNumber;
+	u8 SGIndex;
+	u8 SGcount;
+
+	u8 MsgCnt;
+	u8 EndMessage;
+	u8 SavedSGCount;
+
+	u8 MsgInBuf[6];
+	u8 MsgOutBuf[6];
+
+//u8            IORBFlag;       /*;81h-Reset, 2-retry */
 };
 
-
 /*
 ;-----------------------------------------------------------------------
 ; Device Control Block
 ;-----------------------------------------------------------------------
 */
-struct dc390_dcb
-{
-struct dc390_dcb	*pNextDCB;
-struct dc390_acb	*pDCBACB;
+struct dc390_dcb {
+	struct dc390_dcb *pNextDCB;
+	struct dc390_acb *pDCBACB;
 
 /* Queued SRBs */
-struct dc390_srb	*pGoingSRB;
-struct dc390_srb	*pGoingLast;
-struct dc390_srb	*pActiveSRB;
-u8		GoingSRBCnt;
-
-u32		TagMask;
-
-u8		TargetID;	/*; SCSI Target ID  (SCSI Only) */
-u8		TargetLUN;	/*; SCSI Log.  Unit (SCSI Only) */
-u8		DevMode;
-u8		DCBFlag;
5H-
-u8		CtrlR1;
-u8		CtrlR3;
-u8		CtrlR4;
-
-u8		SyncMode;	/*; 0:async mode */
-u8		NegoPeriod;	/*;for nego. */
-u8		SyncPeriod;	/*;for reg. */
-u8		SyncOffset;	/*;for reg. and nego.(low nibble) */
+	struct dc390_srb *pGoingSRB;
+	struct dc390_srb *pGoingLast;
+	struct dc390_srb *pActiveSRB;
+	u8 GoingSRBCnt;
+
+	u32 TagMask;
+
+	u8 TargetID;		/*; SCSI Target ID  (SCSI Only) */
+	u8 TargetLUN;		/*; SCSI Log.  Unit (SCSI Only) */
+	u8 DevMode;
+	u8 DCBFlag;
+
+	u8 CtrlR1;
+	u8 CtrlR3;
+	u8 CtrlR4;
+
+	u8 SyncMode;		/*; 0:async mode */
+	u8 NegoPeriod;		/*;for nego. */
+	u8 SyncPeriod;		/*;for reg. */
+	u8 SyncOffset;		/*;for reg. and nego.(low nibble) */
 };
 
-
 /*
 ;-----------------------------------------------------------------------
 ; Adapter Control Block
 ;-----------------------------------------------------------------------
 */
-struct dc390_acb
-{
-struct Scsi_Host *pScsiHost;
-u16		IOPortBase;
-u8		IRQLevel;
-u8		status;
-
-u8		SRBCount;
-u8		AdapterIndex;	/*; nth Adapter this driver */
-u8		DCBCnt;
-
-u8		TagMaxNum;
-u8		ACBFlag;
-u8		Gmode2;
-u8		scan_devices;
-
-struct dc390_dcb	*pLinkDCB;
-struct dc390_dcb	*pLastDCB;
-struct dc390_dcb	*pDCBRunRobin;
-
-struct dc390_dcb	*pActiveDCB;
-struct dc390_srb	*pFreeSRB;
-struct dc390_srb	*pTmpSRB;
-
-u8		msgin123[4];
-u8		Connected;
-u8		pad;
+struct dc390_acb {
+	struct Scsi_Host *pScsiHost;
+	u16 IOPortBase;
+	u8 IRQLevel;
+	u8 status;
+
+	u8 SRBCount;
+	u8 AdapterIndex;	/*; nth Adapter this driver */
+	u8 DCBCnt;
+
+	u8 TagMaxNum;
+	u8 ACBFlag;
+	u8 Gmode2;
+	u8 scan_devices;
+
+	struct dc390_dcb *pLinkDCB;
+	struct dc390_dcb *pLastDCB;
+	struct dc390_dcb *pDCBRunRobin;
+
+	struct dc390_dcb *pActiveDCB;
+	struct dc390_srb *pFreeSRB;
+	struct dc390_srb *pTmpSRB;
+
+	u8 msgin123[4];
+	u8 Connected;
+	u8 pad;
 
 #if defined(USE_SPINLOCKS) && USE_SPINLOCKS > 1 && (defined(CONFIG_SMP) || DEBUG_SPINLOCKS > 0)
-spinlock_t	lock;
+	spinlock_t lock;
 #endif
-u8		sel_timeout;
-u8		glitch_cfg;
+	u8 sel_timeout;
+	u8 glitch_cfg;
 
-u8		MsgLen;
-u8		Ignore_IRQ;	/* Not used */
+	u8 MsgLen;
+	u8 Ignore_IRQ;		/* Not used */
 
-struct pci_dev	*pdev;
+	struct pci_dev *pdev;
 
-unsigned long	Cmds;
-u32		SelLost;
-u32		SelConn;
-u32		CmdInQ;
-u32		CmdOutOfSRB;
+	unsigned long Cmds;
+	u32 SelLost;
+	u32 SelConn;
+	u32 CmdInQ;
+	u32 CmdOutOfSRB;
 
-struct dc390_srb	TmpSRB;
-struct dc390_srb	SRB_array[MAX_SRB_CNT]; 	/* 50 SRBs */
+	struct dc390_srb TmpSRB;
+	struct dc390_srb SRB_array[MAX_SRB_CNT];	/* 50 SRBs */
 };
 
-
 /*;-----------------------------------------------------------------------*/
 
-
 #define BIT31	0x80000000
 #define BIT30	0x40000000
 #define BIT29	0x20000000
@@ -206,11 +199,11 @@ struct dc390_srb	SRB_array[MAX_SRB_CNT]; 	/* 50 SRBs */
 #define SRB_FREE	0
 #define SRB_WAIT	BIT0
 #define SRB_READY	BIT1
-#define SRB_MSGOUT	BIT2	/*;arbitration+msg_out 1st byte*/
+#define SRB_MSGOUT	BIT2	/*;arbitration+msg_out 1st byte */
 #define SRB_MSGIN	BIT3
 #define SRB_MSGIN_MULTI BIT4
 #define SRB_COMMAND	BIT5
-#define SRB_START_	BIT6	/*;arbitration+msg_out+command_out*/
+#define SRB_START_	BIT6	/*;arbitration+msg_out+command_out */
 #define SRB_DISCONNECT	BIT7
 #define SRB_DATA_XFER	BIT8
 #define SRB_XFERPAD	BIT9
@@ -258,7 +251,7 @@ struct dc390_srb	SRB_array[MAX_SRB_CNT]; 	/* 50 SRBs */
 #define H_BAD_CCB_OR_SG  0x1A
 #define H_ABORT 	 0x0FF
 
-/*; SCSI Status byte codes*/ 
+/*; SCSI Status byte codes*/
 /* The values defined in include/scsi/scsi.h, to be shifted << 1 */
 
 #define SCSI_STAT_UNEXP_BUS_F	0xFD	/*;  Unexpect Bus Free */
@@ -302,14 +295,14 @@ struct dc390_srb	SRB_array[MAX_SRB_CNT]; 	/* 50 SRBs */
 #define SCSI_MSG_OUT	6
 #define SCSI_MSG_IN	7
 
-/*;----SCSI MSG BYTE*/ /* see scsi/scsi.h */ /* One is missing ! */
+					     /*;----SCSI MSG BYTE*//* see scsi/scsi.h *//* One is missing ! */
 #define ABORT_TAG	0x0d
 
 /*
  *	SISC query queue
  */
 typedef struct {
-	dma_addr_t		saved_dma_handle;
+	dma_addr_t saved_dma_handle;
 } dc390_cmd_scp_t;
 
 /*
@@ -317,12 +310,11 @@ typedef struct {
 ; EEPROM byte offset
 ;==========================================================
 */
-typedef  struct  _EEprom
-{
-u8	EE_MODE1;
-u8	EE_SPEED;
-u8	xx1;
-u8	xx2;
+typedef struct _EEprom {
+	u8 EE_MODE1;
+	u8 EE_SPEED;
+	u8 xx1;
+	u8 xx2;
 } EEprom, *PEEprom;
 
 #define REAL_EE_ADAPT_SCSI_ID 64
@@ -392,14 +384,13 @@ u8	xx2;
 
 #define DATA_XFER_CMD		INFO_XFER_CMD
 
-
 /*; SCSI Status Reg.(+10H) (r) */
 #define INTERRUPT		BIT7
 #define ILLEGAL_OP_ERR		BIT6
 #define PARITY_ERR		BIT5
 #define COUNT_2_ZERO		BIT4
 #define GROUP_CODE_VALID	BIT3
-#define SCSI_PHASE_MASK 	(BIT2+BIT1+BIT0) 
+#define SCSI_PHASE_MASK 	(BIT2+BIT1+BIT0)
 /* BIT2: MSG phase; BIT1: C/D physe; BIT0: I/O phase */
 
 /*; Interrupt Status Reg.(+14H) (r) */
@@ -430,7 +421,7 @@ u8	xx2;
 #define EXTENDED_TIMING 	BIT7
 #define DIS_INT_ON_SCSI_RST	BIT6
 #define PARITY_ERR_REPO 	BIT4
-#define SCSI_ID_ON_BUS		(BIT2+BIT1+BIT0) /* host adapter ID */
+#define SCSI_ID_ON_BUS		(BIT2+BIT1+BIT0)	/* host adapter ID */
 
 /*; Control Reg. 2(+2CH) (rw) */
 #define EN_FEATURE		BIT6
@@ -497,7 +488,7 @@ u8	xx2;
 ;==========================================================
 ;Registers are rw unless declared otherwise 
 */
-#define CtcReg_Low	0x00	/* r	curr. transfer count */
+#define CtcReg_Low	0x00	/* r    curr. transfer count */
 #define CtcReg_Mid	0x04	/* r */
 #define CtcReg_High	0x38	/* r */
 #define ScsiFifo	0x08
@@ -507,28 +498,27 @@ u8	xx2;
 #define Sync_Period	0x18	/* w */
 #define Sync_Offset	0x1C	/* w */
 #define Clk_Factor	0x24	/* w */
-#define CtrlReg1	0x20	
+#define CtrlReg1	0x20
 #define CtrlReg2	0x2C
 #define CtrlReg3	0x30
 #define CtrlReg4	0x34
 #define DMA_Cmd 	0x40
-#define DMA_XferCnt	0x44	/* rw	starting transfer count (32 bit) */
-#define DMA_XferAddr	0x48	/* rw	starting physical address (32 bit) */
-#define DMA_Wk_ByteCntr 0x4C	/* r	working byte counter */
-#define DMA_Wk_AddrCntr 0x50	/* r	working address counter */
+#define DMA_XferCnt	0x44	/* rw   starting transfer count (32 bit) */
+#define DMA_XferAddr	0x48	/* rw   starting physical address (32 bit) */
+#define DMA_Wk_ByteCntr 0x4C	/* r    working byte counter */
+#define DMA_Wk_AddrCntr 0x50	/* r    working address counter */
 #define DMA_Status	0x54	/* r */
-#define DMA_MDL_Addr	0x58	/* rw	starting MDL address */
-#define DMA_Wk_MDL_Cntr 0x5C	/* r	working MDL counter */
-#define DMA_ScsiBusCtrl 0x70	/* rw	SCSI Bus, PCI/DMA Ctrl */
+#define DMA_MDL_Addr	0x58	/* rw   starting MDL address */
+#define DMA_Wk_MDL_Cntr 0x5C	/* r    working MDL counter */
+#define DMA_ScsiBusCtrl 0x70	/* rw   SCSI Bus, PCI/DMA Ctrl */
 
-#define StcReg_Low	CtcReg_Low	/* w	start transfer count */
+#define StcReg_Low	CtcReg_Low	/* w    start transfer count */
 #define StcReg_Mid	CtcReg_Mid	/* w */
 #define StcReg_High	CtcReg_High	/* w */
 #define Scsi_Dest_ID	Scsi_Status	/* w */
 #define Scsi_TimeOut	INT_Status	/* w */
 #define Intern_State	Sync_Period	/* r */
-#define Current_Fifo	Sync_Offset	/* r	Curr. FIFO / int. state */
-
+#define Current_Fifo	Sync_Offset	/* r    Curr. FIFO / int. state */
 
 #define DC390_read8(address)			\
 	(inb (pACB->IOPortBase + (address)))
@@ -554,5 +544,4 @@ u8	xx2;
 #define DC390_write32(address,value)		\
 	outl ((value), pACB->IOPortBase + (address))
 
-
-#endif /* _TMSCSIM_H */
+#endif				/* _TMSCSIM_H */
