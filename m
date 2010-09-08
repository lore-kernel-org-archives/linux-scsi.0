From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 12/12] zfcp: Replace status modifier functions.
Date: Wed, 08 Sep 2010 14:40:01 +0200
Message-ID: <20100908124354.379439556@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:43203 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab0IHMn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:57 -0400
Content-Disposition: inline; filename=711-zfcp-status-functions.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Replace the zfcp_modify_<xxx>_status functions and its accompanying wrappers
with dedicated status modifier functions. This eases code readability and
maintenance.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_ccw.c   |    8 -
 drivers/s390/scsi/zfcp_cfdc.c  |   22 +--
 drivers/s390/scsi/zfcp_def.h   |    5 
 drivers/s390/scsi/zfcp_erp.c   |  258 ++++++++++++++++++-----------------------
 drivers/s390/scsi/zfcp_ext.h   |   17 --
 drivers/s390/scsi/zfcp_fc.c    |    2 
 drivers/s390/scsi/zfcp_fsf.c   |   72 +++++++----
 drivers/s390/scsi/zfcp_scsi.c  |    3 
 drivers/s390/scsi/zfcp_sysfs.c |   10 -
 9 files changed, 189 insertions(+), 208 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2010-09-08 08:49:32.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2010-09-08 08:49:32.000000000 +0200
@@ -46,8 +46,7 @@ static int zfcp_ccw_activate(struct ccw_
 	if (!adapter)
 		return 0;
 
-	zfcp_erp_modify_adapter_status(adapter, "ccresu1", NULL,
-				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
+	zfcp_erp_set_adapter_status(adapter, ZFCP_STATUS_COMMON_RUNNING);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
 				"ccresu2", NULL);
 	zfcp_erp_wait(adapter);
@@ -217,9 +216,8 @@ static int zfcp_ccw_notify(struct ccw_de
 		break;
 	case CIO_OPER:
 		dev_info(&cdev->dev, "The FCP device is operational again\n");
-		zfcp_erp_modify_adapter_status(adapter, "ccnoti3", NULL,
-					       ZFCP_STATUS_COMMON_RUNNING,
-					       ZFCP_SET);
+		zfcp_erp_set_adapter_status(adapter,
+					    ZFCP_STATUS_COMMON_RUNNING);
 		zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
 					"ccnoti4", NULL);
 		break;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_cfdc.c linux-2.6-patched/drivers/s390/scsi/zfcp_cfdc.c
--- linux-2.6/drivers/s390/scsi/zfcp_cfdc.c	2010-09-08 08:49:31.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_cfdc.c	2010-09-08 08:49:32.000000000 +0200
@@ -328,9 +328,9 @@ void zfcp_cfdc_port_denied(struct zfcp_p
 
 	zfcp_act_eval_err(port->adapter, qual->halfword[0]);
 	zfcp_act_eval_err(port->adapter, qual->halfword[1]);
-	zfcp_erp_modify_port_status(port, "cfadp_1", NULL,
-				    ZFCP_STATUS_COMMON_ERP_FAILED |
-				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
+	zfcp_erp_set_port_status(port,
+				 ZFCP_STATUS_COMMON_ERP_FAILED |
+				 ZFCP_STATUS_COMMON_ACCESS_DENIED);
 }
 
 /**
@@ -349,9 +349,9 @@ void zfcp_cfdc_lun_denied(struct scsi_de
 		 (unsigned long long)zfcp_sdev->port->wwpn);
 	zfcp_act_eval_err(zfcp_sdev->port->adapter, qual->halfword[0]);
 	zfcp_act_eval_err(zfcp_sdev->port->adapter, qual->halfword[1]);
-	zfcp_erp_modify_lun_status(sdev, "cfadl_1", NULL,
-				   ZFCP_STATUS_COMMON_ERP_FAILED |
-				   ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
+	zfcp_erp_set_lun_status(sdev,
+				ZFCP_STATUS_COMMON_ERP_FAILED |
+				ZFCP_STATUS_COMMON_ACCESS_DENIED);
 
 	atomic_clear_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
 	atomic_clear_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
@@ -378,9 +378,9 @@ void zfcp_cfdc_lun_shrng_vltn(struct scs
 	else
 		zfcp_act_eval_err(zfcp_sdev->port->adapter, qual->word[2]);
 
-	zfcp_erp_modify_lun_status(sdev, "fsosh_3", NULL,
-				   ZFCP_STATUS_COMMON_ERP_FAILED |
-				   ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
+	zfcp_erp_set_lun_status(sdev,
+				ZFCP_STATUS_COMMON_ERP_FAILED |
+				ZFCP_STATUS_COMMON_ACCESS_DENIED);
 	atomic_clear_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
 	atomic_clear_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
 }
@@ -424,7 +424,7 @@ int zfcp_cfdc_open_lun_eval(struct scsi_
 			"not supported (LUN 0x%016Lx, port 0x%016Lx)\n",
 			zfcp_scsi_dev_lun(sdev),
 			(unsigned long long)zfcp_sdev->port->wwpn);
-		zfcp_erp_lun_failed(sdev, "fsosh_5", NULL);
+		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ERP_FAILED);
 		zfcp_erp_lun_shutdown(sdev, 0, "fsouh_6", NULL);
 		return -EACCES;
 	}
@@ -435,7 +435,7 @@ int zfcp_cfdc_open_lun_eval(struct scsi_
 			"(LUN 0x%016Lx, port 0x%016Lx)\n",
 			zfcp_scsi_dev_lun(sdev),
 			(unsigned long long)zfcp_sdev->port->wwpn);
-		zfcp_erp_lun_failed(sdev, "fsosh_7", NULL);
+		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ERP_FAILED);
 		zfcp_erp_lun_shutdown(sdev, 0, "fsosh_8", NULL);
 		return -EACCES;
 	}
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2010-09-08 08:49:29.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2010-09-08 08:49:32.000000000 +0200
@@ -325,9 +325,4 @@ struct zfcp_data {
 	struct kmem_cache	*adisc_cache;
 };
 
-/********************** ZFCP SPECIFIC DEFINES ********************************/
-
-#define ZFCP_SET                0x00000100
-#define ZFCP_CLEAR              0x00000200
-
 #endif /* ZFCP_DEF_H */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-09-08 08:49:31.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-09-08 08:49:32.000000000 +0200
@@ -57,9 +57,8 @@ enum zfcp_erp_act_result {
 
 static void zfcp_erp_adapter_block(struct zfcp_adapter *adapter, int mask)
 {
-	zfcp_erp_modify_adapter_status(adapter, "erablk1", NULL,
-				       ZFCP_STATUS_COMMON_UNBLOCKED | mask,
-				       ZFCP_CLEAR);
+	zfcp_erp_clear_adapter_status(adapter,
+				       ZFCP_STATUS_COMMON_UNBLOCKED | mask);
 }
 
 static int zfcp_erp_action_exists(struct zfcp_erp_action *act)
@@ -266,7 +265,8 @@ static int _zfcp_erp_adapter_reopen(stru
 
 	/* ensure propagation of failed status to new devices */
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
-		zfcp_erp_adapter_failed(adapter, "erareo1", NULL);
+		zfcp_erp_set_adapter_status(adapter,
+					    ZFCP_STATUS_COMMON_ERP_FAILED);
 		return -EIO;
 	}
 	return zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_ADAPTER,
@@ -290,7 +290,8 @@ void zfcp_erp_adapter_reopen(struct zfcp
 
 	write_lock_irqsave(&adapter->erp_lock, flags);
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_ERP_FAILED)
-		zfcp_erp_adapter_failed(adapter, "erareo1", NULL);
+		zfcp_erp_set_adapter_status(adapter,
+					    ZFCP_STATUS_COMMON_ERP_FAILED);
 	else
 		zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_ADAPTER, adapter,
 					NULL, NULL, id, ref, 0);
@@ -327,9 +328,8 @@ void zfcp_erp_port_shutdown(struct zfcp_
 
 static void zfcp_erp_port_block(struct zfcp_port *port, int clear)
 {
-	zfcp_erp_modify_port_status(port, "erpblk1", NULL,
-				    ZFCP_STATUS_COMMON_UNBLOCKED | clear,
-				    ZFCP_CLEAR);
+	zfcp_erp_clear_port_status(port,
+				    ZFCP_STATUS_COMMON_UNBLOCKED | clear);
 }
 
 static void _zfcp_erp_port_forced_reopen(struct zfcp_port *port,
@@ -370,7 +370,7 @@ static int _zfcp_erp_port_reopen(struct
 
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
 		/* ensure propagation of failed status to new devices */
-		zfcp_erp_port_failed(port, "erpreo1", NULL);
+		zfcp_erp_set_port_status(port, ZFCP_STATUS_COMMON_ERP_FAILED);
 		return -EIO;
 	}
 
@@ -400,9 +400,8 @@ int zfcp_erp_port_reopen(struct zfcp_por
 
 static void zfcp_erp_lun_block(struct scsi_device *sdev, int clear_mask)
 {
-	zfcp_erp_modify_lun_status(sdev, "erlblk1", NULL,
-				   ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
-				   ZFCP_CLEAR);
+	zfcp_erp_clear_lun_status(sdev,
+				  ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask);
 }
 
 static void _zfcp_erp_lun_reopen(struct scsi_device *sdev, int clear, char *id,
@@ -483,11 +482,6 @@ static int status_change_set(unsigned lo
 	return (atomic_read(status) ^ mask) & mask;
 }
 
-static int status_change_clear(unsigned long mask, atomic_t *status)
-{
-	return atomic_read(status) & mask;
-}
-
 static void zfcp_erp_adapter_unblock(struct zfcp_adapter *adapter)
 {
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status))
@@ -779,8 +773,7 @@ static void zfcp_erp_adapter_strategy_cl
 	adapter->fsf_req_seq_no = 0;
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
 	/* all ports and LUNs are closed */
-	zfcp_erp_modify_adapter_status(adapter, "erascl1", NULL,
-				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
+	zfcp_erp_clear_adapter_status(adapter, ZFCP_STATUS_COMMON_OPEN);
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
 			  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
@@ -897,7 +890,7 @@ static int zfcp_erp_open_ptp_port(struct
 	struct zfcp_port *port = act->port;
 
 	if (port->wwpn != adapter->peer_wwpn) {
-		zfcp_erp_port_failed(port, "eroptp1", NULL);
+		zfcp_erp_set_port_status(port, ZFCP_STATUS_COMMON_ERP_FAILED);
 		return ZFCP_ERP_FAILED;
 	}
 	port->d_id = adapter->peer_d_id;
@@ -1042,7 +1035,8 @@ static int zfcp_erp_strategy_check_lun(s
 				"port 0x%016Lx\n",
 				(unsigned long long)zfcp_scsi_dev_lun(sdev),
 				(unsigned long long)zfcp_sdev->port->wwpn);
-			zfcp_erp_lun_failed(sdev, "ersckl1", NULL);
+			zfcp_erp_set_lun_status(sdev,
+						ZFCP_STATUS_COMMON_ERP_FAILED);
 		}
 		break;
 	}
@@ -1072,7 +1066,8 @@ static int zfcp_erp_strategy_check_port(
 			dev_err(&port->adapter->ccw_device->dev,
 				"ERP failed for remote port 0x%016Lx\n",
 				(unsigned long long)port->wwpn);
-			zfcp_erp_port_failed(port, "erpsck1", NULL);
+			zfcp_erp_set_port_status(port,
+					 ZFCP_STATUS_COMMON_ERP_FAILED);
 		}
 		break;
 	}
@@ -1099,7 +1094,8 @@ static int zfcp_erp_strategy_check_adapt
 			dev_err(&adapter->ccw_device->dev,
 				"ERP cannot recover an error "
 				"on the FCP device\n");
-			zfcp_erp_adapter_failed(adapter, "erasck1", NULL);
+			zfcp_erp_set_adapter_status(adapter,
+					    ZFCP_STATUS_COMMON_ERP_FAILED);
 		}
 		break;
 	}
@@ -1421,175 +1417,159 @@ void zfcp_erp_thread_kill(struct zfcp_ad
 }
 
 /**
- * zfcp_erp_adapter_failed - Set adapter status to failed.
- * @adapter: Failed adapter.
- * @id: Event id for debug trace.
- * @ref: Reference for debug trace.
+ * zfcp_erp_wait - wait for completion of error recovery on an adapter
+ * @adapter: adapter for which to wait for completion of its error recovery
  */
-void zfcp_erp_adapter_failed(struct zfcp_adapter *adapter, char *id, void *ref)
+void zfcp_erp_wait(struct zfcp_adapter *adapter)
 {
-	zfcp_erp_modify_adapter_status(adapter, id, ref,
-				       ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
+	wait_event(adapter->erp_done_wqh,
+		   !(atomic_read(&adapter->status) &
+			ZFCP_STATUS_ADAPTER_ERP_PENDING));
 }
 
 /**
- * zfcp_erp_port_failed - Set port status to failed.
- * @port: Failed port.
- * @id: Event id for debug trace.
- * @ref: Reference for debug trace.
+ * zfcp_erp_set_adapter_status - set adapter status bits
+ * @adapter: adapter to change the status
+ * @mask: status bits to change
+ *
+ * Changes in common status bits are propagated to attached ports and LUNs.
  */
-void zfcp_erp_port_failed(struct zfcp_port *port, char *id, void *ref)
+void zfcp_erp_set_adapter_status(struct zfcp_adapter *adapter, u32 mask)
 {
-	zfcp_erp_modify_port_status(port, id, ref,
-				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
-}
+	struct zfcp_port *port;
+	struct scsi_device *sdev;
+	unsigned long flags;
+	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 
-/**
- * zfcp_erp_lun_failed - Set LUN status to failed.
- * @sdev: Failed SCSI device / LUN
- * @id: Event id for debug trace.
- * @ref: Reference for debug trace.
- */
-void zfcp_erp_lun_failed(struct scsi_device *sdev, char *id, void *ref)
-{
-	zfcp_erp_modify_lun_status(sdev, id, ref,
-				   ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
-}
+	atomic_set_mask(mask, &adapter->status);
 
-/**
- * zfcp_erp_wait - wait for completion of error recovery on an adapter
- * @adapter: adapter for which to wait for completion of its error recovery
- */
-void zfcp_erp_wait(struct zfcp_adapter *adapter)
-{
-	wait_event(adapter->erp_done_wqh,
-		   !(atomic_read(&adapter->status) &
-			ZFCP_STATUS_ADAPTER_ERP_PENDING));
+	if (!common_mask)
+		return;
+
+	read_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list)
+		atomic_set_mask(common_mask, &port->status);
+	read_unlock_irqrestore(&adapter->port_list_lock, flags);
+
+	shost_for_each_device(sdev, adapter->scsi_host)
+		atomic_set_mask(common_mask, &sdev_to_zfcp(sdev)->status);
 }
 
 /**
- * zfcp_erp_modify_adapter_status - change adapter status bits
+ * zfcp_erp_clear_adapter_status - clear adapter status bits
  * @adapter: adapter to change the status
- * @id: id for the debug trace
- * @ref: reference for the debug trace
  * @mask: status bits to change
- * @set_or_clear: ZFCP_SET or ZFCP_CLEAR
  *
  * Changes in common status bits are propagated to attached ports and LUNs.
  */
-void zfcp_erp_modify_adapter_status(struct zfcp_adapter *adapter, char *id,
-				    void *ref, u32 mask, int set_or_clear)
+void zfcp_erp_clear_adapter_status(struct zfcp_adapter *adapter, u32 mask)
 {
 	struct zfcp_port *port;
+	struct scsi_device *sdev;
 	unsigned long flags;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
+	u32 clear_counter = mask & ZFCP_STATUS_COMMON_ERP_FAILED;
 
-	if (set_or_clear == ZFCP_SET) {
-		if (status_change_set(mask, &adapter->status))
-			zfcp_dbf_rec_adapter(id, ref, adapter->dbf);
-		atomic_set_mask(mask, &adapter->status);
-	} else {
-		if (status_change_clear(mask, &adapter->status))
-			zfcp_dbf_rec_adapter(id, ref, adapter->dbf);
-		atomic_clear_mask(mask, &adapter->status);
-		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
-			atomic_set(&adapter->erp_counter, 0);
+	atomic_clear_mask(mask, &adapter->status);
+
+	if (!common_mask)
+		return;
+
+	if (clear_counter)
+		atomic_set(&adapter->erp_counter, 0);
+
+	read_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list) {
+		atomic_clear_mask(common_mask, &port->status);
+		if (clear_counter)
+			atomic_set(&port->erp_counter, 0);
 	}
+	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	if (common_mask) {
-		read_lock_irqsave(&adapter->port_list_lock, flags);
-		list_for_each_entry(port, &adapter->port_list, list)
-			zfcp_erp_modify_port_status(port, id, ref, common_mask,
-						    set_or_clear);
-		read_unlock_irqrestore(&adapter->port_list_lock, flags);
+	shost_for_each_device(sdev, adapter->scsi_host) {
+		atomic_clear_mask(common_mask, &sdev_to_zfcp(sdev)->status);
+		if (clear_counter)
+			atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
 	}
 }
 
 /**
- * zfcp_erp_modify_port_status - change port status bits
- * @port: port to change the status bits
- * @id: id for the debug trace
- * @ref: reference for the debug trace
+ * zfcp_erp_set_port_status - set port status bits
+ * @port: port to change the status
  * @mask: status bits to change
- * @set_or_clear: ZFCP_SET or ZFCP_CLEAR
  *
  * Changes in common status bits are propagated to attached LUNs.
  */
-void zfcp_erp_modify_port_status(struct zfcp_port *port, char *id, void *ref,
-				 u32 mask, int set_or_clear)
+void zfcp_erp_set_port_status(struct zfcp_port *port, u32 mask)
 {
 	struct scsi_device *sdev;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 
-	if (set_or_clear == ZFCP_SET) {
-		if (status_change_set(mask, &port->status))
-			zfcp_dbf_rec_port(id, ref, port);
-		atomic_set_mask(mask, &port->status);
-	} else {
-		if (status_change_clear(mask, &port->status))
-			zfcp_dbf_rec_port(id, ref, port);
-		atomic_clear_mask(mask, &port->status);
-		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
-			atomic_set(&port->erp_counter, 0);
-	}
+	atomic_set_mask(mask, &port->status);
 
-	if (common_mask)
-		shost_for_each_device(sdev, port->adapter->scsi_host)
-			if (sdev_to_zfcp(sdev)->port == port)
-				zfcp_erp_modify_lun_status(sdev, id, ref,
-							   common_mask,
-							   set_or_clear);
+	if (!common_mask)
+		return;
+
+	shost_for_each_device(sdev, port->adapter->scsi_host)
+		if (sdev_to_zfcp(sdev)->port == port)
+			atomic_set_mask(common_mask,
+					&sdev_to_zfcp(sdev)->status);
 }
 
 /**
- * zfcp_erp_modify_lun_status - change LUN status bits
- * @sdev: SCSI device / LUN where to change the status bits
- * @id: id for the debug trace
- * @ref: reference for the debug trace
+ * zfcp_erp_clear_port_status - clear port status bits
+ * @port: adapter to change the status
  * @mask: status bits to change
- * @set_or_clear: ZFCP_SET or ZFCP_CLEAR
+ *
+ * Changes in common status bits are propagated to attached LUNs.
  */
-void zfcp_erp_modify_lun_status(struct scsi_device *sdev, char *id, void *ref,
-				u32 mask, int set_or_clear)
+void zfcp_erp_clear_port_status(struct zfcp_port *port, u32 mask)
 {
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct scsi_device *sdev;
+	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
+	u32 clear_counter = mask & ZFCP_STATUS_COMMON_ERP_FAILED;
+
+	atomic_clear_mask(mask, &port->status);
+
+	if (!common_mask)
+		return;
 
-	if (set_or_clear == ZFCP_SET) {
-		if (status_change_set(mask, &zfcp_sdev->status))
-			zfcp_dbf_rec_lun(id, ref, sdev);
-		atomic_set_mask(mask, &zfcp_sdev->status);
-	} else {
-		if (status_change_clear(mask, &zfcp_sdev->status))
-			zfcp_dbf_rec_lun(id, ref, sdev);
-		atomic_clear_mask(mask, &zfcp_sdev->status);
-		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED) {
-			atomic_set(&zfcp_sdev->erp_counter, 0);
+	if (clear_counter)
+		atomic_set(&port->erp_counter, 0);
+
+	shost_for_each_device(sdev, port->adapter->scsi_host)
+		if (sdev_to_zfcp(sdev)->port == port) {
+			atomic_clear_mask(common_mask,
+					  &sdev_to_zfcp(sdev)->status);
+			if (clear_counter)
+				atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
 		}
-	}
 }
 
 /**
- * zfcp_erp_port_boxed - Mark port as "boxed" and start ERP
- * @port: The "boxed" port.
- * @id: The debug trace id.
- * @id: Reference for the debug trace.
+ * zfcp_erp_set_lun_status - set lun status bits
+ * @sdev: SCSI device / lun to set the status bits
+ * @mask: status bits to change
  */
-void zfcp_erp_port_boxed(struct zfcp_port *port, char *id, void *ref)
+void zfcp_erp_set_lun_status(struct scsi_device *sdev, u32 mask)
 {
-	zfcp_erp_modify_port_status(port, id, ref,
-				    ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
-	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+
+	atomic_set_mask(mask, &zfcp_sdev->status);
 }
 
 /**
- * zfcp_erp_lun_boxed - Mark LUN as "boxed" and start ERP
- * @sdev: The "boxed" SCSI device / LUN.
- * @id: The debug trace id.
- * @ref: Reference for the debug trace.
+ * zfcp_erp_clear_lun_status - clear lun status bits
+ * @sdev: SCSi device / lun to clear the status bits
+ * @mask: status bits to change
  */
-void zfcp_erp_lun_boxed(struct scsi_device *sdev, char *id, void *ref)
+void zfcp_erp_clear_lun_status(struct scsi_device *sdev, u32 mask)
 {
-	zfcp_erp_modify_lun_status(sdev, id, ref,
-				   ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
-	zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+
+	atomic_clear_mask(mask, &zfcp_sdev->status);
+
+	if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
+		atomic_set(&zfcp_sdev->erp_counter, 0);
 }
+
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2010-09-08 08:49:31.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2010-09-08 08:49:32.000000000 +0200
@@ -71,31 +71,26 @@ extern void _zfcp_dbf_scsi(const char *,
 			   unsigned long);
 
 /* zfcp_erp.c */
-extern void zfcp_erp_modify_adapter_status(struct zfcp_adapter *, char *,
-					   void *, u32, int);
+extern void zfcp_erp_set_adapter_status(struct zfcp_adapter *, u32);
+extern void zfcp_erp_clear_adapter_status(struct zfcp_adapter *, u32);
 extern void zfcp_erp_adapter_reopen(struct zfcp_adapter *, int, char *, void *);
 extern void zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int, char *,
 				      void *);
-extern void zfcp_erp_adapter_failed(struct zfcp_adapter *, char *, void *);
-extern void zfcp_erp_modify_port_status(struct zfcp_port *, char *, void *, u32,
-					int);
+extern void zfcp_erp_set_port_status(struct zfcp_port *, u32);
+extern void zfcp_erp_clear_port_status(struct zfcp_port *, u32);
 extern int  zfcp_erp_port_reopen(struct zfcp_port *, int, char *, void *);
 extern void zfcp_erp_port_shutdown(struct zfcp_port *, int, char *, void *);
 extern void zfcp_erp_port_forced_reopen(struct zfcp_port *, int, char *,
 					void *);
-extern void zfcp_erp_port_failed(struct zfcp_port *, char *, void *);
-extern void zfcp_erp_modify_lun_status(struct scsi_device *, char *, void *,
-				       u32, int);
+extern void zfcp_erp_set_lun_status(struct scsi_device *, u32);
+extern void zfcp_erp_clear_lun_status(struct scsi_device *, u32);
 extern void zfcp_erp_lun_reopen(struct scsi_device *, int, char *, void *);
 extern void zfcp_erp_lun_shutdown(struct scsi_device *, int, char *, void *);
 extern void zfcp_erp_lun_shutdown_wait(struct scsi_device *, char *);
-extern void zfcp_erp_lun_failed(struct scsi_device *, char *, void *);
 extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
 extern void zfcp_erp_thread_kill(struct zfcp_adapter *);
 extern void zfcp_erp_wait(struct zfcp_adapter *);
 extern void zfcp_erp_notify(struct zfcp_erp_action *, unsigned long);
-extern void zfcp_erp_port_boxed(struct zfcp_port *, char *, void *);
-extern void zfcp_erp_lun_boxed(struct scsi_device *, char *, void *);
 extern void zfcp_erp_timeout_handler(unsigned long);
 
 /* zfcp_fc.c */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2010-09-08 08:49:06.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2010-09-08 08:49:32.000000000 +0200
@@ -365,7 +365,7 @@ void zfcp_fc_port_did_lookup(struct work
 	}
 
 	if (!port->d_id) {
-		zfcp_erp_port_failed(port, "fcgpn_2", NULL);
+		zfcp_erp_set_port_status(port, ZFCP_STATUS_COMMON_ERP_FAILED);
 		goto out;
 	}
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-09-08 08:49:31.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-09-08 08:49:32.000000000 +0200
@@ -104,7 +104,7 @@ static void zfcp_fsf_status_read_port_cl
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
 
-static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *req, char *id,
+static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *req,
 					 struct fsf_link_down_info *link_down)
 {
 	struct zfcp_adapter *adapter = req->adapter;
@@ -184,7 +184,7 @@ static void zfcp_fsf_link_down_info_eval
 			 "the FC fabric is down\n");
 	}
 out:
-	zfcp_erp_adapter_failed(adapter, id, req);
+	zfcp_erp_set_adapter_status(adapter, ZFCP_STATUS_COMMON_ERP_FAILED);
 }
 
 static void zfcp_fsf_status_read_link_down(struct zfcp_fsf_req *req)
@@ -195,13 +195,13 @@ static void zfcp_fsf_status_read_link_do
 
 	switch (sr_buf->status_subtype) {
 	case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
-		zfcp_fsf_link_down_info_eval(req, "fssrld1", ldi);
+		zfcp_fsf_link_down_info_eval(req, ldi);
 		break;
 	case FSF_STATUS_READ_SUB_FDISC_FAILED:
-		zfcp_fsf_link_down_info_eval(req, "fssrld2", ldi);
+		zfcp_fsf_link_down_info_eval(req, ldi);
 		break;
 	case FSF_STATUS_READ_SUB_FIRMWARE_UPDATE:
-		zfcp_fsf_link_down_info_eval(req, "fssrld3", NULL);
+		zfcp_fsf_link_down_info_eval(req, NULL);
 	};
 }
 
@@ -242,9 +242,8 @@ static void zfcp_fsf_status_read_handler
 		dev_info(&adapter->ccw_device->dev,
 			 "The local link has been restored\n");
 		/* All ports should be marked as ready to run again */
-		zfcp_erp_modify_adapter_status(adapter, "fssrh_1", NULL,
-					       ZFCP_STATUS_COMMON_RUNNING,
-					       ZFCP_SET);
+		zfcp_erp_set_adapter_status(adapter,
+					    ZFCP_STATUS_COMMON_RUNNING);
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
 					ZFCP_STATUS_COMMON_ERP_FAILED,
@@ -359,16 +358,14 @@ static void zfcp_fsf_protstatus_eval(str
 		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_4", req);
 		break;
 	case FSF_PROT_LINK_DOWN:
-		zfcp_fsf_link_down_info_eval(req, "fspse_5",
-					     &psq->link_down_info);
+		zfcp_fsf_link_down_info_eval(req, &psq->link_down_info);
 		/* go through reopen to flush pending requests */
 		zfcp_erp_adapter_reopen(adapter, 0, "fspse_6", req);
 		break;
 	case FSF_PROT_REEST_QUEUE:
 		/* All ports should be marked as ready to run again */
-		zfcp_erp_modify_adapter_status(adapter, "fspse_7", NULL,
-					       ZFCP_STATUS_COMMON_RUNNING,
-					       ZFCP_SET);
+		zfcp_erp_set_adapter_status(adapter,
+					    ZFCP_STATUS_COMMON_RUNNING);
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
 					ZFCP_STATUS_COMMON_ERP_FAILED,
@@ -538,7 +535,7 @@ static void zfcp_fsf_exchange_config_dat
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
 				&adapter->status);
 
-		zfcp_fsf_link_down_info_eval(req, "fsecdh2",
+		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
 	default:
@@ -604,7 +601,7 @@ static void zfcp_fsf_exchange_port_data_
 		break;
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
 		zfcp_fsf_exchange_port_evaluate(req);
-		zfcp_fsf_link_down_info_eval(req, "fsepdh1",
+		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
 	}
@@ -797,11 +794,17 @@ static void zfcp_fsf_abort_fcp_command_h
 		req->status |= ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED;
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(zfcp_sdev->port, "fsafch3", req);
+		zfcp_erp_set_port_status(zfcp_sdev->port,
+					 ZFCP_STATUS_COMMON_ACCESS_BOXED);
+		zfcp_erp_port_reopen(zfcp_sdev->port,
+				     ZFCP_STATUS_COMMON_ERP_FAILED, "fsafch3",
+				     req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_BOXED:
-		zfcp_erp_lun_boxed(sdev, "fsafch4", req);
+		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ACCESS_BOXED);
+		zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED,
+				    "fsafch4", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
                 break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -1343,7 +1346,8 @@ static void zfcp_fsf_open_port_handler(s
 			 "Not enough FCP adapter resources to open "
 			 "remote port 0x%016Lx\n",
 			 (unsigned long long)port->wwpn);
-		zfcp_erp_port_failed(port, "fsoph_1", req);
+		zfcp_erp_set_port_status(port,
+					 ZFCP_STATUS_COMMON_ERP_FAILED);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -1453,9 +1457,7 @@ static void zfcp_fsf_close_port_handler(
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		break;
 	case FSF_GOOD:
-		zfcp_erp_modify_port_status(port, "fscph_2", req,
-					    ZFCP_STATUS_COMMON_OPEN,
-					    ZFCP_CLEAR);
+		zfcp_erp_clear_port_status(port, ZFCP_STATUS_COMMON_OPEN);
 		break;
 	}
 }
@@ -1653,7 +1655,9 @@ static void zfcp_fsf_close_physical_port
 			if (sdev_to_zfcp(sdev)->port == port)
 				atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
 						  &sdev_to_zfcp(sdev)->status);
-		zfcp_erp_port_boxed(port, "fscpph2", req);
+		zfcp_erp_set_port_status(port, ZFCP_STATUS_COMMON_ACCESS_BOXED);
+		zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
+				     "fscpph2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -1751,7 +1755,11 @@ static void zfcp_fsf_open_lun_handler(st
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(zfcp_sdev->port, "fsouh_2", req);
+		zfcp_erp_set_port_status(zfcp_sdev->port,
+					 ZFCP_STATUS_COMMON_ACCESS_BOXED);
+		zfcp_erp_port_reopen(zfcp_sdev->port,
+				     ZFCP_STATUS_COMMON_ERP_FAILED, "fsouh_2",
+				     req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_SHARING_VIOLATION:
@@ -1764,7 +1772,7 @@ static void zfcp_fsf_open_lun_handler(st
 			 "0x%016Lx on port 0x%016Lx\n",
 			 (unsigned long long)zfcp_scsi_dev_lun(sdev),
 			 (unsigned long long)zfcp_sdev->port->wwpn);
-		zfcp_erp_lun_failed(sdev, "fsolh_4", req);
+		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ERP_FAILED);
 		/* fall through */
 	case FSF_INVALID_COMMAND_OPTION:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1856,7 +1864,11 @@ static void zfcp_fsf_close_lun_handler(s
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(zfcp_sdev->port, "fscuh_3", req);
+		zfcp_erp_set_port_status(zfcp_sdev->port,
+					 ZFCP_STATUS_COMMON_ACCESS_BOXED);
+		zfcp_erp_port_reopen(zfcp_sdev->port,
+				     ZFCP_STATUS_COMMON_ERP_FAILED, "fscuh_3",
+				     req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -2032,11 +2044,17 @@ static void zfcp_fsf_fcp_handler_common(
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(zfcp_sdev->port, "fssfch5", req);
+		zfcp_erp_set_port_status(zfcp_sdev->port,
+					 ZFCP_STATUS_COMMON_ACCESS_BOXED);
+		zfcp_erp_port_reopen(zfcp_sdev->port,
+				     ZFCP_STATUS_COMMON_ERP_FAILED, "fssfch5",
+				     req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_BOXED:
-		zfcp_erp_lun_boxed(sdev, "fssfch6", req);
+		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ACCESS_BOXED);
+		zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED,
+				    "fssfch6", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2010-09-08 08:49:30.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2010-09-08 08:49:32.000000000 +0200
@@ -158,8 +158,7 @@ static int zfcp_scsi_slave_alloc(struct
 	zfcp_sdev->latencies.cmd.fabric.min = 0xFFFFFFFF;
 	spin_lock_init(&zfcp_sdev->latencies.lock);
 
-	zfcp_erp_modify_lun_status(sdev, "scsla_0", NULL,
-				   ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
+	zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_RUNNING);
 	zfcp_erp_lun_reopen(sdev, 0, "scsla_1", NULL);
 	zfcp_erp_wait(port->adapter);
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2010-09-08 08:49:29.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2010-09-08 08:49:32.000000000 +0200
@@ -104,8 +104,7 @@ static ssize_t zfcp_sysfs_port_failed_st
 	if (strict_strtoul(buf, 0, &val) || val != 0)
 		return -EINVAL;
 
-	zfcp_erp_modify_port_status(port, "sypfai1", NULL,
-				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
+	zfcp_erp_set_port_status(port, ZFCP_STATUS_COMMON_RUNNING);
 	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, "sypfai2",
 			     NULL);
 	zfcp_erp_wait(port->adapter);
@@ -147,9 +146,7 @@ static ssize_t zfcp_sysfs_unit_failed_st
 
 	sdev = zfcp_unit_sdev(unit);
 	if (sdev) {
-		zfcp_erp_modify_lun_status(sdev, "syufai1", NULL,
-					   ZFCP_STATUS_COMMON_RUNNING,
-					   ZFCP_SET);
+		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_RUNNING);
 		zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED,
 				    "syufai2", NULL);
 		zfcp_erp_wait(unit->port->adapter);
@@ -199,8 +196,7 @@ static ssize_t zfcp_sysfs_adapter_failed
 		goto out;
 	}
 
-	zfcp_erp_modify_adapter_status(adapter, "syafai1", NULL,
-				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
+	zfcp_erp_set_adapter_status(adapter, ZFCP_STATUS_COMMON_RUNNING);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
 				"syafai2", NULL);
 	zfcp_erp_wait(adapter);

