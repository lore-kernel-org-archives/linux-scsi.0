Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43489C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B38661409
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244882AbhDURus (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:50:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:52318 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245016AbhDURtA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 72B4CAFEF;
        Wed, 21 Apr 2021 17:48:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/42] scsi: Kill DRIVER_SENSE
Date:   Wed, 21 Apr 2021 19:47:14 +0200
Message-Id: <20210421174749.11221-8-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace the check for DRIVER_SENSE with a check for
SAM_STAT_CHECK_CONDITION and audit all callsites to
ensure the SAM status is set correctly.
For backwards compability move the DRIVER_SENSE definition
to sg.h, and update the sg driver to set the DRIVER_SENSE
driver_status whenever SAM_STAT_CHECK_CONDITION is present.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c                   | 13 ++------
 drivers/scsi/NCR5380.c                      |  2 +-
 drivers/scsi/advansys.c                     |  2 --
 drivers/scsi/aic7xxx/aic79xx_osm.c          | 19 +++++-------
 drivers/scsi/aic7xxx/aic7xxx_osm.c          |  1 -
 drivers/scsi/arcmsr/arcmsr_hba.c            |  1 -
 drivers/scsi/ch.c                           |  2 +-
 drivers/scsi/cxlflash/superpipe.c           |  3 +-
 drivers/scsi/dc395x.c                       | 13 ++------
 drivers/scsi/esp_scsi.c                     |  4 +--
 drivers/scsi/megaraid.c                     | 10 +++---
 drivers/scsi/megaraid/megaraid_mbox.c       |  8 ++---
 drivers/scsi/megaraid/megaraid_sas_base.c   |  2 --
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  1 -
 drivers/scsi/mvumi.c                        |  1 -
 drivers/scsi/scsi.c                         |  7 -----
 drivers/scsi/scsi_debug.c                   |  4 +--
 drivers/scsi/scsi_ioctl.c                   |  3 +-
 drivers/scsi/scsi_lib.c                     |  9 ++----
 drivers/scsi/scsi_scan.c                    |  2 +-
 drivers/scsi/scsi_transport_spi.c           |  2 +-
 drivers/scsi/sd.c                           | 34 +++++++++++----------
 drivers/scsi/sd_zbc.c                       |  3 +-
 drivers/scsi/sg.c                           |  9 ++++--
 drivers/scsi/stex.c                         |  4 +--
 drivers/scsi/sym53c8xx_2/sym_glue.c         |  6 ++--
 drivers/scsi/ufs/ufshcd.c                   |  2 +-
 drivers/scsi/virtio_scsi.c                  |  3 +-
 drivers/scsi/vmw_pvscsi.c                   |  3 --
 drivers/target/loopback/tcm_loop.c          |  1 -
 drivers/usb/storage/cypress_atacb.c         |  4 +--
 drivers/xen/xen-scsiback.c                  |  2 +-
 include/scsi/sg.h                           |  2 ++
 33 files changed, 68 insertions(+), 114 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 10d0ef9e969d..e42c23e589ff 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -411,13 +411,12 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 		rc = cmd_result;
 		goto error;
 	}
-	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
+	if (scsi_sense_valid(&sshdr)) {/* sense data available */
 		u8 *desc = sensebuf + 8;
-		cmd_result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
 
 		/* If we set cc then ATA pass-through will cause a
 		 * check condition even if no error. Filter that. */
-		if (cmd_result & SAM_STAT_CHECK_CONDITION) {
+		if (status_byte(cmd_result) == SAM_STAT_CHECK_CONDITION) {
 			if (sshdr.sense_key == RECOVERED_ERROR &&
 			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
@@ -496,9 +495,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 		rc = cmd_result;
 		goto error;
 	}
-	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
+	if (scsi_sense_valid(&sshdr)) {/* sense data available */
 		u8 *desc = sensebuf + 8;
-		cmd_result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
 
 		/* If we set cc then ATA pass-through will cause a
 		 * check condition even if no error. Filter that. */
@@ -864,8 +862,6 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 
 	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
 
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-
 	/*
 	 * Use ata_to_sense_error() to map status register bits
 	 * onto sense key, asc & ascq.
@@ -962,8 +958,6 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 
 	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
 
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-
 	if (ata_dev_disabled(dev)) {
 		/* Device disabled after error recovery */
 		/* LOGICAL UNIT NOT READY, HARD RESET REQUIRED */
@@ -4202,7 +4196,6 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 
 	case REQUEST_SENSE:
 		ata_scsi_set_sense(dev, cmd, 0, 0, 0);
-		cmd->result = (DRIVER_SENSE << 24);
 		break;
 
 	/* if we reach this, then writeback caching is disabled,
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 2ddbcaa667d1..d7594b794d3c 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -542,7 +542,7 @@ static void complete_cmd(struct Scsi_Host *instance,
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
 		} else {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
-			set_driver_byte(cmd, DRIVER_SENSE);
+			set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
 		}
 		hostdata->sensing = NULL;
 	}
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e9516de8c18b..77c99fe11c81 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -6009,7 +6009,6 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 				ASC_DBG(2, "SAM_STAT_CHECK_CONDITION\n");
 				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
 						  SCSI_SENSE_BUFFERSIZE);
-				set_driver_byte(scp, DRIVER_SENSE);
 			}
 			break;
 
@@ -6760,7 +6759,6 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 				ASC_DBG(2, "SAM_STAT_CHECK_CONDITION\n");
 				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
 						  SCSI_SENSE_BUFFERSIZE);
-				set_driver_byte(scp, DRIVER_SENSE);
 			}
 			break;
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 4f7102f8eeb0..92ea24a075b8 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1928,7 +1928,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 			memcpy(cmd->sense_buffer,
 			       ahd_get_sense_buf(ahd, scb)
 			       + sense_offset, sense_size);
-			cmd->result |= (DRIVER_SENSE << 24);
+			set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
 
 #ifdef AHD_DEBUG
 			if (ahd_debug & AHD_SHOW_SENSE) {
@@ -2018,6 +2018,7 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 	int new_status = DID_OK;
 	int do_fallback = 0;
 	int scsi_status;
+	struct scsi_sense_data *sense;
 
 	/*
 	 * Map CAM error codes into Linux Error codes.  We
@@ -2041,18 +2042,12 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 		switch(scsi_status) {
 		case SAM_STAT_COMMAND_TERMINATED:
 		case SAM_STAT_CHECK_CONDITION:
-			if ((cmd->result >> 24) != DRIVER_SENSE) {
+			sense = (struct scsi_sense_data *)
+				cmd->sense_buffer;
+			if (sense->extra_len >= 5 &&
+			    (sense->add_sense_code == 0x47
+			     || sense->add_sense_code == 0x48))
 				do_fallback = 1;
-			} else {
-				struct scsi_sense_data *sense;
-				
-				sense = (struct scsi_sense_data *)
-					cmd->sense_buffer;
-				if (sense->extra_len >= 5 &&
-				    (sense->add_sense_code == 0x47
-				     || sense->add_sense_code == 0x48))
-					do_fallback = 1;
-			}
 			break;
 		default:
 			break;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d33f5a00bf0b..8b3d472aa3cc 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1838,7 +1838,6 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
 			if (sense_size < SCSI_SENSE_BUFFERSIZE)
 				memset(&cmd->sense_buffer[sense_size], 0,
 				       SCSI_SENSE_BUFFERSIZE - sense_size);
-			cmd->result |= (DRIVER_SENSE << 24);
 #ifdef AHC_DEBUG
 			if (ahc_debug & AHC_SHOW_SENSE) {
 				int i;
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 4b79661275c9..8e4d7d0e649c 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1335,7 +1335,6 @@ static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
 		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
 		sensebuffer->Valid = 1;
-		pcmd->result |= (DRIVER_SENSE << 24);
 	}
 }
 
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 0e7d1214c3d8..b8f3d6d96cf3 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -200,7 +200,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 				  MAX_RETRIES, NULL);
 	if (result < 0)
 		return result;
-	if (driver_byte(result) == DRIVER_SENSE) {
+	if (scsi_sense_valid(&sshdr)) {
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index caa7c5fd233d..df0ebabbf387 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -369,8 +369,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 		goto out;
 	}
 
-	if (result > 0 && driver_byte(result) == DRIVER_SENSE) {
-		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
+	if (result > 0 && scsi_sense_valid(&sshdr)) {
 		if (result & SAM_STAT_CHECK_CONDITION) {
 			switch (sshdr.sense_key) {
 			case NO_SENSE:
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index be87d5a7583d..a713fe605dda 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3239,16 +3239,9 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		}
 		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE2\n");
 
-		if (srb->total_xfer_length
-		    && srb->total_xfer_length >= cmd->underflow)
-			cmd->result =
-			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
-				       srb->end_message, CHECK_CONDITION);
-		/*SET_RES_DID(cmd->result,DID_OK) */
-		else
-			cmd->result =
-			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
-				       srb->end_message, CHECK_CONDITION);
+		cmd->result =
+		    MK_RES(0, DID_OK,
+			   srb->end_message, SAM_STAT_CHECK_CONDITION);
 
 		goto ckc_e;
 	}
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 342535ac0570..60e27d7708a4 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -922,9 +922,7 @@ static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
 		 * saw originally.  Also, report that we are providing
 		 * the sense data.
 		 */
-		cmd->result = ((DRIVER_SENSE << 24) |
-			       (DID_OK << 16) |
-			       (SAM_STAT_CHECK_CONDITION << 0));
+		set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
 
 		ent->flags &= ~ESP_CMD_FLAG_AUTOSENSE;
 		if (esp_debug & ESP_DEBUG_AUTOSENSE) {
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index ae3f32f89381..c957dddf06e9 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1583,9 +1583,8 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 				memcpy(cmd->sense_buffer, pthru->reqsensearea,
 						14);
 
-				cmd->result = (DRIVER_SENSE << 24) |
-					(DID_OK << 16) |
-					(CHECK_CONDITION << 1);
+				cmd->result = (DID_OK << 16) |
+					SAM_STAT_CHECK_CONDITION;
 			}
 			else {
 				if (mbox->m_out.cmd == MEGA_MBOXCMD_EXTPTHRU) {
@@ -1593,9 +1592,8 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 					memcpy(cmd->sense_buffer,
 						epthru->reqsensearea, 14);
 
-					cmd->result = (DRIVER_SENSE << 24) |
-						(DID_OK << 16) |
-						(CHECK_CONDITION << 1);
+					cmd->result = (DID_OK << 16) |
+						SAM_STAT_CHECK_CONDITION;
 				} else
 					scsi_build_sense(cmd, 0,
 							 ABORTED_COMMAND, 0, 0);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 6a5b844a8499..2b6138a7c71f 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2299,8 +2299,7 @@ megaraid_mbox_dpc(unsigned long devp)
 				memcpy(scp->sense_buffer, pthru->reqsensearea,
 						14);
 
-				scp->result = DRIVER_SENSE << 24 |
-					DID_OK << 16 | CHECK_CONDITION << 1;
+				scp->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 			}
 			else {
 				if (mbox->cmd == MBOXCMD_EXTPTHRU) {
@@ -2308,9 +2307,8 @@ megaraid_mbox_dpc(unsigned long devp)
 					memcpy(scp->sense_buffer,
 						epthru->reqsensearea, 14);
 
-					scp->result = DRIVER_SENSE << 24 |
-						DID_OK << 16 |
-						CHECK_CONDITION << 1;
+					scp->result = DID_OK << 16 |
+						SAM_STAT_CHECK_CONDITION;
 				} else
 					scsi_build_sense(scp, 0,
 							 ABORTED_COMMAND, 0, 0);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 4d4e9dbe5193..5c5fae5fc443 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3617,8 +3617,6 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 				       SCSI_SENSE_BUFFERSIZE);
 				memcpy(cmd->scmd->sense_buffer, cmd->sense,
 				       hdr->sense_len);
-
-				cmd->scmd->result |= DRIVER_SENSE << 24;
 			}
 
 			break;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2221175ae051..1a4bd75229cf 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2051,7 +2051,6 @@ map_cmd_status(struct fusion_context *fusion,
 			       SCSI_SENSE_BUFFERSIZE);
 			memcpy(scmd->sense_buffer, sense,
 			       SCSI_SENSE_BUFFERSIZE);
-			scmd->result |= DRIVER_SENSE << 24;
 		}
 
 		/*
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 94f706eeb561..f61250545025 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1317,7 +1317,6 @@ static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
 		if (ob_frame->rsp_flag & CL_RSP_FLAG_SENSEDATA) {
 			memcpy(cmd->scmd->sense_buffer, ob_frame->payload,
 				sizeof(struct mvumi_sense_data));
-			scmd->result |=  (DRIVER_SENSE << 24);
 		}
 		break;
 	default:
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 99dc6ec0b6e5..df236dbbf8e0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -185,13 +185,6 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 	if (atomic_read(&sdev->device_blocked))
 		atomic_set(&sdev->device_blocked, 0);
 
-	/*
-	 * If we have valid sense information, then some kind of recovery
-	 * must have taken place.  Make a note of this.
-	 */
-	if (SCSI_SENSE_VALID(cmd))
-		cmd->result |= (DRIVER_SENSE << 24);
-
 	SCSI_LOG_MLCOMPLETE(4, sdev_printk(KERN_INFO, sdev,
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f7e72d21749a..33fcc356d28e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -851,10 +851,10 @@ static struct device_driver sdebug_driverfs_driver = {
 };
 
 static const int check_condition_result =
-		(DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+		(DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 
 static const int illegal_condition_result =
-	(DRIVER_SENSE << 24) | (DID_ABORT << 16) | SAM_STAT_CHECK_CONDITION;
+	(DID_ABORT << 16) | SAM_STAT_CHECK_CONDITION;
 
 static const int device_qfull_result =
 	(DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index d34e1b41dc71..0d13610cd6bf 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -103,8 +103,7 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 
 	if (result < 0)
 		goto out;
-	if (driver_byte(result) == DRIVER_SENSE &&
-	    scsi_sense_valid(&sshdr)) {
+	if (scsi_sense_valid(&sshdr)) {
 		switch (sshdr.sense_key) {
 		case ILLEGAL_REQUEST:
 			if (cmd[0] == ALLOW_MEDIUM_REMOVAL)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d72f15f6c225..cbcfda0abd37 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -627,8 +627,6 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 	case DID_OK:
 		/*
 		 * Also check the other bytes than the status byte in result
-		 * to handle the case when a SCSI LLD sets result to
-		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
 		 */
 		if (scsi_status_is_good(result) && (result & ~0xff) == 0)
 			return BLK_STS_OK;
@@ -824,7 +822,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 			 */
 			if (!level && __ratelimit(&_rs)) {
 				scsi_print_result(cmd, NULL, FAILED);
-				if (driver_byte(result) == DRIVER_SENSE)
+				if (sense_valid)
 					scsi_print_sense(cmd);
 				scsi_print_command(cmd);
 			}
@@ -2194,7 +2192,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	if (result < 0)
 		return result;
 	if (use_10_for_ms && !scsi_status_is_good(result) &&
-	    driver_byte(result) == DRIVER_SENSE) {
+	    status_byte(result) == SAM_STAT_CHECK_CONDITION) {
 		if (scsi_sense_valid(sshdr)) {
 			if ((sshdr->sense_key == ILLEGAL_REQUEST) &&
 			    (sshdr->asc == 0x20) && (sshdr->ascq == 0)) {
@@ -3279,7 +3277,6 @@ EXPORT_SYMBOL(scsi_vpd_tpg_id);
 void scsi_build_sense(struct scsi_cmnd *scmd, int desc, u8 key, u8 asc, u8 ascq)
 {
 	scsi_build_sense_buffer(desc, scmd->sense_buffer, key, asc, ascq);
-	scmd->result = (DRIVER_SENSE << 24) | (DID_OK << 16) |
-		SAM_STAT_CHECK_CONDITION;
+	scmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 }
 EXPORT_SYMBOL_GPL(scsi_build_sense);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 493f17bf26f2..3616b36219a0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -623,7 +623,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			 * INQUIRY should not yield UNIT_ATTENTION
 			 * but many buggy devices do so anyway. 
 			 */
-			if (driver_byte(result) == DRIVER_SENSE &&
+			if (status_byte(result) == SAM_STAT_CHECK_CONDITION &&
 			    scsi_sense_valid(&sshdr)) {
 				if ((sshdr.sense_key == UNIT_ATTENTION) &&
 				    ((sshdr.asc == 0x28) ||
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index a9bb7ae2fafd..5af7a10e9514 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -127,7 +127,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 				      REQ_FAILFAST_TRANSPORT |
 				      REQ_FAILFAST_DRIVER,
 				      RQF_PM, NULL);
-		if (result < 0 || driver_byte(result) != DRIVER_SENSE ||
+		if (result < 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5733fbee2bae..7537c2873efd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1722,16 +1722,17 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		if (res < 0)
 			return res;
 
-		if (driver_byte(res) == DRIVER_SENSE)
+		if (status_byte(res) == SAM_STAT_CHECK_CONDITION &&
+		    scsi_sense_valid(sshdr)) {
 			sd_print_sense_hdr(sdkp, sshdr);
 
-		/* we need to evaluate the error return  */
-		if (scsi_sense_valid(sshdr) &&
-			(sshdr->asc == 0x3a ||	/* medium not present */
-			 sshdr->asc == 0x20 ||	/* invalid command */
-			 (sshdr->asc == 0x74 && sshdr->ascq == 0x71)))	/* drive is password locked */
+			/* we need to evaluate the error return  */
+			if (sshdr->asc == 0x3a ||	/* medium not present */
+			    sshdr->asc == 0x20 ||	/* invalid command */
+			    (sshdr->asc == 0x74 && sshdr->ascq == 0x71))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
+		}
 
 		switch (host_byte(res)) {
 		/* ignore errors due to racing a disconnection */
@@ -1828,7 +1829,7 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
 			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
 
-	if (result > 0 && driver_byte(result) == DRIVER_SENSE &&
+	if (result > 0 && status_byte(result) == SAM_STAT_CHECK_CONDITION &&
 	    scsi_sense_valid(&sshdr)) {
 		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
@@ -2072,7 +2073,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	}
 	sdkp->medium_access_timed_out = 0;
 
-	if (driver_byte(result) != DRIVER_SENSE &&
+	if (status_byte(result) != SAM_STAT_CHECK_CONDITION &&
 	    (!sense_valid || sense_deferred))
 		goto out;
 
@@ -2175,12 +2176,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
 			retries++;
-		} while (retries < 3 && 
+		} while (retries < 3 &&
 			 (!scsi_status_is_good(the_result) ||
-			  ((driver_byte(the_result) == DRIVER_SENSE) &&
+			  ((status_byte(the_result) == SAM_STAT_CHECK_CONDITION) &&
 			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
 
-		if (the_result < 0 || driver_byte(the_result) != DRIVER_SENSE) {
+		if (the_result < 0 ||
+		    status_byte(the_result) != SAM_STAT_CHECK_CONDITION) {
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */
 			if(!spintime && !scsi_status_is_good(the_result)) {
@@ -2308,7 +2310,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			struct scsi_sense_hdr *sshdr, int sense_valid,
 			int the_result)
 {
-	if (driver_byte(the_result) == DRIVER_SENSE)
+	if (sense_valid)
 		sd_print_sense_hdr(sdkp, sshdr);
 	else
 		sd_printk(KERN_NOTICE, sdkp, "Sense not available.\n");
@@ -3594,12 +3596,12 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
-		if (res > 0 && driver_byte(res) == DRIVER_SENSE)
+		if (res > 0 && scsi_sense_valid(&sshdr)) {
 			sd_print_sense_hdr(sdkp, &sshdr);
-		if (scsi_sense_valid(&sshdr) &&
 			/* 0x3a is medium not present */
-			sshdr.asc == 0x3a)
-			res = 0;
+			if (sshdr.asc == 0x3a)
+				res = 0;
+		}
 	}
 
 	/* SCSI error codes must not go to the generic layer */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index d4a79fdcfffe..186b5ff52c3a 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -116,8 +116,7 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
 		sd_print_result(sdkp, "REPORT ZONES", result);
-		if (result > 0 && driver_byte(result) == DRIVER_SENSE &&
-		    scsi_sense_valid(&sshdr))
+		if (result > 0 && scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EIO;
 	}
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 737cea9d908e..9122d05563d0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -498,9 +498,11 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	old_hdr->host_status = hp->host_status;
 	old_hdr->driver_status = hp->driver_status;
 	if ((CHECK_CONDITION & hp->masked_status) ||
-	    (DRIVER_SENSE & hp->driver_status))
+	    (srp->sense_b && (srp->sense_b[0] & 0x70) == 0x70)) {
+		old_hdr->driver_status |= DRIVER_SENSE;
 		memcpy(old_hdr->sense_buffer, srp->sense_b,
 		       sizeof (old_hdr->sense_buffer));
+	}
 	switch (hp->host_status) {
 	/* This setup of 'result' is for backward compatibility and is best
 	   ignored by the user who should use target, host + driver status */
@@ -574,7 +576,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 	hp->sb_len_wr = 0;
 	if ((hp->mx_sb_len > 0) && hp->sbp) {
 		if ((CHECK_CONDITION & hp->masked_status) ||
-		    (DRIVER_SENSE & hp->driver_status)) {
+		    (srp->sense_b && (srp->sense_b[0] & 0x70) == 0x70)) {
 			int sb_len = SCSI_SENSE_BUFFERSIZE;
 			sb_len = (hp->mx_sb_len > sb_len) ? sb_len : hp->mx_sb_len;
 			len = 8 + (int) srp->sense_b[7];	/* Additional sense length field */
@@ -582,7 +584,8 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 			if (copy_to_user(hp->sbp, srp->sense_b, len)) {
 				err = -EFAULT;
 				goto err_out;
-			}
+			} else
+				hp->driver_status |= DRIVER_SENSE;
 			hp->sb_len_wr = len;
 		}
 	}
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 3af2a2d3bfa2..73ae97371f09 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -737,7 +737,7 @@ static void stex_scsi_done(struct st_ccb *ccb)
 			result |= DID_OK << 16;
 			break;
 		case SAM_STAT_CHECK_CONDITION:
-			result |= DRIVER_SENSE << 24;
+			result |= DID_OK << 16;
 			break;
 		case SAM_STAT_BUSY:
 			result |= DID_BUS_BUSY << 16;
@@ -748,7 +748,7 @@ static void stex_scsi_done(struct st_ccb *ccb)
 		}
 	}
 	else if (ccb->srb_status & SRB_SEE_SENSE)
-		result = DRIVER_SENSE << 24 | SAM_STAT_CHECK_CONDITION;
+		result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 	else switch (ccb->srb_status) {
 		case SRB_STATUS_SELECTION_TIMEOUT:
 			result = DID_NO_CONNECT << 16;
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d9a045f9858c..16b65fc4405c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -170,9 +170,8 @@ static int sym_xerr_cam_status(int cam_status, int x_status)
 void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 {
 	struct scsi_cmnd *cmd = cp->cmd;
-	u_int cam_status, scsi_status, drv_status;
+	u_int cam_status, scsi_status;
 
-	drv_status  = 0;
 	cam_status  = DID_OK;
 	scsi_status = cp->ssss_status;
 
@@ -186,7 +185,6 @@ void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 		    cp->xerr_status == 0) {
 			cam_status = sym_xerr_cam_status(DID_OK,
 							 cp->sv_xerr_status);
-			drv_status = DRIVER_SENSE;
 			/*
 			 *  Bounce back the sense data to user.
 			 */
@@ -235,7 +233,7 @@ void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 		cam_status = sym_xerr_cam_status(DID_ERROR, cp->xerr_status);
 	}
 	scsi_set_resid(cmd, resid);
-	cmd->result = (drv_status << 24) | (cam_status << 16) | scsi_status;
+	cmd->result = (cam_status << 16) | scsi_status;
 }
 
 static int sym_scatter(struct sym_hcb *np, struct sym_ccb *cp, struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f743434073ac..6d5d0f5a56be 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8487,7 +8487,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
 			    pwr_mode, ret);
-		if (ret > 0 && driver_byte(ret) == DRIVER_SENSE)
+		if (ret > 0 && scsi_sense_valid(&sshdr))
 			scsi_print_sense_hdr(sdp, NULL, &sshdr);
 	}
 
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 1678b6f14af9..fd69a03d6137 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -161,8 +161,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 		       min_t(u32,
 			     virtio32_to_cpu(vscsi->vdev, resp->sense_len),
 			     VIRTIO_SCSI_SENSE_SIZE));
-		if (resp->sense_len)
-			set_driver_byte(sc, DRIVER_SENSE);
+		set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
 	}
 
 	sc->scsi_done(sc);
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 8a79605d9652..f0707eaad9f7 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -576,9 +576,6 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 			cmd->result = (DID_RESET << 16);
 		} else {
 			cmd->result = (DID_OK << 16) | sdstat;
-			if (sdstat == SAM_STAT_CHECK_CONDITION &&
-			    cmd->sense_buffer)
-				cmd->result |= (DRIVER_SENSE << 24);
 		}
 	} else
 		switch (btstat) {
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 2687fd7d45db..6d0b0e67e79e 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -566,7 +566,6 @@ static int tcm_loop_queue_data_or_status(const char *func,
 		memcpy(sc->sense_buffer, se_cmd->sense_buffer,
 				SCSI_SENSE_BUFFERSIZE);
 		sc->result = SAM_STAT_CHECK_CONDITION;
-		set_driver_byte(sc, DRIVER_SENSE);
 	} else
 		sc->result = scsi_status;
 
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index a6f3267bbef6..ba10ee3585c1 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -221,11 +221,11 @@ static void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
 		desc[12] = regs[6];  /* device */
 		desc[13] = regs[7];  /* command */
 
-		srb->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+		srb->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 	}
 	goto end;
 invalid_fld:
-	srb->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+	srb->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 
 	memcpy(srb->sense_buffer,
 			usb_stor_sense_invalidCDB,
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 55a4763da05e..499b94702e2b 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1401,7 +1401,7 @@ static int scsiback_queue_status(struct se_cmd *se_cmd)
 	if (se_cmd->sense_buffer &&
 	    ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
 	     (se_cmd->se_cmd_flags & SCF_EMULATED_TASK_SENSE)))
-		pending_req->result = (DRIVER_SENSE << 24) |
+		pending_req->result = (DID_OK << 16) |
 				      SAM_STAT_CHECK_CONDITION;
 	else
 		pending_req->result = se_cmd->scsi_status;
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 7327e12f3373..a90703cf15f4 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -131,6 +131,8 @@ struct compat_sg_io_hdr {
 #define SG_INFO_DIRECT_IO 0x2   /* direct IO requested and performed */
 #define SG_INFO_MIXED_IO 0x4    /* part direct, part indirect IO */
 
+/* Obsolete DRIVER_SENSE setting */
+#define DRIVER_SENSE 0x08
 
 typedef struct sg_scsi_id { /* used by SG_GET_SCSI_ID ioctl() */
     int host_no;        /* as in "scsi<n>" where 'n' is one of 0, 1, 2 etc */
-- 
2.29.2

