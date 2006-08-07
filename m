From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 07/10] qla4xxx: qla4xxx_recover_adapter defn before use
Date: Mon, 07 Aug 2006 10:37:54 -0500
Message-ID: <20060807153754.31019.41934.stgit@bebe.enoyolf.org>
References: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:43170 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932173AbWHGPk0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:40:26 -0400
In-Reply-To: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

- move the defn to before the call.
- make defn static.

This entailed moving a few more functions around to keep it compiling:
qla4xxx_cmd_wait
qla4010_soft_reset
qla4xxx_topcat_reset
qla4xxx_hard_reset

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |  625 ++++++++++++++++++++---------------------
 1 files changed, 311 insertions(+), 314 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d75e2bd..71498c7 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -45,9 +45,6 @@ MODULE_PARM_DESC(extended_error_logging,
  */
 
 static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha);
-int qla4xxx_reset_target(struct scsi_qla_host *ha,
-			 struct ddb_entry * ddb_entry);
-int qla4xxx_recover_adapter(struct scsi_qla_host *ha, uint8_t renew_ddb_list);
 void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha);
 
 static int qla4xxx_iospace_config(struct scsi_qla_host *ha);
@@ -667,6 +664,317 @@ static void qla4xxx_timer(struct scsi_ql
 }
 
 /**
+ * qla4xxx_cmd_wait - waits for all outstanding commands to complete
+ * @ha: Pointer to host adapter structure.
+ *
+ * This routine stalls the driver until all outstanding commands are returned.
+ * Caller must release the Hardware Lock prior to calling this routine.
+ **/
+static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
+{
+	uint32_t index = 0;
+	int stat = QLA_SUCCESS;
+	unsigned long flags;
+	int wait_cnt = WAIT_CMD_TOV;	/*
+					 * Initialized for 30 seconds as we
+					 * expect all commands to retuned
+					 * ASAP.
+					 */
+
+	while (wait_cnt) {
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		/* Find a command that hasn't completed. */
+		for (index = 1; index < MAX_SRBS; index++) {
+			if (ha->active_srb_array[index] != NULL)
+				break;
+		}
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		/* If No Commands are pending, wait is complete */
+		if (index == MAX_SRBS) {
+			break;
+		}
+
+		/* If we timed out on waiting for commands to come back
+		 * return ERROR.
+		 */
+		wait_cnt--;
+		if (wait_cnt == 0)
+			stat = QLA_ERROR;
+		else {
+			msleep(1000);
+		}
+	}			/* End of While (wait_cnt) */
+
+	return stat;
+}
+
+/**
+ * qla4010_soft_reset - performs soft reset.
+ * @ha: Pointer to host adapter structure.
+ **/
+static int qla4010_soft_reset(struct scsi_qla_host *ha)
+{
+	uint32_t max_wait_time;
+	unsigned long flags = 0;
+	int status = QLA_ERROR;
+	uint32_t ctrl_status;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	/*
+	 * If the SCSI Reset Interrupt bit is set, clear it.
+	 * Otherwise, the Soft Reset won't work.
+	 */
+	ctrl_status = readw(&ha->reg->ctrl_status);
+	if ((ctrl_status & CSR_SCSI_RESET_INTR) != 0)
+		writel(set_rmask(CSR_SCSI_RESET_INTR), &ha->reg->ctrl_status);
+
+	/* Issue Soft Reset */
+	writel(set_rmask(CSR_SOFT_RESET), &ha->reg->ctrl_status);
+	readl(&ha->reg->ctrl_status);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	/* Wait until the Network Reset Intr bit is cleared */
+	max_wait_time = RESET_INTR_TOV;
+	do {
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		ctrl_status = readw(&ha->reg->ctrl_status);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		if ((ctrl_status & CSR_NET_RESET_INTR) == 0)
+			break;
+
+		msleep(1000);
+	} while ((--max_wait_time));
+
+	if ((ctrl_status & CSR_NET_RESET_INTR) != 0) {
+		DEBUG2(printk(KERN_WARNING
+			      "scsi%ld: Network Reset Intr not cleared by "
+			      "Network function, clearing it now!\n",
+			      ha->host_no));
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		writel(set_rmask(CSR_NET_RESET_INTR), &ha->reg->ctrl_status);
+		readl(&ha->reg->ctrl_status);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	}
+
+	/* Wait until the firmware tells us the Soft Reset is done */
+	max_wait_time = SOFT_RESET_TOV;
+	do {
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		ctrl_status = readw(&ha->reg->ctrl_status);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		if ((ctrl_status & CSR_SOFT_RESET) == 0) {
+			status = QLA_SUCCESS;
+			break;
+		}
+
+		msleep(1000);
+	} while ((--max_wait_time));
+
+	/*
+	 * Also, make sure that the SCSI Reset Interrupt bit has been cleared
+	 * after the soft reset has taken place.
+	 */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ctrl_status = readw(&ha->reg->ctrl_status);
+	if ((ctrl_status & CSR_SCSI_RESET_INTR) != 0) {
+		writel(set_rmask(CSR_SCSI_RESET_INTR), &ha->reg->ctrl_status);
+		readl(&ha->reg->ctrl_status);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	/* If soft reset fails then most probably the bios on other
+	 * function is also enabled.
+	 * Since the initialization is sequential the other fn
+	 * wont be able to acknowledge the soft reset.
+	 * Issue a force soft reset to workaround this scenario.
+	 */
+	if (max_wait_time == 0) {
+		/* Issue Force Soft Reset */
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		writel(set_rmask(CSR_FORCE_SOFT_RESET), &ha->reg->ctrl_status);
+		readl(&ha->reg->ctrl_status);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		/* Wait until the firmware tells us the Soft Reset is done */
+		max_wait_time = SOFT_RESET_TOV;
+		do {
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+			ctrl_status = readw(&ha->reg->ctrl_status);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+			if ((ctrl_status & CSR_FORCE_SOFT_RESET) == 0) {
+				status = QLA_SUCCESS;
+				break;
+			}
+
+			msleep(1000);
+		} while ((--max_wait_time));
+	}
+
+	return status;
+}
+
+/**
+ * qla4xxx_topcat_reset - performs hard reset of TopCat Chip.
+ * @ha: Pointer to host adapter structure.
+ **/
+static int qla4xxx_topcat_reset(struct scsi_qla_host *ha)
+{
+	unsigned long flags;
+
+	ql4xxx_lock_nvram(ha);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	writel(set_rmask(GPOR_TOPCAT_RESET), isp_gp_out(ha));
+	readl(isp_gp_out(ha));
+	mdelay(1);
+
+	writel(clr_rmask(GPOR_TOPCAT_RESET), isp_gp_out(ha));
+	readl(isp_gp_out(ha));
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	mdelay(2523);
+
+	ql4xxx_unlock_nvram(ha);
+	return QLA_SUCCESS;
+}
+
+/**
+ * qla4xxx_hard_reset - performs HBA Hard Reset
+ * @ha: Pointer to host adapter structure.
+ **/
+static int qla4xxx_hard_reset(struct scsi_qla_host *ha)
+{
+	/* The QLA4010 really doesn't have an equivalent to a hard reset */
+	qla4xxx_flush_active_srbs(ha);
+	if (test_bit(AF_TOPCAT_CHIP_PRESENT, &ha->flags)) {
+		int status = QLA_ERROR;
+
+		if ((qla4010_soft_reset(ha) == QLA_SUCCESS) &&
+		    (qla4xxx_topcat_reset(ha) == QLA_SUCCESS) &&
+		    (qla4010_soft_reset(ha) == QLA_SUCCESS))
+			status = QLA_SUCCESS;
+		return status;
+	} else
+		return qla4010_soft_reset(ha);
+}
+
+/**
+ * qla4xxx_recover_adapter - recovers adapter after a fatal error
+ * @ha: Pointer to host adapter structure.
+ * @renew_ddb_list: Indicates what to do with the adapter's ddb list
+ *	after adapter recovery has completed.
+ *	0=preserve ddb list, 1=destroy and rebuild ddb list
+ **/
+static int qla4xxx_recover_adapter(struct scsi_qla_host *ha, uint8_t renew_ddb_list)
+{
+	int status;
+
+	/* Stall incoming I/O until we are done */
+	clear_bit(AF_ONLINE, &ha->flags);
+	DEBUG2(printk("scsi%ld: %s calling qla4xxx_cmd_wait\n", ha->host_no,
+		      __func__));
+
+	/* Wait for outstanding commands to complete.
+	 * Stalls the driver for max 30 secs
+	 */
+	status = qla4xxx_cmd_wait(ha);
+
+	qla4xxx_disable_intrs(ha);
+
+	/* Flush any pending ddb changed AENs */
+	qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
+
+	/* Reset the firmware.	If successful, function
+	 * returns with ISP interrupts enabled.
+	 */
+	if (status == QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
+			      ha->host_no, __func__));
+		status = qla4xxx_soft_reset(ha);
+	}
+	/* FIXMEkaren: Do we want to keep interrupts enabled and process
+	   AENs after soft reset */
+
+	/* If firmware (SOFT) reset failed, or if all outstanding
+	 * commands have not returned, then do a HARD reset.
+	 */
+	if (status == QLA_ERROR) {
+		DEBUG2(printk("scsi%ld: %s - Performing hard reset..\n",
+			      ha->host_no, __func__));
+		status = qla4xxx_hard_reset(ha);
+	}
+
+	/* Flush any pending ddb changed AENs */
+	qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
+
+	/* Re-initialize firmware. If successful, function returns
+	 * with ISP interrupts enabled */
+	if (status == QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s - Initializing adapter..\n",
+			      ha->host_no, __func__));
+
+		/* If successful, AF_ONLINE flag set in
+		 * qla4xxx_initialize_adapter */
+		status = qla4xxx_initialize_adapter(ha, renew_ddb_list);
+	}
+
+	/* Failed adapter initialization?
+	 * Retry reset_ha only if invoked via DPC (DPC_RESET_HA) */
+	if ((test_bit(AF_ONLINE, &ha->flags) == 0) &&
+	    (test_bit(DPC_RESET_HA, &ha->dpc_flags))) {
+		/* Adapter initialization failed, see if we can retry
+		 * resetting the ha */
+		if (!test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags)) {
+			ha->retry_reset_ha_cnt = MAX_RESET_HA_RETRIES;
+			DEBUG2(printk("scsi%ld: recover adapter - retrying "
+				      "(%d) more times\n", ha->host_no,
+				      ha->retry_reset_ha_cnt));
+			set_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
+			status = QLA_ERROR;
+		} else {
+			if (ha->retry_reset_ha_cnt > 0) {
+				/* Schedule another Reset HA--DPC will retry */
+				ha->retry_reset_ha_cnt--;
+				DEBUG2(printk("scsi%ld: recover adapter - "
+					      "retry remaining %d\n",
+					      ha->host_no,
+					      ha->retry_reset_ha_cnt));
+				status = QLA_ERROR;
+			}
+
+			if (ha->retry_reset_ha_cnt == 0) {
+				/* Recover adapter retries have been exhausted.
+				 * Adapter DEAD */
+				DEBUG2(printk("scsi%ld: recover adapter "
+					      "failed - board disabled\n",
+					      ha->host_no));
+				qla4xxx_flush_active_srbs(ha);
+				clear_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
+				clear_bit(DPC_RESET_HA, &ha->dpc_flags);
+				clear_bit(DPC_RESET_HA_DESTROY_DDB_LIST,
+					  &ha->dpc_flags);
+				status = QLA_ERROR;
+			}
+		}
+	} else {
+		clear_bit(DPC_RESET_HA, &ha->dpc_flags);
+		clear_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags);
+		clear_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
+	}
+
+	ha->adapter_error_count++;
+
+	if (status == QLA_SUCCESS)
+		qla4xxx_enable_intrs(ha);
+
+	DEBUG2(printk("scsi%ld: recover adapter .. DONE\n", ha->host_no));
+	return status;
+}
+
+/**
  * qla4xxx_do_dpc - dpc routine
  * @data: in our case pointer to adapter structure
  *
@@ -1127,138 +1435,6 @@ struct srb * del_from_active_array(struc
 
 
 /**
- * qla4010_soft_reset - performs soft reset.
- * @ha: Pointer to host adapter structure.
- **/
-int qla4010_soft_reset(struct scsi_qla_host *ha)
-{
-	uint32_t max_wait_time;
-	unsigned long flags = 0;
-	int status = QLA_ERROR;
-	uint32_t ctrl_status;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-
-	/*
-	 * If the SCSI Reset Interrupt bit is set, clear it.
-	 * Otherwise, the Soft Reset won't work.
-	 */
-	ctrl_status = readw(&ha->reg->ctrl_status);
-	if ((ctrl_status & CSR_SCSI_RESET_INTR) != 0)
-		writel(set_rmask(CSR_SCSI_RESET_INTR), &ha->reg->ctrl_status);
-
-	/* Issue Soft Reset */
-	writel(set_rmask(CSR_SOFT_RESET), &ha->reg->ctrl_status);
-	readl(&ha->reg->ctrl_status);
-
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	/* Wait until the Network Reset Intr bit is cleared */
-	max_wait_time = RESET_INTR_TOV;
-	do {
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		ctrl_status = readw(&ha->reg->ctrl_status);
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-		if ((ctrl_status & CSR_NET_RESET_INTR) == 0)
-			break;
-
-		msleep(1000);
-	} while ((--max_wait_time));
-
-	if ((ctrl_status & CSR_NET_RESET_INTR) != 0) {
-		DEBUG2(printk(KERN_WARNING
-			      "scsi%ld: Network Reset Intr not cleared by "
-			      "Network function, clearing it now!\n",
-			      ha->host_no));
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		writel(set_rmask(CSR_NET_RESET_INTR), &ha->reg->ctrl_status);
-		readl(&ha->reg->ctrl_status);
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	}
-
-	/* Wait until the firmware tells us the Soft Reset is done */
-	max_wait_time = SOFT_RESET_TOV;
-	do {
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		ctrl_status = readw(&ha->reg->ctrl_status);
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-		if ((ctrl_status & CSR_SOFT_RESET) == 0) {
-			status = QLA_SUCCESS;
-			break;
-		}
-
-		msleep(1000);
-	} while ((--max_wait_time));
-
-	/*
-	 * Also, make sure that the SCSI Reset Interrupt bit has been cleared
-	 * after the soft reset has taken place.
-	 */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ctrl_status = readw(&ha->reg->ctrl_status);
-	if ((ctrl_status & CSR_SCSI_RESET_INTR) != 0) {
-		writel(set_rmask(CSR_SCSI_RESET_INTR), &ha->reg->ctrl_status);
-		readl(&ha->reg->ctrl_status);
-	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	/* If soft reset fails then most probably the bios on other
-	 * function is also enabled.
-	 * Since the initialization is sequential the other fn
-	 * wont be able to acknowledge the soft reset.
-	 * Issue a force soft reset to workaround this scenario.
-	 */
-	if (max_wait_time == 0) {
-		/* Issue Force Soft Reset */
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		writel(set_rmask(CSR_FORCE_SOFT_RESET), &ha->reg->ctrl_status);
-		readl(&ha->reg->ctrl_status);
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		/* Wait until the firmware tells us the Soft Reset is done */
-		max_wait_time = SOFT_RESET_TOV;
-		do {
-			spin_lock_irqsave(&ha->hardware_lock, flags);
-			ctrl_status = readw(&ha->reg->ctrl_status);
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-			if ((ctrl_status & CSR_FORCE_SOFT_RESET) == 0) {
-				status = QLA_SUCCESS;
-				break;
-			}
-
-			msleep(1000);
-		} while ((--max_wait_time));
-	}
-
-	return status;
-}
-
-/**
- * qla4xxx_topcat_reset - performs hard reset of TopCat Chip.
- * @ha: Pointer to host adapter structure.
- **/
-int qla4xxx_topcat_reset(struct scsi_qla_host *ha)
-{
-	unsigned long flags;
-
-	ql4xxx_lock_nvram(ha);
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	writel(set_rmask(GPOR_TOPCAT_RESET), isp_gp_out(ha));
-	readl(isp_gp_out(ha));
-	mdelay(1);
-
-	writel(clr_rmask(GPOR_TOPCAT_RESET), isp_gp_out(ha));
-	readl(isp_gp_out(ha));
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	mdelay(2523);
-
-	ql4xxx_unlock_nvram(ha);
-	return QLA_SUCCESS;
-}
-
-/**
  * qla4xxx_soft_reset - performs a SOFT RESET of hba.
  * @ha: Pointer to host adapter structure.
  **/
@@ -1279,185 +1455,6 @@ int qla4xxx_soft_reset(struct scsi_qla_h
 		return qla4010_soft_reset(ha);
 }
 
-/**
- * qla4xxx_hard_reset - performs HBA Hard Reset
- * @ha: Pointer to host adapter structure.
- **/
-int qla4xxx_hard_reset(struct scsi_qla_host *ha)
-{
-	/* The QLA4010 really doesn't have an equivalent to a hard reset */
-	qla4xxx_flush_active_srbs(ha);
-	if (test_bit(AF_TOPCAT_CHIP_PRESENT, &ha->flags)) {
-		int status = QLA_ERROR;
-
-		if ((qla4010_soft_reset(ha) == QLA_SUCCESS) &&
-		    (qla4xxx_topcat_reset(ha) == QLA_SUCCESS) &&
-		    (qla4010_soft_reset(ha) == QLA_SUCCESS))
-			status = QLA_SUCCESS;
-		return status;
-	} else
-		return qla4010_soft_reset(ha);
-}
-
-/**
- * qla4xxx_cmd_wait - waits for all outstanding commands to complete
- * @ha: Pointer to host adapter structure.
- *
- * This routine stalls the driver until all outstanding commands are returned.
- * Caller must release the Hardware Lock prior to calling this routine.
- **/
-static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
-{
-	uint32_t index = 0;
-	int stat = QLA_SUCCESS;
-	unsigned long flags;
-	int wait_cnt = WAIT_CMD_TOV;	/*
-					 * Initialized for 30 seconds as we
-					 * expect all commands to retuned
-					 * ASAP.
-					 */
-
-	while (wait_cnt) {
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		/* Find a command that hasn't completed. */
-		for (index = 1; index < MAX_SRBS; index++) {
-			if (ha->active_srb_array[index] != NULL)
-				break;
-		}
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-		/* If No Commands are pending, wait is complete */
-		if (index == MAX_SRBS) {
-			break;
-		}
-
-		/* If we timed out on waiting for commands to come back
-		 * return ERROR.
-		 */
-		wait_cnt--;
-		if (wait_cnt == 0)
-			stat = QLA_ERROR;
-		else {
-			msleep(1000);
-		}
-	}			/* End of While (wait_cnt) */
-
-	return stat;
-}
-
-/**
- * qla4xxx_recover_adapter - recovers adapter after a fatal error
- * @ha: Pointer to host adapter structure.
- * @renew_ddb_list: Indicates what to do with the adapter's ddb list
- *	after adapter recovery has completed.
- *	0=preserve ddb list, 1=destroy and rebuild ddb list
- **/
-int qla4xxx_recover_adapter(struct scsi_qla_host *ha, uint8_t renew_ddb_list)
-{
-	int status;
-
-	/* Stall incoming I/O until we are done */
-	clear_bit(AF_ONLINE, &ha->flags);
-	DEBUG2(printk("scsi%ld: %s calling qla4xxx_cmd_wait\n", ha->host_no,
-		      __func__));
-
-	/* Wait for outstanding commands to complete.
-	 * Stalls the driver for max 30 secs
-	 */
-	status = qla4xxx_cmd_wait(ha);
-
-	qla4xxx_disable_intrs(ha);
-
-	/* Flush any pending ddb changed AENs */
-	qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
-
-	/* Reset the firmware.	If successful, function
-	 * returns with ISP interrupts enabled.
-	 */
-	if (status == QLA_SUCCESS) {
-		DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
-			      ha->host_no, __func__));
-		status = qla4xxx_soft_reset(ha);
-	}
-	/* FIXMEkaren: Do we want to keep interrupts enabled and process
-	   AENs after soft reset */
-
-	/* If firmware (SOFT) reset failed, or if all outstanding
-	 * commands have not returned, then do a HARD reset.
-	 */
-	if (status == QLA_ERROR) {
-		DEBUG2(printk("scsi%ld: %s - Performing hard reset..\n",
-			      ha->host_no, __func__));
-		status = qla4xxx_hard_reset(ha);
-	}
-
-	/* Flush any pending ddb changed AENs */
-	qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
-
-	/* Re-initialize firmware. If successful, function returns
-	 * with ISP interrupts enabled */
-	if (status == QLA_SUCCESS) {
-		DEBUG2(printk("scsi%ld: %s - Initializing adapter..\n",
-			      ha->host_no, __func__));
-
-		/* If successful, AF_ONLINE flag set in
-		 * qla4xxx_initialize_adapter */
-		status = qla4xxx_initialize_adapter(ha, renew_ddb_list);
-	}
-
-	/* Failed adapter initialization?
-	 * Retry reset_ha only if invoked via DPC (DPC_RESET_HA) */
-	if ((test_bit(AF_ONLINE, &ha->flags) == 0) &&
-	    (test_bit(DPC_RESET_HA, &ha->dpc_flags))) {
-		/* Adapter initialization failed, see if we can retry
-		 * resetting the ha */
-		if (!test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags)) {
-			ha->retry_reset_ha_cnt = MAX_RESET_HA_RETRIES;
-			DEBUG2(printk("scsi%ld: recover adapter - retrying "
-				      "(%d) more times\n", ha->host_no,
-				      ha->retry_reset_ha_cnt));
-			set_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
-			status = QLA_ERROR;
-		} else {
-			if (ha->retry_reset_ha_cnt > 0) {
-				/* Schedule another Reset HA--DPC will retry */
-				ha->retry_reset_ha_cnt--;
-				DEBUG2(printk("scsi%ld: recover adapter - "
-					      "retry remaining %d\n",
-					      ha->host_no,
-					      ha->retry_reset_ha_cnt));
-				status = QLA_ERROR;
-			}
-
-			if (ha->retry_reset_ha_cnt == 0) {
-				/* Recover adapter retries have been exhausted.
-				 * Adapter DEAD */
-				DEBUG2(printk("scsi%ld: recover adapter "
-					      "failed - board disabled\n",
-					      ha->host_no));
-				qla4xxx_flush_active_srbs(ha);
-				clear_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
-				clear_bit(DPC_RESET_HA, &ha->dpc_flags);
-				clear_bit(DPC_RESET_HA_DESTROY_DDB_LIST,
-					  &ha->dpc_flags);
-				status = QLA_ERROR;
-			}
-		}
-	} else {
-		clear_bit(DPC_RESET_HA, &ha->dpc_flags);
-		clear_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags);
-		clear_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
-	}
-
-	ha->adapter_error_count++;
-
-	if (status == QLA_SUCCESS)
-		qla4xxx_enable_intrs(ha);
-
-	DEBUG2(printk("scsi%ld: recover adapter .. DONE\n", ha->host_no));
-	return status;
-}
-
 
 /**
  * qla4xxx_eh_wait_on_command - waits for command to be returned by firmware
