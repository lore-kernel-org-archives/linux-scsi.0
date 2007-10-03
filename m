From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 20/21] advansys: Use dma mapping for overrun buffer
Date: Tue,  2 Oct 2007 21:55:41 -0400
Message-ID: <11913765432212-git-send-email-matthew@wil.cx>
References: <11913765421743-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:58802 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbXJCBzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 21:55:47 -0400
In-Reply-To: <11913765421743-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Convert the call to virt_to_bus() into a call to dma_map_single().  Some
architectures may require different DMA addresses for different devices,
so allocate one overrun buffer per host rather than one for all cards.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/advansys.c |   42 ++++++++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index d31a281..8e39df5 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -529,7 +529,6 @@ typedef struct asc_dvc_cfg {
 	ushort mcode_date;
 	ushort mcode_version;
 	uchar max_tag_qng[ASC_MAX_TID + 1];
-	uchar *overrun_buf;
 	uchar sdtr_period_offset[ASC_MAX_TID + 1];
 	uchar adapter_info[6];
 } ASC_DVC_CFG;
@@ -551,6 +550,7 @@ typedef struct asc_dvc_cfg {
 #define ASC_BUG_FIX_ASYN_USE_SYN     0x0002
 #define ASC_MIN_TAGGED_CMD  7
 #define ASC_MAX_SCSI_RESET_WAIT      30
+#define ASC_OVERRUN_BSIZE		64
 
 struct asc_dvc_var;		/* Forward Declaration. */
 
@@ -566,6 +566,8 @@ typedef struct asc_dvc_var {
 	ASC_SCSI_BIT_ID_TYPE unit_not_ready;
 	ASC_SCSI_BIT_ID_TYPE queue_full_or_busy;
 	ASC_SCSI_BIT_ID_TYPE start_motor;
+	uchar overrun_buf[ASC_OVERRUN_BSIZE] __aligned(8);
+	dma_addr_t overrun_dma;
 	uchar scsi_reset_wait;
 	uchar chip_no;
 	char is_in_int;
@@ -668,7 +670,6 @@ typedef struct asceep_config {
 #define ASC_EEP_CMD_WRITE         0x40
 #define ASC_EEP_CMD_WRITE_ABLE    0x30
 #define ASC_EEP_CMD_WRITE_DISABLE 0x00
-#define ASC_OVERRUN_BSIZE  0x00000048UL
 #define ASCV_MSGOUT_BEG         0x0000
 #define ASCV_MSGOUT_SDTR_PERIOD (ASCV_MSGOUT_BEG+3)
 #define ASCV_MSGOUT_SDTR_OFFSET (ASCV_MSGOUT_BEG+4)
@@ -2404,13 +2405,12 @@ struct asc_board {
 	ushort bios_codelen;	/* BIOS Code Segment Length. */
 };
 
+#define asc_dvc_to_board(asc_dvc) container_of(asc_dvc, struct asc_board, \
+							dvc_var.asc_dvc_var)
 #define adv_dvc_to_board(adv_dvc) container_of(adv_dvc, struct asc_board, \
 							dvc_var.adv_dvc_var)
 #define adv_dvc_to_pdev(adv_dvc) to_pci_dev(adv_dvc_to_board(adv_dvc)->dev)
 
-/* Overrun buffer used by all narrow boards. */
-static uchar overrun_buf[ASC_OVERRUN_BSIZE] = { 0 };
-
 #ifdef ADVANSYS_DEBUG
 static int asc_dbglvl = 3;
 
@@ -2465,8 +2465,8 @@ static void asc_prt_asc_dvc_cfg(ASC_DVC_CFG *h)
 		"chip_version %d,\n", h->chip_scsi_id, h->isa_dma_speed,
 		h->isa_dma_channel, h->chip_version);
 
-	printk(" mcode_date 0x%x, mcode_version %d, overrun_buf 0x%p\n",
-		h->mcode_date, h->mcode_version, h->overrun_buf);
+	printk(" mcode_date 0x%x, mcode_version %d\n",
+		h->mcode_date, h->mcode_version);
 }
 
 /*
@@ -6316,6 +6316,7 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	PortAddr iop_base;
 	ASC_PADDR phy_addr;
 	ASC_DCNT phy_size;
+	struct asc_board *board = asc_dvc_to_board(asc_dvc);
 
 	iop_base = asc_dvc->iop_base;
 	warn_code = 0;
@@ -6330,12 +6331,14 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	AscWriteLramByte(iop_base, ASCV_HOSTSCSI_ID_B,
 			 ASC_TID_TO_TARGET_ID(asc_dvc->cfg->chip_scsi_id));
 
-	/* Align overrun buffer on an 8 byte boundary. */
-	phy_addr = virt_to_bus(asc_dvc->cfg->overrun_buf);
-	phy_addr = cpu_to_le32((phy_addr + 7) & ~0x7);
+	/* Ensure overrun buffer is aligned on an 8 byte boundary. */
+	BUG_ON((unsigned long)asc_dvc->overrun_buf & 7);
+	asc_dvc->overrun_dma = dma_map_single(board->dev, asc_dvc->overrun_buf,
+					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+	phy_addr = cpu_to_le32(asc_dvc->overrun_dma);
 	AscMemDWordCopyPtrToLram(iop_base, ASCV_OVERRUN_PADDR_D,
 				 (uchar *)&phy_addr, 1);
-	phy_size = cpu_to_le32(ASC_OVERRUN_BSIZE - 8);
+	phy_size = cpu_to_le32(ASC_OVERRUN_BSIZE);
 	AscMemDWordCopyPtrToLram(iop_base, ASCV_OVERRUN_BSIZE_D,
 				 (uchar *)&phy_size, 1);
 
@@ -13404,7 +13407,6 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		asc_dvc_varp->bus_type = bus_type;
 		asc_dvc_varp->drv_ptr = boardp;
 		asc_dvc_varp->cfg = &boardp->dvc_cfg.asc_dvc_cfg;
-		asc_dvc_varp->cfg->overrun_buf = &overrun_buf[0];
 		asc_dvc_varp->iop_base = iop;
 	} else {
 #ifdef CONFIG_PCI
@@ -13880,19 +13882,23 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
  */
 static int advansys_release(struct Scsi_Host *shost)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *board = shost_priv(shost);
 	ASC_DBG(1, "begin\n");
 	scsi_remove_host(shost);
-	free_irq(boardp->irq, shost);
+	free_irq(board->irq, shost);
 	if (shost->dma_channel != NO_ISA_DMA) {
 		ASC_DBG(1, "free_dma()\n");
 		free_dma(shost->dma_channel);
 	}
-	if (!ASC_NARROW_BOARD(boardp)) {
-		iounmap(boardp->ioremap_addr);
-		advansys_wide_free_mem(boardp);
+	if (ASC_NARROW_BOARD(board)) {
+		dma_unmap_single(board->dev,
+					board->dvc_var.asc_dvc_var.overrun_dma,
+					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+	} else {
+		iounmap(board->ioremap_addr);
+		advansys_wide_free_mem(board);
 	}
-	kfree(boardp->prtbuf);
+	kfree(board->prtbuf);
 	scsi_host_put(shost);
 	ASC_DBG(1, "end\n");
 	return 0;
-- 
1.5.3.1

