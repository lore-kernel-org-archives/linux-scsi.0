Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A88B27FD74
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 15:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861496; cv=none; b=hL0T6niSX+c+XvhJbnrqyLa6OGSVAbEgGLaGx1gwmPYXkzApkORfm1kq5EVyVAHQD3lLar775mhokoN5Ocdk5yiWrxNH1CsuHHwyrHG7wNMqIoMvVQ+JGrl2hQoAKRw4MvayBiVZkLdNTYjKo0Ku7W4dLAzSktMs/01KHu45G3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861496; c=relaxed/simple;
	bh=XnRz87Smm5yk3/nAhm3fE03CZKpIZUu5LXbUziAa45g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tHoqceWe5froWN1eovcJJ7mMfIWIFgPlA5MJzXZL304uQpZip4+3kB1UkBInhOfjoa0GPUGsdzTHrg3E/rAP92B6CUjUMK7qCXEgRXky6ELgKLMKC3L76ayf83M0+ihmONMzswOe3QELdCDt9nVlQEJmLH7IRtMxesvxa+vImE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=BjMyX9VW; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="BjMyX9VW"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B3NrmJ41015282;
	Thu, 4 Dec 2025 07:18:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=C
	nWI/2rlITpelAAL2I69JRN/Fe/YGmvyv2fxJtRihgw=; b=BjMyX9VWFOzt6ZJw1
	znc2wpFCIod6fyP9watxd9ouiWsoHJvKz1+hl+V6jUJzj8pkXcU8ZsSQDzgRT4Rk
	hRkQnaZJ6i3pmWxuXxQnB+nZW2EpE3At8TL3D4h67Aske796edpOZHbSXuRTL6WL
	Z82syG1imVNlygvut3htdIDyJXUFo2XnTwKeQCsUucBThBeOhshXkZJT9Ts6z9rS
	Y+4qrnoy2QYmjZ3Hh9+V6DNhZdkpjjHm1HzLYziwxuJMxBfyJxEAYHAYMYDGyzkW
	6u++ZD83BPqF4UXItjniFhkBHdtQPBLOXT0yhA985gultdZkSMS85G8HL+IcrWDf
	Tw4ag==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4atjuu3n44-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Dec 2025 07:18:12 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 4 Dec 2025 07:18:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 4 Dec 2025 07:18:24 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 4324A3F7074;
	Thu,  4 Dec 2025 07:18:09 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 05/12] qla2xxx: Add bsg interface to support firmware img validation
Date: Thu, 4 Dec 2025 20:47:44 +0530
Message-ID: <20251204151751.2321801-6-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251204151751.2321801-1-njavali@marvell.com>
References: <20251204151751.2321801-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA0MDEyMyBTYWx0ZWRfXylcXI+b64MEP
 75wt44VPgXJRXFRXB3Cmgj/LQxpwNorg2BBIoWYcoP0EPYQcbA4ZzZ2ICmjL/LwCGFZh8vYa+/X
 ENszocoVSJerZG4OSflH4+7iyi7qbEvallo56Y2J2YfVet8loVj7pHYWYvF17r9xu+bpVMJbxJ3
 ekmniTwZycj4QEXkMUV86LuJISP2PaL7GX/mH4O1Ap4VhT5D+YHGiK4hWMWuJOYW177Lwi5w+Zv
 dSmtaD9YplZWVEK5GS8ieMuFJ6mFAD5V2GO3uUhcWaF4mO026pU4BFPT7W7YlThqZKPWPgDVkfA
 9uKdCjWJcoEZjpDcvXKrWic7Z0G+PfAsaarzg/NKnsg38xh8MfpEkWN7q3oguuw3YBcACveh517
 DFhALL0M5ni6T7G2ccjVYJjFiTVoYA==
X-Proofpoint-ORIG-GUID: ZgRiuDNpSC8rJ8lz0vxOakKAY1wilt__
X-Proofpoint-GUID: ZgRiuDNpSC8rJ8lz0vxOakKAY1wilt__
X-Authority-Analysis: v=2.4 cv=E/nAZKdl c=1 sm=1 tr=0 ts=6931a634 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=pGLkceISAAAA:8
 a=VM1oBaI6kV5Rzjb4Zc4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_03,2025-12-04_01,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Add new bsg interface to issue MPI
passthrough sub command to validate
the newly flash firmware image partition.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 118 +++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h |  12 ++++
 drivers/scsi/qla2xxx/qla_def.h |  20 ++++++
 drivers/scsi/qla2xxx/qla_gbl.h |   2 +
 drivers/scsi/qla2xxx/qla_mbx.c |  40 +++++++++++
 5 files changed, 192 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index ccfc2d26dd37..8afa8a4b8ccb 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -11,6 +11,8 @@
 #include <linux/delay.h>
 #include <linux/bsg-lib.h>
 
+static int qla28xx_validate_flash_image(struct bsg_job *bsg_job);
+
 static void qla2xxx_free_fcport_work(struct work_struct *work)
 {
 	struct fc_port *fcport = container_of(work, typeof(*fcport),
@@ -2549,6 +2551,30 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
 	return 0;
 }
 
+static int
+qla2x00_get_drv_attr(struct bsg_job *bsg_job)
+{
+	struct qla_drv_attr drv_attr;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+
+	memset(&drv_attr, 0, sizeof(struct qla_drv_attr));
+	drv_attr.ext_attributes |= QLA_IMG_SET_VALID_SUPPORT;
+
+
+	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+			bsg_job->reply_payload.sg_cnt, &drv_attr,
+			sizeof(struct qla_drv_attr));
+
+	bsg_reply->reply_payload_rcv_len = sizeof(struct qla_drv_attr);
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
+
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	bsg_reply->result = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
+
+	return 0;
+}
+
 static int
 qla2x00_manage_host_stats(struct bsg_job *bsg_job)
 {
@@ -2933,6 +2959,12 @@ qla2x00_process_vendor_specific(struct scsi_qla_host *vha, struct bsg_job *bsg_j
 	case QL_VND_GET_FLASH_UPDATE_CAPS:
 		return qla27xx_get_flash_upd_cap(bsg_job);
 
+	case QL_VND_GET_DRV_ATTR:
+		return qla2x00_get_drv_attr(bsg_job);
+
+	case QL_VND_IMG_SET_VALID:
+		return qla28xx_validate_flash_image(bsg_job);
+
 	case QL_VND_SET_FLASH_UPDATE_CAPS:
 		return qla27xx_set_flash_upd_cap(bsg_job);
 
@@ -3246,3 +3278,89 @@ int qla2x00_mailbox_passthru(struct bsg_job *bsg_job)
 
 	return ret;
 }
+
+static int
+qla28xx_do_validate_flash_image(struct bsg_job *bsg_job, uint16_t *state)
+{
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
+	uint16_t mstate[16];
+	uint16_t mpi_state = 0;
+	uint16_t img_idx;
+	int rval = QLA_SUCCESS;
+
+	memset(mstate, 0, sizeof(mstate));
+
+	rval = qla2x00_get_firmware_state(vha, mstate);
+	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0xffff,
+				"MBC to get MPI state failed (%d)\n", rval);
+		rval = -EINVAL;
+		goto exit_flash_img;
+	}
+
+	mpi_state = mstate[11];
+
+	if (!(mpi_state & BIT_9 && mpi_state & BIT_8 && mpi_state & BIT_15)) {
+		ql_log(ql_log_warn, vha, 0xffff,
+				"MPI firmware state failed (0x%02x)\n", mpi_state);
+		rval = -EINVAL;
+		goto exit_flash_img;
+	}
+
+	rval = qla81xx_fac_semaphore_access(vha, FAC_SEMAPHORE_LOCK);
+	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0xffff,
+				"Unable to lock flash semaphore.");
+		goto exit_flash_img;
+	}
+
+	img_idx = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
+
+	rval = qla_mpipt_validate_fw(vha, img_idx, state);
+	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0xffff,
+				"Failed to validate Firmware image index [0x%x].\n",
+				img_idx);
+	}
+
+	qla81xx_fac_semaphore_access(vha, FAC_SEMAPHORE_UNLOCK);
+
+exit_flash_img:
+	return rval;
+}
+
+static int qla28xx_validate_flash_image(struct bsg_job *bsg_job)
+{
+	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t state = 0;
+	int rval = 0;
+
+	if (!IS_QLA28XX(ha) || vha->vp_idx != 0)
+		return -EPERM;
+
+	mutex_lock(&ha->optrom_mutex);
+	rval = qla28xx_do_validate_flash_image(bsg_job, &state);
+	if (rval)
+		rval = -EINVAL;
+	mutex_unlock(&ha->optrom_mutex);
+
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+
+	if (rval)
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+			(state == 39) ? EXT_STATUS_IMG_SET_VALID_ERR :
+			EXT_STATUS_IMG_SET_CONFIG_ERR;
+	else
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
+
+	bsg_reply->result = DID_OK << 16;
+	bsg_reply->reply_payload_rcv_len = 0;
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	bsg_job_done(bsg_job, bsg_reply->result,
+			bsg_reply->reply_payload_rcv_len);
+
+	return QLA_SUCCESS;
+}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index d38dab0a07e8..a920c8e482bc 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -32,12 +32,14 @@
 #define QL_VND_GET_PRIV_STATS_EX	0x1A
 #define QL_VND_SS_GET_FLASH_IMAGE_STATUS	0x1E
 #define QL_VND_EDIF_MGMT                0X1F
+#define QL_VND_GET_DRV_ATTR		0x22
 #define QL_VND_MANAGE_HOST_STATS	0x23
 #define QL_VND_GET_HOST_STATS		0x24
 #define QL_VND_GET_TGT_STATS		0x25
 #define QL_VND_MANAGE_HOST_PORT		0x26
 #define QL_VND_MBX_PASSTHRU		0x2B
 #define QL_VND_DPORT_DIAGNOSTICS_V2	0x2C
+#define QL_VND_IMG_SET_VALID	0x30
 
 /* BSG Vendor specific subcode returns */
 #define EXT_STATUS_OK			0
@@ -50,6 +52,8 @@
 #define EXT_STATUS_BUFFER_TOO_SMALL	16
 #define EXT_STATUS_NO_MEMORY		17
 #define EXT_STATUS_DEVICE_OFFLINE	22
+#define EXT_STATUS_IMG_SET_VALID_ERR	47
+#define EXT_STATUS_IMG_SET_CONFIG_ERR	48
 
 /*
  * To support bidirectional iocb
@@ -318,6 +322,14 @@ struct qla_active_regions {
 	uint8_t reserved[31];
 } __packed;
 
+struct qla_drv_attr {
+        uint32_t        attributes;
+        u32             ext_attributes;
+#define QLA_IMG_SET_VALID_SUPPORT       BIT_4
+        u32             status_flags;
+        uint8_t         reserved[20];
+} __packed;
+
 #include "qla_edif_bsg.h"
 
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index cac4745b012e..907f6db234e3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1386,6 +1386,26 @@ static inline bool qla2xxx_is_valid_mbs(unsigned int mbs)
 #define HCS_WRITE_SERDES		0x3
 #define HCS_READ_SERDES			0x4
 
+/*
+ * ISP2[7|8]xx mailbox commands.
+ */
+#define MBC_MPI_PASSTHROUGH            0x200
+
+/* MBC_MPI_PASSTHROUGH */
+#define MPIPT_REQ_V1 1
+enum {
+       MPIPT_SUBCMD_GET_SUP_CMD = 0x10,
+       MPIPT_SUBCMD_GET_SUP_FEATURE,
+       MPIPT_SUBCMD_GET_STATUS,
+       MPIPT_SUBCMD_VALIDATE_FW,
+};
+
+enum {
+       MPIPT_MPI_STATUS = 1,
+       MPIPT_FCORE_STATUS,
+       MPIPT_LOCKDOWN_STATUS,
+};
+
 /* Firmware return data sizes */
 #define FCAL_MAP_SIZE	128
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 87fa1e3eabf4..2ee6c4b60589 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -842,6 +842,8 @@ extern int qla82xx_write_optrom_data(struct scsi_qla_host *, void *,
 extern int qla82xx_abort_isp(scsi_qla_host_t *);
 extern int qla82xx_restart_isp(scsi_qla_host_t *);
 
+extern int qla_mpipt_validate_fw(scsi_qla_host_t *vha, u16 img_idx, u16 *state);
+
 /* IOCB related functions */
 extern int qla82xx_start_scsi(srb_t *);
 extern void qla2x00_sp_free(srb_t *sp);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2a856965eb3b..26851ca2a074 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -7203,3 +7203,43 @@ int qla_mailbox_passthru(scsi_qla_host_t *vha,
 
 	return rval;
 }
+
+int qla_mpipt_validate_fw(scsi_qla_host_t *vha, u16 img_idx, uint16_t *state)
+{
+	struct qla_hw_data *ha = vha->hw;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	int rval;
+
+	if (!IS_QLA28XX(ha)) {
+		ql_dbg(ql_dbg_mbx, vha, 0xffff, "%s %d\n", __func__, __LINE__);
+		return QLA_FUNCTION_FAILED;
+	}
+
+	if (img_idx > 1) {
+		ql_log(ql_log_info, vha, 0xffff,
+				"%s %d Invalid flash image index [%d]\n",
+				__func__, __LINE__, img_idx);
+		return QLA_INVALID_COMMAND;
+	}
+
+	memset(&mc, 0, sizeof(mc));
+	mcp->mb[0] = MBC_MPI_PASSTHROUGH;
+	mcp->mb[1] = MPIPT_SUBCMD_VALIDATE_FW;
+	mcp->mb[2] = img_idx;
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_2|MBX_1|MBX_0;
+
+	/* send mb via iocb */
+	rval = qla24xx_send_mb_cmd(vha, &mc);
+	if (rval) {
+		ql_log(ql_log_info, vha, 0xffff, "%s:Failed %x (mb=%x,%x)\n",
+				__func__, rval, mcp->mb[0], mcp->mb[1]);
+		*state = mcp->mb[1];
+	} else {
+		ql_log(ql_log_info, vha, 0xffff, "%s: mb=%x,%x,%x\n", __func__,
+				mcp->mb[0], mcp->mb[1], mcp->mb[2]);
+	}
+
+	return rval;
+}
-- 
2.23.1

