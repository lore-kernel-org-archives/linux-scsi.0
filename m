From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 06/10] qla4xxx: qla4xxx_do_dpc defn before use
Date: Mon, 07 Aug 2006 10:37:44 -0500
Message-ID: <20060807153744.31019.87472.stgit@bebe.enoyolf.org>
References: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:38306 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932168AbWHGPkK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:40:10 -0400
In-Reply-To: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

- move the defn to before the call.

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |  211 ++++++++++++++++++++---------------------
 1 files changed, 105 insertions(+), 106 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index dcb5930..d75e2bd 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -44,7 +44,6 @@ MODULE_PARM_DESC(extended_error_logging,
  * SCSI host template entry points
  */
 
-static void qla4xxx_do_dpc(void *data);
 static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha);
 int qla4xxx_reset_target(struct scsi_qla_host *ha,
 			 struct ddb_entry * ddb_entry);
@@ -668,6 +667,111 @@ static void qla4xxx_timer(struct scsi_ql
 }
 
 /**
+ * qla4xxx_do_dpc - dpc routine
+ * @data: in our case pointer to adapter structure
+ *
+ * This routine is a task that is schedule by the interrupt handler
+ * to perform the background processing for interrupts.	 We put it
+ * on a task queue that is consumed whenever the scheduler runs; that's
+ * so you can do anything (i.e. put the process to sleep etc).	In fact,
+ * the mid-level tries to sleep when it reaches the driver threshold
+ * "host->can_queue". This can cause a panic if we were in our interrupt code.
+ **/
+static void qla4xxx_do_dpc(void *data)
+{
+	struct scsi_qla_host *ha = (struct scsi_qla_host *) data;
+	struct ddb_entry *ddb_entry, *dtemp;
+
+	DEBUG2(printk("scsi%ld: %s: DPC handler waking up.\n",
+		      ha->host_no, __func__));
+
+	DEBUG2(printk("scsi%ld: %s: ha->flags = 0x%08lx\n",
+		      ha->host_no, __func__, ha->flags));
+	DEBUG2(printk("scsi%ld: %s: ha->dpc_flags = 0x%08lx\n",
+		      ha->host_no, __func__, ha->dpc_flags));
+
+	/* Initialization not yet finished. Don't do anything yet. */
+	if (!test_bit(AF_INIT_DONE, &ha->flags))
+		return;
+
+	if (adapter_up(ha) ||
+	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
+	    test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
+	    test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags)) {
+		if (test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags))
+			/*
+			 * dg 09/23 Never initialize ddb list
+			 * once we up and running
+			 * qla4xxx_recover_adapter(ha,
+			 *    REBUILD_DDB_LIST);
+			 */
+			qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST);
+
+		if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
+			qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST);
+
+		if (test_and_clear_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
+			uint8_t wait_time = RESET_INTR_TOV;
+			unsigned long flags = 0;
+
+			qla4xxx_flush_active_srbs(ha);
+
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+			while ((readw(&ha->reg->ctrl_status) &
+				(CSR_SOFT_RESET | CSR_FORCE_SOFT_RESET)) != 0) {
+				if (--wait_time == 0)
+					break;
+
+				spin_unlock_irqrestore(&ha->hardware_lock,
+						       flags);
+
+				msleep(1000);
+
+				spin_lock_irqsave(&ha->hardware_lock, flags);
+			}
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+			if (wait_time == 0)
+				DEBUG2(printk("scsi%ld: %s: SR|FSR "
+					      "bit not cleared-- resetting\n",
+					      ha->host_no, __func__));
+		}
+	}
+
+	/* ---- process AEN? --- */
+	if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
+		qla4xxx_process_aen(ha, PROCESS_ALL_AENS);
+
+	/* ---- Get DHCP IP Address? --- */
+	if (test_and_clear_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags))
+		qla4xxx_get_dhcp_ip_address(ha);
+
+	/* ---- relogin device? --- */
+	if (adapter_up(ha) &&
+	    test_and_clear_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags)) {
+		list_for_each_entry_safe(ddb_entry, dtemp,
+					 &ha->ddb_list, list) {
+			if (test_and_clear_bit(DF_RELOGIN, &ddb_entry->flags) &&
+			    atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE)
+				qla4xxx_relogin_device(ha, ddb_entry);
+
+			/*
+			 * If mbx cmd times out there is no point
+			 * in continuing further.
+			 * With large no of targets this can hang
+			 * the system.
+			 */
+			if (test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
+				printk(KERN_WARNING "scsi%ld: %s: "
+				       "need to reset hba\n",
+				       ha->host_no, __func__);
+				break;
+			}
+		}
+	}
+}
+
+/**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
  * @pci_device_id: pointer to pci_device entry
@@ -1023,111 +1127,6 @@ struct srb * del_from_active_array(struc
 
 
 /**
- * qla4xxx_do_dpc - dpc routine
- * @data: in our case pointer to adapter structure
- *
- * This routine is a task that is schedule by the interrupt handler
- * to perform the background processing for interrupts.	 We put it
- * on a task queue that is consumed whenever the scheduler runs; that's
- * so you can do anything (i.e. put the process to sleep etc).	In fact,
- * the mid-level tries to sleep when it reaches the driver threshold
- * "host->can_queue". This can cause a panic if we were in our interrupt code.
- **/
-static void qla4xxx_do_dpc(void *data)
-{
-	struct scsi_qla_host *ha = (struct scsi_qla_host *) data;
-	struct ddb_entry *ddb_entry, *dtemp;
-
-	DEBUG2(printk("scsi%ld: %s: DPC handler waking up.\n",
-		      ha->host_no, __func__));
-
-	DEBUG2(printk("scsi%ld: %s: ha->flags = 0x%08lx\n",
-		      ha->host_no, __func__, ha->flags));
-	DEBUG2(printk("scsi%ld: %s: ha->dpc_flags = 0x%08lx\n",
-		      ha->host_no, __func__, ha->dpc_flags));
-
-	/* Initialization not yet finished. Don't do anything yet. */
-	if (!test_bit(AF_INIT_DONE, &ha->flags))
-		return;
-
-	if (adapter_up(ha) ||
-	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
-	    test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
-	    test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags)) {
-		if (test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags))
-			/*
-			 * dg 09/23 Never initialize ddb list
-			 * once we up and running
-			 * qla4xxx_recover_adapter(ha,
-			 *    REBUILD_DDB_LIST);
-			 */
-			qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST);
-
-		if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
-			qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST);
-
-		if (test_and_clear_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
-			uint8_t wait_time = RESET_INTR_TOV;
-			unsigned long flags = 0;
-
-			qla4xxx_flush_active_srbs(ha);
-
-			spin_lock_irqsave(&ha->hardware_lock, flags);
-			while ((readw(&ha->reg->ctrl_status) &
-				(CSR_SOFT_RESET | CSR_FORCE_SOFT_RESET)) != 0) {
-				if (--wait_time == 0)
-					break;
-
-				spin_unlock_irqrestore(&ha->hardware_lock,
-						       flags);
-
-				msleep(1000);
-
-				spin_lock_irqsave(&ha->hardware_lock, flags);
-			}
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-			if (wait_time == 0)
-				DEBUG2(printk("scsi%ld: %s: SR|FSR "
-					      "bit not cleared-- resetting\n",
-					      ha->host_no, __func__));
-		}
-	}
-
-	/* ---- process AEN? --- */
-	if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
-		qla4xxx_process_aen(ha, PROCESS_ALL_AENS);
-
-	/* ---- Get DHCP IP Address? --- */
-	if (test_and_clear_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags))
-		qla4xxx_get_dhcp_ip_address(ha);
-
-	/* ---- relogin device? --- */
-	if (adapter_up(ha) &&
-	    test_and_clear_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags)) {
-		list_for_each_entry_safe(ddb_entry, dtemp,
-					 &ha->ddb_list, list) {
-			if (test_and_clear_bit(DF_RELOGIN, &ddb_entry->flags) &&
-			    atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE)
-				qla4xxx_relogin_device(ha, ddb_entry);
-
-			/*
-			 * If mbx cmd times out there is no point
-			 * in continuing further.
-			 * With large no of targets this can hang
-			 * the system.
-			 */
-			if (test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
-				printk(KERN_WARNING "scsi%ld: %s: "
-				       "need to reset hba\n",
-				       ha->host_no, __func__);
-				break;
-			}
-		}
-	}
-}
-
-/**
  * qla4010_soft_reset - performs soft reset.
  * @ha: Pointer to host adapter structure.
  **/
