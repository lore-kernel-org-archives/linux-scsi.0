From: Christoph Hellwig <hch@lst.de>
Subject: start removing queue from tmscsim
Date: Thu, 19 Aug 2004 13:36:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040819113637.GB21326@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37029 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265668AbUHSLgk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 07:36:40 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: g.liakhovetski@gmx.de
Cc: linux-scsi@vger.kernel.org

So actually I have a patch that starts to remove internal queueing from
tmscsim.  This gets rid of internal queueing for those cases where we
can just make the midlayer do the the work by returning erros from
->queuecommand (and cleans up the tmscsim queuecommand implementation
singnificantly).

Next step would get rid of the more complicated internal queueing where
we need to make the scsi layer requeue by returning appropinquate DID_
values from ->scsidone.


--- linux/drivers/scsi/tmscsim.c~	2004-08-18 00:25:00.909269808 +0200
+++ linux/drivers/scsi/tmscsim.c	2004-08-18 00:51:27.469076056 +0200
@@ -630,22 +630,6 @@
  * Lists are managed using two pointers and eventually a counter
  */
 
-/* Return next free SRB */
-static __inline__ struct dc390_srb* dc390_Free_get ( struct dc390_acb* pACB )
-{
-    struct dc390_srb*   pSRB;
-
-    pSRB = pACB->pFreeSRB;
-    DEBUG0(printk ("DC390: Get Free SRB %p\n", pSRB));
-    if( pSRB )
-    {
-	pACB->pFreeSRB = pSRB->pNextSRB;
-	pSRB->pNextSRB = NULL;
-    }
-
-    return( pSRB );
-}
-
 /* Insert SRB oin top of free list */
 static __inline__ void dc390_Free_insert (struct dc390_acb* pACB, struct dc390_srb* pSRB)
 {
@@ -667,21 +651,6 @@
 }
 
 
-/* Queue SRB to waiting list */
-static __inline__ void dc390_Waiting_append ( struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
-{
-	DEBUG0(printk ("DC390: Append pSRB %p cmd %li to Waiting\n", pSRB, pSRB->pcmd->pid));
-    if( pDCB->pWaitingSRB )
-	pDCB->pWaitLast->pNextSRB = pSRB;
-    else
-	pDCB->pWaitingSRB = pSRB;
-
-    pDCB->pWaitLast = pSRB;
-    pSRB->pNextSRB = NULL;
-    pDCB->WaitSRBCnt++;
-    pDCB->pDCBACB->CmdInQ++;
-}
-
 static __inline__ void dc390_Going_append (struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
 {
     pDCB->GoingSRBCnt++;
@@ -801,47 +770,6 @@
 	spin_unlock_irqrestore(pACB->pScsiHost->host_lock, iflags);
 }
 
-/***********************************************************************
- * Function: static void dc390_SendSRB (struct dc390_acb* pACB, struct dc390_srb* pSRB)
- *
- * Purpose: Send SCSI Request Block (pSRB) to adapter (pACB)
- *
- ***********************************************************************/
-
-static void dc390_SendSRB( struct dc390_acb* pACB, struct dc390_srb* pSRB )
-{
-    struct dc390_dcb*   pDCB;
-
-    pDCB = pSRB->pSRBDCB;
-    if( (pDCB->MaxCommand <= pDCB->GoingSRBCnt) || (pACB->pActiveDCB) ||
-	(pACB->ACBFlag & (RESET_DETECT+RESET_DONE+RESET_DEV)) )
-    {
-	dc390_Waiting_append (pDCB, pSRB);
-	dc390_Waiting_process (pACB);
-	return;
-    }
-
-#if 0
-    if( pDCB->pWaitingSRB )
-    {
-	dc390_Waiting_append (pDCB, pSRB);
-/*	pSRB = GetWaitingSRB(pDCB); */	/* non-existent */
-	pSRB = pDCB->pWaitingSRB;
-	/* Remove from waiting list */
-	pDCB->pWaitingSRB = pSRB->pNextSRB;
-	pSRB->pNextSRB = NULL;
-	if (!pDCB->pWaitingSRB) pDCB->pWaitLast = NULL;
-    }
-#endif
-	
-    if (!dc390_StartSCSI(pACB, pDCB, pSRB))
-	dc390_Going_append (pDCB, pSRB);
-    else {
-	dc390_Waiting_insert (pDCB, pSRB);
-	dc390_waiting_timer (pACB, HZ/5);
-    }
-}
-
 static struct scatterlist* dc390_sg_build_single(struct scatterlist *sg, void *addr, unsigned int length)
 {
 	memset(sg, 0, sizeof(struct scatterlist));
@@ -917,86 +845,72 @@
 	}
 }
 
-
-/***********************************************************************
- * Function: static void dc390_BuildSRB (Scsi_Cmd *pcmd, struct dc390_dcb* pDCB, 
- * 					 struct dc390_srb* pSRB)
- *
- * Purpose: Prepare SRB for being sent to Device DCB w/ command *pcmd
- *
- ***********************************************************************/
-
-static void dc390_BuildSRB (struct scsi_cmnd *pcmd, struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
+static int DC390_queuecommand(struct scsi_cmnd *cmd,
+		void (*done)(struct scsi_cmnd *))
 {
-    pSRB->pSRBDCB = pDCB;
-    pSRB->pcmd = pcmd;
-    
-    pSRB->SGIndex = 0;
-    pSRB->AdaptStatus = 0;
-    pSRB->TargetStatus = 0;
-    pSRB->MsgCnt = 0;
-    if( pDCB->DevType != TYPE_TAPE )
-	pSRB->RetryCnt = 1;
-    else
-	pSRB->RetryCnt = 0;
-    pSRB->SRBStatus = 0;
-    pSRB->SRBFlag = 0;
-    pSRB->SRBState = 0;
-    pSRB->TotalXferredLen = 0;
-    pSRB->SGBusAddr = 0;
-    pSRB->SGToBeXferLen = 0;
-    pSRB->ScsiPhase = 0;
-    pSRB->EndMessage = 0;
-    pSRB->TagNumber = 255;
-    /* KG: deferred PCI mapping to dc390_StartSCSI */
-}
+	struct scsi_device *sdev = cmd->device;
+	struct dc390_acb *acb = (struct dc390_acb *)sdev->host->hostdata;
+	struct dc390_dcb *dcb = sdev->hostdata;
+	struct dc390_srb *srb;
+
+	if (dcb->pWaitingSRB)
+		goto device_busy;
+	if (dcb->MaxCommand <= dcb->GoingSRBCnt)
+		goto device_busy;
+	if (acb->pActiveDCB)
+		goto host_busy;
+	if (acb->ACBFlag & (RESET_DETECT|RESET_DONE|RESET_DEV))
+		goto host_busy;
+
+	srb = acb->pFreeSRB;
+	if (unlikely(srb == NULL))
+		goto host_busy;
+
+	cmd->scsi_done = done;
+	cmd->result = 0;
+	acb->Cmds++;
 
-/***********************************************************************
- * Function : static int DC390_queue_command (struct scsi_cmnd *cmd,
- *					       void (*done)(struct scsi_cmnd *))
- *
- * Purpose : enqueues a SCSI command
- *
- * Inputs : cmd - SCSI command, done - callback function called on 
- *	    completion, with a pointer to the command descriptor.
- *
- * Returns : (depending on kernel version)
- * 2.0.x: always return 0
- * 2.1.x: old model: (use_new_eh_code == 0): like 2.0.x
- *	  TO BE DONE:
- *	  new model: return 0 if successful, or must not be re-queued
- *		     return 1 if command cannot be queued (queue full)
- *		     command will be inserted in midlevel queue then ...
- *
- ***********************************************************************/
+	acb->pFreeSRB = srb->pNextSRB;
+	srb->pNextSRB = NULL;
 
-static int DC390_queue_command(struct scsi_cmnd *cmd,
-		void (* done)(struct scsi_cmnd *))
-{
-    struct dc390_dcb*   pDCB = (struct dc390_dcb*) cmd->device->hostdata;
-    struct dc390_srb*   pSRB;
-    struct dc390_acb*   pACB = (struct dc390_acb*) cmd->device->host->hostdata;
-
-    pACB->Cmds++;
-    cmd->scsi_done = done;
-    cmd->result = 0;
-
-    pSRB = dc390_Free_get(pACB);
-    if (!pSRB)
-	    goto requeue;
-
-    dc390_BuildSRB(cmd, pDCB, pSRB);
-    if (pDCB->pWaitingSRB) {
-	    dc390_Waiting_append(pDCB, pSRB);
-	    dc390_Waiting_process(pACB);
-    } else
-	    dc390_SendSRB(pACB, pSRB);
+	srb->pSRBDCB = dcb;
+	srb->pcmd = cmd;
+    
+	srb->SGIndex = 0;
+	srb->AdaptStatus = 0;
+	srb->TargetStatus = 0;
+	srb->MsgCnt = 0;
+	if (dcb->DevType == TYPE_TAPE)
+		srb->RetryCnt = 0;
+	else
+		srb->RetryCnt = 1;
+	srb->SRBStatus = 0;
+	srb->SRBFlag = 0;
+	srb->SRBState = 0;
+	srb->TotalXferredLen = 0;
+	srb->SGBusAddr = 0;
+	srb->SGToBeXferLen = 0;
+	srb->ScsiPhase = 0;
+	srb->EndMessage = 0;
+	srb->TagNumber = 255;
+
+	if (dc390_StartSCSI(acb, dcb, srb)) {
+		dc390_Waiting_insert(dcb, srb);
+		dc390_waiting_timer(acb, HZ/5);
+		goto done;
+	}
 
-    DEBUG1(printk (KERN_DEBUG " ... command (pid %li) queued successfully.\n", cmd->pid));
-    return(0);
+	dc390_Going_append(dcb, srb);
+ done:
+	return 0;
 
- requeue:
-    return 1;
+ host_busy:
+	dc390_Waiting_process(acb);
+	return SCSI_MLQUEUE_HOST_BUSY;
+
+ device_busy:
+	dc390_Waiting_process(acb);
+	return SCSI_MLQUEUE_DEVICE_BUSY;
 }
 
 /* We ignore mapping problems, as we expect everybody to respect 
@@ -1629,7 +1543,7 @@
 	.slave_alloc		= dc390_slave_alloc,
 	.slave_configure	= dc390_slave_configure,
 	.slave_destroy		= dc390_slave_destroy,
-	.queuecommand		= DC390_queue_command,
+	.queuecommand		= DC390_queuecommand,
 	.eh_abort_handler	= DC390_abort,
 	.eh_bus_reset_handler	= DC390_bus_reset,
 	.bios_param		= DC390_bios_param,
