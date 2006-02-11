From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 2/4] zfcp: fix adapter erp when link is unplugged
Date: Sat, 11 Feb 2006 01:41:50 +0100
Message-ID: <20060211004150.GA17341@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:57583 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S932283AbWBKAmf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 19:42:35 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id k1B0gYHm239930
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 00:42:34 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1B0gYC3238900
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 01:42:34 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k1B0gXUt018682
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 01:42:33 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

Remove endless polling for replug of the local link. Just wait for
link up notification.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

 drivers/s390/scsi/zfcp_def.h |    5 ---
 drivers/s390/scsi/zfcp_erp.c |   80 +++++++++++++++---------------------------
 drivers/s390/scsi/zfcp_fsf.c |   74 ++++++++++++++++++++++-----------------
 3 files changed, 69 insertions(+), 90 deletions(-)

41d46dbc33d5020cd3434b496eb204de0e8a2ed2
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 7dac56c..f031199 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -152,11 +152,6 @@ typedef u32 scsi_lun_t;
 #define ZFCP_EXCHANGE_CONFIG_DATA_FIRST_SLEEP	100
 #define ZFCP_EXCHANGE_CONFIG_DATA_RETRIES	7
 
-/* Retry 5 times every 2 second, then every minute */
-#define ZFCP_EXCHANGE_PORT_DATA_SHORT_RETRIES	5
-#define ZFCP_EXCHANGE_PORT_DATA_SHORT_SLEEP	200
-#define ZFCP_EXCHANGE_PORT_DATA_LONG_SLEEP	6000
-
 /* timeout value for "default timer" for fsf requests */
 #define ZFCP_FSF_REQUEST_TIMEOUT (60*HZ);
 
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index da947e6..8ed6fcb 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -2246,15 +2246,6 @@ zfcp_erp_adapter_strategy_open_fsf(struc
 {
 	int retval;
 
-	if ((atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
-			      &erp_action->adapter->status)) &&
-	    (erp_action->adapter->adapter_features &
-	     FSF_FEATURE_HBAAPI_MANAGEMENT)) {
-		zfcp_erp_adapter_strategy_open_fsf_xport(erp_action);
-		atomic_set(&erp_action->adapter->erp_counter, 0);
-		return ZFCP_ERP_FAILED;
-	}
-
 	retval = zfcp_erp_adapter_strategy_open_fsf_xconfig(erp_action);
 	if (retval == ZFCP_ERP_FAILED)
 		return ZFCP_ERP_FAILED;
@@ -2266,13 +2257,6 @@ zfcp_erp_adapter_strategy_open_fsf(struc
 	return zfcp_erp_adapter_strategy_open_fsf_statusread(erp_action);
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_adapter_strategy_open_fsf_xconfig(struct zfcp_erp_action *erp_action)
 {
@@ -2350,48 +2334,40 @@ static int
 zfcp_erp_adapter_strategy_open_fsf_xport(struct zfcp_erp_action *erp_action)
 {
 	int ret;
-	int retries;
-	int sleep;
-	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_adapter *adapter;
 
+	adapter = erp_action->adapter;
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
 
-	retries = 0;
-	do {
-		write_lock(&adapter->erp_lock);
-		zfcp_erp_action_to_running(erp_action);
-		write_unlock(&adapter->erp_lock);
-		zfcp_erp_timeout_init(erp_action);
-		ret = zfcp_fsf_exchange_port_data(erp_action, adapter, NULL);
-		if (ret == -EOPNOTSUPP) {
-			debug_text_event(adapter->erp_dbf, 3, "a_xport_notsupp");
-			return ZFCP_ERP_SUCCEEDED;
-		} else if (ret) {
-			debug_text_event(adapter->erp_dbf, 3, "a_xport_failed");
-			return ZFCP_ERP_FAILED;
-		}
-		debug_text_event(adapter->erp_dbf, 6, "a_xport_ok");
+	write_lock(&adapter->erp_lock);
+	zfcp_erp_action_to_running(erp_action);
+	write_unlock(&adapter->erp_lock);
 
-		down(&adapter->erp_ready_sem);
-		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
-			ZFCP_LOG_INFO("error: exchange of port data "
-				      "for adapter %s timed out\n",
-				      zfcp_get_busid_by_adapter(adapter));
-			break;
-		}
-		if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
-				      &adapter->status))
-			break;
+	zfcp_erp_timeout_init(erp_action);
+	ret = zfcp_fsf_exchange_port_data(erp_action, adapter, NULL);
+	if (ret == -EOPNOTSUPP) {
+		debug_text_event(adapter->erp_dbf, 3, "a_xport_notsupp");
+		return ZFCP_ERP_SUCCEEDED;
+	} else if (ret) {
+		debug_text_event(adapter->erp_dbf, 3, "a_xport_failed");
+		return ZFCP_ERP_FAILED;
+	}
+	debug_text_event(adapter->erp_dbf, 6, "a_xport_ok");
 
-		if (retries < ZFCP_EXCHANGE_PORT_DATA_SHORT_RETRIES) {
-			sleep = ZFCP_EXCHANGE_PORT_DATA_SHORT_SLEEP;
-			retries++;
-		} else
-			sleep = ZFCP_EXCHANGE_PORT_DATA_LONG_SLEEP;
-		schedule_timeout(sleep);
-	} while (1);
+	ret = ZFCP_ERP_SUCCEEDED;
+	down(&adapter->erp_ready_sem);
+	if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
+		ZFCP_LOG_INFO("error: exchange port data timed out (adapter "
+			      "%s)\n", zfcp_get_busid_by_adapter(adapter));
+		ret = ZFCP_ERP_FAILED;
+	}
+	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status)) {
+		ZFCP_LOG_INFO("error: exchange port data failed (adapter "
+			      "%s\n", zfcp_get_busid_by_adapter(adapter));
+		ret = ZFCP_ERP_FAILED;
+	}
 
-	return ZFCP_ERP_SUCCEEDED;
+	return ret;
 }
 
 /*
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 9f0cb3d..bd8cd4d 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -388,6 +388,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 	case FSF_PROT_LINK_DOWN:
 		zfcp_fsf_link_down_info_eval(adapter,
 					     &prot_status_qual->link_down_info);
+		zfcp_erp_adapter_reopen(adapter, 0);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -558,10 +559,8 @@ zfcp_fsf_link_down_info_eval(struct zfcp
 
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
 
-	if (link_down == NULL) {
-		zfcp_erp_adapter_reopen(adapter, 0);
-		return;
-	}
+	if (link_down == NULL)
+		goto out;
 
 	switch (link_down->error_code) {
 	case FSF_PSQ_LINK_NO_LIGHT:
@@ -643,16 +642,8 @@ zfcp_fsf_link_down_info_eval(struct zfcp
 				link_down->explanation_code,
 				link_down->vendor_specific_code);
 
-	switch (link_down->error_code) {
-	case FSF_PSQ_LINK_NO_LIGHT:
-	case FSF_PSQ_LINK_WRAP_PLUG:
-	case FSF_PSQ_LINK_NO_FCP:
-	case FSF_PSQ_LINK_FIRMWARE_UPDATE:
-		zfcp_erp_adapter_reopen(adapter, 0);
-		break;
-	default:
-		zfcp_erp_adapter_failed(adapter);
-	}
+ out:
+	zfcp_erp_adapter_failed(adapter);
 }
 
 /*
@@ -2304,6 +2295,35 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 	return retval;
 }
 
+/**
+ * zfcp_fsf_exchange_port_evaluate
+ * @fsf_req: fsf_req which belongs to xchg port data request
+ * @xchg_ok: specifies if xchg port data was incomplete or complete (0/1)
+ */
+static void
+zfcp_fsf_exchange_port_evaluate(struct zfcp_fsf_req *fsf_req, int xchg_ok)
+{
+	struct zfcp_adapter *adapter;
+	struct fsf_qtcb *qtcb;
+	struct fsf_qtcb_bottom_port *bottom, *data;
+	struct Scsi_Host *shost;
+
+	adapter = fsf_req->adapter;
+	qtcb = fsf_req->qtcb;
+	bottom = &qtcb->bottom.port;
+	shost = adapter->scsi_host;
+
+	data = (struct fsf_qtcb_bottom_port*) fsf_req->data;
+	if (data)
+		memcpy(data, bottom, sizeof(struct fsf_qtcb_bottom_port));
+
+	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
+		fc_host_permanent_port_name(shost) = bottom->wwpn;
+	else
+		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
+	fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
+	fc_host_supported_speeds(shost) = bottom->supported_speed;
+}
 
 /**
  * zfcp_fsf_exchange_port_data_handler - handler for exchange_port_data request
@@ -2312,38 +2332,26 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 static void
 zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *fsf_req)
 {
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct Scsi_Host *shost = adapter->scsi_host;
-	struct fsf_qtcb *qtcb = fsf_req->qtcb;
-	struct fsf_qtcb_bottom_port *bottom, *data;
+	struct zfcp_adapter *adapter;
+	struct fsf_qtcb *qtcb;
+
+	adapter = fsf_req->adapter;
+	qtcb = fsf_req->qtcb;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
 	switch (qtcb->header.fsf_status) {
         case FSF_GOOD:
+		zfcp_fsf_exchange_port_evaluate(fsf_req, 1);
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
-
-		bottom = &qtcb->bottom.port;
-		data = (struct fsf_qtcb_bottom_port*) fsf_req->data;
-		if (data)
-			memcpy(data, bottom, sizeof(struct fsf_qtcb_bottom_port));
-		if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
-			fc_host_permanent_port_name(shost) = bottom->wwpn;
-		else
-			fc_host_permanent_port_name(shost) =
-				fc_host_port_name(shost);
-		fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
-		fc_host_supported_speeds(shost) = bottom->supported_speed;
 		break;
-
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
+		zfcp_fsf_exchange_port_evaluate(fsf_req, 0);
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
-
 		zfcp_fsf_link_down_info_eval(adapter,
 			&qtcb->header.fsf_status_qual.link_down_info);
                 break;
-
         default:
 		debug_text_event(adapter->erp_dbf, 0, "xchg-port-ng");
 		debug_event(adapter->erp_dbf, 0,
-- 
0.99.9n-g5a22
