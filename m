Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1659C4DF4C1;
	Wed, 16 Sep 2026 23:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600193; cv=none; b=MIiPxN7GJFMDXq7k4DZNrh5fYjGfRQfwwwmh2YZ2z2kBXNpWoVHu5h6PrMSmH2AbqNzcDw9ranrY4vR4wVQbO9s1JZBlXaWsUTVHjPjRmDzvaGQ8PIBUQypIKpMKSBpK07ka+m2kfgXHakBRKu4ToPb/6TgaMWWcF46xS7W9tyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600193; c=relaxed/simple;
	bh=BKzJNtbcpl7AWuskcHlS/q1zvEjlIf1PkHugFLftmnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhdXuSFM9gh8uBrnnaWSmyBL1OrQZncgjR7EYsPlMfimQQAoWOJC/5N7NlmxJmDlbWZapRPhinTlGvgiKWe+0DeV3K0dXGVTd6jLssai9bEivyz4kcWhL+3SX3i3ZImjL3QPG2ONRaq70YYOW8vY8iYBE3DVMmPfeZj2IuZ43hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hZtm0kAo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hZtm0kAo"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1Vl3006701;
	Wed, 16 Sep 2026 23:09:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=EEuEuE0WYF2hGja20
	dAtbb6NKs9VnDwccw2Va5YMUlo=; b=hZtm0kAokL+N/JSUNOCvmMOpPLdVKsLxT
	46U/PHi0vOc/msxZpyQ0pQxwdBJHqcL3KI4I13YbSe8vI/TBQVs9+eb+B1Uw2vfV
	KsxDsQEswML/nDG1WBKX9qqnOcmhqoro6RoTKRqPQAArIohPyVfBxybjwFTEE3ZJ
	fvwe7iC2hRo63QITNBtDQyaA20w1EbvU+Krv61bcr/60JNGK0VcCg/7aqhXHvlEV
	P7p5/206i9oMoySm4NjyRxFlfT+/clJFToPVqr8Jtpt7gEJ/HdTTkovugEtoDBCt
	AgaYudb7tU6qjeX+WKsEdY+NklCfhUJIfT6ZiW0RoS9vS3GYx+H7g==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmx83ydyt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:45 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GN2IAU1699595;
	Wed, 16 Sep 2026 23:09:44 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gq03vgufr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:44 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9heq4719444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:43 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E39CC5804E;
	Wed, 16 Sep 2026 23:09:42 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0358458066;
	Wed, 16 Sep 2026 23:09:42 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:41 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 14/20] scsi: ibmvfc: fix UAF and stall in NVMe LS abort callback
Date: Wed, 16 Sep 2026 16:09:15 -0700
Message-ID: <20260916230921.2204729-15-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916230921.2204729-1-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfXxvRt7LLxO4fk
 oCNxB0/HcNk6V6sUoRiJFVm5xuKjcGXheCr4GxsNb02RVlTE+i2YRFjjBfajrXWiStDdbTOthiP
 Tewr4squ1SJyajKAXKCq0+2Ca3VyPYwup0BRArGYG61Hj6b3wvbP4TK36QFSC8wpFtDG4yy4vZV
 ravlV47TQpEwynOLhVkcvJcxC2WuUXJUb2Is2F7iYhU6uiinlFvT9/OxsoebPHwyML8nxjBwBO4
 SpBU2PdjDp74DDKpj6D3a5MvdQER6P6T62Ov/XMGXLT9Jeqpp5r+/yDHPgFJyY2V1ELKwgd+pN4
 3j154SzZgLg3jJr1Z9GSB4gli+Hdt/7Wt2FYo5x8Yg+TxbT4I5ZiOSbV2dD45oVABmW/ho21Ibu
 0tBHNyOB1rI3SzP1HfQgoMI2Du+3vNqZAIj5+9HR1Uo/CDl9fl0Q6rGoAFK7aJcCMvnAqe5CLia
 hx756L4wcsAG1EIrjKw==
X-Proofpoint-ORIG-GUID: YSDbtv1x8s2r3nj-LMWiwgUn8DGl6t2m
X-Proofpoint-GUID: YSDbtv1x8s2r3nj-LMWiwgUn8DGl6t2m
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX014pdk1roAkM
 lpV/Cq67rx1VRnlXwCggeXNazBgMgw1/mqgcB5GCCncyM3ShxTxAbdX2xjTgzmCVwyOZCldIx7k
 nud+MSxaaQHLgjsKPIjTl0O7kLNDlTg=
X-Authority-Analysis: v=2.4 cv=cY9HPXDM c=1 sm=1 tr=0 ts=6aab21b9 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=bf3VTdwimHnaYT9JOUcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160322

Two problems in ibmvfc_nvme_ls_abort():

1. Use-after-free / stale pointer dereference.
   ibmvfc_init_ls_abort() reads abt_evt = ls_abort->private and
   immediately dereferences abt_evt->tgt.  ibmvfc_ls_req_done() calls
   ibmvfc_free_event() under host_lock, which returns the event slot to
   the pool.  If the LS completes naturally just before ls_abort is
   called, abt_evt points to a freed (and potentially reused) event,
   making the dereference a UAF.

   Fix by taking host_lock before reading ls_abort->private and checking
   evt->free (set to 1 by ibmvfc_free_event() under host_lock) to detect
   whether the original LS has already completed.  If so, there is
   nothing to cancel and we return early.  ibmvfc_get_event() is also
   moved inside the lock so the validity check and event allocation are
   atomic with respect to the completion path.

2. Blocking wait on timeout workqueue (same class as the FCP abort fix).
   The original code called wait_for_completion() from ls_abort, which
   is invoked by the NVMe-FC transport from a context that must not
   block.

   Fix by replacing ibmvfc_sync_nvme_completion with a dedicated async
   callback ibmvfc_nvme_ls_abort_done() that logs any non-zero MAD
   status, drops the target kref, and frees the event.
   ibmvfc_send_event() guarantees the callback fires on both success and
   failure paths, so ibmvfc_nvme_ls_abort() returns immediately after
   ibmvfc_send_event().

ibmvfc_sync_nvme_completion is now unused and is removed.
ibmvfc_init_ls_abort() is updated to take the validated abt_evt pointer
directly instead of deriving it from ls_abort->private.

Fixes: 20bec08f0208 ("scsi: ibmvfc: implement nvme-fc LS abort handling callback")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 68 +++++++++++++++--------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 52e2621a4342..7e18b79ae4cc 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -164,21 +164,12 @@ static int ibmvfc_nvme_ls_req(struct nvme_fc_local_port *lport,
 	return 0;
 }
 
-static void ibmvfc_sync_nvme_completion(struct ibmvfc_event *evt)
+static void ibmvfc_init_ls_abort(struct ibmvfc_event *evt,
+				 struct ibmvfc_event *abt_evt)
 {
-	/* copy the response back */
-	if (evt->sync_iu)
-		*evt->sync_iu = *evt->xfer_iu;
-
-	complete(&evt->comp);
-}
-
-static void ibmvfc_init_ls_abort(struct ibmvfc_event *evt, struct nvmefc_ls_req *ls_abort)
-{
-	struct ibmvfc_tmf *tmf;
-	struct ibmvfc_event *abt_evt = ls_abort->private;
 	struct ibmvfc_target *tgt = abt_evt->tgt;
 	struct ibmvfc_host *vhost = evt->vhost;
+	struct ibmvfc_tmf *tmf;
 
 	tmf = &evt->iu.tmf;
 	memset(tmf, 0, sizeof(*tmf));
@@ -192,8 +183,18 @@ static void ibmvfc_init_ls_abort(struct ibmvfc_event *evt, struct nvmefc_ls_req
 	tmf->cancel_key = cpu_to_be32((u64)abt_evt);
 	tmf->my_cancel_key = cpu_to_be32((u64)evt);
 	tmf->assoc_id = cpu_to_be64(tgt->assoc_id);
+}
+
+static void ibmvfc_nvme_ls_abort_done(struct ibmvfc_event *evt)
+{
+	u16 status = be16_to_cpu(evt->xfer_iu->mad_common.status);
+
+	if (status)
+		ibmvfc_dbg(evt->vhost, "ls_abort: cancel MAD failed with rc=%x\n",
+			   status);
 
-	init_completion(&evt->comp);
+	kref_put(&evt->tgt->kref, ibmvfc_release_tgt);
+	ibmvfc_free_event(evt);
 }
 
 static void ibmvfc_nvme_ls_abort(struct nvme_fc_local_port *lport,
@@ -202,34 +203,35 @@ static void ibmvfc_nvme_ls_abort(struct nvme_fc_local_port *lport,
 {
 	struct ibmvfc_host *vhost = lport->private;
 	struct ibmvfc_target *tgt = rport->private;
-	struct ibmvfc_event *evt;
-	union ibmvfc_iu rsp;
+	struct ibmvfc_event *evt, *abt_evt;
 	unsigned long flags;
-	u16 status = IBMVFC_MAD_CRQ_ERROR;
+
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
+
+	/*
+	 * If the original LS has already completed naturally, abt_evt will
+	 * have been freed back to the pool (evt->free set to 1 under
+	 * host_lock by ibmvfc_free_event()).  Nothing left to cancel.
+	 */
+	abt_evt = ls_abort->private;
+	if (!abt_evt || atomic_read(&abt_evt->free)) {
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		return;
+	}
 
 	evt = ibmvfc_get_event(&vhost->crq);
-	if (!vhost->logged_in || !evt)
+	if (!vhost->logged_in || !evt) {
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		return;
+	}
 
-	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	kref_get(&tgt->kref);
-	ibmvfc_init_event(evt, ibmvfc_sync_nvme_completion, IBMVFC_MAD_FORMAT);
-	ibmvfc_init_ls_abort(evt, ls_abort);
-	evt->sync_iu = &rsp;
-
-	if (ibmvfc_send_event(evt, vhost, default_timeout))
-		goto out;
-
-	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+	ibmvfc_init_event(evt, ibmvfc_nvme_ls_abort_done, IBMVFC_MAD_FORMAT);
+	ibmvfc_init_ls_abort(evt, abt_evt);
+	evt->tgt = tgt;
 
-	wait_for_completion(&evt->comp);
-	status = be16_to_cpu(rsp.mad_common.status);
-	spin_lock_irqsave(&vhost->host->host_lock, flags);
-	ibmvfc_free_event(evt);
-out:
+	ibmvfc_send_event(evt, vhost, default_timeout);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
-	ibmvfc_dbg(vhost, "ls_abort: cancel failed with rc=%x\n", status);
-	kref_put(&tgt->kref, ibmvfc_release_tgt);
 }
 
 static void ibmvfc_nvme_done(struct ibmvfc_event *evt)
-- 
2.55.0

