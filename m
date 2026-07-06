Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAECF3EB81A;
	Mon,  6 Jul 2026 06:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783321004; cv=none; b=kBDO6hJAeR++nxZ1KFrR/61zagl/DrziORzsyNZTpr4luY5CKECnXfb9ne7jOfCGhh8YMWDEluq99Xrpj1Wftolx7MP30hJQ3fLbUtGnSSLbbXGs929wj5FbN0KO5H5dwIOeMIejGGkAnQGPOzCXf4BKbBB6J5UrOO8887JElSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783321004; c=relaxed/simple;
	bh=klgTrJH9GlpJ6paJIe7/ChG9BSMIm9XZgLVyvLRgu8U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTCaCLDeZpieSJ05Uma8OZI0cTXDMooC+r0C66qXAh/McLQVBHdIU0m991GV5dWtmXWt1UTEYyIfiPzN8o3/yoA/goGFK2KzGnx2V8JbAt7NSVyYQR7Pwsk5tBS0U6TKPOyeSEGoCr4pApXEQA7f/ZCJbxWdJcHsQpRGK/m3uKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZEVhHVmi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEVhHVmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A06D1F01559;
	Mon,  6 Jul 2026 06:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320988;
	bh=QyuwRXJW6wxjnAsOKfyWiPGiPGU8LlapAbhb3R5HxJk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ZEVhHVmiMgK3PxfiICbWMSBLzAttj+6x4gHc7hdGz7yYlA9qEJVL8r2Q4lE73DyOl
	 taWc6QPft4vW3nTo+99KE4+hguoxDJQPQdBaZD1zllL7wMKmiWkvrxs5TYQnMQIBKI
	 yZ2DFyfj8MXGy62i/ZJgtomOyQoiB+dAn9C+NcUdRk399o0oz9LBjwUPYpYgK3fHy6
	 3c7DTSdYGHtZOzi7yjTh32zk4zMEZfPdXdXmn9D5OvheRxJLWmLRRg8Sl6bpejlXcM
	 DYPkuahJXXSaiYMncyb9fTKrxaWNLCwPyaI0enHcmp0w5ixOsmvTYf/Uxc5dhwc9lo
	 ZyU4wGuTus5Yg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v1 9/9] ata: libata-scsi: add support for the REMOVE ELEMENT AND MODIFY ZONES command
Date: Mon,  6 Jul 2026 15:56:10 +0900
Message-ID: <20260706065610.3559692-10-dlemoal@kernel.org>
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

Define the translation for the REMOVE ELEMENT AND MODIFY ZONES command
(SERVICE ACTION IN command with service action
SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES) into the ATA command
ATA_CMD_REMOVE_ELEMENT_AND_MODIFY_ZONES with the new function
ata_scsi_remove_element_and_modify_zones_xlat()

The array of supported commands ata_supported_cmds is modified to add a
new entry for this command. ata_scsi_cmd_is_supported() is also modify to
correctly handle this new entry depending on the target device flag
ATA_DFLAG_DEPOP being set, and the target device being a ZAC zoned device.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/ata.h       |  1 +
 2 files changed, 40 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5bdf54a9e9b1..1d225ee9eb86 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3739,6 +3739,11 @@ static const struct ata_scsi_cmd ata_supported_cmds[] = {
 		.sa_valid = true,
 		.sa = SAI_RESTORE_ELEMENTS_AND_REBUILD
 	},
+	{
+		.op = SERVICE_ACTION_IN_16,	.cdb_len = 16,
+		.sa_valid = true,
+		.sa = SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES
+	},
 	{	.op = REPORT_LUNS,		.cdb_len = 12	},
 	{	.op = ATA_12,			.cdb_len = 12	},
 	{	.op = SECURITY_PROTOCOL_IN,	.cdb_len = 12	},
@@ -3826,6 +3831,8 @@ static bool ata_scsi_cmd_is_supported(struct ata_device *dev, u8 op, u16 sa,
 			return dev->flags & ATA_DFLAG_DEPOP;
 		case SAI_RESTORE_ELEMENTS_AND_REBUILD:
 			return dev->flags & ATA_DFLAG_DEPOP_RESTORE;
+		case SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES:
+			return dev->flags & ATA_DFLAG_DEPOP_MODIFY;
 		default:
 			return true;
 		}
@@ -4787,6 +4794,36 @@ ata_scsi_remove_element_and_truncate_xlat(struct ata_queued_cmd *qc)
 	return 0;
 }
 
+static unsigned int
+ata_scsi_remove_element_and_modify_zones_xlat(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	const u8 *cdb = scmd->cmnd;
+	struct ata_device *dev = qc->dev;
+	struct ata_taskfile *tf = &qc->tf;
+	u32 id;
+
+	if (!(dev->flags & ATA_DFLAG_DEPOP_MODIFY)) {
+		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		return 1;
+	}
+
+	id = get_unaligned_be32(&cdb[10]);
+
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_REMOVE_ELEMENT_AND_MODIFY_ZONES;
+	tf->hob_feature = (id >> 24) & 0xff;
+	tf->feature = (id >> 16) & 0xff;
+	tf->hob_nsect = (id >> 8) & 0xff;
+	tf->nsect = id & 0xff;
+	tf->device = ATA_LBA;
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48;
+
+	qc->flags |= ATA_QCFLAG_RESULT_TF;
+
+	return 0;
+}
+
 static unsigned int
 ata_scsi_restore_elements_and_rebuild_xlat(struct ata_queued_cmd *qc)
 {
@@ -4895,6 +4932,8 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev,
 			return ata_scsi_get_phys_element_status_xlat;
 		if (sa == SAI_REMOVE_ELEMENT_AND_TRUNCATE)
 			return ata_scsi_remove_element_and_truncate_xlat;
+		if (sa == SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES)
+			return ata_scsi_remove_element_and_modify_zones_xlat;
 		if (sa == SAI_RESTORE_ELEMENTS_AND_REBUILD)
 			return ata_scsi_restore_elements_and_rebuild_xlat;
 		break;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index a1cd68cfb44f..fc21a2417b25 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -292,6 +292,7 @@ enum {
 	ATA_CMD_GET_PHYS_ELEMENT_STATUS = 0x12,
 	ATA_CMD_REMOVE_ELEMENT_AND_TRUNCATE = 0x7c,
 	ATA_CMD_RESTORE_ELEMENTS_AND_REBUILD = 0x7d,
+	ATA_CMD_REMOVE_ELEMENT_AND_MODIFY_ZONES = 0x7e,
 
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
-- 
2.54.0

