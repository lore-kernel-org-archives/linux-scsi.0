From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 5/8] mvsas: retry aborting task.
Date: Fri, 21 Mar 2008 19:06:11 +0800
Message-ID: <47E396A3.1050104@marvell.com>
Reply-To: kewei@marvell.com, kewei.mv@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:11991 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754387AbYCULGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 07:06:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org


Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index ebfe164..f4f7b0a 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -2159,42 +2159,59 @@ out_done:
 
 static int mvs_task_abort(struct sas_task *task)
 {
-    int rc = 1;
+    int rc;
     unsigned long flags;
     struct mvs_info *mvi = task->dev->port->ha->lldd_ha;
     struct pci_dev *pdev = mvi->pdev;
+    int tag;
 
     spin_lock_irqsave(&task->task_state_lock, flags);
     if (task->task_state_flags & SAS_TASK_STATE_DONE) {
         rc = TMF_RESP_FUNC_COMPLETE;
+        spin_unlock_irqrestore(&task->task_state_lock, flags);
         goto out_done;
     }
     spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-    /*FIXME*/
-    rc = TMF_RESP_FUNC_COMPLETE;
-
     switch (task->task_proto) {
     case SAS_PROTOCOL_SMP:
-        dev_printk(KERN_DEBUG, &pdev->dev, "SMP Abort! ");
+        dev_printk(KERN_DEBUG, &pdev->dev, "SMP Abort! \n");
         break;
     case SAS_PROTOCOL_SSP:
-        dev_printk(KERN_DEBUG, &pdev->dev, "SSP Abort! ");
+        dev_printk(KERN_DEBUG, &pdev->dev, "SSP Abort! \n");
         break;
     case SAS_PROTOCOL_SATA:
     case SAS_PROTOCOL_STP:
     case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:{
-        dev_printk(KERN_DEBUG, &pdev->dev, "STP Abort! "
-            "Dump D2H FIS: \n");
+        dev_printk(KERN_DEBUG, &pdev->dev, "STP Abort! \n");
+#if _MV_DUMP
+        dev_printk(KERN_DEBUG, &pdev->dev, "Dump D2H FIS: \n");
         mvs_hexdump(sizeof(struct host_to_dev_fis),
                 (void *)&task->ata_task.fis, 0);
         dev_printk(KERN_DEBUG, &pdev->dev, "Dump ATAPI Cmd : \n");
         mvs_hexdump(16, task->ata_task.atapi_packet, 0);
+#endif
+        spin_lock_irqsave(&task->task_state_lock, flags);
+        if (task->task_state_flags & SAS_TASK_NEED_DEV_RESET) {
+            /* TODO */
+            ;
+        }
+        spin_unlock_irqrestore(&task->task_state_lock, flags);
         break;
     }
     default:
         break;
     }
+
+    if (mvs_find_tag(mvi, task, &tag)) {
+        spin_lock_irqsave(&mvi->lock, flags);
+        mvs_slot_task_free(mvi, task, &mvi->slot_info[tag], tag);
+        spin_unlock_irqrestore(&mvi->lock, flags);
+    }
+    if (!mvs_task_exec(task, 1, GFP_ATOMIC))
+        rc = TMF_RESP_FUNC_COMPLETE;
+    else
+        rc = TMF_RESP_FUNC_FAILED;
 out_done:
     return rc;
 }
-- 
1.5.4

