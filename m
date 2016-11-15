From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 07/14] cxlflash: Use cmd_size for private commands
Date: Tue, 15 Nov 2016 17:15:00 -0600
Message-ID: <1479251700-22928-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48245 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1161074AbcKOXPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 18:15:08 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAFNE7rq122426
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:15:08 -0500
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26r77vth27-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:15:08 -0500
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Tue, 15 Nov 2016 18:15:07 -0500
In-Reply-To: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Instead of using a private pool of AFU commands, use cmd_size to prime
the private pool of SCSI commands such that they are allocated with a
size large enough to contain an aligned AFU command. Use scsi_cmd_priv()
to derive the aligned/zeroed private command on queuecommand and TMF
paths. Remove cmd_checkout() as it is no longer required. The remaining
AFU private command infrastructure will be removed in a cleanup commit.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h | 14 +++++++++
 drivers/scsi/cxlflash/main.c   | 65 +++++++-----------------------------------
 2 files changed, 25 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 0744546..40507a9 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -19,6 +19,7 @@
 #include <linux/rwsem.h>
 #include <linux/types.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 
 extern const struct file_operations cxlflash_cxl_fops;
@@ -146,6 +147,19 @@ struct afu_cmd {
 	 */
 } __aligned(cache_line_size());
 
+static inline struct afu_cmd *sc_to_afuc(struct scsi_cmnd *sc)
+{
+	return PTR_ALIGN(scsi_cmd_priv(sc), __alignof__(struct afu_cmd));
+}
+
+static inline struct afu_cmd *sc_to_afucz(struct scsi_cmnd *sc)
+{
+	struct afu_cmd *afuc = sc_to_afuc(sc);
+
+	memset(afuc, 0, sizeof(*afuc));
+	return afuc;
+}
+
 struct afu {
 	/* Stuff requiring alignment go first. */
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 816d85c..7fa27db 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -35,38 +35,6 @@ MODULE_AUTHOR("Matthew R. Ochs <mrochs@linux.vnet.ibm.com>");
 MODULE_LICENSE("GPL");
 
 /**
- * cmd_checkout() - checks out an AFU command
- * @afu:	AFU to checkout from.
- *
- * Commands are checked out in a round-robin fashion. Note that since
- * the command pool is larger than the hardware queue, the majority of
- * times we will only loop once or twice before getting a command. The
- * CDB within the command is initialized (zeroed) prior to returning.
- *
- * Return: The checked out command or NULL when command pool is empty.
- */
-static struct afu_cmd *cmd_checkout(struct afu *afu)
-{
-	int k, dec = CXLFLASH_NUM_CMDS;
-	struct afu_cmd *cmd;
-
-	while (dec--) {
-		k = (afu->cmd_couts++ & (CXLFLASH_NUM_CMDS - 1));
-
-		cmd = &afu->cmd[k];
-
-		if (!atomic_dec_if_positive(&cmd->free)) {
-			pr_devel("%s: returning found index=%d cmd=%p\n",
-				 __func__, cmd->slot, cmd);
-			memset(cmd->rcb.cdb, 0, sizeof(cmd->rcb.cdb));
-			return cmd;
-		}
-	}
-
-	return NULL;
-}
-
-/**
  * cmd_checkin() - checks in an AFU command
  * @cmd:	AFU command to checkin.
  *
@@ -232,7 +200,6 @@ static void cmd_complete(struct afu_cmd *cmd)
 			scp->result = (DID_OK << 16);
 
 		cmd_is_tmf = cmd->cmd_tmf;
-		cmd_checkin(cmd); /* Don't use cmd after here */
 
 		pr_debug_ratelimited("%s: calling scsi_done scp=%p result=%X "
 				     "ioasc=%d\n", __func__, scp, scp->result,
@@ -390,7 +357,7 @@ static void wait_resp(struct afu *afu, struct afu_cmd *cmd)
  */
 static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 {
-	struct afu_cmd *cmd;
+	struct afu_cmd *cmd = sc_to_afucz(scp);
 
 	u32 port_sel = scp->device->channel + 1;
 	short lflag = 0;
@@ -401,13 +368,6 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	int rc = 0;
 	ulong to;
 
-	cmd = cmd_checkout(afu);
-	if (unlikely(!cmd)) {
-		dev_err(dev, "%s: could not get a free command\n", __func__);
-		rc = SCSI_MLQUEUE_HOST_BUSY;
-		goto out;
-	}
-
 	/* When Task Management Function is active do not send another */
 	spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 	if (cfg->tmf_active)
@@ -419,6 +379,7 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 
 	cmd->rcb.ctx_id = afu->ctx_hndl;
+	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
 	cmd->rcb.port_sel = port_sel;
 	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
 
@@ -427,8 +388,10 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
 			      SISL_REQ_FLAGS_SUP_UNDERRUN | lflag);
 
-	/* Stash the scp in the reserved field, for reuse during interrupt */
+	/* Stash the scp in the command, for reuse during interrupt */
 	cmd->rcb.scp = scp;
+	cmd->parent = afu;
+	spin_lock_init(&cmd->slock);
 
 	/* Copy the CDB from the cmd passed in */
 	memcpy(cmd->rcb.cdb, &tmfcmd, sizeof(tmfcmd));
@@ -436,7 +399,6 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	/* Send the command */
 	rc = send_cmd(afu, cmd);
 	if (unlikely(rc)) {
-		cmd_checkin(cmd);
 		spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 		cfg->tmf_active = false;
 		spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
@@ -492,7 +454,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
-	struct afu_cmd *cmd;
+	struct afu_cmd *cmd = sc_to_afucz(scp);
 	u32 port_sel = scp->device->channel + 1;
 	int nseg, i, ncount;
 	struct scatterlist *sg;
@@ -537,17 +499,11 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 		break;
 	}
 
-	cmd = cmd_checkout(afu);
-	if (unlikely(!cmd)) {
-		dev_err(dev, "%s: could not get a free command\n", __func__);
-		rc = SCSI_MLQUEUE_HOST_BUSY;
-		goto out;
-	}
-
 	kref_get(&cfg->afu->mapcount);
 	kref_got = 1;
 
 	cmd->rcb.ctx_id = afu->ctx_hndl;
+	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
 	cmd->rcb.port_sel = port_sel;
 	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
 
@@ -561,6 +517,8 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 
 	/* Stash the scp in the reserved field, for reuse during interrupt */
 	cmd->rcb.scp = scp;
+	cmd->parent = afu;
+	spin_lock_init(&cmd->slock);
 
 	nseg = scsi_dma_map(scp);
 	if (unlikely(nseg < 0)) {
@@ -581,10 +539,8 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 
 	/* Send the command */
 	rc = send_cmd(afu, cmd);
-	if (unlikely(rc)) {
-		cmd_checkin(cmd);
+	if (unlikely(rc))
 		scsi_dma_unmap(scp);
-	}
 
 out:
 	if (kref_got)
@@ -2338,6 +2294,7 @@ static struct scsi_host_template driver_template = {
 	.change_queue_depth = cxlflash_change_queue_depth,
 	.cmd_per_lun = CXLFLASH_MAX_CMDS_PER_LUN,
 	.can_queue = CXLFLASH_MAX_CMDS,
+	.cmd_size = sizeof(struct afu_cmd) + __alignof__(struct afu_cmd) - 1,
 	.this_id = -1,
 	.sg_tablesize = 1,	/* No scatter gather support */
 	.max_sectors = CXLFLASH_MAX_SECTORS,
-- 
2.1.0

