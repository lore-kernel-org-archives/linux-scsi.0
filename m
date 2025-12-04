Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484F628D8F1
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 15:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861509; cv=none; b=tHbmM6KJCLNR1YL9JD5Pu2g64bthM8VYWYYajC3vwWZ2AIKnCcYqxZ2+v37yO6I3X42dK36U7vKx85oUuHg1jwcxfjQlNTkSszYf3wT2Zok7n6GczacdVLoFkl0Rk42RXTNV/Sld+s4gpmXQd6AV57t7aDvo5nflo7ODlWKKLMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861509; c=relaxed/simple;
	bh=AjhWCpMJXrDy/pZJla/ngVn985Cc96w2c8y0bv7I1Fs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6EhvRnI8tLbTKuCg4W5DnhSx5XdMwnKXCLmh6dv7bf//76iduLz5qY7Me5ax++1ZpfC2+rpe0xU97rFMm7fMrYBTmG8kZ8pOR+lTdQ862HmoZ/gm6sbbetXeGZD+8cQy/LLfllLPV24WHCmTs5eY9O0SbP0o/h2gptwjl5pS4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=LWU+heMk; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="LWU+heMk"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B3NUGCc1015281;
	Thu, 4 Dec 2025 07:18:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=G
	ovduqNt3yTwWEh/g7Cs7vBkC4HBPcsKeNzRPUjbOw8=; b=LWU+heMkZm6+RXUgr
	gQFQ7iuOTRv9DWCZ4x/7xUsbLnMqIZ3fLOaabA02IafAH/gfXlrtZjwkcMEBDY1l
	KcFhC8DvmAuOP6ZXgNn2NPxF5IsT2KY19hZrDrSB7FNtLhjwswtPDpU2d0dCiFKf
	7EaZK8/Ikj/HdK5vTAnKw4ZIFd9yoKvpUtQH1JAScY0dBBnJQxj0FB84RTmo9+Ao
	SpEA42zJMkU5BQDyQzKc6+7sjHnh6sczqUV+NBNzHo+54Sup0rHl4N9ortpLwSdP
	jU4Zofjx/aL9W8LEdfaPfaOZ1h6DRuSuiSmm1y16fShMRR2XMS3FJCEyi8DU5Cl6
	sj+aw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4atjuu3n5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Dec 2025 07:18:25 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 4 Dec 2025 07:18:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 4 Dec 2025 07:18:37 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7357A3F7074;
	Thu,  4 Dec 2025 07:18:22 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 10/12] qla2xxx: Query FW again before proceeding with login
Date: Thu, 4 Dec 2025 20:47:49 +0530
Message-ID: <20251204151751.2321801-11-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA0MDEyMyBTYWx0ZWRfX222OPBXUR32z
 nYEjPc6BzbVCiqUWGNWbUfc5bByjlYSLyPzTrAStQc4HwpAlzYfHjR2xxWBGUHr6KGUvksZGKT+
 ijnyJrHU/l4CZJodKVJ5ZZ3NJ1YM4Fr1jRIJezmCf7uHjI7EFDeaWREI1TIKe1tnGgcrM0SedLD
 W2lOj1wUL0alQSsPgcGDEpVO53Nh9Kj0630PBLX9y766CkKF73YaFv2D1DyaQbkOUAgB5tKv7gO
 3AkUU8z8gzBELwvoa13vAk4xz7fGq1Yiuv2ZDp8fXxTfSraC42rRF8vX+tDfcdRRmGfiTkD5d/k
 iqP0GKQQQ+WHcK5efdHT8lKsRbHYN/93rJwC/8Nlrk0h851WrFM2NOBUhWBcHtb692hRURqzDso
 jAAbXX4TdN1EtiJ3N7GbBUIc2dqV3w==
X-Proofpoint-ORIG-GUID: l2gbH9WIs9C72krRfj3vUUAhSniiAkbe
X-Proofpoint-GUID: l2gbH9WIs9C72krRfj3vUUAhSniiAkbe
X-Authority-Analysis: v=2.4 cv=E/nAZKdl c=1 sm=1 tr=0 ts=6931a641 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=iFQdS_rSKdxmbl9riRwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_03,2025-12-04_01,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

Issue occurred during a continuous reboot test of several
thousand iterations specific to a fabric topo with dual
mode target where it sends a PLOGI/PRLI and then sends
a LOGO. The initiator was also in the process of discovery
and sent a PLOGI to the switch. It then queried a list of
ports logged in via mbx 75h and the GPDB response indicated that
the target was logged in. This caused a mismatch in the states
between the driver and FW.
Requery the FW for the state and proceed with the rest of
discovery process.

Fixes: a4239945b8ad ("scsi: qla2xxx: Add switch command to simplify fabric discovery")
Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 19 +++++++++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c  | 19 +++++++++++++++++--
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index fa4abeefc0f3..07a1f681fcca 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2462,8 +2462,23 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 	    ea->sp->gen1, fcport->rscn_gen,
 	    ea->data[0], ea->data[1], ea->iop[0], ea->iop[1]);
 
-	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
-	    (fcport->fw_login_state == DSC_LS_PRLI_PEND)) {
+	if (fcport->fw_login_state == DSC_LS_PLOGI_PEND) {
+		ql_dbg(ql_dbg_disc, vha, 0x20ea,
+		    "%s %d %8phC Remote is trying to login\n",
+		    __func__, __LINE__, fcport->port_name);
+		/*
+		 * If we get here, there is port thats already logged in,
+		 * but it's state has not moved ahead. Recheck with FW on
+		 * what state it is in and proceed ahead
+		 */
+		if (!N2N_TOPO(vha->hw)) {
+			fcport->fw_login_state = DSC_LS_PRLI_COMP;
+			qla24xx_post_gpdb_work(vha, fcport, 0);
+		}
+		return;
+	}
+
+	if (fcport->fw_login_state == DSC_LS_PRLI_PEND) {
 		ql_dbg(ql_dbg_disc, vha, 0x20ea,
 		    "%s %d %8phC Remote is trying to login\n",
 		    __func__, __LINE__, fcport->port_name);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c4c6b5c6658c..8786b5fd0966 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1669,13 +1669,28 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 
 			/* Port logout */
 			fcport = qla2x00_find_fcport_by_loopid(vha, mb[1]);
-			if (!fcport)
+			if (!fcport) {
+				ql_dbg(ql_dbg_async, vha, 0x5011,
+					"Could not find fcport:%04x %04x %04x\n",
+					mb[1], mb[2], mb[3]);
 				break;
-			if (atomic_read(&fcport->state) != FCS_ONLINE)
+			}
+
+			if (atomic_read(&fcport->state) != FCS_ONLINE) {
+				ql_dbg(ql_dbg_async, vha, 0x5012,
+					"Port state is not online State:0x%x \n",
+					atomic_read(&fcport->state));
+				ql_dbg(ql_dbg_async, vha, 0x5012,
+					"Scheduling session for deletion \n");
+				fcport->logout_on_delete = 0;
+				qlt_schedule_sess_for_deletion(fcport);
 				break;
+			}
+
 			ql_dbg(ql_dbg_async, vha, 0x508a,
 			    "Marking port lost loopid=%04x portid=%06x.\n",
 			    fcport->loop_id, fcport->d_id.b24);
+
 			if (qla_ini_mode_enabled(vha)) {
 				fcport->logout_on_delete = 0;
 				qlt_schedule_sess_for_deletion(fcport);
-- 
2.23.1

