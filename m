Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAD5368D43
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258062; cv=none; b=IwYy4umpeEN646PKrX7s/a3Tlx9/pkny85bAVd33gm1r96EqYILW9Lq31mIXF4V9xYazEx1ng7YbmZ8LkkZIzcqPYXzkuyUAs6BB4mhg/1ia2INnyBtPzzetGR9r1Px4A3v+I3LqWHQMOCM2MuQmRIt7Y+bEnwSuUyxZ1GOL3yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258062; c=relaxed/simple;
	bh=gF+bSgWlSV1ZpoT/bbcqaRADB5rPXo586v9OeV/CgwE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JkL1vz285+HbqkZxEqmzepUZjT1MeqPvmXq5dJVPpzBhb8q4V2XikoMd3lF2E7J19KU0fQ9d6CpM04H4DJycXyRroT4IpGnmrHRJEEQ98mUi7DYhPeEjjgFPBHA9iRvAmuo7DeTisi/JneiNfA61HGqkGV6x+j7iwZ0b+ww375A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=YyeRSWk1; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YyeRSWk1"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C5FeYW273805;
	Fri, 12 Jun 2026 02:54:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=R
	JYpyBVYERzW4TsbJQyWPcw4RvgeVW9a9njNOxshZ6M=; b=YyeRSWk1awdujmk1S
	fOIinwfCzG6+jNsgVgymiXGRu3IBfdZrhDDfJ2N8ky8z4bPXKzsNcwlm6C5PgQNp
	NhQoBvRgG9APl3V6DO64EmT9G72o+oUdmlnjc/qSsRBrDpKwa5mkYUNBWyjwq2x2
	L5BEcYayc0HqaxtnVdqDodmdqRzjnGLwZ4qAZqslZKyuKnf+JBVvvPftzy9KcUnD
	Y+rzwzL7alNVpsRnKA8EoT4gSe5K2tVd0ijyA7UcCsY7PC7ye6ggHQ/0IBv/VtQX
	8j8hwiwR2kWw6hPBCd7ID7eaLnCWMZIy8WZXXdENt5avlGXxavLlzJ4Ju1xCuckA
	df+Iw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5r6rsp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:54:17 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:54:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:54:16 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3103A3F7040;
	Fri, 12 Jun 2026 02:54:13 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 07/60] scsi: qla2xxx: Add flash block read/write BSG support for 29xx
Date: Fri, 12 Jun 2026 15:22:40 +0530
Message-ID: <20260612095333.1666592-8-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXypEKlSmeijuJ
 zRjqJjRnT5ItBj9XCwESIev7pfWuOfMPLtjFwpQipSAJhYNNs+W6d4YdGJnDuVHW1gcxhkfCVDy
 sf9jzdq4KVcDIrgBY5akAf+wgsKYXog=
X-Authority-Analysis: v=2.4 cv=O6gJeh9W c=1 sm=1 tr=0 ts=6a2bd749 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=W5ZNQ9BdWYVPlAK08zEA:9
 a=O8hF6Hzn-FEA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: mnWDN5KW_fuDMqDQoXPEctkeuPbLBoQG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXwY0DkaJJKCV0
 emWtIhi4OkUZyGS8LuQZsO+aIbZCxDq9xSNyNS7H3w2SED/aA5Icg1qH86vD4JwsIzNlQA1ROhZ
 Advh/wRFI6sBCs63V+erHdyU30+s43NA14hCi0hQpAuErK0hKSdgAJRZrqtBsCjdZQ1WeQT536u
 xgAMBTdmHB2yQ+pap/fFJft6LwEZai1te6yUF9GwCQUkUfMeBLOxKttpSWNPlL0JoJRvMt7Wre3
 FFVocvs7kkkG/SfPChTRgrllnVFbxhzTz/1f4QKDzGwJh6B6iVyUD/aMTYHvltPd/gWvXxIhMlT
 52ApSG+5Z6f+aJ3JxjF9Rtgya1TOxdjL5Wp8qFDSJOAWVF6XVSI9Tb8y1bx30zxOpMvhmRXky/W
 dYbRvMdN8srDRy7E5g8Rka5zcvZFoPwuXpJKDiUGu/Ypz4xDrWf1w7uRq+/BGdbUQahrUWFdEgY
 /G35OS55BLesRh9vg/w==
X-Proofpoint-ORIG-GUID: mnWDN5KW_fuDMqDQoXPEctkeuPbLBoQG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Introduce QL_VND_READ_FLASH_BLOCK and QL_VND_WRITE_FLASH_BLOCK
BSG vendor commands so that userspace tools can perform flash
block-level operations on 29xx adapters via the isp_ops
interface.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   1 -
 drivers/scsi/qla2xxx/qla_bsg.c  | 286 +++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_bsg.h  |  16 ++
 drivers/scsi/qla2xxx/qla_def.h  |   7 +
 drivers/scsi/qla2xxx/qla_os.c   |  24 ++-
 5 files changed, 292 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 6a05ce195aa0..800751ab562a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -580,7 +580,6 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobject *kobj,
 	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
 	mutex_unlock(&ha->optrom_mutex);
 
-	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
 skip:
 	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);
 }
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 5e910b5ca670..0baf486e8fb8 100644
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
@@ -1554,6 +1592,170 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
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
+	return rval;
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
@@ -3007,6 +3209,12 @@ qla2x00_process_vendor_specific(struct scsi_qla_host *vha, struct bsg_job *bsg_j
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

