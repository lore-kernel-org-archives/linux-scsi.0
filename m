From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/2] zfcp: Add FC pass-through support
Date: Mon, 06 Apr 2009 18:31:47 +0200
Message-ID: <20090406163534.659628000@de.ibm.com>
References: <20090406163145.686874000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:56603 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZDFQgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 12:36:35 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.14.3/8.13.8) with ESMTP id n36GZZl4376088
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 16:35:35 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n36GZZ8Q3100710
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 18:35:35 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n36GZYDL026311
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 18:35:35 +0200
Content-Disposition: inline; filename=fc_passthrough.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sven Schuetz <sven@linux.vnet.ibm.com>, James.Smart@Emulex.Com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Sven Schuetz <sven@linux.vnet.ibm.com>

Provide the ability to do fibre channel requests from the userspace to
our zfcp driver.  Patch builds upon extension to the fibre channel
tranport class by James Smart and Seokmann Ju.  See here
http://marc.info/?l=linux-scsi&m=123808882309133&w=2

Signed-off-by: Sven Schuetz <sven@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |   10 +-
 drivers/s390/scsi/zfcp_def.h  |   18 ++--
 drivers/s390/scsi/zfcp_erp.c  |    2 
 drivers/s390/scsi/zfcp_ext.h  |    6 +
 drivers/s390/scsi/zfcp_fc.c   |  188 +++++++++++++++++++++++++++++++++++++++---
 drivers/s390/scsi/zfcp_scsi.c |   15 +++
 6 files changed, 219 insertions(+), 20 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-04-06 17:23:25.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-04-06 17:23:29.000000000 +0200
@@ -471,6 +471,12 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	if (!adapter)
 		return -ENOMEM;
 
+	adapter->gs = kzalloc(sizeof(struct zfcp_wka_ports), GFP_KERNEL);
+	if (!adapter->gs) {
+		kfree(adapter);
+		return -ENOMEM;
+	}
+
 	ccw_device->handler = NULL;
 	adapter->ccw_device = ccw_device;
 	atomic_set(&adapter->refcount, 0);
@@ -524,8 +530,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 		goto sysfs_failed;
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
-
-	zfcp_fc_nameserver_init(adapter);
+	zfcp_fc_wka_ports_init(adapter);
 
 	if (!zfcp_adapter_scsi_register(adapter))
 		return 0;
@@ -572,6 +577,7 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 	kfree(adapter->req_list);
 	kfree(adapter->fc_stats);
 	kfree(adapter->stats_reset_data);
+	kfree(adapter->gs);
 	kfree(adapter);
 }
 
--- a/drivers/s390/scsi/zfcp_def.h	2009-04-06 17:23:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-04-06 17:23:29.000000000 +0200
@@ -22,6 +22,8 @@
 #include <linux/syscalls.h>
 #include <linux/scatterlist.h>
 #include <linux/ioctl.h>
+#include <scsi/fc/fc_fs.h>
+#include <scsi/fc/fc_gs.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_cmnd.h>
@@ -29,6 +31,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_bsg_fc.h>
 #include <asm/ccwdev.h>
 #include <asm/qdio.h>
 #include <asm/debug.h>
@@ -235,11 +238,6 @@ struct zfcp_ls_adisc {
 
 /* FC-PH/FC-GS well-known address identifiers for generic services */
 #define ZFCP_DID_WKA				0xFFFFF0
-#define ZFCP_DID_MANAGEMENT_SERVICE		0xFFFFFA
-#define ZFCP_DID_TIME_SERVICE			0xFFFFFB
-#define ZFCP_DID_DIRECTORY_SERVICE		0xFFFFFC
-#define ZFCP_DID_ALIAS_SERVICE			0xFFFFF8
-#define ZFCP_DID_KEY_DISTRIBUTION_SERVICE	0xFFFFF7
 
 /* remote port status */
 #define ZFCP_STATUS_PORT_PHYS_OPEN		0x00000001
@@ -384,6 +382,14 @@ struct zfcp_wka_port {
 	struct delayed_work	work;
 };
 
+struct zfcp_wka_ports {
+	struct zfcp_wka_port ms; 	/* management service */
+	struct zfcp_wka_port ts; 	/* time service */
+	struct zfcp_wka_port ds; 	/* directory service */
+	struct zfcp_wka_port as; 	/* alias service */
+	struct zfcp_wka_port ks; 	/* key distribution service */
+};
+
 struct zfcp_qdio_queue {
 	struct qdio_buffer *sbal[QDIO_MAX_BUFFERS_PER_Q];
 	u8		   first;	/* index of next free bfr in queue */
@@ -469,7 +475,7 @@ struct zfcp_adapter {
 						      actions */
 	u32			erp_low_mem_count; /* nr of erp actions waiting
 						      for memory */
-	struct zfcp_wka_port	nsp;		   /* adapter's nameserver */
+	struct zfcp_wka_ports	*gs;		   /* generic services */
 	debug_info_t		*rec_dbf;
 	debug_info_t		*hba_dbf;
 	debug_info_t		*san_dbf;          /* debug feature areas */
--- a/drivers/s390/scsi/zfcp_ext.h	2009-04-06 17:23:25.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-04-06 17:23:29.000000000 +0200
@@ -105,8 +105,12 @@ extern int zfcp_fc_ns_gid_pn(struct zfcp
 extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
 extern void zfcp_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
-extern void zfcp_fc_nameserver_init(struct zfcp_adapter *);
 extern void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *);
+extern void zfcp_fc_wka_ports_init(struct zfcp_adapter *);
+extern int zfcp_fc_execute_els_fc_job(struct fc_bsg_job *);
+extern int zfcp_fc_execute_ct_fc_job(struct fc_bsg_job *);
+extern void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *);
+
 
 /* zfcp_fsf.c */
 extern int zfcp_fsf_open_port(struct zfcp_erp_action *);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-04-06 17:23:25.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-04-06 17:24:30.000000000 +0200
@@ -123,14 +123,13 @@ static void zfcp_wka_port_put(struct zfc
 	schedule_delayed_work(&wka_port->work, HZ / 100);
 }
 
-void zfcp_fc_nameserver_init(struct zfcp_adapter *adapter)
+static void zfcp_fc_wka_port_init(struct zfcp_wka_port *wka_port, u32 d_id,
+				  struct zfcp_adapter *adapter)
 {
-	struct zfcp_wka_port *wka_port = &adapter->nsp;
-
 	init_waitqueue_head(&wka_port->completion_wq);
 
 	wka_port->adapter = adapter;
-	wka_port->d_id = ZFCP_DID_DIRECTORY_SERVICE;
+	wka_port->d_id = d_id;
 
 	wka_port->status = ZFCP_WKA_PORT_OFFLINE;
 	atomic_set(&wka_port->refcount, 0);
@@ -146,6 +145,17 @@ void zfcp_fc_wka_port_force_offline(stru
 	mutex_unlock(&wka->mutex);
 }
 
+void zfcp_fc_wka_ports_init(struct zfcp_adapter *adapter)
+{
+	struct zfcp_wka_ports *gs = adapter->gs;
+
+	zfcp_fc_wka_port_init(&gs->ms, FC_FID_MGMT_SERV, adapter);
+	zfcp_fc_wka_port_init(&gs->ts, FC_FID_TIME_SERV, adapter);
+	zfcp_fc_wka_port_init(&gs->ds, FC_FID_DIR_SERV, adapter);
+	zfcp_fc_wka_port_init(&gs->as, FC_FID_ALIASES, adapter);
+	zfcp_fc_wka_port_init(&gs->ks, FC_FID_SEC_KEY, adapter);
+}
+
 static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 				   struct fcp_rscn_element *elem)
 {
@@ -280,7 +290,7 @@ int static zfcp_fc_ns_gid_pn_request(str
 
 	/* setup parameters for send generic command */
 	gid_pn->port = erp_action->port;
-	gid_pn->ct.wka_port = &adapter->nsp;
+	gid_pn->ct.wka_port = &adapter->gs->ds;
 	gid_pn->ct.handler = zfcp_fc_ns_handler;
 	gid_pn->ct.handler_data = (unsigned long) &compl_rec;
 	gid_pn->ct.timeout = ZFCP_NS_GID_PN_TIMEOUT;
@@ -327,13 +337,13 @@ int zfcp_fc_ns_gid_pn(struct zfcp_erp_ac
 
 	memset(gid_pn, 0, sizeof(*gid_pn));
 
-	ret = zfcp_wka_port_get(&adapter->nsp);
+	ret = zfcp_wka_port_get(&adapter->gs->ds);
 	if (ret)
 		goto out;
 
 	ret = zfcp_fc_ns_gid_pn_request(erp_action, gid_pn);
 
-	zfcp_wka_port_put(&adapter->nsp);
+	zfcp_wka_port_put(&adapter->gs->ds);
 out:
 	mempool_free(gid_pn, adapter->pool.data_gid_pn);
 	return ret;
@@ -527,7 +537,7 @@ static int zfcp_scan_issue_gpn_ft(struct
 	req->fc4_type = ZFCP_CT_SCSI_FCP;
 
 	/* prepare zfcp_send_ct */
-	ct->wka_port = &adapter->nsp;
+	ct->wka_port = &adapter->gs->ds;
 	ct->handler = zfcp_fc_ns_handler;
 	ct->handler_data = (unsigned long)&compl_rec;
 	ct->timeout = 10;
@@ -644,7 +654,7 @@ int zfcp_scan_ports(struct zfcp_adapter 
 	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT)
 		return 0;
 
-	ret = zfcp_wka_port_get(&adapter->nsp);
+	ret = zfcp_wka_port_get(&adapter->gs->ds);
 	if (ret)
 		return ret;
 
@@ -666,7 +676,7 @@ int zfcp_scan_ports(struct zfcp_adapter 
 	}
 	zfcp_free_sg_env(gpn_ft, buf_num);
 out:
-	zfcp_wka_port_put(&adapter->nsp);
+	zfcp_wka_port_put(&adapter->gs->ds);
 	return ret;
 }
 
@@ -675,3 +685,161 @@ void _zfcp_scan_ports_later(struct work_
 {
 	zfcp_scan_ports(container_of(work, struct zfcp_adapter, scan_work));
 }
+
+struct zfcp_els_fc_job {
+	struct zfcp_send_els els;
+	struct fc_bsg_job *job;
+};
+
+static void zfcp_fc_generic_els_handler(unsigned long data)
+{
+	struct zfcp_els_fc_job *els_fc_job = (struct zfcp_els_fc_job *) data;
+	struct fc_bsg_job *job = els_fc_job->job;
+	struct fc_bsg_reply *reply = job->reply;
+
+	if (els_fc_job->els.status) {
+		/* request rejected or timed out */
+		reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_REJECT;
+		goto out;
+	}
+
+	reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+	reply->reply_payload_rcv_len = blk_rq_bytes(job->req->next_rq);
+
+out:
+	job->state_flags = FC_RQST_STATE_DONE;
+	job->job_done(job);
+	kfree(els_fc_job);
+}
+
+int zfcp_fc_execute_els_fc_job(struct fc_bsg_job *job)
+{
+	struct zfcp_els_fc_job *els_fc_job;
+	struct fc_rport *rport = job->rport;
+	struct Scsi_Host *shost;
+	struct zfcp_adapter *adapter;
+	struct zfcp_port *port;
+	u8 *port_did;
+
+	shost = rport ? rport_to_shost(rport) : job->shost;
+	adapter = (struct zfcp_adapter *)shost->hostdata[0];
+
+	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN))
+		return -EINVAL;
+
+	els_fc_job = kzalloc(sizeof(struct zfcp_els_fc_job), GFP_KERNEL);
+	if (!els_fc_job)
+		return -ENOMEM;
+
+	els_fc_job->els.adapter = adapter;
+	if (rport) {
+		read_lock_irq(&zfcp_data.config_lock);
+		port = rport->dd_data;
+		if (port)
+			zfcp_port_get(port);
+		read_unlock_irq(&zfcp_data.config_lock);
+		if (!port) {
+			kfree(els_fc_job);
+			return -EINVAL;
+		}
+		els_fc_job->els.port = port;
+		els_fc_job->els.d_id = port->d_id;
+		zfcp_port_put(port);
+	} else {
+		port_did = job->request->rqst_data.h_els.port_id;
+		els_fc_job->els.d_id = (port_did[0] << 16) +
+					(port_did[1] << 8) + port_did[2];
+	}
+
+	els_fc_job->els.req = job->request_payload.sg_list;
+	els_fc_job->els.resp = job->reply_payload.sg_list;
+	els_fc_job->els.handler = zfcp_fc_generic_els_handler;
+	els_fc_job->els.handler_data = (unsigned long) els_fc_job;
+	els_fc_job->job = job;
+
+	return zfcp_fsf_send_els(&els_fc_job->els);
+}
+
+struct zfcp_ct_fc_job {
+	struct zfcp_send_ct ct;
+	struct fc_bsg_job *job;
+};
+
+static void zfcp_fc_generic_ct_handler(unsigned long data)
+{
+	struct zfcp_ct_fc_job *ct_fc_job = (struct zfcp_ct_fc_job *) data;
+	struct fc_bsg_job *job = ct_fc_job->job;
+
+	job->reply->reply_data.ctels_reply.status = ct_fc_job->ct.status ?
+				FC_CTELS_STATUS_REJECT : FC_CTELS_STATUS_OK;
+	job->state_flags = FC_RQST_STATE_DONE;
+	job->reply->reply_payload_rcv_len = blk_rq_bytes(job->req->next_rq);
+	job->job_done(job);
+
+	zfcp_wka_port_put(ct_fc_job->ct.wka_port);
+
+	kfree(ct_fc_job);
+}
+
+int zfcp_fc_execute_ct_fc_job(struct fc_bsg_job *job)
+{
+	int ret;
+	u8 gs_type;
+	struct fc_rport *rport = job->rport;
+	struct Scsi_Host *shost;
+	struct zfcp_adapter *adapter;
+	struct zfcp_ct_fc_job *ct_fc_job;
+	u32 preamble_word1;
+
+	shost = rport ? rport_to_shost(rport) : job->shost;
+
+	adapter = (struct zfcp_adapter *)shost->hostdata[0];
+	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN))
+		return -EINVAL;
+
+	ct_fc_job = kzalloc(sizeof(struct zfcp_ct_fc_job), GFP_KERNEL);
+	if (!ct_fc_job)
+		return -ENOMEM;
+
+	preamble_word1 = job->request->rqst_data.r_ct.preamble_word1;
+	gs_type = (preamble_word1 & 0xff000000) >> 24;
+
+	switch (gs_type) {
+	case FC_FST_ALIAS:
+		ct_fc_job->ct.wka_port = &adapter->gs->as;
+		break;
+	case FC_FST_MGMT:
+		ct_fc_job->ct.wka_port = &adapter->gs->ms;
+		break;
+	case FC_FST_TIME:
+		ct_fc_job->ct.wka_port = &adapter->gs->ts;
+		break;
+	case FC_FST_DIR:
+		ct_fc_job->ct.wka_port = &adapter->gs->ds;
+		break;
+	default:
+		kfree(ct_fc_job);
+		return -EINVAL; /* no such service */
+	}
+
+	ret = zfcp_wka_port_get(ct_fc_job->ct.wka_port);
+	if (ret) {
+		kfree(ct_fc_job);
+		return ret;
+	}
+
+	ct_fc_job->ct.req = job->request_payload.sg_list;
+	ct_fc_job->ct.resp = job->reply_payload.sg_list;
+	ct_fc_job->ct.timeout = ZFCP_FSF_REQUEST_TIMEOUT;
+	ct_fc_job->ct.handler = zfcp_fc_generic_ct_handler;
+	ct_fc_job->ct.handler_data = (unsigned long) ct_fc_job;
+	ct_fc_job->ct.completion = NULL;
+	ct_fc_job->job = job;
+
+	ret = zfcp_fsf_send_ct(&ct_fc_job->ct, NULL, NULL);
+	if (ret) {
+		kfree(ct_fc_job);
+		zfcp_wka_port_put(ct_fc_job->ct.wka_port);
+	}
+	return ret;
+}
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-04-06 17:23:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-04-06 17:23:29.000000000 +0200
@@ -583,6 +583,20 @@ void zfcp_scsi_rport_work(struct work_st
 }
 
 
+static int zfcp_execute_fc_job(struct fc_bsg_job *job)
+{
+	switch (job->request->msgcode) {
+	case FC_BSG_RPT_ELS:
+	case FC_BSG_HST_ELS_NOLOGIN:
+		return zfcp_fc_execute_els_fc_job(job);
+	case FC_BSG_RPT_CT:
+	case FC_BSG_HST_CT:
+		return zfcp_fc_execute_ct_fc_job(job);
+	default:
+		return -EINVAL;
+	}
+}
+
 struct fc_function_template zfcp_transport_functions = {
 	.show_starget_port_id = 1,
 	.show_starget_port_name = 1,
@@ -604,6 +618,7 @@ struct fc_function_template zfcp_transpo
 	.dev_loss_tmo_callbk = zfcp_scsi_dev_loss_tmo_callbk,
 	.terminate_rport_io = zfcp_scsi_terminate_rport_io,
 	.show_host_port_state = 1,
+	.bsg_request = zfcp_execute_fc_job,
 	/* no functions registered for following dynamic attributes but
 	   directly set by LLDD */
 	.show_host_port_type = 1,
--- a/drivers/s390/scsi/zfcp_erp.c	2009-04-06 17:23:25.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-04-06 17:23:29.000000000 +0200
@@ -719,7 +719,7 @@ static void zfcp_erp_adapter_strategy_cl
 	zfcp_qdio_close(adapter);
 	zfcp_fsf_req_dismiss_all(adapter);
 	adapter->fsf_req_seq_no = 0;
-	zfcp_fc_wka_port_force_offline(&adapter->nsp);
+	zfcp_fc_wka_port_force_offline(&adapter->gs->ds);
 	/* all ports and units are closed */
 	zfcp_erp_modify_adapter_status(adapter, "erascl1", NULL,
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);

