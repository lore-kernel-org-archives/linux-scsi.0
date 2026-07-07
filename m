Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C4C202C48
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403749; cv=none; b=CIYvprMelgss5WMJ6GYuevzzpe2YWjXb1Xi6aOx8Ev3Ke8yFIgoYqZVk9YVfda1QiH+am/RAlkBy51GTbMKP13jfuMnmZaB/crC0Ov7GshHPoMxTffJ/4WFh3MrneOuXdo7kkd1reb2/wJG7FQ2P7qu/IJ7aarrVWhotjN5ShWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403749; c=relaxed/simple;
	bh=U1D583t1OZQ5aRJZ93r4+rRZh+7XqZIvpxYFQgHd+Vc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IyJ7/hJ4FBQtUHGj33zqox5QYfVSVSsbw/Mr1aaRk28Ubbg/Fv8lTb2loFo8xv4fZ89la4OFUb1vSM+6yoBA7cOiRRV0NdaW+us8qDsBkGggue6Crvw7KDDZyoKntFXFNMgN5+D9Cbh4oQeKIu2XscfR4Y89axN7yiJklLz8yDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=XSBgn50n; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="XSBgn50n"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748fQ31656206;
	Mon, 6 Jul 2026 22:55:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=K
	wKD05ZzEEq+hhCSNK8wD3FPDKNsubkX1eOs+zrO+OA=; b=XSBgn50nAUxDITp4I
	ys7uRixDw+1G1n1TYndptPyV72MNIGgyeyCeLYTxQQw1K1YwZjV94WVWI2cvvmSD
	dEmAVqrj/7SbSKjsoetB4ujRoU1VXrxC1VGYWMNfZZ5r60M+kl2C7z4lkGtZL4xq
	Qqi7wSEOYQavphma4xP5x6rqH+LFmNGr6j66pTihfmej0OtxWiGG1xd9fcNXYtQ6
	fl6GhUUPnFbOzkvPXBLDO3wYlJG+KNOYjU+zXe915aRf3KWBE2ELvEp4gGCE8M3j
	hI5vQx5rTtMXmXEcRwbD77F68hKIFykUxc+fBqyEJ/L4dglfejF/mZdcz0FntdRr
	V+QMw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqdub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:45 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:45 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 56B353F7066;
	Mon,  6 Jul 2026 22:55:42 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 15/88] scsi: qla2xxx: Extend execute_fw mailbox to include 29xx
Date: Tue, 7 Jul 2026 11:23:22 +0530
Message-ID: <20260707055435.2680300-16-njavali@marvell.com>
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
X-Proofpoint-GUID: 5rh7Vk7nzwNcFH7pocyR8vYqzjDjkun1
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c94e1 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=WWqGWK72s1XPCDKfqbsA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 5rh7Vk7nzwNcFH7pocyR8vYqzjDjkun1
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX6OiojMNBIdny
 1rGvFc1zTXePq5xI33BDbJI0NIM6QVaO4lCNJf7LUk8XtZl93FScCcivzFl1UnE4dsoeRJb9S9n
 5UZ+NY9PNtaCCRy53l/7HRXJBSvFBws=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX9poeJ0+nRVyC
 ARkZgrN+f0oo+6OBPIVXXbwf2bjrwMHxGE4IL2YskBd7SJSzEulK3d3TysAp4JpGKiMY+6j9svp
 ypcjWpLhVw7xzTK03VpAHEi3RS5nth3aoUjerWQNsotLARhPAbbnQcDmXa5MnbNmZMR/hcCjhn9
 7MlRxOqXTuYUWlW6eh9KVr/T9EwbIBPT7MEYb0Ew43uOxYFVMwUKa0UVfkL7IxxVtdnAzI/Eg37
 D0fdr1SzoaiTELMAhZJZKkr1efeXdjMAek+qTSAorLW3pSoco1iJTIXZmIO2fiAwJ1/JcZFClkq
 tinwIPG9BK9+S86PE9yo4RNgG8h38W/C3lnbF+zDG0doa/7AE7/6tNwmUUnvVHqQroswx6A9MiO
 MF1bQHBzD7a5vC7rKYcXK9o8g/vvQAZFr7ZVgvTt9AxPtzYwi7/1W9kikItdCu14RHY9M0uPeG7
 fIbyH6O7U1P/ZZS/plQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

Add IS_QLA29XX() to the BPM capability macros and to the
execute-firmware mailbox command so that NVMe enable, minimum
speed negotiation, 128 Gbps speed reporting, EDIF hardware
detection, and FW-semaphore retry logic all apply to 29xx
adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 12 ++++++++++--
 drivers/scsi/qla2xxx/qla_def.h  |  5 +++--
 drivers/scsi/qla2xxx/qla_gs.c   | 16 +++++++++++++---
 drivers/scsi/qla2xxx/qla_isr.c  |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 23 +++++++++++++----------
 5 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index c44f5282abb3..7b7722de2844 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1784,10 +1784,11 @@ qla2x00_min_supported_speed_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
 
 	return scnprintf(buf, PAGE_SIZE, "%s\n",
+	    ha->min_supported_speed == 7 ? "128Gps" :
 	    ha->min_supported_speed == 6 ? "64Gps" :
 	    ha->min_supported_speed == 5 ? "32Gps" :
 	    ha->min_supported_speed == 4 ? "16Gps" :
@@ -1803,10 +1804,11 @@ qla2x00_max_supported_speed_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
 
 	return scnprintf(buf, PAGE_SIZE, "%s\n",
+	    ha->max_supported_speed  == 3 ? "128Gps" :
 	    ha->max_supported_speed  == 2 ? "64Gps" :
 	    ha->max_supported_speed  == 1 ? "32Gps" :
 	    ha->max_supported_speed  == 0 ? "16Gps" : "unknown");
@@ -1887,6 +1889,7 @@ static const struct {
 	{ PORT_SPEED_16GB, "16" },
 	{ PORT_SPEED_32GB, "32" },
 	{ PORT_SPEED_64GB, "64" },
+	{ PORT_SPEED_128GB, "128" },
 	{ PORT_SPEED_10GB, "10" },
 };
 
@@ -2668,6 +2671,9 @@ qla2x00_get_host_speed(struct Scsi_Host *shost)
 	case PORT_SPEED_64GB:
 		speed = FC_PORTSPEED_64GBIT;
 		break;
+	case PORT_SPEED_128GB:
+		speed = FC_PORTSPEED_128GBIT;
+		break;
 	default:
 		speed = FC_PORTSPEED_UNKNOWN;
 		break;
@@ -3429,6 +3435,8 @@ qla2x00_get_host_supported_speeds(scsi_qla_host_t *vha, uint speeds)
 {
 	uint supported_speeds = FC_PORTSPEED_UNKNOWN;
 
+	if (speeds & FDMI_PORT_SPEED_128GB)
+		supported_speeds |= FC_PORTSPEED_128GBIT;
 	if (speeds & FDMI_PORT_SPEED_64GB)
 		supported_speeds |= FC_PORTSPEED_64GBIT;
 	if (speeds & FDMI_PORT_SPEED_32GB)
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index fcd185807e2b..0bbe2bae7101 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4333,6 +4333,7 @@ struct qla_hw_data {
 #define PORT_SPEED_16GB 0x05
 #define PORT_SPEED_32GB 0x06
 #define PORT_SPEED_64GB 0x07
+#define PORT_SPEED_128GB 0x08
 #define PORT_SPEED_10GB	0x13
 	uint16_t	link_data_rate;         /* F/W operating speed */
 	uint16_t	set_data_rate;		/* Set by user */
@@ -5581,9 +5582,9 @@ struct sff_8247_a0 {
 /* BPM -- Buffer Plus Management support. */
 #define IS_BPM_CAPABLE(ha) \
 	(IS_QLA25XX(ha) || IS_QLA81XX(ha) || IS_QLA83XX(ha) || \
-	 IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	 IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 #define IS_BPM_RANGE_CAPABLE(ha) \
-	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 #define IS_BPM_ENABLED(vha) \
 	(ql2xautodetectsfp && !vha->vp_idx && IS_BPM_CAPABLE(vha->hw))
 
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 880cd73feaca..514f04aa1423 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1508,12 +1508,18 @@ qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
 
 	if (IS_CNA_CAPABLE(ha))
 		return FDMI_PORT_SPEED_10GB;
-	if (IS_QLA28XX(ha) || IS_QLA27XX(ha)) {
-		if (ha->max_supported_speed == 2) {
+	if (IS_QLA28XX(ha) || IS_QLA27XX(ha) || IS_QLA29XX(ha)) {
+		if (ha->max_supported_speed == 3) {
+			if (ha->min_supported_speed <= 7)
+				speeds |= FDMI_PORT_SPEED_128GB;
+		}
+		if (ha->max_supported_speed == 3 ||
+		    ha->max_supported_speed == 2) {
 			if (ha->min_supported_speed <= 6)
 				speeds |= FDMI_PORT_SPEED_64GB;
 		}
-		if (ha->max_supported_speed == 2 ||
+		if (ha->max_supported_speed == 3 ||
+		    ha->max_supported_speed == 2 ||
 		    ha->max_supported_speed == 1) {
 			if (ha->min_supported_speed <= 5)
 				speeds |= FDMI_PORT_SPEED_32GB;
@@ -1577,6 +1583,8 @@ qla25xx_fdmi_port_speed_currently(struct qla_hw_data *ha)
 		return FDMI_PORT_SPEED_32GB;
 	case PORT_SPEED_64GB:
 		return FDMI_PORT_SPEED_64GB;
+	case PORT_SPEED_128GB:
+		return FDMI_PORT_SPEED_128GB;
 	default:
 		return FDMI_PORT_SPEED_UNKNOWN;
 	}
@@ -2620,6 +2628,8 @@ qla2x00_port_speed_capability(uint16_t speed)
 		return PORT_SPEED_32GB;
 	case BIT_7:
 		return PORT_SPEED_64GB;
+	case BIT_6:
+		return PORT_SPEED_128GB;
 	default:
 		return PORT_SPEED_UNKNOWN;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e95fb0e59f38..26722afa937c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -652,7 +652,7 @@ const char *
 qla2x00_get_link_speed_str(struct qla_hw_data *ha, uint16_t speed)
 {
 	static const char *const link_speeds[] = {
-		"1", "2", "?", "4", "8", "16", "32", "64", "10"
+		"1", "2", "?", "4", "8", "16", "32", "64", "128", "10"
 	};
 #define	QLA_LAST_SPEED (ARRAY_SIZE(link_speeds) - 1)
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0feb98b83293..52d70b61654c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -699,6 +699,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 {
 	int rval;
 	struct qla_hw_data *ha = vha->hw;
+	struct nvram_81xx *nv = ha->nvram;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	u8 semaphore = 0;
@@ -727,14 +728,13 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 				    ha->lr_distance << LR_DIST_FW_POS;
 		}
 
-		if (ql2xnvmeenable && (IS_QLA27XX(ha) || IS_QLA28XX(ha)))
+		if (ql2xnvmeenable && (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)))
 			mcp->mb[4] |= NVME_ENABLE_FLAG;
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-			struct nvram_81xx *nv = ha->nvram;
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			/* set minimum speed if specified in nvram */
 			if (nv->min_supported_speed >= 2 &&
-			    nv->min_supported_speed <= 5) {
+			    nv->min_supported_speed <= 7) {
 				mcp->mb[4] |= BIT_4;
 				mcp->mb[11] |= nv->min_supported_speed & 0xF;
 				mcp->out_mb |= MBX_11;
@@ -772,7 +772,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		if (IS_QLA28XX(ha) && rval == QLA_COMMAND_ERROR &&
+		if ((IS_QLA28XX(ha) || IS_QLA29XX(ha)) && rval == QLA_COMMAND_ERROR &&
 		    mcp->mb[1] == 0x27 && retry) {
 			semaphore = 1;
 			retry--;
@@ -800,17 +800,20 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 	ql_dbg(ql_dbg_mbx, vha, 0x119a,
 	    "fw_ability_mask=%x.\n", ha->fw_ability_mask);
 	ql_dbg(ql_dbg_mbx, vha, 0x1027, "exchanges=%x.\n", mcp->mb[1]);
-	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-		ha->max_supported_speed = mcp->mb[2] & (BIT_0|BIT_1);
+
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
+		ha->max_supported_speed = mcp->mb[2] & (BIT_0|BIT_1|BIT_2|BIT_3);
 		ql_dbg(ql_dbg_mbx, vha, 0x119b, "max_supported_speed=%s.\n",
 		    ha->max_supported_speed == 0 ? "16Gps" :
 		    ha->max_supported_speed == 1 ? "32Gps" :
-		    ha->max_supported_speed == 2 ? "64Gps" : "unknown");
+		    ha->max_supported_speed == 2 ? "64Gps" :
+		    ha->max_supported_speed == 3 ? "128Gps" : "unknown");
 		if (vha->min_supported_speed) {
 			ha->min_supported_speed = mcp->mb[5] &
-			    (BIT_0 | BIT_1 | BIT_2);
+			    (BIT_0 | BIT_1 | BIT_2 | BIT_3);
 			ql_dbg(ql_dbg_mbx, vha, 0x119c,
 			    "min_supported_speed=%s.\n",
+			    ha->min_supported_speed == 7 ? "128Gps" :
 			    ha->min_supported_speed == 6 ? "64Gps" :
 			    ha->min_supported_speed == 5 ? "32Gps" :
 			    ha->min_supported_speed == 4 ? "16Gps" :
@@ -819,7 +822,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		}
 	}
 
-	if (IS_QLA28XX(ha) && (mcp->mb[5] & EDIF_HW_SUPPORT)) {
+	if ((IS_QLA28XX(ha) || IS_QLA29XX(ha)) && (mcp->mb[5] & EDIF_HW_SUPPORT)) {
 		ha->flags.edif_hw = 1;
 		ql_log(ql_log_info, vha, 0xffff,
 		    "%s: edif HW\n", __func__);
-- 
2.47.3

