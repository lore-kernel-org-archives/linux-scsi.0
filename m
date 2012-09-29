From: James Smart <james.smart@emulex.com>
Subject: [PATCH 12/16] lpfc 8.3.35: Fixed not checking solicition in
 progress bit when verifying FCF record for use
Date: Sat, 29 Sep 2012 11:31:55 -0400
Message-ID: <1348932715.23909.31.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:35025 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab2I2Ph2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:37:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed not checking solicition in progress bit when verifying FCF record for use


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |   11 ++++++++---
 lpfc_hw4.h     |    8 +++++++-
 2 files changed, 15 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-09-26 21:11:46.312154134 -0400
@@ -1506,9 +1506,10 @@ lpfc_match_fcf_conn_list(struct lpfc_hba
 		}
 	}
 
-	/* If FCF not available return 0 */
+	/* FCF not valid/available or solicitation in progress */
 	if (!bf_get(lpfc_fcf_record_fcf_avail, new_fcf_record) ||
-		!bf_get(lpfc_fcf_record_fcf_valid, new_fcf_record))
+	    !bf_get(lpfc_fcf_record_fcf_valid, new_fcf_record) ||
+	    bf_get(lpfc_fcf_record_fcf_sol, new_fcf_record))
 		return 0;
 
 	if (!(phba->hba_flag & HBA_FIP_SUPPORT)) {
@@ -1842,6 +1843,7 @@ lpfc_sli4_log_fcf_record_info(struct lpf
 			"\tFCF_Index     : x%x\n"
 			"\tFCF_Avail     : x%x\n"
 			"\tFCF_Valid     : x%x\n"
+			"\tFCF_SOL       : x%x\n"
 			"\tFIP_Priority  : x%x\n"
 			"\tMAC_Provider  : x%x\n"
 			"\tLowest VLANID : x%x\n"
@@ -1852,6 +1854,7 @@ lpfc_sli4_log_fcf_record_info(struct lpf
 			bf_get(lpfc_fcf_record_fcf_index, fcf_record),
 			bf_get(lpfc_fcf_record_fcf_avail, fcf_record),
 			bf_get(lpfc_fcf_record_fcf_valid, fcf_record),
+			bf_get(lpfc_fcf_record_fcf_sol, fcf_record),
 			fcf_record->fip_priority,
 			bf_get(lpfc_fcf_record_mac_addr_prov, fcf_record),
 			vlan_id,
@@ -2185,12 +2188,14 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 					       new_fcf_record));
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FIP,
 				"2781 FCF (x%x) failed connection "
-				"list check: (x%x/x%x)\n",
+				"list check: (x%x/x%x/%x)\n",
 				bf_get(lpfc_fcf_record_fcf_index,
 				       new_fcf_record),
 				bf_get(lpfc_fcf_record_fcf_avail,
 				       new_fcf_record),
 				bf_get(lpfc_fcf_record_fcf_valid,
+				       new_fcf_record),
+				bf_get(lpfc_fcf_record_fcf_sol,
 				       new_fcf_record));
 		if ((phba->fcf.fcf_flag & FCF_IN_USE) &&
 		    lpfc_sli4_fcf_record_match(phba, &phba->fcf.current_rec,
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2012-09-26 21:11:46.323154134 -0400
@@ -1695,8 +1695,14 @@ struct fcf_record {
 #define lpfc_fcf_record_fc_map_2_MASK		0x000000FF
 #define lpfc_fcf_record_fc_map_2_WORD		word7
 #define lpfc_fcf_record_fcf_valid_SHIFT		24
-#define lpfc_fcf_record_fcf_valid_MASK		0x000000FF
+#define lpfc_fcf_record_fcf_valid_MASK		0x00000001
 #define lpfc_fcf_record_fcf_valid_WORD		word7
+#define lpfc_fcf_record_fcf_fc_SHIFT		25
+#define lpfc_fcf_record_fcf_fc_MASK		0x00000001
+#define lpfc_fcf_record_fcf_fc_WORD		word7
+#define lpfc_fcf_record_fcf_sol_SHIFT		31
+#define lpfc_fcf_record_fcf_sol_MASK		0x00000001
+#define lpfc_fcf_record_fcf_sol_WORD		word7
 	uint32_t word8;
 #define lpfc_fcf_record_fcf_index_SHIFT		0
 #define lpfc_fcf_record_fcf_index_MASK		0x0000FFFF



