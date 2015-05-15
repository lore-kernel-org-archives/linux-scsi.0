From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH 5/9] [SCSI] aacraid: Tune response path if IsFastPath
 bit set
Date: Fri, 15 May 2015 02:57:19 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F6ACC9@BBYEXM01.pmc-sierra.internal>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1431562378-8514-6-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:38677 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423341AbbEOC5V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2015 22:57:21 -0400
In-Reply-To: <1431562378-8514-6-git-send-email-rajinikanth.pandurangan@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>

Reviewed-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

-----Original Message-----
From: rajinikanth.pandurangan@pmcs.com [mailto:rajinikanth.pandurangan@pmcs.com] 
Sent: Thursday, May 14, 2015 5:43 AM
To: jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Achim Leubner; Murthy Bhat; Rajinikanth Pandurangan
Subject: [PATCH 5/9] [SCSI] aacraid: Tune response path if IsFastPath bit set

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
        If 'IsFastPath' bit is set, then response path assumes no error
        and skips error check.

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/aachba.c | 259 ++++++++++++++++++++++--------------------
 1 file changed, 137 insertions(+), 122 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c index fe59b00..864e9f6 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2977,11 +2977,16 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 		return;
 
 	BUG_ON(fibptr == NULL);
-
 	dev = fibptr->dev;
 
-	srbreply = (struct aac_srb_reply *) fib_data(fibptr);
+	scsi_dma_unmap(scsicmd);
 
+	/* expose physical device if expose_physicald flag is on */
+	if (scsicmd->cmnd[0] == INQUIRY && !(scsicmd->cmnd[1] & 0x01)
+	  && expose_physicals > 0)
+		aac_expose_phy_device(scsicmd);
+
+	srbreply = (struct aac_srb_reply *) fib_data(fibptr);
 	scsicmd->sense_buffer[0] = '\0';  /* Initialize sense valid flag to false */
 
 	if (fibptr->flags & FIB_CONTEXT_FLAG_FASTRESP) { @@ -2994,147 +2999,157 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 		 */
 		scsi_set_resid(scsicmd, scsi_bufflen(scsicmd)
 				   - le32_to_cpu(srbreply->data_xfer_length));
-	}
-
-	scsi_dma_unmap(scsicmd);
-
-	/* expose physical device if expose_physicald flag is on */
-	if (scsicmd->cmnd[0] == INQUIRY && !(scsicmd->cmnd[1] & 0x01)
-	  && expose_physicals > 0)
-		aac_expose_phy_device(scsicmd);
+		/*
+		 * First check the fib status
+		 */
 
-	/*
-	 * First check the fib status
-	 */
+		if (le32_to_cpu(srbreply->status) != ST_OK) {
+			int len;
 
-	if (le32_to_cpu(srbreply->status) != ST_OK){
-		int len;
-		printk(KERN_WARNING "aac_srb_callback: srb failed, status = %d\n", le32_to_cpu(srbreply->status));
-		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
-			    SCSI_SENSE_BUFFERSIZE);
-		scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
-		memcpy(scsicmd->sense_buffer, srbreply->sense_data, len);
-	}
+			printk(KERN_WARNING "aac_srb_callback: srb failed, status = %d\n", le32_to_cpu(srbreply->status));
+			len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
+				    SCSI_SENSE_BUFFERSIZE);
+			scsicmd->result = DID_ERROR << 16
+						| COMMAND_COMPLETE << 8
+						| SAM_STAT_CHECK_CONDITION;
+			memcpy(scsicmd->sense_buffer,
+					srbreply->sense_data, len);
+		}
 
-	/*
-	 * Next check the srb status
-	 */
-	switch( (le32_to_cpu(srbreply->srb_status))&0x3f){
-	case SRB_STATUS_ERROR_RECOVERY:
-	case SRB_STATUS_PENDING:
-	case SRB_STATUS_SUCCESS:
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
-		break;
-	case SRB_STATUS_DATA_OVERRUN:
-		switch(scsicmd->cmnd[0]){
-		case  READ_6:
-		case  WRITE_6:
-		case  READ_10:
-		case  WRITE_10:
-		case  READ_12:
-		case  WRITE_12:
-		case  READ_16:
-		case  WRITE_16:
-			if (le32_to_cpu(srbreply->data_xfer_length) < scsicmd->underflow) {
-				printk(KERN_WARNING"aacraid: SCSI CMD underflow\n");
-			} else {
-				printk(KERN_WARNING"aacraid: SCSI CMD Data Overrun\n");
+		/*
+		 * Next check the srb status
+		 */
+		switch ((le32_to_cpu(srbreply->srb_status))&0x3f) {
+		case SRB_STATUS_ERROR_RECOVERY:
+		case SRB_STATUS_PENDING:
+		case SRB_STATUS_SUCCESS:
+			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			break;
+		case SRB_STATUS_DATA_OVERRUN:
+			switch (scsicmd->cmnd[0]) {
+			case  READ_6:
+			case  WRITE_6:
+			case  READ_10:
+			case  WRITE_10:
+			case  READ_12:
+			case  WRITE_12:
+			case  READ_16:
+			case  WRITE_16:
+				if (le32_to_cpu(srbreply->data_xfer_length)
+							< scsicmd->underflow)
+					printk(KERN_WARNING"aacraid: SCSI CMD underflow\n");
+				else
+					printk(KERN_WARNING"aacraid: SCSI CMD Data Overrun\n");
+				scsicmd->result = DID_ERROR << 16
+							| COMMAND_COMPLETE << 8;
+				break;
+			case INQUIRY: {
+				scsicmd->result = DID_OK << 16
+							| COMMAND_COMPLETE << 8;
+				break;
+			}
+			default:
+				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+				break;
 			}
-			scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
 			break;
-		case INQUIRY: {
-			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+		case SRB_STATUS_ABORTED:
+			scsicmd->result = DID_ABORT << 16 | ABORT << 8;
 			break;
-		}
-		default:
-			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+		case SRB_STATUS_ABORT_FAILED:
+			/*
+			 * Not sure about this one - but assuming the
+			 * hba was trying to abort for some reason
+			 */
+			scsicmd->result = DID_ERROR << 16 | ABORT << 8;
+			break;
+		case SRB_STATUS_PARITY_ERROR:
+			scsicmd->result = DID_PARITY << 16
+						| MSG_PARITY_ERROR << 8;
+			break;
+		case SRB_STATUS_NO_DEVICE:
+		case SRB_STATUS_INVALID_PATH_ID:
+		case SRB_STATUS_INVALID_TARGET_ID:
+		case SRB_STATUS_INVALID_LUN:
+		case SRB_STATUS_SELECTION_TIMEOUT:
+			scsicmd->result = DID_NO_CONNECT << 16
+						| COMMAND_COMPLETE << 8;
 			break;
-		}
-		break;
-	case SRB_STATUS_ABORTED:
-		scsicmd->result = DID_ABORT << 16 | ABORT << 8;
-		break;
-	case SRB_STATUS_ABORT_FAILED:
-		// Not sure about this one - but assuming the hba was trying to abort for some reason
-		scsicmd->result = DID_ERROR << 16 | ABORT << 8;
-		break;
-	case SRB_STATUS_PARITY_ERROR:
-		scsicmd->result = DID_PARITY << 16 | MSG_PARITY_ERROR << 8;
-		break;
-	case SRB_STATUS_NO_DEVICE:
-	case SRB_STATUS_INVALID_PATH_ID:
-	case SRB_STATUS_INVALID_TARGET_ID:
-	case SRB_STATUS_INVALID_LUN:
-	case SRB_STATUS_SELECTION_TIMEOUT:
-		scsicmd->result = DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
-		break;
 
-	case SRB_STATUS_COMMAND_TIMEOUT:
-	case SRB_STATUS_TIMEOUT:
-		scsicmd->result = DID_TIME_OUT << 16 | COMMAND_COMPLETE << 8;
-		break;
+		case SRB_STATUS_COMMAND_TIMEOUT:
+		case SRB_STATUS_TIMEOUT:
+			scsicmd->result = DID_TIME_OUT << 16
+						| COMMAND_COMPLETE << 8;
+			break;
 
-	case SRB_STATUS_BUSY:
-		scsicmd->result = DID_BUS_BUSY << 16 | COMMAND_COMPLETE << 8;
-		break;
+		case SRB_STATUS_BUSY:
+			scsicmd->result = DID_BUS_BUSY << 16
+						| COMMAND_COMPLETE << 8;
+			break;
 
-	case SRB_STATUS_BUS_RESET:
-		scsicmd->result = DID_RESET << 16 | COMMAND_COMPLETE << 8;
-		break;
+		case SRB_STATUS_BUS_RESET:
+			scsicmd->result = DID_RESET << 16
+						| COMMAND_COMPLETE << 8;
+			break;
 
-	case SRB_STATUS_MESSAGE_REJECTED:
-		scsicmd->result = DID_ERROR << 16 | MESSAGE_REJECT << 8;
-		break;
-	case SRB_STATUS_REQUEST_FLUSHED:
-	case SRB_STATUS_ERROR:
-	case SRB_STATUS_INVALID_REQUEST:
-	case SRB_STATUS_REQUEST_SENSE_FAILED:
-	case SRB_STATUS_NO_HBA:
-	case SRB_STATUS_UNEXPECTED_BUS_FREE:
-	case SRB_STATUS_PHASE_SEQUENCE_FAILURE:
-	case SRB_STATUS_BAD_SRB_BLOCK_LENGTH:
-	case SRB_STATUS_DELAYED_RETRY:
-	case SRB_STATUS_BAD_FUNCTION:
-	case SRB_STATUS_NOT_STARTED:
-	case SRB_STATUS_NOT_IN_USE:
-	case SRB_STATUS_FORCE_ABORT:
-	case SRB_STATUS_DOMAIN_VALIDATION_FAIL:
-	default:
+		case SRB_STATUS_MESSAGE_REJECTED:
+			scsicmd->result = DID_ERROR << 16
+						| MESSAGE_REJECT << 8;
+			break;
+		case SRB_STATUS_REQUEST_FLUSHED:
+		case SRB_STATUS_ERROR:
+		case SRB_STATUS_INVALID_REQUEST:
+		case SRB_STATUS_REQUEST_SENSE_FAILED:
+		case SRB_STATUS_NO_HBA:
+		case SRB_STATUS_UNEXPECTED_BUS_FREE:
+		case SRB_STATUS_PHASE_SEQUENCE_FAILURE:
+		case SRB_STATUS_BAD_SRB_BLOCK_LENGTH:
+		case SRB_STATUS_DELAYED_RETRY:
+		case SRB_STATUS_BAD_FUNCTION:
+		case SRB_STATUS_NOT_STARTED:
+		case SRB_STATUS_NOT_IN_USE:
+		case SRB_STATUS_FORCE_ABORT:
+		case SRB_STATUS_DOMAIN_VALIDATION_FAIL:
+		default:
 #ifdef AAC_DETAILED_STATUS_INFO
-		printk("aacraid: SRB ERROR(%u) %s scsi cmd 0x%x - scsi status 0x%x\n",
-			le32_to_cpu(srbreply->srb_status) & 0x3F,
-			aac_get_status_string(
-				le32_to_cpu(srbreply->srb_status) & 0x3F),
-			scsicmd->cmnd[0],
-			le32_to_cpu(srbreply->scsi_status));
+			printk(KERN_INFO "aacraid: SRB ERROR(%u) %s scsi cmd 0x%x - scsi status 0x%x\n",
+				le32_to_cpu(srbreply->srb_status) & 0x3F,
+				aac_get_status_string(
+					le32_to_cpu(srbreply->srb_status) & 0x3F),
+				scsicmd->cmnd[0],
+				le32_to_cpu(srbreply->scsi_status));
 #endif
-		if ((scsicmd->cmnd[0] == ATA_12)
-		  || (scsicmd->cmnd[0] == ATA_16)) {
-			if (scsicmd->cmnd[2] & (0x01 << 5)) {
-				scsicmd->result = DID_OK << 16
-						| COMMAND_COMPLETE << 8;
+			if ((scsicmd->cmnd[0] == ATA_12)
+				|| (scsicmd->cmnd[0] == ATA_16)) {
+					if (scsicmd->cmnd[2] & (0x01 << 5)) {
+						scsicmd->result = DID_OK << 16
+							| COMMAND_COMPLETE << 8;
 				break;
+				} else {
+					scsicmd->result = DID_ERROR << 16
+						| COMMAND_COMPLETE << 8;
+					break;
+				}
 			} else {
 				scsicmd->result = DID_ERROR << 16
-						| COMMAND_COMPLETE << 8;
+					| COMMAND_COMPLETE << 8;
 				break;
 			}
-		} else {
-			scsicmd->result = DID_ERROR << 16
-					| COMMAND_COMPLETE << 8;
-			break;
 		}
-	}
-	if (le32_to_cpu(srbreply->scsi_status) == SAM_STAT_CHECK_CONDITION) {
-		int len;
-		scsicmd->result |= SAM_STAT_CHECK_CONDITION;
-		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
-			    SCSI_SENSE_BUFFERSIZE);
+		if (le32_to_cpu(srbreply->scsi_status)
+				== SAM_STAT_CHECK_CONDITION) {
+			int len;
+
+			scsicmd->result |= SAM_STAT_CHECK_CONDITION;
+			len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
+				    SCSI_SENSE_BUFFERSIZE);
 #ifdef AAC_DETAILED_STATUS_INFO
-		printk(KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n",
-					le32_to_cpu(srbreply->status), len);
+			printk(KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n",
+						le32_to_cpu(srbreply->status), len);
 #endif
-		memcpy(scsicmd->sense_buffer, srbreply->sense_data, len);
+			memcpy(scsicmd->sense_buffer,
+					srbreply->sense_data, len);
+		}
 	}
 	/*
 	 * OR in the scsi status (already shifted up a bit)
--
1.9.3

