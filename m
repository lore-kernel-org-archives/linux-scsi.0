From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 09/12] be2iscsi: Remove wq_name from beiscsi_hba
Date: Mon,  5 Dec 2016 13:36:48 +0530
Message-ID: <1480925211-13223-10-git-send-email-jitendra.bhivare@broadcom.com>
References: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34179 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbcLEIH1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 03:07:27 -0500
Received: by mail-qk0-f178.google.com with SMTP id q130so150701445qke.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2016 00:07:26 -0800 (PST)
In-Reply-To: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
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
index 723869d..c04080f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5619,11 +5619,12 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
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
@@ -5735,9 +5736,9 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 
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
1.8.3.1

