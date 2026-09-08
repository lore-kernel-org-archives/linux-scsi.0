Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4385E49CF3E;
	Tue,  8 Sep 2026 09:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858222; cv=none; b=RL5dIlee4frA1rE1A5NlHJGNADOVf+7+4TKt3lbrDdGE3WUyHZ8Ll5CfGb4nNuPrw/n4iXqRsrC6tnLs+7OhTOzmafDevJQw5wxVJVQXQ/DjcOV6cPXfaRGgn9IePkB1JcB/QEEd3Dw7j9gx703t5XQSS6CpYG3wgvYCxF82RUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858222; c=relaxed/simple;
	bh=Z5cQ1bbPNlHnIJ0d/6dN0K2c/jRmoj8SeKNaO26HxvY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnuY3fAKnEJar9sgKlT8VN9ZDJIROvDai5QeOMrdEzSVichpSaShsPzILL0Maf2paYUQPWJ74ZzmZ6eqqujlKKMVBwnuugAd4HdZZ5GoDRd/y3lpg8TKeuRDLOcFu2DfoUsc8Tm1aQtrTSNL/RbFckljwL0zJRbMOfoUd/v/saE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sf3puZIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sf3puZIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C631F00ADE;
	Tue,  8 Sep 2026 09:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858213;
	bh=/yHCbOAaDvvWM1VbssCo8zhBx8PPEneokDM0XNLh3QQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Sf3puZIbk0Dm52bGlCd30tMAXFsZ9GyMpFozJf/ybxqiEMyOb7IZoLIpIk5Usgoc2
	 T2W05t8ug6OnQvMCcfQsLctqqGnRC8MipQElxZ+L8Z6kTFXMjLcSVRzKBXc7StnhmA
	 0/4Bz7nxRFhcrAH92+BTLLHdbi/LHErcDziOXL/QrsY6ZbjyMM+22V0EpI7xb5qNbw
	 wsoJMSFL7wEjfU7rQO0jYYd1biMevHVOipGq72/KqH5AAXvFREeQh9h8EkTtH7IkO9
	 Vqx7L8XVhr3zKrTq9U54OtUqOEhTZ06O8d4PZhbYzbXE/0Ib6tHhGMZE8MUQH4BEHo
	 JQdwaKZOQF83A==
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
Subject: [PATCH v6 07/40] scsi: core: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:02:35 +0900
Message-ID: <20260908090308.1085097-8-dlemoal@kernel.org>
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

Refactor the SCSI core code to use the 16-bits sense_code field of
struct scsi_sense_hdr and struct scsi_failure and replace all hard-coded
additional sense codes and additional sense code qualifiers with the enum
values defined in include/scsi/scsi_sense.h. This helps with code clarity
as the sense codes being processed are easier to test and self-documented.

No functional change intended, with the exception of a correction of the
array any_sense_failure_defs in scsi_lib_test_any_sense() which
erroenously sets result to SCMD_FAILURE_RESULT_ANY instead of
SAM_STAT_CHECK_CONDITION and does not sets sense_key to
SCMD_FAILURE_SENSE_KEY_ANY.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/constants.c          |  38 ++++++++--
 drivers/scsi/scsi.c               |   3 +-
 drivers/scsi/scsi_common.c        |  12 ++--
 drivers/scsi/scsi_error.c         |  94 ++++++++++++++----------
 drivers/scsi/scsi_ioctl.c         |   3 +-
 drivers/scsi/scsi_lib.c           | 116 ++++++++++++++++--------------
 drivers/scsi/scsi_lib_test.c      |  72 +++++++++++--------
 drivers/scsi/scsi_scan.c          |  14 ++--
 drivers/scsi/scsi_transport_spi.c |  10 ++-
 include/trace/events/scsi.h       |   4 +-
 10 files changed, 218 insertions(+), 148 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 57b51c4529c3..767631835c81 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -327,13 +327,37 @@ struct error_info2 {
 
 static const struct error_info2 additional2[] =
 {
-	{0x40, 0x00, 0x7f, "Ram failure", ""},
-	{0x40, 0x80, 0xff, "Diagnostic failure on component", ""},
-	{0x41, 0x00, 0xff, "Data path failure", ""},
-	{0x42, 0x00, 0xff, "Power-on or self-test failure", ""},
-	{0x4D, 0x00, 0xff, "Tagged overlapped commands", "task tag "},
-	{0x70, 0x00, 0xff, "Decompression exception", "short algorithm id of "},
-	{0, 0, 0, NULL, NULL}
+	{
+		ASC_RAM_FAILURE,
+		0x00, 0x7f,
+		"Ram failure", ""
+	},
+	{
+		ASC_RAM_FAILURE,
+		0x80, 0xff,
+		"Diagnostic failure on component", ""
+	},
+	{
+		ASC_DATA_PATH_FAILURE,
+		0x00, 0xff,
+		"Data path failure", ""
+	},
+	{
+		ASC_POWER_ON_OR_SELFTEST_FAILURE,
+		0x00, 0xff,
+		"Power-on or self-test failure", ""
+	},
+	{
+		ASC_TAGGED_OVERLAPPED_COMMANDS,
+		0x00, 0xff,
+		"Tagged overlapped commands", "task tag "
+	},
+	{
+		ASC_DECOMPRESSION_EXCEPTION_SHORT_ALGORITHM_ID,
+		0x00, 0xff,
+		"Decompression exception", "short algorithm id of "
+	},
+	{ 0, 0, 0, NULL, NULL }
 };
 
 /* description of the sense key values */
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4e7e7a6b7315..3af9e77847f7 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -606,7 +606,8 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 		return result;
 	if (result && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
-	    (sshdr.asc == 0x20 || sshdr.asc == 0x24) && sshdr.ascq == 0x00)
+	    (sshdr.sense_code == INVALID_COMMAND_OP_CODE ||
+	     sshdr.sense_code == INVALID_FIELD_IN_CDB))
 		return -EINVAL;
 
 	if ((buffer[1] & 3) == 3) /* Command supported */
diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index e1a2a62b6910..2cabc932acd4 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -191,6 +191,8 @@ EXPORT_SYMBOL(int_to_scsilun);
 bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 			  struct scsi_sense_hdr *sshdr)
 {
+	u8 asc = 0, ascq = 0;
+
 	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
 
 	if (!sense_buffer || !sb_len)
@@ -208,9 +210,9 @@ bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		if (sb_len > 1)
 			sshdr->sense_key = (sense_buffer[1] & 0xf);
 		if (sb_len > 2)
-			sshdr->asc = sense_buffer[2];
+			asc = sense_buffer[2];
 		if (sb_len > 3)
-			sshdr->ascq = sense_buffer[3];
+			ascq = sense_buffer[3];
 		if (sb_len > 7)
 			sshdr->additional_length = sense_buffer[7];
 	} else {
@@ -222,12 +224,14 @@ bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		if (sb_len > 7) {
 			sb_len = min(sb_len, sense_buffer[7] + 8);
 			if (sb_len > 12)
-				sshdr->asc = sense_buffer[12];
+				asc = sense_buffer[12];
 			if (sb_len > 13)
-				sshdr->ascq = sense_buffer[13];
+				ascq = sense_buffer[13];
 		}
 	}
 
+	sshdr->sense_code = scsi_sense_code(asc, ascq);
+
 	return true;
 }
 EXPORT_SYMBOL(scsi_normalize_sense);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d9b89a9a7c6e..2e0b1909dc69 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -490,24 +490,27 @@ static void scsi_report_sense(struct scsi_device *sdev,
 	enum scsi_device_event evt_type = SDEV_EVT_MAXBITS;	/* i.e. none */
 
 	if (sshdr->sense_key == UNIT_ATTENTION) {
-		if (sshdr->asc == 0x3f && sshdr->ascq == 0x03) {
+		if (sshdr->sense_code == INQUIRY_DATA_HAS_CHANGED) {
 			evt_type = SDEV_EVT_INQUIRY_CHANGE_REPORTED;
 			sdev_printk(KERN_WARNING, sdev,
 				    "Inquiry data has changed");
-		} else if (sshdr->asc == 0x3f && sshdr->ascq == 0x0e) {
+		} else if (sshdr->sense_code == REPORTED_LUNS_DATA_HAS_CHANGED) {
 			evt_type = SDEV_EVT_LUN_CHANGE_REPORTED;
 			scsi_report_lun_change(sdev);
 			sdev_printk(KERN_WARNING, sdev,
 				    "LUN assignments on this target have "
 				    "changed. The Linux SCSI layer does not "
 				    "automatically remap LUN assignments.\n");
-		} else if (sshdr->asc == 0x3f)
+		} else if (scsi_sense_asc(sshdr) ==
+			   ASC_TARGET_OPERATING_CONDITIONS_HAVE_CHANGED) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "Operating parameters on this target have "
 				    "changed. The Linux SCSI layer does not "
 				    "automatically adjust these parameters.\n");
+		}
 
-		if (sshdr->asc == 0x38 && sshdr->ascq == 0x07) {
+		if (sshdr->sense_code ==
+		    THIN_PROVISIONING_SOFT_THRESHOLD_REACHED) {
 			evt_type = SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED;
 			sdev_printk(KERN_WARNING, sdev,
 				    "Warning! Received an indication that the "
@@ -515,7 +518,8 @@ static void scsi_report_sense(struct scsi_device *sdev,
 				    "threshold.\n");
 		}
 
-		if (sshdr->asc == 0x29) {
+		if (scsi_sense_asc(sshdr) ==
+		    ASC_POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED) {
 			evt_type = SDEV_EVT_POWER_ON_RESET_OCCURRED;
 			/*
 			 * Do not print message if it is an expected side-effect
@@ -526,21 +530,22 @@ static void scsi_report_sense(struct scsi_device *sdev,
 					    "Power-on or device reset occurred\n");
 		}
 
-		if (sshdr->asc == 0x2a && sshdr->ascq == 0x01) {
+		if (sshdr->sense_code == MODE_PARAMETERS_CHANGED) {
 			evt_type = SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED;
 			sdev_printk(KERN_WARNING, sdev,
 				    "Mode parameters changed");
-		} else if (sshdr->asc == 0x2a && sshdr->ascq == 0x06) {
+		} else if (sshdr->sense_code == ASYMMETRIC_ACCESS_STATE_CHANGED) {
 			evt_type = SDEV_EVT_ALUA_STATE_CHANGE_REPORTED;
 			sdev_printk(KERN_WARNING, sdev,
 				    "Asymmetric access state changed");
-		} else if (sshdr->asc == 0x2a && sshdr->ascq == 0x09) {
+		} else if (sshdr->sense_code == CAPACITY_DATA_HAS_CHANGED) {
 			evt_type = SDEV_EVT_CAPACITY_CHANGE_REPORTED;
 			sdev_printk(KERN_WARNING, sdev,
 				    "Capacity data has changed");
-		} else if (sshdr->asc == 0x2a)
+		} else if (scsi_sense_asc(sshdr) == ASC_PARAMETERS_CHANGED) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "Parameters changed");
+		}
 	}
 
 	if (evt_type != SDEV_EVT_MAXBITS) {
@@ -582,9 +587,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		 * that all ULDs interested in these can see that those have
 		 * happened, even if someone else gets the sense data.
 		 */
-		if (sshdr.asc == 0x28)
+		if (scsi_sense_asc(&sshdr) ==
+		    ASC_NOT_READY_TO_READY_CHANGE_MEDIUM_MAY_HAVE_CHANGED)
 			atomic_inc(&sdev->ua_new_media_ctr);
-		else if (sshdr.asc == 0x29)
+		else if (scsi_sense_asc(&sshdr) ==
+			 ASC_POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED)
 			atomic_inc(&sdev->ua_por_ctr);
 	}
 
@@ -636,7 +643,8 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		return /* soft_error */ SUCCESS;
 
 	case ABORTED_COMMAND:
-		if (sshdr.asc == 0x10) /* DIF */
+		if (scsi_sense_asc(&sshdr) == ASC_ID_CRC_OR_ECC_ERROR)
+			/* DIF */
 			return SUCCESS;
 
 		/*
@@ -647,18 +655,20 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		 * COMMAND TIMEOUT DURING PROCESSING DUE TO ERROR RECOVERY
 		 * additional sense code qualifiers.
 		 */
-		if (sshdr.asc == 0x2e &&
-		    sshdr.ascq >= 0x01 && sshdr.ascq <= 0x03) {
+		if (sshdr.sense_code >= COMMAND_TIMEOUT_BEFORE_PROCESSING &&
+		    sshdr.sense_code <=
+		    COMMAND_TIMEOUT_DURING_PROCESSING_DUE_TO_ERROR_RECOVERY) {
 			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
 			req->cmd_flags |= REQ_FAILFAST_DEV;
 			req->rq_flags |= RQF_QUIET;
 			return SUCCESS;
 		}
 
-		if (sshdr.asc == 0x44 && sdev->sdev_bflags & BLIST_RETRY_ITF)
+		if ((sdev->sdev_bflags & BLIST_RETRY_ITF) &&
+		    scsi_sense_asc(&sshdr) == ASC_INTERNAL_TARGET_FAILURE)
 			return ADD_TO_MLQUEUE;
-		if (sshdr.asc == 0xc1 && sshdr.ascq == 0x01 &&
-		    sdev->sdev_bflags & BLIST_RETRY_ASC_C1)
+		if ((sdev->sdev_bflags & BLIST_RETRY_ASC_C1) &&
+		    sshdr.sense_code == scsi_sense_code(0xc1, 0x01))
 			return ADD_TO_MLQUEUE;
 
 		return NEEDS_RETRY;
@@ -672,12 +682,13 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		 */
 		if (scmd->device->expecting_cc_ua) {
 			/*
-			 * Because some device does not queue unit
-			 * attentions correctly, we carefully check
-			 * additional sense code and qualifier so as
-			 * not to squash media change unit attention.
+			 * Because some devices do not queue unit attentions
+			 * correctly, we carefully check additional sense code
+			 * and qualifier so as not to squash media change unit
+			 * attention.
 			 */
-			if (sshdr.asc != 0x28 || sshdr.ascq != 0x00) {
+			if (sshdr.sense_code !=
+			    NOT_READY_TO_READY_CHANGE_MEDIUM_MAY_HAVE_CHANGED) {
 				scmd->device->expecting_cc_ua = 0;
 				return NEEDS_RETRY;
 			}
@@ -688,21 +699,23 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		 * REPORTED LUNS DATA HAS CHANGED.
 		 */
 		if (scmd->device->sdev_target->expecting_lun_change &&
-		    sshdr.asc == 0x3f && sshdr.ascq == 0x0e)
+		    sshdr.sense_code == REPORTED_LUNS_DATA_HAS_CHANGED)
 			return NEEDS_RETRY;
 		/*
 		 * if the device is in the process of becoming ready, we
 		 * should retry.
 		 */
-		if ((sshdr.asc == 0x04) &&
-		    (sshdr.ascq == 0x01 || sshdr.ascq == 0x0a))
+		if (sshdr.sense_code == LU_IS_IN_PROCESS_OF_BECOMING_READY ||
+		    sshdr.sense_code ==
+		    LU_NOT_ACCESSIBLE_ASYMMETRIC_ACCESS_STATE_TRANSITION)
 			return NEEDS_RETRY;
 		/*
 		 * if the device is not started, we need to wake
 		 * the error handler to start the motor
 		 */
 		if (scmd->device->allow_restart &&
-		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
+		    sshdr.sense_code ==
+		    LU_NOT_READY_INITIALIZING_COMMAND_REQUIRED)
 			return FAILED;
 		/*
 		 * Pass the UA upwards for a determination in the completion
@@ -712,7 +725,7 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 
 		/* these are not supported */
 	case DATA_PROTECT:
-		if (sshdr.asc == 0x27 && sshdr.ascq == 0x07) {
+		if (sshdr.sense_code == SPACE_ALLOCATION_FAILED_WRITE_PROTECT) {
 			/* Thin provisioning hard threshold reached */
 			set_scsi_ml_byte(scmd, SCSIML_STAT_NOSPC);
 			return SUCCESS;
@@ -726,11 +739,14 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		return SUCCESS;
 
 	case MEDIUM_ERROR:
-		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
-		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
-		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
+		switch (scsi_sense_asc(&sshdr)) {
+		case ASC_UNRECOVERED_READ_ERROR:
+		case ASC_ADDRESS_MARK_NOT_FOUND_FOR_DATA_FIELD:
+		case ASC_RECORDED_ENTITY_NOT_FOUND:
 			set_scsi_ml_byte(scmd, SCSIML_STAT_MED_ERROR);
 			return SUCCESS;
+		default:
+			break;
 		}
 		return NEEDS_RETRY;
 
@@ -742,13 +758,17 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		fallthrough;
 
 	case ILLEGAL_REQUEST:
-		if (sshdr.asc == 0x20 || /* Invalid command operation code */
-		    sshdr.asc == 0x21 || /* Logical block address out of range */
-		    sshdr.asc == 0x22 || /* Invalid function */
-		    sshdr.asc == 0x24 || /* Invalid field in cdb */
-		    sshdr.asc == 0x26 || /* Parameter value invalid */
-		    sshdr.asc == 0x27) { /* Write protected */
+		switch (scsi_sense_asc(&sshdr)) {
+		case ASC_INVALID_COMMAND_OP_CODE:
+		case ASC_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE:
+		case ASC_ILLEGAL_FUNCTION:
+		case ASC_INVALID_FIELD_IN_CDB:
+		case ASC_INVALID_FIELD_IN_PARAMETER_LIST:
+		case ASC_WRITE_PROTECTED:
 			set_scsi_ml_byte(scmd, SCSIML_STAT_TGT_FAILURE);
+			break;
+		default:
+			break;
 		}
 		return SUCCESS;
 
@@ -760,7 +780,7 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		 * that the command was in fact aborted because it exceeded its
 		 * duration limit. Never retry these commands.
 		 */
-		if (sshdr.asc == 0x55 && sshdr.ascq == 0x0a) {
+		if (sshdr.sense_code == DATA_CURRENTLY_UNAVAILABLE) {
 			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
 			req->cmd_flags |= REQ_FAILFAST_DEV;
 			req->rq_flags |= RQF_QUIET;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index c14f81403a09..122403ec3ab8 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -96,7 +96,8 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 					    "ioctl_internal_command: "
 					    "ILLEGAL REQUEST "
 					    "asc=0x%x ascq=0x%x\n",
-					    sshdr.asc, sshdr.ascq);
+					    scsi_sense_asc(&sshdr),
+					    scsi_sense_ascq(&sshdr));
 			break;
 		case NOT_READY:	/* This happens if there is no disc in drive */
 			if (sdev->removable)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 64dbbf1d4a0a..7b1684379021 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -252,14 +252,14 @@ static int scsi_check_passthrough(struct scsi_cmnd *scmd,
 		if (failure->sense_key != sshdr.sense_key)
 			continue;
 
-		if (failure->asc == SCMD_FAILURE_ASC_ANY)
+		if (scsi_failure_asc(failure) == SCMD_FAILURE_ASC_ANY)
 			goto maybe_retry;
 
-		if (failure->asc != sshdr.asc)
+		if (scsi_failure_asc(failure) != scsi_sense_asc(&sshdr))
 			continue;
 
-		if (failure->ascq == SCMD_FAILURE_ASCQ_ANY ||
-		    failure->ascq == sshdr.ascq)
+		if (scsi_failure_ascq(failure) == SCMD_FAILURE_ASCQ_ANY ||
+		    scsi_failure_ascq(failure) == scsi_sense_ascq(&sshdr))
 			goto maybe_retry;
 	}
 
@@ -839,6 +839,8 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 		 */
 		action = ACTION_RETRY;
 	} else if (sense_valid && sense_current) {
+		u8 asc = scsi_sense_asc(&sshdr);
+
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
 			if (cmd->device->removable) {
@@ -865,64 +867,72 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 			 * where READ CAPACITY failed, we may have
 			 * read past the end of the disk.
 			 */
-			if ((cmd->device->use_10_for_rw &&
-			    sshdr.asc == 0x20 && sshdr.ascq == 0x00) &&
+			if (cmd->device->use_10_for_rw &&
+			    sshdr.sense_code == INVALID_COMMAND_OP_CODE &&
 			    (cmd->cmnd[0] == READ_10 ||
 			     cmd->cmnd[0] == WRITE_10)) {
 				/* This will issue a new 6-byte command. */
 				cmd->device->use_10_for_rw = 0;
 				action = ACTION_REPREP;
-			} else if (sshdr.asc == 0x10) /* DIX */ {
+				break;
+			}
+			if (asc == ASC_ID_CRC_OR_ECC_ERROR) {
+				/* DIX */
 				action = ACTION_FAIL;
 				blk_stat = BLK_STS_PROTECTION;
-			/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
-			} else if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
+				break;
+			}
+			if (asc == ASC_INVALID_COMMAND_OP_CODE ||
+			    asc == ASC_INVALID_FIELD_IN_CDB) {
 				action = ACTION_FAIL;
 				blk_stat = BLK_STS_TARGET;
-			} else
-				action = ACTION_FAIL;
+				break;
+			}
+			action = ACTION_FAIL;
 			break;
 		case ABORTED_COMMAND:
 			action = ACTION_FAIL;
-			if (sshdr.asc == 0x10) /* DIF */
+			if (asc == ASC_ID_CRC_OR_ECC_ERROR) /* DIF */
 				blk_stat = BLK_STS_PROTECTION;
 			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming
 			 * ready, or has a temporary blockage, retry.
 			 */
-			if (sshdr.asc == 0x04) {
-				switch (sshdr.ascq) {
-				case 0x01: /* becoming ready */
-				case 0x04: /* format in progress */
-				case 0x05: /* rebuild in progress */
-				case 0x06: /* recalculation in progress */
-				case 0x07: /* operation in progress */
-				case 0x08: /* Long write in progress */
-				case 0x09: /* self test in progress */
-				case 0x11: /* notify (enable spinup) required */
-				case 0x14: /* space allocation in progress */
-				case 0x1a: /* start stop unit in progress */
-				case 0x1b: /* sanitize in progress */
-				case 0x1d: /* configuration in progress */
-					action = ACTION_DELAYED_RETRY;
-					break;
-				case 0x0a: /* ALUA state transition */
-					action = ACTION_DELAYED_REPREP;
-					break;
-				/*
-				 * Depopulation might take many hours,
-				 * thus it is not worthwhile to retry.
-				 */
-				case 0x24: /* depopulation in progress */
-				case 0x25: /* depopulation restore in progress */
-					fallthrough;
-				default:
-					action = ACTION_FAIL;
-					break;
-				}
-			} else
+			if (asc != ASC_LU_NOT_READY) {
 				action = ACTION_FAIL;
+				break;
+			}
+
+			switch (sshdr.sense_code) {
+			case LU_IS_IN_PROCESS_OF_BECOMING_READY:
+			case LU_NOT_READY_FORMAT_IN_PROGRESS:
+			case LU_NOT_READY_REBUILD_IN_PROGRESS:
+			case LU_NOT_READY_RECALCULATION_IN_PROGRESS:
+			case LU_NOT_READY_OP_IN_PROGRESS:
+			case LU_NOT_READY_LONG_WRITE_IN_PROGRESS:
+			case LU_NOT_READY_SELFTEST_IN_PROGRESS:
+			case LU_NOT_READY_NOTIFY_REQUIRED:
+			case LU_NOT_READY_SPACE_ALLOCATION_IN_PROGRESS:
+			case LU_NOT_READY_START_STOP_UNIT_COMMAND_IN_PROGRESS:
+			case LU_NOT_READY_SANITIZE_IN_PROGRESS:
+			case LU_NOT_READY_CONFIG_IN_PROGRESS:
+				action = ACTION_DELAYED_RETRY;
+				break;
+			case LU_NOT_ACCESSIBLE_ASYMMETRIC_ACCESS_STATE_TRANSITION:
+				action = ACTION_DELAYED_REPREP;
+				break;
+			/*
+			 * Depopulation might take many hours, thus it is not
+			 * worthwhile to retry.
+			 */
+			case DEPOPULATION_IN_PROGRESS:
+			case DEPOPULATION_RESTORATION_IN_PROGRESS:
+				fallthrough;
+			default:
+				action = ACTION_FAIL;
+				break;
+			}
 			break;
 		case VOLUME_OVERFLOW:
 			/* See SSC3rXX or current. */
@@ -930,11 +940,14 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 			break;
 		case DATA_PROTECT:
 			action = ACTION_FAIL;
-			if ((sshdr.asc == 0x0C && sshdr.ascq == 0x12) ||
-			    (sshdr.asc == 0x55 &&
-			     (sshdr.ascq == 0x0E || sshdr.ascq == 0x0F))) {
-				/* Insufficient zone resources */
+			switch (sshdr.sense_code) {
+			case WRITE_ERROR_INSUFFICIENT_ZONE_RESOURCES:
+			case INSUFFICIENT_ZONE_RESOURCES:
+			case INSUFFICIENT_ZONE_RESOURCES_TO_COMPLETE_WRITE:
 				blk_stat = BLK_STS_ZONE_OPEN_RESOURCE;
+				break;
+			default:
+				break;
 			}
 			break;
 		case COMPLETED:
@@ -1041,7 +1054,7 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 		 * skip print since caller wants ATA registers. Only occurs
 		 * on SCSI ATA PASS_THROUGH commands when CK_COND=1
 		 */
-		if ((sshdr.asc == 0x0) && (sshdr.ascq == 0x1d))
+		if (sshdr.sense_code == ATA_PASS_THROUGH_INFORMATION_AVAILABLE)
 			do_print = false;
 		else if (req->rq_flags & RQF_QUIET)
 			do_print = false;
@@ -2373,8 +2386,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.allowed = retries,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -2432,8 +2444,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 
 	if (!scsi_status_is_good(result)) {
 		if (scsi_sense_valid(sshdr)) {
-			if ((sshdr->sense_key == ILLEGAL_REQUEST) &&
-			    (sshdr->asc == 0x20) && (sshdr->ascq == 0)) {
+			if (sshdr->sense_key == ILLEGAL_REQUEST &&
+			    sshdr->sense_code == INVALID_COMMAND_OP_CODE) {
 				/*
 				 * Invalid command operation code: retry using
 				 * MODE SENSE(6) if this was a MODE SENSE(10)
diff --git a/drivers/scsi/scsi_lib_test.c b/drivers/scsi/scsi_lib_test.c
index 4558dc853e26..dfd8eefe57e1 100644
--- a/drivers/scsi/scsi_lib_test.c
+++ b/drivers/scsi/scsi_lib_test.c
@@ -18,41 +18,42 @@ static void scsi_lib_test_multiple_sense(struct kunit *test)
 	struct scsi_failure multiple_sense_failure_defs[] = {
 		{
 			.sense_key = DATA_PROTECT,
-			.asc = 0x1,
-			.ascq = 0x1,
+			.sense_code =
+				scsi_sense_code(ASC_NO_INDEX_SECTOR_SIGNAL,
+						0x1),
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x11,
-			.ascq = 0x0,
+			.sense_code = UNRECOVERED_READ_ERROR,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = NOT_READY,
-			.asc = 0x11,
-			.ascq = 0x22,
+			.sense_code =
+				scsi_sense_code(ASC_UNRECOVERED_READ_ERROR,
+						0x22),
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = ABORTED_COMMAND,
-			.asc = 0x11,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code =
+				scsi_sense_code(ASC_UNRECOVERED_READ_ERROR,
+						SCMD_FAILURE_ASCQ_ANY),
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = HARDWARE_ERROR,
-			.asc = SCMD_FAILURE_ASC_ANY,
+			.sense_code = scsi_sense_code(SCMD_FAILURE_ASC_ANY, 0),
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = ILLEGAL_REQUEST,
-			.asc = 0x91,
-			.ascq = 0x36,
+			.sense_code = scsi_sense_code(0x91, 0x36),
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -72,32 +73,36 @@ static void scsi_lib_test_multiple_sense(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
 	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, NULL));
 	/* Command failed but caller did not pass in a failures array */
-	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	scsi_set_sense(&sc, 0, ILLEGAL_REQUEST, scsi_sense_code(0x91, 0x36));
 	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, NULL));
 	/* Match end of array */
-	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	scsi_set_sense(&sc, 0, ILLEGAL_REQUEST, scsi_sense_code(0x91, 0x36));
 	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
 	/* Basic match in array */
-	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x11, 0x0);
+	scsi_set_sense(&sc, 0, UNIT_ATTENTION, UNRECOVERED_READ_ERROR);
 	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
 	/* No matching sense entry */
-	scsi_build_sense(&sc, 0, MISCOMPARE, 0x11, 0x11);
+	scsi_set_sense(&sc, 0, MISCOMPARE, READ_ERROR_LOSS_OF_STREAMING);
 	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
 	/* Match using SCMD_FAILURE_ASCQ_ANY */
-	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x11, 0x22);
+	scsi_set_sense(&sc, 0, ABORTED_COMMAND,
+		       scsi_sense_code(ASC_UNRECOVERED_READ_ERROR, 0x22));
 	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
 	/* Fail to match */
-	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x22, 0x22);
+	scsi_set_sense(&sc, 0, ABORTED_COMMAND,
+		       scsi_sense_code(ASC_ILLEGAL_FUNCTION, 0x22));
 	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
 	/* Match using SCMD_FAILURE_ASC_ANY */
-	scsi_build_sense(&sc, 0, HARDWARE_ERROR, 0x11, 0x22);
+	scsi_set_sense(&sc, 0, HARDWARE_ERROR,
+		       scsi_sense_code(ASC_UNRECOVERED_READ_ERROR, 0x22));
 	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
 	/* No matching status entry */
 	sc.result = SAM_STAT_RESERVATION_CONFLICT;
 	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
 
 	/* Test hitting allowed limit */
-	scsi_build_sense(&sc, 0, NOT_READY, 0x11, 0x22);
+	scsi_set_sense(&sc, 0, NOT_READY,
+		       scsi_sense_code(ASC_UNRECOVERED_READ_ERROR, 0x22));
 	for (i = 0; i < SCSI_LIB_TEST_MAX_ALLOWED; i++)
 		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
 				&failures));
@@ -108,7 +113,8 @@ static void scsi_lib_test_multiple_sense(struct kunit *test)
 	scsi_failures_reset_retries(&failures);
 
 	/* Test no retries allowed */
-	scsi_build_sense(&sc, 0, DATA_PROTECT, 0x1, 0x1);
+	scsi_set_sense(&sc, 0, DATA_PROTECT,
+		       scsi_sense_code(ASC_NO_INDEX_SECTOR_SIGNAL, 0x1));
 	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
 }
 
@@ -118,7 +124,7 @@ static void scsi_lib_test_any_sense(struct kunit *test)
 		{
 			.sense_key = SCMD_FAILURE_SENSE_KEY_ANY,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
-			.result = SCMD_FAILURE_RESULT_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{}
 	};
@@ -132,7 +138,8 @@ static void scsi_lib_test_any_sense(struct kunit *test)
 
 	/* Match using SCMD_FAILURE_SENSE_KEY_ANY */
 	failures.failure_definitions = any_sense_failure_defs;
-	scsi_build_sense(&sc, 0, MEDIUM_ERROR, 0x11, 0x22);
+	scsi_set_sense(&sc, 0, MEDIUM_ERROR,
+		       scsi_sense_code(ASC_UNRECOVERED_READ_ERROR, 0x22));
 	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
 }
 
@@ -217,8 +224,7 @@ static void scsi_lib_test_total_allowed(struct kunit *test)
 	struct scsi_failure total_allowed_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Fail all CCs except the UA above */
@@ -246,7 +252,8 @@ static void scsi_lib_test_total_allowed(struct kunit *test)
 	scsi_failures_reset_retries(&failures);
 	failures.total_allowed = SCSI_LIB_TEST_TOTAL_MAX_ALLOWED;
 
-	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x28, 0x0);
+	scsi_set_sense(&sc, 0, UNIT_ATTENTION,
+		       NOT_READY_TO_READY_CHANGE_MEDIUM_MAY_HAVE_CHANGED);
 	for (i = 0; i < SCSI_LIB_TEST_TOTAL_MAX_ALLOWED; i++)
 		/* Retry since we under the total_allowed limit */
 		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
@@ -261,12 +268,14 @@ static void scsi_lib_test_mixed_total(struct kunit *test)
 	struct scsi_failure mixed_total_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x28,
+			.sense_code =
+				NOT_READY_TO_READY_CHANGE_MEDIUM_MAY_HAVE_CHANGED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x29,
+			.sense_code =
+				POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
@@ -292,7 +301,8 @@ static void scsi_lib_test_mixed_total(struct kunit *test)
 	scsi_failures_reset_retries(&failures);
 	failures.total_allowed = SCSI_LIB_TEST_TOTAL_MAX_ALLOWED;
 
-	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x28, 0x0);
+	scsi_set_sense(&sc, 0, UNIT_ATTENTION,
+		       NOT_READY_TO_READY_CHANGE_MEDIUM_MAY_HAVE_CHANGED);
 	for (i = 0; i < SCSI_LIB_TEST_TOTAL_MAX_ALLOWED; i++)
 		/* Retry since we under the total_allowed limit */
 		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
@@ -301,7 +311,8 @@ static void scsi_lib_test_mixed_total(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
 
 	scsi_failures_reset_retries(&failures);
-	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x28, 0x0);
+	scsi_set_sense(&sc, 0, UNIT_ATTENTION,
+		       NOT_READY_TO_READY_CHANGE_MEDIUM_MAY_HAVE_CHANGED);
 	for (i = 0; i < SCSI_LIB_TEST_TOTAL_MAX_ALLOWED; i++)
 		/* Retry since we under the total_allowed limit */
 		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
@@ -309,7 +320,8 @@ static void scsi_lib_test_mixed_total(struct kunit *test)
 	sc.result = DID_TIME_OUT << 16;
 	/* Retry because this failure has a per failure limit */
 	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
-	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x29, 0x0);
+	scsi_set_sense(&sc, 0, UNIT_ATTENTION,
+		       POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED);
 	/* total_allowed is now hit so no more retries */
 	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
 }
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8fe93962dc87..e9ac10cdaac8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -652,19 +652,18 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int pass, count, result, resid;
 	struct scsi_failure failure_defs[] = {
 		/*
-		 * not-ready to ready transition [asc/ascq=0x28/0x0] or
-		 * power-on, reset [asc/ascq=0x29/0x0], continue. INQUIRY
-		 * should not yield UNIT_ATTENTION but many buggy devices do
-		 * so anyway.
+		 * not-ready to ready transition or power-on, reset, continue.
+		 * INQUIRY should not yield UNIT_ATTENTION but many buggy
+		 * devices do so anyway.
 		 */
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x28,
+			.sense_code = NOT_READY_TO_READY_CHANGE_MEDIUM_MAY_HAVE_CHANGED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x29,
+			.sense_code = POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
@@ -1458,8 +1457,7 @@ static int scsi_report_lun_scan(struct Scsi_Host *shost,
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Fail all CCs except the UA above */
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index ec3884a6657f..bd049d549244 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -113,8 +113,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.allowed = DV_RETRIES,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -680,10 +679,9 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 		if (result || !scsi_device_online(sdev)) {
 
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
-			if (result > 0 && scsi_sense_valid(&sshdr)
-			    && sshdr.sense_key == ILLEGAL_REQUEST
-			    /* INVALID FIELD IN CDB */
-			    && sshdr.asc == 0x24 && sshdr.ascq == 0x00)
+			if (result > 0 && scsi_sense_valid(&sshdr) &&
+			    sshdr.sense_key == ILLEGAL_REQUEST &&
+			    sshdr.sense_code == INVALID_FIELD_IN_CDB)
 				/* This would mean that the drive lied
 				 * to us about supporting an echo
 				 * buffer (unfortunately some Western
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index c36c72ab7f2b..e8328df587c3 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -303,8 +303,8 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
 		    scsi_command_normalize_sense(cmd, &sshdr)) {
 			__entry->sense_key = sshdr.sense_key;
-			__entry->asc = sshdr.asc;
-			__entry->ascq = sshdr.ascq;
+			__entry->asc = scsi_sense_asc(&sshdr);
+			__entry->ascq = scsi_sense_ascq(&sshdr);
 		} else {
 			__entry->sense_key = 0;
 			__entry->asc = 0;
-- 
2.55.0

