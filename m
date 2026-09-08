Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94454E2348;
	Tue,  8 Sep 2026 09:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858259; cv=none; b=c0UCEPq4/xYTExWUnDWw49KAgxVGa7/tJP31MR8ovHGJ5Wx7eshoTSfiI1pQmVWao+V2Qq3ZpeVtweOV/8s5Q0PJZIsCNljAX+1mBZLGiWQIW+DmYF4mYEzxR0hmuMaku7bH2vuZjQmUSe2IVKYMjojMuxUxxYI04KK7oTU+X0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858259; c=relaxed/simple;
	bh=tMRN/0vU7jcCRK5qKbgHgRusTj/tI0V9kuQAy/qSHl4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jt2rq/fs+2bzjM7KG9XwsUSeBuN1rysR53vE+BWvKpzrPtbcvMSinAqr6t/Ofyqbk9Jcch4XgToOqwCXYXssskoBG8qeVs2YhyMXeEVFDWvNJ5GLf9jJcQXK6lSkXYkC2nF/maMITF8yS/SX8Z1F7C1lXwmqtojNwmxn79GLmzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdKQDbbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdKQDbbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F75A1F00A3F;
	Tue,  8 Sep 2026 09:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858256;
	bh=JwcQOQsBSPsQO15W8V583ZWJ8BcR95sdwq7ysym28lY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=fdKQDbbsAajgj15vpPjAH5AWlrwm1ozWvCN58LQR7OwnZUQyZSyRx9HEPw03U/UqW
	 EBCjgAPbRsBTRR7hCoDZwqL+ygJ/01NIAKdzujIeG+BXTbVg4B5DEBGLd+H7XF6obQ
	 uW0PkSXnOnMO1pyOamV598boPBsFThmXhuNlx0gWTvscNeDT4oFcEnM64LaOYZrxaZ
	 0v2Xr4gPLkZUheKTu/3cukwxMcTSriuH8D2TWEQUqd2qUO5iN9WcmBzJqYxTv7cTwG
	 aE3Iy+Y8E/vYax4mKY4fDBc7C6d31PALtD9VBHexYD0IOsQYEAs0Xblm/UwFOKBQ7J
	 e85SLz5C/sweQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v6 32/40] scsi: hpsa: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:03:00 +0900
Message-ID: <20260908090308.1085097-33-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the hpsa driver to replace all hard-coded additional sense codes
and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

The function decode_sense_data() is also modified to take a pointer to a
16-bits sense_code variable in place of the two pointers to the additional
sense code and its code qualifier. The local definitions of ASCs and ASCQs
are deleted too.

No functional change intended, but the function hpsa_volume_offline() was
checking only the addditional sense code qualifier with checking the
additional sense code. This change assumes that the intended additional
sense code to check is ASC_LU_NOT_READY.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/hpsa.c     | 69 +++++++++++++++++++++--------------------
 drivers/scsi/hpsa_cmd.h | 23 --------------
 2 files changed, 35 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8edad1830abe..795e8c7592af 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -353,14 +353,13 @@ static inline bool hpsa_is_cmd_idle(struct CommandList *c)
 
 /* extract sense key, asc, and ascq from sense data.  -1 means invalid. */
 static void decode_sense_data(const u8 *sense_data, int sense_data_len,
-			u8 *sense_key, u8 *asc, u8 *ascq)
+			      u8 *sense_key, u16 *sense_code)
 {
 	struct scsi_sense_hdr sshdr;
 	bool rc;
 
 	*sense_key = -1;
-	*asc = -1;
-	*ascq = -1;
+	*sense_code = -1;
 
 	if (sense_data_len < 1)
 		return;
@@ -368,15 +367,15 @@ static void decode_sense_data(const u8 *sense_data, int sense_data_len,
 	rc = scsi_normalize_sense(sense_data, sense_data_len, &sshdr);
 	if (rc) {
 		*sense_key = sshdr.sense_key;
-		*asc = sshdr.asc;
-		*ascq = sshdr.ascq;
+		*sense_code = sshdr.sense_code;
 	}
 }
 
 static int check_for_unit_attention(struct ctlr_info *h,
 	struct CommandList *c)
 {
-	u8 sense_key, asc, ascq;
+	u8 sense_key;
+	u16 sense_code;
 	int sense_len;
 
 	if (c->err_info->SenseLen > sizeof(c->err_info->SenseInfo))
@@ -385,34 +384,35 @@ static int check_for_unit_attention(struct ctlr_info *h,
 		sense_len = c->err_info->SenseLen;
 
 	decode_sense_data(c->err_info->SenseInfo, sense_len,
-				&sense_key, &asc, &ascq);
-	if (sense_key != UNIT_ATTENTION || asc == 0xff)
+			  &sense_key, &sense_code);
+	if (sense_key != UNIT_ATTENTION ||
+	    scsi_sense_code_asc(sense_code) == 0xff)
 		return 0;
 
-	switch (asc) {
-	case STATE_CHANGED:
+	switch (scsi_sense_code_asc(sense_code)) {
+	case ASC_PARAMETERS_CHANGED:
 		dev_warn(&h->pdev->dev,
 			"%s: a state change detected, command retried\n",
 			h->devname);
 		break;
-	case LUN_FAILED:
+	case ASC_LU_HAS_NOT_SELF_CONFIGURED_YET:
 		dev_warn(&h->pdev->dev,
 			"%s: LUN failure detected\n", h->devname);
 		break;
-	case REPORT_LUNS_CHANGED:
+	case ASC_TARGET_OPERATING_CONDITIONS_HAVE_CHANGED:
 		dev_warn(&h->pdev->dev,
 			"%s: report LUN data changed\n", h->devname);
 	/*
-	 * Note: this REPORT_LUNS_CHANGED condition only occurs on the external
-	 * target (array) devices.
+	 * Note: this ASC_TARGET_OPERATING_CONDITIONS_HAVE_CHANGED condition
+	 * only occurs on the external target (array) devices.
 	 */
 		break;
-	case POWER_OR_RESET:
+	case ASC_POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED:
 		dev_warn(&h->pdev->dev,
 			"%s: a power on or device reset detected\n",
 			h->devname);
 		break;
-	case UNIT_ATTENTION_CLEARED:
+	case ASC_COMMANDS_CLEARED_BY_ANOTHER_INITIATOR:
 		dev_warn(&h->pdev->dev,
 			"%s: unit attention cleared by another initiator\n",
 			h->devname);
@@ -2562,10 +2562,8 @@ static void complete_scsi_command(struct CommandList *cp)
 	struct ErrorInfo *ei;
 	struct hpsa_scsi_dev_t *dev;
 	struct io_accel2_cmd *c2;
-
 	u8 sense_key;
-	u8 asc;      /* additional sense code */
-	u8 ascq;     /* additional sense code qualifier */
+	u16 sense_code;
 	unsigned long sense_data_size;
 
 	ei = cp->err_info;
@@ -2666,18 +2664,19 @@ static void complete_scsi_command(struct CommandList *cp)
 		memcpy(cmd->sense_buffer, ei->SenseInfo, sense_data_size);
 		if (ei->ScsiStatus)
 			decode_sense_data(ei->SenseInfo, sense_data_size,
-				&sense_key, &asc, &ascq);
+				&sense_key, &sense_code);
 		if (ei->ScsiStatus == SAM_STAT_CHECK_CONDITION) {
 			switch (sense_key) {
 			case ABORTED_COMMAND:
 				cmd->result |= DID_SOFT_ERROR << 16;
 				break;
 			case UNIT_ATTENTION:
-				if (asc == 0x3F && ascq == 0x0E)
+				if (sense_code ==
+				    REPORTED_LUNS_DATA_HAS_CHANGED)
 					h->drv_req_rescan = 1;
 				break;
 			case ILLEGAL_REQUEST:
-				if (asc == 0x25 && ascq == 0x00) {
+				if (sense_code == LU_NOT_SUPPORTED) {
 					dev->removed = 1;
 					cmd->result = DID_NO_CONNECT << 16;
 				}
@@ -2693,7 +2692,9 @@ static void complete_scsi_command(struct CommandList *cp)
 				"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
 				"Returning result: 0x%x\n",
 				cp, ei->ScsiStatus,
-				sense_key, asc, ascq,
+				sense_key,
+				scsi_sense_code_asc(sense_code),
+				scsi_sense_code_ascq(sense_code),
 				cmd->result);
 		} else {  /* scsi status is zero??? How??? */
 			dev_warn(&h->pdev->dev, "cp %p SCSI status was 0. "
@@ -2919,7 +2920,8 @@ static void hpsa_scsi_interpret_error(struct ctlr_info *h,
 {
 	const struct ErrorInfo *ei = cp->err_info;
 	struct device *d = &cp->h->pdev->dev;
-	u8 sense_key, asc, ascq;
+	u8 sense_key;
+	u16 sense_code;
 	int sense_len;
 
 	switch (ei->CommandStatus) {
@@ -2928,12 +2930,13 @@ static void hpsa_scsi_interpret_error(struct ctlr_info *h,
 			sense_len = sizeof(ei->SenseInfo);
 		else
 			sense_len = ei->SenseLen;
-		decode_sense_data(ei->SenseInfo, sense_len,
-					&sense_key, &asc, &ascq);
+		decode_sense_data(ei->SenseInfo, sense_len, &sense_key,
+				  &sense_code);
 		hpsa_print_cmd(h, "SCSI status", cp);
 		if (ei->ScsiStatus == SAM_STAT_CHECK_CONDITION)
 			dev_warn(d, "SCSI Status = 02, Sense key = 0x%02x, ASC = 0x%02x, ASCQ = 0x%02x\n",
-				sense_key, asc, ascq);
+				sense_key, scsi_sense_code_asc(sense_code),
+				 scsi_sense_code_ascq(sense_code));
 		else
 			dev_warn(d, "SCSI Status = 0x%02x\n", ei->ScsiStatus);
 		if (ei->ScsiStatus == 0)
@@ -3868,12 +3871,10 @@ static unsigned char hpsa_volume_offline(struct ctlr_info *h,
 {
 	struct CommandList *c;
 	unsigned char *sense;
-	u8 sense_key, asc, ascq;
+	u8 sense_key;
+	u16 sense_code;
 	int sense_len;
 	int rc, ldstat = 0;
-#define ASC_LUN_NOT_READY 0x04
-#define ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS 0x04
-#define ASCQ_LUN_NOT_READY_INITIALIZING_CMD_REQ 0x02
 
 	c = cmd_alloc(h);
 
@@ -3889,7 +3890,7 @@ static unsigned char hpsa_volume_offline(struct ctlr_info *h,
 		sense_len = sizeof(c->err_info->SenseInfo);
 	else
 		sense_len = c->err_info->SenseLen;
-	decode_sense_data(sense, sense_len, &sense_key, &asc, &ascq);
+	decode_sense_data(sense, sense_len, &sense_key, &sense_code);
 	cmd_free(h, c);
 
 	/* Determine the reason for not ready state */
@@ -3912,8 +3913,8 @@ static unsigned char hpsa_volume_offline(struct ctlr_info *h,
 		/* If VPD status page isn't available,
 		 * use ASC/ASCQ to determine state
 		 */
-		if ((ascq == ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS) ||
-			(ascq == ASCQ_LUN_NOT_READY_INITIALIZING_CMD_REQ))
+		if (sense_code == LU_NOT_READY_FORMAT_IN_PROGRESS ||
+		    sense_code == LU_NOT_READY_INITIALIZING_COMMAND_REQUIRED)
 			return ldstat;
 		break;
 	default:
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index ba6a3aa8d954..0dbfbec37ce2 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -63,29 +63,6 @@
 #define CISS_TMF_WRONG_LUN	0x09
 #define CISS_TMF_OVERLAPPED_TAG 0x0a
 
-/* Unit Attentions ASC's as defined for the MSA2012sa */
-#define POWER_OR_RESET			0x29
-#define STATE_CHANGED			0x2a
-#define UNIT_ATTENTION_CLEARED		0x2f
-#define LUN_FAILED			0x3e
-#define REPORT_LUNS_CHANGED		0x3f
-
-/* Unit Attentions ASCQ's as defined for the MSA2012sa */
-
-	/* These ASCQ's defined for ASC = POWER_OR_RESET */
-#define POWER_ON_RESET			0x00
-#define POWER_ON_REBOOT			0x01
-#define SCSI_BUS_RESET			0x02
-#define MSA_TARGET_RESET		0x03
-#define CONTROLLER_FAILOVER		0x04
-#define TRANSCEIVER_SE			0x05
-#define TRANSCEIVER_LVD			0x06
-
-	/* These ASCQ's defined for ASC = STATE_CHANGED */
-#define RESERVATION_PREEMPTED		0x03
-#define ASYM_ACCESS_CHANGED		0x06
-#define LUN_CAPACITY_CHANGED		0x09
-
 /* transfer direction */
 #define XFER_NONE               0x00
 #define XFER_WRITE              0x01
-- 
2.55.0

