Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E586311C37
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361798; cv=none; b=thINKmSPdInWeA58N6zX6eOt8QDc3ASh1msXIbIfDp5mU0AMVi3pFGEgCCZvnAvZIkGJUDVoT9cMaq9uvMsev+wycieLSzAyeZdcejCtzsr3bBWjMTO4fdSixB3+r+P/Iav5Wsb5PZweOa4iJyWKetlQElrRtFPqfbRxgmkOD5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361798; c=relaxed/simple;
	bh=ztnGqscf3Kvc0lfKNWsxebXjPBkwt9Fa1EMXVa+dAZY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I7XH1S5BpyrtAPd2jIDpumsqUk2rXJ7rDNsGPVyDtgEz4LjzKKuzB/xXtft8KpFhTs82/loYYLCYM5oTuC0Gt2pr2qVJwZLrF9TGNOha3rtQ8NQKMGz+mbA8X8INWF8u/e5nVS/Hipf/hg1DC1eAqprxaa6UiIFDowUsmOF9zE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=fail smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Mf0Fl7co; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Mf0Fl7co"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4aL8d3329357;
	Wed, 10 Dec 2025 02:16:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=p
	auVjL6HmQmivqA8OsH4TNFvndjpq85ktv2VggY5cKA=; b=Mf0Fl7coUu1gdPz8Z
	Q46bG2VyyPLZrlcFeX53WKlGkDP+4xXwrS/sh5M4FL65zhmvEzfkazg69VfkeY6X
	yfUo2ibOxLrt02Pep36vVaQGQsYehrOesAQsoJIWcpngRg3khVaHbH9UHlb3NZvT
	rdraO983QrgByB/bm0LNLQtTZ6poco9AlR2qou8hTjnGexuRPrL3EgeyvicZd4zW
	tPo5nr/AKu37Ah3YMcIRiy9ZlGJotnl35+gapd2t9NsdZLQMX2SohIiPVv3xj40t
	hG3ScVaPUgfdhd/sN0oMCTm47Mz6EpBv/GhBzOg+uRIC5dH1HiwIokhMHArSOp0R
	outgg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4axuknhj15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 02:16:35 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 10 Dec 2025 02:16:47 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 10 Dec 2025 02:16:47 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id F39C03F709D;
	Wed, 10 Dec 2025 02:16:31 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 06/12] qla2xxx: Allow recovery for tape devices
Date: Wed, 10 Dec 2025 15:45:58 +0530
Message-ID: <20251210101604.431868-7-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251210101604.431868-1-njavali@marvell.com>
References: <20251210101604.431868-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Aur3d8lFHmkm6J6Xja8CS_mLAFDj7eok
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4NSBTYWx0ZWRfXxjnz55ixKfn/
 U6Z6yjUxI8Sl8j45J/09CiVwwEn7BJz5zuR77yZb8GtA8tCtlrda48QqVaIwAG/6L1mOZK22KMb
 4IkL4XSrRDx7CJZgC6CWrR8j1VFFQASAf9iEGT1uSbajvndq2gLndSoQlsMrk7zygFzjDx1q4e9
 XuiU/VAQBfs6ZV9SXk8KtlaAphs9S0IqgGm48R9yyUiyYSQmVdHo/OYZW1PuXt8qu4RMGy4xA06
 koanY73xXu+yHxcQMGKdblqlQ8fIFupZCqcnhaUXXLpJ2YDmqaLxbcS7RM1s29kQGbtNjnpv5Li
 HUCkSBQtPAHvOglv/dnZopqTDDd/d79qJ+MPPyVD8zzgwiziExf9GonFEXf47qWyd5yqLX5uSPS
 Yjzb3vBrNttHOC3bVBgwOLZcTF+uVA==
X-Proofpoint-ORIG-GUID: Aur3d8lFHmkm6J6Xja8CS_mLAFDj7eok
X-Authority-Analysis: v=2.4 cv=P483RyAu c=1 sm=1 tr=0 ts=69394883 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=9c9XOHCOo3frZ98gKQ0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01

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

