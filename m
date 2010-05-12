From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/7] lpfc 8.3.13: SCSI specific changes
Date: Wed, 12 May 2010 09:31:44 -0400
Message-ID: <1273671124.24670.19.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16386 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753978Ab0ELNcq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 09:32:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Fix hba_queue_depth to reflect actual available XRIs
- Add support for new SLER specific firmware status codes.
- Free SCSI buffer when iotag allocation fails.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw.h   |    8 ++++++++
 lpfc_init.c |    7 +++++--
 lpfc_scsi.c |    5 ++++-
 3 files changed, 17 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-05-12 09:02:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-05-12 09:03:12.000000000 -0400
@@ -3124,6 +3124,14 @@ typedef struct {
 #define IOERR_BUFFER_SHORTAGE         0x28
 #define IOERR_DEFAULT                 0x29
 #define IOERR_CNT                     0x2A
+#define IOERR_SLER_FAILURE            0x46
+#define IOERR_SLER_CMD_RCV_FAILURE    0x47
+#define IOERR_SLER_REC_RJT_ERR        0x48
+#define IOERR_SLER_REC_SRR_RETRY_ERR  0x49
+#define IOERR_SLER_SRR_RJT_ERR        0x4A
+#define IOERR_SLER_RRQ_RJT_ERR        0x4C
+#define IOERR_SLER_RRQ_RETRY_ERR      0x4D
+#define IOERR_SLER_ABTS_ERR           0x4E
 
 #define IOERR_DRVR_MASK               0x100
 #define IOERR_SLI_DOWN                0x101  /* ulpStatus  - Driver defined */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-05-12 09:02:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-05-12 09:03:12.000000000 -0400
@@ -5563,9 +5563,12 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	/* Reset the DFT_HBA_Q_DEPTH to the max xri  */
-	if (phba->cfg_hba_queue_depth > (phba->sli4_hba.max_cfg_param.max_xri))
+	if (phba->cfg_hba_queue_depth >
+		(phba->sli4_hba.max_cfg_param.max_xri -
+			lpfc_sli4_get_els_iocb_cnt(phba)))
 		phba->cfg_hba_queue_depth =
-				phba->sli4_hba.max_cfg_param.max_xri;
+			phba->sli4_hba.max_cfg_param.max_xri -
+				lpfc_sli4_get_els_iocb_cnt(phba);
 	return rc;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-05-12 09:03:12.000000000 -0400
@@ -774,6 +774,8 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 		/* Allocate iotag for psb->cur_iocbq. */
 		iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
 		if (iotag == 0) {
+			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
+				psb->data, psb->dma_handle);
 			kfree(psb);
 			break;
 		}
@@ -2363,7 +2365,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		case IOSTAT_LOCAL_REJECT:
 			if (lpfc_cmd->result == IOERR_INVALID_RPI ||
 			    lpfc_cmd->result == IOERR_NO_RESOURCES ||
-			    lpfc_cmd->result == IOERR_ABORT_REQUESTED) {
+			    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
+			    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
 				cmd->result = ScsiResult(DID_REQUEUE, 0);
 				break;
 			}


