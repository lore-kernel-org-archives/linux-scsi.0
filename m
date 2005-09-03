From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 7/7] zfcp: provide support for NPIV
Date: Sat, 3 Sep 2005 14:35:34 +0200
Message-ID: <20050903123534.GA7944@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:11159 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750911AbVICMhu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 08:37:50 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j83CbmOI086236
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 12:37:48 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j83Cbmih180980
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:37:48 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j83CbmOB015588
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:37:48 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Maxim Shchetynin <maxim@de.ibm.com>

From: Maxim Shchetynin <maxim@de.ibm.com>

zfcp: provide support for NPIV

N_Port ID Virtualization (NPIV) allows a single FCP port to appear as
multiple, distinct ports providing separate port identification. NPIV
is supported by FC HBAs on System z9. zfcp was adapted to support this
new feature.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

 zfcp_dbf.c           |   11 +
 zfcp_def.h           |   13 +-
 zfcp_erp.c           |   95 +++++++++++++-
 zfcp_ext.h           |    3 
 zfcp_fsf.c           |  330 +++++++++++++++++++++++++++++++++------------------
 zfcp_fsf.h           |   51 ++++++-
 zfcp_sysfs_adapter.c |    4 
 7 files changed, 367 insertions(+), 140 deletions(-)

diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_dbf.c linux-2.6.13/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_dbf.c	2005-09-03 12:23:43.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_dbf.c	2005-09-03 12:32:48.000000000 +0200
@@ -279,9 +279,18 @@ zfcp_hba_dbf_event_fsf_unsol(const char 
 			break;
 
 		case FSF_STATUS_READ_LINK_DOWN:
-			rec->type.status.payload_size = sizeof(u64);
+			switch (status_buffer->status_subtype) {
+			case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
+			case FSF_STATUS_READ_SUB_FDISC_FAILED:
+				rec->type.status.payload_size =
+					sizeof(struct fsf_link_down_info);
+			}
 			break;
 
+		case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
+			rec->type.status.payload_size =
+			    ZFCP_DBF_UNSOL_PAYLOAD_FEATURE_UPDATE_ALERT;
+			break;
 		}
 		memcpy(&rec->type.status.payload,
 		       &status_buffer->payload, rec->type.status.payload_size);
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_def.h linux-2.6.13/drivers/s390/scsi/zfcp_def.h
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_def.h	2005-09-03 12:23:43.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_def.h	2005-09-03 12:32:48.000000000 +0200
@@ -66,7 +66,7 @@
 /********************* GENERAL DEFINES *********************************/
 
 /* zfcp version number, it consists of major, minor, and patch-level number */
-#define ZFCP_VERSION		"4.4.0"
+#define ZFCP_VERSION		"4.5.0"
 
 /**
  * zfcp_sg_to_address - determine kernel address from struct scatterlist
@@ -154,6 +154,11 @@ typedef u32 scsi_lun_t;
 #define ZFCP_EXCHANGE_CONFIG_DATA_FIRST_SLEEP	100
 #define ZFCP_EXCHANGE_CONFIG_DATA_RETRIES	7
 
+/* Retry 5 times every 2 second, then every minute */
+#define ZFCP_EXCHANGE_PORT_DATA_SHORT_RETRIES	5
+#define ZFCP_EXCHANGE_PORT_DATA_SHORT_SLEEP	200
+#define ZFCP_EXCHANGE_PORT_DATA_LONG_SLEEP	6000
+
 /* timeout value for "default timer" for fsf requests */
 #define ZFCP_FSF_REQUEST_TIMEOUT (60*HZ);
 
@@ -638,6 +643,7 @@ do { \
 #define ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL	0x00000080
 #define ZFCP_STATUS_ADAPTER_ERP_PENDING		0x00000100
 #define ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED	0x00000200
+#define ZFCP_STATUS_ADAPTER_XPORT_OK		0x00000800
 
 #define ZFCP_STATUS_ADAPTER_SCSI_UP			\
 		(ZFCP_STATUS_COMMON_UNBLOCKED |	\
@@ -915,13 +921,16 @@ struct zfcp_adapter {
 	wwn_t			peer_wwnn;	   /* P2P peer WWNN */
 	wwn_t			peer_wwpn;	   /* P2P peer WWPN */
 	fc_id_t			peer_d_id;	   /* P2P peer D_ID */
+	wwn_t			physical_wwpn;     /* WWPN of physical port */
+	fc_id_t			physical_s_id;     /* local FC port ID */
 	struct ccw_device       *ccw_device;	   /* S/390 ccw device */
 	u8			fc_service_class;
 	u32			fc_topology;	   /* FC topology */
 	u32			fc_link_speed;	   /* FC interface speed */
 	u32			hydra_version;	   /* Hydra version */
 	u32			fsf_lic_version;
-        u32			supported_features;/* of FCP channel */
+	u32			adapter_features;  /* FCP channel features */
+	u32			connection_features; /* host connection features */
         u32			hardware_version;  /* of FCP channel */
         u8			serial_number[32]; /* of hardware */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_erp.c linux-2.6.13/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_erp.c	2005-09-03 12:20:07.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_erp.c	2005-09-03 12:32:48.000000000 +0200
@@ -82,6 +82,7 @@ static int zfcp_erp_adapter_strategy_ope
 static int zfcp_erp_adapter_strategy_open_qdio(struct zfcp_erp_action *);
 static int zfcp_erp_adapter_strategy_open_fsf(struct zfcp_erp_action *);
 static int zfcp_erp_adapter_strategy_open_fsf_xconfig(struct zfcp_erp_action *);
+static int zfcp_erp_adapter_strategy_open_fsf_xport(struct zfcp_erp_action *);
 static int zfcp_erp_adapter_strategy_open_fsf_statusread(
 	struct zfcp_erp_action *);
 
@@ -2258,16 +2259,21 @@ zfcp_erp_adapter_strategy_close_qdio(str
 static int
 zfcp_erp_adapter_strategy_open_fsf(struct zfcp_erp_action *erp_action)
 {
-	int retval;
+	int xconfig, xport;
+
+	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
+			     &erp_action->adapter->status)) {
+		zfcp_erp_adapter_strategy_open_fsf_xport(erp_action);
+		atomic_set(&erp_action->adapter->erp_counter, 0);
+		return ZFCP_ERP_FAILED;
+	}
 
-	/* do 'exchange configuration data' */
-	retval = zfcp_erp_adapter_strategy_open_fsf_xconfig(erp_action);
-	if (retval == ZFCP_ERP_FAILED)
-		return retval;
+	xconfig = zfcp_erp_adapter_strategy_open_fsf_xconfig(erp_action);
+	xport   = zfcp_erp_adapter_strategy_open_fsf_xport(erp_action);
+	if ((xconfig == ZFCP_ERP_FAILED) || (xport == ZFCP_ERP_FAILED))
+		return ZFCP_ERP_FAILED;
 
-	/* start the desired number of Status Reads */
-	retval = zfcp_erp_adapter_strategy_open_fsf_statusread(erp_action);
-	return retval;
+	return zfcp_erp_adapter_strategy_open_fsf_statusread(erp_action);
 }
 
 /*
@@ -2350,6 +2356,76 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 	return retval;
 }
 
+static int
+zfcp_erp_adapter_strategy_open_fsf_xport(struct zfcp_erp_action *erp_action)
+{
+	int retval = ZFCP_ERP_SUCCEEDED;
+	int retries;
+	int sleep;
+	struct zfcp_adapter *adapter = erp_action->adapter;
+
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
+
+	for (retries = 0; ; retries++) {
+		ZFCP_LOG_DEBUG("Doing exchange port data\n");
+		zfcp_erp_action_to_running(erp_action);
+		zfcp_erp_timeout_init(erp_action);
+		if (zfcp_fsf_exchange_port_data(erp_action, adapter, NULL)) {
+			retval = ZFCP_ERP_FAILED;
+			debug_text_event(adapter->erp_dbf, 5, "a_fstx_xf");
+			ZFCP_LOG_INFO("error: initiation of exchange of "
+				      "port data failed for adapter %s\n",
+				      zfcp_get_busid_by_adapter(adapter));
+			break;
+		}
+		debug_text_event(adapter->erp_dbf, 6, "a_fstx_xok");
+		ZFCP_LOG_DEBUG("Xchange underway\n");
+
+		/*
+		 * Why this works:
+		 * Both the normal completion handler as well as the timeout
+		 * handler will do an 'up' when the 'exchange port data'
+		 * request completes or times out. Thus, the signal to go on
+		 * won't be lost utilizing this semaphore.
+		 * Furthermore, this 'adapter_reopen' action is
+		 * guaranteed to be the only action being there (highest action
+		 * which prevents other actions from being created).
+		 * Resulting from that, the wake signal recognized here
+		 * _must_ be the one belonging to the 'exchange port
+		 * data' request.
+		 */
+		down(&adapter->erp_ready_sem);
+		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
+			ZFCP_LOG_INFO("error: exchange of port data "
+				      "for adapter %s timed out\n",
+				      zfcp_get_busid_by_adapter(adapter));
+			break;
+		}
+
+		if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
+				      &adapter->status))
+			break;
+
+		ZFCP_LOG_DEBUG("host connection still initialising... "
+			       "waiting and retrying...\n");
+		/* sleep a little bit before retry */
+		sleep = retries < ZFCP_EXCHANGE_PORT_DATA_SHORT_RETRIES ?
+				ZFCP_EXCHANGE_PORT_DATA_SHORT_SLEEP :
+				ZFCP_EXCHANGE_PORT_DATA_LONG_SLEEP;
+		msleep(jiffies_to_msecs(sleep));
+	}
+
+	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
+			     &adapter->status)) {
+		ZFCP_LOG_INFO("error: exchange of port data for "
+			      "adapter %s failed\n",
+			      zfcp_get_busid_by_adapter(adapter));
+		retval = ZFCP_ERP_FAILED;
+	}
+
+	return retval;
+}
+
 /*
  * function:	
  *
@@ -3599,6 +3675,9 @@ zfcp_erp_adapter_access_changed(struct z
 	struct zfcp_port *port;
 	unsigned long flags;
 
+	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
+		return;
+
 	debug_text_event(adapter->erp_dbf, 3, "a_access_recover");
 	debug_event(adapter->erp_dbf, 3, &adapter->name, 8);
 
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_ext.h linux-2.6.13/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_ext.h	2005-09-03 12:23:43.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_ext.h	2005-09-03 12:32:48.000000000 +0200
@@ -96,7 +96,8 @@ extern int  zfcp_fsf_open_unit(struct zf
 extern int  zfcp_fsf_close_unit(struct zfcp_erp_action *);
 
 extern int  zfcp_fsf_exchange_config_data(struct zfcp_erp_action *);
-extern int  zfcp_fsf_exchange_port_data(struct zfcp_adapter *,
+extern int  zfcp_fsf_exchange_port_data(struct zfcp_erp_action *,
+					struct zfcp_adapter *,
 					struct fsf_qtcb_bottom_port *);
 extern int  zfcp_fsf_control_file(struct zfcp_adapter *, struct zfcp_fsf_req **,
 				  u32, u32, struct zfcp_sg_list *);
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_fsf.c linux-2.6.13/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_fsf.c	2005-09-03 12:23:43.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_fsf.c	2005-09-03 12:32:48.000000000 +0200
@@ -59,6 +59,8 @@ static int zfcp_fsf_req_send(struct zfcp
 static int zfcp_fsf_protstatus_eval(struct zfcp_fsf_req *);
 static int zfcp_fsf_fsfstatus_eval(struct zfcp_fsf_req *);
 static int zfcp_fsf_fsfstatus_qual_eval(struct zfcp_fsf_req *);
+static void zfcp_fsf_link_down_info_eval(struct zfcp_adapter *,
+	struct fsf_link_down_info *);
 static int zfcp_fsf_req_dispatch(struct zfcp_fsf_req *);
 static void zfcp_fsf_req_dismiss(struct zfcp_fsf_req *);
 
@@ -375,87 +377,19 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 		break;
 
 	case FSF_PROT_DUPLICATE_REQUEST_ID:
-		if (fsf_req->qtcb) {
 			ZFCP_LOG_NORMAL("bug: The request identifier 0x%Lx "
 					"to the adapter %s is ambiguous. "
-					"Stopping all operations on this "
-					"adapter.\n",
-					*(unsigned long long *)
-					(&fsf_req->qtcb->bottom.support.
-					 req_handle),
-					zfcp_get_busid_by_adapter(adapter));
-		} else {
-			ZFCP_LOG_NORMAL("bug: The request identifier %p "
-					"to the adapter %s is ambiguous. "
-					"Stopping all operations on this "
-					"adapter. "
-					"(bug: got this for an unsolicited "
-					"status read request)\n",
-					fsf_req,
+				"Stopping all operations on this adapter.\n",
+				*(unsigned long long*)
+				(&qtcb->bottom.support.req_handle),
 					zfcp_get_busid_by_adapter(adapter));
-		}
 		zfcp_erp_adapter_shutdown(adapter, 0);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_PROT_LINK_DOWN:
-		/*
-		 * 'test and set' is not atomic here -
-		 * it's ok as long as calls to our response queue handler
-		 * (and thus execution of this code here) are serialized
-		 * by the qdio module
-		 */
-		if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
-				      &adapter->status)) {
-			switch (fsf_req->qtcb->prefix.prot_status_qual.
-				locallink_error.code) {
-			case FSF_PSQ_LINK_NOLIGHT:
-				ZFCP_LOG_INFO("The local link to adapter %s "
-					      "is down (no light detected).\n",
-					      zfcp_get_busid_by_adapter(
-						      adapter));
-				break;
-			case FSF_PSQ_LINK_WRAPPLUG:
-				ZFCP_LOG_INFO("The local link to adapter %s "
-					      "is down (wrap plug detected).\n",
-					      zfcp_get_busid_by_adapter(
-						      adapter));
-				break;
-			case FSF_PSQ_LINK_NOFCP:
-				ZFCP_LOG_INFO("The local link to adapter %s "
-					      "is down (adjacent node on "
-					      "link does not support FCP).\n",
-					      zfcp_get_busid_by_adapter(
-						      adapter));
-				break;
-			default:
-				ZFCP_LOG_INFO("The local link to adapter %s "
-					      "is down "
-					      "(warning: unknown reason "
-					      "code).\n",
-					      zfcp_get_busid_by_adapter(
-						      adapter));
-				break;
-
-			}
-			/*
-			 * Due to the 'erp failed' flag the adapter won't
-			 * be recovered but will be just set to 'blocked'
-			 * state. All subordinary devices will have state
-			 * 'blocked' and 'erp failed', too.
-			 * Thus the adapter is still able to provide
-			 * 'link up' status without being flooded with
-			 * requests.
-			 * (note: even 'close port' is not permitted)
-			 */
-			ZFCP_LOG_INFO("Stopping all operations for adapter "
-				      "%s.\n",
-				      zfcp_get_busid_by_adapter(adapter));
-			atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
-					ZFCP_STATUS_COMMON_ERP_FAILED,
-					&adapter->status);
-			zfcp_erp_adapter_reopen(adapter, 0);
-		}
+		zfcp_fsf_link_down_info_eval(adapter,
+					     &prot_status_qual->link_down_info);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -613,6 +547,110 @@ zfcp_fsf_fsfstatus_qual_eval(struct zfcp
 	return retval;
 }
 
+/**
+ * zfcp_fsf_link_down_info_eval - evaluate link down information block
+ */
+static void
+zfcp_fsf_link_down_info_eval(struct zfcp_adapter *adapter,
+			     struct fsf_link_down_info *link_down)
+{
+	switch (link_down->error_code) {
+	case FSF_PSQ_LINK_NO_LIGHT:
+		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
+				"(no light detected)\n",
+				zfcp_get_busid_by_adapter(adapter));
+		break;
+	case FSF_PSQ_LINK_WRAP_PLUG:
+		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
+				"(wrap plug detected)\n",
+				zfcp_get_busid_by_adapter(adapter));
+		break;
+	case FSF_PSQ_LINK_NO_FCP:
+		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
+				"(adjacent node on link does not support FCP)\n",
+				zfcp_get_busid_by_adapter(adapter));
+		break;
+	case FSF_PSQ_LINK_FIRMWARE_UPDATE:
+		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
+				"(firmware update in progress)\n",
+				zfcp_get_busid_by_adapter(adapter));
+			break;
+	case FSF_PSQ_LINK_INVALID_WWPN:
+		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
+				"(duplicate or invalid WWPN detected)\n",
+				zfcp_get_busid_by_adapter(adapter));
+		break;
+	case FSF_PSQ_LINK_NO_NPIV_SUPPORT:
+		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
+				"(no support for NPIV by Fabric)\n",
+				zfcp_get_busid_by_adapter(adapter));
+		break;
+	case FSF_PSQ_LINK_NO_FCP_RESOURCES:
+		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
+				"(out of resource in FCP daughtercard)\n",
+				zfcp_get_busid_by_adapter(adapter));
+		break;
+	case FSF_PSQ_LINK_NO_FABRIC_RESOURCES:
+		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
+				"(out of resource in Fabric)\n",
+				zfcp_get_busid_by_adapter(adapter));
+		break;
+	case FSF_PSQ_LINK_FABRIC_LOGIN_UNABLE:
+		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
+				"(unable to Fabric login)\n",
+				zfcp_get_busid_by_adapter(adapter));
+		break;
+	case FSF_PSQ_LINK_WWPN_ASSIGNMENT_CORRUPTED:
+		ZFCP_LOG_NORMAL("WWPN assignment file corrupted on adapter %s\n",
+				zfcp_get_busid_by_adapter(adapter));
+		break;
+	case FSF_PSQ_LINK_MODE_TABLE_CURRUPTED:
+		ZFCP_LOG_NORMAL("Mode table corrupted on adapter %s\n",
+				zfcp_get_busid_by_adapter(adapter));
+		break;
+	case FSF_PSQ_LINK_NO_WWPN_ASSIGNMENT:
+		ZFCP_LOG_NORMAL("No WWPN for assignment table on adapter %s\n",
+				zfcp_get_busid_by_adapter(adapter));
+		break;
+	default:
+		ZFCP_LOG_NORMAL("The local link to adapter %s is down "
+				"(warning: unknown reason code %d)\n",
+				zfcp_get_busid_by_adapter(adapter),
+				link_down->error_code);
+	}
+
+	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
+		ZFCP_LOG_DEBUG("Debug information to link down: "
+		               "primary_status=0x%02x "
+		               "ioerr_code=0x%02x "
+		               "action_code=0x%02x "
+		               "reason_code=0x%02x "
+		               "explanation_code=0x%02x "
+		               "vendor_specific_code=0x%02x\n",
+				link_down->primary_status,
+				link_down->ioerr_code,
+				link_down->action_code,
+				link_down->reason_code,
+				link_down->explanation_code,
+				link_down->vendor_specific_code);
+
+	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
+			      &adapter->status)) {
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
+				&adapter->status);
+		switch (link_down->error_code) {
+		case FSF_PSQ_LINK_NO_LIGHT:
+		case FSF_PSQ_LINK_WRAP_PLUG:
+		case FSF_PSQ_LINK_NO_FCP:
+		case FSF_PSQ_LINK_FIRMWARE_UPDATE:
+			zfcp_erp_adapter_reopen(adapter, 0);
+			break;
+		default:
+			zfcp_erp_adapter_failed(adapter);
+		}
+	}
+}
+
 /*
  * function:	zfcp_fsf_req_dispatch
  *
@@ -877,17 +915,32 @@ zfcp_fsf_status_read_handler(struct zfcp
 		break;
 
 	case FSF_STATUS_READ_LINK_DOWN:
-		debug_text_event(adapter->erp_dbf, 0, "unsol_link_down:");
-		ZFCP_LOG_INFO("Local link to adapter %s is down\n",
+		switch (status_buffer->status_subtype) {
+		case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
+			ZFCP_LOG_INFO("Physical link to adapter %s is down\n",
+				      zfcp_get_busid_by_adapter(adapter));
+			break;
+		case FSF_STATUS_READ_SUB_FDISC_FAILED:
+			ZFCP_LOG_INFO("Local link to adapter %s is down "
+				      "due to failed FDISC login\n",
 			      zfcp_get_busid_by_adapter(adapter));
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
-				&adapter->status);
-		zfcp_erp_adapter_failed(adapter);
+			break;
+		case FSF_STATUS_READ_SUB_FIRMWARE_UPDATE:
+			ZFCP_LOG_INFO("Local link to adapter %s is down "
+				      "due to firmware update on adapter\n",
+				      zfcp_get_busid_by_adapter(adapter));
+			break;
+		default:
+			ZFCP_LOG_INFO("Local link to adapter %s is down "
+				      "due to unknown reason\n",
+				      zfcp_get_busid_by_adapter(adapter));
+		};
+		zfcp_fsf_link_down_info_eval(adapter,
+			(struct fsf_link_down_info *) &status_buffer->payload);
 		break;
 
 	case FSF_STATUS_READ_LINK_UP:
-		debug_text_event(adapter->erp_dbf, 2, "unsol_link_up:");
-		ZFCP_LOG_INFO("Local link to adapter %s was replugged. "
+		ZFCP_LOG_NORMAL("Local link to adapter %s was replugged. "
 			      "Restarting operations on this adapter\n",
 			      zfcp_get_busid_by_adapter(adapter));
 		/* All ports should be marked as ready to run again */
@@ -922,6 +975,16 @@ zfcp_fsf_status_read_handler(struct zfcp
 		}
 		break;
 
+	case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
+		debug_text_event(adapter->erp_dbf, 2, "unsol_features:");
+		ZFCP_LOG_INFO("List of supported features on adapter %s has "
+			      "been changed from 0x%08X to 0x%08X\n",
+			      zfcp_get_busid_by_adapter(adapter),
+			      *(u32*) (status_buffer->payload + 4),
+			      *(u32*) (status_buffer->payload));
+		adapter->adapter_features = *(u32*) status_buffer->payload;
+		break;
+
 	default:
 		ZFCP_LOG_NORMAL("warning: An unsolicited status packet of unknown "
 				"type was received (debug info 0x%x)\n",
@@ -1281,7 +1344,7 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
                 sbale[3].addr = zfcp_sg_to_address(&ct->resp[0]);
                 sbale[3].length = ct->resp[0].length;
                 sbale[3].flags |= SBAL_FLAGS_LAST_ENTRY;
-        } else if (adapter->supported_features &
+	} else if (adapter->adapter_features &
                    FSF_FEATURE_ELS_CT_CHAINED_SBALS) {
                 /* try to use chained SBALs */
                 bytes = zfcp_qdio_sbals_from_sg(fsf_req,
@@ -1584,7 +1647,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
                 sbale[3].addr = zfcp_sg_to_address(&els->resp[0]);
                 sbale[3].length = els->resp[0].length;
                 sbale[3].flags |= SBAL_FLAGS_LAST_ENTRY;
-        } else if (adapter->supported_features &
+	} else if (adapter->adapter_features &
                    FSF_FEATURE_ELS_CT_CHAINED_SBALS) {
                 /* try to use chained SBALs */
                 bytes = zfcp_qdio_sbals_from_sg(fsf_req,
@@ -1877,7 +1940,9 @@ zfcp_fsf_exchange_config_data(struct zfc
 
 	erp_action->fsf_req->erp_action = erp_action;
 	erp_action->fsf_req->qtcb->bottom.config.feature_selection =
-		(FSF_FEATURE_CFDC | FSF_FEATURE_LUN_SHARING);
+			FSF_FEATURE_CFDC |
+			FSF_FEATURE_LUN_SHARING |
+			FSF_FEATURE_UPDATE_ALERT;
 
 	/* start QDIO request for this FSF request */
 	retval = zfcp_fsf_req_send(erp_action->fsf_req, &erp_action->timer);
@@ -1918,7 +1983,8 @@ zfcp_fsf_exchange_config_evaluate(struct
 	ZFCP_LOG_DEBUG("low/high QTCB version 0x%x/0x%x of FSF\n",
 		       bottom->low_qtcb_version, bottom->high_qtcb_version);
 	adapter->fsf_lic_version = bottom->lic_version;
-	adapter->supported_features = bottom->supported_features;
+	adapter->adapter_features = bottom->adapter_features;
+	adapter->connection_features = bottom->connection_features;
 	adapter->peer_wwpn = 0;
 	adapter->peer_wwnn = 0;
 	adapter->peer_d_id = 0;
@@ -1930,6 +1996,10 @@ zfcp_fsf_exchange_config_evaluate(struct
 		adapter->fc_topology = bottom->fc_topology;
 		adapter->fc_link_speed = bottom->fc_link_speed;
 		adapter->hydra_version = bottom->adapter_type;
+		if (adapter->physical_wwpn == 0)
+			adapter->physical_wwpn = adapter->wwpn;
+		if (adapter->physical_s_id == 0)
+			adapter->physical_s_id = adapter->s_id;
 	} else {
 		adapter->wwnn = 0;
 		adapter->wwpn = 0;
@@ -1945,7 +2015,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 		adapter->peer_wwnn = bottom->plogi_payload.wwnn;
 	}
 
-	if(adapter->supported_features & FSF_FEATURE_HBAAPI_MANAGEMENT){
+	if (adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT) {
 		adapter->hardware_version = bottom->hardware_version;
 		memcpy(adapter->serial_number, bottom->serial_number, 17);
 		EBCASC(adapter->serial_number, sizeof(adapter->serial_number));
@@ -2001,11 +2071,12 @@ zfcp_fsf_exchange_config_data_handler(st
 {
 	struct fsf_qtcb_bottom_config *bottom;
 	struct zfcp_adapter *adapter = fsf_req->adapter;
+	struct fsf_qtcb *qtcb = fsf_req->qtcb;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return -EIO;
 
-	switch (fsf_req->qtcb->header.fsf_status) {
+	switch (qtcb->header.fsf_status) {
 
 	case FSF_GOOD:
 		if (zfcp_fsf_exchange_config_evaluate(fsf_req, 1))
@@ -2035,7 +2106,7 @@ zfcp_fsf_exchange_config_data_handler(st
 			zfcp_erp_adapter_shutdown(adapter, 0);
 			return -EIO;
 		case FSF_TOPO_FABRIC:
-			ZFCP_LOG_INFO("Switched fabric fibrechannel "
+			ZFCP_LOG_NORMAL("Switched fabric fibrechannel "
 				      "network detected at adapter %s.\n",
 				      zfcp_get_busid_by_adapter(adapter));
 			break;
@@ -2053,7 +2124,7 @@ zfcp_fsf_exchange_config_data_handler(st
 			zfcp_erp_adapter_shutdown(adapter, 0);
 			return -EIO;
 		}
-		bottom = &fsf_req->qtcb->bottom.config;
+		bottom = &qtcb->bottom.config;
 		if (bottom->max_qtcb_size < sizeof(struct fsf_qtcb)) {
 			ZFCP_LOG_NORMAL("bug: Maximum QTCB size (%d bytes) "
 					"allowed by the adapter %s "
@@ -2078,12 +2149,10 @@ zfcp_fsf_exchange_config_data_handler(st
 		if (zfcp_fsf_exchange_config_evaluate(fsf_req, 0))
 			return -EIO;
 
-		ZFCP_LOG_INFO("Local link to adapter %s is down\n",
-			      zfcp_get_busid_by_adapter(adapter));
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
-				ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
-				&adapter->status);
-		zfcp_erp_adapter_failed(adapter);
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK, &adapter->status);
+
+		zfcp_fsf_link_down_info_eval(adapter,
+			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
 	default:
 		debug_text_event(fsf_req->adapter->erp_dbf, 0, "fsf-stat-ng");
@@ -2097,11 +2166,13 @@ zfcp_fsf_exchange_config_data_handler(st
 
 /**
  * zfcp_fsf_exchange_port_data - request information about local port
+ * @erp_action: ERP action for the adapter for which port data is requested
  * @adapter: for which port data is requested
  * @data: response to exchange port data request
  */
 int
-zfcp_fsf_exchange_port_data(struct zfcp_adapter *adapter,
+zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action,
+			    struct zfcp_adapter *adapter,
 			    struct fsf_qtcb_bottom_port *data)
 {
 	volatile struct qdio_buffer_element *sbale;
@@ -2110,7 +2181,7 @@ zfcp_fsf_exchange_port_data(struct zfcp_
         struct zfcp_fsf_req *fsf_req;
 	struct timer_list *timer;
 
-        if(!(adapter->supported_features & FSF_FEATURE_HBAAPI_MANAGEMENT)){
+	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT)) {
 		ZFCP_LOG_INFO("error: exchange port data "
                               "command not supported by adapter %s\n",
 			      zfcp_get_busid_by_adapter(adapter));
@@ -2134,6 +2205,12 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 		goto out;
 	}
 
+	if (erp_action) {
+		erp_action->fsf_req = fsf_req;
+		fsf_req->erp_action = erp_action;
+	}
+
+	if (data)
 	fsf_req->data = (unsigned long) data;
 
 	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
@@ -2151,6 +2228,8 @@ zfcp_fsf_exchange_port_data(struct zfcp_
                               "command on the adapter %s\n",
 			      zfcp_get_busid_by_adapter(adapter));
 		zfcp_fsf_req_free(fsf_req);
+		if (erp_action)
+			erp_action->fsf_req = NULL;
 		write_unlock_irqrestore(&adapter->request_queue.queue_lock,
 					lock_flags);
 		goto out;
@@ -2179,23 +2258,40 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 static void
 zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *fsf_req)
 {
-	struct fsf_qtcb_bottom_port *bottom;
-	struct fsf_qtcb_bottom_port *data;
-
-	data = (struct fsf_qtcb_bottom_port*) fsf_req->data;
+	struct zfcp_adapter *adapter = fsf_req->adapter;
+	struct fsf_qtcb *qtcb = fsf_req->qtcb;
+	struct fsf_qtcb_bottom_port *bottom, *data;
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
-	switch (fsf_req->qtcb->header.fsf_status) {
+	switch (qtcb->header.fsf_status) {
         case FSF_GOOD:
-                bottom = &fsf_req->qtcb->bottom.port;
-                memcpy(data, bottom, sizeof(*data));
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
+
+		bottom = &qtcb->bottom.port;
+		data = (struct fsf_qtcb_bottom_port*) fsf_req->data;
+		if (data)
+			memcpy(data, bottom, sizeof(struct fsf_qtcb_bottom_port));
+		if (adapter->connection_features & FSF_FEATURE_NPIV_MODE) {
+			adapter->physical_wwpn = bottom->wwpn;
+			adapter->physical_s_id = bottom->fc_port_id;
+		} else {
+			adapter->physical_wwpn = adapter->wwpn;
+			adapter->physical_s_id = adapter->s_id;
+		}
+		break;
+
+	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
+
+		zfcp_fsf_link_down_info_eval(adapter,
+			&qtcb->header.fsf_status_qual.link_down_info);
                 break;
 
         default:
-		debug_text_event(fsf_req->adapter->erp_dbf, 0, "xchg-port-ng");
-                debug_event(fsf_req->adapter->erp_dbf, 0,
+		debug_text_event(adapter->erp_dbf, 0, "xchg-port-ng");
+		debug_event(adapter->erp_dbf, 0,
 			    &fsf_req->qtcb->header.fsf_status, sizeof(u32));
 	}
 }
@@ -2629,7 +2725,7 @@ zfcp_fsf_close_physical_port(struct zfcp
 			&erp_action->port->status);
 	/* save a pointer to this port */
 	erp_action->fsf_req->data = (unsigned long) erp_action->port;
-	/* port to be closeed */
+	/* port to be closed */
 	erp_action->fsf_req->qtcb->header.port_handle =
 	    erp_action->port->handle;
 	erp_action->fsf_req->erp_action = erp_action;
@@ -2833,6 +2929,7 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
 		erp_action->port->handle;
 	erp_action->fsf_req->qtcb->bottom.support.fcp_lun =
 		erp_action->unit->fcp_lun;
+	if (!(erp_action->adapter->connection_features & FSF_FEATURE_NPIV_MODE))
 	erp_action->fsf_req->qtcb->bottom.support.option =
 		FSF_OPEN_LUN_SUPPRESS_BOXING;
 	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->unit->status);
@@ -2880,7 +2977,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 	struct fsf_qtcb_bottom_support *bottom;
 	struct fsf_queue_designator *queue_designator;
 	u16 subtable, rule, counter;
-	u32 allowed, exclusive, readwrite;
+	int exclusive, readwrite;
 
 	unit = (struct zfcp_unit *) fsf_req->data;
 
@@ -2894,10 +2991,6 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 	bottom = &fsf_req->qtcb->bottom.support;
 	queue_designator = &header->fsf_status_qual.fsf_queue_designator;
 
-	allowed   = bottom->lun_access_info & FSF_UNIT_ACCESS_OPEN_LUN_ALLOWED;
-	exclusive = bottom->lun_access_info & FSF_UNIT_ACCESS_EXCLUSIVE;
-	readwrite = bottom->lun_access_info & FSF_UNIT_ACCESS_OUTBOUND_TRANSFER;
-
 	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			  ZFCP_STATUS_UNIT_SHARED |
 			  ZFCP_STATUS_UNIT_READONLY,
@@ -3071,10 +3164,15 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			       unit->handle);
 		/* mark unit as open */
 		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status);
-		atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
-		                  ZFCP_STATUS_COMMON_ACCESS_BOXED,
-		                  &unit->status);
-		if (adapter->supported_features & FSF_FEATURE_LUN_SHARING){
+
+		if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE) &&
+		    (adapter->adapter_features & FSF_FEATURE_LUN_SHARING) &&
+		    (adapter->ccw_device->id.dev_model != ZFCP_DEVICE_MODEL_PRIV)) {
+			exclusive = (bottom->lun_access_info &
+					FSF_UNIT_ACCESS_EXCLUSIVE);
+			readwrite = (bottom->lun_access_info &
+					FSF_UNIT_ACCESS_OUTBOUND_TRANSFER);
+
 			if (!exclusive)
 		                atomic_set_mask(ZFCP_STATUS_UNIT_SHARED,
 						&unit->status);
@@ -4164,7 +4262,7 @@ zfcp_fsf_control_file(struct zfcp_adapte
 	int direction;
 	int retval = 0;
 
-	if (!(adapter->supported_features & FSF_FEATURE_CFDC)) {
+	if (!(adapter->adapter_features & FSF_FEATURE_CFDC)) {
 		ZFCP_LOG_INFO("cfdc not supported (adapter %s)\n",
 			      zfcp_get_busid_by_adapter(adapter));
 		retval = -EOPNOTSUPP;
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_fsf.h linux-2.6.13/drivers/s390/scsi/zfcp_fsf.h
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_fsf.h	2005-09-03 12:23:43.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_fsf.h	2005-09-03 12:32:48.000000000 +0200
@@ -140,9 +140,18 @@
 #define FSF_SQ_CFDC_SUBTABLE_LUN		0x0004
 
 /* FSF status qualifier (most significant 4 bytes), local link down */
-#define FSF_PSQ_LINK_NOLIGHT			0x00000004
-#define FSF_PSQ_LINK_WRAPPLUG			0x00000008
-#define FSF_PSQ_LINK_NOFCP			0x00000010
+#define FSF_PSQ_LINK_NO_LIGHT			0x00000004
+#define FSF_PSQ_LINK_WRAP_PLUG			0x00000008
+#define FSF_PSQ_LINK_NO_FCP			0x00000010
+#define FSF_PSQ_LINK_FIRMWARE_UPDATE		0x00000020
+#define FSF_PSQ_LINK_INVALID_WWPN		0x00000100
+#define FSF_PSQ_LINK_NO_NPIV_SUPPORT		0x00000200
+#define FSF_PSQ_LINK_NO_FCP_RESOURCES		0x00000400
+#define FSF_PSQ_LINK_NO_FABRIC_RESOURCES	0x00000800
+#define FSF_PSQ_LINK_FABRIC_LOGIN_UNABLE	0x00001000
+#define FSF_PSQ_LINK_WWPN_ASSIGNMENT_CORRUPTED	0x00002000
+#define FSF_PSQ_LINK_MODE_TABLE_CURRUPTED	0x00004000
+#define FSF_PSQ_LINK_NO_WWPN_ASSIGNMENT		0x00008000
 
 /* payload size in status read buffer */
 #define FSF_STATUS_READ_PAYLOAD_SIZE		4032
@@ -155,15 +164,21 @@
 #define FSF_STATUS_READ_INCOMING_ELS		0x00000002
 #define FSF_STATUS_READ_SENSE_DATA_AVAIL        0x00000003
 #define FSF_STATUS_READ_BIT_ERROR_THRESHOLD	0x00000004
-#define FSF_STATUS_READ_LINK_DOWN		0x00000005 /* FIXME: really? */
+#define FSF_STATUS_READ_LINK_DOWN		0x00000005
 #define FSF_STATUS_READ_LINK_UP          	0x00000006
 #define FSF_STATUS_READ_CFDC_UPDATED		0x0000000A
 #define FSF_STATUS_READ_CFDC_HARDENED		0x0000000B
+#define FSF_STATUS_READ_FEATURE_UPDATE_ALERT	0x0000000C
 
 /* status subtypes in status read buffer */
 #define FSF_STATUS_READ_SUB_CLOSE_PHYS_PORT	0x00000001
 #define FSF_STATUS_READ_SUB_ERROR_PORT		0x00000002
 
+/* status subtypes for link down */
+#define FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK	0x00000000
+#define FSF_STATUS_READ_SUB_FDISC_FAILED	0x00000001
+#define FSF_STATUS_READ_SUB_FIRMWARE_UPDATE	0x00000002
+
 /* status subtypes for CFDC */
 #define FSF_STATUS_READ_SUB_CFDC_HARDENED_ON_SE	0x00000002
 #define FSF_STATUS_READ_SUB_CFDC_HARDENED_ON_SE2 0x0000000F
@@ -194,11 +209,15 @@
 #define FSF_QTCB_LOG_SIZE			1024
 
 /* channel features */
-#define FSF_FEATURE_QTCB_SUPPRESSION            0x00000001
 #define FSF_FEATURE_CFDC			0x00000002
 #define FSF_FEATURE_LUN_SHARING			0x00000004
 #define FSF_FEATURE_HBAAPI_MANAGEMENT           0x00000010
 #define FSF_FEATURE_ELS_CT_CHAINED_SBALS        0x00000020
+#define FSF_FEATURE_UPDATE_ALERT		0x00000100
+
+/* host connection features */
+#define FSF_FEATURE_NPIV_MODE			0x00000001
+#define FSF_FEATURE_VM_ASSIGNED_WWPN		0x00000002
 
 /* option */
 #define FSF_OPEN_LUN_SUPPRESS_BOXING		0x00000001
@@ -306,16 +325,23 @@ struct fsf_qual_sequence_error {
 	u32 res1[3];
 } __attribute__ ((packed));
 
-struct fsf_qual_locallink_error {
-	u32 code;
-	u32 res1[3];
+struct fsf_link_down_info {
+	u32 error_code;
+	u32 res1;
+	u8 res2[2];
+	u8 primary_status;
+	u8 ioerr_code;
+	u8 action_code;
+	u8 reason_code;
+	u8 explanation_code;
+	u8 vendor_specific_code;
 } __attribute__ ((packed));
 
 union fsf_prot_status_qual {
 	u64 doubleword[FSF_PROT_STATUS_QUAL_SIZE / sizeof(u64)];
 	struct fsf_qual_version_error   version_error;
 	struct fsf_qual_sequence_error  sequence_error;
-	struct fsf_qual_locallink_error locallink_error;
+	struct fsf_link_down_info link_down_info;
 } __attribute__ ((packed));
 
 struct fsf_qtcb_prefix {
@@ -335,6 +361,7 @@ union fsf_status_qual {
 	u32 word[FSF_STATUS_QUALIFIER_SIZE / sizeof (u32)];
 	u64 doubleword[FSF_STATUS_QUALIFIER_SIZE / sizeof(u64)];
 	struct fsf_queue_designator fsf_queue_designator;
+	struct fsf_link_down_info link_down_info;
 } __attribute__ ((packed));
 
 struct fsf_qtcb_header {
@@ -409,8 +436,8 @@ struct fsf_qtcb_bottom_config {
 	u32 low_qtcb_version;
 	u32 max_qtcb_size;
 	u32 max_data_transfer_size;
-	u32 supported_features;
-	u8  res1[4];
+	u32 adapter_features;
+	u32 connection_features;
 	u32 fc_topology;
 	u32 fc_link_speed;
 	u32 adapter_type;
@@ -428,7 +455,7 @@ struct fsf_qtcb_bottom_config {
 } __attribute__ ((packed));
 
 struct fsf_qtcb_bottom_port {
-	u8 res1[8];
+	u64 wwpn;
 	u32 fc_port_id;
 	u32 port_type;
 	u32 port_state;
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_sysfs_adapter.c linux-2.6.13/drivers/s390/scsi/zfcp_sysfs_adapter.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_sysfs_adapter.c	2005-09-03 12:17:16.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_sysfs_adapter.c	2005-09-03 12:32:48.000000000 +0200
@@ -68,6 +68,8 @@ ZFCP_DEFINE_ADAPTER_ATTR(s_id, "0x%06x\n
 ZFCP_DEFINE_ADAPTER_ATTR(peer_wwnn, "0x%016llx\n", adapter->peer_wwnn);
 ZFCP_DEFINE_ADAPTER_ATTR(peer_wwpn, "0x%016llx\n", adapter->peer_wwpn);
 ZFCP_DEFINE_ADAPTER_ATTR(peer_d_id, "0x%06x\n", adapter->peer_d_id);
+ZFCP_DEFINE_ADAPTER_ATTR(physical_wwpn, "0x%016llx\n", adapter->physical_wwpn);
+ZFCP_DEFINE_ADAPTER_ATTR(physical_s_id, "0x%06x\n", adapter->physical_s_id);
 ZFCP_DEFINE_ADAPTER_ATTR(card_version, "0x%04x\n", adapter->hydra_version);
 ZFCP_DEFINE_ADAPTER_ATTR(lic_version, "0x%08x\n", adapter->fsf_lic_version);
 ZFCP_DEFINE_ADAPTER_ATTR(fc_link_speed, "%d Gb/s\n", adapter->fc_link_speed);
@@ -261,6 +263,8 @@ static struct attribute *zfcp_adapter_at
 	&dev_attr_peer_wwnn.attr,
 	&dev_attr_peer_wwpn.attr,
 	&dev_attr_peer_d_id.attr,
+	&dev_attr_physical_wwpn.attr,
+	&dev_attr_physical_s_id.attr,
 	&dev_attr_card_version.attr,
 	&dev_attr_lic_version.attr,
 	&dev_attr_fc_link_speed.attr,
