Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8D8313528
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361809; cv=none; b=M48akKZWYOi0jy3+3yPRV2VYXU8tKp4GL6uRXUB8lVdkswtQvboueFxmxY/sNE30Lu5WURTNILrtEuYcUaTXBeQ+/GWS31Rn1rIrfFMntUPQPH34xZU6zeEl4ic9ezxM9QPFLw0k5y+f2Fr2b+0NY4F8P0naKV7rWkcu3lju/mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361809; c=relaxed/simple;
	bh=AjhWCpMJXrDy/pZJla/ngVn985Cc96w2c8y0bv7I1Fs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pf2R8CSjUlvT5vNykl9n5Vcn0C//lgxvwmuKP5VlPDMIztiAPS3Ax0MjkCxUtXxOmR0NpqUFFAQ+u5yMKgoxhkpBhouaQd5Sa2ZJOZvaXVKVKZujTysg7MuGEykWcMhUk3koNLxNzC0UMDJYFh60y54pQMm+iz991n2roO/h8ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Tga0BCOT; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Tga0BCOT"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4aLnf3329346;
	Wed, 10 Dec 2025 02:16:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=G
	ovduqNt3yTwWEh/g7Cs7vBkC4HBPcsKeNzRPUjbOw8=; b=Tga0BCOT0i/PzgKgx
	dfsdN7slS4SRbQjnLwVx1zBZ8npzFxmcVIdFL03iuXviscW0aw6KxlwdGB5juTRn
	2qv+a30FahRvsT2N7TPGGgYmcjlnFahEcJyDjimwJqIVRKS7fVfxkXEBXTESAtXy
	QJ2vixTNBjZ92fWu7urFlEDzMaUbNOqRr2GJWfRCojQcCFiLnaOBvPaMDUaRozMJ
	efkJbeoYzs6wjQWJhqAr60bDUsBQ+ftEsY79gNjbHIJ3prTylQKo78l2aywB0Nfq
	AuZ5EJXFFrzuq5PoSykrexNGi3TxGQsPOmGXhApFbNn52NID6dUdsviYNSkxffIP
	GhNAA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4axuknhj1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 02:16:45 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 10 Dec 2025 02:16:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 10 Dec 2025 02:16:58 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 93B033F709D;
	Wed, 10 Dec 2025 02:16:42 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 10/12] qla2xxx: Query FW again before proceeding with login
Date: Wed, 10 Dec 2025 15:46:02 +0530
Message-ID: <20251210101604.431868-11-njavali@marvell.com>
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
X-Proofpoint-GUID: SogGwI780GjG2RHmo4GEABdW4d_0BmQI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4NSBTYWx0ZWRfX5mIDChOSSV0E
 KcYlf16i7qdiiomAO0DMX+Z22ZWrLrIFOmdR0DVYyhUhEqv8qLZgLNweNZZo7uqvysUrVG0bloc
 1B41QUyucZMfqXzNyd0erEPoIsrv/L6f53SjmtbmUYxa0a3ZOWlbm7vDVDGiiD04h5V5coa2JPe
 0kbUtMePJtRdOMZRpSTEHgGtn4nNSUrwE8zVb5Q1d4h4MF5qrWUm9PbLCqBLkkSxQLnGa89VmPX
 A9u3yM+/9mwppbxJwRN7GRPiCIdbBqCo4yXXj9LyJTykHruhenlKe47JEPkUi8hfj+NMlTdqfUi
 hTtkbXQ9uYLNeBrCnrzMziXTeGMZrq+00Zpxw06aQSZQj7n2aOdx8QdCLkw3j4cQN4YB9PUMrvA
 b7mvhFIHUh6kZt+4rzfEd1nEuAQHXQ==
X-Proofpoint-ORIG-GUID: SogGwI780GjG2RHmo4GEABdW4d_0BmQI
X-Authority-Analysis: v=2.4 cv=P483RyAu c=1 sm=1 tr=0 ts=6939488d cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=iFQdS_rSKdxmbl9riRwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01

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

