Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A3E33345A
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309813; cv=none; b=nKHicwPs4T1UQw5UpfbhoJov3bDYwb6gu6uoKEfClhBynw/OFtwLIO773h42hd995PryrtGb5xa2udwY2jz81beQ0SBCKsHV45Q0kaJHQJEgE0tDgeX7atCT3yR91TmDINAVgLYVjfpN3MEfeZ8IIFtzfDqrX6Zoevq9e8TrUsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309813; c=relaxed/simple;
	bh=aqPaBMxPm+X4/0EsoOt1SQC0VFdmEMJbnI+/19eVCFY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nrxwKsWSNobGEU9evb6RZRW0idKY3YHo26oveSbkUwWIpLpRpEfQF+7lJzAjfzuhY83hpUtqoFrtLdjxvrxrwnCQHXzx3i0HuNhH38s/OaHBONAhcFkSGbuZH+50AuPMlUqsIn6Mt2eltyQ7E7aebQt3jGfo+ruuw8r3Rlh+P9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RwRB+0uu; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RwRB+0uu"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VN0LBk3439390;
	Mon, 1 Jun 2026 03:30:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=r
	TsARZ++liF1DIHq0/pmNKzlctivKtnzxqQAvv789yg=; b=RwRB+0uuErCJ+H9d/
	88+G0W3KeCDkGCxOgCBkPkJZybjqOsLTkxUyIHx0DDMXACX8lTIp3eb6K7iP9IYX
	7tHxVfamZrPVpLdKASeLr5SRNGYV0JLxM2a8HxiCgbYXF5UvKMFaznWvaMlRyV/K
	UpwN7CTB8iky0PxzmZxU5ksEaDMxH2V5he1saM8/ge6x9iUdfH+NSFaoPloeKSMp
	B2ABwyqviWxRNfNgHuIVrao8zXcZCXXDm5jQultAzDNxWSgSo4pfmgJWjWEw2xaf
	pm63E1ZEw1w6NEhf8dCthHTDdjP0u+QbGq7rv2bKOlCyVjfCpG/8gMjntOlupa33
	YCl6Q==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eggn8b8uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:09 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:08 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id AF6613F705E;
	Mon,  1 Jun 2026 03:30:05 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 17/44] scsi: qla2xxx: Extend execute_fw mailbox to include 29xx
Date: Mon, 1 Jun 2026 15:58:26 +0530
Message-ID: <20260601102853.328426-18-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: OWQ1_1NY2MN7rtR8caiaHkrhorkN8t_1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX45/Q/n/KqYmq
 6DIWvhlhECRtx4j3o7bGoa6ELdU1ysvS9U6GO043gq/rS/0W11RZtFKQ4dgWySmFAhQbuIveql/
 C/iFmNItD3I80MWIfsMAraQD6JiMspLiI1+dnMtHozjeFTl2Ra9H3wvFq43G7ECIhorlR2LupxF
 GVoBap+iGCGfRua3eXajkYguMYDszBrulyW3XnzYyyNJYjC48x940ObKvnclRJmvnYyWT4LGWuM
 39K8xoV8bii2LuSDuiKsr31w6azL5YZw6p1vzGEVJjsVitYUPJIVlD5Ru3GJSMx3XBcOh2+58vN
 omMIWLtmdtT9UYXL637axnLC6UJW+5yO2VzA6jrBVMgQERSqmYTWBiXkeE/u9xO3XCbdV9bDVQC
 0/aumvAQ6QBvMR3GSHco70WQCHUdhW6O/ti+sVxjoqntGYkQz0bsOmtUouZIslzuRRNtgE5cYfM
 8BHArmgi4Iy5hwFehaQ==
X-Proofpoint-GUID: OWQ1_1NY2MN7rtR8caiaHkrhorkN8t_1
X-Authority-Analysis: v=2.4 cv=ON0XGyaB c=1 sm=1 tr=0 ts=6a1d5f31 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=IjkUP9Y0PugEctBw9wkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Add IS_QLA29XX() to the BPM capability macros and to the
execute-firmware mailbox command so that NVMe enable, minimum
speed negotiation, 128 Gbps speed reporting, EDIF hardware
detection, and FW-semaphore retry logic all apply to 29xx
adapters.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  4 ++--
 drivers/scsi/qla2xxx/qla_mbx.c | 21 ++++++++++++---------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 38651b5024bf..becee225ae83 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5604,9 +5604,9 @@ struct sff_8247_a0 {
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
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0feb98b83293..edd9849aa719 100644
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
@@ -727,11 +728,10 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
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
 			    nv->min_supported_speed <= 5) {
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

