From: Anton Blanchard <anton@ozlabs.org>
Subject: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Mon, 13 Feb 2017 08:49:20 +1100
Message-ID: <20170212214920.28866-1-anton@ozlabs.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:50219 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750999AbdBLVti (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Feb 2017 16:49:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, benh@kernel.crashing.org, jk@ozlabs.org
Cc: linux-scsi@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

We see lpfc devices regularly fail during kexec. Fix this by adding
a shutdown method which mirrors the remove method.

Signed-off-by: Anton Blanchard <anton@samba.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4776fd8..10f75ad 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11447,6 +11447,7 @@ static struct pci_driver lpfc_driver = {
 	.id_table	= lpfc_id_table,
 	.probe		= lpfc_pci_probe_one,
 	.remove		= lpfc_pci_remove_one,
+	.shutdown	= lpfc_pci_remove_one,
 	.suspend        = lpfc_pci_suspend_one,
 	.resume		= lpfc_pci_resume_one,
 	.err_handler    = &lpfc_err_handler,
-- 
2.9.3
