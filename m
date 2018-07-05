From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 3/4] scsi: lpfc: remove ScsiResult macro
Date: Thu,  5 Jul 2018 13:01:39 +0200
Message-ID: <20180705110140.19545-4-jthumshirn@suse.de>
References: <20180705110140.19545-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705110140.19545-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Remove the ScsiResult macro and open code it on all call sites.

This will make subsequent refactoring in this area easier.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h |  1 -
 drivers/scsi/lpfc/lpfc_scsi.c | 44 +++++++++++++++++++++----------------------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 4ae9ba425e78..30f9e3ff6cb5 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -469,7 +469,6 @@ int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 void lpfc_start_fdiscs(struct lpfc_hba *phba);
 struct lpfc_vport *lpfc_find_vport_by_vpid(struct lpfc_hba *, uint16_t);
 struct lpfc_sglq *__lpfc_get_active_sglq(struct lpfc_hba *, uint16_t);
-#define ScsiResult(host_code, scsi_code) (((host_code) << 16) | scsi_code)
 #define HBA_EVENT_RSCN                   5
 #define HBA_EVENT_LINK_UP                2
 #define HBA_EVENT_LINK_DOWN              3
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index a94fb9f8bb44..924d7d672e9f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3017,8 +3017,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 	if (err_type == BGS_GUARD_ERR_MASK) {
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 					0x10, 0x1);
-		cmd->result = DRIVER_SENSE << 24
-			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
+		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+			      SAM_STAT_CHECK_CONDITION;
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9069 BLKGRD: LBA %lx grd_tag error %x != %x\n",
@@ -3028,8 +3028,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 					0x10, 0x3);
-		cmd->result = DRIVER_SENSE << 24
-			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
+		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+			      SAM_STAT_CHECK_CONDITION;
 
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -3040,8 +3040,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 					0x10, 0x2);
-		cmd->result = DRIVER_SENSE << 24
-			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
+		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+			      SAM_STAT_CHECK_CONDITION;
 
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -3096,7 +3096,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd,
 	spin_unlock(&_dump_buf_lock);
 
 	if (lpfc_bgs_get_invalid_prof(bgstat)) {
-		cmd->result = ScsiResult(DID_ERROR, 0);
+		cmd->result = DID_ERROR << 16;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9072 BLKGRD: Invalid BG Profile in cmd"
 				" 0x%x lba 0x%llx blk cnt 0x%x "
@@ -3108,7 +3108,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd,
 	}
 
 	if (lpfc_bgs_get_uninit_dif_block(bgstat)) {
-		cmd->result = ScsiResult(DID_ERROR, 0);
+		cmd->result = DID_ERROR << 16;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9073 BLKGRD: Invalid BG PDIF Block in cmd"
 				" 0x%x lba 0x%llx blk cnt 0x%x "
@@ -3124,8 +3124,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 				0x10, 0x1);
-		cmd->result = DRIVER_SENSE << 24
-			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
+		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+			      SAM_STAT_CHECK_CONDITION;
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9055 BLKGRD: Guard Tag error in cmd"
@@ -3140,8 +3140,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 				0x10, 0x3);
-		cmd->result = DRIVER_SENSE << 24
-			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
+		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+			      SAM_STAT_CHECK_CONDITION;
 
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -3157,8 +3157,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 				0x10, 0x2);
-		cmd->result = DRIVER_SENSE << 24
-			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
+		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+			      SAM_STAT_CHECK_CONDITION;
 
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -3866,7 +3866,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 	}
 
  out:
-	cmnd->result = ScsiResult(host_status, scsi_status);
+	cmnd->result = host_status << 16 | scsi_status;
 	lpfc_send_scsi_error_event(vport->phba, vport, lpfc_cmd, rsp_iocb);
 }
 
@@ -4019,7 +4019,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			break;
 		case IOSTAT_NPORT_BSY:
 		case IOSTAT_FABRIC_BSY:
-			cmd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
+			cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 			fast_path_evt = lpfc_alloc_fast_evt(phba);
 			if (!fast_path_evt)
 				break;
@@ -4053,14 +4053,14 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			    lpfc_cmd->result == IOERR_ELXSEC_CRYPTO_ERROR ||
 			    lpfc_cmd->result ==
 					IOERR_ELXSEC_CRYPTO_COMPARE_ERROR) {
-				cmd->result = ScsiResult(DID_NO_CONNECT, 0);
+				cmd->result = DID_NO_CONNECT << 16;
 				break;
 			}
 			if (lpfc_cmd->result == IOERR_INVALID_RPI ||
 			    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 			    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
 			    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
-				cmd->result = ScsiResult(DID_REQUEUE, 0);
+				cmd->result = DID_REQUEUE << 16;
 				break;
 			}
 			if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
@@ -4094,16 +4094,16 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			}
 		/* else: fall through */
 		default:
-			cmd->result = ScsiResult(DID_ERROR, 0);
+			cmd->result = DID_ERROR << 16;
 			break;
 		}
 
 		if (!pnode || !NLP_CHK_NODE_ACT(pnode)
 		    || (pnode->nlp_state != NLP_STE_MAPPED_NODE))
-			cmd->result = ScsiResult(DID_TRANSPORT_DISRUPTED,
-						 SAM_STAT_BUSY);
+			cmd->result = DID_TRANSPORT_DISRUPTED << 16 |
+				      SAM_STAT_BUSY;
 	} else
-		cmd->result = ScsiResult(DID_OK, 0);
+		cmd->result = DID_OK << 16;
 
 	if (cmd->result || lpfc_cmd->fcp_rsp->rspSnsLen) {
 		uint32_t *lp = (uint32_t *)cmd->sense_buffer;
-- 
2.16.4
