Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24371385D8B
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403761; cv=none; b=pJTeWDWeFernh5byPpmKq4p4k68538e93sU6xEYInnXQ2XtAUaZqh6Mxl4wI9TP/RkMnw+V1FzRp6ycDlrQndJd/dKwgY3S1TdZm4WU/5L9I4FW71xgKGIJzmc7vJkvk8+KxL4npr6MpbmDe4+bAjM5Ov348cK8sp3RF64BkE4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403761; c=relaxed/simple;
	bh=OiaG6CmhEgeL/ygI4V73KiTKzzGtb+REfNWlCqLg38Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OuJPN46yjUS2BIjK4CgnaG8yazCD2yiMDzutCvHfd1+33IviRao9sjS4AYtljQtxFenkO7d3IIbq/LP5I9puFxMIIUzimI2j4cH/dpLlHXfMKApnsWMFepgsi6Bg+uMPUeRyb82oLP3O/gowsq7Totuqbuxd9KEj1MpXwrxrEuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=P+VCUiRn; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="P+VCUiRn"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747HXQ853916;
	Mon, 6 Jul 2026 22:55:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=h
	AyqJNo1v+XzgDL+BTkJBpkfwhaH4S8YDIK5tKt4PnU=; b=P+VCUiRnC3dI/2aW8
	AtQ10iLUxm7je/sOVoM+A8wYCDYmpwUu6s8/tr2bx+sbFnC5pBjCGfpQAKagmASU
	jSXWYLCKAcVkJ2DPgDxYcVW6RcOsiE6HVIoiRkiCbt/TAxWXLsj7gyIAcBn1FrMm
	Vl+hLlYnnJvTc0P2+ZDcz3/HpU9AFW4+FjBeG+AoCV4M50soDFiIxNsbYnXsfYNw
	H8Cs1CWA0eGz8AqigTBDGfwjVfQe0Mhs8cOqmlE38ozXhJ4fPaYHkCXAl6ugd3if
	aJxJdr/+05sxW5bjDSNXKQLmJCP/LZdASCzrNawd68rGQqmUtMtMRosnKso55+cQ
	nfiuA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:56 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:56 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BCF3D3F7066;
	Mon,  6 Jul 2026 22:55:53 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 19/88] scsi: qla2xxx: Enable serdes, resource count and FCE trace for 29xx
Date: Tue, 7 Jul 2026 11:23:26 +0530
Message-ID: <20260707055435.2680300-20-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX5BlQnzfwrK+j
 yIWGn4F92EQont/8zRYhECT6/pS6hB0QHcy+tW1D18dIzL4YoAHmTjNfR2+7RpBigAG7hfuH8y8
 v9bIspAUD/OcQGEGNMrQqJOPbN2Rvi5stihU1CNRHqYTV1jWfReM0oTWSJkKYgFA4KgXngAybdx
 97SxKp6sE6kjAAJCOjfxQYteXGaQpbsrr7IcTh3qsJ/omoSDbuJIB53LkXxM8osG7eaXW+gC2w4
 DY7DGy0oGAA2mlBBJcThOKJEBhA6dgr4SqSxvVRHJj6wmNP7XT1jP6NDV5ip1JjUOiFgfw5a/Xg
 ojZ7XqLRr5KLHaWvHykeoYczKxWkWz25vscxlUqjy/MKFHfZf/m4jH5g2X5GCPB1ruPd7I3whNA
 sa/EgkvJnkk230XAqW6pR7wi8KKEtfncwtCgEHjf94xBHPPDsCbZcHLVC5j0bxD1b95bZb2NIGd
 WYuSvc3tnVbwiSEVh0g==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c94ec cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=DgSK5nL-u3n_r36zDegA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX8s4DL51irfva
 sBwK8POCfqcPq/U1PXmWi8bv3izsY10+SvO0edH3OMR6sHSjQd7X/W1szjt+f04S0rNIbW9IBs6
 qRzoAv6rJ25lnI8vjX03+FKJ/thH/dE=
X-Proofpoint-ORIG-GUID: 9d8RZcaw5j8RfoeJtr00KP2MnaBqdqo2
X-Proofpoint-GUID: 9d8RZcaw5j8RfoeJtr00KP2MnaBqdqo2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

The 29xx adapters share the diagnostic and management interfaces
already supported on ISP27xx/28xx, but several family capability
gates still omitted IS_QLA29XX(), leaving these paths unreachable
on 29xx.

Add IS_QLA29XX() to the relevant checks so the following work on
29xx adapters:

  - read/write SerDes word mailbox commands for PHY register access.
  - get_resource_cnts requests MBX_12 to report the extended
    firmware resource counts.
  - FCE trace: the enable-FCE mailbox command, the "fce" and
    "fw_resource_count" debugfs nodes in qla2x00_dfs_setup(), the
    debugfs enable write in qla2x00_dfs_fce_write(), and the FCE DMA
    buffer allocation in qla2x00_alloc_fce_trace().

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_dfs.c  |  4 ++--
 drivers/scsi/qla2xxx/qla_init.c |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 11 +++++++----
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 43970caca7b3..177d47e92e49 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -497,7 +497,7 @@ qla2x00_dfs_fce_write(struct file *file, const char __user *buffer,
 	unsigned long enable;
 
 	if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha) && !IS_QLA83XX(ha) &&
-	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha)) {
+	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha)) {
 		ql_dbg(ql_dbg_user, vha, 0xd034,
 		       "this adapter does not support FCE.");
 		return -EINVAL;
@@ -698,7 +698,7 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha) && !IS_QLA83XX(ha) &&
-	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		goto out;
 
 	if (qla2x00_dfs_root)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bd0684d97fef..ae9bf6871079 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3733,7 +3733,7 @@ int qla2x00_alloc_fce_trace(scsi_qla_host_t *vha)
 		return -EINVAL;
 
 	if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha) && !IS_QLA83XX(ha) &&
-	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return -EINVAL;
 
 	if (ha->fce) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a91ac59dd9c0..d195723fc06b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3093,7 +3093,8 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha)
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_11|MBX_10|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	if (IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
-	    IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	    IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+	    IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_12;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
@@ -3565,7 +3566,8 @@ qla2x00_write_serdes_word(scsi_qla_host_t *vha, uint16_t addr, uint16_t data)
 	mbx_cmd_t *mcp = &mc;
 
 	if (!IS_QLA25XX(vha->hw) && !IS_QLA2031(vha->hw) &&
-	    !IS_QLA27XX(vha->hw) && !IS_QLA28XX(vha->hw))
+	    !IS_QLA27XX(vha->hw) && !IS_QLA28XX(vha->hw) &&
+	    !IS_QLA29XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1182,
@@ -3604,7 +3606,8 @@ qla2x00_read_serdes_word(scsi_qla_host_t *vha, uint16_t addr, uint16_t *data)
 	mbx_cmd_t *mcp = &mc;
 
 	if (!IS_QLA25XX(vha->hw) && !IS_QLA2031(vha->hw) &&
-	    !IS_QLA27XX(vha->hw) && !IS_QLA28XX(vha->hw))
+	    !IS_QLA27XX(vha->hw) && !IS_QLA28XX(vha->hw) &&
+	    !IS_QLA29XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1185,
@@ -3874,7 +3877,7 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *vha, dma_addr_t fce_dma,
 
 	if (!IS_QLA25XX(vha->hw) && !IS_QLA81XX(vha->hw) &&
 	    !IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
-	    !IS_QLA28XX(vha->hw))
+	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	if (unlikely(pci_channel_offline(vha->hw->pdev)))
-- 
2.47.3

