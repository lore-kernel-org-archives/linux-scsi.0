Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA063A6B8F;
	Thu,  3 Sep 2026 03:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407010; cv=none; b=WiwexJoEz0v32OLpc/3xuXKnFlZ2IDVV8mLoSHqIujGnXa9TrogRvyGLJzPUbZVes0zApED0aq73wqzQYZVFYBz4E0FIYmt/WhiyA8yV6thIf68CLblEx29f3Ao367K+S7C7Gk/mNIBdEJmNBRRHGWZ0RL7yeUBNlqYkbaYVyxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407010; c=relaxed/simple;
	bh=IbYm7cP+21Jqyg7+ZshPIAKrbV5Tt1hZMvRo+HF2NZ0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwXbK9QAgNaw6GgqrJKnwNuly2xwY7lXFnKYpewIYPNg7l8xxu+6hKXPVyvc95NIiqZWTpPM1Yr3EZ0+depEckcT9aY2YQCa5Y4vUwZheD1lkMDTp3cYqbyOm7UZewIjy5ebSerrHHUJrwRoyN04ymQf6lpIfJQmn0qRM+E9z24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nzex5+IT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nzex5+IT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9621F00A3A;
	Thu,  3 Sep 2026 03:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407003;
	bh=k1/WzEDyeeHtOcq/dUfbQQ0V9vUwrQgcqoT0tDBm848=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Nzex5+ITxUWjvmSf0rnyEqQNBmUo1/iSGhWJd1il1ZGN4ZwmcmWJ+WIwEPHZ1zeNJ
	 ghkiWRAvOPgCCXmtBLF2gldcharDzyU4hvwr698uGKzjQwIatH7jlFpTIbaFHJtRli
	 uhgHUOKXXt8SPk0qAyaA+KMst6G++Fc+laOetkEtU8Vkz44oWL3PITGxetyKS2cK5j
	 N5yTusRMl/QHtXP0DOE3ouewbmvS7fY8kVJdrdeFBblJUoRfLa5DCawy2Gl97YewSD
	 9hW+cC+BiW34JMOjW/lRsrLcJBMXrBaMZ7wCJLg0r0exeBHvU0VZhFoVaaJlbGkaRW
	 NV6ly0exIs5Zw==
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
Subject: [PATCH v2 37/40] ata: libata: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:58 +0900
Message-ID: <20260903034201.112211-38-dlemoal@kernel.org>
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

Refactor libata core code to use the 16-bits sense_code field of
struct scsi_sense_hdr and replace all hard-coded additional sense codes
and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-eh.c   |  13 +-
 drivers/ata/libata-sata.c |  20 +--
 drivers/ata/libata-scsi.c | 346 +++++++++++++++++++++++---------------
 drivers/ata/libata.h      |   5 +-
 4 files changed, 229 insertions(+), 155 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c93c24b22d9c..71961fbaa42f 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1516,11 +1516,13 @@ static bool ata_eh_request_sense(struct ata_queued_cmd *qc)
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 	/* Ignore err_mask; ATA_ERR might be set */
 	if (tf.status & ATA_SENSE) {
-		if (ata_scsi_sense_is_valid(tf.lbah, tf.lbam, tf.lbal)) {
+		u16 sense_code = scsi_sense_code(tf.lbam, tf.lbal);
+
+		if (ata_scsi_sense_is_valid(tf.lbah, sense_code)) {
 			/* Set sense without also setting scsicmd->result */
-			scsi_build_sense_buffer(dev->flags & ATA_DFLAG_D_SENSE,
-						cmd->sense_buffer, tf.lbah,
-						tf.lbam, tf.lbal);
+			scsi_set_sense_buffer(dev->flags & ATA_DFLAG_D_SENSE,
+					      cmd->sense_buffer, tf.lbah,
+					      sense_code);
 			qc->flags |= ATA_QCFLAG_SENSE_VALID;
 			return true;
 		}
@@ -2094,7 +2096,8 @@ static void ata_eh_get_success_sense(struct ata_link *link)
 			continue;
 
 		/* This success command had sense data, but we failed to get. */
-		ata_scsi_set_sense(dev, qc->scsicmd, ABORTED_COMMAND, 0, 0);
+		ata_scsi_set_sense(dev, qc->scsicmd, ABORTED_COMMAND,
+				   NO_ADDITIONAL_SENSE_INFORMATION);
 		qc->flags |= ATA_QCFLAG_SENSE_VALID;
 	}
 	ata_eh_done(link, dev, ATA_EH_GET_SUCCESS_SENSE);
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index ad40f516c6d4..32fd0e804654 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1588,7 +1588,7 @@ int ata_eh_get_ncq_success_sense(struct ata_link *link)
 		asc = sense[1];
 		ascq = sense[2];
 
-		if (!ata_scsi_sense_is_valid(sk, asc, ascq)) {
+		if (!ata_scsi_sense_is_valid(sk, scsi_sense_code(asc, ascq))) {
 			ret = -EIO;
 			continue;
 		}
@@ -1605,9 +1605,9 @@ int ata_eh_get_ncq_success_sense(struct ata_link *link)
 			qc->result_tf.auxiliary = get_unaligned_le32(&sense[16]);
 
 		/* Set sense without also setting scsicmd->result */
-		scsi_build_sense_buffer(dev->flags & ATA_DFLAG_D_SENSE,
-					qc->scsicmd->sense_buffer, sk,
-					asc, ascq);
+		scsi_set_sense_buffer(dev->flags & ATA_DFLAG_D_SENSE,
+				      qc->scsicmd->sense_buffer, sk,
+				      scsi_sense_code(asc, ascq));
 		qc->flags |= ATA_QCFLAG_SENSE_VALID;
 
 		/*
@@ -1684,14 +1684,14 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 	 * stored the sense data in qc->result_tf.auxiliary.
 	 */
 	if (qc->result_tf.auxiliary) {
-		char sense_key, asc, ascq;
+		u16 sense_code;
+		u8 sense_key;
 
 		sense_key = (qc->result_tf.auxiliary >> 16) & 0xff;
-		asc = (qc->result_tf.auxiliary >> 8) & 0xff;
-		ascq = qc->result_tf.auxiliary & 0xff;
-		if (ata_scsi_sense_is_valid(sense_key, asc, ascq)) {
-			ata_scsi_set_sense(dev, qc->scsicmd, sense_key, asc,
-					   ascq);
+		sense_code = qc->result_tf.auxiliary & 0xffff;
+		if (ata_scsi_sense_is_valid(sense_key, sense_code)) {
+			ata_scsi_set_sense(dev, qc->scsicmd, sense_key,
+					   sense_code);
 			qc->flags |= ATA_QCFLAG_SENSE_VALID;
 		}
 	}
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a7d667cfcfec..66fef7ffbf1b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -190,28 +190,25 @@ DEVICE_ATTR(unload_heads, S_IRUGO | S_IWUSR,
 	    ata_scsi_park_show, ata_scsi_park_store);
 EXPORT_SYMBOL_GPL(dev_attr_unload_heads);
 
-bool ata_scsi_sense_is_valid(u8 sk, u8 asc, u8 ascq)
+bool ata_scsi_sense_is_valid(u8 sense_key, u16 sense_code)
 {
-	/*
-	 * If sk == NO_SENSE, and asc + ascq == NO ADDITIONAL SENSE INFORMATION,
-	 * then there is no sense data to add.
-	 */
-	if (sk == 0 && asc == 0 && ascq == 0)
+	if (sense_key == NO_SENSE &&
+	    sense_code == NO_ADDITIONAL_SENSE_INFORMATION)
 		return false;
 
 	/* If sk > COMPLETED, sense data is bogus. */
-	if (sk > COMPLETED)
+	if (sense_key > COMPLETED)
 		return false;
 
 	return true;
 }
 
 void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
-			u8 sk, u8 asc, u8 ascq)
+			u8 sk, u16 code)
 {
 	bool d_sense = (dev->flags & ATA_DFLAG_D_SENSE);
 
-	scsi_build_sense(cmd, d_sense, sk, asc, ascq);
+	scsi_set_sense(cmd, d_sense, sk, code);
 }
 
 static void ata_scsi_set_sense_information(struct ata_queued_cmd *qc)
@@ -316,8 +313,7 @@ static void ata_scsi_set_passthru_sense_fields(struct ata_queued_cmd *qc)
 static void ata_scsi_set_invalid_field(struct ata_device *dev,
 				       struct scsi_cmnd *cmd, u16 field, u8 bit)
 {
-	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x24, 0x0);
-	/* "Invalid field in CDB" */
+	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB);
 	scsi_set_sense_field_pointer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				     field, bit, 1);
 }
@@ -325,8 +321,8 @@ static void ata_scsi_set_invalid_field(struct ata_device *dev,
 static void ata_scsi_set_invalid_parameter(struct ata_device *dev,
 					   struct scsi_cmnd *cmd, u16 field)
 {
-	/* "Invalid field in parameter list" */
-	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x26, 0x0);
+	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST,
+			   INVALID_FIELD_IN_PARAMETER_LIST);
 	scsi_set_sense_field_pointer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				     field, 0xff, 0);
 }
@@ -525,7 +521,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 		 * check condition even if no error. Filter that. */
 		if (scsi_status_is_check_condition(cmd_result)) {
 			if (sshdr.sense_key == RECOVERED_ERROR &&
-			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
+			    sshdr.sense_code ==
+			    ATA_PASS_THROUGH_INFORMATION_AVAILABLE)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
@@ -613,7 +610,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 		 * check condition even if no error. Filter that. */
 		if (cmd_result & SAM_STAT_CHECK_CONDITION) {
 			if (sshdr.sense_key == RECOVERED_ERROR &&
-			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
+			    sshdr.sense_code ==
+			    ATA_PASS_THROUGH_INFORMATION_AVAILABLE)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
@@ -792,79 +790,143 @@ static void ata_qc_set_pc_nbytes(struct ata_queued_cmd *qc)
 	qc->nbytes = scsi_bufflen(scmd) + qc->extrabytes;
 }
 
+struct ata_err_sense {
+	u8	err_mask;
+	u8	sense_key;
+	u16	sense_code;
+};
+
 /**
  *	ata_to_sense_error - convert ATA error to SCSI error
  *	@drv_stat: value contained in ATA status register
  *	@drv_err: value contained in ATA error register
  *	@sk: the sense key we'll fill out
- *	@asc: the additional sense code we'll fill out
- *	@ascq: the additional sense code qualifier we'll fill out
+ *	@scode: the additional sense code and its qualifier we'll fill out
  *
  *	Converts an ATA error into a SCSI error.  Fill out pointers to
- *	SK, ASC, and ASCQ bytes for later use in fixed or descriptor
+ *	the sense key and sense code for later use in fixed or descriptor
  *	format sense blocks.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-static void ata_to_sense_error(u8 drv_stat, u8 drv_err, u8 *sk, u8 *asc,
-			       u8 *ascq)
+static void ata_to_sense_error(u8 drv_stat, u8 drv_err, u8 *sk, u16 *scode)
 {
 	int i;
 
 	/* Based on the 3ware driver translation table */
-	static const unsigned char sense_table[][4] = {
-		/* BBD|ECC|ID|MAR */
-		{0xd1,		ABORTED_COMMAND, 0x00, 0x00},
-			// Device busy                  Aborted command
-		/* BBD|ECC|ID */
-		{0xd0,		ABORTED_COMMAND, 0x00, 0x00},
-			// Device busy                  Aborted command
-		/* ECC|MC|MARK */
-		{0x61,		HARDWARE_ERROR, 0x00, 0x00},
-			// Device fault                 Hardware error
-		/* ICRC|ABRT */		/* NB: ICRC & !ABRT is BBD */
-		{0x84,		ABORTED_COMMAND, 0x47, 0x00},
-			// Data CRC error               SCSI parity error
-		/* MC|ID|ABRT|TRK0|MARK */
-		{0x37,		NOT_READY, 0x04, 0x00},
-			// Unit offline                 Not ready
-		/* MCR|MARK */
-		{0x09,		NOT_READY, 0x04, 0x00},
-			// Unrecovered disk error       Not ready
-		/*  Bad address mark */
-		{0x01,		MEDIUM_ERROR, 0x13, 0x00},
-			// Address mark not found for data field
-		/* TRK0 - Track 0 not found */
-		{0x02,		HARDWARE_ERROR, 0x00, 0x00},
-			// Hardware error
-		/* Abort: 0x04 is not translated here, see below */
-		/* Media change request */
-		{0x08,		NOT_READY, 0x04, 0x00},
-			// FIXME: faking offline
-		/* SRV/IDNF - ID not found */
-		{0x10,		ILLEGAL_REQUEST, 0x21, 0x00},
-			// Logical address out of range
-		/* MC - Media Changed */
-		{0x20,		UNIT_ATTENTION, 0x28, 0x00},
-			// Not ready to ready change, medium may have changed
-		/* ECC - Uncorrectable ECC error */
-		{0x40,		MEDIUM_ERROR, 0x11, 0x04},
-			// Unrecovered read error
-		/* BBD - block marked bad */
-		{0x80,		MEDIUM_ERROR, 0x11, 0x04},
-			// Block marked bad	Medium error, unrecovered read error
-		{0xFF, 0xFF, 0xFF, 0xFF}, // END mark
+	static const struct ata_err_sense sense_table[] = {
+		{
+			/* BBD|ECC|ID|MAR - Device busy */
+			0xd1,
+			ABORTED_COMMAND,
+			NO_ADDITIONAL_SENSE_INFORMATION
+		},
+		{
+			/* BBD|ECC|ID - Device busy */
+			0xd0,
+			ABORTED_COMMAND,
+			NO_ADDITIONAL_SENSE_INFORMATION
+		},
+		{
+			/* ECC|MC|MARK - Device fault */
+			0x61,
+			HARDWARE_ERROR,
+			NO_ADDITIONAL_SENSE_INFORMATION
+		},
+		{
+			/* ICRC|ABRT - Data CRC error */
+			/* NB: ICRC & !ABRT is BBD */
+			0x84,
+			ABORTED_COMMAND,
+			SCSI_PARITY_ERROR
+		},
+		{
+			/* MC|ID|ABRT|TRK0|MARK - Unit offline */
+			0x37,
+			NOT_READY,
+			LU_NOT_READY
+		},
+		{
+			/* MCR|MARK - Unrecovered disk error */
+			0x09,
+			NOT_READY,
+			LU_NOT_READY
+		},
+		{
+			/* Bad address mark */
+			0x01,
+			MEDIUM_ERROR,
+			ADDRESS_MARK_NOT_FOUND_FOR_DATA_FIELD
+		},
+		{
+			/* TRK0 - Track 0 not found */
+			0x02,
+			HARDWARE_ERROR,
+			NO_ADDITIONAL_SENSE_INFORMATION
+		},
+		{
+			/* Abort: 0x04 is not translated here, see below */
+			/* Media change request */
+			0x08,
+			NOT_READY,
+			LU_NOT_READY
+		},
+		{
+			/* SRV/IDNF - ID not found */
+			0x10,
+			ILLEGAL_REQUEST,
+			LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE
+		},
+		{
+			/* MC - Media Changed */
+			0x20,
+			UNIT_ATTENTION,
+			NOT_READY_TO_READY_CHANGE_MEDIUM_MAY_HAVE_CHANGED
+		},
+		{
+			/* ECC - Uncorrectable ECC error */
+			0x40,
+			MEDIUM_ERROR,
+			UNRECOVERED_READ_ERROR_AUTO_REALLOCATE_FAILED
+		},
+		{
+			/* BBD - block marked bad */
+			0x80,
+			MEDIUM_ERROR,
+			UNRECOVERED_READ_ERROR_AUTO_REALLOCATE_FAILED
+		},
+		{
+			/* END mark */
+			0xFF, 0xFF, 0xFFFF
+		},
 	};
-	static const unsigned char stat_table[][4] = {
-		/* Busy: must be first because BUSY means no other bits valid */
-		{ ATA_BUSY,	ABORTED_COMMAND, 0x00, 0x00 },
-		/* Device fault: INTERNAL TARGET FAILURE */
-		{ ATA_DF,	HARDWARE_ERROR,  0x44, 0x00 },
-		/* Corrected data error */
-		{ ATA_CORR,	RECOVERED_ERROR, 0x00, 0x00 },
-
-		{ 0xFF, 0xFF, 0xFF, 0xFF }, /* END mark */
+	static const struct ata_err_sense stat_table[] = {
+		{
+			/*
+			 * Busy: must be first because BUSY means no other bits
+			 * valid.
+			 */
+			ATA_BUSY,
+			ABORTED_COMMAND,
+			NO_ADDITIONAL_SENSE_INFORMATION
+		},
+		{
+			/* Device fault */
+			ATA_DF,
+			HARDWARE_ERROR,
+			INTERNAL_TARGET_FAILURE
+		},
+		{
+			/* Corrected data error */
+			ATA_CORR,
+			RECOVERED_ERROR,
+			NO_ADDITIONAL_SENSE_INFORMATION
+		},
+		{
+			/* END mark */
+			0xFF, 0xFF, 0xFFFF
+		},
 	};
 
 	/*
@@ -876,13 +938,12 @@ static void ata_to_sense_error(u8 drv_stat, u8 drv_err, u8 *sk, u8 *asc,
 
 	if (drv_err) {
 		/* Look for drv_err */
-		for (i = 0; sense_table[i][0] != 0xFF; i++) {
+		for (i = 0; sense_table[i].err_mask != 0xFF; i++) {
 			/* Look for best matches first */
-			if ((sense_table[i][0] & drv_err) ==
-			    sense_table[i][0]) {
-				*sk = sense_table[i][1];
-				*asc = sense_table[i][2];
-				*ascq = sense_table[i][3];
+			if ((sense_table[i].err_mask & drv_err) ==
+			    sense_table[i].err_mask) {
+				*sk = sense_table[i].sense_key;
+				*scode = sense_table[i].sense_code;
 				return;
 			}
 		}
@@ -893,11 +954,10 @@ static void ata_to_sense_error(u8 drv_stat, u8 drv_err, u8 *sk, u8 *asc,
 	 * has only the ABRT bit set, we decode drv_stat.  ABRT by itself
 	 * is not descriptive enough.
 	 */
-	for (i = 0; stat_table[i][0] != 0xFF; i++) {
-		if (stat_table[i][0] & drv_stat) {
-			*sk = stat_table[i][1];
-			*asc = stat_table[i][2];
-			*ascq = stat_table[i][3];
+	for (i = 0; stat_table[i].err_mask != 0xFF; i++) {
+		if (stat_table[i].err_mask & drv_stat) {
+			*sk = stat_table[i].sense_key;
+			*scode = stat_table[i].sense_code;
 			return;
 		}
 	}
@@ -907,8 +967,7 @@ static void ata_to_sense_error(u8 drv_stat, u8 drv_err, u8 *sk, u8 *asc,
 	 * that won't cause people to do things like return a disk wrongly.
 	 */
 	*sk = ABORTED_COMMAND;
-	*asc = 0x00;
-	*ascq = 0x00;
+	*scode = NO_ADDITIONAL_SENSE_INFORMATION;
 }
 
 /*
@@ -931,40 +990,41 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 	struct ata_device *dev = qc->dev;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->result_tf;
-	u8 sense_key, asc, ascq;
+	u16 sense_code;
+	u8 sense_key;
 
 	if (!(qc->flags & ATA_QCFLAG_RTF_FILLED)) {
 		ata_dev_dbg(dev,
 			    "missing result TF: can't generate ATA PT sense data\n");
 		if (qc->err_mask)
-			ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
+			ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND,
+					   NO_ADDITIONAL_SENSE_INFORMATION);
 		return;
 	}
 
 	/*
-	 * Use ata_to_sense_error() to map status register bits
-	 * onto sense key, asc & ascq.
+	 * Use ata_to_sense_error() to map status register bits onto sense key
+	 * and sense code.
 	 */
 	if (qc->err_mask ||
 	    tf->status & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
 		ata_to_sense_error(tf->status, tf->error,
-				   &sense_key, &asc, &ascq);
-		ata_scsi_set_sense(qc->dev, cmd, sense_key, asc, ascq);
-	} else {
-		/*
-		 * ATA PASS-THROUGH INFORMATION AVAILABLE
-		 *
-		 * Note: we are supposed to call ata_scsi_set_sense(), which
-		 * respects the D_SENSE bit, instead of unconditionally
-		 * generating the sense data in descriptor format. However,
-		 * because hdparm, hddtemp, and udisks incorrectly assume sense
-		 * data in descriptor format, without even looking at the
-		 * RESPONSE CODE field in the returned sense data (to see which
-		 * format the returned sense data is in), we are stuck with
-		 * being bug compatible with older kernels.
-		 */
-		scsi_build_sense(cmd, 1, RECOVERED_ERROR, 0, 0x1D);
+				   &sense_key, &sense_code);
+		ata_scsi_set_sense(qc->dev, cmd, sense_key, sense_code);
+		return;
 	}
+
+	/*
+	 * Note: we are supposed to call ata_scsi_set_sense(), which respects
+	 * the D_SENSE bit, instead of unconditionally generating the sense data
+	 * in descriptor format. However, because hdparm, hddtemp, and udisks
+	 * incorrectly assume sense data in descriptor format, without even
+	 * looking at the RESPONSE CODE field in the returned sense data (to see
+	 * which format the returned sense data is in), we are stuck with being
+	 * bug compatible with older kernels.
+	 */
+	scsi_set_sense(cmd, 1, RECOVERED_ERROR,
+		       ATA_PASS_THROUGH_INFORMATION_AVAILABLE);
 }
 
 /**
@@ -981,19 +1041,18 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	struct ata_device *dev = qc->dev;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->result_tf;
-	u8 sense_key, asc, ascq;
 
 	if (ata_dev_disabled(dev)) {
 		/* Device disabled after error recovery */
-		/* LOGICAL UNIT NOT READY, HARD RESET REQUIRED */
-		ata_scsi_set_sense(dev, cmd, NOT_READY, 0x04, 0x21);
+		ata_scsi_set_sense(dev, cmd, NOT_READY,
+				   LU_NOT_READY_HARD_RESET_REQUIRED);
 		return;
 	}
 
 	if (ata_id_is_locked(dev->id)) {
 		/* Security locked */
-		/* LOGICAL UNIT ACCESS NOT AUTHORIZED */
-		ata_scsi_set_sense(dev, cmd, DATA_PROTECT, 0x74, 0x71);
+		ata_scsi_set_sense(dev, cmd, DATA_PROTECT,
+				   LU_ACCESS_NOT_AUTHORIZED);
 		return;
 	}
 
@@ -1008,9 +1067,12 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	 */
 	if (qc->err_mask ||
 	    tf->status & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
+		u16 sense_code;
+		u8 sense_key;
+
 		ata_to_sense_error(tf->status, tf->error,
-				   &sense_key, &asc, &ascq);
-		ata_scsi_set_sense(dev, cmd, sense_key, asc, ascq);
+				   &sense_key, &sense_code);
+		ata_scsi_set_sense(dev, cmd, sense_key, sense_code);
 		return;
 	}
 
@@ -1019,7 +1081,8 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 		"Could not decode error 0x%x, status 0x%x (err_mask=0x%x)\n",
 		tf->error, tf->status, qc->err_mask);
 aborted:
-	ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
+	ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND,
+			   NO_ADDITIONAL_SENSE_INFORMATION);
 }
 
 void ata_scsi_sdev_config(struct scsi_device *sdev)
@@ -1273,7 +1336,8 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 
 	/* Ignore IMMED bit (cdb[1] & 0x1), violates sat-r05 */
 	if (!ata_dev_power_init_tf(qc->dev, &qc->tf, cdb[4] & 0x1)) {
-		ata_scsi_set_sense(qc->dev, scmd, ABORTED_COMMAND, 0, 0);
+		ata_scsi_set_sense(qc->dev, scmd, ABORTED_COMMAND,
+				   NO_ADDITIONAL_SENSE_INFORMATION);
 		return 1;
 	}
 
@@ -1501,8 +1565,8 @@ static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc)
 	return 1;
 
 out_of_range:
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x21, 0x0);
-	/* "Logical Block Address out of range" */
+	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST,
+			   LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE);
 	return 1;
 
 nothing_to_do:
@@ -1638,8 +1702,8 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 	return 1;
 
 out_of_range:
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x21, 0x0);
-	/* "Logical Block Address out of range" */
+	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST,
+			   LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE);
 	return 1;
 
 nothing_to_do:
@@ -2015,7 +2079,8 @@ static void ata_scsi_rbuf_fill(struct ata_device *dev, struct scsi_cmnd *cmd,
 	len = actor(dev, cmd, ata_scsi_rbuf);
 	if (len) {
 		if (WARN_ON(len > ATA_SCSI_RBUF_SIZE)) {
-			ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
+			ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND,
+					   NO_ADDITIONAL_SENSE_INFORMATION);
 			spin_unlock_irqrestore(&ata_scsi_rbuf_lock, flags);
 			return;
 		}
@@ -2894,8 +2959,8 @@ static unsigned int ata_scsiop_mode_sense(struct ata_device *dev,
 	return 0;
 
 saving_not_supp:
-	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x39, 0x0);
-	 /* "Saving parameters not supported" */
+	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST,
+			   SAVING_PARAMETERS_NOT_SUPPORTED);
 	return 0;
 }
 
@@ -3732,12 +3797,12 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	ata_scsi_set_invalid_field(dev, scmd, fp, bp);
 	return 1;
 invalid_param_len:
-	/* "Parameter list length error" */
-	ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST,
+			   PARAMETER_LIST_LENGTH_ERROR);
 	return 1;
 invalid_opcode:
-	/* "Invalid command operation code" */
-	ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+	ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST,
+			   INVALID_COMMAND_OP_CODE);
 	return 1;
 }
 
@@ -4199,8 +4264,8 @@ static unsigned int ata_scsi_zbc_in_xlat(struct ata_queued_cmd *qc)
 	return 1;
 
 invalid_param_len:
-	/* "Parameter list length error" */
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST,
+			   PARAMETER_LIST_LENGTH_ERROR);
 	return 1;
 }
 
@@ -4277,8 +4342,8 @@ static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc)
 	ata_scsi_set_invalid_field(qc->dev, scmd, fp, 0xff);
 	return 1;
 invalid_param_len:
-	/* "Parameter list length error" */
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST,
+			   PARAMETER_LIST_LENGTH_ERROR);
 	return 1;
 }
 
@@ -4629,8 +4694,8 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	return 1;
 
  invalid_param_len:
-	/* "Parameter list length error" */
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST,
+			   PARAMETER_LIST_LENGTH_ERROR);
 	return 1;
 
  skip:
@@ -4789,7 +4854,8 @@ ata_scsi_get_phys_element_status_xlat(struct ata_queued_cmd *qc)
 
 	/* ATA_CMD_GET_PHYS_ELEMENT_STATUS is a DMA command. */
 	if (!(dev->flags & ATA_DFLAG_DEPOP) || !ata_dma_enabled(dev)) {
-		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST,
+				   INVALID_COMMAND_OP_CODE);
 		return 1;
 	}
 
@@ -4841,7 +4907,7 @@ static void ata_scsi_depop_ua_cap_changed_complete(struct ata_queued_cmd *qc)
 	 */
 	if (is_success && !is_ata_passthru)
 		ata_scsi_set_sense(qc->dev, scmd, UNIT_ATTENTION,
-				   UA_CHANGED_ASC, CAPACITY_CHANGED_ASCQ);
+				   CAPACITY_DATA_HAS_CHANGED);
 	ata_scsi_qc_complete(qc);
 }
 
@@ -4856,7 +4922,8 @@ ata_scsi_remove_element_and_truncate_xlat(struct ata_queued_cmd *qc)
 	u32 id;
 
 	if (!(dev->flags & ATA_DFLAG_DEPOP)) {
-		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST,
+				   INVALID_COMMAND_OP_CODE);
 		return 1;
 	}
 
@@ -4899,7 +4966,8 @@ ata_scsi_remove_element_and_modify_zones_xlat(struct ata_queued_cmd *qc)
 	u32 id;
 
 	if (!(dev->flags & ATA_DFLAG_DEPOP_MODIFY)) {
-		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST,
+				   INVALID_COMMAND_OP_CODE);
 		return 1;
 	}
 
@@ -4927,7 +4995,8 @@ ata_scsi_restore_elements_and_rebuild_xlat(struct ata_queued_cmd *qc)
 	struct ata_taskfile *tf = &qc->tf;
 
 	if (!(dev->flags & ATA_DFLAG_DEPOP_RESTORE)) {
-		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST,
+				   INVALID_COMMAND_OP_CODE);
 		return 1;
 	}
 
@@ -5088,7 +5157,8 @@ static void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 		break;
 
 	case REQUEST_SENSE:
-		ata_scsi_set_sense(dev, cmd, 0, 0, 0);
+		ata_scsi_set_sense(dev, cmd, NO_SENSE,
+				   NO_ADDITIONAL_SENSE_INFORMATION);
 		break;
 
 	/* if we reach this, then writeback caching is disabled,
@@ -5117,8 +5187,8 @@ static void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 
 	/* all other commands */
 	default:
-		ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x20, 0x0);
-		/* "Invalid command operation code" */
+		ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST,
+				   INVALID_COMMAND_OP_CODE);
 		break;
 	}
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 48274691cd0e..d222a2c92efc 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -164,9 +164,10 @@ extern int ata_scsi_add_hosts(struct ata_host *host,
 			      const struct scsi_host_template *sht);
 extern void ata_scsi_scan_host(struct ata_port *ap, int sync);
 extern bool ata_scsi_offline_dev(struct ata_device *dev);
-extern bool ata_scsi_sense_is_valid(u8 sk, u8 asc, u8 ascq);
+extern bool ata_scsi_sense_is_valid(u8 sense_key, u16 sense_code);
 extern void ata_scsi_set_sense(struct ata_device *dev,
-			       struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq);
+			       struct scsi_cmnd *cmd, u8 sense_key,
+			       u16 sense_code);
 extern void ata_scsi_media_change_notify(struct ata_device *dev);
 extern void ata_scsi_hotplug(struct work_struct *work);
 extern void ata_scsi_dev_rescan(struct work_struct *work);
-- 
2.55.0

