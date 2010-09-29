From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/6] lpfc 8.3.17: SLI Additions and Fixes
Date: Wed, 29 Sep 2010 11:18:53 -0400
Message-ID: <1285773533.25110.10.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16092 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386Ab0I2PS4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2010 11:18:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Added driver support for management application to pass down two security
  specific mailbox commands (MBX_SECURITY_MGMT and MBX_AUTH_PORT)
- Added driver support for handling FIPS zeroization trap of host ERATT ER8,
  performing selective reset and bringing the device up.
- Added code to detect INIT_LINK mailbox command completion returning status
  MBXERR_SEC_NO_PERMISSION.
- Increased the wait timeout on host status register HS_FFRDY and HS_MBRDY
  being set.
- Remove the port offline code from the Heartbeat TMO handler.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |   10 ++++++++++
 lpfc_hw.h   |    6 +++++-
 lpfc_init.c |   45 ++++++++++++++++++++++++---------------------
 lpfc_sli.c  |   55 +++++++++++++++++++++++++++++++++++++++----------------
 4 files changed, 78 insertions(+), 38 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-09-08 12:08:03.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-09-29 10:19:33.000000000 -0400
@@ -586,6 +586,11 @@ lpfc_issue_lip(struct Scsi_Host *shost)
 			       phba->cfg_link_speed);
 		mbxstatus = lpfc_sli_issue_mbox_wait(phba, pmboxq,
 						     phba->fc_ratov * 2);
+		if ((mbxstatus == MBX_SUCCESS) &&
+		    (pmboxq->u.mb.mbxStatus == MBXERR_SEC_NO_PERMISSION))
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"2859 SLI authentication is required "
+					"for INIT_LINK but has not done yet\n");
 	}
 
 	lpfc_set_loopback_flag(phba);
@@ -3776,6 +3781,11 @@ sysfs_mbox_read(struct file *filp, struc
 		case MBX_PORT_CAPABILITIES:
 		case MBX_PORT_IOV_CONTROL:
 			break;
+		case MBX_SECURITY_MGMT:
+		case MBX_AUTH_PORT:
+			if (phba->pci_dev_grp == LPFC_PCI_DEV_OC)
+				return -EPERM;
+			break;
 		case MBX_READ_SPARM64:
 		case MBX_READ_LA:
 		case MBX_READ_LA64:
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-08-09 09:30:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-09-29 10:19:33.000000000 -0400
@@ -1380,6 +1380,9 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_INIT_VFI        0xA3
 #define MBX_INIT_VPI        0xA4
 
+#define MBX_AUTH_PORT       0xF8
+#define MBX_SECURITY_MGMT   0xF9
+
 /* IOCB Commands */
 
 #define CMD_RCV_SEQUENCE_CX     0x01
@@ -1502,7 +1505,8 @@ typedef struct {		/* FireFly BIU registe
 #define MBXERR_DMA_ERROR            15
 #define MBXERR_ERROR                16
 #define MBXERR_LINK_DOWN            0x33
-#define MBX_NOT_FINISHED           255
+#define MBXERR_SEC_NO_PERMISSION    0xF02
+#define MBX_NOT_FINISHED            255
 
 #define MBX_BUSY                   0xffffff /* Attempted cmd to busy Mailbox */
 #define MBX_TIMEOUT                0xfffffe /* time-out expired waiting for */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-09-29 10:07:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-09-29 10:19:33.000000000 -0400
@@ -1076,21 +1076,16 @@ lpfc_hb_timeout_handler(struct lpfc_hba 
 		} else {
 			/*
 			* If heart beat timeout called with hb_outstanding set
-			* we need to take the HBA offline.
+			* we need to give the hb mailbox cmd a chance to
+			* complete or TMO.
 			*/
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0459 Adapter heartbeat failure, "
-					"taking this port offline.\n");
-
-			spin_lock_irq(&phba->hbalock);
-			psli->sli_flag &= ~LPFC_SLI_ACTIVE;
-			spin_unlock_irq(&phba->hbalock);
-
-			lpfc_offline_prep(phba);
-			lpfc_offline(phba);
-			lpfc_unblock_mgmt_io(phba);
-			phba->link_state = LPFC_HBA_ERROR;
-			lpfc_hba_down_post(phba);
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+					"0459 Adapter heartbeat still out"
+					"standing:last compl time was %d ms.\n",
+					jiffies_to_msecs(jiffies
+						 - phba->last_completion_time));
+			mod_timer(&phba->hb_tmofunc,
+				  jiffies + HZ * LPFC_HB_MBOX_TIMEOUT);
 		}
 	}
 }
@@ -1277,13 +1272,21 @@ lpfc_handle_eratt_s3(struct lpfc_hba *ph
 	if (phba->hba_flag & DEFER_ERATT)
 		lpfc_handle_deferred_eratt(phba);
 
-	if (phba->work_hs & HS_FFER6) {
-		/* Re-establishing Link */
-		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
-				"1301 Re-establishing Link "
-				"Data: x%x x%x x%x\n",
-				phba->work_hs,
-				phba->work_status[0], phba->work_status[1]);
+	if ((phba->work_hs & HS_FFER6) || (phba->work_hs & HS_FFER8)) {
+		if (phba->work_hs & HS_FFER6)
+			/* Re-establishing Link */
+			lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
+					"1301 Re-establishing Link "
+					"Data: x%x x%x x%x\n",
+					phba->work_hs, phba->work_status[0],
+					phba->work_status[1]);
+		if (phba->work_hs & HS_FFER8)
+			/* Device Zeroization */
+			lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
+					"2861 Host Authentication device "
+					"zeroization Data:x%x x%x x%x\n",
+					phba->work_hs, phba->work_status[0],
+					phba->work_status[1]);
 
 		spin_lock_irq(&phba->hbalock);
 		psli->sli_flag &= ~LPFC_SLI_ACTIVE;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-09-29 10:07:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-09-29 10:19:33.000000000 -0400
@@ -1677,6 +1677,8 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_RESUME_RPI:
 	case MBX_READ_EVENT_LOG_STATUS:
 	case MBX_READ_EVENT_LOG:
+	case MBX_SECURITY_MGMT:
+	case MBX_AUTH_PORT:
 		ret = mbxCommand;
 		break;
 	default:
@@ -1781,6 +1783,13 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 		pmb->context2 = NULL;
 	}
 
+	/* Check security permission status on INIT_LINK mailbox command */
+	if ((pmb->u.mb.mbxCommand == MBX_INIT_LINK) &&
+	    (pmb->u.mb.mbxStatus == MBXERR_SEC_NO_PERMISSION))
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"2860 SLI authentication is required "
+				"for INIT_LINK but has not done yet\n");
+
 	if (bf_get(lpfc_mqe_command, &pmb->u.mqe) == MBX_SLI4_CONFIG)
 		lpfc_sli4_mbox_cmd_free(phba, pmb);
 	else
@@ -3658,11 +3667,15 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
 	i = 0;
 	while ((status & (HS_FFRDY | HS_MBRDY)) != (HS_FFRDY | HS_MBRDY)) {
 
-		/* Check every 100ms for 5 retries, then every 500ms for 5, then
-		 * every 2.5 sec for 5, then reset board and every 2.5 sec for
-		 * 4.
+		/* Check every 10ms for 10 retries, then every 100ms for 90
+		 * retries, then every 1 sec for 50 retires for a total of
+		 * ~60 seconds before reset the board again and check every
+		 * 1 sec for 50 retries. The up to 60 seconds before the
+		 * board ready is required by the Falcon FIPS zeroization
+		 * complete, and any reset the board in between shall cause
+		 * restart of zeroization, further delay the board ready.
 		 */
-		if (i++ >= 20) {
+		if (i++ >= 200) {
 			/* Adapter failed to init, timeout, status reg
 			   <status> */
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -3690,16 +3703,15 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
 			return -EIO;
 		}
 
-		if (i <= 5) {
+		if (i <= 10)
 			msleep(10);
-		} else if (i <= 10) {
-			msleep(500);
-		} else {
-			msleep(2500);
-		}
+		else if (i <= 100)
+			msleep(100);
+		else
+			msleep(1000);
 
-		if (i == 15) {
-				/* Do post */
+		if (i == 150) {
+			/* Do post */
 			phba->pport->port_state = LPFC_VPORT_UNKNOWN;
 			lpfc_sli_brdrestart(phba);
 		}
@@ -5950,6 +5962,8 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	uint8_t command_type = ELS_COMMAND_NON_FIP;
 	uint8_t cmnd;
 	uint16_t xritag;
+	uint16_t abrt_iotag;
+	struct lpfc_iocbq *abrtiocbq;
 	struct ulp_bde64 *bpl = NULL;
 	uint32_t els_id = ELS_ID_DEFAULT;
 	int numBdes, i;
@@ -6162,9 +6176,17 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	case CMD_ABORT_XRI_CX:
 		/* words 0-2 memcpy should be 0 rserved */
 		/* port will send abts */
-		if (iocbq->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
+		abrt_iotag = iocbq->iocb.un.acxri.abortContextTag;
+		if (abrt_iotag != 0 && abrt_iotag <= phba->sli.last_iotag) {
+			abrtiocbq = phba->sli.iocbq_lookup[abrt_iotag];
+			fip = abrtiocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK;
+		} else
+			fip = 0;
+
+		if ((iocbq->iocb.ulpCommand == CMD_CLOSE_XRI_CN) || fip)
 			/*
-			 * The link is down so the fw does not need to send abts
+			 * The link is down, or the command was ELS_FIP
+			 * so the fw does not need to send abts
 			 * on the wire.
 			 */
 			bf_set(abort_cmd_ia, &wqe->abort_cmd, 1);
@@ -7895,7 +7917,7 @@ lpfc_sli_eratt_read(struct lpfc_hba *phb
 		/* Check if there is a deferred error condition is active */
 		if ((HS_FFER1 & phba->work_hs) &&
 		    ((HS_FFER2 | HS_FFER3 | HS_FFER4 | HS_FFER5 |
-		     HS_FFER6 | HS_FFER7) & phba->work_hs)) {
+		      HS_FFER6 | HS_FFER7 | HS_FFER8) & phba->work_hs)) {
 			phba->hba_flag |= DEFER_ERATT;
 			/* Clear all interrupt enable conditions */
 			writel(0, phba->HCregaddr);
@@ -8211,7 +8233,8 @@ lpfc_sli_sp_intr_handler(int irq, void *
 			 */
 			if ((HS_FFER1 & phba->work_hs) &&
 				((HS_FFER2 | HS_FFER3 | HS_FFER4 | HS_FFER5 |
-				HS_FFER6 | HS_FFER7) & phba->work_hs)) {
+				  HS_FFER6 | HS_FFER7 | HS_FFER8) &
+				  phba->work_hs)) {
 				phba->hba_flag |= DEFER_ERATT;
 				/* Clear all interrupt enable conditions */
 				writel(0, phba->HCregaddr);


