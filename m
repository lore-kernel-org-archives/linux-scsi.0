From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 05/10] ibmvfc: Fix deadlock in EH
Date: Thu, 28 May 2009 16:17:28 -0500
Message-ID: <200905282117.n4SLHTPl001169@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:35425 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764035AbZE1VRq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 17:17:46 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e38.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n4SLEv44001258
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:14:57 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4SLHUG5128166
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:17:32 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4SLHT0q001172
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:17:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Fixes the following deadlock scenario shown below. We currently allow
queuecommand to send commands when the ibmvfc workqueue is scanning for
new rports, so we should also allow EH to function at this time as well.


scsi_eh_3     D 0000000000000000 12304  1279      2
Call Trace:
[c0000002f7257730] [c0000002f72577e0] 0xc0000002f72577e0 (unreliable)
[c0000002f7257900] [c0000000000118f4] .__switch_to+0x158/0x1a0
[c0000002f72579a0] [c0000000004f8b40] .schedule+0x8d4/0x9dc
[c0000002f7257b60] [c0000000004f8f08] .schedule_timeout+0xa8/0xe8
[c0000002f7257c50] [d0000000001d23e0] .ibmvfc_wait_while_resetting+0xe4/0x140 [ibmvfc]
[c0000002f7257d20] [d0000000001d3984] .ibmvfc_eh_abort_handler+0x60/0xe4 [ibmvfc]
[c0000002f7257dc0] [d000000000366714] .scsi_error_handler+0x38c/0x674 [scsi_mod]
[c0000002f7257f00] [c0000000000a7470] .kthread+0x78/0xc4
[c0000002f7257f90] [c000000000029b8c] .kernel_thread+0x4c/0x68
ibmvfc_3      D 0000000000000000 12432  1280      2
Call Trace:
[c0000002f7253540] [c0000002f72535f0] 0xc0000002f72535f0 (unreliable)
[c0000002f7253710] [c0000000000118f4] .__switch_to+0x158/0x1a0
[c0000002f72537b0] [c0000000004f8b40] .schedule+0x8d4/0x9dc
[c0000002f7253970] [c0000000004f8e98] .schedule_timeout+0x38/0xe8
[c0000002f7253a60] [c0000000004f80cc] .wait_for_common+0x138/0x220
[c0000002f7253b40] [c0000000000a2784] .flush_cpu_workqueue+0xac/0xcc
[c0000002f7253c10] [c0000000000a2960] .flush_workqueue+0x58/0xa0
[c0000002f7253ca0] [d0000000000827fc] .fc_flush_work+0x4c/0x64 [scsi_transport_fc]
[c0000002f7253d20] [d000000000082db4] .fc_remote_port_add+0x48/0x6c4 [scsi_transport_fc]
[c0000002f7253dd0] [d0000000001d7d04] .ibmvfc_work+0x820/0xa7c [ibmvfc]
[c0000002f7253f00] [c0000000000a7470] .kthread+0x78/0xc4
[c0000002f7253f90] [c000000000029b8c] .kernel_thread+0x4c/0x68
fc_wq_3       D 0000000000000000 10720  1283      2
Call Trace:
[c0000002f559ac30] [c0000002f559ace0] 0xc0000002f559ace0 (unreliable)
[c0000002f559ae00] [c0000000000118f4] .__switch_to+0x158/0x1a0
[c0000002f559aea0] [c0000000004f8b40] .schedule+0x8d4/0x9dc
[c0000002f559b060] [c0000000004f8e98] .schedule_timeout+0x38/0xe8
[c0000002f559b150] [c0000000004f80cc] .wait_for_common+0x138/0x220
[c0000002f559b230] [c0000000002721c4] .blk_execute_rq+0xb4/0x100
[c0000002f559b360] [d00000000036a1f8] .scsi_execute+0x118/0x194 [scsi_mod]
[c0000002f559b420] [d00000000036a32c] .scsi_execute_req+0xb8/0x124 [scsi_mod]
[c0000002f559b500] [d0000000000c1330] .sd_sync_cache+0x8c/0x108 [sd_mod]
[c0000002f559b5e0] [d0000000000c15b4] .sd_shutdown+0x9c/0x158 [sd_mod]
[c0000002f559b660] [d0000000000c16d0] .sd_remove+0x60/0xb4 [sd_mod]
[c0000002f559b700] [c000000000392ecc] .__device_release_driver+0xd0/0x118
[c0000002f559b7a0] [c000000000393080] .device_release_driver+0x30/0x54
[c0000002f559b830] [c000000000392108] .bus_remove_device+0x128/0x16c
[c0000002f559b8d0] [c00000000038f94c] .device_del+0x158/0x234
[c0000002f559b960] [d00000000036f078] .__scsi_remove_device+0x5c/0xd4 [scsi_mod]
[c0000002f559b9f0] [d00000000036f124] .scsi_remove_device+0x34/0x58 [scsi_mod]
[c0000002f559ba80] [d00000000036f204] .__scsi_remove_target+0xb4/0x120 [scsi_mod]
[c0000002f559bb10] [d00000000036f338] .__remove_child+0x2c/0x44 [scsi_mod]
[c0000002f559bb90] [c00000000038f11c] .device_for_each_child+0x54/0xb4
[c0000002f559bc50] [d00000000036f2e0] .scsi_remove_target+0x70/0x9c [scsi_mod]
[c0000002f559bce0] [d000000000083454] .fc_starget_delete+0x24/0x3c [scsi_transport_fc]
[c0000002f559bd70] [c0000000000a2368] .run_workqueue+0x118/0x208
[c0000002f559be30] [c0000000000a2580] .worker_thread+0x128/0x154
[c0000002f559bf00] [c0000000000a7470] .kthread+0x78/0xc4
[c0000002f559bf90] [c000000000029b8c] .kernel_thread+0x4c/0x68

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |  122 +++++++++++++++++++++++++++--------------
 drivers/scsi/ibmvscsi/ibmvfc.h |    5 +
 2 files changed, 86 insertions(+), 41 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_eh_deadlock drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_eh_deadlock	2009-03-31 08:46:11.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-03-31 08:46:11.000000000 -0500
@@ -431,6 +431,8 @@ static void ibmvfc_set_tgt_action(struct
 	case IBMVFC_TGT_ACTION_DEL_RPORT:
 		break;
 	default:
+		if (action == IBMVFC_TGT_ACTION_DEL_RPORT)
+			tgt->add_rport = 0;
 		tgt->action = action;
 		break;
 	}
@@ -483,7 +485,7 @@ static void ibmvfc_set_host_action(struc
 		switch (vhost->action) {
 		case IBMVFC_HOST_ACTION_INIT_WAIT:
 		case IBMVFC_HOST_ACTION_NONE:
-		case IBMVFC_HOST_ACTION_TGT_ADD:
+		case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
 			vhost->action = action;
 			break;
 		default:
@@ -498,7 +500,6 @@ static void ibmvfc_set_host_action(struc
 	case IBMVFC_HOST_ACTION_TGT_DEL:
 	case IBMVFC_HOST_ACTION_QUERY_TGTS:
 	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
-	case IBMVFC_HOST_ACTION_TGT_ADD:
 	case IBMVFC_HOST_ACTION_NONE:
 	default:
 		vhost->action = action;
@@ -2306,7 +2307,7 @@ static int ibmvfc_scan_finished(struct S
 		done = 1;
 	}
 
-	if (vhost->state != IBMVFC_NO_CRQ && vhost->action == IBMVFC_HOST_ACTION_NONE)
+	if (vhost->scan_complete)
 		done = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return done;
@@ -2820,7 +2821,7 @@ static void ibmvfc_tgt_prli_done(struct 
 						tgt->ids.roles |= FC_PORT_ROLE_FCP_TARGET;
 					if (parms->service_parms & IBMVFC_PRLI_INITIATOR_FUNC)
 						tgt->ids.roles |= FC_PORT_ROLE_FCP_INITIATOR;
-					ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_ADD_RPORT);
+					tgt->add_rport = 1;
 				} else
 					ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 			} else if (prli_rsp[index].retry)
@@ -3660,7 +3661,6 @@ static int __ibmvfc_work_to_do(struct ib
 		return 1;
 	case IBMVFC_HOST_ACTION_INIT:
 	case IBMVFC_HOST_ACTION_ALLOC_TGTS:
-	case IBMVFC_HOST_ACTION_TGT_ADD:
 	case IBMVFC_HOST_ACTION_TGT_DEL:
 	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
 	case IBMVFC_HOST_ACTION_QUERY:
@@ -3715,25 +3715,26 @@ static void ibmvfc_log_ae(struct ibmvfc_
 static void ibmvfc_tgt_add_rport(struct ibmvfc_target *tgt)
 {
 	struct ibmvfc_host *vhost = tgt->vhost;
-	struct fc_rport *rport = tgt->rport;
+	struct fc_rport *rport;
 	unsigned long flags;
 
-	if (rport) {
-		tgt_dbg(tgt, "Setting rport roles\n");
-		fc_remote_port_rolechg(rport, tgt->ids.roles);
-		spin_lock_irqsave(vhost->host->host_lock, flags);
-		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+	tgt_dbg(tgt, "Adding rport\n");
+	rport = fc_remote_port_add(vhost->host, 0, &tgt->ids);
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+
+	if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
+		tgt_dbg(tgt, "Deleting rport\n");
+		list_del(&tgt->queue);
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		fc_remote_port_delete(rport);
+		del_timer_sync(&tgt->timer);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
 		return;
 	}
 
-	tgt_dbg(tgt, "Adding rport\n");
-	rport = fc_remote_port_add(vhost->host, 0, &tgt->ids);
-	spin_lock_irqsave(vhost->host->host_lock, flags);
-	tgt->rport = rport;
-	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 	if (rport) {
 		tgt_dbg(tgt, "rport add succeeded\n");
+		tgt->rport = rport;
 		rport->maxframe_size = tgt->service_parms.common.bb_rcv_sz & 0x0fff;
 		rport->supported_classes = 0;
 		tgt->target_id = rport->scsi_target_id;
@@ -3811,11 +3812,21 @@ static void ibmvfc_do_work(struct ibmvfc
 
 		if (vhost->state == IBMVFC_INITIALIZING) {
 			if (vhost->action == IBMVFC_HOST_ACTION_TGT_DEL_FAILED) {
-				ibmvfc_set_host_state(vhost, IBMVFC_ACTIVE);
-				ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_ADD);
-				vhost->init_retries = 0;
-				spin_unlock_irqrestore(vhost->host->host_lock, flags);
-				scsi_unblock_requests(vhost->host);
+				if (vhost->reinit) {
+					vhost->reinit = 0;
+					scsi_block_requests(vhost->host);
+					ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
+					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				} else {
+					ibmvfc_set_host_state(vhost, IBMVFC_ACTIVE);
+					ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
+					wake_up(&vhost->init_wait_q);
+					schedule_work(&vhost->rport_add_work_q);
+					vhost->init_retries = 0;
+					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					scsi_unblock_requests(vhost->host);
+				}
+
 				return;
 			} else {
 				ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
@@ -3846,24 +3857,6 @@ static void ibmvfc_do_work(struct ibmvfc
 		if (!ibmvfc_dev_init_to_do(vhost))
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_DEL_FAILED);
 		break;
-	case IBMVFC_HOST_ACTION_TGT_ADD:
-		list_for_each_entry(tgt, &vhost->targets, queue) {
-			if (tgt->action == IBMVFC_TGT_ACTION_ADD_RPORT) {
-				spin_unlock_irqrestore(vhost->host->host_lock, flags);
-				ibmvfc_tgt_add_rport(tgt);
-				return;
-			}
-		}
-
-		if (vhost->reinit && !ibmvfc_set_host_state(vhost, IBMVFC_INITIALIZING)) {
-			vhost->reinit = 0;
-			scsi_block_requests(vhost->host);
-			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
-		} else {
-			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
-			wake_up(&vhost->init_wait_q);
-		}
-		break;
 	default:
 		break;
 	};
@@ -4093,6 +4086,56 @@ nomem:
 }
 
 /**
+ * ibmvfc_rport_add_thread - Worker thread for rport adds
+ * @work:	work struct
+ *
+ **/
+static void ibmvfc_rport_add_thread(struct work_struct *work)
+{
+	struct ibmvfc_host *vhost = container_of(work, struct ibmvfc_host,
+						 rport_add_work_q);
+	struct ibmvfc_target *tgt;
+	struct fc_rport *rport;
+	unsigned long flags;
+	int did_work;
+
+	ENTER;
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	do {
+		did_work = 0;
+		if (vhost->state != IBMVFC_ACTIVE)
+			break;
+
+		list_for_each_entry(tgt, &vhost->targets, queue) {
+			if (tgt->add_rport) {
+				did_work = 1;
+				tgt->add_rport = 0;
+				kref_get(&tgt->kref);
+				rport = tgt->rport;
+				if (!rport) {
+					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					ibmvfc_tgt_add_rport(tgt);
+				} else if (get_device(&rport->dev)) {
+					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					tgt_dbg(tgt, "Setting rport roles\n");
+					fc_remote_port_rolechg(rport, tgt->ids.roles);
+					put_device(&rport->dev);
+				}
+
+				kref_put(&tgt->kref, ibmvfc_release_tgt);
+				spin_lock_irqsave(vhost->host->host_lock, flags);
+				break;
+			}
+		}
+	} while(did_work);
+
+	if (vhost->state == IBMVFC_ACTIVE)
+		vhost->scan_complete = 1;
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	LEAVE;
+}
+
+/**
  * ibmvfc_probe - Adapter hot plug add entry point
  * @vdev:	vio device struct
  * @id:	vio device id struct
@@ -4135,6 +4178,7 @@ static int ibmvfc_probe(struct vio_dev *
 	strcpy(vhost->partition_name, "UNKNOWN");
 	init_waitqueue_head(&vhost->work_wait_q);
 	init_waitqueue_head(&vhost->init_wait_q);
+	INIT_WORK(&vhost->rport_add_work_q, ibmvfc_rport_add_thread);
 
 	if ((rc = ibmvfc_alloc_mem(vhost)))
 		goto free_scsi_host;
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_fix_eh_deadlock drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_fix_eh_deadlock	2009-03-31 08:46:11.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2009-03-31 08:46:11.000000000 -0500
@@ -575,7 +575,6 @@ enum ibmvfc_target_action {
 	IBMVFC_TGT_ACTION_NONE = 0,
 	IBMVFC_TGT_ACTION_INIT,
 	IBMVFC_TGT_ACTION_INIT_WAIT,
-	IBMVFC_TGT_ACTION_ADD_RPORT,
 	IBMVFC_TGT_ACTION_DEL_RPORT,
 };
 
@@ -588,6 +587,7 @@ struct ibmvfc_target {
 	int target_id;
 	enum ibmvfc_target_action action;
 	int need_login;
+	int add_rport;
 	int init_retries;
 	u32 cancel_key;
 	struct ibmvfc_service_parms service_parms;
@@ -635,7 +635,6 @@ enum ibmvfc_host_action {
 	IBMVFC_HOST_ACTION_ALLOC_TGTS,
 	IBMVFC_HOST_ACTION_TGT_INIT,
 	IBMVFC_HOST_ACTION_TGT_DEL_FAILED,
-	IBMVFC_HOST_ACTION_TGT_ADD,
 };
 
 enum ibmvfc_host_state {
@@ -682,6 +681,7 @@ struct ibmvfc_host {
 	int client_migrated;
 	int reinit;
 	int delay_init;
+	int scan_complete;
 	int events_to_log;
 #define IBMVFC_AE_LINKUP	0x0001
 #define IBMVFC_AE_LINKDOWN	0x0002
@@ -692,6 +692,7 @@ struct ibmvfc_host {
 	void (*job_step) (struct ibmvfc_host *);
 	struct task_struct *work_thread;
 	struct tasklet_struct tasklet;
+	struct work_struct rport_add_work_q;
 	wait_queue_head_t init_wait_q;
 	wait_queue_head_t work_wait_q;
 };
_
