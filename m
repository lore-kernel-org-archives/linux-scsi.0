Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD67547043
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 00:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790640205; cv=none; b=bcZikst7s0bdpiPRbzx8hzOrbu10sIMpMqiBFvJ60PGH3gQU0FGAujMQ6CphSOBBUYQq4TGAAHC12RkWMj3qm0CTgpgeYfLo4Z4PQLzfx69q2rcbjlfwmcMAcH0vnwT7+0App6veNRuNRlKUonBA15JamCqXP36jWHrskfQ/EN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790640205; c=relaxed/simple;
	bh=2IEROk7VBVvgDMBGfTDxQCML369aTIZfDcQbAweIrWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RlQugnv1YlTrEnloBzTN9gHf4RfiIw3gToTpDuQUmj8AIpit9UMN3hmVuU3amv4r1G0K0Apro2gxESmYbKgDDe62eIa8CbVVYIW23tO/+h2QLMs6/Pf6/EHJSI/w8W3rIjROx8rqWSrE9iinccC+X6JazzJN6Sv6CRDlTCuIaT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XNBLhylC; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XNBLhylC"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SNbU9X2548531;
	Tue, 29 Sep 2026 00:03:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=+pqPjUWV75dpAD01kGjwHtqy210Wi
	EMFcIsD9B84RG8=; b=XNBLhylChEUOjcX/wEkVgEk35XnTN+wxs0EqIYTymgWVU
	QL/jeAR9f1zoXS9HDUmM/4DY+hoLQkx8af8ltLtD2XCdTAQ9U1FA6zr1jqnr297T
	xYRf8EC1PlLd6Ia4DPdTgaaMJGbxGk8JOQRh6fhbtFBLJ2NKK5DUb81B350iToio
	bDTi80zUAQ7bxAE5zO3ht3e9OGuIOdbqNrG54givj0pb4mb51OwZodVfbhutaapH
	s/eMixSF4LCyX+H8TfwOG7j/+RQZUWK/UjD5V3gO3iAsTloITmq70ZqN+Gf4FniY
	Nm/jjk6eOBoSkSrtaT/vGFDK86HNGudoACy9U161A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4y9bsej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Sep 2026 00:03:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68SNo0KR010544;
	Tue, 29 Sep 2026 00:03:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gamsgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Sep 2026 00:03:20 +0000 (GMT)
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 68T01nGX036113;
	Tue, 29 Sep 2026 00:03:20 GMT
Received: from labops-common-sca-01.us.oracle.com (labops-common-sca-01.us.oracle.com [10.132.26.161])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4gx4gamsgj-1;
	Tue, 29 Sep 2026 00:03:20 +0000 (GMT)
From: Dai Ngo <dai.ngo@oracle.com>
To: justin.tee@broadcom.com, paul.ely@broadcom.com
Cc: linux-scsi@vger.kernel.org, dai.ngo@oracle.com
Subject: [PATCH v4 1/1] scsi: lpfc: defer SCSI rport node put until devloss callback
Date: Mon, 28 Sep 2026 17:02:57 -0700
Message-ID: <20260929000315.2298554-1-dai.ngo@oracle.com>
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
 definitions=2026-09-28_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0
 mlxscore=0 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609280095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA5NSBTYWx0ZWRfX79BaAu8M3EXc
 GHUCn1+5K+YPZSotdEOInhj5rmw3H0V65XRFpDMgXagBt9W2pC7VuFN5B1lKJcE1pe4nQ5kAMNe
 adxkPBVU4/lZczw65LKWaZPH98jdjvjmo19Hz8dvcU9mKRSnpLssytMPh3sQpslIhOJVH/HFKrY
 6GciyO+oXp4LbUbqEGGWRy9UDYhiSsKSqWM9oimeQsUQVfhQqc2lZEo4NAlpy1Lh5XNHtDDfeSI
 N8OEzQuDrCRTfCdIuMfuH5xgp5jTZZxwXPQ6D2vh449ekmWrL2Rprhf/0gHwVPe6pmnLxYVck1l
 jM6nfoTwN1sbnOx4xb3JfZF7X+FCg7UrFdp5M3KsOq9Ez00cfNl6ma6iFpdG16m/rlMx0QtTeSq
 Lyp+H+/2qOfEepL8Ftw3Nvl/VL/sPge48juLu29R1VyUVlgA4L48ug3nC2vnY4HedDHqyzOMKJ8
 pu92q9GjXUcGcd+PQ6w==
X-Proofpoint-GUID: OVxeaj8H990gHkibf0mMfxqJ449xKC-C
X-Proofpoint-ORIG-GUID: OVxeaj8H990gHkibf0mMfxqJ449xKC-C
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA5NSBTYWx0ZWRfXyMC3h4rX0A6q
 Z9oHC+W097rij7akalsFQiT+9adu/SQH5Wl1jS5Qav8BFqxYOgZWENzBnYBFA0I9dOM00Q5mx6N
 QhNMqiA4MSsqdqg4bVv2aAXXtcxVvlewoSjCIWsIlcKwzBIhzTL0
X-Authority-Analysis: v=2.4 cv=IuyL47/g c=1 sm=1 tr=0 ts=6abb0049 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=jie1_J9daaOAJg9D-NcA:9
 a=WmVTiCyuxqgg3mnwYu6p:22

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
 drivers/scsi/lpfc/lpfc_hbadisc.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

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

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4f68038789b5..582efb297c74 100644
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
@@ -4475,6 +4481,7 @@ static void
 lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct fc_rport  *old_rport = ndlp->rport;
 	struct fc_rport  *rport;
 	struct lpfc_rport_data *rdata;
 	struct fc_rport_identifiers rport_ids;
@@ -4510,7 +4517,10 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	rport->maxframe_size = ndlp->nlp_maxframe;
 	rport->supported_classes = ndlp->nlp_class_sup;
 	rdata = rport->dd_data;
-	rdata->pnode = lpfc_nlp_get(ndlp);
+	if (rport == old_rport)
+		rdata->pnode = ndlp;
+	else
+		rdata->pnode = lpfc_nlp_get(ndlp);
 	if (!rdata->pnode) {
 		dev_warn(&phba->pcidev->dev,
 			 "Warning - node ref failed. Unreg rport\n");
@@ -4570,7 +4580,6 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 			 kref_read(&ndlp->kref));
 
 	fc_remote_port_delete(rport);
-	lpfc_nlp_put(ndlp);
 }
 
 static void
-- 
2.47.3

