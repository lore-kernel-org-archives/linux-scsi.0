From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] lpfc: avoid double free of resource identifiers
Date: Wed, 11 Jan 2017 11:06:42 +0100
Message-ID: <20170111100642.18573-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Dick Kennedy <dick.kennedy@broadcom.com>, Roberto Sassu <rsassu@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

From: Roberto Sassu <rsassu@suse.de>

Set variables initialized in lpfc_sli4_alloc_resource_identifiers() to NULL
if an error occurred. Otherwise, lpfc_sli4_driver_resource_unset() attempts
to free the memory again.

Signed-off-by: Roberto Sassu <rsassu@suse.de>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_sli.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4faa767..a78a3df 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5954,18 +5954,25 @@ lpfc_sli4_alloc_resource_identifiers(struct lpfc_hba *phba)
 
  free_vfi_bmask:
 	kfree(phba->sli4_hba.vfi_bmask);
+	phba->sli4_hba.vfi_bmask = NULL;
  free_xri_ids:
 	kfree(phba->sli4_hba.xri_ids);
+	phba->sli4_hba.xri_ids = NULL;
  free_xri_bmask:
 	kfree(phba->sli4_hba.xri_bmask);
+	phba->sli4_hba.xri_bmask = NULL;
  free_vpi_ids:
 	kfree(phba->vpi_ids);
+	phba->vpi_ids = NULL;
  free_vpi_bmask:
 	kfree(phba->vpi_bmask);
+	phba->vpi_bmask = NULL;
  free_rpi_ids:
 	kfree(phba->sli4_hba.rpi_ids);
+	phba->sli4_hba.rpi_ids = NULL;
  free_rpi_bmask:
 	kfree(phba->sli4_hba.rpi_bmask);
+	phba->sli4_hba.rpi_bmask = NULL;
  err_exit:
 	return rc;
 }
-- 
2.10.2
