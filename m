Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CC3202C48
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403747; cv=none; b=R8l0+W1GoRFpzee95Hcz8wYaVZvDpTRAFKe2mSIlsvjZ0OlSzU8pJtzLjAhsil9SCccAJFq4HeKLfESLIKAjJVJvhQupgrV8tmKsrqq1/XzBrIQl7mVdvOmeOzYwr6BvUgGnLim+xvFbnHWxOZR2mqWXKD2u08o7pgkwC/hJxUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403747; c=relaxed/simple;
	bh=+QvULlatdvMHv9pECySc0fcJvPRzpEAKvqRA8XtQDho=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dKxpjMLGGCY75l5qlWkMKTP3c9E9VtSyIefYP5kX4bfP/qHl+iXqAn0sch7Q5rAdjh/76mZdVPF7Ngm1rJKDEKN+5K4C5hWg40GL2hQraytPOQNiDngTWtTcnSEZMjSA2DbQQnwVDGV1TGGfKxQ8RPT5quaBi5AmiPfnHNb5Ipk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Z3HWsG0l; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Z3HWsG0l"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748kVt1656479;
	Mon, 6 Jul 2026 22:55:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=w
	1q1cOpG5eFmSjjtGeSG+HSkDtdRC5QcyYRP69HvUj0=; b=Z3HWsG0lwurIwZ0UD
	S+wVr5WUfmRfeYcPmt6s+AHLVAVqiC04tnUpXHB1vPzAbBMo3xYDruWq+cLh7qJo
	P6QIeTP+4M6ViRgLu7ueGg4gxxdKBMo4LMo9vFMrSuziQoFEti/LAq9MAE1KAKHw
	xnfVfzJkV9HhQaeNX2hTSd0KIu4HKZHQWLPShn4Lef6veLhKDnCV9qmS/WWb1H6u
	+ADTQeKaARfN90AorE2DO5zh5JzJYzKJIW1FXMid+SEzoYJJMzyeIqxcjl6H7B5s
	PGzs5T35SsB11sQruhHbS7pX4CMzvTmRRfhAAiDpY9cAzgYixK5v7dkUpppq0pjB
	EoIIw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqdu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:43 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:41 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7AB713F7066;
	Mon,  6 Jul 2026 22:55:39 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 14/88] scsi: qla2xxx: Enable get_fw_version mailbox for 29xx
Date: Tue, 7 Jul 2026 11:23:21 +0530
Message-ID: <20260707055435.2680300-15-njavali@marvell.com>
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
X-Proofpoint-GUID: pdw3psaKvhK6_s_IWjk4TEqiIVlH3Xjz
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c94df cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=bXaJlivqrgYIT1gw71sA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: pdw3psaKvhK6_s_IWjk4TEqiIVlH3Xjz
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX6zuR7K24xWRV
 pOYd9EzOs+NLFMhg883TnhdjUqvMOD/WAYRvAKq5hQx52r1wtAbeFHEn6b/sxLzaXpl5k52Q3la
 zQH/ysnJZOLGbzMKllqDzQACKnE38ew=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfXyvjSHmt0H1Me
 8Ub2fn1miFkbEvEIu+9qaQYl5mJpXK2dhnxnnypRNJP7rKacMSYVFNKr+xFrXvoHXC8nXAI6m3f
 hyNpFBT7KeZ7wM+IvvFqi/YMvQekmYsoARNPAfeYBEBrWlDZHHZ+7hO9n1OXIJ5Z/zNiwkCOgcr
 IEGXbAa8AFYPKrQq/ASmmrHzttL7RJ/SzzroMh8BCcuzmdi0z0P8l1Vm+k6FEH7XA4mVizRzv8r
 JO7RtTU3tt0SMZG/n2XSby7EShgfDJ9iDwfDT7bCzjqUXH5UbV4Ehsd6rLA4HqQjrBAOTPgeLcD
 2ZPexWtZFN3fuEpI6/lnHvaRBGhelerK5SaLH3L/Qrb93DWmU2wCv+PF+GNPnr6GOhpgb25ya/C
 d/YVR6v8YhTMtEmOT04fK+yX2BnLvitHsDCn6NXozQxYNPiv2YAoJRLQwL2Q92ESxoN+cQyIw6x
 OHR+D0vtHh6S4j8/VHA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

The serdes_version and several firmware capability fields were not
populated for 29xx because the get_fw_version mailbox path
excluded it from the 27xx/28xx checks.  Add IS_QLA29XX() to
the relevant conditionals so that firmware version, EDIF, and
serdes information are correctly retrieved on 29xx adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 4 ++--
 drivers/scsi/qla2xxx/qla_mbx.c  | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e8755ab86b6a..c44f5282abb3 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1526,7 +1526,7 @@ qla2x00_serdes_version_show(struct device *dev, struct device_attribute *attr,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
 
 	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d\n",
@@ -2386,7 +2386,7 @@ qla2x00_fw_attr_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
 
 	return scnprintf(buf, PAGE_SIZE, "%llx\n",
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9c2633ca5036..0feb98b83293 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1136,7 +1136,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10|MBX_9|MBX_8;
 	if (IS_FWI2_CAPABLE(ha))
 		mcp->in_mb |= MBX_17|MBX_16|MBX_15;
-	if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |=
 		    MBX_25|MBX_24|MBX_23|MBX_22|MBX_21|MBX_20|MBX_19|MBX_18|
 		    MBX_14|MBX_13|MBX_11|MBX_10|MBX_9|MBX_8|MBX_7;
@@ -1212,7 +1212,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 			vha->flags.nvme2_enabled = 1;
 		}
 
-		if (IS_QLA28XX(ha) && ha->flags.edif_hw && ql2xsecenable &&
+		if ((IS_QLA28XX(ha) || IS_QLA29XX(ha)) && ha->flags.edif_hw && ql2xsecenable &&
 		    (ha->fw_attributes_ext[0] & FW_ATTR_EXT0_EDIF)) {
 			ha->flags.edif_enabled = 1;
 			ql_log(ql_log_info, vha, 0xffff,
@@ -1220,7 +1220,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		}
 	}
 
-	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		ha->serdes_version[0] = mcp->mb[7] & 0xff;
 		ha->serdes_version[1] = mcp->mb[8] >> 8;
 		ha->serdes_version[2] = mcp->mb[8] & 0xff;
@@ -1234,7 +1234,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		ha->fw_shared_ram_end = (mcp->mb[21] << 16) | mcp->mb[20];
 		ha->fw_ddr_ram_start = (mcp->mb[23] << 16) | mcp->mb[22];
 		ha->fw_ddr_ram_end = (mcp->mb[25] << 16) | mcp->mb[24];
-		if (IS_QLA28XX(ha)) {
+		if (IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[16] & BIT_10)
 				ha->flags.secure_fw = 1;
 
-- 
2.47.3

