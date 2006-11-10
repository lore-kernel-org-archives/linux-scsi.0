From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Asynchronous scanning for FC/SAS version 2
Date: Fri, 10 Nov 2006 05:53:28 -0700
Message-ID: <20061110125327.GW16952@parisc-linux.org>
References: <20061109225417.GS16952@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:26540 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1946557AbWKJMx3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 07:53:29 -0500
Content-Disposition: inline
In-Reply-To: <20061109225417.GS16952@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, Nov 09, 2006 at 03:54:17PM -0700, Matthew Wilcox wrote:
> Here's the second iteration of
> http://marc.theaimsgroup.com/?l=linux-scsi&m=116136002113903&w=2

Many thanks to Justin Chen for testing a couple of intermediate versions;
this incremental patch rearranges the QLogic driver initialisation to
perform the LIP reset in the scanning thread.  This gets the time to
initialise qlogic devices down to under a tenth of a second per device.

I introduce another scsi_host_template method to achieve this.  I suppose
I could have done it by calling scan_finished(host, 0) and checking
the time argument in the qlogic implementation ... but that seemed a
bit unclean.

Still todo:
 - Get Emulex LPFC using scan_start
 - Work out how to use this interface for USB/Firewire/iSCSI
 - Get LSI Fusion using this infrastructure

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 91b8bf3..048dd3f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -83,7 +83,8 @@ MODULE_PARM_DESC(ql2xfdmienable,
 static int qla2xxx_slave_configure(struct scsi_device * device);
 static int qla2xxx_slave_alloc(struct scsi_device *);
 static void qla2xxx_slave_destroy(struct scsi_device *);
-static int qla2xxx_scan_finished(struct Scsi_Host *);
+static int qla2xxx_scan_finished(struct Scsi_Host *, unsigned long time);
+static void qla2xxx_scan_start(struct Scsi_Host *);
 static int qla2x00_queuecommand(struct scsi_cmnd *cmd,
 		void (*fn)(struct scsi_cmnd *));
 static int qla24xx_queuecommand(struct scsi_cmnd *cmd,
@@ -112,7 +113,8 @@ static struct scsi_host_template qla2x00
 
 	.slave_alloc		= qla2xxx_slave_alloc,
 	.slave_destroy		= qla2xxx_slave_destroy,
-	.scan_finished		= qla2x00_scan_finished,
+	.scan_finished		= qla2xxx_scan_finished,
+	.scan_start		= qla2xxx_scan_start,
 	.change_queue_depth	= qla2x00_change_queue_depth,
 	.change_queue_type	= qla2x00_change_queue_type,
 	.this_id		= -1,
@@ -1355,18 +1357,115 @@ qla24xx_disable_intrs(scsi_qla_host_t *h
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
-static int qla2x00_scan_finished(struct Scsi_Host *shost, unsigned long time)
+static void qla2xxx_remove_device(scsi_qla_host_t *ha)
 {
+	qla2x00_free_sysfs_attr(ha);
+	fc_remove_host(ha->host);
+	scsi_remove_host(ha->host);
+	qla2x00_free_device(ha);
+	scsi_host_put(ha->host);
+}
+
+static void qla2xxx_scan_start(struct Scsi_Host *shost)
+{
+	unsigned long flags;
+	device_reg_t __iomem *reg;
 	scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
 
-	if (time > ha->loop_reset_delay * HZ)
+	if (qla2x00_initialize_adapter(ha) &&
+	    !(ha->device_flags & DFLG_NO_CABLE)) {
+
+		qla_printk(KERN_WARNING, ha,
+		    "Failed to initialize adapter\n");
+
+		DEBUG2(printk("scsi(%ld): Failed to initialize adapter - "
+		    "Adapter flags %x.\n",
+		    ha->host_no, ha->device_flags));
+		goto error;
+	}
+
+	/*
+	 * Startup the kernel thread for this host adapter
+	 */
+	ha->dpc_thread = kthread_create(qla2x00_do_dpc, ha,
+			"%s_dpc", ha->host_str);
+	if (IS_ERR(ha->dpc_thread)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to start DPC thread!\n");
+		goto error;
+	}
+
+	qla2x00_start_timer(ha, qla2x00_timer, WATCH_INTERVAL);
+
+	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
+	    ha->host_no, ha));
+
+	ha->isp_ops.disable_intrs(ha);
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	reg = ha->iobase;
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
+		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_RISC_INT);
+	} else {
+		WRT_REG_WORD(&reg->isp.semaphore, 0);
+		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_RISC_INT);
+		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
+
+		/* Enable proper parity */
+		if (!IS_QLA2100(ha) && !IS_QLA2200(ha)) {
+			if (IS_QLA2300(ha))
+				/* SRAM parity */
+				WRT_REG_WORD(&reg->isp.hccr,
+				    (HCCR_ENABLE_PARITY + 0x1));
+			else
+				/* SRAM, Instruction RAM and GP RAM parity */
+				WRT_REG_WORD(&reg->isp.hccr,
+				    (HCCR_ENABLE_PARITY + 0x7));
+		}
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	ha->isp_ops.enable_intrs(ha);
+	ha->flags.init_done = 1;
+
+	return;
+
+ error:
+	qla2xxx_remove_device(ha);
+	ha->host = NULL;
+}
+
+static int qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	fc_port_t *fcport;
+	scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
+
+	if (!ha->host)
 		return 1;
 
+	if (time > ha->loop_reset_delay * HZ)
+		goto finished;
+
 	qla2x00_check_fabric_devices(ha);
 
 	if (ha->device_flags & (DFLG_NO_CABLE | DFLG_FABRIC_DEVICES))
-		return 1;
-	return !(ha->device_flags & SWITCH_FOUND);
+		goto finished;
+	if (!(ha->device_flags & SWITCH_FOUND))
+		goto finished;
+
+	return 0;
+
+ finished:
+	qla2x00_alloc_sysfs_attr(ha);
+
+	qla2x00_init_host_attr(ha);
+
+	/* Go with fc_rport registration. */
+	list_for_each_entry(fcport, &ha->fcports, list)
+		qla2x00_reg_remote_port(ha, fcport);
+
+	return 1;
 }
 
 /*
@@ -1376,13 +1475,10 @@ static int __devinit
 qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int	ret = -ENODEV;
-	device_reg_t __iomem *reg;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
-	unsigned long flags;
 	char pci_info[20];
 	char fw_str[30];
-	fc_port_t *fcport;
 	struct scsi_host_template *sht;
 
 	if (pci_enable_device(pdev))
@@ -1526,7 +1622,7 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	host->can_queue = ha->request_q_length + 128;
 
 	/* load the F/W, read paramaters, and init the H/W */
-	ha->instance = num_hosts;
+	ha->instance = num_hosts++;
 
 	init_MUTEX(&ha->mbx_cmd_sem);
 	init_MUTEX_LOCKED(&ha->mbx_intr_sem);
@@ -1551,32 +1647,6 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 		goto probe_failed;
 	}
 
-	if (qla2x00_initialize_adapter(ha) &&
-	    !(ha->device_flags & DFLG_NO_CABLE)) {
-
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to initialize adapter\n");
-
-		DEBUG2(printk("scsi(%ld): Failed to initialize adapter - "
-		    "Adapter flags %x.\n",
-		    ha->host_no, ha->device_flags));
-
-		ret = -ENODEV;
-		goto probe_failed;
-	}
-
-	/*
-	 * Startup the kernel thread for this host adapter
-	 */
-	ha->dpc_thread = kthread_create(qla2x00_do_dpc, ha,
-			"%s_dpc", ha->host_str);
-	if (IS_ERR(ha->dpc_thread)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to start DPC thread!\n");
-		ret = PTR_ERR(ha->dpc_thread);
-		goto probe_failed;
-	}
-
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
 	host->unique_id = ha->instance;
@@ -1594,54 +1664,13 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 		goto probe_failed;
 	}
 	host->irq = pdev->irq;
-
-	/* Initialized the timer */
-	qla2x00_start_timer(ha, qla2x00_timer, WATCH_INTERVAL);
-
-	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
-	    ha->host_no, ha));
-
-	ha->isp_ops.disable_intrs(ha);
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	reg = ha->iobase;
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
-		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
-		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_RISC_INT);
-	} else {
-		WRT_REG_WORD(&reg->isp.semaphore, 0);
-		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_RISC_INT);
-		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
-
-		/* Enable proper parity */
-		if (!IS_QLA2100(ha) && !IS_QLA2200(ha)) {
-			if (IS_QLA2300(ha))
-				/* SRAM parity */
-				WRT_REG_WORD(&reg->isp.hccr,
-				    (HCCR_ENABLE_PARITY + 0x1));
-			else
-				/* SRAM, Instruction RAM and GP RAM parity */
-				WRT_REG_WORD(&reg->isp.hccr,
-				    (HCCR_ENABLE_PARITY + 0x7));
-		}
-	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	ha->isp_ops.enable_intrs(ha);
-
 	pci_set_drvdata(pdev, ha);
-	ha->flags.init_done = 1;
-	num_hosts++;
 
 	ret = scsi_add_host(host, &pdev->dev);
 	if (ret)
 		goto probe_failed;
 	scsi_scan_host(host);
 
-	qla2x00_alloc_sysfs_attr(ha);
-
-	qla2x00_init_host_attr(ha);
-
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic Fibre Channel HBA Driver: %s\n"
 	    "  QLogic %s - %s\n"
@@ -1652,10 +1681,6 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	    ha->flags.enable_64bit_addressing ? '+': '-', ha->host_no,
 	    ha->isp_ops.fw_version_str(ha, fw_str));
 
-	/* Go with fc_rport registration. */
-	list_for_each_entry(fcport, &ha->fcports, list)
-		qla2x00_reg_remote_port(ha, fcport);
-
 	return 0;
 
 probe_failed:
@@ -1676,17 +1701,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	scsi_qla_host_t *ha;
 
 	ha = pci_get_drvdata(pdev);
-
-	qla2x00_free_sysfs_attr(ha);
-
-	fc_remove_host(ha->host);
-
-	scsi_remove_host(ha->host);
-
-	qla2x00_free_device(ha);
-
-	scsi_host_put(ha->host);
-
+	qla2xxx_remove_device(ha);
 	pci_set_drvdata(pdev, NULL);
 }
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index bbeddf9..5c7d65d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1713,6 +1713,9 @@ static void do_scsi_scan_host(struct Scs
 {
 	if (shost->hostt->scan_finished) {
 		unsigned long start = jiffies;
+		if (shost->hostt->scan_start)
+			shost->hostt->scan_start(shost);
+
 		while (!shost->hostt->scan_finished(shost, jiffies - start))
 			msleep(10);
 	} else {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 359672a..20ebcea 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -252,6 +252,13 @@ #endif
 	int (* scan_finished)(struct Scsi_Host *, unsigned long);
 
 	/*
+	 * If the host wants to be called before the scan starts, but
+	 * after the midlayer has set up ready for the scan, it can fill
+	 * in this function.
+	 */
+	void (* scan_start)(struct Scsi_Host *);
+
+	/*
 	 * fill in this function to allow the queue depth of this host
 	 * to be changeable (on a per device basis).  returns either
 	 * the current queue depth setting (may be different from what
