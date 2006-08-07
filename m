From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 05/10] qla4xxx: qla4xxx_timer defn before use
Date: Mon, 07 Aug 2006 10:37:34 -0500
Message-ID: <20060807153734.31019.64203.stgit@bebe.enoyolf.org>
References: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:36770 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932167AbWHGPkC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:40:02 -0400
In-Reply-To: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

- move the defn to before the call.
- make defn static.
- retabify the whole file

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |  215 ++++++++++++++++++++---------------------
 1 files changed, 107 insertions(+), 108 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 73dcde4..dcb5930 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -44,7 +44,6 @@ MODULE_PARM_DESC(extended_error_logging,
  * SCSI host template entry points
  */
 
-static void qla4xxx_timer(struct scsi_qla_host *ha);
 static void qla4xxx_do_dpc(void *data);
 static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha);
 int qla4xxx_reset_target(struct scsi_qla_host *ha,
@@ -565,6 +564,110 @@ mem_alloc_error_exit:
 }
 
 /**
+ * qla4xxx_timer - checks every second for work to do.
+ * @ha: Pointer to host adapter structure.
+ **/
+static void qla4xxx_timer(struct scsi_qla_host *ha)
+{
+	struct ddb_entry *ddb_entry, *dtemp;
+	int start_dpc = 0;
+
+	/* Search for relogin's to time-out and port down retry. */
+	list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
+		/* Count down time between sending relogins */
+		if (adapter_up(ha) &&
+		    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
+		    atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
+			if (atomic_read(&ddb_entry->retry_relogin_timer) !=
+			    INVALID_ENTRY) {
+				if (atomic_read(&ddb_entry->retry_relogin_timer)
+				    == 0) {
+					atomic_set(&ddb_entry->
+						   retry_relogin_timer,
+						   INVALID_ENTRY);
+					set_bit(DPC_RELOGIN_DEVICE,
+						&ha->dpc_flags);
+					set_bit(DF_RELOGIN, &ddb_entry->flags);
+					DEBUG2(printk("scsi%ld: %s: index [%d]"
+						      " login device\n",
+						      ha->host_no, __func__,
+						      ddb_entry->fw_ddb_index));
+				} else
+					atomic_dec(&ddb_entry->
+						   retry_relogin_timer);
+			}
+		}
+
+		/* Wait for relogin to timeout */
+		if (atomic_read(&ddb_entry->relogin_timer) &&
+		    (atomic_dec_and_test(&ddb_entry->relogin_timer) != 0)) {
+			/*
+			 * If the relogin times out and the device is
+			 * still NOT ONLINE then try and relogin again.
+			 */
+			if (atomic_read(&ddb_entry->state) !=
+			    DDB_STATE_ONLINE &&
+			    ddb_entry->fw_ddb_device_state ==
+			    DDB_DS_SESSION_FAILED) {
+				/* Reset retry relogin timer */
+				atomic_inc(&ddb_entry->relogin_retry_count);
+				DEBUG2(printk("scsi%ld: index[%d] relogin"
+					      " timed out-retrying"
+					      " relogin (%d)\n",
+					      ha->host_no,
+					      ddb_entry->fw_ddb_index,
+					      atomic_read(&ddb_entry->
+							  relogin_retry_count))
+					);
+				start_dpc++;
+				DEBUG(printk("scsi%ld:%d:%d: index [%d] "
+					     "initate relogin after"
+					     " %d seconds\n",
+					     ha->host_no, ddb_entry->bus,
+					     ddb_entry->target,
+					     ddb_entry->fw_ddb_index,
+					     ddb_entry->default_time2wait + 4)
+					);
+
+				atomic_set(&ddb_entry->retry_relogin_timer,
+					   ddb_entry->default_time2wait + 4);
+			}
+		}
+	}
+
+	/* Check for heartbeat interval. */
+	if (ha->firmware_options & FWOPT_HEARTBEAT_ENABLE &&
+	    ha->heartbeat_interval != 0) {
+		ha->seconds_since_last_heartbeat++;
+		if (ha->seconds_since_last_heartbeat >
+		    ha->heartbeat_interval + 2)
+			set_bit(DPC_RESET_HA, &ha->dpc_flags);
+	}
+
+
+	/* Wakeup the dpc routine for this adapter, if needed. */
+	if ((start_dpc ||
+	     test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
+	     test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags) ||
+	     test_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags) ||
+	     test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags) ||
+	     test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
+	     test_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags) ||
+	     test_bit(DPC_AEN, &ha->dpc_flags)) &&
+	    ha->dpc_thread) {
+		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine"
+			      " - dpc flags = 0x%lx\n",
+			      ha->host_no, __func__, ha->dpc_flags));
+		queue_work(ha->dpc_thread, &ha->dpc_work);
+	}
+
+	/* Reschedule timer thread to call us back in one second */
+	mod_timer(&ha->timer, jiffies + HZ);
+
+	DEBUG2(ha->seconds_since_last_intr++);
+}
+
+/**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
  * @pci_device_id: pointer to pci_device entry
@@ -572,7 +675,7 @@ mem_alloc_error_exit:
  * This routine will probe for Qlogic 4010 iSCSI host adapters.
  * It returns the number of host adapters of a particular
  * type that were found.  It also initializes all data necessary for
- * the driver.  It is passed-in the host number, so that it
+ * the driver.	It is passed-in the host number, so that it
  * knows where its first entry is in the scsi_hosts[] array.
  **/
 static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
@@ -918,119 +1021,15 @@ struct srb * del_from_active_array(struc
 	return srb;
 }
 
-/**
- * qla4xxx_timer - checks every second for work to do.
- * @ha: Pointer to host adapter structure.
- **/
-void qla4xxx_timer(struct scsi_qla_host *ha)
-{
-	struct ddb_entry *ddb_entry, *dtemp;
-	int start_dpc = 0;
-
-	/* Search for relogin's to time-out and port down retry. */
-	list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
-		/* Count down time between sending relogins */
-		if (adapter_up(ha) &&
-		    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
-		    atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
-			if (atomic_read(&ddb_entry->retry_relogin_timer) !=
-			    INVALID_ENTRY) {
-				if (atomic_read(&ddb_entry->retry_relogin_timer)
-				    		== 0) {
-					atomic_set(&ddb_entry->
-						retry_relogin_timer,
-						INVALID_ENTRY);
-					set_bit(DPC_RELOGIN_DEVICE,
-						&ha->dpc_flags);
-					set_bit(DF_RELOGIN, &ddb_entry->flags);
-					DEBUG2(printk("scsi%ld: %s: index [%d]"
-						      " login device\n",
-						      ha->host_no, __func__,
-						      ddb_entry->fw_ddb_index));
-				} else
-					atomic_dec(&ddb_entry->
-							retry_relogin_timer);
-			}
-		}
-
-		/* Wait for relogin to timeout */
-		if (atomic_read(&ddb_entry->relogin_timer) &&
-		    (atomic_dec_and_test(&ddb_entry->relogin_timer) != 0)) {
-			/*
-			 * If the relogin times out and the device is
-			 * still NOT ONLINE then try and relogin again.
-			 */
-			if (atomic_read(&ddb_entry->state) !=
-			    DDB_STATE_ONLINE &&
-			    ddb_entry->fw_ddb_device_state ==
-			    DDB_DS_SESSION_FAILED) {
-				/* Reset retry relogin timer */
-				atomic_inc(&ddb_entry->relogin_retry_count);
-				DEBUG2(printk("scsi%ld: index[%d] relogin"
-					      " timed out-retrying"
-					      " relogin (%d)\n",
-					      ha->host_no,
-					      ddb_entry->fw_ddb_index,
-					      atomic_read(&ddb_entry->
-							  relogin_retry_count))
-					);
-				start_dpc++;
-				DEBUG(printk("scsi%ld:%d:%d: index [%d] "
-					     "initate relogin after"
-					     " %d seconds\n",
-					     ha->host_no, ddb_entry->bus,
-					     ddb_entry->target,
-					     ddb_entry->fw_ddb_index,
-					     ddb_entry->default_time2wait + 4)
-					);
-
-				atomic_set(&ddb_entry->retry_relogin_timer,
-					   ddb_entry->default_time2wait + 4);
-			}
-		}
-	}
-
-	/* Check for heartbeat interval. */
-	if (ha->firmware_options & FWOPT_HEARTBEAT_ENABLE &&
-	    ha->heartbeat_interval != 0) {
-		ha->seconds_since_last_heartbeat++;
-		if (ha->seconds_since_last_heartbeat >
-		    ha->heartbeat_interval + 2)
-			set_bit(DPC_RESET_HA, &ha->dpc_flags);
-	}
-
-
-	/* Wakeup the dpc routine for this adapter, if needed. */
-	if ((start_dpc ||
-	     test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
-	     test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags) ||
-	     test_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags) ||
-	     test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags) ||
-	     test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
-	     test_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags) ||
-	     test_bit(DPC_AEN, &ha->dpc_flags)) &&
-	     ha->dpc_thread) {
-		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine"
-			      " - dpc flags = 0x%lx\n",
-			      ha->host_no, __func__, ha->dpc_flags));
-		queue_work(ha->dpc_thread, &ha->dpc_work);
-	}
-
-	/* Reschedule timer thread to call us back in one second */
-	mod_timer(&ha->timer, jiffies + HZ);
-
-	DEBUG2(ha->seconds_since_last_intr++);
-}
-
 
 /**
  * qla4xxx_do_dpc - dpc routine
  * @data: in our case pointer to adapter structure
  *
  * This routine is a task that is schedule by the interrupt handler
- * to perform the background processing for interrupts.  We put it
+ * to perform the background processing for interrupts.	 We put it
  * on a task queue that is consumed whenever the scheduler runs; that's
- * so you can do anything (i.e. put the process to sleep etc).  In fact,
+ * so you can do anything (i.e. put the process to sleep etc).	In fact,
  * the mid-level tries to sleep when it reaches the driver threshold
  * "host->can_queue". This can cause a panic if we were in our interrupt code.
  **/
