From: Matthew Wilcox <matthew@wil.cx>
Subject: [RFC] Asynchronous scanning for FC/SAS
Date: Fri, 20 Oct 2006 09:56:53 -0600
Message-ID: <20061020155653.GY2602@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:63667 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S2992613AbWJTP4y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 11:56:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch, relative to scsi-misc, adds infrastructure to support
asynchronous scanning for drivers which call scsi_scan_target, and
changes the aic94xx, lpfc and qla2xxx drivers to use it.

Also add the SCSI_SCAN_ASYNC Kconfig option so people can turn it on by
default rather than having to pass a kernel command line param.

Other changes relative to scsi-misc:
 - Added missing "none" case to scsi_scan_target()
 - Refactor scsi_prep_async_scan/scsi_finish_async_scan so the async_scan_data
   is now passed into them rather than being allocated and freed by them.
 - Make the above two functions static.

Relative to earlier versions of this patch:
 - Add documentation for scsi_target_discovery()
 - Handle errors from scsi_prep_async_scan() properly (including sync mode)
 - Embed the async_scan_data in the target_discovery_data since they're both
   tiny structs.

Todo:
 - I'd like a better name than scsi_target_discovery().
 - Find out why it still doesn't actually help qla2xxx.
 - Testing.  Lots and lots of testing.
 - See if it can help out the FireWire/USB/iSCSI people
 - Convert zfcp to use it
 - Work out how to get Fusion using this.

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index 75a535a..f7e019e 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -388,6 +388,7 @@ Summary:
    scsi_remove_host - detach and remove all SCSI devices owned by host
    scsi_report_bus_reset - report scsi _bus_ reset observed
    scsi_scan_host - scan SCSI bus
+   scsi_target_discovery - register host as doing target discovery
    scsi_track_queue_full - track successive QUEUE_FULL events 
    scsi_unblock_requests - allow further commands to be queued to given host
    scsi_unregister - [calls scsi_host_put()]
@@ -718,6 +719,19 @@ void scsi_scan_host(struct Scsi_Host *sh
 
 
 /**
+ * scsi_target_discovery - register host as performing target discovery
+ * @shost: the host which is discovering targets
+ * @timeout: how long to wait (in jiffies)
+ * @finished: callback to determine if all targets have been discovered
+ * 
+ * Might block: yes
+ * Defined in: drivers/scsi/scsi_scan.c
+ */
+void scsi_target_discovery(struct Scsi_Host *shost, unsigned long timeout,
+                           int (*finished)(struct Scsi_Host *, unsigned long))
+
+
+/**
  * scsi_track_queue_full - track successive QUEUE_FULL events on given
  *                      device to determine if and when there is a need
  *                      to adjust the queue depth on the device.
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9540eb8..c312444 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -216,6 +216,23 @@ config SCSI_LOGGING
 	  there should be no noticeable performance impact as long as you have
 	  logging turned off.
 
+config SCSI_SCAN_ASYNC
+	bool "Asynchronous SCSI scanning"
+	depends on SCSI
+	help
+	  The SCSI subsystem can probe for devices while the rest of the
+	  system continues booting, and even probe devices on different
+	  busses in parallel, leading to a significant speed-up.
+	  If you have built SCSI as modules, enabling this option can
+	  be a problem as the devices may not have been found by the
+	  time your system expects them to have been.  You can load the
+	  scsi_wait_scan module to ensure that all scans have completed.
+	  If you build your SCSI drivers into the kernel, then everything
+	  will work fine if you say Y here.
+
+	  You can override this choice by specifying scsi_mod.scan="sync"
+	  or "async" on the kernel's command line.
+
 menu "SCSI Transports"
 	depends on SCSI
 
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 99743ca..8000d88 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -546,6 +546,19 @@ static int asd_unregister_sas_ha(struct 
 	return err;
 }
 
+static int asd_finished_discovery(struct Scsi_Host *shost,
+						unsigned long elapsed_jiffies)
+{
+	/* give the phy enabling interrupt event time to come in (1s
+	 * is empirically about all it takes) */
+	if (elapsed_jiffies < HZ)
+		return 0;
+
+	/* Wait for discovery to finish */
+	scsi_flush_work(shost);
+	return 1;
+}
+
 static int __devinit asd_pci_probe(struct pci_dev *dev,
 				   const struct pci_device_id *id)
 {
@@ -677,11 +690,7 @@ static int __devinit asd_pci_probe(struc
 		goto Err_en_phys;
 	}
 	ASD_DPRINTK("enabled phys\n");
-	/* give the phy enabling interrupt event time to come in (1s
-	 * is empirically about all it takes) */
-	ssleep(1);
-	/* Wait for discovery to finish */
-	scsi_flush_work(asd_ha->sas_ha.core.shost);
+	scsi_target_discovery(shost, 30 * HZ, asd_finished_discovery);
 
 	return 0;
 Err_en_phys:
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a5723ad..c2b0766 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -416,33 +416,6 @@ lpfc_config_port_post(struct lpfc_hba * 
 	return (0);
 }
 
-static int
-lpfc_discovery_wait(struct lpfc_hba *phba)
-{
-	int i = 0;
-
-	while ((phba->hba_state != LPFC_HBA_READY) ||
-	       (phba->num_disc_nodes) || (phba->fc_prli_sent) ||
-	       ((phba->fc_map_cnt == 0) && (i<2)) ||
-	       (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE)) {
-		/* Check every second for 30 retries. */
-		i++;
-		if (i > 30) {
-			return -ETIMEDOUT;
-		}
-		if ((i >= 15) && (phba->hba_state <= LPFC_LINK_DOWN)) {
-			/* The link is down.  Set linkdown timeout */
-			return -ETIMEDOUT;
-		}
-
-		/* Delay for 1 second to give discovery time to complete. */
-		msleep(1000);
-
-	}
-
-	return 0;
-}
-
 /************************************************************************/
 /*                                                                      */
 /*    lpfc_hba_down_prep                                                */
@@ -1441,6 +1414,23 @@ lpfc_scsi_free(struct lpfc_hba * phba)
 	return 0;
 }
 
+static int lpfc_finished_discovery(struct Scsi_Host *shost,
+						unsigned long elapsed_jiffies)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
+
+	if (phba->hba_state != LPFC_HBA_READY)
+		return 0;
+	if (phba->num_disc_nodes || phba->fc_prli_sent)
+		return 0;
+	if ((phba->fc_map_cnt == 0) && (elapsed_jiffies < 2 * HZ))
+		return 0;
+	if (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE)
+		return 0;
+	if ((phba->hba_state > LPFC_LINK_DOWN) || (elapsed_jiffies < 15 * HZ))
+		return 0;
+	return 1;
+}
 
 static int __devinit
 lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
@@ -1647,6 +1637,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	if (error)
 		goto out_kthread_stop;
 
+	scsi_target_discovery(host, 30 * HZ, lpfc_finished_discovery);
 	error = lpfc_alloc_sysfs_attr(phba);
 	if (error)
 		goto out_remove_host;
@@ -1677,8 +1668,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	 */
 	host->can_queue = phba->cfg_hba_queue_depth - 10;
 
-	lpfc_discovery_wait(phba);
-
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
 		spin_lock_irq(phba->host->host_lock);
 		lpfc_poll_start_timer(phba);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3f20d76..74726c2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1353,6 +1353,17 @@ qla24xx_disable_intrs(scsi_qla_host_t *h
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
+static int qla2x00_scan_finished(struct Scsi_Host *shost, unsigned long x)
+{
+	scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
+
+	qla2x00_check_fabric_devices(ha);
+
+	if (ha->device_flags & (DFLG_NO_CABLE | DFLG_FABRIC_DEVICES))
+		return 1;
+	return !(ha->device_flags & SWITCH_FOUND);
+}
+
 /*
  * PCI driver interface
  */
@@ -1363,8 +1374,7 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	device_reg_t __iomem *reg;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
-	unsigned long	flags = 0;
-	unsigned long	wait_switch = 0;
+	unsigned long flags;
 	char pci_info[20];
 	char fw_str[30];
 	fc_port_t *fcport;
@@ -1614,22 +1624,6 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 
 	ha->isp_ops.enable_intrs(ha);
 
-	/* v2.19.5b6 */
-	/*
-	 * Wait around max loop_reset_delay secs for the devices to come
-	 * on-line. We don't want Linux scanning before we are ready.
-	 *
-	 */
-	for (wait_switch = jiffies + (ha->loop_reset_delay * HZ);
-	    time_before(jiffies,wait_switch) &&
-	     !(ha->device_flags & (DFLG_NO_CABLE | DFLG_FABRIC_DEVICES))
-	     && (ha->device_flags & SWITCH_FOUND) ;) {
-
-		qla2x00_check_fabric_devices(ha);
-
-		msleep(10);
-	}
-
 	pci_set_drvdata(pdev, ha);
 	ha->flags.init_done = 1;
 	num_hosts++;
@@ -1638,6 +1632,8 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	if (ret)
 		goto probe_failed;
 
+	scsi_target_discovery(host, ha->loop_reset_delay * HZ,
+				qla2x00_scan_finished);
 	qla2x00_alloc_sysfs_attr(ha);
 
 	qla2x00_init_host_attr(ha);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 148e24c..2548fec 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -89,7 +89,13 @@ module_param_named(max_luns, max_scsi_lu
 MODULE_PARM_DESC(max_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
 
-static char scsi_scan_type[6] = "sync";
+#ifdef CONFIG_SCSI_SCAN_ASYNC
+#define SCSI_SCAN_TYPE_DEFAULT "async"
+#else
+#define SCSI_SCAN_TYPE_DEFAULT "sync"
+#endif
+
+static char scsi_scan_type[6] = SCSI_SCAN_TYPE_DEFAULT;
 
 module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
 MODULE_PARM_DESC(scan, "sync, async or none");
@@ -1533,6 +1539,9 @@ void scsi_scan_target(struct device *par
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 
+	if (strncmp(scsi_scan_type, "none", 4) == 0)
+		return;
+
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
@@ -1616,33 +1625,30 @@ static void scsi_sysfs_add_devices(struc
 /**
  * scsi_prep_async_scan - prepare for an async scan
  * @shost: the host which will be scanned
- * Returns: a cookie to be passed to scsi_finish_async_scan()
+ * @data: filled in by this function
+ * Returns: an errno, or 0 on success
  *
  * Tells the midlayer this host is going to do an asynchronous scan.
  * It reserves the host's position in the scanning list and ensures
  * that other asynchronous scans started after this one won't affect the
  * ordering of the discovered devices.
  */
-struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
+static int scsi_prep_async_scan(struct Scsi_Host *shost,
+						struct async_scan_data *data)
 {
-	struct async_scan_data *data;
-
 	if (strncmp(scsi_scan_type, "sync", 4) == 0)
-		return NULL;
+		return -EINVAL;
 
 	if (shost->async_scan) {
 		printk("%s called twice for host %d", __FUNCTION__,
 				shost->host_no);
 		dump_stack();
-		return NULL;
+		return -EBUSY;
 	}
 
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		goto err;
 	data->shost = scsi_host_get(shost);
 	if (!data->shost)
-		goto err;
+		return -ENODEV;
 	init_completion(&data->prev_finished);
 
 	spin_lock(&async_scan_lock);
@@ -1652,22 +1658,18 @@ struct async_scan_data *scsi_prep_async_
 	list_add_tail(&data->list, &scanning_hosts);
 	spin_unlock(&async_scan_lock);
 
-	return data;
-
- err:
-	kfree(data);
-	return NULL;
+	return 0;
 }
 
 /**
  * scsi_finish_async_scan - asynchronous scan has finished
- * @data: cookie returned from earlier call to scsi_prep_async_scan()
+ * @data: asynchronous scan data
  *
  * All the devices currently attached to this host have been found.
  * This function announces all the devices it has found to the rest
  * of the system.
  */
-void scsi_finish_async_scan(struct async_scan_data *data)
+static void scsi_finish_async_scan(struct async_scan_data *data)
 {
 	struct Scsi_Host *shost;
 
@@ -1697,7 +1699,6 @@ void scsi_finish_async_scan(struct async
 	spin_unlock(&async_scan_lock);
 
 	scsi_host_put(shost);
-	kfree(data);
 }
 
 static int do_scan_async(void *_data)
@@ -1707,6 +1708,7 @@ static int do_scan_async(void *_data)
 				SCAN_WILD_CARD, 0);
 
 	scsi_finish_async_scan(data);
+	kfree(data);
 	return 0;
 }
 
@@ -1721,16 +1723,100 @@ void scsi_scan_host(struct Scsi_Host *sh
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return;
 
-	data = scsi_prep_async_scan(shost);
+	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	if (data) {
+		int err = scsi_prep_async_scan(shost, data);
+		if (err) {
+			kfree(data);
+			data = NULL;
+		}
+	}
+
 	if (!data) {
 		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
 					SCAN_WILD_CARD, 0);
 		return;
 	}
+
 	kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
 }
 EXPORT_SYMBOL(scsi_scan_host);
 
+/* If only kthread_run allowed the threadfn to be variadic ... */
+struct target_discovery_data {
+	struct async_scan_data async_data;
+	int (*finished)(struct Scsi_Host *, unsigned long);
+	unsigned long timeout;
+};
+
+static void wait_for_target_scan(struct Scsi_Host *shost, unsigned long timeout,
+			   int (*finished)(struct Scsi_Host *, unsigned long))
+{
+	unsigned long start = jiffies;
+	while (time_before(jiffies, start + timeout)) {
+		if (finished(shost, jiffies - start))
+			break;
+		msleep(10);
+	}
+}
+
+static int do_target_discovery(void *_data)
+{
+	struct target_discovery_data *data = _data;
+	wait_for_target_scan(data->async_data.shost, data->timeout,
+							data->finished);
+	scsi_finish_async_scan(&data->async_data);
+	kfree(data);
+	return 0;
+}
+
+/**
+ * scsi_target_discovery - register host as performing target discovery
+ * @shost: the host which is discovering targets
+ * @timeout: how long to wait (in jiffies)
+ * @finished: callback to determine if all targets have been discovered
+ *
+ * Drivers should call this for each host that is going to perform its
+ * own target discovery (ie not if they call scsi_scan_host()).  If the
+ * user has requested synchronous target discovery, or there is a problem
+ * with allocating the target struct, it will wait until all targets have
+ * been discovered, or we hit the timeout.  Otherwise, it will spawn a
+ * thread and return immediately.  Drivers should take care to call this
+ * function before any devices can be discovered, otherwise the first
+ * call to scsi_scan_target() may block, making asynchronous discovery
+ * useless.
+ *
+ * If this function spawns a thread, it will have taken a reference on the
+ * @shost so it cannot disappear from under us.  The finished callback will
+ * be called periodically, and passed the number of jiffies that have
+ * elapsed since we started probing.  It should return 0 to continue waiting
+ * and non-0 to finish.
+ */
+void scsi_target_discovery(struct Scsi_Host *shost, unsigned long timeout,
+			   int (*finished)(struct Scsi_Host *, unsigned long))
+{
+	struct target_discovery_data *data;
+	
+	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	if (data) {
+		int err = scsi_prep_async_scan(shost, &data->async_data);
+		if (err) {
+			kfree(data);
+			data = NULL;
+		}
+	}
+
+	if (!data) {
+		wait_for_target_scan(shost, timeout, finished);
+		return;
+	}
+
+	data->finished = finished;
+	data->timeout = timeout;
+	kthread_run(do_target_discovery, data, "scsi_scan_%d", shost->host_no);
+}
+EXPORT_SYMBOL_GPL(scsi_target_discovery);
+
 void scsi_forget_host(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ba5b3eb..88be61e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -649,6 +649,9 @@ extern void scsi_host_put(struct Scsi_Ho
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 extern const char *scsi_host_state_name(enum scsi_host_state);
 
+void scsi_target_discovery(struct Scsi_Host *shost, unsigned long timeout,
+			   int (*finished)(struct Scsi_Host *, unsigned long));
+
 extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
 
 static inline void scsi_assign_lock(struct Scsi_Host *shost, spinlock_t *lock)
