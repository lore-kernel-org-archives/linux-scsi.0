From: James Smart <james.smart@emulex.com>
Subject: [PATCH 19/21] lpfc: Fix for lun discovery issue with 8Gig adapter.
Date: Thu, 5 Feb 2015 14:25:59 -0500
Message-ID: <1423164359.7917.44.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:47598 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbbBET0J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 14:26:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


---
 drivers/scsi/lpfc/lpfc_scsi.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index fbdc39c..e900902 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1134,6 +1134,25 @@ lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 }
 
 /**
+ * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB
+ * @data: A pointer to the immediate command data portion of the IOCB.
+ * @fcp_cmnd: The FCP Command that is provided by the SCSI layer.
+ *
+ * The routine copies the entire FCP command from @fcp_cmnd to @data while
+ * byte swapping the data to big endian format for transmission on the wire.
+ **/
+static void
+lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
+{
+	int i, j;
+
+	for (i = 0, j = 0; i < sizeof(struct fcp_cmnd);
+	     i += sizeof(uint32_t), j++) {
+		((uint32_t *)data)[j] = cpu_to_be32(((uint32_t *)fcp_cmnd)[j]);
+	}
+}
+
+/**
  * lpfc_scsi_prep_dma_buf_s3 - DMA mapping for scsi buffer to SLI3 IF spec
  * @phba: The Hba for which this call is being executed.
  * @lpfc_cmd: The scsi buffer which is going to be mapped.
@@ -1268,6 +1287,7 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 	 * we need to set word 4 of IOCB here
 	 */
 	iocb_cmd->un.fcpi.fcpi_parm = scsi_bufflen(scsi_cmnd);
+	lpfc_fcpcmd_to_iocb(iocb_cmd->unsli3.fcp_ext.icd, fcp_cmnd);
 	return 0;
 }
 
@@ -4177,24 +4197,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 }
 
 /**
- * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB
- * @data: A pointer to the immediate command data portion of the IOCB.
- * @fcp_cmnd: The FCP Command that is provided by the SCSI layer.
- *
- * The routine copies the entire FCP command from @fcp_cmnd to @data while
- * byte swapping the data to big endian format for transmission on the wire.
- **/
-static void
-lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
-{
-	int i, j;
-	for (i = 0, j = 0; i < sizeof(struct fcp_cmnd);
-	     i += sizeof(uint32_t), j++) {
-		((uint32_t *)data)[j] = cpu_to_be32(((uint32_t *)fcp_cmnd)[j]);
-	}
-}
-
-/**
  * lpfc_scsi_prep_cmnd - Wrapper func for convert scsi cmnd to FCP info unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: The scsi command which needs to send.
@@ -4277,9 +4279,6 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		fcp_cmnd->fcpCntl3 = 0;
 		phba->fc4ControlRequests++;
 	}
-	if (phba->sli_rev == 3 &&
-	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED))
-		lpfc_fcpcmd_to_iocb(iocb_cmd->unsli3.fcp_ext.icd, fcp_cmnd);
 	/*
 	 * Finish initializing those IOCB fields that are independent
 	 * of the scsi_cmnd request_buffer
-- 
1.7.11.7

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>



