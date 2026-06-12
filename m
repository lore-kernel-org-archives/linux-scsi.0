Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D93C379C23
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258053; cv=none; b=mSQZRNHmMGF6N8XjlqrXLKCKE0wyrdqGXNrBKvTfS7xjd9QXMBHlwxQmeWX5sK42hTiS+H26f4rY9IVzpuV05WuYXHW9lc1UyFfYTkq3xUMyLnry4k7O1fivUuxpMaMGBiLYYAjuNHjjlm4SGQSE+b6TzOt+iW+UnZpFBk9hU1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258053; c=relaxed/simple;
	bh=DRlkx3/jTNZrfZjhxIFp7Cdyyfhs9WnBmFx2fleHVe0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OtkUZqOKDrSKtLFP9YY5luQB5G+Qgqqtz5Ya0k76FlOv0Op65jjJjKSPgjPv0wRx0ylaa0LS2xKSj20cfbHPE/pRNFgI7oW9nkhXFiFnpghIIC5FBWoklrkwt5GFi4BH1/6o+r50MY8dYt6lX1w1QMNSUszGyWUhhDVK663+mtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HJKMaQ7v; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HJKMaQ7v"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39sFx3783292;
	Fri, 12 Jun 2026 02:54:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	AxIIm0xua8WwHpc4NmDS1946OB8r+lWhRiGTGqov8s=; b=HJKMaQ7v9pB7voi1j
	kiOHRT2nt/lzEfGtISR0f2SyuZm7Pq+QIH71mMUQMNxpEUCekzhytmnGxGt9M+zs
	DLHbZFJESTd3cTihAO2h2QFKyq+oz6MYTbRMyCMyjjIaevjsRUd1K02hQwSSpbpI
	WrTZUgpfXWloK6d6ZK6h0xaTCNbcrdEWTDc4M0TgwlxVvFjpYibPa7ZgCf/dFE0i
	LHCJI52Q/XDwxoiKh0ikkVw0oZmD8TewhOLMuRGmN/p+ZdNikNMARnTxQ6GIUhb5
	Q9ZIg6t5SNZh264zI4ClWMpIyj8D8ezpDG2ySKG0fcNfRQGgExNdU5Cd3u5rlYeA
	zqbYw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4er6r2hjf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:54:08 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:54:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:54:07 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id DEA463F7040;
	Fri, 12 Jun 2026 02:54:04 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 04/60] scsi: qla2xxx: Add get_flash_version support for 29xx adapters
Date: Fri, 12 Jun 2026 15:22:37 +0530
Message-ID: <20260612095333.1666592-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX1KARmmuZGOrs
 dapMEIa4w26SF9bRYu2wRG9ezekZZkNLGWU9JMoXw+NcltfEPYwXtbFvFhYmIpSv9vFXMTVkqUw
 Q3tiGCiZVTQMvfF00xJFuRfCA6pmovbdBpXlnzxNBx830Mm8WUoZ3Rfu3ZemU/nu/wLUSPjFSsg
 UsAUUadte+gf1rJA6XDp9km860wpx8i4UjLD7JqDRmxWiQbcAa/yYiZgdQ52uadcQ7xjJbCb+bZ
 48Fqfn3hMXy2tr8UuIiPUkWgKaIHlAcj6/dANvA0ykIS2Dlmpm9a2TBJcJamS6vcIYNBNH5up2h
 r7mU25cG8uHZLlvcu7zpMc14ZvqNFysuWdU0JWg3OlzmYh4RrJA/UCOMUh7yOPMFQ7Qsp6nPaug
 JR2wRe3uzahXURH92UXPjXBQ2MCPoBuvLLtlWSjC13aAJOa9jjsm5hv7xiCu+VA8GdFzVayWEVX
 y/dTAsXbnSLaasZIxfg==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a2bd740 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=LCKQs7F6Ci21OR7lPcUA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX6MVyocNqFpfr
 20mr5dGOCuFgs/qpE7MI2hgrzbF3OTmVhGbv2WUM33qcuouZZYWyqGq1ENqDdAwnOp89S1dOxfK
 IZUmjPC8/UW8M8eLjx72xgyPq12Ze4Y=
X-Proofpoint-GUID: vHLGLtBNGBZ6IgJcmHBu7zETKhJLxubQ
X-Proofpoint-ORIG-GUID: vHLGLtBNGBZ6IgJcmHBu7zETKhJLxubQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_sup.c | 235 +++++++++++++++------------------
 1 file changed, 103 insertions(+), 132 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index eb10904f14ca..2229c2b084cf 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -527,134 +527,6 @@ qla29xx_read_optrom_data(struct scsi_qla_host *vha, uint16_t reg_code,
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
@@ -4099,6 +3971,86 @@ qla82xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 	return ret;
 }
 
+/*
+ * Read the boot BIOS/FCODE/EFI version for 29xx adapters.
+ *
+ * 29xx reads flash through an FLT region code plus a region-relative
+ * offset.  The firmware only honours such a read at the region base
+ * (offset 0) and rejects a non-zero offset with MBS_COMMAND_ERROR.  The
+ * PCI expansion ROM header and the PCI data structure it points to both
+ * live within the first dwords of FLT_REG_BOOT_CODE, so read one bounded
+ * block at offset 0 and parse both structures from memory instead of
+ * issuing a second read at the PCI-data-structure offset.
+ */
+#define QLA29XX_BOOT_PROBE_LEN	0x100
+
+static void
+qla29xx_get_boot_version(scsi_qla_host_t *vha, void *mbuf)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint8_t *bcode = mbuf;
+	uint32_t pcids;
+	uint8_t code_type;
+
+	if (!qla29xx_read_optrom_data(vha, FLT_REG_BOOT_CODE, 0, mbuf, 0,
+				      QLA29XX_BOOT_PROBE_LEN)) {
+		ql_log(ql_log_info, vha, 0x018e,
+		    "Unable to read PCI Data Structure.\n");
+		return;
+	}
+
+	/* Verify PCI expansion ROM header. */
+	if (memcmp(bcode, "\x55\xaa", 2)) {
+		ql_log(ql_log_info, vha, 0x0059,
+		    "No matching ROM signature.\n");
+		return;
+	}
+
+	/* Locate the PCI data structure within the buffer. */
+	pcids = (bcode[0x19] << 8) | bcode[0x18];
+	if (pcids + 0x16 > QLA29XX_BOOT_PROBE_LEN)
+		return;
+
+	bcode += pcids;
+
+	/* Validate signature of PCI data structure. */
+	if (memcmp(bcode, "PCIR", 4)) {
+		ql_log(ql_log_info, vha, 0x005a,
+		    "PCI data struct not found pcir_adr=%x.\n", pcids);
+		return;
+	}
+
+	code_type = bcode[0x14];
+	switch (code_type) {
+	case ROM_CODE_TYPE_BIOS:
+		/* Intel x86, PC-AT compatible. */
+		ha->bios_revision[0] = bcode[0x12];
+		ha->bios_revision[1] = bcode[0x13];
+		ql_dbg(ql_dbg_init, vha, 0x005b, "Read BIOS %d.%d.\n",
+		    ha->bios_revision[1], ha->bios_revision[0]);
+		break;
+	case ROM_CODE_TYPE_FCODE:
+		/* Open Firmware standard for PCI (FCode). */
+		ha->fcode_revision[0] = bcode[0x12];
+		ha->fcode_revision[1] = bcode[0x13];
+		ql_dbg(ql_dbg_init, vha, 0x005c, "Read FCODE %d.%d.\n",
+		    ha->fcode_revision[1], ha->fcode_revision[0]);
+		break;
+	case ROM_CODE_TYPE_EFI:
+		/* Extensible Firmware Interface (EFI). */
+		ha->efi_revision[0] = bcode[0x12];
+		ha->efi_revision[1] = bcode[0x13];
+		ql_dbg(ql_dbg_init, vha, 0x005d, "Read EFI %d.%d.\n",
+		    ha->efi_revision[1], ha->efi_revision[0]);
+		break;
+	default:
+		ql_log(ql_log_warn, vha, 0x005e,
+		    "Unrecognized code type %x at pcids %x.\n",
+		    code_type, pcids);
+		break;
+	}
+}
+
 int
 qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 {
@@ -4123,12 +4075,31 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 	memset(ha->fcode_revision, 0, sizeof(ha->fcode_revision));
 	memset(ha->fw_revision, 0, sizeof(ha->fw_revision));
 
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
+
+		/* BIOS/FCODE/EFI version from the boot-code region. */
+		qla29xx_get_boot_version(vha, mbuf);
+		return ret;
+	}
+
 	pcihdr = ha->flt_region_boot << 2;
 	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
 		qla27xx_get_active_image(vha, &active_regions);
-		if (active_regions.global == QLA27XX_SECONDARY_IMAGE) {
+		if (active_regions.global == QLA27XX_SECONDARY_IMAGE)
 			pcihdr = ha->flt_region_boot_sec << 2;
-		}
 	}
 
 	do {
@@ -4137,7 +4108,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		if (ret) {
 			ql_log(ql_log_info, vha, 0x017d,
 			    "Unable to read PCI EXP Rom Header(%x).\n", ret);
-			return QLA_FUNCTION_FAILED;
+			break;
 		}
 
 		bcode = mbuf + (pcihdr % 4);
@@ -4155,7 +4126,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		if (ret) {
 			ql_log(ql_log_info, vha, 0x018e,
 			    "Unable to read PCI Data Structure (%x).\n", ret);
-			return QLA_FUNCTION_FAILED;
+			break;
 		}
 
 		bcode = mbuf + (pcihdr % 4);
-- 
2.47.3

