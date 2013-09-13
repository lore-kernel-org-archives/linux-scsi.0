From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: [PATCH v2] SCSI: buslogic: Added check for DMA mapping errors (was
 Re:[BusLogic] DMA-API: device driver failed to check map error)
Date: Fri, 13 Sep 2013 13:44:06 -0600
Message-ID: <1379101446.8358.4.camel@concerto>
References: <201309101503.ECC18788.SOOVOJLFtQHMFF@I-love.SAKURA.ne.jp>
	 <1378816604.6973.53.camel@dabdike.int.hansenpartnership.com>
	 <1379004807.10738.3.camel@concerto>
	 <201309140042.GEI73439.QHSJtOFFVFOLOM@I-love.SAKURA.ne.jp>
	 <52333560.50209@oracle.com>
Reply-To: khalid.aziz@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52333560.50209@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jbottomley@parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Added check for DMA mapping errors for request sense data
buffer. Checking for mapping error can avoid potential wild
writes. This patch was prompted by the warning from
dma_unmap when kernel is compiled with CONFIG_DMA_API_DEBUG.


Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
---
Changelog:
 v1 - Fixed a typo and addressed a potential NULL pointer 
	dereference issue

 drivers/scsi/BusLogic.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index feab3a5..e63b788 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -26,8 +26,8 @@
 
 */
 
-#define blogic_drvr_version		"2.1.16"
-#define blogic_drvr_date		"18 July 2002"
+#define blogic_drvr_version		"2.1.17"
+#define blogic_drvr_date		"12 September 2013"
 
 #include <linux/module.h>
 #include <linux/init.h>
@@ -311,12 +311,14 @@ static struct blogic_ccb *blogic_alloc_ccb(struct blogic_adapter *adapter)
   caller.
 */
 
-static void blogic_dealloc_ccb(struct blogic_ccb *ccb)
+static void blogic_dealloc_ccb(struct blogic_ccb *ccb, int dma_unmap)
 {
 	struct blogic_adapter *adapter = ccb->adapter;
 
-	scsi_dma_unmap(ccb->command);
-	pci_unmap_single(adapter->pci_device, ccb->sensedata,
+	if (ccb->command != NULL)
+		scsi_dma_unmap(ccb->command);
+	if (dma_unmap)
+		pci_unmap_single(adapter->pci_device, ccb->sensedata,
 			 ccb->sense_datalen, PCI_DMA_FROMDEVICE);
 
 	ccb->command = NULL;
@@ -2762,8 +2764,8 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 			/*
 			   Place CCB back on the Host Adapter's free list.
 			 */
-			blogic_dealloc_ccb(ccb);
-#if 0				/* this needs to be redone different for new EH */
+			blogic_dealloc_ccb(ccb, 1);
+#if 0			/* this needs to be redone different for new EH */
 			/*
 			   Bus Device Reset CCBs have the command field
 			   non-NULL only when a Bus Device Reset was requested
@@ -2791,7 +2793,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 				if (ccb->status == BLOGIC_CCB_RESET &&
 						ccb->tgt_id == tgt_id) {
 					command = ccb->command;
-					blogic_dealloc_ccb(ccb);
+					blogic_dealloc_ccb(ccb, 1);
 					adapter->active_cmds[tgt_id]--;
 					command->result = DID_RESET << 16;
 					command->scsi_done(command);
@@ -2862,7 +2864,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 			/*
 			   Place CCB back on the Host Adapter's free list.
 			 */
-			blogic_dealloc_ccb(ccb);
+			blogic_dealloc_ccb(ccb, 1);
 			/*
 			   Call the SCSI Command Completion Routine.
 			 */
@@ -3034,6 +3036,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 	int buflen = scsi_bufflen(command);
 	int count;
 	struct blogic_ccb *ccb;
+	dma_addr_t sense_buf;
 
 	/*
 	   SCSI REQUEST_SENSE commands will be executed automatically by the
@@ -3179,10 +3182,17 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 	}
 	memcpy(ccb->cdb, cdb, cdblen);
 	ccb->sense_datalen = SCSI_SENSE_BUFFERSIZE;
-	ccb->sensedata = pci_map_single(adapter->pci_device,
+	ccb->command = command;
+	sense_buf = pci_map_single(adapter->pci_device,
 				command->sense_buffer, ccb->sense_datalen,
 				PCI_DMA_FROMDEVICE);
-	ccb->command = command;
+	if (dma_mapping_error(&adapter->pci_device->dev, sense_buf)) {
+		blogic_err("DMA mapping for sense data buffer failed\n",
+				adapter);
+		blogic_dealloc_ccb(ccb, 0);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+	ccb->sensedata = sense_buf;
 	command->scsi_done = comp_cb;
 	if (blogic_multimaster_type(adapter)) {
 		/*
@@ -3203,7 +3213,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
 						ccb)) {
 				blogic_warn("Still unable to write Outgoing Mailbox - " "Host Adapter Dead?\n", adapter);
-				blogic_dealloc_ccb(ccb);
+				blogic_dealloc_ccb(ccb, 1);
 				command->result = DID_ERROR << 16;
 				command->scsi_done(command);
 			}
@@ -3337,7 +3347,7 @@ static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard_reset)
 
 	for (ccb = adapter->all_ccbs; ccb != NULL; ccb = ccb->next_all)
 		if (ccb->status == BLOGIC_CCB_ACTIVE)
-			blogic_dealloc_ccb(ccb);
+			blogic_dealloc_ccb(ccb, 1);
 	/*
 	 * Wait a few seconds between the Host Adapter Hard Reset which
 	 * initiates a SCSI Bus Reset and issuing any SCSI Commands.  Some
-- 
1.7.10.4
