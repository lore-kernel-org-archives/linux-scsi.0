From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 12/37] cxlflash: Fix to avoid spamming the kernel log
Date: Wed, 21 Oct 2015 15:13:11 -0500
Message-ID: <1445458391-59080-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:50589 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbJUUOg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:14:36 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 16:14:35 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 19255C90057
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:02:44 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKEWjc46989558
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:14:32 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKEV5C018023
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:14:32 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

During run-time the driver can be very chatty and spam the system
kernel log. Various print statements can be limited and/or moved
to development-only mode. Additionally, numerous prints can be
converted to trace the corresponding device. Lastly, one spelling
correction was made: 'entra' to 'extra'.

The following changes were made:
 - pr_debug to pr_devel
 - pr_debug to pr_debug_ratelimited
 - pr_err to dev_err
 - pr_debug to dev_dbg

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

Conflicts:
	drivers/scsi/cxlflash/main.c
---
 drivers/scsi/cxlflash/main.c | 109 +++++++++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b44212b..527ff85 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -58,8 +58,8 @@ static struct afu_cmd *cmd_checkout(struct afu *afu)
 		cmd = &afu->cmd[k];
 
 		if (!atomic_dec_if_positive(&cmd->free)) {
-			pr_debug("%s: returning found index=%d\n",
-				 __func__, cmd->slot);
+			pr_devel("%s: returning found index=%d cmd=%p\n",
+				 __func__, cmd->slot, cmd);
 			memset(cmd->buf, 0, CMD_BUFSIZE);
 			memset(cmd->rcb.cdb, 0, sizeof(cmd->rcb.cdb));
 			return cmd;
@@ -93,7 +93,7 @@ static void cmd_checkin(struct afu_cmd *cmd)
 		return;
 	}
 
-	pr_debug("%s: released cmd %p index=%d\n", __func__, cmd, cmd->slot);
+	pr_devel("%s: released cmd %p index=%d\n", __func__, cmd, cmd->slot);
 }
 
 /**
@@ -127,7 +127,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 	}
 
 	pr_debug("%s: cmd failed afu_rc=%d scsi_rc=%d fc_rc=%d "
-		 "afu_extra=0x%X, scsi_entra=0x%X, fc_extra=0x%X\n",
+		 "afu_extra=0x%X, scsi_extra=0x%X, fc_extra=0x%X\n",
 		 __func__, ioasa->rc.afu_rc, ioasa->rc.scsi_rc,
 		 ioasa->rc.fc_rc, ioasa->afu_extra, ioasa->scsi_extra,
 		 ioasa->fc_extra);
@@ -240,9 +240,9 @@ static void cmd_complete(struct afu_cmd *cmd)
 		cmd_is_tmf = cmd->cmd_tmf;
 		cmd_checkin(cmd); /* Don't use cmd after here */
 
-		pr_debug("%s: calling scsi_set_resid, scp=%p "
-			 "result=%X resid=%d\n", __func__,
-			 scp, scp->result, resid);
+		pr_debug_ratelimited("%s: calling scsi_done scp=%p result=%X "
+				     "ioasc=%d\n", __func__, scp, scp->result,
+				     cmd->sa.ioasc);
 
 		scsi_set_resid(scp, resid);
 		scsi_dma_unmap(scp);
@@ -417,12 +417,13 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	short lflag = 0;
 	struct Scsi_Host *host = scp->device->host;
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
+	struct device *dev = &cfg->dev->dev;
 	ulong lock_flags;
 	int rc = 0;
 
 	cmd = cmd_checkout(afu);
 	if (unlikely(!cmd)) {
-		pr_err("%s: could not get a free command\n", __func__);
+		dev_err(dev, "%s: could not get a free command\n", __func__);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
@@ -493,7 +494,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 {
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
 	struct afu *afu = cfg->afu;
-	struct pci_dev *pdev = cfg->dev;
+	struct device *dev = &cfg->dev->dev;
 	struct afu_cmd *cmd;
 	u32 port_sel = scp->device->channel + 1;
 	int nseg, i, ncount;
@@ -502,13 +503,14 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	short lflag = 0;
 	int rc = 0;
 
-	pr_debug("%s: (scp=%p) %d/%d/%d/%llu cdb=(%08X-%08X-%08X-%08X)\n",
-		 __func__, scp, host->host_no, scp->device->channel,
-		 scp->device->id, scp->device->lun,
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
-		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+	dev_dbg_ratelimited(dev, "%s: (scp=%p) %d/%d/%d/%llu "
+			    "cdb=(%08X-%08X-%08X-%08X)\n",
+			    __func__, scp, host->host_no, scp->device->channel,
+			    scp->device->id, scp->device->lun,
+			    get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
+			    get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
+			    get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
+			    get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
 
 	/* If a Task Management Function is active, wait for it to complete
 	 * before continuing with regular commands.
@@ -523,13 +525,11 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 
 	switch (cfg->state) {
 	case STATE_RESET:
-		dev_dbg_ratelimited(&cfg->dev->dev, "%s: device is in reset!\n",
-				    __func__);
+		dev_dbg_ratelimited(dev, "%s: device is in reset!\n", __func__);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	case STATE_FAILTERM:
-		dev_dbg_ratelimited(&cfg->dev->dev, "%s: device has failed!\n",
-				    __func__);
+		dev_dbg_ratelimited(dev, "%s: device has failed!\n", __func__);
 		scp->result = (DID_NO_CONNECT << 16);
 		scp->scsi_done(scp);
 		rc = 0;
@@ -540,7 +540,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 
 	cmd = cmd_checkout(afu);
 	if (unlikely(!cmd)) {
-		pr_err("%s: could not get a free command\n", __func__);
+		dev_err(dev, "%s: could not get a free command\n", __func__);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
@@ -562,7 +562,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 
 	nseg = scsi_dma_map(scp);
 	if (unlikely(nseg < 0)) {
-		dev_err(&pdev->dev, "%s: Fail DMA map! nseg=%d\n",
+		dev_err(dev, "%s: Fail DMA map! nseg=%d\n",
 			__func__, nseg);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
@@ -585,6 +585,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	}
 
 out:
+	pr_devel("%s: returning rc=%d\n", __func__, rc);
 	return rc;
 }
 
@@ -657,9 +658,10 @@ static void term_mc(struct cxlflash_cfg *cfg, enum undo_level level)
 {
 	int rc = 0;
 	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
 
 	if (!afu || !cfg->mcctx) {
-		pr_err("%s: returning from term_mc with NULL afu or MC\n",
+		dev_err(dev, "%s: returning from term_mc with NULL afu or MC\n",
 		       __func__);
 		return;
 	}
@@ -755,6 +757,7 @@ static int alloc_mem(struct cxlflash_cfg *cfg)
 	int rc = 0;
 	int i;
 	char *buf = NULL;
+	struct device *dev = &cfg->dev->dev;
 
 	/* This allocation is about 12K, i.e. only 1 64k page
 	 * and upto 4 4k pages
@@ -762,8 +765,8 @@ static int alloc_mem(struct cxlflash_cfg *cfg)
 	cfg->afu = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					    get_order(sizeof(struct afu)));
 	if (unlikely(!cfg->afu)) {
-		pr_err("%s: cannot get %d free pages\n",
-		       __func__, get_order(sizeof(struct afu)));
+		dev_err(dev, "%s: cannot get %d free pages\n",
+			__func__, get_order(sizeof(struct afu)));
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -774,7 +777,8 @@ static int alloc_mem(struct cxlflash_cfg *cfg)
 		if (!((u64)buf & (PAGE_SIZE - 1))) {
 			buf = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 			if (unlikely(!buf)) {
-				pr_err("%s: Allocate command buffers fail!\n",
+				dev_err(dev,
+					"%s: Allocate command buffers fail!\n",
 				       __func__);
 				rc = -ENOMEM;
 				free_mem(cfg);
@@ -1280,7 +1284,8 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 {
 	struct afu *afu = (struct afu *)data;
-	struct cxlflash_cfg *cfg;
+	struct cxlflash_cfg *cfg = afu->parent;
+	struct device *dev = &cfg->dev->dev;
 	u64 reg_unmasked;
 	const struct asyc_intr_info *info;
 	struct sisl_global_map *global = &afu->afu_map->global;
@@ -1288,14 +1293,12 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 	u8 port;
 	int i;
 
-	cfg = afu->parent;
-
 	reg = readq_be(&global->regs.aintr_status);
 	reg_unmasked = (reg & SISL_ASTATUS_UNMASK);
 
 	if (reg_unmasked == 0) {
-		pr_err("%s: spurious interrupt, aintr_status 0x%016llX\n",
-		       __func__, reg);
+		dev_err(dev, "%s: spurious interrupt, aintr_status 0x%016llX\n",
+			__func__, reg);
 		goto out;
 	}
 
@@ -1310,8 +1313,8 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 
 		port = info->port;
 
-		pr_err("%s: FC Port %d -> %s, fc_status 0x%08llX\n",
-		       __func__, port, info->desc,
+		dev_err(dev, "%s: FC Port %d -> %s, fc_status 0x%08llX\n",
+			__func__, port, info->desc,
 		       readq_be(&global->fc_regs[port][FC_STATUS / 8]));
 
 		/*
@@ -1319,8 +1322,8 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 		 * again if cleared before or w/o a reset
 		 */
 		if (info->action & LINK_RESET) {
-			pr_err("%s: FC Port %d: resetting link\n",
-			       __func__, port);
+			dev_err(dev, "%s: FC Port %d: resetting link\n",
+				__func__, port);
 			cfg->lr_state = LINK_RESET_REQUIRED;
 			cfg->lr_port = port;
 			schedule_work(&cfg->work_q);
@@ -1334,8 +1337,8 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 			 * should be the same and tracing one is sufficient.
 			 */
 
-			pr_err("%s: fc %d: clearing fc_error 0x%08llX\n",
-			       __func__, port, reg);
+			dev_err(dev, "%s: fc %d: clearing fc_error 0x%08llX\n",
+				__func__, port, reg);
 
 			writeq_be(reg, &global->fc_regs[port][FC_ERROR / 8]);
 			writeq_be(0, &global->fc_regs[port][FC_ERRCAP / 8]);
@@ -1343,7 +1346,7 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 	}
 
 out:
-	pr_debug("%s: returning rc=%d, afu=%p\n", __func__, IRQ_HANDLED, afu);
+	dev_dbg(dev, "%s: returning IRQ_HANDLED, afu=%p\n", __func__, afu);
 	return IRQ_HANDLED;
 }
 
@@ -1387,7 +1390,7 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 	/* Get the VPD data from the device */
 	vpd_size = pci_read_vpd(dev, 0, sizeof(vpd_data), vpd_data);
 	if (unlikely(vpd_size <= 0)) {
-		pr_err("%s: Unable to read VPD (size = %ld)\n",
+		dev_err(&dev->dev, "%s: Unable to read VPD (size = %ld)\n",
 		       __func__, vpd_size);
 		rc = -ENODEV;
 		goto out;
@@ -1397,7 +1400,8 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 	ro_start = pci_vpd_find_tag(vpd_data, 0, vpd_size,
 				    PCI_VPD_LRDT_RO_DATA);
 	if (unlikely(ro_start < 0)) {
-		pr_err("%s: VPD Read-only data not found\n", __func__);
+		dev_err(&dev->dev, "%s: VPD Read-only data not found\n",
+			__func__);
 		rc = -ENODEV;
 		goto out;
 	}
@@ -1426,8 +1430,8 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 
 		i = pci_vpd_find_info_keyword(vpd_data, i, j, wwpn_vpd_tags[k]);
 		if (unlikely(i < 0)) {
-			pr_err("%s: Port %d WWPN not found in VPD\n",
-			       __func__, k);
+			dev_err(&dev->dev, "%s: Port %d WWPN not found "
+				"in VPD\n", __func__, k);
 			rc = -ENODEV;
 			goto out;
 		}
@@ -1435,7 +1439,8 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 		j = pci_vpd_info_field_size(&vpd_data[i]);
 		i += PCI_VPD_INFO_FLD_HDR_SIZE;
 		if (unlikely((i + j > vpd_size) || (j != WWPN_LEN))) {
-			pr_err("%s: Port %d WWPN incomplete or VPD corrupt\n",
+			dev_err(&dev->dev, "%s: Port %d WWPN incomplete or "
+				"VPD corrupt\n",
 			       __func__, k);
 			rc = -ENODEV;
 			goto out;
@@ -1444,8 +1449,8 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 		memcpy(tmp_buf, &vpd_data[i], WWPN_LEN);
 		rc = kstrtoul(tmp_buf, WWPN_LEN, (ulong *)&wwpn[k]);
 		if (unlikely(rc)) {
-			pr_err("%s: Fail to convert port %d WWPN to integer\n",
-			       __func__, k);
+			dev_err(&dev->dev, "%s: Fail to convert port %d WWPN "
+				"to integer\n", __func__, k);
 			rc = -ENODEV;
 			goto out;
 		}
@@ -1502,6 +1507,7 @@ static void init_pcr(struct cxlflash_cfg *cfg)
 static int init_global(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
 	u64 wwpn[NUM_FC_PORTS];	/* wwpn of AFU ports */
 	int i = 0, num_ports = 0;
 	int rc = 0;
@@ -1509,7 +1515,7 @@ static int init_global(struct cxlflash_cfg *cfg)
 
 	rc = read_vpd(cfg, &wwpn[0]);
 	if (rc) {
-		pr_err("%s: could not read vpd rc=%d\n", __func__, rc);
+		dev_err(dev, "%s: could not read vpd rc=%d\n", __func__, rc);
 		goto out;
 	}
 
@@ -1552,7 +1558,7 @@ static int init_global(struct cxlflash_cfg *cfg)
 		    afu_set_wwpn(afu, i,
 				 &afu->afu_map->global.fc_regs[i][0],
 				 wwpn[i])) {
-			pr_err("%s: failed to set WWPN on port %d\n",
+			dev_err(dev, "%s: failed to set WWPN on port %d\n",
 			       __func__, i);
 			rc = -EIO;
 			goto out;
@@ -1795,6 +1801,7 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 		      res_hndl_t res_hndl_u, u8 mode)
 {
 	struct cxlflash_cfg *cfg = afu->parent;
+	struct device *dev = &cfg->dev->dev;
 	struct afu_cmd *cmd = NULL;
 	int rc = 0;
 	int retry_cnt = 0;
@@ -1813,7 +1820,7 @@ retry:
 		udelay(1000 * retry_cnt);
 		if (retry_cnt < MC_RETRY_CNT)
 			goto retry;
-		pr_err("%s: could not get a free command\n", __func__);
+		dev_err(dev, "%s: could not get a free command\n", __func__);
 		rc = -1;
 		goto out;
 	}
@@ -2301,6 +2308,7 @@ static void cxlflash_worker_thread(struct work_struct *work)
 	struct cxlflash_cfg *cfg = container_of(work, struct cxlflash_cfg,
 						work_q);
 	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
 	int port;
 	ulong lock_flags;
 
@@ -2314,7 +2322,8 @@ static void cxlflash_worker_thread(struct work_struct *work)
 	if (cfg->lr_state == LINK_RESET_REQUIRED) {
 		port = cfg->lr_port;
 		if (port < 0)
-			pr_err("%s: invalid port index %d\n", __func__, port);
+			dev_err(dev, "%s: invalid port index %d\n",
+				__func__, port);
 		else {
 			spin_unlock_irqrestore(cfg->host->host_lock,
 					       lock_flags);
@@ -2419,7 +2428,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	 */
 	phys_dev = cxl_get_phys_dev(pdev);
 	if (!dev_is_pci(phys_dev)) {
-		pr_err("%s: not a pci dev\n", __func__);
+		dev_err(&pdev->dev, "%s: not a pci dev\n", __func__);
 		rc = -ENODEV;
 		goto out_remove;
 	}
-- 
2.1.0

