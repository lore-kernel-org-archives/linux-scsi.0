From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 10/17] advansys: Remove asc_board_t typedef and ASC_BOARDP macro
Date: Sun, 16 Sep 2007 14:39:06 -0600
Message-ID: <11899751462224-git-send-email-matthew@wil.cx>
References: <1189867145.3339.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:36486 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbXIPUix (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 16:38:53 -0400
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

asc_board_t was simply a typedef for struct asc_board.  ASC_BOARDP()
can be replaced by shost_priv() except in the ASC_STATS* macros which
rely on the cast; add an explicit cast there.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  132 ++++++++++++++++++-----------------------------
 1 files changed, 51 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 4c792db..e17626c 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2203,10 +2203,7 @@ do { \
          (sizeof(ADV_SG_BLOCK) * \
           ((ADV_MAX_SG_LIST + (NO_OF_SG_PER_BLOCK - 1))/NO_OF_SG_PER_BLOCK))
 
-/* Reference Scsi_Host hostdata */
-#define ASC_BOARDP(host) ((asc_board_t *) &((host)->hostdata))
-
-/* asc_board_t flags */
+/* struct asc_board flags */
 #define ASC_IS_WIDE_BOARD       0x04	/* AdvanSys Wide Board */
 
 #define ASC_NARROW_BOARD(boardp) (((boardp)->flags & ASC_IS_WIDE_BOARD) == 0)
@@ -2244,15 +2241,12 @@ do { \
 #define HOST_BYTE(byte)     ((byte) << 16)
 #define DRIVER_BYTE(byte)   ((byte) << 24)
 
+#define ASC_STATS(shost, counter) ASC_STATS_ADD(shost, counter, 1)
 #ifndef ADVANSYS_STATS
-#define ASC_STATS(shost, counter)
 #define ASC_STATS_ADD(shost, counter, count)
 #else /* ADVANSYS_STATS */
-#define ASC_STATS(shost, counter) \
-    (ASC_BOARDP(shost)->asc_stats.counter++)
-
 #define ASC_STATS_ADD(shost, counter, count) \
-    (ASC_BOARDP(shost)->asc_stats.counter += (count))
+	(((struct asc_board *) shost_priv(shost))->asc_stats.counter += (count))
 #endif /* ADVANSYS_STATS */
 
 #define ASC_CEILING(val, unit) (((val) + ((unit) - 1))/(unit))
@@ -2475,7 +2469,7 @@ typedef struct adv_req {
  * of the 'Scsi_Host' structure starting at the 'hostdata'
  * field. It is guaranteed to be allocated from DMA-able memory.
  */
-typedef struct asc_board {
+struct asc_board {
 	struct device *dev;
 	int id;			/* Board Id */
 	uint flags;		/* Board flags */
@@ -2523,7 +2517,7 @@ typedef struct asc_board {
 	ushort bios_version;	/* BIOS Version. */
 	ushort bios_codeseg;	/* BIOS Code Segment. */
 	ushort bios_codelen;	/* BIOS Code Segment Length. */
-} asc_board_t;
+};
 
 #define adv_dvc_to_board(adv_dvc) container_of(adv_dvc, struct asc_board, \
 							dvc_var.adv_dvc_var)
@@ -2543,9 +2537,7 @@ static int asc_dbglvl = 3;
  */
 static void asc_prt_scsi_host(struct Scsi_Host *s)
 {
-	asc_board_t *boardp;
-
-	boardp = ASC_BOARDP(s);
+	struct asc_board *boardp = shost_priv(s);
 
 	printk("Scsi_Host at addr 0x%lx\n", (ulong)s);
 	printk(" host_busy %u, host_no %d, last_reset %d,\n",
@@ -2561,11 +2553,11 @@ static void asc_prt_scsi_host(struct Scsi_Host *s)
 	       s->cmd_per_lun, s->sg_tablesize, s->unchecked_isa_dma);
 
 	if (ASC_NARROW_BOARD(boardp)) {
-		asc_prt_asc_dvc_var(&ASC_BOARDP(s)->dvc_var.asc_dvc_var);
-		asc_prt_asc_dvc_cfg(&ASC_BOARDP(s)->dvc_cfg.asc_dvc_cfg);
+		asc_prt_asc_dvc_var(boardp->dvc_var.asc_dvc_var);
+		asc_prt_asc_dvc_cfg(boardp->dvc_cfg.asc_dvc_cfg);
 	} else {
-		asc_prt_adv_dvc_var(&ASC_BOARDP(s)->dvc_var.adv_dvc_var);
-		asc_prt_adv_dvc_cfg(&ASC_BOARDP(s)->dvc_cfg.adv_dvc_cfg);
+		asc_prt_adv_dvc_var(boardp->dvc_var.adv_dvc_var);
+		asc_prt_adv_dvc_cfg(boardp->dvc_cfg.adv_dvc_cfg);
 	}
 }
 
@@ -2914,13 +2906,12 @@ static void asc_prt_hex(char *f, uchar *s, int l)
 static const char *advansys_info(struct Scsi_Host *shost)
 {
 	static char info[ASC_INFO_SIZE];
-	asc_board_t *boardp;
+	struct asc_board *boardp = shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp;
 	ADV_DVC_VAR *adv_dvc_varp;
 	char *busname;
 	char *widename = NULL;
 
-	boardp = ASC_BOARDP(shost);
 	if (ASC_NARROW_BOARD(boardp)) {
 		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
 		ASC_DBG(1, "advansys_info: begin\n");
@@ -3032,14 +3023,13 @@ static int asc_prt_line(char *buf, int buflen, char *fmt, ...)
  */
 static int asc_prt_board_devices(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	asc_board_t *boardp;
+	struct asc_board *boardp = shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
 	int chip_scsi_id;
 	int i;
 
-	boardp = ASC_BOARDP(shost);
 	leftlen = cplen;
 	totlen = len = 0;
 
@@ -3073,13 +3063,12 @@ static int asc_prt_board_devices(struct Scsi_Host *shost, char *cp, int cplen)
  */
 static int asc_prt_adv_bios(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	asc_board_t *boardp;
+	struct asc_board *boardp = shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
 	ushort major, minor, letter;
 
-	boardp = ASC_BOARDP(shost);
 	leftlen = cplen;
 	totlen = len = 0;
 
@@ -3239,7 +3228,7 @@ static int asc_get_eeprom_string(ushort *serialnum, uchar *cp)
  */
 static int asc_prt_asc_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	asc_board_t *boardp;
+	struct asc_board *boardp = shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp;
 	int leftlen;
 	int totlen;
@@ -3251,7 +3240,6 @@ static int asc_prt_asc_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 #endif /* CONFIG_ISA */
 	uchar serialstr[13];
 
-	boardp = ASC_BOARDP(shost);
 	asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
 	ep = &boardp->eep_config.asc_eep;
 
@@ -3373,7 +3361,7 @@ static int asc_prt_asc_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
  */
 static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	asc_board_t *boardp;
+	struct asc_board *boardp = shost_priv(shost);
 	ADV_DVC_VAR *adv_dvc_varp;
 	int leftlen;
 	int totlen;
@@ -3388,7 +3376,6 @@ static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 	ushort *wordp;
 	ushort sdtr_speed = 0;
 
-	boardp = ASC_BOARDP(shost);
 	adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		ep_3550 = &boardp->eep_config.adv_3550_eep;
@@ -3660,14 +3647,12 @@ static int asc_prt_adv_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
  */
 static int asc_prt_driver_conf(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	asc_board_t *boardp;
+	struct asc_board *boardp = shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
 	int chip_scsi_id;
 
-	boardp = ASC_BOARDP(shost);
-
 	leftlen = cplen;
 	totlen = len = 0;
 
@@ -3724,7 +3709,7 @@ static int asc_prt_driver_conf(struct Scsi_Host *shost, char *cp, int cplen)
  */
 static int asc_prt_asc_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	asc_board_t *boardp;
+	struct asc_board *boardp = shost_priv(shost);
 	int chip_scsi_id;
 	int leftlen;
 	int totlen;
@@ -3734,7 +3719,6 @@ static int asc_prt_asc_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 	int i;
 	int renegotiate = 0;
 
-	boardp = ASC_BOARDP(shost);
 	v = &boardp->dvc_var.asc_dvc_var;
 	c = &boardp->dvc_cfg.asc_dvc_cfg;
 	chip_scsi_id = c->chip_scsi_id;
@@ -3912,7 +3896,7 @@ static int asc_prt_asc_board_info(struct Scsi_Host *shost, char *cp, int cplen)
  */
 static int asc_prt_adv_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	asc_board_t *boardp;
+	struct asc_board *boardp = shost_priv(shost);
 	int leftlen;
 	int totlen;
 	int len;
@@ -3929,7 +3913,6 @@ static int asc_prt_adv_board_info(struct Scsi_Host *shost, char *cp, int cplen)
 	ushort period = 0;
 	int renegotiate = 0;
 
-	boardp = ASC_BOARDP(shost);
 	v = &boardp->dvc_var.adv_dvc_var;
 	c = &boardp->dvc_cfg.adv_dvc_cfg;
 	iop_base = v->iop_base;
@@ -4192,17 +4175,11 @@ asc_proc_copy(off_t advoffset, off_t offset, char *curbuf, int leftlen,
  */
 static int asc_prt_board_stats(struct Scsi_Host *shost, char *cp, int cplen)
 {
-	int leftlen;
-	int totlen;
-	int len;
-	struct asc_stats *s;
-	asc_board_t *boardp;
-
-	leftlen = cplen;
-	totlen = len = 0;
+	struct asc_board *boardp = shost_priv(shost);
+	struct asc_stats *s = &boardp->asc_stats;
 
-	boardp = ASC_BOARDP(shost);
-	s = &boardp->asc_stats;
+	int leftlen = cplen;
+	int len, totlen = 0;
 
 	len = asc_prt_line(cp, leftlen,
 			   "\nLinux Driver Statistics for AdvanSys SCSI Host %d:\n",
@@ -4309,7 +4286,7 @@ static int
 advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		   off_t offset, int length, int inout)
 {
-	asc_board_t *boardp;
+	struct asc_board *boardp = shost_priv(shost);
 	char *cp;
 	int cplen;
 	int cnt;
@@ -4323,16 +4300,13 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	/*
 	 * User write not supported.
 	 */
-	if (inout == TRUE) {
-		return (-ENOSYS);
-	}
+	if (inout == TRUE)
+		return -ENOSYS;
 
 	/*
 	 * User read of /proc/scsi/advansys/[0...] file.
 	 */
 
-	boardp = ASC_BOARDP(shost);
-
 	/* Copy read data starting at the beginning of the buffer. */
 	*start = buffer;
 	curbuf = buffer;
@@ -4477,7 +4451,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 
 static void asc_scsi_done(struct scsi_cmnd *scp)
 {
-	struct asc_board *boardp = ASC_BOARDP(scp->device->host);
+	struct asc_board *boardp = shost_priv(scp->device->host);
 
 	if (scp->use_sg)
 		dma_unmap_sg(boardp->dev,
@@ -8376,7 +8350,7 @@ static void adv_async_callback(ADV_DVC_VAR *adv_dvc_varp, uchar code)
  */
 static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 {
-	asc_board_t *boardp;
+	struct asc_board *boardp;
 	adv_req_t *reqp;
 	adv_sgblk_t *sgblkp;
 	struct scsi_cmnd *scp;
@@ -8420,7 +8394,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	ASC_STATS(shost, callback);
 	ASC_DBG1(1, "adv_isr_callback: shost 0x%lx\n", (ulong)shost);
 
-	boardp = ASC_BOARDP(shost);
+	boardp = shost_priv(shost);
 	BUG_ON(adv_dvc_varp != &boardp->dvc_var.adv_dvc_var);
 
 	/*
@@ -8825,7 +8799,7 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 	uchar cur_dvc_qng;
 	uchar asyn_sdtr;
 	uchar scsi_status;
-	asc_board_t *boardp;
+	struct asc_board *boardp;
 
 	BUG_ON(!asc_dvc->drv_ptr);
 	boardp = asc_dvc->drv_ptr;
@@ -9346,7 +9320,7 @@ _AscCopyLramScsiDoneQ(PortAddr iop_base,
  */
 static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 {
-	asc_board_t *boardp;
+	struct asc_board *boardp;
 	struct scsi_cmnd *scp;
 	struct Scsi_Host *shost;
 
@@ -9371,7 +9345,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	ASC_STATS(shost, callback);
 	ASC_DBG1(1, "asc_isr_callback: shost 0x%lx\n", (ulong)shost);
 
-	boardp = ASC_BOARDP(shost);
+	boardp = shost_priv(shost);
 	BUG_ON(asc_dvc_varp != &boardp->dvc_var.asc_dvc_var);
 
 	/*
@@ -9727,7 +9701,7 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 static int advansys_reset(struct scsi_cmnd *scp)
 {
 	struct Scsi_Host *shost = scp->device->host;
-	struct asc_board *boardp = ASC_BOARDP(shost);
+	struct asc_board *boardp = shost_priv(shost);
 	unsigned long flags;
 	int status;
 	int ret = SUCCESS;
@@ -9810,11 +9784,10 @@ static int
 advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		   sector_t capacity, int ip[])
 {
-	asc_board_t *boardp;
+	struct asc_board *boardp = shost_priv(sdev->host);
 
 	ASC_DBG(1, "advansys_biosparam: begin\n");
 	ASC_STATS(sdev->host, biosparam);
-	boardp = ASC_BOARDP(sdev->host);
 	if (ASC_NARROW_BOARD(boardp)) {
 		if ((boardp->dvc_var.asc_dvc_var.dvc_cntl &
 		     ASC_CNTL_BIOS_GT_1GB) && capacity > 0x200000) {
@@ -9848,7 +9821,7 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 {
 	unsigned long flags;
 	struct Scsi_Host *shost = dev_id;
-	asc_board_t *boardp = ASC_BOARDP(shost);
+	struct asc_board *boardp = shost_priv(shost);
 	irqreturn_t result = IRQ_NONE;
 
 	ASC_DBG1(2, "advansys_interrupt: boardp 0x%p\n", boardp);
@@ -10110,7 +10083,7 @@ advansys_wide_slave_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv_dvc)
  */
 static int advansys_slave_configure(struct scsi_device *sdev)
 {
-	asc_board_t *boardp = ASC_BOARDP(sdev->host);
+	struct asc_board *boardp = shost_priv(sdev->host);
 
 	if (ASC_NARROW_BOARD(boardp))
 		advansys_narrow_slave_configure(sdev,
@@ -10122,7 +10095,7 @@ static int advansys_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
+static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 			struct asc_scsi_q *asc_scsi_q)
 {
 	memset(asc_scsi_q, 0, sizeof(*asc_scsi_q));
@@ -10257,7 +10230,7 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
  *      ADV_ERROR(-1) - SG List creation failed
  */
 static int
-adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
+adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 	       int use_sg)
 {
 	adv_sgblk_t *sgblkp;
@@ -10367,7 +10340,7 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
  * to little-endian order.
  */
 static int
-adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
+adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	      ADV_SCSI_REQ_Q **adv_scsiqpp)
 {
 	adv_req_t *reqp;
@@ -11255,7 +11228,7 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 {
 	int ret, err_code;
-	asc_board_t *boardp = ASC_BOARDP(scp->device->host);
+	struct asc_board *boardp = shost_priv(scp->device->host);
 
 	ASC_DBG1(1, "asc_execute_scsi_cmnd: scp 0x%p\n", scp);
 
@@ -11346,7 +11319,7 @@ static int
 advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 {
 	struct Scsi_Host *shost = scp->device->host;
-	asc_board_t *boardp = ASC_BOARDP(shost);
+	struct asc_board *boardp = shost_priv(shost);
 	unsigned long flags;
 	int asc_res, result = 0;
 
@@ -12094,7 +12067,7 @@ static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static int __devinit AscInitGetConfig(asc_board_t *boardp)
+static int __devinit AscInitGetConfig(struct asc_board *boardp)
 {
 	ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 	unsigned short warn_code = 0;
@@ -12151,7 +12124,7 @@ static int __devinit AscInitGetConfig(asc_board_t *boardp)
 	return asc_dvc->err_code;
 }
 
-static int __devinit AscInitSetConfig(struct pci_dev *pdev, asc_board_t *boardp)
+static int __devinit AscInitSetConfig(struct pci_dev *pdev, struct asc_board *boardp)
 {
 	ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 	PortAddr iop_base = asc_dvc->iop_base;
@@ -13548,7 +13521,7 @@ static int __devinit AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
  * then 0 is returned.
  */
 static int __devinit
-AdvInitGetConfig(struct pci_dev *pdev, asc_board_t *boardp)
+AdvInitGetConfig(struct pci_dev *pdev, struct asc_board *boardp)
 {
 	ADV_DVC_VAR *asc_dvc = &boardp->dvc_var.adv_dvc_var;
 	unsigned short warn_code = 0;
@@ -13660,7 +13633,7 @@ static struct scsi_host_template advansys_template = {
 };
 
 static int __devinit
-advansys_wide_init_chip(asc_board_t *boardp, ADV_DVC_VAR *adv_dvc_varp)
+advansys_wide_init_chip(struct asc_board *boardp, ADV_DVC_VAR *adv_dvc_varp)
 {
 	int req_cnt = 0;
 	adv_req_t *reqp = NULL;
@@ -13764,7 +13737,7 @@ advansys_wide_init_chip(asc_board_t *boardp, ADV_DVC_VAR *adv_dvc_varp)
 	return err_code;
 }
 
-static void advansys_wide_free_mem(asc_board_t *boardp)
+static void advansys_wide_free_mem(struct asc_board *boardp)
 {
 	kfree(boardp->carrp);
 	boardp->carrp = NULL;
@@ -13781,12 +13754,11 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 					  unsigned int iop, int bus_type)
 {
 	struct pci_dev *pdev;
-	asc_board_t *boardp;
+	struct asc_board *boardp = shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp = NULL;
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
 	int share_irq, warn_code, ret;
 
-	boardp = ASC_BOARDP(shost);
 	boardp->id = asc_board_count++;
 	spin_lock_init(&boardp->lock);
 	pdev = (bus_type == ASC_IS_PCI) ? to_pci_dev(boardp->dev) : NULL;
@@ -14282,11 +14254,9 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
  */
 static int advansys_release(struct Scsi_Host *shost)
 {
-	asc_board_t *boardp;
-
+	struct asc_board *boardp = shost_priv(shost); 
 	ASC_DBG(1, "advansys_release: begin\n");
 	scsi_remove_host(shost);
-	boardp = ASC_BOARDP(shost);
 	free_irq(boardp->irq, shost);
 	if (shost->dma_channel != NO_ISA_DMA) {
 		ASC_DBG(1, "advansys_release: free_dma()\n");
@@ -14348,7 +14318,7 @@ static int __devinit advansys_isa_probe(struct device *dev, unsigned int id)
 	if (!shost)
 		goto release_region;
 
-	board = ASC_BOARDP(shost);
+	board = shost_priv(shost);
 	board->irq = advansys_isa_irq_no(iop_base);
 	board->dev = dev;
 
@@ -14431,7 +14401,7 @@ static int __devinit advansys_vlb_probe(struct device *dev, unsigned int id)
 	if (!shost)
 		goto release_region;
 
-	board = ASC_BOARDP(shost);
+	board = shost_priv(shost);
 	board->irq = advansys_vlb_irq_no(iop_base);
 	board->dev = dev;
 
@@ -14538,7 +14508,7 @@ static int __devinit advansys_eisa_probe(struct device *dev)
 		if (!shost)
 			goto release_region;
 
-		board = ASC_BOARDP(shost);
+		board = shost_priv(shost);
 		board->irq = irq;
 		board->dev = dev;
 
@@ -14654,7 +14624,7 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!shost)
 		goto release_region;
 
-	board = ASC_BOARDP(shost);
+	board = shost_priv(shost);
 	board->irq = pdev->irq;
 	board->dev = &pdev->dev;
 
-- 
1.5.2.4

