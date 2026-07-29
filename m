Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA84335E1B6
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 21:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785359067; cv=none; b=GSznsb4SLKNkNJfNCnpa9YALNt9sCkV0DLV/xkgiRB2mbc8Nh9g/j4UWNvDUNdmUBiKOss3V1TcK0FWdX7nG5RIAJrdc9ZubJNn3fkDn1mx4zvXM8wKHdMetlswjBzlwejdHjq3HaLGYfVVimfgrv2yZlMXk0kuRzgFbNrcmGoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785359067; c=relaxed/simple;
	bh=rxutJ3yOvioBgqPkEcfGLL1vtFu9x4/d4+u3eaM3BY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D2Z3/dpewwCplVd5Nk/hxg0CJVAlD9Kdv9i7bKUjIZhukSGTtsoODTDbOybva80CTs2w1rg+8BybE4qHsYA9drh07wL+UwM9j5GPefy1aNIWl2DoPnFH7yo8BMaW1ksLRnidiLHWGtqzXjaetG20kT+aqz69aj2ZcQfXS1OhFa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rraenrcH; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rraenrcH"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDTUnl2983500;
	Wed, 29 Jul 2026 21:04:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=pEPCqNgjNBodXo9XahTUhMSAVXj5Y
	DXcSWqt+GtTmQE=; b=rraenrcHTYCAeb8GnSf73Yp7aK5jMjg9WUpwcI4u2OLnR
	UXXanK+VHezbEfogVbwFMEJzynuNKHjiZd2vNotyKR+HHHgFTqOmin+j8skZF22m
	oB0X/7aO4M8ZtPsx7/EChcVqPSxkA2nnmWeysCnqW07HzzOvisjGRvY1tzchQgqT
	qtvMNAuGtB5Mq6/K1WBAu11L/t4rN83/nf7htiJ9UazE7A63al04IJn5cbRoxUxx
	YtwZuP+q1OE/uKj3uKgd4uoGdDwjxMen+NmU+V+Tl3JfeD4ZtqIFBNikeRY8hglA
	lnf23ziXBrg3vjWQkj0S+pJWPaWZ6SFsbj6JFAAgA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1demxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 21:04:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TKem34012804;
	Wed, 29 Jul 2026 21:04:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6eebmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 21:04:22 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66TL1H18035771;
	Wed, 29 Jul 2026 21:04:22 GMT
Received: from labops-common-sca-01.us.oracle.com (labops-common-sca-01.us.oracle.com [10.132.26.161])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6eebkx-1;
	Wed, 29 Jul 2026 21:04:22 +0000 (GMT)
From: Dai Ngo <dai.ngo@oracle.com>
To: james.smart@broadcom.com, dick.kennedy@broadcom.com
Cc: linux-scsi@vger.kernel.org, dai.ngo@oracle.com
Subject: [PATCH v2 1/1] scsi: lpfc: Clear rport node association before unregister
Date: Wed, 29 Jul 2026 14:04:09 -0700
Message-ID: <20260729210413.700187-1-dai.ngo@oracle.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_07,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290158
X-Proofpoint-GUID: a25Ik0zFlPrybRwu1IlvbZni-RxT-5qY
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a6a6ad7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=xMQEAA6d7aCKQBBbxUYA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDE1OCBTYWx0ZWRfX7DkwhaeWuGh/
 30+978Cp443IVPuVQlOQ2eXDbOPWm6OgjnAbgJEaZolyUY4l+nASJymr53y7k3ILTw6/aLuiyfx
 s4QtdeHx8+Q95eHCsQj3YWwTmQ4RmKmHdel8FVba1zf6h/ixJdIw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDE1OCBTYWx0ZWRfX0P+8iO8uaPta
 oPBnMn49O+l+UvLnH3DARK2wrIwFrgi2UICnNpjUJ2eE3doQQuufI5td0ffdEbooOxH2/ZIwjc+
 UWBwBZFYpF+kvEEeuQ08ErPDdsFFWyQQWFLX5SX1TWOJ+GPjpqnDCpMqfp2WYFhxhf/Oxrtl7/P
 Bo4jQKMUEj7cDlRF6rKWR+NFqY88bTvAP8twtrF9aNrm9fs3yHDdCqm5bKQO3MAXswZjW2SG1Ey
 PK5liJcygeUgHdgldES6ym3zJCO1dhU5+fjI6sRyzukgwvlJBv7AVE5JbhJaCBgKFPzciKltQKW
 xIzyyZmVu8nVygcBB9LpgRSEP5IwZNjZsWeN9dXsirTAyKz3FPRJiNC+teKdUwI1bvsWZ+kDjfp
 ZJN1BQ4NCw704X3ok9gQghOmWIiT5j5e1bNMBGTnYU3l7dgOAGfjn0hqWEDmwOkC2dMotjmLizI
 C6lU/f75ssNNksgT7RtgxvNa1C1kdaksToio4Rl0=
X-Proofpoint-ORIG-GUID: a25Ik0zFlPrybRwu1IlvbZni-RxT-5qY

Pulling an FC cable can drive lpfc through remote-port devloss teardown.
In one observed crash, the SCSI transport workqueue called
lpfc_dev_loss_tmo_callbk() from fc_rport_final_delete(), and lpfc faulted
while dereferencing the ndlp-derived vport:

  Workqueue: fc_wq_19 fc_rport_final_delete [scsi_transport_fc]
  RIP: lpfc_dev_loss_tmo_callbk+0x58/0x48d [lpfc]

Call trace:

lpfc_dev_loss_tmo_callbk+0x58/0x48d [lpfc]
fc_rport_final_delete+0xeb/0x1b0 [scsi_transport_fc]
process_one_work+0x174/0x31a
worker_thread+0x191/0x300
kthread+0xcf/0x100
ret_from_fork+0x31/0x50
ret_from_fork_asm+0x1a/0x30

The rport private data still contained a non-NULL pnode, but that pointer
could refer to an ndlp whose lifetime had already ended. The callback then
treated the stale pnode as valid and dereferenced fields such as
ndlp->vport.

When lpfc unregisters a SCSI remote port, it calls fc_remote_port_delete()
and then drops the ndlp reference that was taken when rdata->pnode was set
during registration. However, the rport private pnode field was left intact
until the transport devloss callback path cleared it. This leaves a window
where a later transport callback can observe a stale pnode after the ndlp
reference has been released.

This patch detaches the lpfc node from the rport before calling
fc_remote_port_delete() and before dropping the transport-held ndlp
reference. Snapshot ndlp->rport under ndlp->lock, clear rdata->pnode,
clear ndlp->rport, and clear the SCSI transport registration flag while
holding the lock. Also make the devloss callback tolerate a NULL rport
or rport private data and use READ_ONCE() / WRITE_ONCE() for the lockless
pnode handoff.

This makes the unregister path match the callback teardown path: once lpfc
has severed the rport-to-ndlp association, later devloss callbacks see a
NULL pnode and return instead of touching a released node.

Assisted-by: Codex:gpt-5
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

V2:
  . in lpfc_unregister_remote_port(), snapshot ndlp->rport under ndlp->lock,
    clear rdata->pnode, clear ndlp->rport, and clear the SCSI transport
    registration flag while holding the ndlp->lock.

  . in lpfc_dev_loss_tmo_callbk, check rport's private data before
    using it and and use READ_ONCE() / WRITE_ONCE() for the lockless
    pnode handoff.

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4f68038789b5..a04222ab4092 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -157,13 +157,21 @@ void
 lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 {
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_rport_data *rdata;
 	struct lpfc_vport *vport;
 	struct lpfc_hba   *phba;
 	struct lpfc_work_evt *evtp;
 	unsigned long iflags;
 	bool drop_initial_node_ref = false;
 
-	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
+	if (!rport)
+		return;
+
+	rdata = rport->dd_data;
+	if (!rdata)
+		return;
+
+	ndlp = READ_ONCE(rdata->pnode);
 	if (!ndlp)
 		return;
 
@@ -187,6 +195,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	    !test_bit(HBA_SETUP, &phba->hba_flag))) {
 
 		spin_lock_irqsave(&ndlp->lock, iflags);
+		WRITE_ONCE(rdata->pnode, NULL);
 		ndlp->rport = NULL;
 
 		/* Only 1 thread can drop the initial node reference.
@@ -271,7 +280,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	 * rport. Remove the association between rport and ndlp.
 	 */
 	ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
-	((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
+	WRITE_ONCE(((struct lpfc_rport_data *)rport->dd_data)->pnode, NULL);
 	ndlp->rport = NULL;
 	spin_unlock_irqrestore(&ndlp->lock, iflags);
 
@@ -4553,8 +4562,10 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 static void
 lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 {
-	struct fc_rport *rport = ndlp->rport;
+	struct fc_rport *rport;
 	struct lpfc_vport *vport = ndlp->vport;
+	struct lpfc_rport_data *rdata;
+	unsigned long iflags;
 
 	if (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
 		return;
@@ -4566,9 +4577,22 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 			 "3184 rport unregister x%06x, rport x%px "
 			 "xptflg x%x refcnt %d\n",
-			 ndlp->nlp_DID, rport, ndlp->fc4_xpt_flags,
+			 ndlp->nlp_DID, ndlp->rport, ndlp->fc4_xpt_flags,
 			 kref_read(&ndlp->kref));
 
+	spin_lock_irqsave(&ndlp->lock, iflags);
+	rport = ndlp->rport;
+	if (!rport) {
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+		return;
+	}
+	rdata = rport->dd_data;
+	if (rdata && READ_ONCE(rdata->pnode) == ndlp)
+		WRITE_ONCE(rdata->pnode, NULL);
+	ndlp->rport = NULL;
+	ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+	spin_unlock_irqrestore(&ndlp->lock, iflags);
+
 	fc_remote_port_delete(rport);
 	lpfc_nlp_put(ndlp);
 }
-- 
2.47.3

