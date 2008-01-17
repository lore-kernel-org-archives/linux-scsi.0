From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Consolidate duplicate sense-data handling codes.
Date: Thu, 17 Jan 2008 09:02:07 -0800
Message-ID: <1200589340-19499-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20835 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYAQRC3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:29 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   85 ++++++++++++++-------------------------
 1 files changed, 31 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 53cbaff..5d2dc92 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -822,6 +822,35 @@ qla2x00_process_response_queue(struct scsi_qla_host *ha)
 	WRT_REG_WORD(ISP_RSP_Q_OUT(ha, reg), ha->rsp_ring_index);
 }
 
+static inline void
+qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
+{
+	struct scsi_cmnd *cp = sp->cmd;
+
+	if (sense_len >= SCSI_SENSE_BUFFERSIZE)
+		sense_len = SCSI_SENSE_BUFFERSIZE;
+
+	CMD_ACTUAL_SNSLEN(cp) = sense_len;
+	sp->request_sense_length = sense_len;
+	sp->request_sense_ptr = cp->sense_buffer;
+	if (sp->request_sense_length > 32)
+		sense_len = 32;
+
+	memcpy(cp->sense_buffer, sense_data, sense_len);
+
+	sp->request_sense_ptr += sense_len;
+	sp->request_sense_length -= sense_len;
+	if (sp->request_sense_length != 0)
+		sp->ha->status_srb = sp;
+
+	DEBUG5(printk("%s(): Check condition Sense data, scsi(%ld:%d:%d:%d) "
+	    "cmd=%p pid=%ld\n", __func__, sp->ha->host_no, cp->device->channel,
+	    cp->device->id, cp->device->lun, cp, cp->serial_number));
+	if (sense_len)
+		DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
+		    CMD_ACTUAL_SNSLEN(cp)));
+}
+
 /**
  * qla2x00_status_entry() - Process a Status IOCB entry.
  * @ha: SCSI driver HA context
@@ -976,36 +1005,11 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		if (lscsi_status != SS_CHECK_CONDITION)
 			break;
 
-		/* Copy Sense Data into sense buffer. */
 		memset(cp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-
 		if (!(scsi_status & SS_SENSE_LEN_VALID))
 			break;
 
-		if (sense_len >= SCSI_SENSE_BUFFERSIZE)
-			sense_len = SCSI_SENSE_BUFFERSIZE;
-
-		CMD_ACTUAL_SNSLEN(cp) = sense_len;
-		sp->request_sense_length = sense_len;
-		sp->request_sense_ptr = cp->sense_buffer;
-
-		if (sp->request_sense_length > 32)
-			sense_len = 32;
-
-		memcpy(cp->sense_buffer, sense_data, sense_len);
-
-		sp->request_sense_ptr += sense_len;
-		sp->request_sense_length -= sense_len;
-		if (sp->request_sense_length != 0)
-			ha->status_srb = sp;
-
-		DEBUG5(printk("%s(): Check condition Sense data, "
-		    "scsi(%ld:%d:%d:%d) cmd=%p pid=%ld\n", __func__,
-		    ha->host_no, cp->device->channel, cp->device->id,
-		    cp->device->lun, cp, cp->serial_number));
-		if (sense_len)
-			DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
-			    CMD_ACTUAL_SNSLEN(cp)));
+		qla2x00_handle_sense(sp, sense_data, sense_len);
 		break;
 
 	case CS_DATA_UNDERRUN:
@@ -1060,34 +1064,11 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 			if (lscsi_status != SS_CHECK_CONDITION)
 				break;
 
-			/* Copy Sense Data into sense buffer */
 			memset(cp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-
 			if (!(scsi_status & SS_SENSE_LEN_VALID))
 				break;
 
-			if (sense_len >= SCSI_SENSE_BUFFERSIZE)
-				sense_len = SCSI_SENSE_BUFFERSIZE;
-
-			CMD_ACTUAL_SNSLEN(cp) = sense_len;
-			sp->request_sense_length = sense_len;
-			sp->request_sense_ptr = cp->sense_buffer;
-
-			if (sp->request_sense_length > 32)
-				sense_len = 32;
-
-			memcpy(cp->sense_buffer, sense_data, sense_len);
-
-			sp->request_sense_ptr += sense_len;
-			sp->request_sense_length -= sense_len;
-			if (sp->request_sense_length != 0)
-				ha->status_srb = sp;
-
-			DEBUG5(printk("%s(): Check condition Sense data, "
-			    "scsi(%ld:%d:%d:%d) cmd=%p pid=%ld\n",
-			    __func__, ha->host_no, cp->device->channel,
-			    cp->device->id, cp->device->lun, cp,
-			    cp->serial_number));
+			qla2x00_handle_sense(sp, sense_data, sense_len);
 
 			/*
 			 * In case of a Underrun condition, set both the lscsi
@@ -1107,10 +1088,6 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 
 				cp->result = DID_ERROR << 16 | lscsi_status;
 			}
-
-			if (sense_len)
-				DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
-				    CMD_ACTUAL_SNSLEN(cp)));
 		} else {
 			/*
 			 * If RISC reports underrun and target does not report
-- 
1.5.4.rc3.14.g44397

