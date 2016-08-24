From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 1/3] be2iscsi: Fix error return code
Date: Wed, 24 Aug 2016 15:03:13 +0530
Message-ID: <1472031195-14556-2-git-send-email-jitendra.bhivare@broadcom.com>
References: <1472031195-14556-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:33814 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753945AbcHXJgE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2016 05:36:04 -0400
Received: by mail-pf0-f181.google.com with SMTP id p64so5240667pfb.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2016 02:36:04 -0700 (PDT)
In-Reply-To: <1472031195-14556-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, julia.lawall@lip6.fr, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

We know that 'ret' is not an error code because it has been tested a few
lines above.
So, if one of these function fails, 0 will be returned instead of an error
code.
Return -ENOMEM instead.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

'ret' needs to be set with error code if hba_setup_cid_tbls fails.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 222edfc..b30db87 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3017,8 +3017,8 @@ static int be_fill_queue(struct be_queue_info *q,
 static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 			     struct hwi_context_memory *phwi_context)
 {
+	int ret = -ENOMEM, eq_for_mcc;
 	unsigned int i, num_eq_pages;
-	int ret = 0, eq_for_mcc;
 	struct be_queue_info *eq;
 	struct be_dma_mem *mem;
 	void *eq_vaddress;
@@ -3036,8 +3036,8 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 		mem = &eq->dma_mem;
 		phwi_context->be_eq[i].phba = phba;
 		eq_vaddress = pci_alloc_consistent(phba->pcidev,
-						     num_eq_pages * PAGE_SIZE,
-						     &paddr);
+						   num_eq_pages * PAGE_SIZE,
+						   &paddr);
 		if (!eq_vaddress)
 			goto create_eq_error;
 
@@ -3065,6 +3065,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 			    phwi_context->be_eq[i].q.id);
 	}
 	return 0;
+
 create_eq_error:
 	for (i = 0; i < (phba->num_cpus + eq_for_mcc); i++) {
 		eq = &phwi_context->be_eq[i].q;
@@ -3081,11 +3082,11 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 			     struct hwi_context_memory *phwi_context)
 {
 	unsigned int i, num_cq_pages;
-	int ret = 0;
 	struct be_queue_info *cq, *eq;
 	struct be_dma_mem *mem;
 	struct be_eq_obj *pbe_eq;
 	void *cq_vaddress;
+	int ret = -ENOMEM;
 	dma_addr_t paddr;
 
 	num_cq_pages = PAGES_REQUIRED(phba->params.num_cq_entries * \
@@ -3099,10 +3100,11 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 		pbe_eq->phba = phba;
 		mem = &cq->dma_mem;
 		cq_vaddress = pci_alloc_consistent(phba->pcidev,
-						     num_cq_pages * PAGE_SIZE,
-						     &paddr);
+						   num_cq_pages * PAGE_SIZE,
+						   &paddr);
 		if (!cq_vaddress)
 			goto create_cq_error;
+
 		ret = be_fill_queue(cq, phba->params.num_cq_entries,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
@@ -3137,7 +3139,6 @@ create_cq_error:
 					    mem->va, mem->dma);
 	}
 	return ret;
-
 }
 
 static int
@@ -4230,7 +4231,8 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
 		goto do_cleanup_ctrlr;
 	}
 
-	if (hba_setup_cid_tbls(phba)) {
+	ret = hba_setup_cid_tbls(phba);
+	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : Failed in hba_setup_cid_tbls\n");
 		kfree(phba->io_sgl_hndl_base);
@@ -5627,7 +5629,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
 	unsigned int s_handle;
-	int ret = 0, i;
+	int ret, i;
 
 	ret = beiscsi_enable_pci(pcidev);
 	if (ret < 0) {
@@ -5640,6 +5642,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	if (!phba) {
 		dev_err(&pcidev->dev,
 			"beiscsi_dev_probe - Failed in beiscsi_hba_alloc\n");
+		ret = -ENOMEM;
 		goto disable_pci;
 	}
 
@@ -5744,6 +5747,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : beiscsi_dev_probe-"
 			    "Failed to allocate work queue\n");
+		ret = -ENOMEM;
 		goto free_twq;
 	}
 
-- 
1.9.1

