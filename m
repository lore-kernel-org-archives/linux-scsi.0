From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v1 12/12] be2iscsi: Add lock to protect WRB alloc and free
Date: Thu,  4 Feb 2016 15:49:20 +0530
Message-ID: <1454581160-31869-13-git-send-email-jitendra.bhivare@broadcom.com>
References: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:62101 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S964903AbcBDKhk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 05:37:40 -0500
In-Reply-To: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

FW got into UE after running IO stress test

With kernel change to split session lock in frwd_lock and back_lock for tx
and rx path correspondingly, in the IO path, common resource used in driver
such as WRB was left unprotected.

Add wrb_lock spinlock to protect allocation and freeing of WRB.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/be2iscsi/be_main.c | 5 +++++
 drivers/scsi/be2iscsi/be_main.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fa2b589..0892ee2 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1190,12 +1190,14 @@ beiscsi_get_wrb_handle(struct hwi_wrb_context *pwrb_context,
 {
 	struct wrb_handle *pwrb_handle;
 
+	spin_lock_bh(&pwrb_context->wrb_lock);
 	pwrb_handle = pwrb_context->pwrb_handle_base[pwrb_context->alloc_index];
 	pwrb_context->wrb_handles_available--;
 	if (pwrb_context->alloc_index == (wrbs_per_cxn - 1))
 		pwrb_context->alloc_index = 0;
 	else
 		pwrb_context->alloc_index++;
+	spin_unlock_bh(&pwrb_context->wrb_lock);
 
 	return pwrb_handle;
 }
@@ -1227,12 +1229,14 @@ beiscsi_put_wrb_handle(struct hwi_wrb_context *pwrb_context,
 		       struct wrb_handle *pwrb_handle,
 		       unsigned int wrbs_per_cxn)
 {
+	spin_lock_bh(&pwrb_context->wrb_lock);
 	pwrb_context->pwrb_handle_base[pwrb_context->free_index] = pwrb_handle;
 	pwrb_context->wrb_handles_available++;
 	if (pwrb_context->free_index == (wrbs_per_cxn - 1))
 		pwrb_context->free_index = 0;
 	else
 		pwrb_context->free_index++;
+	spin_unlock_bh(&pwrb_context->wrb_lock);
 }
 
 /**
@@ -2920,6 +2924,7 @@ static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 			}
 			num_cxn_wrbh--;
 		}
+		spin_lock_init(&pwrb_context->wrb_lock);
 	}
 	idx = 0;
 	for (index = 0; index < phba->params.cxns_per_ctrl; index++) {
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 5ded3fa..30a4606 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -304,6 +304,7 @@ struct invalidate_command_table {
 #define BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr, cri) \
 	(phwi_ctrlr->wrb_context[cri].ulp_num)
 struct hwi_wrb_context {
+	spinlock_t wrb_lock;
 	struct list_head wrb_handle_list;
 	struct list_head wrb_handle_drvr_list;
 	struct wrb_handle **pwrb_handle_base;
-- 
2.5.0

