Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFAE30F951
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361792; cv=none; b=aNxDvtBLRAY8GnOEQtoaRYnZYa1BvRMopmgw7A799uuhQjHs/E3rMCPzyVKg+M9aHqAZ64K7x00zH43Z4iNzYORUypwtI06CJGJpNBUoq35n65znOYn4J+i/VJwDF+nX+sv1SL7xcfxbYFiCbADCBDbU2zwPrqNzVvahE/Bo4/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361792; c=relaxed/simple;
	bh=9i/eJoNT2bVVj9wWAEiKtF8QfL/5ablALwwnzZeM0kc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OIa4ktXBATWzECzGr/Z9UtiGC/e8jsTGFu55ci3nGTeV7TQLzvNq+Ary2ciiZnK3+2YVA0JN1udp94m7Hs7kq+38dcTWs8+6IgLgV/qQTqAEfLM9toO96fK57VU+u7zQ4oJMmdReFiZBTFDJYINJ6FCVUasj1hO5ekw74EElJPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=FW9ZB883; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FW9ZB883"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4aLIx3329360;
	Wed, 10 Dec 2025 02:16:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=M
	AFIDv4h6WJUh6G3tZibkcyf49MlxPLJiII/INzvObk=; b=FW9ZB883qxrF3vgr9
	tKkvpKo/Yy8uaX/BNF2Vbhwsa/k5r7MNCUGu/lHbAQr1mU2RNkHewpluJsP1nxB+
	vPyvGsNgwp2CnjLU572QJPPJfOnyulgo5PCDWMZ1iZBbnJkXa+09ywlxYlC+OPmS
	wr9P3t99/QzyfTGZvceFGEoLQbRNBpeXPUhahiGzqP27Wole8M3ugjrimsxZlzN9
	2Bs3b60o6CIdHMvpdm4cDLk5AFZ7qFxmSZxX8iNOC/UYGolutxpsU+SiEgwi2+Ki
	gYFeW4xGU2lzeLHyDeD+0UQIptrky/emxuK0qcccUM2BwQBUinZAqd9vNa/TbT2V
	XVGRw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4axuknhj0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 02:16:27 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 10 Dec 2025 02:16:39 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 10 Dec 2025 02:16:39 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0D2AF3F709D;
	Wed, 10 Dec 2025 02:16:23 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 03/12] qla2xxx: Add load flash firmware mailbox support for 28xxx
Date: Wed, 10 Dec 2025 15:45:55 +0530
Message-ID: <20251210101604.431868-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251210101604.431868-1-njavali@marvell.com>
References: <20251210101604.431868-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: nN1StnIlJzKTS2JGmUA-7SzEMYz2qbHN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4NSBTYWx0ZWRfX/J8Qx/KfK7VB
 uU3wjyZEZgFjVJTjI55OTdbeJIgsS1cfeQobVPAjjzoG50nZCsR1IUm+S9BmRCNwpi4TZUjZKwu
 7zBZ5ujGysMnHg+r6YOjTmAIhg6SM2aGGYSsqkN2Ym0vEZ5uFfriXI873nnPenCTOuNYuGZ5pu2
 aAP3cb+Vm9gPydGNsVzwZELPz1j7xdLI0+WOfYs03PgOf0VqbfVrVwm5y8qW8arNLuWvgS72qNG
 dal7QLSM+zQDpYLft7SoTrJ8k1SRbvd6PHlXXbDK26VWzyihF7EISP8YtHQqRCukkt/yy8ky2OQ
 vBygVdZIW/h1BD3G7O8/4FLxCMtMFCDsE4TvGFtC8lz0l/Lv0ztig1ZIqRmJ5gxL0xgxlS0sYhm
 ixLq5AqhIk5FVFjQkkuR6bRKJ89T4w==
X-Proofpoint-ORIG-GUID: nN1StnIlJzKTS2JGmUA-7SzEMYz2qbHN
X-Authority-Analysis: v=2.4 cv=P483RyAu c=1 sm=1 tr=0 ts=6939487b cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=M5GUcnROAAAA:8 a=pGLkceISAAAA:8 a=Rfd0i-ch6evIgXS3oikA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

For 28xxx adaptor Load flash firmware mailbox load the
operational firmware from flash, and also validate the
checksum. Driver do not need to load the operational
firmware anymore, but it still need to read fwdt
from flash to build and allocate firmware dump template.
Remove request_firmware() support for 28xxx adaptor.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512031128.XsuvzBv1-lkp@intel.com/
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
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
index b83029b55a05..82879fb8b565 100644
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
+		for (fragment = 0; fragment < risc_size; fragment++) {
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
index 32eb0ce8b170..2a856965eb3b 100644
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
+ *	Load firmware from flash.
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

