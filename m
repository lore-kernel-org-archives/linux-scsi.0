From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 04/12] sas_ata: ata_post_internal should abort the sas_task
Date: Tue, 30 Jan 2007 01:18:41 -0800
Message-ID: <20070130091841.31530.81645.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38829 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965452AbXA3JQJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:16:09 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9G81M005615
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:08 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9G8SX287570
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:08 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9G7xU010568
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:08 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


This patch adds a new field, lldd_task, to ata_queued_cmd so that libata
users such as libsas can associate some data with a qc.  The particular
ambition with this patch is to associate a sas_task with a qc; that way,
if libata decides to timeout a command, we can come back (in
sas_ata_post_internal) and abort the sas task.

One question remains: Is it necessary to reset the phy on error, or will
the libata error handler take care of it?  (Assuming that one is written,
of course.)  This patch, as it is today, works well enough to clean
things up when an ATA device probe attempt fails halfway through the probe,
though I'm not sure this is always the right thing to do.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c |   30 +++++++++++++++++++++++++++---
 include/linux/libata.h        |    1 +
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 46e1dbe..c8af884 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -88,12 +88,17 @@ static enum ata_completion_errors sas_to
 static void sas_ata_task_done(struct sas_task *task)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
-	struct domain_device *dev = qc->ap->private_data;
+	struct domain_device *dev;
 	struct task_status_struct *stat = &task->task_status;
 	struct ata_task_resp *resp = (struct ata_task_resp *)stat->buf;
 	enum ata_completion_errors ac;
 	unsigned long flags;
 
+	if (!qc)
+		goto qc_already_gone;
+
+	dev = qc->ap->private_data;
+
 	spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
 	if (stat->stat == SAS_PROTO_RESPONSE) {
 		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
@@ -114,9 +119,11 @@ static void sas_ata_task_done(struct sas
 		}
 	}
 
+	qc->lldd_task = NULL;
 	ata_qc_complete(qc);
 	spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
 
+qc_already_gone:
 	list_del_init(&task->list);
 	sas_free_task(task);
 }
@@ -166,6 +173,7 @@ static unsigned int sas_ata_qc_issue(str
 	task->scatter = qc->__sg;
 	task->ata_task.retry_count = 1;
 	task->task_state_flags = SAS_TASK_STATE_PENDING;
+	qc->lldd_task = task;
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_NCQ:
@@ -237,8 +245,24 @@ static void sas_ata_post_internal(struct
 	if (qc->flags & ATA_QCFLAG_FAILED)
 		qc->err_mask |= AC_ERR_OTHER;
 
-	if (qc->err_mask)
-		SAS_DPRINTK("%s: Failure; reset phy!\n", __FUNCTION__);
+	if (qc->err_mask) {
+		/*
+		 * Find the sas_task and kill it.  By this point,
+		 * libata has decided to kill the qc, so we needn't
+		 * bother with sas_ata_task_done.  But we still
+		 * ought to abort the task.
+		 */
+		struct sas_task *task = qc->lldd_task;
+		struct domain_device *dev = qc->ap->private_data;
+
+		qc->lldd_task = NULL;
+		if (task) {
+			task->uldd_task = NULL;
+			__sas_task_abort(task);
+		}
+
+		sas_phy_reset(dev->port->phy, 1);
+	}
 }
 
 static void sas_ata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 22aa69e..fe98957 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -452,6 +452,7 @@ struct ata_queued_cmd {
 	ata_qc_cb_t		complete_fn;
 
 	void			*private_data;
+	void			*lldd_task;
 };
 
 struct ata_port_stats {
