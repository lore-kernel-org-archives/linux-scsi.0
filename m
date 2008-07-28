From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Mon, 28 Jul 2008 21:33:18 +0400
Message-ID: <488E02DE.5080100@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:38537 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750720AbYG1RdP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2008 13:33:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

This patch fixes race on dpc_thread field of struct scsi_qla_host,
which can lead to crash on the module unload.

This patch is against 2.6.26

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 qla_def.h |    1 +
 qla_mbx.c |    2 +-
 qla_os.c  |   36 ++++++++++++++++++++++++++----------
 3 files changed, 28 insertions(+), 11 deletions(-)

diff -upr linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h
--- linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h	2008-07-14 01:51:29.000000000 +0400
+++ linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h	2008-07-24 10:07:39.000000000 +0400
@@ -2425,6 +2436,7 @@ typedef struct scsi_qla_host {
 	void			*sfp_data;
 	dma_addr_t		sfp_data_dma;
 
+	spinlock_t		dpc_lock;
 	struct task_struct	*dpc_thread;
 	uint8_t dpc_active;                  /* DPC routine is active */
 
diff -upr linux-2.6.26/drivers/scsi/qla2xxx/qla_mbx.c linux-2.6.26/drivers/scsi/qla2xxx/qla_mbx.c
--- linux-2.6.26/drivers/scsi/qla2xxx/qla_mbx.c	2008-07-14 01:51:29.000000000 +0400
+++ linux-2.6.26/drivers/scsi/qla2xxx/qla_mbx.c	2008-07-23 19:27:20.000000000 +0400
@@ -2683,7 +2687,7 @@ qla24xx_report_id_acquisition(scsi_qla_h
 		set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
 		set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
 
-		wake_up_process(ha->dpc_thread);
+		qla2xxx_wake_dpc(ha);
 	}
 }
 
diff -upr linux-2.6.26/drivers/scsi/qla2xxx/qla_os.c linux-2.6.26/drivers/scsi/qla2xxx/qla_os.c
--- linux-2.6.26/drivers/scsi/qla2xxx/qla_os.c	2008-07-14 01:51:29.000000000 +0400
+++ linux-2.6.26/drivers/scsi/qla2xxx/qla_os.c	2008-07-24 10:13:45.000000000 +0400
@@ -1632,6 +1630,8 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	/* load the F/W, read paramaters, and init the H/W */
 	ha->instance = num_hosts;
 
+	spin_lock_init(&ha->dpc_lock);
+
 	mutex_init(&ha->vport_lock);
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
@@ -1764,6 +1770,26 @@ qla2x00_remove_one(struct pci_dev *pdev)
 }
 
 static void
+qla2x00_stop_dpc_thread(scsi_qla_host_t *ha)
+{
+	struct task_struct *t = NULL;
+
+	spin_lock_irq(&ha->dpc_lock);
+	if (ha->dpc_thread != NULL) {
+		t = ha->dpc_thread;
+		/*
+		 * qla2xxx_wake_dpc checks for ->dpc_thread
+		 * so we need to zero it out.
+		 */
+		ha->dpc_thread = NULL;
+	}
+	spin_unlock_irq(&ha->dpc_lock);
+
+	if (t != NULL)
+		kthread_stop(t);
+}
+
+static void
 qla2x00_free_device(scsi_qla_host_t *ha)
 {
 	qla2x00_abort_all_cmds(ha, DID_NO_CONNECT << 16);
@@ -1775,16 +1801,7 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	ha->flags.online = 0;
 
 	/* Kill the kernel thread for this host */
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
+	qla2x00_stop_dpc_thread(ha);
 
 	if (ha->flags.fce_enabled)
 		qla2x00_disable_fce_trace(ha, NULL, NULL);
@@ -2427,8 +2444,11 @@ qla2x00_do_dpc(void *data)
 void
 qla2xxx_wake_dpc(scsi_qla_host_t *ha)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&ha->dpc_lock, flags);
 	if (ha->dpc_thread)
 		wake_up_process(ha->dpc_thread);
+	spin_unlock_irqrestore(&ha->dpc_lock, flags);
 }
 
 /*

