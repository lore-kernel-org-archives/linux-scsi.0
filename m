From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 13/16] lpfc 8.1.12 : Add support for async scanning
Date: Wed, 25 Apr 2007 09:53:22 -0400
Message-ID: <1177509202.23155.20.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51763 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031043AbXDYNxN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:53:13 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDrClm006700
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:53:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add support for async scanning

Notes: This is the async scan patch to our driver from Matthew Wilcox.
  The async scan logic is still subject to errors in insmod/rmmod, as
  the async scan threads don't get shutdown when the module unloads
  underneath them. See http://marc.info/?l=linux-scsi&m=117551999925582&w=2
  
Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:43.000000000 -0400
@@ -200,6 +200,9 @@ void lpfc_mbuf_free(struct lpfc_hba *, v
 
 /* Function prototypes. */
 const char* lpfc_info(struct Scsi_Host *);
+void lpfc_scan_start(struct Scsi_Host *);
+int lpfc_scan_finished(struct Scsi_Host *, unsigned long);
+
 void lpfc_get_cfgparam(struct lpfc_hba *);
 int lpfc_alloc_sysfs_attr(struct lpfc_hba *);
 void lpfc_free_sysfs_attr(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:43.000000000 -0400
@@ -418,33 +418,6 @@ lpfc_config_port_post(struct lpfc_hba * 
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
@@ -1362,6 +1335,156 @@ lpfc_scsi_free(struct lpfc_hba * phba)
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
+	pci_disable_msi(phba->pcidev);
+
+	lpfc_cleanup(phba);
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
+error:
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
+finished:
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
@@ -1552,13 +1675,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 
 	host->transportt = lpfc_transport_template;
 	pci_set_drvdata(pdev, host);
-	error = scsi_add_host(host, &pdev->dev);
-	if (error)
-		goto out_kthread_stop;
-
-	error = lpfc_alloc_sysfs_attr(phba);
-	if (error)
-		goto out_remove_host;
 
 	if (phba->cfg_use_msi) {
 		error = pci_enable_msi(phba->pcidev);
@@ -1574,73 +1690,15 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
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
@@ -1648,11 +1706,6 @@ out_free_irq:
 	phba->work_hba_events = 0;
 	free_irq(phba->pcidev->irq, phba);
 	pci_disable_msi(phba->pcidev);
-out_free_sysfs_attr:
-	lpfc_free_sysfs_attr(phba);
-out_remove_host:
-	fc_remove_host(phba->host);
-	scsi_remove_host(phba->host);
 out_kthread_stop:
 	kthread_stop(phba->worker_thread);
 out_free_iocbq:
@@ -1690,56 +1743,8 @@ lpfc_pci_remove_one(struct pci_dev *pdev
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
-	pci_disable_msi(phba->pcidev);
-
-	lpfc_cleanup(phba);
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
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-04-24 11:12:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2007-04-24 11:12:43.000000000 -0400
@@ -1351,6 +1351,8 @@ struct scsi_host_template lpfc_template 
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
+	.scan_finished		= lpfc_scan_finished,
+	.scan_start		= lpfc_scan_start,
 	.this_id		= -1,
 	.sg_tablesize		= LPFC_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,


