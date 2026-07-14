Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0248A445ACC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022879; cv=none; b=mVD7B6GNt/EIGePXfMKtSCOlUz7f0UOQsuTzjgc93FxmDcxW62FA8wp5GkXulAe3H6hoWChKZEzHp0Fq6lu1jkX8BArV8bYZENOZlieDX6iMMY+bfQdXoeXkFit1RRnnEVJ3mG0DtB7KT2+usVVIYoPBGQuI2U64yM8v2Qil6Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022879; c=relaxed/simple;
	bh=50JCE9IVCBDLrCs+DPKjkMeUHuk/ZbdJS5yZuWmL5Ug=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pOpKh2eA68tMLBjz1aTvtbBi+I3ap2j05Xff1SfozGI/z2EhH0Lml6wxHxOwpXZHj79MhLCZGRlvhq8xPLJp+mPe81IC4lIx/ijeo0sMOgXp5FVkrWnHWM6Bx2KdsB7N4iftl/0Vl59LKoR0iepdK60N5aXb1IdhbFK3BrbEJco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=B55K7F0H; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="B55K7F0H"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UiI33693335;
	Tue, 14 Jul 2026 02:54:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=C
	2vke2ICXa8lPPJCRry+kQDp1kYJ2yQP9v6kLLHyIGA=; b=B55K7F0H0HhZmU8jB
	BLoLNq9cmw6mITWxWpLYTjDJxNkL3jggmvfhQvXV1TFpu3Kc9z8T9ISsUI37uUtO
	mun5QmhWHrxV3ynPKuT8ktlvL5rHHW0LehiLNRAU4KRResXlbmU0BjFxAuZqUeeL
	GSZ9yDLkBMBf0wW/uV17eoWij57XXR1XZM+Okvy1forEHcD1QWLeRRWQTKqkjAFG
	NOhOQxH9nN7/lB9HjY2dGZnZGHwE7xl4nYYdbpRXtt5S3RKMoj1YXsR8320Jl7jk
	7WB705dtRnXjjWitZxexWRhpMthBl0GpR6ARAc8einEHTDd4o+pHcT7b4MDPwN4Y
	V53RQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8gm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:54:30 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:54:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:54:29 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A3F835E6867;
	Tue, 14 Jul 2026 02:54:26 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 08/56] scsi: qla2xxx: Add BSG MPI firmware load/dump for 29xx
Date: Tue, 14 Jul 2026 15:23:05 +0530
Message-ID: <20260714095353.289460-9-njavali@marvell.com>
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
X-Proofpoint-GUID: ksAQt6XQ4G79ouVhsuqMaAdjWHKScbHF
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a560756 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=Isfp46XGf30kw2XteiEA:9 a=O8hF6Hzn-FEA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: ksAQt6XQ4G79ouVhsuqMaAdjWHKScbHF
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX9WFP2vw7S0NO
 XXjo0+RIo6U3UFoNJlM38MQ79A/hm4E90q8QDQCQfNdEObyNW4jk5cR43QHf3nJQgypKJZ8Ui7B
 QPy8hd7hiztWHCQU959jDIfYuXUVGsI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX8HqgZ0CZt5GT
 n4b0LpHsSjQ66VD9228QnsJw4sep/Zg7kve14PeKR0oD1eDpT6YB6I3ezR+NuXxUlwNqPTZpB9t
 b8hKxlFD0nQbq5iKxfMfq/nB/o0UU5Mt4ka6IByIHlJYbARTe/HxQIMRUwcQb7+tmBwvfjzRSee
 ZUnJNgWLTH7zUjGmI4pMdJeRJg7SohNV1eMIOeg6EU3fDBzRmpbH6OFb2kWqqQ5gmMBB9/azrGH
 L53PMlmFuT44OM5wUn79KPhpzxg0Yo5nsk97BPlG7aA2+XDQrxTjHc6DGL9pLBWpmfc2SQhLqrz
 xZHPlBkn1cOT+rGMNwBSaH/GYI1cLIxAm6Y0E5BmxUiiFJgJ1kxvlN8QSp5JTdPJtP3PR/2wLkj
 Ohz30hAxuesTWm4DFRdDguOUweAanB4yQLHHPftYAXopAQqBmyV5lgJdahEfO2a2zUq+1TIrr4c
 gO/WoVW6BZZ1t/t+2VA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Add BSG vendor commands for loading and dumping MPI firmware on
29xx adapters.  This extends the existing BSG infrastructure with
the necessary mailbox wrappers and flash helpers for MPI
operations.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 203 +++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h |  18 +++
 drivers/scsi/qla2xxx/qla_def.h |   5 +
 drivers/scsi/qla2xxx/qla_gbl.h |   5 +
 drivers/scsi/qla2xxx/qla_mbx.c |  45 ++++++++
 drivers/scsi/qla2xxx/qla_sup.c | 117 +++++++++++++++++++
 6 files changed, 393 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 92a1af81c057..5dd7e5e969ab 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1820,6 +1820,203 @@ static int qla29xx_bsg_flash_block_write(struct bsg_job *bsg_job)
 	return 0;
 }
 
+static int
+qla29xx_mpi_optrom_setup(struct bsg_job *bsg_job, scsi_qla_host_t *vha,
+	uint32_t start, uint8_t is_update)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return -EINVAL;
+
+	if (ha->optrom_state != QLA_SWAITING) {
+		ql_log(ql_log_info, vha, 0x7068,
+		       "optrom_state %d.\n", ha->optrom_state);
+		return -EBUSY;
+	}
+
+	ha->optrom_region_start = start;
+	if (is_update) {
+		ha->optrom_region_size = bsg_job->request_payload.payload_len;
+		ha->optrom_state = QLA_SWRITING;
+	} else {
+		ha->optrom_region_size = bsg_job->reply_payload.payload_len;
+		ha->optrom_state = QLA_SREADING;
+	}
+
+	ha->optrom_buffer = vzalloc(ha->optrom_region_size);
+	if (!ha->optrom_buffer) {
+		ql_log(ql_log_warn, vha, 0x7069,
+		       "%s: Unable to allocate memory for optrom retrieval (%x)\n",
+		       __func__, ha->optrom_region_size);
+		ha->optrom_state = QLA_SWAITING;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int qla2900_bsg_dump_mpi(struct bsg_job *bsg_job)
+{
+	struct fc_bsg_request *bsg_req = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_load_dump_mpi *dmcmd;
+	uint16_t opts = 0;
+	int rval = 0;
+
+	if (bsg_job->request_len < sizeof(struct fc_bsg_request) +
+	    2 * sizeof(uint32_t) + sizeof(struct qla_load_dump_mpi))
+		return -EINVAL;
+
+	if (!IS_QLA29XX(ha)) {
+		ql_log(ql_log_warn, vha, 0x706c,
+		       "%s: MPI dump not supported on this adapter.\n",
+		       __func__);
+		return -EINVAL;
+	}
+
+	dmcmd =
+	(struct qla_load_dump_mpi *)&bsg_req->rqst_data.h_vendor.vendor_cmd[2];
+
+	ql_log(ql_log_info, vha, 0xffff,
+	       "%s: mpi_address 0x%x mpi options 0x%x length 0x%x\n",
+		__func__, dmcmd->mpi_address, dmcmd->options, dmcmd->length);
+
+	mutex_lock(&ha->optrom_mutex);
+	rval = qla29xx_mpi_optrom_setup(bsg_job, vha, dmcmd->mpi_address, 1);
+	if (rval) {
+		mutex_unlock(&ha->optrom_mutex);
+		return rval;
+	}
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+			  bsg_job->request_payload.sg_cnt, ha->optrom_buffer,
+			  ha->optrom_region_size);
+
+	ql_dump_buffer(ql_dbg_init, vha, 0x00d7, ha->optrom_buffer,
+			ha->optrom_region_size);
+
+	check_and_set_mbc_bits(dmcmd->options, opts, QLA_LDM_SECURE_ENABLE,
+			       BIT_3);
+	check_and_set_mbc_bits(dmcmd->options, opts, QLA_LDM_OTP_PROV, BIT_4);
+	check_and_set_mbc_bits(dmcmd->options, opts, QLA_LDM_DEV_CSR, BIT_5);
+	check_and_set_mbc_bits(dmcmd->options, opts, QLA_LDM_AUTH_CMD_BIN,
+			       BIT_6);
+	check_and_set_mbc_bits(dmcmd->options, opts, QLA_LDM_MLDSA_ALGO,
+			       BIT_9);
+
+	rval = qla29xx_mpi_optrom_data(vha, opts, ha->optrom_buffer,
+				       ha->optrom_region_start,
+				       ha->optrom_region_size,
+				       QLA29XX_MPI_OP_DUMP);
+	if (rval) {
+		ql_log(ql_log_warn, vha, 0xffff,
+			"%s failed mpi dump %x\n", __func__, rval);
+		bsg_reply->result = -EINVAL;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+							EXT_STATUS_MAILBOX;
+	} else {
+		bsg_reply->result = DID_OK;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+			EXT_STATUS_OK;
+	}
+
+	vfree(ha->optrom_buffer);
+	ha->optrom_buffer = NULL;
+	ha->optrom_state = QLA_SWAITING;
+	mutex_unlock(&ha->optrom_mutex);
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	bsg_job_done(bsg_job, bsg_reply->result,
+			bsg_reply->reply_payload_rcv_len);
+	return 0;
+}
+
+static int qla2900_bsg_load_mpi(struct bsg_job *bsg_job)
+{
+	struct fc_bsg_request *bsg_req = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_load_dump_mpi *lmcmd;
+	uint16_t opts = 0;
+	int rval = 0;
+
+	if (bsg_job->request_len < sizeof(struct fc_bsg_request) +
+	    2 * sizeof(uint32_t) + sizeof(struct qla_load_dump_mpi))
+		return -EINVAL;
+
+	if (!IS_QLA29XX(ha)) {
+		ql_log(ql_log_warn, vha, 0x706d,
+		       "%s: MPI load not supported on this adapter.\n",
+		       __func__);
+		return -EINVAL;
+	}
+
+	lmcmd =
+	(struct qla_load_dump_mpi *)&bsg_req->rqst_data.h_vendor.vendor_cmd[2];
+
+	ql_log(ql_log_info, vha, 0xffff,
+	       "%s: mpi_address 0x%x mpi options 0x%x length 0x%x\n",
+		__func__, lmcmd->mpi_address, lmcmd->options, lmcmd->length);
+
+	mutex_lock(&ha->optrom_mutex);
+	rval = qla29xx_mpi_optrom_setup(bsg_job, vha, lmcmd->mpi_address, 0);
+	if (rval) {
+		mutex_unlock(&ha->optrom_mutex);
+		return rval;
+	}
+
+	check_and_set_mbc_bits(lmcmd->options, opts, QLA_LDM_SECURE_ENABLE,
+			       BIT_3);
+	check_and_set_mbc_bits(lmcmd->options, opts, QLA_LDM_DEV_CSR, BIT_5);
+	check_and_set_mbc_bits(lmcmd->options, opts, QLA_LDM_SHADOW_REGS,
+			       BIT_7);
+	check_and_set_mbc_bits(lmcmd->options, opts, QLA_LDM_CA_CSR, BIT_8);
+	check_and_set_mbc_bits(lmcmd->options, opts, QLA_LDM_MLDSA_ALGO,
+			       BIT_9);
+	check_and_set_mbc_bits(lmcmd->options, opts, QLA_LDM_MLDSA_SIGNATURE,
+			       BIT_10);
+
+	rval = qla29xx_mpi_optrom_data(vha, opts, ha->optrom_buffer,
+				       ha->optrom_region_start,
+				       ha->optrom_region_size,
+				       QLA29XX_MPI_OP_LOAD);
+	if (rval) {
+		ql_log(ql_log_warn, vha, 0xffff,
+			"%s failed mpi load %x\n", __func__, rval);
+		bsg_reply->result = -EINVAL;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+							EXT_STATUS_MAILBOX;
+	} else {
+		bsg_reply->result = DID_OK;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+			EXT_STATUS_OK;
+	}
+
+	ql_dump_buffer(ql_dbg_init, vha, 0x00d7, ha->optrom_buffer,
+			ha->optrom_region_size);
+
+	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+			    bsg_job->reply_payload.sg_cnt,
+			    ha->optrom_buffer,
+			    ha->optrom_region_size);
+
+	bsg_reply->reply_payload_rcv_len = ha->optrom_region_size;
+	vfree(ha->optrom_buffer);
+	ha->optrom_buffer = NULL;
+	ha->optrom_state = QLA_SWAITING;
+	mutex_unlock(&ha->optrom_mutex);
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+
+	return rval;
+}
+
 static int
 qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 {
@@ -3279,6 +3476,12 @@ qla2x00_process_vendor_specific(struct scsi_qla_host *vha, struct bsg_job *bsg_j
 	case QL_VND_WRITE_FLASH_BLOCK:
 		return qla29xx_bsg_flash_block_write(bsg_job);
 
+	case QL_VND_LOAD_MPI:
+		return qla2900_bsg_load_mpi(bsg_job);
+
+	case QL_VND_DUMP_MPI:
+		return qla2900_bsg_dump_mpi(bsg_job);
+
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index ca0d83986b57..8a784b8226cc 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -42,6 +42,8 @@
 #define QL_VND_IMG_SET_VALID	0x30
 #define QL_VND_READ_FLASH_BLOCK		0x33
 #define QL_VND_WRITE_FLASH_BLOCK	0x34
+#define QL_VND_LOAD_MPI			0x35
+#define QL_VND_DUMP_MPI			0x36
 
 /* BSG Vendor specific subcode returns */
 #define EXT_STATUS_OK			0
@@ -99,6 +101,22 @@ struct qla_block_rw {
 	uint8_t  reserved[44];
 } __packed;
 
+struct qla_load_dump_mpi {
+	uint32_t mpi_address;
+	uint32_t length;
+	uint32_t options;
+#define	QLA_LDM_SECURE_ENABLE	0x1
+#define	QLA_LDM_OTP_PROV	0x2
+#define	QLA_LDM_DEV_CSR		0x4
+#define	QLA_LDM_AUTH_CMD_BIN	0x8
+#define	QLA_LDM_SHADOW_REGS	0x10
+#define	QLA_LDM_CA_CSR		0x20
+#define	QLA_LDM_MLDSA_ALGO	0x40
+#define	QLA_LDM_MLDSA_SIGNATURE	0x80
+
+	uint8_t reserved[52];
+} __packed;
+
 #define A84_ISSUE_WRITE_TYPE_CMD        0
 #define A84_ISSUE_READ_TYPE_CMD         1
 #define A84_CLEANUP_CMD                 2
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 719b6a1f9123..7423687578dc 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1548,6 +1548,11 @@ typedef struct {
 #define PD_STATE_PORT_LOGOUT			10
 #define PD_STATE_WAIT_PORT_LOGOUT_ACK		11
 
+enum qla29xx_mpi_optrom_op {
+	QLA29XX_MPI_OP_DUMP,
+	QLA29XX_MPI_OP_LOAD,
+};
+
 
 #define QLA_ZIO_MODE_6		(BIT_2 | BIT_1)
 #define QLA_ZIO_DISABLED	0
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 120a7b1bb217..106f95a4e7f0 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -699,6 +699,11 @@ extern int qla29xx_write_optrom_data(struct scsi_qla_host *vha,
 				     uint32_t length);
 int qla29xx_get_flash_region(struct scsi_qla_host *vha, uint32_t code,
 			     struct qla_flt_region_data *region);
+extern int qla29xx_mpi_optrom_data(struct scsi_qla_host *vha, uint16_t opts,
+				   void *buf, uint32_t offset, uint32_t length,
+				   enum qla29xx_mpi_optrom_op op);
+extern int qla29xx_load_dump_mpi(scsi_qla_host_t *vha, uint16_t opt,
+				 uint32_t mpi_addr, uint32_t dlen, dma_addr_t req_dma);
 /*
  * Global Function Prototypes in qla_dbg.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d49dacf6d576..9c2633ca5036 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -7415,3 +7415,48 @@ int qla29xx_flash_block_write(scsi_qla_host_t *vha, dma_addr_t req_dma,
 
 	return rval;
 }
+
+int
+qla29xx_load_dump_mpi(scsi_qla_host_t *vha, uint16_t opt, uint32_t mpi_addr,
+		      uint32_t dlen, dma_addr_t req_dma)
+{
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	int rval = 0;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0xffff,
+	       "Entered %s mpi_addr 0x%x len 0x%x opt 0x%x.\n",
+		__func__, mpi_addr, dlen, opt);
+
+	memset(mcp->mb, 0, sizeof(mcp->mb));
+
+	mcp->mb[0] = MBC_LOAD_DUMP_MPI_RAM;
+	mcp->mb[9] = opt;
+	mcp->mb[1] = LSW(mpi_addr);
+	mcp->mb[8] = MSW(mpi_addr);
+
+	mcp->mb[2] = MSW(req_dma);
+	mcp->mb[3] = LSW(req_dma);
+	mcp->mb[6] = MSW(MSD(req_dma));
+	mcp->mb[7] = LSW(MSD(req_dma));
+
+	mcp->mb[4] = MSW(dlen);
+	mcp->mb[5] = LSW(dlen);
+
+	mcp->out_mb = MBX_9|MBX_8|MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS)
+		ql_dbg(ql_dbg_mbx, vha, 0x110a,
+		       "Failed=%x mb=(0x%x,0x%x).\n",
+			rval, mcp->mb[0], mcp->mb[1]);
+	else
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x110b,
+		       "Done %s mb=(0x%x,0x%x,0x%x).\n", __func__,
+		       mcp->mb[0], mcp->mb[1],  mcp->mb[2]);
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 51ea481c68eb..255aa3c731a2 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -543,6 +543,123 @@ qla29xx_read_optrom_data(struct scsi_qla_host *vha, uint16_t reg_code,
 	return NULL;
 }
 
+static void set_chunk_mpi_bits(uint16_t *options, int count, int total)
+{
+	/* - Single chunk complete segment/image
+	 * - 1st chunk of a segment/image
+	 * - Last chunk of a segment/image
+	 */
+	if (total == 1)
+		*options |= BIT_2 | BIT_1;
+	else if (count == 0)
+		*options |= BIT_1;
+	else if (count == total - 1)
+		*options |= BIT_2;
+}
+
+/**
+ * qla29xx_mpi_optrom_data - Dump/load MPI optrom data for 29xx.
+ * @vha: Pointer to SCSI QLogic host structure.
+ * @opts: Options for the operation.
+ * @buf: Buffer to read from/write to.
+ * @offset: Offset into the device memory.
+ * @length: Length of data, in bytes.
+ * @op: Operation, either QLA29XX_MPI_OP_DUMP or QLA29XX_MPI_OP_LOAD.
+ *
+ * Returns:
+ * QLA_SUCCESS on success or an error code on failure.
+ */
+int
+qla29xx_mpi_optrom_data(struct scsi_qla_host *vha, uint16_t opts, void *buf,
+		       uint32_t offset, uint32_t length, enum qla29xx_mpi_optrom_op op)
+{
+	struct qla_hw_data *ha = vha->hw;
+	dma_addr_t optrom_dma;
+	void *optrom;
+	uint32_t mpi_addr, mpi_size, burst = 0;
+	uint32_t total_chunks = 0;
+	uint32_t *dcode, *fwcode;
+	uint32_t chunk_count = 0;
+	int rval = -EINVAL;
+
+	optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
+				    &optrom_dma, GFP_KERNEL);
+	if (!optrom) {
+		ql_log(ql_log_warn, vha, 0x0090,
+			"Unable to allocate memory for optrom burst read (%x KB).\n",
+			OPTROM_BURST_SIZE / 1024);
+		rval = -ENOMEM;
+		goto exit_mpi_op;
+	}
+
+	mpi_addr = offset;
+	dcode = (uint32_t *)optrom;
+	memset(dcode, 0, OPTROM_BURST_SIZE);
+
+	fwcode = (uint32_t *)buf;
+	mpi_size = length >> 2;
+	burst = OPTROM_BURST_SIZE >> 2;
+	total_chunks = (mpi_size + burst - 1) / burst;
+
+	while (mpi_size > 0) {
+		uint16_t options = 0;
+
+		if (burst > mpi_size)
+			burst = mpi_size;
+
+		set_chunk_mpi_bits(&options, chunk_count, total_chunks);
+
+		if (op == QLA29XX_MPI_OP_DUMP) {
+			options |= (BIT_0);
+			options |= opts;
+
+			ql_log(ql_log_info, vha, 0x008b,
+				"-> %s (DUMP): %#x <-(%#x words) (0x%x options) chunk (0x%x, 0x%x)\n",
+				__func__, mpi_addr, burst, options, chunk_count,
+				total_chunks);
+
+			memcpy(dcode, fwcode, burst * 4);
+
+			rval = qla29xx_load_dump_mpi(vha, options, mpi_addr, burst,
+						     optrom_dma);
+			if (rval) {
+				ql_log(ql_log_fatal, vha, 0x0098,
+					"Failed dump mpi firmware.\n");
+				goto free_buf;
+			}
+		} else if (op == QLA29XX_MPI_OP_LOAD) {
+			options |= opts;
+
+			ql_log(ql_log_info, vha, 0x008b,
+				"-> %s (LOAD): %#x <-(%#x words) (0x%x options) chunk (0x%x, 0x%x)\n",
+				__func__, mpi_addr, burst, options, chunk_count,
+				total_chunks);
+
+			rval = qla29xx_load_dump_mpi(vha, options, mpi_addr, burst,
+						     optrom_dma);
+			if (rval) {
+				ql_log(ql_log_fatal, vha, 0x0098,
+					"Failed load mpi firmware.\n");
+				goto free_buf;
+			}
+			memcpy(fwcode, dcode, burst * 4);
+		}
+
+		chunk_count++;
+		fwcode += burst;
+		mpi_addr += burst;
+		mpi_size -= burst;
+	}
+
+	rval = QLA_SUCCESS;
+free_buf:
+	dma_free_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE, optrom,
+			  optrom_dma);
+
+exit_mpi_op:
+	return rval;
+}
+
 /*
  * NVRAM support routines
  */
-- 
2.47.3

