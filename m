Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85147CA9ED0
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52FA42086D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 11:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfJaLFj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 07:05:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:37442 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727511AbfJaLFd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Oct 2019 07:05:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 017DAB36B;
        Thu, 31 Oct 2019 11:05:28 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/24] scsi: introduce scsi_build_sense()
Date:   Thu, 31 Oct 2019 12:04:40 +0100
Message-Id: <20191031110452.73463-13-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191031110452.73463-1-hare@suse.de>
References: <20191031110452.73463-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce scsi_build_sense() as a wrapper around
scsi_build_sense_buffer() to format the buffer and set
the correct SCSI status.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c             |  7 ++--
 drivers/s390/scsi/zfcp_scsi.c         |  5 +--
 drivers/scsi/3w-xxxx.c                |  3 +-
 drivers/scsi/libiscsi.c               |  5 +--
 drivers/scsi/lpfc/lpfc_scsi.c         | 36 +++++++--------------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  |  6 ++--
 drivers/scsi/mvumi.c                  |  5 +--
 drivers/scsi/myrb.c                   | 61 ++++++++---------------------------
 drivers/scsi/myrs.c                   |  9 ++----
 drivers/scsi/ps3rom.c                 |  3 +-
 drivers/scsi/qla2xxx/qla_isr.c        | 15 ++-------
 drivers/scsi/scsi_debug.c             | 11 +++----
 drivers/scsi/scsi_lib.c               | 18 +++++++++++
 drivers/scsi/smartpqi/smartpqi_init.c |  3 +-
 drivers/scsi/stex.c                   |  5 +--
 include/scsi/scsi_cmnd.h              |  3 ++
 16 files changed, 67 insertions(+), 128 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b197d2fbe3f8..0fd3cb8e4e49 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -342,9 +342,7 @@ void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
 	if (!cmd)
 		return;
 
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-
-	scsi_build_sense_buffer(d_sense, cmd->sense_buffer, sk, asc, ascq);
+	scsi_build_sense(cmd, d_sense, sk, asc, ascq);
 }
 
 void ata_scsi_set_sense_information(struct ata_device *dev,
@@ -1092,8 +1090,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 		 * ATA PASS-THROUGH INFORMATION AVAILABLE
 		 * Always in descriptor format sense.
 		 */
-		scsi_build_sense_buffer(1, cmd->sense_buffer,
-					RECOVERED_ERROR, 0, 0x1D);
+		scsi_build_sense(cmd, 1, RECOVERED_ERROR, 0, 0x1D);
 	}
 
 	if ((cmd->sense_buffer[0] & 0x7f) >= 0x72) {
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 3910d529c15a..120787dfcdca 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -834,10 +834,7 @@ void zfcp_scsi_set_prot(struct zfcp_adapter *adapter)
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
index 79eca8f1fd05..381723634c13 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1981,8 +1981,7 @@ static int tw_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_c
 			printk(KERN_NOTICE "3w-xxxx: scsi%d: Unknown scsi opcode: 0x%x\n", tw_dev->host->host_no, *command);
 			tw_dev->state[request_id] = TW_S_COMPLETED;
 			tw_state_request_finish(tw_dev, request_id);
-			SCpnt->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-			scsi_build_sense_buffer(1, SCpnt->sense_buffer, ILLEGAL_REQUEST, 0x20, 0);
+			scsi_build_sense(SCpnt, 1, ILLEGAL_REQUEST, 0x20, 0);
 			done(SCpnt);
 			retval = 0;
 	}
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ebd47c0cf9e9..9c85d7902faa 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -813,10 +813,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
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
index 959ef471d758..cd91afd5c101 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2843,10 +2843,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
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
 				"9069 BLKGRD: LBA %lx grd_tag error %x != %x\n",
@@ -2854,10 +2852,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
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
@@ -2866,10 +2862,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
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
@@ -2930,10 +2924,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
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
 				"9055 BLKGRD: Guard Tag error in cmd"
@@ -2946,10 +2938,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
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
@@ -2963,10 +2953,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
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
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a038be8a0e90..6477fb84ac60 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4619,10 +4619,8 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
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
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 8906aceda4c4..645606446bbe 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2067,10 +2067,7 @@ static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
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
index 539ac8ce4fcd..04a75bd0dcb5 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1449,10 +1449,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
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
@@ -1467,10 +1464,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
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
@@ -1481,20 +1475,14 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
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
@@ -1508,10 +1496,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
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
@@ -1521,10 +1506,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
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
@@ -1538,10 +1520,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
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
@@ -1555,10 +1534,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
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
@@ -1571,9 +1547,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
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
@@ -2354,25 +2328,19 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
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
@@ -2383,8 +2351,7 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
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
index eb0dd566330a..70ba289aa24f 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1602,9 +1602,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
 
 	switch (scmd->cmnd[0]) {
 	case REPORT_LUNS:
-		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
-					0x20, 0x0);
-		scmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0x0);
 		scmd->scsi_done(scmd);
 		return 0;
 	case MODE_SENSE:
@@ -1614,10 +1612,7 @@ static int myrs_queuecommand(struct Scsi_Host *shost,
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
index f75c0b5cd587..63ff9259925a 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -319,8 +319,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 		goto done;
 	}
 
-	scsi_build_sense_buffer(0, cmd->sense_buffer, sense_key, asc, ascq);
-	cmd->result = SAM_STAT_CHECK_CONDITION;
+	scsi_build_sense(cmd, 0, sense_key, asc, ascq);
 
 done:
 	priv->curr_cmd = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index acef3d73983c..d5c0c57b9d00 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2232,31 +2232,22 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 
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
index d323523f5f9d..72f10e631ff4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -779,7 +779,7 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
 	}
 	asc = c_d ? INVALID_FIELD_IN_CDB : INVALID_FIELD_IN_PARAM_LIST;
 	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
-	scsi_build_sense_buffer(sdebug_dsense, sbuff, ILLEGAL_REQUEST, asc, 0);
+	scsi_build_sense(scp, sdebug_dsense, ILLEGAL_REQUEST, asc, 0);
 	memset(sks, 0, sizeof(sks));
 	sks[0] = 0x80;
 	if (c_d)
@@ -805,17 +805,14 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
 
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
index a0db8d8766a8..2babf6df8066 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3117,3 +3117,21 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
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
index 7b7ef3acb504..c0bd02613b02 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2874,8 +2874,7 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 	}
 
 	if (device_offline && sense_data_length == 0)
-		scsi_build_sense_buffer(0, scmd->sense_buffer, HARDWARE_ERROR,
-			0x3e, 0x1);
+		scsi_build_sense(scmd, 0, HARDWARE_ERROR, 0x3e, 0x1);
 
 	scmd->result = scsi_status;
 	set_host_byte(scmd, host_byte);
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 33287b6bdf0e..b02251868cb9 100644
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
index 6932d91472d5..9b9ca629097d 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -338,4 +338,7 @@ static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 	return xfer_len;
 }
 
+extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
+			     u8 key, u8 asc, u8 ascq);
+
 #endif /* _SCSI_SCSI_CMND_H */
-- 
2.16.4

