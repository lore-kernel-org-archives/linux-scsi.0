From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 06/10] ibmvfc: Add support for NPIV Logout
Date: Thu, 28 May 2009 16:17:29 -0500
Message-ID: <200905282117.n4SLHTgj025772@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:39656 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763711AbZE1VRd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 17:17:33 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e39.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n4SLDigN027985
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:13:44 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4SLHVM5157108
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:17:31 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4SLHU9u025804
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 15:17:30 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


This patch adds support for a new command supported by the Virtual I/O
Server, NPIV Logout. The command will abort all outstanding commands
and log out of the fabric. Currently, the only way to do this is
by breaking the CRQ, which can take a fairly long time when lots of
commands are outstanding. The NPIV Logout commands provides a mechanism
to accomplish virtually the same function, but is much faster.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   97 +++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/ibmvscsi/ibmvfc.h |   12 ++++-
 2 files changed, 105 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_npiv_logout drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_npiv_logout	2009-03-31 08:46:13.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2009-03-31 08:46:13.000000000 -0500
@@ -57,9 +57,10 @@
  * Ensure we have resources for ERP and initialization:
  * 1 for ERP
  * 1 for initialization
+ * 1 for NPIV Logout
  * 2 for each discovery thread
  */
-#define IBMVFC_NUM_INTERNAL_REQ	(1 + 1 + (disc_threads * 2))
+#define IBMVFC_NUM_INTERNAL_REQ	(1 + 1 + 1 + (disc_threads * 2))
 
 #define IBMVFC_MAD_SUCCESS		0x00
 #define IBMVFC_MAD_NOT_SUPPORTED	0xF1
@@ -127,6 +128,7 @@ enum ibmvfc_mad_types {
 	IBMVFC_IMPLICIT_LOGOUT	= 0x0040,
 	IBMVFC_PASSTHRU		= 0x0200,
 	IBMVFC_TMF_MAD		= 0x0100,
+	IBMVFC_NPIV_LOGOUT	= 0x0800,
 };
 
 struct ibmvfc_mad_common {
@@ -143,6 +145,10 @@ struct ibmvfc_npiv_login_mad {
 	struct srp_direct_buf buffer;
 }__attribute__((packed, aligned (8)));
 
+struct ibmvfc_npiv_logout_mad {
+	struct ibmvfc_mad_common common;
+}__attribute__((packed, aligned (8)));
+
 #define IBMVFC_MAX_NAME 256
 
 struct ibmvfc_npiv_login {
@@ -561,6 +567,7 @@ struct ibmvfc_async_crq_queue {
 union ibmvfc_iu {
 	struct ibmvfc_mad_common mad_common;
 	struct ibmvfc_npiv_login_mad npiv_login;
+	struct ibmvfc_npiv_logout_mad npiv_logout;
 	struct ibmvfc_discover_targets discover_targets;
 	struct ibmvfc_port_login plogi;
 	struct ibmvfc_process_login prli;
@@ -627,6 +634,8 @@ struct ibmvfc_event_pool {
 
 enum ibmvfc_host_action {
 	IBMVFC_HOST_ACTION_NONE = 0,
+	IBMVFC_HOST_ACTION_LOGO,
+	IBMVFC_HOST_ACTION_LOGO_WAIT,
 	IBMVFC_HOST_ACTION_INIT,
 	IBMVFC_HOST_ACTION_INIT_WAIT,
 	IBMVFC_HOST_ACTION_QUERY,
@@ -682,6 +691,7 @@ struct ibmvfc_host {
 	int reinit;
 	int delay_init;
 	int scan_complete;
+	int logged_in;
 	int events_to_log;
 #define IBMVFC_AE_LINKUP	0x0001
 #define IBMVFC_AE_LINKDOWN	0x0002
diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_npiv_logout drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_npiv_logout	2009-03-31 08:46:13.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-03-31 08:46:13.000000000 -0500
@@ -143,6 +143,7 @@ static void ibmvfc_npiv_login(struct ibm
 static void ibmvfc_tgt_send_prli(struct ibmvfc_target *);
 static void ibmvfc_tgt_send_plogi(struct ibmvfc_target *);
 static void ibmvfc_tgt_query_target(struct ibmvfc_target *);
+static void ibmvfc_npiv_logout(struct ibmvfc_host *);
 
 static const char *unknown_error = "unknown error";
 
@@ -477,6 +478,10 @@ static void ibmvfc_set_host_action(struc
 		if (vhost->action == IBMVFC_HOST_ACTION_INIT_WAIT)
 			vhost->action = action;
 		break;
+	case IBMVFC_HOST_ACTION_LOGO_WAIT:
+		if (vhost->action == IBMVFC_HOST_ACTION_LOGO)
+			vhost->action = action;
+		break;
 	case IBMVFC_HOST_ACTION_INIT_WAIT:
 		if (vhost->action == IBMVFC_HOST_ACTION_INIT)
 			vhost->action = action;
@@ -496,6 +501,7 @@ static void ibmvfc_set_host_action(struc
 		if (vhost->action == IBMVFC_HOST_ACTION_ALLOC_TGTS)
 			vhost->action = action;
 		break;
+	case IBMVFC_HOST_ACTION_LOGO:
 	case IBMVFC_HOST_ACTION_INIT:
 	case IBMVFC_HOST_ACTION_TGT_DEL:
 	case IBMVFC_HOST_ACTION_QUERY_TGTS:
@@ -647,6 +653,7 @@ static void ibmvfc_release_crq_queue(str
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 
 	vhost->state = IBMVFC_NO_CRQ;
+	vhost->logged_in = 0;
 	dma_unmap_single(vhost->dev, crq->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
 	free_page((unsigned long)crq->msgs);
 }
@@ -693,6 +700,7 @@ static int ibmvfc_reset_crq(struct ibmvf
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 
 	vhost->state = IBMVFC_NO_CRQ;
+	vhost->logged_in = 0;
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
 
 	/* Clean out the queue */
@@ -808,10 +816,10 @@ static void ibmvfc_purge_requests(struct
 }
 
 /**
- * __ibmvfc_reset_host - Reset the connection to the server (no locking)
+ * ibmvfc_hard_reset_host - Reset the connection to the server by breaking the CRQ
  * @vhost:	struct ibmvfc host to reset
  **/
-static void __ibmvfc_reset_host(struct ibmvfc_host *vhost)
+static void ibmvfc_hard_reset_host(struct ibmvfc_host *vhost)
 {
 	int rc;
 
@@ -827,9 +835,25 @@ static void __ibmvfc_reset_host(struct i
 }
 
 /**
- * ibmvfc_reset_host - Reset the connection to the server
+ * __ibmvfc_reset_host - Reset the connection to the server (no locking)
  * @vhost:	struct ibmvfc host to reset
  **/
+static void __ibmvfc_reset_host(struct ibmvfc_host *vhost)
+{
+	if (vhost->logged_in && vhost->action != IBMVFC_HOST_ACTION_LOGO_WAIT &&
+	    !ibmvfc_set_host_state(vhost, IBMVFC_INITIALIZING)) {
+		scsi_block_requests(vhost->host);
+		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_LOGO);
+		vhost->job_step = ibmvfc_npiv_logout;
+		wake_up(&vhost->work_wait_q);
+	} else
+		ibmvfc_hard_reset_host(vhost);
+}
+
+/**
+ * ibmvfc_reset_host - Reset the connection to the server
+ * @vhost:	ibmvfc host struct
+ **/
 static void ibmvfc_reset_host(struct ibmvfc_host *vhost)
 {
 	unsigned long flags;
@@ -2230,6 +2254,7 @@ static void ibmvfc_handle_crq(struct ibm
 		return;
 	case IBMVFC_CRQ_XPORT_EVENT:
 		vhost->state = IBMVFC_NO_CRQ;
+		vhost->logged_in = 0;
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
 		if (crq->format == IBMVFC_PARTITION_MIGRATED) {
 			/* We need to re-setup the interpartition connection */
@@ -3554,6 +3579,7 @@ static void ibmvfc_npiv_login_done(struc
 		return;
 	}
 
+	vhost->logged_in = 1;
 	npiv_max_sectors = min((uint)(rsp->max_dma_len >> 9), IBMVFC_MAX_SECTORS);
 	dev_info(vhost->dev, "Host partition: %s, device: %s %s %s max sectors %u\n",
 		 rsp->partition_name, rsp->device_name, rsp->port_loc_code,
@@ -3612,6 +3638,65 @@ static void ibmvfc_npiv_login(struct ibm
 };
 
 /**
+ * ibmvfc_npiv_logout_done - Completion handler for NPIV Logout
+ * @vhost:		ibmvfc host struct
+ *
+ **/
+static void ibmvfc_npiv_logout_done(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_host *vhost = evt->vhost;
+	u32 mad_status = evt->xfer_iu->npiv_logout.common.status;
+
+	ibmvfc_free_event(evt);
+
+	switch (mad_status) {
+	case IBMVFC_MAD_SUCCESS:
+		if (list_empty(&vhost->sent) &&
+		    vhost->action == IBMVFC_HOST_ACTION_LOGO_WAIT) {
+			ibmvfc_init_host(vhost, 0);
+			return;
+		}
+		break;
+	case IBMVFC_MAD_FAILED:
+	case IBMVFC_MAD_NOT_SUPPORTED:
+	case IBMVFC_MAD_CRQ_ERROR:
+	case IBMVFC_MAD_DRIVER_FAILED:
+	default:
+		ibmvfc_dbg(vhost, "NPIV Logout failed. 0x%X\n", mad_status);
+		break;
+	}
+
+	ibmvfc_hard_reset_host(vhost);
+}
+
+/**
+ * ibmvfc_npiv_logout - Issue an NPIV Logout
+ * @vhost:		ibmvfc host struct
+ *
+ **/
+static void ibmvfc_npiv_logout(struct ibmvfc_host *vhost)
+{
+	struct ibmvfc_npiv_logout_mad *mad;
+	struct ibmvfc_event *evt;
+
+	evt = ibmvfc_get_event(vhost);
+	ibmvfc_init_event(evt, ibmvfc_npiv_logout_done, IBMVFC_MAD_FORMAT);
+
+	mad = &evt->iu.npiv_logout;
+	memset(mad, 0, sizeof(*mad));
+	mad->common.version = 1;
+	mad->common.opcode = IBMVFC_NPIV_LOGOUT;
+	mad->common.length = sizeof(struct ibmvfc_npiv_logout_mad);
+
+	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_LOGO_WAIT);
+
+	if (!ibmvfc_send_event(evt, vhost, default_timeout))
+		ibmvfc_dbg(vhost, "Sent NPIV logout\n");
+	else
+		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+}
+
+/**
  * ibmvfc_dev_init_to_do - Is there target initialization work to do?
  * @vhost:		ibmvfc host struct
  *
@@ -3647,6 +3732,7 @@ static int __ibmvfc_work_to_do(struct ib
 	switch (vhost->action) {
 	case IBMVFC_HOST_ACTION_NONE:
 	case IBMVFC_HOST_ACTION_INIT_WAIT:
+	case IBMVFC_HOST_ACTION_LOGO_WAIT:
 		return 0;
 	case IBMVFC_HOST_ACTION_TGT_INIT:
 	case IBMVFC_HOST_ACTION_QUERY_TGTS:
@@ -3659,6 +3745,7 @@ static int __ibmvfc_work_to_do(struct ib
 			if (tgt->action == IBMVFC_TGT_ACTION_INIT_WAIT)
 				return 0;
 		return 1;
+	case IBMVFC_HOST_ACTION_LOGO:
 	case IBMVFC_HOST_ACTION_INIT:
 	case IBMVFC_HOST_ACTION_ALLOC_TGTS:
 	case IBMVFC_HOST_ACTION_TGT_DEL:
@@ -3765,8 +3852,12 @@ static void ibmvfc_do_work(struct ibmvfc
 	vhost->events_to_log = 0;
 	switch (vhost->action) {
 	case IBMVFC_HOST_ACTION_NONE:
+	case IBMVFC_HOST_ACTION_LOGO_WAIT:
 	case IBMVFC_HOST_ACTION_INIT_WAIT:
 		break;
+	case IBMVFC_HOST_ACTION_LOGO:
+		vhost->job_step(vhost);
+		break;
 	case IBMVFC_HOST_ACTION_INIT:
 		BUG_ON(vhost->state != IBMVFC_INITIALIZING);
 		if (vhost->delay_init) {
_
