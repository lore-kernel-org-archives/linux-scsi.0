From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] tmascsim: (resend updated) track_queue_full
Date: Tue, 9 Nov 2004 00:00:39 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0411090000210.9020@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:39111 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261286AbUKHXAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2004 18:00:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James

I've sent the tmscsim-tcq patch to you in 2 version, asking in the second 
one not to apply the first one. Unfortunately, you did apply it. But 
that's not that big of a problem anyway, because the next patch, which is 
still not in your bk overrides the conflicting fragment anyway. So, here's 
the updated (or, rather, down-dated?:-)) version of that patch. Or are 
there problems with this patch?

Thanks
Guennadi
---
Guennadi Liakhovetski

Use scsi_track_queue_full(), don't lie about driver's queueing
abilities.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -ur a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	Sun Nov  7 23:56:01 2004
+++ b/drivers/scsi/tmscsim.c	Sun Nov  7 23:56:46 2004
@@ -526,21 +526,23 @@
     DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);		/* Flush FIFO */
     DEBUG1(printk (KERN_INFO "DC390: Start SCSI command: %02x (Sync:%02x)\n",\
             scmd->cmnd[0], pDCB->SyncMode));
-    disc_allowed = pDCB->DevMode & EN_DISCONNECT_;
-    try_sync_nego = 0;
+
     /* Don't disconnect on AUTO_REQSENSE, cause it might be an
      * Contingent Allegiance Condition (6.6), where no tags should be used.
      * All other have to be allowed to disconnect to prevent Incorrect 
      * Initiator Connection (6.8.2/6.5.2) */
     /* Changed KG, 99/06/06 */
-    if( /*(((pSRB->pcmd->cmnd[0] == INQUIRY) || (pSRB->pcmd->cmnd[0] == REQUEST_SENSE) ||
-	 * (pSRB->pcmd->cmnd[0] == TEST_UNIT_READY)) && pACB->scan_devices)
-		||*/ (pSRB->SRBFlag & AUTO_REQSENSE) ) 
-      disc_allowed = 0;
-    if ( (pDCB->SyncMode & SYNC_ENABLE) && (pDCB->TargetLUN == 0) && sdev->sdtr &&
-	( ( ( (scmd->cmnd[0] == REQUEST_SENSE) || (pSRB->SRBFlag & AUTO_REQSENSE) )
-	  && !(pDCB->SyncMode & SYNC_NEGO_DONE) ) || (scmd->cmnd[0] == INQUIRY) ) )
+    if (! (pSRB->SRBFlag & AUTO_REQSENSE))
+	disc_allowed = pDCB->DevMode & EN_DISCONNECT_;
+    else
+	disc_allowed = 0;
+
+    if ((pDCB->SyncMode & SYNC_ENABLE) && pDCB->TargetLUN == 0 && sdev->sdtr &&
+	(((scmd->cmnd[0] == REQUEST_SENSE || (pSRB->SRBFlag & AUTO_REQSENSE)) &&
+	  !(pDCB->SyncMode & SYNC_NEGO_DONE)) || scmd->cmnd[0] == INQUIRY))
       try_sync_nego = 1;
+    else
+      try_sync_nego = 0;
 
     pSRB->MsgCnt = 0;
     cmd = SEL_W_ATN;
@@ -548,7 +550,7 @@
     /* Change 99/05/31: Don't use tags when not disconnecting (BUSY) */
     if ((pDCB->SyncMode & EN_TAG_QUEUEING) && disc_allowed && scsi_populate_tag_msg(scmd, tag)) {
 	DC390_write8(ScsiFifo, tag[0]);
-	pDCB->TagMask |= (1 << tag[1]);
+	pDCB->TagMask |= 1 << tag[1];
 	pSRB->TagNumber = tag[1];
 	DC390_write8(ScsiFifo, tag[1]);
 	DEBUG1(printk(KERN_INFO "DC390: Select w/DisCn for Cmd %li (SRB %p), block tag %02x\n", scmd->pid, pSRB, tag[1]));
@@ -556,7 +558,7 @@
     } else {
 	/* No TagQ */
 //no_tag:
-	DEBUG1(printk(KERN_INFO "DC390: Select w%s/DisCn for Cmd %li (SRB %p), No TagQ\n", (disc_allowed ? "" : "o"), scmd->pid, pSRB));
+	DEBUG1(printk(KERN_INFO "DC390: Select w%s/DisCn for Cmd %li (SRB %p), No TagQ\n", disc_allowed ? "" : "o", scmd->pid, pSRB));
     }
 
     pSRB->SRBState = SRB_START_;
@@ -1461,14 +1463,13 @@
     }
     else
     {
-	u8 bval = 0;
 	DC390_write8 (ScsiFifo, REQUEST_SENSE);
 	pDCB = pACB->pActiveDCB;
 	DC390_write8 (ScsiFifo, pDCB->TargetLUN << 5);
-	DC390_write8 (ScsiFifo, bval);
-	DC390_write8 (ScsiFifo, bval);
+	DC390_write8 (ScsiFifo, 0);
+	DC390_write8 (ScsiFifo, 0);
 	DC390_write8 (ScsiFifo, sizeof(pSRB->pcmd->sense_buffer));
-	DC390_write8 (ScsiFifo, bval);
+	DC390_write8 (ScsiFifo, 0);
 	DEBUG0(printk(KERN_DEBUG "DC390: AutoReqSense (CmndPhase)!\n"));
     }
     pSRB->SRBState = SRB_COMMAND;
@@ -1773,7 +1774,7 @@
 static void
 dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB )
 {
-    u8  bval, status;
+    u8 status;
     struct scsi_cmnd *pcmd;
 
     pcmd = pSRB->pcmd;
@@ -1824,9 +1825,7 @@
 	}
 	else if( status_byte(status) == QUEUE_FULL )
 	{
-	    bval = (u8) pDCB->GoingSRBCnt;
-	    bval--;
-	    pDCB->MaxCommand = bval;
+	    scsi_track_queue_full(pcmd->device, pDCB->GoingSRBCnt - 1);
 	    pcmd->use_sg = pSRB->SavedSGCount;
 	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
 	    pSRB->TotalXferredLen = 0;
@@ -1974,7 +1973,7 @@
 	struct dc390_dcb *dcb = sdev->hostdata;
 	struct dc390_srb *srb;
 
-	if (dcb->MaxCommand <= dcb->GoingSRBCnt)
+	if (sdev->queue_depth <= dcb->GoingSRBCnt)
 		goto device_busy;
 	if (acb->pActiveDCB)
 		goto host_busy;
@@ -2177,7 +2176,6 @@
 	pDCB->pDCBACB = pACB;
 	pDCB->TargetID = id;
 	pDCB->TargetLUN = lun;
-	pDCB->MaxCommand = 1;
 
 	/*
 	 * Some values are for all LUNs: Copy them 
@@ -2270,8 +2268,7 @@
 	acb->scan_devices = 0;
 	if (sdev->tagged_supported && (dcb->DevMode & TAG_QUEUEING_)) {
 		dcb->SyncMode |= EN_TAG_QUEUEING;
-		dcb->MaxCommand = dcb->pDCBACB->TagMaxNum;
-		scsi_activate_tcq(sdev, dcb->MaxCommand);
+		scsi_activate_tcq(sdev, acb->TagMaxNum);
 	}
 
 	return 0;
@@ -2287,10 +2284,10 @@
 	.queuecommand		= DC390_queuecommand,
 	.eh_abort_handler	= DC390_abort,
 	.eh_bus_reset_handler	= DC390_bus_reset,
-	.can_queue		= 42,
+	.can_queue		= 1,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 16,
+	.cmd_per_lun		= 1,
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 
@@ -2583,8 +2580,6 @@
 
 	io_port = pci_resource_start(pdev, 0);
 
-	shost->can_queue = MAX_CMD_QUEUE;
-	shost->cmd_per_lun = MAX_CMD_PER_LUN;
 	shost->this_id = dc390_eepromBuf[dc390_adapterCnt][EE_ADAPT_SCSI_ID];
 	shost->io_port = io_port;
 	shost->n_io_port = 0x80;
diff -ur a/drivers/scsi/tmscsim.h b/drivers/scsi/tmscsim.h
--- a/drivers/scsi/tmscsim.h	Sun Nov  7 23:55:36 2004
+++ b/drivers/scsi/tmscsim.h	Sun Nov  7 23:56:46 2004
@@ -15,10 +15,8 @@
 
 #define MAX_ADAPTER_NUM 	4
 #define MAX_SG_LIST_BUF 	16	/* Not used */
-#define MAX_CMD_PER_LUN 	32
-#define MAX_CMD_QUEUE		MAX_CMD_PER_LUN+MAX_CMD_PER_LUN/2+1	
 #define MAX_SCSI_ID		8
-#define MAX_SRB_CNT		MAX_CMD_QUEUE+1	/* Max number of started commands */
+#define MAX_SRB_CNT		50	/* Max number of started commands */
 
 #define SEL_TIMEOUT		153	/* 250 ms selection timeout (@ 40 MHz) */
 
@@ -90,8 +88,6 @@
 struct dc390_srb	*pGoingLast;
 struct dc390_srb	*pActiveSRB;
 u8		GoingSRBCnt;
-
-u8		MaxCommand;
 
 u32		TagMask;
 
