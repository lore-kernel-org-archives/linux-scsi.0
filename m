From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 07/11] Fix crash after firmware flash when IO is running.
Date: Thu, 15 Jun 2017 22:56:47 -0700
Message-ID: <20170616055651.9674-8-jsmart2021@gmail.com>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34352 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFPF5P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 01:57:15 -0400
Received: by mail-qt0-f193.google.com with SMTP id o21so7936714qtb.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2017 22:57:15 -0700 (PDT)
In-Reply-To: <20170616055651.9674-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

OS crashes after the completion of firmware download.

Failure in posting SCSI SGL buffers because number of SGL buffers
is less than total count. Some of the pending IOs are not completed
by driver. SGL buffers for these IOs are not added back to the list.
Pending IOs are not completed because lpfc_wq_list list is
initialized before completion of pending IOs.

Postpone lpfc_wq_list reinitialization by moving
lpfc_sli4_queue_destroy() after lpfc_hba_down_post().

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4f2cc395597e..8de70b9d79dd 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4303,7 +4303,6 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba)
 
 	/* Perform FCoE PCI function reset before freeing queue memory */
 	rc = lpfc_pci_function_reset(phba);
-	lpfc_sli4_queue_destroy(phba);
 
 	/* Restore PCI cmd register */
 	pci_write_config_word(phba->pcidev, PCI_COMMAND, cfg_value);
@@ -4428,6 +4427,7 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 		pci_disable_pcie_error_reporting(phba->pcidev);
 
 	lpfc_hba_down_post(phba);
+	lpfc_sli4_queue_destroy(phba);
 
 	return rc;
 }
-- 
2.11.0
