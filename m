From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 01/21] lpfc: fix pci hot plug crash in timer management routines
Date: Fri, 29 Sep 2017 17:34:27 -0700
Message-ID: <20170930003447.10747-2-jsmart2021@gmail.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:52637 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752578AbdI3Ae5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 20:34:57 -0400
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, stable@vger.kernel.org, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

During pci hot plug, the kernel crashes in timer management code.

The sli4 remove_one handler is not stoping the timers as it starts to
remove the port so that it can be swapped.

Fix: Stop the timers early in the handler routine.

Note: Fix in SLI-4 only. SLI-3 already stopped the timers properly.

Cc: <stable@vger.kernel.org> # 4.12+
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v2: original v1 hot plug patch split into 2 patches

 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7e7ae786121b..1773b9ce3149 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11419,6 +11419,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	lpfc_debugfs_terminate(vport);
 	lpfc_sli4_hba_unset(phba);
 
+	lpfc_stop_hba_timers(phba);
 	spin_lock_irq(&phba->hbalock);
 	list_del_init(&vport->listentry);
 	spin_unlock_irq(&phba->hbalock);
-- 
2.13.1
