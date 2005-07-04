From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/9] qla1280: misc cleanups
Date: Mon, 4 Jul 2005 17:48:30 +0200
Message-ID: <20050704154830.GD30435@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:49356 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261303AbVGDPse (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2005 11:48:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org, ths@linux-mips.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thiemo Seufer <ths@linux-mips.org>

Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c	2005-06-19 20:55:09.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.c	2005-06-19 21:12:55.000000000 +0200
@@ -1459,7 +1459,6 @@
  *
  * Input:
  *      ha           = adapter block pointer.
- *      done_q       = done queue.
  */
 static void
 qla1280_done(struct scsi_qla_host *ha)
@@ -1593,7 +1592,7 @@
 
 	case CS_DATA_OVERRUN:
 		dprintk(2, "Data overrun 0x%x\n", residual_length);
-		dprintk(2, "qla1280_isr: response packet data\n");
+		dprintk(2, "qla1280_return_status: response packet data\n");
 		qla1280_dump_buffer(2, (char *)sts, RESPONSE_ENTRY_SIZE);
 		host_status = DID_ERROR;
 		break;
@@ -2061,7 +2060,7 @@
 	mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
 	err = qla1280_mailbox_command(ha, BIT_1 | BIT_0, mb);
 	if (err) {
-		printk(KERN_ERR "scsi(%li): Failed checksum\n", ha->host_no);
+		printk(KERN_ERR "scsi(%li): RISC checksum failed.\n", ha->host_no);
 		return err;
 	}
 
@@ -3080,10 +3079,13 @@
 				REQUEST_ENTRY_CNT - (ha->req_ring_index - cnt);
 	}
 
+	dprintk(3, "Number of free entries=(%d) seg_cnt=0x%x\n",
+		ha->req_q_cnt, seg_cnt);
+
 	/* If room for request in request ring. */
 	if ((req_cnt + 2) >= ha->req_q_cnt) {
 		status = 1;
-		dprintk(2, "qla1280_64bit_start_scsi: in-ptr=0x%x  req_q_cnt="
+		dprintk(2, "qla1280_start_scsi: in-ptr=0x%x  req_q_cnt="
 			"0x%xreq_cnt=0x%x", ha->req_ring_index, ha->req_q_cnt,
 			req_cnt);
 		goto out;
@@ -3095,7 +3097,7 @@
 
 	if (cnt >= MAX_OUTSTANDING_COMMANDS) {
 		status = 1;
-		dprintk(2, "qla1280_64bit_start_scsi: NO ROOM IN "
+		dprintk(2, "qla1280_start_scsi: NO ROOM IN "
 			"OUTSTANDING ARRAY, req_q_cnt=0x%x", ha->req_q_cnt);
 		goto out;
 	}
@@ -3104,7 +3106,7 @@
 	ha->req_q_cnt -= req_cnt;
 	CMD_HANDLE(sp->cmd) = (unsigned char *)(unsigned long)(cnt + 1);
 
-	dprintk(2, "64bit_start: cmd=%p sp=%p CDB=%xm, handle %lx\n", cmd, sp,
+	dprintk(2, "start: cmd=%p sp=%p CDB=%xm, handle %lx\n", cmd, sp,
 		cmd->cmnd[0], (long)CMD_HANDLE(sp->cmd));
 	dprintk(2, "             bus %i, target %i, lun %i\n",
 		SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
@@ -4626,7 +4628,7 @@
 	if (pci_set_dma_mask(ha->pdev, (dma_addr_t) ~ 0ULL)) {
 		if (pci_set_dma_mask(ha->pdev, 0xffffffff)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
-			       " suitable DMA mask - aboring\n", ha->host_no);
+			       "suitable DMA mask - aborting\n", ha->host_no);
 			error = -ENODEV;
 			goto error_free_irq;
 		}
@@ -4636,14 +4638,14 @@
 #else
 	if (pci_set_dma_mask(ha->pdev, 0xffffffff)) {
 		printk(KERN_WARNING "scsi(%li): Unable to set a "
-		       " suitable DMA mask - aboring\n", ha->host_no);
+		       "suitable DMA mask - aborting\n", ha->host_no);
 		error = -ENODEV;
 		goto error_free_irq;
 	}
 #endif
 
 	ha->request_ring = pci_alloc_consistent(ha->pdev,
-			((REQUEST_ENTRY_CNT + 1) * (sizeof(request_t))),
+			((REQUEST_ENTRY_CNT + 1) * sizeof(request_t)),
 			&ha->request_dma);
 	if (!ha->request_ring) {
 		printk(KERN_INFO "qla1280: Failed to get request memory\n");
@@ -4651,7 +4653,7 @@
 	}
 
 	ha->response_ring = pci_alloc_consistent(ha->pdev,
-			((RESPONSE_ENTRY_CNT + 1) * (sizeof(struct response))),
+			((RESPONSE_ENTRY_CNT + 1) * sizeof(struct response)),
 			&ha->response_dma);
 	if (!ha->response_ring) {
 		printk(KERN_INFO "qla1280: Failed to get response memory\n");
@@ -4746,11 +4748,11 @@
 #endif
  error_free_response_ring:
 	pci_free_consistent(ha->pdev,
-			((RESPONSE_ENTRY_CNT + 1) * (sizeof(struct response))),
+			((RESPONSE_ENTRY_CNT + 1) * sizeof(struct response)),
 			ha->response_ring, ha->response_dma);
  error_free_request_ring:
 	pci_free_consistent(ha->pdev,
-			((REQUEST_ENTRY_CNT + 1) * (sizeof(request_t))),
+			((REQUEST_ENTRY_CNT + 1) * sizeof(request_t)),
 			ha->request_ring, ha->request_dma);
  error_put_host:
 	scsi_host_put(host);
