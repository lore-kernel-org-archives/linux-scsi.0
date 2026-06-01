Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1E034F48F
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309823; cv=none; b=RfB3CnTBuMebd1nRkGc1353rlxNkk90m28/T2C8/Umrf3c5u7Xc0ut+nqg42Pc4aH3mNkQAraR0ZfPTgCi3ktYK2SG/dgWaQaHH6tfnlCZfLli6Z6tFQnJMo38iPxU3pvEvNV//Hvg4MDCc+WvuyhUFOd9Dzt2Uh8aHaMcsPEnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309823; c=relaxed/simple;
	bh=tISvUMcz3ypbcMAukW5/9D3HI3R7xiwXcmcP/71b9L4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=soSKn+R90UPrzOxf3cs7Na6+2zm8GQ6h7ArOxbF0jrLE01dW2MvUG02+3rtzyCTkWOPNiJOxgFoUwEqUIWyeN0XoQgwJHX7xyWhHOxutnvLziCTAtKSHhHAV1vTTrNZoIINhVXGOZ/ooOKWQ7WdB2uOtmn1vQOYyHQ+aDIncgxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=WWchjIK9; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WWchjIK9"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLxfYT1231225;
	Mon, 1 Jun 2026 03:30:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Y
	xt/Debo9hAyAcBRVXeMV94fdbfVagrl2H4HbyxTfIk=; b=WWchjIK9nwk0wPPB7
	oEFnaOCQsVThlfcAdAacsY3nLOpxY+uzXYAp6YrQfszAnskIcxpyspTdgagrqDh0
	BWDcImhyamPK64sBhyEGoIGvZ0ygUO8JBB3+fzzAJQSUT58fR/x2cXBM/Ke3p4wE
	5fuSbU4LeiqiPdV4QCEwajpNM/nGXah+hvc86SnwyTFhgW2e1ajZK00yyk72iq85
	/LcZro8+UsO96akToY29OwU3Oj7nj2umX29qjVikJ5Z/NF2RPK8VOQX03Q8RL63X
	dHbNvt0AiP0/c22Par/HHDYsIgKBb8nt5NzcC6MyJqOBzD+98D58+g/Lo7rrhWQ9
	TrLEA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b41km-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:19 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:17 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B647A3F7054;
	Mon,  1 Jun 2026 03:30:14 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 20/44] scsi: qla2xxx: Enable get_firmware_state for 29xx
Date: Mon, 1 Jun 2026 15:58:29 +0530
Message-ID: <20260601102853.328426-21-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX3U2Lj0j4vfb5
 tUUwUAgz7x0JItVo9BP7PRNILUcf+ucYncxamQKYGU5vgc/8WIYn8gR7VlQpDZmWT6zVmaghIuy
 2kJROv0gd1zsAYtsyKZZDLsN5ROhOhxV3i6Ysu6uWac4crKOJgJjwTlkLHIT9nrwrvreI/ROY+x
 wyN5yd2QWH+9XMp2acaQBy3XdIxq8E3sDoO4D/F9zBxPHZZgE9LoKZuUzCaQgFIVZ+btTSz3CFy
 wKINEXwvTrH0hL5ntxIPGz5dQskCPepaocgYh/j140DxkX9NvdKwcf/6w48+X4Z1ULc1gdYw4Gf
 yutMRQjYNUWenoN/xheEO9V49HH5j50Vxt/DVtNDv2TChu2Vq+BOpN2Jfkcb2I142kbtIBMmgjG
 AWtEvrqg2UbpPT8yGSSeFo/QAVQt1n/qaXnTXvFYLG1qcLu5pykO9QBKgqqAuBYsV5xImNNGOuD
 HrBDocaPPSHW0KBkbHw==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1d5f3b cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=huUdkCh2h3h8dLQvukgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: ha4mPOoF1a9n6A4xaVPbjpksdHAadznH
X-Proofpoint-GUID: ha4mPOoF1a9n6A4xaVPbjpksdHAadznH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Enable get_firmware_state mailbox command for 29xx adapters by adding
IS_QLA29XX() checks alongside existing IS_QLA27XX/IS_QLA28XX checks.
This ensures MBX_12 (MPI state) is properly set up and reported for
29xx adapters.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 735240405ad8..0fdb869304a3 100644
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

