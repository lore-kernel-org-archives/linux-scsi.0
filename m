Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E50E256C84
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783127; cv=none; b=kdQqrZd1dpnRnFjwlPEMRLjhIwKk86nhsy9O2lhMyBnerjkV33zzq+AM0jG8w6R9A7KuJ/+yT961KFf5cjkEYvSVgtjFSKRSrh38qFPTYbkN5BKKPebhKZFMBHMKVqDTVR93YkQ978bkzZP004CsNhFyBK0Ds1nMMRm8gkMTioI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783127; c=relaxed/simple;
	bh=5Uv2VISuFc1Jw30YYEiSN3UTSTHEIOyzev20Aup5LmY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sCKPncTzQ5AFHuaBNhHnfjmtO57SbFTafADnocCqU/FH9hVhLyE++/gytEihKSw7MaNjJz6+sPGMjRVmmeeDoEJwqj3PW1HR2QaXMfVnNx7bhhBbqD3nM+QO5Kv8Fpyw7CcLR/S6OAPmzmpq9XOIKn8iCa/zmpjCPlMpP2H9yK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=GKmZ4ZZi; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GKmZ4ZZi"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w0E0422579;
	Wed, 22 Jul 2026 22:05:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	bDQoWqcIw8F0oDgP94QVM68xhJfvX/JABEGzuMRVV4=; b=GKmZ4ZZiwrilJ7paL
	G3xA6V6IgCzNw4hW/fiA+qaI6GGob9YCCpHbGCvCj3pda1s3BX4DlxY+2Jmy82Jy
	E9fSTcKdjOmAroMrjcG9QZzCHfSn6mKItVOamxsvZWEP3sihYSWRnA6M9fTNugKP
	RdIQRdnZPrECQZHl8Kb0Qe9KFxD6wqCiOi3K04qmOjfbFbnRSTGfqkQd6QHuOxUx
	t5zgMcRgZZT/iBpI4a50YjdE7s1gZVwIExwWtSkabxht8vM5aQK4HFlC7AMEs1ln
	4+HbUuZztn1xF6GAar/LHgpgayqJfdgy3yM2lBrJbBWyZyQq1kBz0nwgO4wK/5tk
	IiC0w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8de-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:05:20 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:05:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:05:19 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0DFEF5C68EC;
	Wed, 22 Jul 2026 22:05:16 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 18/56] scsi: qla2xxx: Enable get_firmware_state for 29xx
Date: Thu, 23 Jul 2026 10:33:35 +0530
Message-ID: <20260723050413.3897522-19-njavali@marvell.com>
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
X-Proofpoint-GUID: D49ggajk4E17FeGXs5J7kAfgsryboJl2
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXwLp4YETZsz1y
 oJKtF/xKcQluPDBJVEy20PhrPLgcasYlGJ8HPwEcsXr1EgjOfBFFUQSp+Kr9joTqGkuyHQFetmV
 cXe/zE/OebMEDF80nEqzXp/qZ7B6F6U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX+dKO/BejPhf2
 7RmbamHhRRzVEI2T8t5wytkA3VWkSLJdjO4UBPnO+JWQBa9xtfRmWm6MEdGfHqQG0wuaavSa4wy
 Nyr9PjdCoxJBMGktQ7RK7qkWM+DAa84crrdQhU4cXcDHodyurvEn7+szrCv3aUlGJxLBZPkfD9+
 ycZaHgMuugnkdDQgAuFuKuKFA5tC6wF9O9Ll+zbP8ArsQwqbIkqgCRuuP3F0lwcT84VhoHKdmVi
 lCywhEKwfl6J8i/1ioBHOtcIXz8JTA9z9a1vfBJwRVAPYsXXjLFTxUzETygjuWZgDIFcHrLmHf9
 Vnzk/FrwIXcw3rBD9IdyVozWjR2kjYRXv3mdZU2lROJKlEMite82XNDAhCIe7OFp824umvFsuB2
 rPAU0Awv1wrVoHxSeXbhDhQG6ZVkaj/pm0iT7TRjEXsyjvlrsrcMJmpSAiaixDxuS/FdcYJ79Im
 cWeCArmsfdGeY1U4ApQ==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a110 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=jXld2Aqxrx9nTAx2xuoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: D49ggajk4E17FeGXs5J7kAfgsryboJl2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

Enable get_firmware_state mailbox command for 29xx adapters by adding
IS_QLA29XX() checks alongside existing IS_QLA27XX/IS_QLA28XX checks.
This ensures MBX_12 (MPI state) is properly set up and reported for
29xx adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7b7722de2844..5a934f40323e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2436,7 +2436,7 @@ qla2x00_mpi_fw_state_show(struct device *dev, struct device_attribute *attr,
 	u16 mpi_state;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!(IS_QLA27XX(ha) || IS_QLA28XX(ha)))
+	if (!(IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)))
 		return scnprintf(buf, PAGE_SIZE,
 				"MPI state reporting is not supported for this HBA.\n");
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9c78aa66e12b..a91ac59dd9c0 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2283,7 +2283,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 	else
 		mcp->in_mb = MBX_1|MBX_0;
 
-	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		mcp->mb[12] = 0;
 		mcp->out_mb |= MBX_12;
 		mcp->in_mb |= MBX_12;
@@ -2301,7 +2301,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 		states[3] = mcp->mb[4];
 		states[4] = mcp->mb[5];
 		states[5] = mcp->mb[6];  /* DPORT status */
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 			states[11] = mcp->mb[12]; /* MPI state. */
 	}
 
@@ -2309,7 +2309,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 		/*EMPTY*/
 		ql_dbg(ql_dbg_mbx, vha, 0x1055, "Failed=%x.\n", rval);
 	} else {
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[2] == 6 || mcp->mb[3] == 2)
 				ql_dbg(ql_dbg_mbx, vha, 0x119e,
 				    "Invalid SFP/Validation Failed\n");
-- 
2.47.3

