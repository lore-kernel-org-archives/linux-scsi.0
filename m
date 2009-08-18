From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 15/27] zfcp: Decouple gid_pn requests from erp
Date: Tue, 18 Aug 2009 15:43:20 +0200
Message-ID: <20090818135030.743703000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:47044 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbZHRNua (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:30 -0400
Content-Disposition: inline; filename=716.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Don't let the erp wait for gid_pn requests to complete. Instead, queue
the gid_pn work, exit erp and let the finished gid_pn work trigger a
new port reopen.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-18 14:19:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-18 14:19:59.000000000 +0200
@@ -362,6 +362,11 @@ static int zfcp_allocate_low_mem_buffers
 	if (!adapter->pool.erp_req)
 		return -ENOMEM;
 
+	adapter->pool.gid_pn_req =
+		mempool_create_kmalloc_pool(1, sizeof(struct zfcp_fsf_req));
+	if (!adapter->pool.gid_pn_req)
+		return -ENOMEM;
+
 	adapter->pool.scsi_req =
 		mempool_create_kmalloc_pool(1, sizeof(struct zfcp_fsf_req));
 	if (!adapter->pool.scsi_req)
@@ -379,7 +384,7 @@ static int zfcp_allocate_low_mem_buffers
 		return -ENOMEM;
 
 	adapter->pool.qtcb_pool =
-		mempool_create_slab_pool(3, zfcp_data.qtcb_cache);
+		mempool_create_slab_pool(4, zfcp_data.qtcb_cache);
 	if (!adapter->pool.qtcb_pool)
 		return -ENOMEM;
 
@@ -652,7 +657,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 
 	init_waitqueue_head(&port->remove_wq);
 	INIT_LIST_HEAD(&port->unit_list_head);
-	INIT_WORK(&port->gid_pn_work, zfcp_erp_port_strategy_open_lookup);
+	INIT_WORK(&port->gid_pn_work, zfcp_fc_port_did_lookup);
 	INIT_WORK(&port->test_link_work, zfcp_fc_link_test_work);
 	INIT_WORK(&port->rport_work, zfcp_scsi_rport_work);
 
--- a/drivers/s390/scsi/zfcp_def.h	2009-08-18 14:19:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-08-18 14:19:59.000000000 +0200
@@ -265,6 +265,7 @@ struct zfcp_fsf_req;
 /* holds various memory pools of an adapter */
 struct zfcp_adapter_mempool {
 	mempool_t *erp_req;
+	mempool_t *gid_pn_req;
 	mempool_t *scsi_req;
 	mempool_t *scsi_abort;
 	mempool_t *status_read_req;
--- a/drivers/s390/scsi/zfcp_erp.c	2009-08-18 14:19:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-08-18 14:19:59.000000000 +0200
@@ -26,7 +26,6 @@ enum zfcp_erp_steps {
 	ZFCP_ERP_STEP_FSF_XCONFIG	= 0x0001,
 	ZFCP_ERP_STEP_PHYS_PORT_CLOSING	= 0x0010,
 	ZFCP_ERP_STEP_PORT_CLOSING	= 0x0100,
-	ZFCP_ERP_STEP_NAMESERVER_LOOKUP	= 0x0400,
 	ZFCP_ERP_STEP_PORT_OPENING	= 0x0800,
 	ZFCP_ERP_STEP_UNIT_CLOSING	= 0x1000,
 	ZFCP_ERP_STEP_UNIT_OPENING	= 0x2000,
@@ -842,27 +841,6 @@ static int zfcp_erp_open_ptp_port(struct
 	return zfcp_erp_port_strategy_open_port(act);
 }
 
-void zfcp_erp_port_strategy_open_lookup(struct work_struct *work)
-{
-	int retval;
-	struct zfcp_port *port = container_of(work, struct zfcp_port,
-					      gid_pn_work);
-
-	retval = zfcp_fc_ns_gid_pn(&port->erp_action);
-	if (!retval) {
-		port->erp_action.step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
-		goto out;
-	}
-	if (retval == -ENOMEM) {
-		zfcp_erp_notify(&port->erp_action, ZFCP_STATUS_ERP_LOWMEM);
-		goto out;
-	}
-	/* all other error condtions */
-	zfcp_erp_notify(&port->erp_action, 0);
-out:
-	zfcp_port_put(port);
-}
-
 static int zfcp_erp_port_strategy_open_common(struct zfcp_erp_action *act)
 {
 	struct zfcp_adapter *adapter = act->adapter;
@@ -880,12 +858,8 @@ static int zfcp_erp_port_strategy_open_c
 			if (!queue_work(adapter->work_queue,
 					&port->gid_pn_work))
 				zfcp_port_put(port);
-			return ZFCP_ERP_CONTINUES;
+			return ZFCP_ERP_EXIT;
 		}
-		/* fall through */
-	case ZFCP_ERP_STEP_NAMESERVER_LOOKUP:
-		if (!port->d_id)
-			return ZFCP_ERP_FAILED;
 		return zfcp_erp_port_strategy_open_port(act);
 
 	case ZFCP_ERP_STEP_PORT_OPENING:
--- a/drivers/s390/scsi/zfcp_ext.h	2009-08-18 14:19:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-08-18 14:19:59.000000000 +0200
@@ -94,13 +94,12 @@ extern void zfcp_erp_unit_access_denied(
 extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *, char *,
 					    void *);
 extern void zfcp_erp_timeout_handler(unsigned long);
-extern void zfcp_erp_port_strategy_open_lookup(struct work_struct *);
 
 /* zfcp_fc.c */
 extern int zfcp_scan_ports(struct zfcp_adapter *);
 extern void _zfcp_scan_ports_later(struct work_struct *);
 extern void zfcp_fc_incoming_els(struct zfcp_fsf_req *);
-extern int zfcp_fc_ns_gid_pn(struct zfcp_erp_action *);
+extern void zfcp_fc_port_did_lookup(struct work_struct *);
 extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
 extern void zfcp_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
@@ -128,8 +127,7 @@ extern struct zfcp_fsf_req *zfcp_fsf_con
 extern void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
 extern int zfcp_fsf_status_read(struct zfcp_qdio *);
 extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
-extern int zfcp_fsf_send_ct(struct zfcp_send_ct *, mempool_t *,
-			    struct zfcp_erp_action *);
+extern int zfcp_fsf_send_ct(struct zfcp_send_ct *, mempool_t *);
 extern int zfcp_fsf_send_els(struct zfcp_send_els *);
 extern int zfcp_fsf_send_fcp_command_task(struct zfcp_unit *,
 					  struct scsi_cmnd *);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-08-18 14:19:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-08-18 14:19:59.000000000 +0200
@@ -282,15 +282,15 @@ static void zfcp_fc_ns_gid_pn_eval(unsig
 	port->d_id = ct_iu_resp->d_id & ZFCP_DID_MASK;
 }
 
-int static zfcp_fc_ns_gid_pn_request(struct zfcp_erp_action *erp_action,
+static int zfcp_fc_ns_gid_pn_request(struct zfcp_port *port,
 				     struct zfcp_gid_pn_data *gid_pn)
 {
-	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_adapter *adapter = port->adapter;
 	struct zfcp_fc_ns_handler_data compl_rec;
 	int ret;
 
 	/* setup parameters for send generic command */
-	gid_pn->port = erp_action->port;
+	gid_pn->port = port;
 	gid_pn->ct.wka_port = &adapter->gs->ds;
 	gid_pn->ct.handler = zfcp_fc_ns_handler;
 	gid_pn->ct.handler_data = (unsigned long) &compl_rec;
@@ -309,12 +309,12 @@ int static zfcp_fc_ns_gid_pn_request(str
 	gid_pn->ct_iu_req.header.options = ZFCP_CT_SYNCHRONOUS;
 	gid_pn->ct_iu_req.header.cmd_rsp_code = ZFCP_CT_GID_PN;
 	gid_pn->ct_iu_req.header.max_res_size = ZFCP_CT_SIZE_ONE_PAGE / 4;
-	gid_pn->ct_iu_req.wwpn = erp_action->port->wwpn;
+	gid_pn->ct_iu_req.wwpn = port->wwpn;
 
 	init_completion(&compl_rec.done);
 	compl_rec.handler = zfcp_fc_ns_gid_pn_eval;
 	compl_rec.handler_data = (unsigned long) gid_pn;
-	ret = zfcp_fsf_send_ct(&gid_pn->ct, adapter->pool.erp_req, erp_action);
+	ret = zfcp_fsf_send_ct(&gid_pn->ct, adapter->pool.gid_pn_req);
 	if (!ret)
 		wait_for_completion(&compl_rec.done);
 	return ret;
@@ -322,14 +322,14 @@ int static zfcp_fc_ns_gid_pn_request(str
 
 /**
  * zfcp_fc_ns_gid_pn_request - initiate GID_PN nameserver request
- * @erp_action: pointer to zfcp_erp_action where GID_PN request is needed
+ * @port: port where GID_PN request is needed
  * return: -ENOMEM on error, 0 otherwise
  */
-int zfcp_fc_ns_gid_pn(struct zfcp_erp_action *erp_action)
+static int zfcp_fc_ns_gid_pn(struct zfcp_port *port)
 {
 	int ret;
 	struct zfcp_gid_pn_data *gid_pn;
-	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_adapter *adapter = port->adapter;
 
 	gid_pn = mempool_alloc(adapter->pool.gid_pn_data, GFP_ATOMIC);
 	if (!gid_pn)
@@ -341,7 +341,7 @@ int zfcp_fc_ns_gid_pn(struct zfcp_erp_ac
 	if (ret)
 		goto out;
 
-	ret = zfcp_fc_ns_gid_pn_request(erp_action, gid_pn);
+	ret = zfcp_fc_ns_gid_pn_request(port, gid_pn);
 
 	zfcp_wka_port_put(&adapter->gs->ds);
 out:
@@ -349,6 +349,29 @@ out:
 	return ret;
 }
 
+void zfcp_fc_port_did_lookup(struct work_struct *work)
+{
+	int ret;
+	struct zfcp_port *port = container_of(work, struct zfcp_port,
+					      gid_pn_work);
+
+	ret = zfcp_fc_ns_gid_pn(port);
+	if (ret) {
+		/* could not issue gid_pn for some reason */
+		zfcp_erp_adapter_reopen(port->adapter, 0, "fcgpn_1", NULL);
+		goto out;
+	}
+
+	if (!port->d_id) {
+		zfcp_erp_port_failed(port, "fcgpn_2", NULL);
+		goto out;
+	}
+
+	zfcp_erp_port_reopen(port, 0, "fcgpn_3", NULL);
+out:
+	zfcp_port_put(port);
+}
+
 /**
  * zfcp_fc_plogi_evaluate - evaluate PLOGI playload
  * @port: zfcp_port structure
@@ -551,7 +574,7 @@ static int zfcp_scan_issue_gpn_ft(struct
 
 	init_completion(&compl_rec.done);
 	compl_rec.handler = NULL;
-	ret = zfcp_fsf_send_ct(ct, NULL, NULL);
+	ret = zfcp_fsf_send_ct(ct, NULL);
 	if (!ret)
 		wait_for_completion(&compl_rec.done);
 	return ret;
@@ -840,7 +863,7 @@ int zfcp_fc_execute_ct_fc_job(struct fc_
 	ct_fc_job->ct.completion = NULL;
 	ct_fc_job->job = job;
 
-	ret = zfcp_fsf_send_ct(&ct_fc_job->ct, NULL, NULL);
+	ret = zfcp_fsf_send_ct(&ct_fc_job->ct, NULL);
 	if (ret) {
 		kfree(ct_fc_job);
 		zfcp_wka_port_put(ct_fc_job->ct.wka_port);
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-08-18 14:19:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-08-18 14:19:59.000000000 +0200
@@ -1069,10 +1069,8 @@ static int zfcp_fsf_setup_ct_els_sbals(s
  * zfcp_fsf_send_ct - initiate a Generic Service request (FC-GS)
  * @ct: pointer to struct zfcp_send_ct with data for request
  * @pool: if non-null this mempool is used to allocate struct zfcp_fsf_req
- * @erp_action: if non-null the Generic Service request sent within ERP
  */
-int zfcp_fsf_send_ct(struct zfcp_send_ct *ct, mempool_t *pool,
-		     struct zfcp_erp_action *erp_action)
+int zfcp_fsf_send_ct(struct zfcp_send_ct *ct, mempool_t *pool)
 {
 	struct zfcp_wka_port *wka_port = ct->wka_port;
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
@@ -1103,13 +1101,7 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 	req->data = ct;
 
 	zfcp_san_dbf_event_ct_request(req);
-
-	if (erp_action) {
-		erp_action->fsf_req = req;
-		req->erp_action = erp_action;
-		zfcp_fsf_start_erp_timer(req);
-	} else
-		zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
+	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 
 	ret = zfcp_fsf_req_send(req);
 	if (ret)
@@ -1119,8 +1111,6 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 
 failed_send:
 	zfcp_fsf_req_free(req);
-	if (erp_action)
-		erp_action->fsf_req = NULL;
 out:
 	spin_unlock_bh(&qdio->req_q_lock);
 	return ret;

