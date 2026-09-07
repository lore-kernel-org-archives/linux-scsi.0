Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EE53F1078;
	Mon,  7 Sep 2026 02:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749072; cv=none; b=L3xGiDP2uE141/mQOrolrY9G0QiSj4qDs7UigPo348iMAJdJR2920D8VP5qoTchShRA5TCSXUsJoaCd3fW0o/XIfwIHeDE65RNTSs6A6mfw1fbKUCU3XvUtqjZAUI9+nAph3r8f+RqILbyxBEEcUGXyBmogJVff1b/KNKSCXxXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749072; c=relaxed/simple;
	bh=bAovaVY/TVuEXu5+7bD4s3Kl8fNG0uEUH/DT07I9yag=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeCvNbfsxtLGfpz9gSVyfRqHCR9VK6pCs95oEiBsZyLkFOyNA+cGxZxmrAC6X8x/tPsxHIEm6yzuTnApGwg1ZZmPK7KfeZxpoqzFmUrMhDbGIEIoxOZrMYmLU7/uk4v9Pydz+9Do8bwLXa5ZWY4JLTYhmirtXmntPmZ2gFANzCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ClYiTQt+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ClYiTQt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DC81F00A3A;
	Mon,  7 Sep 2026 02:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749070;
	bh=tIDXQKMllmsxwf2jRvx9lpY/rcum82qgtRKDXQNYrFM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ClYiTQt+ZzoVWwHI3wJkwXjs+g1APtycAZcqkfIdHU10O6hAB1yfcitzyoZRFRjZs
	 gzerFxHiD1jsmb7p7h3lh4KT+kuXZrWJtqKofZgU8c98ttxtSM5DMaSoYTXH4yXGE/
	 dOsKUkLTki/nlBhrpKRbena4yXeb2akjcl36hrWTUGtHuCcGc2/AAbD5CTeb4adHHZ
	 cmi47M4I10DHEFz5Hon6QncojVK/ys4CPHLH/fxMXBLSBhLHzlMqa/MsS14tc/vvY7
	 tY4Yq381pltBLbY3IV6cN/LnZaztGzygeyBWA1WqO32i7bhtW3xtryxmcGhZxe0+W6
	 6QBO3m0FRzkcQ==
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
Subject: [PATCH v5 22/40] scsi: myrX: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:25 +0900
Message-ID: <20260907024343.1046387-23-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907024343.1046387-1-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the Mylex RAID controller driver to use scsi_set_sense() and the
16-bits sense_code field of struct scsi_sense_hdr and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/myrb.c | 67 +++++++++++++++++++++++----------------------
 drivers/scsi/myrs.c | 23 ++++++++++------
 2 files changed, 48 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 3678b66310ed..e7d796add986 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -314,17 +314,19 @@ static void myrb_get_event(struct myrb_hba *cb, unsigned int event)
 		scsi_normalize_sense(ev_buf->sense, 32, &sshdr);
 
 		if (sshdr.sense_key == VENDOR_SPECIFIC &&
-		    sshdr.asc == 0x80 &&
-		    sshdr.ascq < ARRAY_SIZE(myrb_event_msg))
+		    scsi_sense_asc(&sshdr) == 0x80 &&
+		    scsi_sense_ascq(&sshdr) < ARRAY_SIZE(myrb_event_msg))
 			shost_printk(KERN_CRIT, cb->host,
 				     "Physical drive %d:%d: %s\n",
 				     ev_buf->channel, ev_buf->target,
-				     myrb_event_msg[sshdr.ascq]);
+				     myrb_event_msg[scsi_sense_ascq(&sshdr)]);
 		else
 			shost_printk(KERN_CRIT, cb->host,
 				     "Physical drive %d:%d: Sense: %X/%02X/%02X\n",
 				     ev_buf->channel, ev_buf->target,
-				     sshdr.sense_key, sshdr.asc, sshdr.ascq);
+				     sshdr.sense_key,
+				     scsi_sense_asc(&sshdr),
+				     scsi_sense_ascq(&sshdr));
 	}
 
 	dma_free_coherent(&cb->pdev->dev, sizeof(struct myrb_log_entry),
@@ -1398,7 +1400,7 @@ myrb_mode_sense(struct myrb_hba *cb, struct scsi_cmnd *scmd,
 static void myrb_request_sense(struct myrb_hba *cb,
 		struct scsi_cmnd *scmd)
 {
-	scsi_build_sense(scmd, 0, NO_SENSE, 0, 0);
+	scsi_set_sense(scmd, 0, NO_SENSE, NO_ADDITIONAL_SENSE_INFORMATION);
 	scsi_sg_copy_from_buffer(scmd, scmd->sense_buffer,
 				 SCSI_SENSE_BUFFERSIZE);
 }
@@ -1446,8 +1448,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		return 0;
 	case INQUIRY:
 		if (scmd->cmnd[1] & 1) {
-			/* Illegal request, invalid field in CDB */
-			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
+			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
+				       INVALID_FIELD_IN_CDB);
 		} else {
 			myrb_inquiry(cb, scmd);
 			scmd->result = (DID_OK << 16);
@@ -1461,8 +1463,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case MODE_SENSE:
 		if ((scmd->cmnd[2] & 0x3F) != 0x3F &&
 		    (scmd->cmnd[2] & 0x3F) != 0x08) {
-			/* Illegal request, invalid field in CDB */
-			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
+			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
+				       INVALID_FIELD_IN_CDB);
 		} else {
 			myrb_mode_sense(cb, scmd, ldev_info);
 			scmd->result = (DID_OK << 16);
@@ -1472,15 +1474,15 @@ static enum scsi_qc_status myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	case READ_CAPACITY:
 		if ((scmd->cmnd[1] & 1) ||
 		    (scmd->cmnd[8] & 1)) {
-			/* Illegal request, invalid field in CDB */
-			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
+			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
+				       INVALID_FIELD_IN_CDB);
 			scsi_done(scmd);
 			return 0;
 		}
 		lba = get_unaligned_be32(&scmd->cmnd[2]);
 		if (lba) {
-			/* Illegal request, invalid field in CDB */
-			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
+			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
+				       INVALID_FIELD_IN_CDB);
 			scsi_done(scmd);
 			return 0;
 		}
@@ -1493,8 +1495,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		return 0;
 	case SEND_DIAGNOSTIC:
 		if (scmd->cmnd[1] != 0x04) {
-			/* Illegal request, invalid field in CDB */
-			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
+			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
+				       INVALID_FIELD_IN_CDB);
 		} else {
 			/* Assume good status */
 			scmd->result = (DID_OK << 16);
@@ -1503,8 +1505,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		return 0;
 	case READ_6:
 		if (ldev_info->state == MYRB_DEVICE_WO) {
-			/* Data protect, attempt to read invalid data */
-			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
+			scsi_set_sense(scmd, 0, DATA_PROTECT,
+				       ATTEMPT_TO_READ_INVALID_DATA);
 			scsi_done(scmd);
 			return 0;
 		}
@@ -1517,8 +1519,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		break;
 	case READ_10:
 		if (ldev_info->state == MYRB_DEVICE_WO) {
-			/* Data protect, attempt to read invalid data */
-			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
+			scsi_set_sense(scmd, 0, DATA_PROTECT,
+				       ATTEMPT_TO_READ_INVALID_DATA);
 			scsi_done(scmd);
 			return 0;
 		}
@@ -1531,8 +1533,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		break;
 	case READ_12:
 		if (ldev_info->state == MYRB_DEVICE_WO) {
-			/* Data protect, attempt to read invalid data */
-			scsi_build_sense(scmd, 0, DATA_PROTECT, 0x21, 0x06);
+			scsi_set_sense(scmd, 0, DATA_PROTECT,
+				       ATTEMPT_TO_READ_INVALID_DATA);
 			scsi_done(scmd);
 			return 0;
 		}
@@ -1544,8 +1546,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(struct Scsi_Host *shost,
 		block_cnt = get_unaligned_be32(&scmd->cmnd[6]);
 		break;
 	default:
-		/* Illegal request, invalid opcode */
-		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0);
+		scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
+			       INVALID_COMMAND_OP_CODE);
 		scsi_done(scmd);
 		return 0;
 	}
@@ -2328,20 +2330,19 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
 		dev_dbg(&scmd->device->sdev_gendev,
 			"Bad Data Encountered\n");
 		if (scmd->sc_data_direction == DMA_FROM_DEVICE)
-			/* Unrecovered read error */
-			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x11, 0);
+			scsi_set_sense(scmd, 0, MEDIUM_ERROR,
+					 UNRECOVERED_READ_ERROR);
 		else
-			/* Write error */
-			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x0C, 0);
+			scsi_set_sense(scmd, 0, MEDIUM_ERROR, WRITE_ERROR);
 		break;
 	case MYRB_STATUS_IRRECOVERABLE_DATA_ERROR:
 		scmd_printk(KERN_ERR, scmd, "Irrecoverable Data Error\n");
 		if (scmd->sc_data_direction == DMA_FROM_DEVICE)
-			/* Unrecovered read error, auto-reallocation failed */
-			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x11, 0x04);
+			scsi_set_sense(scmd, 0, MEDIUM_ERROR,
+				UNRECOVERED_READ_ERROR_AUTO_REALLOCATE_FAILED);
 		else
-			/* Write error, auto-reallocation failed */
-			scsi_build_sense(scmd, 0, MEDIUM_ERROR, 0x0C, 0x02);
+			scsi_set_sense(scmd, 0, MEDIUM_ERROR,
+				       WRITE_ERROR_AUTO_REALLOCATION_FAILED);
 		break;
 	case MYRB_STATUS_LDRV_NONEXISTENT_OR_OFFLINE:
 		dev_dbg(&scmd->device->sdev_gendev,
@@ -2351,8 +2352,8 @@ static void myrb_handle_scsi(struct myrb_hba *cb, struct myrb_cmdblk *cmd_blk,
 	case MYRB_STATUS_ACCESS_BEYOND_END_OF_LDRV:
 		dev_dbg(&scmd->device->sdev_gendev,
 			    "Attempt to Access Beyond End of Logical Drive");
-		/* Logical block address out of range */
-		scsi_build_sense(scmd, 0, NOT_READY, 0x21, 0);
+		scsi_set_sense(scmd, 0, NOT_READY,
+			       LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE);
 		break;
 	case MYRB_STATUS_DEVICE_NONRESPONSIVE:
 		dev_dbg(&scmd->device->sdev_gendev, "Device nonresponsive\n");
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index afd68225221a..1192b01fab8e 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -816,7 +816,7 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
 	struct Scsi_Host *shost = cs->host;
 	struct scsi_device *sdev;
 	struct scsi_sense_hdr sshdr = {0};
-	unsigned char sense_info[4];
+	unsigned char asc, sense_info[4];
 	unsigned char cmd_specific[4];
 
 	if (ev->ev_code == 0x1C) {
@@ -829,9 +829,11 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
 			memcpy(cmd_specific, &ev->sense_data[7], 4);
 		}
 	}
+	asc = scsi_sense_asc(&sshdr);
 	if (sshdr.sense_key == VENDOR_SPECIFIC &&
-	    (sshdr.asc == 0x80 || sshdr.asc == 0x81))
-		ev->ev_code = ((sshdr.asc - 0x80) << 8 | sshdr.ascq);
+	    (asc == 0x80 || asc == 0x81))
+		ev->ev_code = scsi_sense_code(asc - 0x80,
+					      scsi_sense_ascq(&sshdr));
 	while (true) {
 		ev_code = myrs_ev_list[ev_idx].ev_code;
 		if (ev_code == ev->ev_code || ev_code == 0)
@@ -891,8 +893,9 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
 	case 'S':
 		if (sshdr.sense_key == NO_SENSE ||
 		    (sshdr.sense_key == NOT_READY &&
-		     sshdr.asc == 0x04 && (sshdr.ascq == 0x01 ||
-					    sshdr.ascq == 0x02)))
+		     (sshdr.sense_code == LU_IS_IN_PROCESS_OF_BECOMING_READY ||
+		      sshdr.sense_code ==
+		      LU_NOT_READY_INITIALIZING_COMMAND_REQUIRED)))
 			break;
 		shost_printk(KERN_INFO, shost,
 			     "event %d: Physical Device %d:%d %s\n",
@@ -900,7 +903,8 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
 		shost_printk(KERN_INFO, shost,
 			     "Physical Device %d:%d Sense Key = %X, ASC = %02X, ASCQ = %02X\n",
 			     ev->channel, ev->target,
-			     sshdr.sense_key, sshdr.asc, sshdr.ascq);
+			     sshdr.sense_key, scsi_sense_asc(&sshdr),
+			     scsi_sense_ascq(&sshdr));
 		shost_printk(KERN_INFO, shost,
 			     "Physical Device %d:%d Sense Information = %02X%02X%02X%02X %02X%02X%02X%02X\n",
 			     ev->channel, ev->target,
@@ -1603,7 +1607,8 @@ static enum scsi_qc_status myrs_queuecommand(struct Scsi_Host *shost,
 
 	switch (scmd->cmnd[0]) {
 	case REPORT_LUNS:
-		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0x0);
+		scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
+			       INVALID_COMMAND_OP_CODE);
 		scsi_done(scmd);
 		return 0;
 	case MODE_SENSE:
@@ -1612,8 +1617,8 @@ static enum scsi_qc_status myrs_queuecommand(struct Scsi_Host *shost,
 
 			if ((scmd->cmnd[2] & 0x3F) != 0x3F &&
 			    (scmd->cmnd[2] & 0x3F) != 0x08) {
-				/* Illegal request, invalid field in CDB */
-				scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
+				scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
+					       INVALID_FIELD_IN_CDB);
 			} else {
 				myrs_mode_sense(cs, scmd, ldev_info);
 				scmd->result = (DID_OK << 16);
-- 
2.55.0

