From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] prepare qla1280 drivers for ISP1020/1040 support
Date: Fri, 6 Feb 2004 16:56:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040206155632.GA4679@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:63940 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265525AbUBFP4h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2004 10:56:37 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: linux-scsi@vger.kernel.org

I thought it might be a good idea to not dump a huge patch with all my
restructuring at you when I'm done, so here's the bits of the 1040
support I'm already comfortable with and that make sense to merge.

Really new is only the firmware loading by PIO as needed by the
1020/1040, everything else is some restructuring to make the code more
readable and easiert to hack.  This includes the flush_cache_all removal
I sent to the list.

Warning:  this patch hasn't actually been tested on a currently
supported chip due to lack of hardware.


--- 1.54/drivers/scsi/qla1280.c	Mon Jan 19 04:50:29 2004
+++ edited/drivers/scsi/qla1280.c	Thu Feb  5 07:52:47 2004
@@ -4,7 +4,7 @@
 * QLogic  QLA1280 (Ultra2)  and  QLA12160 (Ultra3) SCSI driver
 * Copyright (C) 2000 Qlogic Corporation (www.qlogic.com)
 * Copyright (C) 2001-2004 Jes Sorensen, Wild Open Source Inc.
-* Copyright (C) 2003 Christoph Hellwig
+* Copyright (C) 2003-2004 Christoph Hellwig
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
@@ -17,9 +17,15 @@
 * General Public License for more details.
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.24.3"
+#define QLA1280_VERSION      "3.24.4"
 /*****************************************************************************
     Revision History:
+    Rev  3.24.4 February 5, 2004, Christoph Hellwig
+    	- Add support for loading firmware by PIO, needed for ISP1020/1040
+	- Cleanup qla1280_abort_isp
+	- Remove unessecary cache flush during fimware loading
+	- Restructure some chip-conditional code in preparation of
+	  ISP1020/1040 support
     Rev  3.24.3 January 19, 2004, Jes Sorensen
 	- Handle PCI DMA mask settings correctly
 	- Correct order of error handling in probe_one, free_irq should not
@@ -348,7 +354,6 @@
 #include <asm/system.h>
 
 #if LINUX_VERSION_CODE >= 0x020545
-#include <asm/cacheflush.h>	/* for flush_cache_all() */
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -486,6 +491,10 @@
 #define ia64_platform_is(foo)		(!strcmp(x, platform_name))
 #endif
 
+#define IS_ISP1x160(ha)	(ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 || \
+			 ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160)
+
+
 static int qla1280_probe_one(struct pci_dev *, const struct pci_device_id *);
 static void qla1280_remove_one(struct pci_dev *);
 
@@ -502,9 +511,7 @@
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
@@ -1382,48 +1389,37 @@
 static int
 qla1280_set_target_parameters(struct scsi_qla_host *ha, int bus, int target)
 {
-	uint8_t mr;
-	uint16_t mb[MAILBOX_REGISTER_COUNT];
-	struct nvram *nv;
-	int is1x160, status;
-
-	nv = &ha->nvram;
-
-	if (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
-	    ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160)
-		is1x160 = 1;
-	else
-		is1x160 = 0;
-
-	mr = BIT_3 | BIT_2 | BIT_1 | BIT_0;
+	u16 mb[MAILBOX_REGISTER_COUNT];
+	u8 mr = BIT_3 | BIT_2 | BIT_1 | BIT_0;
+	struct nvram *nv = &ha->nvram;
+	int err;
 
 	/* Set Target Parameters. */
 	mb[0] = MBC_SET_TARGET_PARAMETERS;
-	mb[1] = (uint16_t) (bus ? target | BIT_7 : target);
+	mb[1] = (u16) (bus ? target | BIT_7 : target);
 	mb[1] <<= 8;
 
-	mb[2] = (nv->bus[bus].target[target].parameter.c << 8);
-
-	if (is1x160)
-		mb[3] =	nv->bus[bus].target[target].flags.flags1x160.sync_offset << 8;
-	else
-		mb[3] =	nv->bus[bus].target[target].flags.flags1x80.sync_offset << 8;
-	mb[3] |= nv->bus[bus].target[target].sync_period;
-
-	if (is1x160) {
-		mb[2] |= nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr << 5;
-		mb[6] =	nv->bus[bus].target[target].ppr_1x160.flags.ppr_options << 8;
-		mb[6] |= nv->bus[bus].target[target].ppr_1x160.flags.ppr_bus_width;
+	if (IS_ISP1x160(ha)) {
+		mb[2] = nv->bus[bus].target[target].parameter.c << 8 |
+			nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr << 5;
+		mb[3] =	nv->bus[bus].target[target].flags.flags1x160.sync_offset << 8 |
+			nv->bus[bus].target[target].sync_period;
+		mb[6] =	nv->bus[bus].target[target].ppr_1x160.flags.ppr_options << 8 |
+			nv->bus[bus].target[target].ppr_1x160.flags.ppr_bus_width;
 		mr |= BIT_6;
+	} else {
+		mb[2] = nv->bus[bus].target[target].parameter.c << 8;
+		mb[3] =	nv->bus[bus].target[target].flags.flags1x80.sync_offset << 8 |
+			nv->bus[bus].target[target].sync_period;
 	}
 
-	status = qla1280_mailbox_command(ha, mr, &mb[0]);
-
-	if (status)
+	err = qla1280_mailbox_command(ha, mr, &mb[0]);
+	if (err) {
 		printk(KERN_WARNING "scsi(%ld:%i:%i): "
 		       "qla1280_set_target_parameters() failed\n",
 		       ha->host_no, bus, target);
-	return status;
+	}
+	return err;
 }
 
 
@@ -1477,8 +1473,7 @@
 	    (driver_setup.wide_mask &&
 	     (~driver_setup.wide_mask & (1 << target))))
 		nv->bus[bus].target[target].parameter.f.enable_wide = 0;
-	if (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
-	    ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160) {
+	if (IS_ISP1x160(ha)) {
 		if (driver_setup.no_ppr ||
 		    (driver_setup.ppr_mask &&
 		     (~driver_setup.ppr_mask & (1 << target))))
@@ -1803,17 +1798,8 @@
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
@@ -2063,52 +2049,62 @@
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
+#ifdef QLA1040_SUPPORT
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
+	u16 risc_address, *risc_code_address, risc_code_size;
+	u16 mb[MAILBOX_REGISTER_COUNT], i;
+	int err;
+
+	/* Load RISC code. */
+	risc_address = *ql1280_board_tbl[ha->devnum].fwstart;
+	risc_code_address = ql1280_board_tbl[ha->devnum].fwcode;
+	risc_code_size = *ql1280_board_tbl[ha->devnum].fwlen;
 
-	ENTER("qla1280_setup_chip");
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
 
-	dprintk(1, "scsi(%ld): Setup chip\n", ha->host_no);
+	return 0;
+}
+#endif
 
+#define DUMP_IT_BACK 0		/* for debug of RISC loading */
+static int
+qla1280_load_firmware_dma(struct scsi_qla_host *ha)
+{
+	u16 risc_address, *risc_code_address, risc_code_size;
+	u16 mb[MAILBOX_REGISTER_COUNT], cnt;
+	int err = 0, num, i;
 #if DUMP_IT_BACK
-	/* get consistent memory allocated for setup_chip */
+	u8 *sp, *tbuf;
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
@@ -2116,15 +2112,13 @@
 		if (cnt > risc_code_size)
 			cnt = risc_code_size;
 
-		dprintk(2, "qla1280_setup_chip:  loading risc @ =(0x%p),"
-			"%d,%d(0x%x)\n",
-			risc_code_address, cnt, num, risc_address);
+		dprintk(2, "%s:  loading risc @ =(0x%p),%d,%d(0x%x)\n",
+				__FUNCTION__, risc_code_address, cnt,
+				num, risc_address);
 		for(i = 0; i < cnt; i++)
-			((uint16_t *)ha->request_ring)[i] =
+			((u16 *)ha->request_ring)[i] =
 				cpu_to_le16(risc_code_address[i]);
 
-		flush_cache_all();
-
 		mb[0] = MBC_LOAD_RAM;
 		mb[1] = risc_address;
 		mb[4] = cnt;
@@ -2132,15 +2126,16 @@
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
@@ -2152,22 +2147,22 @@
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
-		sp = (uint8_t *)ha->request_ring;
+		sp = (u8 *)ha->request_ring;
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
@@ -2178,37 +2173,71 @@
 		num++;
 	}
 
-	/* Verify checksum of loaded RISC code. */
-	if (!status) {
-		dprintk(1, "qla1280_setup_chip: Verifying checksum of "
-			"loaded RISC code.\n");
-		mb[0] = MBC_VERIFY_CHECKSUM;
-		/* mb[1] = ql12_risc_code_addr01; */
-		mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
-
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
-	}
-
+ out:
 #if DUMP_IT_BACK
-	/* free consistent memory allocated for setup_chip */
 	pci_free_consistent(ha->pdev, 8000, tbuf, p_tbuf);
 #endif
+	return err;
+}
 
-	if (status)
-		dprintk(2, "qla1280_setup_chip: **** FAILED ****\n");
+static int
+qla1280_start_firmware(struct scsi_qla_host *ha)
+{
+	u16 mb[MAILBOX_REGISTER_COUNT];
+	int err;
 
-	LEAVE("qla1280_setup_chip");
-	return status;
+	dprintk(1, "%s: Verifying checksum of loaded RISC code.\n",
+			__FUNCTION__);
+
+	/* Verify checksum of loaded RISC code. */
+	mb[0] = MBC_VERIFY_CHECKSUM;
+	/* mb[1] = ql12_risc_code_addr01; */
+	mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
+	err = qla1280_mailbox_command(ha, BIT_1 | BIT_0, mb);
+	if (err) {
+		printk(KERN_ERR "scsi(%li): Failed checksum\n", ha->host_no);
+		return err;
+	}
+
+	/* Start firmware execution. */
+	dprintk(1, "%s: start firmware running.\n", __FUNCTION__);
+	mb[0] = MBC_EXECUTE_FIRMWARE;
+	mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
+	err = qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
+	if (err) {
+		printk(KERN_ERR "scsi(%li): Failed to start firmware\n",
+				ha->host_no);
+	}
+
+	return err;
+}
+
+static int
+qla1280_load_firmware(struct scsi_qla_host *ha)
+{
+	int err = -ENODEV;
+
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
+#ifdef QLA1040_SUPPORT
+	if (IS_ISP1040(ha))
+		err = qla1280_load_firmware_pio(ha);
+	else
+#endif
+		err = qla1280_load_firmware_dma(ha);
+	if (err)
+		goto out;
+	err = qla1280_start_firmware(ha);
+ out:
+	return err;
 }
 
 /*
@@ -2292,19 +2321,13 @@
 {
 	struct device_reg *reg = ha->iobase;
 	struct nvram *nv;
-	int is1x160, status = 0;
+	int status = 0;
 	int bus, target, lun;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	uint16_t mask;
 
 	ENTER("qla1280_nvram_config");
 
-	if (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
-	    ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160)
-		is1x160 = 1;
-	else
-		is1x160 = 0;
-
 	nv = &ha->nvram;
 	if (!ha->nvram_valid) {
 		dprintk(1, "Using defaults for NVRAM: \n");
@@ -2328,7 +2351,7 @@
 		 */
 		nv->isp_config.c = 0x44;
 
-		if (is1x160)
+		if (IS_ISP1x160(ha))
 			nv->isp_parameter = 0x01;
 
 		for (bus = 0; bus < MAX_BUSES; bus++) {
@@ -2360,7 +2383,7 @@
 					disconnect_allowed = 1;
 				nv->bus[bus].target[target].execution_throttle=
 					nv->bus[bus].max_queue_depth - 1;
-				if (is1x160) {
+				if (IS_ISP1x160(ha)) {
 					nv->bus[bus].target[target].flags.
 						flags1x160.device_enable = 1;
 					nv->bus[bus].target[target].flags.
@@ -2561,7 +2584,7 @@
 			nv->bus[bus].target[target].parameter.f.
 				stop_queue_on_check = 0;
 
-			if (is1x160)
+			if (IS_ISP1x160(ha))
 				nv->bus[bus].target[target].ppr_1x160.
 					flags.enable_ppr = 0;
 			/*
@@ -2570,7 +2593,7 @@
 			mb[2] = (nv->bus[bus].target[target].parameter.c << 8)&
 				~(TP_SYNC /*| TP_WIDE | TP_PPR*/);
 
-			if (is1x160)
+			if (IS_ISP1x160(ha))
 				mb[3] =	nv->bus[bus].target[target].flags.flags1x160.sync_offset << 8;
 			else
 				mb[3] =	nv->bus[bus].target[target].flags.flags1x80.sync_offset << 8;
@@ -2582,7 +2605,7 @@
 			 * determined that the target actually supports it
 			 */
 #if 0
-			if (is1x160) {
+			if (IS_ISP1x160(ha)) {
 				mb[2] |= nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr << 5;
 
 				mb[6] =	nv->bus[bus].target[target].ppr_1x160.flags.ppr_options << 8;
@@ -2599,7 +2622,7 @@
 				ha->bus_settings[bus].qtag_enables |= mb[0];
 
 			/* Save Device enable flag. */
-			if (is1x160) {
+			if (IS_ISP1x160(ha)) {
 				if (nv->bus[bus].target[target].flags.flags1x160.device_enable)
 					ha->bus_settings[bus].device_enables |= mb[0];
 				ha->bus_settings[bus].lun_disables |= 0;
@@ -4231,6 +4254,7 @@
 static int
 qla1280_abort_isp(struct scsi_qla_host *ha)
 {
+	struct device_reg *reg = ha->iobase;
 	struct srb *sp;
 	int status = 0;
 	int cnt;
@@ -4238,69 +4262,53 @@
 
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
+
+	printk(KERN_INFO "scsi(%li): dequeuing outstanding commands\n",
+	       ha->host_no);
+	/* Dequeue all commands in outstanding command list. */
+	for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+		struct scsi_cmnd *cmd;
+		sp = ha->outstanding_cmds[cnt];
+		if (sp) {
+
+			cmd = sp->cmd;
+			CMD_RESULT(cmd) = DID_RESET << 16;
 
-				sp->cmd = NULL;
-				ha->outstanding_cmds[cnt] = NULL;
+			sp->cmd = NULL;
+			ha->outstanding_cmds[cnt] = NULL;
 
-				(*cmd->scsi_done)(cmd);
+			(*cmd->scsi_done)(cmd);
 
-				sp->flags = 0;
-			}
+			sp->flags = 0;
 		}
+	}
 
-		/* If firmware needs to be loaded */
-		if (qla1280_isp_firmware (ha)) {
-			if (!(status = qla1280_chip_diag(ha)))
-				status = qla1280_setup_chip(ha);
-		}
+	status = qla1280_load_firmware(ha);
+	if (status)
+		goto out;
 
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
-		}
-	}
+	/* Setup adapter based on NVRAM parameters. */
+	qla1280_nvram_config (ha);
 
+	status = qla1280_init_rings(ha);
+	if (status)
+		goto out;
+		
+	/* Issue SCSI reset. */
+	for (bus = 0; bus < ha->ports; bus++)
+			qla1280_bus_reset(ha, bus);
+		
+	ha->flags.abort_isp_active = 0;
+ out:
 	if (status) {
 		printk(KERN_WARNING
 		       "qla1280: ISP error recovery failed, board disabled");
