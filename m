From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 5/6] scsi: megaraid_sas - support for poll_mode_io
	(reducedinterrupt)
Date: Fri, 09 Nov 2007 04:40:16 -0500
Message-ID: <1194601216.6297.12.camel@dhcp-75-884.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36643 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762615AbXKIVfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2007 16:35:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com

Added module parameter "poll_mode_io" to support for "polling" (reduced interrupt operation).
        In this mode, IO completion interrupts are delayed. At the end of initiating IOs,
        the driver schedules for cmd completion if there are pending cmds.
        A timer-based interrupt has also been added to prevent IO completion from
        being delayed indefinitely in the case that no new IOs are initiated. 
Some formatting issues in resume, suspend comment block also corrected

Signed-off-by: Bo Yang <bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |  152 ++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |    3
 2 files changed, 149 insertions(+), 6 deletions(-)

diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 02:37:20.964596296 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 02:37:52.930736704 -0500
@@ -46,6 +46,14 @@
 #include <scsi/scsi_host.h>
 #include "megaraid_sas.h"
 
+/*
+ * poll_mode_io:1- schedule complete completion from q cmd
+ */
+static unsigned int poll_mode_io;
+module_param_named(poll_mode_io, poll_mode_io, int, 0);
+MODULE_PARM_DESC(poll_mode_io,
+	"Complete cmds from IO path, (default=0)");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
@@ -859,6 +867,12 @@ megasas_queue_command(struct scsi_cmnd *
 	atomic_inc(&instance->fw_outstanding);
 
 	instance->instancet->fire_cmd(cmd->frame_phys_addr ,cmd->frame_count-1,instance->reg_set);
+	/*
+	 * Check if we have pend cmds to be completed
+	 */
+	if (poll_mode_io && atomic_read(&instance->fw_outstanding))
+		tasklet_schedule(&instance->isr_tasklet);
+
 
 	return 0;
 
@@ -1891,6 +1905,47 @@ fail_fw_init:
 }
 
 /**
+ * megasas_start_timer - Initializes a timer object
+ * @instance:		Adapter soft state
+ * @timer:		timer object to be initialized
+ * @fn:			timer function
+ * @interval:		time interval between timer function call
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
+}
+
+/**
+ * megasas_io_completion_timer - Timer fn
+ * @instance_addr:	Address of adapter soft state
+ *
+ * Schedules tasklet for cmd completion
+ * if poll_mode_io is set
+ */
+static void
+megasas_io_completion_timer(unsigned long instance_addr)
+{
+	struct megasas_instance *instance =
+			(struct megasas_instance *)instance_addr;
+
+	if (atomic_read(&instance->fw_outstanding))
+		tasklet_schedule(&instance->isr_tasklet);
+
+	/* Restart timer */
+	if (poll_mode_io)
+		mod_timer(&instance->io_completion_timer,
+			jiffies + MEGASAS_COMPLETION_TIMER_INTERVAL);
+}
+
+/**
  * megasas_init_mfi -	Initializes the FW
  * @instance:		Adapter soft state
  *
@@ -2016,8 +2071,14 @@ static int megasas_init_mfi(struct megas
 	* Setup tasklet for cmd completion
 	*/
 
-        tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
-                        (unsigned long)instance);
+	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
+		(unsigned long)instance);
+
+	/* Initialize the cmd completion timer */
+	if (poll_mode_io)
+		megasas_start_timer(instance, &instance->io_completion_timer,
+				megasas_io_completion_timer,
+				MEGASAS_COMPLETION_TIMER_INTERVAL);
 	return 0;
 
       fail_fw_init:
@@ -2577,8 +2638,8 @@ static void megasas_shutdown_controller(
 }
 
 /**
- * megasas_suspend -    driver suspend entry point
- * @pdev:               PCI device structure
+ * megasas_suspend -	driver suspend entry point
+ * @pdev:		PCI device structure
  * @state:		PCI power state to suspend routine
  */
 static int __devinit
@@ -2590,6 +2651,9 @@ megasas_suspend(struct pci_dev *pdev, pm
 	instance = pci_get_drvdata(pdev);
 	host = instance->host;
 
+	if (poll_mode_io)
+		del_timer_sync(&instance->io_completion_timer);
+
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_HIBERNATE_SHUTDOWN);
 	tasklet_kill(&instance->isr_tasklet);
@@ -2676,6 +2740,11 @@ megasas_resume(struct pci_dev *pdev)
 	if (megasas_start_aen(instance))
 		printk(KERN_ERR "megasas: Start AEN failed\n");
 
+	/* Initialize the cmd completion timer */
+	if (poll_mode_io)
+		megasas_start_timer(instance, &instance->io_completion_timer,
+				megasas_io_completion_timer,
+				MEGASAS_COMPLETION_TIMER_INTERVAL);
 	return 0;
 
 fail_irq:
@@ -2714,6 +2783,9 @@ static void megasas_detach_one(struct pc
 	instance = pci_get_drvdata(pdev);
 	host = instance->host;
 
+	if (poll_mode_io)
+		del_timer_sync(&instance->io_completion_timer);
+
 	scsi_remove_host(instance->host);
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
@@ -3187,7 +3259,7 @@ static DRIVER_ATTR(release_date, S_IRUGO
 static ssize_t
 megasas_sysfs_show_dbg_lvl(struct device_driver *dd, char *buf)
 {
-	return sprintf(buf,"%u",megasas_dbg_lvl);
+	return sprintf(buf, "%u\n", megasas_dbg_lvl);
 }
 
 static ssize_t
@@ -3202,7 +3274,65 @@ megasas_sysfs_set_dbg_lvl(struct device_
 }
 
 static DRIVER_ATTR(dbg_lvl, S_IRUGO|S_IWUGO, megasas_sysfs_show_dbg_lvl,
-		   megasas_sysfs_set_dbg_lvl);
+		megasas_sysfs_set_dbg_lvl);
+
+static ssize_t
+megasas_sysfs_show_poll_mode_io(struct device_driver *dd, char *buf)
+{
+	return sprintf(buf, "%u\n", poll_mode_io);
+}
+
+static ssize_t
+megasas_sysfs_set_poll_mode_io(struct device_driver *dd,
+				const char *buf, size_t count)
+{
+	int retval = count;
+	int tmp = poll_mode_io;
+	int i;
+	struct megasas_instance *instance;
+
+	if (sscanf(buf, "%u", &poll_mode_io) < 1) {
+		printk(KERN_ERR "megasas: could not set poll_mode_io\n");
+		retval = -EINVAL;
+	}
+
+	/*
+	 * Check if poll_mode_io is already set or is same as previous value
+	 */
+	if ((tmp && poll_mode_io) || (tmp == poll_mode_io))
+		goto out;
+
+	if (poll_mode_io) {
+		/*
+		 * Start timers for all adapters
+		 */
+		for (i = 0; i < megasas_mgmt_info.max_index; i++) {
+			instance = megasas_mgmt_info.instance[i];
+			if (instance) {
+				megasas_start_timer(instance,
+					&instance->io_completion_timer,
+					megasas_io_completion_timer,
+					MEGASAS_COMPLETION_TIMER_INTERVAL);
+			}
+		}
+	} else {
+		/*
+		 * Delete timers for all adapters
+		 */
+		for (i = 0; i < megasas_mgmt_info.max_index; i++) {
+			instance = megasas_mgmt_info.instance[i];
+			if (instance)
+				del_timer_sync(&instance->io_completion_timer);
+		}
+	}
+
+out:
+	return retval;
+}
+
+static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUGO,
+		megasas_sysfs_show_poll_mode_io,
+		megasas_sysfs_set_poll_mode_io);
 
 /**
  * megasas_init - Driver load entry point
@@ -3253,8 +3383,16 @@ static int __init megasas_init(void)
 				  &driver_attr_dbg_lvl);
 	if (rval)
 		goto err_dcf_dbg_lvl;
+	rval = driver_create_file(&megasas_pci_driver.driver,
+				  &driver_attr_poll_mode_io);
+	if (rval)
+		goto err_dcf_poll_mode_io;
 
 	return rval;
+
+err_dcf_poll_mode_io:
+	driver_remove_file(&megasas_pci_driver.driver,
+			   &driver_attr_dbg_lvl);
 err_dcf_dbg_lvl:
 	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_release_date);
@@ -3273,6 +3411,8 @@ err_pcidrv:
 static void __exit megasas_exit(void)
 {
 	driver_remove_file(&megasas_pci_driver.driver,
+			   &driver_attr_poll_mode_io);
+	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_dbg_lvl);
 	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_release_date);
diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h	2007-11-07 02:37:21.548507528 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h	2007-11-07 02:37:52.932736400 -0500
@@ -572,6 +572,7 @@ struct megasas_ctrl_info {
 
 #define MFI_OB_INTR_STATUS_MASK			0x00000002
 #define MFI_POLL_TIMEOUT_SECS			60
+#define MEGASAS_COMPLETION_TIMER_INTERVAL      (HZ/10)
 
 #define MFI_REPLY_1078_MESSAGE_INTERRUPT	0x80000000
 
@@ -1111,6 +1112,8 @@ struct megasas_instance {
 
 	u8 flag;
 	unsigned long last_time;
+
+	struct timer_list io_completion_timer;
 };
 
 #define MEGASAS_IS_LOGICAL(scp)						\


