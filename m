From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] scsi/lpfc: use remove handler as shutdown handler
Date: Mon, 26 Jan 2015 13:18:58 -0200
Message-ID: <1422285538-487-1-git-send-email-cascardo@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.smart@emulex.com, JBottomley@parallels.com, linux-kernel@vger.kernel.org, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Without a shutdown handler, some cards behave very badly after a kexec.
During probe, pending DMA writes will corrupt kernel memory, for
example.

Using the remove handler guarantees we will use a well tested path.

With this patch I applied, I managed to use kexec multiple times and
probe and SCSI scan worked every time.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/scsi/lpfc/lpfc_init.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0b2c53a..8aa804a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11248,6 +11248,7 @@ static struct pci_driver lpfc_driver = {
 	.id_table	= lpfc_id_table,
 	.probe		= lpfc_pci_probe_one,
 	.remove		= lpfc_pci_remove_one,
+	.shutdown	= lpfc_pci_remove_one,
 	.suspend        = lpfc_pci_suspend_one,
 	.resume		= lpfc_pci_resume_one,
 	.err_handler    = &lpfc_err_handler,
-- 
1.7.10.4
