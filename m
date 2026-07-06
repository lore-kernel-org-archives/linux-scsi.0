Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197673E9F8E;
	Mon,  6 Jul 2026 06:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320996; cv=none; b=uxliOxcYa3FYyUm98fxM+UEfFuenxThqzJWGQ2WtZZ4JxFciYf8QdSNWWX+mwmTWWtDeEx2W8lTt58c11sdVCvVLUquyCr9FeKpuvdf9+d4z8nb52P5Rcq6e8goYG9cTQVnA6IGPbsd64iApzdU0IEWp5T2ivYfR+ktYsBUibOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320996; c=relaxed/simple;
	bh=rfGuT7AG1KxFetBvQLhDhIkn2IGG4QdcualXD9unWWw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jq4lAljR6soZLAzvlYs9jvPgQtE8Yn0Ar32D62K5kj8IEJYdeTmU9LGu5S2hQA+reYKOyszzLS2rCB/3s+6ugcy/1oEJSIWvleYAJSaNnS/ffBzJ8ve9fiFYqwQ7MtkwamI3OXRmcqKTOc7iNNs7btuqGvupLLg/ZGi5JiTaN+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nKvKRpQp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nKvKRpQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854781F00ADB;
	Mon,  6 Jul 2026 06:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320987;
	bh=w5H/fngHdOMAY71nrW/XpOi948LecNYQ5eO4dlo0YlU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=nKvKRpQpM2Mn0L7MNfo1cSXqq0JsxUwDSDnvA2OiMdVj6M82hCkot/jZLt7HQyNwz
	 P9D8Hoz0+B8X7flT3LxWqmIAJv9UdjArJnTJQxfnFOXyHMA+sxIHrcJetqIOQfPcEi
	 0bpAq6QxdTBkTyEgACTxkLCqg8CEKIej9bgYRvw2V/A5Rjg0TmvNqrec1Tu+Irtjcf
	 41MStZ/pr++uNaB8xjnZZd37PjYPcG3RvXBKDFo+xDII0LbuH6UjCJp/g/g++zQ4R5
	 1een3KFitFHIJ6fWnsQm4+dHaedDQo72T0xO7cg+3/Cof811irwbqXgJo6srDKnc5M
	 HR9ZMZZzGO/Tg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v1 7/9] ata: libata-scsi: add support for the REMOVE ELEMENT AND TRUNCATE command
Date: Mon,  6 Jul 2026 15:56:08 +0900
Message-ID: <20260706065610.3559692-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706065610.3559692-1-dlemoal@kernel.org>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define the translation for the REMOVE ELEMENT AND TRUNCATE command
(SERVICE ACTION IN command with service action
SAI_REMOVE_ELEMENT_AND_TRUNCATE) into the ATA command
ATA_CMD_REMOVE_ELEMENT_AND_TRUNCATE with the new function
ata_scsi_remove_element_and_truncate_xlat()

The array of supported commands ata_supported_cmds is modified to add a
new entry for this command. ata_scsi_cmd_is_supported() is also modify to
correctly handle this new entry depending on the target device flag
ATA_DFLAG_DEPOP being set.

The ATA command completion is handled using the function
ata_scsi_depop_ua_cap_changed_complete() so that on a successful
completion, a UNIT ATTENTION with the additional sense code set to
CAPACITY DATA HAS CHANGED is raised.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c | 73 +++++++++++++++++++++++++++++++++++++++
 include/linux/ata.h       |  1 +
 2 files changed, 74 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8723faa96c48..49beefa46cf3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3729,6 +3729,11 @@ static const struct ata_scsi_cmd ata_supported_cmds[] = {
 		.sa_valid = true,
 		.sa = SAI_GET_PHYSICAL_ELEMENT_STATUS
 	},
+	{
+		.op = SERVICE_ACTION_IN_16,	.cdb_len = 16,
+		.sa_valid = true,
+		.sa = SAI_REMOVE_ELEMENT_AND_TRUNCATE
+	},
 	{	.op = REPORT_LUNS,		.cdb_len = 12	},
 	{	.op = ATA_12,			.cdb_len = 12	},
 	{	.op = SECURITY_PROTOCOL_IN,	.cdb_len = 12	},
@@ -3812,6 +3817,7 @@ static bool ata_scsi_cmd_is_supported(struct ata_device *dev, u8 op, u16 sa,
 	case SERVICE_ACTION_IN_16:
 		switch (sa) {
 		case SAI_GET_PHYSICAL_ELEMENT_STATUS:
+		case SAI_REMOVE_ELEMENT_AND_TRUNCATE:
 			return dev->flags & ATA_DFLAG_DEPOP;
 		default:
 			return true;
@@ -4708,6 +4714,71 @@ ata_scsi_get_phys_element_status_xlat(struct ata_queued_cmd *qc)
 	return 0;
 }
 
+static void ata_scsi_depop_ua_cap_changed_complete(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	u8 *cdb = scmd->cmnd;
+	bool is_ata_passthru = cdb[0] == ATA_16 || cdb[0] == ATA_12;
+	bool is_success = qc->err_mask == 0;
+
+	/*
+	 * For successful non-passthrough commands, raise a UNIT ATTENTION with
+	 * the additional sense code set to CAPACITY DATA HAS CHANGED to be
+	 * raised. Note that this should be done only if the capacity has
+	 * actually changed, which may not be the case if the element that was
+	 * specified for depopulation was already depopulated. But a capacity
+	 * change unit attention is harmless, so always raise the unit attention.
+	 */
+	if (is_success && !is_ata_passthru)
+		ata_scsi_set_sense(qc->dev, scmd, UNIT_ATTENTION,
+				   UA_CHANGED_ASC, CAPACITY_CHANGED_ASCQ);
+	ata_scsi_qc_complete(qc);
+}
+
+static unsigned int
+ata_scsi_remove_element_and_truncate_xlat(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	const u8 *cdb = scmd->cmnd;
+	struct ata_device *dev = qc->dev;
+	struct ata_taskfile *tf = &qc->tf;
+	u64 req_capacity;
+	u32 id;
+
+	if (!(dev->flags & ATA_DFLAG_DEPOP)) {
+		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		return 1;
+	}
+
+	req_capacity = get_unaligned_be64(&cdb[2]);
+	if (req_capacity == 1) {
+		ata_scsi_set_invalid_field(dev, scmd, 2, 0);
+		return 1;
+	}
+
+	id = get_unaligned_be32(&cdb[10]);
+
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_REMOVE_ELEMENT_AND_TRUNCATE;
+	tf->hob_feature = (id >> 24) & 0xff;
+	tf->feature = (id >> 16) & 0xff;
+	tf->hob_nsect = (id >> 8) & 0xff;
+	tf->nsect = id & 0xff;
+	tf->hob_lbah = (req_capacity >> 40) & 0xff;
+	tf->hob_lbam = (req_capacity >> 32) & 0xff;
+	tf->hob_lbal = (req_capacity >> 24) & 0xff;
+	tf->lbah = (req_capacity >> 16) & 0xff;
+	tf->lbam = (req_capacity >> 8) & 0xff;
+	tf->lbal = req_capacity & 0xff;
+	tf->device = ATA_LBA;
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48;
+
+	qc->flags |= ATA_QCFLAG_RESULT_TF;
+	qc->complete_fn = ata_scsi_depop_ua_cap_changed_complete;
+
+	return 0;
+}
+
 /**
  *	ata_scsi_var_len_cdb_xlat - SATL variable length CDB to Handler
  *	@qc: Command to be translated
@@ -4791,6 +4862,8 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev,
 		sa = cdb[1] & 0x1f;
 		if (sa == SAI_GET_PHYSICAL_ELEMENT_STATUS)
 			return ata_scsi_get_phys_element_status_xlat;
+		if (sa == SAI_REMOVE_ELEMENT_AND_TRUNCATE)
+			return ata_scsi_remove_element_and_truncate_xlat;
 		break;
 
 	case ZBC_IN:
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 8b726d9bdda3..89ac27743f50 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -290,6 +290,7 @@ enum {
 	ATA_CMD_ZAC_MGMT_IN	= 0x4A,
 	ATA_CMD_ZAC_MGMT_OUT	= 0x9F,
 	ATA_CMD_GET_PHYS_ELEMENT_STATUS = 0x12,
+	ATA_CMD_REMOVE_ELEMENT_AND_TRUNCATE = 0x7c,
 
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
-- 
2.54.0

