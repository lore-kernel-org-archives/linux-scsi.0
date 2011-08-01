From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/8] qla4xxx: Code cleanup for read/update flash using BSG
Date: Mon, 1 Aug 2011 03:26:14 -0700
Message-ID: <1312194379-9241-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1312194379-9241-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:29308 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab1HAKft (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 06:35:49 -0400
In-Reply-To: <1312194379-9241-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

- Corrected return status
- Added reset active check
- Removed unused dma_map_sg calls
- Added debug prints on failure

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_bsg.c |  128 +++++++++++++++++-----------------------
 drivers/scsi/qla4xxx/ql4_def.h |   10 +++
 2 files changed, 65 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_bsg.c b/drivers/scsi/qla4xxx/ql4_bsg.c
index daa2b0f..15032f1 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.c
+++ b/drivers/scsi/qla4xxx/ql4_bsg.c
@@ -16,36 +16,31 @@ qla4xxx_read_flash(struct bsg_job *bsg_job)
 	struct scsi_qla_host *ha = to_qla_host(host);
 	struct iscsi_bsg_reply *bsg_reply = bsg_job->reply;
 	struct iscsi_bsg_request *bsg_req = bsg_job->request;
-	uint32_t sg_cnt;
 	uint32_t offset = 0;
 	uint32_t length = 0;
 	dma_addr_t flash_dma;
 	uint8_t *flash = NULL;
-	int rval = 0;
+	int rval = -EINVAL;
 
 	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (unlikely(pci_channel_offline(ha->pdev)))
-		return -EINVAL;
+		goto leave;
 
-	if (ha->flash_state != QLFLASH_WAITING)
-		return -EBUSY;
-
-	/* TODO: Add check for adapter online, reset active?? */
-	sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
-			    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-
-	if (!sg_cnt)
-		return -ENOMEM;
+	if (ql4xxx_reset_active(ha)) {
+		ql4_printk(KERN_ERR, ha, "%s: reset active\n", __func__);
+		rval = -EBUSY;
+		goto leave;
+	}
 
-	if (sg_cnt != bsg_job->reply_payload.sg_cnt) {
-		ql4_printk(KERN_ERR, ha, "dma mapping resulted in different"
-			   " sg counts, sg_cnt: %x dma_sg_cnt: %x\n",
-			   bsg_job->reply_payload.sg_cnt, sg_cnt);
-		rval = -EAGAIN;
-		goto unmap_sg;
+	if (ha->flash_state != QLFLASH_WAITING) {
+		ql4_printk(KERN_ERR, ha, "%s: another flash operation "
+			   "active\n", __func__);
+		rval = -EBUSY;
+		goto leave;
 	}
 
+	ha->flash_state = QLFLASH_READING;
 	offset = bsg_req->rqst_data.h_vendor.vendor_cmd[1];
 	length = bsg_job->reply_payload.payload_len;
 
@@ -55,31 +50,27 @@ qla4xxx_read_flash(struct bsg_job *bsg_job)
 		ql4_printk(KERN_ERR, ha, "%s: dma alloc failed for flash "
 			   "data\n", __func__);
 		rval = -ENOMEM;
-		goto unmap_sg;
+		goto leave;
 	}
 
-	ha->flash_state = QLFLASH_READING;
-	if (qla4xxx_get_flash(ha, flash_dma, offset, length))
-		bsg_reply->result = (DID_ERROR << 16);
-	else {
-		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-				    bsg_job->reply_payload.sg_cnt,
-				    flash, length);
-
-		bsg_reply->result = DID_OK;
-		bsg_reply->reply_payload_rcv_len = length;
+	rval = qla4xxx_get_flash(ha, flash_dma, offset, length);
+	if (rval) {
+		ql4_printk(KERN_ERR, ha, "%s: get flash failed\n", __func__);
+		bsg_reply->result = DID_ERROR << 16;
+		rval = -EIO;
+	} else {
+		bsg_reply->reply_payload_rcv_len =
+			sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+					    bsg_job->reply_payload.sg_cnt,
+					    flash, length);
+		bsg_reply->result = DID_OK << 16;
 	}
 
-	if (flash)
-		dma_free_coherent(&ha->pdev->dev, length, flash, flash_dma);
-
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+	dma_free_coherent(&ha->pdev->dev, length, flash, flash_dma);
+leave:
 	ha->flash_state = QLFLASH_WAITING;
-unmap_sg:
-	dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
-		     bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-	if (!rval)
-		bsg_job_done(bsg_job, bsg_reply->result,
-			     bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -90,36 +81,32 @@ qla4xxx_update_flash(struct bsg_job *bsg_job)
 	struct scsi_qla_host *ha = to_qla_host(host);
 	struct iscsi_bsg_reply *bsg_reply = bsg_job->reply;
 	struct iscsi_bsg_request *bsg_req = bsg_job->request;
-	uint32_t sg_cnt;
 	uint32_t length = 0;
 	uint32_t offset = 0;
 	uint32_t options = 0;
 	dma_addr_t flash_dma;
 	uint8_t *flash = NULL;
-	int rval = 0;
+	int rval = -EINVAL;
 
 	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (unlikely(pci_channel_offline(ha->pdev)))
-		return -EINVAL;
-
-	if (ha->flash_state != QLFLASH_WAITING)
-		return -EBUSY;
+		goto leave;
 
-	sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
-			    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-
-	if (!sg_cnt)
-		return -ENOMEM;
+	if (ql4xxx_reset_active(ha)) {
+		ql4_printk(KERN_ERR, ha, "%s: reset active\n", __func__);
+		rval = -EBUSY;
+		goto leave;
+	}
 
-	if (sg_cnt != bsg_job->request_payload.sg_cnt) {
-		ql4_printk(KERN_ERR, ha, "dma mapping resulted in different "
-			   "sg counts request_sg_cnt: %x dma_request_sg_cnt: "
-			   "%x\n", bsg_job->request_payload.sg_cnt, sg_cnt);
-		rval = -EAGAIN;
-		goto unmap_sg;
+	if (ha->flash_state != QLFLASH_WAITING) {
+		ql4_printk(KERN_ERR, ha, "%s: another flash operation "
+			   "active\n", __func__);
+		rval = -EBUSY;
+		goto leave;
 	}
 
+	ha->flash_state = QLFLASH_WRITING;
 	length = bsg_job->request_payload.payload_len;
 	offset = bsg_req->rqst_data.h_vendor.vendor_cmd[1];
 	options = bsg_req->rqst_data.h_vendor.vendor_cmd[2];
@@ -130,30 +117,25 @@ qla4xxx_update_flash(struct bsg_job *bsg_job)
 		ql4_printk(KERN_ERR, ha, "%s: dma alloc failed for flash "
 			   "data\n", __func__);
 		rval = -ENOMEM;
-		goto unmap_sg;
+		goto leave;
 	}
 
-	ha->flash_state = QLFLASH_WRITING;
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 			  bsg_job->request_payload.sg_cnt, flash, length);
 
-	if (qla4xxx_set_flash(ha, flash_dma, offset, length, options))
-		bsg_reply->result = (DID_ERROR << 16);
-	else {
-		bsg_reply->result = DID_OK;
-		bsg_reply->reply_payload_rcv_len = length;
-	}
-
-	if (flash)
-		dma_free_coherent(&ha->pdev->dev, length, flash, flash_dma);
+	rval = qla4xxx_set_flash(ha, flash_dma, offset, length, options);
+	if (rval) {
+		ql4_printk(KERN_ERR, ha, "%s: set flash failed\n", __func__);
+		bsg_reply->result = DID_ERROR << 16;
+		rval = -EIO;
+	} else
+		bsg_reply->result = DID_OK << 16;
+
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+	dma_free_coherent(&ha->pdev->dev, length, flash, flash_dma);
+leave:
 	ha->flash_state = QLFLASH_WAITING;
-unmap_sg:
-	dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
-		     bsg_job->reply_payload.sg_cnt, DMA_TO_DEVICE);
-
-	if (!rval)
-		bsg_job_done(bsg_job, bsg_reply->result,
-			     bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 90dc621..74c71af 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -803,6 +803,16 @@ static inline void ql4xxx_unlock_drvr(struct scsi_qla_host *a)
 		ql4xxx_sem_unlock(a, QL4022_DRVR_SEM_MASK);
 }
 
+static inline int ql4xxx_reset_active(struct scsi_qla_host *ha)
+{
+	return test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags) ||
+	       test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
+	       test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags) ||
+	       test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
+	       test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags) ||
+	       test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags);
+
+}
 /*---------------------------------------------------------------------------*/
 
 /* Defines for qla4xxx_initialize_adapter() and qla4xxx_recover_adapter() */
-- 
1.7.6


