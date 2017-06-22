From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 03/17] cxlflash: Reset hardware queue context via specified register
Date: Wed, 21 Jun 2017 21:14:02 -0500
Message-ID: <1498097642-8789-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46161 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751140AbdFVCOV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 22:14:21 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5M29lbu114157
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:14:21 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b7rm6appn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:14:20 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 22:14:19 -0400
In-Reply-To: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Per the SISLite specification, context_reset() writes 0x1 to the LSB of the
reset register. When the AFU processes this reset request, it is expected
to clear the bit after reset is complete. The current implementation simply
checks that the entire value read back is not 1, instead of masking off the
LSB and evaluating it for a change to 0. Should the AFU manipulate other
bits during the reset (reading back a value of 0xF for example), successful
completion will be prematurely indicated given the existing logic.

Additionally, in the event that the context reset operation fails, there
does not currently exist a way to provide feedback to the initiator of the
reset. This poses a problem for the rare case that a context reset fails as
the caller will proceed on the assumption that all is well.

To remedy these issues, refactor the context reset routine to only mask off
the LSB when evaluating for success and return status to the caller. Also
update the context reset handler parameters to pass a hardware queue
reference instead of a single command to better reflect that the entire
queue associated with the context is impacted by the reset.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  2 +-
 drivers/scsi/cxlflash/main.c   | 83 +++++++++++++++++++++++-------------------
 2 files changed, 47 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 6fc32cfc..75decf6 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -211,7 +211,7 @@ struct hwq {
 struct afu {
 	struct hwq hwqs[CXLFLASH_MAX_HWQS];
 	int (*send_cmd)(struct afu *, struct afu_cmd *);
-	void (*context_reset)(struct afu_cmd *);
+	int (*context_reset)(struct hwq *);
 
 	/* AFU HW */
 	struct cxlflash_afu_map __iomem *afu_map;	/* entire MMIO map */
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 815d04b..b8dc379 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -189,55 +189,59 @@ static void cmd_complete(struct afu_cmd *cmd)
 }
 
 /**
- * context_reset() - reset command owner context via specified register
- * @cmd:	AFU command that timed out.
+ * context_reset() - reset context via specified register
+ * @hwq:	Hardware queue owning the context to be reset.
  * @reset_reg:	MMIO register to perform reset.
+ *
+ * Return: 0 on success, -errno on failure
  */
-static void context_reset(struct afu_cmd *cmd, __be64 __iomem *reset_reg)
+static int context_reset(struct hwq *hwq, __be64 __iomem *reset_reg)
 {
-	int nretry = 0;
-	u64 rrin = 0x1;
-	struct afu *afu = cmd->parent;
-	struct cxlflash_cfg *cfg = afu->parent;
+	struct cxlflash_cfg *cfg = hwq->afu->parent;
 	struct device *dev = &cfg->dev->dev;
+	int rc = -ETIMEDOUT;
+	int nretry = 0;
+	u64 val = 0x1;
 
-	dev_dbg(dev, "%s: cmd=%p\n", __func__, cmd);
+	dev_dbg(dev, "%s: hwq=%p\n", __func__, hwq);
 
-	writeq_be(rrin, reset_reg);
+	writeq_be(val, reset_reg);
 	do {
-		rrin = readq_be(reset_reg);
-		if (rrin != 0x1)
+		val = readq_be(reset_reg);
+		if ((val & 0x1) == 0x0) {
+			rc = 0;
 			break;
+		}
+
 		/* Double delay each time */
 		udelay(1 << nretry);
 	} while (nretry++ < MC_ROOM_RETRY_CNT);
 
-	dev_dbg(dev, "%s: returning rrin=%016llx nretry=%d\n",
-		__func__, rrin, nretry);
+	dev_dbg(dev, "%s: returning rc=%d, val=%016llx nretry=%d\n",
+		__func__, rc, val, nretry);
+	return rc;
 }
 
 /**
- * context_reset_ioarrin() - reset command owner context via IOARRIN register
- * @cmd:	AFU command that timed out.
+ * context_reset_ioarrin() - reset context via IOARRIN register
+ * @hwq:	Hardware queue owning the context to be reset.
+ *
+ * Return: 0 on success, -errno on failure
  */
-static void context_reset_ioarrin(struct afu_cmd *cmd)
+static int context_reset_ioarrin(struct hwq *hwq)
 {
-	struct afu *afu = cmd->parent;
-	struct hwq *hwq = get_hwq(afu, cmd->hwq_index);
-
-	context_reset(cmd, &hwq->host_map->ioarrin);
+	return context_reset(hwq, &hwq->host_map->ioarrin);
 }
 
 /**
- * context_reset_sq() - reset command owner context w/ SQ Context Reset register
- * @cmd:	AFU command that timed out.
+ * context_reset_sq() - reset context via SQ_CONTEXT_RESET register
+ * @hwq:	Hardware queue owning the context to be reset.
+ *
+ * Return: 0 on success, -errno on failure
  */
-static void context_reset_sq(struct afu_cmd *cmd)
+static int context_reset_sq(struct hwq *hwq)
 {
-	struct afu *afu = cmd->parent;
-	struct hwq *hwq = get_hwq(afu, cmd->hwq_index);
-
-	context_reset(cmd, &hwq->host_map->sq_ctx_reset);
+	return context_reset(hwq, &hwq->host_map->sq_ctx_reset);
 }
 
 /**
@@ -332,8 +336,7 @@ static int send_cmd_sq(struct afu *afu, struct afu_cmd *cmd)
  * @afu:	AFU associated with the host.
  * @cmd:	AFU command that was sent.
  *
- * Return:
- *	0 on success, -1 on timeout/error
+ * Return: 0 on success, -errno on failure
  */
 static int wait_resp(struct afu *afu, struct afu_cmd *cmd)
 {
@@ -343,15 +346,13 @@ static int wait_resp(struct afu *afu, struct afu_cmd *cmd)
 	ulong timeout = msecs_to_jiffies(cmd->rcb.timeout * 2 * 1000);
 
 	timeout = wait_for_completion_timeout(&cmd->cevent, timeout);
-	if (!timeout) {
-		afu->context_reset(cmd);
-		rc = -1;
-	}
+	if (!timeout)
+		rc = -ETIMEDOUT;
 
 	if (unlikely(cmd->sa.ioasc != 0)) {
 		dev_err(dev, "%s: cmd %02x failed, ioasc=%08x\n",
 			__func__, cmd->rcb.cdb[0], cmd->sa.ioasc);
-		rc = -1;
+		rc = -EIO;
 	}
 
 	return rc;
@@ -2033,6 +2034,7 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	struct hwq *hwq = get_hwq(afu, PRIMARY_HWQ);
 	char *buf = NULL;
 	int rc = 0;
+	int nretry = 0;
 	static DEFINE_MUTEX(sync_active);
 
 	if (cfg->state != STATE_NORMAL) {
@@ -2051,11 +2053,14 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	}
 
 	cmd = (struct afu_cmd *)PTR_ALIGN(buf, __alignof__(*cmd));
+
+retry:
 	init_completion(&cmd->cevent);
 	cmd->parent = afu;
 	cmd->hwq_index = hwq->index;
 
-	dev_dbg(dev, "%s: afu=%p cmd=%p %d\n", __func__, afu, cmd, ctx_hndl_u);
+	dev_dbg(dev, "%s: afu=%p cmd=%p ctx=%d nretry=%d\n",
+		__func__, afu, cmd, ctx_hndl_u, nretry);
 
 	cmd->rcb.req_flags = SISL_REQ_FLAGS_AFU_CMD;
 	cmd->rcb.ctx_id = hwq->ctx_hndl;
@@ -2076,8 +2081,12 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	}
 
 	rc = wait_resp(afu, cmd);
-	if (unlikely(rc))
-		rc = -EIO;
+	if (rc == -ETIMEDOUT) {
+		rc = afu->context_reset(hwq);
+		if (!rc && ++nretry < 2)
+			goto retry;
+	}
+
 out:
 	atomic_dec(&afu->cmds_active);
 	mutex_unlock(&sync_active);
-- 
2.1.0
