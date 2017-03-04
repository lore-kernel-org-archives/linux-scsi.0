From: jsmart2021@gmail.com
Subject: [PATCH 14/20] lpfc: Rename LPFC_MAX_EQ_DELAY to LPFC_MAX_EQ_DELAY_EQID_CNT
Date: Sat,  4 Mar 2017 09:30:34 -0800
Message-ID: <1488648640-5170-15-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35402 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752402AbdCDRbH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:31:07 -0500
Received: by mail-qk0-f196.google.com with SMTP id n127so34673191qkf.2
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:31:06 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Without apriori understanding of what the define is, the name gives
a very different impression of what it is (a max delay value
for an EQ).  Rename the define so it reflects what it is: the number
of EQ IDs that can be set in one instance of the MODIFY_EQ_DELAY
mbx command.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 3 ++-
 drivers/scsi/lpfc/lpfc_hw4.h  | 4 ++--
 drivers/scsi/lpfc/lpfc_init.c | 7 ++-----
 drivers/scsi/lpfc/lpfc_sli.c  | 5 ++++-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index b741dcb..fbd3a56 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4457,7 +4457,8 @@ lpfc_fcp_imax_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	phba->cfg_fcp_imax = (uint32_t)val;
-	for (i = 0; i < phba->io_channel_irqs; i++)
+
+	for (i = 0; i < phba->io_channel_irqs; i += LPFC_MAX_EQ_DELAY_EQID_CNT)
 		lpfc_modify_hba_eq_delay(phba, i);
 
 	return strlen(buf);
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index cfdb068..1527770 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1001,7 +1001,7 @@ struct eq_delay_info {
 	uint32_t phase;
 	uint32_t delay_multi;
 };
-#define	LPFC_MAX_EQ_DELAY	8
+#define	LPFC_MAX_EQ_DELAY_EQID_CNT	8
 
 struct sgl_page_pairs {
 	uint32_t sgl_pg0_addr_lo;
@@ -1070,7 +1070,7 @@ struct lpfc_mbx_modify_eq_delay {
 	union {
 		struct {
 			uint32_t num_eq;
-			struct eq_delay_info eq[LPFC_MAX_EQ_DELAY];
+			struct eq_delay_info eq[LPFC_MAX_EQ_DELAY_EQID_CNT];
 		} request;
 		struct {
 			uint32_t word0;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ecb8e1c..10c89e8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8769,12 +8769,9 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		}
 	}
 
-	/*
-	 * Configure EQ delay multipier for interrupt coalescing using
-	 * MODIFY_EQ_DELAY for all EQs created, LPFC_MAX_EQ_DELAY at a time.
-	 */
-	for (qidx = 0; qidx < io_channel; qidx += LPFC_MAX_EQ_DELAY)
+	for (qidx = 0; qidx < io_channel; qidx += LPFC_MAX_EQ_DELAY_EQID_CNT)
 		lpfc_modify_hba_eq_delay(phba, qidx);
+
 	return 0;
 
 out_destroy:
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8a606d0..618cdac 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1,3 +1,4 @@
+
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
@@ -13874,6 +13875,8 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
  * @startq: The starting FCP EQ to modify
  *
  * This function sends an MODIFY_EQ_DELAY mailbox command to the HBA.
+ * The command allows up to LPFC_MAX_EQ_DELAY_EQID_CNT EQ ID's to be
+ * updated in one mailbox command.
  *
  * The @phba struct is used to send mailbox command to HBA. The @startq
  * is used to get the starting FCP EQ to change.
@@ -13926,7 +13929,7 @@ lpfc_modify_hba_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 		eq_delay->u.request.eq[cnt].phase = 0;
 		eq_delay->u.request.eq[cnt].delay_multi = dmult;
 		cnt++;
-		if (cnt >= LPFC_MAX_EQ_DELAY)
+		if (cnt >= LPFC_MAX_EQ_DELAY_EQID_CNT)
 			break;
 	}
 	eq_delay->u.request.num_eq = cnt;
-- 
2.5.0
