Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19C027466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403731; cv=none; b=V19KEAA3NN1l+8jP9lJLutsTjvI17tTUFyi87Fp9n//4++2BGo8SLdsXHB4CmoESxiLGB4RtitNtsPOGkkIbREjG16nQoXtaxoTMZxnxNswhqHZ+4Z70+kP2zWEqBIH9hWMlYdRoy/6gHKqE5Fqe+mp5lRr2cgJPhkwiC1y4Awk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403731; c=relaxed/simple;
	bh=vNCQmyGK3xA9Lk7PNUyGlJshJWylTg+ZU/Q7r7um9OU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+pb/22WHRi/a5VnuV/quth9Li/Pc+UCeV71pvLPu4QdxciSpJ5O+3VENVqG3RzpXw132206WkxPl49REZJbw9TAUXMnXN3ybWPXscxgNVZ3unp+HNwqPxj6ud31DFVlSmZayOMxBfIjFCr4IC6Wphu6P4x6OSJYJTmOHVBA3YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RD/JfzIB; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RD/JfzIB"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6674834F872825;
	Mon, 6 Jul 2026 22:55:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=p
	gYsHoO0Ak+mwxSv6WntcF0ZYtML6qGPZYSek/zfjUE=; b=RD/JfzIBsV37yWZpJ
	d+AejLj94QkZgq5/xoWcaL3SvovG7MKGPY9V9IbJk7DBT4EzYmV49aAHq0562E0b
	9TSmuKFbwipohbiH+3y1WL8NrJp89Idz5VxWZoqbIgSvodo+6kltWjefQ9tXQs/S
	oGAfNRv8EbWH9DZskOoWSaY4kEpFcj6TX0Shse7oxFMcG3WbF8ljMM8FgtUklaiR
	l6OmKVsuYs2Hh1bmBz/88Dp+K7QP2VSw2PHCxfK/OYSi95kS9Kq0euRxQ+TT6YG5
	iOgc6qC1QTf2/L8in1FOWNR5UkR+GW6RB/mlDLONotEbGE9dnVWIOthwBO6oy/IA
	ZjEoQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:27 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:26 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 657913F7066;
	Mon,  6 Jul 2026 22:55:23 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 09/88] scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx
Date: Tue, 7 Jul 2026 11:23:16 +0530
Message-ID: <20260707055435.2680300-10-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dSVuxeU0JsNprMUGV4kPa1Dk98JxfMSO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX8B8AYxC0zBfR
 lvChmLx/UwVOixHtxn81ZBV+ggGkbChkpzrlZyy53g/Tah6fpoQ/9BdDjn5XplvZLuKWZe25V8+
 FJpm0s0xRB2Y1dGHScESVQEFzBu45hEjOLCT5J3FOLkGOu7dXBM6+7kHSqv7iJL+9rwZGYdk8gI
 pcdS6cDwAoVpYqL5D1kKdpGQ9Mr/O59Z3QfMs3dk6xRI0rX24PPAI1ZE1JGaWcxg9RiTup1Bdfs
 vNDQ7phCBmXPeOEiElHQs6MVbvcZx1CQvwD5S78K7fKuB18U4tQcMQoiIFvUd+mbBgjj12p3z7g
 jjOZXwL3kPwht0R65CCy+zW6rBX0HM4Y6tFiLlUY3J6zWirS/oyywkg9ZPIcs11H4+OS65YGSOI
 jAP6XlPzSsK8fR+nBmsyht+xwINug8OdRxf1Rwdg4S7ZN15cI8WS99oerYlyH958+R/fI0xolLP
 8GtLTPeeTupURw247lw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX+otHDXcfJsDk
 noHFtQHcRNRP6Z1VzvctTHNfz66B1bHTuXMT1EB+u3EwgIpBwKnDz5sR9bUUc6nrWy5rAKprzrj
 h5pGPTBtLJQRVk8EzzOebIkYaxIiKO4=
X-Proofpoint-GUID: dSVuxeU0JsNprMUGV4kPa1Dk98JxfMSO
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c94cf cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=dLhCqXqUJiBd9FaHYSMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

The 29xx series uses 128-byte IOCBs instead of the 64-byte IOCBs
used by earlier adapters.  Add a new header (qla_fw29.h) with the
extended IOCB structure definitions that match the 29xx firmware
interface.

Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_fw29.h | 686 ++++++++++++++++++++++++++++++++
 1 file changed, 686 insertions(+)
 create mode 100644 drivers/scsi/qla2xxx/qla_fw29.h

diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_fw29.h
new file mode 100644
index 000000000000..efe1c60bee81
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_fw29.h
@@ -0,0 +1,686 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2026- Marvell.
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#ifndef __QLA_FW29_H
+#define __QLA_FW29_H
+
+#include "qla_fw.h"
+
+/* Control Flags 2 common for cmd6 and 7 */
+#define CF2_VMID_ENABLE			BIT_0
+#define CF2_CSCTL_PRIORITY_TAG		BIT_1
+#define CF2_NO_TRNF_READY_ENABLE	BIT_2
+#define CF2_RX_ID_ENABLE		BIT_3
+
+/*
+ * vp_index layout for 29xx extended command IOCBs
+ * (cmd_type_6_ext, cmd_type_7_ext, cmd_type_crc_2_ext, ...):
+ *   bits [8:0]   - VP index (9 bits)
+ *   bits [15:9]  - reserved, must be zero
+ * Access on a host-endian value via le16_to_cpu(vp_index) & CMD_EXT_VP_INDEX_MASK.
+ */
+#define CMD_EXT_VP_INDEX_MASK		0x01ff
+/*
+ * ISP queue - command entry structure definition.
+ */
+#define NUM_CMD67_DSDS	4
+struct cmd_type_6_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	__le16	nport_handle;		/* N_PORT handle. */
+	__le16	timeout;		/* Command timeout. */
+
+	__le16	dseg_count;		/* Data segment count. */
+
+	__le16	fcp_rsp_dsd_len;	/* FCP_RSP DSD length. */
+
+	struct scsi_lun lun;		/* FCP LUN (BE). */
+
+	__le16	control_flags;		/* Control flags. */
+
+	__le16	fcp_cmnd_dseg_len;	/* Data segment length. */
+					/* Data segment address. */
+	__le64	 fcp_cmnd_dseg_address __packed;
+					/* Data segment address. */
+	__le64	 fcp_rsp_dseg_address __packed;
+
+	__le32	byte_count;		/* Total byte count. */
+	__le16	control_flags_2;		/* Control flags 2. */
+
+	__le16	vp_index;		/* VP Index 9bits*/
+	__le32	fburstlen_rxid;		/* First Burst length/RX ID */
+	__le16 io_tag;			/* I/O Tag */
+	uint8_t vl_n_fctl;		/* VL (7-4) | RSVD (3-2) | F_CTL [17] (1) | RSVD (0) */
+	uint8_t prtag_csctl;		/* Priority Tag or CS_CTL */
+	__le32	src_vm_id;		/* Source VM ID */
+	uint8_t reserved_2[16];		/* Reserved */
+	struct dsd64 dsd[NUM_CMD67_DSDS];		/* Data Segment Descriptors */
+};
+
+struct cmd_type_7_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+	uint32_t handle;		/* System handle. */
+	__le16	nport_handle;		/* N_PORT handle. */
+	__le16	timeout;		/* Command timeout. */
+
+	__le16	dseg_count;		/* Data segment count. */
+	uint16_t reserved_1;
+
+	struct scsi_lun lun;		/* FCP LUN (BE). */
+
+	__le16	task_mgmt_flags;	/* Task management flags. */
+
+	uint8_t task;
+	uint8_t crn;
+	uint8_t fcp_cdb[MAX_CMDSZ];	/* SCSI command words. */
+	__le32	byte_count;		/* Total byte count. */
+	__le16	ctrl_flags_2;		/* Control flags 2 */
+	__le16	vp_index;		/* VP Index 9bits*/
+	__le32	rx_id;			/* Receive Exchange ID */
+	__le16	io_tag;			/* I/O Tag */
+	uint8_t vl_n_fctl;		/* VL (7-4) | RSVD (3-2) | F_CTL [17] (1) | RSVD (0) */
+	uint8_t reserved_3[21];		/* Reserved */
+	struct dsd64 dsd[NUM_CMD67_DSDS];	/* Data Segment Descriptors */
+};
+
+struct cmd_type_crc_2_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	__le16	nport_handle;		/* N_PORT handle. */
+	__le16	timeout;		/* Command timeout. */
+
+	__le16	dseg_count;		/* Data segment count. */
+	__le16	fcp_rsp_dseg_len;	/* FCP_RSP DSD length. */
+
+	struct scsi_lun lun;		/* FCP LUN (BE). */
+
+	__le16	control_flags_1;		/* Control flags. */
+	__le16	fcp_cmnd_dseg_len;	/* Data segment length. */
+
+	__le64	 fcp_cmnd_dseg_address __packed;
+					/* Data segment address. */
+	__le64	 fcp_rsp_dseg_address __packed;
+
+	__le32	byte_count;		/* Total byte count. */
+
+	__le16	control_flags_2;		/* Control flags - 2 */
+	__le16	vp_index;		/* VP Index (bits [8:0]); bits [15:9] reserved.
+					 * See CMD_EXT_VP_INDEX_MASK.
+					 */
+
+	uint32_t reserved_1;
+
+	__le16	 iocb_tag; /* Unused */
+	__le16 vl_prio; /* Bit 1 - F_CTL, Bits 4-7 VL, rest are rsvd */
+
+	uint32_t reserved_2; /* 3C-3F offset */
+
+	__le32 ref_tag;
+	uint8_t ref_tag_mask[4];	/* Validation/Replacement Mask*/
+
+	__le16 app_tag;
+	uint8_t app_tag_mask[2];	/* Validation/Replacement Mask*/
+
+	__le16 blk_size;		/* Data size in bytes */
+	__le16 prot_opts;		/* Requested Data Protection Mode */
+
+	__le32 tot_byte_count;		/* Total byte count/ total data
+					 * transfer count
+					 */
+	union {
+		struct {
+			uint32_t	reserved_1; /* offset 54 */
+			uint16_t	reserved_2;
+			__le16		guard_seed; /* offset 5A */
+			struct dsd64	data_dsd[1];
+			uint32_t	reserved_5[2];
+			uint32_t	reserved_6;
+		} nobundling;
+		struct {
+			__le32	dif_byte_count;	/* Total DIF byte
+						 * count
+						 */
+			__le16	dseg_count;	/* Data segment count */
+			__le16 guard_seed;      /* Initial Guard Seed */
+			struct dsd64	data_dsd[1];
+			struct dsd64	dif_dsd;
+		} bundling;
+	} u;
+	uint8_t reserved_3[12];			/* MUST be set to 0. */
+};
+
+/*
+ * ISP queue - status entry structure definition.
+ */
+struct sts_entry_24xx_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	__le16	comp_status;		/* Completion status. */
+	__le16	ox_id;			/* OX_ID used by the firmware. */
+
+	__le32	residual_len;		/* FW calc residual transfer length. */
+
+	union {
+		__le16 reserved_1;
+		__le16 nvme_rsp_pyld_len;
+	} u1;
+
+	__le16	state_flags;		/* State flags. */
+
+	__le16 read_sa_index;
+	__le16 wr_sa_index;
+	uint8_t	reserved_2[8];
+	uint8_t act_dif[8];
+	uint8_t exp_dif[8];
+	union {
+		struct {
+			__le32	rsp_data_len_dma;	/* FCP response data length  */
+			uint8_t reserved_3[76];
+		};
+		struct {
+			uint8_t nvme_ersp_data[32];
+			uint8_t reserved_4[48];
+		};
+		struct {
+			__le32	bid_rd_rsp_residual_count;	/* BID read rsp residual cnt */
+			__le16	retry_delay_timer;	/* Retry delay timer. */
+			__le16	scsi_status;		/* SCSI status. */
+			__le32	rsp_residual_count;	/* FCP RSP residual count. */
+			__le32	sense_len;		/* FCP SENSE length. */
+			__le32	rsp_data_len_ndma;	/* FCP response data length  */
+			uint8_t	data[60];	/* FCP rsp/sense information */
+		};
+	} u2;
+
+	/*
+	 * If DIF Error is set in comp_status, these additional fields are
+	 * defined:
+	 *
+	 * !!! NOTE: Firmware sends expected/actual DIF data in big endian
+	 * format; but all of the "data" field gets swab32-d in the beginning
+	 * of qla2900_status_entry().
+	 *
+	 * &data[10] : uint8_t report_runt_bg[2];	- computed guard
+	 * &data[12] : uint8_t actual_dif[8];		- DIF Data received
+	 * &data[20] : uint8_t expected_dif[8];		- DIF Data computed
+	 */
+};
+
+/*
+ * ISP queue - marker entry structure definition.
+ */
+struct mrk_entry_24xx_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t handle_count;		/* Handle count. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	__le16	nport_handle;		/* N_PORT handle. */
+
+	uint8_t modifier;		/* Modifier (7-0). */
+	uint8_t reserved_1;
+
+	__le16	vp_index;	/* VP Index. 9bits*/
+	uint16_t reserved_3;
+
+	uint8_t lun[8];			/* FCP LUN (BE). */
+	uint8_t reserved_4[104];
+};
+
+/*
+ * ISP queue - CT Pass-Through entry structure definition.
+ */
+#define NUM_CT_DSDS	5
+struct ct_entry_24xx_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System Defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	__le16	comp_status;		/* Completion status. */
+
+	__le16	nport_handle;		/* N_PORT handle. */
+
+	__le16	cmd_dsd_count;
+
+	__le16	vp_index;		/* vp index 9 bits*/
+
+	__le16	timeout;		/* Command timeout. */
+	uint16_t reserved_2;
+
+	__le16	rsp_dsd_count;
+
+	uint8_t reserved_3[10];
+	uint8_t reserved_4[28];		/* Reserved. */
+
+	__le32	rsp_byte_count;
+	__le32	cmd_byte_count;
+	struct dsd64 dsd[NUM_CT_DSDS];	/* Data Segment Descriptors */
+};
+
+/*
+ * ISP queue - PUREX IOCB entry structure definition
+ */
+struct purex_entry_24xx_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	__le16	reserved1;
+	__le16	vp_idx;			/* VP index 9 bits*/
+
+	__le16	status_flags;
+	__le16	nport_handle;
+
+	__le16	frame_size;
+	__le16	trunc_frame_size;
+
+	__le32	rx_xchg_addr;
+
+	uint8_t d_id[3];
+	uint8_t r_ctl;
+
+	uint8_t s_id[3];
+	uint8_t cs_ctl;
+
+	uint8_t f_ctl[3];
+	uint8_t type;
+
+	__le16	seq_cnt;
+	uint8_t df_ctl;
+	uint8_t seq_id;
+
+	__le16	rx_id;
+	__le16	ox_id;
+	__le32	param;
+
+	uint8_t els_frame_payload[84];
+};
+
+/*
+ * ISP queue - ELS Pass-Through entry structure definition.
+ * ELS_EXT_EST_SOFI*: 4-bit sof_type for extended IOCBs (qla_fw.h EST_SOFI*
+ * is for els_entry_24xx byte layout).
+ */
+#define ELS_EXT_EST_SOFI3	(1 << 1)
+#define ELS_EXT_EST_SOFI2	(3 << 3)
+
+struct els_entry_24xx_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System Defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	__le16	comp_status;		/* response only */
+	__le16	nport_handle;
+
+	__le16	tx_dsd_count;
+
+	__le16	vp_index : 9;		/* VP Index 9bits */
+	__le16	reserved_1_sof : 3;
+	__le16	sof_type : 4;
+
+	__le32	rx_xchg_address;	/* Receive exchange address. */
+	__le16	rx_dsd_count;
+
+	uint8_t opcode;
+	uint8_t reserved_2;
+
+	uint8_t d_id[3];
+	uint8_t s_id[3];
+
+	__le16	control_flags;		/* Control flags. */
+
+	union {
+		struct {
+			__le32	 rx_byte_count;
+			__le32	 tx_byte_count;
+
+			__le64	 tx_address __packed;	/* DSD 0 address. */
+			__le32	 tx_len;		/* DSD 0 length. */
+
+			__le64	 rx_address __packed;	/* DSD 1 address. */
+			__le32	 rx_len;		/* DSD 1 length. */
+		};
+		struct {
+			__le32	total_byte_count;
+			__le32	error_subcode_1;
+			__le32	error_subcode_2;
+			__le32	error_subcode_3;
+			uint8_t reserved_3[16];
+		};
+	};
+	uint8_t reserved_4[64];
+};
+
+struct els_sts_entry_24xx_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System Defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	__le32	handle;		/* System handle. */
+
+	__le16	comp_status;
+
+	__le16	nport_handle;		/* N_PORT handle. */
+
+	__le16	reserved_1;
+
+	__le16	vp_index : 9;		/* VP Index 9bits */
+	__le16	reserved_1_sof : 3;
+	__le16	sof_type : 4;
+
+	__le32	rx_xchg_address;	/* Receive exchange address. */
+	__le16	reserved_2;
+
+	uint8_t opcode;
+	uint8_t reserved_3;
+
+	uint8_t d_id[3];
+	uint8_t s_id[3];
+
+	__le16	control_flags;		/* Control flags. */
+	__le32	total_byte_count;
+	__le32	error_subcode_1;
+	__le32	error_subcode_2;
+	__le32	error_subcode_3;
+
+	uint8_t	reserved_4[80];
+};
+
+struct logio_entry_24xx_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	__le16	comp_status;		/* Completion status. */
+
+	__le16	nport_handle;		/* N_PORT handle. */
+
+	__le16	control_flags;		/* Control flags. */
+
+	__le16	vp_index;		/* VP Index 9bits*/
+
+	uint8_t port_id[3];		/* PortID of destination port. */
+
+	uint8_t rsp_size;		/* Response size in 32bit words. */
+
+	__le32	io_parameter[11];	/* General I/O parameters. */
+	uint8_t reserved_2[64];		/* Reserved*/
+};
+
+struct tsk_mgmt_entry_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t handle_count;		/* Handle count. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	__le16	nport_handle;		/* N_PORT handle. */
+
+	__le16	reserved_1;
+
+	__le16	delay;			/* Activity delay in seconds. */
+
+	__le16	timeout;		/* Command timeout. */
+
+	struct scsi_lun lun;		/* FCP LUN (BE). */
+
+	__le32	control_flags;		/* Control Flags. */
+
+	__le16	vp_index;	/* VP Index 9bits */
+
+	uint8_t reserved_3[98];
+};
+
+struct abort_entry_24xx_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t handle_count;		/* Handle count. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	union {
+		__le16 nport_handle;            /* N_PORT handle. */
+		__le16 comp_status;             /* Completion status. */
+	};
+
+	__le16	options;		/* Options. */
+
+	uint32_t handle_to_abort;	/* System handle to abort. */
+
+	__le16	req_que_no;
+
+	__le16	vp_index;		/* VP Index 9bits*/
+	u8	reserved_2[4];
+	union {
+		struct {
+			__le16 abts_rty_cnt;
+			__le16 rsp_timeout;
+		} drv;
+		struct {
+			u8	ba_rjt_vendorUnique;
+			u8	ba_rjt_reasonCodeExpl;
+			u8	ba_rjt_reasonCode;
+			u8	reserved_3;
+		} fw;
+	};
+	u8	reserved_4[100];
+};
+
+struct abts_entry_24xx_ext {
+	uint8_t entry_type;
+	uint8_t entry_count;
+	uint8_t handle_count;
+	uint8_t entry_status;
+
+	__le32	handle;		/* type 0x55 only */
+
+	__le16	comp_status;		/* type 0x55 only */
+	__le16	nport_handle;		/* type 0x54 only */
+
+	__le16	control_flags;		/* type 0x55 only */
+	__le16	vp_idx : 9;		/* VP index 9 bits */
+	__le16	reserved_1_sof : 3;
+	__le16	sof_type : 4;		/* sof_type is upper nibble */
+
+	__le32	rx_xch_addr;
+
+	uint8_t d_id[3];
+	uint8_t r_ctl;
+
+	uint8_t s_id[3];
+	uint8_t cs_ctl;
+
+	uint8_t f_ctl[3];
+	uint8_t type;
+
+	__le16	seq_cnt;
+	uint8_t df_ctl;
+	uint8_t seq_id;
+
+	__le16	rx_id;
+	__le16	ox_id;
+
+	__le32	param;
+
+	union {
+		struct {
+			__le32	subcode3;
+			__le32	rsvd;
+			__le32	subcode1;
+			__le32	subcode2;
+		} error;
+		struct {
+			__le16	rsrvd1;
+			uint8_t last_seq_id;
+			uint8_t seq_id_valid;
+			__le16	aborted_rx_id;
+			__le16	aborted_ox_id;
+			__le16	high_seq_cnt;
+			__le16	low_seq_cnt;
+		} ba_acc;
+		struct {
+			uint8_t vendor_unique;
+			uint8_t explanation;
+			uint8_t reason;
+		} ba_rjt;
+	} payload;
+
+	__le32	rx_xch_addr_to_abort;
+	uint8_t reserved_2[64];
+} __packed;
+/*
+ * Virtual Port Control IOCB
+ */
+struct vp_ctrl_entry_24xx_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	__le16	vp_idx_failed;
+
+	__le16	comp_status;		/* Completion status. */
+
+	__le16	command;
+
+	__le16	vp_count;
+
+	uint8_t vp_idx_map[16];
+	__le16	flags;
+	__le16	id;
+	uint16_t reserved_4;
+	__le16	hopct;
+	uint8_t reserved_5[88];
+};
+
+/*
+ * Modify Virtual Port Configuration IOCB
+ */
+struct vp_config_entry_24xx_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t handle_count;
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	__le16	flags;
+
+	__le16	comp_status;		/* Completion status. */
+
+	uint8_t command;
+
+	uint8_t vp_count;
+
+	uint8_t vp_index1;
+	uint8_t vp_index2;
+
+	uint8_t options_idx1;
+	uint8_t hard_address_idx1;
+	uint16_t reserved_vp1;
+	uint8_t port_name_idx1[WWN_SIZE];
+	uint8_t node_name_idx1[WWN_SIZE];
+
+	uint8_t options_idx2;
+	uint8_t hard_address_idx2;
+	uint16_t reserved_vp2;
+	uint8_t port_name_idx2[WWN_SIZE];
+	uint8_t node_name_idx2[WWN_SIZE];
+	__le16	id;
+	uint16_t reserved_4;
+	__le16	hopct;
+	uint8_t reserved_5[66];
+};
+
+struct vp_rpt_id_entry_24xx_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+	__le32 resv1;
+	uint8_t vp_acquired;
+	uint8_t vp_setup;
+	__le16	vp_idx : 9;		/* VP Index 9bits */
+	__le16	vp_status : 7;		/* VP Status 7bits */
+
+	uint8_t port_id[3];
+	uint8_t format;
+	union {
+		struct vp_rpt_id_ext_f1 {
+			/* format 1 fabric */
+			uint8_t vpstat1_subcode; /* vp_status=1 subcode */
+			uint8_t flags;
+
+			uint16_t fip_flags;
+			uint8_t rsv2[12];
+
+			uint8_t ls_rjt_vendor;
+			uint8_t ls_rjt_explanation;
+			uint8_t ls_rjt_reason;
+			uint8_t rsv3;
+			__le16	rsv8;
+			__le16	flogi_acc_payload_size;	/* bits [8:0] meaningful */
+			uint8_t port_name[8];
+			uint8_t node_name[8];
+			uint16_t bbcr;
+			uint8_t reserved_5[6];
+		} f1;
+		struct vp_rpt_id_ext_f2 { /* format 2: N2N direct connect */
+			uint8_t vpstat1_subcode;
+			uint8_t flags;
+			uint16_t fip_flags;
+			uint8_t rsv2[12];
+
+			uint8_t ls_rjt_vendor;
+			uint8_t ls_rjt_explanation;
+			uint8_t ls_rjt_reason;
+			uint8_t rsv3[5];
+
+			uint8_t port_name[8];
+			uint8_t node_name[8];
+			uint16_t bbcr;
+			uint8_t reserved_5[2];
+			uint8_t remote_nport_id[4];
+		} f2;
+	} u;
+};
+#endif
-- 
2.47.3

