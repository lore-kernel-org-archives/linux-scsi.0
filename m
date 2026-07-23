Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD8965192;
	Thu, 23 Jul 2026 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764937; cv=none; b=BBcwPpzvOZ+q+c8fWRJRvMzzz6WsUXra++ebcPho8I3Z2RIS0kUxyKF+Mhoohn6wEJXTYdsEvu2M9P+aVM3dMgBapJkn4J4kLsXmwoBVAMs27qx5Pf2UgkTHshuaO+9dzsyiEq8hlkBZDcXNMcEz5s3zcQjbKORfObsgofleHyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764937; c=relaxed/simple;
	bh=wH52HurCCEyEpCTpml3yT69cz0+PwY3haXx363vKcIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukXWdGFGZ+vLL0PwkgxIYHgT11ih6qoQWvWhBBgntPVm6wOhT/xNuhvl97PfeQh7vhNz0zwW+Y2B14kiNbriNHTngfMJWqa3JQ9FSwocrVGaUdl3jha+W7B0JYZfoX3oYuOd9+ESxjRkS45g/N/F6G5QsT/jA1f0VdtaBO/PIH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=K6rOuwMF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="K6rOuwMF"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBwLk705318;
	Thu, 23 Jul 2026 00:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=RR5jRZ40pgCx7orHG
	IjgvXuGQmSuE9vcqGnLzyWm4eM=; b=K6rOuwMFpYSnTE9t6GNbo8ayZr7lBqfPr
	CACSmsGf7mHvQoxatGlgXJw2wlO0a1UzosZsG8Ma9RjmlchuAOEc64vYv5FAYeKY
	4Yxgr1rYZOc/6qMRew7czx94fqjHWlOYBee+7Lr7KpdS6RmMv21tf/eayDfRggOi
	CQ/FwqteDqDhRIazug3rbU5NNRKeAewSpdafIDAF/nNO77uwBYumqn56ZuFDbaNy
	0KzhyDz06xzfdSP4lSXN6W1kVI+PdxwyYIJabLlo4cdI9wrjgFRMUWrcMhGcaU9f
	ImGvertyGqEmC1iTUWtzY4S+QPChSNH8nt3e29uXRFj6EqZk+RvXQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abmymu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:01:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNncJn028176;
	Thu, 23 Jul 2026 00:01:58 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgnah9q28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:01:58 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N01vM45374508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:01:57 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4682858060;
	Thu, 23 Jul 2026 00:01:57 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A487658063;
	Thu, 23 Jul 2026 00:01:56 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:01:56 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 05/33] ibmvfc: move target list from host to protocol specific channel groups
Date: Wed, 22 Jul 2026 17:01:21 -0700
Message-ID: <20260723000149.969416-6-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX96BqVQ+uIBJw
 cdQGzAQZvsdUo9MhJq6LJqDaAUDIwdrWAAINGEMd2L8H80oZ3CnzbtSf10DW7VjRwaIYw7YajMp
 icFM0zZY9zwJ7FdaCmlvdXaQTCMoW7lTiBPvnEogy99BUGl22ZgJQG5Ds3LM1Wi9h9SgwxV6yp2
 7krsElkL3Gpns89/jtuOxlsGzijkhdIwlobXH9+/+qzuTLC+F12A6M9oAeouhGmXcmuyvPuqTa6
 LqGm/jnEBZlcw3RJt//p4QzNH9M6+1+j9xop/zIsEzOPFJM8lgKwU0wrpIO9COFPan/7bRju16e
 84cTfghLEjVN4bPnBUUIvl21/OnyK9FMEGQowoA8leKYhN/zrg0pdtTYu8X6xcv1pBNVDCBmj4K
 H43ud8fxqKC2x1si/SSkh/Tu94VAz3o4airUy+3BX76+ZyoCVJlSPUQLMqVWdo4/3Uq+Rq6yJIW
 F/TpY9eaQNhvgZotNjA==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a6159f7 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=jQP8Ix9JCXI5f8BnMGsA:9
X-Proofpoint-ORIG-GUID: 46UsOOT-52-sI5she-8l_vqdUisWHvXh
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfXxqFSf2NWovRY
 RmWF9BNMCPxY+LHt5HxSkdVbe5caubnhKs3dGLMPx39QB9Oz7WEQmgUfjW/FXbpvbj+YrjBofD4
 YEGxH+S8tqdnhI6UbOPVxArOeCnD/I0=
X-Proofpoint-GUID: 46UsOOT-52-sI5she-8l_vqdUisWHvXh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

Prepare the driver for protocol-specific target management by moving
the target list and target count out of struct ibmvfc_host and into
struct ibmvfc_channels.

Today the driver only maintains a single SCSI target list, but NVMe/FC
support will require separate target tracking for each protocol-specific
channel group. Update the existing target iteration, allocation, and
discovery paths to use the SCSI channel group's target list instead of a
host-wide list.

This is a preparatory refactoring only. No functional change is intended
for existing SCSI operation.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 52 +++++++++++++++++-----------------
 drivers/scsi/ibmvscsi/ibmvfc.h |  4 +--
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 412e946abcb7..78b4ac201a49 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -682,7 +682,7 @@ static void ibmvfc_link_down(struct ibmvfc_host *vhost,
 
 	ENTER;
 	scsi_block_requests(vhost->host);
-	list_for_each_entry(tgt, &vhost->targets, queue)
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 		ibmvfc_del_tgt(tgt);
 	ibmvfc_set_host_state(vhost, state);
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_DEL);
@@ -715,7 +715,7 @@ static void ibmvfc_init_host(struct ibmvfc_host *vhost)
 		memset(vhost->async_crq.msgs.async, 0, PAGE_SIZE);
 		vhost->async_crq.cur = 0;
 
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (vhost->client_migrated)
 				tgt->need_login = 1;
 			else
@@ -1232,7 +1232,7 @@ static struct ibmvfc_target *__ibmvfc_get_target(struct scsi_target *starget)
 	struct ibmvfc_host *vhost = shost_priv(shost);
 	struct ibmvfc_target *tgt;
 
-	list_for_each_entry(tgt, &vhost->targets, queue)
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 		if (tgt->target_id == starget->id) {
 			kref_get(&tgt->kref);
 			return tgt;
@@ -1834,7 +1834,7 @@ static void ibmvfc_relogin(struct scsi_device *sdev)
 	unsigned long flags;
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (rport == tgt->rport) {
 			ibmvfc_del_tgt(tgt);
 			break;
@@ -2132,7 +2132,7 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
 
 	ENTER;
 	spin_lock_irqsave(vhost->host->host_lock, flags);
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->scsi_id == port_id) {
 			issue_login = 0;
 			break;
@@ -3104,7 +3104,7 @@ static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	found = 0;
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->scsi_id == rport->port_id) {
 			found++;
 			break;
@@ -3244,7 +3244,7 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 	case IBMVFC_AE_ELS_LOGO:
 	case IBMVFC_AE_ELS_PRLO:
 	case IBMVFC_AE_ELS_PLOGI:
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
 				break;
 			if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) != crq->scsi_id)
@@ -4873,14 +4873,14 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 
 	/* Look to see if we already have a target allocated for this SCSI ID or WWPN */
 	spin_lock_irqsave(vhost->host->host_lock, flags);
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->wwpn == wwpn) {
 			wtgt = tgt;
 			break;
 		}
 	}
 
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->scsi_id == scsi_id) {
 			stgt = tgt;
 			break;
@@ -4937,7 +4937,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 	ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	tgt->cancel_key = vhost->task_set++;
-	list_add_tail(&tgt->queue, &vhost->targets);
+	list_add_tail(&tgt->queue, &vhost->scsi_scrqs.targets);
 
 unlock_out:
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
@@ -4955,7 +4955,7 @@ static int ibmvfc_alloc_targets(struct ibmvfc_host *vhost)
 {
 	int i, rc;
 
-	for (i = 0, rc = 0; !rc && i < vhost->num_targets; i++)
+	for (i = 0, rc = 0; !rc && i < vhost->scsi_scrqs.num_targets; i++)
 		rc = ibmvfc_alloc_target(vhost, &vhost->scsi_scrqs.disc_buf[i]);
 
 	return rc;
@@ -4976,8 +4976,8 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
 		ibmvfc_dbg(vhost, "Discover Targets succeeded\n");
-		vhost->num_targets = min_t(u32, be32_to_cpu(rsp->num_written),
-					   max_targets);
+		vhost->scsi_scrqs.num_targets = min_t(u32, be32_to_cpu(rsp->num_written),
+						      max_targets);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
 		break;
 	case IBMVFC_MAD_FAILED:
@@ -5393,7 +5393,7 @@ static int ibmvfc_dev_init_to_do(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_target *tgt;
 
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->action == IBMVFC_TGT_ACTION_INIT ||
 		    tgt->action == IBMVFC_TGT_ACTION_INIT_WAIT)
 			return 1;
@@ -5413,7 +5413,7 @@ static int ibmvfc_dev_logo_to_do(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_target *tgt;
 
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT ||
 		    tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT)
 			return 1;
@@ -5443,10 +5443,10 @@ static int __ibmvfc_work_to_do(struct ibmvfc_host *vhost)
 	case IBMVFC_HOST_ACTION_QUERY_TGTS:
 		if (vhost->discovery_threads == disc_threads)
 			return 0;
-		list_for_each_entry(tgt, &vhost->targets, queue)
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			if (tgt->action == IBMVFC_TGT_ACTION_INIT)
 				return 1;
-		list_for_each_entry(tgt, &vhost->targets, queue)
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			if (tgt->action == IBMVFC_TGT_ACTION_INIT_WAIT)
 				return 0;
 		return 1;
@@ -5454,10 +5454,10 @@ static int __ibmvfc_work_to_do(struct ibmvfc_host *vhost)
 	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
 		if (vhost->discovery_threads == disc_threads)
 			return 0;
-		list_for_each_entry(tgt, &vhost->targets, queue)
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT)
 				return 1;
-		list_for_each_entry(tgt, &vhost->targets, queue)
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT)
 				return 0;
 		return 1;
@@ -5645,12 +5645,12 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 			vhost->job_step(vhost);
 		break;
 	case IBMVFC_HOST_ACTION_QUERY:
-		list_for_each_entry(tgt, &vhost->targets, queue)
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			ibmvfc_init_tgt(tgt, ibmvfc_tgt_query_target);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY_TGTS);
 		break;
 	case IBMVFC_HOST_ACTION_QUERY_TGTS:
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (tgt->action == IBMVFC_TGT_ACTION_INIT) {
 				tgt->job_step(tgt);
 				break;
@@ -5662,7 +5662,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		break;
 	case IBMVFC_HOST_ACTION_TGT_DEL:
 	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT) {
 				tgt->job_step(tgt);
 				break;
@@ -5674,7 +5674,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 			return;
 		}
 
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
 				tgt_dbg(tgt, "Deleting rport\n");
 				rport = tgt->rport;
@@ -5749,7 +5749,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		spin_lock_irqsave(vhost->host->host_lock, flags);
 		break;
 	case IBMVFC_HOST_ACTION_TGT_INIT:
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (tgt->action == IBMVFC_TGT_ACTION_INIT) {
 				tgt->job_step(tgt);
 				break;
@@ -6286,7 +6286,7 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 		if (vhost->state != IBMVFC_ACTIVE)
 			break;
 
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (tgt->add_rport) {
 				did_work = 1;
 				tgt->add_rport = 0;
@@ -6351,7 +6351,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	shost->nr_hw_queues = mq_enabled ? min(max_scsi_queues, nr_scsi_hw_queues) : 1;
 
 	vhost = shost_priv(shost);
-	INIT_LIST_HEAD(&vhost->targets);
+	INIT_LIST_HEAD(&vhost->scsi_scrqs.targets);
 	INIT_LIST_HEAD(&vhost->purge);
 	sprintf(vhost->name, IBMVFC_NAME);
 	vhost->host = shost;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index c73ed2314ad0..0e259e9d2e9b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -828,6 +828,8 @@ struct ibmvfc_channels {
 	unsigned int active_queues;
 	unsigned int desired_queues;
 	unsigned int max_queues;
+	int num_targets;
+	struct list_head targets;
 	int disc_buf_sz;
 	struct ibmvfc_discover_targets_entry *disc_buf;
 	dma_addr_t disc_buf_dma;
@@ -871,8 +873,6 @@ struct ibmvfc_host {
 #define IBMVFC_TRACE_SIZE	(sizeof(struct ibmvfc_trace_entry) * IBMVFC_NUM_TRACE_ENTRIES)
 	struct ibmvfc_trace_entry *trace;
 	atomic_t trace_index;
-	int num_targets;
-	struct list_head targets;
 	struct list_head purge;
 	struct device *dev;
 	struct dma_pool *sg_pool;
-- 
2.55.0

