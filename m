Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2661470EB2
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783130; cv=none; b=lP+TPgyJO2dAGUeLYOjW4vlG5S0r6gyCv3VzD5SZEEBCIEohIXjrFFTnWD2w5S2JgzXA+nBKFhlWGLhVQYtTQC7NngFgOt/0sJAJ7BFRzy9zkFaAiNbesWCe5RXlSjNCE0evNe2uzaP43anml4nOCpViwshsomLX0T/CapSsDZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783130; c=relaxed/simple;
	bh=pZtjIs6DRrZTnZkXMe5WBLjXRzVLHVKVggrWiTz2d3w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TLcIu7sc9yAiph77h587Se8fxM/kZmENGI4CNIdnQ9pl18iBLB00uLG4djaDlor5qA89BA9kPYW2WrsvBbPyM5TQTlXRdvIAKkZy8opJ8v6wQdDo5cJHeYGvsAPWuWhQrVt/dczOyLF7acu86Qn0/2tAEAGpRtTUDrnM3TiL5R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Zd0R1btP; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Zd0R1btP"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vxqU422561;
	Wed, 22 Jul 2026 22:05:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=p
	GIFHGG7fxRQO4dKd7vbgHFqzrUPeCsxmr6gg+dOn9M=; b=Zd0R1btPY9IvfMsF1
	rfbubmKAWdk/ZqIwWLfEURrIU9UzX22IxOjmrem0kSLV3qc8zerleqBmGAteXdpN
	z6wrcZyw+UnLh0M1ZuvXAZT0JEceM1HlJE3L5iSOgN7tL8AF5LZ110NZiKkk+9I4
	pw4m5Eh/SUb0tBvPGrnrBDiSc31IZuoY+F7BX0rh5e7qjY0c/LLw3nYOXrUnV/3l
	D8W5FdL6i0hGBo3W0saXq+Vcy46P4aNQN1u7zQZ6zTRwduPqNK97SlYYEKW2unmh
	KuWgX1Z2gj4IfmGivLCnd0YMPg76TA08aeugVX/zvJFdQsQYbXuYmLvOmrIzLWHn
	PUdfA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8dk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:05:23 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:05:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:05:22 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id DF6E45C68E6;
	Wed, 22 Jul 2026 22:05:19 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 19/56] scsi: qla2xxx: Enable serdes, resource count and FCE trace for 29xx
Date: Thu, 23 Jul 2026 10:33:36 +0530
Message-ID: <20260723050413.3897522-20-njavali@marvell.com>
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
X-Proofpoint-GUID: 0TbzWq-812SPriTMnWhS2P8xDsavZK4p
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX0wwIaeeUYcE7
 loaWqhGzzTYmm+T3C3kYLUzgnKKUNFre8Kj+sb9O1iUjbaORlFWvtyHJ/5CSZMEZOPKiPMdcJGI
 r1eA3fTxLwJfMvGaL41wDYKpuSK0wAI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXzSaRjBwz/7td
 t3QoDYwdwNmpfHan6hIwBqgDDsrgwu1JOCeH0OYynGLFo7J8IaQRV9IAe/oJhkrrKkCjwGWnCQr
 EDrxH4PHds13MU+U5MGhx9Q/FwLb2MmzJfsKNVozuYlRSL4KsRC9YGrWSpaNAqu+svqYoEWIVlp
 EQuKqB6z1Pqq9Totp3Su08j2ZUqVKZDvbiNzcXyjPmNmYXCEtwJemAElm/7Z5JVvVoPNG/mSZde
 kRbONvaqrjWFarumyjB69T6AuWS0c8tnusrQm+6czxdNMVKtePNkkvJ3tUTnwsji5bzYHq11JGx
 0vWoLyQRGQGuBwDZxSUr4HAgEvW8UHhMSCw3HqXtlbLPCKdTc/wIXd1kumaihHqvXGeN5zdBtTv
 bPPg0ZQDWSvWIkOwkeuWVksNmS8g3f+Mur+Q7mRk+FCmZ/YQZQbriLDttPfgi1INMF2J0QrVlar
 reiK6kMoRo5JNhE1Kxg==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a113 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=DgSK5nL-u3n_r36zDegA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 0TbzWq-812SPriTMnWhS2P8xDsavZK4p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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
index 1b011aea432f..545066f67e02 100644
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

