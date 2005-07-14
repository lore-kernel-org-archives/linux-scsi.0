From: domen@coderock.org
Subject: [patch 2/2] scsi/lpfc_scsi: use msleep() instead of schedule_timeout()
Date: Thu, 14 Jul 2005 23:43:22 +0200
Message-ID: <20050714214322.441591000@homer>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:929 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S263149AbVGNVni (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2005 17:43:38 -0400
Content-Disposition: inline; filename=msleep-drivers_scsi_lpfc_lpfc_scsi
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, Nishanth Aravamudan <nacc@us.ibm.com>, domen@coderock.org

From: Nishanth Aravamudan <nacc@us.ibm.com>


Replace schedule_timeout() with msleep() to guarantee the
task delays as expected.

Patch is compile-tested.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Domen Puncer <domen@coderock.org>

---
 lpfc_scsi.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

Index: quilt/drivers/scsi/lpfc/lpfc_scsi.c
===================================================================
--- quilt.orig/drivers/scsi/lpfc/lpfc_scsi.c
+++ quilt/drivers/scsi/lpfc/lpfc_scsi.c
@@ -24,6 +24,7 @@
 
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -885,8 +886,7 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 		while (cmnd->host_scribble)
 		{
 			spin_unlock_irq(phba->host->host_lock);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(LPFC_ABORT_WAIT*HZ);
+			msleep(LPFC_ABORT_WAIT * 1000);
 			spin_lock_irq(phba->host->host_lock);
 			if (++loop_count
 			    > (2 * phba->cfg_nodev_tmo)/LPFC_ABORT_WAIT)
@@ -952,8 +952,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 
 		if (pnode->nlp_state != NLP_STE_MAPPED_NODE) {
 			spin_unlock_irq(phba->host->host_lock);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout( HZ/2);
+			msleep(500);
 			spin_lock_irq(phba->host->host_lock);
 		}
 		if ((pnode) && (pnode->nlp_state == NLP_STE_MAPPED_NODE))
@@ -1011,8 +1010,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 				       cmnd->device->id, cmnd->device->lun,
 				       LPFC_CTX_LUN))) {
 		spin_unlock_irq(phba->host->host_lock);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(LPFC_RESET_WAIT*HZ);
+		msleep(LPFC_RESET_WAIT * 1000);
 		spin_lock_irq(phba->host->host_lock);
 
 		if (++loopcnt
@@ -1110,8 +1108,7 @@ __lpfc_reset_bus_handler(struct scsi_cmn
 				&phba->sli.ring[phba->sli.fcp_ring],
 				0, 0, LPFC_CTX_HOST))) {
 		spin_unlock_irq(phba->host->host_lock);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(LPFC_RESET_WAIT*HZ);
+		msleep(LPFC_RESET_WAIT * 1000);
 		spin_lock_irq(phba->host->host_lock);
 
 		if (++loopcnt

--
