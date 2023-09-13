Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA76EE0211
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 23:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbjIMXbA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 19:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbjIMXa4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 19:30:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0376E3
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 16:30:52 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DN8lkL022804;
        Wed, 13 Sep 2023 23:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZbNv/mTqk7SxTvZ6GCHdrKjsa7moQsbJT3XjgL76who=;
 b=ri0YT6yQ3+ZPiNN37iNSE/M/R3nl9oMoi8h9WgVjv/lkB2SC1RzEMlVHeWzfq77r9+pH
 N00WxLK/gefxc52dPcNrw2HCnVXHictH6VCVkPqzV41TKmbRgjOvn6FVRyr1Z2pEnVbW
 hjD5Z+LjTN6LnFe4iblaMYGfHwd8qJlkCPc8w6+HYEPdHcO39M2zMQicx528IjFGBPVh
 KJqmZDyxvOAN0UD3xj+9u4XKEeSbQHJPWx8cwP1g8Dck0aMk1efAdugtd7GPxA7kHM+9
 fK8g0fuC2y4sDJfrJ973uK6FrIBWneueez4hVviltetE99d95ImDEOzuyINrC4+wF2un mQ== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3mh6k8q1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:30:49 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DMr5hS012083;
        Wed, 13 Sep 2023 23:05:01 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t13dyxtn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:05:01 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DN50kC33948166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 23:05:00 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4B8058053;
        Wed, 13 Sep 2023 23:05:00 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CB2A58043;
        Wed, 13 Sep 2023 23:05:00 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 23:05:00 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 02/11] ibmvfc: implement channel queue depth and event buffer accounting
Date:   Wed, 13 Sep 2023 18:04:48 -0500
Message-Id: <20230913230457.2575849-3-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230913230457.2575849-1-tyreld@linux.ibm.com>
References: <20230913230457.2575849-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o5Q8foEDEjq2vkgaZ5gO5syzQIAchsMh
X-Proofpoint-ORIG-GUID: o5Q8foEDEjq2vkgaZ5gO5syzQIAchsMh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_17,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309130191
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Extend ibmvfc_queue, ibmvfc_event, and ibmvfc_event_pool to provide
queue depths for general IO commands and reserved commands as well as
proper accounting of the free events of each type from the general event
pool. Further, calculate the negotiated max command limit with the VIOS
at NPIV login time as a function of the number of queues times their
total queue depth (general and reserved depths combined).

This does away with the legacy max_request value, and allows the driver
to better manage and track it resources.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 108 +++++++++++++++++++++------------
 drivers/scsi/ibmvscsi/ibmvfc.h |   9 +++
 2 files changed, 78 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 10435ddddfe5..9cd11cab4f3e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -38,6 +38,7 @@ static unsigned int default_timeout = IBMVFC_DEFAULT_TIMEOUT;
 static u64 max_lun = IBMVFC_MAX_LUN;
 static unsigned int max_targets = IBMVFC_MAX_TARGETS;
 static unsigned int max_requests = IBMVFC_MAX_REQUESTS_DEFAULT;
+static u16 scsi_qdepth = IBMVFC_SCSI_QDEPTH;
 static unsigned int disc_threads = IBMVFC_MAX_DISC_THREADS;
 static unsigned int ibmvfc_debug = IBMVFC_DEBUG;
 static unsigned int log_level = IBMVFC_DEFAULT_LOG_LEVEL;
@@ -83,6 +84,9 @@ MODULE_PARM_DESC(default_timeout,
 module_param_named(max_requests, max_requests, uint, S_IRUGO);
 MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter. "
 		 "[Default=" __stringify(IBMVFC_MAX_REQUESTS_DEFAULT) "]");
+module_param_named(scsi_qdepth, scsi_qdepth, ushort, S_IRUGO);
+MODULE_PARM_DESC(scsi_qdepth, "Maximum scsi command depth per adapter queue. "
+		 "[Default=" __stringify(IBMVFC_SCSI_QDEPTH) "]");
 module_param_named(max_lun, max_lun, ullong, S_IRUGO);
 MODULE_PARM_DESC(max_lun, "Maximum allowed LUN. "
 		 "[Default=" __stringify(IBMVFC_MAX_LUN) "]");
@@ -781,23 +785,22 @@ static int ibmvfc_send_crq_init_complete(struct ibmvfc_host *vhost)
  * Returns zero on success.
  **/
 static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
-				  struct ibmvfc_queue *queue,
-				  unsigned int size)
+				  struct ibmvfc_queue *queue)
 {
 	int i;
 	struct ibmvfc_event_pool *pool = &queue->evt_pool;
 
 	ENTER;
-	if (!size)
+	if (!queue->total_depth)
 		return 0;
 
-	pool->size = size;
-	pool->events = kcalloc(size, sizeof(*pool->events), GFP_KERNEL);
+	pool->size = queue->total_depth;
+	pool->events = kcalloc(pool->size, sizeof(*pool->events), GFP_KERNEL);
 	if (!pool->events)
 		return -ENOMEM;
 
 	pool->iu_storage = dma_alloc_coherent(vhost->dev,
-					      size * sizeof(*pool->iu_storage),
+					      pool->size * sizeof(*pool->iu_storage),
 					      &pool->iu_token, 0);
 
 	if (!pool->iu_storage) {
@@ -807,9 +810,11 @@ static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
 
 	INIT_LIST_HEAD(&queue->sent);
 	INIT_LIST_HEAD(&queue->free);
+	queue->evt_free = queue->evt_depth;
+	queue->reserved_free = queue->reserved_depth;
 	spin_lock_init(&queue->l_lock);
 
-	for (i = 0; i < size; ++i) {
+	for (i = 0; i < pool->size; ++i) {
 		struct ibmvfc_event *evt = &pool->events[i];
 
 		/*
@@ -1033,6 +1038,12 @@ static void ibmvfc_free_event(struct ibmvfc_event *evt)
 
 	spin_lock_irqsave(&evt->queue->l_lock, flags);
 	list_add_tail(&evt->queue_list, &evt->queue->free);
+	if (evt->reserved) {
+		evt->reserved = 0;
+		evt->queue->reserved_free++;
+	} else {
+		evt->queue->evt_free++;
+	}
 	if (evt->eh_comp)
 		complete(evt->eh_comp);
 	spin_unlock_irqrestore(&evt->queue->l_lock, flags);
@@ -1475,6 +1486,12 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 	struct ibmvfc_queue *async_crq = &vhost->async_crq;
 	struct device_node *of_node = vhost->dev->of_node;
 	const char *location;
+	u16 max_cmds;
+
+	max_cmds = scsi_qdepth + IBMVFC_NUM_INTERNAL_REQ;
+	if (mq_enabled)
+		max_cmds += (scsi_qdepth + IBMVFC_NUM_INTERNAL_SUBQ_REQ) *
+			vhost->client_scsi_channels;
 
 	memset(login_info, 0, sizeof(*login_info));
 
@@ -1489,7 +1506,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 	if (vhost->client_migrated)
 		login_info->flags |= cpu_to_be16(IBMVFC_CLIENT_MIGRATED);
 
-	login_info->max_cmds = cpu_to_be32(max_requests + IBMVFC_NUM_INTERNAL_REQ);
+	login_info->max_cmds = cpu_to_be32(max_cmds);
 	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
 
 	if (vhost->mq_enabled || vhost->using_channels)
@@ -1513,24 +1530,33 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
  *
  * Returns a free event from the pool.
  **/
-static struct ibmvfc_event *ibmvfc_get_event(struct ibmvfc_queue *queue)
+static struct ibmvfc_event *__ibmvfc_get_event(struct ibmvfc_queue *queue, int reserved)
 {
-	struct ibmvfc_event *evt;
+	struct ibmvfc_event *evt = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&queue->l_lock, flags);
-	if (list_empty(&queue->free)) {
-		ibmvfc_log(queue->vhost, 4, "empty event pool on queue:%ld\n", queue->hwq_id);
-		spin_unlock_irqrestore(&queue->l_lock, flags);
-		return NULL;
+	if (reserved && queue->reserved_free) {
+		evt = list_entry(queue->free.next, struct ibmvfc_event, queue_list);
+		evt->reserved = 1;
+		queue->reserved_free--;
+	} else if (queue->evt_free) {
+		evt = list_entry(queue->free.next, struct ibmvfc_event, queue_list);
+		queue->evt_free--;
+	} else {
+		goto out;
 	}
-	evt = list_entry(queue->free.next, struct ibmvfc_event, queue_list);
+
 	atomic_set(&evt->free, 0);
 	list_del(&evt->queue_list);
+out:
 	spin_unlock_irqrestore(&queue->l_lock, flags);
 	return evt;
 }
 
+#define ibmvfc_get_event(queue) __ibmvfc_get_event(queue, 0)
+#define ibmvfc_get_reserved_event(queue) __ibmvfc_get_event(queue, 1)
+
 /**
  * ibmvfc_locked_done - Calls evt completion with host_lock held
  * @evt:	ibmvfc evt to complete
@@ -2047,7 +2073,7 @@ static int ibmvfc_bsg_timeout(struct bsg_job *job)
 	}
 
 	vhost->aborting_passthru = 1;
-	evt = ibmvfc_get_event(&vhost->crq);
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 		return -ENOMEM;
@@ -2110,7 +2136,7 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
 	if (unlikely((rc = ibmvfc_host_chkready(vhost))))
 		goto unlock_out;
 
-	evt = ibmvfc_get_event(&vhost->crq);
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
 		rc = -ENOMEM;
 		goto unlock_out;
@@ -2232,7 +2258,7 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 		goto out;
 	}
 
-	evt = ibmvfc_get_event(&vhost->crq);
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 		rc = -ENOMEM;
@@ -2533,7 +2559,7 @@ static struct ibmvfc_event *ibmvfc_init_tmf(struct ibmvfc_queue *queue,
 	struct ibmvfc_event *evt;
 	struct ibmvfc_tmf *tmf;
 
-	evt = ibmvfc_get_event(queue);
+	evt = ibmvfc_get_reserved_event(queue);
 	if (!evt)
 		return NULL;
 	ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_MAD_FORMAT);
@@ -3673,7 +3699,6 @@ static const struct scsi_host_template driver_template = {
 	.max_sectors = IBMVFC_MAX_SECTORS,
 	.shost_groups = ibmvfc_host_groups,
 	.track_queue_depth = 1,
-	.host_tagset = 1,
 };
 
 /**
@@ -4071,7 +4096,7 @@ static void ibmvfc_tgt_send_prli(struct ibmvfc_target *tgt)
 		return;
 
 	kref_get(&tgt->kref);
-	evt = ibmvfc_get_event(&vhost->crq);
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
@@ -4184,7 +4209,7 @@ static void ibmvfc_tgt_send_plogi(struct ibmvfc_target *tgt)
 
 	kref_get(&tgt->kref);
 	tgt->logo_rcvd = 0;
-	evt = ibmvfc_get_event(&vhost->crq);
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
@@ -4266,7 +4291,7 @@ static struct ibmvfc_event *__ibmvfc_tgt_get_implicit_logout_evt(struct ibmvfc_t
 	struct ibmvfc_event *evt;
 
 	kref_get(&tgt->kref);
-	evt = ibmvfc_get_event(&vhost->crq);
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt)
 		return NULL;
 	ibmvfc_init_event(evt, done, IBMVFC_MAD_FORMAT);
@@ -4441,7 +4466,7 @@ static void ibmvfc_tgt_move_login(struct ibmvfc_target *tgt)
 		return;
 
 	kref_get(&tgt->kref);
-	evt = ibmvfc_get_event(&vhost->crq);
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
@@ -4613,7 +4638,7 @@ static void ibmvfc_adisc_timeout(struct timer_list *t)
 
 	vhost->abort_threads++;
 	kref_get(&tgt->kref);
-	evt = ibmvfc_get_event(&vhost->crq);
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
 		tgt_err(tgt, "Failed to send cancel event for ADISC. rc=%d\n", rc);
 		vhost->abort_threads--;
@@ -4671,7 +4696,7 @@ static void ibmvfc_tgt_adisc(struct ibmvfc_target *tgt)
 		return;
 
 	kref_get(&tgt->kref);
-	evt = ibmvfc_get_event(&vhost->crq);
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
@@ -4780,7 +4805,7 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_target *tgt)
 		return;
 
 	kref_get(&tgt->kref);
-	evt = ibmvfc_get_event(&vhost->crq);
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
@@ -4958,7 +4983,7 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
 static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_discover_targets *mad;
-	struct ibmvfc_event *evt = ibmvfc_get_event(&vhost->crq);
+	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 
 	if (!evt) {
@@ -5039,7 +5064,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_channel_setup_mad *mad;
 	struct ibmvfc_channel_setup *setup_buf = vhost->channel_setup_buf;
-	struct ibmvfc_event *evt = ibmvfc_get_event(&vhost->crq);
+	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
 	struct ibmvfc_scsi_channels *scrqs = &vhost->scsi_scrqs;
 	unsigned int num_channels =
 		min(vhost->client_scsi_channels, vhost->max_vios_scsi_channels);
@@ -5112,7 +5137,7 @@ static void ibmvfc_channel_enquiry_done(struct ibmvfc_event *evt)
 static void ibmvfc_channel_enquiry(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_channel_enquiry *mad;
-	struct ibmvfc_event *evt = ibmvfc_get_event(&vhost->crq);
+	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 
 	if (!evt) {
@@ -5240,7 +5265,7 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
 static void ibmvfc_npiv_login(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_npiv_login_mad *mad;
-	struct ibmvfc_event *evt = ibmvfc_get_event(&vhost->crq);
+	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
 
 	if (!evt) {
 		ibmvfc_dbg(vhost, "NPIV Login failed: no available events\n");
@@ -5311,7 +5336,7 @@ static void ibmvfc_npiv_logout(struct ibmvfc_host *vhost)
 	struct ibmvfc_npiv_logout_mad *mad;
 	struct ibmvfc_event *evt;
 
-	evt = ibmvfc_get_event(&vhost->crq);
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
 		ibmvfc_dbg(vhost, "NPIV Logout failed: no available events\n");
 		ibmvfc_hard_reset_host(vhost);
@@ -5765,7 +5790,6 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 {
 	struct device *dev = vhost->dev;
 	size_t fmt_size;
-	unsigned int pool_size = 0;
 
 	ENTER;
 	spin_lock_init(&queue->_lock);
@@ -5774,7 +5798,9 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 	switch (fmt) {
 	case IBMVFC_CRQ_FMT:
 		fmt_size = sizeof(*queue->msgs.crq);
-		pool_size = max_requests + IBMVFC_NUM_INTERNAL_REQ;
+		queue->total_depth = scsi_qdepth + IBMVFC_NUM_INTERNAL_REQ;
+		queue->evt_depth = scsi_qdepth;
+		queue->reserved_depth = IBMVFC_NUM_INTERNAL_REQ;
 		break;
 	case IBMVFC_ASYNC_FMT:
 		fmt_size = sizeof(*queue->msgs.async);
@@ -5782,14 +5808,17 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 	case IBMVFC_SUB_CRQ_FMT:
 		fmt_size = sizeof(*queue->msgs.scrq);
 		/* We need one extra event for Cancel Commands */
-		pool_size = max_requests + 1;
+		queue->total_depth = scsi_qdepth + IBMVFC_NUM_INTERNAL_SUBQ_REQ;
+		queue->evt_depth = scsi_qdepth;
+		queue->reserved_depth = IBMVFC_NUM_INTERNAL_SUBQ_REQ;
 		break;
 	default:
 		dev_warn(dev, "Unknown command/response queue message format: %d\n", fmt);
 		return -EINVAL;
 	}
 
-	if (ibmvfc_init_event_pool(vhost, queue, pool_size)) {
+	queue->fmt = fmt;
+	if (ibmvfc_init_event_pool(vhost, queue)) {
 		dev_err(dev, "Couldn't initialize event pool.\n");
 		return -ENOMEM;
 	}
@@ -5808,7 +5837,6 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 	}
 
 	queue->cur = 0;
-	queue->fmt = fmt;
 	queue->size = PAGE_SIZE / fmt_size;
 
 	queue->vhost = vhost;
@@ -6243,7 +6271,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	}
 
 	shost->transportt = ibmvfc_transport_template;
-	shost->can_queue = max_requests;
+	shost->can_queue = scsi_qdepth;
 	shost->max_lun = max_lun;
 	shost->max_id = max_targets;
 	shost->max_sectors = IBMVFC_MAX_SECTORS;
@@ -6402,7 +6430,9 @@ static int ibmvfc_resume(struct device *dev)
  */
 static unsigned long ibmvfc_get_desired_dma(struct vio_dev *vdev)
 {
-	unsigned long pool_dma = max_requests * sizeof(union ibmvfc_iu);
+	unsigned long pool_dma;
+
+	pool_dma = (IBMVFC_MAX_SCSI_QUEUES * scsi_qdepth) * sizeof(union ibmvfc_iu);
 	return pool_dma + ((512 * 1024) * driver_template.cmd_per_lun);
 }
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index c39a245f43d0..0e641a880e1c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -27,6 +27,7 @@
 #define IBMVFC_ABORT_TIMEOUT		8
 #define IBMVFC_ABORT_WAIT_TIMEOUT	40
 #define IBMVFC_MAX_REQUESTS_DEFAULT	100
+#define IBMVFC_SCSI_QDEPTH		128
 
 #define IBMVFC_DEBUG			0
 #define IBMVFC_MAX_TARGETS		1024
@@ -57,6 +58,8 @@
  * 2 for each discovery thread
  */
 #define IBMVFC_NUM_INTERNAL_REQ	(1 + 1 + 1 + 2 + (disc_threads * 2))
+/* Reserved suset of events for cancelling channelized IO commands */
+#define IBMVFC_NUM_INTERNAL_SUBQ_REQ 4
 
 #define IBMVFC_MAD_SUCCESS		0x00
 #define IBMVFC_MAD_NOT_SUPPORTED	0xF1
@@ -758,6 +761,7 @@ struct ibmvfc_event {
 	struct completion *eh_comp;
 	struct timer_list timer;
 	u16 hwq;
+	u8 reserved;
 };
 
 /* a pool of event structs for use */
@@ -793,6 +797,11 @@ struct ibmvfc_queue {
 	struct ibmvfc_event_pool evt_pool;
 	struct list_head sent;
 	struct list_head free;
+	u16 total_depth;
+	u16 evt_depth;
+	u16 reserved_depth;
+	u16 evt_free;
+	u16 reserved_free;
 	spinlock_t l_lock;
 
 	union ibmvfc_iu cancel_rsp;
-- 
2.31.1

