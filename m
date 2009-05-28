From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 04/10] ibmvfc: Reduce error logging noise
Date: Thu, 28 May 2009 16:17:26 -0500
Message-ID: <200905282117.n4SLHQWs025450@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:40519 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763686AbZE1VRd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 17:17:33 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e37.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n4SLGtjv010064
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:16:55 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4SLHVm6215842
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:17:31 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4SLHRfc025518
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:17:28 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The ibmvfc driver currently logs errors during discovery for several
transient fabric errors, which generally get retried. If retries
do not work, we see multiple errors in the log. If retries do work,
we see errors in the log which may be confusing since the retry worked.
This patch enhances the discovery time error logging to only log errors
for command failures during discovery if all allowed retries have been
used up. The existing behavior of logging all failures can be restored
by setting the hosts log_level to a value of 3 or greater.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   68 +++++++++++++++++++++++++----------------
 drivers/scsi/ibmvscsi/ibmvfc.h |    6 +++
 2 files changed, 48 insertions(+), 26 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_no_log_on_retry drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_no_log_on_retry	2009-03-31 08:46:08.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-03-31 08:46:08.000000000 -0500
@@ -842,9 +842,13 @@ static void ibmvfc_reset_host(struct ibm
  * ibmvfc_retry_host_init - Retry host initialization if allowed
  * @vhost:	ibmvfc host struct
  *
+ * Returns: 1 if init will be retried / 0 if not
+ *
  **/
-static void ibmvfc_retry_host_init(struct ibmvfc_host *vhost)
+static int ibmvfc_retry_host_init(struct ibmvfc_host *vhost)
 {
+	int retry = 0;
+
 	if (vhost->action == IBMVFC_HOST_ACTION_INIT_WAIT) {
 		vhost->delay_init = 1;
 		if (++vhost->init_retries > IBMVFC_MAX_HOST_INIT_RETRIES) {
@@ -853,11 +857,14 @@ static void ibmvfc_retry_host_init(struc
 			ibmvfc_link_down(vhost, IBMVFC_HOST_OFFLINE);
 		} else if (vhost->init_retries == IBMVFC_MAX_HOST_INIT_RETRIES)
 			__ibmvfc_reset_host(vhost);
-		else
+		else {
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
+			retry = 1;
+		}
 	}
 
 	wake_up(&vhost->work_wait_q);
+	return retry;
 }
 
 /**
@@ -2733,15 +2740,19 @@ static void ibmvfc_init_tgt(struct ibmvf
  * @tgt:		ibmvfc target struct
  * @job_step:	initialization job step
  *
+ * Returns: 1 if step will be retried / 0 if not
+ *
  **/
-static void ibmvfc_retry_tgt_init(struct ibmvfc_target *tgt,
+static int ibmvfc_retry_tgt_init(struct ibmvfc_target *tgt,
 				  void (*job_step) (struct ibmvfc_target *))
 {
 	if (++tgt->init_retries > IBMVFC_MAX_TGT_INIT_RETRIES) {
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		wake_up(&tgt->vhost->work_wait_q);
+		return 0;
 	} else
 		ibmvfc_init_tgt(tgt, job_step);
+	return 1;
 }
 
 /* Defined in FC-LS */
@@ -2790,7 +2801,7 @@ static void ibmvfc_tgt_prli_done(struct 
 	struct ibmvfc_process_login *rsp = &evt->xfer_iu->prli;
 	struct ibmvfc_prli_svc_parms *parms = &rsp->parms;
 	u32 status = rsp->common.status;
-	int index;
+	int index, level = IBMVFC_DEFAULT_LOG_LEVEL;
 
 	vhost->discovery_threads--;
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
@@ -2826,13 +2837,14 @@ static void ibmvfc_tgt_prli_done(struct 
 		break;
 	case IBMVFC_MAD_FAILED:
 	default:
-		tgt_err(tgt, "Process Login failed: %s (%x:%x) rc=0x%02X\n",
-			ibmvfc_get_cmd_error(rsp->status, rsp->error),
-			rsp->status, rsp->error, status);
 		if (ibmvfc_retry_cmd(rsp->status, rsp->error))
-			ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_prli);
+			level += ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_prli);
 		else
 			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+
+		tgt_log(tgt, level, "Process Login failed: %s (%x:%x) rc=0x%02X\n",
+			ibmvfc_get_cmd_error(rsp->status, rsp->error),
+			rsp->status, rsp->error, status);
 		break;
 	};
 
@@ -2891,6 +2903,7 @@ static void ibmvfc_tgt_plogi_done(struct
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_port_login *rsp = &evt->xfer_iu->plogi;
 	u32 status = rsp->common.status;
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 
 	vhost->discovery_threads--;
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
@@ -2919,15 +2932,15 @@ static void ibmvfc_tgt_plogi_done(struct
 		break;
 	case IBMVFC_MAD_FAILED:
 	default:
-		tgt_err(tgt, "Port Login failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
-			ibmvfc_get_cmd_error(rsp->status, rsp->error), rsp->status, rsp->error,
-			ibmvfc_get_fc_type(rsp->fc_type), rsp->fc_type,
-			ibmvfc_get_ls_explain(rsp->fc_explain), rsp->fc_explain, status);
-
 		if (ibmvfc_retry_cmd(rsp->status, rsp->error))
-			ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_plogi);
+			level += ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_plogi);
 		else
 			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+
+		tgt_log(tgt, level, "Port Login failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
+			ibmvfc_get_cmd_error(rsp->status, rsp->error), rsp->status, rsp->error,
+			ibmvfc_get_fc_type(rsp->fc_type), rsp->fc_type,
+			ibmvfc_get_ls_explain(rsp->fc_explain), rsp->fc_explain, status);
 		break;
 	};
 
@@ -3281,6 +3294,7 @@ static void ibmvfc_tgt_query_target_done
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_query_tgt *rsp = &evt->xfer_iu->query_tgt;
 	u32 status = rsp->common.status;
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 
 	vhost->discovery_threads--;
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
@@ -3300,19 +3314,19 @@ static void ibmvfc_tgt_query_target_done
 		break;
 	case IBMVFC_MAD_FAILED:
 	default:
-		tgt_err(tgt, "Query Target failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
-			ibmvfc_get_cmd_error(rsp->status, rsp->error), rsp->status, rsp->error,
-			ibmvfc_get_fc_type(rsp->fc_type), rsp->fc_type,
-			ibmvfc_get_gs_explain(rsp->fc_explain), rsp->fc_explain, status);
-
 		if ((rsp->status & IBMVFC_FABRIC_MAPPED) == IBMVFC_FABRIC_MAPPED &&
 		    rsp->error == IBMVFC_UNABLE_TO_PERFORM_REQ &&
 		    rsp->fc_explain == IBMVFC_PORT_NAME_NOT_REG)
 			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		else if (ibmvfc_retry_cmd(rsp->status, rsp->error))
-			ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_query_target);
+			level += ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_query_target);
 		else
 			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
+
+		tgt_log(tgt, level, "Query Target failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
+			ibmvfc_get_cmd_error(rsp->status, rsp->error), rsp->status, rsp->error,
+			ibmvfc_get_fc_type(rsp->fc_type), rsp->fc_type,
+			ibmvfc_get_gs_explain(rsp->fc_explain), rsp->fc_explain, status);
 		break;
 	};
 
@@ -3431,6 +3445,7 @@ static void ibmvfc_discover_targets_done
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_discover_targets *rsp = &evt->xfer_iu->discover_targets;
 	u32 mad_status = rsp->common.status;
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
@@ -3439,9 +3454,9 @@ static void ibmvfc_discover_targets_done
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
 		break;
 	case IBMVFC_MAD_FAILED:
-		dev_err(vhost->dev, "Discover Targets failed: %s (%x:%x)\n",
-			ibmvfc_get_cmd_error(rsp->status, rsp->error), rsp->status, rsp->error);
-		ibmvfc_retry_host_init(vhost);
+		level += ibmvfc_retry_host_init(vhost);
+		ibmvfc_log(vhost, level, "Discover Targets failed: %s (%x:%x)\n",
+			   ibmvfc_get_cmd_error(rsp->status, rsp->error), rsp->status, rsp->error);
 		break;
 	case IBMVFC_MAD_DRIVER_FAILED:
 		break;
@@ -3493,18 +3508,19 @@ static void ibmvfc_npiv_login_done(struc
 	u32 mad_status = evt->xfer_iu->npiv_login.common.status;
 	struct ibmvfc_npiv_login_resp *rsp = &vhost->login_buf->resp;
 	unsigned int npiv_max_sectors;
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
 		ibmvfc_free_event(evt);
 		break;
 	case IBMVFC_MAD_FAILED:
-		dev_err(vhost->dev, "NPIV Login failed: %s (%x:%x)\n",
-			ibmvfc_get_cmd_error(rsp->status, rsp->error), rsp->status, rsp->error);
 		if (ibmvfc_retry_cmd(rsp->status, rsp->error))
-			ibmvfc_retry_host_init(vhost);
+			level += ibmvfc_retry_host_init(vhost);
 		else
 			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+		ibmvfc_log(vhost, level, "NPIV Login failed: %s (%x:%x)\n",
+			   ibmvfc_get_cmd_error(rsp->status, rsp->error), rsp->status, rsp->error);
 		ibmvfc_free_event(evt);
 		return;
 	case IBMVFC_MAD_CRQ_ERROR:
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_no_log_on_retry drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_no_log_on_retry	2009-03-31 08:46:08.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2009-03-31 08:46:08.000000000 -0500
@@ -707,6 +707,12 @@ struct ibmvfc_host {
 #define tgt_err(t, fmt, ...)		\
 	dev_err((t)->vhost->dev, "%llX: " fmt, (t)->scsi_id, ##__VA_ARGS__)
 
+#define tgt_log(t, level, fmt, ...) \
+	do { \
+		if ((t)->vhost->log_level >= level) \
+			tgt_err(t, fmt, ##__VA_ARGS__); \
+	} while (0)
+
 #define ibmvfc_dbg(vhost, ...) \
 	DBG_CMD(dev_info((vhost)->dev, ##__VA_ARGS__))
 
_
