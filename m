From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/12] advansys: use DMA-API for mapping sense buffer
Date: Wed,  3 Dec 2014 12:44:56 +0100
Message-ID: <1417607105-85455-4-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbaLCLpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:12 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 6af2a52..4979e5a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -309,7 +309,7 @@ typedef struct asc_scsiq_1 {
 	uchar target_lun;
 	ASC_PADDR data_addr;
 	ASC_DCNT data_cnt;
-	ASC_PADDR sense_addr;
+	__le32 sense_addr;
 	uchar sense_len;
 	uchar extra_bytes;
 } ASC_SCSIQ_1;
@@ -6110,6 +6110,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	adv_sgblk_t *sgblkp;
 	struct scsi_cmnd *scp;
 	ADV_DCNT resid_cnt;
+	dma_addr_t sense_addr;
 
 	ASC_DBG(1, "adv_dvc_varp 0x%p, scsiqp 0x%p\n",
 		adv_dvc_varp, scsiqp);
@@ -6147,6 +6148,10 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	ASC_STATS(boardp->shost, callback);
 	ASC_DBG(1, "shost 0x%p\n", boardp->shost);
 
+	sense_addr = le32_to_cpu(scsiqp->sense_addr);
+	dma_unmap_single(boardp->dev, sense_addr,
+			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+
 	/*
 	 * 'done_status' contains the command's ending status.
 	 */
@@ -7930,18 +7935,16 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
  *      ADV_ERROR(-1) - SG List creation failed
  */
 static int
-adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
-	       int use_sg)
+adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp,
+	       ADV_SCSI_REQ_Q *scsiqp, struct scsi_cmnd *scp, int use_sg)
 {
 	adv_sgblk_t *sgblkp;
-	ADV_SCSI_REQ_Q *scsiqp;
 	struct scatterlist *slp;
 	int sg_elem_cnt;
 	ADV_SG_BLOCK *sg_block, *prev_sg_block;
 	ADV_PADDR sg_block_paddr;
 	int i;
 
-	scsiqp = (ADV_SCSI_REQ_Q *)ADV_32BALIGN(&reqp->scsi_req_q);
 	slp = scsi_sglist(scp);
 	sg_elem_cnt = use_sg;
 	prev_sg_block = NULL;
@@ -8046,9 +8049,9 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	u32 srb_tag = scp->request->tag;
 	adv_req_t *reqp;
 	ADV_SCSI_REQ_Q *scsiqp;
-	int i;
 	int ret;
 	int use_sg;
+	dma_addr_t sense_addr;
 
 	/*
 	 * Allocate an adv_req_t structure from the board to execute
@@ -8091,19 +8094,23 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	/* Set CDB length and copy it to the request structure.  */
 	scsiqp->cdb_len = scp->cmd_len;
 	/* Copy first 12 CDB bytes to cdb[]. */
-	for (i = 0; i < scp->cmd_len && i < 12; i++) {
-		scsiqp->cdb[i] = scp->cmnd[i];
-	}
+	memcpy(scsiqp->cdb, scp->cmnd, scp->cmd_len < 12 ? scp->cmd_len : 12);
 	/* Copy last 4 CDB bytes, if present, to cdb16[]. */
-	for (; i < scp->cmd_len; i++) {
-		scsiqp->cdb16[i - 12] = scp->cmnd[i];
+	if (scp->cmd_len > 12) {
+		int cdb16_len = scp->cmd_len - 12;
+
+		memcpy(scsiqp->cdb16, &scp->cmnd[12], cdb16_len);
 	}
 
 	scsiqp->target_id = scp->device->id;
 	scsiqp->target_lun = scp->device->lun;
 
-	scsiqp->sense_addr = cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
-	scsiqp->sense_len = SCSI_SENSE_BUFFERSIZE;
+	sense_addr = dma_map_single(boardp->dev, scp->sense_buffer,
+				    SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+	scsiqp->sense_addr = cpu_to_le32(sense_addr);
+	scsiqp->sense_len = cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
+	dma_cache_sync(boardp->dev, scp->sense_buffer,
+		       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 
 	/* Build ADV_SCSI_REQ_Q */
 
@@ -8132,7 +8139,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 
 		scsiqp->data_cnt = cpu_to_le32(scsi_bufflen(scp));
 
-		ret = adv_get_sglist(boardp, reqp, scp, use_sg);
+		ret = adv_get_sglist(boardp, reqp, scsiqp, scp, use_sg);
 		if (ret != ADV_SUCCESS) {
 			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_ERROR);
-- 
1.8.5.2

