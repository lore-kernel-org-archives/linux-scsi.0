Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F00CA9ED2
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 014A820656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfKDJCX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:57304 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728281AbfKDJCV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0F7F1B4B2;
        Mon,  4 Nov 2019 09:02:11 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 40/52] scsi: Kill DRIVER_SENSE
Date:   Mon,  4 Nov 2019 10:01:39 +0100
Message-Id: <20191104090151.129140-41-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
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
 drivers/ata/libata-scsi.c                   | 13 ++++-----
 drivers/scsi/NCR5380.c                      |  2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c          | 19 +++++-------
 drivers/scsi/aic7xxx/aic7xxx_osm.c          |  1 -
 drivers/scsi/arcmsr/arcmsr_hba.c            |  1 -
 drivers/scsi/ch.c                           |  3 +-
 drivers/scsi/constants.c                    |  2 +-
 drivers/scsi/cxlflash/superpipe.c           | 45 ++++++++++++++---------------
 drivers/scsi/dc395x.c                       |  2 +-
 drivers/scsi/esp_scsi.c                     |  3 +-
 drivers/scsi/megaraid.c                     | 14 ++++-----
 drivers/scsi/megaraid/megaraid_mbox.c       | 14 ++++-----
 drivers/scsi/megaraid/megaraid_sas_base.c   |  2 --
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  1 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  3 +-
 drivers/scsi/mvumi.c                        |  1 -
 drivers/scsi/scsi.c                         |  7 -----
 drivers/scsi/scsi_debug.c                   |  4 +--
 drivers/scsi/scsi_ioctl.c                   |  2 +-
 drivers/scsi/scsi_lib.c                     | 13 ++++-----
 drivers/scsi/scsi_scan.c                    |  2 +-
 drivers/scsi/scsi_transport_spi.c           |  2 +-
 drivers/scsi/sd.c                           | 33 +++++++++++----------
 drivers/scsi/sg.c                           |  9 +++---
 drivers/scsi/stex.c                         |  4 +--
 drivers/scsi/sym53c8xx_2/sym_glue.c         |  6 ++--
 drivers/scsi/ufs/ufshcd.c                   |  2 +-
 drivers/scsi/virtio_scsi.c                  |  3 +-
 drivers/scsi/vmw_pvscsi.c                   |  3 --
 drivers/target/loopback/tcm_loop.c          |  1 -
 drivers/usb/storage/cypress_atacb.c         |  4 +--
 drivers/xen/xen-scsiback.c                  |  2 +-
 include/scsi/scsi.h                         |  1 -
 include/scsi/sg.h                           |  5 ++--
 include/trace/events/scsi.h                 |  3 +-
 35 files changed, 94 insertions(+), 138 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0fd3cb8e4e49..6ae0b579a6ca 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -633,13 +633,12 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
 				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
 
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
@@ -714,9 +713,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
 				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
 
-	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
+	if (scsi_sense_valid(&sshdr)) {/* sense data available */
 		u8 *desc = sensebuf + 8;
-		cmd_result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
 
 		/* If we set cc then ATA pass-through will cause a
 		 * check condition even if no error. Filter that. */
@@ -1074,7 +1072,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 
 	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
 
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+	cmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 
 	/*
 	 * Use ata_to_sense_error() to map status register bits
@@ -1172,7 +1170,7 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 
 	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
 
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+	cmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 
 	if (ata_dev_disabled(dev)) {
 		/* Device disabled after error recovery */
@@ -4480,7 +4478,6 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 
 	case REQUEST_SENSE:
 		ata_scsi_set_sense(dev, cmd, 0, 0, 0);
-		cmd->result = (DRIVER_SENSE << 24);
 		break;
 
 	/* if we reach this, then writeback caching is disabled,
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 5559d39a00b7..ddeeed02cc8b 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -526,7 +526,7 @@ static void complete_cmd(struct Scsi_Host *instance,
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
 		} else {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
-			set_driver_byte(cmd, DRIVER_SENSE);
+			set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
 		}
 		hostdata->sensing = NULL;
 	}
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 72c67e89b911..0d83184d069c 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1940,7 +1940,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 			memcpy(cmd->sense_buffer,
 			       ahd_get_sense_buf(ahd, scb)
 			       + sense_offset, sense_size);
-			cmd->result |= (DRIVER_SENSE << 24);
+			cmd->result |= SAM_STAT_CHECK_CONDITION;
 
 #ifdef AHD_DEBUG
 			if (ahd_debug & AHD_SHOW_SENSE) {
@@ -2030,6 +2030,7 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 	int new_status = DID_OK;
 	int do_fallback = 0;
 	int scsi_status;
+	struct scsi_sense_data *sense;
 
 	/*
 	 * Map CAM error codes into Linux Error codes.  We
@@ -2053,18 +2054,12 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
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
index a0b444e6209d..1c718cf5083f 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1853,7 +1853,6 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
 			if (sense_size < SCSI_SENSE_BUFFERSIZE)
 				memset(&cmd->sense_buffer[sense_size], 0,
 				       SCSI_SENSE_BUFFERSIZE - sense_size);
-			cmd->result |= (DRIVER_SENSE << 24);
 #ifdef AHC_DEBUG
 			if (ahc_debug & AHC_SHOW_SENSE) {
 				int i;
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 89eda0c79349..372aba7f12f3 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1280,7 +1280,6 @@ static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
 		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
 		sensebuffer->Valid = 1;
-		pcmd->result |= (DRIVER_SENSE << 24);
 	}
 }
 
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 5f8153c37f77..380a519b1757 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -199,8 +199,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	result = scsi_execute_req(ch->device, cmd, direction, buffer,
 				  buflength, &sshdr, timeout * HZ,
 				  MAX_RETRIES, NULL);
-
-	if (driver_byte(result) == DRIVER_SENSE) {
+	if (status_byte(result) == SAM_STAT_CHECK_CONDITION) {
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index d4c2a2e4c5d4..7809bf618606 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -408,7 +408,7 @@ static const char * const hostbyte_table[]={
 
 static const char * const driverbyte_table[]={
 "DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR",
-"DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
+"DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD"};
 
 const char *scsi_hostbyte_string(int result)
 {
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 593669ac3669..ee03a2b59b57 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -369,33 +369,30 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 		goto out;
 	}
 
-	if (driver_byte(result) == DRIVER_SENSE) {
-		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
-		if (result & SAM_STAT_CHECK_CONDITION) {
-			switch (sshdr.sense_key) {
-			case NO_SENSE:
-			case RECOVERED_ERROR:
+	if (result & SAM_STAT_CHECK_CONDITION) {
+		switch (sshdr.sense_key) {
+		case NO_SENSE:
+		case RECOVERED_ERROR:
+			/* fall through */
+		case NOT_READY:
+			result &= ~SAM_STAT_CHECK_CONDITION;
+			break;
+		case UNIT_ATTENTION:
+			switch (sshdr.asc) {
+			case 0x29: /* Power on Reset or Device Reset */
 				/* fall through */
-			case NOT_READY:
-				result &= ~SAM_STAT_CHECK_CONDITION;
-				break;
-			case UNIT_ATTENTION:
-				switch (sshdr.asc) {
-				case 0x29: /* Power on Reset or Device Reset */
-					/* fall through */
-				case 0x2A: /* Device capacity changed */
-				case 0x3F: /* Report LUNs changed */
-					/* Retry the command once more */
-					if (retry_cnt++ < 1) {
-						kfree(cmd_buf);
-						kfree(scsi_cmd);
-						goto retry;
-					}
+			case 0x2A: /* Device capacity changed */
+			case 0x3F: /* Report LUNs changed */
+				/* Retry the command once more */
+				if (retry_cnt++ < 1) {
+					kfree(cmd_buf);
+					kfree(scsi_cmd);
+					goto retry;
 				}
-				break;
-			default:
-				break;
 			}
+			break;
+		default:
+			break;
 		}
 	}
 
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index e79db03196f7..d32537d75439 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3281,7 +3281,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE2\n");
 
 		cmd->result =
-		    MK_RES(DRIVER_SENSE, DID_OK,
+		    MK_RES(0, DID_OK,
 			   srb->end_message, SAM_STAT_CHECK_CONDITION);
 
 		goto ckc_e;
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index bb88995a12c7..f32561bbb0b5 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -916,8 +916,7 @@ static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
 		 * saw originally.  Also, report that we are providing
 		 * the sense data.
 		 */
-		cmd->result = ((DRIVER_SENSE << 24) |
-			       (DID_OK << 16) |
+		cmd->result = ((DID_OK << 16) |
 			       (COMMAND_COMPLETE << 8) |
 			       (SAM_STAT_CHECK_CONDITION << 0));
 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 21e190c38b97..007d4f2d371d 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1579,8 +1579,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 				memcpy(cmd->sense_buffer, pthru->reqsensearea,
 						14);
 
-				cmd->result = (DRIVER_SENSE << 24) |
-					(DID_OK << 16) |
+				cmd->result = (DID_OK << 16) |
 					SAM_STAT_CHECK_CONDITION;
 			}
 			else {
@@ -1589,14 +1588,11 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 					memcpy(cmd->sense_buffer,
 						epthru->reqsensearea, 14);
 
-					cmd->result = (DRIVER_SENSE << 24) |
-						(DID_OK << 16) |
+					cmd->result = (DID_OK << 16) |
 						SAM_STAT_CHECK_CONDITION;
-				} else {
-					cmd->sense_buffer[0] = 0x70;
-					cmd->sense_buffer[2] = ABORTED_COMMAND;
-					cmd->result |= SAM_STAT_CHECK_CONDITION;
-				}
+				} else
+					scsi_build_sense(cmd, 0,
+							 ABORTED_COMMAND, 0, 0);
 			}
 			break;
 
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index dc58c5ff31e4..0825e0baa7d1 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2301,8 +2301,7 @@ megaraid_mbox_dpc(unsigned long devp)
 				memcpy(scp->sense_buffer, pthru->reqsensearea,
 						14);
 
-				scp->result = DRIVER_SENSE << 24 |
-					DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
+				scp->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 			}
 			else {
 				if (mbox->cmd == MBOXCMD_EXTPTHRU) {
@@ -2310,14 +2309,11 @@ megaraid_mbox_dpc(unsigned long devp)
 					memcpy(scp->sense_buffer,
 						epthru->reqsensearea, 14);
 
-					scp->result = DRIVER_SENSE << 24 |
-						DID_OK << 16 |
+					scp->result = DID_OK << 16 |
 						SAM_STAT_CHECK_CONDITION;
-				} else {
-					scp->sense_buffer[0] = 0x70;
-					scp->sense_buffer[2] = ABORTED_COMMAND;
-					scp->result = SAM_STAT_CHECK_CONDITION;
-				}
+				} else
+					scsi_build_sense(scp, 0,
+							 ABORTED_COMMAND, 0, 0);
 			}
 			break;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c40fbea06cc5..9e683c876641 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3548,8 +3548,6 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 				       SCSI_SENSE_BUFFERSIZE);
 				memcpy(cmd->scmd->sense_buffer, cmd->sense,
 				       hdr->sense_len);
-
-				cmd->scmd->result |= DRIVER_SENSE << 24;
 			}
 
 			break;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index e301458bcbae..a00449475095 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1988,7 +1988,6 @@ map_cmd_status(struct fusion_context *fusion,
 			       SCSI_SENSE_BUFFERSIZE);
 			memcpy(scmd->sense_buffer, sense,
 			       SCSI_SENSE_BUFFERSIZE);
-			scmd->result |= DRIVER_SENSE << 24;
 		}
 
 		/*
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6477fb84ac60..27f9d66a7d53 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5377,8 +5377,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		else if (!xfer_cnt && scmd->cmnd[0] == REPORT_LUNS) {
 			mpi_reply->SCSIState = MPI2_SCSI_STATE_AUTOSENSE_VALID;
 			mpi_reply->SCSIStatus = SAM_STAT_CHECK_CONDITION;
-			scmd->result = (DRIVER_SENSE << 24) |
-			    SAM_STAT_CHECK_CONDITION;
+			scmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 			scmd->sense_buffer[0] = 0x70;
 			scmd->sense_buffer[2] = ILLEGAL_REQUEST;
 			scmd->sense_buffer[12] = 0x20;
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 645606446bbe..91eb879692c3 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1316,7 +1316,6 @@ static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
 		if (ob_frame->rsp_flag & CL_RSP_FLAG_SENSEDATA) {
 			memcpy(cmd->scmd->sense_buffer, ob_frame->payload,
 				sizeof(struct mvumi_sense_data));
-			scmd->result |=  (DRIVER_SENSE << 24);
 		}
 		break;
 	default:
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 59443e0184fd..b977ea651d12 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -199,13 +199,6 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
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
index 72f10e631ff4..be7036cd4e62 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -708,10 +708,10 @@ static struct device_driver sdebug_driverfs_driver = {
 };
 
 static const int check_condition_result =
-		(DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+		(DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 
 static const int illegal_condition_result =
-	(DRIVER_SENSE << 24) | (DID_ABORT << 16) | SAM_STAT_CHECK_CONDITION;
+	(DID_ABORT << 16) | SAM_STAT_CHECK_CONDITION;
 
 static const int device_qfull_result =
 	(DID_OK << 16) | (COMMAND_COMPLETE << 8) | SAM_STAT_TASK_SET_FULL;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 57bcd05605bf..70c1eab90710 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -101,7 +101,7 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "Ioctl returned  0x%x\n", result));
 
-	if (driver_byte(result) == DRIVER_SENSE &&
+	if (status_byte(result) == SAM_STAT_CHECK_CONDITION &&
 	    scsi_sense_valid(&sshdr)) {
 		switch (sshdr.sense_key) {
 		case ILLEGAL_REQUEST:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2babf6df8066..eac14ecc82dc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -636,8 +636,6 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 	case DID_OK:
 		/*
 		 * Also check the other bytes than the status byte in result
-		 * to handle the case when a SCSI LLD sets result to
-		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
 		 */
 		if (scsi_status_is_good(result) && (result & ~0xff) == 0)
 			return BLK_STS_OK;
@@ -805,7 +803,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 			 */
 			if (!level && __ratelimit(&_rs)) {
 				scsi_print_result(cmd, NULL, FAILED);
-				if (driver_byte(result) == DRIVER_SENSE)
+				if (status_byte(result) == SAM_STAT_CHECK_CONDITION)
 					scsi_print_sense(cmd);
 				scsi_print_command(cmd);
 			}
@@ -2143,11 +2141,11 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	 * ILLEGAL REQUEST if the code page isn't supported */
 
 	if (use_10_for_ms && !scsi_status_is_good(result) &&
-	    driver_byte(result) == DRIVER_SENSE) {
+	    status_byte(result) == SAM_STAT_CHECK_CONDITION) {
 		if (scsi_sense_valid(sshdr)) {
 			if ((sshdr->sense_key == ILLEGAL_REQUEST) &&
 			    (sshdr->asc == 0x20) && (sshdr->ascq == 0)) {
-				/* 
+				/*
 				 * Invalid command operation code
 				 */
 				sdev->use_10_for_ms = 0;
@@ -2156,7 +2154,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		}
 	}
 
-	if(scsi_status_is_good(result)) {
+	if (scsi_status_is_good(result)) {
 		if (unlikely(buffer[0] == 0x86 && buffer[1] == 0x0b &&
 			     (modepage == 6 || modepage == 8))) {
 			/* Initio breakage? */
@@ -3131,7 +3129,6 @@ EXPORT_SYMBOL(scsi_vpd_tpg_id);
 void scsi_build_sense(struct scsi_cmnd *scmd, int desc, u8 key, u8 asc, u8 ascq)
 {
 	scsi_build_sense_buffer(desc, scmd->sense_buffer, key, asc, ascq);
-	scmd->result = (DRIVER_SENSE << 24) | (DID_OK << 16) |
-		SAM_STAT_CHECK_CONDITION;
+	scmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 }
 EXPORT_SYMBOL_GPL(scsi_build_sense);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 058079f915f1..36385f6c5cdc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -606,7 +606,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			 * INQUIRY should not yield UNIT_ATTENTION
 			 * but many buggy devices do so anyway. 
 			 */
-			if (driver_byte(result) == DRIVER_SENSE &&
+			if (status_byte(result) == SAM_STAT_CHECK_CONDITION &&
 			    scsi_sense_valid(&sshdr)) {
 				if ((sshdr.sense_key == UNIT_ATTENTION) &&
 				    ((sshdr.asc == 0x28) ||
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f8661062ef95..9a08a60552a4 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -123,7 +123,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 				      REQ_FAILFAST_TRANSPORT |
 				      REQ_FAILFAST_DRIVER,
 				      0, NULL);
-		if (driver_byte(result) != DRIVER_SENSE ||
+		if (status_byte(result) != SAM_STAT_CHECK_CONDITION ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 326e2877f169..220990183b6b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1648,16 +1648,17 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
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
@@ -1751,7 +1752,7 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
 			&sshdr, SD_TIMEOUT, SD_MAX_RETRIES, NULL);
 
-	if (driver_byte(result) == DRIVER_SENSE &&
+	if (status_byte(result) == SAM_STAT_CHECK_CONDITION &&
 	    scsi_sense_valid(&sshdr)) {
 		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
@@ -1993,7 +1994,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	}
 	sdkp->medium_access_timed_out = 0;
 
-	if (driver_byte(result) != DRIVER_SENSE &&
+	if (status_byte(result) != SAM_STAT_CHECK_CONDITION &&
 	    (!sense_valid || sense_deferred))
 		goto out;
 
@@ -2096,12 +2097,12 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
 			retries++;
-		} while (retries < 3 && 
+		} while (retries < 3 &&
 			 (!scsi_status_is_good(the_result) ||
-			  ((driver_byte(the_result) == DRIVER_SENSE) &&
+			  ((status_byte(the_result) == SAM_STAT_CHECK_CONDITION) &&
 			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
 
-		if (driver_byte(the_result) != DRIVER_SENSE) {
+		if (status_byte(the_result) != SAM_STAT_CHECK_CONDITION) {
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */
 			if(!spintime && !scsi_status_is_good(the_result)) {
@@ -2227,7 +2228,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			struct scsi_sense_hdr *sshdr, int sense_valid,
 			int the_result)
 {
-	if (driver_byte(the_result) == DRIVER_SENSE)
+	if (status_byte(the_result) == SAM_STAT_CHECK_CONDITION)
 		sd_print_sense_hdr(sdkp, sshdr);
 	else
 		sd_printk(KERN_NOTICE, sdkp, "Sense not available.\n");
@@ -3494,12 +3495,12 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 			SD_TIMEOUT, SD_MAX_RETRIES, 0, RQF_PM, NULL);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
-		if (driver_byte(res) == DRIVER_SENSE)
+		if (status_byte(res) == SAM_STAT_CHECK_CONDITION) {
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
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 60ff388d04b9..c6f5e0a8d271 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -503,10 +503,11 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	old_hdr->target_status = hp->masked_status;
 	old_hdr->host_status = hp->host_status;
 	old_hdr->driver_status = hp->driver_status;
-	if ((SAM_STAT_CHECK_CONDITION & hp->status) ||
-	    (DRIVER_SENSE & hp->driver_status))
+	if (SAM_STAT_CHECK_CONDITION & hp->status) {
+		old_hdr->driver_status |= DRIVER_SENSE;
 		memcpy(old_hdr->sense_buffer, srp->sense_b,
 		       sizeof (old_hdr->sense_buffer));
+	}
 	switch (hp->host_status) {
 	/* This setup of 'result' is for backward compatibility and is best
 	   ignored by the user who should use target, host + driver status */
@@ -574,8 +575,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 	}
 	hp->sb_len_wr = 0;
 	if ((hp->mx_sb_len > 0) && hp->sbp) {
-		if ((SAM_STAT_CHECK_CONDITION & hp->status) ||
-		    (DRIVER_SENSE & hp->driver_status)) {
+		if (SAM_STAT_CHECK_CONDITION & hp->status) {
 			int sb_len = SCSI_SENSE_BUFFERSIZE;
 			sb_len = (hp->mx_sb_len > sb_len) ? sb_len : hp->mx_sb_len;
 			len = 8 + (int) srp->sense_b[7];	/* Additional sense length field */
@@ -585,6 +585,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 				goto err_out;
 			}
 			hp->sb_len_wr = len;
+			hp->driver_status |= DRIVER_SENSE;
 		}
 	}
 	if (hp->status || hp->host_status || hp->driver_status)
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index b02251868cb9..b7ebc869d30f 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -735,7 +735,7 @@ static void stex_scsi_done(struct st_ccb *ccb)
 			result |= DID_OK << 16 | COMMAND_COMPLETE << 8;
 			break;
 		case SAM_STAT_CHECK_CONDITION:
-			result |= DRIVER_SENSE << 24;
+			result |= DID_OK << 16;
 			break;
 		case SAM_STAT_BUSY:
 			result |= DID_BUS_BUSY << 16 | COMMAND_COMPLETE << 8;
@@ -746,7 +746,7 @@ static void stex_scsi_done(struct st_ccb *ccb)
 		}
 	}
 	else if (ccb->srb_status & SRB_SEE_SENSE)
-		result = DRIVER_SENSE << 24 | SAM_STAT_CHECK_CONDITION;
+		result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 	else switch (ccb->srb_status) {
 		case SRB_STATUS_SELECTION_TIMEOUT:
 			result = DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 2ca018ce796f..e72fc73cdd96 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -174,9 +174,8 @@ static int sym_xerr_cam_status(int cam_status, int x_status)
 void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 {
 	struct scsi_cmnd *cmd = cp->cmd;
-	u_int cam_status, scsi_status, drv_status;
+	u_int cam_status, scsi_status;
 
-	drv_status  = 0;
 	cam_status  = DID_OK;
 	scsi_status = cp->ssss_status;
 
@@ -190,7 +189,6 @@ void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 		    cp->xerr_status == 0) {
 			cam_status = sym_xerr_cam_status(DID_OK,
 							 cp->sv_xerr_status);
-			drv_status = DRIVER_SENSE;
 			/*
 			 *  Bounce back the sense data to user.
 			 */
@@ -239,7 +237,7 @@ void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 		cam_status = sym_xerr_cam_status(DID_ERROR, cp->xerr_status);
 	}
 	scsi_set_resid(cmd, resid);
-	cmd->result = (drv_status << 24) | (cam_status << 16) | scsi_status;
+	cmd->result = (cam_status << 16) | scsi_status;
 }
 
 static int sym_scatter(struct sym_hcb *np, struct sym_ccb *cp, struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c28c144d9b4a..e411aadb6da7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7600,7 +7600,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
 			    pwr_mode, ret);
-		if (driver_byte(ret) == DRIVER_SENSE)
+		if (scsi_sense_valid(&sshdr))
 			scsi_print_sense_hdr(sdp, NULL, &sshdr);
 	}
 
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index bfec84aacd90..97b980bf145f 100644
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
index 70008816c91f..74e5ed940952 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -565,9 +565,6 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
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
index 3305b47fdf53..99a88aee1c94 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -579,7 +579,6 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 		memcpy(sc->sense_buffer, se_cmd->sense_buffer,
 				SCSI_SENSE_BUFFERSIZE);
 		sc->result = SAM_STAT_CHECK_CONDITION;
-		set_driver_byte(sc, DRIVER_SENSE);
 	} else
 		sc->result = se_cmd->scsi_status;
 
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
index ba0942e481bc..e130b4426c62 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1431,7 +1431,7 @@ static int scsiback_queue_status(struct se_cmd *se_cmd)
 	if (se_cmd->sense_buffer &&
 	    ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
 	     (se_cmd->se_cmd_flags & SCF_EMULATED_TASK_SENSE)))
-		pending_req->result = (DRIVER_SENSE << 24) |
+		pending_req->result = (DID_OK << 16) |
 				      SAM_STAT_CHECK_CONDITION;
 	else
 		pending_req->result = se_cmd->scsi_status;
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index ce8096a99981..f68c234dd3e8 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -173,7 +173,6 @@ static inline int scsi_is_wlun(u64 lun)
 #define DRIVER_INVALID      0x05
 #define DRIVER_TIMEOUT      0x06
 #define DRIVER_HARD         0x07
-#define DRIVER_SENSE	    0x08
 
 /*
  * Internal return values.
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index f91bcca604e4..28ba4f6a7a35 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -101,6 +101,8 @@ typedef struct sg_io_hdr
 #define SG_INFO_DIRECT_IO 0x2   /* direct IO requested and performed */
 #define SG_INFO_MIXED_IO 0x4    /* part direct, part indirect IO */
 
+/* Old linux DRIVER_SENSE setting */
+#define DRIVER_SENSE 0x08
 
 typedef struct sg_scsi_id { /* used by SG_GET_SCSI_ID ioctl() */
     int host_no;        /* as in "scsi<n>" where 'n' is one of 0, 1, 2 etc */
@@ -234,8 +236,7 @@ struct sg_header
     unsigned int other_flags:10;    /* unused */
     unsigned char sense_buffer[SG_MAX_SENSE]; /* [o] Output in 3 cases:
 	   when target_status is CHECK_CONDITION or
-	   when target_status is COMMAND_TERMINATED or
-	   when (driver_status & DRIVER_SENSE) is true. */
+	   when target_status is COMMAND_TERMINATED */
 };      /* This structure is 36 bytes long on i386 */
 
 
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index f624969a4f14..404fbc54bc32 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -134,8 +134,7 @@
 		scsi_driverbyte_name(DRIVER_ERROR),		\
 		scsi_driverbyte_name(DRIVER_INVALID),		\
 		scsi_driverbyte_name(DRIVER_TIMEOUT),		\
-		scsi_driverbyte_name(DRIVER_HARD),		\
-		scsi_driverbyte_name(DRIVER_SENSE))
+		 scsi_driverbyte_name(DRIVER_HARD))
 
 #define scsi_msgbyte_name(result)	{ result, #result }
 #define show_msgbyte_name(val)					\
-- 
2.16.4

