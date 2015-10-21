From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 24/37] cxlflash: Fix MMIO and endianness errors
Date: Wed, 21 Oct 2015 15:14:48 -0500
Message-ID: <1445458488-57055-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:37201 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbbJUUQM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:16:12 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 16:16:11 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id ED5D96E804C
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:04:19 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKG8vG58654820
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:16:08 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKG6F9027591
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:16:08 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

Sparse uncovered several errors with MMIO operations (accessing
directly) and handling endianness. These can cause issues when
running in different environments.

Introduce __iomem and proper endianness tags/swaps where
appropriate to make driver sparse clean.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
---
 drivers/scsi/cxlflash/common.h    | 10 +++++-----
 drivers/scsi/cxlflash/main.c      | 25 +++++++++++++------------
 drivers/scsi/cxlflash/superpipe.c |  6 +++---
 drivers/scsi/cxlflash/superpipe.h |  2 +-
 drivers/scsi/cxlflash/vlun.c      |  4 ++--
 5 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 3be5754..a810585 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -164,9 +164,9 @@ struct afu {
 
 	/* AFU HW */
 	struct cxl_ioctl_start_work work;
-	struct cxlflash_afu_map *afu_map;	/* entire MMIO map */
-	struct sisl_host_map *host_map;		/* MC host map */
-	struct sisl_ctrl_map *ctrl_map;		/* MC control map */
+	struct cxlflash_afu_map __iomem *afu_map;	/* entire MMIO map */
+	struct sisl_host_map __iomem *host_map;		/* MC host map */
+	struct sisl_ctrl_map __iomem *ctrl_map;		/* MC control map */
 
 	ctx_hndl_t ctx_hndl;	/* master's context handle */
 	u64 *hrrq_start;
@@ -188,10 +188,10 @@ struct afu {
 
 static inline u64 lun_to_lunid(u64 lun)
 {
-	u64 lun_id;
+	__be64 lun_id;
 
 	int_to_scsilun(lun, (struct scsi_lun *)&lun_id);
-	return swab64(lun_id);
+	return be64_to_cpu(lun_id);
 }
 
 int cxlflash_afu_sync(struct afu *, ctx_hndl_t, res_hndl_t, u8);
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index f37e968..14fb9b4 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -644,7 +644,7 @@ static void stop_afu(struct cxlflash_cfg *cfg)
 			complete(&afu->cmd[i].cevent);
 
 		if (likely(afu->afu_map)) {
-			cxl_psa_unmap((void *)afu->afu_map);
+			cxl_psa_unmap((void __iomem *)afu->afu_map);
 			afu->afu_map = NULL;
 		}
 	}
@@ -914,7 +914,7 @@ out:
  * that the FC link layer has synced, completed the handshaking process, and
  * is ready for login to start.
  */
-static void set_port_online(u64 *fc_regs)
+static void set_port_online(__be64 __iomem *fc_regs)
 {
 	u64 cmdcfg;
 
@@ -930,7 +930,7 @@ static void set_port_online(u64 *fc_regs)
  *
  * The provided MMIO region must be mapped prior to call.
  */
-static void set_port_offline(u64 *fc_regs)
+static void set_port_offline(__be64 __iomem *fc_regs)
 {
 	u64 cmdcfg;
 
@@ -954,7 +954,7 @@ static void set_port_offline(u64 *fc_regs)
  *	FALSE (0) when the specified port fails to come online after timeout
  *	-EINVAL when @delay_us is less than 1000
  */
-static int wait_port_online(u64 *fc_regs, u32 delay_us, u32 nretry)
+static int wait_port_online(__be64 __iomem *fc_regs, u32 delay_us, u32 nretry)
 {
 	u64 status;
 
@@ -985,7 +985,7 @@ static int wait_port_online(u64 *fc_regs, u32 delay_us, u32 nretry)
  *	FALSE (0) when the specified port fails to go offline after timeout
  *	-EINVAL when @delay_us is less than 1000
  */
-static int wait_port_offline(u64 *fc_regs, u32 delay_us, u32 nretry)
+static int wait_port_offline(__be64 __iomem *fc_regs, u32 delay_us, u32 nretry)
 {
 	u64 status;
 
@@ -1020,7 +1020,8 @@ static int wait_port_offline(u64 *fc_regs, u32 delay_us, u32 nretry)
  *	0 when the WWPN is successfully written and the port comes back online
  *	-1 when the port fails to go offline or come back up online
  */
-static int afu_set_wwpn(struct afu *afu, int port, u64 *fc_regs, u64 wwpn)
+static int afu_set_wwpn(struct afu *afu, int port, __be64 __iomem *fc_regs,
+			u64 wwpn)
 {
 	int rc = 0;
 
@@ -1065,7 +1066,7 @@ static int afu_set_wwpn(struct afu *afu, int port, u64 *fc_regs, u64 wwpn)
  * the alternate port exclusively while the reset takes place.
  * failure to come online is overridden.
  */
-static void afu_link_reset(struct afu *afu, int port, u64 *fc_regs)
+static void afu_link_reset(struct afu *afu, int port, __be64 __iomem *fc_regs)
 {
 	u64 port_sel;
 
@@ -1280,7 +1281,7 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 	struct device *dev = &cfg->dev->dev;
 	u64 reg_unmasked;
 	const struct asyc_intr_info *info;
-	struct sisl_global_map *global = &afu->afu_map->global;
+	struct sisl_global_map __iomem *global = &afu->afu_map->global;
 	u64 reg;
 	u8 port;
 	int i;
@@ -1466,7 +1467,7 @@ out:
 static void init_pcr(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
-	struct sisl_ctrl_map *ctrl_map;
+	struct sisl_ctrl_map __iomem *ctrl_map;
 	int i;
 
 	for (i = 0; i < MAX_CONTEXT; i++) {
@@ -1755,7 +1756,7 @@ static int init_afu(struct cxlflash_cfg *cfg)
 		dev_err(dev, "%s: call to start_afu failed, rc=%d!\n",
 			__func__, rc);
 		term_mc(cfg, UNDO_START);
-		cxl_psa_unmap((void *)afu->afu_map);
+		cxl_psa_unmap((void __iomem *)afu->afu_map);
 		afu->afu_map = NULL;
 		goto err1;
 	}
@@ -1835,8 +1836,8 @@ retry:
 	cmd->rcb.cdb[1] = mode;
 
 	/* The cdb is aligned, no unaligned accessors required */
-	*((u16 *)&cmd->rcb.cdb[2]) = swab16(ctx_hndl_u);
-	*((u32 *)&cmd->rcb.cdb[4]) = swab32(res_hndl_u);
+	*((__be16 *)&cmd->rcb.cdb[2]) = cpu_to_be16(ctx_hndl_u);
+	*((__be32 *)&cmd->rcb.cdb[4]) = cpu_to_be32(res_hndl_u);
 
 	rc = send_cmd(afu, cmd);
 	if (unlikely(rc))
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 8a7ec5d..a6316f5 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -253,7 +253,7 @@ static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 {
 	struct device *dev = &cfg->dev->dev;
 	struct afu *afu = cfg->afu;
-	struct sisl_ctrl_map *ctrl_map = ctxi->ctrl_map;
+	struct sisl_ctrl_map __iomem *ctrl_map = ctxi->ctrl_map;
 	int rc = 0;
 	u64 val;
 
@@ -365,8 +365,8 @@ retry:
 	 * as the buffer is allocated on an aligned boundary.
 	 */
 	mutex_lock(&gli->mutex);
-	gli->max_lba = be64_to_cpu(*((u64 *)&cmd_buf[0]));
-	gli->blk_len = be32_to_cpu(*((u32 *)&cmd_buf[8]));
+	gli->max_lba = be64_to_cpu(*((__be64 *)&cmd_buf[0]));
+	gli->blk_len = be32_to_cpu(*((__be32 *)&cmd_buf[8]));
 	mutex_unlock(&gli->mutex);
 
 out:
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 7947091..7df88ee 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -91,7 +91,7 @@ enum ctx_ctrl {
 #define DECODE_CTXID(_val)	(_val & 0xFFFFFFFF)
 
 struct ctx_info {
-	struct sisl_ctrl_map *ctrl_map; /* initialized at startup */
+	struct sisl_ctrl_map __iomem *ctrl_map; /* initialized at startup */
 	struct sisl_rht_entry *rht_start; /* 1 page (req'd for alignment),
 					     alloc/free on attach/detach */
 	u32 rht_out;		/* Number of checked out RHT entries */
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 96b074f..f91b5b3 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -786,7 +786,7 @@ void cxlflash_restore_luntable(struct cxlflash_cfg *cfg)
 	u32 chan;
 	u32 lind;
 	struct afu *afu = cfg->afu;
-	struct sisl_global_map *agm = &afu->afu_map->global;
+	struct sisl_global_map __iomem *agm = &afu->afu_map->global;
 
 	mutex_lock(&global.mutex);
 
@@ -831,7 +831,7 @@ static int init_luntable(struct cxlflash_cfg *cfg, struct llun_info *lli)
 	u32 lind;
 	int rc = 0;
 	struct afu *afu = cfg->afu;
-	struct sisl_global_map *agm = &afu->afu_map->global;
+	struct sisl_global_map __iomem *agm = &afu->afu_map->global;
 
 	mutex_lock(&global.mutex);
 
-- 
2.1.0

