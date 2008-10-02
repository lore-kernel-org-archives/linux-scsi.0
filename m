From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [6/21] SCSI-ISA-DMA: Remove unchecked_isa_dma in advansys.c
Date: Thu,  2 Oct 2008 09:58:44 +0200 (CEST)
Message-ID: <20081002075844.320353E6A07@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57090 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYJBH6q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:46 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


That patch is a little more complicated than the others. advansys
was the only ISA driver who actually passed ->cmnd to the firmware.
So I implemented a simple own bounce buffer scheme for this case.
Also did sense_buffer bouncing in the driver while I was at it;
which means it doesn't require the mid layer to do this anymore.

- allocate hostdata with GFP_DMA separately for the ISA case
- Tell block layer explicitely to bounce for ISA case
- remove unchecked_isa_dma

Untested due to lack of hardware

v2: use dma api for all allocations
v3: remove cmnd buffer bouncing (thanks m.willcox), move sense bouncing
    to mid layer

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/advansys.c |  162 ++++++++++++++++++++++++++++++------------------
 1 file changed, 103 insertions(+), 59 deletions(-)

Index: linux/drivers/scsi/advansys.c
===================================================================
--- linux.orig/drivers/scsi/advansys.c
+++ linux/drivers/scsi/advansys.c
@@ -2212,7 +2212,7 @@ do { \
 #define ASC_STATS_ADD(shost, counter, count)
 #else /* ADVANSYS_STATS */
 #define ASC_STATS_ADD(shost, counter, count) \
-	(((struct asc_board *) shost_priv(shost))->asc_stats.counter += (count))
+	(asc_shost_priv(shost)->asc_stats.counter += (count))
 #endif /* ADVANSYS_STATS */
 
 /* If the result wraps when calculating tenths, return 0. */
@@ -2354,10 +2354,6 @@ struct asc_stats {
 
 /*
  * Structure allocated for each board.
- *
- * This structure is allocated by scsi_host_alloc() at the end
- * of the 'Scsi_Host' structure starting at the 'hostdata'
- * field. It is guaranteed to be allocated from DMA-able memory.
  */
 struct asc_board {
 	struct device *dev;
@@ -2388,6 +2384,7 @@ struct asc_board {
 #ifdef ADVANSYS_STATS
 	struct asc_stats asc_stats;	/* Board statistics */
 #endif				/* ADVANSYS_STATS */
+
 	/*
 	 * The following fields are used only for Narrow Boards.
 	 */
@@ -2403,8 +2400,19 @@ struct asc_board {
 	ushort bios_version;	/* BIOS Version. */
 	ushort bios_codeseg;	/* BIOS Code Segment. */
 	ushort bios_codelen;	/* BIOS Code Segment Length. */
+
+};
+
+struct asc_board_ptr {
+	struct asc_board *b;
+	dma_addr_t dma;
 };
 
+
+
+#define asc_shost_priv(h) (((struct asc_board_ptr *)shost_priv(h))->b)
+#define asc_shost_dma(h) (((struct asc_board_ptr *)shost_priv(h))->dma)
+
 #define asc_dvc_to_board(asc_dvc) container_of(asc_dvc, struct asc_board, \
 							dvc_var.asc_dvc_var)
 #define adv_dvc_to_board(adv_dvc) container_of(adv_dvc, struct asc_board, \
@@ -2525,7 +2533,7 @@ static void asc_prt_adv_dvc_cfg(ADV_DVC_
  */
 static void asc_prt_scsi_host(struct Scsi_Host *s)
 {
-	struct asc_board *boardp = shost_priv(s);
+	struct asc_board *boardp = asc_shost_priv(s);
 
 	printk("Scsi_Host at addr 0x%p, device %s\n", s, boardp->dev->bus_id);
 	printk(" host_busy %u, host_no %d, last_reset %d,\n",
@@ -2537,8 +2545,8 @@ static void asc_prt_scsi_host(struct Scs
 	printk(" dma_channel %d, this_id %d, can_queue %d,\n",
 	       s->dma_channel, s->this_id, s->can_queue);
 
-	printk(" cmd_per_lun %d, sg_tablesize %d, unchecked_isa_dma %d\n",
-	       s->cmd_per_lun, s->sg_tablesize, s->unchecked_isa_dma);
+	printk(" cmd_per_lun %d, sg_tablesize %d\n",
+	       s->cmd_per_lun, s->sg_tablesize);
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		asc_prt_asc_dvc_var(&boardp->dvc_var.asc_dvc_var);
@@ -2803,7 +2811,7 @@ static void * advansys_srb_to_ptr(struct
 static const char *advansys_info(struct Scsi_Host *shost)
 {
 	static char info[ASC_INFO_SIZE];
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp;
 	ADV_DVC_VAR *adv_dvc_varp;
 	char *busname;
@@ -2919,7 +2927,7 @@ static int asc_prt_line(char *buf, int b
  */
 static int asc_prt_board_devices(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
@@ -2959,7 +2967,7 @@ static int asc_prt_board_devices(struct 
  */
 static int asc_prt_adv_bios(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
@@ -3124,7 +3132,7 @@ static int asc_get_eeprom_string(ushort 
  */
 static int asc_prt_asc_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp;
 	int leftlen;
 	int totlen;
@@ -3257,7 +3265,7 @@ static int asc_prt_asc_board_eeprom(stru
  */
 static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	ADV_DVC_VAR *adv_dvc_varp;
 	int leftlen;
 	int totlen;
@@ -3543,7 +3551,7 @@ static int asc_prt_adv_board_eeprom(stru
  */
 static int asc_prt_driver_conf(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
@@ -3569,9 +3577,7 @@ static int asc_prt_driver_conf(struct Sc
 			   shost->sg_tablesize, shost->cmd_per_lun);
 	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
-			   " unchecked_isa_dma %d, use_clustering %d\n",
-			   shost->unchecked_isa_dma, shost->use_clustering);
+	len = asc_prt_line(cp, leftlen, " use_clustering %d\n", shost->use_clustering);
 	ASC_PRT_NEXT();
 
 	len = asc_prt_line(cp, leftlen,
@@ -3605,7 +3611,7 @@ static int asc_prt_driver_conf(struct Sc
  */
 static int asc_prt_asc_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	int chip_scsi_id;
 	int leftlen;
 	int totlen;
@@ -3787,7 +3793,7 @@ static int asc_prt_asc_board_info(struct
  */
 static int asc_prt_adv_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
@@ -4065,7 +4071,7 @@ asc_proc_copy(off_t advoffset, off_t off
  */
 static int asc_prt_board_stats(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	struct asc_stats *s = &boardp->asc_stats;
 
 	int leftlen = cplen;
@@ -4151,7 +4157,7 @@ static int
 advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		   off_t offset, int length, int inout)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	char *cp;
 	int cplen;
 	int cnt;
@@ -8200,7 +8206,7 @@ static void adv_isr_callback(ADV_DVC_VAR
 	ASC_STATS(shost, callback);
 	ASC_DBG(1, "shost 0x%p\n", shost);
 
-	boardp = shost_priv(shost);
+	boardp = asc_shost_priv(shost);
 	BUG_ON(adv_dvc_varp != &boardp->dvc_var.adv_dvc_var);
 
 	/*
@@ -9132,7 +9138,7 @@ static void asc_isr_callback(ASC_DVC_VAR
 	ASC_STATS(shost, callback);
 	ASC_DBG(1, "shost 0x%p\n", shost);
 
-	boardp = shost_priv(shost);
+	boardp = asc_shost_priv(shost);
 	BUG_ON(asc_dvc_varp != &boardp->dvc_var.asc_dvc_var);
 
 	dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
@@ -9484,7 +9490,7 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 static int advansys_reset(struct scsi_cmnd *scp)
 {
 	struct Scsi_Host *shost = scp->device->host;
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	unsigned long flags;
 	int status;
 	int ret = SUCCESS;
@@ -9567,7 +9573,7 @@ static int
 advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		   sector_t capacity, int ip[])
 {
-	struct asc_board *boardp = shost_priv(sdev->host);
+	struct asc_board *boardp = asc_shost_priv(sdev->host);
 
 	ASC_DBG(1, "begin\n");
 	ASC_STATS(sdev->host, biosparam);
@@ -9603,7 +9609,7 @@ advansys_biosparam(struct scsi_device *s
 static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 {
 	struct Scsi_Host *shost = dev_id;
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	irqreturn_t result = IRQ_NONE;
 
 	ASC_DBG(2, "boardp 0x%p\n", boardp);
@@ -9691,6 +9697,9 @@ advansys_narrow_slave_configure(struct s
 	ASC_SCSI_BIT_ID_TYPE tid_bit = 1 << sdev->id;
 	ASC_SCSI_BIT_ID_TYPE orig_use_tagged_qng = asc_dvc->use_tagged_qng;
 
+	if (sdev->host->sense_buffer_isa)
+		blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ISA);
+
 	if (sdev->lun == 0) {
 		ASC_SCSI_BIT_ID_TYPE orig_init_sdtr = asc_dvc->init_sdtr;
 		if ((asc_dvc->cfg->sdtr_enable & tid_bit) && sdev->sdtr) {
@@ -9865,7 +9874,7 @@ advansys_wide_slave_configure(struct scs
  */
 static int advansys_slave_configure(struct scsi_device *sdev)
 {
-	struct asc_board *boardp = shost_priv(sdev->host);
+	struct asc_board *boardp = asc_shost_priv(sdev->host);
 
 	if (ASC_NARROW_BOARD(boardp))
 		advansys_narrow_slave_configure(sdev,
@@ -10925,7 +10934,7 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *
 static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 {
 	int ret, err_code;
-	struct asc_board *boardp = shost_priv(scp->device->host);
+	struct asc_board *boardp = asc_shost_priv(scp->device->host);
 
 	ASC_DBG(1, "scp 0x%p\n", scp);
 
@@ -11725,7 +11734,7 @@ static ushort __devinit AscInitFromEEP(A
 
 static int __devinit AscInitGetConfig(struct Scsi_Host *shost)
 {
-	struct asc_board *board = shost_priv(shost);
+	struct asc_board *board = asc_shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc = &board->dvc_var.asc_dvc_var;
 	unsigned short warn_code = 0;
 
@@ -11779,7 +11788,7 @@ static int __devinit AscInitGetConfig(st
 
 static int __devinit AscInitSetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 {
-	struct asc_board *board = shost_priv(shost);
+	struct asc_board *board = asc_shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc = &board->dvc_var.asc_dvc_var;
 	PortAddr iop_base = asc_dvc->iop_base;
 	unsigned short cfg_msw;
@@ -13172,7 +13181,7 @@ static int __devinit AdvInitFrom38C1600E
 static int __devinit
 AdvInitGetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 {
-	struct asc_board *board = shost_priv(shost);
+	struct asc_board *board = asc_shost_priv(shost);
 	ADV_DVC_VAR *asc_dvc = &board->dvc_var.adv_dvc_var;
 	unsigned short warn_code = 0;
 	AdvPortAddr iop_base = asc_dvc->iop_base;
@@ -13250,6 +13259,13 @@ AdvInitGetConfig(struct pci_dev *pdev, s
 }
 #endif
 
+static int advansys_adjust_queue(struct scsi_device *device)
+{
+	if (device->host->sense_buffer_isa)
+		blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
+
 static struct scsi_host_template advansys_template = {
 	.proc_name = DRV_NAME,
 #ifdef CONFIG_PROC_FS
@@ -13261,12 +13277,7 @@ static struct scsi_host_template advansy
 	.eh_bus_reset_handler = advansys_reset,
 	.bios_param = advansys_biosparam,
 	.slave_configure = advansys_slave_configure,
-	/*
-	 * Because the driver may control an ISA adapter 'unchecked_isa_dma'
-	 * must be set. The flag will be cleared in advansys_board_found
-	 * for non-ISA adapters.
-	 */
-	.unchecked_isa_dma = 1,
+	.slave_alloc = advansys_adjust_queue,
 	/*
 	 * All adapters controlled by this driver are capable of large
 	 * scatter-gather lists. According to the mid-level SCSI documentation
@@ -13279,7 +13290,7 @@ static struct scsi_host_template advansy
 
 static int __devinit advansys_wide_init_chip(struct Scsi_Host *shost)
 {
-	struct asc_board *board = shost_priv(shost);
+	struct asc_board *board = asc_shost_priv(shost);
 	struct adv_dvc_var *adv_dvc = &board->dvc_var.adv_dvc_var;
 	int req_cnt = 0;
 	adv_req_t *reqp = NULL;
@@ -13394,7 +13405,7 @@ static int __devinit advansys_board_foun
 					  unsigned int iop, int bus_type)
 {
 	struct pci_dev *pdev;
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp = NULL;
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
 	int share_irq, warn_code, ret;
@@ -13464,6 +13475,8 @@ static int __devinit advansys_board_foun
 	}
 #endif /* CONFIG_PROC_FS */
 
+	ret = 0;
+
 	if (ASC_NARROW_BOARD(boardp)) {
 		/*
 		 * Set the board bus type and PCI IRQ before
@@ -13472,28 +13485,23 @@ static int __devinit advansys_board_foun
 		switch (asc_dvc_varp->bus_type) {
 #ifdef CONFIG_ISA
 		case ASC_IS_ISA:
-			shost->unchecked_isa_dma = TRUE;
 			share_irq = 0;
 			break;
 		case ASC_IS_VL:
-			shost->unchecked_isa_dma = FALSE;
 			share_irq = 0;
 			break;
 		case ASC_IS_EISA:
-			shost->unchecked_isa_dma = FALSE;
 			share_irq = IRQF_SHARED;
 			break;
 #endif /* CONFIG_ISA */
 #ifdef CONFIG_PCI
 		case ASC_IS_PCI:
-			shost->unchecked_isa_dma = FALSE;
 			share_irq = IRQF_SHARED;
 			break;
 #endif /* CONFIG_PCI */
 		default:
 			shost_printk(KERN_ERR, shost, "unknown adapter type: "
 					"%d\n", asc_dvc_varp->bus_type);
-			shost->unchecked_isa_dma = TRUE;
 			share_irq = 0;
 			break;
 		}
@@ -13505,14 +13513,14 @@ static int __devinit advansys_board_foun
 		 * referenced only use the bit-wise AND operator "&".
 		 */
 		ASC_DBG(2, "AscInitGetConfig()\n");
-		ret = AscInitGetConfig(shost) ? -ENODEV : 0;
+		if (!ret)
+			ret = AscInitGetConfig(shost) ? -ENODEV : 0;
 	} else {
 #ifdef CONFIG_PCI
 		/*
 		 * For Wide boards set PCI information before calling
 		 * AdvInitGetConfig().
 		 */
-		shost->unchecked_isa_dma = FALSE;
 		share_irq = IRQF_SHARED;
 		ASC_DBG(2, "AdvInitGetConfig()\n");
 
@@ -13883,6 +13891,16 @@ static int __devinit advansys_board_foun
 	return ret;
 }
 
+static void adv_free_host(struct Scsi_Host *shost)
+{
+	struct asc_board *board = asc_shost_priv(shost);
+	struct device *device = board->dev;
+	dma_free_coherent(device, sizeof(struct asc_board),
+				  asc_shost_priv(shost),
+				  asc_shost_dma(shost));
+	scsi_host_put(shost);
+}
+
 /*
  * advansys_release()
  *
@@ -13890,7 +13908,7 @@ static int __devinit advansys_board_foun
  */
 static int advansys_release(struct Scsi_Host *shost)
 {
-	struct asc_board *board = shost_priv(shost);
+	struct asc_board *board = asc_shost_priv(shost);
 	ASC_DBG(1, "begin\n");
 	scsi_remove_host(shost);
 	free_irq(board->irq, shost);
@@ -13908,11 +13926,32 @@ static int advansys_release(struct Scsi_
 		advansys_wide_free_mem(board);
 	}
 	kfree(board->prtbuf);
-	scsi_host_put(shost);
+	adv_free_host(shost);
 	ASC_DBG(1, "end\n");
 	return 0;
 }
 
+static struct Scsi_Host *adv_host_alloc(struct device *dev)
+{
+	struct asc_board *board;
+	struct Scsi_Host *shost;
+	shost = scsi_host_alloc(&advansys_template,
+				sizeof(struct asc_board_ptr));
+	if (!shost)
+		return NULL;
+
+	board = dma_alloc_coherent(dev,
+				   sizeof(struct asc_board),
+				   &asc_shost_dma(shost),
+				   GFP_KERNEL);
+	if (!board) {
+		scsi_host_put(shost);
+		return NULL;
+	}
+	asc_shost_priv(shost) = board;
+	return shost;
+}
+
 #define ASC_IOADR_TABLE_MAX_IX  11
 
 static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] = {
@@ -13954,11 +13993,13 @@ static int __devinit advansys_isa_probe(
 		goto release_region;
 
 	err = -ENOMEM;
-	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
+	shost = adv_host_alloc(NULL);
 	if (!shost)
 		goto release_region;
+	shost->sense_buffer_isa = 1;
+
+	board = asc_shost_priv(shost);
 
-	board = shost_priv(shost);
 	board->irq = advansys_isa_irq_no(iop_base);
 	board->dev = dev;
 
@@ -13970,7 +14011,7 @@ static int __devinit advansys_isa_probe(
 	return 0;
 
  free_host:
-	scsi_host_put(shost);
+	adv_free_host(shost);
  release_region:
 	release_region(iop_base, ASC_IOADR_GAP);
 	return err;
@@ -14036,11 +14077,12 @@ static int __devinit advansys_vlb_probe(
 		goto release_region;
 
 	err = -ENOMEM;
-	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
+	shost = adv_host_alloc(NULL);
 	if (!shost)
 		goto release_region;
+	shost->sense_buffer_isa = 1;
 
-	board = shost_priv(shost);
+	board = asc_shost_priv(shost);
 	board->irq = advansys_vlb_irq_no(iop_base);
 	board->dev = dev;
 
@@ -14052,7 +14094,7 @@ static int __devinit advansys_vlb_probe(
 	return 0;
 
  free_host:
-	scsi_host_put(shost);
+	adv_free_host(shost);
  release_region:
 	release_region(iop_base, ASC_IOADR_GAP);
 	return -ENODEV;
@@ -14143,11 +14185,13 @@ static int __devinit advansys_eisa_probe
 			irq = advansys_eisa_irq_no(edev);
 
 		err = -ENOMEM;
-		shost = scsi_host_alloc(&advansys_template, sizeof(*board));
+		/* RED-PEN does use GFP_DMA unnecessarily since EISA is 32bit */
+		shost = adv_host_alloc(NULL);
+
 		if (!shost)
 			goto release_region;
 
-		board = shost_priv(shost);
+		board = asc_shost_priv(shost);
 		board->irq = irq;
 		board->dev = dev;
 
@@ -14259,11 +14303,11 @@ advansys_pci_probe(struct pci_dev *pdev,
 	ioport = pci_resource_start(pdev, 0);
 
 	err = -ENOMEM;
-	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
+	shost = adv_host_alloc(&pdev->dev);
 	if (!shost)
 		goto release_region;
 
-	board = shost_priv(shost);
+	board = asc_shost_priv(shost);
 	board->irq = pdev->irq;
 	board->dev = &pdev->dev;
 
@@ -14281,7 +14325,7 @@ advansys_pci_probe(struct pci_dev *pdev,
 	return 0;
 
  free_host:
-	scsi_host_put(shost);
+	adv_free_host(shost);
  release_region:
 	pci_release_regions(pdev);
  disable_device:
