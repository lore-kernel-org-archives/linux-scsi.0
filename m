Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AA0386571
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403952; cv=none; b=aZgC0bOVhVMVNrM4mzIHBwc38xjk7IHOq0xYQszKVnBEr1S5dLbBpHB3NycHt33GbvK7dKjDr8gYPgh96rkWRWiHWB4b3i1+Ru0Uge6om2pHaZxh0f/RncFMzv1rvU8IGN2mWOO3oM9qJBeP8pMTHpUWYpAQJBdezXE20QMZ1Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403952; c=relaxed/simple;
	bh=T92l5F+eerzsH/PJkkpAcft/mRT94xPabQsMmPoQqD4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hR+wsv/IV1IIyA7s3zfkCx/49xm4L3RpU2naZnIL3kvPEhFHbff291VecX38HWrhumfvvN0JTVRNEH9y3Qcpza8sFXK3SDfrF593DfrXNkxpA9KK4Q1ZOkTyiSo8uuREWfJcZR+Lo9z7ZXiXmW6vJjRyG5hOx9D1bdSWgTSLNe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=b8KbzmkG; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="b8KbzmkG"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747glZ854300;
	Mon, 6 Jul 2026 22:59:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=m
	Iu12G1e16kuiAaPMR7DJ7V59fuwKEOM6LD7a/aWVqY=; b=b8KbzmkGYcDK6cwdM
	t8xTH6aQCINYK9y32cTof7DjuDS+YRFUbtqheZK6bWB2xLBC1P4v6NOCvW56CrnW
	VWYitJnNsu5DtaQ4B+t+JgTehZVdtYr6s7nz1za0k6U4aEhTqOvkTJnNgi4XW5tv
	u5nzOx/5nVF4wJGh9zpDUm8EOkHNJhBub75olKnmYWSWdvvwZT4mUMtnHKSUgtdx
	rs42GFD7JmxKXlJd5s/eDGQ7+h6pKN0cJhYeC+aKAufAGWfJ1hwFkEhLpSJ0IcyY
	KTbtoNR3IvPl9vWlIukU8KFQSJkhLuN9ezlhQSfEjIDmhiiifFWfRqQ/CdD2CtfW
	L5IMQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0qat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:59:07 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:59:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:59:06 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 929593F7066;
	Mon,  6 Jul 2026 22:59:04 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 85/88] scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]
Date: Tue, 7 Jul 2026 11:24:32 +0530
Message-ID: <20260707055435.2680300-86-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX6YUhMa7bKXzE
 OB7zCKrFPwmFJGL0XsVlav0d/kt3znkLT5TmvV4iOjwT8AWqSjoCmbtgevdnDInzqn2gmMC3jXe
 BsNdZM6AXUlp1ENNT1N/jItyYcW+y/1YiANhrZ32dsDlcROY1K7iX9A/fYpaVpgaUqVxvj+hdij
 J7+eyMD7iS2ncKlzCUvxzTWFhzbEcsIeghFjTzya0tGDLN+KELtXr46uIvA+wqnG1+OmjFq0pyr
 cHUiCOBf8Y+cg0/GGDxyEQ3nCB6REaL0zIl0/uPFCdUxt2UptNqOUOnyzCOhchjVC1v2j1EXcEP
 2qHZe03S9+fVRb3i3rRS14j1c6Cxym6ZGDgp0E7Bkl8qQIQzi7GGlncbNsY/3g1dKbjdMIyfHEc
 X9AbMnhYY35leHkjFEKoyCKZpD8PnyN0wUPc/QfUoTdGPLh9RdcbsoMNu3dy6okWVV2tOUvFL6Z
 tQ1vc0yP1Teon73+p1w==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c95ab cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=lDlMmypVyh5eTQNAPEUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXwa3Tur0njOMy
 q73ztBAEXSqpmIWZp3uRvunDM92K/QRyaPexEvPeJqr50QkYWQZV+Uv3kt+R9aYkFmMV4dpr7jI
 iQ3cjQBUAIqW7jm0KZmODop89pmoJLE=
X-Proofpoint-ORIG-GUID: yaWx8jnO79NcoF5xHOANsiPGVeHXhgut
X-Proofpoint-GUID: yaWx8jnO79NcoF5xHOANsiPGVeHXhgut
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

The FC BSG transport allocates job->request via memdup_user() using the
exact user-supplied request_len. For FC_BSG_HST_VENDOR,
fc_bsg_host_dispatch() only guarantees request_len covers msgcode and
vendor_id; it does not account for the vendor_cmd[] flexible array.

qla2xxx then reads the command selector vendor_cmd[0] and, in several
sub-handlers, vendor_cmd[1]/[2] or structures overlaid on the vendor
command area without verifying request_len. A caller holding
CAP_SYS_RAWIO can submit a short request whose vendor_id matches the
host, triggering out-of-bounds heap reads (KASAN-detectable, and able to
mis-select a command or panic).

Add a central guard in qla2x00_process_vendor_specific() so the selector
is always in bounds, restrict the early vendor_cmd[0] read in
qla24xx_bsg_request() to sufficiently long vendor messages, and add
request_len checks to the sub-handlers that read further:
qla24xx_proc_fcp_prio_cfg_cmd(), qla2x00_process_loopback(),
qla84xx_reset(), qla84xx_updatefw(), qla2x00_read_optrom(),
qla2x00_update_optrom(), qlafx00_mgmt_cmd() and
qla28xx_validate_flash_image().

Fixes: 01e0e15c8b3b ("scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 57 +++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index cb7227298b24..e671c3de8c05 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -160,6 +160,12 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 		goto exit_fcp_prio_cfg;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t)) {
+		ret = -EINVAL;
+		goto exit_fcp_prio_cfg;
+	}
+
 	/* Get the sub command */
 	oper = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
@@ -758,6 +764,10 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 		return -EIO;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 3 * sizeof(uint32_t))
+		return -EINVAL;
+
 	memset(&elreq, 0, sizeof(elreq));
 
 	elreq.req_sg_cnt = dma_map_sg(&ha->pdev->dev,
@@ -990,6 +1000,10 @@ qla84xx_reset(struct bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	flag = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 	rval = qla84xx_reset_chip(vha, flag == A84_ISSUE_RESET_DIAG_FW);
@@ -1034,6 +1048,10 @@ qla84xx_updatefw(struct bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!sg_cnt) {
@@ -1511,9 +1529,15 @@ qla2x00_read_optrom(struct bsg_job *bsg_job)
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
-	uint32_t start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
+	uint32_t start;
 	int rval = 0;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
+	start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
+
 	if (ha->flags.nic_core_reset_hdlr_active)
 		return -EBUSY;
 
@@ -1556,9 +1580,15 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
-	uint32_t start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
+	uint32_t start;
 	int rval = 0;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
+	start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
+
 	mutex_lock(&ha->optrom_mutex);
 	rval = qla2x00_optrom_setup(bsg_job, vha, start, 1);
 	if (rval) {
@@ -2397,6 +2427,11 @@ qlafx00_mgmt_cmd(struct bsg_job *bsg_job)
 	struct fc_port *fcport;
 	char  *type = "FC_BSG_HST_FX_MGMT";
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(uint32_t) +
+	    sizeof(struct qla_mt_iocb_rqst_fx00))
+		return -EINVAL;
+
 	/* Copy the IOCB specific information */
 	piocb_rqst = (struct qla_mt_iocb_rqst_fx00 *)
 	    &bsg_request->rqst_data.h_vendor.vendor_cmd[1];
@@ -3318,6 +3353,13 @@ qla2x00_process_vendor_specific(struct scsi_qla_host *vha, struct bsg_job *bsg_j
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(uint32_t)) {
+		ql_log(ql_log_warn, vha, 0x7000,
+		       "BSG request too small for vendor cmd.\n");
+		return -EINVAL;
+	}
+
 	ql_dbg(ql_dbg_edif, vha, 0x911b, "%s FC_BSG_HST_VENDOR cmd[0]=0x%x\n",
 	    __func__, bsg_request->rqst_data.h_vendor.vendor_cmd[0]);
 
@@ -3461,8 +3503,11 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 	}
 
 	/* Disable port will bring down the chip, allow enable command */
-	if (bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_MANAGE_HOST_PORT ||
-	    bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_GET_HOST_STATS)
+	if (bsg_request->msgcode == FC_BSG_HST_VENDOR &&
+	    bsg_job->request_len >=
+		sizeof(struct fc_bsg_request) + sizeof(uint32_t) &&
+	    (bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_MANAGE_HOST_PORT ||
+	     bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_GET_HOST_STATS))
 		goto skip_chip_chk;
 
 	if (vha->hw->flags.port_isolated) {
@@ -3771,6 +3816,10 @@ static int qla28xx_validate_flash_image(struct bsg_job *bsg_job)
 	if (!IS_QLA28XX(ha) || vha->vp_idx != 0)
 		return -EPERM;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	mutex_lock(&ha->optrom_mutex);
 	rval = qla28xx_do_validate_flash_image(bsg_job, &state);
 	if (rval)
-- 
2.47.3

