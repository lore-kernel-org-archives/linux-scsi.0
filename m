Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA95B13AA2D
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302286; cv=none; b=RsY9ypRF+Wo7WsuR0o2hIrqdNGdJSd9ePlWg+QqM/Ag0zlioaLYKMi9+2VNpJ/hmtyI9RucCHEyiGHzd/cd8SkM14ymYPisYjrp5PVbAlRJhmqjmoiog7CV4zDJW9EOzcsvBxbT6uO4zcvLAzc1FOz75QYy78fUo4nBgsg6utME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302286; c=relaxed/simple;
	bh=2g0OZbzyNlcbpl6670X4NvJXIlwPRy3To/9y5PdLKf0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GctHcem9veSG0pKpPAy6UnpdC5MXVng3hRhNgtH1fmipcLPYQaTJNNIU0NHncXyLM7S5+jNNogzJ4cCoZukJxOARBaLfCWgUrBphfqc8YOud0mvZl8Ksu+uWEo6yxlrZWab4UN6OLaJdwMDs7BrBl5cnfdfvEWPtSxV0MQIrPyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=iSTeyx/n; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="iSTeyx/n"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7tar094736;
	Fri, 17 Jul 2026 08:31:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=O
	JPGqqbn5HindJKnJV9QtnYkoZD0K9Y87bszxDmyilI=; b=iSTeyx/n2mzNmYPPR
	qd17KwNCHeWFdncDD2u47bPIbIoJNmv4PTTeIRs4UgtW7HXjDts2Ip6R6Cgp1irh
	LUvt5Deo6j/TCxIZKGc1aaFQq/K+pftaHI/mzMiGdXNyYmakCF99qwLWsKHuPsKl
	2wLOVuEdnSCtW8f/j6O2S7Vagjb7gbhMKReKIFuJjg3FTCaxlQskj6ESTZo7Z6cK
	iPexiWl+TwQ9bM+GBtoJMLlAW8MzPPdxFfSB439jUEjoZeYaVro/nLOAIx0euOJc
	tgE1RfsjdGfEqUZQfk4LoQcpz1R3mYGyFrbYpvVQ7isH/hdpHDNoN6W8UWbaVqsU
	QCQww==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxhk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:20 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:19 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 125FC5B693E;
	Fri, 17 Jul 2026 08:31:16 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 46/56] scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
Date: Fri, 17 Jul 2026 20:58:54 +0530
Message-ID: <20260717152904.3155730-47-njavali@marvell.com>
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
X-Proofpoint-GUID: XTDl7i9VlzSv0X_GrkfkVS7aIU2u0GOk
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX6sJllMwfdmCE
 weyaAJ6uqZe4hd1uxUMnYsa7atGg3HAMW0dfxSXjQtCGiScTct5I/RMMRVLzWglCOad2r5nEv95
 CrqdoZMuKGpvlb4gZD1qYTnnPSjnigo=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4ac8 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=reP9pj-AO4Wx2xJZjeUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX52TnZgbJDDxl
 mgYe/aStRSVUvpuQ1ZiDh3t4HPKcPYmaRc3pug5Fx7EB5HixAW0pDoiJfr2xH15QHoFFihpxjuW
 rEZw+LgUgtHY480or36WDf9VQ9cd1MBP23e2NwuACG6LKRtG3tLe5IVPH6U4pN6cPfn1AMHqhzx
 KTv3Jv9SJqKn62soOfHmf9VmBZZx4g7NBDCTDkK+a0U2WxG6VAm5iWQY5qEvegh/+oMefz1O0ZG
 gWsR4LhYfHudMsdPibx/nI5Ig4NUYXZTwOFbeQorP5Ig3zjn829LZgXVkTBAzLsx1iIi0GlDxV7
 Ac6wAQnHHEdJMytHHjFKGjqfuCiB5sSTHtBsPpCGhWdnVa1vLQagzAjoz1ojHKFR/CzJPvF5oWA
 KNShbrTQ3qhGi5OQSaH83m3+cui6DYhNmd0coIHCI+cv9U2kVIUrD9kOpjHUkUAFWjlqga10plx
 +cd7UI6QolJnGo/rMZg==
X-Proofpoint-ORIG-GUID: XTDl7i9VlzSv0X_GrkfkVS7aIU2u0GOk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index ade1d8178573..bfa520f936a2 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -3540,6 +3540,9 @@ void qla_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
 	uint32_t handle;
 	uint16_t sa_index;
 
+	if (!cmd)
+		return;
+
 	handle = (uint32_t)LSW(sts24->handle);
 
 	/* find out if this status iosb is for a scsi read */
-- 
2.47.3

