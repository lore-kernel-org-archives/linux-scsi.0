From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 16/17] sym53c8xx: Remove pci_dev pointer from sym_shcb
Date: Fri,  5 Oct 2007 15:55:13 -0400
Message-ID: <11916141151125-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:44022 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761346AbXJETzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:22 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

This structure is accessed by the device; the fewer Linux things in it,
the better.  Using the pci_dev pointer from the hostdata requires a lot
of changes:

 - Pass Scsi_Host to a lot of routines which currently take a sym_hcb.
 - Set the Scsi_Host as the pci drvdata (instead of the sym_hcb)

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_fw.c   |   16 ++++--
 drivers/scsi/sym53c8xx_2/sym_fw.h   |    2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c |   97 ++++++++++++++++++-----------------
 drivers/scsi/sym53c8xx_2/sym_glue.h |    5 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   60 +++++++++++++---------
 drivers/scsi/sym53c8xx_2/sym_hipd.h |    4 +-
 6 files changed, 99 insertions(+), 85 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index aa230d2..190770b 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -104,8 +104,9 @@ static struct sym_fwz_ofs sym_fw2z_ofs = {
  *  Patch routine for firmware #1.
  */
 static void
-sym_fw1_patch(struct sym_hcb *np)
+sym_fw1_patch(struct Scsi_Host *shost)
 {
+	struct sym_hcb *np = sym_get_hcb(shost);
 	struct sym_fw1a_scr *scripta0;
 	struct sym_fw1b_scr *scriptb0;
 
@@ -145,8 +146,11 @@ sym_fw1_patch(struct sym_hcb *np)
  *  Patch routine for firmware #2.
  */
 static void
-sym_fw2_patch(struct sym_hcb *np)
+sym_fw2_patch(struct Scsi_Host *shost)
 {
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
 	struct sym_fw2a_scr *scripta0;
 	struct sym_fw2b_scr *scriptb0;
 
@@ -205,14 +209,14 @@ sym_fw2_patch(struct sym_hcb *np)
 	 *  Remove a couple of work-arounds specific to C1010 if 
 	 *  they are not desirable. See `sym_fw2.h' for more details.
 	 */
-	if (!(np->s.device->device == PCI_DEVICE_ID_LSI_53C1010_66 &&
-	      np->s.device->revision < 0x1 &&
+	if (!(pdev->device == PCI_DEVICE_ID_LSI_53C1010_66 &&
+	      pdev->revision < 0x1 &&
 	      np->pciclk_khz < 60000)) {
 		scripta0->datao_phase[0] = cpu_to_scr(SCR_NO_OP);
 		scripta0->datao_phase[1] = cpu_to_scr(0);
 	}
-	if (!(np->s.device->device == PCI_DEVICE_ID_LSI_53C1010_33 /* &&
-	      np->s.device->revision < 0xff */)) {
+	if (!(pdev->device == PCI_DEVICE_ID_LSI_53C1010_33 /* &&
+	      pdev->revision < 0xff */)) {
 		scripta0->sel_done[0] = cpu_to_scr(SCR_NO_OP);
 		scripta0->sel_done[1] = cpu_to_scr(0);
 	}
diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.h b/drivers/scsi/sym53c8xx_2/sym_fw.h
index 66ec35b..ae7e0f9 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.h
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.h
@@ -143,7 +143,7 @@ struct sym_fw {
 		*z_ofs;		/* Useful offsets in script Z	*/
 	/* Setup and patch methods for this firmware */
 	void	(*setup)(struct sym_hcb *, struct sym_fw *);
-	void	(*patch)(struct sym_hcb *);
+	void	(*patch)(struct Scsi_Host *);
 };
 
 /*
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index e515485..4c7b8a6 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -497,14 +497,16 @@ static void sym_timer(struct sym_hcb *np)
 /*
  *  PCI BUS error handler.
  */
-void sym_log_bus_error(struct sym_hcb *np)
+void sym_log_bus_error(struct Scsi_Host *shost)
 {
-	u_short pci_sts;
-	pci_read_config_word(np->s.device, PCI_STATUS, &pci_sts);
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+	unsigned short pci_sts;
+	pci_read_config_word(pdev, PCI_STATUS, &pci_sts);
 	if (pci_sts & 0xf900) {
-		pci_write_config_word(np->s.device, PCI_STATUS, pci_sts);
-		printf("%s: PCI STATUS = 0x%04x\n",
-			sym_name(np), pci_sts & 0xf900);
+		pci_write_config_word(pdev, PCI_STATUS, pci_sts);
+		shost_printk(KERN_WARNING, shost,
+			"PCI bus error: status = 0x%04x\n", pci_sts & 0xf900);
 	}
 }
 
@@ -595,16 +597,17 @@ static void sym53c8xx_timer(unsigned long npref)
  */
 static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 {
-	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
 	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
-	struct Scsi_Host *host = cmd->device->host;
-	struct pci_dev *pdev = np->s.device;
+	struct Scsi_Host *shost = cmd->device->host;
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
 	SYM_QUEHEAD *qp;
 	int cmd_queued = 0;
 	int sts = -1;
 	struct completion eh_done;
 
-	scmd_printk(KERN_WARNING, cmd, "%s operation started.\n", opname);
+	scmd_printk(KERN_WARNING, cmd, "%s operation started\n", opname);
 
 	/* We may be in an error condition because the PCI bus
 	 * went down. In this case, we need to wait until the
@@ -614,11 +617,10 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	 */
 #define WAIT_FOR_PCI_RECOVERY	35
 	if (pci_channel_offline(pdev)) {
-		struct sym_data *sym_data = shost_priv(host);
 		struct completion *io_reset;
 		int finished_reset = 0;
 		init_completion(&eh_done);
-		spin_lock_irq(host->host_lock);
+		spin_lock_irq(shost->host_lock);
 		/* Make sure we didn't race */
 		if (pci_channel_offline(pdev)) {
 			if (!sym_data->io_reset)
@@ -627,7 +629,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 		} else {
 			finished_reset = 1;
 		}
-		spin_unlock_irq(host->host_lock);
+		spin_unlock_irq(shost->host_lock);
 		if (!finished_reset)
 			finished_reset = wait_for_completion_timeout(io_reset,
 						WAIT_FOR_PCI_RECOVERY*HZ);
@@ -635,7 +637,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 			return SCSI_FAILED;
 	}
 
-	spin_lock_irq(host->host_lock);
+	spin_lock_irq(shost->host_lock);
 	/* This one is queued in some place -> to wait for completion */
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
 		struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
@@ -660,7 +662,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 		break;
 	case SYM_EH_HOST_RESET:
 		sym_reset_scsi_bus(np, 0);
-		sym_start_up(np, 1);
+		sym_start_up(shost, 1);
 		sts = 0;
 		break;
 	default:
@@ -674,13 +676,13 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	if (cmd_queued) {
 		init_completion(&eh_done);
 		ucmd->eh_done = &eh_done;
-		spin_unlock_irq(host->host_lock);
+		spin_unlock_irq(shost->host_lock);
 		if (!wait_for_completion_timeout(&eh_done, 5*HZ)) {
 			ucmd->eh_done = NULL;
 			sts = -2;
 		}
 	} else {
-		spin_unlock_irq(host->host_lock);
+		spin_unlock_irq(shost->host_lock);
 	}
 
 	dev_warn(&cmd->device->sdev_gendev, "%s operation %s.\n", opname,
@@ -993,8 +995,9 @@ static int is_keyword(char *ptr, int len, char *verb)
  * Parse a control command
  */
 
-static int sym_user_command(struct sym_hcb *np, char *buffer, int length)
+static int sym_user_command(struct Scsi_Host *shost, char *buffer, int length)
 {
+	struct sym_hcb *np = sym_get_hcb(shost);
 	char *ptr	= buffer;
 	int len		= length;
 	struct sym_usrcmd cmd, *uc = &cmd;
@@ -1121,9 +1124,9 @@ printk("sym_user_command: data=%ld\n", uc->data);
 	else {
 		unsigned long flags;
 
-		spin_lock_irqsave(np->s.host->host_lock, flags);
-		sym_exec_user_command (np, uc);
-		spin_unlock_irqrestore(np->s.host->host_lock, flags);
+		spin_lock_irqsave(shost->host_lock, flags);
+		sym_exec_user_command(np, uc);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 	return length;
 }
@@ -1179,8 +1182,11 @@ static int copy_info(struct info_str *info, char *fmt, ...)
 /*
  *  Copy formatted information into the input buffer.
  */
-static int sym_host_info(struct sym_hcb *np, char *ptr, off_t offset, int len)
+static int sym_host_info(struct Scsi_Host *shost, char *ptr, off_t offset, int len)
 {
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
 	struct info_str info;
 
 	info.buffer	= ptr;
@@ -1190,9 +1196,9 @@ static int sym_host_info(struct sym_hcb *np, char *ptr, off_t offset, int len)
 
 	copy_info(&info, "Chip " NAME53C "%s, device id 0x%x, "
 			 "revision id 0x%x\n", np->s.chip_name,
-			 np->s.device->device, np->s.device->revision);
+			 pdev->device, pdev->revision);
 	copy_info(&info, "At PCI address %s, IRQ %d\n",
-			 pci_name(np->s.device), np->s.device->irq);
+			 pci_name(pdev), pdev->irq);
 	copy_info(&info, "Min. period factor %d, %s SCSI BUS%s\n",
 			 (int) (np->minsync_dt ? np->minsync_dt : np->minsync),
 			 np->maxwide ? "Wide" : "Narrow",
@@ -1211,15 +1217,14 @@ static int sym_host_info(struct sym_hcb *np, char *ptr, off_t offset, int len)
  *  - func = 0 means read  (returns adapter infos)
  *  - func = 1 means write (not yet merget from sym53c8xx)
  */
-static int sym53c8xx_proc_info(struct Scsi_Host *host, char *buffer,
+static int sym53c8xx_proc_info(struct Scsi_Host *shost, char *buffer,
 			char **start, off_t offset, int length, int func)
 {
-	struct sym_hcb *np = sym_get_hcb(host);
 	int retv;
 
 	if (func) {
 #ifdef	SYM_LINUX_USER_COMMAND_SUPPORT
-		retv = sym_user_command(np, buffer, length);
+		retv = sym_user_command(shost, buffer, length);
 #else
 		retv = -EINVAL;
 #endif
@@ -1227,7 +1232,7 @@ static int sym53c8xx_proc_info(struct Scsi_Host *host, char *buffer,
 		if (start)
 			*start = buffer;
 #ifdef SYM_LINUX_USER_INFO_SUPPORT
-		retv = sym_host_info(np, buffer, offset, length);
+		retv = sym_host_info(shost, buffer, offset, length);
 #else
 		retv = -EINVAL;
 #endif
@@ -1303,20 +1308,18 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	np = __sym_calloc_dma(&pdev->dev, sizeof(*np), "HCB");
 	if (!np)
 		goto attach_failed;
-	np->s.device = pdev;
 	np->bus_dmat = &pdev->dev; /* Result in 1 DMA pool per HBA */
 	sym_data->ncb = np;
 	sym_data->pdev = pdev;
 	np->s.host = shost;
 
-	pci_set_drvdata(pdev, np);
+	pci_set_drvdata(pdev, shost);
 
 	/*
 	 *  Copy some useful infos to the HCB.
 	 */
 	np->hcb_ba	= vtobus(np);
 	np->verbose	= sym_driver_setup.verbose;
-	np->s.device	= pdev;
 	np->s.unit	= unit;
 	np->features	= dev->chip.features;
 	np->clock_divn	= dev->chip.nr_divisor;
@@ -1331,9 +1334,9 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	sprintf(np->s.inst_name, "sym%d", np->s.unit);
 
 	if ((SYM_CONF_DMA_ADDRESSING_MODE > 0) && (np->features & FE_DAC) &&
-			!pci_set_dma_mask(np->s.device, DMA_DAC_MASK)) {
+			!pci_set_dma_mask(pdev, DMA_DAC_MASK)) {
 		set_dac(np);
-	} else if (pci_set_dma_mask(np->s.device, DMA_32BIT_MASK)) {
+	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printf_warning("%s: No suitable DMA available\n", sym_name(np));
 		goto attach_failed;
 	}
@@ -1380,7 +1383,7 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	/*
 	 *  Start the SCRIPTS.
 	 */
-	sym_start_up(np, 1);
+	sym_start_up(shost, 1);
 
 	/*
 	 *  Start the timer daemon
@@ -1645,8 +1648,9 @@ static void sym_config_pqs(struct pci_dev *pdev, struct sym_device *sym_dev)
  *  Detach the host.
  *  We have to free resources and halt the NCR chip.
  */
-static int sym_detach(struct sym_hcb *np, struct pci_dev *pdev)
+static int sym_detach(struct Scsi_Host *shost, struct pci_dev *pdev)
 {
+	struct sym_hcb *np = sym_get_hcb(shost);
 	printk("%s: detaching ...\n", sym_name(np));
 
 	del_timer_sync(&np->s.timer);
@@ -1749,14 +1753,11 @@ static int __devinit sym2_probe(struct pci_dev *pdev,
 
 static void __devexit sym2_remove(struct pci_dev *pdev)
 {
-	struct sym_hcb *np = pci_get_drvdata(pdev);
-	struct Scsi_Host *host = np->s.host;
-
-	scsi_remove_host(host);
-	scsi_host_put(host);
-
-	sym_detach(np, pdev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 
+	scsi_remove_host(shost);
+	scsi_host_put(shost);
+	sym_detach(shost, pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 
@@ -1790,9 +1791,9 @@ static pci_ers_result_t sym2_io_error_detected(struct pci_dev *pdev,
  */
 static pci_ers_result_t sym2_io_slot_dump(struct pci_dev *pdev)
 {
-	struct sym_hcb *np = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 
-	sym_dump_registers(np);
+	sym_dump_registers(shost);
 
 	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
@@ -1832,7 +1833,8 @@ static void sym2_reset_workarounds(struct pci_dev *pdev)
  */
 static pci_ers_result_t sym2_io_slot_reset(struct pci_dev *pdev)
 {
-	struct sym_hcb *np = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct sym_hcb *np = sym_get_hcb(shost);
 
 	printk(KERN_INFO "%s: recovering from a PCI slot reset\n",
 	          sym_name(np));
@@ -1862,7 +1864,7 @@ static pci_ers_result_t sym2_io_slot_reset(struct pci_dev *pdev)
 			        sym_name(np));
 			return PCI_ERS_RESULT_DISCONNECT;
 		}
-		sym_start_up(np, 1);
+		sym_start_up(shost, 1);
 	}
 
 	return PCI_ERS_RESULT_RECOVERED;
@@ -1878,8 +1880,7 @@ static pci_ers_result_t sym2_io_slot_reset(struct pci_dev *pdev)
  */
 static void sym2_io_resume(struct pci_dev *pdev)
 {
-	struct sym_hcb *np = pci_get_drvdata(pdev);
-	struct Scsi_Host *shost = np->s.host;
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct sym_data *sym_data = shost_priv(shost);
 
 	spin_lock_irq(shost->host_lock);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index 98261a5..e5bd0af 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -179,7 +179,6 @@ struct sym_shcb {
 	int		unit;
 	char		inst_name[16];
 	char		chip_name[8];
-	struct pci_dev	*device;
 
 	struct Scsi_Host *host;
 
@@ -266,7 +265,7 @@ void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *ccb);
 void sym_xpt_async_bus_reset(struct sym_hcb *np);
 void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target);
 int  sym_setup_data_and_start (struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
-void sym_log_bus_error(struct sym_hcb *np);
-void sym_dump_registers(struct sym_hcb *np);
+void sym_log_bus_error(struct Scsi_Host *);
+void sym_dump_registers(struct Scsi_Host *);
 
 #endif /* SYM_GLUE_H */
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 5d2079f..3cf1209 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -684,6 +684,8 @@ static void sym_set_bus_mode(struct sym_hcb *np, struct sym_nvram *nvram)
  */
 static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, struct sym_nvram *nvram)
 {
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
 	u_char	burst_max;
 	u32	period;
 	int i;
@@ -797,8 +799,8 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 	 *  In dual channel mode, contention occurs if internal cycles
 	 *  are used. Disable internal cycles.
 	 */
-	if (np->s.device->device == PCI_DEVICE_ID_LSI_53C1010_33 &&
-	    np->s.device->revision < 0x1)
+	if (pdev->device == PCI_DEVICE_ID_LSI_53C1010_33 &&
+	    pdev->revision < 0x1)
 		np->rv_ccntl0	|=  DILS;
 
 	/*
@@ -821,10 +823,10 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 	 *  this driver. The generic ncr driver that does not use 
 	 *  LOAD/STORE instructions does not need this work-around.
 	 */
-	if ((np->s.device->device == PCI_DEVICE_ID_NCR_53C810 &&
-	     np->s.device->revision >= 0x10 && np->s.device->revision <= 0x11) ||
-	    (np->s.device->device == PCI_DEVICE_ID_NCR_53C860 &&
-	     np->s.device->revision <= 0x1))
+	if ((pdev->device == PCI_DEVICE_ID_NCR_53C810 &&
+	     pdev->revision >= 0x10 && pdev->revision <= 0x11) ||
+	    (pdev->device == PCI_DEVICE_ID_NCR_53C860 &&
+	     pdev->revision <= 0x1))
 		np->features &= ~(FE_WRIE|FE_ERL|FE_ERMP);
 
 	/*
@@ -890,7 +892,7 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 	if ((SYM_SETUP_SCSI_LED || 
 	     (nvram->type == SYM_SYMBIOS_NVRAM ||
 	      (nvram->type == SYM_TEKRAM_NVRAM &&
-	       np->s.device->device == PCI_DEVICE_ID_NCR_53C895))) &&
+	       pdev->device == PCI_DEVICE_ID_NCR_53C895))) &&
 	    !(np->features & FE_LEDC) && !(np->sv_gpcntl & 0x01))
 		np->features |= FE_LED0;
 
@@ -1128,8 +1130,9 @@ restart_test:
  *  First 24 register of the chip:
  *  	r0..rf
  */
-static void sym_log_hard_error(struct sym_hcb *np, u_short sist, u_char dstat)
+static void sym_log_hard_error(struct Scsi_Host *shost, u_short sist, u_char dstat)
 {
+	struct sym_hcb *np = sym_get_hcb(shost);
 	u32	dsp;
 	int	script_ofs;
 	int	script_size;
@@ -1182,17 +1185,18 @@ static void sym_log_hard_error(struct sym_hcb *np, u_short sist, u_char dstat)
 	 *  PCI BUS error.
 	 */
 	if (dstat & (MDPE|BF))
-		sym_log_bus_error(np);
+		sym_log_bus_error(shost);
 }
 
-void sym_dump_registers(struct sym_hcb *np)
+void sym_dump_registers(struct Scsi_Host *shost)
 {
+	struct sym_hcb *np = sym_get_hcb(shost);
 	u_short sist;
 	u_char dstat;
 
 	sist = INW(np, nc_sist);
 	dstat = INB(np, nc_dstat);
-	sym_log_hard_error(np, sist, dstat);
+	sym_log_hard_error(shost, sist, dstat);
 }
 
 static struct sym_chip sym_dev_table[] = {
@@ -1700,8 +1704,11 @@ static void sym_flush_busy_queue (struct sym_hcb *np, int cam_status)
  *     1: SCSI BUS RESET delivered or received.
  *     2: SCSI BUS MODE changed.
  */
-void sym_start_up (struct sym_hcb *np, int reason)
+void sym_start_up(struct Scsi_Host *shost, int reason)
 {
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
  	int	i;
 	u32	phys;
 
@@ -1750,7 +1757,7 @@ void sym_start_up (struct sym_hcb *np, int reason)
 	 *  This also let point to first position the start 
 	 *  and done queue pointers used from SCRIPTS.
 	 */
-	np->fw_patch(np);
+	np->fw_patch(shost);
 
 	/*
 	 *  Wakeup all pending jobs.
@@ -1792,7 +1799,7 @@ void sym_start_up (struct sym_hcb *np, int reason)
 	/*
 	 *  For now, disable AIP generation on C1010-66.
 	 */
-	if (np->s.device->device == PCI_DEVICE_ID_LSI_53C1010_66)
+	if (pdev->device == PCI_DEVICE_ID_LSI_53C1010_66)
 		OUTB(np, nc_aipcntl1, DISAIP);
 
 	/*
@@ -1802,8 +1809,8 @@ void sym_start_up (struct sym_hcb *np, int reason)
 	 *  that from SCRIPTS for each selection/reselection, but 
 	 *  I just don't want. :)
 	 */
-	if (np->s.device->device == PCI_DEVICE_ID_LSI_53C1010_33 &&
-	    np->s.device->revision < 1)
+	if (pdev->device == PCI_DEVICE_ID_LSI_53C1010_33 &&
+	    pdev->revision < 1)
 		OUTB(np, nc_stest1, INB(np, nc_stest1) | 0x30);
 
 	/*
@@ -1811,9 +1818,9 @@ void sym_start_up (struct sym_hcb *np, int reason)
 	 *  Disable overlapped arbitration for some dual function devices, 
 	 *  regardless revision id (kind of post-chip-design feature. ;-))
 	 */
-	if (np->s.device->device == PCI_DEVICE_ID_NCR_53C875)
+	if (pdev->device == PCI_DEVICE_ID_NCR_53C875)
 		OUTB(np, nc_ctest0, (1<<5));
-	else if (np->s.device->device == PCI_DEVICE_ID_NCR_53C896)
+	else if (pdev->device == PCI_DEVICE_ID_NCR_53C896)
 		np->rv_ccntl0 |= DPR;
 
 	/*
@@ -2218,8 +2225,9 @@ static void sym_int_udc (struct sym_hcb *np)
  *  mode to eight bit asynchronous, etc...
  *  So, just reinitializing all except chip should be enough.
  */
-static void sym_int_sbmc (struct sym_hcb *np)
+static void sym_int_sbmc(struct Scsi_Host *shost)
 {
+	struct sym_hcb *np = sym_get_hcb(shost);
 	u_char scsi_mode = INB(np, nc_stest4) & SMODE;
 
 	/*
@@ -2232,7 +2240,7 @@ static void sym_int_sbmc (struct sym_hcb *np)
 	 *  Should suspend command processing for a few seconds and 
 	 *  reinitialize all except the chip.
 	 */
-	sym_start_up (np, 2);
+	sym_start_up(shost, 2);
 }
 
 /*
@@ -2762,7 +2770,9 @@ reset_all:
 
 irqreturn_t sym_interrupt(struct Scsi_Host *shost)
 {
-	struct sym_hcb *np = sym_get_hcb(shost);
+	struct sym_data *sym_data = shost_priv(shost);
+	struct sym_hcb *np = sym_data->ncb;
+	struct pci_dev *pdev = sym_data->pdev;
 	u_char	istat, istatc;
 	u_char	dstat;
 	u_short	sist;
@@ -2818,7 +2828,7 @@ irqreturn_t sym_interrupt(struct Scsi_Host *shost)
 		/* Prevent deadlock waiting on a condition that may
 		 * never clear. */
 		if (unlikely(sist == 0xffff && dstat == 0xff)) {
-			if (pci_channel_offline(np->s.device))
+			if (pci_channel_offline(pdev))
 				return IRQ_NONE;
 		}
 	} while (istatc & (SIP|DIP));
@@ -2873,7 +2883,7 @@ irqreturn_t sym_interrupt(struct Scsi_Host *shost)
 	 */
 	if (sist & RST) {
 		printf("%s: SCSI BUS reset detected.\n", sym_name(np));
-		sym_start_up (np, 1);
+		sym_start_up(shost, 1);
 		return IRQ_HANDLED;
 	}
 
@@ -2882,7 +2892,7 @@ irqreturn_t sym_interrupt(struct Scsi_Host *shost)
 
 	if (!(sist  & (GEN|HTH|SGE)) &&
 	    !(dstat & (MDPE|BF|ABRT|IID))) {
-		if	(sist & SBMC)	sym_int_sbmc (np);
+		if	(sist & SBMC)	sym_int_sbmc(shost);
 		else if (sist & STO)	sym_int_sto (np);
 		else if (sist & UDC)	sym_int_udc (np);
 		else			goto unknown_int;
@@ -2896,7 +2906,7 @@ irqreturn_t sym_interrupt(struct Scsi_Host *shost)
 	 *  Reset everything.
 	 */
 
-	sym_log_hard_error(np, sist, dstat);
+	sym_log_hard_error(shost, sist, dstat);
 
 	if ((sist & (GEN|HTH|SGE)) ||
 		(dstat & (MDPE|BF|ABRT|IID))) {
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index a9c0866..ad07880 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -909,7 +909,7 @@ struct sym_hcb {
 	struct sym_fwb_ba fwb_bas;	/* Useful SCRIPTB bus addresses	*/
 	struct sym_fwz_ba fwz_bas;	/* Useful SCRIPTZ bus addresses	*/
 	void		(*fw_setup)(struct sym_hcb *np, struct sym_fw *fw);
-	void		(*fw_patch)(struct sym_hcb *np);
+	void		(*fw_patch)(struct Scsi_Host *);
 	char		*fw_name;
 
 	/*
@@ -1055,7 +1055,7 @@ void sym_start_next_ccbs(struct sym_hcb *np, struct sym_lcb *lp, int maxn);
 #else
 void sym_put_start_queue(struct sym_hcb *np, struct sym_ccb *cp);
 #endif
-void sym_start_up(struct sym_hcb *np, int reason);
+void sym_start_up(struct Scsi_Host *, int reason);
 irqreturn_t sym_interrupt(struct Scsi_Host *);
 int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, int lun, int task);
 struct sym_ccb *sym_get_ccb(struct sym_hcb *np, struct scsi_cmnd *cmd, u_char tag_order);
-- 
1.4.4.2

