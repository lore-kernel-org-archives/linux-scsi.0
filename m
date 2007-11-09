From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 4/6] scsi: megaraid_sas - call cmd completion from reset
Date: Fri, 09 Nov 2007 04:35:44 -0500
Message-ID: <1194600944.6297.8.camel@dhcp-75-884.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36196 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757705AbXKIVaS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2007 16:30:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com

Driver will call cmd completion routine from Reset path without waiting for cmd completion from isr context.

Signed-off-by: Bo Yang <bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |  122 +++++++++++++------------
 drivers/scsi/megaraid/megaraid_sas.h |    2
 2 files changed, 70 insertions(+), 54 deletions(-)

diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 02:33:01.252078600 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 02:33:32.746290752 -0500
@@ -76,6 +76,10 @@ static DEFINE_MUTEX(megasas_async_queue_
 
 static u32 megasas_dbg_lvl;
 
+static void
+megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
+		     u8 alt_status);
+
 /**
  * megasas_get_cmd -	Get a command from the free pool
  * @instance:		Adapter soft state
@@ -886,6 +890,64 @@ static int megasas_slave_configure(struc
 }
 
 /**
+ * megasas_complete_cmd_dpc	 -	Returns FW's controller structure
+ * @instance_addr:			Address of adapter soft state
+ *
+ * Tasklet to complete cmds
+ */
+static void megasas_complete_cmd_dpc(unsigned long instance_addr)
+{
+	u32 producer;
+	u32 consumer;
+	u32 context;
+	struct megasas_cmd *cmd;
+	struct megasas_instance *instance =
+				(struct megasas_instance *)instance_addr;
+	unsigned long flags;
+
+	/* If we have already declared adapter dead, donot complete cmds */
+	if (instance->hw_crit_error)
+		return;
+
+	spin_lock_irqsave(&instance->completion_lock, flags);
+
+	producer = *instance->producer;
+	consumer = *instance->consumer;
+
+	while (consumer != producer) {
+		context = instance->reply_queue[consumer];
+
+		cmd = instance->cmd_list[context];
+
+		megasas_complete_cmd(instance, cmd, DID_OK);
+
+		consumer++;
+		if (consumer == (instance->max_fw_cmds + 1)) {
+			consumer = 0;
+		}
+	}
+
+	*instance->consumer = producer;
+
+	spin_unlock_irqrestore(&instance->completion_lock, flags);
+
+	/*
+	 * Check if we can restore can_queue
+	 */
+	if (instance->flag & MEGASAS_FW_BUSY
+		&& time_after(jiffies, instance->last_time + 5 * HZ)
+		&& atomic_read(&instance->fw_outstanding) < 17) {
+
+		spin_lock_irqsave(instance->host->host_lock, flags);
+		instance->flag &= ~MEGASAS_FW_BUSY;
+		instance->host->can_queue =
+				instance->max_fw_cmds - MEGASAS_INT_CMDS;
+
+		spin_unlock_irqrestore(instance->host->host_lock, flags);
+	}
+}
+
+/**
  * megasas_wait_for_outstanding -	Wait for all outstanding cmds
  * @instance:				Adapter soft state
  *
@@ -908,6 +970,11 @@ static int megasas_wait_for_outstanding(
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
 			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
 			       "commands to complete\n",i,outstanding);
+			/*
+			 * Call cmd completion routine. Cmd to be
+			 * be completed directly without depending on isr.
+			 */
+			megasas_complete_cmd_dpc((unsigned long)instance);
 		}
 
 		msleep(1000);
@@ -1749,60 +1816,6 @@ megasas_get_ctrl_info(struct megasas_ins
 }
 
 /**
- * megasas_complete_cmd_dpc	 -	Returns FW's controller structure
- * @instance_addr:			Address of adapter soft state
- *
- * Tasklet to complete cmds
- */
-static void megasas_complete_cmd_dpc(unsigned long instance_addr)
-{
-	u32 producer;
-	u32 consumer;
-	u32 context;
-	struct megasas_cmd *cmd;
-	struct megasas_instance *instance = (struct megasas_instance *)instance_addr;
-	unsigned long flags;
-
-	/* If we have already declared adapter dead, donot complete cmds */
-	if (instance->hw_crit_error)
-		return;
-
-	producer = *instance->producer;
-	consumer = *instance->consumer;
-
-	while (consumer != producer) {
-		context = instance->reply_queue[consumer];
-
-		cmd = instance->cmd_list[context];
-
-		megasas_complete_cmd(instance, cmd, DID_OK);
-
-		consumer++;
-		if (consumer == (instance->max_fw_cmds + 1)) {
-			consumer = 0;
-		}
-	}
-
-	*instance->consumer = producer;
-
-	/*
-	 * Check if we can restore can_queue
-	 */
-	if (instance->flag & MEGASAS_FW_BUSY
-		&& time_after(jiffies, instance->last_time + 5 * HZ)
-		&& atomic_read(&instance->fw_outstanding) < 17) {
-
-		spin_lock_irqsave(instance->host->host_lock, flags);
-		instance->flag &= ~MEGASAS_FW_BUSY;
-		instance->host->can_queue =
-				instance->max_fw_cmds - MEGASAS_INT_CMDS;
-
-		spin_unlock_irqrestore(instance->host->host_lock, flags);
-	}
-
-}
-
-/**
  * megasas_issue_init_mfi -	Initializes the FW
  * @instance:		Adapter soft state
  *
@@ -2394,6 +2407,7 @@ megasas_probe_one(struct pci_dev *pdev, 
 	init_waitqueue_head(&instance->abort_cmd_wait_q);
 
 	spin_lock_init(&instance->cmd_pool_lock);
+	spin_lock_init(&instance->completion_lock);
 
 	sema_init(&instance->aen_mutex, 1);
 	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h	2007-11-07 02:33:01.711008832 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h	2007-11-07 02:33:32.748290448 -0500
@@ -1084,6 +1084,8 @@ struct megasas_instance {
 	struct megasas_cmd **cmd_list;
 	struct list_head cmd_pool;
 	spinlock_t cmd_pool_lock;
+	/* used to synch producer, consumer ptrs in dpc */
+	spinlock_t completion_lock;
 	struct dma_pool *frame_dma_pool;
 	struct dma_pool *sense_dma_pool;
 


