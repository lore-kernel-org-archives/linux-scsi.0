From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 19/21] advansys: Remove a couple of uses of bus_to_virt
Date: Tue,  2 Oct 2007 21:55:40 -0400
Message-ID: <1191376543887-git-send-email-matthew@wil.cx>
References: <11913765421743-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:45167 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbXJCBzq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 21:55:46 -0400
In-Reply-To: <11913765421743-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Replace ASC_VADDR_TO_U32 and ASC_U32_TO_VADDR with an auto-expanding
array that maps pointers to 32-bit IDs and back.  One of the uses of
ASC_VADDR_TO_U32 was in error; it should have been using ADV_VADDR_TO_U32.

Also replace the use of virt_to_bus when setting the sense_address with
a call to dma_map_single() followed by dma_cache_sync.  This part cribbed
from the 53c700 driver.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/advansys.c |  105 +++++++++++++++++++++++++++++++++++------------
 1 files changed, 79 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 7d334f8..d31a281 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -90,17 +90,6 @@
 #define ASC_DCNT  __u32		/* Unsigned Data count type. */
 #define ASC_SDCNT __s32		/* Signed Data count type. */
 
-/*
- * These macros are used to convert a virtual address to a
- * 32-bit value. This currently can be used on Linux Alpha
- * which uses 64-bit virtual address but a 32-bit bus address.
- * This is likely to break in the future, but doing this now
- * will give us time to change the HW and FW to handle 64-bit
- * addresses.
- */
-#define ASC_VADDR_TO_U32   virt_to_bus
-#define ASC_U32_TO_VADDR   bus_to_virt
-
 typedef unsigned char uchar;
 
 #ifndef TRUE
@@ -601,6 +590,8 @@ typedef struct asc_dvc_var {
 	uchar min_sdtr_index;
 	uchar max_sdtr_index;
 	struct asc_board *drv_ptr;
+	int ptr_map_count;
+	void **ptr_map;
 	ASC_DCNT uc_break;
 } ASC_DVC_VAR;
 
@@ -2748,6 +2739,59 @@ static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *q)
 #endif /* ADVANSYS_DEBUG */
 
 /*
+ * The advansys chip/microcode contains a 32-bit identifier for each command
+ * known as the 'srb'.  I don't know what it stands for.  The driver used
+ * to encode the scsi_cmnd pointer by calling virt_to_bus and retrieve it
+ * with bus_to_virt.  Now the driver keeps a per-host map of integers to
+ * pointers.  It auto-expands when full, unless it can't allocate memory.
+ * Note that an srb of 0 is treated specially by the chip/firmware, hence
+ * the return of i+1 in this routine, and the corresponding subtraction in
+ * the inverse routine.
+ */
+#define BAD_SRB 0
+static u32 advansys_ptr_to_srb(struct asc_dvc_var *asc_dvc, void *ptr)
+{
+	int i;
+	void **new_ptr;
+
+	for (i = 0; i < asc_dvc->ptr_map_count; i++) {
+		if (!asc_dvc->ptr_map[i])
+			goto out;
+	}
+
+	if (asc_dvc->ptr_map_count == 0)
+		asc_dvc->ptr_map_count = 1;
+	else
+		asc_dvc->ptr_map_count *= 2;
+
+	new_ptr = krealloc(asc_dvc->ptr_map,
+			asc_dvc->ptr_map_count * sizeof(void *), GFP_ATOMIC);
+	if (!new_ptr)
+		return BAD_SRB;
+	asc_dvc->ptr_map = new_ptr;
+ out:
+	ASC_DBG(3, "Putting ptr %p into array offset %d\n", ptr, i);
+	asc_dvc->ptr_map[i] = ptr;
+	return i + 1;
+}
+
+static void * advansys_srb_to_ptr(struct asc_dvc_var *asc_dvc, u32 srb)
+{
+	void *ptr;
+
+	srb--;
+	if (srb >= asc_dvc->ptr_map_count) {
+		printk("advansys: bad SRB %u, max %u\n", srb,
+							asc_dvc->ptr_map_count);
+		return NULL;
+	}
+	ptr = asc_dvc->ptr_map[srb];
+	asc_dvc->ptr_map[srb] = NULL;
+	ASC_DBG(3, "Returning ptr %p from array offset %d\n", ptr, srb);
+	return ptr;
+}
+
+/*
  * advansys_info()
  *
  * Return suitable for printing on the console with the argument
@@ -9075,17 +9119,10 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	ASC_DBG(1, "asc_dvc_varp 0x%p, qdonep 0x%p\n", asc_dvc_varp, qdonep);
 	ASC_DBG_PRT_ASC_QDONE_INFO(2, qdonep);
 
-	/*
-	 * Get the struct scsi_cmnd structure and Scsi_Host structure for the
-	 * command that has been completed.
-	 */
-	scp = (struct scsi_cmnd *)ASC_U32_TO_VADDR(qdonep->d2.srb_ptr);
-	ASC_DBG(1, "scp 0x%p\n", scp);
-
-	if (scp == NULL) {
-		ASC_PRINT("asc_isr_callback: scp is NULL\n");
+	scp = advansys_srb_to_ptr(asc_dvc_varp, qdonep->d2.srb_ptr);
+	if (!scp)
 		return;
-	}
+
 	ASC_DBG_PRT_CDB(2, scp->cmnd, scp->cmd_len);
 
 	shost = scp->device->host;
@@ -9095,6 +9132,8 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	boardp = shost_priv(shost);
 	BUG_ON(asc_dvc_varp != &boardp->dvc_var.asc_dvc_var);
 
+	dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
+			sizeof(scp->sense_buffer), DMA_FROM_DEVICE);
 	/*
 	 * 'qdonep' contains the command's ending status.
 	 */
@@ -9835,9 +9874,20 @@ static int advansys_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+static __le32 advansys_get_sense_buffer_dma(struct scsi_cmnd *scp)
+{
+	struct asc_board *board = shost_priv(scp->device->host);
+	scp->SCp.dma_handle = dma_map_single(board->dev, scp->sense_buffer,
+				sizeof(scp->sense_buffer), DMA_FROM_DEVICE);
+	dma_cache_sync(board->dev, scp->sense_buffer,
+				sizeof(scp->sense_buffer), DMA_FROM_DEVICE);
+	return cpu_to_le32(scp->SCp.dma_handle);
+}
+
 static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 			struct asc_scsi_q *asc_scsi_q)
 {
+	struct asc_dvc_var *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 	int use_sg;
 
 	memset(asc_scsi_q, 0, sizeof(*asc_scsi_q));
@@ -9845,7 +9895,11 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	/*
 	 * Point the ASC_SCSI_Q to the 'struct scsi_cmnd'.
 	 */
-	asc_scsi_q->q2.srb_ptr = ASC_VADDR_TO_U32(scp);
+	asc_scsi_q->q2.srb_ptr = advansys_ptr_to_srb(asc_dvc, scp);
+	if (asc_scsi_q->q2.srb_ptr == BAD_SRB) {
+		scp->result = HOST_BYTE(DID_SOFT_ERROR);
+		return ASC_ERROR;
+	}
 
 	/*
 	 * Build the ASC_SCSI_Q request.
@@ -9856,8 +9910,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	asc_scsi_q->q1.target_lun = scp->device->lun;
 	asc_scsi_q->q2.target_ix =
 	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
-	asc_scsi_q->q1.sense_addr =
-	    cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
+	asc_scsi_q->q1.sense_addr = advansys_get_sense_buffer_dma(scp);
 	asc_scsi_q->q1.sense_len = sizeof(scp->sense_buffer);
 
 	/*
@@ -9871,7 +9924,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	 * started request.
 	 *
 	 */
-	if ((boardp->dvc_var.asc_dvc_var.cur_dvc_qng[scp->device->id] > 0) &&
+	if ((asc_dvc->cur_dvc_qng[scp->device->id] > 0) &&
 	    (boardp->reqcnt[scp->device->id] % 255) == 0) {
 		asc_scsi_q->q2.tag_code = MSG_ORDERED_TAG;
 	} else {
@@ -10091,7 +10144,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	/*
 	 * Set the ADV_SCSI_REQ_Q 'srb_ptr' to point to the adv_req_t structure.
 	 */
-	scsiqp->srb_ptr = ASC_VADDR_TO_U32(reqp);
+	scsiqp->srb_ptr = ADV_VADDR_TO_U32(reqp);
 
 	/*
 	 * Set the adv_req_t 'cmndp' to point to the struct scsi_cmnd structure.
-- 
1.5.3.1

