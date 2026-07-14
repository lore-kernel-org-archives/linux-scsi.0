Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2F4445ADA
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022864; cv=none; b=cw8cFoF6qGkZWX/gPoJn1HeFyfFYj+W2VrNjEhZzaKeCxPT2xW9hWcaDVKNLuKRJXSUURyhWdwsJ2x1s+zfzMSSWAox5OP6mXXo2C5tH1hm5sb9bn70heUD91nGpVXzuJ83VyNPEApiOExHI9RP508caUIqcCxAyrtKI/woVNFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022864; c=relaxed/simple;
	bh=x/x1cfUIMD9sJNaMFTUFaW+4MxMPf1eOSxeubVaTWqo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUO4SErDjnoUCDFZMW1MccEzoQNAluzNPASiSZvAUV7JW+RHkeMcBcLOdwlohaAjC8cPEHXmaRRDD52MDXwolB4yhi2vmvyMijqIead79MSIGaU8XC0Jw5MP7v+LxukDGbaqJB5yNQQlbv1AE+L8LyNU9+uteuCSqYnNv9be0IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=CJULCCuX; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CJULCCuX"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UTmu2353993;
	Tue, 14 Jul 2026 02:54:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=S
	5dPi+kFHlfDP7w/UbJX6PTdWp7dpYWMhxy608GRvG4=; b=CJULCCuXrl4Bag89N
	aXPJYtakLHwxEsM5p8QBRgJAuQjUSE18h9UZxQMKE91dtorLPBaCjOUYulltcN1o
	yLPJd9eMrgsGh9MdUfR5bcoIq2y7XWcGr4JDqzB/3h6x5UsL6viDbdKfA6yeIfD9
	/p6Ttjo8ywfWOqbx+uRXNlLNYH6FY5rzXgFgp/RRdEsigGbCzKPoOn1VSh3eQEHi
	8Y8hfDZZ9lFA60bnIRQ4cLrq0Y0cxojZiig3oCCM871CsIgKcVEukiUHj/WiYlyj
	rMVpNv9bPBtsDKwLfWvE31Cagm3ILXy3Wqu4tFRDcEyWh40qODZdYdGUPBZ8th81
	8Kvrw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fca36nhtn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:54:12 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:54:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:54:11 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id E9DF75E6867;
	Tue, 14 Jul 2026 02:54:08 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 02/56] scsi: qla2xxx: Add flash read/write interface for 29xx
Date: Tue, 14 Jul 2026 15:22:59 +0530
Message-ID: <20260714095353.289460-3-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX6YgZhCu3xdUZ
 52fQG659NNjcV3mCdDAiVKzXL1FZkjj5Epa7pmMwwq+XKCNvR/qpXzIbSh3yadMxqSnFV6WMQpG
 Y5ApiZdk5BQ5DvBJOtlk5rLoVtfqX2OTuJ34WYDgK5IcU72RS/ppwVBzFIELnX+P/n00ZFncbdK
 sMffY8LOrrWacyY/ISQ2JrximagZVITqL+aJX2cvSQVvjYr4jDIhLMt5H39RGRM2DZBvg/bPRV7
 zaox9NYyhEI7dumVhKbl9tX4rhlCMqfbTAIy9XKAmyztU5GZ/it4SJgLR947emLqYeFUPzjPNmH
 byU9dCNQp+4acb03GPBCDf4TcEGTDFI8ctV3kB5gsMWMAQqBUKQl//YUJvR5WFcnd8WWIAlc5gp
 Swe/TdWX139Mz/eCIHimssaokQy72uHHQu4bcApv+g/hdPpvjTx5ie4svKOooHGjG7H52qd5eMF
 MdxMcGPb+mml73jpqUg==
X-Authority-Analysis: v=2.4 cv=EeT4hvmC c=1 sm=1 tr=0 ts=6a560745 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=wbOFKmT1qOEUhkzc3csA:9 a=AFYevqiTxqbNWMJh:21 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXwymd+3BRjKvo
 XmJ1VcitmcyM+EZ68Qkk5FPCKX8xxXAQ0S8FRt+x4cHksKZoLZ+7Vj8+tiPXDEHMfXPEGCu/fHL
 QOxQZ/CBQ69XSxIIBwUp7Onl4c5SxQQ=
X-Proofpoint-ORIG-GUID: yyUK6QT_zTpnp28iSyKKMvpDIcYzolEV
X-Proofpoint-GUID: yyUK6QT_zTpnp28iSyKKMvpDIcYzolEV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

The 29xx series uses a different flash access mechanism than
earlier adapters.  Add the mailbox wrappers and qla_sup helpers
needed for flash read and write operations, including the
necessary hooks in isp_ops so that the existing flash
infrastructure can drive the new hardware.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  20 +
 drivers/scsi/qla2xxx/qla_fw.h  |  54 +++
 drivers/scsi/qla2xxx/qla_gbl.h |  15 +-
 drivers/scsi/qla2xxx/qla_mbx.c | 144 +++++++
 drivers/scsi/qla2xxx/qla_os.c  |  18 +-
 drivers/scsi/qla2xxx/qla_sup.c | 662 ++++++++++++++++++++++++++++++++-
 6 files changed, 900 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6337a056b149..b5ad6ed3d5d1 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1278,6 +1278,7 @@ static inline bool qla2xxx_is_valid_mbs(unsigned int mbs)
 #define MBC_LOAD_RISC_RAM		9	/* Load RAM command. */
 #define MBC_DUMP_RISC_RAM		0xa	/* Dump RAM command. */
 #define MBC_SECURE_FLASH_UPDATE		0xa	/* Secure Flash Update(28xx) */
+#define MBC_RD_WR_FLASH			0xa	/* Read/write Dword/block Flash(29xx) */
 #define MBC_LOAD_RISC_RAM_EXTENDED	0xb	/* Load RAM extended. */
 #define MBC_DUMP_RISC_RAM_EXTENDED	0xc	/* Dump RAM extended. */
 #define MBC_WRITE_RAM_WORD_EXTENDED	0xd	/* Write RAM word extended */
@@ -4170,6 +4171,7 @@ struct qla_hw_data {
 #define EEH_FLUSH_RDY  1
 #define EEH_FLUSH_DONE 2
 		uint32_t	secure_mcu:1;
+		uint32_t	valid_flt:1;
 	} flags;
 
 	uint16_t max_exchg;
@@ -4498,6 +4500,8 @@ struct qla_hw_data {
 
 	struct qla_flt_header *flt;
 	dma_addr_t	flt_dma;
+	struct qla_flash_layout *flt_data;
+	uint32_t	fw_dump_tmplt_len;
 
 #define XGMAC_DATA_SIZE	4096
 	void		*xgmac_data;
@@ -4722,6 +4726,9 @@ struct qla_hw_data {
 	uint32_t	fdt_protect_sec_cmd;
 	uint32_t	fdt_wrt_sts_reg_cmd;
 
+#define QLA_SEGMENT_LENGTH      0x25000
+	uint32_t        flt_segment_length;
+
 	struct {
 		uint32_t	flt_region_flt;
 		uint32_t	flt_region_fdt;
@@ -5348,6 +5355,14 @@ static inline bool qla_vha_mark_busy(scsi_qla_host_t *vha)
 /*
  * Flash support definitions
  */
+#define check_and_set_mbc_bits(bopt, dopt, bit_to_check, bit_to_set) {	\
+	if (bopt & bit_to_check)			\
+		dopt |= bit_to_set;			\
+}
+
+#define SET_FW_BIT(__opts, bit) ((__opts) |= (bit))
+#define CLEAR_FW_BIT(__opts, bit) ((__opts) &= ~(bit))
+
 #define OPTROM_SIZE_2300	0x20000
 #define OPTROM_SIZE_2322	0x100000
 #define OPTROM_SIZE_24XX	0x100000
@@ -5612,4 +5627,9 @@ struct ql_vnd_tgt_stats_resp {
 	(!_fcport || IS_SESSION_DELETED(_fcport) || atomic_read(&_fcport->state) != FCS_ONLINE || \
 	!_fcport->vha->hw->flags.fw_started)
 
+#define is_flash_read(_opt)	\
+	(!(_opt & BIT_9) && !(_opt & BIT_6))
+
+#define is_flash_write(_opt)	\
+	(!(_opt & BIT_9) && (_opt & BIT_6))
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index f307beed9d29..d27d09964a24 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1695,6 +1695,10 @@ struct qla_flt_location {
 #define FLT_REG_NVME_PARAMS_PRI_28XX	0x14E
 #define FLT_REG_NVME_PARAMS_SEC_28XX	0x179
 
+/* 29xx */
+#define FLT_REG_MINI_FLT		0x201
+#define FLT_REG_FW_DUMP_TMPLT		0x1A0
+
 struct qla_flt_region {
 	__le16	code;
 	uint8_t attribute;
@@ -1716,6 +1720,56 @@ struct qla_flt_header {
 #define FLT_MAX_REGIONS		0xFF
 #define FLT_REGIONS_SIZE	(FLT_REGION_SIZE * FLT_MAX_REGIONS)
 
+/* 29xx */
+#define FLT_HDR_VERSION		0x2
+
+struct qla_flt_region_header {
+	__le32	signature;
+	__le32	version;
+	__le32	length;
+	__le32	checksum;
+	__le16	region_count;
+	__le16	region_size;
+	__le32	segment_size;
+	__le32	res3;
+	__le32	res4;
+	__le32	res5;
+	__le32	res6;
+	__le32	res7;
+	__le32	res8;
+	__le32	res9;
+	__le32	res10;
+	__le32	res11;
+	__le32	res12;
+};
+
+struct qla_flt_region_data {
+	__le16	region_code;
+	__le16	reserved;
+	__le32	attribute;
+	__le32	image_length;
+	__le32	mbi_offset;
+	__le32	version;
+	__le32	card_type;
+	__le32	chip_revision;
+	__le32	res4;
+	__le32	res5;
+	__le32	res6;
+	__le32	res7;
+	__le32	res8;
+	__le32	res9;
+	__le32	res10;
+	__le32	res11;
+	__le32	res12;
+};
+
+struct qla_flash_layout {
+	struct qla_flt_region_header flt_header;
+	struct qla_flt_region_data region[];
+};
+
+#define FLT_DATA_MAX_REGIONS	0xFF
+
 /* Flash NPIV Configuration Table ********************************************/
 
 struct qla_npiv_header {
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 9e328c235e39..a032dd047a8f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -580,6 +580,12 @@ extern int qla2xxx_read_remote_register(scsi_qla_host_t *, uint32_t,
 extern int qla2xxx_write_remote_register(scsi_qla_host_t *, uint32_t,
     uint32_t);
 void qla_no_op_mb(struct scsi_qla_host *vha);
+extern int qla29xx_flash_block_read(scsi_qla_host_t *vha, dma_addr_t req_dma,
+				    uint32_t flash_addr, uint32_t flash_size,
+				    uint16_t reg_code, uint16_t opt);
+extern int qla29xx_flash_block_write(scsi_qla_host_t *vha, dma_addr_t req_dma,
+				     uint32_t flash_addr, uint32_t flash_size,
+				     uint16_t reg_code, uint16_t opt);
 
 /*
  * Global Function Prototypes in qla_isr.c source file.
@@ -682,7 +688,14 @@ struct purex_item *qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha,
 	void **pkt, struct rsp_que **rsp, bool is_purls, bool byte_order);
 int qla_mailbox_passthru(scsi_qla_host_t *vha, uint16_t *mbx_in,
 			 uint16_t *mbx_out);
-
+void *qla29xx_read_optrom_data(struct scsi_qla_host *vha,
+				       uint16_t reg_code, uint16_t opts,
+				       void *buf, uint32_t offset,
+				       uint32_t length);
+extern int qla29xx_write_optrom_data(struct scsi_qla_host *vha,
+				     uint16_t reg_code, uint16_t opts,
+				     void *buf, uint32_t offset,
+				     uint32_t length);
 /*
  * Global Function Prototypes in qla_dbg.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 44e310f1a370..2d052f870b2b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -7254,3 +7254,147 @@ int qla_mpipt_validate_fw(scsi_qla_host_t *vha, u16 img_idx, uint16_t *state)
 
 	return rval;
 }
+
+int qla29xx_flash_block_read(scsi_qla_host_t *vha, dma_addr_t req_dma,
+			     uint32_t flash_addr, uint32_t flash_size,
+			     uint16_t reg_code, uint16_t opt)
+{
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	int rval = 0;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1067,
+			"Entered %s options 0x%x.\n", __func__, opt);
+
+	memset(mcp->mb, 0, sizeof(mcp->mb));
+
+	if (!is_flash_read(opt)) {
+		ql_log(ql_log_info, vha, 0x1068,
+				"%s: Invalid flash option 0x%x.\n", __func__, opt);
+		return -EINVAL;
+	}
+
+	mcp->mb[0] = MBC_RD_WR_FLASH;
+
+	/* mailbox option field :
+	 *      TIM img or Img  : BIT_15 (1/0)
+	 *       Last seg img   : BIT_11 (1)
+	 *      First seg img   : BIT_10  (1)
+	 *      dword or block  : BIT_9  (1/0)
+	 *     flash MBR update : BIT_8  (1/0)
+	 * Secure or non-secure : BIT_7  (1/0)
+	 *        Write or Read : BIT_6  (1/0)
+	 *       Last block img : BIT_5  (1)
+	 *      First block img : BIT_4  (1)
+	 *         Request type : (BIT3 - BIT_0)
+	 *                        - Normal
+	 *                        - Normal, Force Sema
+	 *                        - Initialize
+	 *                        - Initialize, Force sema
+	 *                        - Abort secured update
+	 */
+	mcp->mb[1] = opt;
+	mcp->mb[2] = reg_code;
+
+	mcp->mb[3] = MSW(flash_size);
+	mcp->mb[4] = LSW(flash_size);
+
+	mcp->mb[5] = MSW(req_dma);
+	mcp->mb[6] = LSW(req_dma);
+	mcp->mb[7] = MSW(MSD(req_dma));
+	mcp->mb[8] = LSW(MSD(req_dma));
+
+	mcp->mb[9] = MSW(flash_addr);
+	mcp->mb[10] = LSW(flash_addr);
+
+	mcp->out_mb =
+		MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x103f,
+				"Failed=%x mb=(0x%x,0x%x,0x%x,0x%x).\n",
+				rval, mcp->mb[0], mcp->mb[1], mcp->mb[2], mcp->mb[3]);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1043,
+				"Done %s mb=(0x%x,0x%x,0x%x).\n", __func__,
+				mcp->mb[0], mcp->mb[1],  mcp->mb[2]);
+	}
+
+	return rval;
+}
+
+int qla29xx_flash_block_write(scsi_qla_host_t *vha, dma_addr_t req_dma,
+			      uint32_t flash_addr, uint32_t flash_size,
+			      uint16_t reg_code, uint16_t opt)
+{
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	int rval = 0;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1069,
+			"Entered %s options 0x%x.\n", __func__, opt);
+
+	memset(mcp->mb, 0, sizeof(mcp->mb));
+
+	if (!is_flash_write(opt)) {
+		ql_log(ql_log_info, vha, 0x106a,
+				"%s: Invalid flash option 0x%x.\n", __func__, opt);
+		return -EINVAL;
+	}
+
+	mcp->mb[0] = MBC_RD_WR_FLASH;
+
+	/* mailbox option field :
+	 *      TIM img or Img  : BIT_15 (1/0)
+	 *       Last seg img   : BIT_11 (1)
+	 *      First seg img   : BIT_10  (1)
+	 *      dword or block  : BIT_9  (1/0)
+	 *     flash MBR update : BIT_8  (1/0)
+	 * Secure or non-secure : BIT_7  (1/0)
+	 *        Write or Read : BIT_6  (1/0)
+	 *       Last block img : BIT_5  (1)
+	 *      First block img : BIT_4  (1)
+	 *         Request type : (BIT3 - BIT_0)
+	 *                        - Normal
+	 *                        - Normal, Force Sema
+	 *                        - Initialize
+	 *                        - Initialize, Force sema
+	 *                        - Abort secured update
+	 */
+	mcp->mb[1] = opt;
+	mcp->mb[2] = reg_code;
+
+	mcp->mb[3] = MSW(flash_size);
+	mcp->mb[4] = LSW(flash_size);
+
+	mcp->mb[5] = MSW(req_dma);
+	mcp->mb[6] = LSW(req_dma);
+	mcp->mb[7] = MSW(MSD(req_dma));
+	mcp->mb[8] = LSW(MSD(req_dma));
+
+	mcp->mb[9] = MSW(flash_addr);
+	mcp->mb[10] = LSW(flash_addr);
+
+	mcp->out_mb =
+		MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x110a,
+				"Failed=%x mb=(0x%x,0x%x,0x%x,0x%x).\n",
+				rval, mcp->mb[0], mcp->mb[1], mcp->mb[2], mcp->mb[3]);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x110b,
+				"Done %s mb=(0x%x,0x%x,0x%x).\n", __func__,
+				mcp->mb[0], mcp->mb[1],  mcp->mb[2]);
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c91d2b8bd08e..ebb97329e6ea 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3237,6 +3237,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->flash_data_off = ~0;
 		ha->nvram_conf_off = ~0;
 		ha->nvram_data_off = ~0;
+		ha->flt_segment_length = QLA_SEGMENT_LENGTH;
 	}
 
 	ql_dbg_pci(ql_dbg_init, pdev, 0x001e,
@@ -4488,6 +4489,14 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		goto fail_flt_buffer;
 	}
 
+	ha->flt_data = vzalloc(sizeof(struct qla_flash_layout) +
+			(sizeof(struct qla_flt_region_data) * FLT_MAX_REGIONS));
+	if (!ha->flt_data) {
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x001a,
+			   "Unable to allocate memory for mini FLT data.\n");
+		goto fail_flt;
+	}
+
 	/* allocate the purex dma pool */
 	ha->purex_dma_pool = dma_pool_create(name, &ha->pdev->dev,
 	    ELS_MAX_PAYLOAD, 8, 0);
@@ -4495,7 +4504,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	if (!ha->purex_dma_pool) {
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x011b,
 		    "Unable to allocate purex_dma_pool.\n");
-		goto fail_flt;
+		goto fail_flt_data;
 	}
 
 	ha->elsrej.size = sizeof(struct fc_els_ls_rjt) + 16;
@@ -4528,6 +4537,9 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 			  ha->elsrej.c, ha->elsrej.cdma);
 fail_elsrej:
 	dma_pool_destroy(ha->purex_dma_pool);
+fail_flt_data:
+	vfree(ha->flt_data);
+	ha->flt_data = NULL;
 fail_flt:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 	    ha->flt, ha->flt_dma);
@@ -4963,6 +4975,10 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->flt = NULL;
 	ha->flt_dma = 0;
 
+	if (ha->flt_data)
+		vfree(ha->flt_data);
+	ha->flt_data = NULL;
+
 	if (ha->ms_iocb)
 		dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);
 	ha->ms_iocb = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index b6c36a8a2d60..6b9938d1a750 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -10,6 +10,539 @@
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
 
+/**
+ * qla29xx_get_flt_layout - Retrieve the flash layout table (FLT) for QLA29xx.
+ * @vha: Pointer to SCSI QLogic host structure.
+ *
+ * This function reads and validates the FLT structure from the flash memory.
+ * It extracts region information and updates the hardware data structure.
+ */
+static void
+qla29xx_get_flt_layout(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_flash_layout *flt_layout = ha->flt_data;
+	struct qla_flt_region_header *flt_header = &flt_layout->flt_header;
+	struct qla_flt_region_data *region = &flt_layout->region[0];
+	uint32_t flt_options = 0;
+	uint32_t flt_size;
+	uint32_t cnt, chksum;
+	uint16_t reg_cnt, i;
+	__le32 *wptr;
+	void *buf = NULL;
+
+	flt_size = sizeof(struct qla_flt_region_header);
+	wptr = (__force __le32 *)ha->flt_data;
+
+	buf = qla29xx_read_optrom_data(vha, FLT_REG_MINI_FLT, flt_options,
+				       ha->flt_data, 0, flt_size);
+	if (!buf) {
+		ql_log(ql_log_warn, vha, 0x007b,
+		    "Failed to read FLT information.\n");
+		goto exit_flt;
+	}
+
+	ql_dbg(ql_dbg_init + ql_dbg_buffer, vha, 0x0111,
+	       "Contents of Flash Layout (0x%x):\n", flt_size);
+	ql_dump_buffer(ql_dbg_init + ql_dbg_buffer, vha, 0x0112,
+		       ha->flt_data, flt_size);
+
+	/* check flt version checksum and other info */
+	if ((le32_to_cpu(*wptr) == 0xffffffff) ||
+	    flt_header->version != cpu_to_le32(FLT_HDR_VERSION)) {
+		ql_log(ql_log_warn, vha, 0x007c,
+		    "Unsupported FLT detected: version=0x%x length=0x%x signature=0x%x region_count=0x%x checksum=0x%x.\n",
+		    le32_to_cpu(flt_header->version),
+		    le32_to_cpu(flt_header->length),
+		    le32_to_cpu(flt_header->signature),
+		    le16_to_cpu(flt_header->region_count),
+		    le32_to_cpu(flt_header->checksum));
+		goto exit_flt;
+	}
+
+	reg_cnt = le16_to_cpu(flt_header->region_count);
+	if (reg_cnt > FLT_MAX_REGIONS)
+		goto exit_flt;
+
+	if (le16_to_cpu(flt_header->region_size) !=
+	    sizeof(struct qla_flt_region_data)) {
+		ql_log(ql_log_warn, vha, 0x0082,
+		    "Unsupported FLT region size 0x%x (expected 0x%zx).\n",
+		    le16_to_cpu(flt_header->region_size),
+		    sizeof(struct qla_flt_region_data));
+		goto exit_flt;
+	}
+
+	flt_size = sizeof(struct qla_flash_layout) +
+		   (reg_cnt * le16_to_cpu(flt_header->region_size));
+	if (flt_size > sizeof(struct qla_flash_layout) +
+	    sizeof(struct qla_flt_region_data) * FLT_DATA_MAX_REGIONS) {
+		ql_log(ql_log_warn, vha, 0x007d,
+		    "FLT size 0x%x exceeds buffer, region_size=0x%x.\n",
+		    flt_size, le16_to_cpu(flt_header->region_size));
+		goto exit_flt;
+	}
+
+	buf = qla29xx_read_optrom_data(vha, FLT_REG_MINI_FLT, flt_options,
+				       ha->flt_data, 0, flt_size);
+	if (!buf) {
+		ql_log(ql_log_warn, vha, 0x007b,
+		    "Failed to read FLT information.\n");
+		goto exit_flt;
+	}
+
+	cnt = le32_to_cpu(flt_header->length) / sizeof(*wptr);
+	if (cnt > flt_size / sizeof(*wptr)) {
+		ql_log(ql_log_warn, vha, 0x007e,
+		    "FLT length 0x%x exceeds read size 0x%x, rejecting.\n",
+		    le32_to_cpu(flt_header->length), flt_size);
+		goto exit_flt;
+	}
+	for (chksum = 0; cnt--; wptr++)
+		chksum += le32_to_cpu(*wptr);
+	if (chksum) {
+		ql_log(ql_log_fatal, vha, 0x007f,
+		    "Inconsistent FLT detected: version=0x%x length=0x%x signature=0x%x checksum=0x%x.\n",
+		    le32_to_cpu(flt_header->version),
+		    le32_to_cpu(flt_header->length),
+		    le32_to_cpu(flt_header->signature),
+		    le32_to_cpu(flt_header->checksum));
+		goto exit_flt;
+	}
+
+	ql_dbg(ql_dbg_init, vha, 0x007f,
+		"FLT detected: version=0x%08x length=0x%08x signature=0x%08x region_count=0x%04x region_len=0x%04x segment_len=0x%08x checksum=0x%08x.\n",
+		le32_to_cpu(flt_header->version),
+		le32_to_cpu(flt_header->length),
+		le32_to_cpu(flt_header->signature),
+		le16_to_cpu(flt_header->region_count),
+		le16_to_cpu(flt_header->region_size),
+		le32_to_cpu(flt_header->segment_size),
+		le32_to_cpu(flt_header->checksum));
+
+	for (i = 0; reg_cnt; i++, reg_cnt--) {
+		region = &flt_layout->region[i];
+		ql_dbg(ql_dbg_init, vha, 0x0080,
+		    "FLT[%03x]: len=0x%08x version=0x%08x attr=0x%02x.\n",
+		    le16_to_cpu(region->region_code),
+		    le32_to_cpu(region->image_length),
+		    le32_to_cpu(region->version),
+		    le32_to_cpu(region->attribute));
+		if (le16_to_cpu(region->region_code) == FLT_REG_FW_DUMP_TMPLT) {
+			ql_dbg(ql_dbg_init, vha, 0x0080,
+				"%s: %d: Found FW dump template", __func__, __LINE__);
+			ha->fw_dump_tmplt_len = le32_to_cpu(region->image_length);
+		}
+	}
+
+	if (le32_to_cpu(flt_header->segment_size) >= sizeof(uint32_t)) {
+		ha->flt_segment_length = le32_to_cpu(flt_header->segment_size);
+	} else {
+		ql_log(ql_log_warn, vha, 0x0081,
+		    "FLT segment size 0x%x too small, using default 0x%x.\n",
+		    le32_to_cpu(flt_header->segment_size), QLA_SEGMENT_LENGTH);
+		ha->flt_segment_length = QLA_SEGMENT_LENGTH;
+	}
+	ha->flags.valid_flt = true;
+	return;
+
+exit_flt:
+	ha->flt_segment_length = QLA_SEGMENT_LENGTH;
+}
+
+/**
+ * qla29xx_get_fdt_info - Retrieve flash descriptor table (FDT) information.
+ * @vha: Pointer to SCSI QLogic host structure.
+ *
+ * This function reads and validates the FDT structure from the flash memory.
+ * It extracts manufacturer and device-specific information and updates
+ * the hardware data structure.
+ */
+static void
+qla29xx_get_fdt_info(scsi_qla_host_t *vha)
+{
+#define FLASH_BLK_SIZE_4K	0x1000
+#define FLASH_BLK_SIZE_32K	0x8000
+#define FLASH_BLK_SIZE_64K	0x10000
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+	uint16_t cnt, chksum;
+	__le16 *wptr = (__force __le16 *)req->ring;
+	struct qla_fdt_layout *fdt = (struct qla_fdt_layout *)req->ring;
+	uint32_t fdt_options = 0;
+	void *buf = NULL;
+
+	buf = qla29xx_read_optrom_data(vha, FLT_REG_FDT, fdt_options,
+					fdt, 0, sizeof(*fdt));
+	if (!buf) {
+		ql_log(ql_log_warn, vha, 0x0047,
+		    "Failed to read FLT information.\n");
+		return;
+	}
+
+	if (le16_to_cpu(*wptr) == 0xffff)
+		return;
+	if (memcmp(fdt->sig, "QLID", 4))
+		return;
+
+	for (cnt = 0, chksum = 0; cnt < sizeof(*fdt) >> 1; cnt++, wptr++)
+		chksum += le16_to_cpu(*wptr);
+	if (chksum) {
+		ql_dbg(ql_dbg_init, vha, 0x004c,
+			"Inconsistent FDT detected: checksum=0x%x id=%c version0x%x.\n",
+			chksum, fdt->sig[0], le16_to_cpu(fdt->version));
+		ql_dump_buffer(ql_dbg_init + ql_dbg_buffer, vha, 0x0113,
+		    fdt, sizeof(*fdt));
+		return;
+	}
+}
+
+/**
+ * qla29xx_get_flash_region - Retrieve flash region information for QLA29xx adapters.
+ * @vha: Pointer to SCSI QLogic host structure.
+ * @code: Region code to identify the flash region.
+ * @region: Pointer to store the retrieved flash region information.
+ *
+ * This function retrieves the flash region information for QLA29xx adapters
+ * based on the specified region code.
+ *
+ * Returns QLA_SUCCESS on success or QLA_FUNCTION_FAILED on failure.
+ */
+static int
+qla29xx_get_flash_region(struct scsi_qla_host *vha, uint32_t code,
+			 struct qla_flt_region_data *region)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_flash_layout *flt = ha->flt_data;
+	struct qla_flt_region_header *flt_hdr = &flt->flt_header;
+	struct qla_flt_region_data *flt_reg = &flt->region[0];
+	uint16_t cnt;
+	int rval = QLA_FUNCTION_FAILED;
+
+	if (!ha->flt_data || !ha->flags.valid_flt)
+		return QLA_FUNCTION_FAILED;
+
+	cnt = le16_to_cpu(flt_hdr->region_count);
+	if (cnt > FLT_MAX_REGIONS)
+		return QLA_FUNCTION_FAILED;
+	/*
+	 * flt_reg++ strides by sizeof(struct qla_flt_region_data). This is
+	 * safe because valid_flt is set only after qla29xx_get_flt_layout()
+	 * has verified the firmware region_size equals that struct size.
+	 */
+	for (; cnt; cnt--, flt_reg++) {
+		if (le16_to_cpu(flt_reg->region_code) == code) {
+			memcpy((uint8_t *)region, flt_reg,
+			    sizeof(struct qla_flt_region_data));
+			rval = QLA_SUCCESS;
+			break;
+		}
+	}
+
+	return rval;
+}
+
+/**
+ * set_segment_bits - Set segment-related bits in the options field.
+ * @options: Pointer to the options field.
+ * @segment_index: Index of the current segment.
+ * @total: Total number of segments.
+ *
+ * This function sets the appropriate bits in the options field to indicate
+ * whether the current segment is the first, last, or a single segment.
+ */
+static void set_segment_bits(uint16_t *options, int segment_index, int total)
+{
+	/* - Single segment complete image.
+	 * - 1st Segment of an image.
+	 * - Last segment of an image.
+	 */
+	if (total == 1)
+		*options |= (1 << 10) | (1 << 11);
+	else if (segment_index == 0)
+		*options |= (1 << 10);
+	else if (segment_index == total - 1)
+		*options |= (1 << 11);
+}
+
+/**
+ * set_chunk_bits - Set chunk-related bits in the options field.
+ * @options: Pointer to the options field.
+ * @count: Index of the current chunk.
+ * @total: Total number of chunks.
+ *
+ * This function sets the appropriate bits in the options field to indicate
+ * whether the current chunk is the first, last, or a single chunk.
+ */
+static void set_chunk_bits(uint16_t *options, int count, int total)
+{
+	/* - Single chunk complete segment
+	 * - 1st chunk of a segment
+	 * - Last chunk of a segment
+	 */
+	if (total == 1)
+		*options |= (1 << 4) | (1 << 5);
+	else if (count == 0)
+		*options |= (1 << 4);
+	else if (count == total - 1)
+		*options |= (1 << 5);
+}
+
+/**
+ * qla29xx_write_optrom_data - Write data to the optrom for QLA29xx adapters.
+ * @vha: Pointer to SCSI QLogic host structure.
+ * @reg_code: Region code to write to.
+ * @opts: Options for the write operation.
+ * @buf: Buffer containing the data to write.
+ * @offset: Offset within the region to start writing.
+ * @length: Length of data to write.
+ *
+ * This function writes data to the specified optrom region for QLA29xx adapters.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int
+qla29xx_write_optrom_data(struct scsi_qla_host *vha, uint16_t reg_code,
+			 uint16_t opts, void *buf, uint32_t offset,
+			 uint32_t length)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_flt_region_data region;
+	dma_addr_t optrom_dma;
+	uint32_t faddr, left, burst;
+	uint32_t img_len, seg_dlen;
+	uint32_t region_len, region_dlen;
+	void *optrom;
+	uint8_t *pbuf;
+	int rval = -EINVAL;
+	uint16_t total_segments, segment_index = 0;
+	uint16_t chunk_index = 0, chunk_count = 0;
+
+	memset(&region, 0, sizeof(region));
+
+	optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
+				    &optrom_dma, GFP_KERNEL);
+	if (!optrom) {
+		ql_log(ql_log_warn, vha, 0x0090,
+		    "Unable to allocate memory for optrom burst read (%x KB).\n",
+		    OPTROM_BURST_SIZE / 1024);
+		return -ENOMEM;
+	}
+
+	if (ha->flags.valid_flt && length == 0) {
+		/* Get image length and segment length from FLT */
+		rval = qla29xx_get_flash_region(vha, reg_code, &region);
+		if (rval != QLA_SUCCESS) {
+			ql_log(ql_log_warn, vha, 0x0092,
+				"Invalid address %x - not a region start address\n",
+				reg_code);
+			goto free_buf;
+		}
+		img_len = le32_to_cpu(region.image_length);
+	} else {
+		img_len = length;
+	}
+
+	seg_dlen = ha->flt_segment_length >> 2;
+	region_len = (length > 0) ? length : img_len;
+	region_dlen = (region_len >> 2);
+	total_segments = (region_dlen + seg_dlen - 1) / seg_dlen;
+
+	faddr = offset >> 2;
+	left = region_dlen;
+	burst = OPTROM_BURST_DWORDS;
+	pbuf = buf;
+
+	while (region_dlen > 0) {
+		uint32_t segment_size, total_chunks;
+		uint16_t options = 0;
+
+		segment_size = (region_dlen > seg_dlen) ? seg_dlen : region_dlen;
+		total_chunks = (segment_size + OPTROM_BURST_DWORDS - 1) /
+				OPTROM_BURST_DWORDS;
+
+		burst = OPTROM_BURST_DWORDS;
+		if (burst > left)
+			burst = left;
+		if (burst > segment_size - chunk_index * OPTROM_BURST_DWORDS)
+			burst = segment_size - chunk_index * OPTROM_BURST_DWORDS;
+
+		set_segment_bits(&options, segment_index, total_segments);
+		set_chunk_bits(&options, chunk_index, total_chunks);
+
+		/* flash block write operations */
+		SET_FW_BIT(options, BIT_6);
+		CLEAR_FW_BIT(options, BIT_9);
+
+		check_and_set_mbc_bits(opts, options, BIT_15, BIT_15);
+		check_and_set_mbc_bits(opts, options, BIT_7, BIT_7);
+
+		if (segment_index == total_segments - 1 &&
+		    chunk_index == total_chunks - 1)
+			check_and_set_mbc_bits(opts, options, BIT_8, BIT_8);
+
+		memcpy(optrom, pbuf, burst * 4);
+
+		/* faddr is offset relative to region code */
+		rval = qla29xx_flash_block_write(vha, optrom_dma,
+				faddr, burst, reg_code, options);
+		if (rval) {
+			ql_log(ql_log_warn, vha, 0x0095,
+			    "Unable to burst-write optrom segment (%x/%x/%llx).\n",
+			    rval, faddr, (unsigned long long)optrom_dma);
+
+			dma_free_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
+			    optrom, optrom_dma);
+			goto exit_write;
+		}
+
+		left -= burst;
+		faddr += burst;
+		pbuf += burst * 4;
+		chunk_index++;
+		chunk_count++;
+		if (chunk_index >= total_chunks) {
+			chunk_index = 0;
+			segment_index++;
+			region_dlen -= segment_size;
+		}
+	}
+
+free_buf:
+	dma_free_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE, optrom,
+	    optrom_dma);
+	return rval;
+
+exit_write:
+	return rval;
+}
+
+/**
+ * qla29xx_read_optrom_data - Read data from the optrom for QLA29xx adapters.
+ * @vha: Pointer to SCSI QLogic host structure.
+ * @reg_code: Region code to read from.
+ * @opts: Options for the read operation.
+ * @buf: Buffer to store the read data.
+ * @offset: Offset within the region to start reading.
+ * @length: Length of data to read.
+ *
+ * This function reads data from the specified optrom region for QLA29xx adapters.
+ *
+ * Returns a pointer to the buffer on success or NULL on failure.
+ */
+void *
+qla29xx_read_optrom_data(struct scsi_qla_host *vha, uint16_t reg_code,
+			 uint16_t opts, void *buf, uint32_t offset,
+			 uint32_t length)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_flt_region_data region;
+	dma_addr_t optrom_dma;
+	uint32_t faddr, left, burst;
+	uint32_t img_len, seg_dlen;
+	uint32_t region_len, region_dlen;
+	void *optrom;
+	uint8_t *pbuf;
+	uint16_t total_segments, segment_index = 0;
+	uint16_t chunk_index = 0, chunk_count = 0;
+	int rval;
+
+	memset(&region, 0, sizeof(region));
+
+	optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
+				    &optrom_dma, GFP_KERNEL);
+	if (!optrom) {
+		ql_log(ql_log_warn, vha, 0x0093,
+		    "Unable to allocate memory for optrom burst read (%x KB).\n",
+		    OPTROM_BURST_SIZE / 1024);
+		return NULL;
+	}
+
+	if (ha->flags.valid_flt && length == 0) {
+		/* Get image length and segment length from FLT */
+		rval = qla29xx_get_flash_region(vha, reg_code, &region);
+		if (rval != QLA_SUCCESS) {
+			ql_log(ql_log_warn, vha, 0x7033,
+				"Invalid address %x - not a region start address\n",
+				reg_code);
+			goto free_buf;
+		}
+		img_len = le32_to_cpu(region.image_length);
+	} else {
+		img_len = length;
+	}
+
+	seg_dlen = ha->flt_segment_length >> 2;
+	region_len = (length > 0) ? length : img_len;
+	region_dlen = (region_len >> 2);
+	total_segments = (region_dlen + seg_dlen - 1) / seg_dlen;
+
+	faddr = offset >> 2;
+	left = region_dlen;
+	burst = OPTROM_BURST_DWORDS;
+	pbuf = buf;
+
+	ql_log(ql_log_info, vha, 0x0096,
+	       "Reg[0x%x]: options=0x%x length=0x%x offset=0x%x segments=%u\n",
+		reg_code, opts, region_len, offset, total_segments);
+
+	while (region_dlen > 0) {
+		uint32_t segment_size, total_chunks;
+		uint16_t options = 0;
+
+		segment_size = (region_dlen > seg_dlen) ? seg_dlen : region_dlen;
+		total_chunks = (segment_size + OPTROM_BURST_DWORDS - 1) /
+				OPTROM_BURST_DWORDS;
+
+		burst = OPTROM_BURST_DWORDS;
+		if (burst > left)
+			burst = left;
+		if (burst > segment_size - chunk_index * OPTROM_BURST_DWORDS)
+			burst = segment_size - chunk_index * OPTROM_BURST_DWORDS;
+
+		set_segment_bits(&options, segment_index, total_segments);
+		set_chunk_bits(&options, chunk_index, total_chunks);
+
+		/* flash block read operations */
+		CLEAR_FW_BIT(options, BIT_9);
+		CLEAR_FW_BIT(options, BIT_6);
+
+		options |= opts;
+
+		/* faddr is offset relative to region code */
+		rval = qla29xx_flash_block_read(vha, optrom_dma,
+				faddr, burst, reg_code, options);
+		if (rval) {
+			ql_log(ql_log_warn, vha, 0x0097,
+			    "Unable to burst-read optrom segment (%x/%x/%llx).\n",
+			    rval, faddr, (unsigned long long)optrom_dma);
+			goto free_buf;
+		}
+
+		memcpy(pbuf, optrom, burst * 4);
+
+		left -= burst;
+		faddr += burst;
+		pbuf += burst * 4;
+		chunk_index++;
+		chunk_count++;
+		if (chunk_index >= total_chunks) {
+			chunk_index = 0;
+			segment_index++;
+			region_dlen -= segment_size;
+		}
+	}
+
+	dma_free_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE, optrom,
+	    optrom_dma);
+	return buf;
+
+free_buf:
+	dma_free_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE, optrom,
+	    optrom_dma);
+	return NULL;
+}
+
 /*
  * NVRAM support routines
  */
@@ -1117,10 +1650,18 @@ qla2xxx_get_flash_info(scsi_qla_host_t *vha)
 	uint32_t flt_addr;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha) &&
-	    !IS_CNA_CAPABLE(ha) && !IS_QLA2031(ha) &&
-	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
-		return QLA_SUCCESS;
+	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha) && !IS_CNA_CAPABLE(ha) &&
+	    !IS_QLA2031(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha) &&
+	    !IS_QLA29XX(ha))
+		goto done;
+
+	if (IS_QLA29XX(ha)) {
+		mutex_lock(&ha->optrom_mutex);
+		qla29xx_get_flt_layout(vha);
+		qla29xx_get_fdt_info(vha);
+		mutex_unlock(&ha->optrom_mutex);
+		goto done;
+	}
 
 	if (IS_QLA28XX(ha) && !qla28xx_validate_mcu_signature(vha))
 		ha->flags.secure_mcu = 1;
@@ -1132,7 +1673,7 @@ qla2xxx_get_flash_info(scsi_qla_host_t *vha)
 	qla2xxx_get_flt_info(vha, flt_addr);
 	qla2xxx_get_fdt_info(vha);
 	qla2xxx_get_idc_param(vha);
-
+done:
 	return QLA_SUCCESS;
 }
 
@@ -3448,6 +3989,86 @@ qla82xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
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
@@ -3472,12 +4093,31 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
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
@@ -3486,7 +4126,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		if (ret) {
 			ql_log(ql_log_info, vha, 0x017d,
 			    "Unable to read PCI EXP Rom Header(%x).\n", ret);
-			return QLA_FUNCTION_FAILED;
+			break;
 		}
 
 		bcode = mbuf + (pcihdr % 4);
@@ -3494,7 +4134,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 			/* No signature */
 			ql_log(ql_log_fatal, vha, 0x0059,
 			    "No matching ROM signature.\n");
-			return QLA_FUNCTION_FAILED;
+			break;
 		}
 
 		/* Locate PCI data structure. */
@@ -3504,7 +4144,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		if (ret) {
 			ql_log(ql_log_info, vha, 0x018e,
 			    "Unable to read PCI Data Structure (%x).\n", ret);
-			return QLA_FUNCTION_FAILED;
+			break;
 		}
 
 		bcode = mbuf + (pcihdr % 4);
@@ -3515,7 +4155,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 			ql_log(ql_log_fatal, vha, 0x005a,
 			    "PCI data struct not found pcir_adr=%x.\n", pcids);
 			ql_dump_buffer(ql_dbg_init, vha, 0x0059, dcode, 32);
-			return QLA_FUNCTION_FAILED;
+			break;
 		}
 
 		/* Read version */
-- 
2.47.3

