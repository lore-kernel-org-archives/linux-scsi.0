From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/11] lpfc 8.3.38: Fixed async FCF modified event to in-use
 FCF failure to trigger recovery
Date: Fri, 1 Mar 2013 16:36:34 -0500
Message-ID: <1362173794.8283.20.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:47957 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3CAViB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 16:38:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed async FCF modified event to in-use FCF failure to trigger recovery


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   97 ++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 35 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-02-27 08:23:01.159055175 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-02-27 08:23:19.984055604 -0500
@@ -4007,6 +4007,52 @@ lpfc_sli4_perform_all_vport_cvl(struct l
 }
 
 /**
+ * lpfc_sli4_perform_inuse_fcf_recovery - Perform inuse fcf recovery
+ * @vport: pointer to lpfc hba data structure.
+ *
+ * This routine is to perform FCF recovery when the in-use FCF either dead or
+ * got modified.
+ **/
+static void
+lpfc_sli4_perform_inuse_fcf_recovery(struct lpfc_hba *phba,
+				     struct lpfc_acqe_fip *acqe_fip)
+{
+	int rc;
+
+	spin_lock_irq(&phba->hbalock);
+	/* Mark the fast failover process in progress */
+	phba->fcf.fcf_flag |= FCF_DEAD_DISC;
+	spin_unlock_irq(&phba->hbalock);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
+			"2771 Start FCF fast failover process due to in-use "
+			"FCF DEAD/MODIFIED event: evt_tag:x%x, index:x%x\n",
+			acqe_fip->event_tag, acqe_fip->index);
+	rc = lpfc_sli4_redisc_fcf_table(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
+				"2772 Issue FCF rediscover mabilbox command "
+				"failed, fail through to FCF dead event\n");
+		spin_lock_irq(&phba->hbalock);
+		phba->fcf.fcf_flag &= ~FCF_DEAD_DISC;
+		spin_unlock_irq(&phba->hbalock);
+		/*
+		 * Last resort will fail over by treating this as a link
+		 * down to FCF registration.
+		 */
+		lpfc_sli4_fcf_dead_failthrough(phba);
+	} else {
+		/* Reset FCF roundrobin bmask for new discovery */
+		lpfc_sli4_clear_fcf_rr_bmask(phba);
+		/*
+		 * Handling fast FCF failover to a DEAD FCF event is
+		 * considered equalivant to receiving CVL to all vports.
+		 */
+		lpfc_sli4_perform_all_vport_cvl(phba);
+	}
+}
+
+/**
  * lpfc_sli4_async_fip_evt - Process the asynchronous FCoE FIP event
  * @phba: pointer to lpfc hba data structure.
  * @acqe_link: pointer to the async fcoe completion queue entry.
@@ -4071,9 +4117,22 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba
 			break;
 		}
 
-		/* If the FCF has been in discovered state, do nothing. */
-		if (phba->fcf.fcf_flag & FCF_SCAN_DONE) {
+		/* If FCF has been in discovered state, perform rediscovery
+		 * only if the FCF with the same index of the in-use FCF got
+		 * modified during normal operation. Otherwise, do nothing.
+		 */
+		if (phba->pport->port_state > LPFC_FLOGI) {
 			spin_unlock_irq(&phba->hbalock);
+			if (phba->fcf.current_rec.fcf_indx ==
+			    acqe_fip->index) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
+						"3300 In-use FCF (%d) "
+						"modified, perform FCF "
+						"rediscovery\n",
+						acqe_fip->index);
+				lpfc_sli4_perform_inuse_fcf_recovery(phba,
+								     acqe_fip);
+			}
 			break;
 		}
 		spin_unlock_irq(&phba->hbalock);
@@ -4126,39 +4185,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba
 		 * is no longer valid as we are not in the middle of FCF
 		 * failover process already.
 		 */
-		spin_lock_irq(&phba->hbalock);
-		/* Mark the fast failover process in progress */
-		phba->fcf.fcf_flag |= FCF_DEAD_DISC;
-		spin_unlock_irq(&phba->hbalock);
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
-				"2771 Start FCF fast failover process due to "
-				"FCF DEAD event: evt_tag:x%x, fcf_index:x%x "
-				"\n", acqe_fip->event_tag, acqe_fip->index);
-		rc = lpfc_sli4_redisc_fcf_table(phba);
-		if (rc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
-					LOG_DISCOVERY,
-					"2772 Issue FCF rediscover mabilbox "
-					"command failed, fail through to FCF "
-					"dead event\n");
-			spin_lock_irq(&phba->hbalock);
-			phba->fcf.fcf_flag &= ~FCF_DEAD_DISC;
-			spin_unlock_irq(&phba->hbalock);
-			/*
-			 * Last resort will fail over by treating this
-			 * as a link down to FCF registration.
-			 */
-			lpfc_sli4_fcf_dead_failthrough(phba);
-		} else {
-			/* Reset FCF roundrobin bmask for new discovery */
-			lpfc_sli4_clear_fcf_rr_bmask(phba);
-			/*
-			 * Handling fast FCF failover to a DEAD FCF event is
-			 * considered equalivant to receiving CVL to all vports.
-			 */
-			lpfc_sli4_perform_all_vport_cvl(phba);
-		}
+		lpfc_sli4_perform_inuse_fcf_recovery(phba, acqe_fip);
 		break;
 	case LPFC_FIP_EVENT_TYPE_CVL:
 		phba->fcoe_cvl_eventtag = acqe_fip->event_tag;



