From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/5] ibmvfc: Improve ADISC timeout handling
Date: Fri, 20 Mar 2009 15:44:39 -0500
Message-ID: <200903202044.n2KKiXoo010184@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:33176 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbZCTUog (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2009 16:44:36 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2KKe3PA017204
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:40:03 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2KKiYW0211004
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:44:34 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2KKiXxv010229
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:44:34 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The ibmvfc driver currently breaks the CRQ and essentially
resets the entire virtual FC adapter, killing all outstanding
ops to all attached targets, if an ADISC times out during target
discover/rediscovery. This patch adds some code to cancel the
ADISC if it times out, which prevents a single ADISC timeout from
affecting the other devices attached to the fabric.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   98 ++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ibmvscsi/ibmvfc.h |   11 +++-
 2 files changed, 106 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_adisc_timeout3 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_adisc_timeout3	2009-03-18 16:27:29.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2009-03-20 13:34:53.000000000 -0500
@@ -33,6 +33,10 @@
 #define IBMVFC_DRIVER_DATE		"(November 14, 2008)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	60
+#define IBMVFC_ADISC_CANCEL_TIMEOUT	45
+#define IBMVFC_ADISC_TIMEOUT		15
+#define IBMVFC_ADISC_PLUS_CANCEL_TIMEOUT	\
+		(IBMVFC_ADISC_TIMEOUT + IBMVFC_ADISC_CANCEL_TIMEOUT)
 #define IBMVFC_INIT_TIMEOUT		120
 #define IBMVFC_MAX_REQUESTS_DEFAULT	100
 
@@ -53,9 +57,9 @@
  * Ensure we have resources for ERP and initialization:
  * 1 for ERP
  * 1 for initialization
- * 1 for each discovery thread
+ * 2 for each discovery thread
  */
-#define IBMVFC_NUM_INTERNAL_REQ	(1 + 1 + disc_threads)
+#define IBMVFC_NUM_INTERNAL_REQ	(1 + 1 + (disc_threads * 2))
 
 #define IBMVFC_MAD_SUCCESS		0x00
 #define IBMVFC_MAD_NOT_SUPPORTED	0xF1
@@ -585,10 +589,12 @@ struct ibmvfc_target {
 	enum ibmvfc_target_action action;
 	int need_login;
 	int init_retries;
+	u32 cancel_key;
 	struct ibmvfc_service_parms service_parms;
 	struct ibmvfc_service_parms service_parms_change;
 	struct fc_rport_identifiers ids;
 	void (*job_step) (struct ibmvfc_target *);
+	struct timer_list timer;
 	struct kref kref;
 };
 
@@ -672,6 +678,7 @@ struct ibmvfc_host {
 	int task_set;
 	int init_retries;
 	int discovery_threads;
+	int abort_threads;
 	int client_migrated;
 	int reinit;
 	int delay_init;
diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_adisc_timeout3 drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_adisc_timeout3	2009-03-18 16:27:29.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-03-20 13:34:51.000000000 -0500
@@ -3123,6 +3123,7 @@ static void ibmvfc_tgt_adisc_done(struct
 
 	vhost->discovery_threads--;
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+	del_timer(&tgt->timer);
 
 	switch (status) {
 	case IBMVFC_MAD_SUCCESS:
@@ -3179,9 +3180,89 @@ static void ibmvfc_init_passthru(struct 
 }
 
 /**
+ * ibmvfc_tgt_adisc_cancel_done - Completion handler when cancelling an ADISC
+ * @evt:		ibmvfc event struct
+ *
+ * Just cleanup this event struct. Everything else is handled by
+ * the ADISC completion handler. If the ADISC never actually comes
+ * back, we still have the timer running on the ADISC event struct
+ * which will fire and cause the CRQ to get reset.
+ *
+ **/
+static void ibmvfc_tgt_adisc_cancel_done(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_host *vhost = evt->vhost;
+	struct ibmvfc_target *tgt = evt->tgt;
+
+	tgt_dbg(tgt, "ADISC cancel complete\n");
+	vhost->abort_threads--;
+	ibmvfc_free_event(evt);
+	kref_put(&tgt->kref, ibmvfc_release_tgt);
+	wake_up(&vhost->work_wait_q);
+}
+
+/**
+ * ibmvfc_adisc_timeout - Handle an ADISC timeout
+ * @tgt:		ibmvfc target struct
+ *
+ * If an ADISC times out, send a cancel. If the cancel times
+ * out, reset the CRQ. When the ADISC comes back as cancelled,
+ * log back into the target.
+ **/
+static void ibmvfc_adisc_timeout(struct ibmvfc_target *tgt)
+{
+	struct ibmvfc_host *vhost = tgt->vhost;
+	struct ibmvfc_event *evt;
+	struct ibmvfc_tmf *tmf;
+	unsigned long flags;
+	int rc;
+
+	tgt_dbg(tgt, "ADISC timeout\n");
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	if (vhost->abort_threads >= disc_threads ||
+	    tgt->action != IBMVFC_TGT_ACTION_INIT_WAIT ||
+	    vhost->state != IBMVFC_INITIALIZING ||
+	    vhost->action != IBMVFC_HOST_ACTION_QUERY_TGTS) {
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		return;
+	}
+
+	vhost->abort_threads++;
+	kref_get(&tgt->kref);
+	evt = ibmvfc_get_event(vhost);
+	ibmvfc_init_event(evt, ibmvfc_tgt_adisc_cancel_done, IBMVFC_MAD_FORMAT);
+
+	evt->tgt = tgt;
+	tmf = &evt->iu.tmf;
+	memset(tmf, 0, sizeof(*tmf));
+	tmf->common.version = 1;
+	tmf->common.opcode = IBMVFC_TMF_MAD;
+	tmf->common.length = sizeof(*tmf);
+	tmf->scsi_id = tgt->scsi_id;
+	tmf->cancel_key = tgt->cancel_key;
+
+	rc = ibmvfc_send_event(evt, vhost, default_timeout);
+
+	if (rc) {
+		tgt_err(tgt, "Failed to send cancel event for ADISC. rc=%d\n", rc);
+		vhost->abort_threads--;
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+	} else
+		tgt_dbg(tgt, "Attempting to cancel ADISC\n");
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+}
+
+/**
  * ibmvfc_tgt_adisc - Initiate an ADISC for specified target
  * @tgt:		ibmvfc target struct
  *
+ * When sending an ADISC we end up with two timers running. The
+ * first timer is the timer in the ibmvfc target struct. If this
+ * fires, we send a cancel to the target. The second timer is the
+ * timer on the ibmvfc event for the ADISC, which is longer. If that
+ * fires, it means the ADISC timed out and our attempt to cancel it
+ * also failed, so we need to reset the CRQ.
  **/
 static void ibmvfc_tgt_adisc(struct ibmvfc_target *tgt)
 {
@@ -3202,6 +3283,7 @@ static void ibmvfc_tgt_adisc(struct ibmv
 	mad = &evt->iu.passthru;
 	mad->iu.flags = IBMVFC_FC_ELS;
 	mad->iu.scsi_id = tgt->scsi_id;
+	mad->iu.cancel_key = tgt->cancel_key;
 
 	mad->fc_iu.payload[0] = IBMVFC_ADISC;
 	memcpy(&mad->fc_iu.payload[2], &vhost->login_buf->resp.port_name,
@@ -3210,9 +3292,19 @@ static void ibmvfc_tgt_adisc(struct ibmv
 	       sizeof(vhost->login_buf->resp.node_name));
 	mad->fc_iu.payload[6] = vhost->login_buf->resp.scsi_id & 0x00ffffff;
 
+	if (timer_pending(&tgt->timer))
+		mod_timer(&tgt->timer, jiffies + (IBMVFC_ADISC_TIMEOUT * HZ));
+	else {
+		tgt->timer.data = (unsigned long) tgt;
+		tgt->timer.expires = jiffies + (IBMVFC_ADISC_TIMEOUT * HZ);
+		tgt->timer.function = (void (*)(unsigned long))ibmvfc_adisc_timeout;
+		add_timer(&tgt->timer);
+	}
+
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
-	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
+	if (ibmvfc_send_event(evt, vhost, IBMVFC_ADISC_PLUS_CANCEL_TIMEOUT)) {
 		vhost->discovery_threads--;
+		del_timer(&tgt->timer);
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
 	} else
@@ -3340,6 +3432,8 @@ static int ibmvfc_alloc_target(struct ib
 	tgt->new_scsi_id = scsi_id;
 	tgt->vhost = vhost;
 	tgt->need_login = 1;
+	tgt->cancel_key = vhost->task_set++;
+	init_timer(&tgt->timer);
 	kref_init(&tgt->kref);
 	ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
 	spin_lock_irqsave(vhost->host->host_lock, flags);
@@ -3734,6 +3828,7 @@ static void ibmvfc_do_work(struct ibmvfc
 				spin_unlock_irqrestore(vhost->host->host_lock, flags);
 				if (rport)
 					fc_remote_port_delete(rport);
+				del_timer_sync(&tgt->timer);
 				kref_put(&tgt->kref, ibmvfc_release_tgt);
 				return;
 			}
@@ -4061,6 +4156,7 @@ static int ibmvfc_probe(struct vio_dev *
 	vhost->dev = dev;
 	vhost->partition_number = -1;
 	vhost->log_level = log_level;
+	vhost->task_set = 1;
 	strcpy(vhost->partition_name, "UNKNOWN");
 	init_waitqueue_head(&vhost->work_wait_q);
 	init_waitqueue_head(&vhost->init_wait_q);
_
