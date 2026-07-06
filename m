Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182EF3E5574;
	Mon,  6 Jul 2026 06:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320996; cv=none; b=A63hdgQ3neXpejkutFAmqC/FzFCNr3y3hybG0i0Cognn9rvW+/n1kE3k4MiK+qtE7q4C59+ia2qzwqSsHd4pG7WtiXsgfFDTarNVRaYz5ZQKiMoldExG0gzlb4ns+x9P/wArSOCuPnYMxTAFsYwxEH7YhYqubqQjDhuvKpalaxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320996; c=relaxed/simple;
	bh=0sij9p+Ol8+SAtyaBsjQe8GegRNJOuzNhDlRIAjGmUg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8wR4apZbuvdOLI7J+9OkfIqdaj1WAaHAyhR6Vio1rla/85Kkp4LD2pNl6O7KCbO4cyic1bshr9D2CPV8hncM20Y/bh7k5xaC/a29m3JWY8CBsfRSoHpeDmJRvRszSIQa5us60/eAR0reGOF+BXyw/IHRMp2DWc1treS1dIJ3YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gy6Ls1b/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gy6Ls1b/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC09B1F00ACA;
	Mon,  6 Jul 2026 06:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320986;
	bh=UikuqFT6V9dcjZ08vSqVthYDrnVILGXUcRj40KuYVoI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=gy6Ls1b/1E7NchvdVRyWJLCOf4skdOBOdSNeX7Mew69FR+6ZuE1lGd7InXkbC6c6C
	 nYh7u+Gd1HTHBsFwdKwjC4pZI6mXPMk9nqVFw/72h0Jq49iVE+0azqtenPU3JcjSfg
	 6XKmpW9ap0p0//D93bHS1gANoDTp9l2ChltJfFhURSFwXSgZzy3ULKFcHasv/98Jeb
	 ot5byQDWDoIRCXAsRbZchsnPEbxZkVfnT2sXidswocfuD0X9lGOI1wGxGHy5e1ZfGw
	 8lt+7qjgLG3yZgW3ONN5fGQllLQY3S8dB+bLkqynkut3uf4iDUK53OesZPdJYKzJj6
	 q7nvqRXrwMfaQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v1 6/9] ata: libata-scsi: add support for the GET PHYSICAL ELEMENT STATUS command
Date: Mon,  6 Jul 2026 15:56:07 +0900
Message-ID: <20260706065610.3559692-7-dlemoal@kernel.org>
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

Define the translation for the GET PHYSICAL ELEMENT STATUS command
(SERVICE ACTION IN command with service action
SAI_GET_PHYSICAL_ELEMENT_STATUS) into the ATA command
ATA_CMD_GET_PHYS_ELEMENT_STATUS with the new function
ata_scsi_get_phys_element_status_xlat(). The reply of this function also
needs translation from little endian to big endian. This is done with the
completion callback ata_scsi_get_phys_element_status_complete().

The array of supported commands ata_supported_cmds is modified to add a
new entry for this command. ata_scsi_cmd_is_supported() is also modified
to correctly handle this new entry depending on the target device flag
ATA_DFLAG_DEPOP being set.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c | 141 ++++++++++++++++++++++++++++++++++++++
 include/linux/ata.h       |   1 +
 2 files changed, 142 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f5c838ca0ce9..8723faa96c48 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3724,6 +3724,11 @@ static const struct ata_scsi_cmd ata_supported_cmds[] = {
 		.sa_valid = true,
 		.sa = SAI_READ_CAPACITY_16
 	},
+	{
+		.op = SERVICE_ACTION_IN_16,	.cdb_len = 16,
+		.sa_valid = true,
+		.sa = SAI_GET_PHYSICAL_ELEMENT_STATUS
+	},
 	{	.op = REPORT_LUNS,		.cdb_len = 12	},
 	{	.op = ATA_12,			.cdb_len = 12	},
 	{	.op = SECURITY_PROTOCOL_IN,	.cdb_len = 12	},
@@ -3804,6 +3809,14 @@ static bool ata_scsi_cmd_is_supported(struct ata_device *dev, u8 op, u16 sa,
 	case ZBC_IN:
 	case ZBC_OUT:
 		return ata_dev_is_zoned(dev);
+	case SERVICE_ACTION_IN_16:
+		switch (sa) {
+		case SAI_GET_PHYSICAL_ELEMENT_STATUS:
+			return dev->flags & ATA_DFLAG_DEPOP;
+		default:
+			return true;
+		}
+		break;
 	case SECURITY_PROTOCOL_IN:
 	case SECURITY_PROTOCOL_OUT:
 		return dev->flags & ATA_DFLAG_TRUSTED;
@@ -4575,6 +4588,126 @@ static unsigned int ata_scsi_security_inout_xlat(struct ata_queued_cmd *qc)
 	return 0;
 }
 
+/*
+ * Convert T-13 little-endian field representation of GET PHYSICAL ELEMENT
+ * STATUS DMA command reply into T-10 big-endian field representation.
+ */
+static void ata_scsi_get_phys_element_status_complete(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	struct sg_mapping_iter miter;
+	unsigned int bytes = 0;
+
+	lockdep_assert_held(qc->ap->lock);
+
+	sg_miter_start(&miter, scsi_sglist(scmd), scsi_sg_count(scmd),
+		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
+
+	while (sg_miter_next(&miter)) {
+		unsigned int offset = 0;
+
+		if (bytes == 0) {
+			u32 num_desc, num_desc_returned, id;
+			u16 max_depop, cur_depop;
+			char *hdr;
+
+			/* Swizzle the header */
+			hdr = miter.addr;
+			num_desc = get_unaligned_le32(&hdr[0]);
+			num_desc_returned = get_unaligned_le32(&hdr[4]);
+			id = get_unaligned_le32(&hdr[8]);
+			max_depop = get_unaligned_le16(&hdr[12]);
+			cur_depop = get_unaligned_le16(&hdr[14]);
+
+			put_unaligned_be32(num_desc, &hdr[0]);
+			put_unaligned_be32(num_desc_returned, &hdr[4]);
+			put_unaligned_be32(id, &hdr[8]);
+			put_unaligned_be16(max_depop, &hdr[12]);
+			put_unaligned_be16(cur_depop, &hdr[14]);
+
+			offset += 32;
+			bytes += 32;
+		}
+
+		/* Swizzle the descriptors. */
+		while (offset < miter.length) {
+			char *desc;
+			u32 id;
+			u8 type;
+
+			desc = miter.addr + offset;
+			id = get_unaligned_le32(&desc[4]);
+			put_unaligned_be32(id, &desc[4]);
+
+			type = desc[14];
+			if (type == SCSI_PHYS_ELEM_TYPE_ALL_ACCESS_STORAGE) {
+				u64 capacity = get_unaligned_le64(&desc[16]);
+
+				put_unaligned_be64(capacity, &desc[16]);
+			} else {
+				u64 num_zones;
+
+				id = get_unaligned_le32(&desc[16]);
+				num_zones = get_unaligned_le64(&desc[24]);
+
+				put_unaligned_be32(id, &desc[16]);
+				put_unaligned_be64(num_zones, &desc[24]);
+			}
+
+			offset += 32;
+			bytes += 32;
+		}
+	}
+	sg_miter_stop(&miter);
+
+	ata_scsi_qc_complete(qc);
+}
+
+static unsigned int
+ata_scsi_get_phys_element_status_xlat(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	const u8 *cdb = scmd->cmnd;
+	struct ata_device *dev = qc->dev;
+	struct ata_taskfile *tf = &qc->tf;
+	u32 starting_element, len;
+
+	/* ATA_CMD_GET_PHYS_ELEMENT_STATUS is a DMA command. */
+	if (!(dev->flags & ATA_DFLAG_DEPOP) || !ata_dma_enabled(dev)) {
+		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		return 1;
+	}
+
+	len = get_unaligned_be32(&cdb[10]) / ATA_SECT_SIZE;
+	if (!len || len > U16_MAX) {
+		ata_scsi_set_invalid_field(dev, scmd, 10, 0);
+		return 1;
+	}
+
+	tf->protocol = ATA_PROT_DMA;
+	tf->command = ATA_CMD_GET_PHYS_ELEMENT_STATUS;
+	tf->hob_feature = cdb[14];
+	tf->hob_nsect = (len >> 8) & 0xff;
+	tf->nsect = len & 0xff;
+
+	starting_element = get_unaligned_be32(&cdb[6]);
+	if (starting_element) {
+		tf->hob_lbal = (starting_element >> 24) & 0xff;
+		tf->lbah = (starting_element >> 16) & 0xff;
+		tf->lbam = (starting_element >> 8) & 0xff;
+		tf->lbal = starting_element & 0xff;
+	}
+	tf->device = ATA_LBA;
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48;
+
+	ata_qc_set_pc_nbytes(qc);
+
+	qc->flags |= ATA_QCFLAG_RESULT_TF;
+	qc->complete_fn = ata_scsi_get_phys_element_status_complete;
+
+	return 0;
+}
+
 /**
  *	ata_scsi_var_len_cdb_xlat - SATL variable length CDB to Handler
  *	@qc: Command to be translated
@@ -4618,6 +4751,8 @@ static unsigned int ata_scsi_var_len_cdb_xlat(struct ata_queued_cmd *qc)
 static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev,
 						u8 *cdb)
 {
+	u8 sa;
+
 	switch (cdb[0]) {
 	case READ_6:
 	case READ_10:
@@ -4652,6 +4787,12 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev,
 	case MODE_SELECT_10:
 		return ata_scsi_mode_select_xlat;
 
+	case SERVICE_ACTION_IN_16:
+		sa = cdb[1] & 0x1f;
+		if (sa == SAI_GET_PHYSICAL_ELEMENT_STATUS)
+			return ata_scsi_get_phys_element_status_xlat;
+		break;
+
 	case ZBC_IN:
 		return ata_scsi_zbc_in_xlat;
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index ac5616a9668b..8b726d9bdda3 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -289,6 +289,7 @@ enum {
 	ATA_CMD_SANITIZE_DEVICE = 0xB4,
 	ATA_CMD_ZAC_MGMT_IN	= 0x4A,
 	ATA_CMD_ZAC_MGMT_OUT	= 0x9F,
+	ATA_CMD_GET_PHYS_ELEMENT_STATUS = 0x12,
 
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
-- 
2.54.0

