Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B42C433F4
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD24961A49
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhCZF7S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 01:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhCZF6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 01:58:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259BCC0613B1;
        Thu, 25 Mar 2021 22:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fuhzdoCilY2lylMn5SQaAKUTSZPcSjw8lmoex6MyGCA=; b=DjcsTF34SfeKIMUCv1lVomJoGi
        Iz2aKzBKOLD47lXGI4p050HRlqKM0vwOc4p64StXJ9ErTtJpM5IHNRGKuZHVdwAxbqcOMChgcp8Q4
        nErGEh3iiM2+2tup2m2So5VWilgffZ+e9dnlQyMFST18ASXdYacwhQr8t+VEEKVh054IZlqMOnqFb
        rFnN0R4pCsTBlYHjRVc6LVh5gz+vBMhvKyrhKWqiULni57lugEyUTY3L9rBSa+i1EAfXJCQl7fcG0
        757pWd1ehyE4zjv1yZfGVXginQ1DBtmZmzkchKZOarDno3B4n6U1WdJBoO5rbiUabuCY1gPt9Lc1N
        Vg2uSbXA==;
Received: from [2001:4bb8:191:f692:97ff:1e47:aee2:c7e5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfUQ-005AOf-C8; Fri, 26 Mar 2021 05:58:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 4/8] advansys: remove ISA support
Date:   Fri, 26 Mar 2021 06:58:18 +0100
Message-Id: <20210326055822.1437471-5-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210326055822.1437471-1-hch@lst.de>
References: <20210326055822.1437471-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the last piece in the kernel requiring the block layer ISA
bounce buffering, and it does not actually look used.  So remove it
to see if anyone screams, in which case we'll need to find a solution
to fix it back up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/scsi/advansys.c | 283 ++++------------------------------------
 1 file changed, 25 insertions(+), 258 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ec5627890809e6..ccdd78ac7abd95 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -84,8 +84,6 @@ typedef unsigned char uchar;
 
 #define ASC_CS_TYPE  unsigned short
 
-#define ASC_IS_ISA          (0x0001)
-#define ASC_IS_ISAPNP       (0x0081)
 #define ASC_IS_EISA         (0x0002)
 #define ASC_IS_PCI          (0x0004)
 #define ASC_IS_PCI_ULTRA    (0x0104)
@@ -2415,8 +2413,8 @@ static void asc_prt_scsi_host(struct Scsi_Host *s)
 	printk(" dma_channel %d, this_id %d, can_queue %d,\n",
 	       s->dma_channel, s->this_id, s->can_queue);
 
-	printk(" cmd_per_lun %d, sg_tablesize %d, unchecked_isa_dma %d\n",
-	       s->cmd_per_lun, s->sg_tablesize, s->unchecked_isa_dma);
+	printk(" cmd_per_lun %d, sg_tablesize %d\n",
+	       s->cmd_per_lun, s->sg_tablesize);
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		asc_prt_asc_dvc_var(&boardp->dvc_var.asc_dvc_var);
@@ -2632,42 +2630,28 @@ static const char *advansys_info(struct Scsi_Host *shost)
 	if (ASC_NARROW_BOARD(boardp)) {
 		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
 		ASC_DBG(1, "begin\n");
-		if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
-			if ((asc_dvc_varp->bus_type & ASC_IS_ISAPNP) ==
-			    ASC_IS_ISAPNP) {
-				busname = "ISA PnP";
+
+		if (asc_dvc_varp->bus_type & ASC_IS_VL) {
+			busname = "VL";
+		} else if (asc_dvc_varp->bus_type & ASC_IS_EISA) {
+			busname = "EISA";
+		} else if (asc_dvc_varp->bus_type & ASC_IS_PCI) {
+			if ((asc_dvc_varp->bus_type & ASC_IS_PCI_ULTRA)
+			    == ASC_IS_PCI_ULTRA) {
+				busname = "PCI Ultra";
 			} else {
-				busname = "ISA";
+				busname = "PCI";
 			}
-			sprintf(info,
-				"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X, DMA 0x%X",
-				ASC_VERSION, busname,
-				(ulong)shost->io_port,
-				(ulong)shost->io_port + ASC_IOADR_GAP - 1,
-				boardp->irq, shost->dma_channel);
 		} else {
-			if (asc_dvc_varp->bus_type & ASC_IS_VL) {
-				busname = "VL";
-			} else if (asc_dvc_varp->bus_type & ASC_IS_EISA) {
-				busname = "EISA";
-			} else if (asc_dvc_varp->bus_type & ASC_IS_PCI) {
-				if ((asc_dvc_varp->bus_type & ASC_IS_PCI_ULTRA)
-				    == ASC_IS_PCI_ULTRA) {
-					busname = "PCI Ultra";
-				} else {
-					busname = "PCI";
-				}
-			} else {
-				busname = "?";
-				shost_printk(KERN_ERR, shost, "unknown bus "
-					"type %d\n", asc_dvc_varp->bus_type);
-			}
-			sprintf(info,
-				"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X",
-				ASC_VERSION, busname, (ulong)shost->io_port,
-				(ulong)shost->io_port + ASC_IOADR_GAP - 1,
-				boardp->irq);
+			busname = "?";
+			shost_printk(KERN_ERR, shost, "unknown bus "
+				"type %d\n", asc_dvc_varp->bus_type);
 		}
+		sprintf(info,
+			"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X",
+			ASC_VERSION, busname, (ulong)shost->io_port,
+			(ulong)shost->io_port + ASC_IOADR_GAP - 1,
+			boardp->irq);
 	} else {
 		/*
 		 * Wide Adapter Information
@@ -2873,12 +2857,7 @@ static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	ASCEEP_CONFIG *ep;
 	int i;
 	uchar serialstr[13];
-#ifdef CONFIG_ISA
-	ASC_DVC_VAR *asc_dvc_varp;
-	int isa_dma_speed[] = { 10, 8, 7, 6, 5, 4, 3, 2 };
 
-	asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
-#endif /* CONFIG_ISA */
 	ep = &boardp->eep_config.asc_eep;
 
 	seq_printf(m,
@@ -2926,14 +2905,6 @@ static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 		seq_printf(m, " %c",
 			   (ep->init_sdtr & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	seq_putc(m, '\n');
-
-#ifdef CONFIG_ISA
-	if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
-		seq_printf(m,
-			   " Host ISA DMA speed:   %d MB/S\n",
-			   isa_dma_speed[ASC_EEP_GET_DMA_SPD(ep)]);
-	}
-#endif /* CONFIG_ISA */
 }
 
 /*
@@ -3180,10 +3151,6 @@ static void asc_prt_driver_conf(struct seq_file *m, struct Scsi_Host *shost)
 		   shost->unique_id, shost->can_queue, shost->this_id,
 		   shost->sg_tablesize, shost->cmd_per_lun);
 
-	seq_printf(m,
-		   " unchecked_isa_dma %d\n",
-		   shost->unchecked_isa_dma);
-
 	seq_printf(m,
 		   " flags 0x%x, last_reset 0x%lx, jiffies 0x%lx, asc_n_io_port 0x%x\n",
 		   boardp->flags, shost->last_reset, jiffies,
@@ -8563,12 +8530,6 @@ static unsigned short AscGetChipBiosAddress(PortAddr iop_base,
 	}
 
 	cfg_lsw = AscGetChipCfgLsw(iop_base);
-
-	/*
-	 *  ISA PnP uses the top bit as the 32K BIOS flag
-	 */
-	if (bus_type == ASC_IS_ISAPNP)
-		cfg_lsw &= 0x7FFF;
 	bios_addr = ASC_BIOS_MIN_ADDR + (cfg_lsw >> 12) * ASC_BIOS_BANK_SIZE;
 	return bios_addr;
 }
@@ -8611,19 +8572,6 @@ static unsigned char AscGetChipVersion(PortAddr iop_base,
 	return AscGetChipVerNo(iop_base);
 }
 
-#ifdef CONFIG_ISA
-static void AscEnableIsaDma(uchar dma_channel)
-{
-	if (dma_channel < 4) {
-		outp(0x000B, (ushort)(0xC0 | dma_channel));
-		outp(0x000A, dma_channel);
-	} else if (dma_channel < 8) {
-		outp(0x00D6, (ushort)(0xC0 | (dma_channel - 4)));
-		outp(0x00D4, (ushort)(dma_channel - 4));
-	}
-}
-#endif /* CONFIG_ISA */
-
 static int AscStopQueueExe(PortAddr iop_base)
 {
 	int count = 0;
@@ -8644,65 +8592,11 @@ static int AscStopQueueExe(PortAddr iop_base)
 
 static unsigned int AscGetMaxDmaCount(ushort bus_type)
 {
-	if (bus_type & ASC_IS_ISA)
-		return ASC_MAX_ISA_DMA_COUNT;
-	else if (bus_type & (ASC_IS_EISA | ASC_IS_VL))
+	if (bus_type & (ASC_IS_EISA | ASC_IS_VL))
 		return ASC_MAX_VL_DMA_COUNT;
 	return ASC_MAX_PCI_DMA_COUNT;
 }
 
-#ifdef CONFIG_ISA
-static ushort AscGetIsaDmaChannel(PortAddr iop_base)
-{
-	ushort channel;
-
-	channel = AscGetChipCfgLsw(iop_base) & 0x0003;
-	if (channel == 0x03)
-		return (0);
-	else if (channel == 0x00)
-		return (7);
-	return (channel + 4);
-}
-
-static ushort AscSetIsaDmaChannel(PortAddr iop_base, ushort dma_channel)
-{
-	ushort cfg_lsw;
-	uchar value;
-
-	if ((dma_channel >= 5) && (dma_channel <= 7)) {
-		if (dma_channel == 7)
-			value = 0x00;
-		else
-			value = dma_channel - 4;
-		cfg_lsw = AscGetChipCfgLsw(iop_base) & 0xFFFC;
-		cfg_lsw |= value;
-		AscSetChipCfgLsw(iop_base, cfg_lsw);
-		return (AscGetIsaDmaChannel(iop_base));
-	}
-	return 0;
-}
-
-static uchar AscGetIsaDmaSpeed(PortAddr iop_base)
-{
-	uchar speed_value;
-
-	AscSetBank(iop_base, 1);
-	speed_value = AscReadChipDmaSpeed(iop_base);
-	speed_value &= 0x07;
-	AscSetBank(iop_base, 0);
-	return speed_value;
-}
-
-static uchar AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
-{
-	speed_value &= 0x07;
-	AscSetBank(iop_base, 1);
-	AscWriteChipDmaSpeed(iop_base, speed_value);
-	AscSetBank(iop_base, 0);
-	return AscGetIsaDmaSpeed(iop_base);
-}
-#endif /* CONFIG_ISA */
-
 static void AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 {
 	int i;
@@ -8712,7 +8606,7 @@ static void AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	iop_base = asc_dvc->iop_base;
 	asc_dvc->err_code = 0;
 	if ((asc_dvc->bus_type &
-	     (ASC_IS_ISA | ASC_IS_PCI | ASC_IS_EISA | ASC_IS_VL)) == 0) {
+	     (ASC_IS_PCI | ASC_IS_EISA | ASC_IS_VL)) == 0) {
 		asc_dvc->err_code |= ASC_IERR_NO_BUS_TYPE;
 	}
 	AscSetChipControl(iop_base, CC_HALT);
@@ -8768,16 +8662,6 @@ static void AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	}
 
 	asc_dvc->cfg->isa_dma_speed = ASC_DEF_ISA_DMA_SPEED;
-#ifdef CONFIG_ISA
-	if ((asc_dvc->bus_type & ASC_IS_ISA) != 0) {
-		if (chip_version >= ASC_CHIP_MIN_VER_ISA_PNP) {
-			AscSetChipIFC(iop_base, IFC_INIT_DEFAULT);
-			asc_dvc->bus_type = ASC_IS_ISAPNP;
-		}
-		asc_dvc->cfg->isa_dma_channel =
-		    (uchar)AscGetIsaDmaChannel(iop_base);
-	}
-#endif /* CONFIG_ISA */
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		asc_dvc->cur_dvc_qng[i] = 0;
 		asc_dvc->max_dvc_qng[i] = ASC_MAX_SCSI1_QNG;
@@ -9314,22 +9198,10 @@ static int AscInitSetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 		}
 	} else
 #endif /* CONFIG_PCI */
-	if (asc_dvc->bus_type == ASC_IS_ISAPNP) {
-		if (AscGetChipVersion(iop_base, asc_dvc->bus_type)
-		    == ASC_CHIP_VER_ASYN_BUG) {
-			asc_dvc->bug_fix_cntl |= ASC_BUG_FIX_ASYN_USE_SYN;
-		}
-	}
 	if (AscSetChipScsiID(iop_base, asc_dvc->cfg->chip_scsi_id) !=
 	    asc_dvc->cfg->chip_scsi_id) {
 		asc_dvc->err_code |= ASC_IERR_SET_SCSI_ID;
 	}
-#ifdef CONFIG_ISA
-	if (asc_dvc->bus_type & ASC_IS_ISA) {
-		AscSetIsaDmaChannel(iop_base, asc_dvc->cfg->isa_dma_channel);
-		AscSetIsaDmaSpeed(iop_base, asc_dvc->cfg->isa_dma_speed);
-	}
-#endif /* CONFIG_ISA */
 
 	asc_dvc->init_state |= ASC_INIT_STATE_END_SET_CFG;
 
@@ -10752,12 +10624,6 @@ static struct scsi_host_template advansys_template = {
 	.eh_host_reset_handler = advansys_reset,
 	.bios_param = advansys_biosparam,
 	.slave_configure = advansys_slave_configure,
-	/*
-	 * Because the driver may control an ISA adapter 'unchecked_isa_dma'
-	 * must be set. The flag will be cleared in advansys_board_found
-	 * for non-ISA adapters.
-	 */
-	.unchecked_isa_dma = true,
 };
 
 static int advansys_wide_init_chip(struct Scsi_Host *shost)
@@ -10923,29 +10789,21 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 		 */
 		switch (asc_dvc_varp->bus_type) {
 #ifdef CONFIG_ISA
-		case ASC_IS_ISA:
-			shost->unchecked_isa_dma = true;
-			share_irq = 0;
-			break;
 		case ASC_IS_VL:
-			shost->unchecked_isa_dma = false;
 			share_irq = 0;
 			break;
 		case ASC_IS_EISA:
-			shost->unchecked_isa_dma = false;
 			share_irq = IRQF_SHARED;
 			break;
 #endif /* CONFIG_ISA */
 #ifdef CONFIG_PCI
 		case ASC_IS_PCI:
-			shost->unchecked_isa_dma = false;
 			share_irq = IRQF_SHARED;
 			break;
 #endif /* CONFIG_PCI */
 		default:
 			shost_printk(KERN_ERR, shost, "unknown adapter type: "
 					"%d\n", asc_dvc_varp->bus_type);
-			shost->unchecked_isa_dma = false;
 			share_irq = 0;
 			break;
 		}
@@ -10964,7 +10822,6 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 		 * For Wide boards set PCI information before calling
 		 * AdvInitGetConfig().
 		 */
-		shost->unchecked_isa_dma = false;
 		share_irq = IRQF_SHARED;
 		ASC_DBG(2, "AdvInitGetConfig()\n");
 
@@ -11228,22 +11085,6 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 
 	/* Register DMA Channel for Narrow boards. */
 	shost->dma_channel = NO_ISA_DMA;	/* Default to no ISA DMA. */
-#ifdef CONFIG_ISA
-	if (ASC_NARROW_BOARD(boardp)) {
-		/* Register DMA channel for ISA bus. */
-		if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
-			shost->dma_channel = asc_dvc_varp->cfg->isa_dma_channel;
-			ret = request_dma(shost->dma_channel, DRV_NAME);
-			if (ret) {
-				shost_printk(KERN_ERR, shost, "request_dma() "
-						"%d failed %d\n",
-						shost->dma_channel, ret);
-				goto err_unmap;
-			}
-			AscEnableIsaDma(shost->dma_channel);
-		}
-	}
-#endif /* CONFIG_ISA */
 
 	/* Register IRQ Number. */
 	ASC_DBG(2, "request_irq(%d, %p)\n", boardp->irq, shost);
@@ -11366,79 +11207,13 @@ static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] = {
 	0x0210, 0x0230, 0x0250, 0x0330
 };
 
-/*
- * The ISA IRQ number is found in bits 2 and 3 of the CfgLsw.  It decodes as:
- * 00: 10
- * 01: 11
- * 10: 12
- * 11: 15
- */
-static unsigned int advansys_isa_irq_no(PortAddr iop_base)
-{
-	unsigned short cfg_lsw = AscGetChipCfgLsw(iop_base);
-	unsigned int chip_irq = ((cfg_lsw >> 2) & 0x03) + 10;
-	if (chip_irq == 13)
-		chip_irq = 15;
-	return chip_irq;
-}
-
-static int advansys_isa_probe(struct device *dev, unsigned int id)
-{
-	int err = -ENODEV;
-	PortAddr iop_base = _asc_def_iop_base[id];
-	struct Scsi_Host *shost;
-	struct asc_board *board;
-
-	if (!request_region(iop_base, ASC_IOADR_GAP, DRV_NAME)) {
-		ASC_DBG(1, "I/O port 0x%x busy\n", iop_base);
-		return -ENODEV;
-	}
-	ASC_DBG(1, "probing I/O port 0x%x\n", iop_base);
-	if (!AscFindSignature(iop_base))
-		goto release_region;
-	if (!(AscGetChipVersion(iop_base, ASC_IS_ISA) & ASC_CHIP_VER_ISA_BIT))
-		goto release_region;
-
-	err = -ENOMEM;
-	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
-	if (!shost)
-		goto release_region;
-
-	board = shost_priv(shost);
-	board->irq = advansys_isa_irq_no(iop_base);
-	board->dev = dev;
-	board->shost = shost;
-
-	err = advansys_board_found(shost, iop_base, ASC_IS_ISA);
-	if (err)
-		goto free_host;
-
-	dev_set_drvdata(dev, shost);
-	return 0;
-
- free_host:
-	scsi_host_put(shost);
- release_region:
-	release_region(iop_base, ASC_IOADR_GAP);
-	return err;
-}
-
-static void advansys_isa_remove(struct device *dev, unsigned int id)
+static void advansys_vlb_remove(struct device *dev, unsigned int id)
 {
 	int ioport = _asc_def_iop_base[id];
 	advansys_release(dev_get_drvdata(dev));
 	release_region(ioport, ASC_IOADR_GAP);
 }
 
-static struct isa_driver advansys_isa_driver = {
-	.probe		= advansys_isa_probe,
-	.remove		= advansys_isa_remove,
-	.driver = {
-		.owner	= THIS_MODULE,
-		.name	= DRV_NAME,
-	},
-};
-
 /*
  * The VLB IRQ number is found in bits 2 to 4 of the CfgLsw.  It decodes as:
  * 000: invalid
@@ -11507,7 +11282,7 @@ static int advansys_vlb_probe(struct device *dev, unsigned int id)
 
 static struct isa_driver advansys_vlb_driver = {
 	.probe		= advansys_vlb_probe,
-	.remove		= advansys_isa_remove,
+	.remove		= advansys_vlb_remove,
 	.driver = {
 		.owner	= THIS_MODULE,
 		.name	= "advansys_vlb",
@@ -11757,15 +11532,10 @@ static int __init advansys_init(void)
 {
 	int error;
 
-	error = isa_register_driver(&advansys_isa_driver,
-				    ASC_IOADR_TABLE_MAX_IX);
-	if (error)
-		goto fail;
-
 	error = isa_register_driver(&advansys_vlb_driver,
 				    ASC_IOADR_TABLE_MAX_IX);
 	if (error)
-		goto unregister_isa;
+		goto fail;
 
 	error = eisa_driver_register(&advansys_eisa_driver);
 	if (error)
@@ -11781,8 +11551,6 @@ static int __init advansys_init(void)
 	eisa_driver_unregister(&advansys_eisa_driver);
  unregister_vlb:
 	isa_unregister_driver(&advansys_vlb_driver);
- unregister_isa:
-	isa_unregister_driver(&advansys_isa_driver);
  fail:
 	return error;
 }
@@ -11792,7 +11560,6 @@ static void __exit advansys_exit(void)
 	pci_unregister_driver(&advansys_pci_driver);
 	eisa_driver_unregister(&advansys_eisa_driver);
 	isa_unregister_driver(&advansys_vlb_driver);
-	isa_unregister_driver(&advansys_isa_driver);
 }
 
 module_init(advansys_init);
-- 
2.30.1

