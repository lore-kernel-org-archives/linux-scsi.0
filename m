From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 07/24] aacraid: Process Error for response I/O
Date: Mon, 23 Jan 2017 10:08:51 -0800
Message-ID: <20170123180908.3465-8-RaghavaAditya.Renukunta@microsemi.com>
References: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0086.outbound.protection.outlook.com ([104.47.38.86]:51544
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751838AbdAXBBo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 20:01:44 -0500
In-Reply-To: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Banesh@microsemi.com

Make sure that the driver processes error conditions even in the fast
response path for response from the adapter.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c | 289 ++++++++++++++++++++++--------------------
 1 file changed, 151 insertions(+), 138 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index db73216..c6eb8a5 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -3065,16 +3065,11 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 		return;
 
 	BUG_ON(fibptr == NULL);
-	dev = fibptr->dev;
-
-	scsi_dma_unmap(scsicmd);
 
-	/* expose physical device if expose_physicald flag is on */
-	if (scsicmd->cmnd[0] == INQUIRY && !(scsicmd->cmnd[1] & 0x01)
-	  && expose_physicals > 0)
-		aac_expose_phy_device(scsicmd);
+	dev = fibptr->dev;
 
 	srbreply = (struct aac_srb_reply *) fib_data(fibptr);
+
 	scsicmd->sense_buffer[0] = '\0';  /* Initialize sense valid flag to false */
 
 	if (fibptr->flags & FIB_CONTEXT_FLAG_FASTRESP) {
@@ -3087,158 +3082,176 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 		 */
 		scsi_set_resid(scsicmd, scsi_bufflen(scsicmd)
 				   - le32_to_cpu(srbreply->data_xfer_length));
-		/*
-		 * First check the fib status
-		 */
+	}
 
-		if (le32_to_cpu(srbreply->status) != ST_OK) {
-			int len;
 
-			printk(KERN_WARNING "aac_srb_callback: srb failed, status = %d\n", le32_to_cpu(srbreply->status));
-			len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
-				    SCSI_SENSE_BUFFERSIZE);
-			scsicmd->result = DID_ERROR << 16
-						| COMMAND_COMPLETE << 8
-						| SAM_STAT_CHECK_CONDITION;
-			memcpy(scsicmd->sense_buffer,
-					srbreply->sense_data, len);
-		}
+	scsi_dma_unmap(scsicmd);
 
-		/*
-		 * Next check the srb status
-		 */
-		switch ((le32_to_cpu(srbreply->srb_status))&0x3f) {
-		case SRB_STATUS_ERROR_RECOVERY:
-		case SRB_STATUS_PENDING:
-		case SRB_STATUS_SUCCESS:
-			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
-			break;
-		case SRB_STATUS_DATA_OVERRUN:
-			switch (scsicmd->cmnd[0]) {
-			case  READ_6:
-			case  WRITE_6:
-			case  READ_10:
-			case  WRITE_10:
-			case  READ_12:
-			case  WRITE_12:
-			case  READ_16:
-			case  WRITE_16:
-				if (le32_to_cpu(srbreply->data_xfer_length)
-							< scsicmd->underflow)
-					printk(KERN_WARNING"aacraid: SCSI CMD underflow\n");
-				else
-					printk(KERN_WARNING"aacraid: SCSI CMD Data Overrun\n");
-				scsicmd->result = DID_ERROR << 16
-							| COMMAND_COMPLETE << 8;
-				break;
-			case INQUIRY: {
-				scsicmd->result = DID_OK << 16
-							| COMMAND_COMPLETE << 8;
-				break;
-			}
-			default:
-				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
-				break;
-			}
-			break;
-		case SRB_STATUS_ABORTED:
-			scsicmd->result = DID_ABORT << 16 | ABORT << 8;
-			break;
-		case SRB_STATUS_ABORT_FAILED:
-			/*
-			 * Not sure about this one - but assuming the
-			 * hba was trying to abort for some reason
-			 */
-			scsicmd->result = DID_ERROR << 16 | ABORT << 8;
-			break;
-		case SRB_STATUS_PARITY_ERROR:
-			scsicmd->result = DID_PARITY << 16
-						| MSG_PARITY_ERROR << 8;
-			break;
-		case SRB_STATUS_NO_DEVICE:
-		case SRB_STATUS_INVALID_PATH_ID:
-		case SRB_STATUS_INVALID_TARGET_ID:
-		case SRB_STATUS_INVALID_LUN:
-		case SRB_STATUS_SELECTION_TIMEOUT:
-			scsicmd->result = DID_NO_CONNECT << 16
-						| COMMAND_COMPLETE << 8;
-			break;
+	/* expose physical device if expose_physicald flag is on */
+	if (scsicmd->cmnd[0] == INQUIRY && !(scsicmd->cmnd[1] & 0x01)
+	  && expose_physicals > 0)
+		aac_expose_phy_device(scsicmd);
 
-		case SRB_STATUS_COMMAND_TIMEOUT:
-		case SRB_STATUS_TIMEOUT:
-			scsicmd->result = DID_TIME_OUT << 16
-						| COMMAND_COMPLETE << 8;
-			break;
+	/*
+	 * First check the fib status
+	 */
 
-		case SRB_STATUS_BUSY:
-			scsicmd->result = DID_BUS_BUSY << 16
-						| COMMAND_COMPLETE << 8;
-			break;
+	if (le32_to_cpu(srbreply->status) != ST_OK) {
+		int len;
 
-		case SRB_STATUS_BUS_RESET:
-			scsicmd->result = DID_RESET << 16
-						| COMMAND_COMPLETE << 8;
-			break;
+		pr_warn("aac_srb_callback: srb failed, status = %d\n",
+				le32_to_cpu(srbreply->status));
+		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
+			    SCSI_SENSE_BUFFERSIZE);
+		scsicmd->result = DID_ERROR << 16
+				| COMMAND_COMPLETE << 8
+				| SAM_STAT_CHECK_CONDITION;
+		memcpy(scsicmd->sense_buffer,
+				srbreply->sense_data, len);
+	}
 
-		case SRB_STATUS_MESSAGE_REJECTED:
+	/*
+	 * Next check the srb status
+	 */
+	switch ((le32_to_cpu(srbreply->srb_status))&0x3f) {
+	case SRB_STATUS_ERROR_RECOVERY:
+	case SRB_STATUS_PENDING:
+	case SRB_STATUS_SUCCESS:
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+		break;
+	case SRB_STATUS_DATA_OVERRUN:
+		switch (scsicmd->cmnd[0]) {
+		case  READ_6:
+		case  WRITE_6:
+		case  READ_10:
+		case  WRITE_10:
+		case  READ_12:
+		case  WRITE_12:
+		case  READ_16:
+		case  WRITE_16:
+			if (le32_to_cpu(srbreply->data_xfer_length)
+						< scsicmd->underflow)
+				pr_warn("aacraid: SCSI CMD underflow\n");
+			else
+				pr_warn("aacraid: SCSI CMD Data Overrun\n");
 			scsicmd->result = DID_ERROR << 16
-						| MESSAGE_REJECT << 8;
+					| COMMAND_COMPLETE << 8;
+			break;
+		case INQUIRY:
+			scsicmd->result = DID_OK << 16
+					| COMMAND_COMPLETE << 8;
 			break;
-		case SRB_STATUS_REQUEST_FLUSHED:
-		case SRB_STATUS_ERROR:
-		case SRB_STATUS_INVALID_REQUEST:
-		case SRB_STATUS_REQUEST_SENSE_FAILED:
-		case SRB_STATUS_NO_HBA:
-		case SRB_STATUS_UNEXPECTED_BUS_FREE:
-		case SRB_STATUS_PHASE_SEQUENCE_FAILURE:
-		case SRB_STATUS_BAD_SRB_BLOCK_LENGTH:
-		case SRB_STATUS_DELAYED_RETRY:
-		case SRB_STATUS_BAD_FUNCTION:
-		case SRB_STATUS_NOT_STARTED:
-		case SRB_STATUS_NOT_IN_USE:
-		case SRB_STATUS_FORCE_ABORT:
-		case SRB_STATUS_DOMAIN_VALIDATION_FAIL:
 		default:
+			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			break;
+		}
+		break;
+	case SRB_STATUS_ABORTED:
+		scsicmd->result = DID_ABORT << 16 | ABORT << 8;
+		break;
+	case SRB_STATUS_ABORT_FAILED:
+		/*
+		 * Not sure about this one - but assuming the
+		 * hba was trying to abort for some reason
+		 */
+		scsicmd->result = DID_ERROR << 16 | ABORT << 8;
+		break;
+	case SRB_STATUS_PARITY_ERROR:
+		scsicmd->result = DID_PARITY << 16
+				| MSG_PARITY_ERROR << 8;
+		break;
+	case SRB_STATUS_NO_DEVICE:
+	case SRB_STATUS_INVALID_PATH_ID:
+	case SRB_STATUS_INVALID_TARGET_ID:
+	case SRB_STATUS_INVALID_LUN:
+	case SRB_STATUS_SELECTION_TIMEOUT:
+		scsicmd->result = DID_NO_CONNECT << 16
+				| COMMAND_COMPLETE << 8;
+		break;
+
+	case SRB_STATUS_COMMAND_TIMEOUT:
+	case SRB_STATUS_TIMEOUT:
+		scsicmd->result = DID_TIME_OUT << 16
+				| COMMAND_COMPLETE << 8;
+		break;
+
+	case SRB_STATUS_BUSY:
+		scsicmd->result = DID_BUS_BUSY << 16
+				| COMMAND_COMPLETE << 8;
+		break;
+
+	case SRB_STATUS_BUS_RESET:
+		scsicmd->result = DID_RESET << 16
+				| COMMAND_COMPLETE << 8;
+		break;
+
+	case SRB_STATUS_MESSAGE_REJECTED:
+		scsicmd->result = DID_ERROR << 16
+				| MESSAGE_REJECT << 8;
+		break;
+	case SRB_STATUS_REQUEST_FLUSHED:
+	case SRB_STATUS_ERROR:
+	case SRB_STATUS_INVALID_REQUEST:
+	case SRB_STATUS_REQUEST_SENSE_FAILED:
+	case SRB_STATUS_NO_HBA:
+	case SRB_STATUS_UNEXPECTED_BUS_FREE:
+	case SRB_STATUS_PHASE_SEQUENCE_FAILURE:
+	case SRB_STATUS_BAD_SRB_BLOCK_LENGTH:
+	case SRB_STATUS_DELAYED_RETRY:
+	case SRB_STATUS_BAD_FUNCTION:
+	case SRB_STATUS_NOT_STARTED:
+	case SRB_STATUS_NOT_IN_USE:
+	case SRB_STATUS_FORCE_ABORT:
+	case SRB_STATUS_DOMAIN_VALIDATION_FAIL:
+	default:
 #ifdef AAC_DETAILED_STATUS_INFO
-			printk(KERN_INFO "aacraid: SRB ERROR(%u) %s scsi cmd 0x%x - scsi status 0x%x\n",
-				le32_to_cpu(srbreply->srb_status) & 0x3F,
-				aac_get_status_string(
-					le32_to_cpu(srbreply->srb_status) & 0x3F),
-				scsicmd->cmnd[0],
-				le32_to_cpu(srbreply->scsi_status));
+		pr_info("aacraid: SRB ERROR(%u) %s scsi cmd 0x%x -scsi status 0x%x\n",
+			le32_to_cpu(srbreply->srb_status) & 0x3F,
+			aac_get_status_string(
+				le32_to_cpu(srbreply->srb_status) & 0x3F),
+			scsicmd->cmnd[0],
+			le32_to_cpu(srbreply->scsi_status));
 #endif
-			if ((scsicmd->cmnd[0] == ATA_12)
-				|| (scsicmd->cmnd[0] == ATA_16)) {
-					if (scsicmd->cmnd[2] & (0x01 << 5)) {
-						scsicmd->result = DID_OK << 16
-							| COMMAND_COMPLETE << 8;
-				break;
-				} else {
-					scsicmd->result = DID_ERROR << 16
-						| COMMAND_COMPLETE << 8;
-					break;
-				}
+		/*
+		 * When the CC bit is SET by the host in ATA pass thru CDB,
+		 *  driver is supposed to return DID_OK
+		 *
+		 * When the CC bit is RESET by the host, driver should
+		 *  return DID_ERROR
+		 */
+		if ((scsicmd->cmnd[0] == ATA_12)
+			|| (scsicmd->cmnd[0] == ATA_16)) {
+
+			if (scsicmd->cmnd[2] & (0x01 << 5)) {
+				scsicmd->result = DID_OK << 16
+					| COMMAND_COMPLETE << 8;
+			break;
 			} else {
 				scsicmd->result = DID_ERROR << 16
 					| COMMAND_COMPLETE << 8;
-				break;
+			break;
 			}
+		} else {
+			scsicmd->result = DID_ERROR << 16
+				| COMMAND_COMPLETE << 8;
+			break;
 		}
-		if (le32_to_cpu(srbreply->scsi_status)
-				== SAM_STAT_CHECK_CONDITION) {
-			int len;
+	}
+	if (le32_to_cpu(srbreply->scsi_status)
+			== SAM_STAT_CHECK_CONDITION) {
+		int len;
 
-			scsicmd->result |= SAM_STAT_CHECK_CONDITION;
-			len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
-				    SCSI_SENSE_BUFFERSIZE);
+		scsicmd->result |= SAM_STAT_CHECK_CONDITION;
+		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
+			    SCSI_SENSE_BUFFERSIZE);
 #ifdef AAC_DETAILED_STATUS_INFO
-			printk(KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n",
-						le32_to_cpu(srbreply->status), len);
+		pr_warn("aac_srb_callback: check condition, status = %d len=%d\n",
+					le32_to_cpu(srbreply->status), len);
 #endif
-			memcpy(scsicmd->sense_buffer,
-					srbreply->sense_data, len);
-		}
+		memcpy(scsicmd->sense_buffer,
+				srbreply->sense_data, len);
 	}
+
 	/*
 	 * OR in the scsi status (already shifted up a bit)
 	 */
-- 
2.7.4

