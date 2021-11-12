Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2200AC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 16:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EDAB60ED5
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 16:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbhKLQma (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Nov 2021 11:42:30 -0500
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:60706 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbhKLQm3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Nov 2021 11:42:29 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id lZaQmTkjd1UGBlZaQmGHpS; Fri, 12 Nov 2021 17:39:37 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 12 Nov 2021 17:39:37 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com, satishkh@cisco.com,
        sebaddel@cisco.com, kartilak@cisco.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, njavali@marvell.com,
        mrangankar@marvell.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: Remove redundant 'flush_workqueue()' calls
Date:   Fri, 12 Nov 2021 17:39:33 +0100
Message-Id: <feb3511c02b9df0848c9cac8af3daf87d9ea5821.1636734915.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'destroy_workqueue()' already drains the queue before destroying it, so
there is no need to flush it explicitly.

Remove the redundant 'flush_workqueue()' calls.

This was generated with coccinelle:

@@
expression E;
@@
- 	flush_workqueue(E);
	destroy_workqueue(E);

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/bfa/bfad_im.c    | 1 -
 drivers/scsi/fnic/fnic_main.c | 4 +---
 drivers/scsi/lpfc/lpfc_init.c | 1 -
 drivers/scsi/qedi/qedi_main.c | 2 --
 drivers/scsi/qla2xxx/qla_os.c | 1 -
 5 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 759d2bb1ecdd..b5c1729974ac 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -756,7 +756,6 @@ void
 bfad_destroy_workq(struct bfad_im_s *im)
 {
 	if (im && im->drv_workq) {
-		flush_workqueue(im->drv_workq);
 		destroy_workqueue(im->drv_workq);
 		im->drv_workq = NULL;
 	}
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 44dbaa662d94..806aaf411d10 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -1145,10 +1145,8 @@ static void __exit fnic_cleanup_module(void)
 {
 	pci_unregister_driver(&fnic_driver);
 	destroy_workqueue(fnic_event_queue);
-	if (fnic_fip_queue) {
-		flush_workqueue(fnic_fip_queue);
+	if (fnic_fip_queue)
 		destroy_workqueue(fnic_fip_queue);
-	}
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
 	kmem_cache_destroy(fnic_io_req_cache);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ba17a8f740a9..93decd6c7ab1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8529,7 +8529,6 @@ static void
 lpfc_unset_driver_resource_phase2(struct lpfc_hba *phba)
 {
 	if (phba->wq) {
-		flush_workqueue(phba->wq);
 		destroy_workqueue(phba->wq);
 		phba->wq = NULL;
 	}
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 1dec814d8788..542dde3a1cfd 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2422,13 +2422,11 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 		iscsi_host_remove(qedi->shost);
 
 		if (qedi->tmf_thread) {
-			flush_workqueue(qedi->tmf_thread);
 			destroy_workqueue(qedi->tmf_thread);
 			qedi->tmf_thread = NULL;
 		}
 
 		if (qedi->offload_thread) {
-			flush_workqueue(qedi->offload_thread);
 			destroy_workqueue(qedi->offload_thread);
 			qedi->offload_thread = NULL;
 		}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index abcd30917263..9f9d2f075bbe 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3922,7 +3922,6 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 
 	/* Flush the work queue and remove it */
 	if (ha->wq) {
-		flush_workqueue(ha->wq);
 		destroy_workqueue(ha->wq);
 		ha->wq = NULL;
 	}
-- 
2.30.2

