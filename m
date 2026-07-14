Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C0B32A3D7
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022908; cv=none; b=XhsN5TWYLIQz3ifBh9qGpK8Def4K21iUAmTutkQweoKC/UpXBlaQCHRVQJ1mtVMO+52siYt8JdvJgJGxB9KZTS+SYNhJ4OmE3oL38xTDoMUkxkrD14cMIQDyru2hXm62nVf3DVWk4HipTyIDmmb9P6xvwjinO9iO7Ym7BWyY4W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022908; c=relaxed/simple;
	bh=zrMjsfb6H/DeLhtpxkCK7H3GZzwIY52jej/Ws8kA0KM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fjQZjrdECtFbJkn4w+f0F7v4FtB/CkauyRyDRwfhkmH4/WNPLNXDl7N0U5izgS0cHoGQrawudp6cxoWq8IEU/bfwkJfyS7e7plXtBX0d4410GJcfKCcBYMyNsnRSj4G0R6Ww7bNXuLAVHjkyKLCTz2rHDAVZ06r4xf1rcjlZb8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=f++TazwW; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="f++TazwW"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UDAO2407820;
	Tue, 14 Jul 2026 02:55:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=f
	S7Wg2N2pMMirL1IbOQUOuI/TE08ncoZgwp+SyBkHhs=; b=f++TazwWfhwdV/9Ye
	qKE99+VlE8vwxo/u+b2LmYSgIQs8R/2Y5jPEXW0V8WmwiqutYaNfp2xS0aX80qrJ
	xpZcqLYpbVrJNyTz5E0jSe5eX99tG75T41mnqTHStmzH8QDwvqsDsvvvM9Xnpp6v
	IbewJlpOgwa6AJ6ByZOAni8cKzEsTDtx68yeWKsN6qh43UAxjRQP+6vaOrTNyXVz
	SPTQnKK1eWut0SfmcPzGQqctQvtld4D7wmSl8P8jj9LDDPHT/TbfO6i9LtC8YbD3
	tRLVMi0R1GQMHfkNJPh5qAS+/Gt6Mf1GN4gS1KQIFWNxGtSVLM11xnzlGwg1n1U7
	S4qFQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9npwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:55:04 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:55:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:55:03 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 25C1A5E6868;
	Tue, 14 Jul 2026 02:55:00 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 19/56] scsi: qla2xxx: Enable serdes, resource count and FCE trace for 29xx
Date: Tue, 14 Jul 2026 15:23:16 +0530
Message-ID: <20260714095353.289460-20-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: M2ps65mBPK4f3D78nqyOgwWV7MbbCxlL
X-Proofpoint-GUID: M2ps65mBPK4f3D78nqyOgwWV7MbbCxlL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX2rbTxmn7gGju
 mHlsj7rBjF7o/gbBpyScKLpYgVFm4AxWNH9ydSZRL0cFzRL7CGIhI7Bb1kNB0cweh7ai1P8N69D
 P7XkOGWF+UgiIIe45XrJ9G/6suWN4ic=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX8ED2is8yT1WS
 i6HziEQ8nFWlNi6G+49NErJQXS0KprVNAh4Y7D3WoJkdb6O7Nt8CH8MEX0D+ox7gDz0TU8Dr1WW
 ni65gPyopNLYjteZOYfe/ehHnz87sBqZUslW6mwIPu6i8AQTDbPUqJOJt/gDbeq/Q5czG5u4L+b
 iony0ujuRchvUiHvHf6Qn7qaL0qSZD3AFptegaPY+JTfDIh5m83akJDcGWvMtTiW41rsvfOMhC2
 p3I0AvE97TqVelOtW2x/FQUdkh93ep9vhc1VFEiY9pm/tH8/dYFUsYdvyqUIXGqy+zHuCvgc2q9
 EIa/xvh5Uh+t92QFTaoGZMzFMC0ETxzJavkr+2xL3IwxJMgaOVQWIoYJITl+Se5ZGxZc7uQEh/T
 Kg8ntX6wVpAorVJwzT9FgBXWbhco8FmBAtpayCUyv/2q6WSfcSZdPH0hscxlMq9ffCf0WIufw3O
 0wFYqOfqsJwEKRxrp1A==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a560778 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=DgSK5nL-u3n_r36zDegA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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
index bea7b5403650..e31997241c34 100644
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

