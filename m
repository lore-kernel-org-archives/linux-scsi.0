From: James.Smart@Emulex.Com
Subject: [PATCH 3 of 12] Update Emulex lpfc driver to rev 8.0.29
Date: Sat, 25 Jun 2005 10:34:08 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F4148@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38590 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261240AbVFYOeM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 10:34:12 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5PEY99P008170
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2005 07:34:09 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fixes in mbox_timeout_handler

Analysis:

Timeout of READ_SPARM64 causes call to lpfc_mbox_timeout_handler which
reads psli->mbox_active to determine the timeout mbox.  Timeout
handler then NULL's psli->mbox_active and calls
lpfc_mbx_cmpl_read_sparam(), which on timeout condition, calls
link_down().  link_down() now calls disc_done() which calls
mbox_timeout_hander() again since WORKER_MBOX_TMO is still set, which
goes back to read psli->mbox_active which is already NULL'ed.

Remove redundant if statement in lpfc_mbox_timeout_handler.  pmbox is
assigned psli->mbox_active so there is no need to check if it actually
equals psli->mbox_active.

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_sli.c |   18 ++++++-------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_sli.c~mboxtmo drivers/scsi/lpfc/lpfc_sli.c
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_sli.c~mboxtmo	2005-06-25 09:41:57.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_sli.c	2005-06-25 09:41:57.000000000 -0400
@@ -1724,6 +1724,8 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 		return;
 	}
 
+	phba->work_hba_events &= ~WORKER_MBOX_TMO;
+
 	pmbox = phba->sli.mbox_active;
 	mb = &pmbox->mb;
 
@@ -1738,16 +1740,14 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 		phba->sli.sli_flag,
 		phba->sli.mbox_active);
 
-	if (phba->sli.mbox_active == pmbox) {
-		phba->sli.mbox_active = NULL;
-		if (pmbox->mbox_cmpl) {
-			mb->mbxStatus = MBX_NOT_FINISHED;
-			spin_unlock_irq(phba->host->host_lock);
-			(pmbox->mbox_cmpl) (phba, pmbox);
-			spin_lock_irq(phba->host->host_lock);
-		}
-		phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+	phba->sli.mbox_active = NULL;
+	if (pmbox->mbox_cmpl) {
+		mb->mbxStatus = MBX_NOT_FINISHED;
+		spin_unlock_irq(phba->host->host_lock);
+		(pmbox->mbox_cmpl) (phba, pmbox);
+		spin_lock_irq(phba->host->host_lock);
 	}
+	phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 
 	spin_unlock_irq(phba->host->host_lock);
 	lpfc_mbox_abort(phba);
_
