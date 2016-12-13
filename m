From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 11/13] be2iscsi: Reinit SGL handle, CID tables after TPE
Date: Tue, 13 Dec 2016 15:56:04 +0530
Message-ID: <1481624766-13846-12-git-send-email-jitendra.bhivare@broadcom.com>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:36481 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932562AbcLMK1P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 05:27:15 -0500
Received: by mail-qt0-f170.google.com with SMTP id w33so102124028qtc.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2016 02:27:15 -0800 (PST)
In-Reply-To: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

After TPE recovery, CID table needs to be repopulated as per CIDs in
WRBQ creation responses.

SGL handles table needs to be recreated for posting and its indices need
to be resetted.

This is achieved by calling beiscsi_cleanup_port when disabling and
beiscsi_init_port in enabling port.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 61 ++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a8a23d6..d96f7068 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3919,31 +3919,6 @@ static void beiscsi_free_mem(struct beiscsi_hba *phba)
 	kfree(phba->phwi_ctrlr);
 }
 
-static int beiscsi_init_controller(struct beiscsi_hba *phba)
-{
-	int ret;
-
-	ret = beiscsi_get_memory(phba);
-	if (ret < 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe -"
-			    "Failed in beiscsi_alloc_memory\n");
-		return ret;
-	}
-
-	ret = hwi_init_controller(phba);
-	if (ret)
-		goto free_init;
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : Return success from beiscsi_init_controller");
-
-	return 0;
-
-free_init:
-	beiscsi_free_mem(phba);
-	return ret;
-}
-
 static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 {
 	struct be_mem_descriptor *mem_descr_sglh, *mem_descr_sg;
@@ -4217,33 +4192,30 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
 {
 	int ret;
 
-	ret = beiscsi_init_controller(phba);
+	ret = hwi_init_controller(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe - Failed in"
-			    "beiscsi_init_controller\n");
+			    "BM_%d : init controller failed\n");
 		return ret;
 	}
 	ret = beiscsi_init_sgl_handle(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe - Failed in"
-			    "beiscsi_init_sgl_handle\n");
-		goto do_cleanup_ctrlr;
+			    "BM_%d : init sgl handles failed\n");
+		goto cleanup_port;
 	}
 
 	ret = hba_setup_cid_tbls(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Failed in hba_setup_cid_tbls\n");
+			    "BM_%d : setup CID table failed\n");
 		kfree(phba->io_sgl_hndl_base);
 		kfree(phba->eh_sgl_hndl_base);
-		goto do_cleanup_ctrlr;
+		goto cleanup_port;
 	}
-
 	return ret;
 
-do_cleanup_ctrlr:
+cleanup_port:
 	hwi_cleanup_port(phba);
 	return ret;
 }
@@ -5403,10 +5375,10 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
 
 	phba->shost->max_id = phba->params.cxns_per_ctrl;
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
-	ret = hwi_init_controller(phba);
-	if (ret) {
+	ret = beiscsi_init_port(phba);
+	if (ret < 0) {
 		__beiscsi_log(phba, KERN_ERR,
-			      "BM_%d : init controller failed %d\n", ret);
+			      "BM_%d : init port failed\n");
 		goto disable_msix;
 	}
 
@@ -5512,6 +5484,7 @@ static void beiscsi_disable_port(struct beiscsi_hba *phba, int unload)
 		cancel_work_sync(&pbe_eq->mcc_work);
 	}
 	hwi_cleanup_port(phba);
+	beiscsi_cleanup_port(phba);
 }
 
 static void beiscsi_sess_work(struct work_struct *work)
@@ -5722,11 +5695,18 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	phba->shost->max_id = phba->params.cxns_per_ctrl;
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
+	ret = beiscsi_get_memory(phba);
+	if (ret < 0) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BM_%d : alloc host mem failed\n");
+		goto free_port;
+	}
+
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe-"
-			    "Failed in beiscsi_init_port\n");
+			    "BM_%d : init port failed\n");
+		beiscsi_free_mem(phba);
 		goto free_port;
 	}
 
@@ -5868,7 +5848,6 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 
 	/* free all resources */
 	destroy_workqueue(phba->wq);
-	beiscsi_cleanup_port(phba);
 	beiscsi_free_mem(phba);
 
 	/* ctrl uninit */
-- 
2.7.4

