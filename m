Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E9D4CA282;
	Mon,  6 Jul 2026 06:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783321003; cv=none; b=IJXQSpbVuNCBaFihNLlVcrDJDL0mvu3BagUcVE9u58vZTQVwHz+3T4TQMYJd4F0zlYFY/6+6mjoX9+tYahYsDsfHCMRZQOxv3F0k/zMMVhzza71vUKYYK2Gz34WtbZrHoUxXWqzXSvHHMpBcpwUjSoX4Uo9rIhAF2wwfVKuDArI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783321003; c=relaxed/simple;
	bh=q3NagBjZ2BMZQ8Efx+XhLnhwo8huYTNZHzXNhvpAy94=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sByLzjQJctFJWmJ0q/34hxQwqcxko5jMpeZaiztVCC9ku0YIX/f3qZxxaQV+vLOKRThvbqdeDYi742NNjfLh1t/pfhcjSEWvbq7OTDSB9G5vfvIp+uQpoC9BOjciJHWOV783ESgpmDfbQjIeeRZ2Kb4CdU8fAgdS0xbyx5xkCnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6ZgiC8T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6ZgiC8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4814D1F00ADE;
	Mon,  6 Jul 2026 06:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320987;
	bh=kKxGAdAgDUEOT+Gwyexr31vCEFngF+8EjSBaZqxxtH8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=i6ZgiC8T+y6ffqHLgerXVqo6sjNgbk8Bun0OvT16aThRVCnproi6zTjood9p4kX/q
	 pFZQ5NjnmRQdTxbuDy9OoiS1GOPmE8oZCir/NhV+zcCnkJlevJClbyvY3CKRGhcm6g
	 VOgsYn9FDwdrRWxYCia1nmMtbNFuSeCTf9eWCV8gtIxjiVQkLjblzVnUODtx94fL08
	 5rc3A/Ktlp/Ghb5JwkvdjdIkXOEI+SZAddowetqqVfgDyoyuV/4SfStOoo6ypX0jga
	 29SzWcYf8HzYqpbQmCOaxJtZLpOTu9iFmBldGaUDSnN6onwDUM/QR/1J+uHq5IVyO/
	 wvRMN+p4RLveg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v1 8/9] ata: libata-scsi: add support for the RESTORE ELEMENTS AND REBUILD command
Date: Mon,  6 Jul 2026 15:56:09 +0900
Message-ID: <20260706065610.3559692-9-dlemoal@kernel.org>
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

Define the translation for the RESTORE ELEMENTS AND REBUILD command
(SERVICE ACTION IN command with service action
SAI_RESTORE_ELEMENTS_AND_REBUILD) into the ATA command
ATA_CMD_RESTORE_ELEMENTS_AND_REBUILD with the new function
ata_scsi_restore_elements_and_rebuild_xlat()

The array of supported commands ata_supported_cmds is modified to add a
new entry for this command. ata_scsi_cmd_is_supported() is also modify to
correctly handle this new entry depending on the target device flag
ATA_DFLAG_DEPOP_RESTORE being set.

The ATA command completion is handled using the function
ata_scsi_depop_ua_cap_changed_complete() so that on a successful
completion, a UNIT ATTENTION with the additional sense code set to
CAPACITY DATA HAS CHANGED is raised.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c | 37 +++++++++++++++++++++++++++++++++++--
 include/linux/ata.h       |  1 +
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 49beefa46cf3..5bdf54a9e9b1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3734,6 +3734,11 @@ static const struct ata_scsi_cmd ata_supported_cmds[] = {
 		.sa_valid = true,
 		.sa = SAI_REMOVE_ELEMENT_AND_TRUNCATE
 	},
+	{
+		.op = SERVICE_ACTION_IN_16,	.cdb_len = 16,
+		.sa_valid = true,
+		.sa = SAI_RESTORE_ELEMENTS_AND_REBUILD
+	},
 	{	.op = REPORT_LUNS,		.cdb_len = 12	},
 	{	.op = ATA_12,			.cdb_len = 12	},
 	{	.op = SECURITY_PROTOCOL_IN,	.cdb_len = 12	},
@@ -3819,6 +3824,8 @@ static bool ata_scsi_cmd_is_supported(struct ata_device *dev, u8 op, u16 sa,
 		case SAI_GET_PHYSICAL_ELEMENT_STATUS:
 		case SAI_REMOVE_ELEMENT_AND_TRUNCATE:
 			return dev->flags & ATA_DFLAG_DEPOP;
+		case SAI_RESTORE_ELEMENTS_AND_REBUILD:
+			return dev->flags & ATA_DFLAG_DEPOP_RESTORE;
 		default:
 			return true;
 		}
@@ -4726,8 +4733,9 @@ static void ata_scsi_depop_ua_cap_changed_complete(struct ata_queued_cmd *qc)
 	 * the additional sense code set to CAPACITY DATA HAS CHANGED to be
 	 * raised. Note that this should be done only if the capacity has
 	 * actually changed, which may not be the case if the element that was
-	 * specified for depopulation was already depopulated. But a capacity
-	 * change unit attention is harmless, so always raise the unit attention.
+	 * specified for depopulation was already depopulated, or we did not
+	 * restore any removed element. But a capacity change unit attention is
+	 * harmless, so always raise the unit attention.
 	 */
 	if (is_success && !is_ata_passthru)
 		ata_scsi_set_sense(qc->dev, scmd, UNIT_ATTENTION,
@@ -4779,6 +4787,29 @@ ata_scsi_remove_element_and_truncate_xlat(struct ata_queued_cmd *qc)
 	return 0;
 }
 
+static unsigned int
+ata_scsi_restore_elements_and_rebuild_xlat(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	struct ata_device *dev = qc->dev;
+	struct ata_taskfile *tf = &qc->tf;
+
+	if (!(dev->flags & ATA_DFLAG_DEPOP_RESTORE)) {
+		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		return 1;
+	}
+
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_RESTORE_ELEMENTS_AND_REBUILD;
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
@@ -4864,6 +4895,8 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev,
 			return ata_scsi_get_phys_element_status_xlat;
 		if (sa == SAI_REMOVE_ELEMENT_AND_TRUNCATE)
 			return ata_scsi_remove_element_and_truncate_xlat;
+		if (sa == SAI_RESTORE_ELEMENTS_AND_REBUILD)
+			return ata_scsi_restore_elements_and_rebuild_xlat;
 		break;
 
 	case ZBC_IN:
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 89ac27743f50..a1cd68cfb44f 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -291,6 +291,7 @@ enum {
 	ATA_CMD_ZAC_MGMT_OUT	= 0x9F,
 	ATA_CMD_GET_PHYS_ELEMENT_STATUS = 0x12,
 	ATA_CMD_REMOVE_ELEMENT_AND_TRUNCATE = 0x7c,
+	ATA_CMD_RESTORE_ELEMENTS_AND_REBUILD = 0x7d,
 
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
-- 
2.54.0

