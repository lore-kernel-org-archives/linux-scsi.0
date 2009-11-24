From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/22] zfcp: Assign scheduled work to driver queue
Date: Tue, 24 Nov 2009 16:54:06 +0100
Message-ID: <20091124160137.440266000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44306 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbZKXQBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:32 -0500
Content-Disposition: inline; filename=708-zfcp-work-queue.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The port_scan work was scheduled to the work_queue provided by the
kernel. This resulted on SMP systems to a likely situation that more
than one scan_work were processed in parallel. This is not required
and openes the possibility of race conditions between the removal of
invalid ports and the enqueue of just scanned ports.  This patch
synchronizes the scan_work tasks by scheduling them to adapter local
work_queue.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |    2 +-
 drivers/s390/scsi/zfcp_erp.c   |    2 +-
 drivers/s390/scsi/zfcp_ext.h   |    3 +--
 drivers/s390/scsi/zfcp_fc.c    |   25 +++++++++----------------
 drivers/s390/scsi/zfcp_fsf.c   |    2 +-
 drivers/s390/scsi/zfcp_sysfs.c |    7 ++++---
 6 files changed, 17 insertions(+), 24 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:41.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:41.000000000 +0100
@@ -522,7 +522,7 @@ struct zfcp_adapter *zfcp_adapter_enqueu
 	adapter->ccw_device = ccw_device;
 
 	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
-	INIT_WORK(&adapter->scan_work, _zfcp_fc_scan_ports_later);
+	INIT_WORK(&adapter->scan_work, zfcp_fc_scan_ports);
 
 	if (zfcp_qdio_setup(adapter))
 		goto failed;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-11-23 09:59:41.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-11-23 09:59:41.000000000 +0100
@@ -1197,7 +1197,7 @@ static void zfcp_erp_action_cleanup(stru
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		if (result == ZFCP_ERP_SUCCEEDED) {
 			register_service_level(&adapter->service_level);
-			schedule_work(&adapter->scan_work);
+			queue_work(adapter->work_queue, &adapter->scan_work);
 		} else
 			unregister_service_level(&adapter->service_level);
 		kref_put(&adapter->ref, zfcp_adapter_release);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2009-11-23 09:59:40.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2009-11-23 09:59:41.000000000 +0100
@@ -94,8 +94,7 @@ extern void zfcp_erp_adapter_access_chan
 extern void zfcp_erp_timeout_handler(unsigned long);
 
 /* zfcp_fc.c */
-extern int zfcp_fc_scan_ports(struct zfcp_adapter *);
-extern void _zfcp_fc_scan_ports_later(struct work_struct *);
+extern void zfcp_fc_scan_ports(struct work_struct *);
 extern void zfcp_fc_incoming_els(struct zfcp_fsf_req *);
 extern void zfcp_fc_port_did_lookup(struct work_struct *);
 extern void zfcp_fc_trigger_did_lookup(struct zfcp_port *);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2009-11-23 09:59:41.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2009-11-23 09:59:41.000000000 +0100
@@ -184,7 +184,7 @@ static void zfcp_fc_incoming_rscn(struct
 		range_mask = rscn_range_mask[fcp_rscn_element->addr_format];
 		_zfcp_fc_incoming_rscn(fsf_req, range_mask, fcp_rscn_element);
 	}
-	schedule_work(&fsf_req->adapter->scan_work);
+	queue_work(fsf_req->adapter->work_queue, &fsf_req->adapter->scan_work);
 }
 
 static void zfcp_fc_incoming_wwpn(struct zfcp_fsf_req *req, u64 wwpn)
@@ -664,10 +664,12 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 
 /**
  * zfcp_fc_scan_ports - scan remote ports and attach new ports
- * @adapter: pointer to struct zfcp_adapter
+ * @work: reference to scheduled work
  */
-int zfcp_fc_scan_ports(struct zfcp_adapter *adapter)
+void zfcp_fc_scan_ports(struct work_struct *work)
 {
+	struct zfcp_adapter *adapter = container_of(work, struct zfcp_adapter,
+						    scan_work);
 	int ret, i;
 	struct zfcp_gpn_ft *gpn_ft;
 	int chain, max_entries, buf_num, max_bytes;
@@ -679,17 +681,14 @@ int zfcp_fc_scan_ports(struct zfcp_adapt
 
 	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT &&
 	    fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPIV)
-		return 0;
+		return;
 
-	ret = zfcp_fc_wka_port_get(&adapter->gs->ds);
-	if (ret)
-		return ret;
+	if (zfcp_fc_wka_port_get(&adapter->gs->ds))
+		return;
 
 	gpn_ft = zfcp_alloc_sg_env(buf_num);
-	if (!gpn_ft) {
-		ret = -ENOMEM;
+	if (!gpn_ft)
 		goto out;
-	}
 
 	for (i = 0; i < 3; i++) {
 		ret = zfcp_fc_send_gpn_ft(gpn_ft, adapter, max_bytes);
@@ -704,15 +703,9 @@ int zfcp_fc_scan_ports(struct zfcp_adapt
 	zfcp_free_sg_env(gpn_ft, buf_num);
 out:
 	zfcp_fc_wka_port_put(&adapter->gs->ds);
-	return ret;
 }
 
 
-void _zfcp_fc_scan_ports_later(struct work_struct *work)
-{
-	zfcp_fc_scan_ports(container_of(work, struct zfcp_adapter, scan_work));
-}
-
 struct zfcp_els_fc_job {
 	struct zfcp_send_els els;
 	struct fc_bsg_job *job;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-11-23 09:59:40.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-11-23 09:59:41.000000000 +0100
@@ -287,7 +287,7 @@ static void zfcp_fsf_status_read_handler
 			zfcp_erp_adapter_access_changed(adapter, "fssrh_3",
 							req);
 		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_INCOMING_ELS)
-			schedule_work(&adapter->scan_work);
+			queue_work(adapter->work_queue, &adapter->scan_work);
 		break;
 	case FSF_STATUS_READ_CFDC_UPDATED:
 		zfcp_erp_adapter_access_changed(adapter, "fssrh_4", req);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2009-11-23 09:59:41.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2009-11-23 09:59:41.000000000 +0100
@@ -184,15 +184,16 @@ static ssize_t zfcp_sysfs_port_rescan_st
 {
 	struct ccw_device *cdev = to_ccwdev(dev);
 	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
-	int ret;
 
 	if (!adapter)
 		return -ENODEV;
 
-	ret = zfcp_fc_scan_ports(adapter);
+	/* sync the user-space- with the kernel-invocation of scan_work */
+	queue_work(adapter->work_queue, &adapter->scan_work);
+	flush_work(&adapter->scan_work);
 	zfcp_ccw_adapter_put(adapter);
 
-	return ret ? ret : (ssize_t) count;
+	return (ssize_t) count;
 }
 static ZFCP_DEV_ATTR(adapter, port_rescan, S_IWUSR, NULL,
 		     zfcp_sysfs_port_rescan_store);

