From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 7/8] zfcp: Automatically attach remote ports
Date: Tue, 10 Jun 2008 18:21:00 +0200
Message-ID: <20080610162518.530294000@de.ibm.com>
References: <20080610162053.144590000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:47127 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbYFJQZY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 12:25:24 -0400
Content-Disposition: inline; filename=zfcp-auto-port-scan.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Automatically attach the remote ports in zfcp when the adapter is set
online. This is done by querying all available ports from the FC
namesever. The scan for remote ports is also triggered by RSCNs and
can be triggered manually with the sysfs attribute 'port_rescan'.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c           |   36 ++--
 drivers/s390/scsi/zfcp_dbf.c           |    4 
 drivers/s390/scsi/zfcp_def.h           |    5 
 drivers/s390/scsi/zfcp_erp.c           |   42 +++--
 drivers/s390/scsi/zfcp_ext.h           |    4 
 drivers/s390/scsi/zfcp_fc.c            |  248 +++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.c           |    3 
 drivers/s390/scsi/zfcp_sysfs_adapter.c |   25 +++
 8 files changed, 336 insertions(+), 31 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-06-10 17:41:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-06-10 17:42:15.000000000 +0200
@@ -568,6 +568,19 @@ static void _zfcp_status_read_scheduler(
 					     stat_work));
 }
 
+static int zfcp_nameserver_enqueue(struct zfcp_adapter *adapter)
+{
+	struct zfcp_port *port;
+
+	port = zfcp_port_enqueue(adapter, 0, ZFCP_STATUS_PORT_WKA,
+				 ZFCP_DID_DIRECTORY_SERVICE);
+	if (!port)
+		return -ENXIO;
+	zfcp_port_put(port);
+
+	return 0;
+}
+
 /*
  * Enqueues an adapter at the end of the adapter list in the driver data.
  * All adapter internal structures are set up.
@@ -648,6 +661,7 @@ zfcp_adapter_enqueue(struct ccw_device *
 	/* initialize lock of associated request queue */
 	rwlock_init(&adapter->req_q.lock);
 	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
+	INIT_WORK(&adapter->scan_work, _zfcp_scan_ports_later);
 
 	/* mark adapter unusable as long as sysfs registration is not complete */
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
@@ -673,6 +687,8 @@ zfcp_adapter_enqueue(struct ccw_device *
 
 	zfcp_data.adapters++;
 
+	zfcp_nameserver_enqueue(adapter);
+
 	goto out;
 
  generic_services_failed:
@@ -704,6 +720,7 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 	int retval = 0;
 	unsigned long flags;
 
+	cancel_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
 	zfcp_adapter_scsi_unregister(adapter);
 	device_unregister(&adapter->generic_services);
@@ -816,13 +833,15 @@ zfcp_port_enqueue(struct zfcp_adapter *a
 			kfree(port);
 			return NULL;
 		}
-		port->d_id = d_id;
 		port->sysfs_device.parent = &adapter->generic_services;
 	} else {
 		snprintf(port->sysfs_device.bus_id,
 			 BUS_ID_SIZE, "0x%016llx", wwpn);
 		port->sysfs_device.parent = &adapter->ccw_device->dev;
 	}
+
+	port->d_id = d_id;
+
 	port->sysfs_device.release = zfcp_sysfs_port_release;
 	dev_set_drvdata(&port->sysfs_device, port);
 
@@ -873,21 +892,6 @@ zfcp_port_dequeue(struct zfcp_port *port
 	device_unregister(&port->sysfs_device);
 }
 
-/* Enqueues a nameserver port */
-int
-zfcp_nameserver_enqueue(struct zfcp_adapter *adapter)
-{
-	struct zfcp_port *port;
-
-	port = zfcp_port_enqueue(adapter, 0, ZFCP_STATUS_PORT_WKA,
-				 ZFCP_DID_DIRECTORY_SERVICE);
-	if (!port)
-		return -ENXIO;
-	zfcp_port_put(port);
-
-	return 0;
-}
-
 void zfcp_sg_free_table(struct scatterlist *sg, int count)
 {
 	int i;
--- a/drivers/s390/scsi/zfcp_def.h	2008-06-10 17:41:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-06-10 17:42:15.000000000 +0200
@@ -282,7 +282,10 @@ struct zfcp_rc_entry {
 #define ZFCP_CT_DIRECTORY_SERVICE	0xFC
 #define ZFCP_CT_NAME_SERVER		0x02
 #define ZFCP_CT_SYNCHRONOUS		0x00
+#define ZFCP_CT_SCSI_FCP		0x08
+#define ZFCP_CT_UNABLE_TO_PERFORM_CMD	0x09
 #define ZFCP_CT_GID_PN			0x0121
+#define ZFCP_CT_GPN_FT			0x0172
 #define ZFCP_CT_MAX_SIZE		0x1020
 #define ZFCP_CT_ACCEPT			0x8002
 #define ZFCP_CT_REJECT			0x8001
@@ -311,6 +314,7 @@ struct zfcp_rc_entry {
 #define ZFCP_STATUS_COMMON_ERP_INUSE		0x01000000
 #define ZFCP_STATUS_COMMON_ACCESS_DENIED	0x00800000
 #define ZFCP_STATUS_COMMON_ACCESS_BOXED		0x00400000
+#define ZFCP_STATUS_COMMON_NOESC		0x00200000
 
 /* adapter status */
 #define ZFCP_STATUS_ADAPTER_QDIOUP		0x00000002
@@ -629,6 +633,7 @@ struct zfcp_adapter {
 	struct fc_host_statistics *fc_stats;
 	struct fsf_qtcb_bottom_port *stats_reset_data;
 	unsigned long		stats_reset;
+	struct work_struct	scan_work;
 };
 
 /*
--- a/drivers/s390/scsi/zfcp_ext.h	2008-06-10 17:41:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-06-10 17:42:15.000000000 +0200
@@ -37,6 +37,8 @@ extern struct zfcp_port *zfcp_port_enque
 extern void   zfcp_port_dequeue(struct zfcp_port *);
 extern struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *, fcp_lun_t);
 extern void   zfcp_unit_dequeue(struct zfcp_unit *);
+extern int zfcp_scan_ports(struct zfcp_adapter *);
+extern void _zfcp_scan_ports_later(struct work_struct *work);
 
 /******************************* S/390 IO ************************************/
 extern int  zfcp_ccw_register(void);
@@ -97,8 +99,6 @@ extern int  zfcp_fc_ns_gid_pn_request(st
 extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
 extern void  zfcp_test_link(struct zfcp_port *);
 
-extern int  zfcp_nameserver_enqueue(struct zfcp_adapter *);
-
 /******************************* SCSI ****************************************/
 extern int  zfcp_adapter_scsi_register(struct zfcp_adapter *);
 extern void zfcp_adapter_scsi_unregister(struct zfcp_adapter *);
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-06-10 17:41:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-06-10 17:42:15.000000000 +0200
@@ -596,6 +596,10 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[145]	= "recovery action being processed",
 	[146]	= "recovery action ready for next step",
 	[147]	= "qdio error inbound",
+	[148]   = "nameserver needed for port scan",
+	[149]   = "port scan",
+	[150]	= "ptp attach",
+	[151]   = "port validation failed",
 };
 
 static int zfcp_rec_dbf_view_format(debug_info_t *id, struct debug_view *view,
--- a/drivers/s390/scsi/zfcp_fc.c	2008-06-10 17:35:47.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-06-10 17:42:15.000000000 +0200
@@ -8,6 +8,37 @@
 
 #include "zfcp_ext.h"
 
+struct ct_iu_gpn_ft_req {
+	struct ct_hdr header;
+	u8 flags;
+	u8 domain_id_scope;
+	u8 area_id_scope;
+	u8 fc4_type;
+} __attribute__ ((packed));
+
+struct gpn_ft_resp_acc {
+	u8 control;
+	u8 port_id[3];
+	u8 reserved[4];
+	u64 wwpn;
+} __attribute__ ((packed));
+
+#define ZFCP_GPN_FT_ENTRIES ((PAGE_SIZE - sizeof(struct ct_hdr)) \
+				/ sizeof(struct gpn_ft_resp_acc))
+#define ZFCP_GPN_FT_BUFFERS 4
+#define ZFCP_GPN_FT_MAX_ENTRIES ZFCP_GPN_FT_BUFFERS * (ZFCP_GPN_FT_ENTRIES + 1)
+
+struct ct_iu_gpn_ft_resp {
+	struct ct_hdr header;
+	struct gpn_ft_resp_acc accept[ZFCP_GPN_FT_ENTRIES];
+} __attribute__ ((packed));
+
+struct zfcp_gpn_ft {
+	struct zfcp_send_ct ct;
+	struct scatterlist sg_req;
+	struct scatterlist sg_resp[ZFCP_GPN_FT_BUFFERS];
+};
+
 static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 				   struct fcp_rscn_element *elem)
 {
@@ -68,6 +99,7 @@ static void zfcp_fc_incoming_rscn(struct
 		}
 		_zfcp_fc_incoming_rscn(fsf_req, range_mask, fcp_rscn_element);
 	}
+	schedule_work(&fsf_req->adapter->scan_work);
 }
 
 static void zfcp_fc_incoming_wwpn(struct zfcp_fsf_req *req, wwn_t wwpn)
@@ -303,3 +335,219 @@ void zfcp_test_link(struct zfcp_port *po
 	zfcp_port_put(port);
 	zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
 }
+
+static int zfcp_scan_get_nameserver(struct zfcp_adapter *adapter)
+{
+	int ret;
+
+	if (!adapter->nameserver_port)
+		return -EINTR;
+
+	if (!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
+			       &adapter->nameserver_port->status)) {
+		ret = zfcp_erp_port_reopen(adapter->nameserver_port, 0, 148,
+					   NULL);
+		if (ret)
+			return ret;
+		zfcp_erp_wait(adapter);
+		zfcp_port_put(adapter->nameserver_port);
+	}
+	return !atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
+				  &adapter->nameserver_port->status);
+}
+
+static void zfcp_gpn_ft_handler(unsigned long _done)
+{
+	complete((struct completion *)_done);
+}
+
+static void zfcp_free_sg_env(struct zfcp_gpn_ft *gpn_ft)
+{
+	struct scatterlist *sg = &gpn_ft->sg_req;
+
+	kfree(sg_virt(sg)); /* free request buffer */
+	zfcp_sg_free_table(gpn_ft->sg_resp, ZFCP_GPN_FT_BUFFERS);
+
+	kfree(gpn_ft);
+}
+
+static struct zfcp_gpn_ft *zfcp_alloc_sg_env(void)
+{
+	struct zfcp_gpn_ft *gpn_ft;
+	struct ct_iu_gpn_ft_req *req;
+
+	gpn_ft = kzalloc(sizeof(*gpn_ft), GFP_KERNEL);
+	if (!gpn_ft)
+		return NULL;
+
+	req = kzalloc(sizeof(struct ct_iu_gpn_ft_req), GFP_KERNEL);
+	if (!req) {
+		kfree(gpn_ft);
+		gpn_ft = NULL;
+		goto out;
+	}
+	sg_init_one(&gpn_ft->sg_req, req, sizeof(*req));
+
+	if (zfcp_sg_setup_table(gpn_ft->sg_resp, ZFCP_GPN_FT_BUFFERS)) {
+		zfcp_free_sg_env(gpn_ft);
+		gpn_ft = NULL;
+	}
+out:
+	return gpn_ft;
+}
+
+
+static int zfcp_scan_issue_gpn_ft(struct zfcp_gpn_ft *gpn_ft,
+				  struct zfcp_adapter *adapter)
+{
+	struct zfcp_send_ct *ct = &gpn_ft->ct;
+	struct ct_iu_gpn_ft_req *req = sg_virt(&gpn_ft->sg_req);
+	struct completion done;
+	int ret;
+
+	/* prepare CT IU for GPN_FT */
+	req->header.revision = ZFCP_CT_REVISION;
+	req->header.gs_type = ZFCP_CT_DIRECTORY_SERVICE;
+	req->header.gs_subtype = ZFCP_CT_NAME_SERVER;
+	req->header.options = ZFCP_CT_SYNCHRONOUS;
+	req->header.cmd_rsp_code = ZFCP_CT_GPN_FT;
+	req->header.max_res_size = (sizeof(struct gpn_ft_resp_acc) *
+					(ZFCP_GPN_FT_MAX_ENTRIES - 1)) >> 2;
+	req->flags = 0;
+	req->domain_id_scope = 0;
+	req->area_id_scope = 0;
+	req->fc4_type = ZFCP_CT_SCSI_FCP;
+
+	/* prepare zfcp_send_ct */
+	ct->port = adapter->nameserver_port;
+	ct->handler = zfcp_gpn_ft_handler;
+	ct->handler_data = (unsigned long)&done;
+	ct->timeout = 10;
+	ct->req = &gpn_ft->sg_req;
+	ct->resp = gpn_ft->sg_resp;
+	ct->req_count = 1;
+	ct->resp_count = ZFCP_GPN_FT_BUFFERS;
+
+	init_completion(&done);
+	ret = zfcp_fsf_send_ct(ct, NULL, NULL);
+	if (!ret)
+		wait_for_completion(&done);
+	return ret;
+}
+
+static void zfcp_validate_port(struct zfcp_port *port)
+{
+	struct zfcp_adapter *adapter = port->adapter;
+
+	atomic_clear_mask(ZFCP_STATUS_COMMON_NOESC, &port->status);
+
+	if (port == adapter->nameserver_port)
+		return;
+	if ((port->supported_classes != 0) || (port->units != 0)) {
+		zfcp_port_put(port);
+		return;
+	}
+	zfcp_erp_port_shutdown(port, 0, 151, NULL);
+	zfcp_erp_wait(adapter);
+	zfcp_port_put(port);
+	zfcp_port_dequeue(port);
+}
+
+static int zfcp_scan_eval_gpn_ft(struct zfcp_gpn_ft *gpn_ft)
+{
+	struct zfcp_send_ct *ct = &gpn_ft->ct;
+	struct scatterlist *sg = gpn_ft->sg_resp;
+	struct ct_hdr *hdr = sg_virt(sg);
+	struct gpn_ft_resp_acc *acc = sg_virt(sg);
+	struct zfcp_adapter *adapter = ct->port->adapter;
+	struct zfcp_port *port, *tmp;
+	u32 d_id;
+	int ret = 0, x;
+
+	if (ct->status)
+		return -EIO;
+
+	if (hdr->cmd_rsp_code != ZFCP_CT_ACCEPT) {
+		if (hdr->reason_code == ZFCP_CT_UNABLE_TO_PERFORM_CMD)
+			return -EAGAIN; /* might be a temporary condition */
+		return -EIO;
+	}
+
+	if (hdr->max_res_size)
+		return -E2BIG;
+
+	down(&zfcp_data.config_sema);
+
+	/* first entry is the header */
+	for (x = 1; x < ZFCP_GPN_FT_MAX_ENTRIES; x++) {
+		if (x % (ZFCP_GPN_FT_ENTRIES + 1))
+			acc++;
+		else
+			acc = sg_virt(++sg);
+
+		d_id = acc->port_id[0] << 16 | acc->port_id[1] << 8 |
+		       acc->port_id[2];
+
+		/* skip the adapter's port and known remote ports */
+		if (acc->wwpn == fc_host_port_name(adapter->scsi_host) ||
+		     zfcp_get_port_by_did(adapter, d_id))
+			continue;
+
+		port = zfcp_port_enqueue(adapter, acc->wwpn,
+					 ZFCP_STATUS_PORT_DID_DID |
+					 ZFCP_STATUS_COMMON_NOESC, d_id);
+		if (port)
+			zfcp_erp_port_reopen(port, 0, 149, NULL);
+		else
+			ret = -ENOMEM;
+		if (acc->control & 0x80) /* last entry */
+			break;
+	}
+
+	zfcp_erp_wait(adapter);
+	list_for_each_entry_safe(port, tmp, &adapter->port_list_head, list)
+		zfcp_validate_port(port);
+	up(&zfcp_data.config_sema);
+	return ret;
+}
+
+/**
+ * zfcp_scan_ports - scan remote ports and attach new ports
+ * @adapter: pointer to struct zfcp_adapter
+ */
+int zfcp_scan_ports(struct zfcp_adapter *adapter)
+{
+	int ret, i;
+	struct zfcp_gpn_ft *gpn_ft;
+
+	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT)
+		return 0;
+
+	ret = zfcp_scan_get_nameserver(adapter);
+	if (ret)
+		return ret;
+
+	gpn_ft = zfcp_alloc_sg_env();
+	if (!gpn_ft)
+		return -ENOMEM;
+
+	for (i = 0; i < 3; i++) {
+		ret = zfcp_scan_issue_gpn_ft(gpn_ft, adapter);
+		if (!ret) {
+			ret = zfcp_scan_eval_gpn_ft(gpn_ft);
+			if (ret == -EAGAIN)
+				ssleep(1);
+			else
+				break;
+		}
+	}
+	zfcp_free_sg_env(gpn_ft);
+
+	return ret;
+}
+
+
+void _zfcp_scan_ports_later(struct work_struct *work)
+{
+	zfcp_scan_ports(container_of(work, struct zfcp_adapter, scan_work));
+}
--- a/drivers/s390/scsi/zfcp_erp.c	2008-06-10 17:41:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-06-10 17:42:15.000000000 +0200
@@ -1199,6 +1199,10 @@ zfcp_erp_strategy_check_port(struct zfcp
 		zfcp_erp_port_unblock(port);
 		break;
 	case ZFCP_ERP_FAILED :
+		if (atomic_test_mask(ZFCP_STATUS_COMMON_NOESC, &port->status)) {
+			zfcp_erp_port_block(port, 0);
+			result = ZFCP_ERP_EXIT;
+		}
 		atomic_inc(&port->erp_counter);
 		if (atomic_read(&port->erp_counter) > ZFCP_MAX_ERPS)
 			zfcp_erp_port_failed(port, 22, NULL);
@@ -1607,6 +1611,7 @@ zfcp_erp_adapter_strategy_generic(struct
 		goto failed_openfcp;
 
 	atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &erp_action->adapter->status);
+	schedule_work(&erp_action->adapter->scan_work);
 	goto out;
 
  close_only:
@@ -1665,10 +1670,19 @@ zfcp_erp_adapter_strategy_open_fsf(struc
 	return zfcp_erp_adapter_strategy_open_fsf_statusread(erp_action);
 }
 
+static void zfcp_erp_open_ptp_port(struct zfcp_adapter *adapter)
+{
+	struct zfcp_port *port;
+	port = zfcp_port_enqueue(adapter, adapter->peer_wwpn, 0,
+				 adapter->peer_d_id);
+	if (!port) /* error or port already attached */
+		return;
+	zfcp_erp_port_reopen_internal(port, 0, 150, NULL);
+}
+
 static int
 zfcp_erp_adapter_strategy_open_fsf_xconfig(struct zfcp_erp_action *erp_action)
 {
-	int retval = ZFCP_ERP_SUCCEEDED;
 	int retries;
 	int sleep = ZFCP_EXCHANGE_CONFIG_DATA_FIRST_SLEEP;
 	struct zfcp_adapter *adapter = erp_action->adapter;
@@ -1682,8 +1696,9 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 		zfcp_erp_action_to_running(erp_action);
 		write_unlock_irq(&adapter->erp_lock);
 		if (zfcp_fsf_exchange_config_data(erp_action)) {
-			retval = ZFCP_ERP_FAILED;
-			break;
+			atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
+					  &adapter->status);
+			return ZFCP_ERP_FAILED;
 		}
 
 		/*
@@ -1719,9 +1734,12 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 
 	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
 			      &adapter->status))
-		retval = ZFCP_ERP_FAILED;
+		return ZFCP_ERP_FAILED;
 
-	return retval;
+	if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP)
+		zfcp_erp_open_ptp_port(adapter);
+
+	return ZFCP_ERP_SUCCEEDED;
 }
 
 static int
@@ -1899,14 +1917,12 @@ zfcp_erp_port_strategy_open_common(struc
 			retval = zfcp_erp_port_strategy_open_port(erp_action);
 			break;
 		}
-		if (!(adapter->nameserver_port)) {
-			retval = zfcp_nameserver_enqueue(adapter);
-			if (retval != 0) {
-				dev_err(&adapter->ccw_device->dev,
-					"Nameserver port unavailable.\n");
-				retval = ZFCP_ERP_FAILED;
-				break;
-			}
+
+		if (!adapter->nameserver_port) {
+			dev_err(&adapter->ccw_device->dev,
+				"Nameserver port unavailable.\n");
+			retval = ZFCP_ERP_FAILED;
+			break;
 		}
 		if (!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 				      &adapter->nameserver_port->status)) {
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-06-10 17:41:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-06-10 17:42:15.000000000 +0200
@@ -874,6 +874,9 @@ zfcp_fsf_status_read_handler(struct zfcp
 		if (status_buffer->status_subtype &
 		    FSF_STATUS_READ_SUB_ACT_UPDATED)
 			zfcp_erp_adapter_access_changed(adapter, 135, fsf_req);
+		if (status_buffer->status_subtype &
+		    FSF_STATUS_READ_SUB_INCOMING_ELS)
+			schedule_work(&adapter->scan_work);
 		break;
 
 	case FSF_STATUS_READ_CFDC_UPDATED:
--- a/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-06-10 17:41:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-06-10 17:42:15.000000000 +0200
@@ -85,6 +85,30 @@ zfcp_sysfs_port_add_store(struct device 
 static DEVICE_ATTR(port_add, S_IWUSR, NULL, zfcp_sysfs_port_add_store);
 
 /**
+ * zfcp_sysfs_port_rescan - trigger manual port rescan
+ * @dev: pointer to belonging device
+ * @attr: pointer to struct device_attribute
+ * @buf: pointer to input buffer
+ * @count: number of bytes in buffer
+ */
+static ssize_t zfcp_sysfs_port_rescan_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct zfcp_adapter *adapter;
+	int ret;
+
+	adapter = dev_get_drvdata(dev);
+	if (atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status))
+		return -EBUSY;
+
+	ret = zfcp_scan_ports(adapter);
+
+	return ret ? ret : (ssize_t) count;
+}
+static DEVICE_ATTR(port_rescan, S_IWUSR, NULL, zfcp_sysfs_port_rescan_store);
+
+/**
  * zfcp_sysfs_port_remove_store - remove a port from sysfs tree
  * @dev: pointer to belonging device
  * @buf: pointer to input buffer
@@ -214,6 +238,7 @@ static struct attribute *zfcp_adapter_at
 	&dev_attr_in_recovery.attr,
 	&dev_attr_port_remove.attr,
 	&dev_attr_port_add.attr,
+	&dev_attr_port_rescan.attr,
 	&dev_attr_peer_wwnn.attr,
 	&dev_attr_peer_wwpn.attr,
 	&dev_attr_peer_d_id.attr,

-- 
