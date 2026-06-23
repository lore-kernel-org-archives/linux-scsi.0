Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC052364059;
	Tue, 23 Jun 2026 01:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178251; cv=none; b=Zjly8Vbn6/5p2/jwoBT5fIAhoi9woOHP2EeMoafceZZ6j995alhpSPRmIPcZ8lgfZxkpWKlVRnR4tMnMHNaxozyLK9oYMBc3WHLCcGXtTudsZf/0duO3y3Ycv/w5sQKKp4PSA9q6RswDganqlx/+kNywaOtkSw9y0b+F+BgtRtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178251; c=relaxed/simple;
	bh=cWvA2k9yjRe+unMj3m5DeGnDXdPBjMi6EVn0VJkgS4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu4fQwhSTcINkEJ2RP4PaCgr3edaBsAXha+xua2QUyHHo2YYTmiy0YZwSME6RnixpiRjOucCh2X855ssBO3dqF07UfOqwyoZVogo4AVb77AHqIPLvCM/sBHSRWDhy989t1ENc7t5oVLV63yWsM9XzaER1h5kPsO0KEJchAvpXk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PudmEtl/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PudmEtl/"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mSSN408386;
	Tue, 23 Jun 2026 01:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=sj+kJ714nNZQRSv1E
	MltSRexsmQgoVpXs9691SA5Spo=; b=PudmEtl/EUJob0leVPAGe1UPx0D3z2ZQI
	yHyoFNSsfBf6LmTEo8oPLiBuR+LZWHnWNxsdK4cvoOJEDu0ppdsNHifXxLg9KyxI
	CTQh6m7RWEWO1LO2T2CDmildyEEqQFScprCxxU3iiEapgmtFZv/y28VJ4ybvLNB7
	jThovD5FiwcaO5gnOnkwWAg5Esx57HIRd73EQeQcM+x9qERWEq8n8KZnRo8SM39d
	v5/U5QONjt10Z4m4fGIjVEqS13xCyvgci5HFE3Z2zJ6mtb7owypUKLhtLIGB4BNk
	JVi6q08C5QntKxOOnNMYtVZMuQj4aysAZBxN2YLpt+1dGRd9JGc1Q==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjc3c4qj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:41 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1JlRZ002081;
	Tue, 23 Jun 2026 01:30:40 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex56q95kp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:40 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1Uddp31130340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:39 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E08DF5805A;
	Tue, 23 Jun 2026 01:30:38 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5182D58056;
	Tue, 23 Jun 2026 01:30:38 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:38 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 01/29] ibmvfc: move target list from host to protocol specific channel groups
Date: Mon, 22 Jun 2026 18:30:07 -0700
Message-ID: <20260623013035.3436640-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623013035.3436640-1-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=X4Ni7mTe c=1 sm=1 tr=0 ts=6a39e1c1 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=jQP8Ix9JCXI5f8BnMGsA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX0vZI+ORt53dP
 weSvfqmdR/efbKUQ5v5K/E0qssT94aFbHSAheNMG5Rx0xzoVTfDOjsn1lLZmjOF638BVokzgMz7
 nBeKWJztngdnQakXL7rbkNzijc0mpXs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX2/S+BSUYHBiZ
 FLPQu/z1ycP+bJwjkrHp0q/pUDgDHLDFOsEXBz+t0AMDvPYPY9+DMfjaH/MImr/TaycZnJQZg8A
 XsqD+D7vzLUg9xnHMkEzrFyeHSpuplu8591FdPs4N2coLHuZTUCE0PV5txi1TTL7RBJ0ElCw/jJ
 pZwRgSVqaVWPCMCdWAOGBCV1iwjJyRGFOvD2WB/cAbNjEKYcOQKtXHu5YQ1OGVtNM5owdU4lFpW
 ZLIuPygr8waB13HtJPFxPfIfGVMzzVmlOgsM5GsnuYdxn/CExeZ2w0astGslDRKs7DnHCI/avuL
 DXQ2bNE/bXIEV15uD1g+m1kIbB7s69sn0QH1fqQOtsaM6UTOmG2p6qX+zGBiqcP8TuDGmRDCdmE
 ZD9o9ca1ywVjDajrZNae7JfDML4C3Iw4uzVY75CI5+exoteXFDqktcmVBfozpYZcmI2WThk0uxC
 lAiWk5Nzsr5xSGCUMvw==
X-Proofpoint-ORIG-GUID: IeMtDDTIc6UJVMkxsARYQVLJ691oEuqg
X-Proofpoint-GUID: IeMtDDTIc6UJVMkxsARYQVLJ691oEuqg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

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
index 3dd2adda195e..912901436442 100644
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
@@ -1832,7 +1832,7 @@ static void ibmvfc_relogin(struct scsi_device *sdev)
 	unsigned long flags;
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (rport == tgt->rport) {
 			ibmvfc_del_tgt(tgt);
 			break;
@@ -2130,7 +2130,7 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
 
 	ENTER;
 	spin_lock_irqsave(vhost->host->host_lock, flags);
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->scsi_id == port_id) {
 			issue_login = 0;
 			break;
@@ -3102,7 +3102,7 @@ static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	found = 0;
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->scsi_id == rport->port_id) {
 			found++;
 			break;
@@ -3242,7 +3242,7 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 	case IBMVFC_AE_ELS_LOGO:
 	case IBMVFC_AE_ELS_PRLO:
 	case IBMVFC_AE_ELS_PLOGI:
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
 				break;
 			if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) != crq->scsi_id)
@@ -4863,14 +4863,14 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 
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
@@ -4927,7 +4927,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 	ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	tgt->cancel_key = vhost->task_set++;
-	list_add_tail(&tgt->queue, &vhost->targets);
+	list_add_tail(&tgt->queue, &vhost->scsi_scrqs.targets);
 
 unlock_out:
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
@@ -4945,7 +4945,7 @@ static int ibmvfc_alloc_targets(struct ibmvfc_host *vhost)
 {
 	int i, rc;
 
-	for (i = 0, rc = 0; !rc && i < vhost->num_targets; i++)
+	for (i = 0, rc = 0; !rc && i < vhost->scsi_scrqs.num_targets; i++)
 		rc = ibmvfc_alloc_target(vhost, &vhost->scsi_scrqs.disc_buf[i]);
 
 	return rc;
@@ -4966,8 +4966,8 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
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
@@ -5383,7 +5383,7 @@ static int ibmvfc_dev_init_to_do(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_target *tgt;
 
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->action == IBMVFC_TGT_ACTION_INIT ||
 		    tgt->action == IBMVFC_TGT_ACTION_INIT_WAIT)
 			return 1;
@@ -5403,7 +5403,7 @@ static int ibmvfc_dev_logo_to_do(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_target *tgt;
 
-	list_for_each_entry(tgt, &vhost->targets, queue) {
+	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT ||
 		    tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT)
 			return 1;
@@ -5433,10 +5433,10 @@ static int __ibmvfc_work_to_do(struct ibmvfc_host *vhost)
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
@@ -5444,10 +5444,10 @@ static int __ibmvfc_work_to_do(struct ibmvfc_host *vhost)
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
@@ -5635,12 +5635,12 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
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
@@ -5652,7 +5652,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		break;
 	case IBMVFC_HOST_ACTION_TGT_DEL:
 	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT) {
 				tgt->job_step(tgt);
 				break;
@@ -5664,7 +5664,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 			return;
 		}
 
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
 				tgt_dbg(tgt, "Deleting rport\n");
 				rport = tgt->rport;
@@ -5739,7 +5739,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		spin_lock_irqsave(vhost->host->host_lock, flags);
 		break;
 	case IBMVFC_HOST_ACTION_TGT_INIT:
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (tgt->action == IBMVFC_TGT_ACTION_INIT) {
 				tgt->job_step(tgt);
 				break;
@@ -6276,7 +6276,7 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 		if (vhost->state != IBMVFC_ACTIVE)
 			break;
 
-		list_for_each_entry(tgt, &vhost->targets, queue) {
+		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 			if (tgt->add_rport) {
 				did_work = 1;
 				tgt->add_rport = 0;
@@ -6341,7 +6341,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
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
2.54.0

