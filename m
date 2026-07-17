Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89971140E5F
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302247; cv=none; b=D1ZiRcW3YqdCOnQb+yiRBB2lOyTGkO9gnGt77WK9EQtnFN0+c7O9wX7sEEd2X2YpOs1IDlkZk30PJ6TMFzoBMFJbYkdaHHFKzxxczCNhbAgooiJbCokrNvX/kU4yNJDJxgqhffkwstxHryVamenMtp1TIExk9pWHW6fy6rPojws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302247; c=relaxed/simple;
	bh=mdzrENDl/S/D7pY2QsbReWJQlQ6XldCu17knggGmcd4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g45Ib7XaOUjSrUIXX6vu9xqlAzQoDD3W9i+U9DmFbmwSQicmo/PJ74e1q7yImrlsR93zl44oB/YNz+i6AYuEKupfzCQNJGU5vE+y9iuoDMG59My+2yocFOL2vXENXR/TrWlMVJFRZEoQ26J9Bp0F/bkm3R6fKi18OoehVLF7G6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fWc3Kbvu; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fWc3Kbvu"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5xMW2729911;
	Fri, 17 Jul 2026 08:30:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=K
	KtCHrbV1U4yznBZmuOn8XGMsLE/+7X+CvjxaB70Lp8=; b=fWc3KbvuKwbH9K89p
	4av5wGOmtwz/u7gB0Ql5Muu5QpvqzYPiXw079XB6urtLWzUehOrlEXqQgA+Ujt1C
	h8lo7wisx/BUF6IzUg2ivd8okzIEaZHJ1x7I5sePnuWmzKoYIX+fPLwsxvG1Eguc
	WaI1MA8c72GHDxckuUpHGeeuD7/EuJZtSMMfJ9zqvwP9KtG6RCjlxydQrTxfkDUs
	IEhabrRYcbR6IRZtdmfL9/zBZ9khDaEwcAl/U8SmP7uLLMj5rp5EUiL84bAsMURV
	ca8bHO/vhRshWIrSovxEN9JP5ZxsrFdkJflc9y6e1tUquCfvDLkNkId/9eRmzuYI
	oXljw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fewjwmj3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:42 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:42 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id F06755B693B;
	Fri, 17 Jul 2026 08:30:39 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 32/56] scsi: qla2xxx: Enhance task management IOCB handling for 29xx series
Date: Fri, 17 Jul 2026 20:58:40 +0530
Message-ID: <20260717152904.3155730-33-njavali@marvell.com>
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
X-Proofpoint-GUID: H5CintO-8k-US2XQGM2iLeTc1uDNfmZj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXw4zYCT8C48cX
 ArWAI9yTNSl7rmwJ/dA6WOv/EIjQ2hvTDdgBBCv5YaxYkE5oR/TrrCIB1CzJ4RAgfvGsQElepAw
 7dl7Lr+hon2q+u45fggl/qT8BNzp9b5Rzczhb9REcaDLHAmWwyqZw1Z7gYLFgNL2mLVXOCz0yfs
 GNN58AOajc+XA/Wm1OZ1Q2iRZs9/oYQLgCQeC2/ubQ5EnpFUBcGi8aySs5HsKcqkZ4jQiine8r8
 /nmaiOgx7WnAOO8kCWj0I7O4QzcMElZEjKaJlG4Zn0S4lZ69d6TRzs/SCKSfI7resVSKvxbgKYW
 t7oWUxZlaSAb510SIQsDnD7Nm8uxIvmiLTs9vksnNzqlxhMZmpi8nJS0aNgFH+wSFqfQol/WWno
 EYVamprRI73YeuuRZD7e27bKPf7oFfBIQOlKY0qFYGc3E/XUp3f53dyvvLwkvSIkzoDa0SuDYwo
 tEbg0GTc/4PBiuyeylw==
X-Authority-Analysis: v=2.4 cv=Pa3PQChd c=1 sm=1 tr=0 ts=6a5a4aa2 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=GCX_fLWMEB1gCRu7i1AA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: H5CintO-8k-US2XQGM2iLeTc1uDNfmZj
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX8Rtn7x+d+jYF
 n3+EZX91sofdsI3vNgt8YkxUddPvoYIk/aVqC97CBGjryzB4v+DdihIimwmm45B00cPjO3MbIPc
 ERle8MfLrcLPvjlAvoCromShbN3nZo8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

Update qla24xx_tm_iocb() and __qla24xx_issue_tmf() to support the
extended task management structure (tsk_mgmt_entry_ext) for 29xx
adapters.

tsk_mgmt_entry_ext overlays tsk_mgmt_entry through control_flags
(offsets 0-27 are byte-identical): entry_type, entry_count, handle,
nport_handle, timeout, lun and control_flags sit at the same offsets
and widths.  The layouts diverge only after that point:

  - the 24xx layout has port_id[3] + u8 vp_index;
  - the ext layout has __le16 vp_index and no port_id.

Factor the common IOCB header writes through a single tsk_mgmt_entry *
view and branch on IS_QLA29XX() only for the diverging port_id /
vp_index assignments.  Change qla24xx_tm_iocb() to accept void *pkt
to allow casting to either structure type.

Add tsk_ext member to the tsk_mgmt_cmd union and a BUILD_BUG_ON size
check for the 128-byte extended structure.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 31 ++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_mbx.c  | 18 ++++++++++++++----
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 3 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 4dcacee61e77..c21d7f418f47 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2727,7 +2727,7 @@ qla2x00_adisc_iocb(srb_t *sp, struct mbx_entry *mbx)
 }
 
 static void
-qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
+qla24xx_tm_iocb(srb_t *sp, void *pkt)
 {
 	uint32_t flags;
 	uint64_t lun;
@@ -2736,26 +2736,39 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
 	struct qla_hw_data *ha = vha->hw;
 	struct srb_iocb *iocb = &sp->u.iocb_cmd;
 	struct req_que *req = sp->qpair->req;
+	struct tsk_mgmt_entry *tsk;
 
 	flags = iocb->u.tmf.flags;
 	lun = iocb->u.tmf.lun;
 
+	/*
+	 * tsk_mgmt_entry_ext overlays tsk_mgmt_entry through control_flags
+	 * (offsets 0-27 are byte-identical), so the common header writes
+	 * go through one struct tsk_mgmt_entry * view.  The ext layout
+	 * has no port_id and uses a wider __le16 vp_index at a different
+	 * offset, so port_id / vp_index assignments diverge per stride.
+	 */
+	tsk = pkt;
 	tsk->entry_type = TSK_MGMT_IOCB_TYPE;
 	tsk->entry_count = 1;
 	tsk->handle = make_handle(req->id, tsk->handle);
 	tsk->nport_handle = cpu_to_le16(fcport->loop_id);
 	tsk->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	tsk->control_flags = cpu_to_le32(flags);
-	tsk->port_id[0] = fcport->d_id.b.al_pa;
-	tsk->port_id[1] = fcport->d_id.b.area;
-	tsk->port_id[2] = fcport->d_id.b.domain;
-	tsk->vp_index = fcport->vha->vp_idx;
+	if (IS_QLA29XX(ha)) {
+		((struct tsk_mgmt_entry_ext *)pkt)->vp_index =
+		    cpu_to_le16(fcport->vha->vp_idx);
+	} else {
+		tsk->port_id[0] = fcport->d_id.b.al_pa;
+		tsk->port_id[1] = fcport->d_id.b.area;
+		tsk->port_id[2] = fcport->d_id.b.domain;
+		tsk->vp_index = fcport->vha->vp_idx;
+	}
 
-	if (flags & (TCF_LUN_RESET | TCF_ABORT_TASK_SET|
-	    TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA)) {
+	if (flags & (TCF_LUN_RESET | TCF_ABORT_TASK_SET |
+	    TCF_CLEAR_TASK_SET | TCF_CLEAR_ACA)) {
 		int_to_scsilun(lun, &tsk->lun);
-		host_to_fcp_swap((uint8_t *)&tsk->lun,
-			sizeof(tsk->lun));
+		host_to_fcp_swap((uint8_t *)&tsk->lun, sizeof(tsk->lun));
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7dff227899a5..9bef87862077 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3411,6 +3411,7 @@ qla24xx_abort_command(srb_t *sp)
 struct tsk_mgmt_cmd {
 	union {
 		struct tsk_mgmt_entry tsk;
+		struct tsk_mgmt_entry_ext tsk_ext;
 		struct sts_entry_24xx sts;
 		struct sts_entry_24xx_ext sts_ext;
 	} p;
@@ -3450,16 +3451,25 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
+	/*
+	 * tsk_mgmt_entry_ext overlays tsk_mgmt_entry through control_flags;
+	 * the common-header writes go through tsk->p.tsk and only port_id
+	 * (24xx-only) and vp_index width / offset diverge.
+	 */
 	tsk->p.tsk.entry_type = TSK_MGMT_IOCB_TYPE;
 	tsk->p.tsk.entry_count = 1;
 	tsk->p.tsk.handle = make_handle(req->id, tsk->p.tsk.handle);
 	tsk->p.tsk.nport_handle = cpu_to_le16(fcport->loop_id);
 	tsk->p.tsk.timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	tsk->p.tsk.control_flags = cpu_to_le32(type);
-	tsk->p.tsk.port_id[0] = fcport->d_id.b.al_pa;
-	tsk->p.tsk.port_id[1] = fcport->d_id.b.area;
-	tsk->p.tsk.port_id[2] = fcport->d_id.b.domain;
-	tsk->p.tsk.vp_index = fcport->vha->vp_idx;
+	if (IS_QLA29XX(ha)) {
+		tsk->p.tsk_ext.vp_index = cpu_to_le16(fcport->vha->vp_idx);
+	} else {
+		tsk->p.tsk.port_id[0] = fcport->d_id.b.al_pa;
+		tsk->p.tsk.port_id[1] = fcport->d_id.b.area;
+		tsk->p.tsk.port_id[2] = fcport->d_id.b.domain;
+		tsk->p.tsk.vp_index = fcport->vha->vp_idx;
+	}
 	if (type == TCF_LUN_RESET) {
 		int_to_scsilun(l, &tsk->p.tsk.lun);
 		host_to_fcp_swap((uint8_t *)&tsk->p.tsk.lun,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b0e89dfff2e8..6c951839507b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8428,6 +8428,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct sts_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct sts_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry) != 64);
+	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
 	BUILD_BUG_ON(sizeof(struct verify_chip_rsp_84xx) != 52);
-- 
2.47.3

