Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15133D9DCD
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 22:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790721130; cv=none; b=Pm2eseHQpUhCUzsiWfSndcLEE6t+BQ1IIUwLg8Jqkw9X/pXI17yrCFdqb33IUInCMX/DutjBdAl0KFGqVsLY67X87FEq6wyNYjqNIXqBVkmZ4bh7l1hlO29rLOaWITyV6uVQOLKuq/LdNI5YVehQL4jtUh2Ompjfxkq9DCH9A7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790721130; c=relaxed/simple;
	bh=tNgVDlo6dUyE7aVhUM2BKm/tYp82yUOZpoiICJSbPAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZsPjetO0zkGw2SqDH7fNb1IMmdeo3ml4B8oQM53VQVwmbkaoFjqyO3mwOjPLHPelvCgyhc+zfBmNM0L6xvv7nQw/YzHraP/eChfjXfVspMIar4MSZ/F3Hg4LjchduL5hG1ADQ38kNEP5Q4Mp9VzN7BfjQP8YP6jH2DUDr9GqIiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U+23wVdZ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U+23wVdZ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TM0gS8039611;
	Tue, 29 Sep 2026 22:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=0fdqoJfkNqsKfKOpNGPkTf0LUDb5J
	0sDRZ+rNbyINmw=; b=U+23wVdZDOqThrmRZJExwsmDQLgybWcjnrC/AZu/tGh6K
	wOnLUG2XEbCO0dwFVP7H0XoVMIxzDIKL7e/mkE0oS/9RJOGBcOfrZ7xdhWKUdsqL
	I7iag9ZV6Xc6/RCmCzPZZQwtdpyFzj1lz7W1Uok1FsOfw2J8zQAa1Y0ARHFyLMNp
	SmAaFs14DfGp5OuVnetLYG8HrnyO6FwKbpKQnM/MLPXDsJ/Ktb5KmAIlj/Yrlpkq
	I6UtT3KurG+HhPsomazU+EDQCjWzvBbPv4zPMWjmzlvcz/CQ41mPZ+Pi6H5gu1VQ
	wlgYdRgSKEHyrJo91YBiE2/fA5zr/WZg64d7pEgmQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx5nrwk3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Sep 2026 22:32:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68TMJmsq005174;
	Tue, 29 Sep 2026 22:32:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gch16y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Sep 2026 22:32:06 +0000 (GMT)
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 68TMW5hi032602;
	Tue, 29 Sep 2026 22:32:05 GMT
Received: from labops-common-sca-01.us.oracle.com (labops-common-sca-01.us.oracle.com [10.132.26.161])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4gx4gch16p-1;
	Tue, 29 Sep 2026 22:32:05 +0000 (GMT)
From: Dai Ngo <dai.ngo@oracle.com>
To: justin.tee@broadcom.com, paul.ely@broadcom.com
Cc: linux-scsi@vger.kernel.org, dai.ngo@oracle.com
Subject: [PATCH v5 1/1] scsi: lpfc: defer SCSI rport node put until devloss callback
Date: Tue, 29 Sep 2026 15:28:48 -0700
Message-ID: <20260929223133.2922017-1-dai.ngo@oracle.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609290089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA4OSBTYWx0ZWRfX1Uw5HVIuXiHf
 dENOTBWnAdbq3KPZYt+sClNq5IJ0Dp+N1jaLkqbj4Q+rZh/By1cso7k4Z5IrAHWgJyHyshqkQnd
 Y4nV28qnMFIGTjeRg5JLn3bArWU7BmI2plzr3EARCrZIrSjAK5L7rAMTWOzivilZxfG6JruqV5h
 MAGUszmlH+9GqpqJHi/8sYdw+aPPuiwMc02eYAm2gR5HvGMJzDi38CEGQGWUPZNmmtdLy+l4HVL
 ReK13Js9/A23S4lpfjEcU3bzV8JUVvZ8feoQHOdTUg+PD+IhQpYzgae3KhmsoVrgvsyBwp/AIF9
 ySX/+fF4WTHU63cRzpk2bS+l7ADBNz0aTobmqMjzFQdpXLZoaukbRe937oFOBoarHl09LE4MnnY
 vxT02fdJHTIwcm28nIQXvg9j3reGwa8B7B9D/EVNC7z1bRaCvlv4KdGk2srAPhLvmYG22dtoAVi
 zcHlUQ3XWqz9LqkHAPA==
X-Proofpoint-GUID: R1MmkeFOlP7NUlDW1s6awlAsHbCdJ6CK
X-Authority-Analysis: v=2.4 cv=T8QZ3PKQ c=1 sm=1 tr=0 ts=6abc3c67 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=XaedPNj-x8Qxjbb0r9UA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA4OSBTYWx0ZWRfX/+2QMm9B2Xcq
 bszC54VnhnYg8y18x0PS2XsLWsxL94sK7nuuJRQcbI56/i11wI7dWserjzphyDNfrXMU+xWGYsM
 rbYZlEVz2GKn+hQ70JrWahBtauqjzccLG5KlwFrvkoxlpfE0x9IC
X-Proofpoint-ORIG-GUID: R1MmkeFOlP7NUlDW1s6awlAsHbCdJ6CK

lpfc_register_remote_port() stores an lpfc_nodelist pointer in the SCSI
transport rport private data and takes a node reference for that
association.

lpfc_unregister_remote_port() calls fc_remote_port_delete(), which start
SCSI transport devloss processing.  The rport remains usable until that
processing completes: the transport can still invoke
lpfc_terminate_rport_io() and lpfc_dev_loss_tmo_callbk(), both of which
obtain the lpfc node through rport->dd_data->pnode.

Do not drop the association reference immediately after
fc_remote_port_delete().  Retain it until lpfc_dev_loss_tmo_callbk()
detaches the rport and rport private data from the node, clears
SCSI_XPT_REGD, and drops the association reference.  This prevents the
node from being freed while the transport still has callbacks pending.

An rport can reappear while devloss processing is in progress.  Before
calling fc_remote_port_add(), acquire a provisional node reference.
When the transport reuses the prior fc_rport and its old SCSI association
remains registered, transfer that old reference to the new association
and release the provisional one.  Otherwise retain the provisional
reference because the old association was already released by devloss.

Associate a generation with each rport private-data assignment. A
devloss callback captures the generation and, while holding ndlp->lock,
verifies the pnode, generation, and rport before changing association
state or dropping a reference.  Thus, an old callback cannot operate
on a reused rport after the transport has cleared and reinitialized
its private data.

Set NLP_IN_DEV_LOSS only after these ownership checks succeed.  A stale
callback therefore cannot leave the flag set and suppress a later
node-reference release.

This preserves one node reference for each active SCSI rport association
and closes the devloss callback use-after-free and rport-reuse races.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
---
 drivers/scsi/lpfc/lpfc_disc.h    |   1 +
 drivers/scsi/lpfc/lpfc_hbadisc.c | 139 ++++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_scsi.h    |   1 +
 3 files changed, 121 insertions(+), 20 deletions(-)

V2:
. in lpfc_unregister_remote_port(), snapshot ndlp->rport under
ndlp->lock, clear rdata->pnode, clear ndlp->rport, and clear the
SCSI transport registration flag while holding the ndlp->lock.

. in lpfc_dev_loss_tmo_callbk, check rport's private data before
using it and and use READ_ONCE() / WRITE_ONCE() for the lockless
pnode handoff.

V3:
. Redo the patch based on Paul's review.
Delay dropping the SCSI rport node reference until
lpfc_dev_loss_tmo_callbk() detaches the rport from the lpfc node.

V4:
. Fix the node lead reference when the remote port reconnects before
dev_loss_tmo expires. If fc_remote_port_add() reuses the existing SCSI
rport, transfer the reference that is still held on the rport instead
of acquiring a new reference.

V5:
. Fix devloss callback use-after-free and rport-reuse races identified
in saskiko review by introducing rport association generation number.
lpfc_dev_loss_tmo_callbk checks the generation number verifies the pnode,
generation, and rport before changing association state or dropping a
reference.

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 51cb8571c049..4236e2397357 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -141,6 +141,7 @@ struct lpfc_nodelist {
 	struct timer_list   nlp_delayfunc;	/* Used for delayed ELS cmds */
 	struct lpfc_hba *phba;
 	struct fc_rport *rport;		/* scsi_transport_fc port structure */
+	u32 rport_gen;			/* SCSI rport association generation */
 	struct lpfc_nvme_rport *nrport;	/* nvme transport rport struct. */
 	struct lpfc_vport *vport;
 	struct lpfc_work_evt els_retry_evt;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4f68038789b5..c47a8ccdf2b5 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -157,15 +157,21 @@ void
 lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 {
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_rport_data *rdata;
 	struct lpfc_vport *vport;
 	struct lpfc_hba   *phba;
 	struct lpfc_work_evt *evtp;
 	unsigned long iflags;
+	u32 rport_gen;
 	bool drop_initial_node_ref = false;
+	bool drop_scsi_node_ref = false;
+	bool stale_rport = false;
 
-	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
+	rdata = rport->dd_data;
+	ndlp = READ_ONCE(rdata->pnode);
 	if (!ndlp)
 		return;
+	rport_gen = READ_ONCE(rdata->generation);
 
 	vport = ndlp->vport;
 	phba  = vport->phba;
@@ -187,6 +193,16 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	    !test_bit(HBA_SETUP, &phba->hba_flag))) {
 
 		spin_lock_irqsave(&ndlp->lock, iflags);
+		if (rdata->pnode != ndlp || rdata->generation != rport_gen) {
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
+			return;
+		}
+		if (ndlp->rport != rport) {
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
+			lpfc_nlp_put(ndlp);
+			return;
+		}
+		rdata->pnode = NULL;
 		ndlp->rport = NULL;
 
 		/* Only 1 thread can drop the initial node reference.
@@ -202,6 +218,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		 */
 		if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
 			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+			drop_scsi_node_ref = true;
 
 			/* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
 			 * unregister calls were made to the scsi and nvme
@@ -213,9 +230,6 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 				if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
 					ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
 				spin_unlock_irqrestore(&ndlp->lock, iflags);
-
-				/* Release scsi transport reference */
-				lpfc_nlp_put(ndlp);
 			} else {
 				spin_unlock_irqrestore(&ndlp->lock, iflags);
 			}
@@ -223,14 +237,13 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
 		}
 
+		if (drop_scsi_node_ref)
+			lpfc_nlp_put(ndlp);
 		if (drop_initial_node_ref)
 			lpfc_nlp_put(ndlp);
 		return;
 	}
 
-	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
-		return;
-
 	/* Ignore callback for a mismatched (stale) rport */
 	if (ndlp->rport != rport) {
 		lpfc_vlog_msg(vport, KERN_WARNING, LOG_NODE,
@@ -239,6 +252,31 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			      "refcnt %u\n",
 			      ndlp->nlp_DID, ndlp, rport, ndlp->rport,
 			      ndlp->nlp_state, kref_read(&ndlp->kref));
+		/* Drop the reference held by this stale rport. */
+		lpfc_nlp_put(ndlp);
+		return;
+	}
+
+	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
+		spin_lock_irqsave(&ndlp->lock, iflags);
+		if (rdata->pnode != ndlp || rdata->generation != rport_gen) {
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
+			return;
+		}
+		if (ndlp->rport != rport) {
+			stale_rport = true;
+		} else if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
+			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+			rdata->pnode = NULL;
+			ndlp->rport = NULL;
+			drop_scsi_node_ref = true;
+		}
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+
+		if (stale_rport)
+			lpfc_nlp_put(ndlp);
+		if (drop_scsi_node_ref)
+			lpfc_nlp_put(ndlp);
 		return;
 	}
 
@@ -254,15 +292,44 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6790 rport name %llx dev_loss_evt pending\n",
 				 rport->port_name);
+		spin_lock_irqsave(&ndlp->lock, iflags);
+		if (rdata->pnode != ndlp || rdata->generation != rport_gen) {
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
+			return;
+		}
+		if (ndlp->rport != rport) {
+			stale_rport = true;
+		} else if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
+			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+			rdata->pnode = NULL;
+			ndlp->rport = NULL;
+			drop_scsi_node_ref = true;
+		}
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+
+		if (stale_rport || drop_scsi_node_ref)
+			lpfc_nlp_put(ndlp);
 		return;
 	}
 
-	set_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag);
-
 	spin_lock_irqsave(&ndlp->lock, iflags);
 	/* If there is a PLOGI in progress, and we are in a
 	 * NLP_NPR_2B_DISC state, don't turn off the flag.
 	 */
+	if (rdata->pnode != ndlp || rdata->generation != rport_gen) {
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+		return;
+	}
+	if (ndlp->rport != rport) {
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+		lpfc_nlp_put(ndlp);
+		return;
+	}
+	if (!(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+		return;
+	}
+	set_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag);
 	if (ndlp->nlp_state != NLP_STE_PLOGI_ISSUE)
 		clear_bit(NLP_NPR_2B_DISC, &ndlp->nlp_flag);
 
@@ -271,7 +338,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	 * rport. Remove the association between rport and ndlp.
 	 */
 	ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
-	((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
+	drop_scsi_node_ref = true;
+	rdata->pnode = NULL;
 	ndlp->rport = NULL;
 	spin_unlock_irqrestore(&ndlp->lock, iflags);
 
@@ -287,6 +355,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			list_add_tail(&evtp->evt_listp, &phba->work_list);
 			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			lpfc_worker_wake_up(phba);
+			if (drop_scsi_node_ref)
+				lpfc_nlp_put(ndlp);
 			return;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
@@ -304,6 +374,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 						NLP_EVT_DEVICE_RM);
 		}
 	}
+	if (drop_scsi_node_ref)
+		lpfc_nlp_put(ndlp);
 }
 
 /**
@@ -4475,11 +4547,14 @@ static void
 lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct fc_rport  *old_rport;
 	struct fc_rport  *rport;
 	struct lpfc_rport_data *rdata;
+	struct lpfc_nodelist *pnode;
 	struct fc_rport_identifiers rport_ids;
 	struct lpfc_hba  *phba = vport->phba;
 	unsigned long flags;
+	bool drop_new_scsi_ref = false;
 
 	if (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
 		return;
@@ -4499,10 +4574,27 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (test_bit(FC_UNLOADING, &vport->load_flag))
 		return;
 
-	ndlp->rport = rport = fc_remote_port_add(shost, 0, &rport_ids);
+	/*
+	 * Keep ndlp alive while the transport cancels or completes an old
+	 * rport's devloss work. This reference becomes the new association
+	 * reference after fc_remote_port_add() succeeds.
+	 */
+	pnode = lpfc_nlp_get(ndlp);
+	if (!pnode) {
+		dev_warn(&phba->pcidev->dev,
+			 "Warning - node ref failed. Unreg rport\n");
+		return;
+	}
+
+	spin_lock_irqsave(&ndlp->lock, flags);
+	old_rport = ndlp->rport;
+	spin_unlock_irqrestore(&ndlp->lock, flags);
+
+	rport = fc_remote_port_add(shost, 0, &rport_ids);
 	if (!rport) {
 		dev_printk(KERN_WARNING, &phba->pcidev->dev,
 			   "Warning: fc_remote_port_add failed\n");
+		lpfc_nlp_put(pnode);
 		return;
 	}
 
@@ -4510,19 +4602,27 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	rport->maxframe_size = ndlp->nlp_maxframe;
 	rport->supported_classes = ndlp->nlp_class_sup;
 	rdata = rport->dd_data;
-	rdata->pnode = lpfc_nlp_get(ndlp);
-	if (!rdata->pnode) {
-		dev_warn(&phba->pcidev->dev,
-			 "Warning - node ref failed. Unreg rport\n");
-		fc_remote_port_delete(rport);
-		ndlp->rport = NULL;
-		return;
-	}
 
 	spin_lock_irqsave(&ndlp->lock, flags);
+	/*
+	 * A reused rport normally retains its old association reference.
+	 * However, devloss may have completed while fc_remote_port_add()
+	 * was running, in which case it cleared SCSI_XPT_REGD and released
+	 * that reference. In the former case, transfer the old reference to
+	 * the new association and release the provisional new reference.
+	 */
+	if (rport == old_rport &&
+	    (ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
+		drop_new_scsi_ref = true;
+	rdata->pnode = pnode;
+	rdata->generation = ++ndlp->rport_gen;
+	ndlp->rport = rport;
 	ndlp->fc4_xpt_flags |= SCSI_XPT_REGD;
 	spin_unlock_irqrestore(&ndlp->lock, flags);
 
+	if (drop_new_scsi_ref)
+		lpfc_nlp_put(pnode);
+
 	if (ndlp->nlp_type & NLP_FCP_TARGET)
 		rport_ids.roles |= FC_PORT_ROLE_FCP_TARGET;
 	if (ndlp->nlp_type & NLP_FCP_INITIATOR)
@@ -4570,7 +4670,6 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 			 kref_read(&ndlp->kref));
 
 	fc_remote_port_delete(rport);
-	lpfc_nlp_put(ndlp);
 }
 
 static void
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index a05d203e4777..6e8bb2232cba 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -42,6 +42,7 @@ struct lpfc_hba;
 /* per-port data that is allocated in the FC transport for us */
 struct lpfc_rport_data {
 	struct lpfc_nodelist *pnode;	/* Pointer to the node structure. */
+	u32 generation;		/* rport association generation */
 };
 
 struct lpfc_device_id {
-- 
2.47.3

