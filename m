From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 26/37] cxlflash: Correct spelling, grammar, and alignment mistakes
Date: Wed, 21 Oct 2015 15:15:06 -0500
Message-ID: <1445458506-58210-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:43582 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395AbbJUUQ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:16:28 -0400
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 14:16:28 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 40F6D1FF002D
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:04:37 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKFLjV852270
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 13:15:21 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKGNIW019094
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:16:25 -0600
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

There are several spelling and grammar mistakes throughout the
driver. Additionally there are a handful of places where there
are extra lines and unnecessary variables/statements. These are
a nuisance and pollute the driver.

Fix spelling and grammar issues. Update some comments for clarity and
consistency. Remove extra lines and a few unneeded variables/statements.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
---
 drivers/scsi/cxlflash/common.h    |  2 --
 drivers/scsi/cxlflash/main.c      | 62 +++++++++++++++++----------------------
 drivers/scsi/cxlflash/sislite.h   |  6 ++--
 drivers/scsi/cxlflash/superpipe.c |  2 +-
 drivers/scsi/cxlflash/vlun.c      | 14 ++++-----
 5 files changed, 38 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index a810585..bbfe711 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -105,8 +105,6 @@ struct cxlflash_cfg {
 	atomic_t scan_host_needed;
 
 	struct cxl_afu *cxl_afu;
-
-	struct pci_pool *cxlflash_cmd_pool;
 	struct pci_dev *parent_dev;
 
 	atomic_t recovery_threads;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 14fb9b4..eeb1c47 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -34,7 +34,6 @@ MODULE_AUTHOR("Manoj N. Kumar <manoj@linux.vnet.ibm.com>");
 MODULE_AUTHOR("Matthew R. Ochs <mrochs@linux.vnet.ibm.com>");
 MODULE_LICENSE("GPL");
 
-
 /**
  * cmd_checkout() - checks out an AFU command
  * @afu:	AFU to checkout from.
@@ -730,7 +729,7 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	case INIT_STATE_SCSI:
 		cxlflash_term_local_luns(cfg);
 		scsi_remove_host(cfg->host);
-		/* Fall through */
+		/* fall through */
 	case INIT_STATE_AFU:
 		term_afu(cfg);
 		cancel_work_sync(&cfg->work_q);
@@ -763,9 +762,7 @@ static int alloc_mem(struct cxlflash_cfg *cfg)
 	char *buf = NULL;
 	struct device *dev = &cfg->dev->dev;
 
-	/* This allocation is about 12K, i.e. only 1 64k page
-	 * and upto 4 4k pages
-	 */
+	/* AFU is ~12k, i.e. only one 64k page or up to four 4k pages */
 	cfg->afu = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					    get_order(sizeof(struct afu)));
 	if (unlikely(!cfg->afu)) {
@@ -1295,10 +1292,10 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 		goto out;
 	}
 
-	/* it is OK to clear AFU status before FC_ERROR */
+	/* FYI, it is 'okay' to clear AFU status before FC_ERROR */
 	writeq_be(reg_unmasked, &global->regs.aintr_clear);
 
-	/* check each bit that is on */
+	/* Check each bit that is on */
 	for (i = 0; reg_unmasked; i++, reg_unmasked = (reg_unmasked >> 1)) {
 		info = find_ainfo(1ULL << i);
 		if (((reg_unmasked & 0x1) == 0) || !info)
@@ -1311,7 +1308,7 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 		       readq_be(&global->fc_regs[port][FC_STATUS / 8]));
 
 		/*
-		 * do link reset first, some OTHER errors will set FC_ERROR
+		 * Do link reset first, some OTHER errors will set FC_ERROR
 		 * again if cleared before or w/o a reset
 		 */
 		if (info->action & LINK_RESET) {
@@ -1326,7 +1323,7 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 			reg = readq_be(&global->fc_regs[port][FC_ERROR / 8]);
 
 			/*
-			 * since all errors are unmasked, FC_ERROR and FC_ERRCAP
+			 * Since all errors are unmasked, FC_ERROR and FC_ERRCAP
 			 * should be the same and tracing one is sufficient.
 			 */
 
@@ -1472,23 +1469,22 @@ static void init_pcr(struct cxlflash_cfg *cfg)
 
 	for (i = 0; i < MAX_CONTEXT; i++) {
 		ctrl_map = &afu->afu_map->ctrls[i].ctrl;
-		/* disrupt any clients that could be running */
-		/* e. g. clients that survived a master restart */
+		/* Disrupt any clients that could be running */
+		/* e.g. clients that survived a master restart */
 		writeq_be(0, &ctrl_map->rht_start);
 		writeq_be(0, &ctrl_map->rht_cnt_id);
 		writeq_be(0, &ctrl_map->ctx_cap);
 	}
 
-	/* copy frequently used fields into afu */
+	/* Copy frequently used fields into afu */
 	afu->ctx_hndl = (u16) cxl_process_element(cfg->mcctx);
-	/* ctx_hndl is 16 bits in CAIA */
 	afu->host_map = &afu->afu_map->hosts[afu->ctx_hndl].host;
 	afu->ctrl_map = &afu->afu_map->ctrls[afu->ctx_hndl].ctrl;
 
 	/* Program the Endian Control for the master context */
 	writeq_be(SISL_ENDIAN_CTRL, &afu->host_map->endian_ctrl);
 
-	/* initialize cmd fields that never change */
+	/* Initialize cmd fields that never change */
 	for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
 		afu->cmd[i].rcb.ctx_id = afu->ctx_hndl;
 		afu->cmd[i].rcb.msi = SISL_MSI_RRQ_UPDATED;
@@ -1517,7 +1513,7 @@ static int init_global(struct cxlflash_cfg *cfg)
 
 	pr_debug("%s: wwpn0=0x%llX wwpn1=0x%llX\n", __func__, wwpn[0], wwpn[1]);
 
-	/* set up RRQ in AFU for master issued cmds */
+	/* Set up RRQ in AFU for master issued cmds */
 	writeq_be((u64) afu->hrrq_start, &afu->host_map->rrq_start);
 	writeq_be((u64) afu->hrrq_end, &afu->host_map->rrq_end);
 
@@ -1530,9 +1526,9 @@ static int init_global(struct cxlflash_cfg *cfg)
 	/* checker on if dual afu */
 	writeq_be(reg, &afu->afu_map->global.regs.afu_config);
 
-	/* global port select: select either port */
+	/* Global port select: select either port */
 	if (afu->internal_lun) {
-		/* only use port 0 */
+		/* Only use port 0 */
 		writeq_be(PORT0, &afu->afu_map->global.regs.afu_port_sel);
 		num_ports = NUM_FC_PORTS - 1;
 	} else {
@@ -1541,15 +1537,15 @@ static int init_global(struct cxlflash_cfg *cfg)
 	}
 
 	for (i = 0; i < num_ports; i++) {
-		/* unmask all errors (but they are still masked at AFU) */
+		/* Unmask all errors (but they are still masked at AFU) */
 		writeq_be(0, &afu->afu_map->global.fc_regs[i][FC_ERRMSK / 8]);
-		/* clear CRC error cnt & set a threshold */
+		/* Clear CRC error cnt & set a threshold */
 		(void)readq_be(&afu->afu_map->global.
 			       fc_regs[i][FC_CNT_CRCERR / 8]);
 		writeq_be(MC_CRC_THRESH, &afu->afu_map->global.fc_regs[i]
 			  [FC_CRC_THRESH / 8]);
 
-		/* set WWPNs. If already programmed, wwpn[i] is 0 */
+		/* Set WWPNs. If already programmed, wwpn[i] is 0 */
 		if (wwpn[i] != 0 &&
 		    afu_set_wwpn(afu, i,
 				 &afu->afu_map->global.fc_regs[i][0],
@@ -1563,18 +1559,17 @@ static int init_global(struct cxlflash_cfg *cfg)
 		 * offline/online transitions and a PLOGI
 		 */
 		msleep(100);
-
 	}
 
-	/* set up master's own CTX_CAP to allow real mode, host translation */
-	/* tbls, afu cmds and read/write GSCSI cmds. */
+	/* Set up master's own CTX_CAP to allow real mode, host translation */
+	/* tables, afu cmds and read/write GSCSI cmds. */
 	/* First, unlock ctx_cap write by reading mbox */
 	(void)readq_be(&afu->ctrl_map->mbox_r);	/* unlock ctx_cap */
 	writeq_be((SISL_CTX_CAP_REAL_MODE | SISL_CTX_CAP_HOST_XLATE |
 		   SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD |
 		   SISL_CTX_CAP_AFU_CMD | SISL_CTX_CAP_GSCSI_CMD),
 		  &afu->ctrl_map->ctx_cap);
-	/* init heartbeat */
+	/* Initialize heartbeat */
 	afu->hb = readq_be(&afu->afu_map->global.regs.afu_hb);
 
 out:
@@ -1603,7 +1598,7 @@ static int start_afu(struct cxlflash_cfg *cfg)
 
 	init_pcr(cfg);
 
-	/* initialize RRQ pointers */
+	/* Initialize RRQ pointers */
 	afu->hrrq_start = &afu->rrq_entry[0];
 	afu->hrrq_end = &afu->rrq_entry[NUM_RRQ_ENTRY - 1];
 	afu->hrrq_curr = afu->hrrq_start;
@@ -1726,8 +1721,7 @@ static int init_afu(struct cxlflash_cfg *cfg)
 		goto err1;
 	}
 
-	/* Map the entire MMIO space of the AFU.
-	 */
+	/* Map the entire MMIO space of the AFU */
 	afu->afu_map = cxl_psa_map(cfg->mcctx);
 	if (!afu->afu_map) {
 		rc = -ENOMEM;
@@ -1779,7 +1773,7 @@ err1:
  * @mode:	Type of sync to issue (lightweight, heavyweight, global).
  *
  * The AFU can only take 1 sync command at a time. This routine enforces this
- * limitation by using a mutex to provide exlusive access to the AFU during
+ * limitation by using a mutex to provide exclusive access to the AFU during
  * the sync. This design point requires calling threads to not be on interrupt
  * context due to the possibility of sleeping during concurrent sync operations.
  *
@@ -1845,7 +1839,7 @@ retry:
 
 	wait_resp(afu, cmd);
 
-	/* set on timeout */
+	/* Set on timeout */
 	if (unlikely((cmd->sa.ioasc != 0) ||
 		     (cmd->sa.host_use_b[0] & B_ERROR)))
 		rc = -1;
@@ -2262,7 +2256,7 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun = 16,
 	.can_queue = CXLFLASH_MAX_CMDS,
 	.this_id = -1,
-	.sg_tablesize = SG_NONE,	/* No scatter gather support. */
+	.sg_tablesize = SG_NONE,	/* No scatter gather support */
 	.max_sectors = CXLFLASH_MAX_SECTORS,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = cxlflash_host_attrs,
@@ -2322,8 +2316,7 @@ static void cxlflash_worker_thread(struct work_struct *work)
 
 			/* The reset can block... */
 			afu_link_reset(afu, port,
-				       &afu->afu_map->
-				       global.fc_regs[port][0]);
+				       &afu->afu_map->global.fc_regs[port][0]);
 			spin_lock_irqsave(cfg->host->host_lock, lock_flags);
 		}
 
@@ -2402,7 +2395,6 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	cfg->last_lun_index[1] = CXLFLASH_NUM_VLUNS/2 - 1;
 
 	cfg->dev_id = (struct pci_device_id *)dev_id;
-	cfg->mcctx = NULL;
 
 	init_waitqueue_head(&cfg->tmf_waitq);
 	init_waitqueue_head(&cfg->reset_waitq);
@@ -2418,7 +2410,8 @@ static int cxlflash_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, cfg);
 
-	/* Use the special service provided to look up the physical
+	/*
+	 * Use the special service provided to look up the physical
 	 * PCI device, since we are called on the probe of the virtual
 	 * PCI host bus (vphb)
 	 */
@@ -2448,7 +2441,6 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	}
 	cfg->init_state = INIT_STATE_AFU;
 
-
 	rc = init_scsi(cfg);
 	if (rc) {
 		dev_err(&pdev->dev, "%s: call to init_scsi "
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index 8425d1a..0b3366f 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -146,7 +146,7 @@ struct sisl_rc {
 #define SISL_FC_RC_ABORTFAIL	0x59	/* pending abort completed w/fail */
 #define SISL_FC_RC_RESID	0x5A	/* ioasa underrun/overrun flags set */
 #define SISL_FC_RC_RESIDERR	0x5B	/* actual data len does not match SCSI
-					   reported len, possbly due to dropped
+					   reported len, possibly due to dropped
 					   frames */
 #define SISL_FC_RC_TGTABORT	0x5C	/* command aborted by target */
 };
@@ -258,7 +258,7 @@ struct sisl_host_map {
 	__be64 rrq_start;	/* start & end are both inclusive */
 	__be64 rrq_end;		/* write sequence: start followed by end */
 	__be64 cmd_room;
-	__be64 ctx_ctrl;	/* least signiifcant byte or b56:63 is LISN# */
+	__be64 ctx_ctrl;	/* least significant byte or b56:63 is LISN# */
 	__be64 mbox_w;		/* restricted use */
 };
 
@@ -290,7 +290,7 @@ struct sisl_global_regs {
 #define SISL_ASTATUS_FC0_LOGO    0x4000ULL /* b49, target sent FLOGI/PLOGI/LOGO
 						   while logged in */
 #define SISL_ASTATUS_FC0_CRC_T   0x2000ULL /* b50, CRC threshold exceeded */
-#define SISL_ASTATUS_FC0_LOGI_R  0x1000ULL /* b51, login state mechine timed out
+#define SISL_ASTATUS_FC0_LOGI_R  0x1000ULL /* b51, login state machine timed out
 						   and retrying */
 #define SISL_ASTATUS_FC0_LOGI_F  0x0800ULL /* b52, login failed,
 					      FC_ERROR[19:0] */
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 7283e83..3cc8609 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -76,7 +76,7 @@ void cxlflash_free_errpage(void)
  *
  * When the host needs to go down, all users must be quiesced and their
  * memory freed. This is accomplished by putting the contexts in error
- * state which will notify the user and let them 'drive' the tear-down.
+ * state which will notify the user and let them 'drive' the tear down.
  * Meanwhile, this routine camps until all user contexts have been removed.
  */
 void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *cfg)
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index f91b5b3..b0eaf55 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -132,7 +132,7 @@ static int ba_init(struct ba_lun *ba_lun)
 		return -ENOMEM;
 	}
 
-	/* Pass the allocated lun info as a handle to the user */
+	/* Pass the allocated LUN info as a handle to the user */
 	ba_lun->ba_lun_handle = bali;
 
 	pr_debug("%s: Successfully initialized the LUN: "
@@ -165,7 +165,7 @@ static int find_free_range(u32 low,
 			num_bits = (sizeof(*lam) * BITS_PER_BYTE);
 			bit_pos = find_first_bit(lam, num_bits);
 
-			pr_devel("%s: Found free bit %llX in lun "
+			pr_devel("%s: Found free bit %llX in LUN "
 				 "map entry %llX at bitmap index = %X\n",
 				 __func__, bit_pos, bali->lun_alloc_map[i],
 				 i);
@@ -682,14 +682,14 @@ out:
 }
 
 /**
- * _cxlflash_vlun_resize() - changes the size of a virtual lun
+ * _cxlflash_vlun_resize() - changes the size of a virtual LUN
  * @sdev:	SCSI device associated with LUN owning virtual LUN.
  * @ctxi:	Context owning resources.
  * @resize:	Resize ioctl data structure.
  *
  * On successful return, the user is informed of the new size (in blocks)
- * of the virtual lun in last LBA format. When the size of the virtual
- * lun is zero, the last LBA is reflected as -1. See comment in the
+ * of the virtual LUN in last LBA format. When the size of the virtual
+ * LUN is zero, the last LBA is reflected as -1. See comment in the
  * prologue for _cxlflash_disk_release() regarding AFU syncs and contexts
  * on the error recovery list.
  *
@@ -886,8 +886,8 @@ out:
  * @arg:	UVirtual ioctl data structure.
  *
  * On successful return, the user is informed of the resource handle
- * to be used to identify the virtual lun and the size (in blocks) of
- * the virtual lun in last LBA format. When the size of the virtual lun
+ * to be used to identify the virtual LUN and the size (in blocks) of
+ * the virtual LUN in last LBA format. When the size of the virtual LUN
  * is zero, the last LBA is reflected as -1.
  *
  * Return: 0 on success, -errno on failure
-- 
2.1.0

