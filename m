From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 2/4] drivers/scsi/lpfc/lpfc_sli.c: convert GFP_KERNEL to GFP_ATOMIC
Date: Mon,  9 Jan 2012 10:40:48 +0100
Message-ID: <1326102050-30265-2-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia.lawall@lip6.fr>

The function is called with locks held and thus should not use GFP_KERNEL.

The semantic patch that makes this report is available
in scripts/coccinelle/locks/call_kern.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>

---
 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 23a2759..622d24f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -601,7 +601,7 @@ __lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	if (test_and_set_bit(xritag, ndlp->active_rrqs.xri_bitmap))
 		goto out;
 
-	rrq = mempool_alloc(phba->rrq_pool, GFP_KERNEL);
+	rrq = mempool_alloc(phba->rrq_pool, GFP_ATOMIC);
 	if (rrq) {
 		rrq->send_rrq = send_rrq;
 		rrq->xritag = xritag;
