From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 06/43] hpsa: hpsa decode sense data for io and tmf
Date: Sat, 21 Feb 2015 16:18:03 -0600
Message-ID: <20150221221803.21954.76453.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:57223 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbbBUWTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:19:22 -0500
Received: from g5t1625.atlanta.hp.com (g5t1625.atlanta.hp.com [15.192.137.8])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 8CEF860172
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:19:22 +0000 (UTC)
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

In hba mode, we could get sense data in descriptor format so
we need to handle that.

It's possible for CommandStatus to have value 0x0D
"TMF Function Status", which we should handle.  We will get
this from a P1224 when aborting a non-existent tag, for
example.  The "ScsiStatus" field of the errinfo field
will contain the TMF function status value.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |  150 ++++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/hpsa_cmd.h |    9 +++
 2 files changed, 124 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c70be42..bae8df8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -268,16 +268,57 @@ static inline struct ctlr_info *shost_to_hba(struct Scsi_Host *sh)
 	return (struct ctlr_info *) *priv;
 }
 
+/* extract sense key, asc, and ascq from sense data.  -1 means invalid. */
+static void decode_sense_data(const u8 *sense_data, int sense_data_len,
+			int *sense_key, int *asc, int *ascq)
+{
+	if (sense_data_len < 1) {
+		*sense_key = -1;
+		*ascq = -1;
+		*asc = -1;
+		return;
+	}
+
+	switch (sense_data[0]) {
+	case 0x70: /* old format sense data */
+		*sense_key = (sense_data_len > 2) ? sense_data[2] & 0x0f : -1;
+		*ascq = (sense_data_len > 13) ?  sense_data[13] : -1;
+		*asc = (sense_data_len > 12) ?  sense_data[12] : -1;
+		break;
+	case 0x72: /* descriptor format sense data */
+		*sense_key = (sense_data_len > 1) ? sense_data[1] & 0x0f : -1;
+		*ascq = (sense_data_len > 2) ?  sense_data[2] : -1;
+		*asc = (sense_data_len > 3) ?  sense_data[3] : -1;
+		break;
+	default:
+		*sense_key = -1;
+		*ascq = -1;
+		*asc = -1;
+		break;
+	}
+}
+
 static int check_for_unit_attention(struct ctlr_info *h,
 	struct CommandList *c)
 {
-	if (c->err_info->SenseInfo[2] != UNIT_ATTENTION)
+	int sense_key, asc, ascq;
+	int sense_len;
+
+	if (c->err_info->SenseLen > sizeof(c->err_info->SenseInfo))
+		sense_len = sizeof(c->err_info->SenseInfo);
+	else
+		sense_len = c->err_info->SenseLen;
+
+	decode_sense_data(c->err_info->SenseInfo, sense_len,
+				&sense_key, &asc, &ascq);
+	if (sense_key != UNIT_ATTENTION || asc == -1)
 		return 0;
 
-	switch (c->err_info->SenseInfo[12]) {
+	switch (asc) {
 	case STATE_CHANGED:
-		dev_warn(&h->pdev->dev, HPSA "%d: a state change "
-			"detected, command retried\n", h->ctlr);
+		dev_warn(&h->pdev->dev,
+			HPSA "%d: a state change detected, command retried\n",
+			h->ctlr);
 		break;
 	case LUN_FAILED:
 		dev_warn(&h->pdev->dev,
@@ -1903,6 +1944,34 @@ retry_cmd:
 	queue_work_on(raw_smp_processor_id(), h->resubmit_wq, &c->work);
 }
 
+/* Returns 0 on success, < 0 otherwise. */
+static int hpsa_evaluate_tmf_status(struct ctlr_info *h,
+					struct CommandList *cp)
+{
+	u8 tmf_status = cp->err_info->ScsiStatus;
+
+	switch (tmf_status) {
+	case CISS_TMF_COMPLETE:
+		/*
+		 * CISS_TMF_COMPLETE never happens, instead,
+		 * ei->CommandStatus == 0 for this case.
+		 */
+	case CISS_TMF_SUCCESS:
+		return 0;
+	case CISS_TMF_INVALID_FRAME:
+	case CISS_TMF_NOT_SUPPORTED:
+	case CISS_TMF_FAILED:
+	case CISS_TMF_WRONG_LUN:
+	case CISS_TMF_OVERLAPPED_TAG:
+		break;
+	default:
+		dev_warn(&h->pdev->dev, "Unknown TMF status: 0x%02x\n",
+				tmf_status);
+		break;
+	}
+	return -tmf_status;
+}
+
 static void complete_scsi_command(struct CommandList *cp)
 {
 	struct scsi_cmnd *cmd;
@@ -1910,9 +1979,9 @@ static void complete_scsi_command(struct CommandList *cp)
 	struct ErrorInfo *ei;
 	struct hpsa_scsi_dev_t *dev;
 
-	unsigned char sense_key;
-	unsigned char asc;      /* additional sense code */
-	unsigned char ascq;     /* additional sense code qualifier */
+	int sense_key;
+	int asc;      /* additional sense code */
+	int ascq;     /* additional sense code qualifier */
 	unsigned long sense_data_size;
 
 	ei = cp->err_info;
@@ -1947,8 +2016,6 @@ static void complete_scsi_command(struct CommandList *cp)
 	if (cp->cmd_type == CMD_IOACCEL2)
 		return process_ioaccel2_completion(h, cp, cmd, dev);
 
-	cmd->result |= ei->ScsiStatus;
-
 	scsi_set_resid(cmd, ei->ResidualCnt);
 	if (ei->CommandStatus == 0) {
 		if (cp->cmd_type == CMD_IOACCEL1)
@@ -1958,16 +2025,6 @@ static void complete_scsi_command(struct CommandList *cp)
 		return;
 	}
 
-	/* copy the sense data */
-	if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
-		sense_data_size = SCSI_SENSE_BUFFERSIZE;
-	else
-		sense_data_size = sizeof(ei->SenseInfo);
-	if (ei->SenseLen < sense_data_size)
-		sense_data_size = ei->SenseLen;
-
-	memcpy(cmd->sense_buffer, ei->SenseInfo, sense_data_size);
-
 	/* For I/O accelerator commands, copy over some fields to the normal
 	 * CISS header used below for error handling.
 	 */
@@ -1999,14 +2056,18 @@ static void complete_scsi_command(struct CommandList *cp)
 	switch (ei->CommandStatus) {
 
 	case CMD_TARGET_STATUS:
-		if (ei->ScsiStatus) {
-			/* Get sense key */
-			sense_key = 0xf & ei->SenseInfo[2];
-			/* Get additional sense code */
-			asc = ei->SenseInfo[12];
-			/* Get addition sense code qualifier */
-			ascq = ei->SenseInfo[13];
-		}
+		cmd->result |= ei->ScsiStatus;
+		/* copy the sense data */
+		if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
+			sense_data_size = SCSI_SENSE_BUFFERSIZE;
+		else
+			sense_data_size = sizeof(ei->SenseInfo);
+		if (ei->SenseLen < sense_data_size)
+			sense_data_size = ei->SenseLen;
+		memcpy(cmd->sense_buffer, ei->SenseInfo, sense_data_size);
+		if (ei->ScsiStatus)
+			decode_sense_data(ei->SenseInfo, sense_data_size,
+				&sense_key, &asc, &ascq);
 		if (ei->ScsiStatus == SAM_STAT_CHECK_CONDITION) {
 			if (sense_key == ABORTED_COMMAND) {
 				cmd->result |= DID_SOFT_ERROR << 16;
@@ -2101,6 +2162,10 @@ static void complete_scsi_command(struct CommandList *cp)
 		cmd->result = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "Command unabortable\n");
 		break;
+	case CMD_TMF_STATUS:
+		if (hpsa_evaluate_tmf_status(h, cp)) /* TMF failed? */
+			cmd->result = DID_ERROR << 16;
+		break;
 	case CMD_IOACCEL_DISABLED:
 		/* This only handles the direct pass-through case since RAID
 		 * offload is handled above.  Just attempt a retry.
@@ -2251,16 +2316,22 @@ static void hpsa_scsi_interpret_error(struct ctlr_info *h,
 {
 	const struct ErrorInfo *ei = cp->err_info;
 	struct device *d = &cp->h->pdev->dev;
-	const u8 *sd = ei->SenseInfo;
+	int sense_key, asc, ascq, sense_len;
 
 	switch (ei->CommandStatus) {
 	case CMD_TARGET_STATUS:
+		if (ei->SenseLen > sizeof(ei->SenseInfo))
+			sense_len = sizeof(ei->SenseInfo);
+		else
+			sense_len = ei->SenseLen;
+		decode_sense_data(ei->SenseInfo, sense_len,
+					&sense_key, &asc, &ascq);
 		hpsa_print_cmd(h, "SCSI status", cp);
 		if (ei->ScsiStatus == SAM_STAT_CHECK_CONDITION)
-			dev_warn(d, "SCSI Status = 02, Sense key = %02x, ASC = %02x, ASCQ = %02x\n",
-				sd[2] & 0x0f, sd[12], sd[13]);
+			dev_warn(d, "SCSI Status = 02, Sense key = 0x%02x, ASC = 0x%02x, ASCQ = 0x%02x\n",
+				sense_key, asc, ascq);
 		else
-			dev_warn(d, "SCSI Status = %02x\n", ei->ScsiStatus);
+			dev_warn(d, "SCSI Status = 0x%02x\n", ei->ScsiStatus);
 		if (ei->ScsiStatus == 0)
 			dev_warn(d, "SCSI status is abnormally zero.  "
 			"(probably indicates selection timeout "
@@ -2805,7 +2876,8 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 					unsigned char scsi3addr[])
 {
 	struct CommandList *c;
-	unsigned char *sense, sense_key, asc, ascq;
+	unsigned char *sense;
+	int sense_key, asc, ascq, sense_len;
 	int rc, ldstat = 0;
 	u16 cmd_status;
 	u8 scsi_status;
@@ -2823,9 +2895,11 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 		return 0;
 	}
 	sense = c->err_info->SenseInfo;
-	sense_key = sense[2];
-	asc = sense[12];
-	ascq = sense[13];
+	if (c->err_info->SenseLen > sizeof(c->err_info->SenseInfo))
+		sense_len = sizeof(c->err_info->SenseInfo);
+	else
+		sense_len = c->err_info->SenseLen;
+	decode_sense_data(sense, sense_len, &sense_key, &asc, &ascq);
 	cmd_status = c->err_info->CommandStatus;
 	scsi_status = c->err_info->ScsiStatus;
 	cmd_free(h, c);
@@ -2901,6 +2975,9 @@ static int hpsa_device_supports_aborts(struct ctlr_info *h,
 	case CMD_ABORT_FAILED:
 		rc = 1;
 		break;
+	case CMD_TMF_STATUS:
+		rc = hpsa_evaluate_tmf_status(h, c);
+		break;
 	default:
 		rc = 0;
 		break;
@@ -4708,6 +4785,9 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 	switch (ei->CommandStatus) {
 	case CMD_SUCCESS:
 		break;
+	case CMD_TMF_STATUS:
+		rc = hpsa_evaluate_tmf_status(h, c);
+		break;
 	case CMD_UNABORTABLE: /* Very common, don't make noise. */
 		rc = -1;
 		break;
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index f52c847..f6ca5fa 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -42,6 +42,7 @@
 #define CMD_UNSOLICITED_ABORT   0x000A
 #define CMD_TIMEOUT             0x000B
 #define CMD_UNABORTABLE		0x000C
+#define CMD_TMF_STATUS		0x000D
 #define CMD_IOACCEL_DISABLED	0x000E
 #define CMD_CTLR_LOCKUP		0xffff
 /* Note: CMD_CTLR_LOCKUP is not a value defined by the CISS spec
@@ -49,6 +50,14 @@
  * with when a controller lockup has been detected by the driver
  */
 
+/* TMF function status values */
+#define CISS_TMF_COMPLETE	0x00
+#define CISS_TMF_INVALID_FRAME	0x02
+#define CISS_TMF_NOT_SUPPORTED	0x04
+#define CISS_TMF_FAILED		0x05
+#define CISS_TMF_SUCCESS	0x08
+#define CISS_TMF_WRONG_LUN	0x09
+#define CISS_TMF_OVERLAPPED_TAG 0x0a
 
 /* Unit Attentions ASC's as defined for the MSA2012sa */
 #define POWER_OR_RESET			0x29

