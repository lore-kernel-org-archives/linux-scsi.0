Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E426026ED25;
	Thu, 23 Jul 2026 00:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764947; cv=none; b=ZwjbwcjJlBSsERERarU8vxEsxNUY8jVrWHeqZBxN2+BnkVO/WqK+31yEC6G0kPDSc9pzDGBKt4Qo6wi2aaQtXOiUhXCNr3OxwJJU7eJUlYFDfpExK3WLw8JXFF5Vkco1ojfi7khr2yLeL8Sf9oaQjpTKR4FANxlj/DKQkp4Jo+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764947; c=relaxed/simple;
	bh=acQYF4qaf4H7LHUEvsFSbT6/N9eK1iJt8ArROCisMVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdmkxjq3EJpHBWSSxojlypugoaKn5vZytai9ouYkCcTtTynqMMYIu0ifmKlYl42V14i8SiGUHEy/BZdQTI6WbGbEzyuyihDkcqY7piGEyV/9cPPG00RxRjh47l7q6rZ+i51DIPjbPGDHCvBYK1e580OZ6mXtIFSlwPEAFw27JEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DZaVJkTU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DZaVJkTU"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBfqw712606;
	Thu, 23 Jul 2026 00:02:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QQ3rNVg8Gcs7rw+vU
	VkAKVQPrg9N5i+HUlWECM2IyQM=; b=DZaVJkTUqRTcVSDyKhsov3duY7qboyYN9
	+nAy25FJrTW54ybVS0HhPSRrD0//fCieL6MiPPXsnRJdzm2BCwpIfclDykUIoFs5
	XzQ9+mvnLMPwpTGyS3ccthnSolULsu23y83Fp8xOVwgzEBSv8fm4FdniUGuEnnxx
	C6CMWA6zXC7dw3aWq0LIKTlBLX0uEAlVCwrcfPrrMZg4hakh5274SgRNU40Jjkw5
	aeSqEUIqTXtYvyjaxtPA8SJDj/zuc/qx/fm2uXZrQ6I1g6g+U6oJwkaWuSDKIsd/
	eOSCXm1jh9A9QK79DDScd6hXkUC50y+JzQ+JXkLkN5WsnQmTbDY1Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7914xqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:21 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnaRZ028164;
	Thu, 23 Jul 2026 00:02:20 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgnah9q45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:20 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N01hiP14549616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:01:43 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD1B958064;
	Thu, 23 Jul 2026 00:02:18 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 216A758056;
	Thu, 23 Jul 2026 00:02:18 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:18 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 33/33] ibmvfc: fail nvme-fc fcp-io and ls requests during transport reset
Date: Wed, 22 Jul 2026 17:01:49 -0700
Message-ID: <20260723000149.969416-34-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723000149.969416-1-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: z21QWmp31PYg_xOKxL8F-T6pXfOBLwl1
X-Authority-Analysis: v=2.4 cv=V6RNF+ni c=1 sm=1 tr=0 ts=6a615a0d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=7NqNYta9-qcfpvjv1bIA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX1pHfEmUW4Gi9
 qmjAXJygvtMcurDbySvblE99HCeUziRlKq2Wf3dqHN443WhYaFnqV3NGjD92SmmFVduUCdxHufk
 E3K6PhIZLMJdib7yPGi7w2tOyBimcbY=
X-Proofpoint-GUID: z21QWmp31PYg_xOKxL8F-T6pXfOBLwl1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX1PaBw1FPOF39
 8xa08vwaHtCrdg5IliSQ8C+fb9UZVCv7hyqJh3ZGeTie50ow+8UTc7tXeMUoKoJxODr/UuDMRx5
 OsBDOdJEFA3V+UsdsLompZDPuKhH/4Q09mUQdIE0OvWf2OCe/LQlhGSd3z1XH2vo+CukNKSKi3Q
 tRp17Hj8iDMme6zUKPecJPWJOyg84Fil98vy4GoaA29aib+7NDG+OSBeALG7nIrqGot/7YDJow0
 E8lJN52BoUgcxxkWl3A5SFIDHIemlZr9ss2PDXVtT++nqp8m3z1dMvVmFpG66aBbXsMO0TTVtRw
 aR165wXKKMqIjM6bWPDV9GbNl4GnAB1n+IR5aMjKk+sallBdbH+R7Mmu8aZZ+4lBKvsalUQTFhO
 HS+o7p2b7Tg4TEwKcr1tOTQcd9EtSB3Y6iMKG4usCSql//yfdcUZIBSE2uMoKTGHNPZdlQxOedn
 Hf6asMq2oWz9u0C2uKw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

The current purge code for flushing outstanding commands during a
transport reset only deals with SCSI commands. Rename the
ibmvfc_scsi_eh_done completion handler to ibmvfc_vfc_eh_done and wire it
to correctly complete nvme fcp and ls commands when flushing the
inflight command list during a reset.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 63 ++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index bc975f632da2..dfa231b6cc47 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1092,19 +1092,29 @@ void ibmvfc_free_event(struct ibmvfc_event *evt)
 }
 
 /**
- * ibmvfc_scsi_eh_done - EH done function for queuecommand commands
+ * ibmvfc_vfc_eh_done - EH done function for queued IO
  * @evt:	ibmvfc event struct
  *
- * This function does not setup any error status, that must be done
- * before this function gets called.
+ * This function does not setup any error status for scsi commands, that must be
+ * done before this function gets called.
  **/
-static void ibmvfc_scsi_eh_done(struct ibmvfc_event *evt)
+static void ibmvfc_vfc_eh_done(struct ibmvfc_event *evt)
 {
 	struct scsi_cmnd *cmnd = evt->cmnd;
+	struct nvmefc_ls_req *ls_req = evt->ls_req;
+	struct nvmefc_fcp_req *fcp_req = evt->fcp_req;
 
 	if (cmnd) {
 		scsi_dma_unmap(cmnd);
 		scsi_done(cmnd);
+	} else if (fcp_req) {
+		fcp_req->rcv_rsplen = 0;
+		fcp_req->transferred_length = 0;
+		fcp_req->status = NVME_SC_INTERNAL;
+		fcp_req->done(fcp_req);
+	} else if (ls_req) {
+		ls_req->done(ls_req, -EIO);
+		kref_put(&evt->tgt->kref, ibmvfc_release_tgt);
 	}
 
 	ibmvfc_free_event(evt);
@@ -1146,8 +1156,10 @@ static void ibmvfc_fail_request(struct ibmvfc_event *evt, int error_code)
 	BUG_ON(!atomic_dec_and_test(&evt->active));
 	if (evt->cmnd) {
 		evt->cmnd->result = (error_code << 16);
-		evt->done = ibmvfc_scsi_eh_done;
-	} else
+		evt->done = ibmvfc_vfc_eh_done;
+	} else if (evt->fcp_req || evt->ls_req)
+		evt->done = ibmvfc_vfc_eh_done;
+	else
 		evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_DRIVER_FAILED);
 
 	timer_delete(&evt->timer);
@@ -1164,13 +1176,16 @@ static void ibmvfc_fail_request(struct ibmvfc_event *evt, int error_code)
 static void ibmvfc_purge_requests(struct ibmvfc_host *vhost, int error_code)
 {
 	struct ibmvfc_event *evt, *pos;
-	struct ibmvfc_queue *queues = vhost->scsi_scrqs.scrqs;
+	struct ibmvfc_queue *scsi_q = vhost->scsi_scrqs.scrqs;
+	struct ibmvfc_queue *nvme_q = vhost->nvme_scrqs.scrqs;
 	unsigned long flags;
-	int hwqs = 0;
+	int shwqs, nhwqs = 0;
 	int i;
 
-	if (vhost->using_channels)
-		hwqs = vhost->scsi_scrqs.active_queues;
+	if (vhost->using_channels) {
+		shwqs = vhost->scsi_scrqs.active_queues;
+		nhwqs = vhost->nvme_scrqs.active_queues;
+	}
 
 	ibmvfc_dbg(vhost, "Purging all requests\n");
 	spin_lock_irqsave(&vhost->crq.l_lock, flags);
@@ -1179,14 +1194,24 @@ static void ibmvfc_purge_requests(struct ibmvfc_host *vhost, int error_code)
 	list_splice_init(&vhost->crq.sent, &vhost->purge);
 	spin_unlock_irqrestore(&vhost->crq.l_lock, flags);
 
-	for (i = 0; i < hwqs; i++) {
-		spin_lock_irqsave(queues[i].q_lock, flags);
-		spin_lock(&queues[i].l_lock);
-		list_for_each_entry_safe(evt, pos, &queues[i].sent, queue_list)
+	for (i = 0; i < shwqs; i++) {
+		spin_lock_irqsave(scsi_q[i].q_lock, flags);
+		spin_lock(&scsi_q[i].l_lock);
+		list_for_each_entry_safe(evt, pos, &scsi_q[i].sent, queue_list)
 			ibmvfc_fail_request(evt, error_code);
-		list_splice_init(&queues[i].sent, &vhost->purge);
-		spin_unlock(&queues[i].l_lock);
-		spin_unlock_irqrestore(queues[i].q_lock, flags);
+		list_splice_init(&scsi_q[i].sent, &vhost->purge);
+		spin_unlock(&scsi_q[i].l_lock);
+		spin_unlock_irqrestore(scsi_q[i].q_lock, flags);
+	}
+
+	for (i = 0; i < nhwqs; i++) {
+		spin_lock_irqsave(nvme_q[i].q_lock, flags);
+		spin_lock(&nvme_q[i].l_lock);
+		list_for_each_entry_safe(evt, pos, &nvme_q[i].sent, queue_list)
+			ibmvfc_fail_request(evt, error_code);
+		list_splice_init(&nvme_q[i].sent, &vhost->purge);
+		spin_unlock(&nvme_q[i].l_lock);
+		spin_unlock_irqrestore(nvme_q[i].q_lock, flags);
 	}
 }
 
@@ -1818,7 +1843,9 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
 		dev_err(vhost->dev, "Send error (rc=%d)\n", rc);
 		if (evt->cmnd) {
 			evt->cmnd->result = DID_ERROR << 16;
-			evt->done = ibmvfc_scsi_eh_done;
+			evt->done = ibmvfc_vfc_eh_done;
+		} else if (evt->fcp_req || evt->ls_req) {
+			evt->done = ibmvfc_vfc_eh_done;
 		} else {
 			evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_CRQ_ERROR);
 			evt->done = evt->_done;
-- 
2.55.0

