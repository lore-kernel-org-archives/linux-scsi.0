Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F5A1DE4FB
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783092; cv=none; b=EkXgTcvrLls6mibHYOrrYHXa1W1iK0o1LWq4cQpUm/mYTk+Udc1X9zBgNLpUpPWmR7FkQ5QJn5zc5r3va53e3SUrHhk4/eVs+VmX/FKyvH/U1n8Pfh4mQPwMXdLc16QL3f8+mWkgyTbITqjU4/aGLsqu0Mb0qRy7azb6rWdEMkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783092; c=relaxed/simple;
	bh=QFSEWq4NQwpNYktWurM1IuK1wf5OvFm/UUNiB1pvs3M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IsiqBAMdcxhjvhp8KBStSn5mgGnCdH80jz5zuzMMfGFBOIBLxh9OV8FVAp5cS6HFf6wfKUPwFFCFGh2yx9dKy3SrAy0Juu4RuhpLsUuNNQlQ8GDfXocMjh51oO9sDT3wUQ2FJ47btKc61XNbnmEAP0ZNCdue3VQN2e1xzLFUeT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=OpF3Jczz; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="OpF3Jczz"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w62d422860;
	Wed, 22 Jul 2026 22:04:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	hduPQDNHomOQfd166xwMAZezWUzaDZZu0J5jzKGSoU=; b=OpF3JczzfbflqvTXa
	oiPkGMFkymtckZYkAngA4CiDZd0O+/+vxHWy2b7H5xThl6N6V1mNYpe1KSv1/FnT
	4AnqHoKJvT9QrEPlv2k/r6G4OBYB+uNQ81yvfg0kfND2pl540fILfKvoOszKXyQF
	u3vGq3qlw/tKveiSwSd/YUmNEwi72GmXWYsTzqkIxcOpdJGIg7RwL8x7TgDPh19u
	IvughYb7M04tlVwR59HIoycLKiPTLXX5RKFOFVIUUTc//CN7U+JjVrKDGrzu1zSR
	L+XaDsL2dHgzz4Pf9YEuzMalh6i/4ubX0iS8CmdL+wvguLxFykObuBWLHXlxZxP1
	AQSag==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8cn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:04:46 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:04:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:04:45 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 194115C68E6;
	Wed, 22 Jul 2026 22:04:42 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 07/56] scsi: qla2xxx: Add flash block read/write BSG support for 29xx
Date: Thu, 23 Jul 2026 10:33:24 +0530
Message-ID: <20260723050413.3897522-8-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: fDkf8Oq2Joj-mn2Vlt1YPb4VOUjJSvwx
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXzWFo+m6qV/NA
 ydOJA/sIVnbcdRRoBje/GRKbe2GiB1+XtlNtCF964lq1DgIPmnhkaaOQbwI6zndWyz+lbf0vUzM
 pR6HuSD1VAifKXCKW3BwB8hfxNCOvM0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXz6KOyTz9Y2L1
 RDZG+sbAYjY2h/15GW2FnQiYa+IZVV3lcGhrpzMprTgArOqPLxOod+NmVcpBSM3g+gkI5vSsLKH
 xqOZB7goqVm66LfmMqyAZuYs+s/e9oTCfLJUceiUipgxUHeWXAbxgn3DcmwX9ep2M7AFeUCfNTk
 Ie+26dYPsvDi8YOVvWfjl3QJmxNRiU+zhevjm3DejmiyRuPQ8CAJ3/rs2qLFeKVewb/Lt5Hdp3T
 PlAaYjarLftD5GdZQsr6k8gukpMvN9EQ6Z2bNH2EdlRcgOvlONO2O0uN2NuhHkNASJo8MfeomUl
 EVtlkcbUaTwLTvtOofHx3oVobMKJitqFog2hHL1BkEcEd07Lia+r4opRXvBLSAkHAu9RCgtfvE/
 +w9+wMTGodCARfRBcSIE1LsSIZ0yiRsTNvOlny+QRigCUosaEpxH4puLxV4n9E/JBhlP5gl7YVS
 pOGj5M9r8ogkdPlp9uA==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a0ee cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=W5ZNQ9BdWYVPlAK08zEA:9 a=O8hF6Hzn-FEA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: fDkf8Oq2Joj-mn2Vlt1YPb4VOUjJSvwx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Introduce QL_VND_READ_FLASH_BLOCK and QL_VND_WRITE_FLASH_BLOCK
BSG vendor commands so that userspace tools can perform flash
block-level operations on 29xx adapters via the isp_ops
interface.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 298 ++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_bsg.h |  16 ++
 drivers/scsi/qla2xxx/qla_def.h |   7 +
 drivers/scsi/qla2xxx/qla_os.c  |  24 ++-
 4 files changed, 304 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 5e910b5ca670..b0ba927c54d7 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1407,23 +1407,14 @@ qla24xx_iidma(struct bsg_job *bsg_job)
 
 static int
 qla2x00_optrom_setup(struct bsg_job *bsg_job, scsi_qla_host_t *vha,
-	uint8_t is_update)
+	uint32_t start, uint8_t is_update)
 {
-	struct fc_bsg_request *bsg_request = bsg_job->request;
-	uint32_t start = 0;
 	int valid = 0;
 	struct qla_hw_data *ha = vha->hw;
 
 	if (unlikely(pci_channel_offline(ha->pdev)))
 		return -EINVAL;
 
-	start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
-	if (start > ha->optrom_size) {
-		ql_log(ql_log_warn, vha, 0x7055,
-		    "start %d > optrom_size %d.\n", start, ha->optrom_size);
-		return -EINVAL;
-	}
-
 	if (ha->optrom_state != QLA_SWAITING) {
 		ql_log(ql_log_info, vha, 0x7056,
 		    "optrom_state %d.\n", ha->optrom_state);
@@ -1431,42 +1422,79 @@ qla2x00_optrom_setup(struct bsg_job *bsg_job, scsi_qla_host_t *vha,
 	}
 
 	ha->optrom_region_start = start;
-	ql_dbg(ql_dbg_user, vha, 0x7057, "is_update=%d.\n", is_update);
-	if (is_update) {
-		if (ha->optrom_size == OPTROM_SIZE_2300 && start == 0)
-			valid = 1;
-		else if (start == (ha->flt_region_boot * 4) ||
-		    start == (ha->flt_region_fw * 4))
-			valid = 1;
-		else if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
-		    IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-		    IS_QLA28XX(ha))
-			valid = 1;
-		if (!valid) {
-			ql_log(ql_log_warn, vha, 0x7058,
-			    "Invalid start region 0x%x/0x%x.\n", start,
-			    bsg_job->request_payload.payload_len);
+
+	if (IS_QLA29XX(ha)) {
+		if (start > ha->optrom_size) {
+			ql_log(ql_log_warn, vha, 0x7055,
+			    "start %d > optrom_size %d.\n", start,
+			    ha->optrom_size);
 			return -EINVAL;
 		}
 
-		ha->optrom_region_size = start +
-		    bsg_job->request_payload.payload_len > ha->optrom_size ?
-		    ha->optrom_size - start :
-		    bsg_job->request_payload.payload_len;
-		ha->optrom_state = QLA_SWRITING;
+		if (is_update) {
+			ha->optrom_region_size = start +
+			    bsg_job->request_payload.payload_len >
+			    ha->optrom_size ?
+			    ha->optrom_size - start :
+			    bsg_job->request_payload.payload_len;
+			ha->optrom_state = QLA_SWRITING;
+		} else {
+			ha->optrom_region_size = start +
+			    bsg_job->reply_payload.payload_len >
+			    ha->optrom_size ?
+			    ha->optrom_size - start :
+			    bsg_job->reply_payload.payload_len;
+			ha->optrom_state = QLA_SREADING;
+		}
 	} else {
-		ha->optrom_region_size = start +
-		    bsg_job->reply_payload.payload_len > ha->optrom_size ?
-		    ha->optrom_size - start :
-		    bsg_job->reply_payload.payload_len;
-		ha->optrom_state = QLA_SREADING;
+		if (start > ha->optrom_size) {
+			ql_log(ql_log_warn, vha, 0x7055,
+			    "start %d > optrom_size %d.\n", start,
+			    ha->optrom_size);
+			return -EINVAL;
+		}
+
+		ql_dbg(ql_dbg_user, vha, 0x7057,
+		    "is_update=%d.\n", is_update);
+		if (is_update) {
+			if (ha->optrom_size == OPTROM_SIZE_2300 && start == 0)
+				valid = 1;
+			else if (start == (ha->flt_region_boot * 4) ||
+			    start == (ha->flt_region_fw * 4))
+				valid = 1;
+			else if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
+			    IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) ||
+			    IS_QLA27XX(ha) || IS_QLA28XX(ha))
+				valid = 1;
+			if (!valid) {
+				ql_log(ql_log_warn, vha, 0x7058,
+				    "Invalid start region 0x%x/0x%x.\n",
+				    start,
+				    bsg_job->request_payload.payload_len);
+				return -EINVAL;
+			}
+
+			ha->optrom_region_size = start +
+			    bsg_job->request_payload.payload_len >
+			    ha->optrom_size ?
+			    ha->optrom_size - start :
+			    bsg_job->request_payload.payload_len;
+			ha->optrom_state = QLA_SWRITING;
+		} else {
+			ha->optrom_region_size = start +
+			    bsg_job->reply_payload.payload_len >
+			    ha->optrom_size ?
+			    ha->optrom_size - start :
+			    bsg_job->reply_payload.payload_len;
+			ha->optrom_state = QLA_SREADING;
+		}
 	}
 
 	ha->optrom_buffer = vzalloc(ha->optrom_region_size);
 	if (!ha->optrom_buffer) {
 		ql_log(ql_log_warn, vha, 0x7059,
-		    "Read: Unable to allocate memory for optrom retrieval "
-		    "(%x)\n", ha->optrom_region_size);
+		    "%s: Unable to allocate memory for optrom retrieval (%x)\n",
+		    __func__, ha->optrom_region_size);
 
 		ha->optrom_state = QLA_SWAITING;
 		return -ENOMEM;
@@ -1478,17 +1506,25 @@ qla2x00_optrom_setup(struct bsg_job *bsg_job, scsi_qla_host_t *vha,
 static int
 qla2x00_read_optrom(struct bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
+	uint32_t start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	int rval = 0;
 
 	if (ha->flags.nic_core_reset_hdlr_active)
 		return -EBUSY;
 
+	if (IS_QLA29XX(ha)) {
+		ql_log(ql_log_warn, vha, 0x7070,
+		    "Legacy optrom read not supported on 29xx.\n");
+		return -EINVAL;
+	}
+
 	mutex_lock(&ha->optrom_mutex);
-	rval = qla2x00_optrom_setup(bsg_job, vha, 0);
+	rval = qla2x00_optrom_setup(bsg_job, vha, start, 0);
 	if (rval) {
 		mutex_unlock(&ha->optrom_mutex);
 		return rval;
@@ -1515,14 +1551,16 @@ qla2x00_read_optrom(struct bsg_job *bsg_job)
 static int
 qla2x00_update_optrom(struct bsg_job *bsg_job)
 {
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
+	uint32_t start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	int rval = 0;
 
 	mutex_lock(&ha->optrom_mutex);
-	rval = qla2x00_optrom_setup(bsg_job, vha, 1);
+	rval = qla2x00_optrom_setup(bsg_job, vha, start, 1);
 	if (rval) {
 		mutex_unlock(&ha->optrom_mutex);
 		return rval;
@@ -1554,6 +1592,182 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
 	return rval;
 }
 
+/**
+ * qla29xx_bsg_flash_block_read - Read flash block for QLA29XX.
+ * @bsg_job: BSG job structure.
+ *
+ * Returns 0 on success, error code on failure.
+ */
+static int qla29xx_bsg_flash_block_read(struct bsg_job *bsg_job)
+{
+	struct fc_bsg_request *bsg_req = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_block_rw *brcmd;
+	void *buf;
+	uint16_t opts = 0;
+	int rval = 0;
+
+	if (bsg_job->request_len < sizeof(struct fc_bsg_request) +
+	    2 * sizeof(uint32_t) + sizeof(struct qla_block_rw))
+		return -EINVAL;
+
+	brcmd =
+	(struct qla_block_rw *)&bsg_req->rqst_data.h_vendor.vendor_cmd[2];
+
+	ql_log(ql_log_info, vha, 0x7062,
+	       "%s: region 0x%x options 0x%x rw_length 0x%x offset 0x%x chunk_length 0x%x\n",
+		__func__, brcmd->region, brcmd->options, brcmd->rw_length,
+		brcmd->region_offset, brcmd->chunk_length);
+
+	if (brcmd->region > U16_MAX) {
+		ql_log(ql_log_warn, vha, 0x7066,
+		       "%s: invalid region 0x%x\n", __func__, brcmd->region);
+		return -EINVAL;
+	}
+
+	mutex_lock(&ha->optrom_mutex);
+	rval = qla2x00_optrom_setup(bsg_job, vha, brcmd->region_offset, 0);
+	if (rval) {
+		mutex_unlock(&ha->optrom_mutex);
+		return rval;
+	}
+
+	check_and_set_mbc_bits(brcmd->options, opts, QLA_IS_TIM, BIT_15);
+	check_and_set_mbc_bits(brcmd->options, opts, QLA_IS_SECURE, BIT_7);
+	check_and_set_mbc_bits(brcmd->options, opts, QLA_UPDATE_MBR, BIT_8);
+
+	if (!ha->isp_ops->read_optrom_region) {
+		vfree(ha->optrom_buffer);
+		ha->optrom_buffer = NULL;
+		ha->optrom_state = QLA_SWAITING;
+		mutex_unlock(&ha->optrom_mutex);
+		return -EINVAL;
+	}
+
+	buf = ha->isp_ops->read_optrom_region(vha, brcmd->region, opts,
+				ha->optrom_buffer, ha->optrom_region_start,
+				ha->optrom_region_size);
+	if (!buf) {
+		ql_log(ql_log_warn, vha, 0x7063,
+			"%s failed to read flash region 0x%x\n",
+			__func__, brcmd->region);
+		bsg_reply->result = -EINVAL;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+							EXT_STATUS_MAILBOX;
+		bsg_reply->reply_payload_rcv_len = 0;
+	} else {
+		bsg_reply->result = DID_OK;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+			EXT_STATUS_OK;
+
+		ql_dump_buffer(ql_dbg_user + ql_dbg_verbose, vha, 0x72a6,
+			       ha->optrom_buffer, ha->optrom_region_size);
+
+		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+				    bsg_job->reply_payload.sg_cnt,
+				    ha->optrom_buffer,
+				    ha->optrom_region_size);
+
+		bsg_reply->reply_payload_rcv_len = ha->optrom_region_size;
+	}
+	vfree(ha->optrom_buffer);
+	ha->optrom_buffer = NULL;
+	ha->optrom_state = QLA_SWAITING;
+	mutex_unlock(&ha->optrom_mutex);
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+
+	return 0;
+}
+
+/**
+ * qla29xx_bsg_flash_block_write - Write flash block for QLA29XX.
+ * @bsg_job: BSG job structure.
+ *
+ * Returns 0 on success, error code on failure.
+ */
+static int qla29xx_bsg_flash_block_write(struct bsg_job *bsg_job)
+{
+	struct fc_bsg_request *bsg_req = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_block_rw *bwcmd;
+	uint16_t opts = 0;
+	int rval = 0;
+
+	if (bsg_job->request_len < sizeof(struct fc_bsg_request) +
+	    2 * sizeof(uint32_t) + sizeof(struct qla_block_rw))
+		return -EINVAL;
+
+	bwcmd =
+	   (struct qla_block_rw *)&bsg_req->rqst_data.h_vendor.vendor_cmd[2];
+
+	ql_log(ql_log_info, vha, 0x7064,
+	       "%s: region 0x%x options 0x%x rw_length 0x%x offset 0x%x chunk_length 0x%x\n",
+		__func__, bwcmd->region, bwcmd->options, bwcmd->rw_length,
+		bwcmd->region_offset, bwcmd->chunk_length);
+
+	if (bwcmd->region > U16_MAX) {
+		ql_log(ql_log_warn, vha, 0x7067,
+		       "%s: invalid region 0x%x\n", __func__, bwcmd->region);
+		return -EINVAL;
+	}
+
+	mutex_lock(&ha->optrom_mutex);
+	rval = qla2x00_optrom_setup(bsg_job, vha, bwcmd->region_offset, 1);
+	if (rval) {
+		mutex_unlock(&ha->optrom_mutex);
+		return rval;
+	}
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+			bsg_job->request_payload.sg_cnt, ha->optrom_buffer,
+			ha->optrom_region_size);
+
+	ql_dump_buffer(ql_dbg_user + ql_dbg_verbose, vha, 0x73a6,
+		       ha->optrom_buffer, ha->optrom_region_size);
+
+	check_and_set_mbc_bits(bwcmd->options, opts, QLA_IS_TIM, BIT_15);
+	check_and_set_mbc_bits(bwcmd->options, opts, QLA_IS_SECURE, BIT_7);
+	check_and_set_mbc_bits(bwcmd->options, opts, QLA_UPDATE_MBR, BIT_8);
+
+	if (!ha->isp_ops->write_optrom_region) {
+		vfree(ha->optrom_buffer);
+		ha->optrom_buffer = NULL;
+		ha->optrom_state = QLA_SWAITING;
+		mutex_unlock(&ha->optrom_mutex);
+		return -EINVAL;
+	}
+
+	rval = ha->isp_ops->write_optrom_region(vha, bwcmd->region, opts,
+				ha->optrom_buffer, ha->optrom_region_start,
+				ha->optrom_region_size);
+	if (rval) {
+		ql_log(ql_log_warn, vha, 0x7065,
+			"%s failed to write flash %x\n", __func__, rval);
+		bsg_reply->result = -EINVAL;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+							EXT_STATUS_MAILBOX;
+	} else {
+		bsg_reply->result = DID_OK;
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+			EXT_STATUS_OK;
+	}
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
 static int
 qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 {
@@ -3007,6 +3221,12 @@ qla2x00_process_vendor_specific(struct scsi_qla_host *vha, struct bsg_job *bsg_j
 	case QL_VND_MBX_PASSTHRU:
 		return qla2x00_mailbox_passthru(bsg_job);
 
+	case QL_VND_READ_FLASH_BLOCK:
+		return qla29xx_bsg_flash_block_read(bsg_job);
+
+	case QL_VND_WRITE_FLASH_BLOCK:
+		return qla29xx_bsg_flash_block_write(bsg_job);
+
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index a920c8e482bc..ca0d83986b57 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -40,6 +40,8 @@
 #define QL_VND_MBX_PASSTHRU		0x2B
 #define QL_VND_DPORT_DIAGNOSTICS_V2	0x2C
 #define QL_VND_IMG_SET_VALID	0x30
+#define QL_VND_READ_FLASH_BLOCK		0x33
+#define QL_VND_WRITE_FLASH_BLOCK	0x34
 
 /* BSG Vendor specific subcode returns */
 #define EXT_STATUS_OK			0
@@ -83,6 +85,20 @@
 #define ELS_OPCODE_BYTE			0x10
 
 /* BSG Vendor specific definations */
+
+#define QLA_IS_TIM	0x1
+#define QLA_IS_SECURE	0x2
+#define QLA_UPDATE_MBR	0x4
+
+struct qla_block_rw {
+	uint32_t region;
+	uint32_t rw_length;
+	uint32_t options;
+	uint32_t region_offset;
+	uint32_t chunk_length;
+	uint8_t  reserved[44];
+} __packed;
+
 #define A84_ISSUE_WRITE_TYPE_CMD        0
 #define A84_ISSUE_READ_TYPE_CMD         1
 #define A84_CLEANUP_CMD                 2
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1ec7ee578e0c..719b6a1f9123 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3534,6 +3534,13 @@ struct isp_operations {
 	int (*write_optrom)(struct scsi_qla_host *, void *, uint32_t,
 		uint32_t);
 
+	void *(*read_optrom_region)(struct scsi_qla_host *vha,
+		uint16_t reg_code, uint16_t opts, void *buf,
+		uint32_t offset, uint32_t length);
+	int (*write_optrom_region)(struct scsi_qla_host *vha,
+		uint16_t reg_code, uint16_t opts, void *buf,
+		uint32_t offset, uint32_t length);
+
 	int (*get_flash_version) (struct scsi_qla_host *, void *);
 	int (*start_scsi) (srb_t *);
 	int (*start_scsi_mq) (srb_t *);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6560e58ad87c..948242f0088e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2640,6 +2640,24 @@ static struct isp_operations qla27xx_isp_ops = {
 	.initialize_adapter	= qla2x00_initialize_adapter,
 };
 
+static void *
+qla29xx_read_optrom_stub(struct scsi_qla_host *vha, void *buf,
+			 uint32_t offset, uint32_t length)
+{
+	ql_dbg(ql_dbg_init, vha, 0x0191,
+	    "read_optrom not supported on 29xx, use read_optrom_region.\n");
+	return NULL;
+}
+
+static int
+qla29xx_write_optrom_stub(struct scsi_qla_host *vha, void *buf,
+			  uint32_t offset, uint32_t length)
+{
+	ql_dbg(ql_dbg_init, vha, 0x0192,
+	    "write_optrom not supported on 29xx, use write_optrom_region.\n");
+	return QLA_FUNCTION_FAILED;
+}
+
 static struct isp_operations qla29xx_isp_ops = {
 	.pci_config		= qla25xx_pci_config,
 	.reset_chip		= qla24xx_reset_chip,
@@ -2670,8 +2688,10 @@ static struct isp_operations qla29xx_isp_ops = {
 	.beacon_on		= qla24xx_beacon_on,
 	.beacon_off		= qla24xx_beacon_off,
 	.beacon_blink		= qla83xx_beacon_blink,
-	.read_optrom		= qla25xx_read_optrom_data,
-	.write_optrom		= qla24xx_write_optrom_data,
+	.read_optrom		= qla29xx_read_optrom_stub,
+	.write_optrom		= qla29xx_write_optrom_stub,
+	.read_optrom_region	= qla29xx_read_optrom_data,
+	.write_optrom_region	= qla29xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi_mq		= qla2xxx_dif_start_scsi_mq,
 	.abort_isp		= qla2x00_abort_isp,
-- 
2.47.3

