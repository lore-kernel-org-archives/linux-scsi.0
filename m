From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 08/17] advansys: Sort out irq number mess
Date: Sun, 16 Sep 2007 09:37:39 -0600
Message-ID: <11899570693673-git-send-email-matthew@wil.cx>
References: <1189867145.3339.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:34358 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbXIPPhm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 11:37:42 -0400
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The interrupt number was being stored in 4-5 different places, each with
its own type, rules and usage.  Fix this by keeping an unsigned int in
the struct asc_board, and filling it in from the bus probe functions
(since it's different for each of the four bus types).  In order to do
this, we have to allocate the Scsi_Host in the bus probe functions too.
Then we can return an error from advansys_board_found, which requires
a little rearranging of code (and removing of the err_code variable).
Move the Wide Board flag setting into the PCI bus probe function.

Split the AscGetChipIRQ function into three functions (one for each bus
type that needs it) and add some commentary to explain what's going on.
Also get rid of the AscSetChipIRQ function as we only ever set the
interrupt number to the same value it already had.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  387 +++++++++++++++++++++++------------------------
 1 files changed, 189 insertions(+), 198 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index a5bb4e4..ad9639d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -461,23 +461,13 @@ typedef struct asc_risc_sg_list_q {
 /*
  * Error code values are set in ASC_DVC_VAR  'err_code'.
  */
-#define ASC_IERR_WRITE_EEPROM         0x0001
 #define ASC_IERR_MCODE_CHKSUM         0x0002
 #define ASC_IERR_SET_PC_ADDR          0x0004
 #define ASC_IERR_START_STOP_CHIP      0x0008
-#define ASC_IERR_IRQ_NO               0x0010
-#define ASC_IERR_SET_IRQ_NO           0x0020
-#define ASC_IERR_CHIP_VERSION         0x0040
 #define ASC_IERR_SET_SCSI_ID          0x0080
-#define ASC_IERR_GET_PHY_ADDR         0x0100
 #define ASC_IERR_BAD_SIGNATURE        0x0200
 #define ASC_IERR_NO_BUS_TYPE          0x0400
-#define ASC_IERR_SCAM                 0x0800
-#define ASC_IERR_SET_SDTR             0x1000
-#define ASC_IERR_RW_LRAM              0x8000
 
-#define ASC_MAX_IRQ_NO  15
-#define ASC_MIN_IRQ_NO  10
 #define ASC_DEF_MAX_TOTAL_QNG   (0xF0)
 #define ASC_MIN_TAG_Q_PER_DVC   (0x04)
 #define ASC_MIN_FREE_Q        (0x02)
@@ -605,7 +595,6 @@ typedef struct asc_dvc_var {
 	uchar max_total_qng;
 	uchar cur_total_qng;
 	uchar in_critical_cnt;
-	uchar irq_no;
 	uchar last_q_shortage;
 	ushort init_state;
 	uchar cur_dvc_qng[ASC_MAX_TID + 1];
@@ -1711,11 +1700,9 @@ typedef struct adveep_38C1600_config {
 /*
  * Error code values are set in ADV_DVC_VAR 'err_code'.
  */
-#define ASC_IERR_WRITE_EEPROM       0x0001	/* write EEPROM error */
 #define ASC_IERR_MCODE_CHKSUM       0x0002	/* micro code check sum error */
 #define ASC_IERR_NO_CARRIER         0x0004	/* No more carrier memory. */
 #define ASC_IERR_START_STOP_CHIP    0x0008	/* start/stop chip failed */
-#define ASC_IERR_CHIP_VERSION       0x0040	/* wrong chip version */
 #define ASC_IERR_SET_SCSI_ID        0x0080	/* set SCSI ID failed */
 #define ASC_IERR_HVD_DEVICE         0x0100	/* HVD attached to LVD connector. */
 #define ASC_IERR_BAD_SIGNATURE      0x0200	/* signature not found */
@@ -1919,7 +1906,6 @@ typedef struct adv_dvc_var {
 	uchar scsi_reset_wait;	/* delay in seconds after scsi bus reset */
 	uchar chip_no;		/* should be assigned by caller */
 	uchar max_host_qng;	/* maximum number of Q'ed command allowed */
-	uchar irq_no;		/* IRQ number */
 	ushort no_scam;		/* scam_tolerant of EEPROM */
 	struct asc_board *drv_ptr;	/* driver pointer to private structure */
 	uchar chip_scsi_id;	/* chip SCSI target ID */
@@ -2501,6 +2487,7 @@ typedef struct asc_board {
 	struct device *dev;
 	int id;			/* Board Id */
 	uint flags;		/* Board flags */
+	unsigned int irq;
 	union {
 		ASC_DVC_VAR asc_dvc_var;	/* Narrow board */
 		ADV_DVC_VAR adv_dvc_var;	/* Wide board */
@@ -2573,7 +2560,7 @@ static void asc_prt_scsi_host(struct Scsi_Host *s)
 	       s->host_busy, s->host_no, (unsigned)s->last_reset);
 
 	printk(" base 0x%lx, io_port 0x%lx, irq 0x%x,\n",
-	       (ulong)s->base, (ulong)s->io_port, s->irq);
+	       (ulong)s->base, (ulong)s->io_port, boardp->irq);
 
 	printk(" dma_channel %d, this_id %d, can_queue %d,\n",
 	       s->dma_channel, s->this_id, s->can_queue);
@@ -2651,7 +2638,7 @@ static void asc_prt_asc_dvc_var(ASC_DVC_VAR *h)
 	       (unsigned)h->init_state, (unsigned)h->no_scam,
 	       (unsigned)h->pci_fix_asyn_xfer);
 
-	printk(" cfg 0x%lx, irq_no 0x%x\n", (ulong)h->cfg, (unsigned)h->irq_no);
+	printk(" cfg 0x%lx\n", (ulong)h->cfg);
 }
 
 /*
@@ -2749,9 +2736,8 @@ static void asc_prt_adv_dvc_var(ADV_DVC_VAR *h)
 	       (ulong)h->isr_callback, (unsigned)h->sdtr_able,
 	       (unsigned)h->wdtr_able);
 
-	printk("  start_motor 0x%x, scsi_reset_wait 0x%x, irq_no 0x%x,\n",
-	       (unsigned)h->start_motor,
-	       (unsigned)h->scsi_reset_wait, (unsigned)h->irq_no);
+	printk("  start_motor 0x%x, scsi_reset_wait 0x%x\n",
+	       (unsigned)h->start_motor, (unsigned)h->scsi_reset_wait);
 
 	printk("  max_host_qng %u, max_dvc_qng %u, carr_freelist 0x%lxn\n",
 	       (unsigned)h->max_host_qng, (unsigned)h->max_dvc_qng,
@@ -2958,7 +2944,7 @@ static const char *advansys_info(struct Scsi_Host *shost)
 				ASC_VERSION, busname,
 				(ulong)shost->io_port,
 				(ulong)shost->io_port + ASC_IOADR_GAP - 1,
-				shost->irq, shost->dma_channel);
+				boardp->irq, shost->dma_channel);
 		} else {
 			if (asc_dvc_varp->bus_type & ASC_IS_VL) {
 				busname = "VL";
@@ -2981,7 +2967,7 @@ static const char *advansys_info(struct Scsi_Host *shost)
 				"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X",
 				ASC_VERSION, busname, (ulong)shost->io_port,
 				(ulong)shost->io_port + ASC_IOADR_GAP - 1,
-				shost->irq);
+				boardp->irq);
 		}
 	} else {
 		/*
@@ -3002,7 +2988,7 @@ static const char *advansys_info(struct Scsi_Host *shost)
 		sprintf(info,
 			"AdvanSys SCSI %s: PCI %s: PCIMEM 0x%lX-0x%lX, IRQ 0x%X",
 			ASC_VERSION, widename, (ulong)adv_dvc_varp->iop_base,
-			(ulong)adv_dvc_varp->iop_base + boardp->asc_n_io_port - 1, shost->irq);
+			(ulong)adv_dvc_varp->iop_base + boardp->asc_n_io_port - 1, boardp->irq);
 	}
 	BUG_ON(strlen(info) >= ASC_INFO_SIZE);
 	ASC_DBG(1, "advansys_info: end\n");
@@ -11479,77 +11465,6 @@ AscGetChipVersion(PortAddr iop_base, unsigned short bus_type)
 	return AscGetChipVerNo(iop_base);
 }
 
-static void __devinit AscToggleIRQAct(PortAddr iop_base)
-{
-	AscSetChipStatus(iop_base, CIW_IRQ_ACT);
-	AscSetChipStatus(iop_base, 0);
-	return;
-}
-
-static uchar __devinit AscGetChipIRQ(PortAddr iop_base, ushort bus_type)
-{
-	ushort cfg_lsw;
-	uchar chip_irq;
-
-	if ((bus_type & ASC_IS_EISA) != 0) {
-		cfg_lsw = AscGetEisaChipCfg(iop_base);
-		chip_irq = (uchar)(((cfg_lsw >> 8) & 0x07) + 10);
-		if ((chip_irq == 13) || (chip_irq > 15)) {
-			return (0);
-		}
-		return (chip_irq);
-	}
-	if ((bus_type & ASC_IS_VL) != 0) {
-		cfg_lsw = AscGetChipCfgLsw(iop_base);
-		chip_irq = (uchar)(((cfg_lsw >> 2) & 0x07));
-		if ((chip_irq == 0) || (chip_irq == 4) || (chip_irq == 7)) {
-			return (0);
-		}
-		return ((uchar)(chip_irq + (ASC_MIN_IRQ_NO - 1)));
-	}
-	cfg_lsw = AscGetChipCfgLsw(iop_base);
-	chip_irq = (uchar)(((cfg_lsw >> 2) & 0x03));
-	if (chip_irq == 3)
-		chip_irq += (uchar)2;
-	return ((uchar)(chip_irq + ASC_MIN_IRQ_NO));
-}
-
-static uchar __devinit
-AscSetChipIRQ(PortAddr iop_base, uchar irq_no, ushort bus_type)
-{
-	ushort cfg_lsw;
-
-	if ((bus_type & ASC_IS_VL) != 0) {
-		if (irq_no != 0) {
-			if ((irq_no < ASC_MIN_IRQ_NO)
-			    || (irq_no > ASC_MAX_IRQ_NO)) {
-				irq_no = 0;
-			} else {
-				irq_no -= (uchar)((ASC_MIN_IRQ_NO - 1));
-			}
-		}
-		cfg_lsw = (ushort)(AscGetChipCfgLsw(iop_base) & 0xFFE3);
-		cfg_lsw |= (ushort)0x0010;
-		AscSetChipCfgLsw(iop_base, cfg_lsw);
-		AscToggleIRQAct(iop_base);
-		cfg_lsw = (ushort)(AscGetChipCfgLsw(iop_base) & 0xFFE0);
-		cfg_lsw |= (ushort)((irq_no & 0x07) << 2);
-		AscSetChipCfgLsw(iop_base, cfg_lsw);
-		AscToggleIRQAct(iop_base);
-		return (AscGetChipIRQ(iop_base, bus_type));
-	}
-	if ((bus_type & (ASC_IS_ISA)) != 0) {
-		if (irq_no == 15)
-			irq_no -= (uchar)2;
-		irq_no -= (uchar)ASC_MIN_IRQ_NO;
-		cfg_lsw = (ushort)(AscGetChipCfgLsw(iop_base) & 0xFFF3);
-		cfg_lsw |= (ushort)((irq_no & 0x03) << 2);
-		AscSetChipCfgLsw(iop_base, cfg_lsw);
-		return (AscGetChipIRQ(iop_base, bus_type));
-	}
-	return (0);
-}
-
 #ifdef CONFIG_ISA
 static void __devinit AscEnableIsaDma(uchar dma_channel)
 {
@@ -12157,9 +12072,6 @@ static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 		eep_config->disc_enable = eep_config->use_cmd_qng;
 		warn_code |= ASC_WARN_CMD_QNG_CONFLICT;
 	}
-	if (asc_dvc->bus_type & (ASC_IS_ISA | ASC_IS_VL | ASC_IS_EISA)) {
-		asc_dvc->irq_no = AscGetChipIRQ(iop_base, asc_dvc->bus_type);
-	}
 	ASC_EEP_SET_CHIP_ID(eep_config,
 			    ASC_EEP_GET_CHIP_ID(eep_config) & ASC_MAX_TID);
 	asc_dvc->cfg->chip_scsi_id = ASC_EEP_GET_CHIP_ID(eep_config);
@@ -12276,12 +12188,6 @@ static int __devinit AscInitSetConfig(struct pci_dev *pdev, asc_board_t *boardp)
 	if (AscGetChipStatus(iop_base) & CSW_AUTO_CONFIG) {
 		warn_code |= ASC_WARN_AUTO_CONFIG;
 	}
-	if ((asc_dvc->bus_type & (ASC_IS_ISA | ASC_IS_VL)) != 0) {
-		if (AscSetChipIRQ(iop_base, asc_dvc->irq_no, asc_dvc->bus_type)
-		    != asc_dvc->irq_no) {
-			asc_dvc->err_code |= ASC_IERR_SET_IRQ_NO;
-		}
-	}
 #ifdef CONFIG_PCI
 	if (asc_dvc->bus_type & ASC_IS_PCI) {
 		cfg_msw &= 0xFFC0;
@@ -13879,49 +13785,19 @@ static void advansys_wide_free_mem(asc_board_t *boardp)
 	}
 }
 
-static struct Scsi_Host *__devinit
-advansys_board_found(int iop, struct device *dev, int bus_type)
+static int __devinit advansys_board_found(struct Scsi_Host *shost,
+					  unsigned int iop, int bus_type)
 {
-	struct Scsi_Host *shost;
-	struct pci_dev *pdev = bus_type == ASC_IS_PCI ? to_pci_dev(dev) : NULL;
+	struct pci_dev *pdev;
 	asc_board_t *boardp;
 	ASC_DVC_VAR *asc_dvc_varp = NULL;
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
-	int share_irq;
-	int warn_code, err_code;
-	int ret;
-
-	/*
-	 * Register the adapter, get its configuration, and
-	 * initialize it.
-	 */
-	ASC_DBG(2, "advansys_board_found: scsi_host_alloc()\n");
-	shost = scsi_host_alloc(&advansys_template, sizeof(asc_board_t));
-	if (!shost)
-		return NULL;
+	int share_irq, warn_code, ret;
 
-	/* Initialize private per board data */
 	boardp = ASC_BOARDP(shost);
-	memset(boardp, 0, sizeof(asc_board_t));
 	boardp->id = asc_board_count++;
 	spin_lock_init(&boardp->lock);
-	boardp->dev = dev;
-
-	/*
-	 * Handle both narrow and wide boards.
-	 *
-	 * If a Wide board was detected, set the board structure
-	 * wide board flag. Set-up the board structure based on
-	 * the board type.
-	 */
-#ifdef CONFIG_PCI
-	if (bus_type == ASC_IS_PCI &&
-	    (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW ||
-	     pdev->device == PCI_DEVICE_ID_38C0800_REV1 ||
-	     pdev->device == PCI_DEVICE_ID_38C1600_REV1)) {
-		boardp->flags |= ASC_IS_WIDE_BOARD;
-	}
-#endif /* CONFIG_PCI */
+	pdev = (bus_type == ASC_IS_PCI) ? to_pci_dev(boardp->dev) : NULL;
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		ASC_DBG(1, "advansys_board_found: narrow board\n");
@@ -13956,6 +13832,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 			    ("advansys_board_found: board %d: ioremap(%x, %d) returned NULL\n",
 			     boardp->id, pci_resource_start(pdev, 1),
 			     boardp->asc_n_io_port);
+			ret = -ENODEV;
 			goto err_shost;
 		}
 		adv_dvc_varp->iop_base = (AdvPortAddr)boardp->ioremap_addr
@@ -13984,6 +13861,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	if (!boardp->prtbuf) {
 		ASC_PRINT2("advansys_board_found: board %d: kmalloc(%d) "
 			   "returned NULL\n", boardp->id, ASC_PRTBUF_SIZE);
+		ret = -ENOMEM;
 		goto err_unmap;
 	}
 #endif /* CONFIG_PROC_FS */
@@ -14010,7 +13888,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 #endif /* CONFIG_ISA */
 #ifdef CONFIG_PCI
 		case ASC_IS_PCI:
-			shost->irq = asc_dvc_varp->irq_no = pdev->irq;
 			shost->unchecked_isa_dma = FALSE;
 			share_irq = IRQF_SHARED;
 			break;
@@ -14031,23 +13908,22 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		 * referenced only use the bit-wise AND operator "&".
 		 */
 		ASC_DBG(2, "advansys_board_found: AscInitGetConfig()\n");
-		err_code = AscInitGetConfig(boardp);
+		ret = AscInitGetConfig(boardp) ? -ENODEV : 0;
 	} else {
 #ifdef CONFIG_PCI
 		/*
 		 * For Wide boards set PCI information before calling
 		 * AdvInitGetConfig().
 		 */
-		shost->irq = adv_dvc_varp->irq_no = pdev->irq;
 		shost->unchecked_isa_dma = FALSE;
 		share_irq = IRQF_SHARED;
 		ASC_DBG(2, "advansys_board_found: AdvInitGetConfig()\n");
 
-		err_code = AdvInitGetConfig(pdev, boardp);
+		ret = AdvInitGetConfig(pdev, boardp) ? -ENODEV : 0;
 #endif /* CONFIG_PCI */
 	}
 
-	if (err_code != 0)
+	if (ret)
 		goto err_free_proc;
 
 	/*
@@ -14091,17 +13967,9 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		 * Modify board configuration.
 		 */
 		ASC_DBG(2, "advansys_board_found: AscInitSetConfig()\n");
-		err_code = AscInitSetConfig(pdev, boardp);
-		if (err_code)
+		ret = AscInitSetConfig(pdev, boardp) ? -ENODEV : 0;
+		if (ret)
 			goto err_free_proc;
-
-		/*
-		 * Finish initializing the 'Scsi_Host' structure.
-		 */
-		/* AscInitSetConfig() will set the IRQ for non-PCI boards. */
-		if ((asc_dvc_varp->bus_type & ASC_IS_PCI) == 0) {
-			shost->irq = asc_dvc_varp->irq_no;
-		}
 	} else {
 		ADVEEP_3550_CONFIG *ep_3550;
 		ADVEEP_38C0800_CONFIG *ep_38C0800;
@@ -14346,24 +14214,24 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 #endif /* CONFIG_ISA */
 
 	/* Register IRQ Number. */
-	ASC_DBG1(2, "advansys_board_found: request_irq() %d\n", shost->irq);
+	ASC_DBG1(2, "advansys_board_found: request_irq() %d\n", boardp->irq);
 
-	ret = request_irq(shost->irq, advansys_interrupt, share_irq,
+	ret = request_irq(boardp->irq, advansys_interrupt, share_irq,
 			  DRV_NAME, shost);
 
 	if (ret) {
 		if (ret == -EBUSY) {
 			ASC_PRINT2
 			    ("advansys_board_found: board %d: request_irq(): IRQ 0x%x already in use.\n",
-			     boardp->id, shost->irq);
+			     boardp->id, boardp->irq);
 		} else if (ret == -EINVAL) {
 			ASC_PRINT2
 			    ("advansys_board_found: board %d: request_irq(): IRQ 0x%x not valid.\n",
-			     boardp->id, shost->irq);
+			     boardp->id, boardp->irq);
 		} else {
 			ASC_PRINT3
 			    ("advansys_board_found: board %d: request_irq(): IRQ 0x%x failed with %d\n",
-			     boardp->id, shost->irq, ret);
+			     boardp->id, boardp->irq, ret);
 		}
 		goto err_free_dma;
 	}
@@ -14374,33 +14242,35 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	if (ASC_NARROW_BOARD(boardp)) {
 		ASC_DBG(2, "advansys_board_found: AscInitAsc1000Driver()\n");
 		warn_code = AscInitAsc1000Driver(asc_dvc_varp);
-		err_code = asc_dvc_varp->err_code;
 
-		if (warn_code || err_code) {
-			ASC_PRINT4
-			    ("advansys_board_found: board %d error: init_state 0x%x, warn 0x%x, error 0x%x\n",
-			     boardp->id,
-			     asc_dvc_varp->init_state, warn_code, err_code);
+		if (warn_code || asc_dvc_varp->err_code) {
+			ASC_PRINT4("advansys_board_found: board %d error: "
+				   "init_state 0x%x, warn 0x%x, error 0x%x\n",
+				   boardp->id, asc_dvc_varp->init_state,
+		 		   warn_code, asc_dvc_varp->err_code);
+			if (asc_dvc_varp->err_code)
+				ret = -ENODEV;
 		}
 	} else {
-		err_code = advansys_wide_init_chip(boardp, adv_dvc_varp);
+		if (advansys_wide_init_chip(boardp, adv_dvc_varp))
+			ret = -ENODEV;
 	}
 
-	if (err_code != 0)
+	if (ret)
 		goto err_free_wide_mem;
 
 	ASC_DBG_PRT_SCSI_HOST(2, shost);
 
-	ret = scsi_add_host(shost, dev);
+	ret = scsi_add_host(shost, boardp->dev);
 	if (ret)
 		goto err_free_wide_mem;
 
 	scsi_scan_host(shost);
-	return shost;
+	return 0;
 
  err_free_wide_mem:
 	advansys_wide_free_mem(boardp);
-	free_irq(shost->irq, shost);
+	free_irq(boardp->irq, shost);
  err_free_dma:
 	if (shost->dma_channel != NO_ISA_DMA)
 		free_dma(shost->dma_channel);
@@ -14410,8 +14280,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	if (boardp->ioremap_addr)
 		iounmap(boardp->ioremap_addr);
  err_shost:
-	scsi_host_put(shost);
-	return NULL;
+	return ret;
 }
 
 /*
@@ -14426,7 +14295,7 @@ static int advansys_release(struct Scsi_Host *shost)
 	ASC_DBG(1, "advansys_release: begin\n");
 	scsi_remove_host(shost);
 	boardp = ASC_BOARDP(shost);
-	free_irq(shost->irq, shost);
+	free_irq(boardp->irq, shost);
 	if (shost->dma_channel != NO_ISA_DMA) {
 		ASC_DBG(1, "advansys_release: free_dma()\n");
 		free_dma(shost->dma_channel);
@@ -14448,10 +14317,28 @@ static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __devinitdata = {
 	0x0210, 0x0230, 0x0250, 0x0330
 };
 
+/*
+ * The ISA IRQ number is found in bits 2 and 3 of the CfgLsw.  It decodes as:
+ * 00: 10
+ * 01: 11
+ * 10: 12
+ * 11: 15
+ */
+static unsigned int __devinit advansys_isa_irq_no(PortAddr iop_base)
+{
+	unsigned short cfg_lsw = AscGetChipCfgLsw(iop_base);
+	unsigned int chip_irq = ((cfg_lsw >> 2) & 0x03) + 10;
+	if (chip_irq == 13)
+		chip_irq = 15;
+	return chip_irq;
+}
+
 static int __devinit advansys_isa_probe(struct device *dev, unsigned int id)
 {
+	int err = -ENODEV;
 	PortAddr iop_base = _asc_def_iop_base[id];
 	struct Scsi_Host *shost;
+	struct asc_board *board;
 
 	if (!request_region(iop_base, ASC_IOADR_GAP, DRV_NAME)) {
 		ASC_DBG1(1, "advansys_isa_match: I/O port 0x%x busy\n",
@@ -14460,20 +14347,31 @@ static int __devinit advansys_isa_probe(struct device *dev, unsigned int id)
 	}
 	ASC_DBG1(1, "advansys_isa_match: probing I/O port 0x%x\n", iop_base);
 	if (!AscFindSignature(iop_base))
-		goto nodev;
+		goto release_region;
 	if (!(AscGetChipVersion(iop_base, ASC_IS_ISA) & ASC_CHIP_VER_ISA_BIT))
-		goto nodev;
+		goto release_region;
 
-	shost = advansys_board_found(iop_base, dev, ASC_IS_ISA);
+	err = -ENOMEM;
+	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
 	if (!shost)
-		goto nodev;
+		goto release_region;
+
+	board = ASC_BOARDP(shost);
+	board->irq = advansys_isa_irq_no(iop_base);
+	board->dev = dev;
+
+	err = advansys_board_found(shost, iop_base, ASC_IS_ISA);
+	if (err)
+		goto free_host;
 
 	dev_set_drvdata(dev, shost);
 	return 0;
 
- nodev:
+ free_host:
+	scsi_host_put(shost);
+ release_region:
 	release_region(iop_base, ASC_IOADR_GAP);
-	return -ENODEV;
+	return err;
 }
 
 static int __devexit advansys_isa_remove(struct device *dev, unsigned int id)
@@ -14493,10 +14391,32 @@ static struct isa_driver advansys_isa_driver = {
 	},
 };
 
+/*
+ * The VLB IRQ number is found in bits 2 to 4 of the CfgLsw.  It decodes as:
+ * 000: invalid
+ * 001: 10
+ * 010: 11
+ * 011: 12
+ * 100: invalid
+ * 101: 14
+ * 110: 15
+ * 111: invalid
+ */
+static unsigned int __devinit advansys_vlb_irq_no(PortAddr iop_base)
+{
+	unsigned short cfg_lsw = AscGetChipCfgLsw(iop_base);
+	unsigned int chip_irq = ((cfg_lsw >> 2) & 0x07) + 9;
+	if ((chip_irq < 10) || (chip_irq == 13) || (chip_irq > 15))
+		return 0;
+	return chip_irq;
+}
+
 static int __devinit advansys_vlb_probe(struct device *dev, unsigned int id)
 {
+	int err = -ENODEV;
 	PortAddr iop_base = _asc_def_iop_base[id];
 	struct Scsi_Host *shost;
+	struct asc_board *board;
 
 	if (!request_region(iop_base, ASC_IOADR_GAP, DRV_NAME)) {
 		ASC_DBG1(1, "advansys_vlb_match: I/O port 0x%x busy\n",
@@ -14505,23 +14425,34 @@ static int __devinit advansys_vlb_probe(struct device *dev, unsigned int id)
 	}
 	ASC_DBG1(1, "advansys_vlb_match: probing I/O port 0x%x\n", iop_base);
 	if (!AscFindSignature(iop_base))
-		goto nodev;
+		goto release_region;
 	/*
 	 * I don't think this condition can actually happen, but the old
 	 * driver did it, and the chances of finding a VLB setup in 2007
 	 * to do testing with is slight to none.
 	 */
 	if (AscGetChipVersion(iop_base, ASC_IS_VL) > ASC_CHIP_MAX_VER_VL)
-		goto nodev;
+		goto release_region;
 
-	shost = advansys_board_found(iop_base, dev, ASC_IS_VL);
+	err = -ENOMEM;
+	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
 	if (!shost)
-		goto nodev;
+		goto release_region;
+
+	board = ASC_BOARDP(shost);
+	board->irq = advansys_vlb_irq_no(iop_base);
+	board->dev = dev;
+
+	err = advansys_board_found(shost, iop_base, ASC_IS_VL);
+	if (err)
+		goto free_host;
 
 	dev_set_drvdata(dev, shost);
 	return 0;
 
- nodev:
+ free_host:
+	scsi_host_put(shost);
+ release_region:
 	release_region(iop_base, ASC_IOADR_GAP);
 	return -ENODEV;
 }
@@ -14551,9 +14482,29 @@ struct eisa_scsi_data {
 	struct Scsi_Host *host[2];
 };
 
+/*
+ * The EISA IRQ number is found in bits 8 to 10 of the CfgLsw.  It decodes as:
+ * 000: 10
+ * 001: 11
+ * 010: 12
+ * 011: invalid
+ * 100: 14
+ * 101: 15
+ * 110: invalid
+ * 111: invalid
+ */
+static unsigned int __devinit advansys_eisa_irq_no(struct eisa_device *edev)
+{
+	unsigned short cfg_lsw = inw(edev->base_addr + 0xc86);
+	unsigned int chip_irq = ((cfg_lsw >> 8) & 0x07) + 10;
+	if ((chip_irq == 13) || (chip_irq > 15))
+		return 0;
+	return chip_irq;
+}
+
 static int __devinit advansys_eisa_probe(struct device *dev)
 {
-	int i, ioport;
+	int i, ioport, irq = 0;
 	int err;
 	struct eisa_device *edev = to_eisa_device(dev);
 	struct eisa_scsi_data *data;
@@ -14566,6 +14517,8 @@ static int __devinit advansys_eisa_probe(struct device *dev)
 
 	err = -ENODEV;
 	for (i = 0; i < 2; i++, ioport += 0x20) {
+		struct asc_board *board;
+		struct Scsi_Host *shost;
 		if (!request_region(ioport, ASC_IOADR_GAP, DRV_NAME)) {
 			printk(KERN_WARNING "Region %x-%x busy\n", ioport,
 			       ioport + ASC_IOADR_GAP - 1);
@@ -14584,20 +14537,40 @@ static int __devinit advansys_eisa_probe(struct device *dev)
 		 * test with.
 		 */
 		inw(ioport + 4);
-		data->host[i] = advansys_board_found(ioport, dev, ASC_IS_EISA);
-		if (data->host[i]) {
-			err = 0;
-		} else {
-			release_region(ioport, ASC_IOADR_GAP);
+
+		if (!irq)
+			irq = advansys_eisa_irq_no(edev);
+
+		err = -ENOMEM;
+		shost = scsi_host_alloc(&advansys_template, sizeof(*board));
+		if (!shost)
+			goto release_region;
+
+		board = ASC_BOARDP(shost);
+		board->irq = irq;
+		board->dev = dev;
+
+		err = advansys_board_found(shost, ioport, ASC_IS_EISA);
+		if (!err) {
+			data->host[i] = shost;
+			continue;
 		}
-	}
 
-	if (err) {
-		kfree(data);
-	} else {
-		dev_set_drvdata(dev, data);
+		scsi_host_put(shost);
+ release_region:
+		release_region(ioport, ASC_IOADR_GAP);
+		break;
 	}
 
+	if (err)
+		goto free_data;
+	dev_set_drvdata(dev, data);
+	return 0;
+
+ free_data:
+	kfree(data->host[0]);
+	kfree(data->host[1]);
+	kfree(data);
  fail:
 	return err;
 }
@@ -14667,6 +14640,7 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err, ioport;
 	struct Scsi_Host *shost;
+	struct asc_board *board;
 
 	err = pci_enable_device(pdev);
 	if (err)
@@ -14677,20 +14651,37 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_master(pdev);
 	advansys_set_latency(pdev);
 
+	err = -ENODEV;
 	if (pci_resource_len(pdev, 0) == 0)
-		goto nodev;
+		goto release_region;
 
 	ioport = pci_resource_start(pdev, 0);
-	shost = advansys_board_found(ioport, &pdev->dev, ASC_IS_PCI);
 
+	err = -ENOMEM;
+	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
 	if (!shost)
-		goto nodev;
+		goto release_region;
+
+	board = ASC_BOARDP(shost);
+	board->irq = pdev->irq;
+	board->dev = &pdev->dev;
+
+	if (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW ||
+	    pdev->device == PCI_DEVICE_ID_38C0800_REV1 ||
+	    pdev->device == PCI_DEVICE_ID_38C1600_REV1) {
+		board->flags |= ASC_IS_WIDE_BOARD;
+	}
+
+	err = advansys_board_found(shost, ioport, ASC_IS_PCI);
+	if (err)
+		goto free_host;
 
 	pci_set_drvdata(pdev, shost);
 	return 0;
 
- nodev:
-	err = -ENODEV;
+ free_host:
+	scsi_host_put(shost);
+ release_region:
 	pci_release_regions(pdev);
  disable_device:
 	pci_disable_device(pdev);
-- 
1.5.2.4

