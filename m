From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of obsolete APIs in BusLogic
Date: Sat, 9 Oct 2004 15:45:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041009134502.GB20025@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:14227 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266838AbUJINpE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2004 09:45:04 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.35/drivers/scsi/BusLogic.c	2004-09-14 22:11:49 +02:00
+++ edited/drivers/scsi/BusLogic.c	2004-10-09 14:24:03 +02:00
@@ -47,8 +47,11 @@
 #include <asm/io.h>
 #include <asm/system.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include "BusLogic.h"
 #include "FlashPoint.c"
 
@@ -300,12 +303,19 @@
 static void BusLogic_DeallocateCCB(struct BusLogic_CCB *CCB)
 {
 	struct BusLogic_HostAdapter *HostAdapter = CCB->HostAdapter;
-	if (CCB->Command->use_sg != 0) {
-		pci_unmap_sg(HostAdapter->PCI_Device, (struct scatterlist *) CCB->Command->request_buffer, CCB->Command->use_sg, scsi_to_pci_dma_dir(CCB->Command->sc_data_direction));
-	} else if (CCB->Command->request_bufflen != 0) {
-		pci_unmap_single(HostAdapter->PCI_Device, CCB->DataPointer, CCB->DataLength, scsi_to_pci_dma_dir(CCB->Command->sc_data_direction));
+	struct scsi_cmnd *cmd = CCB->Command;
+
+	if (cmd->use_sg != 0) {
+		pci_unmap_sg(HostAdapter->PCI_Device,
+				(struct scatterlist *)cmd->request_buffer,
+				cmd->use_sg, cmd->sc_data_direction);
+	} else if (cmd->request_bufflen != 0) {
+		pci_unmap_single(HostAdapter->PCI_Device, CCB->DataPointer,
+				CCB->DataLength, cmd->sc_data_direction);
 	}
-	pci_unmap_single(HostAdapter->PCI_Device, CCB->SenseDataPointer, CCB->SenseDataLength, PCI_DMA_FROMDEVICE);
+	pci_unmap_single(HostAdapter->PCI_Device, CCB->SenseDataPointer,
+			CCB->SenseDataLength, PCI_DMA_FROMDEVICE);
+
 	CCB->Command = NULL;
 	CCB->Status = BusLogic_CCB_Free;
 	CCB->Next = HostAdapter->Free_CCBs;
@@ -2730,7 +2740,7 @@
 
 /* Error Handling (EH) support */
 
-static int BusLogic_host_reset(Scsi_Cmnd * SCpnt)
+static int BusLogic_host_reset(struct scsi_cmnd * SCpnt)
 {
 	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) SCpnt->device->host->hostdata;
 
@@ -2793,12 +2803,15 @@
 	if (SegmentCount == 0 && BufferLength != 0) {
 		CCB->Opcode = BusLogic_InitiatorCCB;
 		CCB->DataLength = BufferLength;
-		CCB->DataPointer = pci_map_single(HostAdapter->PCI_Device, BufferPointer, BufferLength, scsi_to_pci_dma_dir(Command->sc_data_direction));
+		CCB->DataPointer = pci_map_single(HostAdapter->PCI_Device,
+				BufferPointer, BufferLength,
+				Command->sc_data_direction);
 	} else if (SegmentCount != 0) {
 		struct scatterlist *ScatterList = (struct scatterlist *) BufferPointer;
 		int Segment, Count;
 
-		Count = pci_map_sg(HostAdapter->PCI_Device, ScatterList, SegmentCount, scsi_to_pci_dma_dir(Command->sc_data_direction));
+		Count = pci_map_sg(HostAdapter->PCI_Device, ScatterList, SegmentCount,
+				Command->sc_data_direction);
 		CCB->Opcode = BusLogic_InitiatorCCB_ScatterGather;
 		CCB->DataLength = Count * sizeof(struct BusLogic_ScatterGatherSegment);
 		if (BusLogic_MultiMasterHostAdapterP(HostAdapter))
