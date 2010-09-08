From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/12] zfcp: Move ACL/CFDC code to zfcp_cfdc.c
Date: Wed, 08 Sep 2010 14:39:59 +0200
Message-ID: <20100908124354.078115310@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:35779 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731Ab0IHMn6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:58 -0400
Content-Disposition: inline; filename=709-zfcp-acl-cfdc-code.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Move the code evaluating the ACL/CFDC specific errors to the file
zfcp_cfdc.c. With this change, all code related to the old access
control feature is kept in one file, not split across zfcp_erp.c and
zfcp_fsf.c.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_cfdc.c |  186 +++++++++++++++++++++++++++++++++++++++++-
 drivers/s390/scsi/zfcp_erp.c  |   82 ------------------
 drivers/s390/scsi/zfcp_ext.h  |   12 +-
 drivers/s390/scsi/zfcp_fsf.c  |  129 +++--------------------------
 4 files changed, 207 insertions(+), 202 deletions(-)

--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -2,9 +2,10 @@
  * zfcp device driver
  *
  * Userspace interface for accessing the
- * Access Control Lists / Control File Data Channel
+ * Access Control Lists / Control File Data Channel;
+ * handling of response code and states for ports and LUNs.
  *
- * Copyright IBM Corporation 2008, 2009
+ * Copyright IBM Corporation 2008, 2010
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -260,3 +261,184 @@ struct miscdevice zfcp_cfdc_misc = {
 	.name = "zfcp_cfdc",
 	.fops = &zfcp_cfdc_fops,
 };
+
+/**
+ * zfcp_cfdc_adapter_access_changed - Process change in adapter ACT
+ * @adapter: Adapter where the Access Control Table (ACT) changed
+ *
+ * After a change in the adapter ACT, check if access to any
+ * previously denied resources is now possible.
+ */
+void zfcp_cfdc_adapter_access_changed(struct zfcp_adapter *adapter)
+{
+	unsigned long flags;
+	struct zfcp_port *port;
+	struct scsi_device *sdev;
+	struct zfcp_scsi_dev *zfcp_sdev;
+	int status;
+
+	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
+		return;
+
+	read_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list) {
+		status = atomic_read(&port->status);
+		if ((status & ZFCP_STATUS_COMMON_ACCESS_DENIED) ||
+		    (status & ZFCP_STATUS_COMMON_ACCESS_BOXED))
+			zfcp_erp_port_reopen(port,
+					     ZFCP_STATUS_COMMON_ERP_FAILED,
+					     "cfaac_1", NULL);
+	}
+	read_unlock_irqrestore(&adapter->port_list_lock, flags);
+
+	shost_for_each_device(sdev, port->adapter->scsi_host) {
+		zfcp_sdev = sdev_to_zfcp(sdev);
+		status = atomic_read(&zfcp_sdev->status);
+		if ((status & ZFCP_STATUS_COMMON_ACCESS_DENIED) ||
+		    (status & ZFCP_STATUS_COMMON_ACCESS_BOXED))
+			zfcp_erp_lun_reopen(sdev,
+					    ZFCP_STATUS_COMMON_ERP_FAILED,
+					    "cfaac_2", NULL);
+	}
+}
+
+static void zfcp_act_eval_err(struct zfcp_adapter *adapter, u32 table)
+{
+	u16 subtable = table >> 16;
+	u16 rule = table & 0xffff;
+	const char *act_type[] = { "unknown", "OS", "WWPN", "DID", "LUN" };
+
+	if (subtable && subtable < ARRAY_SIZE(act_type))
+		dev_warn(&adapter->ccw_device->dev,
+			 "Access denied according to ACT rule type %s, "
+			 "rule %d\n", act_type[subtable], rule);
+}
+
+/**
+ * zfcp_cfdc_port_denied - Process "access denied" for port
+ * @port: The port where the acces has been denied
+ * @qual: The FSF status qualifier for the access denied FSF status
+ */
+void zfcp_cfdc_port_denied(struct zfcp_port *port,
+			   union fsf_status_qual *qual)
+{
+	dev_warn(&port->adapter->ccw_device->dev,
+		 "Access denied to port 0x%016Lx\n",
+		 (unsigned long long)port->wwpn);
+
+	zfcp_act_eval_err(port->adapter, qual->halfword[0]);
+	zfcp_act_eval_err(port->adapter, qual->halfword[1]);
+	zfcp_erp_modify_port_status(port, "cfadp_1", NULL,
+				    ZFCP_STATUS_COMMON_ERP_FAILED |
+				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
+}
+
+/**
+ * zfcp_cfdc_lun_denied - Process "access denied" for LUN
+ * @sdev: The SCSI device / LUN where the access has been denied
+ * @qual: The FSF status qualifier for the access denied FSF status
+ */
+void zfcp_cfdc_lun_denied(struct scsi_device *sdev,
+			  union fsf_status_qual *qual)
+{
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+
+	dev_warn(&zfcp_sdev->port->adapter->ccw_device->dev,
+		 "Access denied to LUN 0x%016Lx on port 0x%016Lx\n",
+		 zfcp_scsi_dev_lun(sdev),
+		 (unsigned long long)zfcp_sdev->port->wwpn);
+	zfcp_act_eval_err(zfcp_sdev->port->adapter, qual->halfword[0]);
+	zfcp_act_eval_err(zfcp_sdev->port->adapter, qual->halfword[1]);
+	zfcp_erp_modify_lun_status(sdev, "cfadl_1", NULL,
+				   ZFCP_STATUS_COMMON_ERP_FAILED |
+				   ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
+
+	atomic_clear_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
+	atomic_clear_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
+}
+
+/**
+ * zfcp_cfdc_lun_shrng_vltn - Evaluate LUN sharing violation status
+ * @sdev: The LUN / SCSI device where sharing violation occurred
+ * @qual: The FSF status qualifier from the LUN sharing violation
+ */
+void zfcp_cfdc_lun_shrng_vltn(struct scsi_device *sdev,
+			      union fsf_status_qual *qual)
+{
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+
+	if (qual->word[0])
+		dev_warn(&zfcp_sdev->port->adapter->ccw_device->dev,
+			 "LUN 0x%Lx on port 0x%Lx is already in "
+			 "use by CSS%d, MIF Image ID %x\n",
+			 zfcp_scsi_dev_lun(sdev),
+			 (unsigned long long)zfcp_sdev->port->wwpn,
+			 qual->fsf_queue_designator.cssid,
+			 qual->fsf_queue_designator.hla);
+	else
+		zfcp_act_eval_err(zfcp_sdev->port->adapter, qual->word[2]);
+
+	zfcp_erp_modify_lun_status(sdev, "fsosh_3", NULL,
+				   ZFCP_STATUS_COMMON_ERP_FAILED |
+				   ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
+	atomic_clear_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
+	atomic_clear_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
+}
+
+/**
+ * zfcp_cfdc_open_lun_eval - Eval access ctrl. status for successful "open lun"
+ * @sdev: The SCSI device / LUN where to evaluate the status
+ * @bottom: The qtcb bottom with the status from the "open lun"
+ *
+ * Returns: 0 if LUN is usable, -EACCES if the access control table
+ *          reports an unsupported configuration.
+ */
+int zfcp_cfdc_open_lun_eval(struct scsi_device *sdev,
+			    struct fsf_qtcb_bottom_support *bottom)
+{
+	int shared, rw;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
+
+	if ((adapter->connection_features & FSF_FEATURE_NPIV_MODE) ||
+	    !(adapter->adapter_features & FSF_FEATURE_LUN_SHARING) ||
+	    zfcp_ccw_priv_sch(adapter))
+		return 0;
+
+	shared = !(bottom->lun_access_info & FSF_UNIT_ACCESS_EXCLUSIVE);
+	rw = (bottom->lun_access_info & FSF_UNIT_ACCESS_OUTBOUND_TRANSFER);
+
+	if (shared)
+		atomic_set_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
+
+	if (!rw) {
+		atomic_set_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
+		dev_info(&adapter->ccw_device->dev, "SCSI device at LUN "
+			 "0x%016Lx on port 0x%016Lx opened read-only\n",
+			 zfcp_scsi_dev_lun(sdev),
+			 (unsigned long long)zfcp_sdev->port->wwpn);
+	}
+
+	if (!shared && !rw) {
+		dev_err(&adapter->ccw_device->dev, "Exclusive read-only access "
+			"not supported (LUN 0x%016Lx, port 0x%016Lx)\n",
+			zfcp_scsi_dev_lun(sdev),
+			(unsigned long long)zfcp_sdev->port->wwpn);
+		zfcp_erp_lun_failed(sdev, "fsosh_5", NULL);
+		zfcp_erp_lun_shutdown(sdev, 0, "fsouh_6", NULL);
+		return -EACCES;
+	}
+
+	if (shared && rw) {
+		dev_err(&adapter->ccw_device->dev,
+			"Shared read-write access not supported "
+			"(LUN 0x%016Lx, port 0x%016Lx)\n",
+			zfcp_scsi_dev_lun(sdev),
+			(unsigned long long)zfcp_sdev->port->wwpn);
+		zfcp_erp_lun_failed(sdev, "fsosh_7", NULL);
+		zfcp_erp_lun_shutdown(sdev, 0, "fsosh_8", NULL);
+		return -EACCES;
+	}
+
+	return 0;
+}
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -1593,85 +1593,3 @@ void zfcp_erp_lun_boxed(struct scsi_devi
 				   ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
 	zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
-
-/**
- * zfcp_erp_port_access_denied - Adapter denied access to port.
- * @port: port where access has been denied
- * @id: id for debug trace
- * @ref: reference for debug trace
- *
- * Since the adapter has denied access, stop using the port and the
- * attached LUNs.
- */
-void zfcp_erp_port_access_denied(struct zfcp_port *port, char *id, void *ref)
-{
-	zfcp_erp_modify_port_status(port, id, ref,
-				    ZFCP_STATUS_COMMON_ERP_FAILED |
-				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
-}
-
-/**
- * zfcp_erp_lun_access_denied - Adapter denied access to LUN.
- * @sdev: SCSI device / LUN where access has been denied
- * @id: id for debug trace
- * @ref: reference for debug trace
- *
- * Since the adapter has denied access, stop using the LUN.
- */
-void zfcp_erp_lun_access_denied(struct scsi_device *sdev, char *id, void *ref)
-{
-	zfcp_erp_modify_lun_status(sdev, id, ref,
-				   ZFCP_STATUS_COMMON_ERP_FAILED |
-				   ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
-}
-
-static void zfcp_erp_lun_access_changed(struct scsi_device *sdev, char *id,
-					void *ref)
-{
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
-	int status = atomic_read(&zfcp_sdev->status);
-
-	if (!(status & (ZFCP_STATUS_COMMON_ACCESS_DENIED |
-			ZFCP_STATUS_COMMON_ACCESS_BOXED)))
-		return;
-
-	zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
-}
-
-static void zfcp_erp_port_access_changed(struct zfcp_port *port, char *id,
-					 void *ref)
-{
-	struct scsi_device *sdev;
-	int status = atomic_read(&port->status);
-
-	if (!(status & (ZFCP_STATUS_COMMON_ACCESS_DENIED |
-			ZFCP_STATUS_COMMON_ACCESS_BOXED))) {
-		shost_for_each_device(sdev, port->adapter->scsi_host)
-			if (sdev_to_zfcp(sdev)->port == port)
-				zfcp_erp_lun_access_changed(sdev, id, ref);
-		return;
-	}
-
-	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
-}
-
-/**
- * zfcp_erp_adapter_access_changed - Process change in adapter ACT
- * @adapter: Adapter where the Access Control Table (ACT) changed
- * @id: Id for debug trace
- * @ref: Reference for debug trace
- */
-void zfcp_erp_adapter_access_changed(struct zfcp_adapter *adapter, char *id,
-				     void *ref)
-{
-	unsigned long flags;
-	struct zfcp_port *port;
-
-	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
-		return;
-
-	read_lock_irqsave(&adapter->port_list_lock, flags);
-	list_for_each_entry(port, &adapter->port_list, list)
-		zfcp_erp_port_access_changed(port, id, ref);
-	read_unlock_irqrestore(&adapter->port_list_lock, flags);
-}
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -34,6 +34,14 @@ extern void zfcp_ccw_adapter_put(struct
 
 /* zfcp_cfdc.c */
 extern struct miscdevice zfcp_cfdc_misc;
+extern void zfcp_cfdc_port_denied(struct zfcp_port *, union fsf_status_qual *);
+extern void zfcp_cfdc_lun_denied(struct scsi_device *, union fsf_status_qual *);
+extern void zfcp_cfdc_lun_shrng_vltn(struct scsi_device *,
+				     union fsf_status_qual *);
+extern int zfcp_cfdc_open_lun_eval(struct scsi_device *,
+				   struct fsf_qtcb_bottom_support *);
+extern void zfcp_cfdc_adapter_access_changed(struct zfcp_adapter *);
+
 
 /* zfcp_dbf.c */
 extern int zfcp_dbf_adapter_register(struct zfcp_adapter *);
@@ -88,10 +96,6 @@ extern void zfcp_erp_wait(struct zfcp_ad
 extern void zfcp_erp_notify(struct zfcp_erp_action *, unsigned long);
 extern void zfcp_erp_port_boxed(struct zfcp_port *, char *, void *);
 extern void zfcp_erp_lun_boxed(struct scsi_device *, char *, void *);
-extern void zfcp_erp_port_access_denied(struct zfcp_port *, char *, void *);
-extern void zfcp_erp_lun_access_denied(struct scsi_device *, char *, void *);
-extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *, char *,
-					    void *);
 extern void zfcp_erp_timeout_handler(unsigned long);
 
 /* zfcp_fc.c */
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -61,47 +61,6 @@ static u32 fsf_qtcb_type[] = {
 	[FSF_QTCB_UPLOAD_CONTROL_FILE] =  FSF_SUPPORT_COMMAND
 };
 
-static void zfcp_act_eval_err(struct zfcp_adapter *adapter, u32 table)
-{
-	u16 subtable = table >> 16;
-	u16 rule = table & 0xffff;
-	const char *act_type[] = { "unknown", "OS", "WWPN", "DID", "LUN" };
-
-	if (subtable && subtable < ARRAY_SIZE(act_type))
-		dev_warn(&adapter->ccw_device->dev,
-			 "Access denied according to ACT rule type %s, "
-			 "rule %d\n", act_type[subtable], rule);
-}
-
-static void zfcp_fsf_access_denied_port(struct zfcp_fsf_req *req,
-					struct zfcp_port *port)
-{
-	struct fsf_qtcb_header *header = &req->qtcb->header;
-	dev_warn(&req->adapter->ccw_device->dev,
-		 "Access denied to port 0x%016Lx\n",
-		 (unsigned long long)port->wwpn);
-	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[0]);
-	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[1]);
-	zfcp_erp_port_access_denied(port, "fspad_1", req);
-	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-}
-
-static void zfcp_fsf_access_denied_lun(struct zfcp_fsf_req *req,
-				       struct scsi_device *sdev)
-{
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
-
-	struct fsf_qtcb_header *header = &req->qtcb->header;
-	dev_warn(&req->adapter->ccw_device->dev,
-		 "Access denied to LUN 0x%016Lx on port 0x%016Lx\n",
-		 (unsigned long long)zfcp_scsi_dev_lun(sdev),
-		 (unsigned long long)zfcp_sdev->port->wwpn);
-	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[0]);
-	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[1]);
-	zfcp_erp_lun_access_denied(sdev, "fsadl_1", req);
-	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-}
-
 static void zfcp_fsf_class_not_supp(struct zfcp_fsf_req *req)
 {
 	dev_err(&req->adapter->ccw_device->dev, "FCP device not "
@@ -295,13 +254,12 @@ static void zfcp_fsf_status_read_handler
 		break;
 	case FSF_STATUS_READ_NOTIFICATION_LOST:
 		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_ACT_UPDATED)
-			zfcp_erp_adapter_access_changed(adapter, "fssrh_3",
-							req);
+			zfcp_cfdc_adapter_access_changed(adapter);
 		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_INCOMING_ELS)
 			queue_work(adapter->work_queue, &adapter->scan_work);
 		break;
 	case FSF_STATUS_READ_CFDC_UPDATED:
-		zfcp_erp_adapter_access_changed(adapter, "fssrh_4", req);
+		zfcp_cfdc_adapter_access_changed(adapter);
 		break;
 	case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
 		adapter->adapter_features = sr_buf->payload.word[0];
@@ -1116,8 +1074,10 @@ static void zfcp_fsf_send_els_handler(st
 	case FSF_RESPONSE_SIZE_TOO_LARGE:
 		break;
 	case FSF_ACCESS_DENIED:
-		if (port)
-			zfcp_fsf_access_denied_port(req, port);
+		if (port) {
+			zfcp_cfdc_port_denied(port, &header->fsf_status_qual);
+			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		}
 		break;
 	case FSF_SBAL_MISMATCH:
 		/* should never occure, avoided in zfcp_fsf_send_els */
@@ -1375,7 +1335,8 @@ static void zfcp_fsf_open_port_handler(s
 	case FSF_PORT_ALREADY_OPEN:
 		break;
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_port(req, port);
+		zfcp_cfdc_port_denied(port, &header->fsf_status_qual);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED:
 		dev_warn(&req->adapter->ccw_device->dev,
@@ -1682,7 +1643,7 @@ static void zfcp_fsf_close_physical_port
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_port(req, port);
+		zfcp_cfdc_port_denied(port, &header->fsf_status_qual);
 		break;
 	case FSF_PORT_BOXED:
 		/* can't use generic zfcp_erp_modify_port_status because
@@ -1768,9 +1729,6 @@ static void zfcp_fsf_open_lun_handler(st
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 	struct fsf_qtcb_bottom_support *bottom = &req->qtcb->bottom.support;
-	struct fsf_queue_designator *queue_designator =
-				&header->fsf_status_qual.fsf_queue_designator;
-	int exclusive, readwrite;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
@@ -1789,29 +1747,15 @@ static void zfcp_fsf_open_lun_handler(st
 	case FSF_LUN_ALREADY_OPEN:
 		break;
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_lun(req, sdev);
-		atomic_clear_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
-		atomic_clear_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
+		zfcp_cfdc_lun_denied(sdev, &header->fsf_status_qual);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_BOXED:
 		zfcp_erp_port_boxed(zfcp_sdev->port, "fsouh_2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_SHARING_VIOLATION:
-		if (header->fsf_status_qual.word[0])
-			dev_warn(&adapter->ccw_device->dev,
-				 "LUN 0x%Lx on port 0x%Lx is already in "
-				 "use by CSS%d, MIF Image ID %x\n",
-				 (unsigned long long)zfcp_scsi_dev_lun(sdev),
-				 (unsigned long long)zfcp_sdev->port->wwpn,
-				 queue_designator->cssid,
-				 queue_designator->hla);
-		else
-			zfcp_act_eval_err(adapter,
-					  header->fsf_status_qual.word[2]);
-		zfcp_erp_lun_access_denied(sdev, "fsolh_3", req);
-		atomic_clear_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
-		atomic_clear_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
+		zfcp_cfdc_lun_shrng_vltn(sdev, &header->fsf_status_qual);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_MAXIMUM_NUMBER_OF_LUNS_EXCEEDED:
@@ -1839,51 +1783,7 @@ static void zfcp_fsf_open_lun_handler(st
 	case FSF_GOOD:
 		zfcp_sdev->lun_handle = header->lun_handle;
 		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &zfcp_sdev->status);
-
-		if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE) &&
-		    (adapter->adapter_features & FSF_FEATURE_LUN_SHARING) &&
-		    !zfcp_ccw_priv_sch(adapter)) {
-			exclusive = (bottom->lun_access_info &
-					FSF_UNIT_ACCESS_EXCLUSIVE);
-			readwrite = (bottom->lun_access_info &
-					FSF_UNIT_ACCESS_OUTBOUND_TRANSFER);
-
-			if (!exclusive)
-				atomic_set_mask(ZFCP_STATUS_LUN_SHARED,
-						&zfcp_sdev->status);
-
-			if (!readwrite) {
-				atomic_set_mask(ZFCP_STATUS_LUN_READONLY,
-						&zfcp_sdev->status);
-				dev_info(&adapter->ccw_device->dev,
-					 "SCSI device at LUN 0x%016Lx on port "
-					 "0x%016Lx opened read-only\n",
-				    (unsigned long long)zfcp_scsi_dev_lun(sdev),
-				    (unsigned long long)zfcp_sdev->port->wwpn);
-        		}
-
-        		if (exclusive && !readwrite) {
-				dev_err(&adapter->ccw_device->dev,
-					"Exclusive read-only access not "
-					"supported (LUN 0x%016Lx, "
-					"port 0x%016Lx)\n",
-				    (unsigned long long)zfcp_scsi_dev_lun(sdev),
-				    (unsigned long long)zfcp_sdev->port->wwpn);
-				zfcp_erp_lun_failed(sdev, "fsolh_5", req);
-				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_lun_shutdown(sdev, 0, "fsolh_6", req);
-        		} else if (!exclusive && readwrite) {
-				dev_err(&adapter->ccw_device->dev,
-					"Shared read-write access not "
-					"supported (LUN 0x%016Lx, port "
-					"0x%016Lx)\n",
-				    (unsigned long long)zfcp_scsi_dev_lun(sdev),
-				    (unsigned long long)zfcp_sdev->port->wwpn);
-				zfcp_erp_lun_failed(sdev, "fsolh_7", req);
-				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_lun_shutdown(sdev, 0, "fsolh_8", req);
-        		}
-		}
+		zfcp_cfdc_open_lun_eval(sdev, bottom);
 		break;
 	}
 }
@@ -2106,7 +2006,8 @@ static void zfcp_fsf_fcp_handler_common(
 		zfcp_fsf_class_not_supp(req);
 		break;
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_lun(req, sdev);
+		zfcp_cfdc_lun_denied(sdev, &header->fsf_status_qual);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_DIRECTION_INDICATOR_NOT_VALID:
 		dev_err(&req->adapter->ccw_device->dev,

