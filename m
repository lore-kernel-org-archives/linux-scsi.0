From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH] qla4xxx: bug fixes
Date: Mon, 22 Jan 2007 12:26:11 -0800
Message-ID: <1169497571.12416.2.camel@linux-58to>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:1508 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbXAVUan (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 15:30:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com, David Somayajulu <david.somayajulu@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

The included patch fixes the following issues:
1. qla3xxx/qla4xxx co-existence issue which can result in a lockup when qla3xxx driver is unloaded, or when ifdown; ifup is performed on one of the interfaces correponding to qla3xxx. This is because qla4xxx HBA supports one ethernet and iscsi interfaces per port. Both iscsi and ethernet interfaces share the same state machine. The problem has to do with synchronizing access to the state machine in the event of a reset
2. mutex_lock() is sometimes not followed by mutex_unlock() prior to invoking a msleep() in qla4xxx_mailbox_command()

Thanks
David Somayajulu

---
 drivers/scsi/qla4xxx/ql4_def.h     |    1 -
 drivers/scsi/qla4xxx/ql4_glbl.h    |    1 +
 drivers/scsi/qla4xxx/ql4_init.c    |   18 +++++-----
 drivers/scsi/qla4xxx/ql4_isr.c     |    4 +-
 drivers/scsi/qla4xxx/ql4_mbx.c     |   35 ++++++++++++--------
 drivers/scsi/qla4xxx/ql4_os.c      |   64 ++++++++++++++++++++++--------------
 drivers/scsi/qla4xxx/ql4_version.h |    2 +
 7 files changed, 73 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 4249e52..6f4cf2d 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -418,7 +418,6 @@ #define MEM_ALIGN_VALUE \
 	 * concurrently.
 	 */
 	struct mutex  mbox_sem;
-	wait_queue_head_t mailbox_wait_queue;
 
 	/* temporary mailbox status registers */
 	volatile uint8_t mbox_status_count;
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 2122967..e021eb5 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -76,4 +76,5 @@ int qla4xxx_process_ddb_changed(struct s
 extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
 extern int ql4xdontresethba;
+extern int ql4_mod_unload;
 #endif /* _QLA4x_GBL_H */
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index cc210f2..b907b06 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -958,25 +958,25 @@ static int qla4xxx_start_firmware_from_f
 	return status;
 }
 
-int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a)
+int ql4xxx_lock_drvr_wait(struct scsi_qla_host *ha)
 {
-#define QL4_LOCK_DRVR_WAIT	300
-#define QL4_LOCK_DRVR_SLEEP	100
+#define QL4_LOCK_DRVR_WAIT	30
+#define QL4_LOCK_DRVR_SLEEP	1
 
 	int drvr_wait = QL4_LOCK_DRVR_WAIT;
 	while (drvr_wait) {
-		if (ql4xxx_lock_drvr(a) == 0) {
-			msleep(QL4_LOCK_DRVR_SLEEP);
+		if (ql4xxx_lock_drvr(ha) == 0) {
+			ssleep(QL4_LOCK_DRVR_SLEEP);
 			if (drvr_wait) {
 				DEBUG2(printk("scsi%ld: %s: Waiting for "
-					      "Global Init Semaphore...n",
-					      a->host_no,
-					      __func__));
+					      "Global Init Semaphore(%d)...n",
+					      ha->host_no,
+					      __func__, drvr_wait));
 			}
 			drvr_wait -= QL4_LOCK_DRVR_SLEEP;
 		} else {
 			DEBUG2(printk("scsi%ld: %s: Global Init Semaphore "
-				      "acquired.n", a->host_no, __func__));
+				      "acquired.n", ha->host_no, __func__));
 			return QLA_SUCCESS;
 		}
 	}
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index ef975e0..35b9e36 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -433,7 +433,6 @@ static void qla4xxx_isr_decode_mailbox(s
 					readl(&ha->reg->mailbox[i]);
 
 			set_bit(AF_MBOX_COMMAND_DONE, &ha->flags);
-			wake_up(&ha->mailbox_wait_queue);
 		}
 	} else if (mbox_status >> 12 == MBOX_ASYNC_EVENT_STATUS) {
 		/* Immediately process the AENs that don't require much work.
@@ -686,7 +685,8 @@ irqreturn_t qla4xxx_intr_handler(int irq
 			       &ha->reg->ctrl_status);
 			readl(&ha->reg->ctrl_status);
 
-			set_bit(DPC_RESET_HA_INTR, &ha->dpc_flags);
+			if (!ql4_mod_unload)
+				set_bit(DPC_RESET_HA_INTR, &ha->dpc_flags);
 
 			break;
 		} else if (intr_status & INTR_PENDING) {
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index b721dc5..d1ef229 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -29,19 +29,31 @@ int qla4xxx_mailbox_command(struct scsi_
 	u_long wait_count;
 	uint32_t intr_status;
 	unsigned long flags = 0;
-	DECLARE_WAITQUEUE(wait, current);
-
-	mutex_lock(&ha->mbox_sem);
-
-	/* Mailbox code active */
-	set_bit(AF_MBOX_COMMAND, &ha->flags);
 
 	/* Make sure that pointers are valid */
 	if (!mbx_cmd || !mbx_sts) {
 		DEBUG2(printk("scsi%ld: %s: Invalid mbx_cmd or mbx_sts "
 			      "pointer\n", ha->host_no, __func__));
-		goto mbox_exit;
+		return status;
 	}
+	/* Mailbox code active */
+	wait_count = MBOX_TOV * 100;
+
+	while (wait_count--) {
+		mutex_lock(&ha->mbox_sem);
+		if (!test_bit(AF_MBOX_COMMAND, &ha->flags)) {
+  			set_bit(AF_MBOX_COMMAND, &ha->flags);
+  			mutex_unlock(&ha->mbox_sem);
+  			break;
+  		}
+  		mutex_unlock(&ha->mbox_sem);
+  		if (!wait_count) {
+  			DEBUG2(printk("scsi%ld: %s: mbox_sem failed\n",
+  				ha->host_no, __func__));
+  			return status;
+  		}
+  		msleep(10);
+  	}
 
 	/* To prevent overwriting mailbox registers for a command that has
 	 * not yet been serviced, check to see if a previously issued
@@ -73,8 +85,6 @@ int qla4xxx_mailbox_command(struct scsi_
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Wait for completion */
-	set_current_state(TASK_UNINTERRUPTIBLE);
-	add_wait_queue(&ha->mailbox_wait_queue, &wait);
 
 	/*
 	 * If we don't want status, don't wait for the mailbox command to
@@ -83,8 +93,6 @@ int qla4xxx_mailbox_command(struct scsi_
 	 */
 	if (outCount == 0) {
 		status = QLA_SUCCESS;
-		set_current_state(TASK_RUNNING);
-		remove_wait_queue(&ha->mailbox_wait_queue, &wait);
 		goto mbox_exit;
 	}
 	/* Wait for command to complete */
@@ -108,8 +116,6 @@ int qla4xxx_mailbox_command(struct scsi_
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		msleep(10);
 	}
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&ha->mailbox_wait_queue, &wait);
 
 	/* Check for mailbox timeout. */
 	if (!test_bit(AF_MBOX_COMMAND_DONE, &ha->flags)) {
@@ -155,9 +161,10 @@ int qla4xxx_mailbox_command(struct scsi_
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 mbox_exit:
+	mutex_lock(&ha->mbox_sem);
 	clear_bit(AF_MBOX_COMMAND, &ha->flags);
-	clear_bit(AF_MBOX_COMMAND_DONE, &ha->flags);
 	mutex_unlock(&ha->mbox_sem);
+	clear_bit(AF_MBOX_COMMAND_DONE, &ha->flags);
 
 	return status;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9ef693c..81fb7bd 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -40,6 +40,8 @@ MODULE_PARM_DESC(ql4xextended_error_logg
 		 "Option to enable extended error logging, "
 		 "Default is 0 - no logging, 1 - debug logging");
 
+int ql4_mod_unload = 0;
+
 /*
  * SCSI host template entry points
  */
@@ -422,6 +424,9 @@ static int qla4xxx_queuecommand(struct s
 		goto qc_host_busy;
 	}
 
+	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
+		goto qc_host_busy;
+
 	spin_unlock_irq(ha->host->host_lock);
 
 	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);
@@ -707,16 +712,12 @@ static int qla4xxx_cmd_wait(struct scsi_
 	return stat;
 }
 
-/**
- * qla4xxx_soft_reset - performs soft reset.
- * @ha: Pointer to host adapter structure.
- **/
-int qla4xxx_soft_reset(struct scsi_qla_host *ha)
+static void qla4xxx_hw_reset(struct scsi_qla_host *ha)
 {
-	uint32_t max_wait_time;
-	unsigned long flags = 0;
-	int status = QLA_ERROR;
 	uint32_t ctrl_status;
+	unsigned long flags = 0;
+
+	DEBUG2(printk(KERN_ERR "scsi%ld: %s\n", ha->host_no, __func__));
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -733,6 +734,20 @@ int qla4xxx_soft_reset(struct scsi_qla_h
 	readl(&ha->reg->ctrl_status);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+/**
+ * qla4xxx_soft_reset - performs soft reset.
+ * @ha: Pointer to host adapter structure.
+ **/
+int qla4xxx_soft_reset(struct scsi_qla_host *ha)
+{
+	uint32_t max_wait_time;
+	unsigned long flags = 0;
+	int status = QLA_ERROR;
+	uint32_t ctrl_status;
+
+	qla4xxx_hw_reset(ha);
 
 	/* Wait until the Network Reset Intr bit is cleared */
 	max_wait_time = RESET_INTR_TOV;
@@ -966,10 +981,12 @@ static void qla4xxx_do_dpc(struct work_s
 	struct scsi_qla_host *ha =
 		container_of(work, struct scsi_qla_host, dpc_work);
 	struct ddb_entry *ddb_entry, *dtemp;
+	int status = QLA_ERROR;
 
 	DEBUG2(printk("scsi%ld: %s: DPC handler waking up."
-		"flags = 0x%08lx, dpc_flags = 0x%08lx\n",
-		ha->host_no, __func__, ha->flags, ha->dpc_flags));
+		"flags = 0x%08lx, dpc_flags = 0x%08lx ctrl_stat = 0x%08x\n",
+		ha->host_no, __func__, ha->flags, ha->dpc_flags,
+		readw(&ha->reg->ctrl_status)));
 
 	/* Initialization not yet finished. Don't do anything yet. */
 	if (!test_bit(AF_INIT_DONE, &ha->flags))
@@ -983,31 +1000,28 @@ static void qla4xxx_do_dpc(struct work_s
 			test_bit(DPC_RESET_HA, &ha->dpc_flags))
 			qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST);
 
-		if (test_and_clear_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
+		if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
 			uint8_t wait_time = RESET_INTR_TOV;
-			unsigned long flags = 0;
-
-			qla4xxx_flush_active_srbs(ha);
 
-			spin_lock_irqsave(&ha->hardware_lock, flags);
 			while ((readw(&ha->reg->ctrl_status) &
 				(CSR_SOFT_RESET | CSR_FORCE_SOFT_RESET)) != 0) {
 				if (--wait_time == 0)
 					break;
-
-				spin_unlock_irqrestore(&ha->hardware_lock,
-						       flags);
-
 				msleep(1000);
-
-				spin_lock_irqsave(&ha->hardware_lock, flags);
 			}
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
 			if (wait_time == 0)
 				DEBUG2(printk("scsi%ld: %s: SR|FSR "
 					      "bit not cleared-- resetting\n",
 					      ha->host_no, __func__));
+			qla4xxx_flush_active_srbs(ha);
+			if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS) {
+				qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
+				status = qla4xxx_initialize_adapter(ha,
+						PRESERVE_DDB_LIST);
+			}
+			clear_bit(DPC_RESET_HA_INTR, &ha->dpc_flags);
+			if (status == QLA_SUCCESS)
+				qla4xxx_enable_intrs(ha);
 		}
 	}
 
@@ -1062,7 +1076,7 @@ static void qla4xxx_free_adapter(struct 
 
 	/* Issue Soft Reset to put firmware in unknown state */
 	if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS)
-		qla4xxx_soft_reset(ha);
+		qla4xxx_hw_reset(ha);
 
 	/* Remove timer thread, if present */
 	if (ha->timer_active)
@@ -1198,7 +1212,6 @@ static int __devinit qla4xxx_probe_adapt
 	INIT_LIST_HEAD(&ha->free_srb_q);
 
 	mutex_init(&ha->mbox_sem);
-	init_waitqueue_head(&ha->mailbox_wait_queue);
 
 	spin_lock_init(&ha->hardware_lock);
 
@@ -1665,6 +1678,7 @@ no_srp_cache:
 
 static void __exit qla4xxx_module_exit(void)
 {
+	ql4_mod_unload = 1;
 	pci_unregister_driver(&qla4xxx_pci_driver);
 	iscsi_unregister_transport(&qla4xxx_iscsi_transport);
 	kmem_cache_destroy(srb_cachep);
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index 454e19c..e5183a6 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.00.07-k"
+#define QLA4XXX_DRIVER_VERSION	"5.00.07-k1"
-- 
1.4.2.3


