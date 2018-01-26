From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 12/19] lpfc: Indicate CONF support in NVMe PRLI
Date: Fri, 26 Jan 2018 11:22:32 -0800
Message-ID: <20180126192239.10727-13-jsmart2021@gmail.com>
References: <20180126192239.10727-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35106 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbeAZTXI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2018 14:23:08 -0500
Received: by mail-qt0-f193.google.com with SMTP id g14so4004841qti.2
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2018 11:23:07 -0800 (PST)
In-Reply-To: <20180126192239.10727-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Revise the NVME PRLI to indicate CONF support.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c       | 3 ++-
 drivers/scsi/lpfc/lpfc_hw4.h       | 6 +++---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 3 ---
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 234c7c015982..404e1af5e2ab 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2293,10 +2293,11 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (phba->nvmet_support) {
 			bf_set(prli_tgt, npr_nvme, 1);
 			bf_set(prli_disc, npr_nvme, 1);
-
 		} else {
 			bf_set(prli_init, npr_nvme, 1);
+			bf_set(prli_conf, npr_nvme, 1);
 		}
+
 		npr_nvme->word1 = cpu_to_be32(npr_nvme->word1);
 		npr_nvme->word4 = cpu_to_be32(npr_nvme->word4);
 		elsiocb->iocb_flag |= LPFC_PRLI_NVME_REQ;
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index ef469129fb71..7c3afc3d3121 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4346,9 +4346,9 @@ struct lpfc_nvme_prli {
 #define prli_init_SHIFT                 5
 #define prli_init_MASK                  0x00000001
 #define prli_init_WORD                  word4
-#define prli_recov_SHIFT                8
-#define prli_recov_MASK                 0x00000001
-#define prli_recov_WORD                 word4
+#define prli_conf_SHIFT                 7
+#define prli_conf_MASK                  0x00000001
+#define prli_conf_WORD                  word4
 	uint32_t word5;
 #define prli_fb_sz_SHIFT                0
 #define prli_fb_sz_MASK                 0x0000ffff
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index d841aa42f607..bbf1e1342b09 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2011,9 +2011,6 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			}
 		}
 
-		if (bf_get_be32(prli_recov, nvpr))
-			ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
-
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
 				 "6029 NVME PRLI Cmpl w1 x%08x "
 				 "w4 x%08x w5 x%08x flag x%x, "
-- 
2.13.1
