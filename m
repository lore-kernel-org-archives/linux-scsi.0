From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] cleanup firmware loading, add pio-based loading
Date: Sun, 6 Jun 2004 14:57:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606125741.GD31063@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:27850 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263551AbUFFM5q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 08:57:46 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org

The ISP1040 needs to load firmware by PIO, and while we're at it clean
the convoluted mess of firmware loading up by splitting it into
managable subroutines.


diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	2004-06-06 14:45:10 +02:00
+++ b/drivers/scsi/qla1280.c	2004-06-06 14:45:10 +02:00
@@ -509,9 +509,7 @@
 /*
  *  QLogic ISP1280 Hardware Support Function Prototypes.
  */
-static int qla1280_isp_firmware(struct scsi_qla_host *);
-static int qla1280_chip_diag(struct scsi_qla_host *);
-static int qla1280_setup_chip(struct scsi_qla_host *);
+static int qla1280_load_firmware(struct scsi_qla_host *);
 static int qla1280_init_rings(struct scsi_qla_host *);
 static int qla1280_nvram_config(struct scsi_qla_host *);
 static int qla1280_mailbox_command(struct scsi_qla_host *,
@@ -1802,17 +1800,8 @@
 	 */
 	spin_lock_irqsave(HOST_LOCK, flags);
 #endif
-	/* If firmware needs to be loaded */
-	if (qla1280_isp_firmware(ha)) {
-		if (!(status = qla1280_chip_diag(ha))) {
-			status = qla1280_setup_chip(ha);
-		}
-	} else {
-		printk(KERN_ERR "scsi(%li): isp_firmware() failed!\n",
-		       ha->host_no);
-		status = 1;
-	}
 
+	status = qla1280_load_firmware(ha);
 	if (status) {
 		printk(KERN_ERR "scsi(%li): initialize: pci probe failed!\n",
 		       ha->host_no);
@@ -1945,13 +1934,13 @@
 	int status = 0;
 	int cnt;
 	uint16_t data;
-
 	dprintk(3, "qla1280_chip_diag: testing device at 0x%p \n", &reg->id_l);
 
 	dprintk(1, "scsi(%ld): Verifying chip\n", ha->host_no);
 
 	/* Soft reset chip and wait for it to finish. */
 	WRT_REG_WORD(&reg->ictrl, ISP_RESET);
+
 	/*
 	 * We can't do a traditional PCI write flush here by reading
 	 * back the register. The card will not respond once the reset
@@ -1969,145 +1958,138 @@
 		data = RD_REG_WORD(&reg->ictrl);
 	}
 
-	if (cnt) {
-		/* Reset register cleared by chip reset. */
-		dprintk(3, "qla1280_chip_diag: reset register cleared by "
-			"chip reset\n");
+	if (!cnt)
+		goto fail;
 
-		WRT_REG_WORD(&reg->cfg_1, 0);
+	/* Reset register cleared by chip reset. */
+	dprintk(3, "qla1280_chip_diag: reset register cleared by chip reset\n");
 
-		/* Reset RISC and disable BIOS which
-		   allows RISC to execute out of RAM. */
-#if 0
-		WRT_REG_WORD(&reg->host_cmd, HC_RESET_RISC);
-		RD_REG_WORD(&reg->id_l);	/* Flush PCI write */
-		WRT_REG_WORD(&reg->host_cmd, HC_RELEASE_RISC);
-		RD_REG_WORD(&reg->id_l);	/* Flush PCI write */
-		WRT_REG_WORD(&reg->host_cmd, HC_DISABLE_BIOS);
-#else
-		WRT_REG_WORD(&reg->host_cmd, HC_RESET_RISC |
-			     HC_RELEASE_RISC | HC_DISABLE_BIOS);
-#endif
-		RD_REG_WORD(&reg->id_l);	/* Flush PCI write */
-		data = qla1280_debounce_register(&reg->mailbox0);
-		/*
-		 * I *LOVE* this code!
-		 */
-		for (cnt = 1000000; cnt && data == MBS_BUSY; cnt--) {
-			udelay(5);
-			data = RD_REG_WORD(&reg->mailbox0);
-		}
-
-		if (cnt) {
-			/* Check product ID of chip */
-			dprintk(3, "qla1280_chip_diag: Checking product "
-				"ID of chip\n");
-
-			if (RD_REG_WORD(&reg->mailbox1) != PROD_ID_1 ||
-			    (RD_REG_WORD(&reg->mailbox2) != PROD_ID_2 &&
-			     RD_REG_WORD(&reg->mailbox2) != PROD_ID_2a) ||
-			    RD_REG_WORD(&reg->mailbox3) != PROD_ID_3 ||
-			    RD_REG_WORD(&reg->mailbox4) != PROD_ID_4) {
-				printk(KERN_INFO "qla1280: Wrong product ID = "
-				       "0x%x,0x%x,0x%x,0x%x\n",
-				       RD_REG_WORD(&reg->mailbox1),
-				       RD_REG_WORD(&reg->mailbox2),
-				       RD_REG_WORD(&reg->mailbox3),
-				       RD_REG_WORD(&reg->mailbox4));
-				status = 1;
-			} else {
-				/*
-				 * Enable ints early!!!
-				 */
-				qla1280_enable_intrs(ha);
-
-				dprintk(1, "qla1280_chip_diag: Checking "
-					"mailboxes of chip\n");
-				/* Wrap Incoming Mailboxes Test. */
-				mb[0] = MBC_MAILBOX_REGISTER_TEST;
-				mb[1] = 0xAAAA;
-				mb[2] = 0x5555;
-				mb[3] = 0xAA55;
-				mb[4] = 0x55AA;
-				mb[5] = 0xA5A5;
-				mb[6] = 0x5A5A;
-				mb[7] = 0x2525;
-				if (!(status = qla1280_mailbox_command(ha,
-								       0xff,
-								       &mb
-								       [0]))) {
-					if (mb[1] != 0xAAAA ||
-					    mb[2] != 0x5555 ||
-					    mb[3] != 0xAA55 ||
-					    mb[4] != 0x55AA ||
-					    mb[5] != 0xA5A5 ||
-					    mb[6] != 0x5A5A ||
-					    mb[7] != 0x2525) {
-						status = 1;
-						printk(KERN_INFO "qla1280: "
-						       "Failed mbox check\n");
-					}
-				}
-			}
-		} else
-			status = 1;
-	} else
-		status = 1;
+	WRT_REG_WORD(&reg->cfg_1, 0);
+
+	/* Reset RISC and disable BIOS which
+	   allows RISC to execute out of RAM. */
+	WRT_REG_WORD(&reg->host_cmd, HC_RESET_RISC |
+		     HC_RELEASE_RISC | HC_DISABLE_BIOS);
+
+	RD_REG_WORD(&reg->id_l);	/* Flush PCI write */
+	data = qla1280_debounce_register(&reg->mailbox0);
 
+	/*
+	 * I *LOVE* this code!
+	 */
+	for (cnt = 1000000; cnt && data == MBS_BUSY; cnt--) {
+		udelay(5);
+		data = RD_REG_WORD(&reg->mailbox0);
+	}
+
+	if (!cnt)
+		goto fail;
+
+	/* Check product ID of chip */
+	dprintk(3, "qla1280_chip_diag: Checking product ID of chip\n");
+
+	if (RD_REG_WORD(&reg->mailbox1) != PROD_ID_1 ||
+	    (RD_REG_WORD(&reg->mailbox2) != PROD_ID_2 &&
+	     RD_REG_WORD(&reg->mailbox2) != PROD_ID_2a) ||
+	    RD_REG_WORD(&reg->mailbox3) != PROD_ID_3 ||
+	    RD_REG_WORD(&reg->mailbox4) != PROD_ID_4) {
+		printk(KERN_INFO "qla1280: Wrong product ID = "
+		       "0x%x,0x%x,0x%x,0x%x\n",
+		       RD_REG_WORD(&reg->mailbox1),
+		       RD_REG_WORD(&reg->mailbox2),
+		       RD_REG_WORD(&reg->mailbox3),
+		       RD_REG_WORD(&reg->mailbox4));
+		goto fail;
+	}
+
+	/*
+	 * Enable ints early!!!
+	 */
+	qla1280_enable_intrs(ha);
+
+	dprintk(1, "qla1280_chip_diag: Checking mailboxes of chip\n");
+	/* Wrap Incoming Mailboxes Test. */
+	mb[0] = MBC_MAILBOX_REGISTER_TEST;
+	mb[1] = 0xAAAA;
+	mb[2] = 0x5555;
+	mb[3] = 0xAA55;
+	mb[4] = 0x55AA;
+	mb[5] = 0xA5A5;
+	mb[6] = 0x5A5A;
+	mb[7] = 0x2525;
+
+	status = qla1280_mailbox_command(ha, 0xff, mb);
 	if (status)
-		dprintk(2, "qla1280_chip_diag: **** FAILED ****\n");
-	else
-		dprintk(3, "qla1280_chip_diag: exiting normally\n");
+		goto fail;
+
+	if (mb[1] != 0xAAAA || mb[2] != 0x5555 || mb[3] != 0xAA55 ||
+	    mb[4] != 0x55AA || mb[5] != 0xA5A5 || mb[6] != 0x5A5A ||
+	    mb[7] != 0x2525) {
+		printk(KERN_INFO "qla1280: Failed mbox check\n");
+		goto fail;
+	}
 
+	dprintk(3, "qla1280_chip_diag: exiting normally\n");
+	return 0;
+ fail:
+	dprintk(2, "qla1280_chip_diag: **** FAILED ****\n");
 	return status;
 }
 
-/*
- * Setup chip
- *      Load and start RISC firmware.
- *
- * Input:
- *      ha = adapter block pointer.
- *
- * Returns:
- *      0 = success.
- */
-#define DUMP_IT_BACK 0		/* for debug of RISC loading */
 static int
-qla1280_setup_chip(struct scsi_qla_host *ha)
+qla1280_load_firmware_pio(struct scsi_qla_host *ha)
 {
-	int status = 0;
-	uint16_t risc_address;
-	uint16_t *risc_code_address;
-	int risc_code_size;
-	uint16_t mb[MAILBOX_REGISTER_COUNT];
-	uint16_t cnt;
-	int num, i;
-#if DUMP_IT_BACK
-	uint8_t *sp;
-	uint8_t *tbuf;
-	dma_addr_t p_tbuf;
-#endif
+	uint16_t risc_address, *risc_code_address, risc_code_size;
+	uint16_t mb[MAILBOX_REGISTER_COUNT], i;
+	int err;
 
-	ENTER("qla1280_setup_chip");
+	/* Load RISC code. */
+	risc_address = *ql1280_board_tbl[ha->devnum].fwstart;
+	risc_code_address = ql1280_board_tbl[ha->devnum].fwcode;
+	risc_code_size = *ql1280_board_tbl[ha->devnum].fwlen;
 
-	dprintk(1, "scsi(%ld): Setup chip\n", ha->host_no);
+	for (i = 0; i < risc_code_size; i++) {
+		mb[0] = MBC_WRITE_RAM_WORD;
+		mb[1] = risc_address + i;
+		mb[2] = risc_code_address[i];
+
+		err = qla1280_mailbox_command(ha, BIT_0 | BIT_1 | BIT_2, mb);
+		if (err) {
+			printk(KERN_ERR "scsi(%li): Failed to load firmware\n",
+					ha->host_no);
+			return err;
+		}
+	}
+
+	return 0;
+}
 
+#define DUMP_IT_BACK 0		/* for debug of RISC loading */
+static int
+qla1280_load_firmware_dma(struct scsi_qla_host *ha)
+{
+	uint16_t risc_address, *risc_code_address, risc_code_size;
+	uint16_t mb[MAILBOX_REGISTER_COUNT], cnt;
+	int err = 0, num, i;
 #if DUMP_IT_BACK
-	/* get consistent memory allocated for setup_chip */
+	uint8_t *sp, *tbuf;
+	dma_addr_t p_tbuf;
+
 	tbuf = pci_alloc_consistent(ha->pdev, 8000, &p_tbuf);
+	if (!tbuf)
+		return -ENOMEM;
 #endif
 
 	/* Load RISC code. */
 	risc_address = *ql1280_board_tbl[ha->devnum].fwstart;
 	risc_code_address = ql1280_board_tbl[ha->devnum].fwcode;
-	risc_code_size = (int) *ql1280_board_tbl[ha->devnum].fwlen;
+	risc_code_size = *ql1280_board_tbl[ha->devnum].fwlen;
 
-	dprintk(1, "qla1280_setup_chip: DMA RISC code (%i) words\n",
-		risc_code_size);
+	dprintk(1, "%s: DMA RISC code (%i) words\n",
+			__FUNCTION__, risc_code_size);
 
 	num = 0;
-	while (risc_code_size > 0 && !status) {
+	while (risc_code_size > 0) {
 		int warn __attribute__((unused)) = 0;
 
 		cnt = 2000 >> 1;
@@ -2129,15 +2111,16 @@
 		mb[2] = (ha->request_dma >> 16) & 0xffff;
 		mb[7] = pci_dma_hi32(ha->request_dma) & 0xffff;
 		mb[6] = pci_dma_hi32(ha->request_dma) >> 16;
-		dprintk(2, "qla1280_setup_chip: op=%d  0x%p = 0x%4x,0x%4x,"
-			"0x%4x,0x%4x\n", mb[0], (void *)(long)ha->request_dma,
-			mb[6], mb[7], mb[2], mb[3]);
-		if ((status = qla1280_mailbox_command(ha, BIT_4 | BIT_3 |
-						      BIT_2 | BIT_1 | BIT_0,
-						      &mb[0]))) {
+		dprintk(2, "%s: op=%d  0x%p = 0x%4x,0x%4x,0x%4x,0x%4x\n",
+				__FUNCTION__, mb[0],
+				(void *)(long)ha->request_dma,
+				mb[6], mb[7], mb[2], mb[3]);
+		err = qla1280_mailbox_command(ha, BIT_4 | BIT_3 | BIT_2 |
+				BIT_1 | BIT_0, mb);
+		if (err) {
 			printk(KERN_ERR "scsi(%li): Failed to load partial "
 			       "segment of f\n", ha->host_no);
-			break;
+			goto out;
 		}
 
 #if DUMP_IT_BACK
@@ -2149,22 +2132,22 @@
 		mb[7] = pci_dma_hi32(p_tbuf) & 0xffff;
 		mb[6] = pci_dma_hi32(p_tbuf) >> 16;
 
-		if ((status = qla1280_mailbox_command(ha,
-						      BIT_4 | BIT_3 | BIT_2 |
-						      BIT_1 | BIT_0,
-						      &mb[0]))) {
+		err = qla1280_mailbox_command(ha, BIT_4 | BIT_3 | BIT_2 |
+				BIT_1 | BIT_0, mb);
+		if (err) {
 			printk(KERN_ERR
 			       "Failed to dump partial segment of f/w\n");
-			break;
+			goto out;
 		}
 		sp = (uint8_t *)ha->request_ring;
 		for (i = 0; i < (cnt << 1); i++) {
 			if (tbuf[i] != sp[i] && warn++ < 10) {
-				printk(KERN_ERR "qla1280_setup_chip: FW "
-				       "compare error @ byte(0x%x) loop#=%x\n",
-				       i, num);
-				printk(KERN_ERR "setup_chip: FWbyte=%x  "
-				       "FWfromChip=%x\n", sp[i], tbuf[i]);
+				printk(KERN_ERR "%s: FW compare error @ "
+						"byte(0x%x) loop#=%x\n",
+						__FUNCTION__, i, num);
+				printk(KERN_ERR "%s: FWbyte=%x  "
+						"FWfromChip=%x\n",
+						__FUNCTION__, sp[i], tbuf[i]);
 				/*break; */
 			}
 		}
@@ -2175,37 +2158,69 @@
 		num++;
 	}
 
+ out:
+#if DUMP_IT_BACK
+	pci_free_consistent(ha->pdev, 8000, tbuf, p_tbuf);
+#endif
+	return err;
+}
+
+static int
+qla1280_start_firmware(struct scsi_qla_host *ha)
+{
+	uint16_t mb[MAILBOX_REGISTER_COUNT];
+	int err;
+
+	dprintk(1, "%s: Verifying checksum of loaded RISC code.\n",
+			__FUNCTION__);
+
 	/* Verify checksum of loaded RISC code. */
-	if (!status) {
-		dprintk(1, "qla1280_setup_chip: Verifying checksum of "
-			"loaded RISC code.\n");
-		mb[0] = MBC_VERIFY_CHECKSUM;
-		/* mb[1] = ql12_risc_code_addr01; */
-		mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
+	mb[0] = MBC_VERIFY_CHECKSUM;
+	/* mb[1] = ql12_risc_code_addr01; */
+	mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
+	err = qla1280_mailbox_command(ha, BIT_1 | BIT_0, mb);
+	if (err) {
+		printk(KERN_ERR "scsi(%li): Failed checksum\n", ha->host_no);
+		return err;
+	}
 
-		if (!(status =
-		      qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]))) {
-			/* Start firmware execution. */
-			dprintk(1,
-				"qla1280_setup_chip: start firmware running.\n");
-			mb[0] = MBC_EXECUTE_FIRMWARE;
-			mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
-			qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
-		} else
-			printk(KERN_ERR "scsi(%li): qla1280_setup_chip: "
-			       "Failed checksum\n", ha->host_no);
+	/* Start firmware execution. */
+	dprintk(1, "%s: start firmware running.\n", __FUNCTION__);
+	mb[0] = MBC_EXECUTE_FIRMWARE;
+	mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
+	err = qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
+	if (err) {
+		printk(KERN_ERR "scsi(%li): Failed to start firmware\n",
+				ha->host_no);
 	}
 
-#if DUMP_IT_BACK
-	/* free consistent memory allocated for setup_chip */
-	pci_free_consistent(ha->pdev, 8000, tbuf, p_tbuf);
-#endif
+	return err;
+}
 
-	if (status)
-		dprintk(2, "qla1280_setup_chip: **** FAILED ****\n");
+static int
+qla1280_load_firmware(struct scsi_qla_host *ha)
+{
+	int err = -ENODEV;
 
-	LEAVE("qla1280_setup_chip");
-	return status;
+	/* If firmware needs to be loaded */
+	if (!qla1280_isp_firmware(ha)) {
+		printk(KERN_ERR "scsi(%li): isp_firmware() failed!\n",
+				ha->host_no);
+		goto out;
+	}
+
+	err = qla1280_chip_diag(ha);
+	if (err)
+		goto out;
+	if (IS_ISP1040(ha))
+		err = qla1280_load_firmware_pio(ha);
+	else
+		err = qla1280_load_firmware_dma(ha);
+	if (err)
+		goto out;
+	err = qla1280_start_firmware(ha);
+ out:
+	return err;
 }
 
 /*
@@ -4227,6 +4242,7 @@
 static int
 qla1280_abort_isp(struct scsi_qla_host *ha)
 {
+	struct device_reg *reg = ha->iobase;
 	struct srb *sp;
 	int status = 0;
 	int cnt;
@@ -4234,69 +4250,53 @@
 
 	ENTER("qla1280_abort_isp");
 
-	if (!ha->flags.abort_isp_active && ha->flags.online) {
-		struct device_reg *reg = ha->iobase;
-		ha->flags.abort_isp_active = 1;
-
-		/* Disable ISP interrupts. */
-		qla1280_disable_intrs(ha);
-		WRT_REG_WORD(&reg->host_cmd, HC_PAUSE_RISC);
-		RD_REG_WORD(&reg->id_l);
-
-		printk(KERN_INFO "scsi(%li): dequeuing outstanding commands\n",
-		       ha->host_no);
-		/* Dequeue all commands in outstanding command list. */
-		for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-			struct scsi_cmnd *cmd;
-			sp = ha->outstanding_cmds[cnt];
-			if (sp) {
+	if (ha->flags.abort_isp_active || !ha->flags.online)
+		goto out;
+	
+	ha->flags.abort_isp_active = 1;
 
-				cmd = sp->cmd;
-				CMD_RESULT(cmd) = DID_RESET << 16;
+	/* Disable ISP interrupts. */
+	qla1280_disable_intrs(ha);
+	WRT_REG_WORD(&reg->host_cmd, HC_PAUSE_RISC);
+	RD_REG_WORD(&reg->id_l);
 
-				sp->cmd = NULL;
-				ha->outstanding_cmds[cnt] = NULL;
+	printk(KERN_INFO "scsi(%li): dequeuing outstanding commands\n",
+	       ha->host_no);
+	/* Dequeue all commands in outstanding command list. */
+	for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+		struct scsi_cmnd *cmd;
+		sp = ha->outstanding_cmds[cnt];
+		if (sp) {
 
-				(*cmd->scsi_done)(cmd);
+			cmd = sp->cmd;
+			CMD_RESULT(cmd) = DID_RESET << 16;
 
-				sp->flags = 0;
-			}
-		}
+			sp->cmd = NULL;
+			ha->outstanding_cmds[cnt] = NULL;
 
-		/* If firmware needs to be loaded */
-		if (qla1280_isp_firmware (ha)) {
-			if (!(status = qla1280_chip_diag(ha)))
-				status = qla1280_setup_chip(ha);
-		}
+			(*cmd->scsi_done)(cmd);
 
-		if (!status) {
-			/* Setup adapter based on NVRAM parameters. */
-			qla1280_nvram_config (ha);
-
-			if (!(status = qla1280_init_rings(ha))) {
-				/* Issue SCSI reset. */
-				for (bus = 0; bus < ha->ports; bus++) {
-					qla1280_bus_reset(ha, bus);
-				}
-				/*
-				 * qla1280_bus_reset() will do the marker
-				 * dance - no reason to repeat here!
-				 */
-#if  0
-				/* Issue marker command. */
-				ha->flags.reset_marker = 0;
-				for (bus = 0; bus < ha->ports; bus++) {
-					ha->bus_settings[bus].
-						reset_marker = 0;
-					qla1280_marker(ha, bus, 0, 0,
-						       MK_SYNC_ALL);
-				}
-#endif
-				ha->flags.abort_isp_active = 0;
-			}
+			sp->flags = 0;
 		}
 	}
 
+	status = qla1280_load_firmware(ha);
+	if (status)
+		goto out;
+
+	/* Setup adapter based on NVRAM parameters. */
+	qla1280_nvram_config (ha);
+
+	status = qla1280_init_rings(ha);
+	if (status)
+		goto out;
+		
+	/* Issue SCSI reset. */
+	for (bus = 0; bus < ha->ports; bus++)
+		qla1280_bus_reset(ha, bus);
+		
+	ha->flags.abort_isp_active = 0;
+ out:
 	if (status) {
 		printk(KERN_WARNING
 		       "qla1280: ISP error recovery failed, board disabled");
