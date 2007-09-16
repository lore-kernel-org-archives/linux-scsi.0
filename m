From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 14/17] advansys: Get rid of board index number
Date: Sun, 16 Sep 2007 09:37:45 -0600
Message-ID: <11899570691226-git-send-email-matthew@wil.cx>
References: <1189867145.3339.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:52643 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbXIPPhk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 11:37:40 -0400
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

It's always a mistake to have your own index of boards; just use the
scsi host number.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  236 ++++++++++++++++++++---------------------------
 1 files changed, 100 insertions(+), 136 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index b652032..798545d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -66,8 +66,7 @@
  *  5. check DMA mapping functions for failure
  *  6. Use scsi_transport_spi
  *  7. advansys_info is not safe against multiple simultaneous callers
- *  8. Kill boardp->id
- *  9. Add module_param to override ISA/VLB ioport array
+ *  8. Add module_param to override ISA/VLB ioport array
  */
 #warning this driver is still not properly converted to the DMA API
 
@@ -2416,7 +2415,6 @@ typedef struct adv_req {
  */
 struct asc_board {
 	struct device *dev;
-	int id;			/* Board Id */
 	uint flags;		/* Board flags */
 	unsigned int irq;
 	union {
@@ -2467,9 +2465,6 @@ struct asc_board {
 							dvc_var.adv_dvc_var)
 #define adv_dvc_to_pdev(adv_dvc) to_pci_dev(adv_dvc_to_board(adv_dvc)->dev)
 
-/* Number of boards detected in system. */
-static int asc_board_count;
-
 /* Overrun buffer used by all narrow boards. */
 static uchar overrun_buf[ASC_OVERRUN_BSIZE] = { 0 };
 
@@ -2848,9 +2843,8 @@ static const char *advansys_info(struct Scsi_Host *shost)
 				}
 			} else {
 				busname = "?";
-				ASC_PRINT2("advansys_info: board %d: unknown "
-					   "bus type %d\n", boardp->id,
-					   asc_dvc_varp->bus_type);
+				shost_printk(KERN_ERR, shost, "unknown bus "
+					"type %d\n", asc_dvc_varp->bus_type);
 			}
 			sprintf(info,
 				"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X",
@@ -4382,7 +4376,6 @@ static void AscSetBank(PortAddr iop_base, uchar bank)
 		val &= ~CC_BANK_ONE;
 	}
 	AscSetChipControl(iop_base, val);
-	return;
 }
 
 static void AscSetChipIH(PortAddr iop_base, ushort ins_code)
@@ -4390,7 +4383,6 @@ static void AscSetChipIH(PortAddr iop_base, ushort ins_code)
 	AscSetBank(iop_base, 1);
 	AscWriteChipIH(iop_base, ins_code);
 	AscSetBank(iop_base, 0);
-	return;
 }
 
 static int AscStartChip(PortAddr iop_base)
@@ -4475,7 +4467,6 @@ static void AscEnableInterrupt(PortAddr iop_base)
 
 	cfg = AscGetChipCfgLsw(iop_base);
 	AscSetChipCfgLsw(iop_base, cfg | ASC_CFG0_HOST_INT_ON);
-	return;
 }
 
 static void AscDisableInterrupt(PortAddr iop_base)
@@ -4484,7 +4475,6 @@ static void AscDisableInterrupt(PortAddr iop_base)
 
 	cfg = AscGetChipCfgLsw(iop_base);
 	AscSetChipCfgLsw(iop_base, cfg & (~ASC_CFG0_HOST_INT_ON));
-	return;
 }
 
 static uchar AscReadLramByte(PortAddr iop_base, ushort addr)
@@ -4542,7 +4532,6 @@ static void AscWriteLramWord(PortAddr iop_base, ushort addr, ushort word_val)
 {
 	AscSetChipLramAddr(iop_base, addr);
 	AscSetChipLramData(iop_base, word_val);
-	return;
 }
 
 static void AscWriteLramByte(PortAddr iop_base, ushort addr, uchar byte_val)
@@ -4560,7 +4549,6 @@ static void AscWriteLramByte(PortAddr iop_base, ushort addr, uchar byte_val)
 		word_data |= ((ushort)byte_val & 0x00FF);
 	}
 	AscWriteLramWord(iop_base, addr, word_data);
-	return;
 }
 
 /*
@@ -4588,7 +4576,6 @@ AscMemWordCopyPtrToLram(PortAddr iop_base,
 		outpw(iop_base + IOP_RAM_DATA,
 		      ((ushort)s_buffer[i + 1] << 8) | s_buffer[i]);
 	}
-	return;
 }
 
 /*
@@ -4608,7 +4595,6 @@ AscMemDWordCopyPtrToLram(PortAddr iop_base,
 		outpw(iop_base + IOP_RAM_DATA, ((ushort)s_buffer[i + 1] << 8) | s_buffer[i]);	/* LSW */
 		outpw(iop_base + IOP_RAM_DATA, ((ushort)s_buffer[i + 3] << 8) | s_buffer[i + 2]);	/* MSW */
 	}
-	return;
 }
 
 /*
@@ -4630,7 +4616,6 @@ AscMemWordCopyPtrFromLram(PortAddr iop_base,
 		d_buffer[i] = word & 0xff;
 		d_buffer[i + 1] = (word >> 8) & 0xff;
 	}
-	return;
 }
 
 static ASC_DCNT AscMemSumLramWord(PortAddr iop_base, ushort s_addr, int words)
@@ -8397,8 +8382,6 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	boardp->adv_reqp = reqp;
 
 	ASC_DBG(1, "done\n");
-
-	return;
 }
 
 /*
@@ -8569,7 +8552,6 @@ static void AscAckInterrupt(PortAddr iop_base)
 		}
 	}
 	AscWriteLramByte(iop_base, ASCV_HOST_FLAG_B, host_flag);
-	return;
 }
 
 static uchar AscGetSynPeriodIndex(ASC_DVC_VAR *asc_dvc, uchar syn_time)
@@ -9325,8 +9307,6 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	}
 
 	asc_scsi_done(scp);
-
-	return;
 }
 
 static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
@@ -10055,9 +10035,9 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 				    scp->sc_data_direction);
 
 		if (use_sg > scp->device->host->sg_tablesize) {
-			ASC_PRINT3("asc_build_req: board %d: use_sg %d > "
-				   "sg_tablesize %d\n", boardp->id, use_sg,
-				   scp->device->host->sg_tablesize);
+			scmd_printk(KERN_ERR, scp, "use_sg %d > "
+				"sg_tablesize %d\n", use_sg,
+				scp->device->host->sg_tablesize);
 			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
 				     scp->sc_data_direction);
 			scp->result = HOST_BYTE(DID_ERROR);
@@ -10332,8 +10312,8 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 				    scp->sc_data_direction);
 
 		if (use_sg > ADV_MAX_SG_LIST) {
-			ASC_PRINT3("adv_build_req: board %d: use_sg %d > "
-				   "ADV_MAX_SG_LIST %d\n", boardp->id, use_sg,
+			scmd_printk(KERN_ERR, scp, "use_sg %d > "
+				   "ADV_MAX_SG_LIST %d\n", use_sg,
 				   scp->device->host->sg_tablesize);
 			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
 				     scp->sc_data_direction);
@@ -11174,14 +11154,14 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 		ASC_STATS(scp->device->host, exe_busy);
 		break;
 	case ASC_ERROR:
-		ASC_PRINT2("asc_execute_scsi_cmnd: board %d: ExeScsiQueue() "
-			   "ASC_ERROR, err_code 0x%x\n", boardp->id, err_code);
+		scmd_printk(KERN_ERR, scp, "ExeScsiQueue() ASC_ERROR, "
+			"err_code 0x%x\n", err_code);
 		ASC_STATS(scp->device->host, exe_error);
 		scp->result = HOST_BYTE(DID_ERROR);
 		break;
 	default:
-		ASC_PRINT2("asc_execute_scsi_cmnd: board %d: ExeScsiQueue() "
-			   "unknown, err_code 0x%x\n", boardp->id, err_code);
+		scmd_printk(KERN_ERR, scp, "ExeScsiQueue() unknown, "
+			"err_code 0x%x\n", err_code);
 		ASC_STATS(scp->device->host, exe_unknown);
 		scp->result = HOST_BYTE(DID_ERROR);
 		break;
@@ -11314,7 +11294,6 @@ static void __devinit AscEnableIsaDma(uchar dma_channel)
 		outp(0x00D6, (ushort)(0xC0 | (dma_channel - 4)));
 		outp(0x00D4, (ushort)(dma_channel - 4));
 	}
-	return;
 }
 #endif /* CONFIG_ISA */
 
@@ -11613,7 +11592,6 @@ static int __devinit AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
 static void __devinit AscWaitEEPWrite(void)
 {
 	mdelay(20);
-	return;
 }
 
 static int __devinit AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
@@ -11936,9 +11914,10 @@ static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static int __devinit AscInitGetConfig(struct asc_board *boardp)
+static int __devinit AscInitGetConfig(struct Scsi_Host *shost)
 {
-	ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
+	struct asc_board *board = shost_priv(shost);
+	ASC_DVC_VAR *asc_dvc = &board->dvc_var.asc_dvc_var;
 	unsigned short warn_code = 0;
 
 	asc_dvc->init_state = ASC_INIT_STATE_BEG_GET_CFG;
@@ -11959,43 +11938,40 @@ static int __devinit AscInitGetConfig(struct asc_board *boardp)
 	case 0:	/* No error */
 		break;
 	case ASC_WARN_IO_PORT_ROTATE:
-		ASC_PRINT1("AscInitGetConfig: board %d: I/O port address "
-			   "modified\n", boardp->id);
+		shost_printk(KERN_WARNING, shost, "I/O port address "
+				"modified\n");
 		break;
 	case ASC_WARN_AUTO_CONFIG:
-		ASC_PRINT1("AscInitGetConfig: board %d: I/O port increment "
-			   "switch enabled\n", boardp->id);
+		shost_printk(KERN_WARNING, shost, "I/O port increment switch "
+				"enabled\n");
 		break;
 	case ASC_WARN_EEPROM_CHKSUM:
-		ASC_PRINT1("AscInitGetConfig: board %d: EEPROM checksum "
-			   "error\n", boardp->id);
+		shost_printk(KERN_WARNING, shost, "EEPROM checksum error\n");
 		break;
 	case ASC_WARN_IRQ_MODIFIED:
-		ASC_PRINT1("AscInitGetConfig: board %d: IRQ modified\n",
-			   boardp->id);
+		shost_printk(KERN_WARNING, shost, "IRQ modified\n");
 		break;
 	case ASC_WARN_CMD_QNG_CONFLICT:
-		ASC_PRINT1("AscInitGetConfig: board %d: tag queuing enabled "
-			   "w/o disconnects\n", boardp->id);
+		shost_printk(KERN_WARNING, shost, "tag queuing enabled w/o "
+				"disconnects\n");
 		break;
 	default:
-		ASC_PRINT2("AscInitGetConfig: board %d: unknown warning: "
-			   "0x%x\n", boardp->id, warn_code);
+		shost_printk(KERN_WARNING, shost, "unknown warning: 0x%x\n",
+				warn_code);
 		break;
 	}
 
-	if (asc_dvc->err_code != 0) {
-		ASC_PRINT3("AscInitGetConfig: board %d error: init_state 0x%x, "
-			   "err_code 0x%x\n", boardp->id, asc_dvc->init_state,
-			   asc_dvc->err_code);
-	}
+	if (asc_dvc->err_code != 0)
+		shost_printk(KERN_ERR, shost, "error 0x%x at init_state "
+			"0x%x\n", asc_dvc->err_code, asc_dvc->init_state);
 
 	return asc_dvc->err_code;
 }
 
-static int __devinit AscInitSetConfig(struct pci_dev *pdev, struct asc_board *boardp)
+static int __devinit AscInitSetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 {
-	ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
+	struct asc_board *board = shost_priv(shost);
+	ASC_DVC_VAR *asc_dvc = &board->dvc_var.asc_dvc_var;
 	PortAddr iop_base = asc_dvc->iop_base;
 	unsigned short cfg_msw;
 	unsigned short warn_code = 0;
@@ -12060,37 +12036,32 @@ static int __devinit AscInitSetConfig(struct pci_dev *pdev, struct asc_board *bo
 	case 0:	/* No error. */
 		break;
 	case ASC_WARN_IO_PORT_ROTATE:
-		ASC_PRINT1("AscInitSetConfig: board %d: I/O port address "
-			   "modified\n", boardp->id);
+		shost_printk(KERN_WARNING, shost, "I/O port address "
+				"modified\n");
 		break;
 	case ASC_WARN_AUTO_CONFIG:
-		ASC_PRINT1("AscInitSetConfig: board %d: I/O port increment "
-			   "switch enabled\n", boardp->id);
+		shost_printk(KERN_WARNING, shost, "I/O port increment switch "
+				"enabled\n");
 		break;
 	case ASC_WARN_EEPROM_CHKSUM:
-		ASC_PRINT1("AscInitSetConfig: board %d: EEPROM checksum "
-			   "error\n", boardp->id);
+		shost_printk(KERN_WARNING, shost, "EEPROM checksum error\n");
 		break;
 	case ASC_WARN_IRQ_MODIFIED:
-		ASC_PRINT1("AscInitSetConfig: board %d: IRQ modified\n",
-			   boardp->id);
+		shost_printk(KERN_WARNING, shost, "IRQ modified\n");
 		break;
 	case ASC_WARN_CMD_QNG_CONFLICT:
-		ASC_PRINT1("AscInitSetConfig: board %d: tag queuing w/o "
-			   "disconnects\n",
-		     boardp->id);
+		shost_printk(KERN_WARNING, shost, "tag queuing w/o "
+				"disconnects\n");
 		break;
 	default:
-		ASC_PRINT2("AscInitSetConfig: board %d: unknown warning: "
-			   "0x%x\n", boardp->id, warn_code);
+		shost_printk(KERN_WARNING, shost, "unknown warning: 0x%x\n",
+				warn_code);
 		break;
 	}
 
-	if (asc_dvc->err_code != 0) {
-		ASC_PRINT3("AscInitSetConfig: board %d error: init_state 0x%x, "
-			   "err_code 0x%x\n", boardp->id, asc_dvc->init_state,
-			   asc_dvc->err_code);
-	}
+	if (asc_dvc->err_code != 0)
+		shost_printk(KERN_ERR, shost, "error 0x%x at init_state "
+			"0x%x\n", asc_dvc->err_code, asc_dvc->init_state);
 
 	return asc_dvc->err_code;
 }
@@ -13390,9 +13361,10 @@ static int __devinit AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
  * then 0 is returned.
  */
 static int __devinit
-AdvInitGetConfig(struct pci_dev *pdev, struct asc_board *boardp)
+AdvInitGetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 {
-	ADV_DVC_VAR *asc_dvc = &boardp->dvc_var.adv_dvc_var;
+	struct asc_board *board = shost_priv(shost);
+	ADV_DVC_VAR *asc_dvc = &board->dvc_var.adv_dvc_var;
 	unsigned short warn_code = 0;
 	AdvPortAddr iop_base = asc_dvc->iop_base;
 	u16 cmd;
@@ -13458,15 +13430,12 @@ AdvInitGetConfig(struct pci_dev *pdev, struct asc_board *boardp)
 		warn_code |= status;
 	}
 
-	if (warn_code != 0) {
-		ASC_PRINT2("AdvInitGetConfig: board %d: warning: 0x%x\n",
-			   boardp->id, warn_code);
-	}
+	if (warn_code != 0)
+		shost_printk(KERN_WARNING, shost, "warning: 0x%x\n", warn_code);
 
-	if (asc_dvc->err_code) {
-		ASC_PRINT2("AdvInitGetConfig: board %d error: err_code 0x%x\n",
-		     boardp->id, asc_dvc->err_code);
-	}
+	if (asc_dvc->err_code)
+		shost_printk(KERN_ERR, shost, "error code 0x%x\n",
+				asc_dvc->err_code);
 
 	return asc_dvc->err_code;
 }
@@ -13499,9 +13468,10 @@ static struct scsi_host_template advansys_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 };
 
-static int __devinit
-advansys_wide_init_chip(struct asc_board *boardp, ADV_DVC_VAR *adv_dvc_varp)
+static int __devinit advansys_wide_init_chip(struct Scsi_Host *shost)
 {
+	struct asc_board *board = shost_priv(shost);
+	struct adv_dvc_var *adv_dvc = &board->dvc_var.adv_dvc_var;
 	int req_cnt = 0;
 	adv_req_t *reqp = NULL;
 	int sg_cnt = 0;
@@ -13512,10 +13482,10 @@ advansys_wide_init_chip(struct asc_board *boardp, ADV_DVC_VAR *adv_dvc_varp)
 	 * Allocate buffer carrier structures. The total size
 	 * is about 4 KB, so allocate all at once.
 	 */
-	boardp->carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_KERNEL);
-	ASC_DBG(1, "carrp 0x%p\n", boardp->carrp);
+	board->carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_KERNEL);
+	ASC_DBG(1, "carrp 0x%p\n", board->carrp);
 
-	if (!boardp->carrp)
+	if (!board->carrp)
 		goto kmalloc_failed;
 
 	/*
@@ -13523,7 +13493,7 @@ advansys_wide_init_chip(struct asc_board *boardp, ADV_DVC_VAR *adv_dvc_varp)
 	 * board. The total size is about 16 KB, so allocate all at once.
 	 * If the allocation fails decrement and try again.
 	 */
-	for (req_cnt = adv_dvc_varp->max_host_qng; req_cnt > 0; req_cnt--) {
+	for (req_cnt = adv_dvc->max_host_qng; req_cnt > 0; req_cnt--) {
 		reqp = kmalloc(sizeof(adv_req_t) * req_cnt, GFP_KERNEL);
 
 		ASC_DBG(1, "reqp 0x%p, req_cnt %d, bytes %lu\n", reqp, req_cnt,
@@ -13536,31 +13506,31 @@ advansys_wide_init_chip(struct asc_board *boardp, ADV_DVC_VAR *adv_dvc_varp)
 	if (!reqp)
 		goto kmalloc_failed;
 
-	boardp->orig_reqp = reqp;
+	board->orig_reqp = reqp;
 
 	/*
 	 * Allocate up to ADV_TOT_SG_BLOCK request structures for
 	 * the Wide board. Each structure is about 136 bytes.
 	 */
-	boardp->adv_sgblkp = NULL;
+	board->adv_sgblkp = NULL;
 	for (sg_cnt = 0; sg_cnt < ADV_TOT_SG_BLOCK; sg_cnt++) {
 		sgp = kmalloc(sizeof(adv_sgblk_t), GFP_KERNEL);
 
 		if (!sgp)
 			break;
 
-		sgp->next_sgblkp = boardp->adv_sgblkp;
-		boardp->adv_sgblkp = sgp;
+		sgp->next_sgblkp = board->adv_sgblkp;
+		board->adv_sgblkp = sgp;
 
 	}
 
 	ASC_DBG(1, "sg_cnt %d * %u = %u bytes\n", sg_cnt, sizeof(adv_sgblk_t),
 		 (unsigned)(sizeof(adv_sgblk_t) * sg_cnt));
 
-	if (!boardp->adv_sgblkp)
+	if (!board->adv_sgblkp)
 		goto kmalloc_failed;
 
-	adv_dvc_varp->carrier_buf = boardp->carrp;
+	adv_dvc->carrier_buf = board->carrp;
 
 	/*
 	 * Point 'adv_reqp' to the request structures and
@@ -13571,30 +13541,29 @@ advansys_wide_init_chip(struct asc_board *boardp, ADV_DVC_VAR *adv_dvc_varp)
 	for (; req_cnt > 0; req_cnt--) {
 		reqp[req_cnt - 1].next_reqp = &reqp[req_cnt];
 	}
-	boardp->adv_reqp = &reqp[0];
+	board->adv_reqp = &reqp[0];
 
-	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
+	if (adv_dvc->chip_type == ADV_CHIP_ASC3550) {
 		ASC_DBG(2, "AdvInitAsc3550Driver()\n");
-		warn_code = AdvInitAsc3550Driver(adv_dvc_varp);
-	} else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800) {
+		warn_code = AdvInitAsc3550Driver(adv_dvc);
+	} else if (adv_dvc->chip_type == ADV_CHIP_ASC38C0800) {
 		ASC_DBG(2, "AdvInitAsc38C0800Driver()\n");
-		warn_code = AdvInitAsc38C0800Driver(adv_dvc_varp);
+		warn_code = AdvInitAsc38C0800Driver(adv_dvc);
 	} else {
 		ASC_DBG(2, "AdvInitAsc38C1600Driver()\n");
-		warn_code = AdvInitAsc38C1600Driver(adv_dvc_varp);
+		warn_code = AdvInitAsc38C1600Driver(adv_dvc);
 	}
-	err_code = adv_dvc_varp->err_code;
+	err_code = adv_dvc->err_code;
 
 	if (warn_code || err_code) {
-		ASC_PRINT3("advansys_wide_init_chip: board %d error: warn 0x%x,"
-			   " error 0x%x\n", boardp->id, warn_code, err_code);
+		shost_printk(KERN_WARNING, shost, "error: warn 0x%x, error "
+			"0x%x\n", warn_code, err_code);
 	}
 
 	goto exit;
 
  kmalloc_failed:
-	ASC_PRINT1("advansys_wide_init_chip: board %d error: kmalloc() "
-		   "failed\n", boardp->id);
+	shost_printk(KERN_ERR, shost, "error: kmalloc() failed\n");
 	err_code = ADV_ERROR;
  exit:
 	return err_code;
@@ -13622,7 +13591,6 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
 	int share_irq, warn_code, ret;
 
-	boardp->id = asc_board_count++;
 	pdev = (bus_type == ASC_IS_PCI) ? to_pci_dev(boardp->dev) : NULL;
 
 	if (ASC_NARROW_BOARD(boardp)) {
@@ -13653,10 +13621,10 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		boardp->ioremap_addr = ioremap(pci_resource_start(pdev, 1),
 					       boardp->asc_n_io_port);
 		if (!boardp->ioremap_addr) {
-			ASC_PRINT3
-			    ("advansys_board_found: board %d: ioremap(%x, %d) returned NULL\n",
-			     boardp->id, pci_resource_start(pdev, 1),
-			     boardp->asc_n_io_port);
+			shost_printk(KERN_ERR, shost, "ioremap(%x, %d) "
+					"returned NULL\n",
+					pci_resource_start(pdev, 1),
+					boardp->asc_n_io_port);
 			ret = -ENODEV;
 			goto err_shost;
 		}
@@ -13682,8 +13650,8 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 	 */
 	boardp->prtbuf = kmalloc(ASC_PRTBUF_SIZE, GFP_KERNEL);
 	if (!boardp->prtbuf) {
-		ASC_PRINT2("advansys_board_found: board %d: kmalloc(%d) "
-			   "returned NULL\n", boardp->id, ASC_PRTBUF_SIZE);
+		shost_printk(KERN_ERR, shost, "kmalloc(%d) returned NULL\n",
+				ASC_PRTBUF_SIZE);
 		ret = -ENOMEM;
 		goto err_unmap;
 	}
@@ -13716,9 +13684,8 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 			break;
 #endif /* CONFIG_PCI */
 		default:
-			ASC_PRINT2
-			    ("advansys_board_found: board %d: unknown adapter type: %d\n",
-			     boardp->id, asc_dvc_varp->bus_type);
+			shost_printk(KERN_ERR, shost, "unknown adapter type: "
+					"%d\n", asc_dvc_varp->bus_type);
 			shost->unchecked_isa_dma = TRUE;
 			share_irq = 0;
 			break;
@@ -13731,7 +13698,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		 * referenced only use the bit-wise AND operator "&".
 		 */
 		ASC_DBG(2, "AscInitGetConfig()\n");
-		ret = AscInitGetConfig(boardp) ? -ENODEV : 0;
+		ret = AscInitGetConfig(shost) ? -ENODEV : 0;
 	} else {
 #ifdef CONFIG_PCI
 		/*
@@ -13742,7 +13709,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		share_irq = IRQF_SHARED;
 		ASC_DBG(2, "AdvInitGetConfig()\n");
 
-		ret = AdvInitGetConfig(pdev, boardp) ? -ENODEV : 0;
+		ret = AdvInitGetConfig(pdev, shost) ? -ENODEV : 0;
 #endif /* CONFIG_PCI */
 	}
 
@@ -13790,7 +13757,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		 * Modify board configuration.
 		 */
 		ASC_DBG(2, "AscInitSetConfig()\n");
-		ret = AscInitSetConfig(pdev, boardp) ? -ENODEV : 0;
+		ret = AscInitSetConfig(pdev, shost) ? -ENODEV : 0;
 		if (ret)
 			goto err_free_proc;
 	} else {
@@ -14024,9 +13991,9 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 			shost->dma_channel = asc_dvc_varp->cfg->isa_dma_channel;
 			ret = request_dma(shost->dma_channel, DRV_NAME);
 			if (ret) {
-				ASC_PRINT3
-				    ("advansys_board_found: board %d: request_dma() %d failed %d\n",
-				     boardp->id, shost->dma_channel, ret);
+				shost_printk(KERN_ERR, shost, "request_dma() "
+						"%d failed %d\n",
+						shost->dma_channel, ret);
 				goto err_free_proc;
 			}
 			AscEnableIsaDma(shost->dma_channel);
@@ -14042,17 +14009,14 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 
 	if (ret) {
 		if (ret == -EBUSY) {
-			ASC_PRINT2
-			    ("advansys_board_found: board %d: request_irq(): IRQ 0x%x already in use.\n",
-			     boardp->id, boardp->irq);
+			shost_printk(KERN_ERR, shost, "request_irq(): IRQ 0x%x "
+					"already in use\n", boardp->irq);
 		} else if (ret == -EINVAL) {
-			ASC_PRINT2
-			    ("advansys_board_found: board %d: request_irq(): IRQ 0x%x not valid.\n",
-			     boardp->id, boardp->irq);
+			shost_printk(KERN_ERR, shost, "request_irq(): IRQ 0x%x "
+					"not valid\n", boardp->irq);
 		} else {
-			ASC_PRINT3
-			    ("advansys_board_found: board %d: request_irq(): IRQ 0x%x failed with %d\n",
-			     boardp->id, boardp->irq, ret);
+			shost_printk(KERN_ERR, shost, "request_irq(): IRQ 0x%x "
+					"failed with %d\n", boardp->irq, ret);
 		}
 		goto err_free_dma;
 	}
@@ -14065,15 +14029,15 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		warn_code = AscInitAsc1000Driver(asc_dvc_varp);
 
 		if (warn_code || asc_dvc_varp->err_code) {
-			ASC_PRINT4("advansys_board_found: board %d error: "
-				   "init_state 0x%x, warn 0x%x, error 0x%x\n",
-				   boardp->id, asc_dvc_varp->init_state,
-		 		   warn_code, asc_dvc_varp->err_code);
+			shost_printk(KERN_ERR, shost, "error: init_state 0x%x, "
+					"warn 0x%x, error 0x%x\n",
+					asc_dvc_varp->init_state, warn_code,
+					asc_dvc_varp->err_code);
 			if (asc_dvc_varp->err_code)
 				ret = -ENODEV;
 		}
 	} else {
-		if (advansys_wide_init_chip(boardp, adv_dvc_varp))
+		if (advansys_wide_init_chip(shost))
 			ret = -ENODEV;
 	}
 
-- 
1.5.2.4

