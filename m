Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698F23546F5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258201; cv=none; b=tZrad3m8/wOVvedFDQobs7tsflad8pjBvKCuaZiw/Yd5uB6LKLiwog9bNbBqpwFXEI0AEQabzBAd2ApbSpcnpxDfKJU46Ts+bSclh3APcKvy2os20P9qCTit7smuEj4W8WE9Ruv5Pg0LntPQL9u/6y4gJxWX3nWHzpVunqbglP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258201; c=relaxed/simple;
	bh=wxG03vFqc+1QdU7LHypgSSZt0Z5ZJ/G1X2Rqx1Xgfew=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I/ePwdwaHRApurl02vcdF6VHFgGiWM4X59nFoEfTOR8PeyUQSHjJPuk1C0iwPAFA0dXCHiZ9xneQ0/lOKPC60oS/WCYoxZpZg8gove1wMu/6MrU9Z2c5qikjA9tDjHZow8ufVqAUGEUhEx9hCbMk6vCcgzB7Tr5gkScRPi6OytU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=g5ESecga; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="g5ESecga"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39qC03679423;
	Fri, 12 Jun 2026 02:56:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=V
	jTw9CDPmt/LoGdQaKPihmphbFVkwbRdqMM0YmSFcwE=; b=g5ESecgayPZKCiygq
	W9Eooy7/LuAnn2KsXU/8EQP4GL5L5tRlXCju8EBP5gPu4ugh4Fo9pB9bQMK6Q2BS
	yxA45pbUl9ezOTlVE90jMolHLkqP3gQ9RtPCBzJKIPQPIFCfL55rtExsATDC5mkL
	fpeuG5x3LC8qO0oWQCcGpaBA2/KlyfrpBuiHwE2dFCUWvyVQkRyTdutuCdHaht3y
	QSqC/l5Jkys5TMRX8KKNRwaNGS+KOF3xPCUh0AvY4tIh+6dZ/bLzwbdqT7rekyKM
	WxmJakuXNHtATcKNJkKSUPKwGluwwLMmJKMCQeoB124TRLMWqGVm9ViGitUFX8pJ
	s2Yvw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92nq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:37 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:36 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0E5CE3F7040;
	Fri, 12 Jun 2026 02:56:33 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 51/60] scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
Date: Fri, 12 Jun 2026 15:23:24 +0530
Message-ID: <20260612095333.1666592-52-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: WdPoD3mZOzUKr_q49WyWsyo815ivJeQI
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd7d5 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=reP9pj-AO4Wx2xJZjeUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX8PotcsW6mTVc
 uaZRLp4+T0r3aonOKBUkUj1dRu7n/gI1qkUiftnPEanHfelNxaY+Rvbc3xuEtIT+E6LFXggmFIO
 sfuNSWHI+bXy6dVSuGXUq9Q+wzZqHG0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfXw3n4C+DyMwt0
 6Z7iqIRfe7ysiVX2C3J3aZRAUt7uOnyzdywS0wloV5I6lcJbXblgyQ6TxAb3xC7ERwAGfJ0Gj6j
 GLfFFWBfi7sbw5b/QgTAu+wbeSMnjmxdV2xQ02g2+YqhdMC8AWMsa175bBJmE/NjCaaokeqF5Dj
 zNs8rDFQ2Ko+wCTHzJOTIk1u0G0rMCICLQQyxB/+VlQIDMeNgd0fgCjg9fIOiXzJ+C/d0NO70TD
 4r2nnIHx9SHs2GicvLUbetTmd3IHvWOzOWMCc2qC3zS+4Mub3chc9owhplwPC6pJWUNKsxKwzto
 rviwVEYOq9O3i45oSDsvxZexwMUgVa1Hqtw442kJppdJo6mx8YLRfaUemXX+MXJER71dNm+N0UP
 PPyniBlXaDz4QHjCjy+GCCjGThYyxjyzf9jP7lUtVK/wBPJQk4xiyEq883+Wc5E3W12+DTW3D+I
 iGhMLZfhHh7PdAoI7GA==
X-Proofpoint-GUID: WdPoD3mZOzUKr_q49WyWsyo815ivJeQI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

qla_chk_edif_rx_sa_delete_pending() obtains the SCSI command via
GET_CMD_SP(sp) and immediately dereferences cmd->sc_data_direction.
That command pointer can be NULL: the firmware may post a status
completion for a command that has already been returned or aborted.
The caller qla2x00_status_entry() acknowledges this on the very same
status path, re-fetching GET_CMD_SP(sp) and bailing out with the
"Command already returned" message when it is NULL -- but that check
runs only after qla_chk_edif_rx_sa_delete_pending() has already
dereferenced the pointer, so a NULL cmd crashes the kernel in
interrupt context.

Return early when cmd is NULL, before touching cmd->sc_data_direction.

Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index f8bc248e5d18..c8889ea199d3 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -3543,6 +3543,9 @@ void qla_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
 	uint32_t handle;
 	uint16_t sa_index;
 
+	if (!cmd)
+		return;
+
 	handle = (uint32_t)LSW(sts24->handle);
 
 	/* find out if this status iosb is for a scsi read */
-- 
2.47.3

