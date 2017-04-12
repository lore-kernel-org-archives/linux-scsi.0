From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 15/17] cxlflash: Support multiple hardware queues
Date: Wed, 12 Apr 2017 14:15:42 -0500
Message-ID: <1492024542-56194-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752304AbdDLTQC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:16:02 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ9AQO087053
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:16:02 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29sn06gpew-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:16:01 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 13:16:01 -0600
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Introduce multiple hardware queues to improve legacy I/O path performance.
Each hardware queue is comprised of a master context and associated I/O
resources. The hardware queues are initially implemented as a static array
embedded in the AFU. This will be transitioned to a dynamic allocation in a
later series to improve the memory footprint of the driver.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h    |  41 ++--
 drivers/scsi/cxlflash/main.c      | 426 ++++++++++++++++++++++++--------------
 drivers/scsi/cxlflash/superpipe.c |   6 +-
 3 files changed, 309 insertions(+), 164 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index c69cdcf..b5858ae 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -60,6 +60,9 @@ extern const struct file_operations cxlflash_cxl_fops;
 /* SQ for master issued cmds */
 #define NUM_SQ_ENTRY			CXLFLASH_MAX_CMDS
 
+#define CXLFLASH_NUM_HWQS		1
+#define PRIMARY_HWQ			0
+
 
 static inline void check_sizes(void)
 {
@@ -98,7 +101,6 @@ enum cxlflash_state {
 
 struct cxlflash_cfg {
 	struct afu *afu;
-	struct cxl_context *mcctx;
 
 	struct pci_dev *dev;
 	struct pci_device_id *dev_id;
@@ -144,6 +146,7 @@ struct afu_cmd {
 	struct list_head queue;
 
 	u8 cmd_tmf:1;
+	u32 hwq_index;
 
 	/* As per the SISLITE spec the IOARCB EA has to be 16-byte aligned.
 	 * However for performance reasons the IOARCB/IOASA should be
@@ -164,7 +167,7 @@ static inline struct afu_cmd *sc_to_afucz(struct scsi_cmnd *sc)
 	return afuc;
 }
 
-struct afu {
+struct hwq {
 	/* Stuff requiring alignment go first. */
 	struct sisl_ioarcb sq[NUM_SQ_ENTRY];		/* 16K SQ */
 	u64 rrq_entry[NUM_RRQ_ENTRY];			/* 2K RRQ */
@@ -172,17 +175,13 @@ struct afu {
 	/* Beware of alignment till here. Preferably introduce new
 	 * fields after this point
 	 */
-
-	int (*send_cmd)(struct afu *, struct afu_cmd *);
-	void (*context_reset)(struct afu_cmd *);
-
-	/* AFU HW */
+	struct afu *afu;
+	struct cxl_context *ctx;
 	struct cxl_ioctl_start_work work;
-	struct cxlflash_afu_map __iomem *afu_map;	/* entire MMIO map */
 	struct sisl_host_map __iomem *host_map;		/* MC host map */
 	struct sisl_ctrl_map __iomem *ctrl_map;		/* MC control map */
-
 	ctx_hndl_t ctx_hndl;	/* master's context handle */
+	u32 index;		/* Index of this hwq */
 
 	atomic_t hsq_credits;
 	spinlock_t hsq_slock;
@@ -194,9 +193,22 @@ struct afu {
 	u64 *hrrq_end;
 	u64 *hrrq_curr;
 	bool toggle;
-	atomic_t cmds_active;	/* Number of currently active AFU commands */
+
 	s64 room;
 	spinlock_t rrin_slock; /* Lock to rrin queuing and cmd_room updates */
+
+	struct irq_poll irqpoll;
+} __aligned(cache_line_size());
+
+struct afu {
+	struct hwq hwqs[CXLFLASH_NUM_HWQS];
+	int (*send_cmd)(struct afu *, struct afu_cmd *);
+	void (*context_reset)(struct afu_cmd *);
+
+	/* AFU HW */
+	struct cxlflash_afu_map __iomem *afu_map;	/* entire MMIO map */
+
+	atomic_t cmds_active;	/* Number of currently active AFU commands */
 	u64 hb;
 	u32 internal_lun;	/* User-desired LUN mode for this AFU */
 
@@ -204,11 +216,16 @@ struct afu {
 	u64 interface_version;
 
 	u32 irqpoll_weight;
-	struct irq_poll irqpoll;
 	struct cxlflash_cfg *parent; /* Pointer back to parent cxlflash_cfg */
-
 };
 
+static inline struct hwq *get_hwq(struct afu *afu, u32 index)
+{
+	WARN_ON(index >= CXLFLASH_NUM_HWQS);
+
+	return &afu->hwqs[index];
+}
+
 static inline bool afu_is_irqpoll_enabled(struct afu *afu)
 {
 	return !!afu->irqpoll_weight;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index c60936f..5d06869 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -223,8 +223,9 @@ static void context_reset(struct afu_cmd *cmd, __be64 __iomem *reset_reg)
 static void context_reset_ioarrin(struct afu_cmd *cmd)
 {
 	struct afu *afu = cmd->parent;
+	struct hwq *hwq = get_hwq(afu, cmd->hwq_index);
 
-	context_reset(cmd, &afu->host_map->ioarrin);
+	context_reset(cmd, &hwq->host_map->ioarrin);
 }
 
 /**
@@ -234,8 +235,9 @@ static void context_reset_ioarrin(struct afu_cmd *cmd)
 static void context_reset_sq(struct afu_cmd *cmd)
 {
 	struct afu *afu = cmd->parent;
+	struct hwq *hwq = get_hwq(afu, cmd->hwq_index);
 
-	context_reset(cmd, &afu->host_map->sq_ctx_reset);
+	context_reset(cmd, &hwq->host_map->sq_ctx_reset);
 }
 
 /**
@@ -250,6 +252,7 @@ static int send_cmd_ioarrin(struct afu *afu, struct afu_cmd *cmd)
 {
 	struct cxlflash_cfg *cfg = afu->parent;
 	struct device *dev = &cfg->dev->dev;
+	struct hwq *hwq = get_hwq(afu, cmd->hwq_index);
 	int rc = 0;
 	s64 room;
 	ulong lock_flags;
@@ -258,23 +261,23 @@ static int send_cmd_ioarrin(struct afu *afu, struct afu_cmd *cmd)
 	 * To avoid the performance penalty of MMIO, spread the update of
 	 * 'room' over multiple commands.
 	 */
-	spin_lock_irqsave(&afu->rrin_slock, lock_flags);
-	if (--afu->room < 0) {
-		room = readq_be(&afu->host_map->cmd_room);
+	spin_lock_irqsave(&hwq->rrin_slock, lock_flags);
+	if (--hwq->room < 0) {
+		room = readq_be(&hwq->host_map->cmd_room);
 		if (room <= 0) {
 			dev_dbg_ratelimited(dev, "%s: no cmd_room to send "
 					    "0x%02X, room=0x%016llX\n",
 					    __func__, cmd->rcb.cdb[0], room);
-			afu->room = 0;
+			hwq->room = 0;
 			rc = SCSI_MLQUEUE_HOST_BUSY;
 			goto out;
 		}
-		afu->room = room - 1;
+		hwq->room = room - 1;
 	}
 
-	writeq_be((u64)&cmd->rcb, &afu->host_map->ioarrin);
+	writeq_be((u64)&cmd->rcb, &hwq->host_map->ioarrin);
 out:
-	spin_unlock_irqrestore(&afu->rrin_slock, lock_flags);
+	spin_unlock_irqrestore(&hwq->rrin_slock, lock_flags);
 	dev_dbg(dev, "%s: cmd=%p len=%u ea=%016llx rc=%d\n", __func__,
 		cmd, cmd->rcb.data_len, cmd->rcb.data_ea, rc);
 	return rc;
@@ -292,11 +295,12 @@ static int send_cmd_sq(struct afu *afu, struct afu_cmd *cmd)
 {
 	struct cxlflash_cfg *cfg = afu->parent;
 	struct device *dev = &cfg->dev->dev;
+	struct hwq *hwq = get_hwq(afu, cmd->hwq_index);
 	int rc = 0;
 	int newval;
 	ulong lock_flags;
 
-	newval = atomic_dec_if_positive(&afu->hsq_credits);
+	newval = atomic_dec_if_positive(&hwq->hsq_credits);
 	if (newval <= 0) {
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
@@ -304,22 +308,22 @@ static int send_cmd_sq(struct afu *afu, struct afu_cmd *cmd)
 
 	cmd->rcb.ioasa = &cmd->sa;
 
-	spin_lock_irqsave(&afu->hsq_slock, lock_flags);
+	spin_lock_irqsave(&hwq->hsq_slock, lock_flags);
 
-	*afu->hsq_curr = cmd->rcb;
-	if (afu->hsq_curr < afu->hsq_end)
-		afu->hsq_curr++;
+	*hwq->hsq_curr = cmd->rcb;
+	if (hwq->hsq_curr < hwq->hsq_end)
+		hwq->hsq_curr++;
 	else
-		afu->hsq_curr = afu->hsq_start;
-	writeq_be((u64)afu->hsq_curr, &afu->host_map->sq_tail);
+		hwq->hsq_curr = hwq->hsq_start;
+	writeq_be((u64)hwq->hsq_curr, &hwq->host_map->sq_tail);
 
-	spin_unlock_irqrestore(&afu->hsq_slock, lock_flags);
+	spin_unlock_irqrestore(&hwq->hsq_slock, lock_flags);
 out:
 	dev_dbg(dev, "%s: cmd=%p len=%u ea=%016llx ioasa=%p rc=%d curr=%p "
 	       "head=%016llx tail=%016llx\n", __func__, cmd, cmd->rcb.data_len,
-	       cmd->rcb.data_ea, cmd->rcb.ioasa, rc, afu->hsq_curr,
-	       readq_be(&afu->host_map->sq_head),
-	       readq_be(&afu->host_map->sq_tail));
+	       cmd->rcb.data_ea, cmd->rcb.ioasa, rc, hwq->hsq_curr,
+	       readq_be(&hwq->host_map->sq_head),
+	       readq_be(&hwq->host_map->sq_tail));
 	return rc;
 }
 
@@ -367,6 +371,7 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	struct cxlflash_cfg *cfg = shost_priv(scp->device->host);
 	struct afu_cmd *cmd = sc_to_afucz(scp);
 	struct device *dev = &cfg->dev->dev;
+	struct hwq *hwq = get_hwq(afu, PRIMARY_HWQ);
 	ulong lock_flags;
 	int rc = 0;
 	ulong to;
@@ -383,8 +388,9 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	cmd->scp = scp;
 	cmd->parent = afu;
 	cmd->cmd_tmf = true;
+	cmd->hwq_index = hwq->index;
 
-	cmd->rcb.ctx_id = afu->ctx_hndl;
+	cmd->rcb.ctx_id = hwq->ctx_hndl;
 	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
 	cmd->rcb.port_sel = CHAN2PORTMASK(scp->device->channel);
 	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
@@ -442,6 +448,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	struct device *dev = &cfg->dev->dev;
 	struct afu_cmd *cmd = sc_to_afucz(scp);
 	struct scatterlist *sg = scsi_sglist(scp);
+	struct hwq *hwq = get_hwq(afu, PRIMARY_HWQ);
 	u16 req_flags = SISL_REQ_FLAGS_SUP_UNDERRUN;
 	ulong lock_flags;
 	int rc = 0;
@@ -491,8 +498,9 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 
 	cmd->scp = scp;
 	cmd->parent = afu;
+	cmd->hwq_index = hwq->index;
 
-	cmd->rcb.ctx_id = afu->ctx_hndl;
+	cmd->rcb.ctx_id = hwq->ctx_hndl;
 	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
 	cmd->rcb.port_sel = CHAN2PORTMASK(scp->device->channel);
 	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
@@ -548,14 +556,23 @@ static void free_mem(struct cxlflash_cfg *cfg)
 static void stop_afu(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
+	struct hwq *hwq;
+	int i;
 
 	cancel_work_sync(&cfg->work_q);
 
 	if (likely(afu)) {
 		while (atomic_read(&afu->cmds_active))
 			ssleep(1);
-		if (afu_is_irqpoll_enabled(afu))
-			irq_poll_disable(&afu->irqpoll);
+
+		if (afu_is_irqpoll_enabled(afu)) {
+			for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+				hwq = get_hwq(afu, i);
+
+				irq_poll_disable(&hwq->irqpoll);
+			}
+		}
+
 		if (likely(afu->afu_map)) {
 			cxl_psa_unmap((void __iomem *)afu->afu_map);
 			afu->afu_map = NULL;
@@ -567,28 +584,40 @@ static void stop_afu(struct cxlflash_cfg *cfg)
  * term_intr() - disables all AFU interrupts
  * @cfg:	Internal structure associated with the host.
  * @level:	Depth of allocation, where to begin waterfall tear down.
+ * @index:	Index of the hardware queue.
  *
  * Safe to call with AFU/MC in partially allocated/initialized state.
  */
-static void term_intr(struct cxlflash_cfg *cfg, enum undo_level level)
+static void term_intr(struct cxlflash_cfg *cfg, enum undo_level level,
+		      u32 index)
 {
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
+	struct hwq *hwq;
 
-	if (!afu || !cfg->mcctx) {
-		dev_err(dev, "%s: returning with NULL afu or MC\n", __func__);
+	if (!afu) {
+		dev_err(dev, "%s: returning with NULL afu\n", __func__);
+		return;
+	}
+
+	hwq = get_hwq(afu, index);
+
+	if (!hwq->ctx) {
+		dev_err(dev, "%s: returning with NULL MC\n", __func__);
 		return;
 	}
 
 	switch (level) {
 	case UNMAP_THREE:
-		cxl_unmap_afu_irq(cfg->mcctx, 3, afu);
+		/* SISL_MSI_ASYNC_ERROR is setup only for the primary HWQ */
+		if (index == PRIMARY_HWQ)
+			cxl_unmap_afu_irq(hwq->ctx, 3, hwq);
 	case UNMAP_TWO:
-		cxl_unmap_afu_irq(cfg->mcctx, 2, afu);
+		cxl_unmap_afu_irq(hwq->ctx, 2, hwq);
 	case UNMAP_ONE:
-		cxl_unmap_afu_irq(cfg->mcctx, 1, afu);
+		cxl_unmap_afu_irq(hwq->ctx, 1, hwq);
 	case FREE_IRQ:
-		cxl_free_afu_irqs(cfg->mcctx);
+		cxl_free_afu_irqs(hwq->ctx);
 		/* fall through */
 	case UNDO_NOOP:
 		/* No action required */
@@ -599,24 +628,32 @@ static void term_intr(struct cxlflash_cfg *cfg, enum undo_level level)
 /**
  * term_mc() - terminates the master context
  * @cfg:	Internal structure associated with the host.
- * @level:	Depth of allocation, where to begin waterfall tear down.
+ * @index:	Index of the hardware queue.
  *
  * Safe to call with AFU/MC in partially allocated/initialized state.
  */
-static void term_mc(struct cxlflash_cfg *cfg)
+static void term_mc(struct cxlflash_cfg *cfg, u32 index)
 {
-	int rc = 0;
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
+	struct hwq *hwq;
 
-	if (!afu || !cfg->mcctx) {
-		dev_err(dev, "%s: returning with NULL afu or MC\n", __func__);
+	if (!afu) {
+		dev_err(dev, "%s: returning with NULL afu\n", __func__);
 		return;
 	}
 
-	rc = cxl_stop_context(cfg->mcctx);
-	WARN_ON(rc);
-	cfg->mcctx = NULL;
+	hwq = get_hwq(afu, index);
+
+	if (!hwq->ctx) {
+		dev_err(dev, "%s: returning with NULL MC\n", __func__);
+		return;
+	}
+
+	WARN_ON(cxl_stop_context(hwq->ctx));
+	if (index != PRIMARY_HWQ)
+		WARN_ON(cxl_release_context(hwq->ctx));
+	hwq->ctx = NULL;
 }
 
 /**
@@ -628,21 +665,25 @@ static void term_mc(struct cxlflash_cfg *cfg)
 static void term_afu(struct cxlflash_cfg *cfg)
 {
 	struct device *dev = &cfg->dev->dev;
+	int k;
 
 	/*
 	 * Tear down is carefully orchestrated to ensure
 	 * no interrupts can come in when the problem state
 	 * area is unmapped.
 	 *
-	 * 1) Disable all AFU interrupts
+	 * 1) Disable all AFU interrupts for each master
 	 * 2) Unmap the problem state area
-	 * 3) Stop the master context
+	 * 3) Stop each master context
 	 */
-	term_intr(cfg, UNMAP_THREE);
+	for (k = CXLFLASH_NUM_HWQS - 1; k >= 0; k--)
+		term_intr(cfg, UNMAP_THREE, k);
+
 	if (cfg->afu)
 		stop_afu(cfg);
 
-	term_mc(cfg);
+	for (k = CXLFLASH_NUM_HWQS - 1; k >= 0; k--)
+		term_mc(cfg, k);
 
 	dev_dbg(dev, "%s: returning\n", __func__);
 }
@@ -1026,6 +1067,7 @@ static void afu_err_intr_init(struct afu *afu)
 	struct cxlflash_cfg *cfg = afu->parent;
 	__be64 __iomem *fc_port_regs;
 	int i;
+	struct hwq *hwq = get_hwq(afu, PRIMARY_HWQ);
 	u64 reg;
 
 	/* global async interrupts: AFU clears afu_ctrl on context exit
@@ -1037,8 +1079,8 @@ static void afu_err_intr_init(struct afu *afu)
 
 	/* mask all */
 	writeq_be(-1ULL, &afu->afu_map->global.regs.aintr_mask);
-	/* set LISN# to send and point to master context */
-	reg = ((u64) (((afu->ctx_hndl << 8) | SISL_MSI_ASYNC_ERROR)) << 40);
+	/* set LISN# to send and point to primary master context */
+	reg = ((u64) (((hwq->ctx_hndl << 8) | SISL_MSI_ASYNC_ERROR)) << 40);
 
 	if (afu->internal_lun)
 		reg |= 1;	/* Bit 63 indicates local lun */
@@ -1074,8 +1116,12 @@ static void afu_err_intr_init(struct afu *afu)
 	/* IOARRIN yet), so there is nothing to clear. */
 
 	/* set LISN#, it is always sent to the context that wrote IOARRIN */
-	writeq_be(SISL_MSI_SYNC_ERROR, &afu->host_map->ctx_ctrl);
-	writeq_be(SISL_ISTATUS_MASK, &afu->host_map->intr_mask);
+	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+		hwq = get_hwq(afu, i);
+
+		writeq_be(SISL_MSI_SYNC_ERROR, &hwq->host_map->ctx_ctrl);
+		writeq_be(SISL_ISTATUS_MASK, &hwq->host_map->intr_mask);
+	}
 }
 
 /**
@@ -1087,13 +1133,13 @@ static void afu_err_intr_init(struct afu *afu)
  */
 static irqreturn_t cxlflash_sync_err_irq(int irq, void *data)
 {
-	struct afu *afu = (struct afu *)data;
-	struct cxlflash_cfg *cfg = afu->parent;
+	struct hwq *hwq = (struct hwq *)data;
+	struct cxlflash_cfg *cfg = hwq->afu->parent;
 	struct device *dev = &cfg->dev->dev;
 	u64 reg;
 	u64 reg_unmasked;
 
-	reg = readq_be(&afu->host_map->intr_status);
+	reg = readq_be(&hwq->host_map->intr_status);
 	reg_unmasked = (reg & SISL_ISTATUS_UNMASK);
 
 	if (reg_unmasked == 0UL) {
@@ -1105,7 +1151,7 @@ static irqreturn_t cxlflash_sync_err_irq(int irq, void *data)
 	dev_err(dev, "%s: unexpected interrupt, intr_status=%016llx\n",
 		__func__, reg);
 
-	writeq_be(reg_unmasked, &afu->host_map->intr_clear);
+	writeq_be(reg_unmasked, &hwq->host_map->intr_clear);
 
 cxlflash_sync_err_irq_exit:
 	return IRQ_HANDLED;
@@ -1121,17 +1167,18 @@ static irqreturn_t cxlflash_sync_err_irq(int irq, void *data)
  *
  * Return: The number of entries processed.
  */
-static int process_hrrq(struct afu *afu, struct list_head *doneq, int budget)
+static int process_hrrq(struct hwq *hwq, struct list_head *doneq, int budget)
 {
+	struct afu *afu = hwq->afu;
 	struct afu_cmd *cmd;
 	struct sisl_ioasa *ioasa;
 	struct sisl_ioarcb *ioarcb;
-	bool toggle = afu->toggle;
+	bool toggle = hwq->toggle;
 	int num_hrrq = 0;
 	u64 entry,
-	    *hrrq_start = afu->hrrq_start,
-	    *hrrq_end = afu->hrrq_end,
-	    *hrrq_curr = afu->hrrq_curr;
+	    *hrrq_start = hwq->hrrq_start,
+	    *hrrq_end = hwq->hrrq_end,
+	    *hrrq_curr = hwq->hrrq_curr;
 
 	/* Process ready RRQ entries up to the specified budget (if any) */
 	while (true) {
@@ -1160,15 +1207,15 @@ static int process_hrrq(struct afu *afu, struct list_head *doneq, int budget)
 			toggle ^= SISL_RESP_HANDLE_T_BIT;
 		}
 
-		atomic_inc(&afu->hsq_credits);
+		atomic_inc(&hwq->hsq_credits);
 		num_hrrq++;
 
 		if (budget > 0 && num_hrrq >= budget)
 			break;
 	}
 
-	afu->hrrq_curr = hrrq_curr;
-	afu->toggle = toggle;
+	hwq->hrrq_curr = hrrq_curr;
+	hwq->toggle = toggle;
 
 	return num_hrrq;
 }
@@ -1198,18 +1245,18 @@ static void process_cmd_doneq(struct list_head *doneq)
  */
 static int cxlflash_irqpoll(struct irq_poll *irqpoll, int budget)
 {
-	struct afu *afu = container_of(irqpoll, struct afu, irqpoll);
+	struct hwq *hwq = container_of(irqpoll, struct hwq, irqpoll);
 	unsigned long hrrq_flags;
 	LIST_HEAD(doneq);
 	int num_entries = 0;
 
-	spin_lock_irqsave(&afu->hrrq_slock, hrrq_flags);
+	spin_lock_irqsave(&hwq->hrrq_slock, hrrq_flags);
 
-	num_entries = process_hrrq(afu, &doneq, budget);
+	num_entries = process_hrrq(hwq, &doneq, budget);
 	if (num_entries < budget)
 		irq_poll_complete(irqpoll);
 
-	spin_unlock_irqrestore(&afu->hrrq_slock, hrrq_flags);
+	spin_unlock_irqrestore(&hwq->hrrq_slock, hrrq_flags);
 
 	process_cmd_doneq(&doneq);
 	return num_entries;
@@ -1224,21 +1271,22 @@ static int cxlflash_irqpoll(struct irq_poll *irqpoll, int budget)
  */
 static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 {
-	struct afu *afu = (struct afu *)data;
+	struct hwq *hwq = (struct hwq *)data;
+	struct afu *afu = hwq->afu;
 	unsigned long hrrq_flags;
 	LIST_HEAD(doneq);
 	int num_entries = 0;
 
-	spin_lock_irqsave(&afu->hrrq_slock, hrrq_flags);
+	spin_lock_irqsave(&hwq->hrrq_slock, hrrq_flags);
 
 	if (afu_is_irqpoll_enabled(afu)) {
-		irq_poll_sched(&afu->irqpoll);
-		spin_unlock_irqrestore(&afu->hrrq_slock, hrrq_flags);
+		irq_poll_sched(&hwq->irqpoll);
+		spin_unlock_irqrestore(&hwq->hrrq_slock, hrrq_flags);
 		return IRQ_HANDLED;
 	}
 
-	num_entries = process_hrrq(afu, &doneq, -1);
-	spin_unlock_irqrestore(&afu->hrrq_slock, hrrq_flags);
+	num_entries = process_hrrq(hwq, &doneq, -1);
+	spin_unlock_irqrestore(&hwq->hrrq_slock, hrrq_flags);
 
 	if (num_entries == 0)
 		return IRQ_NONE;
@@ -1285,7 +1333,8 @@ static const struct asyc_intr_info ainfo[] = {
  */
 static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 {
-	struct afu *afu = (struct afu *)data;
+	struct hwq *hwq = (struct hwq *)data;
+	struct afu *afu = hwq->afu;
 	struct cxlflash_cfg *cfg = afu->parent;
 	struct device *dev = &cfg->dev->dev;
 	const struct asyc_intr_info *info;
@@ -1368,16 +1417,18 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 /**
  * start_context() - starts the master context
  * @cfg:	Internal structure associated with the host.
+ * @index:	Index of the hardware queue.
  *
  * Return: A success or failure value from CXL services.
  */
-static int start_context(struct cxlflash_cfg *cfg)
+static int start_context(struct cxlflash_cfg *cfg, u32 index)
 {
 	struct device *dev = &cfg->dev->dev;
+	struct hwq *hwq = get_hwq(cfg->afu, index);
 	int rc = 0;
 
-	rc = cxl_start_context(cfg->mcctx,
-			       cfg->afu->work.work_element_descriptor,
+	rc = cxl_start_context(hwq->ctx,
+			       hwq->work.work_element_descriptor,
 			       NULL);
 
 	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
@@ -1487,6 +1538,7 @@ static void init_pcr(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
 	struct sisl_ctrl_map __iomem *ctrl_map;
+	struct hwq *hwq;
 	int i;
 
 	for (i = 0; i < MAX_CONTEXT; i++) {
@@ -1498,13 +1550,17 @@ static void init_pcr(struct cxlflash_cfg *cfg)
 		writeq_be(0, &ctrl_map->ctx_cap);
 	}
 
-	/* Copy frequently used fields into afu */
-	afu->ctx_hndl = (u16) cxl_process_element(cfg->mcctx);
-	afu->host_map = &afu->afu_map->hosts[afu->ctx_hndl].host;
-	afu->ctrl_map = &afu->afu_map->ctrls[afu->ctx_hndl].ctrl;
+	/* Copy frequently used fields into hwq */
+	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+		hwq = get_hwq(afu, i);
 
-	/* Program the Endian Control for the master context */
-	writeq_be(SISL_ENDIAN_CTRL, &afu->host_map->endian_ctrl);
+		hwq->ctx_hndl = (u16) cxl_process_element(hwq->ctx);
+		hwq->host_map = &afu->afu_map->hosts[hwq->ctx_hndl].host;
+		hwq->ctrl_map = &afu->afu_map->ctrls[hwq->ctx_hndl].ctrl;
+
+		/* Program the Endian Control for the master context */
+		writeq_be(SISL_ENDIAN_CTRL, &hwq->host_map->endian_ctrl);
+	}
 }
 
 /**
@@ -1515,6 +1571,8 @@ static int init_global(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
+	struct hwq *hwq;
+	struct sisl_host_map __iomem *hmap;
 	__be64 __iomem *fc_port_regs;
 	u64 wwpn[MAX_FC_PORTS];	/* wwpn of AFU ports */
 	int i = 0, num_ports = 0;
@@ -1527,13 +1585,18 @@ static int init_global(struct cxlflash_cfg *cfg)
 		goto out;
 	}
 
-	/* Set up RRQ and SQ in AFU for master issued cmds */
-	writeq_be((u64) afu->hrrq_start, &afu->host_map->rrq_start);
-	writeq_be((u64) afu->hrrq_end, &afu->host_map->rrq_end);
+	/* Set up RRQ and SQ in HWQ for master issued cmds */
+	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+		hwq = get_hwq(afu, i);
+		hmap = hwq->host_map;
 
-	if (afu_is_sq_cmd_mode(afu)) {
-		writeq_be((u64)afu->hsq_start, &afu->host_map->sq_start);
-		writeq_be((u64)afu->hsq_end, &afu->host_map->sq_end);
+		writeq_be((u64) hwq->hrrq_start, &hmap->rrq_start);
+		writeq_be((u64) hwq->hrrq_end, &hmap->rrq_end);
+
+		if (afu_is_sq_cmd_mode(afu)) {
+			writeq_be((u64)hwq->hsq_start, &hmap->sq_start);
+			writeq_be((u64)hwq->hsq_end, &hmap->sq_end);
+		}
 	}
 
 	/* AFU configuration */
@@ -1577,11 +1640,15 @@ static int init_global(struct cxlflash_cfg *cfg)
 	/* Set up master's own CTX_CAP to allow real mode, host translation */
 	/* tables, afu cmds and read/write GSCSI cmds. */
 	/* First, unlock ctx_cap write by reading mbox */
-	(void)readq_be(&afu->ctrl_map->mbox_r);	/* unlock ctx_cap */
-	writeq_be((SISL_CTX_CAP_REAL_MODE | SISL_CTX_CAP_HOST_XLATE |
-		   SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD |
-		   SISL_CTX_CAP_AFU_CMD | SISL_CTX_CAP_GSCSI_CMD),
-		  &afu->ctrl_map->ctx_cap);
+	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+		hwq = get_hwq(afu, i);
+
+		(void)readq_be(&hwq->ctrl_map->mbox_r);	/* unlock ctx_cap */
+		writeq_be((SISL_CTX_CAP_REAL_MODE | SISL_CTX_CAP_HOST_XLATE |
+			SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD |
+			SISL_CTX_CAP_AFU_CMD | SISL_CTX_CAP_GSCSI_CMD),
+			&hwq->ctrl_map->ctx_cap);
+	}
 	/* Initialize heartbeat */
 	afu->hb = readq_be(&afu->afu_map->global.regs.afu_hb);
 out:
@@ -1596,33 +1663,43 @@ static int start_afu(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
+	struct hwq *hwq;
 	int rc = 0;
+	int i;
 
 	init_pcr(cfg);
 
-	/* Initialize RRQ */
-	memset(&afu->rrq_entry, 0, sizeof(afu->rrq_entry));
-	afu->hrrq_start = &afu->rrq_entry[0];
-	afu->hrrq_end = &afu->rrq_entry[NUM_RRQ_ENTRY - 1];
-	afu->hrrq_curr = afu->hrrq_start;
-	afu->toggle = 1;
-	spin_lock_init(&afu->hrrq_slock);
+	/* Initialize each HWQ */
+	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+		hwq = get_hwq(afu, i);
 
-	/* Initialize SQ */
-	if (afu_is_sq_cmd_mode(afu)) {
-		memset(&afu->sq, 0, sizeof(afu->sq));
-		afu->hsq_start = &afu->sq[0];
-		afu->hsq_end = &afu->sq[NUM_SQ_ENTRY - 1];
-		afu->hsq_curr = afu->hsq_start;
+		/* After an AFU reset, RRQ entries are stale, clear them */
+		memset(&hwq->rrq_entry, 0, sizeof(hwq->rrq_entry));
 
-		spin_lock_init(&afu->hsq_slock);
-		atomic_set(&afu->hsq_credits, NUM_SQ_ENTRY - 1);
-	}
+		/* Initialize RRQ pointers */
+		hwq->hrrq_start = &hwq->rrq_entry[0];
+		hwq->hrrq_end = &hwq->rrq_entry[NUM_RRQ_ENTRY - 1];
+		hwq->hrrq_curr = hwq->hrrq_start;
+		hwq->toggle = 1;
+		spin_lock_init(&hwq->hrrq_slock);
+
+		/* Initialize SQ */
+		if (afu_is_sq_cmd_mode(afu)) {
+			memset(&hwq->sq, 0, sizeof(hwq->sq));
+			hwq->hsq_start = &hwq->sq[0];
+			hwq->hsq_end = &hwq->sq[NUM_SQ_ENTRY - 1];
+			hwq->hsq_curr = hwq->hsq_start;
+
+			spin_lock_init(&hwq->hsq_slock);
+			atomic_set(&hwq->hsq_credits, NUM_SQ_ENTRY - 1);
+		}
 
-	/* Initialize IRQ poll */
-	if (afu_is_irqpoll_enabled(afu))
-		irq_poll_init(&afu->irqpoll, afu->irqpoll_weight,
-			      cxlflash_irqpoll);
+		/* Initialize IRQ poll */
+		if (afu_is_irqpoll_enabled(afu))
+			irq_poll_init(&hwq->irqpoll, afu->irqpoll_weight,
+				      cxlflash_irqpoll);
+
+	}
 
 	rc = init_global(cfg);
 
@@ -1633,18 +1710,21 @@ static int start_afu(struct cxlflash_cfg *cfg)
 /**
  * init_intr() - setup interrupt handlers for the master context
  * @cfg:	Internal structure associated with the host.
+ * @hwq:	Hardware queue to initialize.
  *
  * Return: 0 on success, -errno on failure
  */
 static enum undo_level init_intr(struct cxlflash_cfg *cfg,
-				 struct cxl_context *ctx)
+				 struct hwq *hwq)
 {
-	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
+	struct cxl_context *ctx = hwq->ctx;
 	int rc = 0;
 	enum undo_level level = UNDO_NOOP;
+	bool is_primary_hwq = (hwq->index == PRIMARY_HWQ);
+	int num_irqs = is_primary_hwq ? 3 : 2;
 
-	rc = cxl_allocate_afu_irqs(ctx, 3);
+	rc = cxl_allocate_afu_irqs(ctx, num_irqs);
 	if (unlikely(rc)) {
 		dev_err(dev, "%s: allocate_afu_irqs failed rc=%d\n",
 			__func__, rc);
@@ -1652,7 +1732,7 @@ static enum undo_level init_intr(struct cxlflash_cfg *cfg,
 		goto out;
 	}
 
-	rc = cxl_map_afu_irq(ctx, 1, cxlflash_sync_err_irq, afu,
+	rc = cxl_map_afu_irq(ctx, 1, cxlflash_sync_err_irq, hwq,
 			     "SISL_MSI_SYNC_ERROR");
 	if (unlikely(rc <= 0)) {
 		dev_err(dev, "%s: SISL_MSI_SYNC_ERROR map failed\n", __func__);
@@ -1660,7 +1740,7 @@ static enum undo_level init_intr(struct cxlflash_cfg *cfg,
 		goto out;
 	}
 
-	rc = cxl_map_afu_irq(ctx, 2, cxlflash_rrq_irq, afu,
+	rc = cxl_map_afu_irq(ctx, 2, cxlflash_rrq_irq, hwq,
 			     "SISL_MSI_RRQ_UPDATED");
 	if (unlikely(rc <= 0)) {
 		dev_err(dev, "%s: SISL_MSI_RRQ_UPDATED map failed\n", __func__);
@@ -1668,7 +1748,11 @@ static enum undo_level init_intr(struct cxlflash_cfg *cfg,
 		goto out;
 	}
 
-	rc = cxl_map_afu_irq(ctx, 3, cxlflash_async_err_irq, afu,
+	/* SISL_MSI_ASYNC_ERROR is setup only for the primary HWQ */
+	if (!is_primary_hwq)
+		goto out;
+
+	rc = cxl_map_afu_irq(ctx, 3, cxlflash_async_err_irq, hwq,
 			     "SISL_MSI_ASYNC_ERROR");
 	if (unlikely(rc <= 0)) {
 		dev_err(dev, "%s: SISL_MSI_ASYNC_ERROR map failed\n", __func__);
@@ -1682,55 +1766,73 @@ static enum undo_level init_intr(struct cxlflash_cfg *cfg,
 /**
  * init_mc() - create and register as the master context
  * @cfg:	Internal structure associated with the host.
+ * index:	HWQ Index of the master context.
  *
  * Return: 0 on success, -errno on failure
  */
-static int init_mc(struct cxlflash_cfg *cfg)
+static int init_mc(struct cxlflash_cfg *cfg, u32 index)
 {
 	struct cxl_context *ctx;
 	struct device *dev = &cfg->dev->dev;
+	struct hwq *hwq = get_hwq(cfg->afu, index);
 	int rc = 0;
 	enum undo_level level;
 
-	ctx = cxl_get_context(cfg->dev);
+	hwq->afu = cfg->afu;
+	hwq->index = index;
+
+	if (index == PRIMARY_HWQ)
+		ctx = cxl_get_context(cfg->dev);
+	else
+		ctx = cxl_dev_context_init(cfg->dev);
 	if (unlikely(!ctx)) {
 		rc = -ENOMEM;
-		goto ret;
+		goto err1;
 	}
-	cfg->mcctx = ctx;
+
+	WARN_ON(hwq->ctx);
+	hwq->ctx = ctx;
 
 	/* Set it up as a master with the CXL */
 	cxl_set_master(ctx);
 
-	/* During initialization reset the AFU to start from a clean slate */
-	rc = cxl_afu_reset(cfg->mcctx);
-	if (unlikely(rc)) {
-		dev_err(dev, "%s: AFU reset failed rc=%d\n", __func__, rc);
-		goto ret;
+	/* Reset AFU when initializing primary context */
+	if (index == PRIMARY_HWQ) {
+		rc = cxl_afu_reset(ctx);
+		if (unlikely(rc)) {
+			dev_err(dev, "%s: AFU reset failed rc=%d\n",
+				      __func__, rc);
+			goto err1;
+		}
 	}
 
-	level = init_intr(cfg, ctx);
+	level = init_intr(cfg, hwq);
 	if (unlikely(level)) {
 		dev_err(dev, "%s: interrupt init failed rc=%d\n", __func__, rc);
-		goto out;
+		goto err2;
 	}
 
 	/* This performs the equivalent of the CXL_IOCTL_START_WORK.
 	 * The CXL_IOCTL_GET_PROCESS_ELEMENT is implicit in the process
 	 * element (pe) that is embedded in the context (ctx)
 	 */
-	rc = start_context(cfg);
+	rc = start_context(cfg, index);
 	if (unlikely(rc)) {
 		dev_err(dev, "%s: start context failed rc=%d\n", __func__, rc);
 		level = UNMAP_THREE;
-		goto out;
+		goto err2;
 	}
-ret:
+
+out:
 	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
 	return rc;
-out:
-	term_intr(cfg, level);
-	goto ret;
+err2:
+	term_intr(cfg, level, index);
+	if (index != PRIMARY_HWQ)
+		cxl_release_context(ctx);
+err1:
+	hwq->ctx = NULL;
+	goto out;
 }
 
 /**
@@ -1781,18 +1883,23 @@ static int init_afu(struct cxlflash_cfg *cfg)
 	int rc = 0;
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
+	struct hwq *hwq;
+	int i;
 
 	cxl_perst_reloads_same_image(cfg->cxl_afu, true);
 
-	rc = init_mc(cfg);
-	if (rc) {
-		dev_err(dev, "%s: init_mc failed rc=%d\n",
-			__func__, rc);
-		goto out;
+	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+		rc = init_mc(cfg, i);
+		if (rc) {
+			dev_err(dev, "%s: init_mc failed rc=%d index=%d\n",
+				__func__, rc, i);
+			goto err1;
+		}
 	}
 
-	/* Map the entire MMIO space of the AFU */
-	afu->afu_map = cxl_psa_map(cfg->mcctx);
+	/* Map the entire MMIO space of the AFU using the first context */
+	hwq = get_hwq(afu, PRIMARY_HWQ);
+	afu->afu_map = cxl_psa_map(hwq->ctx);
 	if (!afu->afu_map) {
 		dev_err(dev, "%s: cxl_psa_map failed\n", __func__);
 		rc = -ENOMEM;
@@ -1832,8 +1939,12 @@ static int init_afu(struct cxlflash_cfg *cfg)
 	}
 
 	afu_err_intr_init(cfg->afu);
-	spin_lock_init(&afu->rrin_slock);
-	afu->room = readq_be(&afu->host_map->cmd_room);
+	for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+		hwq = get_hwq(afu, i);
+
+		spin_lock_init(&hwq->rrin_slock);
+		hwq->room = readq_be(&hwq->host_map->cmd_room);
+	}
 
 	/* Restore the LUN mappings */
 	cxlflash_restore_luntable(cfg);
@@ -1842,8 +1953,10 @@ static int init_afu(struct cxlflash_cfg *cfg)
 	return rc;
 
 err1:
-	term_intr(cfg, UNMAP_THREE);
-	term_mc(cfg);
+	for (i = CXLFLASH_NUM_HWQS - 1; i >= 0; i--) {
+		term_intr(cfg, UNMAP_THREE, i);
+		term_mc(cfg, i);
+	}
 	goto out;
 }
 
@@ -1875,6 +1988,7 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	struct cxlflash_cfg *cfg = afu->parent;
 	struct device *dev = &cfg->dev->dev;
 	struct afu_cmd *cmd = NULL;
+	struct hwq *hwq = get_hwq(afu, PRIMARY_HWQ);
 	char *buf = NULL;
 	int rc = 0;
 	static DEFINE_MUTEX(sync_active);
@@ -1897,11 +2011,12 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	cmd = (struct afu_cmd *)PTR_ALIGN(buf, __alignof__(*cmd));
 	init_completion(&cmd->cevent);
 	cmd->parent = afu;
+	cmd->hwq_index = hwq->index;
 
 	dev_dbg(dev, "%s: afu=%p cmd=%p %d\n", __func__, afu, cmd, ctx_hndl_u);
 
 	cmd->rcb.req_flags = SISL_REQ_FLAGS_AFU_CMD;
-	cmd->rcb.ctx_id = afu->ctx_hndl;
+	cmd->rcb.ctx_id = hwq->ctx_hndl;
 	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
 	cmd->rcb.timeout = MC_AFU_SYNC_TIMEOUT;
 
@@ -2414,8 +2529,9 @@ static ssize_t irqpoll_weight_store(struct device *dev,
 	struct cxlflash_cfg *cfg = shost_priv(class_to_shost(dev));
 	struct device *cfgdev = &cfg->dev->dev;
 	struct afu *afu = cfg->afu;
+	struct hwq *hwq;
 	u32 weight;
-	int rc;
+	int rc, i;
 
 	rc = kstrtouint(buf, 10, &weight);
 	if (rc)
@@ -2433,13 +2549,23 @@ static ssize_t irqpoll_weight_store(struct device *dev,
 		return -EINVAL;
 	}
 
-	if (afu_is_irqpoll_enabled(afu))
-		irq_poll_disable(&afu->irqpoll);
+	if (afu_is_irqpoll_enabled(afu)) {
+		for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+			hwq = get_hwq(afu, i);
+
+			irq_poll_disable(&hwq->irqpoll);
+		}
+	}
 
 	afu->irqpoll_weight = weight;
 
-	if (weight > 0)
-		irq_poll_init(&afu->irqpoll, weight, cxlflash_irqpoll);
+	if (weight > 0) {
+		for (i = 0; i < CXLFLASH_NUM_HWQS; i++) {
+			hwq = get_hwq(afu, i);
+
+			irq_poll_init(&hwq->irqpoll, weight, cxlflash_irqpoll);
+		}
+	}
 
 	return count;
 }
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 158fa00..52ec525 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -254,6 +254,7 @@ static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 	struct afu *afu = cfg->afu;
 	struct sisl_ctrl_map __iomem *ctrl_map = ctxi->ctrl_map;
 	int rc = 0;
+	struct hwq *hwq = get_hwq(afu, PRIMARY_HWQ);
 	u64 val;
 
 	/* Unlock cap and restrict user to read/write cmds in translated mode */
@@ -270,7 +271,7 @@ static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 
 	/* Set up MMIO registers pointing to the RHT */
 	writeq_be((u64)ctxi->rht_start, &ctrl_map->rht_start);
-	val = SISL_RHT_CNT_ID((u64)MAX_RHT_PER_CONTEXT, (u64)(afu->ctx_hndl));
+	val = SISL_RHT_CNT_ID((u64)MAX_RHT_PER_CONTEXT, (u64)(hwq->ctx_hndl));
 	writeq_be(val, &ctrl_map->rht_cnt_id);
 out:
 	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
@@ -1628,6 +1629,7 @@ static int cxlflash_afu_recover(struct scsi_device *sdev,
 	struct afu *afu = cfg->afu;
 	struct ctx_info *ctxi = NULL;
 	struct mutex *mutex = &cfg->ctx_recovery_mutex;
+	struct hwq *hwq = get_hwq(afu, PRIMARY_HWQ);
 	u64 flags;
 	u64 ctxid = DECODE_CTXID(recover->context_id),
 	    rctxid = recover->context_id;
@@ -1698,7 +1700,7 @@ static int cxlflash_afu_recover(struct scsi_device *sdev,
 	}
 
 	/* Test if in error state */
-	reg = readq_be(&afu->ctrl_map->mbox_r);
+	reg = readq_be(&hwq->ctrl_map->mbox_r);
 	if (reg == -1) {
 		dev_dbg(dev, "%s: MMIO fail, wait for recovery.\n", __func__);
 
-- 
2.1.0
