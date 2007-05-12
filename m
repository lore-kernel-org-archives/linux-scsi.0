From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 16/19] BusLogic: remove the non-use-sg case
Date: Sat, 12 May 2007 19:05:45 +0900 (JST)
Message-ID: <20070512184413R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44888 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbXELKFz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This removes the non-use-sg case.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/BusLogic.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 96f4cab..9f2586f 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -306,13 +306,10 @@ static void BusLogic_DeallocateCCB(struc
 	struct BusLogic_HostAdapter *HostAdapter = CCB->HostAdapter;
 	struct scsi_cmnd *cmd = CCB->Command;
 
-	if (cmd->use_sg != 0) {
+	if (cmd->use_sg) {
 		pci_unmap_sg(HostAdapter->PCI_Device,
-				(struct scatterlist *)cmd->request_buffer,
-				cmd->use_sg, cmd->sc_data_direction);
-	} else if (cmd->request_bufflen != 0) {
-		pci_unmap_single(HostAdapter->PCI_Device, CCB->DataPointer,
-				CCB->DataLength, cmd->sc_data_direction);
+			     (struct scatterlist *)cmd->request_buffer,
+			     cmd->use_sg, cmd->sc_data_direction);
 	}
 	pci_unmap_single(HostAdapter->PCI_Device, CCB->SenseDataPointer,
 			CCB->SenseDataLength, PCI_DMA_FROMDEVICE);
@@ -2821,7 +2818,6 @@ static int BusLogic_QueueCommand(struct
 	int LogicalUnit = Command->device->lun;
 	void *BufferPointer = Command->request_buffer;
 	int BufferLength = Command->request_bufflen;
-	int SegmentCount = Command->use_sg;
 	struct BusLogic_CCB *CCB;
 	/*
 	   SCSI REQUEST_SENSE commands will be executed automatically by the Host
@@ -2854,18 +2850,12 @@ static int BusLogic_QueueCommand(struct
 	/*
 	   Initialize the fields in the BusLogic Command Control Block (CCB).
 	 */
-	if (SegmentCount == 0 && BufferLength != 0) {
-		CCB->Opcode = BusLogic_InitiatorCCB;
-		CCB->DataLength = BufferLength;
-		CCB->DataPointer = pci_map_single(HostAdapter->PCI_Device,
-				BufferPointer, BufferLength,
-				Command->sc_data_direction);
-	} else if (SegmentCount != 0) {
+	if (Command->use_sg) {
 		struct scatterlist *ScatterList = (struct scatterlist *) BufferPointer;
 		int Segment, Count;
 
-		Count = pci_map_sg(HostAdapter->PCI_Device, ScatterList, SegmentCount,
-				Command->sc_data_direction);
+		Count = pci_map_sg(HostAdapter->PCI_Device, ScatterList,
+				   Command->use_sg, Command->sc_data_direction);
 		CCB->Opcode = BusLogic_InitiatorCCB_ScatterGather;
 		CCB->DataLength = Count * sizeof(struct BusLogic_ScatterGatherSegment);
 		if (BusLogic_MultiMasterHostAdapterP(HostAdapter))
-- 
1.4.3.2

