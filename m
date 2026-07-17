Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FAE42E004
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302212; cv=none; b=C1GaJ7nY77D+Mnm2II3RnvYE7bz+jDU/0FsLnPx3MAlVGe+Qin0hr/x8Wgk8lMUoZ+ypJQPfa/8XUE3hl4CHF3822uSvBlC2SpAE/tdZC/bo7/r/WVH9F5TFWypWTlMkuveS0ecJEur5pQ6+caoVJV0VoA5sobEZrsKLkerv81k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302212; c=relaxed/simple;
	bh=pZtjIs6DRrZTnZkXMe5WBLjXRzVLHVKVggrWiTz2d3w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h0cQvcZOdQ6fKMSfJN6VsR7BY4Iz9QgLLnvPRv9NpnhPxNVgHhAQHoS7u1p+m7dfX7A7NHgB4frh712xVe5LpWHwYM7fbgboOOXMtu6QqC+X6hzoQfi1zcvOT2AKPQ/qT71PJcJ9YzVIusSjL35L1RiyFTxLtVUYWM9hMCpzT0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=N4YSCc7G; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="N4YSCc7G"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE80lt094830;
	Fri, 17 Jul 2026 08:30:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=p
	GIFHGG7fxRQO4dKd7vbgHFqzrUPeCsxmr6gg+dOn9M=; b=N4YSCc7Gmx3k77KEW
	WDVt2eN2ER5y+EQlNJowcCMWDUkWwkKt6IO016pT2hFPkqDVAt4cDB5qfQ7hwFFH
	dNybCKDi3I5T9TsyTYrFu/CDeAVBk3aeIp1TCKid04v62tqmTshnCx4nKy2rz9mm
	6Fr9IKjw/RpRO02zWISFlk2ep6f/D9uh+kBkifCSak/RIwe7f6NjktupWjjNex1c
	cFODGjmZuMpC5Zi3oYhpPG39LSHspwCBoyFweWrhyuO3EVJBnPBCeMkQ879zCTq6
	r1TcQN6eakIb8hgKSZgziIsOhZ0PgYCSgXGvIgfto9QnbRukQGdrBzcEa/jcspHF
	IOE8w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:07 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:05 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0BA285B6957;
	Fri, 17 Jul 2026 08:30:02 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 19/56] scsi: qla2xxx: Enable serdes, resource count and FCE trace for 29xx
Date: Fri, 17 Jul 2026 20:58:27 +0530
Message-ID: <20260717152904.3155730-20-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: _1MNdlv38vXI3T2V91ZDSoVGS1sGv_zN
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX2EhVpRtyoWEB
 7nrZ0bhJPT4OWbJLeLY3S00WkSXXtuDSPzynG6EJHW3rh0+wDO2bVDsQtgArf4WdGrHZ99L7u4W
 eUNTt6JvkZbqFbDUn8KLzDP+nIo4VYo=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4a7f cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=DgSK5nL-u3n_r36zDegA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX6TQ8SVlmj88w
 LbrTTgk8ZtucBQdIWoH5Po+GT1i/77p1Zukrdhxm0OM7eR9c6PUwn8etml4pzBXBK3r5nLxupCd
 8ijw2onkk8c4ZqaLzrU8LsyLPAu75/lRA1Tm23jFtWhV8ji6fca/zAb0rx2ip6LRlMFVqhrZfLU
 kTzulABxic2ueYm62NNGYgHn7+gZvzqoNyQkSSWhaINVlI4N3ZscKK/RUJL+Wk+sKnwpsgyDbSH
 m84I4D53Svg1vXoqpJsRtL5Eb8XgJW4fhzVpC8Rh8vXQYzc6zKlzhbUieapfQJCyQEDTfrB1Pdy
 FllFhGFhwvEfhjY7iXHOLzeUCQM/2VPdPXsKrwW6htcL0sPrdyHBRXFH3GCOwBDP0A345Oanh/E
 YCaguTz5jfIUS2ihsZT686YcA2msFgEo2mTkV5vQYu9Bn77lxezrcssy8GuIopaWOqhO7jaSlYv
 MVmUARZUG1Hqz58i8Cw==
X-Proofpoint-ORIG-GUID: _1MNdlv38vXI3T2V91ZDSoVGS1sGv_zN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

