Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29854E1D6
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 17:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709055165; cv=none; b=SQTCGiokjTBJ9dTWX9/1oTqmoqLLMjzEMF9um2SCSNbof4IlRXm8KJCyTG7ITwVGqkespP8vRqCpXydHyntfeHvUlCe8+74U/2+ELvo0dbE8KeObnYcssdIfIyuSrU57kYRoNfpo2Vf9n4Z50foJmpP50Ba/GIHRNL5hnlAc8EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709055165; c=relaxed/simple;
	bh=rUyI26995fRm48mkCBPhqpX+/a6tyoJ18Ck19Z/7wxI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B0+tqpil5VEixqvJz1p6EWeBS7nTj3fOEg3MO83cJwi/ratXPwtMCPVFA0HTDAEOuoYrVNr47GJftgAAt6BIL6OpCpQXnq1VMcKjpe8+Jd+a4OS3n6mhrLJT6dBVQvUB4goIeSv5EihrShQZ3kfuZLLD2289KWPZjYTSp3614vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=eSQYw7mq; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="eSQYw7mq"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41RFhNe0005875;
	Tue, 27 Feb 2024 09:32:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=6W5BJmpRb0Cvt5r7MM9wFZz2tGvSxEBC6qz77rc2KR0=; b=eSQ
	Yw7mqplg36PfbqOuA6K6b2ahdwxnQo47/5OTL3d2nX8xGDbuYlghuAHrK1+NXMz+
	9s7u+wvv+M7afH7keKubx+VFlXSIkGcn1C8mUq7mihDOgVgq+aIgR4dBH2VjwgHx
	8EOnlot7rDsaXvpygYS5DfJZ4W/gVZUKWZkhpLffc2+hjDtJr4SHtLgAKJT7YaUv
	Wd6obzz3J3UY5UPPfFnGMnxFPIpkh/0nG9n0qzIZhy5/9qp1nEFSOJFtFxPs65V0
	TzTRxI9/TGo720eFk31ZWbMrHvvGw0eqXrLkvtsamMo+ZP+Df2j3xCblUyVcXJd+
	gRqw27+CbkgFvf+dq2g==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3whjm68h0q-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Feb 2024 09:32:40 -0800 (PST)
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1258.12; Tue, 27 Feb 2024 09:32:39 -0800
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 27 Feb 2024 11:41:43 -0500
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Tue, 27 Feb 2024 08:41:43 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 158F73F7099;
	Tue, 27 Feb 2024 08:41:40 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 02/11] qla2xxx: Fix N2N stuck connection
Date: Tue, 27 Feb 2024 22:11:18 +0530
Message-ID: <20240227164127.36465-3-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240227164127.36465-1-njavali@marvell.com>
References: <20240227164127.36465-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1vtxDvwP7d7G9w7AvKmohlGef0fMcmqe
X-Proofpoint-GUID: 1vtxDvwP7d7G9w7AvKmohlGef0fMcmqe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-27_03,2024-02-27_01,2023-05-22_02

From: Quinn Tran <qutran@marvell.com>

Disk failed to rediscover after chip reset error
injection. The chip reset happens at the time when
a PLOGI is being sent. This cause a flag to be left
on which blocks the retry. Clear the blocking flag.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |  2 +-
 drivers/scsi/qla2xxx/qla_iocb.c | 32 +++++++++++---------------------
 drivers/scsi/qla2xxx/qla_os.c   |  2 +-
 3 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 09cb9413670a..7309310d2ab9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -44,7 +44,7 @@ extern int qla2x00_fabric_login(scsi_qla_host_t *, fc_port_t *, uint16_t *);
 extern int qla2x00_local_device_login(scsi_qla_host_t *, fc_port_t *);
 
 extern int qla24xx_els_dcmd_iocb(scsi_qla_host_t *, int, port_id_t);
-extern int qla24xx_els_dcmd2_iocb(scsi_qla_host_t *, int, fc_port_t *, bool);
+extern int qla24xx_els_dcmd2_iocb(scsi_qla_host_t *, int, fc_port_t *);
 extern void qla2x00_els_dcmd2_free(scsi_qla_host_t *vha,
 				   struct els_plogi *els_plogi);
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 0228c90b9fe8..892a27afb462 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3041,7 +3041,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 
 int
 qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
-    fc_port_t *fcport, bool wait)
+			fc_port_t *fcport)
 {
 	srb_t *sp;
 	struct srb_iocb *elsio = NULL;
@@ -3056,8 +3056,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (!sp) {
 		ql_log(ql_log_info, vha, 0x70e6,
 		 "SRB allocation failed\n");
-		fcport->flags &= ~FCF_ASYNC_ACTIVE;
-		return -ENOMEM;
+		goto done;
 	}
 
 	fcport->flags |= FCF_ASYNC_SENT;
@@ -3066,9 +3065,6 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	ql_dbg(ql_dbg_io, vha, 0x3073,
 	       "%s Enter: PLOGI portid=%06x\n", __func__, fcport->d_id.b24);
 
-	if (wait)
-		sp->flags = SRB_WAKEUP_ON_COMP;
-
 	sp->type = SRB_ELS_DCMD;
 	sp->name = "ELS_DCMD";
 	sp->fcport = fcport;
@@ -3084,7 +3080,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	if (!elsio->u.els_plogi.els_plogi_pyld) {
 		rval = QLA_FUNCTION_FAILED;
-		goto out;
+		goto done_free_sp;
 	}
 
 	resp_ptr = elsio->u.els_plogi.els_resp_pyld =
@@ -3093,7 +3089,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	if (!elsio->u.els_plogi.els_resp_pyld) {
 		rval = QLA_FUNCTION_FAILED;
-		goto out;
+		goto done_free_sp;
 	}
 
 	ql_dbg(ql_dbg_io, vha, 0x3073, "PLOGI %p %p\n", ptr, resp_ptr);
@@ -3109,7 +3105,6 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	if (els_opcode == ELS_DCMD_PLOGI && DBELL_ACTIVE(vha)) {
 		struct fc_els_flogi *p = ptr;
-
 		p->fl_csp.sp_features |= cpu_to_be16(FC_SP_FT_SEC);
 	}
 
@@ -3118,10 +3113,11 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld,
 	    sizeof(*elsio->u.els_plogi.els_plogi_pyld));
 
-	init_completion(&elsio->u.els_plogi.comp);
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		rval = QLA_FUNCTION_FAILED;
+		fcport->flags |= FCF_LOGIN_NEEDED;
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+		goto done_free_sp;
 	} else {
 		ql_dbg(ql_dbg_disc, vha, 0x3074,
 		    "%s PLOGI sent, hdl=%x, loopid=%x, to port_id %06x from port_id %06x\n",
@@ -3129,21 +3125,15 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 		    fcport->d_id.b24, vha->d_id.b24);
 	}
 
-	if (wait) {
-		wait_for_completion(&elsio->u.els_plogi.comp);
-
-		if (elsio->u.els_plogi.comp_status != CS_COMPLETE)
-			rval = QLA_FUNCTION_FAILED;
-	} else {
-		goto done;
-	}
+	return rval;
 
-out:
-	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+done_free_sp:
 	qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+	qla2x00_set_fcport_disc_state(fcport, DSC_DELETED);
 	return rval;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dd674378f2f3..b3bb974ae797 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5583,7 +5583,7 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 			break;
 		case QLA_EVT_ELS_PLOGI:
 			qla24xx_els_dcmd2_iocb(vha, ELS_DCMD_PLOGI,
-			    e->u.fcport.fcport, false);
+			    e->u.fcport.fcport);
 			break;
 		case QLA_EVT_SA_REPLACE:
 			rc = qla24xx_issue_sa_replace_iocb(vha, e);
-- 
2.23.1

