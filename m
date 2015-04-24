From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/23] advansys: use DMA-API for mapping sense buffer
Date: Fri, 24 Apr 2015 13:18:22 +0200
Message-ID: <1429874322-85488-5-git-send-email-hare@suse.de>
References: <1429874322-85488-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966609AbbDXLSs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 07:18:48 -0400
In-Reply-To: <1429874322-85488-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index b595e8b..dba8c1a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1844,7 +1844,7 @@ typedef struct adv_scsi_req_q {
 	uchar target_lun;	/* Device target logical unit number. */
 	ADV_PADDR data_addr;	/* Data buffer physical address. */
 	ADV_DCNT data_cnt;	/* Data count. Ucode sets to residual. */
-	ADV_PADDR sense_addr;
+	__le32 sense_addr;
 	ADV_PADDR carr_pa;
 	uchar mflag;
 	uchar sense_len;
@@ -6084,6 +6084,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	adv_sgblk_t *sgblkp;
 	struct scsi_cmnd *scp;
 	ADV_DCNT resid_cnt;
+	dma_addr_t sense_addr;
 
 	ASC_DBG(1, "adv_dvc_varp 0x%p, scsiqp 0x%p\n",
 		adv_dvc_varp, scsiqp);
@@ -6121,6 +6122,10 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	ASC_STATS(boardp->shost, callback);
 	ASC_DBG(1, "shost 0x%p\n", boardp->shost);
 
+	sense_addr = le32_to_cpu(scsiqp->sense_addr);
+	dma_unmap_single(boardp->dev, sense_addr,
+			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+
 	/*
 	 * 'done_status' contains the command's ending status.
 	 */
@@ -8018,9 +8023,9 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	u32 srb_tag = scp->request->tag;
 	adv_req_t *reqp;
 	ADV_SCSI_REQ_Q *scsiqp;
-	int i;
 	int ret;
 	int use_sg;
+	dma_addr_t sense_addr;
 
 	/*
 	 * Allocate an adv_req_t structure from the board to execute
@@ -8061,19 +8066,21 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
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
 
 	/* Build ADV_SCSI_REQ_Q */
 
-- 
1.8.5.2

