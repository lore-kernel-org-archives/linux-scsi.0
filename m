From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 17/24][RFC] BusLogic: Use of scsi_make_sense() API for DMA-able sense buffer
Date: Mon,  4 Feb 2008 19:25:48 +0200
Message-ID: <1202145948-5173-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:59781 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbYBDRbY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:31:24 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - Use a pre allocated, DMA mapped, sense buffer at each command,
    Using the scsi_make_sense() API. And scsi_return_sense() when
    done.
  - set .pre_allocate_sense at host template.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/BusLogic.c |   24 +++++++++++-------------
 drivers/scsi/BusLogic.h |    1 +
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 4d3ebb1..5b076f3 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -42,17 +42,19 @@
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/dma-mapping.h>
-#include <scsi/scsicam.h>
 
 #include <asm/dma.h>
 #include <asm/io.h>
 #include <asm/system.h>
 
+#include <scsi/scsicam.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_eh.h>
+
 #include "BusLogic.h"
 #include "FlashPoint.c"
 
@@ -309,6 +311,7 @@ static void BusLogic_DeallocateCCB(struct BusLogic_CCB *CCB)
 	pci_unmap_single(HostAdapter->PCI_Device, CCB->SenseDataPointer,
 			 CCB->SenseDataLength, PCI_DMA_FROMDEVICE);
 
+	scsi_return_sense(CCB->Command, CCB->sense_buffer);
 	CCB->Command = NULL;
 	CCB->Status = BusLogic_CCB_Free;
 	CCB->Next = HostAdapter->Free_CCBs;
@@ -2627,7 +2630,7 @@ static void BusLogic_ProcessCompletedCCBs(struct BusLogic_HostAdapter *HostAdapt
 						BusLogic_Notice("\n", HostAdapter);
 						BusLogic_Notice("Sense ", HostAdapter);
 						for (i = 0; i < CCB->SenseDataLength; i++)
-							BusLogic_Notice(" %02X", HostAdapter, Command->sense_buffer[i]);
+							BusLogic_Notice(" %02X", HostAdapter, CCB->sense_buffer[i]);
 						BusLogic_Notice("\n", HostAdapter);
 					}
 				}
@@ -2816,16 +2819,6 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 	int Count;
 	struct BusLogic_CCB *CCB;
 	/*
-	   SCSI REQUEST_SENSE commands will be executed automatically by the Host
-	   Adapter for any errors, so they should not be executed explicitly unless
-	   the Sense Data is zero indicating that no error occurred.
-	 */
-	if (CDB[0] == REQUEST_SENSE && Command->sense_buffer[0] != 0) {
-		Command->result = DID_OK << 16;
-		CompletionRoutine(Command);
-		return 0;
-	}
-	/*
 	   Allocate a CCB from the Host Adapter's free list.  In the unlikely event
 	   that there are none available and memory allocation fails, wait 1 second
 	   and try again.  If that fails, the Host Adapter is probably hung so signal
@@ -2948,7 +2941,10 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 	}
 	memcpy(CCB->CDB, CDB, CDB_Length);
 	CCB->SenseDataLength = SCSI_SENSE_BUFFERSIZE;
-	CCB->SenseDataPointer = pci_map_single(HostAdapter->PCI_Device, Command->sense_buffer, CCB->SenseDataLength, PCI_DMA_FROMDEVICE);
+	CCB->sense_buffer = scsi_make_sense(Command);
+	CCB->SenseDataPointer = pci_map_single(HostAdapter->PCI_Device,
+					CCB->sense_buffer, CCB->SenseDataLength,
+					PCI_DMA_FROMDEVICE);
 	CCB->Command = Command;
 	Command->scsi_done = CompletionRoutine;
 	if (BusLogic_MultiMasterHostAdapterP(HostAdapter)) {
@@ -3575,6 +3571,8 @@ static struct scsi_host_template Bus_Logic_template = {
 	.unchecked_isa_dma = 1,
 	.max_sectors = 128,
 	.use_clustering = ENABLE_CLUSTERING,
+	.pre_allocate_sense = 1,
+	.sense_buffsize = SCSI_SENSE_BUFFERSIZE,
 };
 
 /*
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index bfbfb5c..6e0a131 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -890,6 +890,7 @@ struct BusLogic_CCB {
 	struct BusLogic_CCB *NextAll;
 	struct BusLogic_ScatterGatherSegment
 	 ScatterGatherList[BusLogic_ScatterGatherLimit];
+	u8 *sense_buffer;
 };
 
 /*
-- 
1.5.3.3

