From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 18/27] zfcp: Apply common naming conventions to zfcp_fc
Date: Tue, 18 Aug 2009 15:43:23 +0200
Message-ID: <20090818135031.143521000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57170 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894AbZHRNub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:31 -0400
Content-Disposition: inline; filename=719-zfcp-naming-conventions.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Update the Fibre Channel related code to use the zfcp_fc prefix.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |    2 -
 drivers/s390/scsi/zfcp_ext.h   |    6 ++--
 drivers/s390/scsi/zfcp_fc.c    |   51 ++++++++++++++++++++---------------------
 drivers/s390/scsi/zfcp_fsf.c   |   10 ++++----
 drivers/s390/scsi/zfcp_sysfs.c |    2 -
 5 files changed, 35 insertions(+), 36 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-18 13:45:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-18 13:45:43.000000000 +0200
@@ -544,7 +544,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	sema_init(&adapter->erp_ready_sem, 0);
 
 	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
-	INIT_WORK(&adapter->scan_work, _zfcp_scan_ports_later);
+	INIT_WORK(&adapter->scan_work, _zfcp_fc_scan_ports_later);
 
 	adapter->service_level.seq_print = zfcp_print_sl;
 
--- a/drivers/s390/scsi/zfcp_ext.h	2009-08-18 13:45:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-08-18 13:46:24.000000000 +0200
@@ -92,12 +92,12 @@ extern void zfcp_erp_adapter_access_chan
 extern void zfcp_erp_timeout_handler(unsigned long);
 
 /* zfcp_fc.c */
-extern int zfcp_scan_ports(struct zfcp_adapter *);
-extern void _zfcp_scan_ports_later(struct work_struct *);
+extern int zfcp_fc_scan_ports(struct zfcp_adapter *);
+extern void _zfcp_fc_scan_ports_later(struct work_struct *);
 extern void zfcp_fc_incoming_els(struct zfcp_fsf_req *);
 extern void zfcp_fc_port_did_lookup(struct work_struct *);
 extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
-extern void zfcp_test_link(struct zfcp_port *);
+extern void zfcp_fc_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
 extern void zfcp_fc_wka_ports_force_offline(struct zfcp_wka_ports *);
 extern int zfcp_fc_gs_setup(struct zfcp_adapter *);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-08-18 13:45:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-08-18 13:45:43.000000000 +0200
@@ -57,7 +57,7 @@ struct zfcp_fc_ns_handler_data {
 	unsigned long handler_data;
 };
 
-static int zfcp_wka_port_get(struct zfcp_wka_port *wka_port)
+static int zfcp_fc_wka_port_get(struct zfcp_wka_port *wka_port)
 {
 	if (mutex_lock_interruptible(&wka_port->mutex))
 		return -ERESTARTSYS;
@@ -82,7 +82,7 @@ static int zfcp_wka_port_get(struct zfcp
 	return -EIO;
 }
 
-static void zfcp_wka_port_offline(struct work_struct *work)
+static void zfcp_fc_wka_port_offline(struct work_struct *work)
 {
 	struct delayed_work *dw = to_delayed_work(work);
 	struct zfcp_wka_port *wka_port =
@@ -102,7 +102,7 @@ out:
 	mutex_unlock(&wka_port->mutex);
 }
 
-static void zfcp_wka_port_put(struct zfcp_wka_port *wka_port)
+static void zfcp_fc_wka_port_put(struct zfcp_wka_port *wka_port)
 {
 	if (atomic_dec_return(&wka_port->refcount) != 0)
 		return;
@@ -121,7 +121,7 @@ static void zfcp_fc_wka_port_init(struct
 	wka_port->status = ZFCP_WKA_PORT_OFFLINE;
 	atomic_set(&wka_port->refcount, 0);
 	mutex_init(&wka_port->mutex);
-	INIT_DELAYED_WORK(&wka_port->work, zfcp_wka_port_offline);
+	INIT_DELAYED_WORK(&wka_port->work, zfcp_fc_wka_port_offline);
 }
 
 static void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *wka)
@@ -150,7 +150,7 @@ static void _zfcp_fc_incoming_rscn(struc
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	list_for_each_entry(port, &fsf_req->adapter->port_list_head, list) {
 		if ((port->d_id & range) == (elem->nport_did & range))
-			zfcp_test_link(port);
+			zfcp_fc_test_link(port);
 		if (!port->d_id)
 			zfcp_erp_port_reopen(port,
 					     ZFCP_STATUS_COMMON_ERP_FAILED,
@@ -326,13 +326,13 @@ static int zfcp_fc_ns_gid_pn(struct zfcp
 
 	memset(gid_pn, 0, sizeof(*gid_pn));
 
-	ret = zfcp_wka_port_get(&adapter->gs->ds);
+	ret = zfcp_fc_wka_port_get(&adapter->gs->ds);
 	if (ret)
 		goto out;
 
 	ret = zfcp_fc_ns_gid_pn_request(port, gid_pn);
 
-	zfcp_wka_port_put(&adapter->gs->ds);
+	zfcp_fc_wka_port_put(&adapter->gs->ds);
 out:
 	mempool_free(gid_pn, adapter->pool.gid_pn_data);
 	return ret;
@@ -482,14 +482,14 @@ out:
 }
 
 /**
- * zfcp_test_link - lightweight link test procedure
+ * zfcp_fc_test_link - lightweight link test procedure
  * @port: port to be tested
  *
  * Test status of a link to a remote port using the ELS command ADISC.
  * If there is a problem with the remote port, error recovery steps
  * will be triggered.
  */
-void zfcp_test_link(struct zfcp_port *port)
+void zfcp_fc_test_link(struct zfcp_port *port)
 {
 	zfcp_port_get(port);
 	if (!queue_work(port->adapter->work_queue, &port->test_link_work))
@@ -532,9 +532,8 @@ out:
 }
 
 
-static int zfcp_scan_issue_gpn_ft(struct zfcp_gpn_ft *gpn_ft,
-				  struct zfcp_adapter *adapter,
-				  int max_bytes)
+static int zfcp_fc_send_gpn_ft(struct zfcp_gpn_ft *gpn_ft,
+			       struct zfcp_adapter *adapter, int max_bytes)
 {
 	struct zfcp_send_ct *ct = &gpn_ft->ct;
 	struct ct_iu_gpn_ft_req *req = sg_virt(&gpn_ft->sg_req);
@@ -569,7 +568,7 @@ static int zfcp_scan_issue_gpn_ft(struct
 	return ret;
 }
 
-static void zfcp_validate_port(struct zfcp_port *port)
+static void zfcp_fc_validate_port(struct zfcp_port *port)
 {
 	struct zfcp_adapter *adapter = port->adapter;
 
@@ -589,7 +588,7 @@ static void zfcp_validate_port(struct zf
 	zfcp_port_dequeue(port);
 }
 
-static int zfcp_scan_eval_gpn_ft(struct zfcp_gpn_ft *gpn_ft, int max_entries)
+static int zfcp_fc_eval_gpn_ft(struct zfcp_gpn_ft *gpn_ft, int max_entries)
 {
 	struct zfcp_send_ct *ct = &gpn_ft->ct;
 	struct scatterlist *sg = gpn_ft->sg_resp;
@@ -649,16 +648,16 @@ static int zfcp_scan_eval_gpn_ft(struct 
 
 	zfcp_erp_wait(adapter);
 	list_for_each_entry_safe(port, tmp, &adapter->port_list_head, list)
-		zfcp_validate_port(port);
+		zfcp_fc_validate_port(port);
 	up(&zfcp_data.config_sema);
 	return ret;
 }
 
 /**
- * zfcp_scan_ports - scan remote ports and attach new ports
+ * zfcp_fc_scan_ports - scan remote ports and attach new ports
  * @adapter: pointer to struct zfcp_adapter
  */
-int zfcp_scan_ports(struct zfcp_adapter *adapter)
+int zfcp_fc_scan_ports(struct zfcp_adapter *adapter)
 {
 	int ret, i;
 	struct zfcp_gpn_ft *gpn_ft;
@@ -673,7 +672,7 @@ int zfcp_scan_ports(struct zfcp_adapter 
 	    fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPIV)
 		return 0;
 
-	ret = zfcp_wka_port_get(&adapter->gs->ds);
+	ret = zfcp_fc_wka_port_get(&adapter->gs->ds);
 	if (ret)
 		return ret;
 
@@ -684,9 +683,9 @@ int zfcp_scan_ports(struct zfcp_adapter 
 	}
 
 	for (i = 0; i < 3; i++) {
-		ret = zfcp_scan_issue_gpn_ft(gpn_ft, adapter, max_bytes);
+		ret = zfcp_fc_send_gpn_ft(gpn_ft, adapter, max_bytes);
 		if (!ret) {
-			ret = zfcp_scan_eval_gpn_ft(gpn_ft, max_entries);
+			ret = zfcp_fc_eval_gpn_ft(gpn_ft, max_entries);
 			if (ret == -EAGAIN)
 				ssleep(1);
 			else
@@ -695,14 +694,14 @@ int zfcp_scan_ports(struct zfcp_adapter 
 	}
 	zfcp_free_sg_env(gpn_ft, buf_num);
 out:
-	zfcp_wka_port_put(&adapter->gs->ds);
+	zfcp_fc_wka_port_put(&adapter->gs->ds);
 	return ret;
 }
 
 
-void _zfcp_scan_ports_later(struct work_struct *work)
+void _zfcp_fc_scan_ports_later(struct work_struct *work)
 {
-	zfcp_scan_ports(container_of(work, struct zfcp_adapter, scan_work));
+	zfcp_fc_scan_ports(container_of(work, struct zfcp_adapter, scan_work));
 }
 
 struct zfcp_els_fc_job {
@@ -792,7 +791,7 @@ static void zfcp_fc_generic_ct_handler(u
 	job->state_flags = FC_RQST_STATE_DONE;
 	job->job_done(job);
 
-	zfcp_wka_port_put(ct_fc_job->ct.wka_port);
+	zfcp_fc_wka_port_put(ct_fc_job->ct.wka_port);
 
 	kfree(ct_fc_job);
 }
@@ -838,7 +837,7 @@ int zfcp_fc_execute_ct_fc_job(struct fc_
 		return -EINVAL; /* no such service */
 	}
 
-	ret = zfcp_wka_port_get(ct_fc_job->ct.wka_port);
+	ret = zfcp_fc_wka_port_get(ct_fc_job->ct.wka_port);
 	if (ret) {
 		kfree(ct_fc_job);
 		return ret;
@@ -855,7 +854,7 @@ int zfcp_fc_execute_ct_fc_job(struct fc_
 	ret = zfcp_fsf_send_ct(&ct_fc_job->ct, NULL);
 	if (ret) {
 		kfree(ct_fc_job);
-		zfcp_wka_port_put(ct_fc_job->ct.wka_port);
+		zfcp_fc_wka_port_put(ct_fc_job->ct.wka_port);
 	}
 	return ret;
 }
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-08-18 13:45:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-08-18 13:45:43.000000000 +0200
@@ -892,7 +892,7 @@ static void zfcp_fsf_abort_fcp_command_h
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (fsq->word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			zfcp_test_link(unit->port);
+			zfcp_fc_test_link(unit->port);
 			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1139,7 +1139,7 @@ static void zfcp_fsf_send_els_handler(st
 		switch (header->fsf_status_qual.word[0]){
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			if (port && (send_els->ls_code != ZFCP_LS_ADISC))
-				zfcp_test_link(port);
+				zfcp_fc_test_link(port);
 			/*fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 		case FSF_SQ_RETRY_IF_POSSIBLE:
@@ -1889,7 +1889,7 @@ static void zfcp_fsf_open_unit_handler(s
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			zfcp_test_link(unit->port);
+			zfcp_fc_test_link(unit->port);
 			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -2024,7 +2024,7 @@ static void zfcp_fsf_close_unit_handler(
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (req->qtcb->header.fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			zfcp_test_link(unit->port);
+			zfcp_fc_test_link(unit->port);
 			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -2307,7 +2307,7 @@ static void zfcp_fsf_send_fcp_command_ha
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		if (header->fsf_status_qual.word[0] ==
 		    FSF_SQ_INVOKE_LINK_TEST_PROCEDURE)
-			zfcp_test_link(unit->port);
+			zfcp_fc_test_link(unit->port);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
--- a/drivers/s390/scsi/zfcp_sysfs.c	2009-08-18 12:08:02.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2009-08-18 13:45:43.000000000 +0200
@@ -126,7 +126,7 @@ static ssize_t zfcp_sysfs_port_rescan_st
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE)
 		return -EBUSY;
 
-	ret = zfcp_scan_ports(adapter);
+	ret = zfcp_fc_scan_ports(adapter);
 	return ret ? ret : (ssize_t) count;
 }
 static ZFCP_DEV_ATTR(adapter, port_rescan, S_IWUSR, NULL,

