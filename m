From: James Smart <james.smart@emulex.com>
Subject: [PATCH 12/19] lpfc 10.4.8000.0: Fix IP Reset processing - wait for
 RDY before proceeding
Date: Wed, 3 Sep 2014 12:57:08 -0400
Message-ID: <1409763428.12357.12.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:43864 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbaICQ5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:57:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix IP Reset processing - wait for RDY before proceeding

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 109 ++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7f54916..33a24fc0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7903,7 +7903,8 @@ lpfc_pci_function_reset(struct lpfc_hba *phba)
 	LPFC_MBOXQ_t *mboxq;
 	uint32_t rc = 0, if_type;
 	uint32_t shdr_status, shdr_add_status;
-	uint32_t rdy_chk, num_resets = 0, reset_again = 0;
+	uint32_t rdy_chk;
+	uint32_t port_reset = 0;
 	union lpfc_sli4_cfg_shdr *shdr;
 	struct lpfc_register reg_data;
 	uint16_t devid;
@@ -7943,9 +7944,42 @@ lpfc_pci_function_reset(struct lpfc_hba *phba)
 		}
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_2:
-		for (num_resets = 0;
-		     num_resets < MAX_IF_TYPE_2_RESETS;
-		     num_resets++) {
+wait:
+		/*
+		 * Poll the Port Status Register and wait for RDY for
+		 * up to 30 seconds. If the port doesn't respond, treat
+		 * it as an error.
+		 */
+		for (rdy_chk = 0; rdy_chk < 3000; rdy_chk++) {
+			if (lpfc_readl(phba->sli4_hba.u.if_type2.
+				STATUSregaddr, &reg_data.word0)) {
+				rc = -ENODEV;
+				goto out;
+			}
+			if (bf_get(lpfc_sliport_status_rdy, &reg_data))
+				break;
+			msleep(20);
+		}
+
+		if (!bf_get(lpfc_sliport_status_rdy, &reg_data)) {
+			phba->work_status[0] = readl(
+				phba->sli4_hba.u.if_type2.ERR1regaddr);
+			phba->work_status[1] = readl(
+				phba->sli4_hba.u.if_type2.ERR2regaddr);
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2890 Port not ready, port status reg "
+					"0x%x error 1=0x%x, error 2=0x%x\n",
+					reg_data.word0,
+					phba->work_status[0],
+					phba->work_status[1]);
+			rc = -ENODEV;
+			goto out;
+		}
+
+		if (!port_reset) {
+			/*
+			 * Reset the port now
+			 */
 			reg_data.word0 = 0;
 			bf_set(lpfc_sliport_ctrl_end, &reg_data,
 			       LPFC_SLIPORT_LITTLE_ENDIAN);
@@ -7956,64 +7990,16 @@ lpfc_pci_function_reset(struct lpfc_hba *phba)
 			/* flush */
 			pci_read_config_word(phba->pcidev,
 					     PCI_DEVICE_ID, &devid);
-			/*
-			 * Poll the Port Status Register and wait for RDY for
-			 * up to 10 seconds.  If the port doesn't respond, treat
-			 * it as an error.  If the port responds with RN, start
-			 * the loop again.
-			 */
-			for (rdy_chk = 0; rdy_chk < 1000; rdy_chk++) {
-				msleep(10);
-				if (lpfc_readl(phba->sli4_hba.u.if_type2.
-					      STATUSregaddr, &reg_data.word0)) {
-					rc = -ENODEV;
-					goto out;
-				}
-				if (bf_get(lpfc_sliport_status_rn, &reg_data))
-					reset_again++;
-				if (bf_get(lpfc_sliport_status_rdy, &reg_data))
-					break;
-			}
-
-			/*
-			 * If the port responds to the init request with
-			 * reset needed, delay for a bit and restart the loop.
-			 */
-			if (reset_again && (rdy_chk < 1000)) {
-				msleep(10);
-				reset_again = 0;
-				continue;
-			}
 
-			/* Detect any port errors. */
-			if ((bf_get(lpfc_sliport_status_err, &reg_data)) ||
-			    (rdy_chk >= 1000)) {
-				phba->work_status[0] = readl(
-					phba->sli4_hba.u.if_type2.ERR1regaddr);
-				phba->work_status[1] = readl(
-					phba->sli4_hba.u.if_type2.ERR2regaddr);
-				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"2890 Port error detected during port "
-					"reset(%d): wait_tmo:%d ms, "
-					"port status reg 0x%x, "
-					"error 1=0x%x, error 2=0x%x\n",
-					num_resets, rdy_chk*10,
-					reg_data.word0,
-					phba->work_status[0],
-					phba->work_status[1]);
-				rc = -ENODEV;
-			}
-
-			/*
-			 * Terminate the outer loop provided the Port indicated
-			 * ready within 10 seconds.
-			 */
-			if (rdy_chk < 1000)
-				break;
+			port_reset = 1;
+			msleep(20);
+			goto wait;
+		} else if (bf_get(lpfc_sliport_status_rn, &reg_data)) {
+			rc = -ENODEV;
+			goto out;
 		}
-		/* delay driver action following IF_TYPE_2 function reset */
-		msleep(100);
 		break;
+
 	case LPFC_SLI_INTF_IF_TYPE_1:
 	default:
 		break;
@@ -8021,11 +8007,10 @@ lpfc_pci_function_reset(struct lpfc_hba *phba)
 
 out:
 	/* Catch the not-ready port failure after a port reset. */
-	if (num_resets >= MAX_IF_TYPE_2_RESETS) {
+	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3317 HBA not functional: IP Reset Failed "
-				"after (%d) retries, try: "
-				"echo fw_reset > board_mode\n", num_resets);
+				"try: echo fw_reset > board_mode\n");
 		rc = -ENODEV;
 	}
 
-- 
1.7.11.7




