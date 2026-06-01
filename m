Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5784939B962
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309810; cv=none; b=PFVagM+tjpvwdzgXmykkwjS/JTGIesG/zswnH+IPqtJ/ku0Rp++8oYJOaNFk9d6bqfDDiY/CTaiLz+0Syvy8YYCu86a8RqkfYfDPfCkWGiEp72rkLOx23xtWkcRThCp3Rr6xpxqgtUUDSmObZK6jvSqMKfceBBQDZlm5AqVE4oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309810; c=relaxed/simple;
	bh=ZYOLxmNrvULrMBhlIzrVWOVOeTYJ/a+iPIPFSGIBYII=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k3/kNBg4EplZ9q3LMWu5wFqaqHXJgJMT+sO5IGHLWgRQZ5W1ygunA5975UGoaAR+T9dx6S77VUN5i8Bb7ppUyT5E4fw8rED0h5/r84B2td9iEYZRQlLw0JMUjlKgP2FFq9/P6scBOrsQi+MkJp3ix9hE86KnfSrklNRUeKJt0Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RtJTmQR2; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RtJTmQR2"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6510rPb62995274;
	Mon, 1 Jun 2026 03:30:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=F
	9CoaKxli3fwv3ljFjdv4zW5ae4h6HZw/+UMr4egVQ4=; b=RtJTmQR2qOtAbjhv4
	kNEKFt6c9RolDvZVSCESsNdTg9Rk1fZzx1iEI2QkIF4ZV7JJncDMv19/EvLzm3D/
	a845m0Zhja0bee4EJoNk5sHkTAQZx6UmmUgYc7AWY81ADea+ATFXxqK92G0wt67L
	ZpeBMX2rGYs8R5i24KTdPoP0O5V0/lAA4gkbVE+a72IhOOgRV2HIMKiFiBLcaybB
	7B22Xb0+UPbDSYW26AYL/beWyxL47Nl5WA5c9v1+Kgj0j2FHmsRG4+tlqOuDjJgM
	siycAcVRDIpkWWfPZAgSmHT3HQ6Ss2hQPZXct1/ep2lbcD54lTZhjmU2tTJsq6U1
	Gl1+Q==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4egm56jycq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:05 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:05 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B0D833F7055;
	Mon,  1 Jun 2026 03:30:02 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 16/44] scsi: qla2xxx: Enable get_fw_version mailbox for 29xx
Date: Mon, 1 Jun 2026 15:58:25 +0530
Message-ID: <20260601102853.328426-17-njavali@marvell.com>
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
X-Proofpoint-GUID: MUM1fFc0_NxPO0KhRut9kASkjZkaXwRr
X-Proofpoint-ORIG-GUID: MUM1fFc0_NxPO0KhRut9kASkjZkaXwRr
X-Authority-Analysis: v=2.4 cv=ZeYt8MVA c=1 sm=1 tr=0 ts=6a1d5f2d cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=nMT6ZNUuZrDJHrgKV8cA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfXw5hceGwxFBGO
 +ku8+mvqCxSpnuWkwQb2Xok3Psp+sLzh9LQlQ7xHoOXtlBos5+ME/Fkw0A0jkW0s1H3FzPDwGf5
 c4brTgEziv/EFbulKyLuJNHhnc/Td46+X1/6YsZm05sLxpyG/ljBL6xsR3grfyukp9hEL9Zw5FV
 U/jpAAzFP1XU5asbfLjXobUhVG0+v7Hb5zBqgqQpb+tac64JnLVpxmcQ6tfVNIwqeGw1AZvO+SQ
 tbfSJQpFIql4NYuuKXSjbzO6Z140nCnDi4A67w+aKK+c8dJ4C54M9FwkclBtNh8D8dHbz8MvQlI
 CijZ7oTrCHF5ztXYgJkWiYqJXoDBB9ZDo2ZD22Ll7nt9JqN5Nrct+TwHGGLjbqYEz5onWn19gX9
 B++jU1HJY7QN4pAJ8S6SpIAcYXERg3YYl8p7adM7WMECZtyJuBH4XcEBDwf77x6tLiSOw4NiEwu
 /zGmgyrhdnHqpE3PSGw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

The serdes_version and several firmware capability fields were not
populated for 29xx because the get_fw_version mailbox path
excluded it from the 27xx/28xx checks.  Add IS_QLA29XX() to
the relevant conditionals so that firmware version, EDIF, and
serdes information are correctly retrieved on 29xx adapters.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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

