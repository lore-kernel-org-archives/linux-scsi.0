Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8054380FEC
	for <linux-scsi@vger.kernel.org>; Sat,  3 Oct 2026 20:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791060093; cv=none; b=RY7ZACJ0u8Es5YdW5VUc5qbFgXjf4B5v96DWPGDj46NNKRNHzNFhrjgHQ3nrX8x1JFVE8F9fk3a9Ijsuf0NRQbN+RVPny1leVBjIzH7I10wKkkoQgwwauMeT8BKFHq1yDH80dAwFEHWZ/ZE2thMD1lip2vCA7K4vJe41ENMb74I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791060093; c=relaxed/simple;
	bh=1VnpekHO7x3xVQPKqjb2ceDfAMXerAfkSJT/ZqIU0I0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Elwdy+bywe6mDyjz76I3CpPxa7oPiRXC/xbt4A4O07/9HrqrGJ16Xeb8l3LAjijAEnnaIbybBIC9pO9TrTwg5oGTeIKC7Nos9+yHCbpV2dvgZkg+Q5UYqDBFDhWwxJEocT/jGeIJnMiGzABm7wcpFjwr6/5FEk916Ay9IhGHTqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A4ER2MO8; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A4ER2MO8"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 693JjDDX2731621;
	Sat, 3 Oct 2026 20:41:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=Wb5rUIDYwPBVzuIDeXSGsBMCmWofb
	408tAX7nJPvhGw=; b=A4ER2MO8/WxGyuYP8RW8S0HXUlDndp9VErGK/vPbWIiQb
	u3E2fEv1b8AEpD2L6U+OwNGPACRNqynHzBdSIxICDstNy2Wyey2dGhVLiyVlttzv
	ecKhwuwwapx9iu/X3Bh/gsgYsy/CQbttb0C3rdwedHwjWbeso30TGx4Sz0HYdUAt
	RKIRdqXj6hdhJIDagd1DtwwML3NhwR/cii6ToQ97x8EtO7drXyhVpJALZ30U3heO
	0VfQKEAmjvWzl2wNrwf1IBRGI6uqDOlAQFJCmQNVJ9HbmWlAyxtvxny2mUoBhFh+
	RPcmtKR/1+NTJliUsmISONoZJrSTht3/nHOWxoKtA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2rm98f8x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Oct 2026 20:41:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 693KZJ3F009635;
	Sat, 3 Oct 2026 20:41:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h2r5mgdjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Oct 2026 20:41:28 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 693KfRBG020518;
	Sat, 3 Oct 2026 20:41:27 GMT
Received: from labops-common-sca-01.us.oracle.com (labops-common-sca-01.us.oracle.com [10.132.26.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4h2r5mgdhp-1;
	Sat, 03 Oct 2026 20:41:27 +0000 (GMT)
From: Dai Ngo <dai.ngo@oracle.com>
To: justin.tee@broadcom.com, paul.ely@broadcom.com
Cc: linux-scsi@vger.kernel.org, dai.ngo@oracle.com
Subject: [PATCH 1/1] scsi: lpfc: fix node use-after-free in rport callbacks
Date: Sat,  3 Oct 2026 13:41:12 -0700
Message-ID: <20261003204122.1393233-1-dai.ngo@oracle.com>
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
 definitions=2026-10-03_03,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610030082
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAzMDA4MiBTYWx0ZWRfXy9F562vTLIuA
 8OWl9rBXi82Aa/SeNZNXfMQsykvwXN7IWmFwlah0f7jlZqKOHzkVvE+GiWzhfoz3QfWg+DSOj2U
 sOsKQhipqZltuKbZ6HXZXfNaXEMttTYxVPC8Tt32Laxbw7LiLRlCcijCgoaU1hbI9jQTc3ZIhpR
 C3Iz91eSoUCUtTS4OA4JHPxExQ5RpiXFCV6HZmULUwLOlIgiRrjkCYkKH8qAtwCdNctGTalL0Zy
 TKOMP/vKuSxaVnJR2m4H+PwzT9CZR4INTKnb9bpgBSKyODAsVQAQBKJGOau5dViVfxwY7IcKVZT
 T1IzqaiHuc57tb20wLZd3KpNSLb0pDqudDqOw399A32jSb+i8cb5Bu5F/xN3IczAiq5rKUBylDG
 BJdA3VREuwwxm/sCaVwpccxx4dKJZSgraiCFNkdCEyCogOTHpUOn7rLQVqjlxWlxNSH6kt7T7d4
 RoFSK7xAx648kORPHz0eE7utP++Yf+g4Or/6McdM=
X-Authority-Analysis: v=2.4 cv=QMD91QLL c=1 sm=1 tr=0 ts=6ac16879 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=xikyijxmekaNXYYyRnkA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-ORIG-GUID: o261WwwzqNlBuOMAhz1kAkk9MdyeY6Ly
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAzMDA4MiBTYWx0ZWRfX7kfHPNN48BVF
 WQ7kNUEIY3WYLYUSSvR71Lhu1qLsK4faGQCYBv3NsUcvcsmVo8ixaMaz1NSRHengqAktnyvlNca
 10IZZLn6xNtOpxNt/DfQixoYJPFDtq7p0amAQpgYF3BWNlq+sZyS
X-Proofpoint-GUID: o261WwwzqNlBuOMAhz1kAkk9MdyeY6Ly

After a cable pull, unregistration can release the SCSI node reference
before the FC transport invokes its delayed rport callbacks. If the
remaining references are also released, rport->dd_data->pnode points
to freed memory.

Use pnode only as a lookup key in the vport's fc_nodes list. Under
fc_nodes_list_lock, obtain a nonzero node reference and hold it through
the callback. Final node release removes the node under the same lock.
Read pnode once per lookup so concurrent rport reuse cannot change the
search key during traversal.

Track the SCSI-owned node reference with SCSI_XPT_REF. Registration
flags and ndlp->rport do not reliably indicate whether that reference
is still held. Publish the association and reference state together
under ndlp->lock, and serialize normal devloss detachment with
registration for the same node. Unregistration and devloss clear
SCSI_XPT_REF under that lock before releasing the reference outside it.

During unregistration, save and pin the old rport so concurrent
registration or devloss cannot redirect or suppress its deletion.
Keep the SCSI node reference through all remaining node accesses,
including NVMe unregistration, and release the rport device last.

Devloss releases any remaining SCSI reference before losing its
association with the node. Unload and HBA teardown also handle a
cleared reverse pointer, while preserving the existing initial-node
and NVMe reference accounting.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
---
 drivers/scsi/lpfc/lpfc_disc.h    |   4 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 200 +++++++++++++++++--------------
 2 files changed, 115 insertions(+), 89 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index a377e97cbe65..4fe900f9dc35 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -87,7 +87,9 @@ enum lpfc_fc4_xpt_flags {
 	SCSI_XPT_REGD		= 0x2,
 	NVME_XPT_REGD		= 0x4,
 	NVME_XPT_UNREG_WAIT	= 0x8,
-	NLP_XPT_HAS_HH		= 0x10
+	NLP_XPT_HAS_HH		= 0x10,
+	/* SCSI node reference, protected by ndlp->lock. */
+	SCSI_XPT_REF		= 0x20
 };
 
 enum lpfc_nlp_save_flags { /* mask bits */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index c9b02d2c6305..a80685761a19 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -83,64 +83,61 @@ lpfc_valid_xpt_node(struct lpfc_nodelist *ndlp)
 		return 1;
 	return 0;
 }
-/* The source of a terminate rport I/O is either a dev_loss_tmo
- * event or a call to fc_remove_host.  While the rport should be
- * valid during these downcalls, the transport can call twice
- * in a single event.  This routine provides somoe protection
- * as the NDLP isn't really free, just released to the pool.
+
+/*
+ * Unregistration can release the node before the transport's delayed
+ * callbacks run.  Treat dd_data->pnode only as a lookup key, not as a
+ * dereferenceable pointer.  Final node release removes the node from
+ * fc_nodes under fc_nodes_list_lock before freeing it.  Holding that lock
+ * lets us safely acquire a reference, unless final release has started.
+ * Association checks belong to the caller: failed registration can clear
+ * ndlp->rport while an old rport still needs devloss cleanup.
  */
-static int
-lpfc_rport_invalid(struct fc_rport *rport)
+static struct lpfc_nodelist *
+lpfc_rport_get_node(struct fc_rport *rport)
 {
-	struct lpfc_rport_data *rdata;
-	struct lpfc_nodelist *ndlp;
-
-	if (!rport) {
-		pr_err("**** %s: NULL rport, exit.\n", __func__);
-		return -EINVAL;
-	}
-
-	if (rport->flags & FC_RPORT_DEVLOSS_CALLBK_DONE) {
-		pr_info("**** %s: devloss_callbk_done rport x%px SID x%x\n",
-			__func__, rport, rport->scsi_target_id);
-		return -EINVAL;
-	}
-
-	rdata = rport->dd_data;
-	if (!rdata) {
-		pr_err("**** %s: NULL dd_data on rport x%px SID x%x\n",
-		       __func__, rport, rport->scsi_target_id);
-		return -EINVAL;
-	}
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
+	struct lpfc_rport_data *rdata = rport->dd_data;
+	struct lpfc_nodelist *ndlp, *pnode, *found = NULL;
+	unsigned long iflags;
 
-	ndlp = rdata->pnode;
-	if (!rdata->pnode) {
-		pr_info("**** %s: NULL ndlp on rport x%px SID x%x\n",
-			__func__, rport, rport->scsi_target_id);
-		return -EINVAL;
-	}
+	if (!rdata)
+		return NULL;
 
-	if (!ndlp->vport) {
-		pr_err("**** %s: Null vport on ndlp x%px, DID x%x rport x%px "
-		       "SID x%x\n", __func__, ndlp, ndlp->nlp_DID, rport,
-		       rport->scsi_target_id);
-		return -EINVAL;
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
+	/*
+	 * Registration can reuse this rport for another node without taking
+	 * the list lock. Keep one lookup key throughout the list traversal.
+	 */
+	pnode = READ_ONCE(rdata->pnode);
+	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
+		if (ndlp == pnode) {
+			if (kref_get_unless_zero(&ndlp->kref))
+				found = ndlp;
+			break;
+		}
 	}
-	return 0;
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
+	return found;
 }
 
 void
 lpfc_terminate_rport_io(struct fc_rport *rport)
 {
-	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_vport *vport;
 
-	if (lpfc_rport_invalid(rport))
+	if (!rport || (READ_ONCE(rport->flags) & FC_RPORT_DEVLOSS_CALLBK_DONE))
 		return;
 
-	rdata = rport->dd_data;
-	ndlp = rdata->pnode;
+	ndlp = lpfc_rport_get_node(rport);
+	if (!ndlp)
+		return;
+
+	if (READ_ONCE(ndlp->rport) != rport)
+		goto out;
+
 	vport = ndlp->vport;
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
 			      "rport terminate: sid:x%x did:x%x flg:x%lx",
@@ -148,6 +145,8 @@ lpfc_terminate_rport_io(struct fc_rport *rport)
 
 	if (ndlp->nlp_sid != NLP_NO_SID)
 		lpfc_sli_abort_iocb(vport, ndlp->nlp_sid, 0, LPFC_CTX_TGT);
+out:
+	lpfc_nlp_put(ndlp);
 }
 
 /*
@@ -162,8 +161,9 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct lpfc_work_evt *evtp;
 	unsigned long iflags;
 	bool drop_initial_node_ref = false;
+	bool drop_scsi_node_ref = false;
 
-	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
+	ndlp = lpfc_rport_get_node(rport);
 	if (!ndlp)
 		return;
 
@@ -186,8 +186,13 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	    (phba->sli_rev == LPFC_SLI_REV4 &&
 	    !test_bit(HBA_SETUP, &phba->hba_flag))) {
 
+		/*
+		 * Teardown cleans up the node, not just this rport association.
+		 * An old rport may be the last callback that can find the node
+		 * after rport reuse. Do not require ndlp->rport == rport here.
+		 */
 		spin_lock_irqsave(&ndlp->lock, iflags);
-		ndlp->rport = NULL;
+		WRITE_ONCE(ndlp->rport, NULL);
 
 		/* Only 1 thread can drop the initial node reference.
 		 * If not registered for NVME and NLP_DROPPED flag is
@@ -203,43 +208,37 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
 			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
 
-			/* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
-			 * unregister calls were made to the scsi and nvme
-			 * transports and refcnt was already decremented. Clear
-			 * the NLP_XPT_REGD flag only if the NVME nrport is
-			 * confirmed unregistered.
-			 */
-			if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
-				if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
-					ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
-				spin_unlock_irqrestore(&ndlp->lock, iflags);
-
-				/* Release scsi transport reference */
-				lpfc_nlp_put(ndlp);
-			} else {
-				spin_unlock_irqrestore(&ndlp->lock, iflags);
-			}
-		} else {
-			spin_unlock_irqrestore(&ndlp->lock, iflags);
+			/* Leave backend registration set while NVMe is active. */
+			if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
+				ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
+		}
+		if (ndlp->fc4_xpt_flags & SCSI_XPT_REF) {
+			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REF;
+			drop_scsi_node_ref = true;
 		}
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
 
 		if (drop_initial_node_ref)
 			lpfc_nlp_put(ndlp);
-		return;
+		goto out;
 	}
 
-	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
-		return;
+	spin_lock_irqsave(&ndlp->lock, iflags);
+	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+		goto out;
+	}
 
-	/* Ignore callback for a mismatched (stale) rport */
+	/* Serialize association validation and detachment with registration. */
 	if (ndlp->rport != rport) {
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
 		lpfc_vlog_msg(vport, KERN_WARNING, LOG_NODE,
 			      "6788 fc rport mismatch: d_id x%06x ndlp x%px "
 			      "fc rport x%px node rport x%px state x%x "
 			      "refcnt %u\n",
 			      ndlp->nlp_DID, ndlp, rport, ndlp->rport,
 			      ndlp->nlp_state, kref_read(&ndlp->kref));
-		return;
+		goto out;
 	}
 
 	if (rport->port_name != wwn_to_u64(ndlp->nlp_portname.u.wwn))
@@ -251,15 +250,15 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	evtp = &ndlp->dev_loss_evt;
 
 	if (!list_empty(&evtp->evt_listp)) {
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6790 rport name %llx dev_loss_evt pending\n",
 				 rport->port_name);
-		return;
+		goto out;
 	}
 
 	set_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag);
 
-	spin_lock_irqsave(&ndlp->lock, iflags);
 	/* If there is a PLOGI in progress, and we are in a
 	 * NLP_NPR_2B_DISC state, don't turn off the flag.
 	 */
@@ -271,8 +270,12 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	 * rport. Remove the association between rport and ndlp.
 	 */
 	ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
-	((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
-	ndlp->rport = NULL;
+	if (ndlp->fc4_xpt_flags & SCSI_XPT_REF) {
+		ndlp->fc4_xpt_flags &= ~SCSI_XPT_REF;
+		drop_scsi_node_ref = true;
+	}
+	WRITE_ONCE(((struct lpfc_rport_data *)rport->dd_data)->pnode, NULL);
+	WRITE_ONCE(ndlp->rport, NULL);
 	spin_unlock_irqrestore(&ndlp->lock, iflags);
 
 	if (phba->worker_thread) {
@@ -287,7 +290,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			list_add_tail(&evtp->evt_listp, &phba->work_list);
 			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			lpfc_worker_wake_up(phba);
-			return;
+			goto out;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	} else {
@@ -304,6 +307,10 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 						NLP_EVT_DEVICE_RM);
 		}
 	}
+out:
+	if (drop_scsi_node_ref)
+		lpfc_nlp_put(ndlp);
+	lpfc_nlp_put(ndlp);
 }
 
 /**
@@ -4506,8 +4513,11 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (test_bit(FC_UNLOADING, &vport->load_flag))
 		return;
 
-	ndlp->rport = rport = fc_remote_port_add(shost, 0, &rport_ids);
+	rport = fc_remote_port_add(shost, 0, &rport_ids);
 	if (!rport) {
+		spin_lock_irqsave(&ndlp->lock, flags);
+		WRITE_ONCE(ndlp->rport, NULL);
+		spin_unlock_irqrestore(&ndlp->lock, flags);
 		dev_printk(KERN_WARNING, &phba->pcidev->dev,
 			   "Warning: fc_remote_port_add failed\n");
 		return;
@@ -4517,17 +4527,20 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	rport->maxframe_size = ndlp->nlp_maxframe;
 	rport->supported_classes = ndlp->nlp_class_sup;
 	rdata = rport->dd_data;
-	rdata->pnode = lpfc_nlp_get(ndlp);
-	if (!rdata->pnode) {
+	spin_lock_irqsave(&ndlp->lock, flags);
+	if (!kref_get_unless_zero(&ndlp->kref)) {
+		WRITE_ONCE(ndlp->rport, NULL);
+		spin_unlock_irqrestore(&ndlp->lock, flags);
 		dev_warn(&phba->pcidev->dev,
 			 "Warning - node ref failed. Unreg rport\n");
 		fc_remote_port_delete(rport);
-		ndlp->rport = NULL;
 		return;
 	}
 
-	spin_lock_irqsave(&ndlp->lock, flags);
-	ndlp->fc4_xpt_flags |= SCSI_XPT_REGD;
+	/* Record the acquired reference separately from association flags. */
+	WRITE_ONCE(ndlp->rport, rport);
+	WRITE_ONCE(rdata->pnode, ndlp);
+	ndlp->fc4_xpt_flags |= SCSI_XPT_REGD | SCSI_XPT_REF;
 	spin_unlock_irqrestore(&ndlp->lock, flags);
 
 	if (ndlp->nlp_type & NLP_FCP_TARGET)
@@ -4558,14 +4571,10 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 }
 
 static void
-lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
+lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp, struct fc_rport *rport)
 {
-	struct fc_rport *rport = ndlp->rport;
 	struct lpfc_vport *vport = ndlp->vport;
 
-	if (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
-		return;
-
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
 		"rport delete:    did:x%x flg:x%lx type x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
@@ -4577,7 +4586,6 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 			 kref_read(&ndlp->kref));
 
 	fc_remote_port_delete(rport);
-	lpfc_nlp_put(ndlp);
 }
 
 static void
@@ -4675,7 +4683,9 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 void
 lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
+	struct fc_rport *rport = NULL;
 	unsigned long iflags;
+	bool drop_scsi_node_ref = false;
 
 	spin_lock_irqsave(&ndlp->lock, iflags);
 	if (!(ndlp->fc4_xpt_flags & NLP_XPT_REGD)) {
@@ -4690,12 +4700,21 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	}
 
 	ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
+	if (ndlp->rport && (ndlp->fc4_xpt_flags & SCSI_XPT_REF)) {
+		ndlp->fc4_xpt_flags &= ~SCSI_XPT_REF;
+		drop_scsi_node_ref = true;
+		rport = ndlp->rport;
+		/*
+		 * Keep the old rport alive if registration replaces ndlp->rport
+		 * or devloss detaches it before fc_remote_port_delete().
+		 */
+		get_device(&rport->dev);
+	}
 	spin_unlock_irqrestore(&ndlp->lock, iflags);
 
-	if (ndlp->rport &&
-	    ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
+	if (drop_scsi_node_ref) {
 		vport->phba->nport_event_cnt++;
-		lpfc_unregister_remote_port(ndlp);
+		lpfc_unregister_remote_port(ndlp, rport);
 	} else if (!ndlp->rport) {
 		lpfc_printf_vlog(vport, KERN_INFO,
 				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
@@ -4716,6 +4735,11 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		}
 	}
 
+	/* Keep both references through all node accesses and final release. */
+	if (drop_scsi_node_ref) {
+		lpfc_nlp_put(ndlp);
+		put_device(&rport->dev);
+	}
 }
 
 /*
-- 
2.47.3

