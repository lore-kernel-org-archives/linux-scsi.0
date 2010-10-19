From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/4] drivers/scsi/lpfc/lpfc_bsg.c: convert nested spin_lock_irqsave to spin_lock
Date: Tue, 19 Oct 2010 11:43:55 +0200
Message-ID: <1287481436-26656-3-git-send-email-julia@diku.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If spin_lock_irqsave is called twice in a row with the same second
argument, the interrupt state at the point of the second call overwrites
the value saved by the first call.  Indeed, the second call does not need
to save the interrupt state, so it is changed to a simple spin_lock.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression lock1,lock2;
expression flags;
@@

*spin_lock_irqsave(lock1,flags)
... when != flags
*spin_lock_irqsave(lock2,flags)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/lpfc/lpfc_bsg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index f5d60b5..7260c3a 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3142,12 +3142,12 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 	job = menlo->set_job;
 	job->dd_data = NULL; /* so timeout handler does not reply */
 
-	spin_lock_irqsave(&phba->hbalock, flags);
+	spin_lock(&phba->hbalock);
 	cmdiocbq->iocb_flag |= LPFC_IO_WAKE;
 	if (cmdiocbq->context2 && rspiocbq)
 		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
 		       &rspiocbq->iocb, sizeof(IOCB_t));
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	spin_unlock(&phba->hbalock);
 
 	bmp = menlo->bmp;
 	rspiocbq = menlo->rspiocbq;
