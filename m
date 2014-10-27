From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ipr: Wait for aborted command responses
Date: Mon, 27 Oct 2014 09:39:49 -0500
Message-ID: <201410271439.s9REdnmS023591@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51662 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbaJ0Ojy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2014 10:39:54 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 27 Oct 2014 10:39:53 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id E24F26E8053
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2014 10:28:34 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s9REdoVc65929282
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2014 14:39:50 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s9REdoDF023614
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2014 10:39:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Fixes a race condition in abort handling that was injected
when multiple interrupt support was added. When only a single
interrupt is present, the adapter guarantees it will send
responses for aborted commands prior to the response for the
abort command itself. With multiple interrupts, these responses
generally come back on different interrupts, so we need to
ensure the abort thread waits until the aborted command is
complete so we don't perform a double completion.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ipr.h |    1 
 2 files changed, 93 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_eh_wait drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_eh_wait	2014-10-24 08:57:55.545196774 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2014-10-24 08:57:55.565197003 -0500
@@ -683,6 +683,7 @@ static void ipr_init_ipr_cmnd(struct ipr
 	ipr_reinit_ipr_cmnd(ipr_cmd);
 	ipr_cmd->u.scratch = 0;
 	ipr_cmd->sibling = NULL;
+	ipr_cmd->eh_comp = NULL;
 	ipr_cmd->fast_done = fast_done;
 	init_timer(&ipr_cmd->timer);
 }
@@ -848,6 +849,8 @@ static void ipr_scsi_eh_done(struct ipr_
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
 	scsi_cmd->scsi_done(scsi_cmd);
+	if (ipr_cmd->eh_comp)
+		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 }
 
@@ -4853,6 +4856,84 @@ static int ipr_slave_alloc(struct scsi_d
 	return rc;
 }
 
+/**
+ * ipr_match_lun - Match function for specified LUN
+ * @ipr_cmd:	ipr command struct
+ * @device:		device to match (sdev)
+ *
+ * Returns:
+ *	1 if command matches sdev / 0 if command does not match sdev
+ **/
+static int ipr_match_lun(struct ipr_cmnd *ipr_cmd, void *device)
+{
+	if (ipr_cmd->scsi_cmd && ipr_cmd->scsi_cmd->device == device)
+		return 1;
+	return 0;
+}
+
+/**
+ * ipr_wait_for_ops - Wait for matching commands to complete
+ * @ipr_cmd:	ipr command struct
+ * @device:		device to match (sdev)
+ * @match:		match function to use
+ *
+ * Returns:
+ *	SUCCESS / FAILED
+ **/
+static int ipr_wait_for_ops(struct ipr_ioa_cfg *ioa_cfg, void *device,
+			    int (*match) (struct ipr_cmnd *, void *))
+{
+	struct ipr_cmnd *ipr_cmd;
+	DECLARE_COMPLETION_ONSTACK(comp);
+	int wait;
+	unsigned long flags;
+	signed long timeout = IPR_ABORT_TASK_TIMEOUT;
+	struct ipr_hrr_queue *hrrq;
+
+	ENTER;
+	do {
+		wait = 0;
+
+		for_each_hrrq(hrrq, ioa_cfg) {
+			spin_lock_irqsave(hrrq->lock, flags);
+			list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
+				if (match(ipr_cmd, device)) {
+					ipr_cmd->eh_comp = &comp;
+					wait++;
+				}
+			}
+			spin_unlock_irqrestore(hrrq->lock, flags);
+		}
+
+		if (wait) {
+			timeout = wait_for_completion_timeout(&comp, timeout);
+
+			if (!timeout) {
+				wait = 0;
+
+				for_each_hrrq(hrrq, ioa_cfg) {
+					spin_lock_irqsave(hrrq->lock, flags);
+					list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
+						if (match(ipr_cmd, device)) {
+							ipr_cmd->eh_comp = NULL;
+							wait++;
+						}
+					}
+					spin_unlock_irqrestore(hrrq->lock, flags);
+				}
+
+				if (wait)
+					dev_err(&ioa_cfg->pdev->dev, "Timed out waiting for aborted commands\n");
+				LEAVE;
+				return wait ? FAILED : SUCCESS;
+			}
+		}
+	} while (wait);
+
+	LEAVE;
+	return SUCCESS;
+}
+
 static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -5072,11 +5153,17 @@ static int __ipr_eh_dev_reset(struct scs
 static int ipr_eh_dev_reset(struct scsi_cmnd *cmd)
 {
 	int rc;
+	struct ipr_ioa_cfg *ioa_cfg;
+
+	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
 
 	spin_lock_irq(cmd->device->host->host_lock);
 	rc = __ipr_eh_dev_reset(cmd);
 	spin_unlock_irq(cmd->device->host->host_lock);
 
+	if (rc == SUCCESS)
+		rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
+
 	return rc;
 }
 
@@ -5254,13 +5341,18 @@ static int ipr_eh_abort(struct scsi_cmnd
 {
 	unsigned long flags;
 	int rc;
+	struct ipr_ioa_cfg *ioa_cfg;
 
 	ENTER;
 
+	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
+
 	spin_lock_irqsave(scsi_cmd->device->host->host_lock, flags);
 	rc = ipr_cancel_op(scsi_cmd);
 	spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, flags);
 
+	if (rc == SUCCESS)
+		rc = ipr_wait_for_ops(ioa_cfg, scsi_cmd->device, ipr_match_lun);
 	LEAVE;
 	return rc;
 }
diff -puN drivers/scsi/ipr.h~ipr_eh_wait drivers/scsi/ipr.h
--- linux/drivers/scsi/ipr.h~ipr_eh_wait	2014-10-24 08:57:55.550196832 -0500
+++ linux-bjking1/drivers/scsi/ipr.h	2014-10-24 08:57:55.574197107 -0500
@@ -1608,6 +1608,7 @@ struct ipr_cmnd {
 		struct scsi_device *sdev;
 	} u;
 
+	struct completion *eh_comp;
 	struct ipr_hrr_queue *hrrq;
 	struct ipr_ioa_cfg *ioa_cfg;
 };
_

