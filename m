Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB40388363
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403758; cv=none; b=bzIc6wItSSviUMXHe4D6JAf9e+xgFGaUcdoF2ouwWNdZuqY7j4I6tkKMM4l4jfTlw2H6bCcOsbjq3coSGzJX0GM4Gk/dL3SfoUO8Anm6uJ3i0Tl72h0tU2B3cswWbMXNkQkHKyIUNbmgTokpXyOZyoYbCZ/yHViNymrT1ifj+IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403758; c=relaxed/simple;
	bh=5Uv2VISuFc1Jw30YYEiSN3UTSTHEIOyzev20Aup5LmY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XKJE+PRaE6aQLLWxlp4aUwLCwXOxBVFPX3CLHQxkXU1FSmUIqH2ZTIU8E5yvEr2jK7toNJLTpr7Vvcyheo0prLxoAeKnqVOnRO2g2VHto5umCK+u7r5OpAlpKQzPmIfAvLYCJezZOjr7jaedAw0yV9JLQU+ZMd8GK68J818lThY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=M1loZ4lA; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="M1loZ4lA"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748KS3873305;
	Mon, 6 Jul 2026 22:55:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	bDQoWqcIw8F0oDgP94QVM68xhJfvX/JABEGzuMRVV4=; b=M1loZ4lAmCv/s+6Oj
	YEJsU/owEBzZbnj+0wmvmAWAwtaArx6OF01JW8LE1YwmoZ3LQfxLGltsJ+s9gsC1
	K4viJmxSlbbf4sGX1iQIxHPDMdXS48wrKvFXWVxjJqwo59LiIUqVNmJ5AKCYATxw
	6Stq5DFG4eEZMsYV+u+eR1S5+1XhKLgj/Doza0fDM1hC/EDWYKqBjcnc41Bzh+YD
	PyhCGU5KPsMi0JAstudm28jf/vGW7VrwxoV+5P+OSfFL1EAH7u9hvokONAcidZTH
	Pi4eunfh1YN+gnKBMWZWs9AWTDgUVRqfATravRKzsprXbM1whKs2wuMgJ4Ctg2AO
	Hu/JA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:54 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:53 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id E18EA3F7066;
	Mon,  6 Jul 2026 22:55:50 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 18/88] scsi: qla2xxx: Enable get_firmware_state for 29xx
Date: Tue, 7 Jul 2026 11:23:25 +0530
Message-ID: <20260707055435.2680300-19-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: X9MXJR5qx6F8MBBHpC3qXjkSbbjBeO39
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX19qvwMYn4wv9
 yMojp5NskHRx0yiJV+zJ0wUoVvYhT3WqxFzv9P6ySUu9nOZt7FKbrdh2aOsA+wxoS9w7N4TLzrM
 2ISLXCNdIPKcKg0nz9gPCgZW1shRuxCYJ4mkZasudbbrnLiQO5BeS/37nIFcso7PJ2tcf+v/auA
 gzj3c7Eu/RRYUQkwA20PxPHCtAMW7tWHXSnOqf/2ShkCSjwR9e09wDsi8GS22BeE+FVka0xMcaO
 Biwcduj0uQhrFZiqgjsdvopRQZpHx7GJqYU5JxRmnxiU0eiFWx4mCrKPF9t9sKuHNREhnBG0Gke
 t4V5hFq76w3n3Jer0tTeATkP4Fgp/F5/EoVitD3fQuGUkxB8hxL6/K5/5eYiXBzkoOVwKyR6giO
 hI2BMxAJ4Lsfv1opos12fQavC+nUizeWLIitejQgLuJKcaH+1TRblVq01WBk8VNtSF4qF3vrSLu
 Hbnn1xUKGAVM5ohuEjw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX+/p27flTMTe0
 E8xbNipr3eXXErlmF8GBAyoZKhjEJj4DrVLrIk5xF0bBHYPxA6z7Ff2yDLeLvQ3Y/xH16PfpnyT
 aXFrQ9VDOm63KLIY8Z1HiuJAp8KsQc0=
X-Proofpoint-GUID: X9MXJR5qx6F8MBBHpC3qXjkSbbjBeO39
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c94ea cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=jXld2Aqxrx9nTAx2xuoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

