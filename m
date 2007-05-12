From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 17/19] BusLogic: convert to use the data buffer accessors
Date: Sat, 12 May 2007 19:05:45 +0900 (JST)
Message-ID: <20070512184416E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55493 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbXELKF5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This converts BusLogic to use the data buffer accessors.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/BusLogic.c |   38 ++++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 9f2586f..01dd0a0 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -306,13 +306,9 @@ static void BusLogic_DeallocateCCB(struc
 	struct BusLogic_HostAdapter *HostAdapter = CCB->HostAdapter;
 	struct scsi_cmnd *cmd = CCB->Command;
 
-	if (cmd->use_sg) {
-		pci_unmap_sg(HostAdapter->PCI_Device,
-			     (struct scatterlist *)cmd->request_buffer,
-			     cmd->use_sg, cmd->sc_data_direction);
-	}
+	scsi_dma_unmap(&HostAdapter->PCI_Device->dev, cmd);
 	pci_unmap_single(HostAdapter->PCI_Device, CCB->SenseDataPointer,
-			CCB->SenseDataLength, PCI_DMA_FROMDEVICE);
+			 CCB->SenseDataLength, PCI_DMA_FROMDEVICE);
 
 	CCB->Command = NULL;
 	CCB->Status = BusLogic_CCB_Free;
@@ -2645,7 +2641,8 @@ #endif
 			 */
 			if (CCB->CDB[0] == INQUIRY && CCB->CDB[1] == 0 && CCB->HostAdapterStatus == BusLogic_CommandCompletedNormally) {
 				struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[CCB->TargetID];
-				struct SCSI_Inquiry *InquiryResult = (struct SCSI_Inquiry *) Command->request_buffer;
+				struct SCSI_Inquiry *InquiryResult =
+					(struct SCSI_Inquiry *) scsi_sglist(Command);
 				TargetFlags->TargetExists = true;
 				TargetFlags->TaggedQueuingSupported = InquiryResult->CmdQue;
 				TargetFlags->WideTransfersSupported = InquiryResult->WBus16;
@@ -2816,8 +2813,8 @@ static int BusLogic_QueueCommand(struct
 	int CDB_Length = Command->cmd_len;
 	int TargetID = Command->device->id;
 	int LogicalUnit = Command->device->lun;
-	void *BufferPointer = Command->request_buffer;
-	int BufferLength = Command->request_bufflen;
+	int BufferLength = scsi_bufflen(Command);
+	int Count;
 	struct BusLogic_CCB *CCB;
 	/*
 	   SCSI REQUEST_SENSE commands will be executed automatically by the Host
@@ -2847,30 +2844,35 @@ static int BusLogic_QueueCommand(struct
 			return 0;
 		}
 	}
+
 	/*
 	   Initialize the fields in the BusLogic Command Control Block (CCB).
 	 */
-	if (Command->use_sg) {
-		struct scatterlist *ScatterList = (struct scatterlist *) BufferPointer;
-		int Segment, Count;
+	Count = scsi_dma_map(&HostAdapter->PCI_Device->dev, Command);
+	BUG_ON(Count < 0);
+	if (Count) {
+		struct scatterlist *sg;
+		int i;
 
-		Count = pci_map_sg(HostAdapter->PCI_Device, ScatterList,
-				   Command->use_sg, Command->sc_data_direction);
 		CCB->Opcode = BusLogic_InitiatorCCB_ScatterGather;
 		CCB->DataLength = Count * sizeof(struct BusLogic_ScatterGatherSegment);
 		if (BusLogic_MultiMasterHostAdapterP(HostAdapter))
 			CCB->DataPointer = (unsigned int) CCB->DMA_Handle + ((unsigned long) &CCB->ScatterGatherList - (unsigned long) CCB);
 		else
 			CCB->DataPointer = Virtual_to_32Bit_Virtual(CCB->ScatterGatherList);
-		for (Segment = 0; Segment < Count; Segment++) {
-			CCB->ScatterGatherList[Segment].SegmentByteCount = sg_dma_len(ScatterList + Segment);
-			CCB->ScatterGatherList[Segment].SegmentDataPointer = sg_dma_address(ScatterList + Segment);
+
+		scsi_for_each_sg(Command, sg, Count, i) {
+			CCB->ScatterGatherList[i].SegmentByteCount =
+				sg_dma_len(sg);
+			CCB->ScatterGatherList[i].SegmentDataPointer =
+				sg_dma_address(sg);
 		}
-	} else {
+	} else if (!Count) {
 		CCB->Opcode = BusLogic_InitiatorCCB;
 		CCB->DataLength = BufferLength;
 		CCB->DataPointer = 0;
 	}
+
 	switch (CDB[0]) {
 	case READ_6:
 	case READ_10:
-- 
1.4.3.2

