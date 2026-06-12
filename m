Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D1C258CE5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258106; cv=none; b=FlHK9BRRpxOwnLaHCfzlKqj54484EWiyiu3n0bVXExyKztiVIq/AxK1t7jdpbXVKSQqvXJzAZ4jm0P8/KpO5kasm5M91QXz12/WHU6tWP1CE3iFIFfqjSOyWb/lFJAwqW1NR7q7F9DuF64xurgJaCqfAL95Mzz/r0s/7s2X8igY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258106; c=relaxed/simple;
	bh=PZGzbD5bnerXzPjMxGAdPGwiDtU15BkeaKOx4xHOhn4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PAA8uPj7actl1EFReI4H0ZLjzGwS8JrBnhFQrnhsj9dMzJrPdUzsEnV7N7Ks9DHO3fO7cpQAyhTzX+ngHhaAZk95qAjZwlMmGr00cRIv1sqM1+xYAhgy1ihY0qvxnI4unvzG8ozXPZaSARWYGeE5ltkX2tIfWBvwkTyxNiB3eCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=EN8qIS6e; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EN8qIS6e"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C5EUip271311;
	Fri, 12 Jun 2026 02:55:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=+
	zJvUyW4ot0//wpAGeFNDdWfv12OENANl1TqXBQSOuw=; b=EN8qIS6eyozT4SZy5
	OX6tLf1o9/tBhk3F/9iCab7pPqxZPSVyPuUaevKu0xPphK9kWuTU+va0g/pZQWQi
	pS3ATX/cJoW813NE9KRrIc9P6NA9AOZ1kTofseCEBgxU6IOddt0GNy+EBS6dOmmS
	kHjEl6gAXJzqpHfRjUhPUMVhAOA4Vt1Dx6Ks0EMl3NU7lpbU4Ob/4uul6tfZ4XJe
	ztHIiGdr4cRAOOvD+sapvZJwdxJz0OJVza7i/f73xlwFICeq3GnmM/tLQa/jR7Hk
	2eAlYl59E3+5xY/vwm4Yk1grYuueTOAdalvwRtsY8Rwj/ZoU7eYuEi4tp7KDaDHZ
	1RrZA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5r6ru8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:01 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:00 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B51CE3F7040;
	Fri, 12 Jun 2026 02:54:58 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 21/60] scsi: qla2xxx: Enable serdes, resource count and FCE trace for 29xx
Date: Fri, 12 Jun 2026 15:22:54 +0530
Message-ID: <20260612095333.1666592-22-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX5DE6hsEberMI
 Xy+Tamn/Wcz7D/GymMMTlbx4d7pu6doMEIdwDSzFn3i1o0TdM0xrRwckRNvUWaI7qLRonFvvJYH
 9vR8yu6ZmOwmHG9ZUNW6hZ+mvbfjnm0=
X-Authority-Analysis: v=2.4 cv=O6gJeh9W c=1 sm=1 tr=0 ts=6a2bd775 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=DgSK5nL-u3n_r36zDegA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: 5viUpBp9J0MB5iu_ncPRewVolPyrinmU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX6EjQxbPZgyqB
 0KwCmdW8qxfszClA/qnFvlbyJ3vyCiFgU6UTp7kT7XsGBYuc+TlKQZ4ATsqpu30CemeDRageKdS
 sejWfklE2ehn0LU9iZnT1B/KC0+oVYhEN0IFEat/5mXU2vifpJiwIgGkpQe4khraeU2H0YZOu5d
 OFfd4gOQBIjOswqX/rE9yyrLfD49TZx15/Rq5rBOkx33BOzBuV0npV4Dwm1JO0U66Lg4RWq9EBo
 yGG/hMXIMOkOpwRyhkoVYxJsoiE3wtQcsf8uA2Sb0rj2OfHV7eezkUqyD5nGJ8xBrBor256MNzB
 VUMM70wGWIh2DTZApjqEPmBBbE5CipD8sec1tLRgtMTUG9cyItDqAlVVnnwPSf7uurAPH37Vj6M
 zhLnPVZZbM+PV7yP+ZA8gZXS5opyKidXR+/KwJ4Rs1ti9sFutD7BfXJTZmRGARPB6wIK1OQb5OO
 yYKhj9gIN7wumciNrTA==
X-Proofpoint-ORIG-GUID: 5viUpBp9J0MB5iu_ncPRewVolPyrinmU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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
index 20eb67096b0b..ae9cd5665469 100644
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

