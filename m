From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] Farther clean-up of tmscsim driver
Date: Thu, 14 Jun 2007 19:33:37 +0300
Message-ID: <46716DE1.6070607@panasas.com>
References: <466EDFAC.9020104@panasas.com>	<20070613085118P.fujita.tomonori@lab.ntt.co.jp>	<E472128B1EB43941B4E7FB268020C89B0250B912@riverside.int.panasas.com> <20070613194513H.fujita.tomonori@lab.ntt.co.jp> <46716C45.1090107@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:57224 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750911AbXFNQdv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 12:33:51 -0400
In-Reply-To: <46716C45.1090107@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ed Lin <ed.lin@promise.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

>From 4a7ac954dcc11531a09fa07d6a6365d98c67b216 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@bh-buildlin2.(none)>
Date: Thu, 14 Jun 2007 19:04:17 +0300
Subject: [PATCH] Farther clean-up of tmscsim driver

 - this is a followup of commit 85289f2efa108d1586a86d0c426ffc9d641bbdc2
   [SCSI] tmscsim: convert to use the data buffer accessors.
   The saved sg_count was a leftover from the time the driver was doing
   dma mapping by himself. But now that scsi-ml is called for the mapping
   it is not the drivers responsibility.
---
 drivers/scsi/tmscsim.c |    3 ---
 drivers/scsi/tmscsim.h |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 73c5ca0..5758f20 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -1680,7 +1680,6 @@ dc390_RequestSense(struct dc390_acb* pACB, struct dc390_dcb*
pDCB, struct dc390_
 			      pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));

 	pSRB->SRBFlag |= AUTO_REQSENSE;
-	pSRB->SavedSGCount = scsi_sg_count(pcmd);
 	pSRB->SavedTotXLen = pSRB->TotalXferredLen;
 	pSRB->AdaptStatus = 0;
 	pSRB->TargetStatus = 0; /* CHECK_CONDITION<<1; */
@@ -1728,7 +1727,6 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb*
pDCB, struct dc390_srb*
 		       (u32) pcmd->result, (u32) pSRB->TotalXferredLen));
 	    } else {
 		SET_RES_DRV(pcmd->result, DRIVER_SENSE);
-		scsi_sg_count(pcmd) = pSRB->SavedSGCount;
 		//pSRB->ScsiCmdLen	 = (u8) (pSRB->Segment1[0] >> 8);
 		DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid,
pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
 		pSRB->TotalXferredLen = 0;
@@ -1750,7 +1748,6 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb*
pDCB, struct dc390_srb*
 	else if( status_byte(status) == QUEUE_FULL )
 	{
 	    scsi_track_queue_full(pcmd->device, pDCB->GoingSRBCnt - 1);
-	    scsi_sg_count(pcmd) = pSRB->SavedSGCount;
 	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid,
pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
 	    pSRB->TotalXferredLen = 0;
 	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
diff --git a/drivers/scsi/tmscsim.h b/drivers/scsi/tmscsim.h
index c3d8c80..fbe7a3e 100644
--- a/drivers/scsi/tmscsim.h
+++ b/drivers/scsi/tmscsim.h
@@ -57,7 +57,6 @@ u8		SGcount;

 u8		MsgCnt;
 u8		EndMessage;
-u8		SavedSGCount;			

 u8		MsgInBuf[6];
 u8		MsgOutBuf[6];
-- 
1.5.0.4.402.g8035

