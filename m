From: James Smart <james.smart@emulex.com>
Subject: [PATCH 06/21] lpfc 8.3.30: Fix deadlock during adapter offline
 request
Date: Thu, 1 Mar 2012 22:35:34 -0500
Message-ID: <1330659336.18500.33.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38853 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757374Ab2CBDfs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:35:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix deadlock during adapter offline request.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:39.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:39.000000000 -0500
@@ -2704,16 +2704,14 @@ lpfc_offline_prep(struct lpfc_hba * phba
 				}
 				spin_lock_irq(shost->host_lock);
 				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-
+				spin_unlock_irq(shost->host_lock);
 				/*
 				 * Whenever an SLI4 port goes offline, free the
-				 * RPI.  A new RPI when the adapter port comes
-				 * back online.
+				 * RPI. Get a new RPI when the adapter port
+				 * comes back online.
 				 */
 				if (phba->sli_rev == LPFC_SLI_REV4)
 					lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
-
-				spin_unlock_irq(shost->host_lock);
 				lpfc_unreg_rpi(vports[i], ndlp);
 			}
 		}



