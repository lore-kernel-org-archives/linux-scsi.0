Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6A4C43470
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0051613B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbhD0IcB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:32:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:49422 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235124AbhD0Ibv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:31:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 46604B01F;
        Tue, 27 Apr 2021 08:31:06 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/40] scsi: introduce scsi_build_sense()
Date:   Tue, 27 Apr 2021 10:30:13 +0200
Message-Id: <20210427083046.31620-8-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427083046.31620-1-hare@suse.de>
References: <20210427083046.31620-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce scsi_build_sense() as a wrapper around
scsi_build_sense_buffer() to format the buffer and set
the correct SCSI status.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/libata-scsi.c             |  7 +--
 drivers/s390/scsi/zfcp_scsi.c         |  5 +--
 drivers/scsi/3w-xxxx.c                |  2 +-
 drivers/scsi/libiscsi.c               |  5 +--
 drivers/scsi/lpfc/lpfc_scsi.c         | 54 ++++++++--------------
 drivers/scsi/megaraid.c               |  8 ++--
 drivers/scsi/megaraid/megaraid_mbox.c | 14 +++---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  | 14 ++----
 drivers/scsi/mvumi.c                  |  5 +--
 drivers/scsi/myrb.c                   | 64 +++++++--------------------
 drivers/scsi/myrs.c                   |  9 +---
 drivers/scsi/ps3rom.c                 |  7 +--
 drivers/scsi/qla2xxx/qla_isr.c        | 15 ++-----
 drivers/scsi/scsi_debug.c             | 11 ++---
 drivers/scsi/scsi_lib.c               | 18 ++++++++
 drivers/scsi/smartpqi/smartpqi_init.c |  3 +-
 drivers/scsi/stex.c                   |  5 +--
 include/scsi/scsi_cmnd.h              |  3 ++
 18 files changed, 85 insertions(+), 164 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c5129b9e3afd..10d0ef9e969d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -196,9 +196,7 @@ void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
 	if (!cmd)
 		return;
 
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-
-	scsi_build_sense_buffer(d_sense, cmd->sense_buffer, sk, asc, ascq);
+	scsi_build_sense(cmd, d_sense, sk, asc, ascq);
 }
 
 void ata_scsi_set_sense_information(struct ata_device *dev,
@@ -882,8 +880,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 		 * ATA PASS-THROUGH INFORMATION AVAILABLE
 		 * Always in descriptor format sense.
 		 */
-		scsi_build_sense_buffer(1, cmd->sense_buffer,
-					RECOVERED_ERROR, 0, 0x1D);
+		scsi_build_sense(cmd, 1, RECOVERED_ERROR, 0, 0x1D);
 	}
 
 	if ((cmd->sense_buffer[0] & 0x7f) >= 0x72) {
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index d58bf79892f2..9da9b2b2a580 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -856,10 +856,7 @@ void zfcp_scsi_set_prot(struct zfcp_adapter *adapter)
  */
 void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, int ascq)
 {
-	scsi_build_sense_buffer(1, scmd->sense_buffer,
-				ILLEGAL_REQUEST, 0x10, ascq);
-	set_driver_byte(scmd, DRIVER_SENSE);
-	scmd->result |= SAM_STAT_CHECK_CONDITION;
+	scsi_build_sense(scmd, 1, ILLEGAL_REQUEST, 0x10, ascq);
 	set_host_byte(scmd, DID_SOFT_ERROR);
 }
 
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index a7292883b72b..7a0b4a44395d 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1977,7 +1977,7 @@ static int tw_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_c
 		printk(KERN_NOTICE "3w-xxxx: scsi%d: Unknown scsi opcode: 0x%x\n", tw_dev->host->host_no, *command);
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		tw_state_request_finish(tw_dev, request_id);
-		scsi_build_sense_buffer(1, SCpnt->sense_buffer, ILLEGAL_REQUEST, 0x20, 0);
+		scsi_build_sense(SCpnt, 1, ILLEGAL_REQUEST, 0x20, 0);
 		done(SCpnt);
 		retval = 0;
 	}
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7ad11e42306d..3a485ad0204e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -829,10 +829,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 		ascq = session->tt->check_protection(task, &sector);
 		if (ascq) {
-			sc->result = DRIVER_SENSE << 24 |
-				     SAM_STAT_CHECK_CONDITION;
-			scsi_build_sense_buffer(1, sc->sense_buffer,
-						ILLEGAL_REQUEST, 0x10, ascq);
+			scsi_build_sense(sc, 1, ILLEGAL_REQUEST, 0x10, ascq);
 			scsi_set_sense_information(sc->sense_buffer,
 						   SCSI_SENSE_BUFFERSIZE,
 						   sector);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index eefbb9b22798..c478f1b45006 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2869,10 +2869,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	}
 out:
 	if (err_type == BGS_GUARD_ERR_MASK) {
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-					0x10, 0x1);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
-			      SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
+		set_host_byte(cmd, DID_ABORT);
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9069 BLKGRD: reftag %x grd_tag err %x != %x\n",
@@ -2880,10 +2878,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 				sum, guard_tag);
 
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-					0x10, 0x3);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
-			      SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
+		set_host_byte(cmd, DID_ABORT);
 
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -2892,10 +2888,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 				ref_tag, start_ref_tag);
 
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-					0x10, 0x2);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
-			      SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
+		set_host_byte(cmd, DID_ABORT);
 
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -2954,10 +2948,8 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (lpfc_bgs_get_guard_err(bgstat)) {
 		ret = 1;
 
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-					0x10, 0x1);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
-			      SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
+		set_host_byte(cmd, DID_ABORT);
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9059 BLKGRD: Guard Tag error in cmd"
@@ -2970,10 +2962,8 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
 		ret = 1;
 
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-					0x10, 0x3);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
-			      SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
+		set_host_byte(cmd, DID_ABORT);
 
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -2987,10 +2977,8 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
 		ret = 1;
 
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-					0x10, 0x2);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
-			      SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
+		set_host_byte(cmd, DID_ABORT);
 
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -3100,10 +3088,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (lpfc_bgs_get_guard_err(bgstat)) {
 		ret = 1;
 
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-				0x10, 0x1);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
-			      SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
+		set_host_byte(cmd, DID_ABORT);
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9055 BLKGRD: Guard Tag error in cmd "
@@ -3116,10 +3102,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
 		ret = 1;
 
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-				0x10, 0x3);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
-			      SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
+		set_host_byte(cmd, DID_ABORT);
 
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -3133,10 +3117,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
 		ret = 1;
 
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-				0x10, 0x2);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
-			      SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
+		set_host_byte(cmd, DID_ABORT);
 
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 80f546976c7e..ae3f32f89381 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1596,11 +1596,9 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 					cmd->result = (DRIVER_SENSE << 24) |
 						(DID_OK << 16) |
 						(CHECK_CONDITION << 1);
-				} else {
-					cmd->sense_buffer[0] = 0x70;
-					cmd->sense_buffer[2] = ABORTED_COMMAND;
-					cmd->result |= (CHECK_CONDITION << 1);
-				}
+				} else
+					scsi_build_sense(cmd, 0,
+							 ABORTED_COMMAND, 0, 0);
 			}
 			break;
 
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index b1a2d3536add..6a5b844a8499 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1574,10 +1574,8 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			}
 
 			if (scp->cmnd[1] & MEGA_SCSI_INQ_EVPD) {
-				scp->sense_buffer[0] = 0x70;
-				scp->sense_buffer[2] = ILLEGAL_REQUEST;
-				scp->sense_buffer[12] = MEGA_INVALID_FIELD_IN_CDB;
-				scp->result = CHECK_CONDITION << 1;
+				scsi_build_sense(scp, 0, ILLEGAL_REQUEST,
+						 MEGA_INVALID_FIELD_IN_CDB, 0);
 				return NULL;
 			}
 
@@ -2313,11 +2311,9 @@ megaraid_mbox_dpc(unsigned long devp)
 					scp->result = DRIVER_SENSE << 24 |
 						DID_OK << 16 |
 						CHECK_CONDITION << 1;
-				} else {
-					scp->sense_buffer[0] = 0x70;
-					scp->sense_buffer[2] = ABORTED_COMMAND;
-					scp->result = CHECK_CONDITION << 1;
-				}
+				} else
+					scsi_build_sense(scp, 0,
+							 ABORTED_COMMAND, 0, 0);
 			}
 			break;
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d00aca3c77ce..fbfbf40a3f66 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5077,10 +5077,8 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 		ascq = 0x00;
 		break;
 	}
-	scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST, 0x10,
-	    ascq);
-	scmd->result = DRIVER_SENSE << 24 | (DID_ABORT << 16) |
-	    SAM_STAT_CHECK_CONDITION;
+	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x10, ascq);
+	set_host_byte(scmd, DID_ABORT);
 }
 
 /**
@@ -5837,12 +5835,8 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		else if (!xfer_cnt && scmd->cmnd[0] == REPORT_LUNS) {
 			mpi_reply->SCSIState = MPI2_SCSI_STATE_AUTOSENSE_VALID;
 			mpi_reply->SCSIStatus = SAM_STAT_CHECK_CONDITION;
-			scmd->result = (DRIVER_SENSE << 24) |
-			    SAM_STAT_CHECK_CONDITION;
-			scmd->sense_buffer[0] = 0x70;
-			scmd->sense_buffer[2] = ILLEGAL_REQUEST;
-			scmd->sense_buffer[12] = 0x20;
-			scmd->sense_buffer[13] = 0;
+			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST,
+					 0x20, 0);
 		}
 		break;
 
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 9d5743627604..94f706eeb561 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2068,10 +2068,7 @@ static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
 	return 0;
 
 error:
-	scmd->result = (DID_OK << 16) | (DRIVER_SENSE << 24) |
-		SAM_STAT_CHECK_CONDITION;
-	scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST, 0x24,
-									0);
+	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 	return -1;
 }
 
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index d9c82e211ae7..542ed88ef90d 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1397,8 +1397,7 @@ myrb_mode_sense(struct myrb_hba *cb, struct scsi_cmnd *scmd,
 static void myrb_request_sense(struct myrb_hba *cb,
 		struct scsi_cmnd *scmd)
 {
-	scsi_build_sense_buffer(0, scmd->sense_buffer,
-				NO_SENSE, 0, 0);
+	scsi_build_sense(scmd, 0, NO_SENSE, 0, 0);
 	scsi_sg_copy_from_buffer(scmd, scmd->sense_buffer,
 				 SCSI_SENSE_BUFFERSIZE);
 }
@@ -1447,10 +1446,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case INQUIRY:
 		if (scmd->cmnd[1] & 1) {
 			/* Illegal request, invalid field in CDB */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 		} else {
 			myrb_inquiry(cb, scmd);
 			scmd->result = (DID_OK << 16);
@@ -1465,10 +1461,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		if ((scmd->cmnd[2] & 0x3F) != 0x3F &&
 		    (scmd->cmnd[2] & 0x3F) != 0x08) {
 			/* Illegal request, invalid field in CDB */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 		} else {
 			myrb_mode_sense(cb, scmd, ldev_info);
 			scmd->result = (DID_OK << 16);
@@ -1479,20 +1472,14 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		if ((scmd->cmnd[1] & 1) ||
 		    (scmd->cmnd[8] & 1)) {
 			/* Illegal request, invalid field in CDB */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 			scmd->scsi_done(scmd);
 			return 0;
 		}
 		lba = get_unaligned_be32(&scmd->cmnd[2]);
 		if (lba) {
 			/* Illegal request, invalid field in CDB */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 			scmd->scsi_done(scmd);
 			return 0;
 		}
@@ -1506,10 +1493,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case SEND_DIAGNOSTIC:
 		if (scmd->cmnd[1] != 0x04) {
 			/* Illegal request, invalid field in CDB */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						ILLEGAL_REQUEST, 0x24, 0);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 		} else {
 			/* Assume good status */
 			scmd->result = (DID_OK << 16);
@@ -1519,10 +1503,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case READ_6:
 		if (ldev_info->state == MYRB_DEVICE_WO) {
 			/* Data protect, attempt to read invalid data */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						DATA_PROTECT, 0x21, 0x06);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
 			scmd->scsi_done(scmd);
 			return 0;
 		}
@@ -1536,10 +1517,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case READ_10:
 		if (ldev_info->state == MYRB_DEVICE_WO) {
 			/* Data protect, attempt to read invalid data */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						DATA_PROTECT, 0x21, 0x06);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
 			scmd->scsi_done(scmd);
 			return 0;
 		}
@@ -1553,10 +1531,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case READ_12:
 		if (ldev_info->state == MYRB_DEVICE_WO) {
 			/* Data protect, attempt to read invalid data */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						DATA_PROTECT, 0x21, 0x06);
-			scmd->result = (DRIVER_SENSE << 24) |
-				SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
 			scmd->scsi_done(scmd);
 			return 0;
 		}
@@ -1569,9 +1544,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		break;
 	default:
 		/* Illegal request, invalid opcode */
-		scsi_build_sense_buffer(0, scmd->sense_buffer,
-					ILLEGAL_REQUEST, 0x20, 0);
-		scmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0);
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -2352,25 +2325,19 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
 			"Bad Data Encountered\n");
 		if (scmd->sc_data_direction == DMA_FROM_DEVICE)
 			/* Unrecovered read error */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						MEDIUM_ERROR, 0x11, 0);
+			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x11, 0);
 		else
 			/* Write error */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						MEDIUM_ERROR, 0x0C, 0);
-		scmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x0C, 0);
 		break;
 	case MYRB_STATUS_IRRECOVERABLE_DATA_ERROR:
 		scmd_printk(KERN_ERR, scmd, "Irrecoverable Data Error\n");
 		if (scmd->sc_data_direction == DMA_FROM_DEVICE)
 			/* Unrecovered read error, auto-reallocation failed */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						MEDIUM_ERROR, 0x11, 0x04);
+			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x11, 0x04);
 		else
 			/* Write error, auto-reallocation failed */
-			scsi_build_sense_buffer(0, scmd->sense_buffer,
-						MEDIUM_ERROR, 0x0C, 0x02);
-		scmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x0C, 0x02);
 		break;
 	case MYRB_STATUS_LDRV_NONEXISTENT_OR_OFFLINE:
 		dev_dbg(&scmd->device->sdev_gendev,
@@ -2381,8 +2348,7 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
 		dev_dbg(&scmd->device->sdev_gendev,
 			    "Attempt to Access Beyond End of Logical Drive");
 		/* Logical block address out of range */
-		scsi_build_sense_buffer(0, scmd->sense_buffer,
-					NOT_READY, 0x21, 0);
+		scsi_build_sense(scmd, 0, NOT_READY, 0x21, 0);
 		break;
 	case MYRB_STATUS_DEVICE_NONRESPONSIVE:
 		dev_dbg(&scmd->device->sdev_gendev, "Device nonresponsive\n");
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 3b68c68d1716..26326af23dbc 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1600,9 +1600,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 
 	switch (scmd->cmnd[0]) {
 	case REPORT_LUNS:
-		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
-					0x20, 0x0);
-		scmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0x0);
 		scmd->scsi_done(scmd);
 		return 0;
 	case MODE_SENSE:
@@ -1612,10 +1610,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 			if ((scmd->cmnd[2] & 0x3F) != 0x3F &&
 			    (scmd->cmnd[2] & 0x3F) != 0x08) {
 				/* Illegal request, invalid field in CDB */
-				scsi_build_sense_buffer(0, scmd->sense_buffer,
-					ILLEGAL_REQUEST, 0x24, 0);
-				scmd->result = (DRIVER_SENSE << 24) |
-					SAM_STAT_CHECK_CONDITION;
+				scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
 			} else {
 				myrs_mode_sense(cs, scmd, ldev_info);
 				scmd->result = (DID_OK << 16);
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index ccb5771f1cb7..0f4b99d92f12 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -234,10 +234,8 @@ static int ps3rom_queuecommand_lck(struct scsi_cmnd *cmd,
 	}
 
 	if (res) {
-		memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+		scsi_build_sense(cmd, 0, ILLEGAL_REQUEST, 0, 0);
 		cmd->result = res;
-		cmd->sense_buffer[0] = 0x70;
-		cmd->sense_buffer[2] = ILLEGAL_REQUEST;
 		priv->curr_cmd = NULL;
 		cmd->scsi_done(cmd);
 	}
@@ -319,8 +317,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 		goto done;
 	}
 
-	scsi_build_sense_buffer(0, cmd->sense_buffer, sense_key, asc, ascq);
-	cmd->result = SAM_STAT_CHECK_CONDITION;
+	scsi_build_sense(cmd, 0, sense_key, asc, ascq);
 
 done:
 	priv->curr_cmd = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6e8f737a4af3..19fe2c1659d0 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2694,31 +2694,22 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 
 	/* check guard */
 	if (e_guard != a_guard) {
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-		    0x10, 0x1);
-		set_driver_byte(cmd, DRIVER_SENSE);
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
 		set_host_byte(cmd, DID_ABORT);
-		cmd->result |= SAM_STAT_CHECK_CONDITION;
 		return 1;
 	}
 
 	/* check ref tag */
 	if (e_ref_tag != a_ref_tag) {
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-		    0x10, 0x3);
-		set_driver_byte(cmd, DRIVER_SENSE);
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
 		set_host_byte(cmd, DID_ABORT);
-		cmd->result |= SAM_STAT_CHECK_CONDITION;
 		return 1;
 	}
 
 	/* check appl tag */
 	if (e_app_tag != a_app_tag) {
-		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-		    0x10, 0x2);
-		set_driver_byte(cmd, DRIVER_SENSE);
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
 		set_host_byte(cmd, DID_ABORT);
-		cmd->result |= SAM_STAT_CHECK_CONDITION;
 		return 1;
 	}
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 70165be10f00..f7e72d21749a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -931,7 +931,7 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
 	}
 	asc = c_d ? INVALID_FIELD_IN_CDB : INVALID_FIELD_IN_PARAM_LIST;
 	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
-	scsi_build_sense_buffer(sdebug_dsense, sbuff, ILLEGAL_REQUEST, asc, 0);
+	scsi_build_sense(scp, sdebug_dsense, ILLEGAL_REQUEST, asc, 0);
 	memset(sks, 0, sizeof(sks));
 	sks[0] = 0x80;
 	if (c_d)
@@ -957,17 +957,14 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
 
 static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int asq)
 {
-	unsigned char *sbuff;
-
-	sbuff = scp->sense_buffer;
-	if (!sbuff) {
+	if (!scp->sense_buffer) {
 		sdev_printk(KERN_ERR, scp->device,
 			    "%s: sense_buffer is NULL\n", __func__);
 		return;
 	}
-	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
+	memset(scp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
-	scsi_build_sense_buffer(sdebug_dsense, sbuff, key, asc, asq);
+	scsi_build_sense(scp, sdebug_dsense, key, asc, asq);
 
 	if (sdebug_verbose)
 		sdev_printk(KERN_INFO, scp->device,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cd316e935281..ea5e34e305e3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3264,3 +3264,21 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 	return group_id;
 }
 EXPORT_SYMBOL(scsi_vpd_tpg_id);
+
+/**
+ * scsi_build_sense - build sense data for a command
+ * @scmd:	scsi command for which the sense should be formatted
+ * @desc:	Sense format (non-zero == descriptor format,
+ *              0 == fixed format)
+ * @key:	Sense key
+ * @asc:	Additional sense code
+ * @ascq:	Additional sense code qualifier
+ *
+ **/
+void scsi_build_sense(struct scsi_cmnd *scmd, int desc, u8 key, u8 asc, u8 ascq)
+{
+	scsi_build_sense_buffer(desc, scmd->sense_buffer, key, asc, ascq);
+	scmd->result = (DRIVER_SENSE << 24) | (DID_OK << 16) |
+		SAM_STAT_CHECK_CONDITION;
+}
+EXPORT_SYMBOL_GPL(scsi_build_sense);
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 25c0409e98df..a112d9c3c548 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3088,8 +3088,7 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 	}
 
 	if (device_offline && sense_data_length == 0)
-		scsi_build_sense_buffer(0, scmd->sense_buffer, HARDWARE_ERROR,
-			0x3e, 0x1);
+		scsi_build_sense(scmd, 0, HARDWARE_ERROR, 0x3e, 0x1);
 
 	scmd->result = scsi_status;
 	set_host_byte(scmd, host_byte);
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 12471208c7a8..3af2a2d3bfa2 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -398,11 +398,8 @@ static struct status_msg *stex_get_status(struct st_hba *hba)
 static void stex_invalid_field(struct scsi_cmnd *cmd,
 			       void (*done)(struct scsi_cmnd *))
 {
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-
 	/* "Invalid field in cdb" */
-	scsi_build_sense_buffer(0, cmd->sense_buffer, ILLEGAL_REQUEST, 0x24,
-				0x0);
+	scsi_build_sense(cmd, 0, ILLEGAL_REQUEST, 0x24, 0x0);
 	done(cmd);
 }
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 83f7e520be48..b3eaf4b74b72 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -342,4 +342,7 @@ static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 	return xfer_len;
 }
 
+extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
+			     u8 key, u8 asc, u8 ascq);
+
 #endif /* _SCSI_SCSI_CMND_H */
-- 
2.29.2

