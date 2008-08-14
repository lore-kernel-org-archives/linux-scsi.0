From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/8] qla2xxx: Explicitly tear-down vports during PCI remove_one().
Date: Wed, 13 Aug 2008 21:37:01 -0700
Message-ID: <1218688622-71361-7-git-send-email-andrew.vasquez@qlogic.com>
References: <20080814043632.GL61889@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:57991 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYHNEhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 00:37:05 -0400
In-Reply-To: <20080814043632.GL61889@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

During internal testing, we've seen issues (hangs) with the
'deferred' vport tear-down-processing typically accompanied with
the fc_remove_host() call.  This is due to the current
implementation's back-end vport handling being performed by the
physical-HA's DPC thread where premature shutdown could lead to
latent vport requests without a processor.

This should also address a problem reported by Gal Rosen
(http://marc.info/?l=linux-scsi&m=121731664417358&w=2) where the
driver would attempt to awaken a previously torn-down DPC thread
from interrupt context by implicitly calling wake_up_process()
rather than the driver's qla2xxx_wake_dpc() helper.  Rather, than
reshuffle the remove_one() device-removal code, during unload,
depend on the driver's timer to wake-up the DPC process, by
limiting wake-ups based on an 'unloading' flag.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c  |   13 ++++++++++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 8c5b25c..431c19e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2236,6 +2236,7 @@ typedef struct scsi_qla_host {
 #define REGISTER_FDMI_NEEDED	26
 #define FCPORT_UPDATE_NEEDED	27
 #define VP_DPC_NEEDED		28	/* wake up for VP dpc handling */
+#define UNLOADING		29
 
 	uint32_t	device_flags;
 #define DFLG_LOCAL_DEVICES		BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bc90d6b..813bc77 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2686,7 +2686,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
 		set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
 		set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
 
-		wake_up_process(ha->dpc_thread);
+		qla2xxx_wake_dpc(ha);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e0880ad..26afe44 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1775,10 +1775,15 @@ probe_out:
 static void
 qla2x00_remove_one(struct pci_dev *pdev)
 {
-	scsi_qla_host_t *ha;
+	scsi_qla_host_t *ha, *vha, *temp;
 
 	ha = pci_get_drvdata(pdev);
 
+	list_for_each_entry_safe(vha, temp, &ha->vp_list, vp_list)
+		fc_vport_terminate(vha->fc_vport);
+
+	set_bit(UNLOADING, &ha->dpc_flags);
+
 	qla2x00_dfs_remove(ha);
 
 	qla84xx_put_chip(ha);
@@ -2450,8 +2455,10 @@ qla2x00_do_dpc(void *data)
 void
 qla2xxx_wake_dpc(scsi_qla_host_t *ha)
 {
-	if (ha->dpc_thread)
-		wake_up_process(ha->dpc_thread);
+	struct task_struct *t = ha->dpc_thread;
+
+	if (!test_bit(UNLOADING, &ha->dpc_flags) && t)
+		wake_up_process(t);
 }
 
 /*
-- 
1.6.0.rc2.22.g71b9

