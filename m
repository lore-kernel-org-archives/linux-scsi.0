Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CDE2F90D5
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 05:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654387; cv=none; b=jSxX2J/+1q16gsdDBZUfahbvvgFn9luwPG1mBwlk2FqjAszcFBv62wWq0aTgQHXS+/4bJ6PeSlx4NZqpw8EkdK+DuRfcDcaLHLxblEu9cbIq/gi35cWc9rPWk1LyZv0376FuIwssLG5LWFJoZQwKWO8BcoUjjKXdliHEhgj8OiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654387; c=relaxed/simple;
	bh=iTgEOw13Mt9lTALhOUQcQqjV0WHI5f5PfAzReWPgrXs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d0W6qTMVgW5yQ+Ff63bxH7GF95/QMPgxvunz6n3hixGSgY3zsiFBGIkXajL9/H5/vpD5bvLMM0qAV4l8HADgGNP/2Fz0UcDfrcqgitZPHRkjnaFhuW/JfeSAnOlfcNFUrY0Q0n8jd7SBTrVGUu3/WUQI7NGU9Pee8MC+q0ryDNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Ddsc7Ry+; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Ddsc7Ry+"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1HZCM04191091;
	Mon, 1 Dec 2025 21:46:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Y
	ljymHFYQw7cH7Q9lHyHhUVIXrN54fzK5KjIyRodlnQ=; b=Ddsc7Ry+xt0sQkgBq
	LjL881wc6RBsxA3IgFRhTv4jYyWimIf7wEW+0vJuKeYWU54U2HFTxd7IIRsboh/F
	9sI/BDqUWm3xw7IskbBVqEUnWyluU6N93ZO2Gyplbgzy64+UGHJl/91ivEcG19zr
	zEN42xwoGl/eXUiCd6my1lGxmNi1KGKnoahHgtDEi+NSy1gSdMeCyrsXVE3q8Ucx
	lig4rj1AvA3pgtIGaGL+HKMj6gKGqYHks+RyStFIDZJwwERj+5coPS5foYgPbOq3
	fSjcy5VC0VQgVU7jbFUVMqLh0W1jLPNbB/ntvAyEFkXMpFjkd9W6zAsv7mJeRo6F
	gsvTQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ar17nn81w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 21:46:19 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 21:46:31 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 21:46:30 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 4AFF25B6975;
	Mon,  1 Dec 2025 21:46:15 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 10/12] qla2xxx: Query FW again before proceeding with login
Date: Tue, 2 Dec 2025 11:14:42 +0530
Message-ID: <20251202054444.1711778-11-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251202054444.1711778-1-njavali@marvell.com>
References: <20251202054444.1711778-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: q7GKEtOvoyRffaKQPFYNQNqUODF3xh2b
X-Authority-Analysis: v=2.4 cv=R+MO2NRX c=1 sm=1 tr=0 ts=692e7d2b cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=iFQdS_rSKdxmbl9riRwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: q7GKEtOvoyRffaKQPFYNQNqUODF3xh2b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0MyBTYWx0ZWRfX3EAHJr3Hh5/9
 8C5M82YupS6Za81rPjUtPNRGu3vZe80WBa6oG/pN5c9dwU4qAOOgAY4uZbcnPQn5UYoS0gvW759
 NgkMqigKEJqrklEgLlU525UFZ/sFmFjO9JeuNTxm1Xt9Bt0tMsg0Grhc8r5cYyCRBGAVF0wSxTO
 fON2+4Zd3H8iAiZ4TkBgr2j/+ytW24jokjI1gkMXrBSUWcrZQbdbUzjdN5r7ylds4Qr/8dEVSJp
 Y/Kqx7uLEeEeO8/WVQapmPd2vE52rdqdVuWeEO44MCy0pdTZ6/xCJsYI5vGoT7LGwHL0Bz/4mVK
 4q56mAHi6UKazx5yFT9x45LBi3LHv7ny94XWOxLPw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

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
---
 drivers/scsi/qla2xxx/qla_init.c | 19 +++++++++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c  | 19 +++++++++++++++++--
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0f0128835edb..0776d4deec06 100644
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

