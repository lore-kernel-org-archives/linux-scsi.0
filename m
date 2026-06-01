Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5CE3955C7
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309780; cv=none; b=e9B4cFcgxkottDbgyWIJTHYjm+j98HymxGPqx1tMFya6soSzMCp2SfdlyPXC2lQjn1M5tryHI6etvsEdRNYB9VWgKkELI4+3CSqL/upGBhr3phI0h/muHnow08SDMxclYCp/96exuP0vvZgfjvrjUmglFzI1vLzuiUfMQNbZpok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309780; c=relaxed/simple;
	bh=hluf8afI8i5Uz+IR8QuXEbJtVCnNd3mjc7H9ysjf1TE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NP3vLJvi2sJdxJy2bon3ZKb4gUewYqMWTuc6KIsc4DzT10ayYGXt+JhT/To0EvNgy3fmvmU4cK1dZrP1N6V/ase1YxocDAkuwCKzYAqGs6661hmpsETtFm0ECLi/fwy7zHxc0TcEVpPacnI1WwfC6u8TXGyFC3V8SeUvLaZ5hlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HtXDdEWt; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HtXDdEWt"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VNSqPn2845655;
	Mon, 1 Jun 2026 03:29:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=N
	0yHXb0yFE1OXVKvEm0Bwth3AAkYwp1pfY9pGMUy7hY=; b=HtXDdEWtyvAxc3JEU
	NfEAM6P7OuCqi7sHFYT3G6sn87wHke7l/13+oVTiP0YeWXvFyltAYque/4Ji2vJG
	dwlG09JQJlV+pnMJCxvNGFRXbvqeBh234VIL5yHUYwijdzWlD4bFOv9k8JaT/HO3
	FagarGhFsqsb2+/1rX+S7p/aE5H8OglfbwLG9u+Qw6ERYd/z6ebmq8G9FP0tVPcU
	+v/H3hY9OJstZ6VQZQ8KrbrmujSTay4i5aRdBAW6AT+oae/V/A9VWzrWHPwVPKOU
	80Uvz+yhwEtpRay97wZPEpsFMQvuwXeBhRS2oBA65mLOedPd+EAOaQAcV7YkZFtW
	YYacA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4egm56jybq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:29:35 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:29:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:29:34 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 5127D3F7053;
	Mon,  1 Jun 2026 03:29:31 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 06/44] scsi: qla2xxx: Add FC operational firmware load for 29xx
Date: Mon, 1 Jun 2026 15:58:15 +0530
Message-ID: <20260601102853.328426-7-njavali@marvell.com>
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
X-Proofpoint-GUID: wmRWC-x71cAGWJ5IBq08S2WzrJzFZyRB
X-Proofpoint-ORIG-GUID: wmRWC-x71cAGWJ5IBq08S2WzrJzFZyRB
X-Authority-Analysis: v=2.4 cv=ZeYt8MVA c=1 sm=1 tr=0 ts=6a1d5f0f cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=3JwbdyWjmYbMLXezcDwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX5wEMJyBuW7ci
 alDufiZ/B8twHpbDC/gn+SJjIehvJjUKmcEx8utCNjpswCk9r8aC9ISlqQTc9x/NhPTh5WkkCCN
 zcc3EE8M1Y2xIMhRu0u0CrWQv9UWxYligwSnGkLH6glgnFKBCgFjR+2zwxImofozcWEbccqQQRM
 auIHA25Qf4lsaGCkf1omis5yYy1TpZMwk29uEZO7dXmUreOeqR0iWiZJ2GZieiL6fXxK6ARRXP8
 7XPMzfcoX4a6+0kO+5rLkeCD/0E0hUPro3c+fhOBqWq6tVIa8iLdP07Fju6z2ozT6pKuCmZtwoQ
 bPupHqU/zVXNQc3DxkkRpVqzjlpEvV2YJqAOnZMvjX45Bt26IZOSbqYVDv1PUhmb/Ww35FoQ27O
 kSPNH2WKjUHxCeYL8YY+XWtRCmNb0RmywmHThsCwGfdAiq/jCdK+91u2dt/huqSfF2a5clluIF5
 mM8W5bd07XuB6TWbqkw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Add support to load the 29xx FC operational firmware from the
filesystem and to set up the corresponding firmware dump
template.  This follows the same request_firmware / segment-load
pattern used by earlier adapters.

Cc: stable@vger.kernel.org
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_fw.h   |  36 +++
 drivers/scsi/qla2xxx/qla_gbl.h  |   3 +-
 drivers/scsi/qla2xxx/qla_init.c | 482 +++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_mbx.c  |  19 +-
 drivers/scsi/qla2xxx/qla_nx.c   |   2 +-
 drivers/scsi/qla2xxx/qla_os.c   |  47 +++-
 drivers/scsi/qla2xxx/qla_sup.c  |   4 +-
 7 files changed, 581 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 6502eff1c0f6..050986c6217f 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -2378,4 +2378,40 @@ struct qla_flash_memo_block {
 	struct qla_fmb_version  tool_version;
 };
 
+#define TIM_DEST_ADDR	0xffffffff
+#define CHUNK_SIZE	0x10000
+
+#define TIM	0
+#define ARR1	1
+#define ARR2	2
+#define ARR3	3
+#define ARR4	4
+
+#define LD_FL_HEADER_SIGNATURE	0x46434F50
+#define LD_FL_HEADER_VERSION	0x01
+#define LD_FL_HEADER_SIZE	(0x14 * 4)
+
+struct fcop_header {
+	uint32_t signature;
+	uint32_t header_length;
+	uint32_t header_version;
+	uint32_t segment_size;
+	uint32_t tim_length;
+	uint32_t fc_major_version;
+	uint32_t fc_minor_version;
+	uint32_t fc_subminor_version;
+	uint32_t array1_length;
+	uint32_t array1_destination_addr;
+	uint32_t array2_length;
+	uint32_t array2_destination_addr;
+	uint32_t array3_length;
+	uint32_t array4_length;
+	uint32_t attribute;
+	uint32_t extended_attribute;
+	uint32_t reserved0;
+	uint32_t reserved1;
+	uint32_t reserved2;
+	uint32_t image_checksum;
+};
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index a032dd047a8f..ca5a80b9c3d2 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -38,6 +38,7 @@ extern void qla24xx_update_fw_options(scsi_qla_host_t *);
 extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
 extern int qla24xx_load_risc(scsi_qla_host_t *, uint32_t *);
 extern int qla81xx_load_risc(scsi_qla_host_t *, uint32_t *);
+extern int qla29xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr);
 
 extern int qla2x00_perform_loop_resync(scsi_qla_host_t *);
 extern int qla2x00_loop_resync(scsi_qla_host_t *);
@@ -336,7 +337,7 @@ void qla2x00_els_dcmd2_iocb_timeout(void *data);
  * Global Function Prototypes in qla_mbx.c source file.
  */
 extern int
-qla2x00_load_ram(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
+qla2x00_load_ram(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t, int);
 
 extern int
 qla2x00_dump_ram(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4acbbe0161df..20214f2736d9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8669,7 +8669,8 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32(dcode[i]);
 
-			rval = qla2x00_load_ram(vha, req->dma, risc_addr, dlen);
+			rval = qla2x00_load_ram(vha, req->dma, risc_addr,
+			    dlen, 0);
 			if (rval) {
 				ql_log(ql_log_fatal, vha, 0x008f,
 				    "-> Failed load firmware fragment %u.\n",
@@ -8839,7 +8840,7 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 				wcode[i] = swab16((__force u32)fwcode[i]);
 
 			rval = qla2x00_load_ram(vha, req->dma, risc_addr,
-			    wlen);
+			    wlen, 0);
 			if (rval) {
 				ql_log(ql_log_fatal, vha, 0x008a,
 				    "Failed to load segment %d of firmware.\n",
@@ -8929,7 +8930,8 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32((__force u32)fwcode[i]);
 
-			rval = qla2x00_load_ram(vha, req->dma, risc_addr, dlen);
+			rval = qla2x00_load_ram(vha, req->dma, risc_addr,
+			    dlen, 0);
 			if (rval) {
 				ql_log(ql_log_fatal, vha, 0x0098,
 				    "-> Failed load firmware fragment %u.\n",
@@ -9128,6 +9130,480 @@ qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	return rval;
 }
 
+static int qla29xx_validate_firmware_image(scsi_qla_host_t *vha,
+					   __be32 *dword)
+{
+	if (be32_to_cpu(dword[0]) != LD_FL_HEADER_SIGNATURE) {
+		ql_dbg(ql_dbg_init, vha, 0x0093,
+		       "Firmware image Signature does not match (0x%x).\n",
+		       be32_to_cpu(dword[0]));
+		return QLA_FUNCTION_FAILED;
+	}
+	if (be32_to_cpu(dword[2]) != LD_FL_HEADER_VERSION) {
+		ql_dbg(ql_dbg_init, vha, 0x0093,
+		       "Firmware image Version does not match (0x%x).\n",
+		       be32_to_cpu(dword[2]));
+		return QLA_FUNCTION_FAILED;
+	}
+	return QLA_SUCCESS;
+}
+
+static int qla29xx_process_rd_image(struct scsi_qla_host *vha,
+				    struct fcop_header *header,
+				    __be32 *fwcode, int section,
+				    uint32_t risc_addr, int section_size)
+{
+	int rval = QLA_SUCCESS;
+	uint32_t *dcode = NULL;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+	int num_segments = 0, segment = 0;
+	int chunks_per_segment = 0, chunk = 0;
+	int is_first_chunk = 0;
+	int is_last_chunk = 0;
+	int is_first_segment = 0;
+	int is_last_segment = 0;
+	int opt = 0;
+	int size = 0;
+	int size_remainder = 0;
+	int seg_size_remainder = 0;
+	int i = 0;
+
+	dcode = (uint32_t *)req->ring;
+
+	if (section == TIM) {
+		opt = BIT_15 | BIT_2 | BIT_1 | BIT_0;
+		for (i = 0; i < (section_size >> 2); i++)
+			dcode[i] = swab32((__force u32)fwcode[i]);
+
+		ql_dbg(ql_dbg_init, vha, 0x0098,
+		       "TIM : process_rd_image [opt 0x%x]\n", opt);
+		rval = qla2x00_load_ram(vha, req->dma, risc_addr,
+					section_size >> 2, opt);
+		if (rval) {
+			ql_log(ql_log_fatal, vha, 0x0098,
+			       "-> Failed load TIM\n");
+			return QLA_FUNCTION_FAILED;
+		}
+	} else {
+		size_remainder = section_size;
+		num_segments += (section_size % header->segment_size == 0) ?
+			(section_size / header->segment_size) :
+			(section_size / header->segment_size) + 1;
+		chunks_per_segment =
+			(header->segment_size % CHUNK_SIZE == 0) ?
+			(header->segment_size / CHUNK_SIZE) :
+			(header->segment_size / CHUNK_SIZE) + 1;
+
+		ql_dbg(ql_dbg_init, vha, 0x0098,
+		       "num seg 0x%x chunk per seg 0x%x\n",
+		       num_segments, chunks_per_segment);
+
+		for (segment = 0; segment < num_segments; segment++) {
+			for (chunk = 0; chunk < chunks_per_segment; chunk++) {
+				is_first_chunk = (chunk == 0);
+				if (chunk == 0) {
+					if (size_remainder >=
+					    (int)header->segment_size)
+						seg_size_remainder =
+							header->segment_size;
+					else
+						seg_size_remainder =
+							size_remainder;
+				}
+
+				is_first_segment =
+					(section == ARR1 && segment == 0);
+				is_last_segment =
+					(section == ARR2 &&
+					 (segment == (num_segments - 1)));
+				is_last_chunk =
+					(chunk == (chunks_per_segment - 1) ||
+					 size_remainder < CHUNK_SIZE);
+
+				if (seg_size_remainder < CHUNK_SIZE)
+					size = seg_size_remainder % CHUNK_SIZE;
+				else
+					size = CHUNK_SIZE;
+
+				ql_dbg(ql_dbg_init, vha, 0x0098,
+				       "[%d]chunk 0x%x segment 0x%x first_segment 0x%x first_chunk 0x%x last_segment 0x%x last_chunk 0x%x\n",
+				       __LINE__, chunk, segment,
+				       is_first_segment, is_first_chunk,
+				       is_last_segment, is_last_chunk);
+
+				opt = BIT_2;
+				if (is_first_chunk)
+					opt |= BIT_0;
+				if (is_last_chunk)
+					opt |= BIT_1;
+				if (is_first_segment)
+					opt |= BIT_3;
+				if (is_last_segment)
+					opt |= BIT_4;
+
+				memcpy((char *)dcode, (char *)fwcode, size);
+
+			ql_dbg(ql_dbg_init, vha, 0x0098,
+			       "ARR[0x%x] : opt 0x%x\n", size, opt);
+				rval = qla2x00_load_ram(vha, req->dma,
+							risc_addr,
+							size >> 2, opt);
+				if (rval) {
+					ql_log(ql_log_fatal, vha, 0x0098,
+					       "-> Failed load ram\n");
+					return QLA_FUNCTION_FAILED;
+				}
+
+				fwcode += size >> 2;
+				size_remainder -= size;
+				seg_size_remainder -= size;
+				if (size_remainder == 0)
+					break;
+			}
+			risc_addr += header->segment_size >> 2;
+		}
+	}
+	return rval;
+}
+
+static int
+qla29xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
+{
+	int rval;
+	struct fcop_header *header;
+	uint32_t *dcode = NULL;
+	struct fw_blob *blob;
+	__be32 *fwcode, *array1_addr, *array3_addr;
+	uint templates;
+	uint32_t array_size, risc_attr = 0;
+	ulong i;
+	uint j;
+	ulong dlen, array3_offset;
+	struct qla_hw_data *ha = vha->hw;
+	struct fwdt *fwdt = ha->fwdt;
+
+	header = vmalloc(sizeof(*header));
+	if (!header)
+		return QLA_FUNCTION_FAILED;
+
+	ql_dbg(ql_dbg_init, vha, 0x0090,
+	       "-> FW: Loading via request-firmware.\n");
+
+	blob = qla2x00_request_firmware(vha);
+	if (!blob) {
+		ql_log(ql_log_warn, vha, 0x0092,
+		       "-> Firmware file not found.\n");
+		vfree(header);
+		return QLA_FUNCTION_FAILED;
+	}
+
+	fwcode = (__force __be32 *)blob->fw->data;
+
+	rval = qla29xx_validate_firmware_image(vha, fwcode);
+	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_fatal, vha, 0x0093,
+		       "Unable to verify integrity of firmware image\n");
+		vfree(header);
+		return QLA_FUNCTION_FAILED;
+	}
+
+	/* byte-swap big-endian firmware header to CPU endian */
+	for (i = 0; i < sizeof(*header) / sizeof(__be32); i++)
+		((uint32_t *)header)[i] = be32_to_cpu(fwcode[i]);
+
+	header->header_length <<= 2;
+	header->tim_length <<= 2;
+	header->array1_length <<= 2;
+	header->array2_length <<= 2;
+	header->array3_length <<= 2;
+	header->array4_length <<= 2;
+
+	{
+		size_t fw_size = blob->fw->size;
+		size_t offset;
+
+		/* TIM */
+		offset = header->header_length;
+		if (offset + header->tim_length > fw_size) {
+			ql_log(ql_log_fatal, vha, 0x0098,
+			       "FW image too small for TIM (%#zx > %#zx).\n",
+			       offset + header->tim_length, fw_size);
+			goto img_corrupt;
+		}
+		rval = qla29xx_process_rd_image(vha, header,
+			(__be32 *)((char *)fwcode + offset),
+			TIM, TIM_DEST_ADDR, header->tim_length);
+		if (rval) {
+			ql_log(ql_log_fatal, vha, 0x0098,
+			       "-> Failed load TIM\n");
+			goto img_corrupt;
+		}
+
+		/* Array 1 */
+		offset += header->tim_length;
+		if (offset + header->array1_length > fw_size) {
+			ql_log(ql_log_fatal, vha, 0x0098,
+			       "FW image too small for Arr1 (%#zx > %#zx).\n",
+			       offset + header->array1_length, fw_size);
+			goto img_corrupt;
+		}
+		rval = qla29xx_process_rd_image(vha, header,
+			(__be32 *)((char *)fwcode + offset),
+			ARR1, header->array1_destination_addr,
+			header->array1_length);
+		if (rval) {
+			ql_log(ql_log_fatal, vha, 0x0098,
+			       "-> Failed load Arr1\n");
+			goto img_corrupt;
+		}
+
+		/* Array 2 */
+		offset += header->array1_length;
+		if (offset + header->array2_length > fw_size) {
+			ql_log(ql_log_fatal, vha, 0x0098,
+			       "FW image too small for Arr2 (%#zx > %#zx).\n",
+			       offset + header->array2_length, fw_size);
+			goto img_corrupt;
+		}
+		rval = qla29xx_process_rd_image(vha, header,
+			(__be32 *)((char *)fwcode + offset),
+			ARR2, header->array2_destination_addr,
+			header->array2_length);
+		if (rval) {
+			ql_log(ql_log_fatal, vha, 0x0098,
+			       "-> Failed load Arr2\n");
+			goto img_corrupt;
+		}
+
+		/* Array 3: FW_DUMP template */
+		if (offset + 10 * sizeof(__be32) > fw_size) {
+			ql_log(ql_log_fatal, vha, 0x0098,
+			       "FW image too small for risc_attr.\n");
+			goto img_corrupt;
+		}
+		array1_addr = (__be32 *)((char *)fwcode +
+				header->header_length +
+				header->tim_length);
+		risc_attr = swab32(array1_addr[9]);
+	}
+	templates = (risc_attr & BIT_9) ? 2 : 1;
+	ql_dbg(ql_dbg_init, vha, 0x0160,
+	       "-> templates = %u\n", templates);
+
+	array3_offset = header->header_length + header->tim_length +
+		header->array1_length + header->array2_length;
+	if (array3_offset > blob->fw->size) {
+		ql_log(ql_log_fatal, vha, 0x0098,
+		       "FW image too small for Arr3 (%#lx > %#zx).\n",
+		       array3_offset, blob->fw->size);
+		goto img_corrupt;
+	}
+
+	array3_addr = (__be32 *)(((char *)fwcode) + array3_offset);
+	for (j = 0; j < templates; j++, fwdt++) {
+		vfree(fwdt->template);
+		fwdt->template = NULL;
+		fwdt->length = 0;
+
+		array_size = be32_to_cpu(array3_addr[2]);
+		ql_dbg(ql_dbg_init, vha, 0x0161,
+		       "-> fwdt%u template array at %p (%#x dwords)\n",
+		       j, array3_addr, array_size);
+
+		if (!array_size || !~array_size) {
+			ql_dbg(ql_dbg_init, vha, 0x0162,
+			       "-> fwdt%u failed to read array\n", j);
+			goto failed;
+		}
+
+		array3_addr += 7;
+		array_size -= 8;
+
+		ql_dbg(ql_dbg_init, vha, 0x0163,
+		       "-> fwdt%u template allocate template %#x words...\n",
+		       j, array_size);
+		fwdt->template = vmalloc(array_size * sizeof(*dcode));
+		if (!fwdt->template) {
+			ql_log(ql_log_warn, vha, 0x0164,
+			       "-> fwdt%u failed allocate template.\n", j);
+			goto failed;
+		}
+
+		dcode = fwdt->template;
+		for (i = 0; i < array_size; i++)
+			dcode[i] = (__force u32)array3_addr[i];
+
+		if (!qla27xx_fwdt_template_valid(dcode)) {
+			ql_log(ql_log_warn, vha, 0x0165,
+			       "-> fwdt%u failed template validate\n", j);
+			goto failed;
+		}
+
+		dlen = qla27xx_fwdt_template_size(dcode);
+		ql_dbg(ql_dbg_init, vha, 0x0166,
+		       "-> fwdt%u template size %#lx bytes (%#lx words)\n",
+		       j, dlen, dlen / sizeof(*dcode));
+		if (dlen > array_size * sizeof(*dcode)) {
+			ql_log(ql_log_warn, vha, 0x0167,
+			       "-> fwdt%u template exceeds array (%-lu bytes)\n",
+			       j, dlen - array_size * sizeof(*dcode));
+			goto failed;
+		}
+
+		fwdt->length = dlen;
+		ql_dbg(ql_dbg_init, vha, 0x0168,
+		       "-> fwdt%u loaded template ok\n", j);
+
+		array3_addr += array_size + 1;
+	}
+	vfree(header);
+	return QLA_SUCCESS;
+
+failed:
+	vfree(fwdt->template);
+	fwdt->template = NULL;
+	fwdt->length = 0;
+img_corrupt:
+	vfree(header);
+	return QLA_FUNCTION_FAILED;
+}
+
+static int
+qla29xx_load_fw_template(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct fwdt *fwdt = ha->fwdt;
+	uint templates = 1;
+	void *fw_dump_tmplt;
+	uint32_t *dcode;
+	void *buf = NULL;
+	uint32_t len;
+	uint32_t template_size;
+	uint j = 0;
+	int rval = 0;
+
+	ql_dbg(ql_dbg_init, vha, 0x01bf,
+	       "-> templates = %u fw_dump_tmplt_len = 0x%x\n",
+	       templates, ha->fw_dump_tmplt_len);
+
+	if (!ha->fw_dump_tmplt_len) {
+		ql_dbg(ql_dbg_init, vha, 0x01bf,
+		       "no fw dump template available\n");
+		return QLA_SUCCESS;
+	}
+
+	fw_dump_tmplt = kzalloc(ha->fw_dump_tmplt_len, GFP_KERNEL);
+	if (!fw_dump_tmplt) {
+		ql_log(ql_log_info, vha, 0x0013,
+		       "Unable to allocate memory\n");
+		return QLA_FUNCTION_FAILED;
+	}
+
+	buf = qla29xx_read_optrom_data(vha, FLT_REG_FW_DUMP_TMPLT, 0,
+				       fw_dump_tmplt, 0,
+				       ha->fw_dump_tmplt_len);
+	if (!buf) {
+		ql_log(ql_log_info, vha, 0x0013,
+		       "Unable to read fw dump temp info.\n");
+		goto free_fw_dump;
+	}
+
+	ql_dump_buffer(ql_dbg_init, vha, 0x006b,
+		       (char *)fw_dump_tmplt, 1024);
+
+	for (j = 0; j < templates; j++, fwdt++) {
+		vfree(fwdt->template);
+		fwdt->template = NULL;
+		fwdt->length = 0;
+
+		template_size = le32_to_cpu(((__le32 *)fw_dump_tmplt)[2]);
+
+		ql_dbg(ql_dbg_init, vha, 0x0161,
+		       "-> fwdt%u template array at %p (0x%x bytes)\n",
+		       j, fw_dump_tmplt, template_size);
+
+		if (!template_size || !~template_size) {
+			ql_dbg(ql_dbg_init, vha, 0x0162,
+			       "-> fwdt%u failed to read array\n", j);
+			goto failed;
+		}
+
+		fwdt->template = vmalloc(template_size);
+		if (!fwdt->template) {
+			ql_log(ql_log_warn, vha, 0x0164,
+			       "-> fwdt%u failed allocate template.\n", j);
+			goto failed;
+		}
+
+		dcode = fwdt->template;
+		memcpy((char *)dcode, (char *)fw_dump_tmplt, template_size);
+
+		if (!qla27xx_fwdt_template_valid(dcode)) {
+			ql_log(ql_log_warn, vha, 0x0165,
+			       "-> fwdt%u failed template validate (rval %x)\n",
+			       j, rval);
+			goto failed;
+		}
+
+		len = qla27xx_fwdt_template_size(dcode);
+		if (len > template_size) {
+			ql_log(ql_log_warn, vha, 0x0167,
+			       "-> fwdt%u template exceeds array (%-u bytes)\n",
+			       j, len - template_size);
+			goto failed;
+		}
+
+		fwdt->length = len;
+	}
+
+	kfree(fw_dump_tmplt);
+	return QLA_SUCCESS;
+
+failed:
+	if (fwdt->template) {
+		vfree(fwdt->template);
+		fwdt->template = NULL;
+		fwdt->length = 0;
+	}
+free_fw_dump:
+	kfree(fw_dump_tmplt);
+	return QLA_FUNCTION_FAILED;
+}
+
+int
+qla29xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
+{
+	int rval;
+
+	*srisc_addr = 0x100000;
+
+	if (ql2xfwloadbin == 2) {
+		rval = qla29xx_load_risc_blob(vha, srisc_addr);
+		if (rval != QLA_SUCCESS) {
+			ql_log(ql_log_fatal, vha, 0x019e,
+			       "Failed to load firmware from file.\n");
+			return QLA_FUNCTION_FAILED;
+		}
+	} else {
+		rval = qla28xx_load_flash_firmware(vha);
+		if (rval != QLA_SUCCESS) {
+			ql_log(ql_log_fatal, vha, 0x019e,
+			       "Failed to load flash firmware.\n");
+			return QLA_FUNCTION_FAILED;
+		}
+
+		rval = qla29xx_load_fw_template(vha);
+		if (rval != QLA_SUCCESS) {
+			ql_log(ql_log_warn, vha, 0x01bd,
+			       "failed to read firmware template\n");
+			return QLA_FUNCTION_FAILED;
+		}
+	}
+
+	return rval;
+}
+
 void
 qla2x00_try_to_stop_firmware(scsi_qla_host_t *vha)
 {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2b232b225c90..d49dacf6d576 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -618,7 +618,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 int
 qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t risc_addr,
-    uint32_t risc_code_size)
+		 uint32_t risc_code_size, int opt)
 {
 	int rval;
 	struct qla_hw_data *ha = vha->hw;
@@ -651,7 +651,14 @@ qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t risc_addr,
 		mcp->out_mb |= MBX_4;
 	}
 
-	mcp->in_mb = MBX_1|MBX_0;
+	if (IS_QLA29XX(ha)) {
+		mcp->mb[9] = opt;
+		mcp->out_mb |= MBX_9;
+		mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
+	} else {
+		mcp->in_mb = MBX_1|MBX_0;
+	}
+
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -846,15 +853,19 @@ qla28xx_load_flash_firmware(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA28XX(ha))
+	if (!IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return rval;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x11a6,
 	       "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_LOAD_FLASH_FIRMWARE;
+	mcp->mb[1] = 0;
 	mcp->out_mb = MBX_2 | MBX_1 | MBX_0;
-	mcp->in_mb = MBX_0;
+	if (IS_QLA29XX(ha))
+		mcp->in_mb = MBX_1 | MBX_0;
+	else
+		mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 298c060c1292..2366cca51bce 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2663,7 +2663,7 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, __le32 *dwptr,
 
 			ret = qla2x00_load_ram(vha, optrom_dma,
 			    (ha->flash_data_off | faddr),
-			    OPTROM_BURST_DWORDS);
+			    OPTROM_BURST_DWORDS, 0);
 			if (ret != QLA_SUCCESS) {
 				ql_log(ql_log_warn, vha, 0xb01e,
 				    "Unable to burst-write optrom segment "
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4d0b77e3ad00..7e2301feeaba 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2631,6 +2631,45 @@ static struct isp_operations qla27xx_isp_ops = {
 	.initialize_adapter	= qla2x00_initialize_adapter,
 };
 
+static struct isp_operations qla29xx_isp_ops = {
+	.pci_config		= qla25xx_pci_config,
+	.reset_chip		= qla24xx_reset_chip,
+	.chip_diag		= qla24xx_chip_diag,
+	.config_rings		= qla24xx_config_rings,
+	.reset_adapter		= qla24xx_reset_adapter,
+	.nvram_config		= qla81xx_nvram_config,
+	.update_fw_options	= qla24xx_update_fw_options,
+	.load_risc		= qla29xx_load_risc,
+	.pci_info_str		= qla24xx_pci_info_str,
+	.fw_version_str		= qla24xx_fw_version_str,
+	.intr_handler		= qla24xx_intr_handler,
+	.enable_intrs		= qla24xx_enable_intrs,
+	.disable_intrs		= qla24xx_disable_intrs,
+	.abort_command		= qla24xx_abort_command,
+	.target_reset		= qla24xx_abort_target,
+	.lun_reset		= qla24xx_lun_reset,
+	.fabric_login		= qla24xx_login_fabric,
+	.fabric_logout		= qla24xx_fabric_logout,
+	.calc_req_entries	= NULL,
+	.build_iocbs		= NULL,
+	.prep_ms_iocb		= qla24xx_prep_ms_iocb,
+	.prep_ms_fdmi_iocb	= qla24xx_prep_ms_fdmi_iocb,
+	.read_nvram		= NULL,
+	.write_nvram		= NULL,
+	.fw_dump		= qla27xx_fwdump,
+	.mpi_fw_dump		= qla27xx_mpi_fwdump,
+	.beacon_on		= qla24xx_beacon_on,
+	.beacon_off		= qla24xx_beacon_off,
+	.beacon_blink		= qla83xx_beacon_blink,
+	.read_optrom		= qla25xx_read_optrom_data,
+	.write_optrom		= qla24xx_write_optrom_data,
+	.get_flash_version	= qla24xx_get_flash_version,
+	.start_scsi_mq		= qla2xxx_dif_start_scsi_mq,
+	.abort_isp		= qla2x00_abort_isp,
+	.iospace_config		= qla83xx_iospace_config,
+	.initialize_adapter	= qla2x00_initialize_adapter,
+};
+
 static inline void
 qla2x00_set_isp_flags(struct qla_hw_data *ha)
 {
@@ -3223,7 +3262,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_28XX;
 		ha->nvram_npiv_size = QLA_MAX_VPORTS_QLA25XX;
-		ha->isp_ops = &qla27xx_isp_ops;
+		ha->isp_ops = &qla29xx_isp_ops;
 		ha->flash_conf_off = ~0;
 		ha->flash_data_off = ~0;
 		ha->nvram_conf_off = ~0;
@@ -7667,6 +7706,7 @@ qla2x00_timer(struct timer_list *t)
 #define FW_ISP8031	9
 #define FW_ISP27XX	10
 #define FW_ISP28XX	11
+#define FW_ISP29XX	12
 
 #define FW_FILE_ISP21XX	"ql2100_fw.bin"
 #define FW_FILE_ISP22XX	"ql2200_fw.bin"
@@ -7680,6 +7720,7 @@ qla2x00_timer(struct timer_list *t)
 #define FW_FILE_ISP8031	"ql8300_fw.bin"
 #define FW_FILE_ISP27XX	"ql2700_fw.bin"
 #define FW_FILE_ISP28XX	"ql2800_fw.bin"
+#define FW_FILE_ISP29XX	"ql2900_fw.bin"
 
 
 static DEFINE_MUTEX(qla_fw_lock);
@@ -7697,6 +7738,7 @@ static struct fw_blob qla_fw_blobs[] = {
 	{ .name = FW_FILE_ISP8031, },
 	{ .name = FW_FILE_ISP27XX, },
 	{ .name = FW_FILE_ISP28XX, },
+	{ .name = FW_FILE_ISP29XX, },
 	{ .name = NULL, },
 };
 
@@ -7730,6 +7772,8 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
 		blob = &qla_fw_blobs[FW_ISP27XX];
 	} else if (IS_QLA28XX(ha)) {
 		blob = &qla_fw_blobs[FW_ISP28XX];
+	} else if (IS_QLA29XX(ha)) {
+		blob = &qla_fw_blobs[FW_ISP29XX];
 	} else {
 		return NULL;
 	}
@@ -8436,3 +8480,4 @@ MODULE_FIRMWARE(FW_FILE_ISP2300);
 MODULE_FIRMWARE(FW_FILE_ISP2322);
 MODULE_FIRMWARE(FW_FILE_ISP24XX);
 MODULE_FIRMWARE(FW_FILE_ISP25XX);
+MODULE_FIRMWARE(FW_FILE_ISP29XX);
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index c1e32cf29492..288b8c2a9312 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1869,7 +1869,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, __le32 *dwptr, uint32_t faddr,
 			ql_log(ql_log_warn + ql_dbg_verbose, vha, 0x7095,
 			    "Write burst (%#lx dwords)...\n", dburst);
 			ret = qla2x00_load_ram(vha, optrom_dma,
-			    flash_data_addr(ha, faddr), dburst);
+			    flash_data_addr(ha, faddr), dburst, 0);
 			if (!ret) {
 				liter += dburst - 1;
 				faddr += dburst - 1;
@@ -3469,7 +3469,7 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		ql_log(ql_log_warn + ql_dbg_verbose, vha, 0x7095,
 		    "Write burst (%#lx dwords)...\n", dburst);
 		rval = qla2x00_load_ram(vha, optrom_dma,
-		    flash_data_addr(ha, faddr), dburst);
+		    flash_data_addr(ha, faddr), dburst, 0);
 		if (rval != QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0x7097,
 			    "Failed burst write at %x (%p/%#llx)...\n",
-- 
2.47.3

