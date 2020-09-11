Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF0BC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 21:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95DFC22207
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 21:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Te3PZ0h7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgIKV3C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 17:29:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbgIKV27 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 17:28:59 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08BL2CYg083121;
        Fri, 11 Sep 2020 17:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=JHRUpoDv4uORlvEHFrHdwSDNyztSjz++rqLWmVXj2Nc=;
 b=Te3PZ0h7fyIVNDc2WVxVbD46rbKyv4MLm86I4tv7e/stStmv7iH2V0mOmsX4VHSm7NDS
 eaVP8pZen3AJd7W+c9COePNO4yxmEI4EqehLZiv5lfFwEiMHU9FACayCu2O6HWwk9TSv
 RL0Yh502gIGxrhejBHIciQY/y4DGStLPr7KTi7KZ6S7qEq4vODcWyTi1/Z4a1wfJHf/I
 8UkTr91i3GUYQsCfio/qA6CJUCYkWP4K457hqkmu3zNy4aypLgNdiAsQeJbjWVBjkmNR
 FwnGxXZj7MyzJe04pOk/yqt78l7PrkamTTLLdfAJ9906n4DoHKVtxPGtxLRggsb43iuF dg== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ggp5rqvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 17:28:46 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08BLRFKd011339;
        Fri, 11 Sep 2020 21:28:44 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 33cebvf223-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 21:28:44 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08BLSiPL53543264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 21:28:44 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FB9CAE05C;
        Fri, 11 Sep 2020 21:28:44 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1AE5AE060;
        Fri, 11 Sep 2020 21:28:43 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.65.206.179])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 11 Sep 2020 21:28:43 +0000 (GMT)
From:   Brian King <brking@linux.vnet.ibm.com>
To:     linux-scsi@vger.kernel.org
Cc:     tyreld@linux.ibm.com, linuxppc-dev@lists.ozlabs.org,
        martin.petersen@oracle.com, Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] ibmvfc: Avoid link down on FS9100 canister reboot
Date:   Fri, 11 Sep 2020 16:28:26 -0500
Message-Id: <1599859706-8505-1-git-send-email-brking@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_10:2020-09-10,2020-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=4 malwarescore=0
 clxscore=1011 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110167
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a canister on a FS9100, or similar storage, running in NPIV mode,
is rebooted, its WWPNs will fail over to another canister. When this
occurs, we see a WWPN going away from the fabric at one N-Port ID,
and, a short time later, the same WWPN appears at a different N-Port ID.
When the canister is fully operational again, the WWPNs fail back to
the original canister. If there is any I/O outstanding to the target
when this occurs, it will result in the implicit logout the ibmvfc driver
issues before removing the rport to fail. When the WWPN then shows up at a
different N-Port ID, and we issue a PLOGI to it, the VIOS will
see that it still has a login for this WWPN at the old N-Port ID,
which results in the VIOS simulating a link down / link up sequence
to the client, in order to get the VIOS and client LPAR in sync.

The patch below improves the way we handle this scenario so as to
avoid the link bounce, which affects all targets under the virtual
host adapter. The change is to utilize the Move Login MAD, which
will work even when I/O is outstanding to the target. The change
only alters the target state machine for the case where the implicit
logout fails prior to deleting the rport. If this implicit logout fails,
we defer deleting the ibmvfc_target object after calling
fc_remote_port_delete. This enables us to later retry the implicit logout
after terminate_rport_io occurs, or to issue the Move Login request if
a WWPN shows up at a new N-Port ID prior to this occurring.

This has been tested by IBM's storage interoperability team
on a FS9100, forcing the failover to occur. With debug tracing enabled
in the ibmvfc driver, we confirmed the move login was sent
in this scenario and confirmed the link bounce no longer occurred.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 211 ++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h |  38 +++++++-
 2 files changed, 232 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 175a165..322bb30 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -134,6 +134,7 @@
 static void ibmvfc_tgt_query_target(struct ibmvfc_target *);
 static void ibmvfc_npiv_logout(struct ibmvfc_host *);
 static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
+static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
 
 static const char *unknown_error = "unknown error";
 
@@ -431,7 +432,20 @@ static int ibmvfc_set_tgt_action(struct ibmvfc_target *tgt,
 		}
 		break;
 	case IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT:
-		if (action == IBMVFC_TGT_ACTION_DEL_RPORT) {
+		if (action == IBMVFC_TGT_ACTION_DEL_RPORT ||
+		    action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
+			tgt->action = action;
+			rc = 0;
+		}
+		break;
+	case IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT:
+		if (action == IBMVFC_TGT_ACTION_LOGOUT_RPORT) {
+			tgt->action = action;
+			rc = 0;
+		}
+		break;
+	case IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT:
+		if (action == IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT) {
 			tgt->action = action;
 			rc = 0;
 		}
@@ -441,16 +455,18 @@ static int ibmvfc_set_tgt_action(struct ibmvfc_target *tgt,
 			tgt->action = action;
 			rc = 0;
 		}
+		break;
 	case IBMVFC_TGT_ACTION_DELETED_RPORT:
 		break;
 	default:
-		if (action >= IBMVFC_TGT_ACTION_LOGOUT_RPORT)
-			tgt->add_rport = 0;
 		tgt->action = action;
 		rc = 0;
 		break;
 	}
 
+	if (action >= IBMVFC_TGT_ACTION_LOGOUT_RPORT)
+		tgt->add_rport = 0;
+
 	return rc;
 }
 
@@ -548,7 +564,8 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
  **/
 static void ibmvfc_reinit_host(struct ibmvfc_host *vhost)
 {
-	if (vhost->action == IBMVFC_HOST_ACTION_NONE) {
+	if (vhost->action == IBMVFC_HOST_ACTION_NONE &&
+	    vhost->state == IBMVFC_ACTIVE) {
 		if (!ibmvfc_set_host_state(vhost, IBMVFC_INITIALIZING)) {
 			scsi_block_requests(vhost->host);
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
@@ -2574,7 +2591,9 @@ static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 	struct ibmvfc_host *vhost = shost_priv(shost);
 	struct fc_rport *dev_rport;
 	struct scsi_device *sdev;
-	unsigned long rc;
+	struct ibmvfc_target *tgt;
+	unsigned long rc, flags;
+	unsigned int found;
 
 	ENTER;
 	shost_for_each_device(sdev, shost) {
@@ -2588,6 +2607,25 @@ static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 
 	if (rc == FAILED)
 		ibmvfc_issue_fc_host_lip(shost);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	found = 0;
+	list_for_each_entry(tgt, &vhost->targets, queue) {
+		if (tgt->scsi_id == rport->port_id) {
+			found++;
+			break;
+		}
+	}
+
+	if (found && tgt->action == IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT) {
+		/* If we get here, that means we previously attempted to send
+		 an implicit logout to the target but it failed, most likely
+		 due to I/O being pending, so we need to send it again */
+		ibmvfc_del_tgt(tgt);
+		ibmvfc_reinit_host(vhost);
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
 	LEAVE;
 }
 
@@ -3623,7 +3661,15 @@ static void ibmvfc_tgt_implicit_logout_and_del_done(struct ibmvfc_event *evt)
 
 	vhost->discovery_threads--;
 	ibmvfc_free_event(evt);
-	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+
+	/* If our state is IBMVFC_HOST_OFFLINE, we could be unloading the driver
+	 in which case we need to free up all the targets. If we are not unloading,
+	 we will still go through a hard reset to get out of offline state, so there
+	 is no need to track the old targets in that case */
+	if (status == IBMVFC_MAD_SUCCESS || vhost->state == IBMVFC_HOST_OFFLINE)
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+	else
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT);
 
 	tgt_dbg(tgt, "Implicit Logout %s\n", (status == IBMVFC_MAD_SUCCESS) ? "succeeded" : "failed");
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
@@ -3662,6 +3708,92 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
 }
 
 /**
+ * ibmvfc_tgt_move_login_done - Completion handler for Move Login
+ * @evt:	ibmvfc event struct
+ *
+ **/
+static void ibmvfc_tgt_move_login_done(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_target *tgt = evt->tgt;
+	struct ibmvfc_host *vhost = evt->vhost;
+	struct ibmvfc_move_login *rsp = &evt->xfer_iu->move_login;
+	u32 status = be16_to_cpu(rsp->common.status);
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
+
+	vhost->discovery_threads--;
+	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+	switch (status) {
+	case IBMVFC_MAD_SUCCESS:
+		tgt_dbg(tgt, "Move Login succeeded for old scsi_id: %llX\n", tgt->old_scsi_id);
+		tgt->ids.node_name = wwn_to_u64(rsp->service_parms.node_name);
+		tgt->ids.port_name = wwn_to_u64(rsp->service_parms.port_name);
+		tgt->ids.port_id = tgt->scsi_id;
+		memcpy(&tgt->service_parms, &rsp->service_parms,
+		       sizeof(tgt->service_parms));
+		memcpy(&tgt->service_parms_change, &rsp->service_parms_change,
+		       sizeof(tgt->service_parms_change));
+		ibmvfc_init_tgt(tgt, ibmvfc_tgt_send_prli);
+		break;
+	case IBMVFC_MAD_DRIVER_FAILED:
+		break;
+	case IBMVFC_MAD_CRQ_ERROR:
+		ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_move_login);
+		break;
+	case IBMVFC_MAD_FAILED:
+	default:
+		level += ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_move_login);
+
+		tgt_log(tgt, level, "Move Login failed: old scsi_id: %llX, flags:%x, vios_flags:%x, rc=0x%02X\n",
+			tgt->old_scsi_id, be32_to_cpu(rsp->flags), be16_to_cpu(rsp->vios_flags), status);
+		break;
+	}
+
+	kref_put(&tgt->kref, ibmvfc_release_tgt);
+	ibmvfc_free_event(evt);
+	wake_up(&vhost->work_wait_q);
+}
+
+
+/**
+ * ibmvfc_tgt_move_login - Initiate a move login for specified target
+ * @tgt:		ibmvfc target struct
+ *
+ **/
+static void ibmvfc_tgt_move_login(struct ibmvfc_target *tgt)
+{
+	struct ibmvfc_host *vhost = tgt->vhost;
+	struct ibmvfc_move_login *move;
+	struct ibmvfc_event *evt;
+
+	if (vhost->discovery_threads >= disc_threads)
+		return;
+
+	kref_get(&tgt->kref);
+	evt = ibmvfc_get_event(vhost);
+	vhost->discovery_threads++;
+	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
+	ibmvfc_init_event(evt, ibmvfc_tgt_move_login_done, IBMVFC_MAD_FORMAT);
+	evt->tgt = tgt;
+	move = &evt->iu.move_login;
+	memset(move, 0, sizeof(*move));
+	move->common.version = cpu_to_be32(1);
+	move->common.opcode = cpu_to_be32(IBMVFC_MOVE_LOGIN);
+	move->common.length = cpu_to_be16(sizeof(*move));
+
+	move->old_scsi_id = cpu_to_be64(tgt->old_scsi_id);
+	move->new_scsi_id = cpu_to_be64(tgt->scsi_id);
+	move->wwpn = cpu_to_be64(tgt->wwpn);
+	move->node_name = cpu_to_be64(tgt->ids.node_name);
+
+	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
+		vhost->discovery_threads--;
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+	} else
+		tgt_dbg(tgt, "Sent Move Login for old scsi_id: %llX\n", tgt->old_scsi_id);
+}
+
+/**
  * ibmvfc_adisc_needs_plogi - Does device need PLOGI?
  * @mad:	ibmvfc passthru mad struct
  * @tgt:	ibmvfc target struct
@@ -3979,24 +4111,62 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_target *tgt)
  * Returns:
  *	0 on success / other on failure
  **/
-static int ibmvfc_alloc_target(struct ibmvfc_host *vhost, u64 scsi_id)
+static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,struct ibmvfc_discover_targets_entry *target)
 {
+	struct ibmvfc_target *stgt = NULL;
+	struct ibmvfc_target *wtgt = NULL;
 	struct ibmvfc_target *tgt;
 	unsigned long flags;
+	u64 scsi_id = be32_to_cpu(target->scsi_id) & IBMVFC_DISC_TGT_SCSI_ID_MASK;
+	u64 wwpn = be64_to_cpu(target->wwpn);
 
+	/* Look to see if we already have a target allocated for this SCSI ID or WWPN */
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	list_for_each_entry(tgt, &vhost->targets, queue) {
+		if (tgt->wwpn == wwpn) {
+			wtgt = tgt;
+			break;
+		}
+	}
+
+	list_for_each_entry(tgt, &vhost->targets, queue) {
 		if (tgt->scsi_id == scsi_id) {
-			if (tgt->need_login)
-				ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
+			stgt = tgt;
+			break;
+		}
+	}
+
+	if (wtgt && !stgt) {
+		/* A WWPN target has moved and we still are tracking the old SCSI ID.
+		 The only way we should be able to get here is if we attempted to
+		 send an implicit logout for the old SCSI ID and it failed for some
+		 reason, such as there being I/O pending to the target. In this
+		 case, we will have already deleted the rport from the FC transport
+		 so we do a move login, which works even with I/O pending, as it
+		 will cancel any active commands. */
+		if (wtgt->action == IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT) {
+			/* Do a move login here. The old target is no longer known to the transport layer
+			 We don't use the normal ibmvfc_set_tgt_action to set this, as
+			 we don't normally want to allow this state change */
+			wtgt->old_scsi_id = wtgt->scsi_id;
+			wtgt->scsi_id = scsi_id;
+			wtgt->action = IBMVFC_TGT_ACTION_INIT;
+			ibmvfc_init_tgt(wtgt, ibmvfc_tgt_move_login);
 			goto unlock_out;
+		} else {
+			tgt_err(wtgt, "Unexpected target state: %d, %p\n", wtgt->action, wtgt->rport);
 		}
+	} else if (stgt) {
+		if (tgt->need_login)
+			ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
+		goto unlock_out;
 	}
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
 	tgt = mempool_alloc(vhost->tgt_pool, GFP_NOIO);
 	memset(tgt, 0, sizeof(*tgt));
 	tgt->scsi_id = scsi_id;
+	tgt->wwpn = wwpn;
 	tgt->vhost = vhost;
 	tgt->need_login = 1;
 	tgt->cancel_key = vhost->task_set++;
@@ -4023,9 +4193,7 @@ static int ibmvfc_alloc_targets(struct ibmvfc_host *vhost)
 	int i, rc;
 
 	for (i = 0, rc = 0; !rc && i < vhost->num_targets; i++)
-		rc = ibmvfc_alloc_target(vhost,
-					 be32_to_cpu(vhost->disc_buf->scsi_id[i]) &
-					 IBMVFC_DISC_TGT_SCSI_ID_MASK);
+		rc = ibmvfc_alloc_target(vhost, &vhost->disc_buf[i]);
 
 	return rc;
 }
@@ -4085,6 +4253,7 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 	mad->bufflen = cpu_to_be32(vhost->disc_buf_sz);
 	mad->buffer.va = cpu_to_be64(vhost->disc_buf_dma);
 	mad->buffer.len = cpu_to_be32(vhost->disc_buf_sz);
+	mad->flags = cpu_to_be32(IBMVFC_DISC_TGT_PORT_ID_WWPN_LIST);
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
 
 	if (!ibmvfc_send_event(evt, vhost, default_timeout))
@@ -4420,6 +4589,13 @@ static void ibmvfc_tgt_add_rport(struct ibmvfc_target *tgt)
 		del_timer_sync(&tgt->timer);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
 		return;
+	} else if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
+		tgt_dbg(tgt, "Deleting rport with outstanding I/O\n");
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
+		tgt->rport = NULL;
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		fc_remote_port_delete(rport);
+		return;
 	} else if (rport && tgt->action == IBMVFC_TGT_ACTION_DELETED_RPORT) {
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 		return;
@@ -4543,6 +4719,15 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 				del_timer_sync(&tgt->timer);
 				kref_put(&tgt->kref, ibmvfc_release_tgt);
 				return;
+			} else if (tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
+				tgt_dbg(tgt, "Deleting rport with I/O outstanding\n");
+				rport = tgt->rport;
+				tgt->rport = NULL;
+				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
+				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				if (rport)
+					fc_remote_port_delete(rport);
+				return;
 			}
 		}
 
@@ -4775,7 +4960,7 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 		goto free_sg_pool;
 	}
 
-	vhost->disc_buf_sz = sizeof(vhost->disc_buf->scsi_id[0]) * max_targets;
+	vhost->disc_buf_sz = sizeof(*vhost->disc_buf) * max_targets;
 	vhost->disc_buf = dma_alloc_coherent(dev, vhost->disc_buf_sz,
 					     &vhost->disc_buf_dma, GFP_KERNEL);
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index e6e1c25..6a21ac3 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -120,6 +120,7 @@ enum ibmvfc_mad_types {
 	IBMVFC_PORT_LOGIN		= 0x0004,
 	IBMVFC_PROCESS_LOGIN	= 0x0008,
 	IBMVFC_QUERY_TARGET	= 0x0010,
+	IBMVFC_MOVE_LOGIN		= 0x0020,
 	IBMVFC_IMPLICIT_LOGOUT	= 0x0040,
 	IBMVFC_PASSTHRU		= 0x0200,
 	IBMVFC_TMF_MAD		= 0x0100,
@@ -197,6 +198,7 @@ struct ibmvfc_service_parms {
 	__be32 ext_len;
 	__be32 reserved[30];
 	__be32 clk_sync_qos[2];
+	__be32 reserved2;
 } __packed __aligned(4);
 
 struct ibmvfc_npiv_login_resp {
@@ -230,15 +232,18 @@ struct ibmvfc_npiv_login_resp {
 	struct ibmvfc_npiv_login_resp resp;
 } __packed __aligned(8);
 
-struct ibmvfc_discover_targets_buf {
-	__be32 scsi_id[1];
+struct ibmvfc_discover_targets_entry {
+	__be32 scsi_id;
+	__be32 pad;
+	__be64 wwpn;
 #define IBMVFC_DISC_TGT_SCSI_ID_MASK	0x00ffffff
-};
+}__packed __aligned(8);
 
 struct ibmvfc_discover_targets {
 	struct ibmvfc_mad_common common;
 	struct srp_direct_buf buffer;
 	__be32 flags;
+#define IBMVFC_DISC_TGT_PORT_ID_WWPN_LIST	0x02
 	__be16 status;
 	__be16 error;
 	__be32 bufflen;
@@ -291,6 +296,26 @@ struct ibmvfc_port_login {
 	__be64 reserved3[2];
 } __packed __aligned(8);
 
+struct ibmvfc_move_login {
+	struct ibmvfc_mad_common common;
+	__be64 old_scsi_id;
+	__be64 new_scsi_id;
+	__be64 wwpn;
+	__be64 node_name;
+	__be32 flags;
+#define IBMVFC_MOVE_LOGIN_IMPLICIT_OLD_FAILED	0x01
+#define IBMVFC_MOVE_LOGIN_IMPLICIT_NEW_FAILED	0x02
+#define IBMVFC_MOVE_LOGIN_PORT_LOGIN_FAILED	0x04
+	__be32 reserved;
+	struct ibmvfc_service_parms service_parms;
+	struct ibmvfc_service_parms service_parms_change;
+	__be32 reserved2;
+	__be16 service_class;
+	__be16 vios_flags;
+#define IBMVFC_MOVE_LOGIN_VF_NOT_SENT_ADAPTER	0x01
+	__be64 reserved3;
+}__packed __aligned(8);
+
 struct ibmvfc_prli_svc_parms {
 	u8 type;
 #define IBMVFC_SCSI_FCP_TYPE		0x08
@@ -646,6 +671,7 @@ struct ibmvfc_async_crq_queue {
 	struct ibmvfc_discover_targets discover_targets;
 	struct ibmvfc_port_login plogi;
 	struct ibmvfc_process_login prli;
+	struct ibmvfc_move_login move_login;
 	struct ibmvfc_query_tgt query_tgt;
 	struct ibmvfc_implicit_logout implicit_logout;
 	struct ibmvfc_tmf tmf;
@@ -664,12 +690,16 @@ enum ibmvfc_target_action {
 	IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT,
 	IBMVFC_TGT_ACTION_DEL_RPORT,
 	IBMVFC_TGT_ACTION_DELETED_RPORT,
+	IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT,
+	IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT,
 };
 
 struct ibmvfc_target {
 	struct list_head queue;
 	struct ibmvfc_host *vhost;
 	u64 scsi_id;
+	u64 wwpn;
+	u64 old_scsi_id;
 	struct fc_rport *rport;
 	int target_id;
 	enum ibmvfc_target_action action;
@@ -765,7 +795,7 @@ struct ibmvfc_host {
 	dma_addr_t login_buf_dma;
 	int disc_buf_sz;
 	int log_level;
-	struct ibmvfc_discover_targets_buf *disc_buf;
+	struct ibmvfc_discover_targets_entry *disc_buf;
 	struct mutex passthru_mutex;
 	int task_set;
 	int init_retries;
-- 
1.8.3.1

