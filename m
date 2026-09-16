Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942A64CDA39;
	Wed, 16 Sep 2026 23:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600191; cv=none; b=NxfLrca7zJq84hX9tCYmUu+PQsDhwHtB7tYU3CnoWvO1WD7Sals4z4u5+WAsrJKsyuWcibFUdfsYIu4eFs6J770+VZ155FfCg/bIeiLIXdpE9mocMHtkEwRcHD7tc09nalTdOkCKYiQAhUHypW+MReZPmXWNDQFCQLC2qeO29Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600191; c=relaxed/simple;
	bh=/9sBlz23bAELsYD4zWmjO4Ay4e7cNSA2tokuQ6fdeKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5qoK+MC8etpT3xNqNmtbv6mF/Ez2OTXv0R3hb8tOs3FpRTtVqIHZ/iwnpbHyL37vAHry6ftwqRcTzLqUdXbNiVoUBNsxsxYLG+wy7SXsPxGJVWXcPB64JiHuQWtV65hT+oB0xI0PL5HOQ8QyPESwCoIXFvwhm6oDmkVLBMDPEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VanvMmMa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VanvMmMa"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1bB14057197;
	Wed, 16 Sep 2026 23:09:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=vrNNndpg8uDbPLoZ8
	wG5Yom8DF08eKhsLkkfjMxG7uk=; b=VanvMmMa/u5bph2/vtZDmPsZpVBqBrObc
	6nNcvu2sJvWu/RKHVgHMqk2spO57ax/552Wqi3eQzuGEIlSD381+uxl7bObTaSYt
	201EEgyVYhWCseim1lQPiwLyjvbE1SH4Z5UQZN6OWfxfrizw9asFCWIjhd/RlFKN
	D59WWBfs9/TxdxM0OmrgSQuSALQgFrtTW8hyI6MniS8689ujRmFjVTmp+VtEZidy
	Qii4rCFX8KbIfRGDt1Ad0oV7H6NKxN4GwrQu5a6QqxfMJQ/DEbhFCLMj3p670oJ1
	iImprXTqY+lZ3bpk2+zPb7rLQqeKSIo7YGbvvjsQxMhP4xeQ5UGgQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmv5hy9vc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:43 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GMqn6e1713205;
	Wed, 16 Sep 2026 23:09:43 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gpywf0w4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:43 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9fFN12321386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:42 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA47358056;
	Wed, 16 Sep 2026 23:09:41 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD48458054;
	Wed, 16 Sep 2026 23:09:40 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:40 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 13/20] scsi: ibmvfc: make NVMe FCP abort callback asynchronous
Date: Wed, 16 Sep 2026 16:09:14 -0700
Message-ID: <20260916230921.2204729-14-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX8cvTC+XuKLgE
 zLapWam3bdzQcqpx2hTQ/4GOFMa6zWJbxXBpLoLJde2Weqs0KHXS/ZUFxMyU0jWEmK4Rg8zYAJ4
 Lktngr02mD3RoXEA+E1+gZs4ePt4BUihYTG15YApfaojfA0FVZsuxy5p9gSIYvp0U56nq6e8eM/
 p8Wy5XM1JB31pW8SgPv+JO54M073pGiPkJT/uk4MPTLK+B9dwUU3OUYkhwflj8BLpEaiVI1YeQC
 Rs25YaMPNK4Kpe4YUctG092sQsuCHqeLjOgzZDRaqCM6NHzWP/T2o8H8502Qbp0Rdr4ME97R40/
 hP8x8+ubWrmLHdBfwMe1Hymz+XJ8UjMjOX+O15TNREFjIF4Au1A4Uv97xjsEmUXN0mSsMXhwcdF
 d7w/wKJxfZFI2i1OtCFof9aPpxKuuCRiU3lCQEz9bhk6p9cOOOi+r5W0DbIIUCVmA1k9sBiy9lK
 anhn/yuZzA0pe4/MOKA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfXyPbCyAs7HPX2
 XX0QSQh3sWB8ftPSL9kN2/aUuE1+6PN+Nhj2QEftjY5yE5HycIlFAiBeKagEaA93oXm26CyNh3u
 +J2uUNT6Op1sWI+QCsG0EL3WnopDRNg=
X-Authority-Analysis: v=2.4 cv=Zsx4uN7G c=1 sm=1 tr=0 ts=6aab21b7 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=bHZ0--RjxAHeecJfWq4A:9
X-Proofpoint-ORIG-GUID: MRfKdFncXLRnA9CZQ_gWCq-OWtpjGDgh
X-Proofpoint-GUID: MRfKdFncXLRnA9CZQ_gWCq-OWtpjGDgh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160322

The nvme_fc_port_template fcp_abort callback is called by the NVMe-FC
transport from the block layer timeout workqueue. The current
implementation submits a cancel MAD and then blocks on
wait_for_completion() until the VIOS response arrives. This stalls the
timeout workqueue for the full MAD round-trip, preventing any other I/O
timeout from being processed in the meantime.

The nvme-fc-driver.h API contract is explicit: the LLDD must initiate
the abort and return immediately; the ABTS does not need to be complete
on return. The transport waits for the original exchange to complete
independently via fcp_req->done().

Replace the synchronous ibmvfc_sync_nvme_completion callback with a
dedicated ibmvfc_nvme_fcp_abort_done() that runs asynchronously when
the cancel MAD response arrives. The new callback logs any non-zero MAD
status, drops the target kref, and frees the event. ibmvfc_send_event()
guarantees the done callback is invoked on both success and failure
paths, so event ownership is fully transferred and ibmvfc_nvme_fcp_abort()
returns immediately after ibmvfc_send_event().

Drop the now-unnecessary init_completion() from ibmvfc_init_fcp_abort()
and the sync_iu / wait_for_completion / second lock-cycle from the abort
function itself.

Fixes: 4e70b8795ee3 ("scsi: ibmvfc: implement nvme-fc FCP abort callback")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 35 ++++++++++++-----------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index d9f280c658eb..52e2621a4342 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -396,8 +396,18 @@ static void ibmvfc_init_fcp_abort(struct ibmvfc_event *evt,
 	tmf->target_wwpn = cpu_to_be64(tgt->wwpn);
 	tmf->assoc_id = cpu_to_be64(tgt->assoc_id);
 	tmf->task_tag = cpu_to_be64((u64)abt_evt);
+}
 
-	init_completion(&evt->comp);
+static void ibmvfc_nvme_fcp_abort_done(struct ibmvfc_event *evt)
+{
+	u16 status = be16_to_cpu(evt->xfer_iu->mad_common.status);
+
+	if (status)
+		ibmvfc_dbg(evt->vhost, "fcp_abort: cancel MAD failed with rc=%x\n",
+			   status);
+
+	kref_put(&evt->tgt->kref, ibmvfc_release_tgt);
+	ibmvfc_free_event(evt);
 }
 
 static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_port *lport,
@@ -409,9 +419,7 @@ static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	struct ibmvfc_target *tgt = rport->private;
 	struct ibmvfc_event *evt, *abt_evt = abort_req->private;
 	struct ibmvfc_queue *queue;
-	union ibmvfc_iu rsp;
 	unsigned long flags;
-	u16 status = 0;
 
 	if (!abt_evt)
 		return;
@@ -426,27 +434,12 @@ static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 
 	spin_lock_irqsave(queue->q_lock, flags);
 	kref_get(&tgt->kref);
-	ibmvfc_init_event(evt, ibmvfc_sync_nvme_completion, IBMVFC_MAD_FORMAT);
+	ibmvfc_init_event(evt, ibmvfc_nvme_fcp_abort_done, IBMVFC_MAD_FORMAT);
 	ibmvfc_init_fcp_abort(evt, abort_req);
-	evt->sync_iu = &rsp;
-
-	if (ibmvfc_send_event(evt, vhost, default_timeout))
-		goto out;
+	evt->tgt = tgt;
 
+	ibmvfc_send_event(evt, vhost, default_timeout);
 	spin_unlock_irqrestore(queue->q_lock, flags);
-
-	wait_for_completion(&evt->comp);
-	status = be16_to_cpu(rsp.mad_common.status);
-
-	spin_lock_irqsave(queue->q_lock, flags);
-	ibmvfc_free_event(evt);
-out:
-	spin_unlock_irqrestore(queue->q_lock, flags);
-
-	if (status)
-		ibmvfc_dbg(vhost, "fcp_abort: cancel failed with rc=%x\n", status);
-
-	kref_put(&tgt->kref, ibmvfc_release_tgt);
 }
 
 static struct nvme_fc_port_template ibmvfc_nvme_fc_transport = {
-- 
2.55.0

