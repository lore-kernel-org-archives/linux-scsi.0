From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 09/13] be2iscsi: Remove wq_name from beiscsi_hba
Date: Tue, 13 Dec 2016 15:56:02 +0530
Message-ID: <1481624766-13846-10-git-send-email-jitendra.bhivare@broadcom.com>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34295 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbcLMK1J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 05:27:09 -0500
Received: by mail-qk0-f176.google.com with SMTP id q130so111374649qke.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2016 02:27:09 -0800 (PST)
In-Reply-To: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

wq_name is used only to set WQ name when its being allocated.
Remove it from beiscsi_hba structure and define locally.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 9 +++++----
 drivers/scsi/be2iscsi/be_main.h | 1 -
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a8e67c6..a68f1be 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5623,11 +5623,12 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 static int beiscsi_dev_probe(struct pci_dev *pcidev,
 			     const struct pci_device_id *id)
 {
-	struct beiscsi_hba *phba = NULL;
-	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
+	struct hwi_controller *phwi_ctrlr;
+	struct beiscsi_hba *phba = NULL;
 	struct be_eq_obj *pbe_eq;
 	unsigned int s_handle;
+	char wq_name[20];
 	int ret, i;
 
 	ret = beiscsi_enable_pci(pcidev);
@@ -5739,9 +5740,9 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	phba->ctrl.mcc_alloc_index = phba->ctrl.mcc_free_index = 0;
 
-	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_%02x_wq",
+	snprintf(wq_name, sizeof(wq_name), "beiscsi_%02x_wq",
 		 phba->shost->host_no);
-	phba->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, phba->wq_name);
+	phba->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, wq_name);
 	if (!phba->wq) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : beiscsi_dev_probe-"
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 73cc2f7..30379de 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -410,7 +410,6 @@ struct beiscsi_hba {
 	u8 port_name;
 	u8 port_speed;
 	char fw_ver_str[BEISCSI_VER_STRLEN];
-	char wq_name[20];
 	struct workqueue_struct *wq;	/* The actuak work queue */
 	struct be_ctrl_info ctrl;
 	unsigned int generation;
-- 
2.7.4

