Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD413630AE
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258099; cv=none; b=UAZL4tDu0KUaM67u43ud7QFOpDqs10a4pRAZShFoF7kDJPU1lNYrvKtSehFE2E6ordYtjJtUu3x2awsWN+7smL/Rff0EdIHOmSyyKCt68z4dFLHKGbe7wOVE9IR+JwTXt+2IPb4oSXvwO3h6jMLcMMF+GfIylWdk9MFR199oe24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258099; c=relaxed/simple;
	bh=KVOiO4Iw+FC4v8A1ofJaxFPTotrq0i7CQYWw83419T0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YlgbeXyocDddhi5RTuP1DX0fFg7+prPWJtrB9bAgeoXH8UZRJ6cKXH8yOo9ZOo+tI8QLV8qCnGKbuB0l8cI6bqEyUEZyW0rovtUGFlEdAIxqO8rE5Q22p16UP80lrlMv1yrgXcLzecUEKvpZhZhHPTzqTDghFNfKhn/KBsJ46vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=QgjT8I9p; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QgjT8I9p"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C5FcO0273724;
	Fri, 12 Jun 2026 02:54:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=H
	Jk3jIYv/gmGnYknWVAmFJEguyt0zmqX3uJupGI6KtE=; b=QgjT8I9pC5xLqGjYL
	w9z/EDSV1TSszJkDnwGFzUN+OcMeazNf6IRnM9Ai2+tuvLWrKkWfrB1NpC8ZfzVB
	IfjUUqHtsGIbiI3STpagI8BAC/1wtz/gMa+MoW2c4a0lC9DWeIkKCdeLeuEly9Ae
	wunoE/do+daMR30nBeya1SUawmvdu7MjmSEPJRFMy539jtw03iVNKqLquEBlxJpz
	H+Loi2gyi6AMoQpLTqopKhfiiJrMpZ6FTBpAtB5xhd4Y9uMtANt4u/4xP73QXoza
	SRmQvBC6dg3fAz8q0cE1kSrAulhtZMat/U1FVWnElS7f2V6SRSQBJpbbMWpdi5DT
	rsdCQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5r6ru1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:54:55 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:54:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:54:54 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B60373F7040;
	Fri, 12 Jun 2026 02:54:52 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 19/60] scsi: qla2xxx: Enable init_firmware mailbox for 29xx
Date: Fri, 12 Jun 2026 15:22:52 +0530
Message-ID: <20260612095333.1666592-20-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX749VeDN3Ipom
 g/LprQsRGZXPYJa2j4qaUzJro+8D+2jqdULx5yXMJOmlMQefvodMuKeCVtAGPceTrzzzPAXv0rK
 upd5Cf8p/FfykhUCX1WI/ZMTpeRohro=
X-Authority-Analysis: v=2.4 cv=O6gJeh9W c=1 sm=1 tr=0 ts=6a2bd76f cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=D95N2Pj2omZygidu6DcA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: R81hl1b7eRVUgrKKFu6GVvgn5YgNgq-T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX1hhmmvRPnR+M
 oYgU6O1iunN9Q939K2TWcDm2aKJm9eMX20s58bSqB2v2WOXRDljFA5i/J0rAK2go6b4Mu3eotXu
 TRLFuVf/26FrFHum/qel1hCs502uoQwUWiuKudQzFaKJ9gdvLPWisb3/8rskZX2DVjJISd4zxbm
 kNTtyqcurqIjqzURRnNsLAPOGRkgrhXsi86/QJ1a4sGKupqqo08aRtxAPBtRBTYrGPG/Z/sn07t
 +n6PPGkeldDTw09RGTqxggyxvqEpXNHCx+DLyIgZxlIFNtf8SlhNNJS02R5vglQwNborrpoqtFt
 n0mCn9jpETOD5cJncRpbdOQGTmojCQwKDh6xrsRZ1+wJKRc8ewyhYmiZ6c5nSZDKA1d52noBTeL
 Cf4z4rR6dZudmWSsNS1gw/2Yaxu15s245WmscGUfjYI4moeODmoolREd4+qkGzVt0zS5WM2rHpT
 Kuqk49V0FesHQamKKAw==
X-Proofpoint-ORIG-GUID: R81hl1b7eRVUgrKKFu6GVvgn5YgNgq-T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

The init_firmware mailbox command needs 29xx adapter support for reading
back SFP information via mb3 and for validating SFP status on successful
firmware initialization. Add IS_QLA29XX() checks alongside the existing
27xx/28xx checks.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3fc08120fdf1..9c78aa66e12b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1968,7 +1968,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 
 	/* 1 and 2 should normally be captured. */
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		/* mb3 is additional info about the installed SFP. */
 		mcp->in_mb  |= MBX_3;
 	mcp->buf_size = size;
@@ -1992,7 +1992,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 			    0x0104d, ha->ex_init_cb, sizeof(*ha->ex_init_cb));
 		}
 	} else {
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[2] == 6 || mcp->mb[3] == 2)
 				ql_dbg(ql_dbg_mbx, vha, 0x119d,
 				    "Invalid SFP/Validation Failed\n");
-- 
2.47.3

