From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 10/12] sas_ata: Implement sas_task_abort for ATA devices
Date: Tue, 30 Jan 2007 01:18:58 -0800
Message-ID: <20070130091858.31530.30087.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39243 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965462AbXA3JQ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:16:26 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9H3sR018338
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:17:03 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9GP9t275840
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:25 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9GOlf010895
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:24 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


ATA devices need special handling for sas_task_abort.  If the ATA command
came from SCSI, then we merely need to tell SCSI to abort the scsi_cmnd.
However, internal commands require a bit more work--we need to fill the qc
with the appropriate error status and complete the command, and eventually
post_internal will issue the actual ABORT TASK.
---

 drivers/scsi/libsas/sas_ata.c       |   47 +++++++++++++++++++++++++++++++++--
 drivers/scsi/libsas/sas_internal.h  |    3 ++
 drivers/scsi/libsas/sas_scsi_host.c |    8 ++++--
 include/scsi/sas_ata.h              |    2 +
 4 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 8111222..1b7221c 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -30,6 +30,8 @@ #include <scsi/scsi.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
 #include "../scsi_sas_internal.h"
+#include "../scsi_transport_api.h"
+#include <scsi/scsi_eh.h>
 
 static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
 {
@@ -91,6 +93,7 @@ static void sas_ata_task_done(struct sas
 	struct domain_device *dev;
 	struct task_status_struct *stat = &task->task_status;
 	struct ata_task_resp *resp = (struct ata_task_resp *)stat->buf;
+	struct sas_ha_struct *sas_ha;
 	enum ata_completion_errors ac;
 	unsigned long flags;
 
@@ -98,6 +101,7 @@ static void sas_ata_task_done(struct sas
 		goto qc_already_gone;
 
 	dev = qc->ap->private_data;
+	sas_ha = dev->port->ha;
 
 	spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
 	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_GOOD) {
@@ -124,6 +128,20 @@ static void sas_ata_task_done(struct sas
 	ata_qc_complete(qc);
 	spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
 
+	/*
+	 * If the sas_task has an ata qc, a scsi_cmnd and the aborted
+	 * flag is set, then we must have come in via the libsas EH
+	 * functions.  When we exit this function, we need to put the
+	 * scsi_cmnd on the list of finished errors.  The ata_qc_complete
+	 * call cleans up the libata side of things but we're protected
+	 * from the scsi_cmnd going away because the scsi_cmnd is owned
+	 * by the EH, making libata's call to scsi_done a NOP.
+	 */
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (qc->scsicmd && task->task_state_flags & SAS_TASK_STATE_ABORTED)
+		scsi_eh_finish_cmd(qc->scsicmd, &sas_ha->eh_done_q);
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+
 qc_already_gone:
 	list_del_init(&task->list);
 	sas_free_task(task);
@@ -259,15 +277,18 @@ static void sas_ata_post_internal(struct
 		 * ought to abort the task.
 		 */
 		struct sas_task *task = qc->lldd_task;
-		struct domain_device *dev = qc->ap->private_data;
+		unsigned long flags;
 
 		qc->lldd_task = NULL;
 		if (task) {
+			/* Should this be a AT(API) device reset? */
+			spin_lock_irqsave(&task->task_state_lock, flags);
+			task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
+			spin_unlock_irqrestore(&task->task_state_lock, flags);
+
 			task->uldd_task = NULL;
 			__sas_task_abort(task);
 		}
-
-		sas_phy_reset(dev->port->phy, 1);
 	}
 }
 
@@ -409,3 +430,23 @@ int sas_ata_init_host_and_port(struct do
 
 	return 0;
 }
+
+void sas_ata_task_abort(struct sas_task *task)
+{
+	struct ata_queued_cmd *qc = task->uldd_task;
+	struct completion *waiting;
+
+	/* Bounce SCSI-initiated commands to the SCSI EH */
+	if (qc->scsicmd) {
+		scsi_req_abort_cmd(qc->scsicmd);
+		scsi_schedule_eh(qc->scsicmd->device->host);
+		return;
+	}
+
+	/* Internal command, fake a timeout and complete. */
+	qc->flags &= ~ATA_QCFLAG_ACTIVE;
+	qc->flags |= ATA_QCFLAG_FAILED;
+	qc->err_mask |= AC_ERR_TIMEOUT;
+	waiting = qc->private_data;
+	complete(waiting);
+}
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index a78638d..2b8213b 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -39,6 +39,9 @@ #else
 #define SAS_DPRINTK(fmt, ...)
 #endif
 
+#define TO_SAS_TASK(_scsi_cmd)  ((void *)(_scsi_cmd)->host_scribble)
+#define ASSIGN_SAS_TASK(_sc, _t) do { (_sc)->host_scribble = (void *) _t; } while (0)
+
 void sas_scsi_recover_host(struct Scsi_Host *shost);
 
 int sas_show_class(enum sas_class class, char *buf);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 5b0c471..a30c0b7 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -44,9 +44,6 @@ #include <linux/libata.h>
 
 /* ---------- SCSI Host glue ---------- */
 
-#define TO_SAS_TASK(_scsi_cmd)  ((void *)(_scsi_cmd)->host_scribble)
-#define ASSIGN_SAS_TASK(_sc, _t) do { (_sc)->host_scribble = (void *) _t; } while (0)
-
 static void sas_scsi_task_done(struct sas_task *task)
 {
 	struct task_status_struct *ts = &task->task_status;
@@ -998,6 +995,11 @@ void sas_task_abort(struct sas_task *tas
 		return;
 	}
 
+	if (dev_is_sata(task->dev)) {
+		sas_ata_task_abort(task);
+		return;
+	}
+
 	scsi_req_abort_cmd(sc);
 	scsi_schedule_eh(sc->device->host);
 }
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 72a1904..3407c81 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -36,4 +36,6 @@ static inline int dev_is_sata(struct dom
 int sas_ata_init_host_and_port(struct domain_device *found_dev,
 			       struct scsi_target *starget);
 
+void sas_ata_task_abort(struct sas_task *task);
+
 #endif /* _SAS_ATA_H_ */
