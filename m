From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/8] lpfc 8.3.45: Fixed driver error messages after firmware
 download
Date: Thu, 20 Feb 2014 09:57:43 -0500
Message-ID: <1392908263.31081.18.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:16714 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbaBTO5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 09:57:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed driver error messages after firmware download


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2014-02-19 15:29:33.869023845 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2014-02-19 15:29:37.302023923 -0500
@@ -1469,7 +1469,8 @@ lpfc_handle_eratt_s3(struct lpfc_hba *ph
  * for handling possible port resource change.
  **/
 static int
-lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action)
+lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
+			    bool en_rn_msg)
 {
 	int rc;
 	uint32_t intr_mode;
@@ -1481,9 +1482,10 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_
 	rc = lpfc_sli4_pdev_status_reg_wait(phba);
 	if (!rc) {
 		/* need reset: attempt for port recovery */
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2887 Reset Needed: Attempting Port "
-				"Recovery...\n");
+		if (en_rn_msg)
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2887 Reset Needed: Attempting Port "
+					"Recovery...\n");
 		lpfc_offline_prep(phba, mbx_action);
 		lpfc_offline(phba);
 		/* release interrupt for possible resource change */
@@ -1523,6 +1525,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *ph
 	uint32_t reg_err1, reg_err2;
 	uint32_t uerrlo_reg, uemasklo_reg;
 	uint32_t pci_rd_rc1, pci_rd_rc2;
+	bool en_rn_msg = true;
 	int rc;
 
 	/* If the pci channel is offline, ignore possible errors, since
@@ -1573,10 +1576,12 @@ lpfc_handle_eratt_s4(struct lpfc_hba *ph
 			break;
 		}
 		if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
-		    reg_err2 == SLIPORT_ERR2_REG_FW_RESTART)
+		    reg_err2 == SLIPORT_ERR2_REG_FW_RESTART) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"3143 Port Down: Firmware Restarted\n");
-		else if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
+					"3143 Port Down: Firmware Update "
+					"Detected\n");
+			en_rn_msg = false;
+		} else if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
 			 reg_err2 == SLIPORT_ERR2_REG_FORCED_DUMP)
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"3144 Port Down: Debug Dump\n");
@@ -1586,7 +1591,8 @@ lpfc_handle_eratt_s4(struct lpfc_hba *ph
 					"3145 Port Down: Provisioning\n");
 
 		/* Check port status register for function reset */
-		rc = lpfc_sli4_port_sta_fn_reset(phba, LPFC_MBX_NO_WAIT);
+		rc = lpfc_sli4_port_sta_fn_reset(phba, LPFC_MBX_NO_WAIT,
+				en_rn_msg);
 		if (rc == 0) {
 			/* don't report event on forced debug dump */
 			if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&



