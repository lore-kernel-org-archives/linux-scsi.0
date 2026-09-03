Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2513803D3;
	Thu,  3 Sep 2026 03:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406960; cv=none; b=LhVNGqgwaQuZBJttJ1UfN5+6Q+ipz7g8e8flcX4BU9Jb/KuCnTXKue4g1jOudIQvmOTiFn1GgZqOy3mBYmcmNBGv60wAfME5JbYv1+hyKK+IqTyw3aGHIB85s8NjgPRx4Dq9PQUPLRSLCJaX1FMsEWND/qmb5fZOxtGu1rlvo1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406960; c=relaxed/simple;
	bh=zcdyRW+GCoNas2BBCl+OGx+51H8elnepCjbRzd0+dnA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oH0+XX4tpBf0S6Ika+wvGmvWblG13MpQt/gy2/YSDNo48IAX2OYI3xeo/r4jZiBeGXa/STAXBx1ZKYSfbIGM1Ptey66MV63Mz+Ok+B0Nxy9GKKwTPMhG8u/87tbSwcZOrRB1s9wlU+iTonJNjKVd2CCtS11ranYhwaL3m+45++k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nGuo5Kgl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nGuo5Kgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856241F00A3F;
	Thu,  3 Sep 2026 03:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406950;
	bh=RJYkdlJAeVFoQGIW6po4irXpwWzAMmnUUe74jPJz2XU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=nGuo5KglP0lXJ4m9q1pwFybjaxKNUimioB7z0amXgY9dLFp6CbmXMgjS2xEGvnwly
	 9vWHerFA9xcZZW/ZOVxUQQiG+Q8wpfTLmMluF8l2sQrJTRmtZoevjEc7ysPYUgpMTr
	 YH8yQqXcNmKt8Yj/MMcLCk1Dv5Bnln9T2ZXuUsOfTj03TeaNCOLdj2ywcdGhB3ruMd
	 PGn3mfwkUj08A+OkmtyqJCg+UhDc80mbRcXJLzuRHAe7JA+2wnOiAvBw33S/eENQur
	 6paCYvBmLh4uvfC6TJ/pqU+uUIgnIdx2EvaQhC0AAz8l79+FmqHjJIyUmgQRFY5z8x
	 4x5KG9nPr7WmQ==
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
Subject: [PATCH v2 08/40] scsi: sd: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:29 +0900
Message-ID: <20260903034201.112211-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the SCSI disk driver to use as much as possible the 16-bits
sense_code field of struct scsi_sense_hdr and struct scsi_failure and
replace all hard-coded additional sense codes and additional sense code
qualifiers with the enum values defined in include/scsi/scsi_sense.h. This
helps with code clarity as the sense codes being processed are easier to
test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.c     | 106 +++++++++++++++++++++---------------------
 drivers/scsi/sd_zbc.c |   2 +-
 2 files changed, 53 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fecb001115ab..b0d2542fd317 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1786,8 +1786,7 @@ static int media_not_present(struct scsi_disk *sdkp,
 	switch (sshdr->sense_key) {
 	case UNIT_ATTENTION:
 	case NOT_READY:
-		/* medium not present */
-		if (sshdr->asc == 0x3A) {
+		if (scsi_sense_asc(sshdr) == ASC_MEDIUM_NOT_PRESENT) {
 			set_media_not_present(sdkp);
 			return 1;
 		}
@@ -1911,12 +1910,14 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
 		if (scsi_status_is_check_condition(res) &&
 		    scsi_sense_valid(&sshdr)) {
+			u8 asc = scsi_sense_asc(&sshdr);
+
 			sd_print_sense_hdr(sdkp, &sshdr);
 
 			/* we need to evaluate the error return  */
-			if (sshdr.asc == 0x3a ||	/* medium not present */
-			    sshdr.asc == 0x20 ||	/* invalid command */
-			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
+			if (asc == ASC_MEDIUM_NOT_PRESENT ||
+			    asc == ASC_INVALID_COMMAND_OP_CODE ||
+			    sshdr.sense_code == LU_ACCESS_NOT_AUTHORIZED)
 				/* this is no error here */
 				return 0;
 
@@ -1926,8 +1927,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 			 * this is called during shutdown or suspend so just
 			 * return success so those operations can proceed.
 			 */
-			if ((sshdr.asc == 0x04 && sshdr.ascq == 0x04) ||
-			    sshdr.sense_key == ILLEGAL_REQUEST)
+			if (sshdr.sense_key == ILLEGAL_REQUEST ||
+			    sshdr.sense_code == LU_NOT_READY_FORMAT_IN_PROGRESS)
 				return 0;
 		}
 
@@ -2015,7 +2016,9 @@ static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
 			return PR_STS_IOERR;
 
 		if (sshdr->sense_key == ILLEGAL_REQUEST &&
-		    (sshdr->asc == 0x26 || sshdr->asc == 0x24))
+		    (scsi_sense_asc(sshdr) ==
+				ASC_INVALID_FIELD_IN_PARAMETER_LIST ||
+		     scsi_sense_asc(sshdr) == ASC_INVALID_FIELD_IN_CDB))
 			return -EINVAL;
 
 		fallthrough;
@@ -2034,8 +2037,7 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.allowed = 5,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -2146,8 +2148,7 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.allowed = 5,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -2440,16 +2441,17 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		break;
 	case ABORTED_COMMAND:
-		if (sshdr.asc == 0x10)  /* DIF: Target detected corruption */
+		if (scsi_sense_asc(&sshdr) == ASC_ID_CRC_OR_ECC_ERROR) /* DIF */
 			good_bytes = sd_completed_bytes(SCpnt);
 		break;
 	case ILLEGAL_REQUEST:
-		switch (sshdr.asc) {
-		case 0x10:	/* DIX: Host detected corruption */
+		switch (scsi_sense_asc(&sshdr)) {
+		case ASC_ID_CRC_OR_ECC_ERROR:
+			/* DIX */
 			good_bytes = sd_completed_bytes(SCpnt);
 			break;
-		case 0x20:	/* INVALID COMMAND OPCODE */
-		case 0x24:	/* INVALID FIELD IN CDB */
+		case ASC_INVALID_COMMAND_OP_CODE:
+		case ASC_INVALID_FIELD_IN_CDB:
 			switch (SCpnt->cmnd[0]) {
 			case UNMAP:
 				sd_disable_discard(sdkp);
@@ -2495,14 +2497,14 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		/* Do not retry Medium Not Present */
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x3A,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code =
+				MEDIUM_NOT_PRESENT | SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = NOT_READY,
-			.asc = 0x3A,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code =
+				MEDIUM_NOT_PRESENT | SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Retry when scsi_status_is_good would return false 3 times */
@@ -2566,18 +2568,18 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			break;
 
 		if (sense_valid && sshdr.sense_key == NOT_READY) {
-			if (sshdr.asc == 4 && sshdr.ascq == 3)
-				break;	/* manual intervention required */
-			if (sshdr.asc == 4 && sshdr.ascq == 0xb)
-				break;	/* standby */
-			if (sshdr.asc == 4 && sshdr.ascq == 0xc)
-				break;	/* unavailable */
-			if (sshdr.asc == 4 && sshdr.ascq == 0x1b)
-				break;	/* sanitize in progress */
-			if (sshdr.asc == 4 && sshdr.ascq == 0x24)
-				break;	/* depopulation in progress */
-			if (sshdr.asc == 4 && sshdr.ascq == 0x25)
-				break;	/* depopulation restoration in progress */
+			switch (sshdr.sense_code) {
+			case LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED:
+			case LU_NOT_ACCESSIBLE_TARGET_PORT_IN_STANDBY_STATE:
+			case LU_NOT_ACCESSIBLE_TARGET_PORT_IN_UNAVAILABLE_STATE:
+			case LU_NOT_READY_SANITIZE_IN_PROGRESS:
+			case DEPOPULATION_IN_PROGRESS:
+			case DEPOPULATION_RESTORATION_IN_PROGRESS:
+				goto out;
+			default:
+				break;
+			}
+
 			/*
 			 * Issue command to spin up drive when not ready
 			 */
@@ -2608,8 +2610,9 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		 * occur here.  It's characteristic of these devices.
 		 */
 		} else if (sense_valid &&
-				sshdr.sense_key == UNIT_ATTENTION &&
-				sshdr.asc == 0x28) {
+			   sshdr.sense_key == UNIT_ATTENTION &&
+			   scsi_sense_asc(&sshdr) ==
+			   ASC_NOT_READY_TO_READY_CHANGE_MEDIUM_MAY_HAVE_CHANGED) {
 			if (!spintime) {
 				spintime_expire = jiffies + 5 * HZ;
 				spintime = 1;
@@ -2628,6 +2631,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				
 	} while (spintime && time_before_eq(jiffies, spintime_expire));
 
+out:
 	if (spintime) {
 		if (scsi_status_is_good(the_result))
 			printk(KERN_CONT "ready\n");
@@ -2753,15 +2757,14 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
+			    (sshdr.sense_code == INVALID_COMMAND_OP_CODE ||
+			     sshdr.sense_code == INVALID_FIELD_IN_CDB))
+				/* Just retry silently with RC10 */
 				return -EINVAL;
 			if (sense_valid &&
 			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
+			    sshdr.sense_code ==
+			    POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED)
 				/* Device reset might occur several times,
 				 * give it one more chance */
 				if (--reset_retries > 0)
@@ -2818,18 +2821,18 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		/* Do not retry Medium Not Present */
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x3A,
+			.sense_code = MEDIUM_NOT_PRESENT,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = NOT_READY,
-			.asc = 0x3A,
+			.sense_code = MEDIUM_NOT_PRESENT,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		 /* Device reset might occur several times so retry a lot */
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x29,
+			.sense_code = POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED,
 			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -3258,8 +3261,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 bad_sense:
 	if (res == -EIO && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
-	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
-		/* Invalid field in CDB */
+	    sshdr.sense_code == INVALID_FIELD_IN_CDB)
 		sd_first_printk(KERN_NOTICE, sdkp, "Cache data unavailable\n");
 	else
 		sd_first_printk(KERN_ERR, sdkp,
@@ -4160,22 +4162,19 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 		{
 			/* Power on, reset, or bus device reset occurred */
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x29,
-			.ascq = 0,
+			.sense_code = POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			/* Power on occurred */
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x29,
-			.ascq = 1,
+			.sense_code = POWER_ON_OCCURRED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			/* SCSI bus reset */
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x29,
-			.ascq = 2,
+			.sense_code = SCSI_BUS_RESET_OCCURRED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{}
@@ -4207,8 +4206,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (res > 0 && scsi_sense_valid(&sshdr)) {
 			sd_print_sense_hdr(sdkp, &sshdr);
-			/* 0x3a is medium not present */
-			if (sshdr.asc == 0x3a)
+			if (scsi_sense_asc(&sshdr) == ASC_MEDIUM_NOT_PRESENT)
 				res = 0;
 		}
 	}
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 56e455fb5add..98f1b9864a79 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -369,7 +369,7 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 	if (op_is_zone_mgmt(req_op(rq)) &&
 	    result &&
 	    sshdr->sense_key == ILLEGAL_REQUEST &&
-	    sshdr->asc == 0x24) {
+	    sshdr->sense_code == INVALID_FIELD_IN_CDB) {
 		/*
 		 * INVALID FIELD IN CDB error: a zone management command was
 		 * attempted on a conventional zone. Nothing to worry about,
-- 
2.55.0

