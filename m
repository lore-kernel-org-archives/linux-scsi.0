From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 7/8] zfcp: No automatic port_rescan on events
Date: Tue, 04 Sep 2012 15:23:35 +0200
Message-ID: <20120904132348.953177437@linux.vnet.ibm.com>
References: <20120904132328.564402930@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:54174 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047Ab2IDN3n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 09:29:43 -0400
Received: from /spool/local
	by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Tue, 4 Sep 2012 14:29:41 +0100
Content-Disposition: inline; filename=710-zfcp-optional-port-rescan-on-rscn.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>

From: Steffen Maier <maier@linux.vnet.ibm.com>

In FC fabrics with large zones, the automatic port_rescan on incoming ELS
and any adapter recovery can cause quite some traffic at the very same
time, especially if lots of Linux images share an HBA, which is common on
s390. This can cause trouble and failures. Fix this by making such port
rescans dependent on a user configurable module parameter.

The following unconditional automatic port rescans remain as is:
On setting an adapter online and
on manual user-triggered writes to the sysfs attribute port_rescan.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_ccw.c |    7 ++++++-
 drivers/s390/scsi/zfcp_erp.c |    2 +-
 drivers/s390/scsi/zfcp_ext.h |    2 ++
 drivers/s390/scsi/zfcp_fc.c  |   23 ++++++++++++++++++++++-
 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 5 files changed, 32 insertions(+), 4 deletions(-)

--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -57,7 +57,7 @@ static int zfcp_ccw_activate(struct ccw_
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
 				tag);
 	zfcp_erp_wait(adapter);
-	flush_work(&adapter->scan_work);
+	flush_work(&adapter->scan_work); /* ok to call even if nothing queued */
 
 	zfcp_ccw_adapter_put(adapter);
 
@@ -171,6 +171,11 @@ static int zfcp_ccw_set_online(struct cc
 	adapter->req_no = 0;
 
 	zfcp_ccw_activate(cdev, 0, "ccsonl1");
+	/* scan for remote ports
+	   either at the end of any successful adapter recovery
+	   or only after the adapter recovery for setting a device online */
+	zfcp_fc_inverse_conditional_port_scan(adapter);
+	flush_work(&adapter->scan_work); /* ok to call even if nothing queued */
 	zfcp_ccw_adapter_put(adapter);
 	return 0;
 }
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -1230,7 +1230,7 @@ static void zfcp_erp_action_cleanup(stru
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		if (result == ZFCP_ERP_SUCCEEDED) {
 			register_service_level(&adapter->service_level);
-			queue_work(adapter->work_queue, &adapter->scan_work);
+			zfcp_fc_conditional_port_scan(adapter);
 			queue_work(adapter->work_queue, &adapter->ns_up_work);
 		} else
 			unregister_service_level(&adapter->service_level);
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -99,6 +99,8 @@ extern void zfcp_fc_gs_destroy(struct zf
 extern int zfcp_fc_exec_bsg_job(struct fc_bsg_job *);
 extern int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *);
 extern void zfcp_fc_sym_name_update(struct work_struct *);
+extern void zfcp_fc_conditional_port_scan(struct zfcp_adapter *);
+extern void zfcp_fc_inverse_conditional_port_scan(struct zfcp_adapter *);
 
 /* zfcp_fsf.c */
 extern struct kmem_cache *zfcp_fsf_qtcb_cache;
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -26,6 +26,27 @@ static u32 zfcp_fc_rscn_range_mask[] = {
 	[ELS_ADDR_FMT_FAB]		= 0x000000,
 };
 
+static bool no_auto_port_rescan;
+module_param_named(no_auto_port_rescan, no_auto_port_rescan, bool, 0600);
+MODULE_PARM_DESC(no_auto_port_rescan,
+		 "no automatic port_rescan (default off)");
+
+void zfcp_fc_conditional_port_scan(struct zfcp_adapter *adapter)
+{
+	if (no_auto_port_rescan)
+		return;
+
+	queue_work(adapter->work_queue, &adapter->scan_work);
+}
+
+void zfcp_fc_inverse_conditional_port_scan(struct zfcp_adapter *adapter)
+{
+	if (!no_auto_port_rescan)
+		return;
+
+	queue_work(adapter->work_queue, &adapter->scan_work);
+}
+
 /**
  * zfcp_fc_post_event - post event to userspace via fc_transport
  * @work: work struct with enqueued events
@@ -206,7 +227,7 @@ static void zfcp_fc_incoming_rscn(struct
 		zfcp_fc_enqueue_event(fsf_req->adapter, FCH_EVT_RSCN,
 				      *(u32 *)page);
 	}
-	queue_work(fsf_req->adapter->work_queue, &fsf_req->adapter->scan_work);
+	zfcp_fc_conditional_port_scan(fsf_req->adapter);
 }
 
 static void zfcp_fc_incoming_wwpn(struct zfcp_fsf_req *req, u64 wwpn)
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -257,7 +257,7 @@ static void zfcp_fsf_status_read_handler
 		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_ACT_UPDATED)
 			zfcp_cfdc_adapter_access_changed(adapter);
 		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_INCOMING_ELS)
-			queue_work(adapter->work_queue, &adapter->scan_work);
+			zfcp_fc_conditional_port_scan(adapter);
 		break;
 	case FSF_STATUS_READ_CFDC_UPDATED:
 		zfcp_cfdc_adapter_access_changed(adapter);

