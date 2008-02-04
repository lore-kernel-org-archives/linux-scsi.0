From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/24][RFC] scsi-drivers: more drivers use new scsi_eh_cpy_sense()
Date: Mon,  4 Feb 2008 17:48:00 +0200
Message-ID: <1202140080-4591-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:53507 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYBDPxN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 10:53:13 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  All below drivers had the sense information stored in some
  driver internal structure, which was copied or manipulated
  and set into sense_buffer. So use scsi_eh_cpy_sense() in it's
  place. In case of manipulation of sense data. a temporary buffer
  is used, then copied.

  Some places that inspect the sense buffer are converted to use
  scsi_sense() accessor.

  driver files changed:
    drivers/s390/scsi/zfcp_fsf.c
    drivers/scsi/3w-xxxx.c
    drivers/scsi/aacraid/aachba.c
    drivers/scsi/aic7xxx/aic79xx_osm.c
    drivers/scsi/aic7xxx/aic7xxx_osm.c
    drivers/scsi/arcmsr/arcmsr_hba.c
    drivers/scsi/ipr.c
    drivers/scsi/ips.c
    drivers/scsi/megaraid/megaraid_mbox.c
    drivers/scsi/ps3rom.c
    drivers/scsi/qla4xxx/ql4_isr.c
    drivers/scsi/stex.c

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/s390/scsi/zfcp_fsf.c          |   11 ++----
 drivers/scsi/3w-xxxx.c                |   20 +++++++++----
 drivers/scsi/aacraid/aachba.c         |   52 ++++++++++----------------------
 drivers/scsi/aic7xxx/aic79xx_osm.c    |   34 +++++++--------------
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |   22 ++++----------
 drivers/scsi/arcmsr/arcmsr_hba.c      |   32 ++++++++++++--------
 drivers/scsi/arm/fas216.c             |    2 +-
 drivers/scsi/ipr.c                    |   17 ++++++-----
 drivers/scsi/ips.c                    |   13 ++++----
 drivers/scsi/megaraid/megaraid_mbox.c |   24 ++++++++++-----
 drivers/scsi/ps3rom.c                 |   31 +++++++++++--------
 drivers/scsi/qla1280.c                |   26 ++++------------
 drivers/scsi/qla4xxx/ql4_isr.c        |   12 ++-----
 drivers/scsi/stex.c                   |   31 +++++++++----------
 14 files changed, 147 insertions(+), 180 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 1abbac5..388d218 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -4209,13 +4209,11 @@ zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *fsf_req)
 
 	/* check for sense data */
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_sns_len_valid)) {
+		u8 *sense;
 		sns_len = FSF_FCP_RSP_SIZE -
 		    sizeof (struct fcp_rsp_iu) + fcp_rsp_iu->fcp_rsp_len;
 		ZFCP_LOG_TRACE("room for %i bytes sense data in QTCB\n",
 			       sns_len);
-		sns_len = min(sns_len, (u32) SCSI_SENSE_BUFFERSIZE);
-		ZFCP_LOG_TRACE("room for %i bytes sense data in SCSI command\n",
-			       SCSI_SENSE_BUFFERSIZE);
 		sns_len = min(sns_len, fcp_rsp_iu->fcp_sns_len);
 		ZFCP_LOG_TRACE("scpnt->result =0x%x, command was:\n",
 			       scpnt->result);
@@ -4224,10 +4222,9 @@ zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *fsf_req)
 
 		ZFCP_LOG_TRACE("%i bytes sense data provided by FCP\n",
 			       fcp_rsp_iu->fcp_sns_len);
-		memcpy(scpnt->sense_buffer,
-		       zfcp_get_fcp_sns_info_ptr(fcp_rsp_iu), sns_len);
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE,
-			      (void *)scpnt->sense_buffer, sns_len);
+		sense = zfcp_get_fcp_sns_info_ptr(fcp_rsp_iu);
+		scsi_eh_cpy_sense(scpnt, sense, sns_len);
+		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE, sense, sns_len);
 	}
 
 	/* check for overrun */
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index d095321..f5dde3d 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -214,6 +214,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
 #include "3w-xxxx.h"
 
 /* Globals */
@@ -410,23 +411,30 @@ static int tw_decode_sense(TW_Device_Extension *tw_dev, int request_id, int fill
 		if ((command->status == 0xc7) || (command->status == 0xcb)) {
 			for (i = 0; i < ARRAY_SIZE(tw_sense_table); i++) {
 				if (command->flags == tw_sense_table[i][0]) {
+					u8 sense[14];
+					struct scsi_cmnd *srb =
+						tw_dev->srb[request_id];
 
+					memset(sense, 0, sizeof(sense));
 					/* Valid bit and 'current errors' */
-					tw_dev->srb[request_id]->sense_buffer[0] = (0x1 << 7 | 0x70);
+					sense[0] = (0x1 << 7 | 0x70);
 
 					/* Sense key */
-					tw_dev->srb[request_id]->sense_buffer[2] = tw_sense_table[i][1];
+					sense[2] = tw_sense_table[i][1];
 
 					/* Additional sense length */
-					tw_dev->srb[request_id]->sense_buffer[7] = 0xa; /* 10 bytes */
+					sense[7] = 0xa; /* 10 bytes */
 
 					/* Additional sense code */
-					tw_dev->srb[request_id]->sense_buffer[12] = tw_sense_table[i][2];
+					sense[12] = tw_sense_table[i][2];
 
 					/* Additional sense code qualifier */
-					tw_dev->srb[request_id]->sense_buffer[13] = tw_sense_table[i][3];
+					sense[13] = tw_sense_table[i][3];
 
-					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+					scsi_eh_cpy_sense(srb, sense,
+								sizeof(sense));
+					srb->result = (DID_OK << 16) |
+						(CHECK_CONDITION << 1);
 					return TW_ISR_DONT_RESULT; /* Special case for isr to not over-write result */
 				}
 			}
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index d7235f4..0e5577c 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -39,6 +39,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
 
 #include "aacraid.h"
 
@@ -862,7 +863,7 @@ static int setinqserial(struct aac_dev *dev, void *data, int cid)
 static void set_sense(u8 *sense_buf, u8 sense_key, u8 sense_code,
 		      u8 a_sense_code, u8 incorrect_length,
 		      u8 bit_pointer, u16 field_pointer,
-		      u32 residue)
+		      u32 residue, struct scsi_cmnd *cmd)
 {
 	sense_buf[0] = 0xF0;	/* Sense data valid, err code 70h (current error) */
 	sense_buf[1] = 0;	/* Segment number, always zero */
@@ -897,6 +898,8 @@ static void set_sense(u8 *sense_buf, u8 sense_key, u8 sense_code,
 		sense_buf[16] = field_pointer >> 8;	/* MSB */
 		sense_buf[17] = field_pointer;		/* LSB */
 	}
+
+	scsi_eh_cpy_sense(cmd, sense_buf, sizeof(struct sense_data));
 }
 
 static int aac_bounds_32(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba)
@@ -910,10 +913,7 @@ static int aac_bounds_32(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba)
 			    HARDWARE_ERROR,
 			    SENCODE_INTERNAL_TARGET_FAILURE,
 			    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
-			    0, 0);
-		memcpy(cmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
-		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
-			     SCSI_SENSE_BUFFERSIZE));
+			    0, 0, cmd);
 		cmd->scsi_done(cmd);
 		return 1;
 	}
@@ -1524,10 +1524,7 @@ static void io_callback(void *context, struct fib * fibptr)
 				    HARDWARE_ERROR,
 				    SENCODE_INTERNAL_TARGET_FAILURE,
 				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
-				    0, 0);
-		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
-		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
-			     SCSI_SENSE_BUFFERSIZE));
+				    0, 0, scsicmd);
 	}
 	aac_fib_complete(fibptr);
 	aac_fib_free(fibptr);
@@ -1737,10 +1734,7 @@ static void synchronize_callback(void *context, struct fib *fibptr)
 				    HARDWARE_ERROR,
 				    SENCODE_INTERNAL_TARGET_FAILURE,
 				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
-				    0, 0);
-		memcpy(cmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
-		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
-			     SCSI_SENSE_BUFFERSIZE));
+				    0, 0, cmd);
 	}
 
 	aac_fib_complete(fibptr);
@@ -1948,10 +1942,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
 			    ILLEGAL_REQUEST,
 			    SENCODE_INVALID_COMMAND,
-			    ASENCODE_INVALID_COMMAND, 0, 0, 0, 0);
-		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
-		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
-			     SCSI_SENSE_BUFFERSIZE));
+			    ASENCODE_INVALID_COMMAND, 0, 0, 0, 0, scsicmd);
 		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
@@ -1998,12 +1989,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
 				  ILLEGAL_REQUEST,
 				  SENCODE_INVALID_CDB_FIELD,
-				  ASENCODE_NO_SENSE, 0, 7, 2, 0);
-				memcpy(scsicmd->sense_buffer,
-				  &dev->fsa_dev[cid].sense_data,
-				  min_t(size_t,
-					sizeof(dev->fsa_dev[cid].sense_data),
-					SCSI_SENSE_BUFFERSIZE));
+				  ASENCODE_NO_SENSE, 0, 7, 2, 0, scsicmd);
 			}
 			scsicmd->scsi_done(scsicmd);
 			return 0;
@@ -2176,7 +2162,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 	}
 	case REQUEST_SENSE:
 		dprintk((KERN_DEBUG "REQUEST SENSE command.\n"));
-		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data, sizeof (struct sense_data));
+		scsi_eh_cpy_sense(scsicmd, &dev->fsa_dev[cid].sense_data,
+					sizeof(struct sense_data));
 		memset(&dev->fsa_dev[cid].sense_data, 0, sizeof (struct sense_data));
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
@@ -2256,11 +2243,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
 			set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
 				ILLEGAL_REQUEST, SENCODE_INVALID_COMMAND,
-				ASENCODE_INVALID_COMMAND, 0, 0, 0, 0);
-			memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
-				min_t(size_t,
-				      sizeof(dev->fsa_dev[cid].sense_data),
-				      SCSI_SENSE_BUFFERSIZE));
+				ASENCODE_INVALID_COMMAND, 0, 0, 0, 0, scsicmd);
 			scsicmd->scsi_done(scsicmd);
 			return 0;
 	}
@@ -2403,7 +2386,6 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 
 	srbreply = (struct aac_srb_reply *) fib_data(fibptr);
 
-	scsicmd->sense_buffer[0] = '\0';  /* Initialize sense valid flag to false */
 	/*
 	 *	Calculate resid for sg
 	 */
@@ -2420,10 +2402,9 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 	if (le32_to_cpu(srbreply->status) != ST_OK){
 		int len;
 		printk(KERN_WARNING "aac_srb_callback: srb failed, status = %d\n", le32_to_cpu(srbreply->status));
-		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
-			    SCSI_SENSE_BUFFERSIZE);
+		len = le32_to_cpu(srbreply->sense_data_size);
 		scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
-		memcpy(scsicmd->sense_buffer, srbreply->sense_data, len);
+		scsi_eh_cpy_sense(scsicmd, srbreply->sense_data, len);
 	}
 
 	/*
@@ -2524,13 +2505,12 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 	if (le32_to_cpu(srbreply->scsi_status) == SAM_STAT_CHECK_CONDITION) {
 		int len;
 		scsicmd->result |= SAM_STAT_CHECK_CONDITION;
-		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
-			    SCSI_SENSE_BUFFERSIZE);
+		len = le32_to_cpu(srbreply->sense_data_size);
 #ifdef AAC_DETAILED_STATUS_INFO
 		printk(KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n",
 					le32_to_cpu(srbreply->status), len);
 #endif
-		memcpy(scsicmd->sense_buffer, srbreply->sense_data, len);
+		scsi_eh_cpy_sense(scsicmd, srbreply->sense_data, len);
 	}
 	/*
 	 * OR in the scsi status (already shifted up a bit)
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 0146547..4bd5aa7 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1654,13 +1654,6 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 	}
 	ahd_linux_unmap_scb(ahd, scb);
 
-	/*
-	 * Guard against stale sense data.
-	 * The Linux mid-layer assumes that sense
-	 * was retrieved anytime the first byte of
-	 * the sense buffer looks "sane".
-	 */
-	cmd->sense_buffer[0] = 0;
 	if (ahd_get_transaction_status(scb) == CAM_REQ_INPROG) {
 		uint32_t amount_xferred;
 
@@ -1779,11 +1772,11 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 			struct scsi_status_iu_header *siu;
 			u_int sense_size;
 			u_int sense_offset;
+			u8 *sense_buffer;
 
 			if (scb->flags & SCB_SENSE) {
-				sense_size = min(sizeof(struct scsi_sense_data)
-					       - ahd_get_sense_residual(scb),
-						 (u_long)SCSI_SENSE_BUFFERSIZE);
+				sense_size = sizeof(struct scsi_sense_data) -
+						ahd_get_sense_residual(scb);
 				sense_offset = 0;
 			} else {
 				/*
@@ -1792,16 +1785,12 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 				 */
 				siu = (struct scsi_status_iu_header *)
 				    scb->sense_data;
-				sense_size = min_t(size_t,
-						scsi_4btoul(siu->sense_length),
-						SCSI_SENSE_BUFFERSIZE);
+				sense_size = scsi_4btoul(siu->sense_length);
 				sense_offset = SIU_SENSE_OFFSET(siu);
 			}
-
-			memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-			memcpy(cmd->sense_buffer,
-			       ahd_get_sense_buf(ahd, scb)
-			       + sense_offset, sense_size);
+			sense_buffer = ahd_get_sense_buf(ahd, scb) +
+								sense_offset;
+			scsi_eh_cpy_sense(cmd, sense_buffer, sense_size);
 			cmd->result |= (DRIVER_SENSE << 24);
 
 #ifdef AHD_DEBUG
@@ -1813,7 +1802,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 				for (i = 0; i < sense_size; i++) {
 					if ((i & 0xF) == 0)
 						printf("\n");
-					printf("0x%x ", cmd->sense_buffer[i]);
+					printf("0x%x ", sense_buffer[i]);
 				}
 				printf("\n");
 			}
@@ -1918,10 +1907,9 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 			if ((cmd->result >> 24) != DRIVER_SENSE) {
 				do_fallback = 1;
 			} else {
-				struct scsi_sense_data *sense;
-				
-				sense = (struct scsi_sense_data *)
-					cmd->sense_buffer;
+				struct scsi_sense_data *sense =
+				      (struct scsi_sense_data *)scsi_sense(cmd);
+
 				if (sense->extra_len >= 5 &&
 				    (sense->add_sense_code == 0x47
 				     || sense->add_sense_code == 0x48))
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 99a3b33..4521370 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1677,13 +1677,6 @@ ahc_done(struct ahc_softc *ahc, struct scb *scb)
 	}
 	ahc_linux_unmap_scb(ahc, scb);
 
-	/*
-	 * Guard against stale sense data.
-	 * The Linux mid-layer assumes that sense
-	 * was retrieved anytime the first byte of
-	 * the sense buffer looks "sane".
-	 */
-	cmd->sense_buffer[0] = 0;
 	if (ahc_get_transaction_status(scb) == CAM_REQ_INPROG) {
 		uint32_t amount_xferred;
 
@@ -1800,15 +1793,12 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
 		cmd = scb->io_ctx;
 		if (scb->flags & SCB_SENSE) {
 			u_int sense_size;
+			u8 *sense_buffer;
 
-			sense_size = min(sizeof(struct scsi_sense_data)
-				       - ahc_get_sense_residual(scb),
-					 (u_long)SCSI_SENSE_BUFFERSIZE);
-			memcpy(cmd->sense_buffer,
-			       ahc_get_sense_buf(ahc, scb), sense_size);
-			if (sense_size < SCSI_SENSE_BUFFERSIZE)
-				memset(&cmd->sense_buffer[sense_size], 0,
-				       SCSI_SENSE_BUFFERSIZE - sense_size);
+			sense_size = sizeof(struct scsi_sense_data)
+				       - ahc_get_sense_residual(scb);
+			sense_buffer = (u8 *)ahc_get_sense_buf(ahc, scb);
+			scsi_eh_cpy_sense(cmd, sense_buffer, sense_size);
 			cmd->result |= (DRIVER_SENSE << 24);
 #ifdef AHC_DEBUG
 			if (ahc_debug & AHC_SHOW_SENSE) {
@@ -1819,7 +1809,7 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
 				for (i = 0; i < sense_size; i++) {
 					if ((i & 0xF) == 0)
 						printf("\n");
-					printf("0x%x ", cmd->sense_buffer[i]);
+					printf("0x%x ", sense_buffer[i]);
 				}
 				printf("\n");
 			}
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f4a202e..2a318ec 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -69,6 +69,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_eh.h>
 #include "arcmsr.h"
 
 MODULE_AUTHOR("Erich Chen <support@areca.com.tw>");
@@ -628,18 +629,15 @@ static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 {
 
 	struct scsi_cmnd *pcmd = ccb->pcmd;
-	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
+	struct SENSE_DATA *sensebuffer =
+		(struct SENSE_DATA *)ccb->arcmsr_cdb.SenseData;
 
 	pcmd->result = DID_OK << 16;
-	if (sensebuffer) {
-		int sense_data_length =
-			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
-			? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;
-		memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
-		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
-		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
-		sensebuffer->Valid = 1;
-	}
+
+	sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
+	sensebuffer->Valid = 1;
+
+	scsi_eh_cpy_sense(pcmd, sensebuffer, sizeof(sensebuffer));
 }
 
 static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
@@ -1442,8 +1440,10 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 		wqbuf_lastindex = acb->wqbuf_lastindex;
 		wqbuf_firstindex = acb->wqbuf_firstindex;
 		if (wqbuf_lastindex != wqbuf_firstindex) {
+			u8 sb[16];
 			struct SENSE_DATA *sensebuffer =
-				(struct SENSE_DATA *)cmd->sense_buffer;
+							(struct SENSE_DATA *)sb;
+			memset(sensebuffer, 0, sizeof(sensebuffer));
 			arcmsr_post_ioctldata2iop(acb);
 			/* has error report sensedata */
 			sensebuffer->ErrorCode = 0x70;
@@ -1451,6 +1451,8 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 			sensebuffer->AdditionalSenseLength = 0x0A;
 			sensebuffer->AdditionalSenseCode = 0x20;
 			sensebuffer->Valid = 1;
+			scsi_eh_cpy_sense(cmd, sensebuffer,
+							sizeof(*sensebuffer));
 			retvalue = ARCMSR_MESSAGE_FAIL;
 		} else {
 			my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
@@ -1471,14 +1473,18 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 					arcmsr_post_ioctldata2iop(acb);
 				}
 			} else {
-				/* has error report sensedata */
+				u8 sb[16];
 				struct SENSE_DATA *sensebuffer =
-					(struct SENSE_DATA *)cmd->sense_buffer;
+							(struct SENSE_DATA *)sb;
+				memset(sensebuffer, 0, sizeof(sensebuffer));
+				/* has error report sensedata */
 				sensebuffer->ErrorCode = 0x70;
 				sensebuffer->SenseKey = ILLEGAL_REQUEST;
 				sensebuffer->AdditionalSenseLength = 0x0A;
 				sensebuffer->AdditionalSenseCode = 0x20;
 				sensebuffer->Valid = 1;
+				scsi_eh_cpy_sense(cmd, sensebuffer,
+							sizeof(sensebuffer));
 				retvalue = ARCMSR_MESSAGE_FAIL;
 			}
 			}
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index fb5f202..6c200ac 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2009,7 +2009,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 		 * have valid data in the sense buffer that could
 		 * confuse the higher levels.
 		 */
-		memset(SCpnt->sense_buffer, 0, sizeof(SCpnt->sense_buffer));
+		scsi_eh_reset_sense(SCpnt);
 //printk("scsi%d.%c: sense buffer: ", info->host->host_no, '0' + SCpnt->device->id);
 //{ int i; for (i = 0; i < 32; i++) printk("%02x ", SCpnt->sense_buffer[i]); printk("\n"); }
 	/*
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 73270ff..46893f2 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4379,8 +4379,8 @@ static void ipr_erp_done(struct ipr_cmnd *ipr_cmd)
 		scmd_printk(KERN_ERR, scsi_cmd,
 			    "Request Sense failed with IOASC: 0x%08X\n", ioasc);
 	} else {
-		memcpy(scsi_cmd->sense_buffer, ipr_cmd->sense_buffer,
-		       SCSI_SENSE_BUFFERSIZE);
+		scsi_eh_cpy_sense(scsi_cmd, ipr_cmd->sense_buffer,
+		       sizeof(ipr_cmd->sense_buffer));
 	}
 
 	if (res) {
@@ -4574,12 +4574,12 @@ static void ipr_dump_ioasa(struct ipr_ioa_cfg *ioa_cfg,
 static void ipr_gen_sense(struct ipr_cmnd *ipr_cmd)
 {
 	u32 failing_lba;
-	u8 *sense_buf = ipr_cmd->scsi_cmd->sense_buffer;
+	u8 sense_buf[24];
 	struct ipr_resource_entry *res = ipr_cmd->scsi_cmd->device->hostdata;
 	struct ipr_ioasa *ioasa = &ipr_cmd->ioasa;
 	u32 ioasc = be32_to_cpu(ioasa->ioasc);
 
-	memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
+	memset(sense_buf, 0, sizeof(sense_buf));
 
 	if (ioasc >= IPR_FIRST_DRIVER_IOASC)
 		return;
@@ -4652,6 +4652,8 @@ static void ipr_gen_sense(struct ipr_cmnd *ipr_cmd)
 			sense_buf[7] = 6;	/* additional length */
 		}
 	}
+	scsi_eh_cpy_sense(ipr_cmd->scsi_cmd, sense_buf, sizeof(sense_buf));
+
 }
 
 /**
@@ -4671,9 +4673,8 @@ static int ipr_get_autosense(struct ipr_cmnd *ipr_cmd)
 	if ((be32_to_cpu(ioasa->ioasc_specific) & IPR_AUTOSENSE_VALID) == 0)
 		return 0;
 
-	memcpy(ipr_cmd->scsi_cmd->sense_buffer, ioasa->auto_sense.data,
-	       min_t(u16, be16_to_cpu(ioasa->auto_sense.auto_sense_len),
-		   SCSI_SENSE_BUFFERSIZE));
+	scsi_eh_cpy_sense(ipr_cmd->scsi_cmd, ioasa->auto_sense.data,
+			  be16_to_cpu(ioasa->auto_sense.auto_sense_len));
 	return 1;
 }
 
@@ -4836,7 +4837,7 @@ static int ipr_queuecommand(struct scsi_cmnd *scsi_cmd,
 	 *  and the ioa_is_dead check can be removed
 	 */
 	if (unlikely(ioa_cfg->ioa_is_dead || !res)) {
-		memset(scsi_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+		scsi_eh_reset_sense(scsi_cmd);
 		scsi_cmd->result = (DID_NO_CONNECT << 16);
 		scsi_cmd->scsi_done(scsi_cmd);
 		return 0;
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 7505cca..4760ed6 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3431,13 +3431,13 @@ ips_map_status(ips_ha_t * ha, ips_scb_t * scb, ips_stat_t * sp)
 					IPS_CMD_EXTENDED_DCDB_SG)) {
 					tapeDCDB =
 					    (IPS_DCDB_TABLE_TAPE *) & scb->dcdb;
-					memcpy(scb->scsi_cmd->sense_buffer,
+					scsi_eh_cpy_sense(scb->scsi_cmd,
 					       tapeDCDB->sense_info,
-					       SCSI_SENSE_BUFFERSIZE);
+					       sizeof(tapeDCDB->sense_info));
 				} else {
-					memcpy(scb->scsi_cmd->sense_buffer,
+					scsi_eh_cpy_sense(scb->scsi_cmd,
 					       scb->dcdb.sense_info,
-					       SCSI_SENSE_BUFFERSIZE);
+					       sizeof(scb->dcdb.sense_info));
 				}
 				device_error = 2;	/* check condition */
 			}
@@ -3571,7 +3571,7 @@ static int
 ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 {
 	int ret;
-	char *sp;
+	u8 sp[16];
 	int device_error;
 	IPS_DCDB_TABLE_TAPE *tapeDCDB;
 	int TimeOut;
@@ -3816,13 +3816,14 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 			/* Set the Return Info to appear like the Command was */
 			/* attempted, a Check Condition occurred, and Sense   */
 			/* Data indicating an Invalid CDB OpCode is returned. */
-			sp = (char *) scb->scsi_cmd->sense_buffer;
+			memset(sp, 0, sizeof(sp));
 
 			sp[0] = 0x70;	/* Error Code               */
 			sp[2] = ILLEGAL_REQUEST;	/* Sense Key 5 Illegal Req. */
 			sp[7] = 0x0A;	/* Additional Sense Length  */
 			sp[12] = 0x20;	/* ASC = Invalid OpCode     */
 			sp[13] = 0x00;	/* ASCQ                     */
+			scsi_eh_cpy_sense(scb->scsi_cmd, sp, sizeof(sp));
 
 			device_error = 2;	/* Indicate Check Condition */
 			scb->scsi_cmd->result = device_error | (DID_OK << 16);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 6db77c0..17718d6 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -70,6 +70,7 @@
  * For history of changes, see Documentation/ChangeLog.megaraid
  */
 
+#include <scsi/scsi_eh.h>
 #include "megaraid_mbox.h"
 
 static int megaraid_init(void);
@@ -1616,9 +1617,13 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			}
 
 			if (scp->cmnd[1] & MEGA_SCSI_INQ_EVPD) {
-				scp->sense_buffer[0] = 0x70;
-				scp->sense_buffer[2] = ILLEGAL_REQUEST;
-				scp->sense_buffer[12] = MEGA_INVALID_FIELD_IN_CDB;
+				u8 sense[14];
+
+				memset(sense, 0, sizeof(sense));
+				sense[0] = 0x70;
+				sense[2] = ILLEGAL_REQUEST;
+				sense[12] = MEGA_INVALID_FIELD_IN_CDB;
+				scsi_eh_cpy_sense(scp, sense, sizeof(sense));
 				scp->result = CHECK_CONDITION << 1;
 				return NULL;
 			}
@@ -2365,8 +2370,7 @@ megaraid_mbox_dpc(unsigned long devp)
 			if (mbox->cmd == MBOXCMD_PASSTHRU ||
 				mbox->cmd == MBOXCMD_PASSTHRU64) {
 
-				memcpy(scp->sense_buffer, pthru->reqsensearea,
-						14);
+				scsi_eh_cpy_sense(scp, pthru->reqsensearea, 14);
 
 				scp->result = DRIVER_SENSE << 24 |
 					DID_OK << 16 | CHECK_CONDITION << 1;
@@ -2374,15 +2378,19 @@ megaraid_mbox_dpc(unsigned long devp)
 			else {
 				if (mbox->cmd == MBOXCMD_EXTPTHRU) {
 
-					memcpy(scp->sense_buffer,
+					scsi_eh_cpy_sense(scp,
 						epthru->reqsensearea, 14);
 
 					scp->result = DRIVER_SENSE << 24 |
 						DID_OK << 16 |
 						CHECK_CONDITION << 1;
 				} else {
-					scp->sense_buffer[0] = 0x70;
-					scp->sense_buffer[2] = ABORTED_COMMAND;
+					u8 sn[4];
+
+					memset(sn, 0, sizeof(sn));
+					sn[0] = 0x70;
+					sn[2] = ABORTED_COMMAND;
+					scsi_eh_cpy_sense(scp, sn, sizeof(sn));
 					scp->result = CHECK_CONDITION << 1;
 				}
 			}
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 0cd614a..0a58033 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -323,10 +323,13 @@ static int ps3rom_queuecommand(struct scsi_cmnd *cmd,
 	}
 
 	if (res) {
-		memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+		u8 sense[4];
+
+		memset(sense, 0, sizeof(sense));
 		cmd->result = res;
-		cmd->sense_buffer[0] = 0x70;
-		cmd->sense_buffer[2] = ILLEGAL_REQUEST;
+		sense[0] = 0x70;
+		sense[2] = ILLEGAL_REQUEST;
+		scsi_eh_cpy_sense(cmd, sense, sizeof(sense);
 		priv->curr_cmd = NULL;
 		cmd->scsi_done(cmd);
 	}
@@ -399,17 +402,19 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 		goto done;
 	}
 
-	if (decode_lv1_status(status, &sense_key, &asc, &ascq)) {
+	if (!decode_lv1_status(status, &sense_key, &asc, &ascq)) {
+		u8 sense[14];
+
+		memset(sense, 0, sizeof(sense));
+		sense[0]  = 0x70;
+		sense[2]  = sense_key;
+		sense[7]  = 16 - 6;
+		sense[12] = asc;
+		sense[13] = ascq;
+		scsi_eh_cpy_sense(cmd, sense, sizeof(sense));
+		cmd->result = SAM_STAT_CHECK_CONDITION;
+	} else
 		cmd->result = DID_ERROR << 16;
-		goto done;
-	}
-
-	cmd->sense_buffer[0]  = 0x70;
-	cmd->sense_buffer[2]  = sense_key;
-	cmd->sense_buffer[7]  = 16 - 6;
-	cmd->sense_buffer[12] = asc;
-	cmd->sense_buffer[13] = ascq;
-	cmd->result = SAM_STAT_CHECK_CONDITION;
 
 done:
 	priv->curr_cmd = NULL;
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 68c0d09..2164858 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -362,6 +362,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_eh.h>
 
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 #include <asm/sn/io.h>
@@ -527,8 +528,6 @@ __setup("qla1280=", qla1280_setup);
 #define	CMD_SP(Cmnd)		&Cmnd->SCp
 #define	CMD_CDBLEN(Cmnd)	Cmnd->cmd_len
 #define	CMD_CDBP(Cmnd)		Cmnd->cmnd
-#define	CMD_SNSP(Cmnd)		Cmnd->sense_buffer
-#define	CMD_SNSLEN(Cmnd)	SCSI_SENSE_BUFFERSIZE
 #define	CMD_RESULT(Cmnd)	Cmnd->result
 #define	CMD_HANDLE(Cmnd)	Cmnd->host_scribble
 #define CMD_REQUEST(Cmnd)	Cmnd->request->cmd
@@ -3698,32 +3697,21 @@ qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 
 		if (scsi_status & SAM_STAT_CHECK_CONDITION) {
 			if (comp_status != CS_ARS_FAILED) {
-				uint16_t req_sense_length =
-					le16_to_cpu(pkt->req_sense_length);
-				if (req_sense_length < CMD_SNSLEN(cmd))
-					sense_sz = req_sense_length;
-				else
-					/*
-					 * scsi_cmnd->sense_buffer is
-					 * 64 bytes, why only copy 63?
-					 * This looks wrong! /Jes
-					 */
-					sense_sz = CMD_SNSLEN(cmd) - 1;
+				sense_sz = min_t(size_t,
+					sizeof(pkt->req_sense_data),
+					le16_to_cpu(pkt->req_sense_length));
 
-				memcpy(cmd->sense_buffer,
-				       &pkt->req_sense_data, sense_sz);
+				scsi_eh_cpy_sense(cmd, pkt->req_sense_data,
+								     sense_sz);
 			} else
 				sense_sz = 0;
-			memset(cmd->sense_buffer + sense_sz, 0,
-			       SCSI_SENSE_BUFFERSIZE - sense_sz);
 
 			dprintk(2, "qla1280_status_entry: Check "
 				"condition Sense data, b %i, t %i, "
 				"l %i\n", bus, target, lun);
 			if (sense_sz)
 				qla1280_dump_buffer(2,
-						    (char *)cmd->sense_buffer,
-						    sense_sz);
+					(char *)pkt->req_sense_data, sense_sz);
 		}
 	}
 
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 0f029d0..6daf119 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -10,6 +10,7 @@
 #include "ql4_dbg.h"
 #include "ql4_inline.h"
 
+#include <scsi/scsi_eh.h>
 /**
  * qla2x00_process_completed_request() - Process a Fast Post response.
  * @ha: SCSI driver HA context
@@ -123,14 +124,11 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			break;
 
 		/* Copy Sense Data into sense buffer. */
-		memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-
 		sensebytecnt = le16_to_cpu(sts_entry->senseDataByteCnt);
 		if (sensebytecnt == 0)
 			break;
 
-		memcpy(cmd->sense_buffer, sts_entry->senseData,
-		       min_t(uint16_t, sensebytecnt, SCSI_SENSE_BUFFERSIZE));
+		scsi_eh_cpy_sense(cmd, sts_entry->senseData, sensebytecnt);
 
 		DEBUG2(printk("scsi%ld:%d:%d:%d: %s: sense key = %x, "
 			      "ASC/ASCQ = %02x/%02x\n", ha->host_no,
@@ -207,15 +205,13 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 				break;
 
 			/* Copy Sense Data into sense buffer. */
-			memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-
 			sensebytecnt =
 				le16_to_cpu(sts_entry->senseDataByteCnt);
 			if (sensebytecnt == 0)
 				break;
 
-			memcpy(cmd->sense_buffer, sts_entry->senseData,
-			       min_t(uint16_t, sensebytecnt, SCSI_SENSE_BUFFERSIZE));
+			scsi_eh_cpy_sense(cmd, sts_entry->senseData,
+								sensebytecnt);
 
 			DEBUG2(printk("scsi%ld:%d:%d:%d: %s: sense key = %x, "
 				      "ASC/ASCQ = %02x/%02x\n", ha->host_no,
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 72f6d80..f26b980 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
 
 #define DRV_NAME "stex"
 #define ST_DRIVER_VERSION "3.6.0000.1"
@@ -290,8 +291,6 @@ struct st_ccb {
 	struct req_msg *req;
 	struct scsi_cmnd *cmd;
 
-	void *sense_buffer;
-	unsigned int sense_bufflen;
 	int sg_count;
 
 	u32 req_type;
@@ -364,13 +363,18 @@ static struct status_msg *stex_get_status(struct st_hba *hba)
 
 static void stex_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 {
+	u8 sense_buffer[14];
+
+	memset(sense_buffer, 0, sizeof(sense_buffer));
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
-	cmd->sense_buffer[0] = 0x70;    /* fixed format, current */
-	cmd->sense_buffer[2] = sk;
-	cmd->sense_buffer[7] = 18 - 8;  /* additional sense length */
-	cmd->sense_buffer[12] = asc;
-	cmd->sense_buffer[13] = ascq;
+	sense_buffer[0] = 0x70;    /* fixed format, current */
+	sense_buffer[2] = sk;
+	sense_buffer[7] = 18 - 8;  /* additional sense length */
+	sense_buffer[12] = asc;
+	sense_buffer[13] = ascq;
+
+	scsi_eh_cpy_sense(cmd, sense_buffer, sizeof(sense_buffer));
 }
 
 static void stex_invalid_field(struct scsi_cmnd *cmd,
@@ -642,8 +646,6 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 	memcpy(req->cdb, cmd->cmnd, STEX_CDB_LENGTH);
 
 	hba->ccb[tag].cmd = cmd;
-	hba->ccb[tag].sense_bufflen = SCSI_SENSE_BUFFERSIZE;
-	hba->ccb[tag].sense_buffer = cmd->sense_buffer;
 	hba->ccb[tag].req_type = 0;
 
 	if (cmd->sc_data_direction != DMA_NONE)
@@ -699,15 +701,14 @@ static void stex_copy_data(struct st_ccb *ccb,
 	struct status_msg *resp, unsigned int variable)
 {
 	size_t count = variable;
+
+	if (ccb->cmd == NULL)
+		return;
 	if (resp->scsi_status != SAM_STAT_GOOD) {
-		if (ccb->sense_buffer != NULL)
-			memcpy(ccb->sense_buffer, resp->variable,
-				min(variable, ccb->sense_bufflen));
+		scsi_eh_cpy_sense(ccb->cmd, resp->variable, variable);
 		return;
 	}
 
-	if (ccb->cmd == NULL)
-		return;
 	stex_internal_copy(ccb->cmd,
 		resp->variable, &count, ccb->sg_count, ST_TO_CMD);
 }
@@ -1295,8 +1296,6 @@ static void stex_hba_stop(struct st_hba *hba)
 
 	hba->ccb[tag].cmd = NULL;
 	hba->ccb[tag].sg_count = 0;
-	hba->ccb[tag].sense_bufflen = 0;
-	hba->ccb[tag].sense_buffer = NULL;
 	hba->ccb[tag].req_type |= PASSTHRU_REQ_TYPE;
 
 	stex_send_cmd(hba, req, tag);
-- 
1.5.3.3

