From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 08/17] cxlflash: Add scsi command abort handler
Date: Wed, 21 Jun 2017 21:15:06 -0500
Message-ID: <1498097706-8970-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37955 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751140AbdFVCPQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 22:15:16 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5M2EZnI140538
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:15:15 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b7t205yd6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:15:15 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 20:15:14 -0600
In-Reply-To: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

To date, CXL flash devices do not support a single command abort operation.
Instead, the SISLite specification provides a context reset operation to
cleanup all pending commands for a given context.

When a context reset is successful, it is guaranteed that the AFU has
aborted all currently pending I/O. This sequence is less invasive than a
device or host reset and can be executed to support scsi command abort
requests. Add eh_abort_handler callback support to process command timeouts
and abort requests.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 61 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 0a3de42..ceb247b 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -228,6 +228,10 @@ static void flush_pending_cmds(struct hwq *hwq)
  * @hwq:	Hardware queue owning the context to be reset.
  * @reset_reg:	MMIO register to perform reset.
  *
+ * When the reset is successful, the SISLite specification guarantees that
+ * the AFU has aborted all currently pending I/O. Accordingly, these commands
+ * must be flushed.
+ *
  * Return: 0 on success, -errno on failure
  */
 static int context_reset(struct hwq *hwq, __be64 __iomem *reset_reg)
@@ -237,9 +241,12 @@ static int context_reset(struct hwq *hwq, __be64 __iomem *reset_reg)
 	int rc = -ETIMEDOUT;
 	int nretry = 0;
 	u64 val = 0x1;
+	ulong lock_flags;
 
 	dev_dbg(dev, "%s: hwq=%p\n", __func__, hwq);
 
+	spin_lock_irqsave(&hwq->hsq_slock, lock_flags);
+
 	writeq_be(val, reset_reg);
 	do {
 		val = readq_be(reset_reg);
@@ -252,6 +259,11 @@ static int context_reset(struct hwq *hwq, __be64 __iomem *reset_reg)
 		udelay(1 << nretry);
 	} while (nretry++ < MC_ROOM_RETRY_CNT);
 
+	if (!rc)
+		flush_pending_cmds(hwq);
+
+	spin_unlock_irqrestore(&hwq->hsq_slock, lock_flags);
+
 	dev_dbg(dev, "%s: returning rc=%d, val=%016llx nretry=%d\n",
 		__func__, rc, val, nretry);
 	return rc;
@@ -2256,6 +2268,54 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 }
 
 /**
+ * cxlflash_eh_abort_handler() - abort a SCSI command
+ * @scp:	SCSI command to abort.
+ *
+ * CXL Flash devices do not support a single command abort. Reset the context
+ * as per SISLite specification. Flush any pending commands in the hardware
+ * queue before the reset.
+ *
+ * Return: SUCCESS/FAILED as defined in scsi/scsi.h
+ */
+static int cxlflash_eh_abort_handler(struct scsi_cmnd *scp)
+{
+	int rc = FAILED;
+	struct Scsi_Host *host = scp->device->host;
+	struct cxlflash_cfg *cfg = shost_priv(host);
+	struct afu_cmd *cmd = sc_to_afuc(scp);
+	struct device *dev = &cfg->dev->dev;
+	struct afu *afu = cfg->afu;
+	struct hwq *hwq = get_hwq(afu, cmd->hwq_index);
+
+	dev_dbg(dev, "%s: (scp=%p) %d/%d/%d/%llu "
+		"cdb=(%08x-%08x-%08x-%08x)\n", __func__, scp, host->host_no,
+		scp->device->channel, scp->device->id, scp->device->lun,
+		get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
+		get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
+		get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
+		get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+
+	/* When the state is not normal, another reset/reload is in progress.
+	 * Return failed and the mid-layer will invoke host reset handler.
+	 */
+	if (cfg->state != STATE_NORMAL) {
+		dev_dbg(dev, "%s: Invalid state for abort, state=%d\n",
+			__func__, cfg->state);
+		goto out;
+	}
+
+	rc = afu->context_reset(hwq);
+	if (unlikely(rc))
+		goto out;
+
+	rc = SUCCESS;
+
+out:
+	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
  * cxlflash_eh_device_reset_handler() - reset a single LUN
  * @scp:	SCSI command to send.
  *
@@ -2969,6 +3029,7 @@ static struct scsi_host_template driver_template = {
 	.ioctl = cxlflash_ioctl,
 	.proc_name = CXLFLASH_NAME,
 	.queuecommand = cxlflash_queuecommand,
+	.eh_abort_handler = cxlflash_eh_abort_handler,
 	.eh_device_reset_handler = cxlflash_eh_device_reset_handler,
 	.eh_host_reset_handler = cxlflash_eh_host_reset_handler,
 	.change_queue_depth = cxlflash_change_queue_depth,
-- 
2.1.0
