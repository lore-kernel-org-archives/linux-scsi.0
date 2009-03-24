From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/26] qla2xxx: Ensure the timer and DPC routines complete prior to midlayer tear-down.
Date: Tue, 24 Mar 2009 09:08:05 -0700
Message-ID: <1237910900-30817-12-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759230AbZCXQIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:34 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Since the routines can/will use resources such as devices and
rports that aren't valid after midlayer tear-down, correct this
potential race, by stopping the offending during the early stages
of the remove() callback.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   49 +++++++++++++++++++++++++----------------
 1 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0d586a4..c795461 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1890,6 +1890,16 @@ probe_init_failed:
 	ha->max_queues = 0;
 
 probe_failed:
+	if (base_vha->timer_active)
+		qla2x00_stop_timer(base_vha);
+	base_vha->flags.online = 0;
+	if (ha->dpc_thread) {
+		struct task_struct *t = ha->dpc_thread;
+
+		ha->dpc_thread = NULL;
+		kthread_stop(t);
+	}
+
 	qla2x00_free_device(base_vha);
 
 	scsi_host_put(base_vha->host);
@@ -1923,10 +1933,30 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 
+	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
+
 	qla2x00_dfs_remove(base_vha);
 
 	qla84xx_put_chip(base_vha);
 
+	/* Disable timer */
+	if (base_vha->timer_active)
+		qla2x00_stop_timer(base_vha);
+
+	base_vha->flags.online = 0;
+
+	/* Kill the kernel thread for this host */
+	if (ha->dpc_thread) {
+		struct task_struct *t = ha->dpc_thread;
+
+		/*
+		 * qla2xxx_wake_dpc checks for ->dpc_thread
+		 * so we need to zero it out.
+		 */
+		ha->dpc_thread = NULL;
+		kthread_stop(t);
+	}
+
 	qla2x00_free_sysfs_attr(base_vha);
 
 	fc_remove_host(base_vha->host);
@@ -1955,25 +1985,6 @@ static void
 qla2x00_free_device(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
-
-	/* Disable timer */
-	if (vha->timer_active)
-		qla2x00_stop_timer(vha);
-
-	vha->flags.online = 0;
-
-	/* Kill the kernel thread for this host */
-	if (ha->dpc_thread) {
-		struct task_struct *t = ha->dpc_thread;
-
-		/*
-		 * qla2xxx_wake_dpc checks for ->dpc_thread
-		 * so we need to zero it out.
-		 */
-		ha->dpc_thread = NULL;
-		kthread_stop(t);
-	}
 
 	if (ha->flags.fce_enabled)
 		qla2x00_disable_fce_trace(vha, NULL, NULL);
-- 
1.6.2.rc0.55.g30aa4f

