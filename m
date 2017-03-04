From: jsmart2021@gmail.com
Subject: [PATCH 18/20] lpfc: code cleanups in NVME initiator base
Date: Sat,  4 Mar 2017 09:30:38 -0800
Message-ID: <1488648640-5170-19-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33296 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbdCDRbM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:31:12 -0500
Received: by mail-qk0-f194.google.com with SMTP id j127so16587280qke.0
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:31:11 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

This patch addresses the smatch issues identified by Dan Carpenter
in http://www.spinics.net/lists/linux-scsi/msg105663.html

The issues are:

drivers/scsi/lpfc/lpfc_hbadisc.c:316 lpfc_dev_loss_tmo_handler()
warn: we tested 'vport->load_flag & 2' before and it was 'false'

Action: removed item from test

drivers/scsi/lpfc/lpfc_hbadisc.c:701 lpfc_work_done()
warn: test_bit() takes a bit number

Action: changed definition so bit number

drivers/scsi/lpfc/lpfc_hbadisc.c:2206 lpfc_mbx_cmpl_fcf_scan_read_fcf_rec()
error: uninitialized symbol 'vlan_id'.
drivers/scsi/lpfc/lpfc_hbadisc.c:2582 lpfc_mbx_cmpl_fcf_rr_read_fcf_rec()
error: uninitialized symbol 'vlan_id'.
drivers/scsi/lpfc/lpfc_hbadisc.c:2683 lpfc_mbx_cmpl_read_fcf_rec() error:
uninitialized symbol 'vlan_id'.

Action: initilized value

drivers/scsi/lpfc/lpfc_hbadisc.c:4025 lpfc_register_remote_port()
error: we previously assumed 'rdata' could be null (see line 4023)

Action: refactored check block

drivers/scsi/lpfc/lpfc_hbadisc.c:4613 lpfc_sli4_dequeue_nport_iocbs()
error: double unlock 'irq:'

Action: removed inner irq reference

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |  2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 17 +++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 763f32d..257bbdd 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -105,7 +105,7 @@ struct lpfc_sli2_slim;
 #define LPFC_MSIX_VECTORS	2
 
 /* lpfc wait event data ready flag */
-#define LPFC_DATA_READY		(1<<0)
+#define LPFC_DATA_READY		0	/* bit 0 */
 
 /* queue dump line buffer size */
 #define LPFC_LBUF_SZ		128
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b940092..b0c4060 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -313,8 +313,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 				 ndlp->nlp_state, ndlp->nlp_rpi);
 	}
 
-	if (!(vport->load_flag & FC_UNLOADING) &&
-	    !(ndlp->nlp_flag & NLP_DELAY_TMO) &&
+	if (!(ndlp->nlp_flag & NLP_DELAY_TMO) &&
 	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
 	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) &&
@@ -2175,7 +2174,7 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	uint32_t boot_flag, addr_mode;
 	uint16_t fcf_index, next_fcf_index;
 	struct lpfc_fcf_rec *fcf_rec = NULL;
-	uint16_t vlan_id;
+	uint16_t vlan_id = LPFC_FCOE_NULL_VID;
 	bool select_new_fcf;
 	int rc;
 
@@ -4022,9 +4021,11 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		rdata = rport->dd_data;
 		/* break the link before dropping the ref */
 		ndlp->rport = NULL;
-		if (rdata && rdata->pnode == ndlp)
-			lpfc_nlp_put(ndlp);
-		rdata->pnode = NULL;
+		if (rdata) {
+			if (rdata->pnode == ndlp)
+				lpfc_nlp_put(ndlp);
+			rdata->pnode = NULL;
+		}
 		/* drop reference for earlier registeration */
 		put_device(&rport->dev);
 	}
@@ -4608,9 +4609,9 @@ lpfc_sli4_dequeue_nport_iocbs(struct lpfc_hba *phba,
 		pring = qp->pring;
 		if (!pring)
 			continue;
-		spin_lock_irq(&pring->ring_lock);
+		spin_lock(&pring->ring_lock);
 		__lpfc_dequeue_nport_iocbs(phba, ndlp, pring, dequeue_list);
-		spin_unlock_irq(&pring->ring_lock);
+		spin_unlock(&pring->ring_lock);
 	}
 	spin_unlock_irq(&phba->hbalock);
 }
-- 
2.5.0
