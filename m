From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/11] lpfc 8.3.38: Fixed PT2PT bring up problem for FC SLI4.
Date: Fri, 1 Mar 2013 16:37:29 -0500
Message-ID: <1362173849.8283.24.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:47982 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3CAVi5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 16:38:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed PT2PT bring up problem for FC SLI4.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-02-27 08:17:23.290047483 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-02-27 08:17:27.368047576 -0500
@@ -691,10 +691,12 @@ lpfc_work_done(struct lpfc_hba *phba)
 			/* Set the lpfc data pending flag */
 			set_bit(LPFC_DATA_READY, &phba->data_flags);
 		} else {
-			pring->flag &= ~LPFC_DEFERRED_RING_EVENT;
-			lpfc_sli_handle_slow_ring_event(phba, pring,
-							(status &
-							 HA_RXMASK));
+			if (phba->link_state >= LPFC_LINK_UP) {
+				pring->flag &= ~LPFC_DEFERRED_RING_EVENT;
+				lpfc_sli_handle_slow_ring_event(phba, pring,
+								(status &
+								HA_RXMASK));
+			}
 		}
 		if ((phba->sli_rev == LPFC_SLI_REV4) &
 				 (!list_empty(&pring->txq)))



