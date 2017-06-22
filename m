From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 07/17] cxlflash: Flush pending commands in cleanup path
Date: Wed, 21 Jun 2017 21:14:56 -0500
Message-ID: <1498097696-8934-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37401 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751140AbdFVCPF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 22:15:05 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5M2EZjY140591
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:15:05 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b7t205y6f-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:15:04 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 20:15:04 -0600
In-Reply-To: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

When the AFU is reset in an error path, pending scsi commands can be
silently dropped without completion or a formal abort. This puts the onus
on the cxlflash driver to notify mid-layer and indicating that the command
can be retried.

Once the card has been quiesced, the hardware send queue lock is acquired
to prevent any data movement while the pending commands are processed.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  5 +++-
 drivers/scsi/cxlflash/main.c   | 57 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 3eaa3be..11a5b0a 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -157,7 +157,9 @@ struct afu_cmd {
 	struct list_head queue;
 	u32 hwq_index;
 
-	u8 cmd_tmf:1;
+	u8 cmd_tmf:1,
+	   cmd_aborted:1;
+
 	struct list_head list;	/* Pending commands link */
 
 	/* As per the SISLITE spec the IOARCB EA has to be 16-byte aligned.
@@ -176,6 +178,7 @@ static inline struct afu_cmd *sc_to_afucz(struct scsi_cmnd *sc)
 	struct afu_cmd *afuc = sc_to_afuc(sc);
 
 	memset(afuc, 0, sizeof(*afuc));
+	INIT_LIST_HEAD(&afuc->queue);
 	return afuc;
 }
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 1446fab..0a3de42 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -194,6 +194,36 @@ static void cmd_complete(struct afu_cmd *cmd)
 }
 
 /**
+ * flush_pending_cmds() - flush all pending commands on this hardware queue
+ * @hwq:	Hardware queue to flush.
+ *
+ * The hardware send queue lock associated with this hardware queue must be
+ * held when calling this routine.
+ */
+static void flush_pending_cmds(struct hwq *hwq)
+{
+	struct afu_cmd *cmd, *tmp;
+	struct scsi_cmnd *scp;
+
+	list_for_each_entry_safe(cmd, tmp, &hwq->pending_cmds, list) {
+		/* Bypass command when on a doneq, cmd_complete() will handle */
+		if (!list_empty(&cmd->queue))
+			continue;
+
+		list_del(&cmd->list);
+
+		if (cmd->scp) {
+			scp = cmd->scp;
+			scp->result = (DID_IMM_RETRY << 16);
+			scp->scsi_done(scp);
+		} else {
+			cmd->cmd_aborted = true;
+			complete(&cmd->cevent);
+		}
+	}
+}
+
+/**
  * context_reset() - reset context via specified register
  * @hwq:	Hardware queue owning the context to be reset.
  * @reset_reg:	MMIO register to perform reset.
@@ -357,6 +387,9 @@ static int wait_resp(struct afu *afu, struct afu_cmd *cmd)
 	if (!timeout)
 		rc = -ETIMEDOUT;
 
+	if (cmd->cmd_aborted)
+		rc = -EAGAIN;
+
 	if (unlikely(cmd->sa.ioasc != 0)) {
 		dev_err(dev, "%s: cmd %02x failed, ioasc=%08x\n",
 			__func__, cmd->rcb.cdb[0], cmd->sa.ioasc);
@@ -702,6 +735,7 @@ static void term_mc(struct cxlflash_cfg *cfg, u32 index)
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
 	struct hwq *hwq;
+	ulong lock_flags;
 
 	if (!afu) {
 		dev_err(dev, "%s: returning with NULL afu\n", __func__);
@@ -719,6 +753,10 @@ static void term_mc(struct cxlflash_cfg *cfg, u32 index)
 	if (index != PRIMARY_HWQ)
 		WARN_ON(cxl_release_context(hwq->ctx));
 	hwq->ctx = NULL;
+
+	spin_lock_irqsave(&hwq->hsq_slock, lock_flags);
+	flush_pending_cmds(hwq);
+	spin_unlock_irqrestore(&hwq->hsq_slock, lock_flags);
 }
 
 /**
@@ -2155,7 +2193,7 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 
 	mutex_lock(&sync_active);
 	atomic_inc(&afu->cmds_active);
-	buf = kzalloc(sizeof(*cmd) + __alignof__(*cmd) - 1, GFP_KERNEL);
+	buf = kmalloc(sizeof(*cmd) + __alignof__(*cmd) - 1, GFP_KERNEL);
 	if (unlikely(!buf)) {
 		dev_err(dev, "%s: no memory for command\n", __func__);
 		rc = -ENOMEM;
@@ -2165,6 +2203,8 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	cmd = (struct afu_cmd *)PTR_ALIGN(buf, __alignof__(*cmd));
 
 retry:
+	memset(cmd, 0, sizeof(*cmd));
+	INIT_LIST_HEAD(&cmd->queue);
 	init_completion(&cmd->cevent);
 	cmd->parent = afu;
 	cmd->hwq_index = hwq->index;
@@ -2191,11 +2231,20 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	}
 
 	rc = wait_resp(afu, cmd);
-	if (rc == -ETIMEDOUT) {
+	switch (rc) {
+	case -ETIMEDOUT:
 		rc = afu->context_reset(hwq);
-		if (!rc && ++nretry < 2)
+		if (rc) {
+			cxlflash_schedule_async_reset(cfg);
+			break;
+		}
+		/* fall through to retry */
+	case -EAGAIN:
+		if (++nretry < 2)
 			goto retry;
-		cxlflash_schedule_async_reset(cfg);
+		/* fall through to exit */
+	default:
+		break;
 	}
 
 out:
-- 
2.1.0
