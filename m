From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 4/4] advansys: Move to scsi hotplug initialisation model
Date: Mon, 16 Jul 2007 16:41:52 -0600
Message-ID: <11846257132833-git-send-email-matthew@wil.cx>
References: <1184625712490-git-send-email-matthew@wil.cx> <11846257131961-git-send-email-matthew@wil.cx> <1184625713127-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:40627 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763783AbXGPXNj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 19:13:39 -0400
In-Reply-To: <1184625713127-git-send-email-matthew@wil.cx>
In-Reply-To: <20070716202815.GQ13826@parisc-linux.org>
References: <20070716202815.GQ13826@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Switch from scsi_register/scsi_unregister to scsi_host_alloc,
scsi_add_host, scsi_scan_host and scsi_host_put.

Also restructure error handling in advansys_board_found, and split
advansys_init_wide_chip out of advansys_board_found.

Don't need to pass the driver_template around any more; and rename it
to advansys_template now we're not using scsi_module.c.

Reordered some functions so we don't need forward declarations.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c | 2129 +++++++++++++++++++++++------------------------
 1 files changed, 1026 insertions(+), 1103 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 35c4a1d..2c5b6ac 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -800,6 +800,8 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 
+MODULE_LICENSE("Dual BSD/GPL");
+
 /*
  * --- Driver Options
  */
@@ -3827,7 +3829,7 @@ typedef struct adv_req {
 /*
  * Structure allocated for each board.
  *
- * This structure is allocated by scsi_register() at the end
+ * This structure is allocated by scsi_host_alloc() at the end
  * of the 'Scsi_Host' structure starting at the 'hostdata'
  * field. It is guaranteed to be allocated from DMA-able memory.
  */
@@ -4258,1104 +4260,6 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 }
 #endif /* CONFIG_PROC_FS */
 
-static int advansys_board_found(struct scsi_host_template *tpnt, int iop,
-				struct pci_dev *pdev, int bus_type)
-{
-    struct Scsi_Host    *shp;
-    asc_board_t         *boardp;
-    ASC_DVC_VAR         *asc_dvc_varp = NULL;
-    ADV_DVC_VAR         *adv_dvc_varp = NULL;
-    adv_sgblk_t         *sgp;
-    int                 share_irq;
-    int                 iolen = 0;
-    ADV_PADDR           pci_memory_address;
-    int                 warn_code, err_code;
-    int                 ret;
-
-            /*
-             * Register the adapter, get its configuration, and
-             * initialize it.
-             */
-            ASC_DBG(2, "advansys_board_found: scsi_register()\n");
-
-            shp = scsi_register(tpnt, sizeof(asc_board_t));
-            if (!shp)
-		return -ENOMEM;
-
-            /* Save a pointer to the Scsi_Host of each board found. */
-            asc_host[asc_board_count++] = shp;
-	    if (pdev)
-		pci_set_drvdata(pdev, shp);
-
-            /* Initialize private per board data */
-            boardp = ASC_BOARDP(shp);
-            memset(boardp, 0, sizeof(asc_board_t));
-            boardp->id = asc_board_count - 1;
-            spin_lock_init(&boardp->lock);
-
-            /*
-             * Handle both narrow and wide boards.
-             *
-             * If a Wide board was detected, set the board structure
-             * wide board flag. Set-up the board structure based on
-             * the board type.
-             */
-#ifdef CONFIG_PCI
-	if (bus_type == ASC_IS_PCI &&
-	    (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW ||
-	     pdev->device == PCI_DEVICE_ID_38C0800_REV1 ||
-	     pdev->device == PCI_DEVICE_ID_38C1600_REV1)) {
-		boardp->flags |= ASC_IS_WIDE_BOARD;
-	}
-#endif /* CONFIG_PCI */
-
-            if (ASC_NARROW_BOARD(boardp)) {
-                ASC_DBG(1, "advansys_detect: narrow board\n");
-                asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
-                asc_dvc_varp->bus_type = bus_type;
-                asc_dvc_varp->drv_ptr = boardp;
-                asc_dvc_varp->cfg = &boardp->dvc_cfg.asc_dvc_cfg;
-                asc_dvc_varp->cfg->overrun_buf = &overrun_buf[0];
-                asc_dvc_varp->iop_base = iop;
-                asc_dvc_varp->isr_callback = asc_isr_callback;
-            } else {
-                ASC_DBG(1, "advansys_detect: wide board\n");
-                adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
-                adv_dvc_varp->drv_ptr = boardp;
-                adv_dvc_varp->cfg = &boardp->dvc_cfg.adv_dvc_cfg;
-                adv_dvc_varp->isr_callback = adv_isr_callback;
-                adv_dvc_varp->async_callback = adv_async_callback;
-#ifdef CONFIG_PCI
-		if (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW) {
-			ASC_DBG(1, "advansys_detect: ASC-3550\n");
-			adv_dvc_varp->chip_type = ADV_CHIP_ASC3550;
-                } else if (pdev->device == PCI_DEVICE_ID_38C0800_REV1) {
-			ASC_DBG(1, "advansys_detect: ASC-38C0800\n");
-			adv_dvc_varp->chip_type = ADV_CHIP_ASC38C0800;
-		} else {
-			ASC_DBG(1, "advansys_detect: ASC-38C1600\n");
-			adv_dvc_varp->chip_type = ADV_CHIP_ASC38C1600;
-		}
-#endif /* CONFIG_PCI */
-
-                /*
-                 * Map the board's registers into virtual memory for
-                 * PCI slave access. Only memory accesses are used to
-                 * access the board's registers.
-                 *
-                 * Note: The PCI register base address is not always
-                 * page aligned, but the address passed to ioremap()
-                 * must be page aligned. It is guaranteed that the
-                 * PCI register base address will not cross a page
-                 * boundary.
-                 */
-                if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550)
-                {
-                    iolen = ADV_3550_IOLEN;
-                } else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800)
-                {
-                    iolen = ADV_38C0800_IOLEN;
-                } else
-                {
-                    iolen = ADV_38C1600_IOLEN;
-                }
-#ifdef CONFIG_PCI
-                pci_memory_address = pci_resource_start(pdev, 1);
-                ASC_DBG1(1, "advansys_detect: pci_memory_address: 0x%lx\n",
-                    (ulong) pci_memory_address);
-                if ((boardp->ioremap_addr =
-                    ioremap(pci_memory_address & PAGE_MASK,
-                         PAGE_SIZE)) == 0) {
-                   ASC_PRINT3(
-"advansys_detect: board %d: ioremap(%x, %d) returned NULL\n",
-                       boardp->id, pci_memory_address, iolen);
-                   scsi_unregister(shp);
-                   asc_board_count--;
-                   return -ENOMEM;
-                }
-                ASC_DBG1(1, "advansys_detect: ioremap_addr: 0x%lx\n",
-                    (ulong) boardp->ioremap_addr);
-                adv_dvc_varp->iop_base = (AdvPortAddr)
-                    (boardp->ioremap_addr +
-                     (pci_memory_address - (pci_memory_address & PAGE_MASK)));
-                ASC_DBG1(1, "advansys_detect: iop_base: 0x%lx\n",
-                    adv_dvc_varp->iop_base);
-#endif /* CONFIG_PCI */
-
-                /*
-                 * Even though it isn't used to access wide boards, other
-                 * than for the debug line below, save I/O Port address so
-                 * that it can be reported.
-                 */
-                boardp->ioport = iop;
-
-                ASC_DBG2(1,
-"advansys_detect: iopb_chip_id_1 0x%x, iopw_chip_id_0 0x%x\n",
-                    (ushort) inp(iop + 1), (ushort) inpw(iop));
-            }
-
-#ifdef CONFIG_PROC_FS
-            /*
-             * Allocate buffer for printing information from
-             * /proc/scsi/advansys/[0...].
-             */
-            if ((boardp->prtbuf =
-                kmalloc(ASC_PRTBUF_SIZE, GFP_ATOMIC)) == NULL) {
-                ASC_PRINT3(
-"advansys_detect: board %d: kmalloc(%d, %d) returned NULL\n",
-                    boardp->id, ASC_PRTBUF_SIZE, GFP_ATOMIC);
-                scsi_unregister(shp);
-                asc_board_count--;
-                return -ENOMEM;
-            }
-#endif /* CONFIG_PROC_FS */
-
-            if (ASC_NARROW_BOARD(boardp)) {
-		asc_dvc_varp->cfg->dev = NULL;
-		/*
-                 * Set the board bus type and PCI IRQ before
-                 * calling AscInitGetConfig().
-                 */
-                switch (asc_dvc_varp->bus_type) {
-#ifdef CONFIG_ISA
-                case ASC_IS_ISA:
-                    shp->unchecked_isa_dma = TRUE;
-                    share_irq = FALSE;
-                    break;
-                case ASC_IS_VL:
-                    shp->unchecked_isa_dma = FALSE;
-                    share_irq = FALSE;
-                    break;
-                case ASC_IS_EISA:
-                    shp->unchecked_isa_dma = FALSE;
-                    share_irq = TRUE;
-                    break;
-#endif /* CONFIG_ISA */
-#ifdef CONFIG_PCI
-                case ASC_IS_PCI:
-                    shp->irq = asc_dvc_varp->irq_no = pdev->irq;
-        	    asc_dvc_varp->cfg->dev = &pdev->dev;
-                    asc_dvc_varp->cfg->pci_slot_info =
-                        ASC_PCI_MKID(pdev->bus->number,
-                            PCI_SLOT(pdev->devfn),
-                            PCI_FUNC(pdev->devfn));
-                    shp->unchecked_isa_dma = FALSE;
-                    share_irq = TRUE;
-                    break;
-#endif /* CONFIG_PCI */
-                default:
-                    ASC_PRINT2(
-"advansys_detect: board %d: unknown adapter type: %d\n",
-                        boardp->id, asc_dvc_varp->bus_type);
-                    shp->unchecked_isa_dma = TRUE;
-                    share_irq = FALSE;
-                    break;
-                }
-            } else {
-                /*
-                 * For Wide boards set PCI information before calling
-                 * AdvInitGetConfig().
-                 */
-#ifdef CONFIG_PCI
-                shp->irq = adv_dvc_varp->irq_no = pdev->irq;
-                adv_dvc_varp->cfg->dev = &pdev->dev;
-                adv_dvc_varp->cfg->pci_slot_info =
-                    ASC_PCI_MKID(pdev->bus->number,
-                        PCI_SLOT(pdev->devfn),
-                        PCI_FUNC(pdev->devfn));
-                shp->unchecked_isa_dma = FALSE;
-                share_irq = TRUE;
-#endif /* CONFIG_PCI */
-            }
-
-            /*
-             * Read the board configuration.
-             */
-            if (ASC_NARROW_BOARD(boardp)) {
-                 /*
-                  * NOTE: AscInitGetConfig() may change the board's
-                  * bus_type value. The asc_bus[bus] value should no
-                  * longer be used. If the bus_type field must be
-                  * referenced only use the bit-wise AND operator "&".
-                  */
-                ASC_DBG(2, "advansys_detect: AscInitGetConfig()\n");
-                switch(ret = AscInitGetConfig(asc_dvc_varp)) {
-                case 0:    /* No error */
-                    break;
-                case ASC_WARN_IO_PORT_ROTATE:
-                    ASC_PRINT1(
-"AscInitGetConfig: board %d: I/O port address modified\n",
-                        boardp->id);
-                    break;
-                case ASC_WARN_AUTO_CONFIG:
-                    ASC_PRINT1(
-"AscInitGetConfig: board %d: I/O port increment switch enabled\n",
-                        boardp->id);
-                    break;
-                case ASC_WARN_EEPROM_CHKSUM:
-                    ASC_PRINT1(
-"AscInitGetConfig: board %d: EEPROM checksum error\n",
-                        boardp->id);
-                    break;
-                case ASC_WARN_IRQ_MODIFIED:
-                    ASC_PRINT1(
-"AscInitGetConfig: board %d: IRQ modified\n",
-                        boardp->id);
-                    break;
-                case ASC_WARN_CMD_QNG_CONFLICT:
-                    ASC_PRINT1(
-"AscInitGetConfig: board %d: tag queuing enabled w/o disconnects\n",
-                        boardp->id);
-                    break;
-                default:
-                    ASC_PRINT2(
-"AscInitGetConfig: board %d: unknown warning: 0x%x\n",
-                        boardp->id, ret);
-                    break;
-                }
-                if ((err_code = asc_dvc_varp->err_code) != 0) {
-                    ASC_PRINT3(
-"AscInitGetConfig: board %d error: init_state 0x%x, err_code 0x%x\n",
-                        boardp->id, asc_dvc_varp->init_state,
-                        asc_dvc_varp->err_code);
-                }
-            } else {
-                ASC_DBG(2, "advansys_detect: AdvInitGetConfig()\n");
-                if ((ret = AdvInitGetConfig(adv_dvc_varp)) != 0) {
-                    ASC_PRINT2("AdvInitGetConfig: board %d: warning: 0x%x\n",
-                        boardp->id, ret);
-                }
-                if ((err_code = adv_dvc_varp->err_code) != 0) {
-                    ASC_PRINT2(
-"AdvInitGetConfig: board %d error: err_code 0x%x\n",
-                        boardp->id, adv_dvc_varp->err_code);
-                }
-            }
-
-            if (err_code != 0) {
-#ifdef CONFIG_PROC_FS
-                kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-                scsi_unregister(shp);
-                asc_board_count--;
-                return err_code;
-            }
-
-            /*
-             * Save the EEPROM configuration so that it can be displayed
-             * from /proc/scsi/advansys/[0...].
-             */
-            if (ASC_NARROW_BOARD(boardp)) {
-
-                ASCEEP_CONFIG *ep;
-
-                /*
-                 * Set the adapter's target id bit in the 'init_tidmask' field.
-                 */
-                boardp->init_tidmask |=
-                    ADV_TID_TO_TIDMASK(asc_dvc_varp->cfg->chip_scsi_id);
-
-                /*
-                 * Save EEPROM settings for the board.
-                 */
-                ep = &boardp->eep_config.asc_eep;
-
-                ep->init_sdtr = asc_dvc_varp->cfg->sdtr_enable;
-                ep->disc_enable = asc_dvc_varp->cfg->disc_enable;
-                ep->use_cmd_qng = asc_dvc_varp->cfg->cmd_qng_enabled;
-                ASC_EEP_SET_DMA_SPD(ep, asc_dvc_varp->cfg->isa_dma_speed);
-                ep->start_motor = asc_dvc_varp->start_motor;
-                ep->cntl = asc_dvc_varp->dvc_cntl;
-                ep->no_scam = asc_dvc_varp->no_scam;
-                ep->max_total_qng = asc_dvc_varp->max_total_qng;
-                ASC_EEP_SET_CHIP_ID(ep, asc_dvc_varp->cfg->chip_scsi_id);
-                /* 'max_tag_qng' is set to the same value for every device. */
-                ep->max_tag_qng = asc_dvc_varp->cfg->max_tag_qng[0];
-                ep->adapter_info[0] = asc_dvc_varp->cfg->adapter_info[0];
-                ep->adapter_info[1] = asc_dvc_varp->cfg->adapter_info[1];
-                ep->adapter_info[2] = asc_dvc_varp->cfg->adapter_info[2];
-                ep->adapter_info[3] = asc_dvc_varp->cfg->adapter_info[3];
-                ep->adapter_info[4] = asc_dvc_varp->cfg->adapter_info[4];
-                ep->adapter_info[5] = asc_dvc_varp->cfg->adapter_info[5];
-
-               /*
-                * Modify board configuration.
-                */
-                ASC_DBG(2, "advansys_detect: AscInitSetConfig()\n");
-                switch (ret = AscInitSetConfig(asc_dvc_varp)) {
-                case 0:    /* No error. */
-                    break;
-                case ASC_WARN_IO_PORT_ROTATE:
-                    ASC_PRINT1(
-"AscInitSetConfig: board %d: I/O port address modified\n",
-                        boardp->id);
-                    break;
-                case ASC_WARN_AUTO_CONFIG:
-                    ASC_PRINT1(
-"AscInitSetConfig: board %d: I/O port increment switch enabled\n",
-                        boardp->id);
-                    break;
-                case ASC_WARN_EEPROM_CHKSUM:
-                    ASC_PRINT1(
-"AscInitSetConfig: board %d: EEPROM checksum error\n",
-                        boardp->id);
-                    break;
-                case ASC_WARN_IRQ_MODIFIED:
-                    ASC_PRINT1(
-"AscInitSetConfig: board %d: IRQ modified\n",
-                        boardp->id);
-                    break;
-                case ASC_WARN_CMD_QNG_CONFLICT:
-                    ASC_PRINT1(
-"AscInitSetConfig: board %d: tag queuing w/o disconnects\n",
-                        boardp->id);
-                    break;
-                default:
-                    ASC_PRINT2(
-"AscInitSetConfig: board %d: unknown warning: 0x%x\n",
-                        boardp->id, ret);
-                    break;
-                }
-                if (asc_dvc_varp->err_code != 0) {
-                    ASC_PRINT3(
-"AscInitSetConfig: board %d error: init_state 0x%x, err_code 0x%x\n",
-                        boardp->id, asc_dvc_varp->init_state,
-                        asc_dvc_varp->err_code);
-#ifdef CONFIG_PROC_FS
-                    kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-                    scsi_unregister(shp);
-                    asc_board_count--;
-                    return asc_dvc_varp->err_code;
-                }
-
-                /*
-                 * Finish initializing the 'Scsi_Host' structure.
-                 */
-                /* AscInitSetConfig() will set the IRQ for non-PCI boards. */
-                if ((asc_dvc_varp->bus_type & ASC_IS_PCI) == 0) {
-                    shp->irq = asc_dvc_varp->irq_no;
-                }
-            } else {
-                ADVEEP_3550_CONFIG      *ep_3550;
-                ADVEEP_38C0800_CONFIG   *ep_38C0800;
-                ADVEEP_38C1600_CONFIG   *ep_38C1600;
-
-                /*
-                 * Save Wide EEP Configuration Information.
-                 */
-                if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550)
-                {
-                    ep_3550 = &boardp->eep_config.adv_3550_eep;
-
-                    ep_3550->adapter_scsi_id = adv_dvc_varp->chip_scsi_id;
-                    ep_3550->max_host_qng = adv_dvc_varp->max_host_qng;
-                    ep_3550->max_dvc_qng = adv_dvc_varp->max_dvc_qng;
-                    ep_3550->termination = adv_dvc_varp->cfg->termination;
-                    ep_3550->disc_enable = adv_dvc_varp->cfg->disc_enable;
-                    ep_3550->bios_ctrl = adv_dvc_varp->bios_ctrl;
-                    ep_3550->wdtr_able = adv_dvc_varp->wdtr_able;
-                    ep_3550->sdtr_able = adv_dvc_varp->sdtr_able;
-                    ep_3550->ultra_able = adv_dvc_varp->ultra_able;
-                    ep_3550->tagqng_able = adv_dvc_varp->tagqng_able;
-                    ep_3550->start_motor = adv_dvc_varp->start_motor;
-                    ep_3550->scsi_reset_delay = adv_dvc_varp->scsi_reset_wait;
-                    ep_3550->serial_number_word1 =
-                        adv_dvc_varp->cfg->serial1;
-                    ep_3550->serial_number_word2 =
-                        adv_dvc_varp->cfg->serial2;
-                    ep_3550->serial_number_word3 =
-                        adv_dvc_varp->cfg->serial3;
-                } else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800)
-                {
-                    ep_38C0800 = &boardp->eep_config.adv_38C0800_eep;
-
-                    ep_38C0800->adapter_scsi_id = adv_dvc_varp->chip_scsi_id;
-                    ep_38C0800->max_host_qng = adv_dvc_varp->max_host_qng;
-                    ep_38C0800->max_dvc_qng = adv_dvc_varp->max_dvc_qng;
-                    ep_38C0800->termination_lvd =
-                        adv_dvc_varp->cfg->termination;
-                    ep_38C0800->disc_enable = adv_dvc_varp->cfg->disc_enable;
-                    ep_38C0800->bios_ctrl = adv_dvc_varp->bios_ctrl;
-                    ep_38C0800->wdtr_able = adv_dvc_varp->wdtr_able;
-                    ep_38C0800->tagqng_able = adv_dvc_varp->tagqng_able;
-                    ep_38C0800->sdtr_speed1 = adv_dvc_varp->sdtr_speed1;
-                    ep_38C0800->sdtr_speed2 = adv_dvc_varp->sdtr_speed2;
-                    ep_38C0800->sdtr_speed3 = adv_dvc_varp->sdtr_speed3;
-                    ep_38C0800->sdtr_speed4 = adv_dvc_varp->sdtr_speed4;
-                    ep_38C0800->tagqng_able = adv_dvc_varp->tagqng_able;
-                    ep_38C0800->start_motor = adv_dvc_varp->start_motor;
-                    ep_38C0800->scsi_reset_delay =
-                        adv_dvc_varp->scsi_reset_wait;
-                    ep_38C0800->serial_number_word1 =
-                        adv_dvc_varp->cfg->serial1;
-                    ep_38C0800->serial_number_word2 =
-                        adv_dvc_varp->cfg->serial2;
-                    ep_38C0800->serial_number_word3 =
-                        adv_dvc_varp->cfg->serial3;
-                } else
-                {
-                    ep_38C1600 = &boardp->eep_config.adv_38C1600_eep;
-
-                    ep_38C1600->adapter_scsi_id = adv_dvc_varp->chip_scsi_id;
-                    ep_38C1600->max_host_qng = adv_dvc_varp->max_host_qng;
-                    ep_38C1600->max_dvc_qng = adv_dvc_varp->max_dvc_qng;
-                    ep_38C1600->termination_lvd =
-                        adv_dvc_varp->cfg->termination;
-                    ep_38C1600->disc_enable = adv_dvc_varp->cfg->disc_enable;
-                    ep_38C1600->bios_ctrl = adv_dvc_varp->bios_ctrl;
-                    ep_38C1600->wdtr_able = adv_dvc_varp->wdtr_able;
-                    ep_38C1600->tagqng_able = adv_dvc_varp->tagqng_able;
-                    ep_38C1600->sdtr_speed1 = adv_dvc_varp->sdtr_speed1;
-                    ep_38C1600->sdtr_speed2 = adv_dvc_varp->sdtr_speed2;
-                    ep_38C1600->sdtr_speed3 = adv_dvc_varp->sdtr_speed3;
-                    ep_38C1600->sdtr_speed4 = adv_dvc_varp->sdtr_speed4;
-                    ep_38C1600->tagqng_able = adv_dvc_varp->tagqng_able;
-                    ep_38C1600->start_motor = adv_dvc_varp->start_motor;
-                    ep_38C1600->scsi_reset_delay =
-                        adv_dvc_varp->scsi_reset_wait;
-                    ep_38C1600->serial_number_word1 =
-                        adv_dvc_varp->cfg->serial1;
-                    ep_38C1600->serial_number_word2 =
-                        adv_dvc_varp->cfg->serial2;
-                    ep_38C1600->serial_number_word3 =
-                        adv_dvc_varp->cfg->serial3;
-                }
-
-                /*
-                 * Set the adapter's target id bit in the 'init_tidmask' field.
-                 */
-                boardp->init_tidmask |=
-                    ADV_TID_TO_TIDMASK(adv_dvc_varp->chip_scsi_id);
-
-                /*
-                 * Finish initializing the 'Scsi_Host' structure.
-                 */
-                shp->irq = adv_dvc_varp->irq_no;
-            }
-
-            /*
-             * Channels are numbered beginning with 0. For AdvanSys one host
-             * structure supports one channel. Multi-channel boards have a
-             * separate host structure for each channel.
-             */
-            shp->max_channel = 0;
-            if (ASC_NARROW_BOARD(boardp)) {
-                shp->max_id = ASC_MAX_TID + 1;
-                shp->max_lun = ASC_MAX_LUN + 1;
-
-                shp->io_port = asc_dvc_varp->iop_base;
-                boardp->asc_n_io_port = ASC_IOADR_GAP;
-                shp->this_id = asc_dvc_varp->cfg->chip_scsi_id;
-
-                /* Set maximum number of queues the adapter can handle. */
-                shp->can_queue = asc_dvc_varp->max_total_qng;
-            } else {
-                shp->max_id = ADV_MAX_TID + 1;
-                shp->max_lun = ADV_MAX_LUN + 1;
-
-                /*
-                 * Save the I/O Port address and length even though
-                 * I/O ports are not used to access Wide boards.
-                 * Instead the Wide boards are accessed with
-                 * PCI Memory Mapped I/O.
-                 */
-                shp->io_port = iop;
-                boardp->asc_n_io_port = iolen;
-
-                shp->this_id = adv_dvc_varp->chip_scsi_id;
-
-                /* Set maximum number of queues the adapter can handle. */
-                shp->can_queue = adv_dvc_varp->max_host_qng;
-            }
-
-            /*
-             * 'n_io_port' currently is one byte.
-             *
-             * Set a value to 'n_io_port', but never referenced it because
-             * it may be truncated.
-             */
-            shp->n_io_port = boardp->asc_n_io_port <= 255 ?
-                boardp->asc_n_io_port : 255;
-
-            /*
-             * Following v1.3.89, 'cmd_per_lun' is no longer needed
-             * and should be set to zero.
-             *
-             * But because of a bug introduced in v1.3.89 if the driver is
-             * compiled as a module and 'cmd_per_lun' is zero, the Mid-Level
-             * SCSI function 'allocate_device' will panic. To allow the driver
-             * to work as a module in these kernels set 'cmd_per_lun' to 1.
-	     *
-	     * Note: This is wrong.  cmd_per_lun should be set to the depth
-	     * you want on untagged devices always.
-#ifdef MODULE
-             */
-            shp->cmd_per_lun = 1;
-/* #else
-            shp->cmd_per_lun = 0;
-#endif */
-
-            /*
-             * Set the maximum number of scatter-gather elements the
-             * adapter can handle.
-             */
-            if (ASC_NARROW_BOARD(boardp)) {
-                /*
-                 * Allow two commands with 'sg_tablesize' scatter-gather
-                 * elements to be executed simultaneously. This value is
-                 * the theoretical hardware limit. It may be decreased
-                 * below.
-                 */
-                shp->sg_tablesize =
-                    (((asc_dvc_varp->max_total_qng - 2) / 2) *
-                    ASC_SG_LIST_PER_Q) + 1;
-            } else {
-                shp->sg_tablesize = ADV_MAX_SG_LIST;
-            }
-
-            /*
-             * The value of 'sg_tablesize' can not exceed the SCSI
-             * mid-level driver definition of SG_ALL. SG_ALL also
-             * must not be exceeded, because it is used to define the
-             * size of the scatter-gather table in 'struct asc_sg_head'.
-             */
-            if (shp->sg_tablesize > SG_ALL) {
-                shp->sg_tablesize = SG_ALL;
-            }
-
-            ASC_DBG1(1, "advansys_detect: sg_tablesize: %d\n",
-                shp->sg_tablesize);
-
-            /* BIOS start address. */
-            if (ASC_NARROW_BOARD(boardp)) {
-                shp->base =
-                        ((ulong) AscGetChipBiosAddress(
-                            asc_dvc_varp->iop_base,
-                            asc_dvc_varp->bus_type));
-            } else {
-                /*
-                 * Fill-in BIOS board variables. The Wide BIOS saves
-                 * information in LRAM that is used by the driver.
-                 */
-                AdvReadWordLram(adv_dvc_varp->iop_base, BIOS_SIGNATURE,
-                    boardp->bios_signature);
-                AdvReadWordLram(adv_dvc_varp->iop_base, BIOS_VERSION,
-                    boardp->bios_version);
-                AdvReadWordLram(adv_dvc_varp->iop_base, BIOS_CODESEG,
-                    boardp->bios_codeseg);
-                AdvReadWordLram(adv_dvc_varp->iop_base, BIOS_CODELEN,
-                    boardp->bios_codelen);
-
-                ASC_DBG2(1,
-                    "advansys_detect: bios_signature 0x%x, bios_version 0x%x\n",
-                    boardp->bios_signature, boardp->bios_version);
-
-                ASC_DBG2(1,
-                    "advansys_detect: bios_codeseg 0x%x, bios_codelen 0x%x\n",
-                    boardp->bios_codeseg, boardp->bios_codelen);
-
-                /*
-                 * If the BIOS saved a valid signature, then fill in
-                 * the BIOS code segment base address.
-                 */
-                if (boardp->bios_signature == 0x55AA) {
-                    /*
-                     * Convert x86 realmode code segment to a linear
-                     * address by shifting left 4.
-                     */
-                    shp->base = ((ulong) boardp->bios_codeseg << 4);
-                } else {
-                    shp->base = 0;
-                }
-            }
-
-            /*
-             * Register Board Resources - I/O Port, DMA, IRQ
-             */
-
-            /*
-             * Register I/O port range.
-             *
-             * For Wide boards the I/O ports are not used to access
-             * the board, but request the region anyway.
-             *
-             * 'shp->n_io_port' is not referenced, because it may be truncated.
-             */
-            ASC_DBG2(2,
-                "advansys_detect: request_region port 0x%lx, len 0x%x\n",
-                (ulong) shp->io_port, boardp->asc_n_io_port);
-            if (request_region(shp->io_port, boardp->asc_n_io_port,
-                               "advansys") == NULL) {
-                ASC_PRINT3(
-"advansys_detect: board %d: request_region() failed, port 0x%lx, len 0x%x\n",
-                    boardp->id, (ulong) shp->io_port, boardp->asc_n_io_port);
-#ifdef CONFIG_PROC_FS
-                kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-                scsi_unregister(shp);
-                asc_board_count--;
-                return -EBUSY;
-            }
-
-            /* Register DMA Channel for Narrow boards. */
-            shp->dma_channel = NO_ISA_DMA; /* Default to no ISA DMA. */
-#ifdef CONFIG_ISA
-            if (ASC_NARROW_BOARD(boardp)) {
-                /* Register DMA channel for ISA bus. */
-                if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
-                    shp->dma_channel = asc_dvc_varp->cfg->isa_dma_channel;
-                    if ((ret =
-                         request_dma(shp->dma_channel, "advansys")) != 0) {
-                        ASC_PRINT3(
-"advansys_detect: board %d: request_dma() %d failed %d\n",
-                            boardp->id, shp->dma_channel, ret);
-                        release_region(shp->io_port, boardp->asc_n_io_port);
-#ifdef CONFIG_PROC_FS
-                        kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-                        scsi_unregister(shp);
-                        asc_board_count--;
-                        return ret;
-                    }
-                    AscEnableIsaDma(shp->dma_channel);
-                }
-            }
-#endif /* CONFIG_ISA */
-
-            /* Register IRQ Number. */
-            ASC_DBG1(2, "advansys_detect: request_irq() %d\n", shp->irq);
-           /*
-            * If request_irq() fails with the IRQF_DISABLED flag set,
-            * then try again without the IRQF_DISABLED flag set. This
-            * allows IRQ sharing to work even with other drivers that
-            * do not set the IRQF_DISABLED flag.
-            *
-            * If IRQF_DISABLED is not set, then interrupts are enabled
-            * before the driver interrupt function is called.
-            */
-            if (((ret = request_irq(shp->irq, advansys_interrupt,
-                            IRQF_DISABLED | (share_irq == TRUE ? IRQF_SHARED : 0),
-                            "advansys", boardp)) != 0) &&
-                ((ret = request_irq(shp->irq, advansys_interrupt,
-                            (share_irq == TRUE ? IRQF_SHARED : 0),
-                            "advansys", boardp)) != 0))
-            {
-                if (ret == -EBUSY) {
-                    ASC_PRINT2(
-"advansys_detect: board %d: request_irq(): IRQ 0x%x already in use.\n",
-                        boardp->id, shp->irq);
-                } else if (ret == -EINVAL) {
-                    ASC_PRINT2(
-"advansys_detect: board %d: request_irq(): IRQ 0x%x not valid.\n",
-                        boardp->id, shp->irq);
-                } else {
-                    ASC_PRINT3(
-"advansys_detect: board %d: request_irq(): IRQ 0x%x failed with %d\n",
-                        boardp->id, shp->irq, ret);
-                }
-                release_region(shp->io_port, boardp->asc_n_io_port);
-                iounmap(boardp->ioremap_addr);
-                if (shp->dma_channel != NO_ISA_DMA) {
-                    free_dma(shp->dma_channel);
-                }
-#ifdef CONFIG_PROC_FS
-                kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-                scsi_unregister(shp);
-                asc_board_count--;
-                return ret;
-            }
-
-            /*
-             * Initialize board RISC chip and enable interrupts.
-             */
-            if (ASC_NARROW_BOARD(boardp)) {
-                ASC_DBG(2, "advansys_detect: AscInitAsc1000Driver()\n");
-                warn_code = AscInitAsc1000Driver(asc_dvc_varp);
-                err_code = asc_dvc_varp->err_code;
-
-                if (warn_code || err_code) {
-                    ASC_PRINT4(
-"advansys_detect: board %d error: init_state 0x%x, warn 0x%x, error 0x%x\n",
-                        boardp->id, asc_dvc_varp->init_state,
-                        warn_code, err_code);
-                }
-            } else {
-                ADV_CARR_T      *carrp;
-                int             req_cnt = 0;
-                adv_req_t       *reqp = NULL;
-                int             sg_cnt = 0;
-
-                /*
-                 * Allocate buffer carrier structures. The total size
-                 * is about 4 KB, so allocate all at once.
-                 */
-                carrp =
-                    (ADV_CARR_T *) kmalloc(ADV_CARRIER_BUFSIZE, GFP_ATOMIC);
-                ASC_DBG1(1, "advansys_detect: carrp 0x%lx\n", (ulong) carrp);
-
-                if (carrp == NULL) {
-                    goto kmalloc_error;
-                }
-
-                /*
-                 * Allocate up to 'max_host_qng' request structures for
-                 * the Wide board. The total size is about 16 KB, so
-                 * allocate all at once. If the allocation fails decrement
-                 * and try again.
-                 */
-                for (req_cnt = adv_dvc_varp->max_host_qng;
-                    req_cnt > 0; req_cnt--) {
-
-                    reqp = (adv_req_t *)
-                        kmalloc(sizeof(adv_req_t) * req_cnt, GFP_ATOMIC);
-
-                    ASC_DBG3(1,
-                        "advansys_detect: reqp 0x%lx, req_cnt %d, bytes %lu\n",
-                        (ulong) reqp, req_cnt,
-                        (ulong) sizeof(adv_req_t) * req_cnt);
-
-                    if (reqp != NULL) {
-                        break;
-                    }
-                }
-                if (reqp == NULL)
-                {
-                    goto kmalloc_error;
-                }
-
-                /*
-                 * Allocate up to ADV_TOT_SG_BLOCK request structures for
-                 * the Wide board. Each structure is about 136 bytes.
-                 */
-                boardp->adv_sgblkp = NULL;
-                for (sg_cnt = 0; sg_cnt < ADV_TOT_SG_BLOCK; sg_cnt++) {
-
-                    sgp = (adv_sgblk_t *)
-                        kmalloc(sizeof(adv_sgblk_t), GFP_ATOMIC);
-
-                    if (sgp == NULL)
-                        break;
-
-                    sgp->next_sgblkp = boardp->adv_sgblkp;
-                    boardp->adv_sgblkp = sgp;
-
-                }
-                ASC_DBG3(1,
-                    "advansys_detect: sg_cnt %d * %u = %u bytes\n",
-                    sg_cnt, sizeof(adv_sgblk_t),
-                    (unsigned) (sizeof(adv_sgblk_t) * sg_cnt));
-
-                /*
-                 * If no request structures or scatter-gather structures could
-                 * be allocated, then return an error. Otherwise continue with
-                 * initialization.
-                 */
-    kmalloc_error:
-                if (carrp == NULL)
-                {
-                    ASC_PRINT1(
-"advansys_detect: board %d error: failed to kmalloc() carrier buffer.\n",
-                        boardp->id);
-                    err_code = ADV_ERROR;
-                } else if (reqp == NULL) {
-                    kfree(carrp);
-                    ASC_PRINT1(
-"advansys_detect: board %d error: failed to kmalloc() adv_req_t buffer.\n",
-                        boardp->id);
-                    err_code = ADV_ERROR;
-                } else if (boardp->adv_sgblkp == NULL) {
-                    kfree(carrp);
-                    kfree(reqp);
-                    ASC_PRINT1(
-"advansys_detect: board %d error: failed to kmalloc() adv_sgblk_t buffers.\n",
-                        boardp->id);
-                    err_code = ADV_ERROR;
-                } else {
-
-                    /* Save carrier buffer pointer. */
-                    boardp->orig_carrp = carrp;
-
-                    /*
-                     * Save original pointer for kfree() in case the
-                     * driver is built as a module and can be unloaded.
-                     */
-                    boardp->orig_reqp = reqp;
-
-                    adv_dvc_varp->carrier_buf = carrp;
-
-                    /*
-                     * Point 'adv_reqp' to the request structures and
-                     * link them together.
-                     */
-                    req_cnt--;
-                    reqp[req_cnt].next_reqp = NULL;
-                    for (; req_cnt > 0; req_cnt--) {
-                        reqp[req_cnt - 1].next_reqp = &reqp[req_cnt];
-                    }
-                    boardp->adv_reqp = &reqp[0];
-
-                    if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550)
-                    {
-                        ASC_DBG(2,
-                            "advansys_detect: AdvInitAsc3550Driver()\n");
-                        warn_code = AdvInitAsc3550Driver(adv_dvc_varp);
-                    } else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800) {
-                        ASC_DBG(2,
-                            "advansys_detect: AdvInitAsc38C0800Driver()\n");
-                        warn_code = AdvInitAsc38C0800Driver(adv_dvc_varp);
-                    } else {
-                        ASC_DBG(2,
-                            "advansys_detect: AdvInitAsc38C1600Driver()\n");
-                        warn_code = AdvInitAsc38C1600Driver(adv_dvc_varp);
-                    }
-                    err_code = adv_dvc_varp->err_code;
-
-                    if (warn_code || err_code) {
-                        ASC_PRINT3(
-"advansys_detect: board %d error: warn 0x%x, error 0x%x\n",
-                            boardp->id, warn_code, err_code);
-                    }
-                }
-            }
-
-            if (err_code != 0) {
-                release_region(shp->io_port, boardp->asc_n_io_port);
-                if (ASC_WIDE_BOARD(boardp)) {
-                    iounmap(boardp->ioremap_addr);
-                    kfree(boardp->orig_carrp);
-                    boardp->orig_carrp = NULL;
-                    if (boardp->orig_reqp) {
-                        kfree(boardp->orig_reqp);
-                        boardp->orig_reqp = boardp->adv_reqp = NULL;
-                    }
-                    while ((sgp = boardp->adv_sgblkp) != NULL)
-                    {
-                        boardp->adv_sgblkp = sgp->next_sgblkp;
-                        kfree(sgp);
-                    }
-                }
-                if (shp->dma_channel != NO_ISA_DMA) {
-                    free_dma(shp->dma_channel);
-                }
-#ifdef CONFIG_PROC_FS
-                kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-                free_irq(shp->irq, boardp);
-                scsi_unregister(shp);
-                asc_board_count--;
-                return err_code;
-	}
-	ASC_DBG_PRT_SCSI_HOST(2, shp);
-
-	return 0;
-}
-
-/*
- * advansys_detect()
- *
- * Detect function for AdvanSys adapters.
- *
- * Argument is a pointer to the host driver's scsi_hosts entry.
- *
- * Return number of adapters found.
- *
- * Note: Because this function is called during system initialization
- * it must not call SCSI mid-level functions including scsi_malloc()
- * and scsi_free().
- */
-static int __init
-advansys_detect(struct scsi_host_template *tpnt)
-{
-    static int          detect_called = ASC_FALSE;
-    int                 iop;
-    int                 bus;
-    int                 ioport = 0;
-
-    if (detect_called == ASC_FALSE) {
-        detect_called = ASC_TRUE;
-    } else {
-        printk("AdvanSys SCSI: advansys_detect() multiple calls ignored\n");
-        return 0;
-    }
-
-    ASC_DBG(1, "advansys_detect: begin\n");
-
-    asc_board_count = 0;
-
-    /*
-     * If I/O port probing has been modified, then verify and
-     * clean-up the 'asc_ioport' list.
-     */
-    if (asc_iopflag == ASC_TRUE) {
-        for (ioport = 0; ioport < ASC_NUM_IOPORT_PROBE; ioport++) {
-            ASC_DBG2(1, "advansys_detect: asc_ioport[%d] 0x%x\n",
-                ioport, asc_ioport[ioport]);
-            if (asc_ioport[ioport] != 0) {
-                for (iop = 0; iop < ASC_IOADR_TABLE_MAX_IX; iop++) {
-                    if (_asc_def_iop_base[iop] == asc_ioport[ioport]) {
-                        break;
-                    }
-                }
-                if (iop == ASC_IOADR_TABLE_MAX_IX) {
-                    printk(
-"AdvanSys SCSI: specified I/O Port 0x%X is invalid\n",
-                        asc_ioport[ioport]);
-                    asc_ioport[ioport] = 0;
-                }
-            }
-        }
-        ioport = 0;
-    }
-
-    for (bus = 0; bus < ASC_NUM_BUS; bus++) {
-
-        ASC_DBG2(1, "advansys_detect: bus search type %d (%s)\n",
-            bus, asc_bus_name[bus]);
-        iop = 0;
-
-        while (asc_board_count < ASC_NUM_BOARD_SUPPORTED) {
-
-            ASC_DBG1(2, "advansys_detect: asc_board_count %d\n",
-                asc_board_count);
-
-            switch (asc_bus[bus]) {
-            case ASC_IS_ISA:
-            case ASC_IS_VL:
-#ifdef CONFIG_ISA
-                if (asc_iopflag == ASC_FALSE) {
-                    iop = AscSearchIOPortAddr(iop, asc_bus[bus]);
-                } else {
-                    /*
-                     * ISA and VL I/O port scanning has either been
-                     * eliminated or limited to selected ports on
-                     * the LILO command line, /etc/lilo.conf, or
-                     * by setting variables when the module was loaded.
-                     */
-                    ASC_DBG(1, "advansys_detect: I/O port scanning modified\n");
-                ioport_try_again:
-                    iop = 0;
-                    for (; ioport < ASC_NUM_IOPORT_PROBE; ioport++) {
-                        if ((iop = asc_ioport[ioport]) != 0) {
-                            break;
-                        }
-                    }
-                    if (iop) {
-                        ASC_DBG1(1,
-                                "advansys_detect: probing I/O port 0x%x...\n",
-                            iop);
-			if (!request_region(iop, ASC_IOADR_GAP, "advansys")){
-                            printk(
-"AdvanSys SCSI: specified I/O Port 0x%X is busy\n", iop);
-                            /* Don't try this I/O port twice. */
-                            asc_ioport[ioport] = 0;
-                            goto ioport_try_again;
-                        } else if (AscFindSignature(iop) == ASC_FALSE) {
-                            printk(
-"AdvanSys SCSI: specified I/O Port 0x%X has no adapter\n", iop);
-                            /* Don't try this I/O port twice. */
-			    release_region(iop, ASC_IOADR_GAP);
-                            asc_ioport[ioport] = 0;
-                            goto ioport_try_again;
-                        } else {
-                            /*
-                             * If this isn't an ISA board, then it must be
-                             * a VL board. If currently looking an ISA
-                             * board is being looked for then try for
-                             * another ISA board in 'asc_ioport'.
-                             */
-                            if (asc_bus[bus] == ASC_IS_ISA &&
-                                (AscGetChipVersion(iop, ASC_IS_ISA) &
-                                 ASC_CHIP_VER_ISA_BIT) == 0) {
-                                 /*
-                                  * Don't clear 'asc_ioport[ioport]'. Try
-                                  * this board again for VL. Increment
-                                  * 'ioport' past this board.
-                                  */
-                                 ioport++;
-				 release_region(iop, ASC_IOADR_GAP);
-                                 goto ioport_try_again;
-                            }
-                        }
-                        /*
-                         * This board appears good, don't try the I/O port
-                         * again by clearing its value. Increment 'ioport'
-                         * for the next iteration.
-                         */
-                        asc_ioport[ioport++] = 0;
-                    }
-                }
-#endif /* CONFIG_ISA */
-                break;
-
-            case ASC_IS_EISA:
-#ifdef CONFIG_ISA
-                iop = AscSearchIOPortAddr(iop, asc_bus[bus]);
-#endif /* CONFIG_ISA */
-                break;
-
-            default:
-                ASC_PRINT1("advansys_detect: unknown bus type: %d\n",
-                    asc_bus[bus]);
-                break;
-            }
-            ASC_DBG1(1, "advansys_detect: iop 0x%x\n", iop);
-
-            if (iop == 0)
-		break;
-
-	    advansys_board_found(tpnt, iop, NULL, asc_bus[bus]);
-        }
-    }
-
-    ASC_DBG1(1, "advansys_detect: done: asc_board_count %d\n", asc_board_count);
-    return asc_board_count;
-}
-
-/*
- * advansys_release()
- *
- * Release resources allocated for a single AdvanSys adapter.
- */
-static int
-advansys_release(struct Scsi_Host *shp)
-{
-    asc_board_t    *boardp;
-
-    ASC_DBG(1, "advansys_release: begin\n");
-    boardp = ASC_BOARDP(shp);
-    free_irq(shp->irq, boardp);
-    if (shp->dma_channel != NO_ISA_DMA) {
-        ASC_DBG(1, "advansys_release: free_dma()\n");
-        free_dma(shp->dma_channel);
-    }
-    release_region(shp->io_port, boardp->asc_n_io_port);
-    if (ASC_WIDE_BOARD(boardp)) {
-        adv_sgblk_t    *sgp = NULL;
-
-        iounmap(boardp->ioremap_addr);
-        kfree(boardp->orig_carrp);
-        boardp->orig_carrp = NULL;
-        if (boardp->orig_reqp) {
-            kfree(boardp->orig_reqp);
-            boardp->orig_reqp = boardp->adv_reqp = NULL;
-        }
-        while ((sgp = boardp->adv_sgblkp) != NULL)
-        {
-            boardp->adv_sgblkp = sgp->next_sgblkp;
-            kfree(sgp);
-        }
-    }
-#ifdef CONFIG_PROC_FS
-    ASC_ASSERT(boardp->prtbuf != NULL);
-    kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-    scsi_unregister(shp);
-    ASC_DBG(1, "advansys_release: end\n");
-    return 0;
-}
-
 /*
  * advansys_info()
  *
@@ -5768,7 +4672,7 @@ advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
  * --- Loadable Driver Support
  */
 
-static struct scsi_host_template driver_template = {
+static struct scsi_host_template advansys_template = {
     .proc_name                  = "advansys",
 #ifdef CONFIG_PROC_FS
     .proc_info                  = advansys_proc_info,
@@ -18028,7 +16932,1025 @@ AdvInquiryHandling(
         }
     }
 }
-MODULE_LICENSE("Dual BSD/GPL");
+
+static int __init advansys_init_wide_chip(asc_board_t *boardp,
+					  ADV_DVC_VAR *adv_dvc_varp)
+{
+	ADV_CARR_T *carrp;
+	int req_cnt = 0;
+	adv_req_t *reqp = NULL;
+	int sg_cnt = 0;
+	adv_sgblk_t *sgp;
+	int warn_code, err_code;
+
+	/*
+	 * Allocate buffer carrier structures. The total size
+	 * is about 4 KB, so allocate all at once.
+	 */
+	carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_KERNEL);
+	ASC_DBG1(1, "advansys_detect: carrp 0x%lx\n", (ulong) carrp);
+
+	if (!carrp)
+		goto kmalloc_failed;
+
+	/*
+	 * Allocate up to 'max_host_qng' request structures for
+	 * the Wide board. The total size is about 16 KB, so
+	 * allocate all at once. If the allocation fails decrement
+	 * and try again.
+	 */
+	for (req_cnt = adv_dvc_varp->max_host_qng; req_cnt > 0; req_cnt--) {
+		reqp = kmalloc(sizeof(adv_req_t) * req_cnt, GFP_KERNEL);
+
+		ASC_DBG3(1,
+			 "advansys_detect: reqp 0x%lx, req_cnt %d, bytes %lu\n",
+			 (ulong) reqp, req_cnt,
+			 (ulong) sizeof(adv_req_t) * req_cnt);
+
+		if (reqp)
+			break;
+	}
+
+	if (!reqp)
+		goto kmalloc_failed;
+
+	/*
+	 * Allocate up to ADV_TOT_SG_BLOCK request structures for
+	 * the Wide board. Each structure is about 136 bytes.
+	 */
+	boardp->adv_sgblkp = NULL;
+	for (sg_cnt = 0; sg_cnt < ADV_TOT_SG_BLOCK; sg_cnt++) {
+		sgp = kmalloc(sizeof(adv_sgblk_t), GFP_KERNEL);
+
+		if (!sgp)
+			break;
+
+		sgp->next_sgblkp = boardp->adv_sgblkp;
+		boardp->adv_sgblkp = sgp;
+	}
+
+	if (!boardp->adv_sgblkp)
+		goto kmalloc_failed;
+
+	ASC_DBG3(1, "advansys_detect: sg_cnt %d * %u = %u bytes\n",
+		 sg_cnt, sizeof(adv_sgblk_t),
+		 (unsigned) (sizeof(adv_sgblk_t) * sg_cnt));
+
+	/* Save carrier buffer pointer. */
+	boardp->orig_carrp = carrp;
+
+	/*
+	 * Save original pointer for kfree() in case the
+	 * driver is built as a module and can be unloaded.
+	 */
+	boardp->orig_reqp = reqp;
+
+	adv_dvc_varp->carrier_buf = carrp;
+
+	/*
+	 * Point 'adv_reqp' to the request structures and
+	 * link them together.
+	 */
+	req_cnt--;
+	reqp[req_cnt].next_reqp = NULL;
+	for (; req_cnt > 0; req_cnt--) {
+		reqp[req_cnt - 1].next_reqp = &reqp[req_cnt];
+	}
+	boardp->adv_reqp = &reqp[0];
+
+	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
+		ASC_DBG(2, "advansys_detect: AdvInitAsc3550Driver()\n");
+		warn_code = AdvInitAsc3550Driver(adv_dvc_varp);
+	} else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800) {
+		ASC_DBG(2, "advansys_detect: AdvInitAsc38C0800Driver()\n");
+		warn_code = AdvInitAsc38C0800Driver(adv_dvc_varp);
+	} else {
+		ASC_DBG(2, "advansys_detect: AdvInitAsc38C1600Driver()\n");
+		warn_code = AdvInitAsc38C1600Driver(adv_dvc_varp);
+	}
+	err_code = adv_dvc_varp->err_code;
+
+	if (warn_code || err_code) {
+		ASC_PRINT3("advansys_detect: board %d error: warn 0x%x, "
+			   "error 0x%x\n", boardp->id, warn_code, err_code);
+	}
+
+	if (err_code == 0)
+		return 0;
+
+	while ((sgp = boardp->adv_sgblkp) != NULL) {
+		boardp->adv_sgblkp = sgp->next_sgblkp;
+		kfree(sgp);
+	}
+
+ failed:
+	kfree(reqp);
+	kfree(carrp);
+	return err_code;
+
+ kmalloc_failed:
+	ASC_PRINT1("advansys_detect: board %d error: kmalloc() failed\n",
+		   boardp->id);
+	err_code = ADV_ERROR;
+	goto failed;
+}
+
+static int advansys_board_found(int iop, struct pci_dev *pdev, int bus_type)
+{
+	struct Scsi_Host *shost;
+	asc_board_t *boardp;
+	ASC_DVC_VAR *asc_dvc_varp = NULL;
+	ADV_DVC_VAR *adv_dvc_varp = NULL;
+	int share_irq;
+	int iolen = 0;
+	int warn_code, err_code;
+	int ret;
+
+	/*
+	 * Register the adapter, get its configuration, and
+	 * initialize it.
+	 */
+	ASC_DBG(2, "advansys_board_found: scsi_host_alloc()\n");
+
+	shost = scsi_host_alloc(&advansys_template, sizeof(asc_board_t));
+	if (!shost)
+		return -ENOMEM;
+
+	/* Save a pointer to the Scsi_Host of each board found. */
+	asc_host[asc_board_count++] = shost;
+	if (pdev)
+		pci_set_drvdata(pdev, shost);
+
+	/* Initialize private per board data */
+	boardp = ASC_BOARDP(shost);
+	memset(boardp, 0, sizeof(asc_board_t));
+	boardp->id = asc_board_count - 1;
+	spin_lock_init(&boardp->lock);
+
+	/*
+	 * Handle both narrow and wide boards.
+	 *
+	 * If a Wide board was detected, set the board structure
+	 * wide board flag. Set-up the board structure based on
+	 * the board type.
+	 */
+#ifdef CONFIG_PCI
+	if (bus_type == ASC_IS_PCI &&
+	    (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW ||
+	     pdev->device == PCI_DEVICE_ID_38C0800_REV1 ||
+	     pdev->device == PCI_DEVICE_ID_38C1600_REV1)) {
+		boardp->flags |= ASC_IS_WIDE_BOARD;
+	}
+#endif /* CONFIG_PCI */
+
+	if (ASC_NARROW_BOARD(boardp)) {
+		ASC_DBG(1, "advansys_detect: narrow board\n");
+		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
+		asc_dvc_varp->bus_type = bus_type;
+		asc_dvc_varp->drv_ptr = boardp;
+		asc_dvc_varp->cfg = &boardp->dvc_cfg.asc_dvc_cfg;
+		asc_dvc_varp->cfg->overrun_buf = &overrun_buf[0];
+		asc_dvc_varp->iop_base = iop;
+		asc_dvc_varp->isr_callback = asc_isr_callback;
+	} else {
+		ASC_DBG(1, "advansys_detect: wide board\n");
+		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
+		adv_dvc_varp->drv_ptr = boardp;
+		adv_dvc_varp->cfg = &boardp->dvc_cfg.adv_dvc_cfg;
+		adv_dvc_varp->isr_callback = adv_isr_callback;
+		adv_dvc_varp->async_callback = adv_async_callback;
+#ifdef CONFIG_PCI
+		if (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW) {
+			ASC_DBG(1, "advansys_detect: ASC-3550\n");
+			adv_dvc_varp->chip_type = ADV_CHIP_ASC3550;
+			iolen = ADV_3550_IOLEN;
+		} else if (pdev->device == PCI_DEVICE_ID_38C0800_REV1) {
+			ASC_DBG(1, "advansys_detect: ASC-38C0800\n");
+			adv_dvc_varp->chip_type = ADV_CHIP_ASC38C0800;
+			iolen = ADV_38C0800_IOLEN;
+		} else {
+			ASC_DBG(1, "advansys_detect: ASC-38C1600\n");
+			adv_dvc_varp->chip_type = ADV_CHIP_ASC38C1600;
+			iolen = ADV_38C1600_IOLEN;
+		}
+
+		/*
+		 * Map the board's registers into virtual memory for
+		 * PCI slave access. Only memory accesses are used to
+		 * access the board's registers.
+		 */
+
+		ASC_DBG1(1, "advansys_detect: pci_memory_address: 0x%lx\n",
+			 pci_resource_start(pdev, 1));
+		boardp->ioremap_addr = ioremap(pci_resource_start(pdev, 1),
+					       iolen);
+		if (boardp->ioremap_addr == 0) {
+			ASC_PRINT3("advansys_detect: board %d: ioremap(%x, %d) "
+				   "returned NULL\n", boardp->id,
+				   pci_resource_start(pdev, 1), iolen);
+			err_code = -ENOMEM;
+			goto err_shost;
+		}
+		ASC_DBG1(1, "advansys_detect: ioremap_addr: 0x%lx\n",
+			 (ulong) boardp->ioremap_addr);
+		adv_dvc_varp->iop_base = (AdvPortAddr) boardp->ioremap_addr;
+#endif /* CONFIG_PCI */
+
+		/*
+		 * Even though it isn't used to access wide boards, other
+		 * than for the debug line below, save I/O Port address so
+		 * that it can be reported.
+		 */
+		boardp->ioport = iop;
+
+		ASC_DBG2(1, "advansys_detect: iopb_chip_id_1 0x%x, "
+			 "iopw_chip_id_0 0x%x\n", (ushort) inp(iop + 1),
+			 (ushort) inpw(iop));
+	}
+
+#ifdef CONFIG_PROC_FS
+	/*
+	 * Allocate buffer for printing information from
+	 * /proc/scsi/advansys/[0...].
+	 */
+	boardp->prtbuf = kmalloc(ASC_PRTBUF_SIZE, GFP_KERNEL);
+	if (!boardp->prtbuf) {
+		ASC_PRINT3("advansys_detect: board %d: kmalloc(%d, %d) "
+			   "returned NULL\n", boardp->id, ASC_PRTBUF_SIZE,
+			   GFP_ATOMIC);
+		err_code = -ENOMEM;
+		goto err_unmap;
+	}
+#endif /* CONFIG_PROC_FS */
+
+	if (ASC_NARROW_BOARD(boardp)) {
+		asc_dvc_varp->cfg->dev = NULL;
+		/*
+		 * Set the board bus type and PCI IRQ before
+		 * calling AscInitGetConfig().
+		 */
+		switch (asc_dvc_varp->bus_type) {
+#ifdef CONFIG_ISA
+		case ASC_IS_ISA:
+			shost->unchecked_isa_dma = TRUE;
+			share_irq = FALSE;
+			break;
+		case ASC_IS_VL:
+			shost->unchecked_isa_dma = FALSE;
+			share_irq = FALSE;
+			break;
+		case ASC_IS_EISA:
+			shost->unchecked_isa_dma = FALSE;
+			share_irq = TRUE;
+			break;
+#endif /* CONFIG_ISA */
+#ifdef CONFIG_PCI
+		case ASC_IS_PCI:
+			shost->irq = asc_dvc_varp->irq_no = pdev->irq;
+			asc_dvc_varp->cfg->dev = &pdev->dev;
+			asc_dvc_varp->cfg->pci_slot_info =
+				ASC_PCI_MKID(pdev->bus->number,
+					PCI_SLOT(pdev->devfn),
+					PCI_FUNC(pdev->devfn));
+			shost->unchecked_isa_dma = FALSE;
+			share_irq = TRUE;
+			break;
+#endif /* CONFIG_PCI */
+		default:
+			ASC_PRINT2("advansys_detect: board %d: unknown adapter"
+				   " type: %d\n", boardp->id,
+				   asc_dvc_varp->bus_type);
+			shost->unchecked_isa_dma = TRUE;
+			share_irq = FALSE;
+			break;
+		}
+	} else {
+		/*
+		 * For Wide boards set PCI information before calling
+		 * AdvInitGetConfig().
+		 */
+#ifdef CONFIG_PCI
+		shost->irq = adv_dvc_varp->irq_no = pdev->irq;
+		adv_dvc_varp->cfg->dev = &pdev->dev;
+		adv_dvc_varp->cfg->pci_slot_info =
+			ASC_PCI_MKID(pdev->bus->number,
+				PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
+		shost->unchecked_isa_dma = FALSE;
+		share_irq = TRUE;
+#endif /* CONFIG_PCI */
+	}
+
+	/* Read the board configuration. */
+	if (ASC_NARROW_BOARD(boardp)) {
+		/*
+		 * NOTE: AscInitGetConfig() may change the board's
+		 * bus_type value. The asc_bus[bus] value should no
+		 * longer be used. If the bus_type field must be
+		 * referenced only use the bit-wise AND operator "&".
+		 */
+                ASC_DBG(2, "advansys_detect: AscInitGetConfig()\n");
+                switch(ret = AscInitGetConfig(asc_dvc_varp)) {
+                case 0:    /* No error */
+                    break;
+                case ASC_WARN_IO_PORT_ROTATE:
+                    ASC_PRINT1(
+"AscInitGetConfig: board %d: I/O port address modified\n",
+                        boardp->id);
+                    break;
+                case ASC_WARN_AUTO_CONFIG:
+                    ASC_PRINT1(
+"AscInitGetConfig: board %d: I/O port increment switch enabled\n",
+                        boardp->id);
+                    break;
+                case ASC_WARN_EEPROM_CHKSUM:
+                    ASC_PRINT1(
+"AscInitGetConfig: board %d: EEPROM checksum error\n",
+                        boardp->id);
+                    break;
+                case ASC_WARN_IRQ_MODIFIED:
+                    ASC_PRINT1(
+"AscInitGetConfig: board %d: IRQ modified\n",
+                        boardp->id);
+                    break;
+                case ASC_WARN_CMD_QNG_CONFLICT:
+                    ASC_PRINT1(
+"AscInitGetConfig: board %d: tag queuing enabled w/o disconnects\n",
+                        boardp->id);
+                    break;
+                default:
+                    ASC_PRINT2(
+"AscInitGetConfig: board %d: unknown warning: 0x%x\n",
+                        boardp->id, ret);
+                    break;
+                }
+                if ((err_code = asc_dvc_varp->err_code) != 0) {
+                    ASC_PRINT3(
+"AscInitGetConfig: board %d error: init_state 0x%x, err_code 0x%x\n",
+                        boardp->id, asc_dvc_varp->init_state,
+                        asc_dvc_varp->err_code);
+                }
+            } else {
+                ASC_DBG(2, "advansys_detect: AdvInitGetConfig()\n");
+                if ((ret = AdvInitGetConfig(adv_dvc_varp)) != 0) {
+                    ASC_PRINT2("AdvInitGetConfig: board %d: warning: 0x%x\n",
+                        boardp->id, ret);
+                }
+                if ((err_code = adv_dvc_varp->err_code) != 0) {
+                    ASC_PRINT2(
+"AdvInitGetConfig: board %d error: err_code 0x%x\n",
+                        boardp->id, adv_dvc_varp->err_code);
+                }
+            }
+
+            if (err_code != 0)
+		goto err_free_proc;
+
+            /*
+             * Save the EEPROM configuration so that it can be displayed
+             * from /proc/scsi/advansys/[0...].
+             */
+            if (ASC_NARROW_BOARD(boardp)) {
+
+                ASCEEP_CONFIG *ep;
+
+                /*
+                 * Set the adapter's target id bit in the 'init_tidmask' field.
+                 */
+                boardp->init_tidmask |=
+                    ADV_TID_TO_TIDMASK(asc_dvc_varp->cfg->chip_scsi_id);
+
+                /*
+                 * Save EEPROM settings for the board.
+                 */
+                ep = &boardp->eep_config.asc_eep;
+
+                ep->init_sdtr = asc_dvc_varp->cfg->sdtr_enable;
+                ep->disc_enable = asc_dvc_varp->cfg->disc_enable;
+                ep->use_cmd_qng = asc_dvc_varp->cfg->cmd_qng_enabled;
+                ASC_EEP_SET_DMA_SPD(ep, asc_dvc_varp->cfg->isa_dma_speed);
+                ep->start_motor = asc_dvc_varp->start_motor;
+                ep->cntl = asc_dvc_varp->dvc_cntl;
+                ep->no_scam = asc_dvc_varp->no_scam;
+                ep->max_total_qng = asc_dvc_varp->max_total_qng;
+                ASC_EEP_SET_CHIP_ID(ep, asc_dvc_varp->cfg->chip_scsi_id);
+                /* 'max_tag_qng' is set to the same value for every device. */
+                ep->max_tag_qng = asc_dvc_varp->cfg->max_tag_qng[0];
+                ep->adapter_info[0] = asc_dvc_varp->cfg->adapter_info[0];
+                ep->adapter_info[1] = asc_dvc_varp->cfg->adapter_info[1];
+                ep->adapter_info[2] = asc_dvc_varp->cfg->adapter_info[2];
+                ep->adapter_info[3] = asc_dvc_varp->cfg->adapter_info[3];
+                ep->adapter_info[4] = asc_dvc_varp->cfg->adapter_info[4];
+                ep->adapter_info[5] = asc_dvc_varp->cfg->adapter_info[5];
+
+               /*
+                * Modify board configuration.
+                */
+                ASC_DBG(2, "advansys_detect: AscInitSetConfig()\n");
+                switch (ret = AscInitSetConfig(asc_dvc_varp)) {
+                case 0:    /* No error. */
+                    break;
+                case ASC_WARN_IO_PORT_ROTATE:
+                    ASC_PRINT1(
+"AscInitSetConfig: board %d: I/O port address modified\n",
+                        boardp->id);
+                    break;
+                case ASC_WARN_AUTO_CONFIG:
+                    ASC_PRINT1(
+"AscInitSetConfig: board %d: I/O port increment switch enabled\n",
+                        boardp->id);
+                    break;
+                case ASC_WARN_EEPROM_CHKSUM:
+                    ASC_PRINT1(
+"AscInitSetConfig: board %d: EEPROM checksum error\n",
+                        boardp->id);
+                    break;
+                case ASC_WARN_IRQ_MODIFIED:
+                    ASC_PRINT1(
+"AscInitSetConfig: board %d: IRQ modified\n",
+                        boardp->id);
+                    break;
+                case ASC_WARN_CMD_QNG_CONFLICT:
+                    ASC_PRINT1(
+"AscInitSetConfig: board %d: tag queuing w/o disconnects\n",
+                        boardp->id);
+                    break;
+                default:
+                    ASC_PRINT2(
+"AscInitSetConfig: board %d: unknown warning: 0x%x\n",
+                        boardp->id, ret);
+                    break;
+                }
+                if (asc_dvc_varp->err_code != 0) {
+		    err_code = asc_dvc_varp->err_code;
+                    ASC_PRINT3(
+"AscInitSetConfig: board %d error: init_state 0x%x, err_code 0x%x\n",
+                        boardp->id, asc_dvc_varp->init_state,
+                        err_code);
+                    goto err_free_proc;
+                }
+
+                /*
+                 * Finish initializing the 'Scsi_Host' structure.
+                 */
+                /* AscInitSetConfig() will set the IRQ for non-PCI boards. */
+                if ((asc_dvc_varp->bus_type & ASC_IS_PCI) == 0) {
+                    shost->irq = asc_dvc_varp->irq_no;
+                }
+            } else {
+                ADVEEP_3550_CONFIG      *ep_3550;
+                ADVEEP_38C0800_CONFIG   *ep_38C0800;
+                ADVEEP_38C1600_CONFIG   *ep_38C1600;
+
+                /*
+                 * Save Wide EEP Configuration Information.
+                 */
+                if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550)
+                {
+                    ep_3550 = &boardp->eep_config.adv_3550_eep;
+
+                    ep_3550->adapter_scsi_id = adv_dvc_varp->chip_scsi_id;
+                    ep_3550->max_host_qng = adv_dvc_varp->max_host_qng;
+                    ep_3550->max_dvc_qng = adv_dvc_varp->max_dvc_qng;
+                    ep_3550->termination = adv_dvc_varp->cfg->termination;
+                    ep_3550->disc_enable = adv_dvc_varp->cfg->disc_enable;
+                    ep_3550->bios_ctrl = adv_dvc_varp->bios_ctrl;
+                    ep_3550->wdtr_able = adv_dvc_varp->wdtr_able;
+                    ep_3550->sdtr_able = adv_dvc_varp->sdtr_able;
+                    ep_3550->ultra_able = adv_dvc_varp->ultra_able;
+                    ep_3550->tagqng_able = adv_dvc_varp->tagqng_able;
+                    ep_3550->start_motor = adv_dvc_varp->start_motor;
+                    ep_3550->scsi_reset_delay = adv_dvc_varp->scsi_reset_wait;
+                    ep_3550->serial_number_word1 =
+                        adv_dvc_varp->cfg->serial1;
+                    ep_3550->serial_number_word2 =
+                        adv_dvc_varp->cfg->serial2;
+                    ep_3550->serial_number_word3 =
+                        adv_dvc_varp->cfg->serial3;
+                } else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800)
+                {
+                    ep_38C0800 = &boardp->eep_config.adv_38C0800_eep;
+
+                    ep_38C0800->adapter_scsi_id = adv_dvc_varp->chip_scsi_id;
+                    ep_38C0800->max_host_qng = adv_dvc_varp->max_host_qng;
+                    ep_38C0800->max_dvc_qng = adv_dvc_varp->max_dvc_qng;
+                    ep_38C0800->termination_lvd =
+                        adv_dvc_varp->cfg->termination;
+                    ep_38C0800->disc_enable = adv_dvc_varp->cfg->disc_enable;
+                    ep_38C0800->bios_ctrl = adv_dvc_varp->bios_ctrl;
+                    ep_38C0800->wdtr_able = adv_dvc_varp->wdtr_able;
+                    ep_38C0800->tagqng_able = adv_dvc_varp->tagqng_able;
+                    ep_38C0800->sdtr_speed1 = adv_dvc_varp->sdtr_speed1;
+                    ep_38C0800->sdtr_speed2 = adv_dvc_varp->sdtr_speed2;
+                    ep_38C0800->sdtr_speed3 = adv_dvc_varp->sdtr_speed3;
+                    ep_38C0800->sdtr_speed4 = adv_dvc_varp->sdtr_speed4;
+                    ep_38C0800->tagqng_able = adv_dvc_varp->tagqng_able;
+                    ep_38C0800->start_motor = adv_dvc_varp->start_motor;
+                    ep_38C0800->scsi_reset_delay =
+                        adv_dvc_varp->scsi_reset_wait;
+                    ep_38C0800->serial_number_word1 =
+                        adv_dvc_varp->cfg->serial1;
+                    ep_38C0800->serial_number_word2 =
+                        adv_dvc_varp->cfg->serial2;
+                    ep_38C0800->serial_number_word3 =
+                        adv_dvc_varp->cfg->serial3;
+                } else
+                {
+                    ep_38C1600 = &boardp->eep_config.adv_38C1600_eep;
+
+                    ep_38C1600->adapter_scsi_id = adv_dvc_varp->chip_scsi_id;
+                    ep_38C1600->max_host_qng = adv_dvc_varp->max_host_qng;
+                    ep_38C1600->max_dvc_qng = adv_dvc_varp->max_dvc_qng;
+                    ep_38C1600->termination_lvd =
+                        adv_dvc_varp->cfg->termination;
+                    ep_38C1600->disc_enable = adv_dvc_varp->cfg->disc_enable;
+                    ep_38C1600->bios_ctrl = adv_dvc_varp->bios_ctrl;
+                    ep_38C1600->wdtr_able = adv_dvc_varp->wdtr_able;
+                    ep_38C1600->tagqng_able = adv_dvc_varp->tagqng_able;
+                    ep_38C1600->sdtr_speed1 = adv_dvc_varp->sdtr_speed1;
+                    ep_38C1600->sdtr_speed2 = adv_dvc_varp->sdtr_speed2;
+                    ep_38C1600->sdtr_speed3 = adv_dvc_varp->sdtr_speed3;
+                    ep_38C1600->sdtr_speed4 = adv_dvc_varp->sdtr_speed4;
+                    ep_38C1600->tagqng_able = adv_dvc_varp->tagqng_able;
+                    ep_38C1600->start_motor = adv_dvc_varp->start_motor;
+                    ep_38C1600->scsi_reset_delay =
+                        adv_dvc_varp->scsi_reset_wait;
+                    ep_38C1600->serial_number_word1 =
+                        adv_dvc_varp->cfg->serial1;
+                    ep_38C1600->serial_number_word2 =
+                        adv_dvc_varp->cfg->serial2;
+                    ep_38C1600->serial_number_word3 =
+                        adv_dvc_varp->cfg->serial3;
+                }
+
+                /*
+                 * Set the adapter's target id bit in the 'init_tidmask' field.
+                 */
+                boardp->init_tidmask |=
+                    ADV_TID_TO_TIDMASK(adv_dvc_varp->chip_scsi_id);
+
+                /*
+                 * Finish initializing the 'Scsi_Host' structure.
+                 */
+                shost->irq = adv_dvc_varp->irq_no;
+            }
+
+            /*
+             * Channels are numbered beginning with 0. For AdvanSys one host
+             * structure supports one channel. Multi-channel boards have a
+             * separate host structure for each channel.
+             */
+            shost->max_channel = 0;
+            if (ASC_NARROW_BOARD(boardp)) {
+                shost->max_id = ASC_MAX_TID + 1;
+                shost->max_lun = ASC_MAX_LUN + 1;
+
+                shost->io_port = asc_dvc_varp->iop_base;
+                boardp->asc_n_io_port = ASC_IOADR_GAP;
+                shost->this_id = asc_dvc_varp->cfg->chip_scsi_id;
+
+                /* Set maximum number of queues the adapter can handle. */
+                shost->can_queue = asc_dvc_varp->max_total_qng;
+            } else {
+                shost->max_id = ADV_MAX_TID + 1;
+                shost->max_lun = ADV_MAX_LUN + 1;
+
+                /*
+                 * Save the I/O Port address and length even though
+                 * I/O ports are not used to access Wide boards.
+                 * Instead the Wide boards are accessed with
+                 * PCI Memory Mapped I/O.
+                 */
+                shost->io_port = iop;
+                boardp->asc_n_io_port = iolen;
+
+                shost->this_id = adv_dvc_varp->chip_scsi_id;
+
+                /* Set maximum number of queues the adapter can handle. */
+                shost->can_queue = adv_dvc_varp->max_host_qng;
+            }
+
+            /*
+             * 'n_io_port' currently is one byte.
+             *
+             * Set a value to 'n_io_port', but never referenced it because
+             * it may be truncated.
+             */
+            shost->n_io_port = boardp->asc_n_io_port <= 255 ?
+                boardp->asc_n_io_port : 255;
+
+            /*
+             * Following v1.3.89, 'cmd_per_lun' is no longer needed
+             * and should be set to zero.
+             *
+             * But because of a bug introduced in v1.3.89 if the driver is
+             * compiled as a module and 'cmd_per_lun' is zero, the Mid-Level
+             * SCSI function 'allocate_device' will panic. To allow the driver
+             * to work as a module in these kernels set 'cmd_per_lun' to 1.
+	     *
+	     * Note: This is wrong.  cmd_per_lun should be set to the depth
+	     * you want on untagged devices always.
+#ifdef MODULE
+             */
+            shost->cmd_per_lun = 1;
+/* #else
+            shost->cmd_per_lun = 0;
+#endif */
+
+            /*
+             * Set the maximum number of scatter-gather elements the
+             * adapter can handle.
+             */
+            if (ASC_NARROW_BOARD(boardp)) {
+                /*
+                 * Allow two commands with 'sg_tablesize' scatter-gather
+                 * elements to be executed simultaneously. This value is
+                 * the theoretical hardware limit. It may be decreased
+                 * below.
+                 */
+                shost->sg_tablesize =
+                    (((asc_dvc_varp->max_total_qng - 2) / 2) *
+                    ASC_SG_LIST_PER_Q) + 1;
+            } else {
+                shost->sg_tablesize = ADV_MAX_SG_LIST;
+            }
+
+            /*
+             * The value of 'sg_tablesize' can not exceed the SCSI
+             * mid-level driver definition of SG_ALL. SG_ALL also
+             * must not be exceeded, because it is used to define the
+             * size of the scatter-gather table in 'struct asc_sg_head'.
+             */
+            if (shost->sg_tablesize > SG_ALL) {
+                shost->sg_tablesize = SG_ALL;
+            }
+
+            ASC_DBG1(1, "advansys_detect: sg_tablesize: %d\n",
+                shost->sg_tablesize);
+
+            /* BIOS start address. */
+            if (ASC_NARROW_BOARD(boardp)) {
+                shost->base =
+                        ((ulong) AscGetChipBiosAddress(
+                            asc_dvc_varp->iop_base,
+                            asc_dvc_varp->bus_type));
+            } else {
+                /*
+                 * Fill-in BIOS board variables. The Wide BIOS saves
+                 * information in LRAM that is used by the driver.
+                 */
+                AdvReadWordLram(adv_dvc_varp->iop_base, BIOS_SIGNATURE,
+                    boardp->bios_signature);
+                AdvReadWordLram(adv_dvc_varp->iop_base, BIOS_VERSION,
+                    boardp->bios_version);
+                AdvReadWordLram(adv_dvc_varp->iop_base, BIOS_CODESEG,
+                    boardp->bios_codeseg);
+                AdvReadWordLram(adv_dvc_varp->iop_base, BIOS_CODELEN,
+                    boardp->bios_codelen);
+
+                ASC_DBG2(1,
+                    "advansys_detect: bios_signature 0x%x, bios_version 0x%x\n",
+                    boardp->bios_signature, boardp->bios_version);
+
+                ASC_DBG2(1,
+                    "advansys_detect: bios_codeseg 0x%x, bios_codelen 0x%x\n",
+                    boardp->bios_codeseg, boardp->bios_codelen);
+
+                /*
+                 * If the BIOS saved a valid signature, then fill in
+                 * the BIOS code segment base address.
+                 */
+                if (boardp->bios_signature == 0x55AA) {
+                    /*
+                     * Convert x86 realmode code segment to a linear
+                     * address by shifting left 4.
+                     */
+                    shost->base = ((ulong) boardp->bios_codeseg << 4);
+                } else {
+                    shost->base = 0;
+                }
+            }
+
+            /*
+             * Register Board Resources - I/O Port, DMA, IRQ
+             */
+
+            /*
+             * Register I/O port range.
+             *
+             * For Wide boards the I/O ports are not used to access
+             * the board, but request the region anyway.
+             *
+             * 'shost->n_io_port' is not referenced, because it may be truncated.
+             */
+            ASC_DBG2(2,
+                "advansys_detect: request_region port 0x%lx, len 0x%x\n",
+                (ulong) shost->io_port, boardp->asc_n_io_port);
+            if (request_region(shost->io_port, boardp->asc_n_io_port,
+                               "advansys") == NULL) {
+                ASC_PRINT3(
+"advansys_detect: board %d: request_region() failed, port 0x%lx, len 0x%x\n",
+                    boardp->id, (ulong) shost->io_port, boardp->asc_n_io_port);
+		err_code = -EBUSY;
+		goto err_free_proc;
+            }
+
+            /* Register DMA Channel for Narrow boards. */
+            shost->dma_channel = NO_ISA_DMA; /* Default to no ISA DMA. */
+#ifdef CONFIG_ISA
+            if (ASC_NARROW_BOARD(boardp)) {
+                /* Register DMA channel for ISA bus. */
+                if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
+                    shost->dma_channel = asc_dvc_varp->cfg->isa_dma_channel;
+                    if ((err_code =
+                         request_dma(shost->dma_channel, "advansys")) != 0) {
+                        ASC_PRINT3(
+"advansys_detect: board %d: request_dma() %d failed %d\n",
+                            boardp->id, shost->dma_channel, ret);
+                         goto err_free_region;
+                    }
+                    AscEnableIsaDma(shost->dma_channel);
+                }
+            }
+#endif /* CONFIG_ISA */
+
+            /* Register IRQ Number. */
+            ASC_DBG1(2, "advansys_detect: request_irq() %d\n", shost->irq);
+           /*
+            * If request_irq() fails with the IRQF_DISABLED flag set,
+            * then try again without the IRQF_DISABLED flag set. This
+            * allows IRQ sharing to work even with other drivers that
+            * do not set the IRQF_DISABLED flag.
+            *
+            * If IRQF_DISABLED is not set, then interrupts are enabled
+            * before the driver interrupt function is called.
+            */
+            if (((err_code = request_irq(shost->irq, advansys_interrupt,
+                            IRQF_DISABLED | (share_irq == TRUE ? IRQF_SHARED : 0),
+                            "advansys", boardp)) != 0) &&
+                ((err_code = request_irq(shost->irq, advansys_interrupt,
+                            (share_irq == TRUE ? IRQF_SHARED : 0),
+                            "advansys", boardp)) != 0))
+            {
+                if (err_code == -EBUSY) {
+                    ASC_PRINT2(
+"advansys_detect: board %d: request_irq(): IRQ 0x%x already in use.\n",
+                        boardp->id, shost->irq);
+                } else if (err_code == -EINVAL) {
+                    ASC_PRINT2(
+"advansys_detect: board %d: request_irq(): IRQ 0x%x not valid.\n",
+                        boardp->id, shost->irq);
+                } else {
+                    ASC_PRINT3(
+"advansys_detect: board %d: request_irq(): IRQ 0x%x failed with %d\n",
+                        boardp->id, shost->irq, ret);
+                }
+                goto err_free_dma;
+            }
+
+            /*
+             * Initialize board RISC chip and enable interrupts.
+             */
+            if (ASC_NARROW_BOARD(boardp)) {
+                ASC_DBG(2, "advansys_detect: AscInitAsc1000Driver()\n");
+                warn_code = AscInitAsc1000Driver(asc_dvc_varp);
+                err_code = asc_dvc_varp->err_code;
+
+                if (warn_code || err_code) {
+                    ASC_PRINT4(
+"advansys_detect: board %d error: init_state 0x%x, warn 0x%x, error 0x%x\n",
+                        boardp->id, asc_dvc_varp->init_state,
+                        warn_code, err_code);
+                }
+            } else {
+	        err_code = advansys_init_wide_chip(boardp, adv_dvc_varp);
+            }
+
+	if (err_code != 0)
+		goto err_free_irq;
+	ASC_DBG_PRT_SCSI_HOST(2, shost);
+
+	err_code = scsi_add_host(shost, pdev ? &pdev->dev : NULL);
+	if (err_code)
+		goto err_free_irq;
+
+	scsi_scan_host(shost);
+
+	return 0;
+
+ err_free_irq:
+	free_irq(shost->irq, boardp);
+
+ err_free_dma:
+	if (shost->dma_channel != NO_ISA_DMA)
+		free_dma(shost->dma_channel);
+
+ err_free_region:
+	release_region(shost->io_port, boardp->asc_n_io_port);
+
+ err_free_proc:
+	kfree(boardp->prtbuf);
+
+ err_unmap:
+	iounmap(boardp->ioremap_addr);
+
+ err_shost:
+	scsi_host_put(shost);
+	asc_board_count--;
+	return err_code;
+}
+
+/*
+ * advansys_detect()
+ *
+ * Detect function for AdvanSys adapters.
+ *
+ * Argument is a pointer to the host driver's scsi_hosts entry.
+ *
+ * Return number of adapters found.
+ *
+ * Note: Because this function is called during system initialization
+ * it must not call SCSI mid-level functions including scsi_malloc()
+ * and scsi_free().
+ */
+static int __init advansys_detect(void)
+{
+    int                 iop;
+    int                 bus;
+    int                 ioport = 0;
+
+    ASC_DBG(1, "advansys_detect: begin\n");
+
+    /*
+     * If I/O port probing has been modified, then verify and
+     * clean-up the 'asc_ioport' list.
+     */
+    if (asc_iopflag == ASC_TRUE) {
+        for (ioport = 0; ioport < ASC_NUM_IOPORT_PROBE; ioport++) {
+            ASC_DBG2(1, "advansys_detect: asc_ioport[%d] 0x%x\n",
+                ioport, asc_ioport[ioport]);
+            if (asc_ioport[ioport] != 0) {
+                for (iop = 0; iop < ASC_IOADR_TABLE_MAX_IX; iop++) {
+                    if (_asc_def_iop_base[iop] == asc_ioport[ioport]) {
+                        break;
+                    }
+                }
+                if (iop == ASC_IOADR_TABLE_MAX_IX) {
+                    printk(
+"AdvanSys SCSI: specified I/O Port 0x%X is invalid\n",
+                        asc_ioport[ioport]);
+                    asc_ioport[ioport] = 0;
+                }
+            }
+        }
+        ioport = 0;
+    }
+
+    for (bus = 0; bus < ASC_NUM_BUS; bus++) {
+
+        ASC_DBG2(1, "advansys_detect: bus search type %d (%s)\n",
+            bus, asc_bus_name[bus]);
+        iop = 0;
+
+        while (asc_board_count < ASC_NUM_BOARD_SUPPORTED) {
+
+            ASC_DBG1(2, "advansys_detect: asc_board_count %d\n",
+                asc_board_count);
+
+            switch (asc_bus[bus]) {
+            case ASC_IS_ISA:
+            case ASC_IS_VL:
+#ifdef CONFIG_ISA
+                if (asc_iopflag == ASC_FALSE) {
+                    iop = AscSearchIOPortAddr(iop, asc_bus[bus]);
+                } else {
+                    /*
+                     * ISA and VL I/O port scanning has either been
+                     * eliminated or limited to selected ports on
+                     * the LILO command line, /etc/lilo.conf, or
+                     * by setting variables when the module was loaded.
+                     */
+                    ASC_DBG(1, "advansys_detect: I/O port scanning modified\n");
+                ioport_try_again:
+                    iop = 0;
+                    for (; ioport < ASC_NUM_IOPORT_PROBE; ioport++) {
+                        if ((iop = asc_ioport[ioport]) != 0) {
+                            break;
+                        }
+                    }
+                    if (iop) {
+                        ASC_DBG1(1,
+                                "advansys_detect: probing I/O port 0x%x...\n",
+                            iop);
+			if (!request_region(iop, ASC_IOADR_GAP, "advansys")){
+                            printk(
+"AdvanSys SCSI: specified I/O Port 0x%X is busy\n", iop);
+                            /* Don't try this I/O port twice. */
+                            asc_ioport[ioport] = 0;
+                            goto ioport_try_again;
+                        } else if (AscFindSignature(iop) == ASC_FALSE) {
+                            printk(
+"AdvanSys SCSI: specified I/O Port 0x%X has no adapter\n", iop);
+                            /* Don't try this I/O port twice. */
+			    release_region(iop, ASC_IOADR_GAP);
+                            asc_ioport[ioport] = 0;
+                            goto ioport_try_again;
+                        } else {
+                            /*
+                             * If this isn't an ISA board, then it must be
+                             * a VL board. If currently looking an ISA
+                             * board is being looked for then try for
+                             * another ISA board in 'asc_ioport'.
+                             */
+                            if (asc_bus[bus] == ASC_IS_ISA &&
+                                (AscGetChipVersion(iop, ASC_IS_ISA) &
+                                 ASC_CHIP_VER_ISA_BIT) == 0) {
+                                 /*
+                                  * Don't clear 'asc_ioport[ioport]'. Try
+                                  * this board again for VL. Increment
+                                  * 'ioport' past this board.
+                                  */
+                                 ioport++;
+				 release_region(iop, ASC_IOADR_GAP);
+                                 goto ioport_try_again;
+                            }
+                        }
+                        /*
+                         * This board appears good, don't try the I/O port
+                         * again by clearing its value. Increment 'ioport'
+                         * for the next iteration.
+                         */
+                        asc_ioport[ioport++] = 0;
+                    }
+                }
+#endif /* CONFIG_ISA */
+                break;
+
+            case ASC_IS_EISA:
+#ifdef CONFIG_ISA
+                iop = AscSearchIOPortAddr(iop, asc_bus[bus]);
+#endif /* CONFIG_ISA */
+                break;
+
+            default:
+                ASC_PRINT1("advansys_detect: unknown bus type: %d\n",
+                    asc_bus[bus]);
+                break;
+            }
+            ASC_DBG1(1, "advansys_detect: iop 0x%x\n", iop);
+
+            if (iop == 0)
+		break;
+
+	    advansys_board_found(iop, NULL, asc_bus[bus]);
+        }
+    }
+
+    ASC_DBG1(1, "advansys_detect: done: asc_board_count %d\n", asc_board_count);
+    return asc_board_count;
+}
+
+/*
+ * advansys_release()
+ *
+ * Release resources allocated for a single AdvanSys adapter.
+ */
+static int
+advansys_release(struct Scsi_Host *shp)
+{
+    asc_board_t    *boardp;
+
+    ASC_DBG(1, "advansys_release: begin\n");
+    boardp = ASC_BOARDP(shp);
+    free_irq(shp->irq, boardp);
+    if (shp->dma_channel != NO_ISA_DMA) {
+        ASC_DBG(1, "advansys_release: free_dma()\n");
+        free_dma(shp->dma_channel);
+    }
+    release_region(shp->io_port, boardp->asc_n_io_port);
+    if (ASC_WIDE_BOARD(boardp)) {
+        adv_sgblk_t    *sgp = NULL;
+
+        iounmap(boardp->ioremap_addr);
+        kfree(boardp->orig_carrp);
+        boardp->orig_carrp = NULL;
+        if (boardp->orig_reqp) {
+            kfree(boardp->orig_reqp);
+            boardp->orig_reqp = boardp->adv_reqp = NULL;
+        }
+        while ((sgp = boardp->adv_sgblkp) != NULL)
+        {
+            boardp->adv_sgblkp = sgp->next_sgblkp;
+            kfree(sgp);
+        }
+    }
+#ifdef CONFIG_PROC_FS
+    ASC_ASSERT(boardp->prtbuf != NULL);
+    kfree(boardp->prtbuf);
+#endif /* CONFIG_PROC_FS */
+    scsi_host_put(shp);
+    ASC_DBG(1, "advansys_release: end\n");
+    return 0;
+}
 
 /* PCI Devices supported by this driver */
 static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
@@ -18054,7 +17976,7 @@ static int __devinit advansys_pci_probe(struct pci_dev *pdev,
 	int err, ioport;
 
 	ioport = pci_resource_start(pdev, 0);
-	err = advansys_board_found(&driver_template, ioport, pdev, ASC_IS_PCI);
+	err = advansys_board_found(ioport, pdev, ASC_IS_PCI);
 
 	return err;
 }
@@ -18098,9 +18020,10 @@ static struct pci_driver advansys_pci_driver = {
 static int __init advansys_init(void)
 {
 	int error;
+
 	error = pci_register_driver(&advansys_pci_driver);
 	if (!error)
-		advansys_detect(&driver_template);
+		advansys_detect();
 	return error;
 }
 
-- 
1.4.4.4

