Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDABC14AA2
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 07:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708674335; cv=none; b=QpRo4a11SOW5AFclL3vMbxUrR+5ERYILFT2nMlA49y7CkQ/NFMqeKGyxeVlPRTBq0z3iq3Q3JkvGTiD5oci04gxvv+W5rT1wYpBy4OMUnFlTdBbJvA5ycIOKbR21LqhUgW6FdbERz2TAIo412G05a24xY2g/qye713z8UcBrahY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708674335; c=relaxed/simple;
	bh=++DTP3/3Nxt9MvQnP4Ulr554gPZCiFOj6TWYvkpL+Pc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DYlHuez+z3ONZDalLluGSlr+XbazlTU+vGTzKE2Om1F3dyeiKhCFLfvHFaipBaMlKSBpR5WvkW8TiLlONDfPtWPHzwD7Q3FxzhUCf+xddkcyK4rx6ZSYNdaqFaKsTDWnbtZrITDHvliBbh1tASkqo1Fue6oppLIGfBhuYwC8YeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=hKyFFGtq; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hKyFFGtq"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41ML8qEq003070;
	Thu, 22 Feb 2024 23:45:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=PPQoE7mLCRwag0/kds5QDWVcLgdQSquiAOAwKNAPH5Q=; b=hKy
	FFGtq+vdarae522TJfdyjTqEngT9vHgI0N0mvWcmIID5epMPW6vjEvR184zktQu6
	iL6XlBgaRBR6L8w+NNwPvWxgsP/zctV85ti1Ntk3B1CYjv6SoJYXNIr8E2kb++dA
	arHQYzmcbLZwbQJdhCi7bNTXtwWjPht9zigBPMgIxyUkFKccZAGczilMvEqTKelK
	4pLKn3haH/urY8xPtlxrLS5Cq8MvOciv4iYekxwPcz0Kqu0lLFICMS2GalM60OBF
	QBf1XFjCBoyAbNAZREJWehm+e8y8y2t+LxhtdiXQaeyswvAHfY+4AkxS+JOxfAB8
	psNiYCGFsfre3ybY2mw==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3wedwxht1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 23:45:30 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 22 Feb
 2024 23:45:28 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 22 Feb 2024 23:45:28 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 3FA773F714A;
	Thu, 22 Feb 2024 23:45:25 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 01/11] qla2xxx: Prevent command send on chip reset
Date: Fri, 23 Feb 2024 13:15:04 +0530
Message-ID: <20240223074514.8472-2-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240223074514.8472-1-njavali@marvell.com>
References: <20240223074514.8472-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: t6YqKMhKcBcy8IShvCse2H1VRpeuet14
X-Proofpoint-ORIG-GUID: t6YqKMhKcBcy8IShvCse2H1VRpeuet14
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_15,2024-02-22_01,2023-05-22_02

From: Quinn Tran <qutran@marvell.com>

Currently IOCBs are allowed to push through while chip reset
could be in progress. During chip reset the outstanding_cmds
array is cleared twice. Once when any command on this array
is returned as failed and secondly when the array is initialize to
zero. If a command is inserted on to the array between these
intervals, then the command will be lost.
Check for chip reset before sending IOCB.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c |  8 ++++++--
 drivers/scsi/qla2xxx/qla_iocb.c | 33 +++++++++++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a314cfc5b263..2f456e69da91 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1193,8 +1193,12 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	/* ref: INIT */
-	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+	/*
+	 * use qla24xx_async_gnl_sp_done to purge all pending gnl request.
+	 * kref_put is call behind the scene.
+	 */
+	sp->u.iocb_cmd.u.mbx.in_mb[0] = MBS_COMMAND_ERROR;
+	qla24xx_async_gnl_sp_done(sp, QLA_COMMAND_ERROR);
 	fcport->flags &= ~(FCF_ASYNC_SENT);
 done:
 	fcport->flags &= ~(FCF_ASYNC_ACTIVE);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index df90169f8244..0228c90b9fe8 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2587,6 +2587,33 @@ void
 qla2x00_sp_release(struct kref *kref)
 {
 	struct srb *sp = container_of(kref, struct srb, cmd_kref);
+	struct scsi_qla_host *vha = sp->vha;
+
+	switch (sp->type) {
+	case SRB_CT_PTHRU_CMD:
+		/* GPSC & GFPNID use fcport->ct_desc.ct_sns for both req & rsp */
+		if (sp->u.iocb_cmd.u.ctarg.req &&
+			(!sp->fcport ||
+			 sp->u.iocb_cmd.u.ctarg.req != sp->fcport->ct_desc.ct_sns)) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+			    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
+			    sp->u.iocb_cmd.u.ctarg.req,
+			    sp->u.iocb_cmd.u.ctarg.req_dma);
+			sp->u.iocb_cmd.u.ctarg.req = NULL;
+		}
+		if (sp->u.iocb_cmd.u.ctarg.rsp &&
+			(!sp->fcport ||
+			 sp->u.iocb_cmd.u.ctarg.rsp != sp->fcport->ct_desc.ct_sns)) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+			    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
+			    sp->u.iocb_cmd.u.ctarg.rsp,
+			    sp->u.iocb_cmd.u.ctarg.rsp_dma);
+			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
+		}
+		break;
+	default:
+		break;
+	}
 
 	sp->free(sp);
 }
@@ -2692,7 +2719,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	 */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp) {
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 		ql_log(ql_log_info, vha, 0x70e6,
 		 "SRB allocation failed\n");
 		return -ENOMEM;
@@ -2747,6 +2774,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (rval != QLA_SUCCESS) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2756,6 +2784,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 	wait_for_completion(&elsio->u.els_logo.comp);
+	qla2x00_free_fcport(fcport);
 
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
@@ -3918,7 +3947,7 @@ qla2x00_start_sp(srb_t *sp)
 		return -EAGAIN;
 	}
 
-	pkt = __qla2x00_alloc_iocbs(sp->qpair, sp);
+	pkt = qla2x00_alloc_iocbs_ready(sp->qpair, sp);
 	if (!pkt) {
 		rval = -EAGAIN;
 		ql_log(ql_log_warn, vha, 0x700c,
-- 
2.23.1

