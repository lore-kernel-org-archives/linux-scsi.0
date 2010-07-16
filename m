From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/10] zfcp: Trigger logging in the FCP channel on qdio error conditions
Date: Fri, 16 Jul 2010 15:37:43 +0200
Message-ID: <20100716134301.132651000@de.ibm.com>
References: <20100716133733.621672000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:44471 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965625Ab0GPNnF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 09:43:05 -0400
Content-Disposition: inline; filename=700-zfcp-log-errors.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Exploit the cio siosl function to trigger logging in the FCP channel
on qdio error conditions. Add a helper function in zfcp_qdio to ensure
that tracing is only triggered once before calling qdio_shutdown.

Trigger in zfcp for hardware logs are:
 - timeout for FSF requests to the FCP channel
 - "no recommendation" status from FCP channel
 - invalid FSF protocol status
 - stalled outbound queue
 - unknown request id on inbound queue
 - QDIO_ERROR_SLSB_STATE

All of the above triggers run from the Linux qdio softirq context, so
no additional synchronization is necessary for the handling of the
ZFCP_STATUS_ADAPTER_SIOSL_ISSUED flag.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h  |    1 +
 drivers/s390/scsi/zfcp_ext.h  |    1 +
 drivers/s390/scsi/zfcp_fsf.c  |    7 ++++++-
 drivers/s390/scsi/zfcp_qdio.c |   35 ++++++++++++++++++++++++++++++++---
 4 files changed, 40 insertions(+), 4 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -73,6 +73,7 @@ struct zfcp_reqlist;
 
 /* adapter status */
 #define ZFCP_STATUS_ADAPTER_QDIOUP		0x00000002
+#define ZFCP_STATUS_ADAPTER_SIOSL_ISSUED	0x00000004
 #define ZFCP_STATUS_ADAPTER_XCONFIG_OK		0x00000008
 #define ZFCP_STATUS_ADAPTER_HOST_CON_INIT	0x00000010
 #define ZFCP_STATUS_ADAPTER_ERP_PENDING		0x00000100
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -152,6 +152,7 @@ extern int zfcp_qdio_sbals_from_sg(struc
 				   struct scatterlist *);
 extern int zfcp_qdio_open(struct zfcp_qdio *);
 extern void zfcp_qdio_close(struct zfcp_qdio *);
+extern void zfcp_qdio_siosl(struct zfcp_adapter *);
 
 /* zfcp_scsi.c */
 extern struct zfcp_data zfcp_data;
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -21,6 +21,7 @@
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
+	zfcp_qdio_siosl(adapter);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
 				"fsrth_1", NULL);
 }
@@ -326,6 +327,7 @@ static void zfcp_fsf_fsfstatus_qual_eval
 		dev_err(&req->adapter->ccw_device->dev,
 			"The FCP adapter reported a problem "
 			"that cannot be recovered\n");
+		zfcp_qdio_siosl(req->adapter);
 		zfcp_erp_adapter_shutdown(req->adapter, 0, "fsfsqe1", req);
 		break;
 	}
@@ -416,6 +418,7 @@ static void zfcp_fsf_protstatus_eval(str
 		dev_err(&adapter->ccw_device->dev,
 			"0x%x is not a valid transfer protocol status\n",
 			qtcb->prefix.prot_status);
+		zfcp_qdio_siosl(adapter);
 		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_9", req);
 	}
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -2485,13 +2488,15 @@ void zfcp_fsf_reqid_check(struct zfcp_qd
 		req_id = (unsigned long) sbale->addr;
 		fsf_req = zfcp_reqlist_find_rm(adapter->req_list, req_id);
 
-		if (!fsf_req)
+		if (!fsf_req) {
 			/*
 			 * Unknown request means that we have potentially memory
 			 * corruption and must stop the machine immediately.
 			 */
+			zfcp_qdio_siosl(adapter);
 			panic("error: unknown req_id (%lx) on adapter %s.\n",
 			      req_id, dev_name(&adapter->ccw_device->dev));
+		}
 
 		fsf_req->qdio_req.sbal_response = sbal_idx;
 		zfcp_fsf_req_complete(fsf_req);
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -30,12 +30,15 @@ static int zfcp_qdio_buffers_enqueue(str
 	return 0;
 }
 
-static void zfcp_qdio_handler_error(struct zfcp_qdio *qdio, char *id)
+static void zfcp_qdio_handler_error(struct zfcp_qdio *qdio, char *id,
+				    unsigned int qdio_err)
 {
 	struct zfcp_adapter *adapter = qdio->adapter;
 
 	dev_warn(&adapter->ccw_device->dev, "A QDIO problem occurred\n");
 
+	if (qdio_err & QDIO_ERROR_SLSB_STATE)
+		zfcp_qdio_siosl(adapter);
 	zfcp_erp_adapter_reopen(adapter,
 				ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
 				ZFCP_STATUS_COMMON_ERP_FAILED, id, NULL);
@@ -74,7 +77,7 @@ static void zfcp_qdio_int_req(struct ccw
 
 	if (unlikely(qdio_err)) {
 		zfcp_dbf_hba_qdio(qdio->adapter->dbf, qdio_err, idx, count);
-		zfcp_qdio_handler_error(qdio, "qdireq1");
+		zfcp_qdio_handler_error(qdio, "qdireq1", qdio_err);
 		return;
 	}
 
@@ -95,7 +98,7 @@ static void zfcp_qdio_int_resp(struct cc
 
 	if (unlikely(qdio_err)) {
 		zfcp_dbf_hba_qdio(qdio->adapter->dbf, qdio_err, idx, count);
-		zfcp_qdio_handler_error(qdio, "qdires1");
+		zfcp_qdio_handler_error(qdio, "qdires1", qdio_err);
 		return;
 	}
 
@@ -361,6 +364,9 @@ int zfcp_qdio_open(struct zfcp_qdio *qdi
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)
 		return -EIO;
 
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_SIOSL_ISSUED,
+			  &qdio->adapter->status);
+
 	zfcp_qdio_setup_init_data(&init_data, qdio);
 
 	if (qdio_establish(&init_data))
@@ -440,3 +446,26 @@ int zfcp_qdio_setup(struct zfcp_adapter 
 	return 0;
 }
 
+/**
+ * zfcp_qdio_siosl - Trigger logging in FCP channel
+ * @adapter: The zfcp_adapter where to trigger logging
+ *
+ * Call the cio siosl function to trigger hardware logging.  This
+ * wrapper function sets a flag to ensure hardware logging is only
+ * triggered once before going through qdio shutdown.
+ *
+ * The triggers are always run from qdio tasklet context, so no
+ * additional synchronization is necessary.
+ */
+void zfcp_qdio_siosl(struct zfcp_adapter *adapter)
+{
+	int rc;
+
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_SIOSL_ISSUED)
+		return;
+
+	rc = ccw_device_siosl(adapter->ccw_device);
+	if (!rc)
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_SIOSL_ISSUED,
+				&adapter->status);
+}

