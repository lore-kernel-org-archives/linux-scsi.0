Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8B0394496;
	Sat, 19 Sep 2026 01:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781613; cv=none; b=U29kSSU9LYT1C61SvYzjN5rVc1nF2h7D9Uus2bmSSKkITqZEsxqJCT57wNwSkmn9HNRGiXXv2hcxh21A6Qkv7tVAv4lC6DcGnGRjA8SiC1KfSSqrq68++go5tarBDCl1GeAA2GsFstRXq3F7PXeeyFfDQ8NM36PNn+/iUYScwYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781613; c=relaxed/simple;
	bh=iwOmATHz6ecG7y6QB9H5IKmbp1v4HCBU86o018GqdGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1M+zpjgmMAdY1iArJUmQNJevUSRvrGn4TBLgQTCpUYRNKXWiwmV6KhnKmYc5TC2nhyMZ6U5fxSCIAEaIKwlxGIAS5L+As6HeSC2KYmsZrUxS80LHCrIR4zg++AXBuvnVGMiddsThnBPaJtfKzwd6BBiCbj/t8Q1k4hsG1kuauc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EcACn6EK; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EcACn6EK"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J01otQ2706961;
	Sat, 19 Sep 2026 01:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fgHc9VzWY7mw63AsN
	Par+mYGs4tBOAd2KXAXORTkIt0=; b=EcACn6EK6A8ezQP3BMqEhXCYJX5nYctNq
	07oa+Sy7Oi1Fm3pypFe71EVMke5rlU78QlLjK+kQZi4Cq48yp6j3TKc6ODziF0A7
	5TDM9H5G8MS4dZP4XG8sAHH067Y8Q+v4n0qOO92HPWovp8di64/QCdyd+7tglh5K
	r3ihAvrro1+QCM4eJc2I8nqBiNsUluXiCs8mhWhaXW/S4KtZ13wmkKDdHkBfkCMT
	i9RdZCl2oJhxtowsxzN73n/CWKZRPvlDn4C/0H1tBtBbxh6l+e4qTJtKnicCp2cw
	9dMeWJgOugpEqoSHqTh0KUT1d6qsrU+Oi1HlYfsl0ksTPvr5XPIzw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcvj9mn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:23 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1QdYb1584450;
	Sat, 19 Sep 2026 01:33:23 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gsgr2r0ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:23 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XLXn31720138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:22 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 986E158051;
	Sat, 19 Sep 2026 01:33:21 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F044A5805C;
	Sat, 19 Sep 2026 01:33:20 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:20 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 14/20] scsi: ibmvfc: fix UAF and stall in NVMe LS abort callback
Date: Fri, 18 Sep 2026 18:33:00 -0700
Message-ID: <20260919013306.2948028-15-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919013306.2948028-1-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX0Nn8DJ1qVtxX
 uSR2NJ9+Sdf9yr1ErXOaEJ5U0rqsKSmbSQ2+OT85uSGoF1IGQWs4JEXOVbmmlztu83WqkO4woDi
 eqx/Dn/OzX3FOdB/9TpyUw3n9TsGjmM=
X-Proofpoint-ORIG-GUID: f7VTWwovgNZgqxy_iXGEOIKrxyTWpP1A
X-Proofpoint-GUID: f7VTWwovgNZgqxy_iXGEOIKrxyTWpP1A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX5sQJGXTKXIex
 a5/0GsVNV4Uo3vYHdA8TF3RQxjnxUeaLC/fMDCpJPIYNX/7jdHLUcUeOb5RqbtApOcBmm27xQ0F
 306JNkucecyYG3aF2EwQS65D8XOUp8AKDFeU6DRYZpjiVC6iRlwICs+3HikLWU1YeGHEyYVQ9cf
 VmY31wlRdoVUXMdiDt3e+tcrLcTJo8TXiq8aOckbjbw+rbRSOLLeMNYFdZwLgUfPgiud1gyQ5XB
 fv7RUdURGuLxulML096+VdW+sKP/tbvWvk/qvkOeJv0m/+BuR49YVU0cndmspeU5Bh/YkBVRgM1
 U0NIpXHV75OkgmFRSJnZRxljocLxsUBzQPZrbn2VciJhYY3etslPEs4aDLxVpbyMT6QkrDrJlUz
 lPSINyPcL2WzfsEmw484/iqe8NVDcMj2lWdZEbG33cKrmD0VdgK9gSHAYwK6o9Coo9yOcVfFYWs
 SFYDjkzMvveNa4jHHpA==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aade663 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=bf3VTdwimHnaYT9JOUcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

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
 1 file changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index d23e5f31f8b5..475177cda103 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -103,6 +103,7 @@ static void ibmvfc_ls_req_done(struct ibmvfc_event *evt)
 		rc = -EIO;
 
 	evt->ls_req->done(evt->ls_req, rc);
+	evt->ls_req = NULL;
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -164,21 +165,12 @@ static int ibmvfc_nvme_ls_req(struct nvme_fc_local_port *lport,
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
@@ -192,8 +184,18 @@ static void ibmvfc_init_ls_abort(struct ibmvfc_event *evt, struct nvmefc_ls_req
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
@@ -202,34 +204,36 @@ static void ibmvfc_nvme_ls_abort(struct nvme_fc_local_port *lport,
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
+	if (!abt_evt || atomic_read(&abt_evt->free) || abt_evt->ls_req != ls_abort) {
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
+	ibmvfc_init_event(evt, ibmvfc_nvme_ls_abort_done, IBMVFC_MAD_FORMAT);
+	ibmvfc_init_ls_abort(evt, abt_evt);
+	evt->tgt = tgt;
 
 	if (ibmvfc_send_event(evt, vhost, default_timeout))
-		goto out;
-
-	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
-
-	wait_for_completion(&evt->comp);
-	status = be16_to_cpu(rsp.mad_common.status);
-	spin_lock_irqsave(&vhost->host->host_lock, flags);
-	ibmvfc_free_event(evt);
-out:
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
-	ibmvfc_dbg(vhost, "ls_abort: cancel failed with rc=%x\n", status);
-	kref_put(&tgt->kref, ibmvfc_release_tgt);
 }
 
 static void ibmvfc_nvme_done(struct ibmvfc_event *evt)
-- 
2.55.0

