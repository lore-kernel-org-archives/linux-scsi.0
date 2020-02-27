Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A7CC4BA35
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 01:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23CD524672
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 01:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgB0BqA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 20:46:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29388 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728145AbgB0BqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 20:46:00 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01R1hhOQ119704
        for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2020 20:45:59 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydcp5cgfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2020 20:45:58 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01R1fcHo000417
        for <linux-scsi@vger.kernel.org>; Thu, 27 Feb 2020 01:45:57 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 2ydcmksnx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 27 Feb 2020 01:45:57 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01R1juWm54264160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 01:45:56 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB5626A04D;
        Thu, 27 Feb 2020 01:45:56 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A9946A057;
        Thu, 27 Feb 2020 01:45:56 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.160.103.100])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 01:45:55 +0000 (GMT)
From:   Brian King <brking@linux.vnet.ibm.com>
To:     tyreld@linux.vnet.ibm.com
Cc:     brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH] ibmvfc: Avoid loss of all paths during SVC node reboot
Date:   Wed, 26 Feb 2020 19:45:43 -0600
Message-Id: <1582767943-16611-1-git-send-email-brking@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 adultscore=0 bulkscore=0 mlxscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=3 mlxlogscore=999 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When an SVC node goes down as part of a node reboot, its WWPNs are moved to the
remaining node. When the node is back online, its WWPNs are moved back. The
result is that the WWPN moves from one NPort_ID to another, then back again.
The ibmvfc driver was forcing the old port to be removed, but not sending
an implicit logout. When the WWPN showed up at the new location, the PLOGI
failed as there was already a login established for the old scsi id. The patch
below fixes this by ensuring we always send an implicit logout for any
scsi id associated with an rport prior to calling fc_remote_port_delete.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 207 ++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ibmvscsi/ibmvfc.h |   3 +-
 2 files changed, 173 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index df897df..84dd8c5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -133,6 +133,7 @@
 static void ibmvfc_tgt_send_plogi(struct ibmvfc_target *);
 static void ibmvfc_tgt_query_target(struct ibmvfc_target *);
 static void ibmvfc_npiv_logout(struct ibmvfc_host *);
+static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
 
 static const char *unknown_error = "unknown error";
 
@@ -413,22 +414,44 @@ static const char *ibmvfc_get_fc_type(u16 status)
  * @tgt:		ibmvfc target struct
  * @action:		action to perform
  *
+ * Returns:
+ *	0 if action changed / non-zero if not changed
  **/
-static void ibmvfc_set_tgt_action(struct ibmvfc_target *tgt,
+static int ibmvfc_set_tgt_action(struct ibmvfc_target *tgt,
 				  enum ibmvfc_target_action action)
 {
+	int rc = -EINVAL;
+
 	switch (tgt->action) {
+	case IBMVFC_TGT_ACTION_LOGOUT_RPORT:
+		if (action == IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT ||
+		    action == IBMVFC_TGT_ACTION_DEL_RPORT) {
+			tgt->action = action;
+			rc = 0;
+		}
+		break;
+	case IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT:
+		if (action == IBMVFC_TGT_ACTION_DEL_RPORT) {
+			tgt->action = action;
+			rc = 0;
+		}
+		break;
 	case IBMVFC_TGT_ACTION_DEL_RPORT:
-		if (action == IBMVFC_TGT_ACTION_DELETED_RPORT)
+		if (action == IBMVFC_TGT_ACTION_DELETED_RPORT) {
 			tgt->action = action;
+			rc = 0;
+		}
 	case IBMVFC_TGT_ACTION_DELETED_RPORT:
 		break;
 	default:
-		if (action == IBMVFC_TGT_ACTION_DEL_RPORT)
+		if (action >= IBMVFC_TGT_ACTION_LOGOUT_RPORT)
 			tgt->add_rport = 0;
 		tgt->action = action;
+		rc = 0;
 		break;
 	}
+
+	return rc;
 }
 
 /**
@@ -537,6 +560,19 @@ static void ibmvfc_reinit_host(struct ibmvfc_host *vhost)
 }
 
 /**
+ * ibmvfc_del_tgt - Schedule cleanup and removal of the target
+ * @tgt:		ibmvfc target struct
+ * @job_step:	job step to perform
+ *
+ **/
+static void ibmvfc_del_tgt(struct ibmvfc_target *tgt)
+{
+	if (!ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT))
+		tgt->job_step = ibmvfc_tgt_implicit_logout_and_del;
+	wake_up(&tgt->vhost->work_wait_q);
+}
+
+/**
  * ibmvfc_link_down - Handle a link down event from the adapter
  * @vhost:	ibmvfc host struct
  * @state:	ibmvfc host state to enter
@@ -550,7 +586,7 @@ static void ibmvfc_link_down(struct ibmvfc_host *vhost,
 	ENTER;
 	scsi_block_requests(vhost->host);
 	list_for_each_entry(tgt, &vhost->targets, queue)
-		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+		ibmvfc_del_tgt(tgt);
 	ibmvfc_set_host_state(vhost, state);
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_DEL);
 	vhost->events_to_log |= IBMVFC_AE_LINKDOWN;
@@ -583,7 +619,7 @@ static void ibmvfc_init_host(struct ibmvfc_host *vhost)
 		vhost->async_crq.cur = 0;
 
 		list_for_each_entry(tgt, &vhost->targets, queue)
-			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+			ibmvfc_del_tgt(tgt);
 		scsi_block_requests(vhost->host);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
 		vhost->job_step = ibmvfc_npiv_login;
@@ -1500,7 +1536,7 @@ static void ibmvfc_relogin(struct scsi_device *sdev)
 
 	list_for_each_entry(tgt, &vhost->targets, queue) {
 		if (rport == tgt->rport) {
-			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+			ibmvfc_del_tgt(tgt);
 			break;
 		}
 	}
@@ -2686,7 +2722,7 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 			if (tgt->need_login && be64_to_cpu(crq->event) == IBMVFC_AE_ELS_LOGO)
 				tgt->logo_rcvd = 1;
 			if (!tgt->need_login || be64_to_cpu(crq->event) == IBMVFC_AE_ELS_PLOGI) {
-				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+				ibmvfc_del_tgt(tgt);
 				ibmvfc_reinit_host(vhost);
 			}
 		}
@@ -3220,8 +3256,8 @@ static void ibmvfc_tasklet(void *data)
 static void ibmvfc_init_tgt(struct ibmvfc_target *tgt,
 			    void (*job_step) (struct ibmvfc_target *))
 {
-	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT);
-	tgt->job_step = job_step;
+	if (!ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT))
+		tgt->job_step = job_step;
 	wake_up(&tgt->vhost->work_wait_q);
 }
 
@@ -3237,7 +3273,7 @@ static int ibmvfc_retry_tgt_init(struct ibmvfc_target *tgt,
 				  void (*job_step) (struct ibmvfc_target *))
 {
 	if (++tgt->init_retries > IBMVFC_MAX_TGT_INIT_RETRIES) {
-		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+		ibmvfc_del_tgt(tgt);
 		wake_up(&tgt->vhost->work_wait_q);
 		return 0;
 	} else
@@ -3312,13 +3348,13 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
 						tgt->ids.roles |= FC_PORT_ROLE_FCP_INITIATOR;
 					tgt->add_rport = 1;
 				} else
-					ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+					ibmvfc_del_tgt(tgt);
 			} else if (prli_rsp[index].retry)
 				ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_prli);
 			else
-				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+				ibmvfc_del_tgt(tgt);
 		} else
-			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+			ibmvfc_del_tgt(tgt);
 		break;
 	case IBMVFC_MAD_DRIVER_FAILED:
 		break;
@@ -3335,7 +3371,7 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
 		else if (ibmvfc_retry_cmd(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)))
 			level += ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_prli);
 		else
-			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+			ibmvfc_del_tgt(tgt);
 
 		tgt_log(tgt, level, "Process Login failed: %s (%x:%x) rc=0x%02X\n",
 			ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
@@ -3434,7 +3470,7 @@ static void ibmvfc_tgt_plogi_done(struct ibmvfc_event *evt)
 		if (ibmvfc_retry_cmd(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)))
 			level += ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_plogi);
 		else
-			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+			ibmvfc_del_tgt(tgt);
 
 		tgt_log(tgt, level, "Port Login failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
 			ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
@@ -3515,33 +3551,28 @@ static void ibmvfc_tgt_implicit_logout_done(struct ibmvfc_event *evt)
 		break;
 	}
 
-	if (vhost->action == IBMVFC_HOST_ACTION_TGT_INIT)
-		ibmvfc_init_tgt(tgt, ibmvfc_tgt_send_plogi);
-	else if (vhost->action == IBMVFC_HOST_ACTION_QUERY_TGTS &&
-		 tgt->scsi_id != tgt->new_scsi_id)
-		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+	ibmvfc_init_tgt(tgt, ibmvfc_tgt_send_plogi);
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	wake_up(&vhost->work_wait_q);
 }
 
 /**
- * ibmvfc_tgt_implicit_logout - Initiate an Implicit Logout for specified target
+ * __ibmvfc_tgt_get_implicit_logout_evt - Allocate and init an event for implicit logout
  * @tgt:		ibmvfc target struct
  *
+ * Returns:
+ *	Allocated and initialized ibmvfc_event struct
  **/
-static void ibmvfc_tgt_implicit_logout(struct ibmvfc_target *tgt)
+static struct ibmvfc_event *__ibmvfc_tgt_get_implicit_logout_evt(struct ibmvfc_target *tgt,
+								 void (*done) (struct ibmvfc_event *))
 {
 	struct ibmvfc_implicit_logout *mad;
 	struct ibmvfc_host *vhost = tgt->vhost;
 	struct ibmvfc_event *evt;
 
-	if (vhost->discovery_threads >= disc_threads)
-		return;
-
 	kref_get(&tgt->kref);
 	evt = ibmvfc_get_event(vhost);
-	vhost->discovery_threads++;
-	ibmvfc_init_event(evt, ibmvfc_tgt_implicit_logout_done, IBMVFC_MAD_FORMAT);
+	ibmvfc_init_event(evt, done, IBMVFC_MAD_FORMAT);
 	evt->tgt = tgt;
 	mad = &evt->iu.implicit_logout;
 	memset(mad, 0, sizeof(*mad));
@@ -3549,6 +3580,25 @@ static void ibmvfc_tgt_implicit_logout(struct ibmvfc_target *tgt)
 	mad->common.opcode = cpu_to_be32(IBMVFC_IMPLICIT_LOGOUT);
 	mad->common.length = cpu_to_be16(sizeof(*mad));
 	mad->old_scsi_id = cpu_to_be64(tgt->scsi_id);
+	return evt;
+}
+
+/**
+ * ibmvfc_tgt_implicit_logout - Initiate an Implicit Logout for specified target
+ * @tgt:		ibmvfc target struct
+ *
+ **/
+static void ibmvfc_tgt_implicit_logout(struct ibmvfc_target *tgt)
+{
+	struct ibmvfc_host *vhost = tgt->vhost;
+	struct ibmvfc_event *evt;
+
+	if (vhost->discovery_threads >= disc_threads)
+		return;
+
+	vhost->discovery_threads++;
+	evt = __ibmvfc_tgt_get_implicit_logout_evt(tgt,
+						   ibmvfc_tgt_implicit_logout_done);
 
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
 	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
@@ -3560,6 +3610,53 @@ static void ibmvfc_tgt_implicit_logout(struct ibmvfc_target *tgt)
 }
 
 /**
+ * ibmvfc_tgt_implicit_logout_and_del_done - Completion handler for Implicit Logout MAD
+ * @evt:	ibmvfc event struct
+ *
+ **/
+static void ibmvfc_tgt_implicit_logout_and_del_done(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_target *tgt = evt->tgt;
+	struct ibmvfc_host *vhost = evt->vhost;
+	struct ibmvfc_passthru_mad *mad = &evt->xfer_iu->passthru;
+	u32 status = be16_to_cpu(mad->common.status);
+
+	vhost->discovery_threads--;
+	ibmvfc_free_event(evt);
+	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+
+	tgt_dbg(tgt, "Implicit Logout %s\n", (status == IBMVFC_MAD_SUCCESS) ? "succeeded" : "failed");
+	kref_put(&tgt->kref, ibmvfc_release_tgt);
+	wake_up(&vhost->work_wait_q);
+}
+
+/**
+ * ibmvfc_tgt_implicit_logout_and_del - Initiate an Implicit Logout for specified target
+ * @tgt:		ibmvfc target struct
+ *
+ **/
+static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
+{
+	struct ibmvfc_host *vhost = tgt->vhost;
+	struct ibmvfc_event *evt;
+
+	if (vhost->discovery_threads >= disc_threads)
+		return NULL;
+
+	vhost->discovery_threads++;
+	evt = __ibmvfc_tgt_get_implicit_logout_evt(tgt,
+						   ibmvfc_tgt_implicit_logout_and_del_done);
+
+	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT);
+	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
+		vhost->discovery_threads--;
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+	} else
+		tgt_dbg(tgt, "Sent Implicit Logout\n");
+}
+
+/**
  * ibmvfc_adisc_needs_plogi - Does device need PLOGI?
  * @mad:	ibmvfc passthru mad struct
  * @tgt:	ibmvfc target struct
@@ -3600,13 +3697,13 @@ static void ibmvfc_tgt_adisc_done(struct ibmvfc_event *evt)
 	case IBMVFC_MAD_SUCCESS:
 		tgt_dbg(tgt, "ADISC succeeded\n");
 		if (ibmvfc_adisc_needs_plogi(mad, tgt))
-			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+			ibmvfc_del_tgt(tgt);
 		break;
 	case IBMVFC_MAD_DRIVER_FAILED:
 		break;
 	case IBMVFC_MAD_FAILED:
 	default:
-		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+		ibmvfc_del_tgt(tgt);
 		fc_reason = (be32_to_cpu(mad->fc_iu.response[1]) & 0x00ff0000) >> 16;
 		fc_explain = (be32_to_cpu(mad->fc_iu.response[1]) & 0x0000ff00) >> 8;
 		tgt_info(tgt, "ADISC failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
@@ -3799,9 +3896,8 @@ static void ibmvfc_tgt_query_target_done(struct ibmvfc_event *evt)
 	switch (status) {
 	case IBMVFC_MAD_SUCCESS:
 		tgt_dbg(tgt, "Query Target succeeded\n");
-		tgt->new_scsi_id = be64_to_cpu(rsp->scsi_id);
 		if (be64_to_cpu(rsp->scsi_id) != tgt->scsi_id)
-			ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
+			ibmvfc_del_tgt(tgt);
 		else
 			ibmvfc_init_tgt(tgt, ibmvfc_tgt_adisc);
 		break;
@@ -3815,11 +3911,11 @@ static void ibmvfc_tgt_query_target_done(struct ibmvfc_event *evt)
 		if ((be16_to_cpu(rsp->status) & IBMVFC_FABRIC_MAPPED) == IBMVFC_FABRIC_MAPPED &&
 		    be16_to_cpu(rsp->error) == IBMVFC_UNABLE_TO_PERFORM_REQ &&
 		    be16_to_cpu(rsp->fc_explain) == IBMVFC_PORT_NAME_NOT_REG)
-			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+			ibmvfc_del_tgt(tgt);
 		else if (ibmvfc_retry_cmd(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)))
 			level += ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_query_target);
 		else
-			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+			ibmvfc_del_tgt(tgt);
 
 		tgt_log(tgt, level, "Query Target failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
 			ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
@@ -3896,7 +3992,6 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost, u64 scsi_id)
 	tgt = mempool_alloc(vhost->tgt_pool, GFP_NOIO);
 	memset(tgt, 0, sizeof(*tgt));
 	tgt->scsi_id = scsi_id;
-	tgt->new_scsi_id = scsi_id;
 	tgt->vhost = vhost;
 	tgt->need_login = 1;
 	tgt->cancel_key = vhost->task_set++;
@@ -4189,6 +4284,25 @@ static int ibmvfc_dev_init_to_do(struct ibmvfc_host *vhost)
 }
 
 /**
+ * ibmvfc_dev_logo_to_do - Is there target logout work to do?
+ * @vhost:		ibmvfc host struct
+ *
+ * Returns:
+ *	1 if work to do / 0 if not
+ **/
+static int ibmvfc_dev_logo_to_do(struct ibmvfc_host *vhost)
+{
+	struct ibmvfc_target *tgt;
+
+	list_for_each_entry(tgt, &vhost->targets, queue) {
+		if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT ||
+		    tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT)
+			return 1;
+	}
+	return 0;
+}
+
+/**
  * __ibmvfc_work_to_do - Is there task level work to do? (no locking)
  * @vhost:		ibmvfc host struct
  *
@@ -4217,11 +4331,20 @@ static int __ibmvfc_work_to_do(struct ibmvfc_host *vhost)
 			if (tgt->action == IBMVFC_TGT_ACTION_INIT_WAIT)
 				return 0;
 		return 1;
+	case IBMVFC_HOST_ACTION_TGT_DEL:
+	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
+		if (vhost->discovery_threads == disc_threads)
+			return 0;
+		list_for_each_entry(tgt, &vhost->targets, queue)
+			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT)
+				return 1;
+		list_for_each_entry(tgt, &vhost->targets, queue)
+			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT)
+				return 0;
+		return 1;
 	case IBMVFC_HOST_ACTION_LOGO:
 	case IBMVFC_HOST_ACTION_INIT:
 	case IBMVFC_HOST_ACTION_ALLOC_TGTS:
-	case IBMVFC_HOST_ACTION_TGT_DEL:
-	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
 	case IBMVFC_HOST_ACTION_QUERY:
 	case IBMVFC_HOST_ACTION_RESET:
 	case IBMVFC_HOST_ACTION_REENABLE:
@@ -4391,6 +4514,18 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 	case IBMVFC_HOST_ACTION_TGT_DEL:
 	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
 		list_for_each_entry(tgt, &vhost->targets, queue) {
+			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT) {
+				tgt->job_step(tgt);
+				break;
+			}
+		}
+
+		if (ibmvfc_dev_logo_to_do(vhost)) {
+			spin_unlock_irqrestore(vhost->host->host_lock, flags);
+			return;
+		}
+
+		list_for_each_entry(tgt, &vhost->targets, queue) {
 			if (tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
 				tgt_dbg(tgt, "Deleting rport\n");
 				rport = tgt->rport;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 7da89f4..907889f 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -596,6 +596,8 @@ enum ibmvfc_target_action {
 	IBMVFC_TGT_ACTION_NONE = 0,
 	IBMVFC_TGT_ACTION_INIT,
 	IBMVFC_TGT_ACTION_INIT_WAIT,
+	IBMVFC_TGT_ACTION_LOGOUT_RPORT,
+	IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT,
 	IBMVFC_TGT_ACTION_DEL_RPORT,
 	IBMVFC_TGT_ACTION_DELETED_RPORT,
 };
@@ -604,7 +606,6 @@ struct ibmvfc_target {
 	struct list_head queue;
 	struct ibmvfc_host *vhost;
 	u64 scsi_id;
-	u64 new_scsi_id;
 	struct fc_rport *rport;
 	int target_id;
 	enum ibmvfc_target_action action;
-- 
1.8.3.1

