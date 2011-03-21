From: vikas.chaudhary@qlogic.com
Subject: [PATCH 04/13] qla4xxx: cleanup DDB relogin logic during initialization
Date: Mon, 21 Mar 2011 03:34:27 -0700
Message-ID: <1300703676-27398-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46160 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753032Ab1CUKqG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 06:46:06 -0400
In-Reply-To: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com, Karen Higgins <karen.higgins@qlogic.com>

From: Karen Higgins <karen.higgins@qlogic.com>

Driver has capability to add device dynamically and present
them to OS, driver no longer need to wait for DDBs to come
online during driver initialization.
Driver still issues a relogin for DDBs that are not online,
but no longer wait for DDB to come online.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    5 -
 drivers/scsi/qla4xxx/ql4_glbl.h |    1 -
 drivers/scsi/qla4xxx/ql4_init.c |  183 +++++++--------------------------------
 drivers/scsi/qla4xxx/ql4_isr.c  |   29 +------
 drivers/scsi/qla4xxx/ql4_mbx.c  |    3 -
 drivers/scsi/qla4xxx/ql4_os.c   |    4 -
 6 files changed, 33 insertions(+), 192 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 2fc0045..b46d0dc 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -233,9 +233,6 @@ struct ddb_entry {
 
 	unsigned long flags;	/* DDB Flags */
 
-	unsigned long dev_scan_wait_to_start_relogin;
-	unsigned long dev_scan_wait_to_complete_relogin;
-
 	uint16_t fw_ddb_index;	/* DDB firmware index */
 	uint16_t options;
 	uint32_t fw_ddb_device_state; /* F/W Device State  -- see ql4_fw.h */
@@ -479,7 +476,6 @@ struct scsi_qla_host {
 	uint32_t timer_active;
 
 	/* Recovery Timers */
-	uint32_t discovery_wait;
 	atomic_t check_relogin_timeouts;
 	uint32_t retry_reset_ha_cnt;
 	uint32_t isp_reset_timer;	/* reset test timer */
@@ -765,6 +761,5 @@ static inline void ql4xxx_unlock_drvr(struct scsi_qla_host *a)
 /* Defines for process_aen() */
 #define PROCESS_ALL_AENS	 0
 #define FLUSH_DDB_CHANGED_AENS	 1
-#define RELOGIN_DDB_CHANGED_AENS 2
 
 #endif	/*_QLA4XXX_H */
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 8fad99b..cc53e3f 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -136,7 +136,6 @@ void qla4_8xxx_clear_drv_active(struct scsi_qla_host *ha);
 void qla4_8xxx_set_drv_active(struct scsi_qla_host *ha);
 
 extern int ql4xextended_error_logging;
-extern int ql4xdiscoverywait;
 extern int ql4xdontresethba;
 extern int ql4xenablemsix;
 
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 22fc57e..bf1c30b 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -723,13 +723,38 @@ int qla4_is_relogin_allowed(struct scsi_qla_host *ha, uint32_t conn_err)
 	return relogin;
 }
 
+static void qla4xxx_flush_AENS(struct scsi_qla_host *ha)
+{
+	unsigned long wtime;
+
+	/* Flush the 0x8014 AEN from the firmware as a result of
+	 * Auto connect. We are basically doing get_firmware_ddb()
+	 * to determine whether we need to log back in or not.
+	 * Trying to do a set ddb before we have processed 0x8014
+	 * will result in another set_ddb() for the same ddb. In other
+	 * words there will be stale entries in the aen_q.
+	 */
+	wtime = jiffies + (2 * HZ);
+	do {
+		if (qla4xxx_get_firmware_state(ha) == QLA_SUCCESS)
+			if (ha->firmware_state & (BIT_2 | BIT_0))
+				return;
+
+		if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
+			qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
+
+		msleep(1000);
+	} while (!time_after_eq(jiffies, wtime));
+}
+
 /**
- * qla4xxx_configure_ddbs - builds driver ddb list
+ * qla4xxx_build_ddb_list - builds driver ddb list
  * @ha: Pointer to host adapter structure.
  *
  * This routine searches for all valid firmware ddb entries and builds
  * an internal ddb list. Ddbs that are considered valid are those with
  * a device state of SESSION_ACTIVE.
+ * A relogin (set_ddb) is issued for DDBs that are not online.
  **/
 static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 {
@@ -744,6 +769,8 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 	uint32_t ipv6_device;
 	uint32_t new_tgt;
 
+	qla4xxx_flush_AENS(ha);
+
 	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
 			&fw_ddb_entry_dma, GFP_KERNEL);
 	if (fw_ddb_entry == NULL) {
@@ -847,144 +874,6 @@ exit_build_ddb_list_no_free:
 	return status;
 }
 
-struct qla4_relog_scan {
-	int halt_wait;
-	uint32_t conn_err;
-	uint32_t fw_ddb_index;
-	uint32_t next_fw_ddb_index;
-	uint32_t fw_ddb_device_state;
-};
-
-static int qla4_test_rdy(struct scsi_qla_host *ha, struct qla4_relog_scan *rs)
-{
-	struct ddb_entry *ddb_entry;
-
-	if (qla4_is_relogin_allowed(ha, rs->conn_err)) {
-		/* We either have a device that is in
-		 * the process of relogging in or a
-		 * device that is waiting to be
-		 * relogged in */
-		rs->halt_wait = 0;
-
-		ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha,
-							   rs->fw_ddb_index);
-		if (ddb_entry == NULL)
-			return QLA_ERROR;
-
-		if (ddb_entry->dev_scan_wait_to_start_relogin != 0
-		    && time_after_eq(jiffies,
-				     ddb_entry->
-				     dev_scan_wait_to_start_relogin))
-		{
-			ddb_entry->dev_scan_wait_to_start_relogin = 0;
-			qla4xxx_set_ddb_entry(ha, rs->fw_ddb_index, 0);
-		}
-	}
-	return QLA_SUCCESS;
-}
-
-static int qla4_scan_for_relogin(struct scsi_qla_host *ha,
-				 struct qla4_relog_scan *rs)
-{
-	int error;
-
-	/* scan for relogins
-	 * ----------------- */
-	for (rs->fw_ddb_index = 0; rs->fw_ddb_index < MAX_DDB_ENTRIES;
-	     rs->fw_ddb_index = rs->next_fw_ddb_index) {
-		if (qla4xxx_get_fwddb_entry(ha, rs->fw_ddb_index, NULL, 0,
-					    NULL, &rs->next_fw_ddb_index,
-					    &rs->fw_ddb_device_state,
-					    &rs->conn_err, NULL, NULL)
-		    == QLA_ERROR)
-			return QLA_ERROR;
-
-		if (rs->fw_ddb_device_state == DDB_DS_LOGIN_IN_PROCESS)
-			rs->halt_wait = 0;
-
-		if (rs->fw_ddb_device_state == DDB_DS_SESSION_FAILED ||
-		    rs->fw_ddb_device_state == DDB_DS_NO_CONNECTION_ACTIVE) {
-			error = qla4_test_rdy(ha, rs);
-			if (error)
-				return error;
-		}
-
-		/* We know we've reached the last device when
-		 * next_fw_ddb_index is 0 */
-		if (rs->next_fw_ddb_index == 0)
-			break;
-	}
-	return QLA_SUCCESS;
-}
-
-/**
- * qla4xxx_devices_ready - wait for target devices to be logged in
- * @ha: pointer to adapter structure
- *
- * This routine waits up to ql4xdiscoverywait seconds
- * F/W database during driver load time.
- **/
-static int qla4xxx_devices_ready(struct scsi_qla_host *ha)
-{
-	int error;
-	unsigned long discovery_wtime;
-	struct qla4_relog_scan rs;
-
-	discovery_wtime = jiffies + (ql4xdiscoverywait * HZ);
-
-	DEBUG(printk("Waiting (%d) for devices ...\n", ql4xdiscoverywait));
-	do {
-		/* poll for AEN. */
-		qla4xxx_get_firmware_state(ha);
-		if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags)) {
-			/* Set time-between-relogin timer */
-			qla4xxx_process_aen(ha, RELOGIN_DDB_CHANGED_AENS);
-		}
-
-		/* if no relogins active or needed, halt discvery wait */
-		rs.halt_wait = 1;
-
-		error = qla4_scan_for_relogin(ha, &rs);
-
-		if (rs.halt_wait) {
-			DEBUG2(printk("scsi%ld: %s: Delay halted.  Devices "
-				      "Ready.\n", ha->host_no, __func__));
-			return QLA_SUCCESS;
-		}
-
-		msleep(2000);
-	} while (!time_after_eq(jiffies, discovery_wtime));
-
-	DEBUG3(qla4xxx_get_conn_event_log(ha));
-
-	return QLA_SUCCESS;
-}
-
-static void qla4xxx_flush_AENS(struct scsi_qla_host *ha)
-{
-	unsigned long wtime;
-
-	/* Flush the 0x8014 AEN from the firmware as a result of
-	 * Auto connect. We are basically doing get_firmware_ddb()
-	 * to determine whether we need to log back in or not.
-	 *  Trying to do a set ddb before we have processed 0x8014
-	 *  will result in another set_ddb() for the same ddb. In other
-	 *  words there will be stale entries in the aen_q.
-	 */
-	wtime = jiffies + (2 * HZ);
-	do {
-		if (qla4xxx_get_firmware_state(ha) == QLA_SUCCESS)
-			if (ha->firmware_state & (BIT_2 | BIT_0))
-				return;
-
-		if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
-			qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
-
-		msleep(1000);
-	} while (!time_after_eq(jiffies, wtime));
-
-}
-
 static int qla4xxx_initialize_ddb_list(struct scsi_qla_host *ha)
 {
 	uint16_t fw_ddb_index;
@@ -996,22 +885,12 @@ static int qla4xxx_initialize_ddb_list(struct scsi_qla_host *ha)
 
 	for (fw_ddb_index = 0; fw_ddb_index < MAX_DDB_ENTRIES; fw_ddb_index++)
 		ha->fw_ddb_index_map[fw_ddb_index] =
-			(struct ddb_entry *)INVALID_ENTRY;
+		    (struct ddb_entry *)INVALID_ENTRY;
 
 	ha->tot_ddbs = 0;
 
-	qla4xxx_flush_AENS(ha);
-
-	/* Wait for an AEN */
-	qla4xxx_devices_ready(ha);
-
-	/*
-	 * First perform device discovery for active
-	 * fw ddb indexes and build
-	 * ddb list.
-	 */
-	if ((status = qla4xxx_build_ddb_list(ha)) == QLA_ERROR)
-		return status;
+	/* Perform device discovery and build ddb list. */
+	status = qla4xxx_build_ddb_list(ha);
 
 	return status;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 6ffbe97..2ef1a98 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1008,34 +1008,9 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen)
 					      mbox_sts[0], mbox_sts[2],
 					      mbox_sts[3]));
 				break;
-			} else if (process_aen == RELOGIN_DDB_CHANGED_AENS) {
-				/* for use during init time, we only want to
-				 * relogin non-active ddbs */
-				struct ddb_entry *ddb_entry;
-
-				ddb_entry =
-					/* FIXME: name length? */
-					qla4xxx_lookup_ddb_by_fw_index(ha,
-								       mbox_sts[2]);
-				if (!ddb_entry)
-					break;
-
-				ddb_entry->dev_scan_wait_to_complete_relogin =
-					0;
-				ddb_entry->dev_scan_wait_to_start_relogin =
-					jiffies +
-					((ddb_entry->default_time2wait +
-					  4) * HZ);
-
-				DEBUG2(printk("scsi%ld: ddb [%d] initate"
-					      " RELOGIN after %d seconds\n",
-					      ha->host_no,
-					      ddb_entry->fw_ddb_index,
-					      ddb_entry->default_time2wait +
-					      4));
-				break;
 			}
-
+		case PROCESS_ALL_AENS:
+		default:
 			if (mbox_sts[1] == 0) {	/* Global DB change. */
 				qla4xxx_reinitialize_ddb_list(ha);
 			} else if (mbox_sts[1] == 1) {	/* Specific device. */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 47b2591..379df2b 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -407,9 +407,6 @@ qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
 	/*memcpy(ha->alias, init_fw_cb->Alias,
 	       min(sizeof(ha->alias), sizeof(init_fw_cb->Alias)));*/
 
-	/* Save Command Line Paramater info */
-	ha->discovery_wait = ql4xdiscoverywait;
-
 	if (ha->acb_version == ACB_SUPPORTED) {
 		ha->ipv6_options = init_fw_cb->ipv6_opts;
 		ha->ipv6_addl_options = init_fw_cb->ipv6_addtl_opts;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d1501fb..6068f80 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -29,10 +29,6 @@ static struct kmem_cache *srb_cachep;
 /*
  * Module parameter information and variables
  */
-int ql4xdiscoverywait = 60;
-module_param(ql4xdiscoverywait, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(ql4xdiscoverywait, "Discovery wait time");
-
 int ql4xdontresethba = 0;
 module_param(ql4xdontresethba, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql4xdontresethba,
-- 
1.7.3.2

