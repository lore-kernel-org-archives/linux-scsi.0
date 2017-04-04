From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 13/19] Fix driver load issues when MRQ=8
Date: Tue,  4 Apr 2017 10:17:06 -0700
Message-ID: <1491326232-11255-14-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38158 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755143AbdDDRZl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:41 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 14D1430C0A5
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:33 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

The symptom is that the driver will fail to login to the fabric. The reason is bacause it is out of iocb resources.
This fix algins the number of MRQ resources with the total resources so that it can handle fabric events when needed.
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 drivers/scsi/lpfc/lpfc_nvme.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 88977b8..12c7e9a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10280,7 +10280,7 @@ lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
 	struct lpfc_hba   *phba;
 	struct lpfc_vport *vport = NULL;
 	struct Scsi_Host  *shost = NULL;
-	int error;
+	int error, cnt;
 	uint32_t cfg_mode, intr_mode;
 
 	/* Allocate memory for HBA structure */
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 9468679..5145ef2 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1480,6 +1480,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 				 phba->hba_flag);
 		return;
 	}
+	nvmereq_wqe = &lpfc_nbuf->cur_iocbq;
 
 	lpfc_nbuf = (struct lpfc_nvme_buf *)pnvme_fcreq->private;
 	if (!lpfc_nbuf) {
-- 
2.1.0
