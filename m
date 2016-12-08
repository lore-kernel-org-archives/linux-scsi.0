From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.9-rc8
Date: Thu, 08 Dec 2016 11:02:07 -0800
Message-ID: <1481223727.2361.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

One small fix for a regression in a prior fix (again).  This time the
condition in the prior fix BUG_ON proved to be wrong under certain
circumstances causing a BUG to trigger where it shouldn't in the lpfc
driver.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Mauricio Faria de Oliveira (1):
      scsi: lpfc: fix oops/BUG in lpfc_sli_ringtxcmpl_put()

And the diffstat:

 drivers/scsi/lpfc/lpfc_sli.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c532605..f4f77c5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1323,18 +1323,20 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 {
 	lockdep_assert_held(&phba->hbalock);
 
-	BUG_ON(!piocb || !piocb->vport);
+	BUG_ON(!piocb);
 
 	list_add_tail(&piocb->list, &pring->txcmplq);
 	piocb->iocb_flag |= LPFC_IO_ON_TXCMPLQ;
 
 	if ((unlikely(pring->ringno == LPFC_ELS_RING)) &&
 	   (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
-	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN) &&
-	    (!(piocb->vport->load_flag & FC_UNLOADING)))
-		mod_timer(&piocb->vport->els_tmofunc,
-			  jiffies +
-			  msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
+	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN)) {
+		BUG_ON(!piocb->vport);
+		if (!(piocb->vport->load_flag & FC_UNLOADING))
+			mod_timer(&piocb->vport->els_tmofunc,
+				  jiffies +
+				  msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
+	}
 
 	return 0;
 }
