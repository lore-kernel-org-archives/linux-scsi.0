Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789041849F4
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 13:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718717905; cv=none; b=kJERnhYXmJ2W43RFFjiMti+1i4XyU0g9ORuDg4R4L+ucpWiK3YFklNRDBp0AJG8Ch6yogrjIo0glGxgOsnzTm8CZOSllE3dvxewiBIRel6GCSPSHunUhDJcE9dQzp/y24rUCrNp/ZQ4ER/oOtH+LyafVYK+DlvnlKMFHgt0W7Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718717905; c=relaxed/simple;
	bh=SIYrZr/0S8QHNiJ7o+kP/yttGKZQioFyGTAr5znGcUE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BVbZU4sy15c3bf3OOC4wQOmwObeHjvHINRl9s3zjWDiZsGG4FGCvaNaUm3XuK2anuP2cz9jFVBSaCc34v+56Pm0oqzq+6Qux45J2NSiIZzFbNRYtxxvQMaudcv6Xi29i9t8aRaM9ukPikAt0hXHzoeGTRC4Se33ICRHvem9fur4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Ct3XdESC; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Ct3XdESC"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45IBi7vm015519;
	Tue, 18 Jun 2024 06:38:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	x9/2ljVSqCvSzJmCyr9k1ZveoieqsSQK1cTWanEfTA=; b=Ct3XdESCbHA99JjoU
	WX9iNsiOUGpTP3GuwZbM04DqhnmruMtCit1bgXzTV3NZMiAOciRTO4qDeAWyNQyk
	UgEzS4ZOfHyFL9N7J4uw8IXrC+hL0L93QDXEsiRGgEfvYzDwP3UgUsqCSXjAF5k0
	3DVsgWNwQR5Q1eSwq1gKm6buGW9tJgBN++5MSh9oC45LHXvxbJBmszfbvNINQc0F
	sWILbczJ0hnJIhA/GEQdAYDpa/4MobRodjYjlt1F33f/7SpkwsevxZEq+0eGPIVm
	GtTCYWtX1XRnnxlMiFBEwfTEin+iJGs7ZqwryE8DndjbRV4jzJouyFjGBXB3+P2/
	dS7pw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3yu0nwt3q3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 06:38:22 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 18 Jun 2024 06:38:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 18 Jun 2024 06:38:21 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 1305A3F706D;
	Tue, 18 Jun 2024 06:38:18 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 10/11] qla2xxx: Use QP lock to search for bsg
Date: Tue, 18 Jun 2024 19:07:38 +0530
Message-ID: <20240618133739.35456-11-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240618133739.35456-1-njavali@marvell.com>
References: <20240618133739.35456-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 4buuqmIQZgillrC4MXOJKy3yp30u27sI
X-Proofpoint-ORIG-GUID: 4buuqmIQZgillrC4MXOJKy3yp30u27sI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01

From: Quinn Tran <qutran@marvell.com>

On bsg timeout, hardware_lock is used as part of search for the srb.
Instead, qpair lock should be used to iterate through different qpair.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 96 ++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 8d1e45b883cd..52dc9604f567 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -3059,17 +3059,61 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 	return ret;
 }
 
-int
-qla24xx_bsg_timeout(struct bsg_job *bsg_job)
+static bool qla_bsg_found(struct qla_qpair *qpair, struct bsg_job *bsg_job)
 {
+	bool found = false;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
 	struct qla_hw_data *ha = vha->hw;
-	srb_t *sp;
-	int cnt, que;
+	srb_t *sp = NULL;
+	int cnt;
 	unsigned long flags;
 	struct req_que *req;
 
+	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
+	req = qpair->req;
+
+	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
+		sp = req->outstanding_cmds[cnt];
+		if (sp &&
+		    (sp->type == SRB_CT_CMD ||
+		     sp->type == SRB_ELS_CMD_HST ||
+		     sp->type == SRB_ELS_CMD_HST_NOLOGIN) &&
+		    sp->u.bsg_job == bsg_job) {
+			req->outstanding_cmds[cnt] = NULL;
+			spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
+			if (!ha->flags.eeh_busy && ha->isp_ops->abort_command(sp)) {
+				ql_log(ql_log_warn, vha, 0x7089,
+						"mbx abort_command failed.\n");
+				bsg_reply->result = -EIO;
+			} else {
+				ql_dbg(ql_dbg_user, vha, 0x708a,
+						"mbx abort_command success.\n");
+				bsg_reply->result = 0;
+			}
+			/* ref: INIT */
+			kref_put(&sp->cmd_kref, qla2x00_sp_release);
+
+			found = true;
+			goto done;
+		}
+	}
+	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
+done:
+	return found;
+}
+
+int
+qla24xx_bsg_timeout(struct bsg_job *bsg_job)
+{
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
+	struct qla_hw_data *ha = vha->hw;
+	int i;
+	struct qla_qpair *qpair;
+
 	ql_log(ql_log_info, vha, 0x708b, "%s CMD timeout. bsg ptr %p.\n",
 	    __func__, bsg_job);
 
@@ -3079,48 +3123,22 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 		qla_pci_set_eeh_busy(vha);
 	}
 
+	if (qla_bsg_found(ha->base_qpair, bsg_job))
+		goto done;
+
 	/* find the bsg job from the active list of commands */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (que = 0; que < ha->max_req_queues; que++) {
-		req = ha->req_q_map[que];
-		if (!req)
+	for (i = 0; i < ha->max_qpairs; i++) {
+		qpair = vha->hw->queue_pair_map[i];
+		if (!qpair)
 			continue;
-
-		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
-			sp = req->outstanding_cmds[cnt];
-			if (sp &&
-			    (sp->type == SRB_CT_CMD ||
-			     sp->type == SRB_ELS_CMD_HST ||
-			     sp->type == SRB_ELS_CMD_HST_NOLOGIN ||
-			     sp->type == SRB_FXIOCB_BCMD) &&
-			    sp->u.bsg_job == bsg_job) {
-				req->outstanding_cmds[cnt] = NULL;
-				spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-				if (!ha->flags.eeh_busy && ha->isp_ops->abort_command(sp)) {
-					ql_log(ql_log_warn, vha, 0x7089,
-					    "mbx abort_command failed.\n");
-					bsg_reply->result = -EIO;
-				} else {
-					ql_dbg(ql_dbg_user, vha, 0x708a,
-					    "mbx abort_command success.\n");
-					bsg_reply->result = 0;
-				}
-				spin_lock_irqsave(&ha->hardware_lock, flags);
-				goto done;
-
-			}
-		}
+		if (qla_bsg_found(qpair, bsg_job))
+			goto done;
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
 	bsg_reply->result = -ENXIO;
-	return 0;
 
 done:
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	/* ref: INIT */
-	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	return 0;
 }
 
-- 
2.23.1

