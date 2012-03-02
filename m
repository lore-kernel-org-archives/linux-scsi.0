From: James Smart <james.smart@emulex.com>
Subject: [PATCH 01/21] lpfc 8.3.30: Make BA_ACC work on a fully qualified
 exchange
Date: Thu, 1 Mar 2012 22:33:29 -0500
Message-ID: <1330659211.18500.28.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38841 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752690Ab2CBDdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:33:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Make BA_ACC work on a fully qualified exchange (CR: 126289)


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-02-27 23:35:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:30.000000000 -0500
@@ -14203,15 +14203,14 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_hba 
 		 * field and RX_ID from ABTS for RX_ID field.
 		 */
 		bf_set(lpfc_abts_orig, &icmd->un.bls_rsp, LPFC_ABTS_UNSOL_RSP);
-		bf_set(lpfc_abts_rxid, &icmd->un.bls_rsp, rxid);
 	} else {
 		/* ABTS sent by initiator to CT exchange, construction
 		 * of BA_ACC will need to allocate a new XRI as for the
-		 * XRI_TAG and RX_ID fields.
+		 * XRI_TAG field.
 		 */
 		bf_set(lpfc_abts_orig, &icmd->un.bls_rsp, LPFC_ABTS_UNSOL_INT);
-		bf_set(lpfc_abts_rxid, &icmd->un.bls_rsp, NO_XRI);
 	}
+	bf_set(lpfc_abts_rxid, &icmd->un.bls_rsp, rxid);
 	bf_set(lpfc_abts_oxid, &icmd->un.bls_rsp, oxid);
 
 	/* Xmit CT abts response on exchange <xid> */



