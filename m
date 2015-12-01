From: Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH Resend] VMW_PVSCSI: Fix the issue of DMA-API related warnings.
Date: Tue, 1 Dec 2015 11:34:10 -0500
Message-ID: <20151201163410.GB19092@hansolo.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, arvindkumar@vmware.com, Thomas Hellstrom <thellstrom@vmware.com>
Cc: linux-scsi@vger.kernel.org, pv-drivers@vmware.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The driver is missing calls to pci_dma_mapping_error() after
performing the DMA mapping, which caused DMA-API warning to
show up in dmesg's output. Though that happens only when
DMA_API_DEBUG option is enabled. This change fixes the issue
and makes pvscsi_map_buffers() function more robust.

Signed-off-by: Arvind Kumar <arvindkumar@vmware.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---

 - Resend of patch that was never committed for some reason

 drivers/scsi/vmw_pvscsi.c | 45 +++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/vmw_pvscsi.h |  2 +-
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 0f133c1817de..19734494f9ec 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -349,9 +349,9 @@ static void pvscsi_create_sg(struct pvscsi_ctx *ctx,
  * Map all data buffers for a command into PCI space and
  * setup the scatter/gather list if needed.
  */
-static void pvscsi_map_buffers(struct pvscsi_adapter *adapter,
-			       struct pvscsi_ctx *ctx, struct scsi_cmnd *cmd,
-			       struct PVSCSIRingReqDesc *e)
+static int pvscsi_map_buffers(struct pvscsi_adapter *adapter,
+			      struct pvscsi_ctx *ctx, struct scsi_cmnd *cmd,
+			      struct PVSCSIRingReqDesc *e)
 {
 	unsigned count;
 	unsigned bufflen = scsi_bufflen(cmd);
@@ -360,18 +360,30 @@ static void pvscsi_map_buffers(struct pvscsi_adapter *adapter,
 	e->dataLen = bufflen;
 	e->dataAddr = 0;
 	if (bufflen == 0)
-		return;
+		return 0;
 
 	sg = scsi_sglist(cmd);
 	count = scsi_sg_count(cmd);
 	if (count != 0) {
 		int segs = scsi_dma_map(cmd);
-		if (segs > 1) {
+
+		if (segs == -ENOMEM) {
+			scmd_printk(KERN_ERR, cmd,
+				    "vmw_pvscsi: Failed to map cmd sglist for DMA.\n");
+			return -1;
+		} else if (segs > 1) {
 			pvscsi_create_sg(ctx, sg, segs);
 
 			e->flags |= PVSCSI_FLAG_CMD_WITH_SG_LIST;
 			ctx->sglPA = pci_map_single(adapter->dev, ctx->sgl,
 						    SGL_SIZE, PCI_DMA_TODEVICE);
+			if (pci_dma_mapping_error(adapter->dev, ctx->sglPA)) {
+				scmd_printk(KERN_ERR, cmd,
+					    "vmw_pvscsi: Failed to map ctx sglist for DMA.\n");
+				scsi_dma_unmap(cmd);
+				ctx->sglPA = 0;
+				return -1;
+			}
 			e->dataAddr = ctx->sglPA;
 		} else
 			e->dataAddr = sg_dma_address(sg);
@@ -382,8 +394,15 @@ static void pvscsi_map_buffers(struct pvscsi_adapter *adapter,
 		 */
 		ctx->dataPA = pci_map_single(adapter->dev, sg, bufflen,
 					     cmd->sc_data_direction);
+		if (pci_dma_mapping_error(adapter->dev, ctx->dataPA)) {
+			scmd_printk(KERN_ERR, cmd,
+				    "vmw_pvscsi: Failed to map direct data buffer for DMA.\n");
+			return -1;
+		}
 		e->dataAddr = ctx->dataPA;
 	}
+
+	return 0;
 }
 
 static void pvscsi_unmap_buffers(const struct pvscsi_adapter *adapter,
@@ -690,6 +709,12 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
 		ctx->sensePA = pci_map_single(adapter->dev, cmd->sense_buffer,
 					      SCSI_SENSE_BUFFERSIZE,
 					      PCI_DMA_FROMDEVICE);
+		if (pci_dma_mapping_error(adapter->dev, ctx->sensePA)) {
+			scmd_printk(KERN_ERR, cmd,
+				    "vmw_pvscsi: Failed to map sense buffer for DMA.\n");
+			ctx->sensePA = 0;
+			return -1;
+		}
 		e->senseAddr = ctx->sensePA;
 		e->senseLen = SCSI_SENSE_BUFFERSIZE;
 	} else {
@@ -711,7 +736,15 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
 	else
 		e->flags = 0;
 
-	pvscsi_map_buffers(adapter, ctx, cmd, e);
+	if (pvscsi_map_buffers(adapter, ctx, cmd, e) != 0) {
+		if (cmd->sense_buffer) {
+			pci_unmap_single(adapter->dev, ctx->sensePA,
+					 SCSI_SENSE_BUFFERSIZE,
+					 PCI_DMA_FROMDEVICE);
+			ctx->sensePA = 0;
+		}
+		return -1;
+	}
 
 	e->context = pvscsi_map_context(adapter, ctx);
 
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index ee16f0c5c47d..12712c92f37a 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -26,7 +26,7 @@
 
 #include <linux/types.h>
 
-#define PVSCSI_DRIVER_VERSION_STRING   "1.0.5.0-k"
+#define PVSCSI_DRIVER_VERSION_STRING   "1.0.6.0-k"
 
 #define PVSCSI_MAX_NUM_SG_ENTRIES_PER_SEGMENT 128
 
-- 
2.5.0
