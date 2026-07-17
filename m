Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1C9363C7F
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302212; cv=none; b=MnmAJAh/Ne6GNMzLBnpJDtoIAdd6UygWhNqvtz3IChJLU+P6LpscZQIpHnoBnTNlG19ivvsdKYQ7e4tch3GZG4yd2nmUu6sHWaEY9NPx1HGtP1urMPv4A27YjzGjUx8dq4+ILXt9xeUCr568cSsLdgMFgNcIVwXNEPcEej2ykDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302212; c=relaxed/simple;
	bh=5Uv2VISuFc1Jw30YYEiSN3UTSTHEIOyzev20Aup5LmY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eXiklyUAuRY3TuxBt8EA/ZDMNf4aMdFyFSHyDfZyUBaMvrSOFeJm09Y9/etrv7rUEEtwyaba0dVS1MSxO2qlgyA3fKjwVXq+/JgEnsxyC4TP3tGvaxQhiXkCa/fCIJ4tS4HdQHYP2eDPyke8B6vDKLxlHvtGZK15ZDzuxWEyvx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Y233YTVU; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Y233YTVU"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE4UdC2774287;
	Fri, 17 Jul 2026 08:30:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	bDQoWqcIw8F0oDgP94QVM68xhJfvX/JABEGzuMRVV4=; b=Y233YTVU+dEJIKJ5f
	5h0N1Q+oGq5ZVZPs5U/UgLoEb72vv5cYXC99p08kHLK8i5wPyGGjnOjtCg+Bq8Ss
	NjH6Pi8eMG5p23maDzU26z8oHclb3lek+TRMGDaPxUr3XKBrf6kf/4IuQ7OQWvRy
	jP+J9j/NUNhM+bOzLjeDSBqNBOhSvyWTHYB1HrlIVSU9Qdt9qZOlXD7KgaNlUCqU
	URfcx7rCgYVQWYmY69yUNjtSVnFwzeLTbVquCrdITtWP4fZakqQZLdYUxzBcgeW5
	DIbPs5xsSyfpl/QUz+ug3yi6JZ8Ygxatnli4JcNe/RHN1ILL6pJg5VP9fMw28CUL
	/Ptmg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ffm6p0hb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:03 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:02 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 62E785B693F;
	Fri, 17 Jul 2026 08:30:00 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 18/56] scsi: qla2xxx: Enable get_firmware_state for 29xx
Date: Fri, 17 Jul 2026 20:58:26 +0530
Message-ID: <20260717152904.3155730-19-njavali@marvell.com>
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
X-Proofpoint-GUID: 1UcDHtR-Mi_2KKu8htO72OawKSQPCMpA
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX7soWeSRLvANK
 7kzJx/D3ieTcEmGC91WvFWGGvbweUWqc1toBVzlMzIbhI4uXkwPDaOg9Z61aa59kpEx61GwA2Lq
 0VjfxrMNxAsHcHncK3dPcyeI1mTXxXM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX2PfI3GAZQQ8N
 iBzY5yVrEW6ZqPa9uC+rsEEpjGPJgiJT9zpPWMJh+QczVzDak9R3OnjPX7oU5FsCrAxPGK/V7kH
 I66n4BcKG326CMi9lMxp7uHmdUp+Fqp2JIr/qEXal4IBc8wtB/QWoX7v9IxOEeWmJaNDBKJKwuR
 arAP0Ap3SP2vLhIeY+Ddz/iCK3jHcscN7WITr8mfTaH5tyyzGrZMPzDY55CIYiDNbzg9oF9FM0d
 pbtpiEUu4TcUJJMhqX2kPfcOaLg5k+FVG0YMXtTaA8uZEUsq1S+s4ftUcz753eZbn6TdF+AK/yv
 i8G8XTgrQsRxt6jBJOdhFSEIdweAN8YjhVHEnUgZQSzWbFullKAl8MTP60ikKPHaB1u8hg9feI3
 QrEPVhgFgl+WqOWGlyV/quCYANU2MQq4LXDOSY3Es8O3oAwbETV30YzE98xUAOPRtKWdqJ1OTDS
 sZ+hJoBwFph4SFteLvQ==
X-Authority-Analysis: v=2.4 cv=Wa88rUhX c=1 sm=1 tr=0 ts=6a5a4a7b cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=jXld2Aqxrx9nTAx2xuoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 1UcDHtR-Mi_2KKu8htO72OawKSQPCMpA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

