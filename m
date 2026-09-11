Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC253A48CA;
	Fri, 11 Sep 2026 05:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789105737; cv=none; b=IHTaTQWnBFDnTUKlnLCesY7s/InBhqFL/GNdmKMAYqMB1L+Azh5fHWf+0cwp5SYdT1YhL8Fo9CE8kuD1erhKaHh+Y5A2mF84bnSxBmnWR+mzQi/wLnG3aSNg6NPF3Nr/2uMkPO8zJWE6Fz6wi1z8/MfuRbnEc1fQgIdoAC5Oha8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789105737; c=relaxed/simple;
	bh=xa9ZFwSNLxpXxPfcW5YLy9ilvFwH6Udy56FUeciO6zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFObSdzWc7E8Mfs7gYJTpo+gLGsA7s0zwd4tJ14oOZamJpeFVdmt24hrwcwBNPhEwexMacG7qM9tFBdht148S4KO1YGLHg2cwicdxyUw58q8UxcfqSWpZKClnEfbOkaqAmyP93nwNIxfg9ZWppnKcjBz9Psq6ea+xJyWeNngu9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AGGCooqx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AGGCooqx"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B4VQk1783552;
	Fri, 11 Sep 2026 05:48:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=S4D4zSL5CZaLxX1fb
	liTHpLx9ksNqGwiA3jn2bfOHNM=; b=AGGCooqx9lbaoRVP+Ot1Km58k/vDH0n1G
	xfOG0JW97MBMzXpQo/6DtT8eWpi8cBW/q4OfBa+7zdl3oY6MLDU3s7admAkLVjrV
	QhZbIrKtGefbvjEsjiKxhT7cwU3bjH1q8gXnVia8f4i4eAkoeq6u/spBvOyj1Q8H
	Y1wnTCdaESIMlc7SE3+qlEGrgci0wAlHY8GKCugxKll7vBMJcK8T3IqVlbUzEc0c
	t3u1z9VLOtQqr4iGqtps7T2sLlqX0e+SA3l632FCaqewD6dcrGVuD9BNr8TJ/2Vu
	DO8MhagDlwNoQcERhcQ1/O+feS/9DlIppDJsbvny+vDIXq73EOyZg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8psjw1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 05:48:44 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B4K3Du1056110;
	Fri, 11 Sep 2026 05:48:43 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvvrchr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 05:48:43 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B5mg8f17826538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 05:48:42 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9BBEF58051;
	Fri, 11 Sep 2026 05:48:42 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 078295805A;
	Fri, 11 Sep 2026 05:48:42 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 05:48:41 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v10 8/9] scsi: ibmvfc: register and use asynchronous sub CRQ for events
Date: Thu, 10 Sep 2026 22:48:31 -0700
Message-ID: <20260911054832.1311668-9-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911054832.1311668-1-tyreld@linux.ibm.com>
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=eM2GH3p1 c=1 sm=1 tr=0 ts=6aa3963c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=EqnsHTcO9pxfbuvt6BcA:9
X-Proofpoint-ORIG-GUID: TCx2wwys1-aXwVct8NF8x8xA8Y2oMxw8
X-Proofpoint-GUID: TCx2wwys1-aXwVct8NF8x8xA8Y2oMxw8
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDA3NCBTYWx0ZWRfX5fljWYFg3pIs
 DgJttsC5yMnOn/aUtaPwg+NAlpJdFBvY/HODt+4JWBsvnP8q4tTANHntxRUZNaCFkdnJzpGsydF
 jPlHQtyCfF/M2wq6UKcRYXNIS1XsZjs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDA3NCBTYWx0ZWRfXzNsD41Bz2klJ
 pcH2KkMrMpund+/03cp0+HLb2NQTATuhggBeNkpxJNgniW2bDYT1InA0zKowTcc2+i7orlnpwqu
 sQYsz2VQbY7whDzSSK8VgErMSK6cGCzCQmawaoaQPdpqzxd9O7FLYD2vYDpOAbEfpYLi5QbcO7o
 n34o8t1FAYDVYyt6TH5UTDGLx9rdKPbOecP3lCXKIrAtQ/Gb8lrqNS5Zzf3QivSjQwwK8m6v7BB
 nzSJOBqU44mYUZrOH4CoBt/aCPtPYpYFq8yhqpRFDMAamuuT2c24LQ2WngkGTssnjrans3s9VQf
 N/zx5+EBY8piwgccFYMNcGliINoQBulpzGlMPHmjQzH+hYTikta+GzrTAiwliBU+QajxJqF18lk
 TEGlrUrcZ9nbggrtJFIBUznf5833a0acuT4igX55nsFV23jBJmg9zOjbvZMf9t34Pegaqn7OnMo
 XLZxRx7kNiMYwPvDJHw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110074

From: Dave Marquardt <davemarq@linux.ibm.com>

Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
registered, and freed alongside the SCSI channel queues.

In ibmvfc_init_sub_crqs(), allocate the async sub-CRQ queue buffer via
ibmvfc_alloc_queue() before allocating the SCSI channels. Register it
with the VIOS by calling ibmvfc_register_channel() with index -1 (the
negative-index sentinel introduced in the previous commit). Either
failure disables multi-queue and aborts init.

In ibmvfc_release_sub_crqs(), ibmvfc_reenable_crq_queue(), and
ibmvfc_reset_crq(), deregister and re-register the async sub-CRQ
alongside the SCSI channel queues.

In ibmvfc_channel_setup_done(), capture the async sub-CRQ handle
returned by the VIOS in the channel setup response and store it in
vhost->async_sub_crq.vios_cookie.

In ibmvfc_set_login_info(), advertise IBMVFC_USE_ASYNC_SUBQ,
IBMVFC_CAN_HANDLE_FPIN, and IBMVFC_YES_SCSI capabilities whenever
multi-queue channels are enabled. IBMVFC_YES_SCSI was previously only
set for NVMe-enabled configurations; move it to the common multi-queue
path so it is always advertised when channels are in use.

Fix a variable-shadowing bug in ibmvfc_register_channel() where the
irq_failed cleanup loop reused rc for the H_FREE_SUB_CRQ hcall result,
clobbering the error code returned to the caller. Introduce hcall_rc
for the cleanup loop instead.

Guard the memset() in ibmvfc_deregister_channel() behind a check of
scrq->msgs.handle to prevent a NULL dereference when the function is
called on a queue that was never allocated, such as async_sub_crq when
multi-queue is disabled or initialization failed before
ibmvfc_alloc_queue() was reached.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 51 +++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index c78e221f182a..70a3046135c7 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -192,6 +192,8 @@ static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
 
 static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
 static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
+static void ibmvfc_deregister_channel(struct ibmvfc_host *, struct ibmvfc_channels *, int);
+static int ibmvfc_register_channel(struct ibmvfc_host *, struct ibmvfc_channels *, int);
 
 static const char *unknown_error = "unknown error";
 
@@ -964,6 +966,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	unsigned long flags;
 
+	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -986,6 +989,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
+	ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -1006,6 +1010,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;
 
+	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -1042,6 +1047,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
+	ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -1584,9 +1590,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 
 	if (vhost->mq_enabled || vhost->using_channels) {
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
+		login_info->capabilities |= cpu_to_be64(IBMVFC_USE_ASYNC_SUBQ);
+		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_HANDLE_FPIN);
+		login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
 		if (vhost->nvme_enabled) {
 			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_NVMEOF);
-			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
 			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
 		}
 	}
@@ -5811,6 +5819,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		for (i = 0; i < nvme->active_queues; i++)
 			nvme->scrqs[i].vios_cookie =
 				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
+		vhost->async_sub_crq.vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
 
 		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
 			   scsi->active_queues);
@@ -5870,6 +5879,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 		for (i = 0; i < nvme_channels; i++)
 			setup_buf->channel_handles[scsi_channels + i] =
 				cpu_to_be64(nvme->scrqs[i].cookie);
+		setup_buf->async_sub_crq_handle = cpu_to_be64(vhost->async_sub_crq.cookie);
 	}
 
 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
@@ -6834,6 +6844,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	bool is_async = index < 0;
 	struct ibmvfc_queue *scrq = !is_async ? &channels->scrqs[index] : &vhost->async_sub_crq;
 	int rc = -ENOMEM;
+	int hcall_rc;
 
 	ENTER;
 
@@ -6902,8 +6913,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 irq_failed:
 	do {
-		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
-	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
+		hcall_rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
+	} while (hcall_rc == H_BUSY || H_IS_LONG_BUSY(hcall_rc));
 reg_failed:
 	LEAVE;
 	return rc;
@@ -6953,8 +6964,10 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 	}
 
 	/* Clean out the queue */
-	memset(scrq->msgs.crq, 0, PAGE_SIZE);
-	scrq->cur = 0;
+	if (scrq->msgs.handle) {
+		memset(scrq->msgs.crq, 0, PAGE_SIZE);
+		scrq->cur = 0;
+	}
 
 	LEAVE;
 }
@@ -6971,7 +6984,9 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 	for (i = 0; i < channels->max_queues; i++) {
 		if (ibmvfc_register_channel(vhost, channels, i)) {
 			for (j = i; j > 0; j--)
-				ibmvfc_deregister_channel(vhost, channels, j - 1);
+				ibmvfc_deregister_channel(
+					vhost, channels, j - 1);
+
 			vhost->do_enquiry = 0;
 			return;
 		}
@@ -7026,16 +7041,26 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 
 static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 {
+	int rc = 0;
+
 	ENTER;
 	if (!vhost->mq_enabled)
 		return;
 
-	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs)) {
+	rc = ibmvfc_alloc_queue(vhost, &vhost->async_sub_crq, IBMVFC_SUB_CRQ_FMT);
+	if (rc) {
 		vhost->do_enquiry = 0;
 		vhost->mq_enabled = 0;
 		return;
 	}
 
+	/* register async_sub_crq channel */
+	if (ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1))
+		goto free_async_sub_crq;
+
+	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
+		goto deregister_async_sub_crq;
+
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
 	if (vhost->nvme_enabled) {
@@ -7046,6 +7071,15 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 	}
 
 	LEAVE;
+	return;
+
+ deregister_async_sub_crq:
+	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
+free_async_sub_crq:
+	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
+	vhost->do_enquiry = 0;
+	vhost->mq_enabled = 0;
+	return;
 }
 
 static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
@@ -7069,6 +7103,9 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
 {
 	ENTER;
+	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
+	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
+
 	if (!vhost->scsi_scrqs.scrqs)
 		return;
 
-- 
2.55.0

