Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8D42C17A3
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 15:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861498; cv=none; b=uUKzBzOw88TCLBLJ5eUdealwBwxuCK/Vp6gFIu76whT5NaPGv3IKTydxGuq/Y1QrO7OFOANDgkqPPNTeW7j/8BcwM2PXOlRPsnIl/TAhJwGMOVybc8ysKRU0PmYxPQQwj4OOdeyoufl+heYT7ej0mnIu13Lu1BsGIInhFWE3ycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861498; c=relaxed/simple;
	bh=ztnGqscf3Kvc0lfKNWsxebXjPBkwt9Fa1EMXVa+dAZY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KIrcHF/BiiuAvBmwcMWhnF5OcLIO0W9Rjpk6U1MXSe/jG3D3euotTcWOvmZ69RIbX2otZ9vKkveJId4TZPLZ1y6CkvllIP01DDE5okxXptNbPWhftpK1bQgiNJEpRZipvMOMSbfdCvbXfiApmh4lWruVreWhWHGJ9x2j9JzOaHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=a9NkxDk6; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="a9NkxDk6"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B46ZVAc3332972;
	Thu, 4 Dec 2025 07:18:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=p
	auVjL6HmQmivqA8OsH4TNFvndjpq85ktv2VggY5cKA=; b=a9NkxDk6h0iz1ONm2
	aWF8LPPBBz7Pdx3FYOEYKjOOC+JTJJ6hp54mNBczl49/reo0Wzrzquw/HMSrgUCm
	8w5JwuKFVbcymfhy3Vz8G3Kl9bnbg1BuEWW4t8p/VgLP9fgoxIvEJ8QEGz4nXale
	diRe2FpxRmcH6vVxrF65CaoRc3M2ZmFUpduV6+EoRtRdEni687Fw96ThUnAk4JSh
	ayc/cntMa0Wv2Dlv8FIv1/wqktJDOi7MwVHqrnc8th99cec61ItxxiXWhtahkSBf
	+n6esqKcClLZgFpPyd6lCIc5rSt84xMhTufInm+6r0V6y6jABdGu4dRdoUeyQtGG
	jPfjA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4atjuu3n4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Dec 2025 07:18:14 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 4 Dec 2025 07:18:26 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 4 Dec 2025 07:18:26 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id DF12D3F7074;
	Thu,  4 Dec 2025 07:18:11 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 06/12] qla2xxx: Allow recovery for tape devices
Date: Thu, 4 Dec 2025 20:47:45 +0530
Message-ID: <20251204151751.2321801-7-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251204151751.2321801-1-njavali@marvell.com>
References: <20251204151751.2321801-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA0MDEyMyBTYWx0ZWRfX61jqOuqUo+zo
 oeQ0Yv7Frj3KyWc9HtgezSEAm5k1VCcp+c94bHQkT+jXZVdVCX2UcDBwUSlCEGr45m/g7DDOvmF
 jsc5ChkCq3XlhgCefIMkc3bIFKbikqwH+IQ8H8Vuj1mbsbwKixnijRrRI64bKaW8drl6rlPl9wP
 CqgGI/oKabkNNk1UlWKcE5V/cgrx+RyndMng5qLiXBPvbvw83OtezmkPNk8AN2NiLlUCdAl/BOx
 Vd/d9THiwRv3Hsl42zhFBXlur1q9vlCo4lxihd+fxxWWVNf2OSDBEZzZFIKSSE/RDK9ZcO8fJqL
 jVOahy8ttCVfePq8ppLrnTvmoHOdN2HvIJaYzGLAf3jjmnpvgQHqvpNXKF84Tbo9Zekt5fzZJPW
 3QCOgVSESayCklpWjhZVfpNPA7fsVw==
X-Proofpoint-ORIG-GUID: G_6KhXNjjoHou-sazni48YZoSyfyGZcb
X-Proofpoint-GUID: G_6KhXNjjoHou-sazni48YZoSyfyGZcb
X-Authority-Analysis: v=2.4 cv=E/nAZKdl c=1 sm=1 tr=0 ts=6931a636 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=9c9XOHCOo3frZ98gKQ0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_03,2025-12-04_01,2025-10-01_01

From: Shreyas Deodhar <sdeodhar@marvell.com>

Tape device doesn't show up after RSCNs.
To fix this remove tape device specific checks
which allows recovery of tape devices.

Fixes: 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target")
Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar<sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 3 ---
 drivers/scsi/qla2xxx/qla_init.c | 9 ---------
 2 files changed, 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 51c7cea71f90..02a52c215797 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3266,9 +3266,6 @@ void qla_fab_scan_finish(scsi_qla_host_t *vha, srb_t *sp)
 			    atomic_read(&fcport->state) == FCS_ONLINE) ||
 				do_delete) {
 				if (fcport->loop_id != FC_NO_LOOP_ID) {
-					if (fcport->flags & FCF_FCP2_DEVICE)
-						continue;
-
 					ql_log(ql_log_warn, vha, 0x20f0,
 					       "%s %d %8phC post del sess\n",
 					       __func__, __LINE__,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4582a92c742a..fa4abeefc0f3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1859,15 +1859,6 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	case RSCN_PORT_ADDR:
 		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
 		if (fcport) {
-			if (ql2xfc2target &&
-			    fcport->flags & FCF_FCP2_DEVICE &&
-			    atomic_read(&fcport->state) == FCS_ONLINE) {
-				ql_dbg(ql_dbg_disc, vha, 0x2115,
-				       "Delaying session delete for FCP2 portid=%06x %8phC ",
-					fcport->d_id.b24, fcport->port_name);
-				return;
-			}
-
 			if (vha->hw->flags.edif_enabled && DBELL_ACTIVE(vha)) {
 				/*
 				 * On ipsec start by remote port, Target port
-- 
2.23.1

