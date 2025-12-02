Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A4B2FCC0F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 05:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654353; cv=none; b=efs8jmpO268dh0pQfCCxtERCoQavtuQ+rkZ9axrViTbnu5k41uL8XWj3lB996NBAv56tXsqW0cFwv6RnGANxbbEVjbgIue/E6ZWZi2C4DDRQRkI8kzLlJS/lyk8eFRBFFY5S+JQ0ju0jaQ5jhHacy/L5MgXkM0zmfTre8+hQqIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654353; c=relaxed/simple;
	bh=30gPIefAtUiYPmlOY1bNN42lDd1yoOJZSqJxmycd4gA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eVZ5YYNU+8+EMJ2PzEglDxR1i5P9LSsFBI64Hv7qE4gvEmzzB9clPKgVNAaZehPUbDo3EOJkx7TOJQ/v/ilCLQdLBjAdEF1hujG8BwrjsYqKqwal/fMGGWhllYpAmICNBRiVLjj+wJLvMhnCMb7mdVzDa3MNf6Km7RML1h/P2GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Qks1CfD8; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Qks1CfD8"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B23NhnO1371971;
	Mon, 1 Dec 2025 21:45:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=9
	8I0ssdB1MBBxPkfwwmKCIOzDP3tJSGxiSQWgmaS1NU=; b=Qks1CfD8LRnICCsa9
	HZRQ6tVlDH9j+say8wXFEcru9Yq/dNoiwLs69GZHM5WhSescGJAkPYjR/JtQxMo8
	5pqbZFCdpIHyZ6OpfmLX0fFhw+qGXKLm/sSp4IH1nDO6AuNm+4SXOZbXsvxXiEYd
	ivEqbm0TcJfsCZwBgnm3avpfWq79dcXsOlihvxrM46jjY0GW9Pll/5/DPJvgiQ1T
	FK0bmePl0vr0FE3yL74bV/q895nq6GealRPrJriHotPG7TRcuPCT8weV3ELg9Sqr
	ymiNRoLL2wnN0s6J7UMMTlI6jPda+q+ihscIyOCJkO/wRiaYNqITd95CgS5uQpmB
	En3wg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ar17nn80w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 21:45:49 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 21:46:02 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 21:46:02 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id EC6655B6976;
	Mon,  1 Dec 2025 21:45:34 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 03/12] qla2xxx: Add load flash firmware mailbox support for 28xxx
Date: Tue, 2 Dec 2025 11:14:35 +0530
Message-ID: <20251202054444.1711778-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251202054444.1711778-1-njavali@marvell.com>
References: <20251202054444.1711778-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: uGxQYJ6T69Sp7UG9nvvD8jqU8R8pJ5v2
X-Authority-Analysis: v=2.4 cv=R+MO2NRX c=1 sm=1 tr=0 ts=692e7d0d cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8
 a=Rfd0i-ch6evIgXS3oikA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: uGxQYJ6T69Sp7UG9nvvD8jqU8R8pJ5v2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0MyBTYWx0ZWRfXzK3Zozm8ICGZ
 82kTDIjGbEQYsfkHkZXMCLYpcpIxtDuvy4PShB5b6rBmoOupqwkNCE6+UP2xa9UEqphih1cGk6e
 Re+VSaNM/M0jSYkE+WyhLiWzYlA+G9tSLz9OKTd3otlxJ5ijbYBiKM3YXa391sKdsG4SCI+5Ml6
 i2AyjG5J8CYCKrG/MRzEksaQ4ljwI4SZ2PhcH2NzBM7msRp0wwMC0ewwf0aTT2UM+00n697VYer
 h/ki38fKwaNHo+eQVo4GbWq82ZClEqyKzaj1zyxjWt7ELFo1vXSVToEuUx1grp3ESV6UObG/Ova
 64zMJ03bGIX8/xB9jx4NrsNtFCCfeUtVFa5X83JvQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

For 28xxx adaptor Load flash firmware mailbox load the
operational firmware from flash, and also validate the
checksum. Driver do not need to load the operational
firmware anymore, but it still need to read fwdt
from flash to build and allocate firmware dump template.
Remove request_firmware() support for 28xxx adaptor.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   1 +
 drivers/scsi/qla2xxx/qla_gbl.h  |   3 +
 drivers/scsi/qla2xxx/qla_init.c | 188 +++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_mbx.c  |  48 ++++++++
 4 files changed, 236 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 34c6e3f06a5b..184a66b8633e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1270,6 +1270,7 @@ static inline bool qla2xxx_is_valid_mbs(unsigned int mbs)
  */
 #define MBC_LOAD_RAM			1	/* Load RAM. */
 #define MBC_EXECUTE_FIRMWARE		2	/* Execute firmware. */
+#define MBC_LOAD_FLASH_FIRMWARE		3	/* Load flash firmware. */
 #define MBC_READ_RAM_WORD		5	/* Read RAM word. */
 #define MBC_MAILBOX_REGISTER_TEST	6	/* Wrap incoming mailboxes */
 #define MBC_VERIFY_CHECKSUM		7	/* Verify checksum. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 145defc420f2..87fa1e3eabf4 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -344,6 +344,9 @@ qla2x00_dump_ram(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
 extern int
 qla2x00_execute_fw(scsi_qla_host_t *, uint32_t);
 
+extern int
+qla28xx_load_flash_firmware(scsi_qla_host_t *vha);
+
 extern int
 qla2x00_get_fw_version(scsi_qla_host_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b83029b55a05..3bfbebc95604 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8457,6 +8457,148 @@ bool qla24xx_risc_firmware_invalid(uint32_t *dword)
 	    !(~dword[4] | ~dword[5] | ~dword[6] | ~dword[7]);
 }
 
+static int
+qla28xx_get_srisc_addr(scsi_qla_host_t *vha, uint32_t *srisc_addr,
+		       uint32_t faddr)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+	uint32_t *dcode;
+	int rval;
+
+	*srisc_addr = 0;
+	dcode = (uint32_t *)req->ring;
+
+	rval = qla24xx_read_flash_data(vha, dcode, faddr, 10);
+	if (rval) {
+		ql_log(ql_log_fatal, vha, 0x01aa,
+		    "-> Failed to read flash addr + size .\n");
+		return QLA_FUNCTION_FAILED;
+	}
+
+	*srisc_addr = be32_to_cpu((__force __be32)dcode[2]);
+	return QLA_SUCCESS;
+}
+
+static int
+qla28xx_load_fw_template(scsi_qla_host_t *vha, uint32_t faddr)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct fwdt *fwdt = ha->fwdt;
+	struct req_que *req = ha->req_q_map[0];
+	uint32_t risc_size, risc_attr = 0;
+	uint templates, segments, fragment;
+	uint32_t *dcode;
+	ulong dlen;
+	int rval;
+	uint j;
+
+	dcode = (uint32_t *)req->ring;
+	segments = FA_RISC_CODE_SEGMENTS;
+
+	for (j = 0; j < segments; j++) {
+		rval = qla24xx_read_flash_data(vha, dcode, faddr, 10);
+		if (rval) {
+			ql_log(ql_log_fatal, vha, 0x01a1,
+			       "-> Failed to read flash addr + size .\n");
+			return QLA_FUNCTION_FAILED;
+		}
+
+		risc_size = be32_to_cpu((__force __be32)dcode[3]);
+
+		if (risc_attr == 0)
+			risc_attr = be32_to_cpu((__force __be32)dcode[9]);
+
+		dlen = ha->fw_transfer_size >> 2;
+		for (fragment = 0; risc_size; fragment++) {
+			if (dlen > risc_size)
+				dlen = risc_size;
+
+			faddr += dlen;
+			risc_size -= dlen;
+		}
+	}
+
+	templates = (risc_attr & BIT_9) ? 2 : 1;
+
+	ql_dbg(ql_dbg_init, vha, 0x01a1, "-> templates = %u\n", templates);
+
+	for (j = 0; j < templates; j++, fwdt++) {
+		vfree(fwdt->template);
+		fwdt->template = NULL;
+		fwdt->length = 0;
+
+		dcode = (uint32_t *)req->ring;
+
+		rval = qla24xx_read_flash_data(vha, dcode, faddr, 7);
+		if (rval) {
+			ql_log(ql_log_fatal, vha, 0x01a2,
+			    "-> Unable to read template size.\n");
+			goto failed;
+		}
+
+		risc_size = be32_to_cpu((__force __be32)dcode[2]);
+		ql_dbg(ql_dbg_init, vha, 0x01a3,
+		    "-> fwdt%u template array at %#x (%#x dwords)\n",
+		    j, faddr, risc_size);
+		if (!risc_size || !~risc_size) {
+			ql_dbg(ql_dbg_init, vha, 0x01a4,
+			    "-> fwdt%u failed to read array\n", j);
+			goto failed;
+		}
+
+		/* skip header and ignore checksum */
+		faddr += 7;
+		risc_size -= 8;
+
+		ql_dbg(ql_dbg_init, vha, 0x01a5,
+		    "-> fwdt%u template allocate template %#x words...\n",
+		    j, risc_size);
+		fwdt->template = vmalloc(risc_size * sizeof(*dcode));
+		if (!fwdt->template) {
+			ql_log(ql_log_warn, vha, 0x01a6,
+			    "-> fwdt%u failed allocate template.\n", j);
+			goto failed;
+		}
+
+		dcode = fwdt->template;
+		rval = qla24xx_read_flash_data(vha, dcode, faddr, risc_size);
+
+		if (rval || !qla27xx_fwdt_template_valid(dcode)) {
+			ql_log(ql_log_warn, vha, 0x01a7,
+			    "-> fwdt%u failed template validate (rval %x)\n",
+			    j, rval);
+			goto failed;
+		}
+
+		dlen = qla27xx_fwdt_template_size(dcode);
+		ql_dbg(ql_dbg_init, vha, 0x01a7,
+		    "-> fwdt%u template size %#lx bytes (%#lx words)\n",
+		    j, dlen, dlen / sizeof(*dcode));
+		if (dlen > risc_size * sizeof(*dcode)) {
+			ql_log(ql_log_warn, vha, 0x01a8,
+			    "-> fwdt%u template exceeds array (%-lu bytes)\n",
+			    j, dlen - risc_size * sizeof(*dcode));
+			goto failed;
+		}
+
+		fwdt->length = dlen;
+		ql_dbg(ql_dbg_init, vha, 0x01a9,
+		    "-> fwdt%u loaded template ok\n", j);
+
+		faddr += risc_size + 1;
+	}
+
+	return QLA_SUCCESS;
+
+failed:
+	vfree(fwdt->template);
+	fwdt->template = NULL;
+	fwdt->length = 0;
+
+	return QLA_SUCCESS;
+}
+
 static int
 qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
     uint32_t faddr)
@@ -8896,16 +9038,18 @@ int
 qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 {
 	int rval;
+	uint32_t f_region = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct active_regions active_regions = { };
 
-	if (ql2xfwloadbin == 2)
+	if (ql2xfwloadbin == 2 && !IS_QLA28XX(ha))
 		goto try_blob_fw;
 
 	/* FW Load priority:
-	 * 1) Firmware residing in flash.
-	 * 2) Firmware via request-firmware interface (.bin file).
-	 * 3) Golden-Firmware residing in flash -- (limited operation).
+	 * 1) If 28xxx, ROM cmd to load flash firmware.
+	 * 2) Firmware residing in flash.
+	 * 3) Firmware via request-firmware interface (.bin file).
+	 * 4) Golden-Firmware residing in flash -- (limited operation).
 	 */
 
 	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
@@ -8913,6 +9057,40 @@ qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 
 	qla27xx_get_active_image(vha, &active_regions);
 
+	/* For 28XXX, always load the flash firmware using rom mbx */
+	if (IS_QLA28XX(ha)) {
+		rval = qla28xx_load_flash_firmware(vha);
+		if (rval != QLA_SUCCESS) {
+			ql_log(ql_log_fatal, vha, 0x019e,
+			       "Failed to load flash firmware.\n");
+			goto exit_load_risc;
+		}
+
+		f_region =
+		(active_regions.global != QLA27XX_SECONDARY_IMAGE) ?
+		 ha->flt_region_fw : ha->flt_region_fw_sec;
+
+		ql_log(ql_log_info, vha, 0x019f,
+		       "Load flash firmware successful (%s).\n",
+		       ((active_regions.global != QLA27XX_SECONDARY_IMAGE) ?
+		       "Primary" : "Secondary"));
+
+		rval = qla28xx_get_srisc_addr(vha, srisc_addr, f_region);
+		if (rval != QLA_SUCCESS) {
+			ql_log(ql_log_warn, vha, 0x019f,
+			       "failed to read srisc address\n");
+			goto exit_load_risc;
+		}
+
+		rval = qla28xx_load_fw_template(vha, f_region);
+		if (rval != QLA_SUCCESS) {
+			ql_log(ql_log_warn, vha, 0x01a0,
+			       "failed to read firmware template\n");
+		}
+
+		goto exit_load_risc;
+	}
+
 	if (active_regions.global != QLA27XX_SECONDARY_IMAGE)
 		goto try_primary_fw;
 
@@ -8942,6 +9120,8 @@ qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 
 	ql_log(ql_log_info, vha, 0x009a, "Need firmware flash update.\n");
 	ha->flags.running_gold_fw = 1;
+
+exit_load_risc:
 	return rval;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 32eb0ce8b170..f23b602ca560 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -43,6 +43,7 @@ static struct rom_cmd {
 } rom_cmds[] = {
 	{ MBC_LOAD_RAM },
 	{ MBC_EXECUTE_FIRMWARE },
+	{ MBC_LOAD_FLASH_FIRMWARE },
 	{ MBC_READ_RAM_WORD },
 	{ MBC_MAILBOX_REGISTER_TEST },
 	{ MBC_VERIFY_CHECKSUM },
@@ -822,6 +823,53 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 	return rval;
 }
 
+/*
+ * qla2x00_load_flash_firmware
+ *	Load fimrware from flash.
+ *
+ * Input:
+ *	vha = adapter block pointer.
+ *
+ * Returns:
+ *	qla28xx local function return status code.
+ *
+ * Context:
+ *	Kernel context.
+ */
+int
+qla28xx_load_flash_firmware(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	int rval = QLA_COMMAND_ERROR;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA28XX(ha))
+		return rval;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x11a6,
+	       "Entered %s.\n", __func__);
+
+	mcp->mb[0] = MBC_LOAD_FLASH_FIRMWARE;
+	mcp->out_mb = MBX_2 | MBX_1 | MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_log_info, vha, 0x11a7,
+		       "Failed=%x cmd error=%x img error=%x.\n",
+		       rval, mcp->mb[1], mcp->mb[2]);
+	} else {
+		ql_dbg(ql_log_info, vha, 0x11a8,
+		       "Done %s.\n", __func__);
+	}
+
+	return rval;
+}
+
+
 /*
  * qla_get_exlogin_status
  *	Get extended login status
-- 
2.23.1

