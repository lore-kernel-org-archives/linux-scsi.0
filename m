From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] clean up some more tmscsim scan logic
Date: Tue, 17 Aug 2004 18:33:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040817163323.GA16799@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:23531 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266138AbUHQQdZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 12:33:25 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: g.liakhovetski@gmx.de
Cc: linux-scsi@vger.kernel.org

 - cleanup checks in ->queuecommand, we only get here either for
   inquiry or a found device now
 - DCBmap in the acb is gone, was only used for debug prints after
   the prevous changes
 - kill some more debugging keyed of by ->scan_devices


--- 1.19/drivers/scsi/scsiiom.c	2004-07-05 00:25:48 +02:00
+++ edited/drivers/scsi/scsiiom.c	2004-08-17 19:56:00 +02:00
@@ -1398,26 +1398,7 @@
 	pSRB->SRBFlag &= ~AUTO_REQSENSE;
 	pSRB->AdaptStatus = 0;
 	pSRB->TargetStatus = CHECK_CONDITION << 1;
-#ifdef DC390_REMOVABLEDEBUG
-	switch (pcmd->sense_buffer[2] & 0x0f)
-	{	    
-	 case NOT_READY: printk (KERN_INFO "DC390: ReqSense: NOT_READY (Cmnd = 0x%02x, Dev = %i-%i, Stat = %i, Scan = %i)\n",
-				 pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN,
-				 status, pACB->scan_devices); break;
-	 case UNIT_ATTENTION: printk (KERN_INFO "DC390: ReqSense: UNIT_ATTENTION (Cmnd = 0x%02x, Dev = %i-%i, Stat = %i, Scan = %i)\n",
-				      pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN,
-				      status, pACB->scan_devices); break;
-	 case ILLEGAL_REQUEST: printk (KERN_INFO "DC390: ReqSense: ILLEGAL_REQUEST (Cmnd = 0x%02x, Dev = %i-%i, Stat = %i, Scan = %i)\n",
-				       pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN,
-				       status, pACB->scan_devices); break;
-	 case MEDIUM_ERROR: printk (KERN_INFO "DC390: ReqSense: MEDIUM_ERROR (Cmnd = 0x%02x, Dev = %i-%i, Stat = %i, Scan = %i)\n",
-				    pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN,
-				    status, pACB->scan_devices); break;
-	 case HARDWARE_ERROR: printk (KERN_INFO "DC390: ReqSense: HARDWARE_ERROR (Cmnd = 0x%02x, Dev = %i-%i, Stat = %i, Scan = %i)\n",
-				      pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN,
-				      status, pACB->scan_devices); break;
-	}
-#endif
+
 	//pcmd->result = MK_RES(DRIVER_SENSE,DID_OK,0,status);
 	if (status == (CHECK_CONDITION << 1))
 	{
@@ -1571,23 +1552,6 @@
 	    pDCB->Inquiry7 = ptr->Flags;
 
 ckc_e:
-    if( pACB->scan_devices )
-    {
-	if( pcmd->cmnd[0] == TEST_UNIT_READY ||
-	    pcmd->cmnd[0] == INQUIRY)
-	{
-#ifdef DC390_DEBUG0
-	    printk (KERN_INFO "DC390: %s: result: %08x", 
-		    (pcmd->cmnd[0] == INQUIRY? "INQUIRY": "TEST_UNIT_READY"),
-		    pcmd->result);
-	    if (pcmd->result & (DRIVER_SENSE << 24)) printk (" (sense: %02x %02x %02x %02x)\n",
-				   pcmd->sense_buffer[0], pcmd->sense_buffer[1],
-				   pcmd->sense_buffer[2], pcmd->sense_buffer[3]);
-	    else printk ("\n");
-#endif
-	}
-    }
-
     if( pcmd->cmnd[0] == INQUIRY && 
 	(pcmd->result == (DID_OK << 16) || status_byte(pcmd->result) & CHECK_CONDITION) )
      {
--- 1.45/drivers/scsi/tmscsim.c	2004-07-05 00:35:28 +02:00
+++ edited/drivers/scsi/tmscsim.c	2004-08-17 20:05:52 +02:00
@@ -612,11 +609,7 @@
      {
 	pDCB = pDCB->pNextDCB;
 	if (pDCB == pACB->pLinkDCB)
-	  {
-	     DCBDEBUG(printk (KERN_WARNING "DC390: DCB not found (DCB=%p, DCBmap[%2x]=%2x)\n",
-			      pDCB, id, pACB->DCBmap[id]));
 	     return 0;
-	  }
      }
    DCBDEBUG1( printk (KERN_DEBUG "DCB %p (%02x,%02x) found.\n",	\
 		      pDCB, pDCB->TargetID, pDCB->TargetLUN));
@@ -984,28 +977,6 @@
     struct dc390_srb*   pSRB;
     struct dc390_acb*   pACB = (struct dc390_acb*) cmd->device->host->hostdata;
 
-    DEBUG0(/*  if(pACB->scan_devices) */	\
-	printk(KERN_INFO "DC390: Queue Cmd=%02x,Tgt=%d,LUN=%d (pid=%li), buffer=%p\n",\
-	       cmd->cmnd[0],cmd->device->id,cmd->device->lun,cmd->pid, cmd->buffer));
-
-    /* TODO: Change the policy: Always accept TEST_UNIT_READY or INQUIRY 
-     * commands and alloc a DCB for the device if not yet there. DCB will
-     * be removed in dc390_SRBdone if SEL_TIMEOUT */
-    if (!(pACB->scan_devices) && !(pACB->DCBmap[cmd->device->id] & (1 << cmd->device->lun))) {
-	printk(KERN_INFO "DC390: Ignore target %02x lun %02x\n",
-		cmd->device->id, cmd->device->lun); 
-	goto fail;
-    }
-
-    /* Should it be: BUG_ON(!pDCB); ? */
-
-    if (!pDCB)
-    {  /* should never happen */
-	printk (KERN_ERR "DC390: no DCB found, target %02x lun %02x\n", 
-		cmd->device->id, cmd->device->lun);
-	goto fail;
-    }
-
     pACB->Cmds++;
     cmd->scsi_done = done;
     cmd->result = 0;
@@ -1026,10 +997,6 @@
 
  requeue:
     return 1;
- fail:
-    cmd->result = DID_BAD_TARGET << 16;
-    done(cmd);
-    return 0;
 }
 
 /* We ignore mapping problems, as we expect everybody to respect 
@@ -1394,7 +1361,6 @@
 static void __devinit dc390_initACB (struct Scsi_Host *psh, unsigned long io_port, u8 Irq, u8 index)
 {
     struct dc390_acb*    pACB;
-    u8   i;
 
     psh->can_queue = MAX_CMD_QUEUE;
     psh->cmd_per_lun = MAX_CMD_PER_LUN;
@@ -1441,8 +1407,6 @@
     dc390_linkSRB( pACB );
     pACB->pTmpSRB = &pACB->TmpSRB;
     dc390_initSRB( pACB->pTmpSRB );
-    for(i=0; i<MAX_SCSI_ID; i++)
-	pACB->DCBmap[i] = 0;
     pACB->sel_timeout = SEL_TIMEOUT;
     pACB->glitch_cfg = EATER_25NS;
     pACB->Cmds = pACB->CmdInQ = pACB->CmdOutOfSRB = 0;
@@ -1603,7 +1567,6 @@
 			pDCB->CtrlR4 |= NEGATE_REQACKDATA | NEGATE_REQACK;
 	}
 
-	pACB->DCBmap[id] |= (1 << lun);
 	dc390_updateDCB(pACB, pDCB);
 
 	pACB->scan_devices = 1;
@@ -1627,8 +1590,6 @@
 
 	BUG_ON(pDCB->GoingSRBCnt > 1);
 	
-	pACB->DCBmap[pDCB->TargetID] &= ~(1 << pDCB->TargetLUN);
-   
 	if (pDCB == pACB->pLinkDCB) {
 		if (pACB->pLastDCB == pDCB) {
 			pDCB->pNextDCB = NULL;
:q	
--- 1.8/drivers/scsi/tmscsim.h	2004-06-24 23:33:43 +02:00
+++ edited/drivers/scsi/tmscsim.h	2004-08-17 19:56:00 +02:00
@@ -163,7 +163,6 @@
 struct dc390_srb	*pTmpSRB;
 
 u8		msgin123[4];
-u8		DCBmap[MAX_SCSI_ID];
 u8		Connected;
 u8		pad;
 
