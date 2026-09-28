Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070624E4324
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 16:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790613302; cv=none; b=pepN7znFTee+koezcajvdbM3eMRUgrbajt5bg0qjZNvm+U2oCccy2g6CGXe2HkAUyUqTCE3/JbIEva6mbyQjVpVwoeDa/x8f1gEvmDGf8tos5xhn7xmdPPmVMKu0JuanuXx0Vg9lsk2EN0Ie+RUbkUAfE8IevqHdeuHfkZtOPKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790613302; c=relaxed/simple;
	bh=KtaRUORBG54LlZQGqMIbeLVnE4bVP9k3Y6rz4SzzJSM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I+x6NglbHHWlWwzrAeFTqCzD6PNmdMMG0pALu8Q36o0eJdTByARmdvK8m7JXQnFejNcov/BqXCfUW6t/MxyAfMrxXEqSAUoZisa+5jdcYjZoqs3aAoFGjnuuFLRAx2d20wEqZfcJeWxt3B+JGwBWPT36Ax/mmGqVj6YcJt1h8IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=shWNQVkA; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="shWNQVkA"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SDjAJx1697684;
	Mon, 28 Sep 2026 16:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=Tx2wUIbBjSH4ZzbWFQImDgPmD7QLv
	h+mFv8RPnp2MCU=; b=shWNQVkAsWB4whyHbYDkr1veArxSUtqMI8RArx0wPdSNg
	96l9v+/oZhUNxm3PGC6n5+0+Kvhp2L0CmKw4+aHHFebnBmuk7+rl75DtEDjmXbkN
	4Jj0rZUMqxMVaXK3VGcwKaJ1uYXyTTYga7EzcVjOdpiNzD0o5h9qOKIeb/Mc9qm0
	pYMBuNaQ4za6EBEn+KV7YtTUs2V9buU+pnJxXBSbHU24VcdWaGbgNSdz+L6MEZoY
	wcJt7QgLvzi7OGEupnxseO5FSqaxPs0RigQ61xVVAiSK33wSno7KdID6qWSudvXw
	8++m8WH7kCQU3Pn0HU8f7Cwkrj2GTnsdNqClhnpzg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4fbb6ca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 16:34:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68SGYqqC026789;
	Mon, 28 Sep 2026 16:34:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4ga8k2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 16:34:56 +0000 (GMT)
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 68SGYrmt026846;
	Mon, 28 Sep 2026 16:34:53 GMT
Received: from labops-common-sca-01.us.oracle.com (labops-common-sca-01.us.oracle.com [10.132.26.161])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4gx4ga8jyp-1;
	Mon, 28 Sep 2026 16:34:53 +0000 (GMT)
From: Dai Ngo <dai.ngo@oracle.com>
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, paul.ely@broadcom.com
Cc: linux-scsi@vger.kernel.org, dai.ngo@oracle.com
Subject: [PATCH v3 1/1] scsi: lpfc: defer SCSI rport node put until devloss callback
Date: Mon, 28 Sep 2026 09:31:48 -0700
Message-ID: <20260928163433.2086184-1-dai.ngo@oracle.com>
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
 definitions=2026-09-28_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0
 mlxscore=0 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609280066
X-Proofpoint-ORIG-GUID: 9Fd5wzJ9_eAqkjT7lZweXS5FwhcpqSDO
X-Proofpoint-GUID: 9Fd5wzJ9_eAqkjT7lZweXS5FwhcpqSDO
X-Authority-Analysis: v=2.4 cv=eJCGH3p1 c=1 sm=1 tr=0 ts=6aba9731 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=RL9bYjTrTEiENRjtfgEA:9
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA2NSBTYWx0ZWRfXwaGVdvH+jNlH
 G8ao42aAhLJXh42XCKCxMCmyn63O3V2WQ8Xm/qvU1cY3qmuiDT/1ISEKAmAvSUxfLxrkxgxWTRH
 5KoMruwzoANyZX4m7QuIGFvlB2tMGqMpbG6zBRltQbSDC7Rdd5L7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA2NSBTYWx0ZWRfX6DAbov/NEg6J
 qQsVaw5ymOVo6X0/va2qMBZc/b2KfeWPPGgmQOPZtPVmpinQ76b3oPZgCZNpQbm8i21yWRYfSCV
 BMk1YqDsmOVp4DEUYZkG+GOYQlfGb7LqGvtEcasKMpC+CYl9nPO8MkA6RU2hX4tyzfkcToNtUML
 bdEjRjkt54V1vsCuq1tD5oxgpzklBwrteT8PfT4UJOFUpE9eQB7R0sCX/fgo53Y9eFjOUgz1JzO
 Fk3R4MdNPRjOpWXzmp0u8cPr/sGjwBT31c6tqLGssHCDRKP2LbplAwfvP80AZcxLg1U9E6bLfv2
 efDLtsndwIKmJRLk080ADtgFhQr1IkDa5nSUbg7NMUhVLTBbUagUL6GhPnERcaf+zSm2PlONUGf
 YNOcnmdN8CtYBjYF2sqP23ngKmUGg9RV3h3JxYiWWZnxGkzhIfDu78CfjTXQ5gTJ4N5MZ3N+bQe
 f62qaTXHCenWrfwQXlw==

lpfc_register_remote_port() stores an lpfc_nodelist pointer in the
SCSI transport rport private data and takes a node reference for that
association.

On remote-port unregister, lpfc_unregister_remote_port() calls
fc_remote_port_delete(), which starts SCSI transport devloss handling.
The rport is not fully finished at that point.  The SCSI transport may
still call back into the driver through lpfc_terminate_rport_io() and
lpfc_dev_loss_tmo_callbk(), both of which use rport->dd_data->pnode to
find the lpfc node.

Dropping the node reference immediately after fc_remote_port_delete()
can therefore free the lpfc_nodelist while the rport still points to
it. A cable pull can hit this window and report a KASAN use-after-free
from lpfc_terminate_rport_io(), followed by stale-node access in
lpfc_dev_loss_tmo_callbk().

Keep the SCSI rport node reference until lpfc_dev_loss_tmo_callbk()
detaches the rport from the lpfc node.  Drop that reference after
clearing SCSI_XPT_REGD and removing the rport/dd_data association,
so the node remains valid for the SCSI transport devloss callbacks.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

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

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4f68038789b5..04f56c2f69dc 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -162,6 +162,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct lpfc_work_evt *evtp;
 	unsigned long iflags;
 	bool drop_initial_node_ref = false;
+	bool drop_scsi_node_ref = false;
 
 	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
 	if (!ndlp)
@@ -202,6 +203,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		 */
 		if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
 			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+			drop_scsi_node_ref = true;
 
 			/* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
 			 * unregister calls were made to the scsi and nvme
@@ -213,9 +215,6 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 				if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
 					ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
 				spin_unlock_irqrestore(&ndlp->lock, iflags);
-
-				/* Release scsi transport reference */
-				lpfc_nlp_put(ndlp);
 			} else {
 				spin_unlock_irqrestore(&ndlp->lock, iflags);
 			}
@@ -223,6 +222,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
 		}
 
+		if (drop_scsi_node_ref)
+			lpfc_nlp_put(ndlp);
 		if (drop_initial_node_ref)
 			lpfc_nlp_put(ndlp);
 		return;
@@ -271,6 +272,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	 * rport. Remove the association between rport and ndlp.
 	 */
 	ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+	drop_scsi_node_ref = true;
 	((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
 	ndlp->rport = NULL;
 	spin_unlock_irqrestore(&ndlp->lock, iflags);
@@ -287,6 +289,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			list_add_tail(&evtp->evt_listp, &phba->work_list);
 			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			lpfc_worker_wake_up(phba);
+			if (drop_scsi_node_ref)
+				lpfc_nlp_put(ndlp);
 			return;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
@@ -304,6 +308,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 						NLP_EVT_DEVICE_RM);
 		}
 	}
+	if (drop_scsi_node_ref)
+		lpfc_nlp_put(ndlp);
 }
 
 /**
@@ -4570,7 +4576,6 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 			 kref_read(&ndlp->kref));
 
 	fc_remote_port_delete(rport);
-	lpfc_nlp_put(ndlp);
 }
 
 static void
-- 
2.47.3

