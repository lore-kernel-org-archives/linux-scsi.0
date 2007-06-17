From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] tmscsim: clean-up status codes
Date: Sun, 17 Jun 2007 20:32:27 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0706172026400.9578@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56883 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752474AbXFQSc0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jun 2007 14:32:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>

Remove redundant defines from the header, replace all occurances in the 
code with standard SAM_STAT_ macros. Also fix what seems to be a typo in 
testing for (status == H_OVER_UNDER_RUN)...

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 73c5ca0..feb9335 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -1564,7 +1564,8 @@ dc390_Disconnect( struct dc390_acb* pACB )
 	if( (pSRB->SRBState & (SRB_START_+SRB_MSGOUT)) ||
 	   !(pSRB->SRBState & (SRB_DISCONNECT+SRB_COMPLETED)) )
 	{	/* Selection time out */
-		pSRB->TargetStatus = SCSI_STAT_SEL_TIMEOUT;
+		pSRB->AdaptStatus = H_SEL_TIMEOUT;
+		pSRB->TargetStatus = 0;
 		goto  disc1;
 	}
 	else if (!(pSRB->SRBState & SRB_DISCONNECT) && (pSRB->SRBState & SRB_COMPLETED))
@@ -1713,17 +1714,17 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
     {	/* Last command was a Request Sense */
 	pSRB->SRBFlag &= ~AUTO_REQSENSE;
 	pSRB->AdaptStatus = 0;
-	pSRB->TargetStatus = CHECK_CONDITION << 1;
+	pSRB->TargetStatus = SAM_STAT_CHECK_CONDITION;
 
 	//pcmd->result = MK_RES(DRIVER_SENSE,DID_OK,0,status);
-	if (status == (CHECK_CONDITION << 1))
+	if (status == SAM_STAT_CHECK_CONDITION)
 	    pcmd->result = MK_RES_LNX(0, DID_BAD_TARGET, 0, /*CHECK_CONDITION*/0);
 	else /* Retry */
 	{
 	    if( pSRB->pcmd->cmnd[0] == TEST_UNIT_READY /* || pSRB->pcmd->cmnd[0] == START_STOP */)
 	    {
 		/* Don't retry on TEST_UNIT_READY */
-		pcmd->result = MK_RES_LNX(DRIVER_SENSE,DID_OK,0,CHECK_CONDITION);
+		pcmd->result = MK_RES_LNX(DRIVER_SENSE, DID_OK, 0, SAM_STAT_CHECK_CONDITION);
 		REMOVABLEDEBUG(printk(KERN_INFO "Cmd=%02x, Result=%08x, XferL=%08x\n",pSRB->pcmd->cmnd[0],\
 		       (u32) pcmd->result, (u32) pSRB->TotalXferredLen));
 	    } else {
@@ -1739,7 +1740,7 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
     }
     if( status )
     {
-	if( status_byte(status) == CHECK_CONDITION )
+	if (status == SAM_STAT_CHECK_CONDITION)
 	{
 	    if (dc390_RequestSense(pACB, pDCB, pSRB)) {
 		SET_RES_DID(pcmd->result, DID_ERROR);
@@ -1747,7 +1748,7 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
 	    }
 	    return;
 	}
-	else if( status_byte(status) == QUEUE_FULL )
+	else if (status == SAM_STAT_TASK_SET_FULL)
 	{
 	    scsi_track_queue_full(pcmd->device, pDCB->GoingSRBCnt - 1);
 	    scsi_sg_count(pcmd) = pSRB->SavedSGCount;
@@ -1755,14 +1756,7 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
 	    pSRB->TotalXferredLen = 0;
 	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
 	}
-	else if(status == SCSI_STAT_SEL_TIMEOUT)
-	{
-	    pSRB->AdaptStatus = H_SEL_TIMEOUT;
-	    pSRB->TargetStatus = 0;
-	    pcmd->result = MK_RES(0,DID_NO_CONNECT,0,0);
-	    /* Devices are removed below ... */
-	}
-	else if (status_byte(status) == BUSY && 
+	else if (status == SAM_STAT_BUSY && 
 		 (pcmd->cmnd[0] == TEST_UNIT_READY || pcmd->cmnd[0] == INQUIRY) &&
 		 pACB->scan_devices)
 	{
@@ -1780,12 +1774,17 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
     else
     {	/*  Target status == 0 */
 	status = pSRB->AdaptStatus;
-	if(status & H_OVER_UNDER_RUN)
+	if (status == H_OVER_UNDER_RUN)
 	{
 	    pSRB->TargetStatus = 0;
 	    SET_RES_DID(pcmd->result,DID_OK);
 	    SET_RES_MSG(pcmd->result,pSRB->EndMessage);
 	}
+	else if (status == H_SEL_TIMEOUT)
+	{
+	    pcmd->result = MK_RES(0, DID_NO_CONNECT, 0, 0);
+	    /* Devices are removed below ... */
+	}
 	else if( pSRB->SRBStatus & PARITY_ERROR)
 	{
 	    //pcmd->result = MK_RES(0,DID_PARITY,pSRB->EndMessage,0);
diff --git a/drivers/scsi/tmscsim.h b/drivers/scsi/tmscsim.h
index c3d8c80..c74c72a 100644
--- a/drivers/scsi/tmscsim.h
+++ b/drivers/scsi/tmscsim.h
@@ -258,13 +258,6 @@ struct dc390_srb	SRB_array[MAX_SRB_CNT]; 	/* 50 SRBs */
 #define H_BAD_CCB_OR_SG  0x1A
 #define H_ABORT 	 0x0FF
 
-/*; SCSI Status byte codes*/ 
-/* The values defined in include/scsi/scsi.h, to be shifted << 1 */
-
-#define SCSI_STAT_UNEXP_BUS_F	0xFD	/*;  Unexpect Bus Free */
-#define SCSI_STAT_BUS_RST_DETECT 0xFE	/*;  Scsi Bus Reset detected */
-#define SCSI_STAT_SEL_TIMEOUT	0xFF	/*;  Selection Time out */
-
 /* cmd->result */
 #define RES_TARGET		0x000000FF	/* Target State */
 #define RES_TARGET_LNX		STATUS_MASK	/* Only official ... */
@@ -273,7 +266,7 @@ struct dc390_srb	SRB_array[MAX_SRB_CNT]; 	/* 50 SRBs */
 #define RES_DRV			0xFF000000	/* DRIVER_ codes */
 
 #define MK_RES(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt))
-#define MK_RES_LNX(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt)<<1)
+#define MK_RES_LNX(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt))
 
 #define SET_RES_TARGET(who, tgt) do { who &= ~RES_TARGET; who |= (int)(tgt); } while (0)
 #define SET_RES_TARGET_LNX(who, tgt) do { who &= ~RES_TARGET_LNX; who |= (int)(tgt) << 1; } while (0)

---
Guennadi Liakhovetski
