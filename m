From: Dan Carpenter <error27@gmail.com>
Subject: [patch] lpfc: change spin_lock_irq() to spin_lock()
Date: Sun, 8 Aug 2010 00:15:17 +0200
Message-ID: <20100807221517.GC9031@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Alex Iannicelli <alex.iannicelli@emulex.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In lpfc_cleanup_pending_mbox() we already have IRQs disabled so we don't
need to disable them again.

Also in lpfc_sli_intr_handler() there is a typo where it has
spin_unlock_irq() instead of just spin_unlock().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e758eae..f772a7e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8460,7 +8460,7 @@ lpfc_sli_intr_handler(int irq, void *dev_id)
 	 * If there is deferred error attention, do not check for any interrupt.
 	 */
 	if (unlikely(phba->hba_flag & DEFER_ERATT)) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock(&phba->hbalock);
 		return IRQ_NONE;
 	}
 
@@ -12813,9 +12813,9 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 			}
 			ndlp = (struct lpfc_nodelist *) mb->context2;
 			if (ndlp) {
-				spin_lock_irq(shost->host_lock);
+				spin_lock(shost->host_lock);
 				ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
-				spin_unlock_irq(shost->host_lock);
+				spin_unlock(shost->host_lock);
 				lpfc_nlp_put(ndlp);
 				mb->context2 = NULL;
 			}
@@ -12831,9 +12831,9 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
 			ndlp = (struct lpfc_nodelist *) mb->context2;
 			if (ndlp) {
-				spin_lock_irq(shost->host_lock);
+				spin_lock(shost->host_lock);
 				ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
-				spin_unlock_irq(shost->host_lock);
+				spin_unlock(shost->host_lock);
 				lpfc_nlp_put(ndlp);
 				mb->context2 = NULL;
 			}
