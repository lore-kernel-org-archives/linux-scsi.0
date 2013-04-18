From: James Smart <james.smart@emulex.com>
Subject: [PATCH 10/22] lpfc 8.3.39: Fixed crash when processing bsg's sg
 list with high memory pages
Date: Wed, 17 Apr 2013 20:17:26 -0400
Message-ID: <1366244246.1513.11.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:15673 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935876Ab3DRAR2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:17:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed crash when processing bsg's sg list with high memory pages


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |   33 +++++++++++++++++++++++----------
 lpfc_sli.c |    3 +--
 2 files changed, 24 insertions(+), 12 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2013-04-15 18:26:24.122040826 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2013-04-15 18:26:39.363041173 -0400
@@ -219,26 +219,35 @@ lpfc_bsg_copy_data(struct lpfc_dmabuf *d
 	unsigned int transfer_bytes, bytes_copied = 0;
 	unsigned int sg_offset, dma_offset;
 	unsigned char *dma_address, *sg_address;
-	struct scatterlist *sgel;
 	LIST_HEAD(temp_list);
-
+	struct sg_mapping_iter miter;
+	unsigned long flags;
+	unsigned int sg_flags = SG_MITER_ATOMIC;
+	bool sg_valid;
 
 	list_splice_init(&dma_buffers->list, &temp_list);
 	list_add(&dma_buffers->list, &temp_list);
 	sg_offset = 0;
-	sgel = bsg_buffers->sg_list;
+	if (to_buffers)
+		sg_flags |= SG_MITER_FROM_SG;
+	else
+		sg_flags |= SG_MITER_TO_SG;
+	sg_miter_start(&miter, bsg_buffers->sg_list, bsg_buffers->sg_cnt,
+		       sg_flags);
+	local_irq_save(flags);
+	sg_valid = sg_miter_next(&miter);
 	list_for_each_entry(mp, &temp_list, list) {
 		dma_offset = 0;
-		while (bytes_to_transfer && sgel &&
+		while (bytes_to_transfer && sg_valid &&
 		       (dma_offset < LPFC_BPL_SIZE)) {
 			dma_address = mp->virt + dma_offset;
 			if (sg_offset) {
 				/* Continue previous partial transfer of sg */
-				sg_address = sg_virt(sgel) + sg_offset;
-				transfer_bytes = sgel->length - sg_offset;
+				sg_address = miter.addr + sg_offset;
+				transfer_bytes = miter.length - sg_offset;
 			} else {
-				sg_address = sg_virt(sgel);
-				transfer_bytes = sgel->length;
+				sg_address = miter.addr;
+				transfer_bytes = miter.length;
 			}
 			if (bytes_to_transfer < transfer_bytes)
 				transfer_bytes = bytes_to_transfer;
@@ -252,12 +261,14 @@ lpfc_bsg_copy_data(struct lpfc_dmabuf *d
 			sg_offset += transfer_bytes;
 			bytes_to_transfer -= transfer_bytes;
 			bytes_copied += transfer_bytes;
-			if (sg_offset >= sgel->length) {
+			if (sg_offset >= miter.length) {
 				sg_offset = 0;
-				sgel = sg_next(sgel);
+				sg_valid = sg_miter_next(&miter);
 			}
 		}
 	}
+	sg_miter_stop(&miter);
+	local_irq_restore(flags);
 	list_del_init(&dma_buffers->list);
 	list_splice(&temp_list, &dma_buffers->list);
 	return bytes_copied;
@@ -471,6 +482,7 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job
 	cmdiocbq->context1 = dd_data;
 	cmdiocbq->context2 = cmp;
 	cmdiocbq->context3 = bmp;
+	cmdiocbq->context_un.ndlp = ndlp;
 	dd_data->type = TYPE_IOCB;
 	dd_data->set_job = job;
 	dd_data->context_un.iocb.cmdiocbq = cmdiocbq;
@@ -1508,6 +1520,7 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba,
 	ctiocb->context1 = dd_data;
 	ctiocb->context2 = cmp;
 	ctiocb->context3 = bmp;
+	ctiocb->context_un.ndlp = ndlp;
 	ctiocb->iocb_cmpl = lpfc_issue_ct_rsp_cmp;
 
 	dd_data->type = TYPE_IOCB;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:35.021041074 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:39.379041174 -0400
@@ -926,8 +926,7 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phb
 	} else  if ((piocbq->iocb.ulpCommand == CMD_GEN_REQUEST64_CR) &&
 			!(piocbq->iocb_flag & LPFC_IO_LIBDFC))
 		ndlp = piocbq->context_un.ndlp;
-	else  if ((piocbq->iocb.ulpCommand == CMD_ELS_REQUEST64_CR) &&
-			(piocbq->iocb_flag & LPFC_IO_LIBDFC))
+	else  if (piocbq->iocb_flag & LPFC_IO_LIBDFC)
 		ndlp = piocbq->context_un.ndlp;
 	else
 		ndlp = piocbq->context1;



