Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB1436998F
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309831; cv=none; b=tbtFh9qcWM9et8dq4epsoPyCFBcccGUA6UwEBwKuvDuE79AlzaNXKPrs/ZYc5HQ4OJvtftYlmH7txjCluDqnhlFi0p14WH0FmrvRqoJyBh+63ih6VTiwJ884pyfz+1oP/mpmnySb8SFGryB5yX6Wjui4Kgcht20AgOvdUlxeXSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309831; c=relaxed/simple;
	bh=E+Uc3Zbl8hXNCOcDGmxTMxq8aif+ffFWNQuLJJKuLi4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nqoCFW6jMzYgPvTO33aSisWhpguGFwCft+TPm7bBxgcuVxoBMUyanIpDSDEibAHWVD1eCGEk0wm8cTdsKNWJ/HwDa0be0ckwf/Vl7Uf4Qauv6HlGGz8VVQttv03R4ZsW/Jp0fWBiI55vhYG0zi2PogRGbryX+Hhe9kiWIhm9q8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=k4v6ofPF; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="k4v6ofPF"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLsEuC1222214;
	Mon, 1 Jun 2026 03:30:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=K
	t4+zFXNIqH2Lb97V2PTez7ysfLiYWulQ3RRmeeCEUQ=; b=k4v6ofPFnhIPJCtsC
	OJUVSph1oDwt90haunKMmqvNO6APGHAOS+XoE/ifY1WgUbUf2RIn8Ay4+mPV8FZJ
	OjccYCSHhXUgCrm7X04gmbyWSbA0nuf9dCU9gmYEyQKtZMzkW7ORa7uUwxkV5uI6
	CJB4NI6IWAqr4VYN5R24aIy7rV1JAEsNQc9rYXA+tSJeYemI7mJff1fty9MVpn/m
	C3SBDTMAHqtwaDRpH8Ato6XlpsK6gp+GPnT7NUjE5E6IxCHzz+Svbm4uvHKTUEx1
	y4jVGPsJ47olFdQ9HmOMrGzLWHulc5VC3nqAOLAwNxFDy0cZ/96fD7Qyn9jWjwYa
	gIKhw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b41kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:27 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:26 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B4D993F7053;
	Mon,  1 Jun 2026 03:30:23 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 23/44] scsi: qla2xxx: Add support for QLA29XX in data rate functions
Date: Mon, 1 Jun 2026 15:58:32 +0530
Message-ID: <20260601102853.328426-24-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX2OxpkLoY3Ag0
 l8++O/K7DUfzH/P3IiGLHDlsVIPez9j4XmK9dVdq6nCCYwhJcUVSRt/JrKRfdGctZOp2srMKmlm
 iqeHqe1i7gHgHqTFIrM8c9PRiiEa5F4q3Cuycff2079QXK4yrJL4SJfrhqkP1+4TmE/s4bZHrZ2
 mU/fjstKU6t+Gn11HQ2wwEqnyIB7TWkH3RAA3m1+C+Y9kNPb1SIRZhgYvVOs7uZdv1aXW5qMbvF
 I/aIfq/QvF1hj8eh7+rsOhJXYEL9DhuAsx+liFXNIzfvSn1D2GM0g8rE2jrKi0oJ4kMI8dbNWyy
 AGO8q34O2VA34OJAgHvUvq6b5w5OHYtxLVBtFHe/VmoyijB7YzpaujvnnbPzAD8eLgUqdazs2mM
 yvAVkiy6KamJukTthjviWaKOqRMeRnyYUW2gPXKJumwOBrZByYWxcRIujjOo1f5WtLMWkLg14q0
 kJH61dKBDPDPERGDflg==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1d5f43 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=Hi-jaBFzzGmvE3R-_ToA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 5GXv6mNcP76GrcBfp6xA9XwiMGNL419_
X-Proofpoint-GUID: 5GXv6mNcP76GrcBfp6xA9XwiMGNL419_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Enhance the qla2x00_set_data_rate and qla2x00_get_data_rate
functions to include checks for the QLA29XX series adapters.
This modification ensures that the mailbox commands are correctly
configured for the 29xx series, improving functionality and
compatibility.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 330371c29c6b..dcc5d15b1656 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5683,7 +5683,7 @@ qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode)
 
 	mcp->out_mb = MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_4|MBX_3;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
@@ -5721,7 +5721,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 	mcp->mb[1] = QLA_GET_DATA_RATE;
 	mcp->out_mb = MBX_1|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_4|MBX_3;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
@@ -5733,7 +5733,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 		if (mcp->mb[1] != 0x7)
 			ha->link_data_rate = mcp->mb[1];
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[4] & BIT_0)
 				ql_log(ql_log_info, vha, 0x11a2,
 				    "FEC=enabled (data rate).\n");
-- 
2.47.3

