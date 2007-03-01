From: Sumant Patro <sumant.patro@lsi.com>
Subject: [PATCH] scsi: megaraid_sas - throttle io if cmds are in risk of
	being timed-out
Date: Thu, 01 Mar 2007 13:29:53 -0800
Message-ID: <1172784593.19842.21.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35070 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422718AbXCBCng (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Mar 2007 21:43:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com

Driver to throttle IO to reduce risk of OS timing out cmds.

Implemented a circular queue to keep track of pending OS cmds in FW. 
This queue is periodically (every 10 sec) checked by a timer routine.
If there is any cmd that is in risk of getting timed-out by the OS, 
the host->can_queue is reduced to 16 and MEGASAS_FW_BUSY flag is set. 
The host->can_queue will be restored to default value when the following 
two conditions are met : 5 secs has elapsed and the # of outstanding cmds
in FW is less than 17.
Also increased the per cmd timeout to 120*HZ from 90*HZ.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---

 drivers/scsi/megaraid/megaraid_sas.c |  118 ++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |   25 ++++-
 2 files changed, 136 insertions(+), 7 deletions(-)

diff -uprN linux-orig/drivers/scsi/megaraid/megaraid_sas.c linux-new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-orig/drivers/scsi/megaraid/megaraid_sas.c	2007-03-01 06:04:40.000000000 -0800
+++ linux-new/drivers/scsi/megaraid/megaraid_sas.c	2007-03-01 10:26:35.000000000 -0800
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.10-rc1
+ * Version	: v00.00.03.10-rc2
  *
  * Authors:
  *	(email-id : megaraidlinux@lsi.com)
@@ -112,6 +112,15 @@ megasas_return_cmd(struct megasas_instan
 {
 	unsigned long flags;
 
+	if (cmd->watchdog_slot != 0xff) {
+		spin_lock_irqsave(&instance->watchdog_lock, flags);
+
+		instance->watchdog_arr[cmd->watchdog_slot]--;
+		cmd->watchdog_slot = 0xff;
+
+		spin_unlock_irqrestore(&instance->watchdog_lock, flags);
+	}
+
 	spin_lock_irqsave(&instance->cmd_pool_lock, flags);
 
 	cmd->scmd = NULL;
@@ -841,6 +850,7 @@ megasas_queue_command(struct scsi_cmnd *
 	u32 frame_count;
 	struct megasas_cmd *cmd;
 	struct megasas_instance *instance;
+	unsigned long flags;
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
@@ -888,6 +898,16 @@ megasas_queue_command(struct scsi_cmnd *
 	cmd->scmd = scmd;
 
 	/*
+	 * Update watchdog array before sending cmd to FW
+	 */
+	spin_lock_irqsave(&instance->watchdog_lock, flags);
+
+	cmd->watchdog_slot = instance->watchdog_head;
+	instance->watchdog_arr[cmd->watchdog_slot]++;
+
+	spin_unlock_irqrestore(&instance->watchdog_lock, flags);
+
+	/*
 	 * Issue the command to the FW
 	 */
 	atomic_inc(&instance->fw_outstanding);
@@ -919,7 +939,7 @@ static int megasas_slave_configure(struc
 	 * The RAID firmware may require extended timeouts.
 	 */
 	if (sdev->channel >= MEGASAS_MAX_PD_CHANNELS)
-		sdev->timeout = 90 * HZ;
+		sdev->timeout = 120 * HZ;
 	return 0;
 }
 
@@ -981,8 +1001,8 @@ static int megasas_generic_reset(struct 
 
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
-	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET -%ld cmd=%x\n",
-	       scmd->serial_number, scmd->cmnd[0]);
+	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET -%ld cmd=%x, retries=%x\n",
+		 scmd->serial_number, scmd->cmnd[0], scmd->retries);
 
 	if (instance->hw_crit_error) {
 		printk(KERN_ERR "megasas: cannot recover from previous reset "
@@ -1714,6 +1734,7 @@ static int megasas_alloc_cmds(struct meg
 		memset(cmd, 0, sizeof(struct megasas_cmd));
 		cmd->index = i;
 		cmd->instance = instance;
+		cmd->watchdog_slot = 0xff;
 
 		list_add_tail(&cmd->list, &instance->cmd_pool);
 	}
@@ -1828,9 +1849,80 @@ static void megasas_complete_cmd_dpc(uns
 	}
 
 	*instance->consumer = producer;
+
+	/*
+	 * Check if we can restore can_queue
+	 */
+	if (instance->flag & MEGASAS_FW_BUSY
+		&& time_after(jiffies, instance->last_time + 5 * HZ)
+		&& atomic_read(&instance->fw_outstanding) < 17) {
+
+		instance->flag &= ~MEGASAS_FW_BUSY;
+		instance->host->can_queue = 
+				instance->max_fw_cmds - MEGASAS_INT_CMDS;
+	}
+}
+
+/**
+ * megasas_start_timer - Initializes a timer object
+ * @instance:		Adapter soft state
+ * @timer: 		timer object to be initialized
+ * @fn:			timer function
+ * @interval:		time interval between timer function call
+ *
+ */
+static inline void
+megasas_start_timer(struct megasas_instance *instance,
+			struct timer_list *timer,
+			void *fn, unsigned long interval)
+{
+	init_timer(timer);
+	timer->expires = jiffies + interval;
+	timer->data = (unsigned long)instance;
+	timer->function = fn;
+	add_timer(timer);
 }
 
 /**
+ * megasas_throttle_timer - Timer fn
+ * @instance_addr:	Address of adapter soft state
+ *
+ * Verifies and sets the FW busy flag if there is any pending cmd
+ * with the FW that is in risk of being timed-out by the OS
+ */
+static void
+megasas_throttle_timer(unsigned long instance_addr)
+{
+	unsigned long flags;
+	u32 pending;
+	struct megasas_instance *instance = (struct megasas_instance *)instance_addr;
+
+	spin_lock_irqsave(&instance->watchdog_lock, flags);
+
+	instance->watchdog_head++;
+	if (instance->watchdog_head == MEGASAS_MAX_WATCHDOG_SLOTS)
+		instance->watchdog_head = 0;
+
+	if (instance->watchdog_head == instance->watchdog_tail) {
+		pending = instance->watchdog_arr[instance->watchdog_tail];
+		if (pending) {
+			/* FW is busy, throttle IO */
+			instance->host->can_queue = 16;
+			instance->last_time = jiffies;
+			instance->flag |= MEGASAS_FW_BUSY;
+		}
+		instance->watchdog_tail++;
+		if (instance->watchdog_tail == MEGASAS_MAX_WATCHDOG_SLOTS)
+			instance->watchdog_tail = 0;
+	}
+	spin_unlock_irqrestore(&instance->watchdog_lock, flags);
+
+	/* Restart timer */
+	mod_timer(&instance->throttle_timer,
+			jiffies + MEGASAS_WATCHDOG_TIMER_INTERVAL);
+}
+ 
+/**
  * megasas_init_mfi -	Initializes the FW
  * @instance:		Adapter soft state
  *
@@ -1851,6 +1943,7 @@ static int megasas_init_mfi(struct megas
 	struct megasas_init_queue_info *initq_info;
 	dma_addr_t init_frame_h;
 	dma_addr_t initq_info_h;
+	int i;
 
 	/*
 	 * Map the message registers
@@ -2006,6 +2099,19 @@ static int megasas_init_mfi(struct megas
 
         tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
                         (unsigned long)instance);
+
+	/* Initialize watchdog data structs */
+	for (i = 0; i < MEGASAS_MAX_WATCHDOG_SLOTS; i++)
+		instance->watchdog_arr[i] = 0;
+
+	instance->watchdog_head = 0;
+	instance->watchdog_tail = MEGASAS_MAX_WATCHDOG_SLOTS - 1;
+
+	/* Initialize the throttle IO timer */
+	megasas_start_timer(instance, &instance->throttle_timer,
+				megasas_throttle_timer,
+				MEGASAS_WATCHDOG_TIMER_INTERVAL);
+
 	return 0;
 
       fail_fw_init:
@@ -2385,6 +2491,7 @@ megasas_probe_one(struct pci_dev *pdev, 
 	init_waitqueue_head(&instance->abort_cmd_wait_q);
 
 	spin_lock_init(&instance->cmd_pool_lock);
+	spin_lock_init(&instance->watchdog_lock);
 
 	sema_init(&instance->aen_mutex, 1);
 	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
@@ -2398,6 +2505,8 @@ megasas_probe_one(struct pci_dev *pdev, 
 	instance->init_id = MEGASAS_DEFAULT_INIT_ID;
 
 	megasas_dbg_lvl = 0;
+	instance->flag = 0;
+	instance->last_time = 0;
 
 	/*
 	 * Initialize MFI Firmware
@@ -2566,6 +2675,7 @@ static void megasas_detach_one(struct pc
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance);
 	tasklet_kill(&instance->isr_tasklet);
+	del_timer_sync(&instance->throttle_timer);
 
 	/*
 	 * Take the instance off the instance array. Note that we will not
diff -uprN linux-orig/drivers/scsi/megaraid/megaraid_sas.h linux-new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-orig/drivers/scsi/megaraid/megaraid_sas.h	2007-03-01 06:04:40.000000000 -0800
+++ linux-new/drivers/scsi/megaraid/megaraid_sas.h	2007-03-01 10:40:16.000000000 -0800
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.10-rc1"
-#define MEGASAS_RELDATE				"Feb 14, 2007"
-#define MEGASAS_EXT_VERSION			"Wed Feb 14 10:14:25 PST 2007"
+#define MEGASAS_VERSION				"00.00.03.10-rc2"
+#define MEGASAS_RELDATE				"Mar 01, 2007"
+#define MEGASAS_EXT_VERSION			"Thu Mar 01 10:07:34 PST 2007"
 
 /*
  * Device IDs
@@ -539,6 +539,10 @@ struct megasas_ctrl_info {
 
 #define MEGASAS_DBG_LVL				1
 
+#define MEGASAS_WATCHDOG_TIMER_INTERVAL		10*HZ
+#define MEGASAS_MAX_WATCHDOG_SLOTS		8
+#define MEGASAS_FW_BUSY				1
+
 /*
  * When SCSI mid-layer calls driver's reset routine, driver waits for
  * MEGASAS_RESET_WAIT_TIME seconds for all outstanding IO to complete. Note
@@ -1104,6 +1108,18 @@ struct megasas_instance {
 
 	struct megasas_instance_template *instancet;
 	struct tasklet_struct isr_tasklet;
+
+	/* 
+	 * watchdog data structs used to throttle IO if required
+	 */
+	u8 flag;
+	u8 watchdog_head;
+	u8 watchdog_tail;
+	u8 resvd;
+	unsigned long last_time;
+	u32 watchdog_arr[MEGASAS_MAX_WATCHDOG_SLOTS];
+	spinlock_t watchdog_lock;
+	struct timer_list throttle_timer;
 };
 
 #define MEGASAS_IS_LOGICAL(scp)						\
@@ -1129,6 +1145,9 @@ struct megasas_cmd {
 	struct scsi_cmnd *scmd;
 	struct megasas_instance *instance;
 	u32 frame_count;
+
+	u8 watchdog_slot;
+	u8 resvd[3];
 };
 
 #define MAX_MGMT_ADAPTERS		1024



