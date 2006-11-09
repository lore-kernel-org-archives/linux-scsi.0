From: Matthew Wilcox <matthew@wil.cx>
Subject: [RFC] Asynchronous scanning for FC/SAS version 2
Date: Thu, 9 Nov 2006 15:54:17 -0700
Message-ID: <20061109225417.GS16952@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:15780 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1424223AbWKIWyS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Nov 2006 17:54:18 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Here's the second iteration of
http://marc.theaimsgroup.com/?l=linux-scsi&m=116136002113903&w=2

Changes since that version:

 - Restructure to put the callback in the scsi_host_template (thanks to
   James Smart for insisting).

Now drivers can fill in scan_finished and call scsi_scan_host().  That
takes care of doing their scans asynchronously.

I should document the new role of scsi_scan_host().

James, relative to the one you've been looking at, this version adds the
'elapsed_jiffies' parameter back in (renamed to 'time').  qla2xxx and
aic94xx needed it too, and it seemed rather intrusive to add an extra
element to their host data structures when I can just keep it on the
stack.

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
index 99743ca..3c46005 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -57,6 +57,7 @@ MODULE_PARM_DESC(collector, "\n"
 char sas_addr_str[2*SAS_ADDR_SIZE + 1] = "";
 
 static struct scsi_transport_template *aic94xx_transport_template;
+static int asd_scan_finished(struct Scsi_Host *, unsigned long);
 
 static struct scsi_host_template aic94xx_sht = {
 	.module			= THIS_MODULE,
@@ -66,6 +67,7 @@ static struct scsi_host_template aic94xx
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
 	.slave_destroy		= sas_slave_destroy,
+	.scan_finished		= asd_scan_finished,
 	.change_queue_depth	= sas_change_queue_depth,
 	.change_queue_type	= sas_change_queue_type,
 	.bios_param		= sas_bios_param,
@@ -546,6 +548,18 @@ static int asd_unregister_sas_ha(struct 
 	return err;
 }
 
+static int asd_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	/* give the phy enabling interrupt event time to come in (1s
+	 * is empirically about all it takes) */
+	if (time < HZ)
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
@@ -677,11 +691,8 @@ static int __devinit asd_pci_probe(struc
 		goto Err_en_phys;
 	}
 	ASD_DPRINTK("enabled phys\n");
-	/* give the phy enabling interrupt event time to come in (1s
-	 * is empirically about all it takes) */
-	ssleep(1);
-	/* Wait for discovery to finish */
-	scsi_flush_work(asd_ha->sas_ha.core.shost);
+
+	scsi_scan_host(shost);
 
 	return 0;
 Err_en_phys:
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a5723ad..3ad31df 100644
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
@@ -1441,7 +1414,6 @@ lpfc_scsi_free(struct lpfc_hba * phba)
 	return 0;
 }
 
-
 static int __devinit
 lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 {
@@ -1647,6 +1619,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	if (error)
 		goto out_kthread_stop;
 
+	scsi_scan_host(host);
 	error = lpfc_alloc_sysfs_attr(phba);
 	if (error)
 		goto out_remove_host;
@@ -1677,8 +1650,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	 */
 	host->can_queue = phba->cfg_hba_queue_depth - 10;
 
-	lpfc_discovery_wait(phba);
-
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
 		spin_lock_irq(phba->host->host_lock);
 		lpfc_poll_start_timer(phba);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 97ae98d..60623f1 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1267,6 +1267,29 @@ lpfc_slave_destroy(struct scsi_device *s
 	return;
 }
 
+static int lpfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
+
+	if (!phba->host)
+		return 1;
+	if (time >= 30 * HZ)
+		return 1;
+
+	if (phba->hba_state != LPFC_HBA_READY)
+		return 0;
+	if (phba->num_disc_nodes || phba->fc_prli_sent)
+		return 0;
+	if ((phba->fc_map_cnt == 0) && (time < 2 * HZ))
+		return 0;
+	if (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE)
+		return 0;
+	if ((phba->hba_state > LPFC_LINK_DOWN) || (time < 15 * HZ))
+		return 0;
+
+	return 1;
+}
+
 struct scsi_host_template lpfc_template = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
@@ -1278,6 +1301,7 @@ struct scsi_host_template lpfc_template 
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
+	.scan_finished		= lpfc_scan_finished,
 	.this_id		= -1,
 	.sg_tablesize		= LPFC_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3f20d76..91b8bf3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -83,6 +83,7 @@ MODULE_PARM_DESC(ql2xfdmienable,
 static int qla2xxx_slave_configure(struct scsi_device * device);
 static int qla2xxx_slave_alloc(struct scsi_device *);
 static void qla2xxx_slave_destroy(struct scsi_device *);
+static int qla2xxx_scan_finished(struct Scsi_Host *);
 static int qla2x00_queuecommand(struct scsi_cmnd *cmd,
 		void (*fn)(struct scsi_cmnd *));
 static int qla24xx_queuecommand(struct scsi_cmnd *cmd,
@@ -111,6 +112,7 @@ static struct scsi_host_template qla2x00
 
 	.slave_alloc		= qla2xxx_slave_alloc,
 	.slave_destroy		= qla2xxx_slave_destroy,
+	.scan_finished		= qla2x00_scan_finished,
 	.change_queue_depth	= qla2x00_change_queue_depth,
 	.change_queue_type	= qla2x00_change_queue_type,
 	.this_id		= -1,
@@ -1353,6 +1355,20 @@ qla24xx_disable_intrs(scsi_qla_host_t *h
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
+static int qla2x00_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
+
+	if (time > ha->loop_reset_delay * HZ)
+		return 1;
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
@@ -1363,8 +1379,7 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	device_reg_t __iomem *reg;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
-	unsigned long	flags = 0;
-	unsigned long	wait_switch = 0;
+	unsigned long flags;
 	char pci_info[20];
 	char fw_str[30];
 	fc_port_t *fcport;
@@ -1614,22 +1629,6 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 
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
@@ -1637,6 +1636,7 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	ret = scsi_add_host(host, &pdev->dev);
 	if (ret)
 		goto probe_failed;
+	scsi_scan_host(host);
 
 	qla2x00_alloc_sysfs_attr(ha);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 148e24c..bbeddf9 100644
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
 
@@ -1623,7 +1632,7 @@ static void scsi_sysfs_add_devices(struc
  * that other asynchronous scans started after this one won't affect the
  * ordering of the discovered devices.
  */
-struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
+static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 {
 	struct async_scan_data *data;
 
@@ -1667,7 +1676,7 @@ struct async_scan_data *scsi_prep_async_
  * This function announces all the devices it has found to the rest
  * of the system.
  */
-void scsi_finish_async_scan(struct async_scan_data *data)
+static void scsi_finish_async_scan(struct async_scan_data *data)
 {
 	struct Scsi_Host *shost;
 
@@ -1700,12 +1709,22 @@ void scsi_finish_async_scan(struct async
 	kfree(data);
 }
 
-static int do_scan_async(void *_data)
+static void do_scsi_scan_host(struct Scsi_Host *shost)
 {
-	struct async_scan_data *data = _data;
-	scsi_scan_host_selected(data->shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
+	if (shost->hostt->scan_finished) {
+		unsigned long start = jiffies;
+		while (!shost->hostt->scan_finished(shost, jiffies - start))
+			msleep(10);
+	} else {
+		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
 				SCAN_WILD_CARD, 0);
+	}
+}
 
+static int do_scan_async(void *_data)
+{
+	struct async_scan_data *data = _data;
+	do_scsi_scan_host(data->shost);
 	scsi_finish_async_scan(data);
 	return 0;
 }
@@ -1723,10 +1742,10 @@ void scsi_scan_host(struct Scsi_Host *sh
 
 	data = scsi_prep_async_scan(shost);
 	if (!data) {
-		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
-					SCAN_WILD_CARD, 0);
+		do_scsi_scan_host(shost);
 		return;
 	}
+
 	kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
 }
 EXPORT_SYMBOL(scsi_scan_host);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ba5b3eb..359672a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -241,6 +241,17 @@ #endif
 	void (* target_destroy)(struct scsi_target *);
 
 	/*
+	 * If a host has the ability to discover targets on its own instead
+	 * of scanning the entire bus, it can fill in this function and
+	 * call scsi_scan_host().  This function will be called periodically
+	 * until it returns 1 with the scsi_host and the elapsed time of
+	 * the scan in jiffies.
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (* scan_finished)(struct Scsi_Host *, unsigned long);
+
+	/*
 	 * fill in this function to allow the queue depth of this host
 	 * to be changeable (on a per device basis).  returns either
 	 * the current queue depth setting (may be different from what
