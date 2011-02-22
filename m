From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 11/11] zfcp: Add information to symbolic port name when running in NPIV mode
Date: Tue, 22 Feb 2011 19:54:48 +0100
Message-ID: <20110222185537.495568514@linux.vnet.ibm.com>
References: <20110222185437.385767855@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:52306 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab1BVSzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2011 13:55:40 -0500
Content-Disposition: inline; filename=711-zfcp-port-name-info.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Query the FC symbolic port name for reporting in the fc_host sysfs and
enable the symbolic_name attribute in the fc_host sysfs. When running
in NPIV mode, extend the symbolic port name with the devno and the
hostname. This allows better identification of Linux systems for SAN
and storage administrators.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---


 drivers/s390/scsi/zfcp_aux.c  |    2 
 drivers/s390/scsi/zfcp_def.h  |    1 
 drivers/s390/scsi/zfcp_erp.c  |    2 
 drivers/s390/scsi/zfcp_ext.h  |    1 
 drivers/s390/scsi/zfcp_fc.c   |  120 ++++++++++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fc.h   |   42 ++++++++++++++
 drivers/s390/scsi/zfcp_scsi.c |    1 
 7 files changed, 169 insertions(+)
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -362,6 +362,7 @@ struct zfcp_adapter *zfcp_adapter_enqueu
 
 	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
 	INIT_WORK(&adapter->scan_work, zfcp_fc_scan_ports);
+	INIT_WORK(&adapter->ns_up_work, zfcp_fc_sym_name_update);
 
 	if (zfcp_qdio_setup(adapter))
 		goto failed;
@@ -427,6 +428,7 @@ void zfcp_adapter_unregister(struct zfcp
 
 	cancel_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
+	cancel_work_sync(&adapter->ns_up_work);
 	zfcp_destroy_adapter_work_queue(adapter);
 
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -189,6 +189,7 @@ struct zfcp_adapter {
 	struct fsf_qtcb_bottom_port *stats_reset_data;
 	unsigned long		stats_reset;
 	struct work_struct	scan_work;
+	struct work_struct	ns_up_work;
 	struct service_level	service_level;
 	struct workqueue_struct	*work_queue;
 	struct device_dma_parameters dma_parms;
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -1231,8 +1231,10 @@ static void zfcp_erp_action_cleanup(stru
 		if (result == ZFCP_ERP_SUCCEEDED) {
 			register_service_level(&adapter->service_level);
 			queue_work(adapter->work_queue, &adapter->scan_work);
+			queue_work(adapter->work_queue, &adapter->ns_up_work);
 		} else
 			unregister_service_level(&adapter->service_level);
+
 		kref_put(&adapter->ref, zfcp_adapter_release);
 		break;
 	}
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -96,6 +96,7 @@ extern int zfcp_fc_gs_setup(struct zfcp_
 extern void zfcp_fc_gs_destroy(struct zfcp_adapter *);
 extern int zfcp_fc_exec_bsg_job(struct fc_bsg_job *);
 extern int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *);
+extern void zfcp_fc_sym_name_update(struct work_struct *);
 
 /* zfcp_fsf.c */
 extern struct kmem_cache *zfcp_fsf_qtcb_cache;
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/utsname.h>
 #include <scsi/fc/fc_els.h>
 #include <scsi/libfc.h>
 #include "zfcp_ext.h"
@@ -696,6 +697,125 @@ out:
 	zfcp_fc_wka_port_put(&adapter->gs->ds);
 }
 
+static int zfcp_fc_gspn(struct zfcp_adapter *adapter,
+			struct zfcp_fc_req *fc_req)
+{
+	DECLARE_COMPLETION_ONSTACK(completion);
+	char devno[] = "DEVNO:";
+	struct zfcp_fsf_ct_els *ct_els = &fc_req->ct_els;
+	struct zfcp_fc_gspn_req *gspn_req = &fc_req->u.gspn.req;
+	struct zfcp_fc_gspn_rsp *gspn_rsp = &fc_req->u.gspn.rsp;
+	int ret;
+
+	zfcp_fc_ct_ns_init(&gspn_req->ct_hdr, FC_NS_GSPN_ID,
+			   FC_SYMBOLIC_NAME_SIZE);
+	hton24(gspn_req->gspn.fp_fid, fc_host_port_id(adapter->scsi_host));
+
+	sg_init_one(&fc_req->sg_req, gspn_req, sizeof(*gspn_req));
+	sg_init_one(&fc_req->sg_rsp, gspn_rsp, sizeof(*gspn_rsp));
+
+	ct_els->handler = zfcp_fc_complete;
+	ct_els->handler_data = &completion;
+	ct_els->req = &fc_req->sg_req;
+	ct_els->resp = &fc_req->sg_rsp;
+
+	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct_els, NULL,
+			       ZFCP_FC_CTELS_TMO);
+	if (ret)
+		return ret;
+
+	wait_for_completion(&completion);
+	if (ct_els->status)
+		return ct_els->status;
+
+	if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_NPIV &&
+	    !(strstr(gspn_rsp->gspn.fp_name, devno)))
+		snprintf(fc_host_symbolic_name(adapter->scsi_host),
+			 FC_SYMBOLIC_NAME_SIZE, "%s%s %s NAME: %s",
+			 gspn_rsp->gspn.fp_name, devno,
+			 dev_name(&adapter->ccw_device->dev),
+			 init_utsname()->nodename);
+	else
+		strlcpy(fc_host_symbolic_name(adapter->scsi_host),
+			gspn_rsp->gspn.fp_name, FC_SYMBOLIC_NAME_SIZE);
+
+	return 0;
+}
+
+static void zfcp_fc_rspn(struct zfcp_adapter *adapter,
+			 struct zfcp_fc_req *fc_req)
+{
+	DECLARE_COMPLETION_ONSTACK(completion);
+	struct Scsi_Host *shost = adapter->scsi_host;
+	struct zfcp_fsf_ct_els *ct_els = &fc_req->ct_els;
+	struct zfcp_fc_rspn_req *rspn_req = &fc_req->u.rspn.req;
+	struct fc_ct_hdr *rspn_rsp = &fc_req->u.rspn.rsp;
+	int ret, len;
+
+	zfcp_fc_ct_ns_init(&rspn_req->ct_hdr, FC_NS_RSPN_ID,
+			   FC_SYMBOLIC_NAME_SIZE);
+	hton24(rspn_req->rspn.fr_fid.fp_fid, fc_host_port_id(shost));
+	len = strlcpy(rspn_req->rspn.fr_name, fc_host_symbolic_name(shost),
+		      FC_SYMBOLIC_NAME_SIZE);
+	rspn_req->rspn.fr_name_len = len;
+
+	sg_init_one(&fc_req->sg_req, rspn_req, sizeof(*rspn_req));
+	sg_init_one(&fc_req->sg_rsp, rspn_rsp, sizeof(*rspn_rsp));
+
+	ct_els->handler = zfcp_fc_complete;
+	ct_els->handler_data = &completion;
+	ct_els->req = &fc_req->sg_req;
+	ct_els->resp = &fc_req->sg_rsp;
+
+	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct_els, NULL,
+			       ZFCP_FC_CTELS_TMO);
+	if (!ret)
+		wait_for_completion(&completion);
+}
+
+/**
+ * zfcp_fc_sym_name_update - Retrieve and update the symbolic port name
+ * @work: ns_up_work of the adapter where to update the symbolic port name
+ *
+ * Retrieve the current symbolic port name that may have been set by
+ * the hardware using the GSPN request and update the fc_host
+ * symbolic_name sysfs attribute. When running in NPIV mode (and hence
+ * the port name is unique for this system), update the symbolic port
+ * name to add Linux specific information and update the FC nameserver
+ * using the RSPN request.
+ */
+void zfcp_fc_sym_name_update(struct work_struct *work)
+{
+	struct zfcp_adapter *adapter = container_of(work, struct zfcp_adapter,
+						    ns_up_work);
+	int ret;
+	struct zfcp_fc_req *fc_req;
+
+	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT &&
+	    fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPIV)
+		return;
+
+	fc_req = kmem_cache_zalloc(zfcp_fc_req_cache, GFP_KERNEL);
+	if (!fc_req)
+		return;
+
+	ret = zfcp_fc_wka_port_get(&adapter->gs->ds);
+	if (ret)
+		goto out_free;
+
+	ret = zfcp_fc_gspn(adapter, fc_req);
+	if (ret || fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPIV)
+		goto out_ds_put;
+
+	memset(fc_req, 0, sizeof(*fc_req));
+	zfcp_fc_rspn(adapter, fc_req);
+
+out_ds_put:
+	zfcp_fc_wka_port_put(&adapter->gs->ds);
+out_free:
+	kmem_cache_free(zfcp_fc_req_cache, fc_req);
+}
+
 static void zfcp_fc_ct_els_job_handler(void *data)
 {
 	struct fc_bsg_job *job = data;
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -84,6 +84,40 @@ struct zfcp_fc_gpn_ft_req {
 } __packed;
 
 /**
+ * struct zfcp_fc_gspn_req - container for ct header plus GSPN_ID request
+ * @ct_hdr: FC GS common transport header
+ * @gspn: GSPN_ID request
+ */
+struct zfcp_fc_gspn_req {
+	struct fc_ct_hdr	ct_hdr;
+	struct fc_gid_pn_resp	gspn;
+} __packed;
+
+/**
+ * struct zfcp_fc_gspn_rsp - container for ct header plus GSPN_ID response
+ * @ct_hdr: FC GS common transport header
+ * @gspn: GSPN_ID response
+ * @name: The name string of the GSPN_ID response
+ */
+struct zfcp_fc_gspn_rsp {
+	struct fc_ct_hdr	ct_hdr;
+	struct fc_gspn_resp	gspn;
+	char			name[FC_SYMBOLIC_NAME_SIZE];
+} __packed;
+
+/**
+ * struct zfcp_fc_rspn_req - container for ct header plus RSPN_ID request
+ * @ct_hdr: FC GS common transport header
+ * @rspn: RSPN_ID request
+ * @name: The name string of the RSPN_ID request
+ */
+struct zfcp_fc_rspn_req {
+	struct fc_ct_hdr	ct_hdr;
+	struct fc_ns_rspn	rspn;
+	char			name[FC_SYMBOLIC_NAME_SIZE];
+} __packed;
+
+/**
  * struct zfcp_fc_req - Container for FC ELS and CT requests sent from zfcp
  * @ct_els: data required for issuing fsf command
  * @sg_req: scatterlist entry for request data
@@ -107,6 +141,14 @@ struct zfcp_fc_req {
 			struct scatterlist sg_rsp2[ZFCP_FC_GPN_FT_NUM_BUFS - 1];
 			struct zfcp_fc_gpn_ft_req	req;
 		} gpn_ft;
+		struct {
+			struct zfcp_fc_gspn_req		req;
+			struct zfcp_fc_gspn_rsp		rsp;
+		} gspn;
+		struct {
+			struct zfcp_fc_rspn_req		req;
+			struct fc_ct_hdr		rsp;
+		} rspn;
 	} u;
 };
 
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -720,6 +720,7 @@ struct fc_function_template zfcp_transpo
 	/* no functions registered for following dynamic attributes but
 	   directly set by LLDD */
 	.show_host_port_type = 1,
+	.show_host_symbolic_name = 1,
 	.show_host_speed = 1,
 	.show_host_port_id = 1,
 	.dd_bsg_size = sizeof(struct zfcp_fsf_ct_els),

