From: Matthew Wilcox <matthew@wil.cx>
Subject: [RFC] Asynchronous scanning for FC/SAS version 3
Date: Mon, 13 Nov 2006 08:26:06 -0700
Message-ID: <20061113152605.GZ16952@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:4043 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1754902AbWKMP0K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Nov 2006 10:26:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, james.smart@emulex.com


This is the third version of this patch.  Earlier versions can be found at

http://marc.theaimsgroup.com/?l=linux-scsi&m=116136002113903&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=116311295814181&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=116316322719160&w=2

This patch, relative to scsi-misc, adds infrastructure to support
asynchronous scanning for drivers which call scsi_scan_target, and
changes the aic94xx, lpfc and qla2xxx drivers to use it.

It's a fairly radical restructuring for lpfc and qla2xxx and I may
well have broken some error handling cases during initialisation.
I'd appreciate review from the respective maintainers.

I remain slightly uncomfortable about adding scan_start and scan_finished
to the scsi_host_template.  On the one hand, it's adding two methods
where one would do.  On the other hand, the contents of those two routines
are completely different to each other.

Maybe there's a better way to do this (like exporting
scsi_prep_async_scan() and scsi_finish_async_scan() to the drivers
which was my original idea.  But I like the symmetry, code-sharing and
encapsulation of calling scsi_scan_host().)

Other changes relative to scsi-misc:
 - Add the SCSI_SCAN_ASYNC Kconfig option so people can turn it on by
   default rather than having to pass a kernel command line param.
 - Added missing "none" case to scsi_scan_target()
 - Make scsi_prep_async_scan and scsi_finish_async_scan static.

Todo:
 - Testing.  Lots and lots of testing.
 - See if it can help out the FireWire/USB/iSCSI people
 - Convert zfcp to use it
 - Work out how to get Fusion using this.

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
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 1251788..344cfe0 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -193,6 +193,9 @@ void lpfc_mbuf_free(struct lpfc_hba *, v
 
 /* Function prototypes. */
 const char* lpfc_info(struct Scsi_Host *);
+void lpfc_scan_start(struct Scsi_Host *);
+int lpfc_scan_finished(struct Scsi_Host *, unsigned long);
+
 void lpfc_get_cfgparam(struct lpfc_hba *);
 int lpfc_alloc_sysfs_attr(struct lpfc_hba *);
 void lpfc_free_sysfs_attr(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a5723ad..600c6d3 100644
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
@@ -1441,6 +1414,155 @@ lpfc_scsi_free(struct lpfc_hba * phba)
 	return 0;
 }
 
+void lpfc_remove_device(struct lpfc_hba *phba)
+{
+	unsigned long iflag;
+
+	lpfc_free_sysfs_attr(phba);
+
+	spin_lock_irqsave(phba->host->host_lock, iflag);
+	phba->fc_flag |= FC_UNLOADING;
+
+	spin_unlock_irqrestore(phba->host->host_lock, iflag);
+
+	fc_remove_host(phba->host);
+	scsi_remove_host(phba->host);
+
+	kthread_stop(phba->worker_thread);
+
+	/*
+	 * Bring down the SLI Layer. This step disable all interrupts,
+	 * clears the rings, discards all mailbox commands, and resets
+	 * the HBA.
+	 */
+	lpfc_sli_hba_down(phba);
+	lpfc_sli_brdrestart(phba);
+
+	/* Release the irq reservation */
+	free_irq(phba->pcidev->irq, phba);
+
+	lpfc_cleanup(phba, 0);
+	lpfc_stop_timer(phba);
+	phba->work_hba_events = 0;
+
+	/*
+	 * Call scsi_free before mem_free since scsi bufs are released to their
+	 * corresponding pools here.
+	 */
+	lpfc_scsi_free(phba);
+	lpfc_mem_free(phba);
+
+	/* Free resources associated with SLI2 interface */
+	dma_free_coherent(&phba->pcidev->dev, SLI2_SLIM_SIZE,
+			  phba->slim2p, phba->slim2p_mapping);
+
+	/* unmap adapter SLIM and Control Registers */
+	iounmap(phba->ctrl_regs_memmap_p);
+	iounmap(phba->slim_memmap_p);
+
+	pci_release_regions(phba->pcidev);
+	pci_disable_device(phba->pcidev);
+
+	idr_remove(&lpfc_hba_index, phba->brd_no);
+	scsi_host_put(phba->host);
+}
+
+void lpfc_scan_start(struct Scsi_Host *host)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
+
+	if (lpfc_alloc_sysfs_attr(phba))
+		goto error;
+
+	phba->MBslimaddr = phba->slim_memmap_p;
+	phba->HAregaddr = phba->ctrl_regs_memmap_p + HA_REG_OFFSET;
+	phba->CAregaddr = phba->ctrl_regs_memmap_p + CA_REG_OFFSET;
+	phba->HSregaddr = phba->ctrl_regs_memmap_p + HS_REG_OFFSET;
+	phba->HCregaddr = phba->ctrl_regs_memmap_p + HC_REG_OFFSET;
+
+	if (lpfc_sli_hba_setup(phba))
+		goto error;
+
+	/*
+	 * hba setup may have changed the hba_queue_depth so we need to adjust
+	 * the value of can_queue.
+	 */
+	host->can_queue = phba->cfg_hba_queue_depth - 10;
+	return;
+
+ error:
+	lpfc_remove_device(phba);
+}
+
+int lpfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
+
+	if (!phba->host)
+		return 1;
+	if (time >= 30 * HZ)
+		goto finished;
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
+ finished:
+	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
+		spin_lock_irq(shost->host_lock);
+		lpfc_poll_start_timer(phba);
+		spin_unlock_irq(shost->host_lock);
+	}
+
+	/*
+	 * set fixed host attributes
+	 * Must done after lpfc_sli_hba_setup()
+	 */
+
+	fc_host_node_name(shost) = wwn_to_u64(phba->fc_nodename.u.wwn);
+	fc_host_port_name(shost) = wwn_to_u64(phba->fc_portname.u.wwn);
+	fc_host_supported_classes(shost) = FC_COS_CLASS3;
+
+	memset(fc_host_supported_fc4s(shost), 0,
+		sizeof(fc_host_supported_fc4s(shost)));
+	fc_host_supported_fc4s(shost)[2] = 1;
+	fc_host_supported_fc4s(shost)[7] = 1;
+
+	lpfc_get_hba_sym_node_name(phba, fc_host_symbolic_name(shost));
+
+	fc_host_supported_speeds(shost) = 0;
+	if (phba->lmt & LMT_10Gb)
+		fc_host_supported_speeds(shost) |= FC_PORTSPEED_10GBIT;
+	if (phba->lmt & LMT_4Gb)
+		fc_host_supported_speeds(shost) |= FC_PORTSPEED_4GBIT;
+	if (phba->lmt & LMT_2Gb)
+		fc_host_supported_speeds(shost) |= FC_PORTSPEED_2GBIT;
+	if (phba->lmt & LMT_1Gb)
+		fc_host_supported_speeds(shost) |= FC_PORTSPEED_1GBIT;
+
+	fc_host_maxframe_size(shost) =
+		((((uint32_t) phba->fc_sparam.cmn.bbRcvSizeMsb & 0x0F) << 8) |
+		 (uint32_t) phba->fc_sparam.cmn.bbRcvSizeLsb);
+
+	/* This value is also unchanging */
+	memset(fc_host_active_fc4s(shost), 0,
+		sizeof(fc_host_active_fc4s(shost)));
+	fc_host_active_fc4s(shost)[2] = 1;
+	fc_host_active_fc4s(shost)[7] = 1;
+
+	spin_lock_irq(shost->host_lock);
+	phba->fc_flag &= ~FC_LOADING;
+	spin_unlock_irq(shost->host_lock);
+
+	return 1;
+}
 
 static int __devinit
 lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
@@ -1643,13 +1765,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 
 	host->transportt = lpfc_transport_template;
 	pci_set_drvdata(pdev, host);
-	error = scsi_add_host(host, &pdev->dev);
-	if (error)
-		goto out_kthread_stop;
-
-	error = lpfc_alloc_sysfs_attr(phba);
-	if (error)
-		goto out_remove_host;
 
 	error =	request_irq(phba->pcidev->irq, lpfc_intr_handler, IRQF_SHARED,
 							LPFC_DRIVER_NAME, phba);
@@ -1657,84 +1772,21 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"%d:0451 Enable interrupt handler failed\n",
 			phba->brd_no);
-		goto out_free_sysfs_attr;
+		goto out_kthread_stop;
 	}
-	phba->MBslimaddr = phba->slim_memmap_p;
-	phba->HAregaddr = phba->ctrl_regs_memmap_p + HA_REG_OFFSET;
-	phba->CAregaddr = phba->ctrl_regs_memmap_p + CA_REG_OFFSET;
-	phba->HSregaddr = phba->ctrl_regs_memmap_p + HS_REG_OFFSET;
-	phba->HCregaddr = phba->ctrl_regs_memmap_p + HC_REG_OFFSET;
 
-	error = lpfc_sli_hba_setup(phba);
-	if (error) {
-		error = -ENODEV;
+	error = scsi_add_host(host, &pdev->dev);
+	if (error)
 		goto out_free_irq;
-	}
-
-	/*
-	 * hba setup may have changed the hba_queue_depth so we need to adjust
-	 * the value of can_queue.
-	 */
-	host->can_queue = phba->cfg_hba_queue_depth - 10;
-
-	lpfc_discovery_wait(phba);
-
-	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
-		spin_lock_irq(phba->host->host_lock);
-		lpfc_poll_start_timer(phba);
-		spin_unlock_irq(phba->host->host_lock);
-	}
 
-	/*
-	 * set fixed host attributes
-	 * Must done after lpfc_sli_hba_setup()
-	 */
-
-	fc_host_node_name(host) = wwn_to_u64(phba->fc_nodename.u.wwn);
-	fc_host_port_name(host) = wwn_to_u64(phba->fc_portname.u.wwn);
-	fc_host_supported_classes(host) = FC_COS_CLASS3;
-
-	memset(fc_host_supported_fc4s(host), 0,
-		sizeof(fc_host_supported_fc4s(host)));
-	fc_host_supported_fc4s(host)[2] = 1;
-	fc_host_supported_fc4s(host)[7] = 1;
-
-	lpfc_get_hba_sym_node_name(phba, fc_host_symbolic_name(host));
-
-	fc_host_supported_speeds(host) = 0;
-	if (phba->lmt & LMT_10Gb)
-		fc_host_supported_speeds(host) |= FC_PORTSPEED_10GBIT;
-	if (phba->lmt & LMT_4Gb)
-		fc_host_supported_speeds(host) |= FC_PORTSPEED_4GBIT;
-	if (phba->lmt & LMT_2Gb)
-		fc_host_supported_speeds(host) |= FC_PORTSPEED_2GBIT;
-	if (phba->lmt & LMT_1Gb)
-		fc_host_supported_speeds(host) |= FC_PORTSPEED_1GBIT;
-
-	fc_host_maxframe_size(host) =
-		((((uint32_t) phba->fc_sparam.cmn.bbRcvSizeMsb & 0x0F) << 8) |
-		 (uint32_t) phba->fc_sparam.cmn.bbRcvSizeLsb);
-
-	/* This value is also unchanging */
-	memset(fc_host_active_fc4s(host), 0,
-		sizeof(fc_host_active_fc4s(host)));
-	fc_host_active_fc4s(host)[2] = 1;
-	fc_host_active_fc4s(host)[7] = 1;
+	scsi_scan_host(host);
 
-	spin_lock_irq(phba->host->host_lock);
-	phba->fc_flag &= ~FC_LOADING;
-	spin_unlock_irq(phba->host->host_lock);
 	return 0;
 
 out_free_irq:
 	lpfc_stop_timer(phba);
 	phba->work_hba_events = 0;
 	free_irq(phba->pcidev->irq, phba);
-out_free_sysfs_attr:
-	lpfc_free_sysfs_attr(phba);
-out_remove_host:
-	fc_remove_host(phba->host);
-	scsi_remove_host(phba->host);
 out_kthread_stop:
 	kthread_stop(phba->worker_thread);
 out_free_iocbq:
@@ -1772,55 +1824,8 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 {
 	struct Scsi_Host   *host = pci_get_drvdata(pdev);
 	struct lpfc_hba    *phba = (struct lpfc_hba *)host->hostdata;
-	unsigned long iflag;
-
-	lpfc_free_sysfs_attr(phba);
-
-	spin_lock_irqsave(phba->host->host_lock, iflag);
-	phba->fc_flag |= FC_UNLOADING;
-
-	spin_unlock_irqrestore(phba->host->host_lock, iflag);
-
-	fc_remove_host(phba->host);
-	scsi_remove_host(phba->host);
-
-	kthread_stop(phba->worker_thread);
-
-	/*
-	 * Bring down the SLI Layer. This step disable all interrupts,
-	 * clears the rings, discards all mailbox commands, and resets
-	 * the HBA.
-	 */
-	lpfc_sli_hba_down(phba);
-	lpfc_sli_brdrestart(phba);
 
-	/* Release the irq reservation */
-	free_irq(phba->pcidev->irq, phba);
-
-	lpfc_cleanup(phba, 0);
-	lpfc_stop_timer(phba);
-	phba->work_hba_events = 0;
-
-	/*
-	 * Call scsi_free before mem_free since scsi bufs are released to their
-	 * corresponding pools here.
-	 */
-	lpfc_scsi_free(phba);
-	lpfc_mem_free(phba);
-
-	/* Free resources associated with SLI2 interface */
-	dma_free_coherent(&pdev->dev, SLI2_SLIM_SIZE,
-			  phba->slim2p, phba->slim2p_mapping);
-
-	/* unmap adapter SLIM and Control Registers */
-	iounmap(phba->ctrl_regs_memmap_p);
-	iounmap(phba->slim_memmap_p);
-
-	pci_release_regions(phba->pcidev);
-	pci_disable_device(phba->pcidev);
-
-	idr_remove(&lpfc_hba_index, phba->brd_no);
-	scsi_host_put(phba->host);
+	lpfc_remove_device(phba);
 
 	pci_set_drvdata(pdev, NULL);
 }
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 97ae98d..e83fcf0 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1278,6 +1278,8 @@ struct scsi_host_template lpfc_template 
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
+	.scan_finished		= lpfc_scan_finished,
+	.scan_start		= lpfc_scan_start,
 	.this_id		= -1,
 	.sg_tablesize		= LPFC_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3f20d76..048dd3f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -83,6 +83,8 @@ MODULE_PARM_DESC(ql2xfdmienable,
 static int qla2xxx_slave_configure(struct scsi_device * device);
 static int qla2xxx_slave_alloc(struct scsi_device *);
 static void qla2xxx_slave_destroy(struct scsi_device *);
+static int qla2xxx_scan_finished(struct Scsi_Host *, unsigned long time);
+static void qla2xxx_scan_start(struct Scsi_Host *);
 static int qla2x00_queuecommand(struct scsi_cmnd *cmd,
 		void (*fn)(struct scsi_cmnd *));
 static int qla24xx_queuecommand(struct scsi_cmnd *cmd,
@@ -111,6 +113,8 @@ static struct scsi_host_template qla2x00
 
 	.slave_alloc		= qla2xxx_slave_alloc,
 	.slave_destroy		= qla2xxx_slave_destroy,
+	.scan_finished		= qla2xxx_scan_finished,
+	.scan_start		= qla2xxx_scan_start,
 	.change_queue_depth	= qla2x00_change_queue_depth,
 	.change_queue_type	= qla2x00_change_queue_type,
 	.this_id		= -1,
@@ -1353,6 +1357,117 @@ qla24xx_disable_intrs(scsi_qla_host_t *h
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
+static void qla2xxx_remove_device(scsi_qla_host_t *ha)
+{
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
+	scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
+
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
+		return 1;
+
+	if (time > ha->loop_reset_delay * HZ)
+		goto finished;
+
+	qla2x00_check_fabric_devices(ha);
+
+	if (ha->device_flags & (DFLG_NO_CABLE | DFLG_FABRIC_DEVICES))
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
+}
+
 /*
  * PCI driver interface
  */
@@ -1360,14 +1475,10 @@ static int __devinit
 qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int	ret = -ENODEV;
-	device_reg_t __iomem *reg;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
-	unsigned long	flags = 0;
-	unsigned long	wait_switch = 0;
 	char pci_info[20];
 	char fw_str[30];
-	fc_port_t *fcport;
 	struct scsi_host_template *sht;
 
 	if (pci_enable_device(pdev))
@@ -1511,7 +1622,7 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	host->can_queue = ha->request_q_length + 128;
 
 	/* load the F/W, read paramaters, and init the H/W */
-	ha->instance = num_hosts;
+	ha->instance = num_hosts++;
 
 	init_MUTEX(&ha->mbx_cmd_sem);
 	init_MUTEX_LOCKED(&ha->mbx_intr_sem);
@@ -1536,32 +1647,6 @@ qla2x00_probe_one(struct pci_dev *pdev, 
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
@@ -1579,68 +1664,12 @@ qla2x00_probe_one(struct pci_dev *pdev, 
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
-	ha->flags.init_done = 1;
-	num_hosts++;
 
 	ret = scsi_add_host(host, &pdev->dev);
 	if (ret)
 		goto probe_failed;
-
-	qla2x00_alloc_sysfs_attr(ha);
-
-	qla2x00_init_host_attr(ha);
+	scsi_scan_host(host);
 
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic Fibre Channel HBA Driver: %s\n"
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
index 148e24c..5c7d65d 100644
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
 
@@ -1700,12 +1709,25 @@ void scsi_finish_async_scan(struct async
 	kfree(data);
 }
 
-static int do_scan_async(void *_data)
+static void do_scsi_scan_host(struct Scsi_Host *shost)
 {
-	struct async_scan_data *data = _data;
-	scsi_scan_host_selected(data->shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
+	if (shost->hostt->scan_finished) {
+		unsigned long start = jiffies;
+		if (shost->hostt->scan_start)
+			shost->hostt->scan_start(shost);
+
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
@@ -1723,10 +1745,10 @@ void scsi_scan_host(struct Scsi_Host *sh
 
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
index ba5b3eb..20ebcea 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -241,6 +241,24 @@ #endif
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
