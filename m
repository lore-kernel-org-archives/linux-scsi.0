From: Pavel Machek <pavel@ucw.cz>
Subject: SCSI power management for AHCI
Date: Tue, 15 Jan 2008 21:11:14 +0100
Message-ID: <20080115201114.GA7219@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56656 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751269AbYAOULK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jan 2008 15:11:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-pm@lists.linux-foundation.org

Hi!

This is my first attempt at ahci autosuspend. It is _very_ hacky at
this moment, I'll seriously need to clean it up. But it seems to work
here.

It includes Alan Stern's patches. I guess I could/should produce
separate version.

								Pavel

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 54f38c2..58c558c 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -32,6 +32,7 @@
  *
  */
 
+#define DEBUG
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -259,8 +260,8 @@ static void ahci_fill_cmd_slot(struct ah
 			       u32 opts);
 #ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
-static int ahci_pci_device_resume(struct pci_dev *pdev);
+int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
+int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
 
 static struct class_device_attribute *ahci_shost_attrs[] = {
@@ -268,6 +269,37 @@ static struct class_device_attribute *ah
 	NULL
 };
 
+struct pci_dev *my_pdev;
+int ahci_runtime_suspend(struct pci_dev *pdev);
+int ahci_runtime_resume(struct pci_dev *pdev);
+int autosuspend_enabled;
+
+/* The host and its devices are all idle so we can autosuspend */
+static int autosuspend(struct Scsi_Host *host)
+{
+	if (my_pdev && autosuspend_enabled) {
+		printk("ahci: should autosuspend\n");
+		ahci_runtime_suspend(my_pdev);
+		return 0;
+	} 
+	printk("ahci: autosuspend disabled\n");
+	return -EINVAL;
+}
+
+/* The host needs to be autoresumed */
+static int autoresume(struct Scsi_Host *host)
+{
+	if (my_pdev && autosuspend_enabled) {
+		printk("ahci: should autoresume\n");
+		ahci_runtime_resume(my_pdev);
+		return 0;
+	}
+	printk("ahci: autoresume disabled\n");
+	return -EINVAL;
+}
+
+
+
 static struct scsi_host_template ahci_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -286,6 +318,8 @@ static struct scsi_host_template ahci_sh
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
 	.shost_attrs		= ahci_shost_attrs,
+	.autosuspend		= autosuspend,
+	.autoresume		= autoresume,
 };
 
 static const struct ata_port_operations ahci_ops = {
@@ -1810,6 +1844,10 @@ static void ahci_thaw(struct ata_port *a
 
 static void ahci_error_handler(struct ata_port *ap)
 {
+	struct ata_host *host = ap->host;
+	int rc;
+	extern int slept;
+
 	if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
 		/* restart engine */
 		ahci_stop_engine(ap);
@@ -1916,7 +1954,7 @@ static int ahci_port_suspend(struct ata_
 	return rc;
 }
 
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
@@ -1936,7 +1974,8 @@ static int ahci_pci_device_suspend(struc
 	return ata_pci_device_suspend(pdev, mesg);
 }
 
-static int ahci_pci_device_resume(struct pci_dev *pdev)
+
+int ahci_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	int rc;
@@ -1945,7 +1984,7 @@ static int ahci_pci_device_resume(struct
 	if (rc)
 		return rc;
 
-	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
+	if (1) {
 		rc = ahci_reset_controller(host);
 		if (rc)
 			return rc;
@@ -1957,6 +1996,55 @@ static int ahci_pci_device_resume(struct
 
 	return 0;
 }
+
+int ahci_runtime_suspend(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int i;
+
+	printk("ahci_runtime_suspend...\n");
+
+#if 0
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (ata_port_is_dummy(ap))
+			continue;
+
+		printk("suspending ata port %d...\n", i);
+		ahci_port_suspend(ap, PMSG_SUSPEND);
+		printk("done suspending port %d...\n", i);
+	}
+#endif
+
+	ata_pci_device_suspend(my_pdev, PMSG_SUSPEND);
+}
+
+int ahci_runtime_resume(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int i;
+
+	printk("ahci_runtime_resume\n");
+	ata_pci_device_resume(my_pdev);
+
+#if 0
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (ata_port_is_dummy(ap))
+			continue;
+
+		printk("resume ata port %d...\n", i);
+		ahci_port_resume(ap);
+		printk("done resume ata port %d...\n", i);
+	}
+#endif
+
+}
+
+
 #endif
 
 static int ahci_port_start(struct ata_port *ap)
@@ -2179,6 +2267,7 @@ static void ahci_p5wdh_workaround(struct
 	}
 }
 
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2283,8 +2372,12 @@ static int ahci_init_one(struct pci_dev 
 	ahci_print_info(host);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
+
+	rc = ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
 				 &ahci_sht);
+	pci_save_state(pdev);
+	my_pdev = pdev;
+	return rc;
 }
 
 static int __init ahci_init(void)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4753a18..b660611 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -779,6 +779,7 @@ void ata_lpm_schedule(struct ata_port *a
 }
 
 #ifdef CONFIG_PM
+/* This disables link power management */
 static void ata_lpm_enable(struct ata_host *host)
 {
 	struct ata_link *link;
@@ -795,6 +796,7 @@ static void ata_lpm_enable(struct ata_ho
 	}
 }
 
+/* This enables link power management */
 static void ata_lpm_disable(struct ata_host *host)
 {
 	int i;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f0124a8..b725df6 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -32,6 +32,7 @@
  *
  */
 
+#define DEBUG
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <scsi/scsi.h>
@@ -353,7 +354,7 @@ enum scsi_eh_timer_return ata_scsi_timed
  *	Inherited from SCSI layer (none, can sleep)
  *
  *	RETURNS:
- *	Zero.
+ *	Nothing.
  */
 void ata_scsi_error(struct Scsi_Host *host)
 {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a883bb0..e2cca05 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -33,6 +33,7 @@
  *
  */
 
+#define DEBUG
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 691ffb6..e6dd899 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -183,7 +183,7 @@ static void dpm_power_up(void)
  *
  *	Power on system devices then devices that required we shut them down
  *	with interrupts disabled.
- *	Called with interrupts disabled.
+ *	Called with interrupts disabled, may not sleep.
  */
 
 void device_power_up(void)
@@ -353,6 +353,8 @@ EXPORT_SYMBOL_GPL(device_suspend);
  *	Walk the dpm_off_irq list, calling ->power_down() for each device that
  *	couldn't power down the device with interrupts enabled. When we're
  *	done, power down system devices.
+ *
+ *	Must be called with disabled interrupts, may not sleep.
  */
 
 int device_power_down(pm_message_t state)
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 5ffbb88..1f61299 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -765,6 +765,7 @@ static int __init init_netconsole(void)
 	if (err)
 		goto undonotifier;
 
+	disable_console_on_suspend++;
 	register_console(&netconsole);
 	printk(KERN_INFO "netconsole: network logging started\n");
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a6676be..835e93d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -43,8 +43,8 @@ config SCSI_TGT
 
 config SCSI_NETLINK
 	bool
+	depends on NET
 	default	n
-	select NET
 
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
@@ -57,6 +57,18 @@ config SCSI_PROC_FS
 
 	  If unsure say Y.
 
+config SCSI_DYNAMIC_PM
+	bool "SCSI dynamic Power Management support (EXPERIMENTAL)"
+	depends on SCSI && PM && EXPERIMENTAL
+	---help---
+	  This option enables support for dynamic (or runtime)
+	  power management of SCSI devices and host adapters.
+	  If you say Y here, you can use the sysfs "power/level"
+	  and "power/autosuspend" files to control manual or
+	  automatic suspend/resume of individual SCSI devices.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
@@ -265,8 +277,7 @@ config SCSI_SPI_ATTRS
 
 config SCSI_FC_ATTRS
 	tristate "FiberChannel Transport Attributes"
-	depends on SCSI
-	select SCSI_NETLINK
+	depends on SCSI && SCSI_NETLINK
 	help
 	  If you wish to export transport-specific information about
 	  each attached FiberChannel device to sysfs, say Y.
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 2e6129f..1f413cc 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -150,7 +150,8 @@ obj-$(CONFIG_SCSI_WAIT_SCAN)	+= scsi_wai
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
-scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
+scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o \
+				   scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 24271a8..96c1839 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -155,24 +155,15 @@ EXPORT_SYMBOL(scsi_host_set_state);
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
-	unsigned long flags;
-	mutex_lock(&shost->scan_mutex);
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (scsi_host_set_state(shost, SHOST_CANCEL))
-		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
-			mutex_unlock(&shost->scan_mutex);
-			return;
-		}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-	mutex_unlock(&shost->scan_mutex);
+	if (scsi_pm_host_stop(shost))
+		return;
 	scsi_forget_host(shost);
 	scsi_proc_host_rm(shost);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irq(shost->host_lock);
 	if (scsi_host_set_state(shost, SHOST_DEL))
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irq(shost->host_lock);
 
 	transport_unregister_device(&shost->shost_gendev);
 	class_device_unregister(&shost->shost_classdev);
@@ -237,6 +228,7 @@ int scsi_add_host(struct Scsi_Host *shos
 	if (error)
 		goto out_destroy_host;
 
+	scsi_autosuspend_host(shost);
 	scsi_proc_host_add(shost);
 	return error;
 
@@ -388,6 +380,8 @@ struct Scsi_Host *scsi_host_alloc(struct
 	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "host%d",
 		  shost->host_no);
 
+	scsi_pm_host_initialize(shost);
+
 	shost->ehandler = kthread_run(scsi_error_handler, shost,
 			"scsi_eh_%d", shost->host_no);
 	if (IS_ERR(shost->ehandler)) {
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 0fb1709..948a789 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1078,15 +1078,20 @@ static int __init init_scsi(void)
 	error = scsi_init_sysctl();
 	if (error)
 		goto cleanup_hosts;
-	error = scsi_sysfs_register();
+	error = scsi_init_pm();
 	if (error)
 		goto cleanup_sysctl;
+	error = scsi_sysfs_register();
+	if (error)
+		goto cleanup_pm;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
 
+cleanup_pm:
+	scsi_exit_pm();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1106,6 +1111,7 @@ static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
 	scsi_sysfs_unregister();
+	scsi_exit_pm();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
 	scsi_exit_devinfo();
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ebaca4c..222d7ca 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -468,30 +468,34 @@ static void scsi_eh_done(struct scsi_cmn
 
 /**
  * scsi_try_host_reset - ask host adapter to reset itself
- * @scmd:	SCSI cmd to send hsot reset.
+ * @scmd:	SCSI cmd to send host reset.
  **/
 static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *shost = scmd->device->host;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
 					  __FUNCTION__));
 
 	if (!scmd->device->host->hostt->eh_host_reset_handler)
 		return FAILED;
+	if (scsi_autoresume_host(shost) != 0)
+		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_host_reset_handler(scmd);
+	rtn = shost->hostt->eh_host_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!shost->hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
+		spin_lock_irqsave(shost->host_lock, flags);
+		scsi_report_bus_reset(shost,
 				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 
+	scsi_autosuspend_host(shost);
 	return rtn;
 }
 
@@ -503,24 +507,28 @@ static int scsi_try_bus_reset(struct scs
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *shost = scmd->device->host;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
 					  __FUNCTION__));
 
-	if (!scmd->device->host->hostt->eh_bus_reset_handler)
+	if (!shost->hostt->eh_bus_reset_handler)
+		return FAILED;
+	if (scsi_autoresume_host(shost) != 0)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_bus_reset_handler(scmd);
+	rtn = shost->hostt->eh_bus_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!shost->hostt->skip_settle_delay)
 			ssleep(BUS_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
+		spin_lock_irqsave(shost->host_lock, flags);
+		scsi_report_bus_reset(shost,
 				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 
+	scsi_autosuspend_host(shost);
 	return rtn;
 }
 
@@ -1544,6 +1552,7 @@ static void scsi_unjam_host(struct Scsi_
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
+	int autoresume_rc;
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
@@ -1573,6 +1582,11 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
+#if 0
+		/* libata uses scsi_error_handler to suspend its parts; we deadlock
+		   if we try to autoresume here */
+		autoresume_rc = scsi_autoresume_host(shost);
+#endif
 		if (shost->transportt->eh_strategy_handler)
 			shost->transportt->eh_strategy_handler(shost);
 		else
@@ -1586,6 +1600,10 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
+#if 0
+		if (autoresume_rc == 0)
+			scsi_autosuspend_host(shost);
+#endif
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a9ac5b1..11667b9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -64,8 +64,6 @@ #endif
 };
 #undef SP
 
-static void scsi_run_queue(struct request_queue *q);
-
 /*
  * Function:	scsi_unprep_request()
  *
@@ -457,6 +455,7 @@ void scsi_device_unbusy(struct scsi_devi
 	spin_unlock(shost->host_lock);
 	spin_lock(sdev->request_queue->queue_lock);
 	sdev->device_busy--;
+	scsi_mark_last_busy(sdev);
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 }
 
@@ -518,7 +517,7 @@ static void scsi_single_lun_run(struct s
  * Notes:	The previous command was completely finished, start
  *		a new one if possible.
  */
-static void scsi_run_queue(struct request_queue *q)
+void scsi_run_queue(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
@@ -1278,6 +1277,8 @@ int scsi_prep_state_check(struct scsi_de
 			ret = BLKPREP_KILL;
 			break;
 		case SDEV_QUIESCE:
+			ret = scsi_pm_state_check(sdev, req);
+			break;
 		case SDEV_BLOCK:
 			/*
 			 * If the devices is blocked we defer normal commands.
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 3f34e93..c331de4 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -4,11 +4,13 @@ #define _SCSI_PRIV_H
 #include <linux/device.h>
 
 struct request_queue;
+struct request;
 struct scsi_cmnd;
 struct scsi_device;
 struct scsi_host_template;
 struct Scsi_Host;
 struct scsi_nl_hdr;
+struct workqueue_struct;
 
 
 /*
@@ -67,6 +69,7 @@ int scsi_eh_get_sense(struct list_head *
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern void scsi_run_queue(struct request_queue *q);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
@@ -132,6 +135,41 @@ static inline void scsi_netlink_init(voi
 static inline void scsi_netlink_exit(void) {}
 #endif
 
+/* scsi_pm.c */
+extern int scsi_bus_suspend(struct device *, pm_message_t);
+extern int scsi_bus_resume(struct device *);
+extern int scsi_pm_state_check(struct scsi_device *, struct request *);
+extern int scsi_pm_device_stop(struct scsi_device *);
+extern int scsi_pm_host_stop(struct Scsi_Host *);
+#ifdef CONFIG_SCSI_DYNAMIC_PM
+extern void scsi_autosuspend_host(struct Scsi_Host *);
+extern int scsi_autoresume_host(struct Scsi_Host *);
+extern void scsi_pm_host_initialize(struct Scsi_Host *);
+extern void scsi_mark_last_busy(struct scsi_device *);
+extern void scsi_use_ULD_pm(struct scsi_device *, int);
+extern void scsi_autosuspend_device(struct scsi_device *);
+extern int scsi_autoresume_device(struct scsi_device *);
+extern int scsi_pm_create_device_files(struct scsi_device *);
+extern void scsi_pm_device_initialize(struct scsi_device *);
+extern int scsi_init_pm(void);
+extern void scsi_exit_pm(void);
+#else
+static inline void scsi_autosuspend_host(struct Scsi_Host *shost)	{}
+static inline int scsi_autoresume_host(struct Scsi_Host *shost)
+					{ return 0; }
+static inline void scsi_pm_host_initialize(struct Scsi_Host *shost)	{}
+static inline void scsi_mark_last_busy(struct scsi_device *sdev)	{}
+static inline void scsi_use_ULD_pm(struct scsi_device *sdev, int v)	{}
+static inline void scsi_autosuspend_device(struct scsi_device *sdev)	{}
+static inline int scsi_autoresume_device(struct scsi_device *sdev)
+					{ return 0; }
+static inline int scsi_pm_create_device_files(struct scsi_device *sdev)
+					{ return 0; }
+static inline void scsi_pm_device_initialize(struct scsi_device *sdev)	{}
+static inline int scsi_init_pm(void)	{ return 0; }
+static inline void scsi_exit_pm(void)	{}
+#endif /* CONFIG_SCSI_DYNAMIC_PM */
+
 /* 
  * internal scsi timeout functions: for use by mid-layer and transport
  * classes.
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 40ea71c..de8c8ca 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -294,6 +294,9 @@ static struct scsi_device *scsi_alloc_sd
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
 	scsi_sysfs_device_initialize(sdev);
+	scsi_pm_device_initialize(sdev);
+	if (scsi_autoresume_host(shost) != 0)
+		goto out_device_destroy;
 
 	if (shost->hostt->slave_alloc) {
 		ret = shost->hostt->slave_alloc(sdev);
@@ -304,6 +307,7 @@ static struct scsi_device *scsi_alloc_sd
 			 */
 			if (ret == -ENXIO)
 				display_failure_msg = 0;
+			scsi_autosuspend_host(shost);
 			goto out_device_destroy;
 		}
 	}
@@ -920,6 +924,7 @@ static int scsi_add_lun(struct scsi_devi
 static inline void scsi_destroy_sdev(struct scsi_device *sdev)
 {
 	scsi_device_set_state(sdev, SDEV_DEL);
+	scsi_autosuspend_host(sdev->host);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(&sdev->sdev_gendev);
@@ -1082,6 +1087,7 @@ static int scsi_probe_and_add_lun(struct
 
 	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
+		scsi_autosuspend_device(sdev);
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
 			scsi_unlock_floptical(sdev, result);
@@ -1775,6 +1781,8 @@ static void scsi_finish_async_scan(struc
 
 static void do_scsi_scan_host(struct Scsi_Host *shost)
 {
+	if (scsi_autoresume_host(shost) != 0)
+		return;
 	if (shost->hostt->scan_finished) {
 		unsigned long start = jiffies;
 		if (shost->hostt->scan_start)
@@ -1786,6 +1794,7 @@ static void do_scsi_scan_host(struct Scs
 		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
 				SCAN_WILD_CARD, 0);
 	}
+	scsi_autosuspend_host(shost);
 }
 
 static int do_scan_async(void *_data)
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 00b3866..4228cb4 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -340,39 +340,6 @@ static int scsi_bus_uevent(struct device
 	return 0;
 }
 
-static int scsi_bus_suspend(struct device * dev, pm_message_t state)
-{
-	struct device_driver *drv = dev->driver;
-	struct scsi_device *sdev = to_scsi_device(dev);
-	int err;
-
-	err = scsi_device_quiesce(sdev);
-	if (err)
-		return err;
-
-	if (drv && drv->suspend) {
-		err = drv->suspend(dev, state);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int scsi_bus_resume(struct device * dev)
-{
-	struct device_driver *drv = dev->driver;
-	struct scsi_device *sdev = to_scsi_device(dev);
-	int err = 0;
-
-	if (drv && drv->resume)
-		err = drv->resume(dev);
-
-	scsi_device_resume(sdev);
-
-	return err;
-}
-
 static int scsi_bus_remove(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
@@ -814,6 +781,12 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 		goto out;
 	}
 
+	error = scsi_pm_create_device_files(sdev);
+	if (error) {
+		__scsi_remove_device(sdev);
+		goto out;
+	}
+
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL);
 
 	if (error)
@@ -854,7 +827,7 @@ void __scsi_remove_device(struct scsi_de
 {
 	struct device *dev = &sdev->sdev_gendev;
 
-	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+	if (scsi_pm_device_stop(sdev) != 0)
 		return;
 
 	bsg_unregister_queue(sdev->request_queue);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a69b155..1bf4150 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -61,6 +61,7 @@ #include <scsi/scsicam.h>
 #include <scsi/sd.h>
 
 #include "scsi_logging.h"
+#include "scsi_priv.h"
 
 MODULE_AUTHOR("Eric Youngdale");
 MODULE_DESCRIPTION("SCSI disk (sd) driver");
@@ -1629,6 +1630,10 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
+	error = scsi_autoresume_device(sdp);
+	if (error)
+		goto out_put;
+
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
@@ -1648,7 +1653,7 @@ static int sd_probe(struct device *dev)
 	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
 
 	if (class_device_add(&sdkp->cdev))
-		goto out_put;
+		goto out_suspend;
 
 	get_device(&sdp->sdev_gendev);
 
@@ -1688,8 +1693,12 @@ static int sd_probe(struct device *dev)
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
 
+	scsi_use_ULD_pm(sdp, 1);
+	scsi_autosuspend_device(sdp);
 	return 0;
 
+ out_suspend:
+	scsi_autosuspend_device(sdp);
  out_put:
 	put_disk(gd);
  out_free:
@@ -1715,6 +1724,7 @@ static int sd_remove(struct device *dev)
 
 	class_device_del(&sdkp->cdev);
 	del_gendisk(sdkp->disk);
+	scsi_use_ULD_pm(sdkp->device, 0);
 	sd_shutdown(dev);
 
 	mutex_lock(&sd_ref_mutex);
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f1871ea..8bc3477 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -56,6 +56,7 @@ #include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
 
+#include "scsi_priv.h"
 #include "scsi_logging.h"
 
 #ifdef CONFIG_SCSI_PROC_FS
@@ -225,6 +226,7 @@ sg_open(struct inode *inode, struct file
 	Sg_fd *sfp;
 	int res;
 	int retval;
+	int autoresume_rc = 1;
 
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
@@ -240,6 +242,10 @@ sg_open(struct inode *inode, struct file
 	if (retval)
 		return retval;
 
+	retval = autoresume_rc = scsi_autoresume_device(sdp->device);
+	if (retval)
+		goto error_out;
+
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
@@ -297,6 +303,8 @@ sg_open(struct inode *inode, struct file
 	return 0;
 
       error_out:
+	if (autoresume_rc == 0)
+		scsi_autosuspend_device(sdp->device);
 	scsi_device_put(sdp->device);
 	return retval;
 }
@@ -312,6 +320,8 @@ sg_release(struct inode *inode, struct f
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 	sg_fasync(-1, filp, 0);	/* remove filp from async notification list */
+	scsi_autosuspend_device(sdp->device);
+
 	if (0 == sg_remove_sfp(sdp, sfp)) {	/* Returns 1 when sdp gone */
 		if (!sdp->detached) {
 			scsi_device_put(sdp->device);
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 7c9593b..740b6de 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -295,10 +295,15 @@ static int device_reset(struct scsi_cmnd
 
 	US_DEBUGP("%s called\n", __FUNCTION__);
 
-	/* lock the device pointers and do the reset */
-	mutex_lock(&(us->dev_mutex));
-	result = us->transport_reset(us);
-	mutex_unlock(&us->dev_mutex);
+	result = usb_autopm_get_interface(us->pusb_intf);
+	if (result == 0) {
+
+		/* lock the device pointers and do the reset */
+		mutex_lock(&(us->dev_mutex));
+		result = us->transport_reset(us);
+		mutex_unlock(&us->dev_mutex);
+		usb_autopm_put_interface(us->pusb_intf);
+	}
 
 	return result < 0 ? FAILED : SUCCESS;
 }
@@ -341,6 +346,24 @@ void usb_stor_report_bus_reset(struct us
 	scsi_unlock(host);
 }
 
+/* The host and its devices are all idle so we can autosuspend */
+static int autosuspend(struct Scsi_Host *host)
+{
+	struct us_data *us = host_to_us(host);
+
+	usb_autopm_put_interface(us->pusb_intf);
+	return 0;
+}
+
+/* The host needs to be autoresumed */
+static int autoresume(struct Scsi_Host *host)
+{
+	struct us_data *us = host_to_us(host);
+
+	return usb_autopm_get_interface(us->pusb_intf);
+}
+
+
 /***********************************************************************
  * /proc/scsi/ functions
  ***********************************************************************/
@@ -467,6 +490,10 @@ struct scsi_host_template usb_stor_host_
 	.eh_device_reset_handler =	device_reset,
 	.eh_bus_reset_handler =		bus_reset,
 
+	/* dynamic power management */
+	.autosuspend =			autosuspend,
+	.autoresume =			autoresume,
+
 	/* queue commands only, only one command per LUN */
 	.can_queue =			1,
 	.cmd_per_lun =			1,
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index ac6114e..a574646 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -184,16 +184,14 @@ static int storage_suspend(struct usb_in
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
+	US_DEBUGP("%s\n", __FUNCTION__);
+
 	/* Wait until no command is running */
 	mutex_lock(&us->dev_mutex);
 
-	US_DEBUGP("%s\n", __FUNCTION__);
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_SUSPEND);
 
-	/* When runtime PM is working, we'll set a flag to indicate
-	 * whether we should autoresume when a SCSI request arrives. */
-
 	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
@@ -202,13 +200,10 @@ static int storage_resume(struct usb_int
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
-	mutex_lock(&us->dev_mutex);
-
 	US_DEBUGP("%s\n", __FUNCTION__);
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_RESUME);
 
-	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
 
@@ -928,6 +923,7 @@ static int usb_stor_scan_thread(void * _
 		/* Should we unbind if no devices were detected? */
 	}
 
+	usb_autopm_put_interface(us->pusb_intf);
 	complete_and_exit(&us->scanning_done, 0);
 }
 
@@ -957,6 +953,9 @@ static int storage_probe(struct usb_inte
 		return -ENOMEM;
 	}
 
+	/* Don't autosuspend until the SCSI core tells us */
+	usb_autopm_get_interface(intf);
+
 	/*
 	 * Allow 16-byte CDBs and thus > 2TB
 	 */
@@ -1017,6 +1016,7 @@ static int storage_probe(struct usb_inte
 		goto BadDevice;
 	}
 
+	usb_autopm_get_interface(intf); /* dropped in the scanning thread */
 	wake_up_process(th);
 
 	return 0;
@@ -1054,6 +1054,7 @@ #endif
 	.pre_reset =	storage_pre_reset,
 	.post_reset =	storage_post_reset,
 	.id_table =	storage_usb_ids,
+	.supports_autosuspend = 1,
 };
 
 static int __init usb_stor_init(void)


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
