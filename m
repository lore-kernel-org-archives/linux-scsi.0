From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] tmscsim: use block-layer tags
Date: Tue, 12 Oct 2004 23:14:14 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410122307180.4565@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:21985 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267783AbUJLVOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 17:14:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Slightly tested. Applies on the top of all up to date tmscsim patches (if 
I didn't miss any). Reviews, tests highly welcome. Inline patch should be 
fine now. Will re-send if still not...

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -u a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	Tue Oct 12 22:46:13 2004
+++ b/drivers/scsi/tmscsim.c	Tue Oct 12 23:00:37 2004
@@ -494,8 +494,10 @@
 static int
 dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB )
 {
-    struct scsi_device *sdev = pSRB->pcmd->device;
-    u8 cmd; u8  disc_allowed, try_sync_nego;
+    struct scsi_cmnd *scmd = pSRB->pcmd;
+    struct scsi_device *sdev = scmd->device;
+    u8 cmd, disc_allowed, try_sync_nego;
+    char tag[2];
 
     pSRB->ScsiPhase = SCSI_NOP0;
 
@@ -524,7 +526,7 @@
     DC390_write8 (CtrlReg4, pDCB->CtrlR4);
     DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);		/* Flush FIFO */
     DEBUG1(printk (KERN_INFO "DC390: Start SCSI command: %02x (Sync:%02x)\n",\
-	    pSRB->pcmd->cmnd[0], pDCB->SyncMode));
+            scmd->cmnd[0], pDCB->SyncMode));
     disc_allowed = pDCB->DevMode & EN_DISCONNECT_;
     try_sync_nego = 0;
     /* Don't disconnect on AUTO_REQSENSE, cause it might be an
@@ -537,33 +539,26 @@
 		||*/ (pSRB->SRBFlag & AUTO_REQSENSE) ) 
       disc_allowed = 0;
     if ( (pDCB->SyncMode & SYNC_ENABLE) && (pDCB->TargetLUN == 0) && sdev->sdtr &&
-	( ( ( (pSRB->pcmd->cmnd[0] == REQUEST_SENSE) || (pSRB->SRBFlag & AUTO_REQSENSE) )
-	  && !(pDCB->SyncMode & SYNC_NEGO_DONE) ) || (pSRB->pcmd->cmnd[0] == INQUIRY) ) )
+	( ( ( (scmd->cmnd[0] == REQUEST_SENSE) || (pSRB->SRBFlag & AUTO_REQSENSE) )
+	  && !(pDCB->SyncMode & SYNC_NEGO_DONE) ) || (scmd->cmnd[0] == INQUIRY) ) )
       try_sync_nego = 1;
 
-    pSRB->MsgCnt = 0; cmd = SEL_W_ATN;
+    pSRB->MsgCnt = 0;
+    cmd = SEL_W_ATN;
     DC390_write8 (ScsiFifo, IDENTIFY(disc_allowed, pDCB->TargetLUN));
     /* Change 99/05/31: Don't use tags when not disconnecting (BUSY) */
-    if ((pDCB->SyncMode & EN_TAG_QUEUEING) && disc_allowed)
-      {
-	s8 tag_no = 0;
-	while ((1 << tag_no) & pDCB->TagMask) tag_no++;
-	if (tag_no >= sizeof (pDCB->TagMask)*8 || tag_no >= pDCB->MaxCommand) { 
-		printk (KERN_WARNING "DC390: Out of tags for Dev. %02x %02x\n", pDCB->TargetID, pDCB->TargetLUN); 
-		return 1;
-		//goto no_tag;
-	}
-	DC390_write8 (ScsiFifo, SIMPLE_QUEUE_TAG);
-	pDCB->TagMask |= (1 << tag_no); pSRB->TagNumber = tag_no;
-	DC390_write8 (ScsiFifo, tag_no);
-	DEBUG1(printk (KERN_DEBUG "DC390: Select w/DisCn for Cmd %li (SRB %p), Using Tag %02x\n", pSRB->pcmd->pid, pSRB, tag_no));
+    if ((pDCB->SyncMode & EN_TAG_QUEUEING) && disc_allowed && scsi_populate_tag_msg(scmd, tag)) {
+	DC390_write8(ScsiFifo, tag[0]);
+	pDCB->TagMask |= (1 << tag[1]);
+	pSRB->TagNumber = tag[1];
+	DC390_write8(ScsiFifo, tag[1]);
+	DEBUG1(printk(KERN_INFO "DC390: Select w/DisCn for Cmd %li (SRB %p), block tag %02x\n", scmd->pid, pSRB, tag[1]));
 	cmd = SEL_W_ATN3;
-      }
-    else	/* No TagQ */
-      {
-//      no_tag:
-	DEBUG1(printk (KERN_DEBUG "DC390: Select w%s/DisCn for Cmd %li (SRB %p), No TagQ\n", (disc_allowed?"":"o"), pSRB->pcmd->pid, pSRB));
-      }
+    } else {
+	/* No TagQ */
+//no_tag:
+	DEBUG1(printk(KERN_INFO "DC390: Select w%s/DisCn for Cmd %li (SRB %p), No TagQ\n", (disc_allowed ? "" : "o"), scmd->pid, pSRB));
+    }
 
     pSRB->SRBState = SRB_START_;
 
@@ -592,15 +587,15 @@
 	    DC390_write8 (ScsiFifo, pDCB->TargetLUN << 5);
 	    DC390_write8 (ScsiFifo, 0);
 	    DC390_write8 (ScsiFifo, 0);
-	    DC390_write8 (ScsiFifo, sizeof(pSRB->pcmd->sense_buffer));
+	    DC390_write8 (ScsiFifo, sizeof(scmd->sense_buffer));
 	    DC390_write8 (ScsiFifo, 0);
 	    DEBUG1(printk (KERN_DEBUG "DC390: AutoReqSense !\n"));
 	  }
 	else	/* write cmnd to bus */ 
 	  {
 	    u8 *ptr; u8 i;
-	    ptr = (u8 *) pSRB->pcmd->cmnd;
-	    for (i=0; i<pSRB->pcmd->cmd_len; i++)
+	    ptr = (u8 *)scmd->cmnd;
+	    for (i = 0; i < scmd->cmd_len; i++)
 	      DC390_write8 (ScsiFifo, *(ptr++));
 	  }
       }
@@ -613,14 +608,15 @@
     {
 	dc390_freetag (pDCB, pSRB);
 	DEBUG0(printk ("DC390: Interrupt during Start SCSI (pid %li, target %02i-%02i)\n",
-		pSRB->pcmd->pid, pSRB->pcmd->device->id, pSRB->pcmd->device->lun));
+		scmd->pid, scmd->device->id, scmd->device->lun));
 	pSRB->SRBState = SRB_READY;
 	//DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
 	pACB->SelLost++;
 	return 1;
     }
     DC390_write8 (ScsiCmd, cmd);
-    pACB->pActiveDCB = pDCB; pDCB->pActiveSRB = pSRB;
+    pACB->pActiveDCB = pDCB;
+    pDCB->pActiveSRB = pSRB;
     pACB->Connected = 1;
     pSRB->ScsiPhase = SCSI_NOP1;
     return 0;
@@ -1067,7 +1063,8 @@
 dc390_MsgIn_reject (struct dc390_acb* pACB, struct dc390_srb* pSRB)
 {
   pSRB->MsgOutBuf[0] = MESSAGE_REJECT;
-  pSRB->MsgCnt = 1; DC390_ENABLE_MSGOUT;
+  pSRB->MsgCnt = 1;
+  DC390_ENABLE_MSGOUT;
   DEBUG0 (printk (KERN_INFO "DC390: Reject message\n"));
 }
 
@@ -1083,29 +1080,24 @@
 static struct dc390_srb*
 dc390_MsgIn_QTag (struct dc390_acb* pACB, struct dc390_dcb* pDCB, s8 tag)
 {
-  struct dc390_srb* lastSRB = pDCB->pGoingLast;
   struct dc390_srb* pSRB = pDCB->pGoingSRB;
 
   if (pSRB)
     {
-      for( ;pSRB ; )
-	{
-	  if (pSRB->TagNumber == tag) break;
-	  if (pSRB == lastSRB) goto mingx0;
-	  pSRB = pSRB->pNextSRB;
-	}
+	struct scsi_cmnd *scmd = scsi_find_tag(pSRB->pcmd->device, tag);
+	pSRB = (struct dc390_srb *)scmd->host_scribble;
 
-      if( pDCB->DCBFlag & ABORT_DEV_ )
+	if (pDCB->DCBFlag & ABORT_DEV_)
 	{
 	  pSRB->SRBState = SRB_ABORT_SENT;
 	  dc390_EnableMsgOut_Abort( pACB, pSRB );
 	}
 
-      if( !(pSRB->SRBState & SRB_DISCONNECT) )
-	goto  mingx0;
+	if (!(pSRB->SRBState & SRB_DISCONNECT))
+		goto mingx0;
 
-      pDCB->pActiveSRB = pSRB;
-      pSRB->SRBState = SRB_DATA_XFER;
+	pDCB->pActiveSRB = pSRB;
+	pSRB->SRBState = SRB_DATA_XFER;
     }
   else
     {
@@ -1906,7 +1898,7 @@
 {
     struct dc390_dcb *pDCB, *pdcb;
     struct dc390_srb *psrb, *psrb2;
-    u8  i;
+    int i;
     struct scsi_cmnd *pcmd;
 
     pDCB = pACB->pLinkDCB;
@@ -1915,7 +1907,7 @@
     do
     {
 	psrb = pdcb->pGoingSRB;
-	for( i=0; i<pdcb->GoingSRBCnt; i++)
+	for (i = 0; i < pdcb->GoingSRBCnt; i++)
 	{
 	    psrb2 = psrb->pNextSRB;
 	    pcmd = psrb->pcmd;
@@ -2003,6 +1995,7 @@
 
 	srb->pSRBDCB = dcb;
 	srb->pcmd = cmd;
+	cmd->host_scribble = (char *)srb;
     
 	srb->SGIndex = 0;
 	srb->AdaptStatus = 0;
@@ -2279,7 +2272,9 @@
 	if (sdev->tagged_supported && (dcb->DevMode & TAG_QUEUEING_)) {
 		dcb->SyncMode |= EN_TAG_QUEUEING;
 		dcb->MaxCommand = dcb->pDCBACB->TagMaxNum;
+		scsi_activate_tcq(sdev, dcb->MaxCommand);
 	}
+
 	return 0;
 }
 
Thanks
Guennadi
---
Guennadi Liakhovetski
