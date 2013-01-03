From: James Smart <james.smart@emulex.com>
Subject: [PATCH 10/11] lpfc 8.3.37: Fixed infinite loop in
 lpfc_sli4_fcf_rr_next_index_get.
Date: Thu, 3 Jan 2013 15:44:16 -0500
Message-ID: <1357245856.2628.24.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:27048 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3ACUuC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2013 15:50:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed infinite loop in lpfc_sli4_fcf_rr_next_index_get.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-01-02 13:13:10.046087810 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-01-02 13:13:10.993087833 -0500
@@ -15556,10 +15556,13 @@ lpfc_sli4_fcf_rr_next_index_get(struct l
 {
 	uint16_t next_fcf_index;
 
+initial_priority:
 	/* Search start from next bit of currently registered FCF index */
+	next_fcf_index = phba->fcf.current_rec.fcf_indx;
+
 next_priority:
-	next_fcf_index = (phba->fcf.current_rec.fcf_indx + 1) %
-					LPFC_SLI4_FCF_TBL_INDX_MAX;
+	/* Determine the next fcf index to check */
+	next_fcf_index = (next_fcf_index + 1) % LPFC_SLI4_FCF_TBL_INDX_MAX;
 	next_fcf_index = find_next_bit(phba->fcf.fcf_rr_bmask,
 				       LPFC_SLI4_FCF_TBL_INDX_MAX,
 				       next_fcf_index);
@@ -15586,7 +15589,7 @@ next_priority:
 		 * at that level and continue the selection process.
 		 */
 		if (lpfc_check_next_fcf_pri_level(phba))
-			goto next_priority;
+			goto initial_priority;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
 				"2844 No roundrobin failover FCF available\n");
 		if (next_fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX)



