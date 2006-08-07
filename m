From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 04/10] qla4xxx: qla4xxx_mem_alloc-defn-before-use
Date: Mon, 07 Aug 2006 10:37:23 -0500
Message-ID: <20060807153723.31019.48452.stgit@bebe.enoyolf.org>
References: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:35490 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932166AbWHGPjt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:39:49 -0400
In-Reply-To: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

- move the defn to before the call.
- make defn static.

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |  206 ++++++++++++++++++++---------------------
 1 files changed, 102 insertions(+), 104 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index aa30a86..73dcde4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -44,8 +44,6 @@ MODULE_PARM_DESC(extended_error_logging,
  * SCSI host template entry points
  */
 
-static int qla4xxx_mem_alloc(struct scsi_qla_host *ha);
-static void qla4xxx_mem_free(struct scsi_qla_host *ha);
 static void qla4xxx_timer(struct scsi_qla_host *ha);
 static void qla4xxx_do_dpc(void *data);
 static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha);
@@ -465,6 +463,108 @@ qc_fail_command:
 }
 
 /**
+ * qla4xxx_mem_free - frees memory allocated to adapter
+ * @ha: Pointer to host adapter structure.
+ *
+ * Frees memory previously allocated by qla4xxx_mem_alloc
+ **/
+static void qla4xxx_mem_free(struct scsi_qla_host *ha)
+{
+	if (ha->queues)
+		dma_free_coherent(&ha->pdev->dev, ha->queues_len, ha->queues,
+				  ha->queues_dma);
+
+	ha->queues_len = 0;
+	ha->queues = NULL;
+	ha->queues_dma = 0;
+	ha->request_ring = NULL;
+	ha->request_dma = 0;
+	ha->response_ring = NULL;
+	ha->response_dma = 0;
+	ha->shadow_regs = NULL;
+	ha->shadow_regs_dma = 0;
+
+	/* Free srb pool. */
+	if (ha->srb_mempool)
+		mempool_destroy(ha->srb_mempool);
+
+	ha->srb_mempool = NULL;
+
+	/* release io space registers  */
+	if (ha->reg)
+		iounmap(ha->reg);
+	pci_release_regions(ha->pdev);
+}
+
+/**
+ * qla4xxx_mem_alloc - allocates memory for use by adapter.
+ * @ha: Pointer to host adapter structure
+ *
+ * Allocates DMA memory for request and response queues. Also allocates memory
+ * for srbs.
+ **/
+static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
+{
+	unsigned long align;
+
+	/* Allocate contiguous block of DMA memory for queues. */
+	ha->queues_len = ((REQUEST_QUEUE_DEPTH * QUEUE_SIZE) +
+			  (RESPONSE_QUEUE_DEPTH * QUEUE_SIZE) +
+			  sizeof(struct shadow_regs) +
+			  MEM_ALIGN_VALUE +
+			  (PAGE_SIZE - 1)) & ~(PAGE_SIZE - 1);
+	ha->queues = dma_alloc_coherent(&ha->pdev->dev, ha->queues_len,
+					&ha->queues_dma, GFP_KERNEL);
+	if (ha->queues == NULL) {
+		dev_warn(&ha->pdev->dev,
+			 "Memory Allocation failed - queues.\n");
+		goto mem_alloc_error_exit;
+	}
+	memset(ha->queues, 0, ha->queues_len);
+
+	/*
+	 * As per RISC alignment requirements -- the bus-address must be a
+	 * multiple of the request-ring size (in bytes).
+	 */
+	align = 0;
+	if ((unsigned long)ha->queues_dma & (MEM_ALIGN_VALUE - 1))
+		align = MEM_ALIGN_VALUE - ((unsigned long)ha->queues_dma &
+					   (MEM_ALIGN_VALUE - 1));
+
+	/* Update request and response queue pointers. */
+	ha->request_dma = ha->queues_dma + align;
+	ha->request_ring = (struct queue_entry *) (ha->queues + align);
+	ha->response_dma = ha->queues_dma + align +
+		(REQUEST_QUEUE_DEPTH * QUEUE_SIZE);
+	ha->response_ring = (struct queue_entry *) (ha->queues + align +
+						    (REQUEST_QUEUE_DEPTH *
+						     QUEUE_SIZE));
+	ha->shadow_regs_dma = ha->queues_dma + align +
+		(REQUEST_QUEUE_DEPTH * QUEUE_SIZE) +
+		(RESPONSE_QUEUE_DEPTH * QUEUE_SIZE);
+	ha->shadow_regs = (struct shadow_regs *) (ha->queues + align +
+						  (REQUEST_QUEUE_DEPTH *
+						   QUEUE_SIZE) +
+						  (RESPONSE_QUEUE_DEPTH *
+						   QUEUE_SIZE));
+
+	/* Allocate memory for srb pool. */
+	ha->srb_mempool = mempool_create(SRB_MIN_REQ, mempool_alloc_slab,
+					 mempool_free_slab, srb_cachep);
+	if (ha->srb_mempool == NULL) {
+		dev_warn(&ha->pdev->dev,
+			 "Memory Allocation failed - SRB Pool.\n");
+		goto mem_alloc_error_exit;
+	}
+
+	return QLA_SUCCESS;
+
+mem_alloc_error_exit:
+	qla4xxx_mem_free(ha);
+	return QLA_ERROR;
+}
+
+/**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
  * @pci_device_id: pointer to pci_device entry
@@ -769,108 +869,6 @@ void qla4xxx_config_dma_addressing(struc
 		retval = pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK);
 }
 
-/**
- * qla4xxx_mem_alloc - allocates memory for use by adapter.
- * @ha: Pointer to host adapter structure
- *
- * Allocates DMA memory for request and response queues. Also allocates memory
- * for srbs.
- **/
-static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
-{
-	unsigned long align;
-
-	/* Allocate contiguous block of DMA memory for queues. */
-	ha->queues_len = ((REQUEST_QUEUE_DEPTH * QUEUE_SIZE) +
-			  (RESPONSE_QUEUE_DEPTH * QUEUE_SIZE) +
-			  sizeof(struct shadow_regs) +
-			  MEM_ALIGN_VALUE +
-			  (PAGE_SIZE - 1)) & ~(PAGE_SIZE - 1);
-	ha->queues = dma_alloc_coherent(&ha->pdev->dev, ha->queues_len,
-					&ha->queues_dma, GFP_KERNEL);
-	if (ha->queues == NULL) {
-		dev_warn(&ha->pdev->dev,
-			 "Memory Allocation failed - queues.\n");
-		goto mem_alloc_error_exit;
-	}
-	memset(ha->queues, 0, ha->queues_len);
-
-	/*
-	 * As per RISC alignment requirements -- the bus-address must be a
-	 * multiple of the request-ring size (in bytes).
-	 */
-	align = 0;
-	if ((unsigned long)ha->queues_dma & (MEM_ALIGN_VALUE - 1))
-		align = MEM_ALIGN_VALUE - ((unsigned long)ha->queues_dma &
-					   (MEM_ALIGN_VALUE - 1));
-
-	/* Update request and response queue pointers. */
-	ha->request_dma = ha->queues_dma + align;
-	ha->request_ring = (struct queue_entry *) (ha->queues + align);
-	ha->response_dma = ha->queues_dma + align +
-		(REQUEST_QUEUE_DEPTH * QUEUE_SIZE);
-	ha->response_ring = (struct queue_entry *) (ha->queues + align +
-						    (REQUEST_QUEUE_DEPTH *
-						     QUEUE_SIZE));
-	ha->shadow_regs_dma = ha->queues_dma + align +
-		(REQUEST_QUEUE_DEPTH * QUEUE_SIZE) +
-		(RESPONSE_QUEUE_DEPTH * QUEUE_SIZE);
-	ha->shadow_regs = (struct shadow_regs *) (ha->queues + align +
-						  (REQUEST_QUEUE_DEPTH *
-						   QUEUE_SIZE) +
-						  (RESPONSE_QUEUE_DEPTH *
-						   QUEUE_SIZE));
-
-	/* Allocate memory for srb pool. */
-	ha->srb_mempool = mempool_create(SRB_MIN_REQ, mempool_alloc_slab,
-					 mempool_free_slab, srb_cachep);
-	if (ha->srb_mempool == NULL) {
-		dev_warn(&ha->pdev->dev,
-			 "Memory Allocation failed - SRB Pool.\n");
-		goto mem_alloc_error_exit;
-	}
-
-	return QLA_SUCCESS;
-
-mem_alloc_error_exit:
-	qla4xxx_mem_free(ha);
-	return QLA_ERROR;
-}
-
-/**
- * qla4xxx_mem_free - frees memory allocated to adapter
- * @ha: Pointer to host adapter structure.
- *
- * Frees memory previously allocated by qla4xxx_mem_alloc
- **/
-static void qla4xxx_mem_free(struct scsi_qla_host *ha)
-{
-	if (ha->queues)
-		dma_free_coherent(&ha->pdev->dev, ha->queues_len, ha->queues,
-				  ha->queues_dma);
-
-	ha->queues_len = 0;
-	ha->queues = NULL;
-	ha->queues_dma = 0;
-	ha->request_ring = NULL;
-	ha->request_dma = 0;
-	ha->response_ring = NULL;
-	ha->response_dma = 0;
-	ha->shadow_regs = NULL;
-	ha->shadow_regs_dma = 0;
-
-	/* Free srb pool. */
-	if (ha->srb_mempool)
-		mempool_destroy(ha->srb_mempool);
-
-	ha->srb_mempool = NULL;
-
-	/* release io space registers  */
-	if (ha->reg)
-		iounmap(ha->reg);
-	pci_release_regions(ha->pdev);
-}
-
 static int qla4xxx_slave_alloc(struct scsi_device *sdev)
 {
 	struct iscsi_cls_session *sess = starget_to_session(sdev->sdev_target);
