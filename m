From: James Smart <james.smart@emulex.com>
Subject: [PATCH 15/17] lpfc 8.3.40: Fixed a race condition between SLI host
 and port failed FCF rediscovery
Date: Fri, 31 May 2013 17:05:36 -0400
Message-ID: <1370034336.17258.37.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5812 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3EaVMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:12:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed a race condition between SLI host and port failed FCF rediscovery


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   97 +++++++++++++++++++++---------------------------------------
 1 file changed, 35 insertions(+), 62 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-05-31 10:58:00.278057229 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-05-31 10:58:28.518057871 -0400
@@ -4050,52 +4050,6 @@ lpfc_sli4_perform_all_vport_cvl(struct l
 }
 
 /**
- * lpfc_sli4_perform_inuse_fcf_recovery - Perform inuse fcf recovery
- * @vport: pointer to lpfc hba data structure.
- *
- * This routine is to perform FCF recovery when the in-use FCF either dead or
- * got modified.
- **/
-static void
-lpfc_sli4_perform_inuse_fcf_recovery(struct lpfc_hba *phba,
-				     struct lpfc_acqe_fip *acqe_fip)
-{
-	int rc;
-
-	spin_lock_irq(&phba->hbalock);
-	/* Mark the fast failover process in progress */
-	phba->fcf.fcf_flag |= FCF_DEAD_DISC;
-	spin_unlock_irq(&phba->hbalock);
-
-	lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
-			"2771 Start FCF fast failover process due to in-use "
-			"FCF DEAD/MODIFIED event: evt_tag:x%x, index:x%x\n",
-			acqe_fip->event_tag, acqe_fip->index);
-	rc = lpfc_sli4_redisc_fcf_table(phba);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
-				"2772 Issue FCF rediscover mabilbox command "
-				"failed, fail through to FCF dead event\n");
-		spin_lock_irq(&phba->hbalock);
-		phba->fcf.fcf_flag &= ~FCF_DEAD_DISC;
-		spin_unlock_irq(&phba->hbalock);
-		/*
-		 * Last resort will fail over by treating this as a link
-		 * down to FCF registration.
-		 */
-		lpfc_sli4_fcf_dead_failthrough(phba);
-	} else {
-		/* Reset FCF roundrobin bmask for new discovery */
-		lpfc_sli4_clear_fcf_rr_bmask(phba);
-		/*
-		 * Handling fast FCF failover to a DEAD FCF event is
-		 * considered equalivant to receiving CVL to all vports.
-		 */
-		lpfc_sli4_perform_all_vport_cvl(phba);
-	}
-}
-
-/**
  * lpfc_sli4_async_fip_evt - Process the asynchronous FCoE FIP event
  * @phba: pointer to lpfc hba data structure.
  * @acqe_link: pointer to the async fcoe completion queue entry.
@@ -4160,22 +4114,9 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba
 			break;
 		}
 
-		/* If FCF has been in discovered state, perform rediscovery
-		 * only if the FCF with the same index of the in-use FCF got
-		 * modified during normal operation. Otherwise, do nothing.
-		 */
-		if (phba->pport->port_state > LPFC_FLOGI) {
+		/* If the FCF has been in discovered state, do nothing. */
+		if (phba->fcf.fcf_flag & FCF_SCAN_DONE) {
 			spin_unlock_irq(&phba->hbalock);
-			if (phba->fcf.current_rec.fcf_indx ==
-			    acqe_fip->index) {
-				lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
-						"3300 In-use FCF (%d) "
-						"modified, perform FCF "
-						"rediscovery\n",
-						acqe_fip->index);
-				lpfc_sli4_perform_inuse_fcf_recovery(phba,
-								     acqe_fip);
-			}
 			break;
 		}
 		spin_unlock_irq(&phba->hbalock);
@@ -4228,7 +4169,39 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba
 		 * is no longer valid as we are not in the middle of FCF
 		 * failover process already.
 		 */
-		lpfc_sli4_perform_inuse_fcf_recovery(phba, acqe_fip);
+		spin_lock_irq(&phba->hbalock);
+		/* Mark the fast failover process in progress */
+		phba->fcf.fcf_flag |= FCF_DEAD_DISC;
+		spin_unlock_irq(&phba->hbalock);
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
+				"2771 Start FCF fast failover process due to "
+				"FCF DEAD event: evt_tag:x%x, fcf_index:x%x "
+				"\n", acqe_fip->event_tag, acqe_fip->index);
+		rc = lpfc_sli4_redisc_fcf_table(phba);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
+					LOG_DISCOVERY,
+					"2772 Issue FCF rediscover mabilbox "
+					"command failed, fail through to FCF "
+					"dead event\n");
+			spin_lock_irq(&phba->hbalock);
+			phba->fcf.fcf_flag &= ~FCF_DEAD_DISC;
+			spin_unlock_irq(&phba->hbalock);
+			/*
+			 * Last resort will fail over by treating this
+			 * as a link down to FCF registration.
+			 */
+			lpfc_sli4_fcf_dead_failthrough(phba);
+		} else {
+			/* Reset FCF roundrobin bmask for new discovery */
+			lpfc_sli4_clear_fcf_rr_bmask(phba);
+			/*
+			 * Handling fast FCF failover to a DEAD FCF event is
+			 * considered equalivant to receiving CVL to all vports.
+			 */
+			lpfc_sli4_perform_all_vport_cvl(phba);
+		}
 		break;
 	case LPFC_FIP_EVENT_TYPE_CVL:
 		phba->fcoe_cvl_eventtag = acqe_fip->event_tag;



