From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [3/22] Remove unchecked_isa_dma in advansys.c
Date: Mon, 25 Feb 2008 00:35:16 +0100 (CET)
Message-ID: <20080224233516.0657F1B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:15963 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYBXXvk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:51:40 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


That patch is a little more complicated than the others. advansys
was the only ISA driver who actually passed ->cmnd to the firmware.
So I implemented a simple own bounce buffer scheme for this case.
Also did sense_buffer bouncing in the driver while I was at it;
which means it doesn't require the mid layer to do this anymore.

- allocate hostdata with GFP_DMA separately for the ISA case
- Tell block layer explicitely to bounce for ISA case
- remove unchecked_isa_dma

Untested due to lack of hardware

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/advansys.c |  216 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 151 insertions(+), 65 deletions(-)

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
@@ -2352,12 +2352,16 @@ struct asc_stats {
 };
 #endif /* ADVANSYS_STATS */
 
+union adv_cmnd {
+	struct {
+		char cmnd[MAX_COMMAND_SIZE];
+		char sense_buffer[SCSI_SENSE_BUFFERSIZE];
+	};
+	struct list_head l;
+};
+
 /*
  * Structure allocated for each board.
- *
- * This structure is allocated by scsi_host_alloc() at the end
- * of the 'Scsi_Host' structure starting at the 'hostdata'
- * field. It is guaranteed to be allocated from DMA-able memory.
  */
 struct asc_board {
 	struct device *dev;
@@ -2388,6 +2392,10 @@ struct asc_board {
 #ifdef ADVANSYS_STATS
 	struct asc_stats asc_stats;	/* Board statistics */
 #endif				/* ADVANSYS_STATS */
+
+	void *adv_bounce;
+	struct list_head adv_cmnd_free;
+
 	/*
 	 * The following fields are used only for Narrow Boards.
 	 */
@@ -2403,8 +2411,17 @@ struct asc_board {
 	ushort bios_version;	/* BIOS Version. */
 	ushort bios_codeseg;	/* BIOS Code Segment. */
 	ushort bios_codelen;	/* BIOS Code Segment Length. */
+
+};
+
+struct asc_board_ptr {
+	struct asc_board *b;
 };
 
+#define ADV_BOUNCE_SIZE  (sizeof(union adv_cmnd) * (ASC_DEF_MAX_HOST_QNG + 1))
+
+#define asc_shost_priv(h) (((struct asc_board_ptr *)shost_priv(h))->b)
+
 #define asc_dvc_to_board(asc_dvc) container_of(asc_dvc, struct asc_board, \
 							dvc_var.asc_dvc_var)
 #define adv_dvc_to_board(adv_dvc) container_of(adv_dvc, struct asc_board, \
@@ -2525,7 +2542,7 @@ static void asc_prt_adv_dvc_cfg(ADV_DVC_
  */
 static void asc_prt_scsi_host(struct Scsi_Host *s)
 {
-	struct asc_board *boardp = shost_priv(s);
+	struct asc_board *boardp = asc_shost_priv(s);
 
 	printk("Scsi_Host at addr 0x%p, device %s\n", s, boardp->dev->bus_id);
 	printk(" host_busy %u, host_no %d, last_reset %d,\n",
@@ -2537,8 +2554,8 @@ static void asc_prt_scsi_host(struct Scs
 	printk(" dma_channel %d, this_id %d, can_queue %d,\n",
 	       s->dma_channel, s->this_id, s->can_queue);
 
-	printk(" cmd_per_lun %d, sg_tablesize %d, unchecked_isa_dma %d\n",
-	       s->cmd_per_lun, s->sg_tablesize, s->unchecked_isa_dma);
+	printk(" cmd_per_lun %d, sg_tablesize %d\n",
+	       s->cmd_per_lun, s->sg_tablesize);
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		asc_prt_asc_dvc_var(&boardp->dvc_var.asc_dvc_var);
@@ -2803,7 +2820,7 @@ static void * advansys_srb_to_ptr(struct
 static const char *advansys_info(struct Scsi_Host *shost)
 {
 	static char info[ASC_INFO_SIZE];
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp;
 	ADV_DVC_VAR *adv_dvc_varp;
 	char *busname;
@@ -2919,7 +2936,7 @@ static int asc_prt_line(char *buf, int b
  */
 static int asc_prt_board_devices(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
@@ -2959,7 +2976,7 @@ static int asc_prt_board_devices(struct 
  */
 static int asc_prt_adv_bios(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
@@ -3124,7 +3141,7 @@ static int asc_get_eeprom_string(ushort 
  */
 static int asc_prt_asc_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp;
 	int leftlen;
 	int totlen;
@@ -3257,7 +3274,7 @@ static int asc_prt_asc_board_eeprom(stru
  */
 static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	ADV_DVC_VAR *adv_dvc_varp;
 	int leftlen;
 	int totlen;
@@ -3543,7 +3560,7 @@ static int asc_prt_adv_board_eeprom(stru
  */
 static int asc_prt_driver_conf(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
@@ -3569,9 +3586,7 @@ static int asc_prt_driver_conf(struct Sc
 			   shost->sg_tablesize, shost->cmd_per_lun);
 	ASC_PRT_NEXT();
 
-	len = asc_prt_line(cp, leftlen,
-			   " unchecked_isa_dma %d, use_clustering %d\n",
-			   shost->unchecked_isa_dma, shost->use_clustering);
+	len = asc_prt_line(cp, leftlen, " use_clustering %d\n", shost->use_clustering);
 	ASC_PRT_NEXT();
 
 	len = asc_prt_line(cp, leftlen,
@@ -3605,7 +3620,7 @@ static int asc_prt_driver_conf(struct Sc
  */
 static int asc_prt_asc_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	int chip_scsi_id;
 	int leftlen;
 	int totlen;
@@ -3787,7 +3802,7 @@ static int asc_prt_asc_board_info(struct
  */
 static int asc_prt_adv_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
@@ -4065,7 +4080,7 @@ asc_proc_copy(off_t advoffset, off_t off
  */
 static int asc_prt_board_stats(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	struct asc_stats *s = &boardp->asc_stats;
 
 	int leftlen = cplen;
@@ -4151,7 +4166,7 @@ static int
 advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		   off_t offset, int length, int inout)
 {
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	char *cp;
 	int cplen;
 	int cnt;
@@ -8200,7 +8215,7 @@ static void adv_isr_callback(ADV_DVC_VAR
 	ASC_STATS(shost, callback);
 	ASC_DBG(1, "shost 0x%p\n", shost);
 
-	boardp = shost_priv(shost);
+	boardp = asc_shost_priv(shost);
 	BUG_ON(adv_dvc_varp != &boardp->dvc_var.adv_dvc_var);
 
 	/*
@@ -9132,9 +9147,18 @@ static void asc_isr_callback(ASC_DVC_VAR
 	ASC_STATS(shost, callback);
 	ASC_DBG(1, "shost 0x%p\n", shost);
 
-	boardp = shost_priv(shost);
+	boardp = asc_shost_priv(shost);
 	BUG_ON(asc_dvc_varp != &boardp->dvc_var.asc_dvc_var);
 
+	/* bounce sense buffer back and free bounce buffer */
+	if (scp->host_scribble) {
+		union adv_cmnd *h = (union adv_cmnd *)scp->host_scribble;
+		if (scp->cmnd[0] == REQUEST_SENSE && scp->sense_buffer)
+			memcpy(scp->sense_buffer, h->sense_buffer,
+			       SCSI_SENSE_BUFFERSIZE);
+		list_add(&boardp->adv_cmnd_free, &h->l);
+	}
+
 	dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
 			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	/*
@@ -9484,7 +9508,7 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 static int advansys_reset(struct scsi_cmnd *scp)
 {
 	struct Scsi_Host *shost = scp->device->host;
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	unsigned long flags;
 	int status;
 	int ret = SUCCESS;
@@ -9567,7 +9591,7 @@ static int
 advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		   sector_t capacity, int ip[])
 {
-	struct asc_board *boardp = shost_priv(sdev->host);
+	struct asc_board *boardp = asc_shost_priv(sdev->host);
 
 	ASC_DBG(1, "begin\n");
 	ASC_STATS(sdev->host, biosparam);
@@ -9603,7 +9627,7 @@ advansys_biosparam(struct scsi_device *s
 static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 {
 	struct Scsi_Host *shost = dev_id;
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	irqreturn_t result = IRQ_NONE;
 
 	ASC_DBG(2, "boardp 0x%p\n", boardp);
@@ -9691,6 +9715,9 @@ advansys_narrow_slave_configure(struct s
 	ASC_SCSI_BIT_ID_TYPE tid_bit = 1 << sdev->id;
 	ASC_SCSI_BIT_ID_TYPE orig_use_tagged_qng = asc_dvc->use_tagged_qng;
 
+	if (asc_shost_priv(sdev->host)->adv_bounce)
+		blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ISA);
+
 	if (sdev->lun == 0) {
 		ASC_SCSI_BIT_ID_TYPE orig_init_sdtr = asc_dvc->init_sdtr;
 		if ((asc_dvc->cfg->sdtr_enable & tid_bit) && sdev->sdtr) {
@@ -9865,7 +9892,7 @@ advansys_wide_slave_configure(struct scs
  */
 static int advansys_slave_configure(struct scsi_device *sdev)
 {
-	struct asc_board *boardp = shost_priv(sdev->host);
+	struct asc_board *boardp = asc_shost_priv(sdev->host);
 
 	if (ASC_NARROW_BOARD(boardp))
 		advansys_narrow_slave_configure(sdev,
@@ -9877,12 +9904,14 @@ static int advansys_slave_configure(stru
 	return 0;
 }
 
-static __le32 advansys_get_sense_buffer_dma(struct scsi_cmnd *scp)
+static __le32 advansys_get_sense_buffer_dma(struct scsi_cmnd *scp,
+					    union adv_cmnd *h)
 {
-	struct asc_board *board = shost_priv(scp->device->host);
-	scp->SCp.dma_handle = dma_map_single(board->dev, scp->sense_buffer,
+	struct asc_board *board = asc_shost_priv(scp->device->host);
+	void *buf = h ? (void *)h->sense_buffer : (void *)scp->sense_buffer;
+	scp->SCp.dma_handle = dma_map_single(board->dev, buf,
 					     SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
-	dma_cache_sync(board->dev, scp->sense_buffer,
+	dma_cache_sync(board->dev, buf,
 		       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	return cpu_to_le32(scp->SCp.dma_handle);
 }
@@ -9892,6 +9921,8 @@ static int asc_build_req(struct asc_boar
 {
 	struct asc_dvc_var *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 	int use_sg;
+	union adv_cmnd *h = NULL;
+
 
 	memset(asc_scsi_q, 0, sizeof(*asc_scsi_q));
 
@@ -9907,13 +9938,23 @@ static int asc_build_req(struct asc_boar
 	/*
 	 * Build the ASC_SCSI_Q request.
 	 */
-	asc_scsi_q->cdbptr = &scp->cmnd[0];
+	if (boardp->adv_bounce) {
+		/* get a isa bounce cmnd buffer. protected by host_lock */
+		h = (union adv_cmnd *)(boardp->adv_cmnd_free.next);
+		list_del(boardp->adv_cmnd_free.next);
+		asc_scsi_q->cdbptr = h->cmnd;
+		memcpy(h->cmnd, scp->cmnd, MAX_COMMAND_SIZE);
+		scp->host_scribble = (void *)h;
+	} else {
+		asc_scsi_q->cdbptr = &scp->cmnd[0];
+		scp->host_scribble = NULL;
+	}
 	asc_scsi_q->q2.cdb_len = scp->cmd_len;
 	asc_scsi_q->q1.target_id = ASC_TID_TO_TARGET_ID(scp->device->id);
 	asc_scsi_q->q1.target_lun = scp->device->lun;
 	asc_scsi_q->q2.target_ix =
 	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
-	asc_scsi_q->q1.sense_addr = advansys_get_sense_buffer_dma(scp);
+	asc_scsi_q->q1.sense_addr = advansys_get_sense_buffer_dma(scp, h);
 	asc_scsi_q->q1.sense_len = SCSI_SENSE_BUFFERSIZE;
 
 	/*
@@ -10925,7 +10966,7 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *
 static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 {
 	int ret, err_code;
-	struct asc_board *boardp = shost_priv(scp->device->host);
+	struct asc_board *boardp = asc_shost_priv(scp->device->host);
 
 	ASC_DBG(1, "scp 0x%p\n", scp);
 
@@ -11725,7 +11766,7 @@ static ushort __devinit AscInitFromEEP(A
 
 static int __devinit AscInitGetConfig(struct Scsi_Host *shost)
 {
-	struct asc_board *board = shost_priv(shost);
+	struct asc_board *board = asc_shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc = &board->dvc_var.asc_dvc_var;
 	unsigned short warn_code = 0;
 
@@ -11779,7 +11820,7 @@ static int __devinit AscInitGetConfig(st
 
 static int __devinit AscInitSetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 {
-	struct asc_board *board = shost_priv(shost);
+	struct asc_board *board = asc_shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc = &board->dvc_var.asc_dvc_var;
 	PortAddr iop_base = asc_dvc->iop_base;
 	unsigned short cfg_msw;
@@ -13172,7 +13213,7 @@ static int __devinit AdvInitFrom38C1600E
 static int __devinit
 AdvInitGetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 {
-	struct asc_board *board = shost_priv(shost);
+	struct asc_board *board = asc_shost_priv(shost);
 	ADV_DVC_VAR *asc_dvc = &board->dvc_var.adv_dvc_var;
 	unsigned short warn_code = 0;
 	AdvPortAddr iop_base = asc_dvc->iop_base;
@@ -13250,6 +13291,13 @@ AdvInitGetConfig(struct pci_dev *pdev, s
 }
 #endif
 
+static int advansys_adjust_queue(struct scsi_device *device)
+{
+	if (asc_shost_priv(device->host)->adv_bounce)
+		blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
+
 static struct scsi_host_template advansys_template = {
 	.proc_name = DRV_NAME,
 #ifdef CONFIG_PROC_FS
@@ -13261,12 +13309,7 @@ static struct scsi_host_template advansy
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
@@ -13279,7 +13322,7 @@ static struct scsi_host_template advansy
 
 static int __devinit advansys_wide_init_chip(struct Scsi_Host *shost)
 {
-	struct asc_board *board = shost_priv(shost);
+	struct asc_board *board = asc_shost_priv(shost);
 	struct adv_dvc_var *adv_dvc = &board->dvc_var.adv_dvc_var;
 	int req_cnt = 0;
 	adv_req_t *reqp = NULL;
@@ -13390,11 +13433,27 @@ static void advansys_wide_free_mem(struc
 	}
 }
 
+static int __devinit alloc_cmnd_bounce(struct asc_board *board)
+{
+	union adv_cmnd *h;
+	int i;
+
+	board->adv_bounce = (void *)__get_free_pages(GFP_KERNEL|GFP_DMA,
+						     get_order(ADV_BOUNCE_SIZE));
+	if (!board->adv_bounce)
+		return -ENOMEM;
+	h = board->adv_bounce;
+	INIT_LIST_HEAD(&board->adv_cmnd_free);
+	for (i = 0; i < ASC_DEF_MAX_HOST_QNG; i++, h++)
+		list_add_tail(&board->adv_cmnd_free, &h->l);
+	return 0;
+}
+
 static int __devinit advansys_board_found(struct Scsi_Host *shost,
 					  unsigned int iop, int bus_type)
 {
 	struct pci_dev *pdev;
-	struct asc_board *boardp = shost_priv(shost);
+	struct asc_board *boardp = asc_shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp = NULL;
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
 	int share_irq, warn_code, ret;
@@ -13464,6 +13523,8 @@ static int __devinit advansys_board_foun
 	}
 #endif /* CONFIG_PROC_FS */
 
+	ret = 0;
+
 	if (ASC_NARROW_BOARD(boardp)) {
 		/*
 		 * Set the board bus type and PCI IRQ before
@@ -13472,28 +13533,23 @@ static int __devinit advansys_board_foun
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
@@ -13505,14 +13561,14 @@ static int __devinit advansys_board_foun
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
 
@@ -13883,6 +13939,16 @@ static int __devinit advansys_board_foun
 	return ret;
 }
 
+static void adv_free_host(struct Scsi_Host *shost)
+{
+	struct asc_board *board = asc_shost_priv(shost);
+	if (board->adv_bounce)
+		free_pages((unsigned long)board->adv_bounce, get_order(ADV_BOUNCE_SIZE));
+	free_pages((unsigned long)asc_shost_priv(shost),
+		     get_order(sizeof(struct asc_board)));
+	scsi_host_put(shost);
+}
+
 /*
  * advansys_release()
  *
@@ -13890,7 +13956,7 @@ static int __devinit advansys_board_foun
  */
 static int advansys_release(struct Scsi_Host *shost)
 {
-	struct asc_board *board = shost_priv(shost);
+	struct asc_board *board = asc_shost_priv(shost);
 	ASC_DBG(1, "begin\n");
 	scsi_remove_host(shost);
 	free_irq(board->irq, shost);
@@ -13908,11 +13974,37 @@ static int advansys_release(struct Scsi_
 		advansys_wide_free_mem(board);
 	}
 	kfree(board->prtbuf);
-	scsi_host_put(shost);
+	adv_free_host(shost);
 	ASC_DBG(1, "end\n");
 	return 0;
 }
 
+static struct Scsi_Host *adv_host_alloc(gfp_t gfp)
+{
+	struct asc_board *board;
+	struct Scsi_Host *shost;
+	shost = scsi_host_alloc(&advansys_template, sizeof(struct asc_board_ptr));
+	if (!shost)
+		return NULL;
+
+	board = (void *)__get_free_pages(gfp|GFP_KERNEL,
+				 get_order(sizeof(struct asc_board)));
+	if (!board) {
+		scsi_host_put(shost);
+		return NULL;
+	}
+
+	memset(board, 0, sizeof(struct asc_board));
+	((struct asc_board_ptr *)shost_priv(shost))->b = board;
+
+	if ((gfp & GFP_DMA) && alloc_cmnd_bounce(board) < 0) {
+		adv_free_host(shost);
+		shost = NULL;
+	}
+
+	return shost;
+}
+
 #define ASC_IOADR_TABLE_MAX_IX  11
 
 static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] = {
@@ -13954,11 +14046,12 @@ static int __devinit advansys_isa_probe(
 		goto release_region;
 
 	err = -ENOMEM;
-	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
+	shost = adv_host_alloc(GFP_DMA);
 	if (!shost)
 		goto release_region;
 
-	board = shost_priv(shost);
+	board = asc_shost_priv(shost);
+
 	board->irq = advansys_isa_irq_no(iop_base);
 	board->dev = dev;
 
@@ -13970,7 +14063,7 @@ static int __devinit advansys_isa_probe(
 	return 0;
 
  free_host:
-	scsi_host_put(shost);
+	adv_free_host(shost);
  release_region:
 	release_region(iop_base, ASC_IOADR_GAP);
 	return err;
@@ -14036,11 +14129,11 @@ static int __devinit advansys_vlb_probe(
 		goto release_region;
 
 	err = -ENOMEM;
-	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
+	shost = adv_host_alloc(GFP_DMA); /* or 0? */
 	if (!shost)
 		goto release_region;
 
-	board = shost_priv(shost);
+	board = asc_shost_priv(shost);
 	board->irq = advansys_vlb_irq_no(iop_base);
 	board->dev = dev;
 
@@ -14052,7 +14145,7 @@ static int __devinit advansys_vlb_probe(
 	return 0;
 
  free_host:
-	scsi_host_put(shost);
+	adv_free_host(shost);
  release_region:
 	release_region(iop_base, ASC_IOADR_GAP);
 	return -ENODEV;
@@ -14143,11 +14236,12 @@ static int __devinit advansys_eisa_probe
 			irq = advansys_eisa_irq_no(edev);
 
 		err = -ENOMEM;
-		shost = scsi_host_alloc(&advansys_template, sizeof(*board));
+		shost = adv_host_alloc(GFP_DMA);
+
 		if (!shost)
 			goto release_region;
 
-		board = shost_priv(shost);
+		board = asc_shost_priv(shost);
 		board->irq = irq;
 		board->dev = dev;
 
@@ -14259,11 +14353,11 @@ advansys_pci_probe(struct pci_dev *pdev,
 	ioport = pci_resource_start(pdev, 0);
 
 	err = -ENOMEM;
-	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
+	shost = adv_host_alloc(0);
 	if (!shost)
 		goto release_region;
 
-	board = shost_priv(shost);
+	board = asc_shost_priv(shost);
 	board->irq = pdev->irq;
 	board->dev = &pdev->dev;
 
@@ -14281,7 +14375,7 @@ advansys_pci_probe(struct pci_dev *pdev,
 	return 0;
 
  free_host:
-	scsi_host_put(shost);
+	adv_free_host(shost);
  release_region:
 	pci_release_regions(pdev);
  disable_device:
