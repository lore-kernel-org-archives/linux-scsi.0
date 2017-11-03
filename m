From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 09/17] lpfc: Adjust default value of lpfc_nvmet_mrq
Date: Fri,  3 Nov 2017 15:56:20 -0700
Message-ID: <20171103225628.24716-10-jsmart2021@gmail.com>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:48799 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752284AbdKCW4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 18:56:46 -0400
Received: by mail-qk0-f193.google.com with SMTP id d67so5045623qkg.5
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 15:56:46 -0700 (PDT)
In-Reply-To: <20171103225628.24716-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The current default for async hw receive queues is 1, which presents
issues under heavy load as number of queues influence the available
async receive buffer limits.

Raise the default to the either the current hw limit (16) or the number
of hw qs configured (io channel value).

Revise the attribute definition for mrq to better reflect what we do
for hw queues. E.g. 0 means default to optimal (# of cpus), non-zero
specifies a specific limit. Before this change, mrq=0 meant target
mode was disabled. As 0 now has a different meaning, rework the
if tests to use the better nvmet_support check.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c    | 11 ++++++++--
 drivers/scsi/lpfc/lpfc_debugfs.c |  2 +-
 drivers/scsi/lpfc/lpfc_init.c    | 47 ++++++++++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_nvmet.h   |  4 ++++
 4 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 4dcd129ca901..598e07f43912 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3361,12 +3361,13 @@ LPFC_ATTR_R(suppress_rsp, 1, 0, 1,
 
 /*
  * lpfc_nvmet_mrq: Specify number of RQ pairs for processing NVMET cmds
+ * lpfc_nvmet_mrq = 0  driver will calcualte optimal number of RQ pairs
  * lpfc_nvmet_mrq = 1  use a single RQ pair
  * lpfc_nvmet_mrq >= 2  use specified RQ pairs for MRQ
  *
  */
 LPFC_ATTR_R(nvmet_mrq,
-	    1, 1, 16,
+	    LPFC_NVMET_MRQ_AUTO, LPFC_NVMET_MRQ_AUTO, LPFC_NVMET_MRQ_MAX,
 	    "Specify number of RQ pairs for processing NVMET cmds");
 
 /*
@@ -6357,6 +6358,9 @@ lpfc_nvme_mod_param_dep(struct lpfc_hba *phba)
 				phba->cfg_nvmet_fb_size = LPFC_NVMET_FB_SZ_MAX;
 		}
 
+		if (!phba->cfg_nvmet_mrq)
+			phba->cfg_nvmet_mrq = phba->cfg_nvme_io_channel;
+
 		/* Adjust lpfc_nvmet_mrq to avoid running out of WQE slots */
 		if (phba->cfg_nvmet_mrq > phba->cfg_nvme_io_channel) {
 			phba->cfg_nvmet_mrq = phba->cfg_nvme_io_channel;
@@ -6364,10 +6368,13 @@ lpfc_nvme_mod_param_dep(struct lpfc_hba *phba)
 					"6018 Adjust lpfc_nvmet_mrq to %d\n",
 					phba->cfg_nvmet_mrq);
 		}
+		if (phba->cfg_nvmet_mrq > LPFC_NVMET_MRQ_MAX)
+			phba->cfg_nvmet_mrq = LPFC_NVMET_MRQ_MAX;
+
 	} else {
 		/* Not NVME Target mode.  Turn off Target parameters. */
 		phba->nvmet_support = 0;
-		phba->cfg_nvmet_mrq = 0;
+		phba->cfg_nvmet_mrq = LPFC_NVMET_MRQ_OFF;
 		phba->cfg_nvmet_fb_size = 0;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index e8c5a0927dd7..e0df6bbfd1c8 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3215,7 +3215,7 @@ lpfc_idiag_cqs_for_eq(struct lpfc_hba *phba, char *pbuffer,
 			return 1;
 	}
 
-	if (eqidx < phba->cfg_nvmet_mrq) {
+	if ((eqidx < phba->cfg_nvmet_mrq) && phba->nvmet_support) {
 		/* NVMET CQset */
 		qp = phba->sli4_hba.nvmet_cqset[eqidx];
 		*len = __lpfc_idiag_print_cq(qp, "NVMET CQset", pbuffer, *len);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index fc9f91327724..7a06f23a3baf 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7939,8 +7939,12 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 		phba->cfg_fcp_io_channel = io_channel;
 	if (phba->cfg_nvme_io_channel > io_channel)
 		phba->cfg_nvme_io_channel = io_channel;
-	if (phba->cfg_nvme_io_channel < phba->cfg_nvmet_mrq)
-		phba->cfg_nvmet_mrq = phba->cfg_nvme_io_channel;
+	if (phba->nvmet_support) {
+		if (phba->cfg_nvme_io_channel < phba->cfg_nvmet_mrq)
+			phba->cfg_nvmet_mrq = phba->cfg_nvme_io_channel;
+	}
+	if (phba->cfg_nvmet_mrq > LPFC_NVMET_MRQ_MAX)
+		phba->cfg_nvmet_mrq = LPFC_NVMET_MRQ_MAX;
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2574 IO channels: irqs %d fcp %d nvme %d MRQ: %d\n",
@@ -8454,13 +8458,15 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 	/* Release NVME CQ mapping array */
 	lpfc_sli4_release_queue_map(&phba->sli4_hba.nvme_cq_map);
 
-	lpfc_sli4_release_queues(&phba->sli4_hba.nvmet_cqset,
-					phba->cfg_nvmet_mrq);
+	if (phba->nvmet_support) {
+		lpfc_sli4_release_queues(&phba->sli4_hba.nvmet_cqset,
+					 phba->cfg_nvmet_mrq);
 
-	lpfc_sli4_release_queues(&phba->sli4_hba.nvmet_mrq_hdr,
-					phba->cfg_nvmet_mrq);
-	lpfc_sli4_release_queues(&phba->sli4_hba.nvmet_mrq_data,
-					phba->cfg_nvmet_mrq);
+		lpfc_sli4_release_queues(&phba->sli4_hba.nvmet_mrq_hdr,
+					 phba->cfg_nvmet_mrq);
+		lpfc_sli4_release_queues(&phba->sli4_hba.nvmet_mrq_data,
+					 phba->cfg_nvmet_mrq);
+	}
 
 	/* Release mailbox command work queue */
 	__lpfc_sli4_release_queue(&phba->sli4_hba.mbx_wq);
@@ -9015,19 +9021,22 @@ lpfc_sli4_queue_unset(struct lpfc_hba *phba)
 		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++)
 			lpfc_cq_destroy(phba, phba->sli4_hba.nvme_cq[qidx]);
 
-	/* Unset NVMET MRQ queue */
-	if (phba->sli4_hba.nvmet_mrq_hdr) {
-		for (qidx = 0; qidx < phba->cfg_nvmet_mrq; qidx++)
-			lpfc_rq_destroy(phba,
+	if (phba->nvmet_support) {
+		/* Unset NVMET MRQ queue */
+		if (phba->sli4_hba.nvmet_mrq_hdr) {
+			for (qidx = 0; qidx < phba->cfg_nvmet_mrq; qidx++)
+				lpfc_rq_destroy(
+					phba,
 					phba->sli4_hba.nvmet_mrq_hdr[qidx],
 					phba->sli4_hba.nvmet_mrq_data[qidx]);
-	}
+		}
 
-	/* Unset NVMET CQ Set complete queue */
-	if (phba->sli4_hba.nvmet_cqset) {
-		for (qidx = 0; qidx < phba->cfg_nvmet_mrq; qidx++)
-			lpfc_cq_destroy(phba,
-					phba->sli4_hba.nvmet_cqset[qidx]);
+		/* Unset NVMET CQ Set complete queue */
+		if (phba->sli4_hba.nvmet_cqset) {
+			for (qidx = 0; qidx < phba->cfg_nvmet_mrq; qidx++)
+				lpfc_cq_destroy(
+					phba, phba->sli4_hba.nvmet_cqset[qidx]);
+		}
 	}
 
 	/* Unset FCP response complete queue */
@@ -10403,7 +10412,7 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	    !phba->nvme_support) {
 		phba->nvme_support = 0;
 		phba->nvmet_support = 0;
-		phba->cfg_nvmet_mrq = 0;
+		phba->cfg_nvmet_mrq = LPFC_NVMET_MRQ_OFF;
 		phba->cfg_nvme_io_channel = 0;
 		phba->io_channel_irqs = phba->cfg_fcp_io_channel;
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_NVME,
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index 25a65b0bb7f3..6723e7b81946 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -25,6 +25,10 @@
 #define LPFC_NVMET_RQE_DEF_COUNT	512
 #define LPFC_NVMET_SUCCESS_LEN	12
 
+#define LPFC_NVMET_MRQ_OFF		0xffff
+#define LPFC_NVMET_MRQ_AUTO		0
+#define LPFC_NVMET_MRQ_MAX		16
+
 /* Used for NVME Target */
 struct lpfc_nvmet_tgtport {
 	struct lpfc_hba *phba;
-- 
2.13.1
