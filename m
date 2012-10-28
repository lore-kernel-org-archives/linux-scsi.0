From: Joe Perches <joe@perches.com>
Subject: [PATCH 12/16] scsi: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:50 -0700
Message-ID: <7fb67679783623235a4603cf78b953d9580de939.1351411048.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, Krishna C Gudipati <kgudipat@brocade.com>, Robert Love <robert.w.love@intel.com>, James Smart <james.smart@emulex.com>, jack_wang@usish.com, lindar_liu@usish.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devel@open-fcoe.org
List-Id: linux-scsi@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.
Coalesce formats for easier grep.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/53c700.c                    |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c   |    4 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c   |    4 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c       |    4 +-
 drivers/scsi/bfa/bfad.c                  |   32 +++++------
 drivers/scsi/fcoe/fcoe_sysfs.c           |    3 +-
 drivers/scsi/lasi700.c                   |    2 +-
 drivers/scsi/libsas/sas_task.c           |    9 +--
 drivers/scsi/lpfc/lpfc_attr.c            |    8 +-
 drivers/scsi/lpfc/lpfc_debugfs.h         |    6 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c         |    4 +-
 drivers/scsi/lpfc/lpfc_init.c            |   45 +++++++--------
 drivers/scsi/mpt2sas/mpt2sas_transport.c |   91 +++++++++++++++---------------
 drivers/scsi/mvsas/mv_64xx.c             |    2 +-
 drivers/scsi/mvsas/mv_chips.h            |    8 +-
 drivers/scsi/mvsas/mv_init.c             |   14 ++---
 drivers/scsi/mvsas/mv_sas.c              |    9 +--
 drivers/scsi/pm8001/pm8001_init.c        |   10 +--
 drivers/scsi/pm8001/pm8001_sas.c         |    4 +-
 drivers/scsi/raid_class.c                |    8 +-
 drivers/scsi/scsi_scan.c                 |    3 +-
 drivers/scsi/scsi_transport_fc.c         |   31 ++++------
 drivers/scsi/scsi_transport_sas.c        |    7 +-
 drivers/scsi/sni_53c710.c                |    2 +-
 drivers/scsi/zalon.c                     |    4 +-
 25 files changed, 148 insertions(+), 168 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a3adfb4..eb0cc6e 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -395,7 +395,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	NCR_700_chip_reset(host);
 
 	if (scsi_add_host(host, dev)) {
-		dev_printk(KERN_ERR, dev, "53c700: scsi_add_host failed\n");
+		dev_err(dev, "53c700: scsi_add_host failed\n");
 		scsi_host_put(host);
 		return NULL;
 	}
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
index 3c85873..76d9390 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -105,8 +105,8 @@ ahd_linux_pci_dev_resume(struct pci_dev *pdev)
 	pci_restore_state(pdev);
 
 	if ((rc = pci_enable_device(pdev))) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "failed to enable device after resume (%d)\n", rc);
+		dev_err(&pdev->dev,
+			"failed to enable device after resume (%d)\n", rc);
 		return rc;
 	}
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index ee05e84..7a2de59 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -150,8 +150,8 @@ ahc_linux_pci_dev_resume(struct pci_dev *pdev)
 	pci_restore_state(pdev);
 
 	if ((rc = pci_enable_device(pdev))) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "failed to enable device after resume (%d)\n", rc);
+		dev_err(&pdev->dev,
+			"failed to enable device after resume (%d)\n", rc);
 		return rc;
 	}
 
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index cf90409..d5fb055 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -208,8 +208,8 @@ int asd_I_T_nexus_reset(struct domain_device *dev)
 	/* This is a bit of a problem:  the sequencer is still suspended
 	 * and is refusing to resume.  Hope it will resume on a bigger hammer
 	 * or the disk is lost */
-	dev_printk(KERN_ERR, &phy->dev,
-		   "Failed to resume nexus after reset 0x%x\n", tmp_res);
+	dev_err(&phy->dev,
+		"Failed to resume nexus after reset 0x%x\n", tmp_res);
 
 	res = TMF_RESP_FUNC_FAILED;
  out:
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 895b0e5..75e0bcf 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1501,9 +1501,8 @@ bfad_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 	unsigned long	flags;
 	pci_ers_result_t ret = PCI_ERS_RESULT_NONE;
 
-	dev_printk(KERN_ERR, &pdev->dev,
-		   "error detected state: %d - flags: 0x%x\n",
-		   state, bfad->bfad_flags);
+	dev_err(&pdev->dev, "error detected state: %d - flags: 0x%x\n",
+		state, bfad->bfad_flags);
 
 	switch (state) {
 	case pci_channel_io_normal: /* non-fatal error */
@@ -1562,8 +1561,8 @@ restart_bfa(struct bfad_s *bfad)
 
 	/* Enable Interrupt and wait bfa_init completion */
 	if (bfad_setup_intr(bfad)) {
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "%s: bfad_setup_intr failed\n", bfad->pci_name);
+		dev_warn(&pdev->dev,
+			 "%s: bfad_setup_intr failed\n", bfad->pci_name);
 		bfa_sm_send_event(bfad, BFAD_E_INTR_INIT_FAILED);
 		return -1;
 	}
@@ -1576,8 +1575,8 @@ restart_bfa(struct bfad_s *bfad)
 	/* Set up interrupt handler for each vectors */
 	if ((bfad->bfad_flags & BFAD_MSIX_ON) &&
 	    bfad_install_msix_handler(bfad))
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "%s: install_msix failed.\n", bfad->pci_name);
+		dev_warn(&pdev->dev,
+			 "%s: install_msix failed\n", bfad->pci_name);
 
 	bfad_init_timer(bfad);
 	wait_for_completion(&bfad->comp);
@@ -1595,12 +1594,11 @@ bfad_pci_slot_reset(struct pci_dev *pdev)
 	struct bfad_s *bfad = pci_get_drvdata(pdev);
 	u8 byte;
 
-	dev_printk(KERN_ERR, &pdev->dev,
-		   "bfad_pci_slot_reset flags: 0x%x\n", bfad->bfad_flags);
+	dev_err(&pdev->dev,
+		"bfad_pci_slot_reset flags: 0x%x\n", bfad->bfad_flags);
 
 	if (pci_enable_device(pdev)) {
-		dev_printk(KERN_ERR, &pdev->dev, "Cannot re-enable "
-			   "PCI device after reset.\n");
+		dev_err(&pdev->dev, "Cannot re-enable PCI device after reset\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -1613,8 +1611,8 @@ bfad_pci_slot_reset(struct pci_dev *pdev)
 	 */
 	pci_read_config_byte(pdev, 0x68, &byte);
 	if (byte == 0xff) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "slot_reset failed ... got another PCI error !\n");
+		dev_err(&pdev->dev,
+			"slot_reset failed ... got another PCI error !\n");
 		goto out_disable_device;
 	}
 
@@ -1631,8 +1629,8 @@ bfad_pci_slot_reset(struct pci_dev *pdev)
 		goto out_disable_device;
 
 	pci_enable_pcie_error_reporting(pdev);
-	dev_printk(KERN_WARNING, &pdev->dev,
-		   "slot_reset completed  flags: 0x%x!\n", bfad->bfad_flags);
+	dev_warn(&pdev->dev,
+		 "slot_reset completed  flags: 0x%x!\n", bfad->bfad_flags);
 
 	return PCI_ERS_RESULT_RECOVERED;
 
@@ -1647,7 +1645,7 @@ bfad_pci_mmio_enabled(struct pci_dev *pdev)
 	unsigned long	flags;
 	struct bfad_s *bfad = pci_get_drvdata(pdev);
 
-	dev_printk(KERN_INFO, &pdev->dev, "mmio_enabled\n");
+	dev_info(&pdev->dev, "mmio_enabled\n");
 
 	/* Fetch FW diagnostic information */
 	bfa_ioc_debug_save_ftrc(&bfad->bfa.ioc);
@@ -1672,7 +1670,7 @@ bfad_pci_resume(struct pci_dev *pdev)
 	unsigned long	flags;
 	struct bfad_s *bfad = pci_get_drvdata(pdev);
 
-	dev_printk(KERN_WARNING, &pdev->dev, "resume\n");
+	dev_warn(&pdev->dev, "resume\n");
 
 	/* wait until the link is online */
 	bfad_rport_online_wait(bfad);
diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 5e75168..daf7f74 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -701,8 +701,7 @@ static void fip_timeout_deleted_fcf(struct work_struct *work)
 	if (fcf->state != FCOE_FCF_STATE_DISCONNECTED)
 		goto out;
 
-	dev_printk(KERN_ERR, &fcf->dev,
-		   "FIP fcf connection time out: removing fcf\n");
+	dev_err(&fcf->dev, "FIP fcf connection time out: removing fcf\n");
 
 	list_del(&fcf->peers);
 	fcf->state = FCOE_FCF_STATE_DELETED;
diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index 23880f8..edc1f35 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -104,7 +104,7 @@ lasi700_probe(struct parisc_device *dev)
 
 	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
 	if (!hostdata) {
-		dev_printk(KERN_ERR, &dev->dev, "Failed to allocate host data\n");
+		dev_err(&dev->dev, "Failed to allocate host data\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index a78e5bd..fab9719 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -23,11 +23,10 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);
 
 		if (iu->status != SAM_STAT_CHECK_CONDITION)
-			dev_printk(KERN_WARNING, dev,
-				   "dev %llx sent sense data, but "
-				   "stat(%x) is not CHECK CONDITION\n",
-				   SAS_ADDR(task->dev->sas_addr),
-				   iu->status);
+			dev_warn(dev,
+				 "dev %llx sent sense data, but stat(%x) is not CHECK CONDITION\n",
+				 SAS_ADDR(task->dev->sas_addr),
+				 iu->status);
 	}
 	else
 		/* when datapres contains corrupt/unknown value... */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index ad16e54..304b4c2 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2172,7 +2172,7 @@ lpfc_soft_wwpn_store(struct device *dev, struct device_attribute *attr,
 	if (phba->cfg_soft_wwnn)
 		fc_host_node_name(shost) = phba->cfg_soft_wwnn;
 
-	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
+	dev_notice(&phba->pcidev->dev,
 		   "lpfc%d: Reinitializing to use soft_wwpn\n", phba->brd_no);
 
 	stat1 = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
@@ -2265,9 +2265,9 @@ lpfc_soft_wwnn_store(struct device *dev, struct device_attribute *attr,
 	}
 	phba->cfg_soft_wwnn = wwn_to_u64(wwnn);
 
-	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
-		   "lpfc%d: soft_wwnn set. Value will take effect upon "
-		   "setting of the soft_wwpn\n", phba->brd_no);
+	dev_notice(&phba->pcidev->dev,
+		   "lpfc%d: soft_wwnn set. Value will take effect upon setting of the soft_wwpn\n",
+		   phba->brd_no);
 
 	return count;
 }
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 8b2b6a3..b75ea8e 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -343,10 +343,8 @@ lpfc_debug_dump_q(struct lpfc_queue *q)
 	if (!q)
 		return;
 
-	dev_printk(KERN_ERR, &(((q->phba))->pcidev)->dev,
-		"%d: [qid:%d, type:%d, subtype:%d, "
-		"qe_size:%d, qe_count:%d, "
-		"host_index:%d, port_index:%d]\n",
+	dev_err(&(((q->phba))->pcidev)->dev,
+		"%d: [qid:%d, type:%d, subtype:%d, qe_size:%d, qe_count:%d, host_index:%d, port_index:%d]\n",
 		(q->phba)->brd_no,
 		q->queue_id, q->type, q->subtype,
 		q->entry_size, q->entry_count,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index d7096ad..d7cd6ec 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3844,8 +3844,8 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 	ndlp->rport = rport = fc_remote_port_add(shost, 0, &rport_ids);
 	if (!rport || !get_device(&rport->dev)) {
-		dev_printk(KERN_WARNING, &phba->pcidev->dev,
-			   "Warning: fc_remote_port_add failed\n");
+		dev_warn(&phba->pcidev->dev,
+			 "Warning: fc_remote_port_add failed\n");
 		return;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7dc4218..e1a76bb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5952,16 +5952,15 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 	/* Map HBA SLIM to a kernel virtual address. */
 	phba->slim_memmap_p = ioremap(phba->pci_bar0_map, bar0map_len);
 	if (!phba->slim_memmap_p) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "ioremap failed for SLIM memory.\n");
+		dev_err(&pdev->dev, "ioremap failed for SLIM memory\n");
 		goto out;
 	}
 
 	/* Map HBA Control Registers to a kernel virtual address. */
 	phba->ctrl_regs_memmap_p = ioremap(phba->pci_bar2_map, bar2map_len);
 	if (!phba->ctrl_regs_memmap_p) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "ioremap failed for HBA control registers.\n");
+		dev_err(&pdev->dev,
+			"ioremap failed for HBA control registers\n");
 		goto out_iounmap_slim;
 	}
 
@@ -6245,9 +6244,9 @@ lpfc_sli4_bar0_register_memmap(struct lpfc_hba *phba, uint32_t if_type)
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 	default:
-		dev_printk(KERN_ERR, &phba->pcidev->dev,
-			   "FATAL - unsupported SLI4 interface type - %d\n",
-			   if_type);
+		dev_err(&phba->pcidev->dev,
+			"FATAL - unsupported SLI4 interface type - %d\n",
+			if_type);
 		break;
 	}
 }
@@ -7806,9 +7805,8 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 		phba->sli4_hba.conf_regs_memmap_p =
 			ioremap(phba->pci_bar0_map, bar0map_len);
 		if (!phba->sli4_hba.conf_regs_memmap_p) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "ioremap failed for SLI4 PCI config "
-				   "registers.\n");
+			dev_err(&pdev->dev,
+				"ioremap failed for SLI4 PCI config registers\n");
 			goto out;
 		}
 		/* Set up BAR0 PCI config space register memory map */
@@ -7817,16 +7815,15 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 		phba->pci_bar0_map = pci_resource_start(pdev, 1);
 		bar0map_len = pci_resource_len(pdev, 1);
 		if (if_type == LPFC_SLI_INTF_IF_TYPE_2) {
-			dev_printk(KERN_ERR, &pdev->dev,
-			   "FATAL - No BAR0 mapping for SLI4, if_type 2\n");
+			dev_err(&pdev->dev,
+				"FATAL - No BAR0 mapping for SLI4, if_type 2\n");
 			goto out;
 		}
 		phba->sli4_hba.conf_regs_memmap_p =
 				ioremap(phba->pci_bar0_map, bar0map_len);
 		if (!phba->sli4_hba.conf_regs_memmap_p) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				"ioremap failed for SLI4 PCI config "
-				"registers.\n");
+			dev_err(&pdev->dev,
+				"ioremap failed for SLI4 PCI config registers\n");
 				goto out;
 		}
 		lpfc_sli4_bar0_register_memmap(phba, if_type);
@@ -7843,8 +7840,8 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 		phba->sli4_hba.ctrl_regs_memmap_p =
 				ioremap(phba->pci_bar1_map, bar1map_len);
 		if (!phba->sli4_hba.ctrl_regs_memmap_p) {
-			dev_printk(KERN_ERR, &pdev->dev,
-			   "ioremap failed for SLI4 HBA control registers.\n");
+			dev_err(&pdev->dev,
+				"ioremap failed for SLI4 HBA control registers\n");
 			goto out_iounmap_conf;
 		}
 		lpfc_sli4_bar1_register_memmap(phba);
@@ -7861,8 +7858,8 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 		phba->sli4_hba.drbl_regs_memmap_p =
 				ioremap(phba->pci_bar2_map, bar2map_len);
 		if (!phba->sli4_hba.drbl_regs_memmap_p) {
-			dev_printk(KERN_ERR, &pdev->dev,
-			   "ioremap failed for SLI4 HBA doorbell registers.\n");
+			dev_err(&pdev->dev,
+				"ioremap failed for SLI4 HBA doorbell registers\n");
 			goto out_iounmap_ctrl;
 		}
 		error = lpfc_sli4_bar2_register_memmap(phba, LPFC_VF0);
@@ -7906,9 +7903,9 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 	default:
-		dev_printk(KERN_ERR, &phba->pcidev->dev,
-			   "FATAL - unsupported SLI4 interface type - %d\n",
-			   if_type);
+		dev_err(&phba->pcidev->dev,
+			"FATAL - unsupported SLI4 interface type - %d\n",
+			if_type);
 		break;
 	}
 }
@@ -9336,7 +9333,7 @@ lpfc_io_slot_reset_s3(struct pci_dev *pdev)
 	struct lpfc_sli *psli = &phba->sli;
 	uint32_t intr_mode;
 
-	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
+	dev_info(&pdev->dev, "recovering from a slot reset\n");
 	if (pci_enable_device_mem(pdev)) {
 		printk(KERN_ERR "lpfc: Cannot re-enable "
 			"PCI device after reset.\n");
@@ -10084,7 +10081,7 @@ lpfc_io_slot_reset_s4(struct pci_dev *pdev)
 	struct lpfc_sli *psli = &phba->sli;
 	uint32_t intr_mode;
 
-	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
+	dev_info(&pdev->dev, "recovering from a slot reset\n");
 	if (pci_enable_device_mem(pdev)) {
 		printk(KERN_ERR "lpfc: Cannot re-enable "
 			"PCI device after reset.\n");
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 8c2ffbe..5b9d16b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -481,9 +481,8 @@ _transport_delete_port(struct MPT2SAS_ADAPTER *ioc,
 	enum sas_device_type device_type =
 	    mpt2sas_port->remote_identify.device_type;
 
-	dev_printk(KERN_INFO, &mpt2sas_port->port->dev,
-	    "remove: sas_addr(0x%016llx)\n",
-	    (unsigned long long) sas_address);
+	dev_info(&mpt2sas_port->port->dev, "remove: sas_addr(0x%016llx)\n",
+		 (unsigned long long) sas_address);
 
 	ioc->logging_level |= MPT_DEBUG_TRANSPORT;
 	if (device_type == SAS_END_DEVICE)
@@ -508,9 +507,9 @@ _transport_delete_phy(struct MPT2SAS_ADAPTER *ioc,
 {
 	u64 sas_address = mpt2sas_port->remote_identify.sas_address;
 
-	dev_printk(KERN_INFO, &mpt2sas_phy->phy->dev,
-	    "remove: sas_addr(0x%016llx), phy(%d)\n",
-	    (unsigned long long) sas_address, mpt2sas_phy->phy_id);
+	dev_info(&mpt2sas_phy->phy->dev,
+		 "remove: sas_addr(0x%016llx), phy(%d)\n",
+		 (unsigned long long) sas_address, mpt2sas_phy->phy_id);
 
 	list_del(&mpt2sas_phy->port_siblings);
 	mpt2sas_port->num_phys--;
@@ -532,9 +531,9 @@ _transport_add_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_port *mpt2sas_port,
 {
 	u64 sas_address = mpt2sas_port->remote_identify.sas_address;
 
-	dev_printk(KERN_INFO, &mpt2sas_phy->phy->dev,
-	    "add: sas_addr(0x%016llx), phy(%d)\n", (unsigned long long)
-	    sas_address, mpt2sas_phy->phy_id);
+	dev_info(&mpt2sas_phy->phy->dev,
+		 "add: sas_addr(0x%016llx), phy(%d)\n",
+		 (unsigned long long)sas_address, mpt2sas_phy->phy_id);
 
 	list_add_tail(&mpt2sas_phy->port_siblings, &mpt2sas_port->phy_list);
 	mpt2sas_port->num_phys++;
@@ -719,11 +718,11 @@ mpt2sas_transport_port_add(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 	list_for_each_entry(mpt2sas_phy, &mpt2sas_port->phy_list,
 	    port_siblings) {
 		if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
-			dev_printk(KERN_INFO, &port->dev, "add: handle(0x%04x)"
-			    ", sas_addr(0x%016llx), phy(%d)\n", handle,
-			    (unsigned long long)
-			    mpt2sas_port->remote_identify.sas_address,
-			    mpt2sas_phy->phy_id);
+			dev_info(&port->dev, "add: handle(0x%04x), sas_addr(0x%016llx), phy(%d)\n",
+				 handle,
+				 (unsigned long long)
+				 mpt2sas_port->remote_identify.sas_address,
+				 mpt2sas_phy->phy_id);
 		sas_port_add_phy(port, mpt2sas_phy->phy);
 		mpt2sas_phy->phy_belongs_to_port = 1;
 	}
@@ -741,10 +740,10 @@ mpt2sas_transport_port_add(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 		    ioc->name, __FILE__, __LINE__, __func__);
 	}
 	if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
-		dev_printk(KERN_INFO, &rphy->dev, "add: handle(0x%04x), "
-		    "sas_addr(0x%016llx)\n", handle,
-		    (unsigned long long)
-		    mpt2sas_port->remote_identify.sas_address);
+		dev_info(&rphy->dev, "add: handle(0x%04x), sas_addr(0x%016llx)\n",
+			 handle,
+			 (unsigned long long)
+			 mpt2sas_port->remote_identify.sas_address);
 	mpt2sas_port->rphy = rphy;
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	list_add_tail(&mpt2sas_port->port_list, &sas_node->sas_port_list);
@@ -823,11 +822,11 @@ mpt2sas_transport_port_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
 	list_for_each_entry_safe(mpt2sas_phy, next_phy,
 	    &mpt2sas_port->phy_list, port_siblings) {
 		if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
-			dev_printk(KERN_INFO, &mpt2sas_port->port->dev,
-			    "remove: sas_addr(0x%016llx), phy(%d)\n",
-			    (unsigned long long)
-			    mpt2sas_port->remote_identify.sas_address,
-			    mpt2sas_phy->phy_id);
+			dev_info(&mpt2sas_port->port->dev,
+				 "remove: sas_addr(0x%016llx), phy(%d)\n",
+				 (unsigned long long)
+				 mpt2sas_port->remote_identify.sas_address,
+				 mpt2sas_phy->phy_id);
 		mpt2sas_phy->phy_belongs_to_port = 0;
 		sas_port_delete_phy(mpt2sas_port->port, mpt2sas_phy->phy);
 		list_del(&mpt2sas_phy->port_siblings);
@@ -890,14 +889,14 @@ mpt2sas_transport_add_host_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
 		return -1;
 	}
 	if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
-		dev_printk(KERN_INFO, &phy->dev,
-		    "add: handle(0x%04x), sas_addr(0x%016llx)\n"
-		    "\tattached_handle(0x%04x), sas_addr(0x%016llx)\n",
-		    mpt2sas_phy->handle, (unsigned long long)
-		    mpt2sas_phy->identify.sas_address,
-		    mpt2sas_phy->attached_handle,
-		    (unsigned long long)
-		    mpt2sas_phy->remote_identify.sas_address);
+		dev_info(&phy->dev,
+			 "add: handle(0x%04x), sas_addr(0x%016llx)\n"
+			 "\tattached_handle(0x%04x), sas_addr(0x%016llx)\n",
+			 mpt2sas_phy->handle, (unsigned long long)
+			 mpt2sas_phy->identify.sas_address,
+			 mpt2sas_phy->attached_handle,
+			 (unsigned long long)
+			 mpt2sas_phy->remote_identify.sas_address);
 	mpt2sas_phy->phy = phy;
 	return 0;
 }
@@ -958,14 +957,14 @@ mpt2sas_transport_add_expander_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
 		return -1;
 	}
 	if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
-		dev_printk(KERN_INFO, &phy->dev,
-		    "add: handle(0x%04x), sas_addr(0x%016llx)\n"
-		    "\tattached_handle(0x%04x), sas_addr(0x%016llx)\n",
-		    mpt2sas_phy->handle, (unsigned long long)
-		    mpt2sas_phy->identify.sas_address,
-		    mpt2sas_phy->attached_handle,
-		    (unsigned long long)
-		    mpt2sas_phy->remote_identify.sas_address);
+		dev_info(&phy->dev,
+			 "add: handle(0x%04x), sas_addr(0x%016llx)\n"
+			 "\tattached_handle(0x%04x), sas_addr(0x%016llx)\n",
+			 mpt2sas_phy->handle, (unsigned long long)
+			 mpt2sas_phy->identify.sas_address,
+			 mpt2sas_phy->attached_handle,
+			 (unsigned long long)
+			 mpt2sas_phy->remote_identify.sas_address);
 	mpt2sas_phy->phy = phy;
 	return 0;
 }
@@ -1015,13 +1014,13 @@ mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc,
 		    _transport_convert_phy_link_rate(link_rate);
 
 	if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
-		dev_printk(KERN_INFO, &mpt2sas_phy->phy->dev,
-		    "refresh: parent sas_addr(0x%016llx),\n"
-		    "\tlink_rate(0x%02x), phy(%d)\n"
-		    "\tattached_handle(0x%04x), sas_addr(0x%016llx)\n",
-		    (unsigned long long)sas_address,
-		    link_rate, phy_number, handle, (unsigned long long)
-		    mpt2sas_phy->remote_identify.sas_address);
+		dev_info(&mpt2sas_phy->phy->dev,
+			 "refresh: parent sas_addr(0x%016llx),\n"
+			 "\tlink_rate(0x%02x), phy(%d)\n"
+			 "\tattached_handle(0x%04x), sas_addr(0x%016llx)\n",
+			 (unsigned long long)sas_address,
+			 link_rate, phy_number, handle, (unsigned long long)
+			 mpt2sas_phy->remote_identify.sas_address);
 }
 
 static inline void *
diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index 8ba4722..33d870c 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -200,7 +200,7 @@ static int __devinit mvs_64xx_chip_reset(struct mvs_info *mvi)
 			break;
 	}
 	if (mr32(MVS_GBL_CTL) & HBA_RST) {
-		dev_printk(KERN_ERR, mvi->dev, "HBA reset failed\n");
+		dev_err(mvi->dev, "HBA reset failed\n");
 		return -EBUSY;
 	}
 	return 0;
diff --git a/drivers/scsi/mvsas/mv_chips.h b/drivers/scsi/mvsas/mv_chips.h
index bcc4080..5cfe325 100644
--- a/drivers/scsi/mvsas/mv_chips.h
+++ b/drivers/scsi/mvsas/mv_chips.h
@@ -255,10 +255,10 @@ static inline void mvs_show_pcie_usage(struct mvs_info *mvi)
 	link_spd = (link_stat & PLS_LINK_SPD) >> PLS_LINK_SPD_OFFS;
 	if (link_spd >= 3)
 		link_spd = 0;
-	dev_printk(KERN_INFO, mvi->dev,
-		"mvsas: PCI-E x%u, Bandwidth Usage: %s Gbps\n",
-	       (link_stat & PLS_NEG_LINK_WD) >> PLS_NEG_LINK_WD_OFFS,
-	       spd[link_spd]);
+	dev_info(mvi->dev,
+		 "mvsas: PCI-E x%u, Bandwidth Usage: %s Gbps\n",
+		 (link_stat & PLS_NEG_LINK_WD) >> PLS_NEG_LINK_WD_OFFS,
+		 spd[link_spd]);
 }
 
 static inline u32 mvs_hw_max_link_rate(void)
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index cc59dff..edd37c5 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -421,22 +421,21 @@ static int pci_go_64(struct pci_dev *pdev)
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (rc) {
-				dev_printk(KERN_ERR, &pdev->dev,
-					   "64-bit DMA enable failed\n");
+				dev_err(&pdev->dev,
+					"64-bit DMA enable failed\n");
 				return rc;
 			}
 		}
 	} else {
 		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit DMA enable failed\n");
+			dev_err(&pdev->dev, "32-bit DMA enable failed\n");
 			return rc;
 		}
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit consistent DMA enable failed\n");
+			dev_err(&pdev->dev,
+				"32-bit consistent DMA enable failed\n");
 			return rc;
 		}
 	}
@@ -547,8 +546,7 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
 	struct Scsi_Host *shost = NULL;
 	const struct mvs_chip_info *chip;
 
-	dev_printk(KERN_INFO, &pdev->dev,
-		"mvsas: driver version %s\n", DRV_VERSION);
+	dev_info(&pdev->dev, "mvsas: driver version %s\n", DRV_VERSION);
 	rc = pci_enable_device(pdev);
 	if (rc)
 		goto err_out_enable;
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a3776d6..5a67f03 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -805,8 +805,7 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 		rc = mvs_task_prep_ata(mvi, &tei);
 		break;
 	default:
-		dev_printk(KERN_ERR, mvi->dev,
-			"unknown sas_task proto: 0x%x\n",
+		dev_err(mvi->dev, "unknown sas_task proto: 0x%x\n",
 			task->task_proto);
 		rc = -EINVAL;
 		break;
@@ -836,7 +835,7 @@ err_out_tag:
 	mvs_tag_free(mvi, tag);
 err_out:
 
-	dev_printk(KERN_ERR, mvi->dev, "mvsas prep failed[%d]!\n", rc);
+	dev_err(mvi->dev, "mvsas prep failed[%d]!\n", rc);
 	if (!sas_protocol_ata(task->task_proto))
 		if (n_elem)
 			dma_unmap_sg(mvi->dev, task->scatter, n_elem,
@@ -895,7 +894,7 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 	spin_lock_irqsave(&mvi->lock, flags);
 	rc = mvs_task_prep(task, mvi, is_tmf, tmf, &pass);
 	if (rc)
-		dev_printk(KERN_ERR, mvi->dev, "mvsas exec failed[%d]!\n", rc);
+		dev_err(mvi->dev, "mvsas exec failed[%d]!\n", rc);
 
 	if (likely(pass))
 			MVS_CHIP_DISP->start_delivery(mvi, (mvi->tx_prod - 1) &
@@ -942,7 +941,7 @@ static int mvs_collector_task_exec(struct sas_task *task, const int num, gfp_t g
 		spin_lock_irqsave(&mvi->lock, flags);
 		rc = mvs_task_prep(t, mvi, is_tmf, tmf, &pass[mvi->id]);
 		if (rc)
-			dev_printk(KERN_ERR, mvi->dev, "mvsas exec failed[%d]!\n", rc);
+			dev_err(mvi->dev, "mvsas exec failed[%d]!\n", rc);
 		spin_unlock_irqrestore(&mvi->lock, flags);
 	}
 
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 0267c22..100f4b3 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -406,7 +406,7 @@ static int pci_go_44(struct pci_dev *pdev)
 			rc = pci_set_consistent_dma_mask(pdev,
 				DMA_BIT_MASK(32));
 			if (rc) {
-				dev_printk(KERN_ERR, &pdev->dev,
+				dev_err(&pdev->dev,
 					"44-bit DMA enable failed\n");
 				return rc;
 			}
@@ -414,13 +414,12 @@ static int pci_go_44(struct pci_dev *pdev)
 	} else {
 		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				"32-bit DMA enable failed\n");
+			dev_err(&pdev->dev, "32-bit DMA enable failed\n");
 			return rc;
 		}
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
+			dev_err(&pdev->dev,
 				"32-bit consistent DMA enable failed\n");
 			return rc;
 		}
@@ -624,8 +623,7 @@ static int __devinit pm8001_pci_probe(struct pci_dev *pdev,
 	struct Scsi_Host *shost = NULL;
 	const struct pm8001_chip_info *chip;
 
-	dev_printk(KERN_INFO, &pdev->dev,
-		"pm8001: driver version %s\n", DRV_VERSION);
+	dev_info(&pdev->dev, "pm8001: driver version %s\n", DRV_VERSION);
 	rc = pci_enable_device(pdev);
 	if (rc)
 		goto err_out_enable;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index b961112..5ac4ed4 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -446,7 +446,7 @@ static int pm8001_task_exec(struct sas_task *task, const int num,
 			rc = pm8001_task_prep_ata(pm8001_ha, ccb);
 			break;
 		default:
-			dev_printk(KERN_ERR, pm8001_ha->dev,
+			dev_err(pm8001_ha->dev,
 				"unknown sas_task proto: 0x%x\n",
 				t->task_proto);
 			rc = -EINVAL;
@@ -472,7 +472,7 @@ static int pm8001_task_exec(struct sas_task *task, const int num,
 err_out_tag:
 	pm8001_tag_free(pm8001_ha, tag);
 err_out:
-	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
+	dev_err(pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
 	if (!sas_protocol_ata(t->task_proto))
 		if (n_elem)
 			dma_unmap_sg(pm8001_ha->dev, t->scatter, n_elem,
diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
index 2c146b4..b9d1603 100644
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -99,14 +99,14 @@ static int raid_remove(struct transport_container *tc, struct device *dev,
 {
 	struct raid_data *rd = dev_get_drvdata(cdev);
 	struct raid_component *rc, *next;
-	dev_printk(KERN_ERR, dev, "RAID REMOVE\n");
+	dev_err(dev, "RAID REMOVE\n");
 	dev_set_drvdata(cdev, NULL);
 	list_for_each_entry_safe(rc, next, &rd->component_list, node) {
 		list_del(&rc->node);
-		dev_printk(KERN_ERR, rc->dev.parent, "RAID COMPONENT REMOVE\n");
+		dev_err(rc->dev.parent, "RAID COMPONENT REMOVE\n");
 		device_unregister(&rc->dev);
 	}
-	dev_printk(KERN_ERR, dev, "RAID REMOVE DONE\n");
+	dev_err(dev, "RAID REMOVE DONE\n");
 	kfree(rd);
 	return 0;
 }
@@ -215,7 +215,7 @@ static void raid_component_release(struct device *dev)
 {
 	struct raid_component *rc =
 		container_of(dev, struct raid_component, dev);
-	dev_printk(KERN_ERR, rc->dev.parent, "COMPONENT RELEASE\n");
+	dev_err(rc->dev.parent, "COMPONENT RELEASE\n");
 	put_device(rc->dev.parent);
 	kfree(rc);
 }
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..d3743da 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -429,7 +429,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		error = shost->hostt->target_alloc(starget);
 
 		if(error) {
-			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
+			dev_err(dev, "target allocation failed, error %d\n",
+				error);
 			/* don't want scsi_target_reap to do the final
 			 * put because it will be under the host lock */
 			scsi_target_destroy(starget);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index e894ca7..bafad1c 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3143,9 +3143,8 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
 	    (rport->scsi_target_id != -1) &&
 	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
-		dev_printk(KERN_ERR, &rport->dev,
-			"blocked FC remote port time out: no longer"
-			" a FCP target, removing starget\n");
+		dev_err(&rport->dev,
+			"blocked FC remote port time out: no longer a FCP target, removing starget\n");
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_target_unblock(&rport->dev, SDEV_TRANSPORT_OFFLINE);
 		fc_queue_work(shost, &rport->stgt_delete_work);
@@ -3155,9 +3154,8 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	/* NOOP state - we're flushing workq's */
 	if (rport->port_state != FC_PORTSTATE_BLOCKED) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		dev_printk(KERN_ERR, &rport->dev,
-			"blocked FC remote port time out: leaving"
-			" rport%s alone\n",
+		dev_err(&rport->dev,
+			"blocked FC remote port time out: leaving rport%s alone\n",
 			(rport->scsi_target_id != -1) ?  " and starget" : "");
 		return;
 	}
@@ -3166,18 +3164,16 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	    (rport->scsi_target_id == -1)) {
 		list_del(&rport->peers);
 		rport->port_state = FC_PORTSTATE_DELETED;
-		dev_printk(KERN_ERR, &rport->dev,
-			"blocked FC remote port time out: removing"
-			" rport%s\n",
+		dev_err(&rport->dev,
+			"blocked FC remote port time out: removing rport%s\n",
 			(rport->scsi_target_id != -1) ?  " and starget" : "");
 		fc_queue_work(shost, &rport->rport_delete_work);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		return;
 	}
 
-	dev_printk(KERN_ERR, &rport->dev,
-		"blocked FC remote port time out: removing target and "
-		"saving binding\n");
+	dev_err(&rport->dev,
+		"blocked FC remote port time out: removing target and saving binding\n");
 
 	list_move_tail(&rport->peers, &fc_host->rport_bindings);
 
@@ -3436,9 +3432,8 @@ fc_vport_setup(struct Scsi_Host *shost, int channel, struct device *pdev,
 	vport->flags &= ~FC_VPORT_CREATING;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	dev_printk(KERN_NOTICE, pdev,
-			"%s created via shost%d channel %d\n", dev_name(dev),
-			shost->host_no, channel);
+	dev_notice(pdev, "%s created via shost%d channel %d\n",
+		   dev_name(dev), shost->host_no, channel);
 
 	*ret_vport = vport;
 
@@ -3551,9 +3546,9 @@ fc_vport_sched_delete(struct work_struct *work)
 
 	stat = fc_vport_terminate(vport);
 	if (stat)
-		dev_printk(KERN_ERR, vport->dev.parent,
-			"%s: %s could not be deleted created via "
-			"shost%d channel %d - error %d\n", __func__,
+		dev_err(vport->dev.parent,
+			"%s: %s could not be deleted created via shost%d channel %d - error %d\n",
+			__func__,
 			dev_name(&vport->dev), vport->shost->host_no,
 			vport->channel, stat);
 }
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index f7565fc..86741cd 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -289,8 +289,7 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
 	sas_host->next_port_id = 0;
 
 	if (sas_bsg_initialize(shost, NULL))
-		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
-			   shost->host_no);
+		dev_err(dev, "fail to a bsg device %d\n", shost->host_no);
 
 	return 0;
 }
@@ -1108,8 +1107,8 @@ void sas_port_add_phy(struct sas_port *port, struct sas_phy *phy)
 		/* If this trips, you added a phy that was already
 		 * part of a different port */
 		if (unlikely(tmp != phy)) {
-			dev_printk(KERN_ERR, &port->dev, "trying to add phy %s fails: it's already part of another port\n",
-				   dev_name(&phy->dev));
+			dev_err(&port->dev, "trying to add phy %s fails: it's already part of another port\n",
+				dev_name(&phy->dev));
 			BUG();
 		}
 	} else {
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index cf51432..6af585c 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -79,7 +79,7 @@ static int __devinit snirm710_probe(struct platform_device *dev)
 	base = res->start;
 	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
 	if (!hostdata) {
-		dev_printk(KERN_ERR, dev, "Failed to allocate host data\n");
+		dev_err(dev, "Failed to allocate host data\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index 27e84e4..f89ab72 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -137,8 +137,8 @@ zalon_probe(struct parisc_device *dev)
 		return -ENODEV;
 
 	if (request_irq(dev->irq, ncr53c8xx_intr, IRQF_SHARED, "zalon", host)) {
-	  dev_printk(KERN_ERR, &dev->dev, "irq problem with %d, detaching\n ",
-		     dev->irq);
+		dev_err(&dev->dev, "irq problem with %d, detaching\n",
+			dev->irq);
 		goto fail;
 	}
 
-- 
1.7.8.112.g3fd21
