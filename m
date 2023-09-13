Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2934EE0211
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 23:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbjIMXay (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 19:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbjIMXax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 19:30:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B2EE6
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 16:30:49 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DNJPp3029718;
        Wed, 13 Sep 2023 23:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LCqcOd6W7BRT3NhaCyOUHCifJBX+JddBnTaNOVFKIxo=;
 b=g/RKokVIEF6D8DXL09KXjlZZb58mN7tcmiK6iCQKLyhJYR8fE9+y8LTprqD7eTtizJif
 H1Cg8rR1ErbMKEU7H2DQFOrEL/xSghrYdFyZLXXviZ9d1k/vB/bCGyKpol4R8HrMGV3H
 FRasjsfeL0VbafyLystKNt28LgbuVh5k/0dzMoMD/gmLRcFzjeqh14fQjo6ASlXXzsZd
 lyk1GtCD/O37ACgWHKbjSSaEjqvsuml1LYwiD8ZgfipdFjAgWOdrw8SDZ2LipD0+k+j6
 bOjynXvJyEPmEyXBjGD1dAxi0nXqiR1I6vd8cTCAce23p2R5XmoFuLM693MBgJ3656bI xQ== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3kfgcn20-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:30:47 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DKgcXJ022941;
        Wed, 13 Sep 2023 23:05:01 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t141nxm0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:05:01 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DN50lp35455612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 23:05:00 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2394058053;
        Wed, 13 Sep 2023 23:05:00 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A88E658043;
        Wed, 13 Sep 2023 23:04:59 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 23:04:59 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 01/11] ibmvfc: remove BUG_ON in the case of an empty event pool
Date:   Wed, 13 Sep 2023 18:04:47 -0500
Message-Id: <20230913230457.2575849-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230913230457.2575849-1-tyreld@linux.ibm.com>
References: <20230913230457.2575849-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Sa2SImVmbSiElQ_sWBnHOpmP6DyXpeq8
X-Proofpoint-ORIG-GUID: Sa2SImVmbSiElQ_sWBnHOpmP6DyXpeq8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_17,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309130191
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In practice the driver should never send more commands than are
allocated to a queues event pool. In the unlikely event that this
happens the code asserts a BUG_ON, and in the case that the kernel is
not configured to crash on panic returns a junk event pointer from the
empty event list causing things to spiral from there. This BUG_ON is a
historical artifact of the ibmvfc driver first being upstreamed, and it
is well known now that the use of BUG_ON is bad practice except in the
most unrecoverable scenario. There is nothing about this scenario that
prevents the driver from recovering and carrying on.

Remove the BUG_ON in question from ibmvfc_get_event() and return a NULL
pointer in the case of an empty event pool. Update all call sites to
ibmvfc_get_event() to check for a NULL pointer and perfrom the
appropriate failure or recovery action.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 124 ++++++++++++++++++++++++++++++++-
 1 file changed, 122 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index ce9eb00e2ca0..10435ddddfe5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1519,7 +1519,11 @@ static struct ibmvfc_event *ibmvfc_get_event(struct ibmvfc_queue *queue)
 	unsigned long flags;
 
 	spin_lock_irqsave(&queue->l_lock, flags);
-	BUG_ON(list_empty(&queue->free));
+	if (list_empty(&queue->free)) {
+		ibmvfc_log(queue->vhost, 4, "empty event pool on queue:%ld\n", queue->hwq_id);
+		spin_unlock_irqrestore(&queue->l_lock, flags);
+		return NULL;
+	}
 	evt = list_entry(queue->free.next, struct ibmvfc_event, queue_list);
 	atomic_set(&evt->free, 0);
 	list_del(&evt->queue_list);
@@ -1948,9 +1952,15 @@ static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	if (vhost->using_channels) {
 		scsi_channel = hwq % vhost->scsi_scrqs.active_queues;
 		evt = ibmvfc_get_event(&vhost->scsi_scrqs.scrqs[scsi_channel]);
+		if (!evt)
+			return SCSI_MLQUEUE_HOST_BUSY;
+
 		evt->hwq = hwq % vhost->scsi_scrqs.active_queues;
-	} else
+	} else {
 		evt = ibmvfc_get_event(&vhost->crq);
+		if (!evt)
+			return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	ibmvfc_init_event(evt, ibmvfc_scsi_done, IBMVFC_CMD_FORMAT);
 	evt->cmnd = cmnd;
@@ -2038,6 +2048,11 @@ static int ibmvfc_bsg_timeout(struct bsg_job *job)
 
 	vhost->aborting_passthru = 1;
 	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt) {
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		return -ENOMEM;
+	}
+
 	ibmvfc_init_event(evt, ibmvfc_bsg_timeout_done, IBMVFC_MAD_FORMAT);
 
 	tmf = &evt->iu.tmf;
@@ -2096,6 +2111,10 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
 		goto unlock_out;
 
 	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt) {
+		rc = -ENOMEM;
+		goto unlock_out;
+	}
 	ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_MAD_FORMAT);
 	plogi = &evt->iu.plogi;
 	memset(plogi, 0, sizeof(*plogi));
@@ -2214,6 +2233,11 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 	}
 
 	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt) {
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		rc = -ENOMEM;
+		goto out;
+	}
 	ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_MAD_FORMAT);
 	mad = &evt->iu.passthru;
 
@@ -2302,6 +2326,11 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 		else
 			evt = ibmvfc_get_event(&vhost->crq);
 
+		if (!evt) {
+			spin_unlock_irqrestore(vhost->host->host_lock, flags);
+			return -ENOMEM;
+		}
+
 		ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_CMD_FORMAT);
 		tmf = ibmvfc_init_vfc_cmd(evt, sdev);
 		iu = ibmvfc_get_fcp_iu(vhost, tmf);
@@ -2505,6 +2534,8 @@ static struct ibmvfc_event *ibmvfc_init_tmf(struct ibmvfc_queue *queue,
 	struct ibmvfc_tmf *tmf;
 
 	evt = ibmvfc_get_event(queue);
+	if (!evt)
+		return NULL;
 	ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_MAD_FORMAT);
 
 	tmf = &evt->iu.tmf;
@@ -2561,6 +2592,11 @@ static int ibmvfc_cancel_all_mq(struct scsi_device *sdev, int type)
 
 		if (found_evt && vhost->logged_in) {
 			evt = ibmvfc_init_tmf(&queues[i], sdev, type);
+			if (!evt) {
+				spin_unlock(queues[i].q_lock);
+				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				return -ENOMEM;
+			}
 			evt->sync_iu = &queues[i].cancel_rsp;
 			ibmvfc_send_event(evt, vhost, default_timeout);
 			list_add_tail(&evt->cancel, &cancelq);
@@ -2774,6 +2810,10 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 
 	if (vhost->state == IBMVFC_ACTIVE) {
 		evt = ibmvfc_get_event(&vhost->crq);
+		if (!evt) {
+			spin_unlock_irqrestore(vhost->host->host_lock, flags);
+			return -ENOMEM;
+		}
 		ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_CMD_FORMAT);
 		tmf = ibmvfc_init_vfc_cmd(evt, sdev);
 		iu = ibmvfc_get_fcp_iu(vhost, tmf);
@@ -4032,6 +4072,12 @@ static void ibmvfc_tgt_send_prli(struct ibmvfc_target *tgt)
 
 	kref_get(&tgt->kref);
 	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt) {
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		return;
+	}
 	vhost->discovery_threads++;
 	ibmvfc_init_event(evt, ibmvfc_tgt_prli_done, IBMVFC_MAD_FORMAT);
 	evt->tgt = tgt;
@@ -4139,6 +4185,12 @@ static void ibmvfc_tgt_send_plogi(struct ibmvfc_target *tgt)
 	kref_get(&tgt->kref);
 	tgt->logo_rcvd = 0;
 	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt) {
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		return;
+	}
 	vhost->discovery_threads++;
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
 	ibmvfc_init_event(evt, ibmvfc_tgt_plogi_done, IBMVFC_MAD_FORMAT);
@@ -4215,6 +4267,8 @@ static struct ibmvfc_event *__ibmvfc_tgt_get_implicit_logout_evt(struct ibmvfc_t
 
 	kref_get(&tgt->kref);
 	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt)
+		return NULL;
 	ibmvfc_init_event(evt, done, IBMVFC_MAD_FORMAT);
 	evt->tgt = tgt;
 	mad = &evt->iu.implicit_logout;
@@ -4242,6 +4296,13 @@ static void ibmvfc_tgt_implicit_logout(struct ibmvfc_target *tgt)
 	vhost->discovery_threads++;
 	evt = __ibmvfc_tgt_get_implicit_logout_evt(tgt,
 						   ibmvfc_tgt_implicit_logout_done);
+	if (!evt) {
+		vhost->discovery_threads--;
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		return;
+	}
 
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
 	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
@@ -4381,6 +4442,12 @@ static void ibmvfc_tgt_move_login(struct ibmvfc_target *tgt)
 
 	kref_get(&tgt->kref);
 	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt) {
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		return;
+	}
 	vhost->discovery_threads++;
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
 	ibmvfc_init_event(evt, ibmvfc_tgt_move_login_done, IBMVFC_MAD_FORMAT);
@@ -4547,6 +4614,14 @@ static void ibmvfc_adisc_timeout(struct timer_list *t)
 	vhost->abort_threads++;
 	kref_get(&tgt->kref);
 	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt) {
+		tgt_err(tgt, "Failed to send cancel event for ADISC. rc=%d\n", rc);
+		vhost->abort_threads--;
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		return;
+	}
 	ibmvfc_init_event(evt, ibmvfc_tgt_adisc_cancel_done, IBMVFC_MAD_FORMAT);
 
 	evt->tgt = tgt;
@@ -4597,6 +4672,12 @@ static void ibmvfc_tgt_adisc(struct ibmvfc_target *tgt)
 
 	kref_get(&tgt->kref);
 	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt) {
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		return;
+	}
 	vhost->discovery_threads++;
 	ibmvfc_init_event(evt, ibmvfc_tgt_adisc_done, IBMVFC_MAD_FORMAT);
 	evt->tgt = tgt;
@@ -4700,6 +4781,12 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_target *tgt)
 
 	kref_get(&tgt->kref);
 	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt) {
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		return;
+	}
 	vhost->discovery_threads++;
 	evt->tgt = tgt;
 	ibmvfc_init_event(evt, ibmvfc_tgt_query_target_done, IBMVFC_MAD_FORMAT);
@@ -4872,6 +4959,13 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_discover_targets *mad;
 	struct ibmvfc_event *evt = ibmvfc_get_event(&vhost->crq);
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
+
+	if (!evt) {
+		ibmvfc_log(vhost, level, "Discover Targets failed: no available events\n");
+		ibmvfc_hard_reset_host(vhost);
+		return;
+	}
 
 	ibmvfc_init_event(evt, ibmvfc_discover_targets_done, IBMVFC_MAD_FORMAT);
 	mad = &evt->iu.discover_targets;
@@ -4949,8 +5043,15 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_scsi_channels *scrqs = &vhost->scsi_scrqs;
 	unsigned int num_channels =
 		min(vhost->client_scsi_channels, vhost->max_vios_scsi_channels);
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 	int i;
 
+	if (!evt) {
+		ibmvfc_log(vhost, level, "Channel Setup failed: no available events\n");
+		ibmvfc_hard_reset_host(vhost);
+		return;
+	}
+
 	memset(setup_buf, 0, sizeof(*setup_buf));
 	if (num_channels == 0)
 		setup_buf->flags = cpu_to_be32(IBMVFC_CANCEL_CHANNELS);
@@ -5012,6 +5113,13 @@ static void ibmvfc_channel_enquiry(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_channel_enquiry *mad;
 	struct ibmvfc_event *evt = ibmvfc_get_event(&vhost->crq);
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
+
+	if (!evt) {
+		ibmvfc_log(vhost, level, "Channel Enquiry failed: no available events\n");
+		ibmvfc_hard_reset_host(vhost);
+		return;
+	}
 
 	ibmvfc_init_event(evt, ibmvfc_channel_enquiry_done, IBMVFC_MAD_FORMAT);
 	mad = &evt->iu.channel_enquiry;
@@ -5134,6 +5242,12 @@ static void ibmvfc_npiv_login(struct ibmvfc_host *vhost)
 	struct ibmvfc_npiv_login_mad *mad;
 	struct ibmvfc_event *evt = ibmvfc_get_event(&vhost->crq);
 
+	if (!evt) {
+		ibmvfc_dbg(vhost, "NPIV Login failed: no available events\n");
+		ibmvfc_hard_reset_host(vhost);
+		return;
+	}
+
 	ibmvfc_gather_partition_info(vhost);
 	ibmvfc_set_login_info(vhost);
 	ibmvfc_init_event(evt, ibmvfc_npiv_login_done, IBMVFC_MAD_FORMAT);
@@ -5198,6 +5312,12 @@ static void ibmvfc_npiv_logout(struct ibmvfc_host *vhost)
 	struct ibmvfc_event *evt;
 
 	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt) {
+		ibmvfc_dbg(vhost, "NPIV Logout failed: no available events\n");
+		ibmvfc_hard_reset_host(vhost);
+		return;
+	}
+
 	ibmvfc_init_event(evt, ibmvfc_npiv_logout_done, IBMVFC_MAD_FORMAT);
 
 	mad = &evt->iu.npiv_logout;
-- 
2.31.1

