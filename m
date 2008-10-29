From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/6] ibmvfc: Fix target initialization failure retry handling
Date: Wed, 29 Oct 2008 08:46:45 -0500
Message-ID: <200810291346.m9TDkigX029947@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38026 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbYJ2NrP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2008 09:47:15 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9TDkHwE023832
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 07:46:17 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9TDlFDf048982
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 07:47:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9TDkjJU030042
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 07:46:46 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If the ibmvfc driver is in discovery attempting to log into a target and
it encounters an error, the command may get retried one or more times, depending
on the error received. If the retries are unsuccessful such that the discovery
thread gives up on discovery to that target, the target ends up in a state where,
if SCSI core had previously known about the device, the host will get unblocked
but the host will not be logged into the target, causing any commands sent to
the target to fail. This patch fixes this so that if this occurs, the target
is deleted such that the normal dev_loss processing can occur instead.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   42 +++++++++++++++++++++--------------------
 drivers/scsi/ibmvscsi/ibmvfc.h |    1 
 2 files changed, 23 insertions(+), 20 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_tgt_init_retry_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_tgt_init_retry_fix	2008-10-27 09:44:12.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-10-27 09:44:12.000000000 -0500
@@ -496,6 +496,7 @@ static void ibmvfc_set_host_action(struc
 	case IBMVFC_HOST_ACTION_INIT:
 	case IBMVFC_HOST_ACTION_TGT_DEL:
 	case IBMVFC_HOST_ACTION_QUERY_TGTS:
+	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
 	case IBMVFC_HOST_ACTION_TGT_ADD:
 	case IBMVFC_HOST_ACTION_NONE:
 	default:
@@ -2791,6 +2792,8 @@ static void ibmvfc_tgt_prli_done(struct 
 			rsp->status, rsp->error, status);
 		if (ibmvfc_retry_cmd(rsp->status, rsp->error))
 			ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_prli);
+		else
+			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		break;
 	};
 
@@ -2885,6 +2888,8 @@ static void ibmvfc_tgt_plogi_done(struct
 
 		if (ibmvfc_retry_cmd(rsp->status, rsp->error))
 			ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_plogi);
+		else
+			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		break;
 	};
 
@@ -3176,6 +3181,8 @@ static void ibmvfc_tgt_query_target_done
 			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		else if (ibmvfc_retry_cmd(rsp->status, rsp->error))
 			ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_query_target);
+		else
+			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		break;
 	};
 
@@ -3506,6 +3513,7 @@ static int __ibmvfc_work_to_do(struct ib
 	case IBMVFC_HOST_ACTION_ALLOC_TGTS:
 	case IBMVFC_HOST_ACTION_TGT_ADD:
 	case IBMVFC_HOST_ACTION_TGT_DEL:
+	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
 	case IBMVFC_HOST_ACTION_QUERY:
 	default:
 		break;
@@ -3621,6 +3629,7 @@ static void ibmvfc_do_work(struct ibmvfc
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_DEL);
 		break;
 	case IBMVFC_HOST_ACTION_TGT_DEL:
+	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
 		list_for_each_entry(tgt, &vhost->targets, queue) {
 			if (tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
 				tgt_dbg(tgt, "Deleting rport\n");
@@ -3636,8 +3645,17 @@ static void ibmvfc_do_work(struct ibmvfc
 		}
 
 		if (vhost->state == IBMVFC_INITIALIZING) {
-			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
-			vhost->job_step = ibmvfc_discover_targets;
+			if (vhost->action == IBMVFC_HOST_ACTION_TGT_DEL_FAILED) {
+				ibmvfc_set_host_state(vhost, IBMVFC_ACTIVE);
+				ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_ADD);
+				vhost->init_retries = 0;
+				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				scsi_unblock_requests(vhost->host);
+				return;
+			} else {
+				ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
+				vhost->job_step = ibmvfc_discover_targets;
+			}
 		} else {
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
 			spin_unlock_irqrestore(vhost->host->host_lock, flags);
@@ -3660,14 +3678,8 @@ static void ibmvfc_do_work(struct ibmvfc
 			}
 		}
 
-		if (!ibmvfc_dev_init_to_do(vhost)) {
-			ibmvfc_set_host_state(vhost, IBMVFC_ACTIVE);
-			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_ADD);
-			vhost->init_retries = 0;
-			spin_unlock_irqrestore(vhost->host->host_lock, flags);
-			scsi_unblock_requests(vhost->host);
-			return;
-		}
+		if (!ibmvfc_dev_init_to_do(vhost))
+			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_DEL_FAILED);
 		break;
 	case IBMVFC_HOST_ACTION_TGT_ADD:
 		list_for_each_entry(tgt, &vhost->targets, queue) {
@@ -3675,16 +3687,6 @@ static void ibmvfc_do_work(struct ibmvfc
 				spin_unlock_irqrestore(vhost->host->host_lock, flags);
 				ibmvfc_tgt_add_rport(tgt);
 				return;
-			} else if (tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
-				tgt_dbg(tgt, "Deleting rport\n");
-				rport = tgt->rport;
-				tgt->rport = NULL;
-				list_del(&tgt->queue);
-				spin_unlock_irqrestore(vhost->host->host_lock, flags);
-				if (rport)
-					fc_remote_port_delete(rport);
-				kref_put(&tgt->kref, ibmvfc_release_tgt);
-				return;
 			}
 		}
 
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_tgt_init_retry_fix drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_tgt_init_retry_fix	2008-10-27 09:44:12.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-10-27 09:44:12.000000000 -0500
@@ -626,6 +626,7 @@ enum ibmvfc_host_action {
 	IBMVFC_HOST_ACTION_TGT_DEL,
 	IBMVFC_HOST_ACTION_ALLOC_TGTS,
 	IBMVFC_HOST_ACTION_TGT_INIT,
+	IBMVFC_HOST_ACTION_TGT_DEL_FAILED,
 	IBMVFC_HOST_ACTION_TGT_ADD,
 };
 
_
