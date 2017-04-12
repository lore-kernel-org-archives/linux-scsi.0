From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 07/17] cxlflash: Hide FC internals behind common access routine
Date: Wed, 12 Apr 2017 14:14:17 -0500
Message-ID: <1492024457-55881-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37497 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752401AbdDLTOg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:14:36 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJDiHH122920
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:14:35 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29sgmjxrub-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:14:35 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 15:14:34 -0400
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

As staging to support FC-related updates to the SISlite specification,
introduce helper routines to obtain references to FC resources that exist
within the global map. This will allow changes to the underlying global
map structure without impacting existing code paths.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h | 14 ++++++++
 drivers/scsi/cxlflash/main.c   | 72 +++++++++++++++++++++++-------------------
 drivers/scsi/cxlflash/vlun.c   | 16 +++++-----
 3 files changed, 61 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index ee23e81..e6a7c97 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -240,6 +240,20 @@ static inline u64 lun_to_lunid(u64 lun)
 	return be64_to_cpu(lun_id);
 }
 
+static inline __be64 __iomem *get_fc_port_regs(struct cxlflash_cfg *cfg, int i)
+{
+	struct afu *afu = cfg->afu;
+
+	return &afu->afu_map->global.fc_regs[i][0];
+}
+
+static inline __be64 __iomem *get_fc_port_luns(struct cxlflash_cfg *cfg, int i)
+{
+	struct afu *afu = cfg->afu;
+
+	return &afu->afu_map->global.fc_port[i][0];
+}
+
 int cxlflash_afu_sync(struct afu *, ctx_hndl_t, res_hndl_t, u8);
 void cxlflash_list_init(void);
 void cxlflash_term_global_luns(void);
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 04e1a8e..e198605 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -670,8 +670,8 @@ static void notify_shutdown(struct cxlflash_cfg *cfg, bool wait)
 {
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
-	struct sisl_global_map __iomem *global;
 	struct dev_dependent_vals *ddv;
+	__be64 __iomem *fc_port_regs;
 	u64 reg, status;
 	int i, retry_cnt = 0;
 
@@ -684,13 +684,13 @@ static void notify_shutdown(struct cxlflash_cfg *cfg, bool wait)
 		return;
 	}
 
-	global = &afu->afu_map->global;
-
 	/* Notify AFU */
 	for (i = 0; i < cfg->num_fc_ports; i++) {
-		reg = readq_be(&global->fc_regs[i][FC_CONFIG2 / 8]);
+		fc_port_regs = get_fc_port_regs(cfg, i);
+
+		reg = readq_be(&fc_port_regs[FC_CONFIG2 / 8]);
 		reg |= SISL_FC_SHUTDOWN_NORMAL;
-		writeq_be(reg, &global->fc_regs[i][FC_CONFIG2 / 8]);
+		writeq_be(reg, &fc_port_regs[FC_CONFIG2 / 8]);
 	}
 
 	if (!wait)
@@ -698,9 +698,11 @@ static void notify_shutdown(struct cxlflash_cfg *cfg, bool wait)
 
 	/* Wait up to 1.5 seconds for shutdown processing to complete */
 	for (i = 0; i < cfg->num_fc_ports; i++) {
+		fc_port_regs = get_fc_port_regs(cfg, i);
 		retry_cnt = 0;
+
 		while (true) {
-			status = readq_be(&global->fc_regs[i][FC_STATUS / 8]);
+			status = readq_be(&fc_port_regs[FC_STATUS / 8]);
 			if (status & SISL_STATUS_SHUTDOWN_COMPLETE)
 				break;
 			if (++retry_cnt >= MC_RETRY_CNT) {
@@ -1071,6 +1073,7 @@ static const struct asyc_intr_info *find_ainfo(u64 status)
 static void afu_err_intr_init(struct afu *afu)
 {
 	struct cxlflash_cfg *cfg = afu->parent;
+	__be64 __iomem *fc_port_regs;
 	int i;
 	u64 reg;
 
@@ -1099,17 +1102,19 @@ static void afu_err_intr_init(struct afu *afu)
 	writeq_be(-1ULL, &afu->afu_map->global.regs.aintr_clear);
 
 	/* Clear/Set internal lun bits */
-	reg = readq_be(&afu->afu_map->global.fc_regs[0][FC_CONFIG2 / 8]);
+	fc_port_regs = get_fc_port_regs(cfg, 0);
+	reg = readq_be(&fc_port_regs[FC_CONFIG2 / 8]);
 	reg &= SISL_FC_INTERNAL_MASK;
 	if (afu->internal_lun)
 		reg |= ((u64)(afu->internal_lun - 1) << SISL_FC_INTERNAL_SHIFT);
-	writeq_be(reg, &afu->afu_map->global.fc_regs[0][FC_CONFIG2 / 8]);
+	writeq_be(reg, &fc_port_regs[FC_CONFIG2 / 8]);
 
 	/* now clear FC errors */
 	for (i = 0; i < cfg->num_fc_ports; i++) {
-		writeq_be(0xFFFFFFFFU,
-			  &afu->afu_map->global.fc_regs[i][FC_ERROR / 8]);
-		writeq_be(0, &afu->afu_map->global.fc_regs[i][FC_ERRCAP / 8]);
+		fc_port_regs = get_fc_port_regs(cfg, i);
+
+		writeq_be(0xFFFFFFFFU, &fc_port_regs[FC_ERROR / 8]);
+		writeq_be(0, &fc_port_regs[FC_ERRCAP / 8]);
 	}
 
 	/* sync interrupts for master's IOARRIN write */
@@ -1306,6 +1311,7 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 	u64 reg_unmasked;
 	const struct asyc_intr_info *info;
 	struct sisl_global_map __iomem *global = &afu->afu_map->global;
+	__be64 __iomem *fc_port_regs;
 	u64 reg;
 	u8 port;
 	int i;
@@ -1329,10 +1335,11 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 			continue;
 
 		port = info->port;
+		fc_port_regs = get_fc_port_regs(cfg, port);
 
 		dev_err(dev, "%s: FC Port %d -> %s, fc_status=%016llx\n",
 			__func__, port, info->desc,
-		       readq_be(&global->fc_regs[port][FC_STATUS / 8]));
+		       readq_be(&fc_port_regs[FC_STATUS / 8]));
 
 		/*
 		 * Do link reset first, some OTHER errors will set FC_ERROR
@@ -1347,7 +1354,7 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 		}
 
 		if (info->action & CLR_FC_ERROR) {
-			reg = readq_be(&global->fc_regs[port][FC_ERROR / 8]);
+			reg = readq_be(&fc_port_regs[FC_ERROR / 8]);
 
 			/*
 			 * Since all errors are unmasked, FC_ERROR and FC_ERRCAP
@@ -1357,8 +1364,8 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 			dev_err(dev, "%s: fc %d: clearing fc_error=%016llx\n",
 				__func__, port, reg);
 
-			writeq_be(reg, &global->fc_regs[port][FC_ERROR / 8]);
-			writeq_be(0, &global->fc_regs[port][FC_ERRCAP / 8]);
+			writeq_be(reg, &fc_port_regs[FC_ERROR / 8]);
+			writeq_be(0, &fc_port_regs[FC_ERRCAP / 8]);
 		}
 
 		if (info->action & SCAN_HOST) {
@@ -1521,6 +1528,7 @@ static int init_global(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
+	__be64 __iomem *fc_port_regs;
 	u64 wwpn[MAX_FC_PORTS];	/* wwpn of AFU ports */
 	int i = 0, num_ports = 0;
 	int rc = 0;
@@ -1562,19 +1570,17 @@ static int init_global(struct cxlflash_cfg *cfg)
 	}
 
 	for (i = 0; i < num_ports; i++) {
+		fc_port_regs = get_fc_port_regs(cfg, i);
+
 		/* Unmask all errors (but they are still masked at AFU) */
-		writeq_be(0, &afu->afu_map->global.fc_regs[i][FC_ERRMSK / 8]);
+		writeq_be(0, &fc_port_regs[FC_ERRMSK / 8]);
 		/* Clear CRC error cnt & set a threshold */
-		(void)readq_be(&afu->afu_map->global.
-			       fc_regs[i][FC_CNT_CRCERR / 8]);
-		writeq_be(MC_CRC_THRESH, &afu->afu_map->global.fc_regs[i]
-			  [FC_CRC_THRESH / 8]);
+		(void)readq_be(&fc_port_regs[FC_CNT_CRCERR / 8]);
+		writeq_be(MC_CRC_THRESH, &fc_port_regs[FC_CRC_THRESH / 8]);
 
 		/* Set WWPNs. If already programmed, wwpn[i] is 0 */
 		if (wwpn[i] != 0)
-			afu_set_wwpn(afu, i,
-				     &afu->afu_map->global.fc_regs[i][0],
-				     wwpn[i]);
+			afu_set_wwpn(afu, i, &fc_port_regs[0], wwpn[i]);
 		/* Programming WWPN back to back causes additional
 		 * offline/online transitions and a PLOGI
 		 */
@@ -2067,10 +2073,9 @@ static ssize_t cxlflash_show_port_status(u32 port,
 					 char *buf)
 {
 	struct device *dev = &cfg->dev->dev;
-	struct afu *afu = cfg->afu;
 	char *disp_status;
 	u64 status;
-	__be64 __iomem *fc_regs;
+	__be64 __iomem *fc_port_regs;
 
 	WARN_ON(port >= MAX_FC_PORTS);
 
@@ -2080,8 +2085,8 @@ static ssize_t cxlflash_show_port_status(u32 port,
 		return -EINVAL;
 	}
 
-	fc_regs = &afu->afu_map->global.fc_regs[port][0];
-	status = readq_be(&fc_regs[FC_MTIP_STATUS / 8]);
+	fc_port_regs = get_fc_port_regs(cfg, port);
+	status = readq_be(&fc_port_regs[FC_MTIP_STATUS / 8]);
 	status &= FC_MTIP_STATUS_MASK;
 
 	if (status == FC_MTIP_STATUS_ONLINE)
@@ -2225,10 +2230,9 @@ static ssize_t cxlflash_show_port_lun_table(u32 port,
 					    char *buf)
 {
 	struct device *dev = &cfg->dev->dev;
-	struct afu *afu = cfg->afu;
+	__be64 __iomem *fc_port_luns;
 	int i;
 	ssize_t bytes = 0;
-	__be64 __iomem *fc_port;
 
 	WARN_ON(port >= MAX_FC_PORTS);
 
@@ -2238,11 +2242,12 @@ static ssize_t cxlflash_show_port_lun_table(u32 port,
 		return -EINVAL;
 	}
 
-	fc_port = &afu->afu_map->global.fc_port[port][0];
+	fc_port_luns = get_fc_port_luns(cfg, port);
 
 	for (i = 0; i < CXLFLASH_NUM_VLUNS; i++)
 		bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
-				   "%03d: %016llx\n", i, readq_be(&fc_port[i]));
+				   "%03d: %016llx\n",
+				   i, readq_be(&fc_port_luns[i]));
 	return bytes;
 }
 
@@ -2462,6 +2467,7 @@ static void cxlflash_worker_thread(struct work_struct *work)
 						work_q);
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
+	__be64 __iomem *fc_port_regs;
 	int port;
 	ulong lock_flags;
 
@@ -2482,8 +2488,8 @@ static void cxlflash_worker_thread(struct work_struct *work)
 					       lock_flags);
 
 			/* The reset can block... */
-			afu_link_reset(afu, port,
-				       &afu->afu_map->global.fc_regs[port][0]);
+			fc_port_regs = get_fc_port_regs(cfg, port);
+			afu_link_reset(afu, port, fc_port_regs);
 			spin_lock_irqsave(cfg->host->host_lock, lock_flags);
 		}
 
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 547c8ff..9a6a9e9 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -821,9 +821,8 @@ void cxlflash_restore_luntable(struct cxlflash_cfg *cfg)
 	struct llun_info *lli, *temp;
 	u32 lind;
 	int k;
-	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
-	struct sisl_global_map __iomem *agm = &afu->afu_map->global;
+	__be64 __iomem *fc_port_luns;
 
 	mutex_lock(&global.mutex);
 
@@ -836,8 +835,8 @@ void cxlflash_restore_luntable(struct cxlflash_cfg *cfg)
 
 		for (k = 0; k < cfg->num_fc_ports; k++)
 			if (lli->port_sel & (1 << k)) {
-				writeq_be(lli->lun_id[k],
-					  &agm->fc_port[k][lind]);
+				fc_port_luns = get_fc_port_luns(cfg, k);
+				writeq_be(lli->lun_id[k], &fc_port_luns[lind]);
 				dev_dbg(dev, "\t%d=%llx\n", k, lli->lun_id[k]);
 			}
 	}
@@ -877,9 +876,8 @@ static int init_luntable(struct cxlflash_cfg *cfg, struct llun_info *lli)
 	u32 nports;
 	int rc = 0;
 	int k;
-	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
-	struct sisl_global_map __iomem *agm = &afu->afu_map->global;
+	__be64 __iomem *fc_port_luns;
 
 	mutex_lock(&global.mutex);
 
@@ -915,7 +913,8 @@ static int init_luntable(struct cxlflash_cfg *cfg, struct llun_info *lli)
 			if (!(lli->port_sel & (1 << k)))
 				continue;
 
-			writeq_be(lli->lun_id[k], &agm->fc_port[k][lind]);
+			fc_port_luns = get_fc_port_luns(cfg, k);
+			writeq_be(lli->lun_id[k], &fc_port_luns[lind]);
 			dev_dbg(dev, "\t%d=%llx\n", k, lli->lun_id[k]);
 		}
 
@@ -932,7 +931,8 @@ static int init_luntable(struct cxlflash_cfg *cfg, struct llun_info *lli)
 		}
 
 		lind = lli->lun_index = cfg->last_lun_index[chan];
-		writeq_be(lli->lun_id[chan], &agm->fc_port[chan][lind]);
+		fc_port_luns = get_fc_port_luns(cfg, chan);
+		writeq_be(lli->lun_id[chan], &fc_port_luns[lind]);
 		cfg->last_lun_index[chan]--;
 		dev_dbg(dev, "%s: Virtual LUNs on slot %d:\n\t%d=%llx\n",
 			__func__, lind, chan, lli->lun_id[chan]);
-- 
2.1.0
