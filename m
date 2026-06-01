Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1756139934A
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309772; cv=none; b=e9v/hmS27BKYRa8hRvUqusb4dTWVLVVSXxXZfXLAJz+izISdNBinQvTnuP9nlVFUAJLpUFioEwq+ROga2xPuIEDdO7+iDq9nxUStBNe03XAJvGhfeyeF40hhtCSn4GhFGX2nEGTfD33kzwnB8c1zjU8v+DRB1CjiMrsRuJeg4Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309772; c=relaxed/simple;
	bh=JDeG4Qr8hRwJpoODAG74yZLCmFY6D1+XPee4HKcLnxI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YybV+DIUIXV+ynMWwdF5Vk6yIlA7Ig+K9Gr7cEMP0kAWWQ1JqQvLJz/i+ErUAMbOaXldW6aU/fZnz8jtX3EXAfVJCqrkZWAMwQmUZ+fzpyhxo/QzVvna8KgcHHOlhFN7Ngy6YMyork5B9bUYr4VcP+zN7vLStcq+lzu9/2/mYjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=kiS2Kd/l; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kiS2Kd/l"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651AK4xk878414;
	Mon, 1 Jun 2026 03:29:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=2
	+W2wILUSuvfBl92CjFQKkOyPNL+F4ciZ+B6A0taOYI=; b=kiS2Kd/lwVP20u6Xd
	UfCkKJS7e2mA9mYxj0rNs8bMw8weDDEotZUD/g2EjKhlPhrs74yA+JR7RhLNsYK5
	cWFqaqNcnluk2y0AXoNYhCvRNElV8hXTM75VkH8TkOVgiWVN+FjLe0xmLKMC+E19
	Br1wYZiCx/23wMQZHUMNSDNYJyZSnyY/C9dX3sRP6NzG3MBeuDOxK+RRRjJ5zbHc
	vuLJbWWLLMnoLqh/dkxfUhUL7JuQTmI3+f6FRFoebILbmF/tyWTgWSWBoepHcauS
	MMlTLe3RAyPCGaLfMbavaH0zoAugXSqeMEKmIohgtWnG69RG2OyPrrDk+JgUGZim
	xbpBQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b41he-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:29:28 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:29:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:29:27 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 8EE0D3F7053;
	Mon,  1 Jun 2026 03:29:24 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 04/44] scsi: qla2xxx: Add get_flash_version support for 29xx adapters
Date: Mon, 1 Jun 2026 15:58:13 +0530
Message-ID: <20260601102853.328426-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfXxrsXq7YzscRZ
 T7OiZJ86Cs0RkOVb6JHZUuW7yqGbAvciziuY2MUayrbiYaEkDaF7WVdGZhlOG9d4vczWB27GFtr
 TICGBYpXczZpqu8yNc4cqZzNq/york33bmN+9hQ++OiVRfEXJVOLilEDu8Cic8vvQZEF+tVWRSU
 kJrQsAIq/ext2rYEfUQO5xTpkCXTnz530QbZkAO2bFDfVLPc3R96LGUMeIb3A7ojeAyyZW+5Kjk
 HOwVxiu2y0g30LO7VWZFyvo54RwnR1xsgLxh9uBPXawbPVdo662YZE729gjj8bdsokrLH70/m0+
 NJXNvLMwf9W72N/CxJFhkvrdgElg3xSDKTrgoF1HGitLa3Ne7C+9S02KnCJM6/BsnDsX5PM66DR
 OmxC+8xbCrfIK1VsGflknYP0tPBkJzLsjrqLuVt0Q5nhl8dbt36qeroVUpOkHFI/6UoDdeMFRMq
 oWbymryKFaAtoQsqAQw==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1d5f08 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=LCKQs7F6Ci21OR7lPcUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: X4lVyBVUqzRjUeg0VUJ-fllBXgIaNnQI
X-Proofpoint-GUID: X4lVyBVUqzRjUeg0VUJ-fllBXgIaNnQI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Remove the standalone qla29xx_get_flash_version() and fold 29xx
support directly into qla24xx_get_flash_version():

  - Firmware version: 29xx reads version metadata from the FLT region
    via qla29xx_get_flash_region(FLT_REG_FW) rather than parsing the
    flash image; an early return skips the legacy firmware-image read.

  - PCI expansion ROM reads (header + data structure): a new
    file-static helper, qla24xx_read_pci_rom_chunk(), abstracts the
    per-generation flash access so both read sites are straight-line
    calls instead of inline if/else twin blocks.  29xx uses
    qla29xx_read_optrom_data(FLT_REG_BOOT_CODE, byte-offset); 24xx
    uses qla24xx_read_flash_data(dword-address).

Cc: stable@vger.kernel.org
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_sup.c | 196 ++++++++++-----------------------
 1 file changed, 59 insertions(+), 137 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 6386c72ebe46..c1e32cf29492 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -499,134 +499,6 @@ qla29xx_read_optrom_data(struct scsi_qla_host *vha, uint16_t reg_code,
 	return NULL;
 }
 
-/**
- * qla29xx_get_flash_version - Retrieve flash version information for QLA29xx adapters.
- * @vha: Pointer to SCSI QLogic host structure.
- * @mbuf: Buffer to store the flash version information.
- *
- * This function retrieves the flash version information for QLA29xx adapters.
- * It initializes the version fields and prepares for future flash read logic.
- *
- * Returns QLA_SUCCESS on success or QLA_FUNCTION_FAILED on failure.
- */
-int
-qla29xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
-{
-	struct qla_hw_data *ha = vha->hw;
-	struct qla_flt_region_data region;
-	uint32_t pcihdr = 0, pcids = 0;
-	uint32_t *dcode = mbuf;
-	uint8_t *bcode = mbuf;
-	uint8_t code_type, last_image;
-	void *buf = NULL;
-	int ret = QLA_SUCCESS;
-
-	if (!mbuf)
-		return QLA_FUNCTION_FAILED;
-
-	memset(ha->bios_revision, 0, sizeof(ha->bios_revision));
-	memset(ha->efi_revision, 0, sizeof(ha->efi_revision));
-	memset(ha->fcode_revision, 0, sizeof(ha->fcode_revision));
-	memset(ha->fw_revision, 0, sizeof(ha->fw_revision));
-
-	ret = qla29xx_get_flash_region(vha, FLT_REG_FW, &region);
-	if (ret != QLA_SUCCESS) {
-		ql_log(ql_log_warn, vha, 0x7033,
-			"Invalid region %x\n", FLT_REG_FW);
-		goto exit_boot;
-	}
-
-	ha->fw_revision[0] = (le32_to_cpu(region.version) >> 16) & 0xff;
-	ha->fw_revision[1] = (le32_to_cpu(region.version) >> 8) & 0xff;
-	ha->fw_revision[2] = le32_to_cpu(region.version) & 0xff;
-
-	do {
-		/* Verify PCI expansion ROM header. */
-		buf = qla29xx_read_optrom_data(vha, FLT_REG_BOOT_CODE, 0,
-					       dcode, 0, 0x20);
-		if (!buf) {
-			ret = QLA_FUNCTION_FAILED;
-			ql_log(ql_log_info, vha, 0x017d,
-			    "Unable to read PCI EXP Rom Header(%x).\n", ret);
-			break;
-		}
-
-		bcode = mbuf + (pcihdr % 4);
-		if (memcmp(bcode, "\x55\xaa", 2)) {
-			/* No signature */
-			ql_log(ql_log_fatal, vha, 0x0059,
-			    "No matching ROM signature.\n");
-			ret = QLA_FUNCTION_FAILED;
-			break;
-		}
-
-		/* Locate PCI data structure. */
-		pcids = pcihdr + ((bcode[0x19] << 8) | bcode[0x18]);
-
-		buf = qla29xx_read_optrom_data(vha, FLT_REG_BOOT_CODE, 0,
-					       dcode, pcids, 0x20);
-		if (!buf) {
-			ret = QLA_FUNCTION_FAILED;
-			ql_log(ql_log_info, vha, 0x018e,
-			    "Unable to read PCI Data Structure (%x).\n", ret);
-			break;
-		}
-
-		bcode = mbuf + (pcihdr % 4);
-		/* Validate signature of PCI data structure. */
-		if (memcmp(bcode, "PCIR", 4)) {
-			/* Incorrect header. */
-			ql_log(ql_log_fatal, vha, 0x005a,
-			    "PCI data struct not found pcir_adr=%x.\n", pcids);
-			ql_dump_buffer(ql_dbg_init, vha, 0x0059, dcode, 32);
-			ret = QLA_FUNCTION_FAILED;
-			break;
-		}
-
-		/* Read version */
-		code_type = bcode[0x14];
-		switch (code_type) {
-		case ROM_CODE_TYPE_BIOS:
-			/* Intel x86, PC-AT compatible. */
-			ha->bios_revision[0] = bcode[0x12];
-			ha->bios_revision[1] = bcode[0x13];
-			ql_dbg(ql_dbg_init, vha, 0x005b,
-			    "Read BIOS %d.%d.\n",
-			    ha->bios_revision[1], ha->bios_revision[0]);
-			break;
-		case ROM_CODE_TYPE_FCODE:
-			/* Open Firmware standard for PCI (FCode). */
-			ha->fcode_revision[0] = bcode[0x12];
-			ha->fcode_revision[1] = bcode[0x13];
-			ql_dbg(ql_dbg_init, vha, 0x005c,
-			    "Read FCODE %d.%d.\n",
-			    ha->fcode_revision[1], ha->fcode_revision[0]);
-			break;
-		case ROM_CODE_TYPE_EFI:
-			/* Extensible Firmware Interface (EFI). */
-			ha->efi_revision[0] = bcode[0x12];
-			ha->efi_revision[1] = bcode[0x13];
-			ql_dbg(ql_dbg_init, vha, 0x005d,
-			    "Read EFI %d.%d.\n",
-			    ha->efi_revision[1], ha->efi_revision[0]);
-			break;
-		default:
-			ql_log(ql_log_warn, vha, 0x005e,
-			    "Unrecognized code type %x at pcids %x.\n",
-			    code_type, pcids);
-			break;
-		}
-
-		last_image = bcode[0x15] & BIT_7;
-
-		/* Locate next PCI expansion ROM. */
-		pcihdr += ((bcode[0x11] << 8) | bcode[0x10]) * 512;
-	} while (!last_image);
-
-exit_boot:
-	return ret;
-}
-
 /*
  * NVRAM support routines
  */
@@ -4071,6 +3943,34 @@ qla82xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 	return ret;
 }
 
+/*
+ * Read a PCI-expansion-ROM-sized chunk (typically 0x20 bytes) into @buf.
+ *
+ * 29xx posts the read to FLT_REG_BOOT_CODE via qla29xx_read_optrom_data()
+ * using a byte offset relative to the region; failure is signalled by a
+ * NULL return. 24xx uses qla24xx_read_flash_data() with a dword address
+ * (caller-supplied byte address >> 2) and returns an int. The two paths
+ * are collapsed here so that qla24xx_get_flash_version() can issue the
+ * read as a single straight-line call instead of an inline if/else twin
+ * block at every read site.
+ *
+ * The 29xx byte offset and the 24xx byte address are taken as separate
+ * parameters to preserve the original callsite behavior verbatim (the
+ * first read site uses byte offset 0 on 29xx vs pcihdr on 24xx).
+ */
+static int
+qla24xx_read_pci_rom_chunk(scsi_qla_host_t *vha, uint32_t *buf,
+	uint32_t b29_off, uint32_t b24_byte_addr, uint32_t length)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	if (IS_QLA29XX(ha))
+		return qla29xx_read_optrom_data(vha, FLT_REG_BOOT_CODE, 0,
+		    buf, b29_off, length) ? QLA_SUCCESS : QLA_FUNCTION_FAILED;
+	return qla24xx_read_flash_data(vha, buf,
+	    b24_byte_addr >> 2, length >> 2);
+}
+
 int
 qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 {
@@ -4095,21 +3995,38 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 	memset(ha->fcode_revision, 0, sizeof(ha->fcode_revision));
 	memset(ha->fw_revision, 0, sizeof(ha->fw_revision));
 
-	pcihdr = ha->flt_region_boot << 2;
-	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-		qla27xx_get_active_image(vha, &active_regions);
-		if (active_regions.global == QLA27XX_SECONDARY_IMAGE) {
-			pcihdr = ha->flt_region_boot_sec << 2;
+	/* ISP29xx: get FW version from FLT region metadata */
+	if (IS_QLA29XX(ha)) {
+		struct qla_flt_region_data region;
+
+		ret = qla29xx_get_flash_region(vha, FLT_REG_FW, &region);
+		if (ret != QLA_SUCCESS) {
+			ql_log(ql_log_warn, vha, 0x7033,
+					"Invalid region %x\n", FLT_REG_FW);
+			return ret;
+		}
+
+		ha->fw_revision[0] = (le32_to_cpu(region.version) >> 16) & 0xff;
+		ha->fw_revision[1] = (le32_to_cpu(region.version) >> 8) & 0xff;
+		ha->fw_revision[2] = le32_to_cpu(region.version) & 0xff;
+	} else {
+		pcihdr = ha->flt_region_boot << 2;
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+			qla27xx_get_active_image(vha, &active_regions);
+			if (active_regions.global == QLA27XX_SECONDARY_IMAGE) {
+				pcihdr = ha->flt_region_boot_sec << 2;
+			}
 		}
 	}
 
 	do {
 		/* Verify PCI expansion ROM header. */
-		ret = qla24xx_read_flash_data(vha, dcode, pcihdr >> 2, 0x20);
+		ret = qla24xx_read_pci_rom_chunk(vha, dcode,
+		    /* b29_off */ 0, /* b24_byte_addr */ pcihdr, 0x20);
 		if (ret) {
 			ql_log(ql_log_info, vha, 0x017d,
 			    "Unable to read PCI EXP Rom Header(%x).\n", ret);
-			return QLA_FUNCTION_FAILED;
+			break;
 		}
 
 		bcode = mbuf + (pcihdr % 4);
@@ -4123,11 +4040,12 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		/* Locate PCI data structure. */
 		pcids = pcihdr + ((bcode[0x19] << 8) | bcode[0x18]);
 
-		ret = qla24xx_read_flash_data(vha, dcode, pcids >> 2, 0x20);
+		ret = qla24xx_read_pci_rom_chunk(vha, dcode,
+		    /* b29_off */ pcids, /* b24_byte_addr */ pcids, 0x20);
 		if (ret) {
 			ql_log(ql_log_info, vha, 0x018e,
 			    "Unable to read PCI Data Structure (%x).\n", ret);
-			return QLA_FUNCTION_FAILED;
+			break;
 		}
 
 		bcode = mbuf + (pcihdr % 4);
@@ -4181,6 +4099,10 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		pcihdr += ((bcode[0x11] << 8) | bcode[0x10]) * 512;
 	} while (!last_image);
 
+	/* ISP29xx already obtained FW version from FLT region above */
+	if (IS_QLA29XX(ha))
+		return ret;
+
 	/* Read firmware image information. */
 	memset(ha->fw_revision, 0, sizeof(ha->fw_revision));
 	faddr = ha->flt_region_fw;
-- 
2.47.3

