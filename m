From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/23] advansys: Check for DMA mapping errors
Date: Fri, 24 Apr 2015 13:18:39 +0200
Message-ID: <1429874322-85488-22-git-send-email-hare@suse.de>
References: <1429874322-85488-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967109AbbDXLSw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 07:18:52 -0400
In-Reply-To: <1429874322-85488-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

DMA mapping might fail, so we need to check for errors here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 5a55272..485eaf0 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7514,6 +7514,10 @@ static __le32 advansys_get_sense_buffer_dma(struct scsi_cmnd *scp)
 	struct asc_board *board = shost_priv(scp->device->host);
 	scp->SCp.dma_handle = dma_map_single(board->dev, scp->sense_buffer,
 					     SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(board->dev, scp->SCp.dma_handle)) {
+		ASC_DBG(1, "failed to map sense buffer\n");
+		return 0;
+	}
 	dma_cache_sync(board->dev, scp->sense_buffer,
 		       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	return cpu_to_le32(scp->SCp.dma_handle);
@@ -7546,6 +7550,8 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
 	asc_scsi_q->q1.sense_addr = advansys_get_sense_buffer_dma(scp);
 	asc_scsi_q->q1.sense_len = SCSI_SENSE_BUFFERSIZE;
+	if (!asc_scsi_q->q1.sense_addr)
+		return ASC_BUSY;
 
 	/*
 	 * If there are any outstanding requests for the current target,
@@ -7567,7 +7573,10 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 
 	/* Build ASC_SCSI_Q */
 	use_sg = scsi_dma_map(scp);
-	if (use_sg != 0) {
+	if (use_sg < 0) {
+		ASC_DBG(1, "failed to map sglist\n");
+		return ASC_BUSY;
+	} else if (use_sg > 0) {
 		int sgcnt;
 		struct scatterlist *slp;
 		struct asc_sg_head *asc_sg_head;
@@ -7799,13 +7808,22 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 
 	sense_addr = dma_map_single(boardp->dev, scp->sense_buffer,
 				    SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(boardp->dev, sense_addr)) {
+		ASC_DBG(1, "failed to map sense buffer\n");
+		ASC_STATS(scp->device->host, adv_build_noreq);
+		return ASC_BUSY;
+	}
 	scsiqp->sense_addr = cpu_to_le32(sense_addr);
 	scsiqp->sense_len = cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
 
 	/* Build ADV_SCSI_REQ_Q */
 
 	use_sg = scsi_dma_map(scp);
-	if (use_sg == 0) {
+	if (use_sg < 0) {
+		ASC_DBG(1, "failed to map SG list\n");
+		ASC_STATS(scp->device->host, adv_build_noreq);
+		return ASC_BUSY;
+	} else if (use_sg == 0) {
 		/* Zero-length transfer */
 		reqp->sgblkp = NULL;
 		scsiqp->data_cnt = 0;
@@ -8473,11 +8491,10 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 		struct asc_scsi_q asc_scsi_q;
 
-		/* asc_build_req() can not return ASC_BUSY. */
 		ret = asc_build_req(boardp, scp, &asc_scsi_q);
-		if (ret == ASC_ERROR) {
+		if (ret != ASC_NOERROR) {
 			ASC_STATS(scp->device->host, build_error);
-			return ASC_ERROR;
+			return ret;
 		}
 
 		ret = AscExeScsiQueue(asc_dvc, &asc_scsi_q);
-- 
1.8.5.2

