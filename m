Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3091B3CBE69;
	Fri, 11 Sep 2026 02:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789092518; cv=none; b=KzCUJN4W2GmxE3b5+AUVZLKhkgSF9EE2U9F/N8SPa00Kj9icVZApY3ujoCNNwZOTh1B8dZjAYt3TuFWjLBUntZlNlj1d2wHeYoOPw8CDSY/TArvHbqFdg3K0a4yxXQ7QiayMYNiSz9HKaQq3fsMa09jweQT5eKm9zZ57gxEHCFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789092518; c=relaxed/simple;
	bh=cFDOesyRchtjzbqWb+xagE27fGimkXLcpYe25pfgCRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9arBjHhNtfM2TKed8MJj7nVw6Guk+322YRla6icHNuuFMM5Q1Lfro33zXid6Wub8JfAfo+wx35TlbokovX11/i6nIYgn96/gYdUStPx43QUddSjvRotFvUAsD2XKC8wc+iDZ1CZAyFFZ0Mc/xuxHr/YFxGTk1KfU7oYZJFU33I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bUzP4jA1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bUzP4jA1"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12ND1348194;
	Fri, 11 Sep 2026 02:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+RjGiJXMaV03MYIAU
	TMYzocFImR+wbC3aWqVmlWRwo4=; b=bUzP4jA1SAa1VnUDm9Mda/UM9KVLRWyUO
	W3RpTmFTVcRkxv5fRnHRAvTKwOmTPpNVyAmjMszTp9RzaxUKEE6oP3sbT4xs8Ryh
	tdv9CgN552P/AkpGmCEJGiFp9PAPed9g9VMg5+njRxSzK+dVqEPILq5baXtDMyPy
	Z8fiXYWHrDwWVl/WJbPQspFEfUSbELb5hzBT6yMunrILJ+WAeEeQajbxAzY90Hxi
	j3ZPgNVevSbh7WalyGU1pv09uG0lXHmX2J6Ns1ikpk0TwRrJFcOcXgX8F04rnqg6
	vaIRXU4AXQ48OxvHw6sdMGKczcGMdbLTUxnVirFprEC/M+4e+XiwA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8t0p5r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:25 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B158l0872144;
	Fri, 11 Sep 2026 02:08:25 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvwk3t33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:25 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B28NIv58720636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:08:24 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2CC758052;
	Fri, 11 Sep 2026 02:08:23 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 313C15805A;
	Fri, 11 Sep 2026 02:08:23 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:08:23 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v9 8/9] scsi: ibmvfc: register and use asynchronous sub CRQ for events
Date: Thu, 10 Sep 2026 19:08:14 -0700
Message-ID: <20260911020817.1033789-8-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX24xc+XLQ+BjB
 FOOvCYkIcfAHVVHU08gw8IEkJv8W+NCxATjH3AZq/hWEwOFNjhP8b3Zk9oHZ75QjxyE4TUWHLsM
 O0hsEp2/h0JZHan9wKHHXfKFgSoEFPA=
X-Proofpoint-ORIG-GUID: 0X86DSCnWwNq4WdfXva8XsXMTA8OMIr5
X-Proofpoint-GUID: 0X86DSCnWwNq4WdfXva8XsXMTA8OMIr5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX6WR0wWTLAEA2
 vxu4PwgKLsnNwaEUCheKmVM2gg43vtwkZfgmK2MHZn2GXU1GDlZ9r1k9dLI3ozvthZxM3+eahXG
 /OypIej2ZJ3AhgK6HfTmUoZB77oae7VE3GS1fvwKoIZ/zw5S/MnvIArAEaYfcx0J6eFUjQOgKHG
 hxY6MT5lugXNe7LZhy4xFfcKdyd7asYKVmIZxkJ75tO/GL4470EQ64SUiPrOCBLsNJdnyvJl9NB
 blJ0MCpFSkpjHvBYD4EOD2qyXjR5paCq30HjXQ9u6bBtfTdptL+fLRIR5LAsomZw24/GUOPIlLo
 GtTWAgwbfrPZtgtOCYOQtUJHTeSSUnNbbfe0hKLvGE7sz6W8xZ5xK6vhU3xqJntVVUpUBAXD9xe
 tfl7TIzPKRwe0cHw3QfKeSw9ozxACnZyxCYnowq34pbSh7jHGamo9dFZCtV+CQ4tejYz0N74Bot
 gdQzdqgh6v+Q2L/EsfQ==
X-Authority-Analysis: v=2.4 cv=PIGaavqC c=1 sm=1 tr=0 ts=6aa36299 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=EqnsHTcO9pxfbuvt6BcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110024

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
index 8eeb125ee13b..6eb299989724 100644
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
@@ -5812,6 +5820,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		for (i = 0; i < nvme->active_queues; i++)
 			nvme->scrqs[i].vios_cookie =
 				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
+		vhost->async_sub_crq.vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
 
 		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
 			   scsi->active_queues);
@@ -5871,6 +5880,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 		for (i = 0; i < nvme_channels; i++)
 			setup_buf->channel_handles[scsi_channels + i] =
 				cpu_to_be64(nvme->scrqs[i].cookie);
+		setup_buf->async_sub_crq_handle = cpu_to_be64(vhost->async_sub_crq.cookie);
 	}
 
 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
@@ -6835,6 +6845,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	bool is_async = index < 0;
 	struct ibmvfc_queue *scrq = !is_async ? &channels->scrqs[index] : &vhost->async_sub_crq;
 	int rc = -ENOMEM;
+	int hcall_rc;
 
 	ENTER;
 
@@ -6903,8 +6914,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 irq_failed:
 	do {
-		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
-	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
+		hcall_rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
+	} while (hcall_rc == H_BUSY || H_IS_LONG_BUSY(hcall_rc));
 reg_failed:
 	LEAVE;
 	return rc;
@@ -6954,8 +6965,10 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
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
@@ -6972,7 +6985,9 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
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
@@ -7027,16 +7042,26 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 
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
@@ -7047,6 +7072,15 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
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
@@ -7070,6 +7104,9 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
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

